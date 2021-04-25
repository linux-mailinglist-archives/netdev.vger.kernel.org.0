Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7A736A6DF
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 13:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhDYLOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 07:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhDYLOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 07:14:09 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66890C061574;
        Sun, 25 Apr 2021 04:13:29 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FSlkl4my0z9sTD;
        Sun, 25 Apr 2021 21:13:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1619349206;
        bh=svys2tIy/5/UUZIxCTMC8S3VvRrrnDcOcI1cawlhKTw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=FQAb7aXP5cuXQ7S4ooGHF+N1KoL6m8dy5/EiwvJ8Ck/hXp0xdm81uMVAM3RyLa6Ay
         a4Hrs/jH2ivqPXCikzIV8HEhTNpNzMzTguhV2emQMMYkUKuuMrnbTddvfUKjfv71OB
         nHWSyx2pt+9oBt7qMrdkBKo5H3qdFntTvD4yn2+HbFliGhDQBv7oaSdFdP6/j6O2TT
         MmyLaZ3sy/h5vjYWVlicmFl5o90dhrZmHJszPi7+S1YTboR8bEtda+nESgkh3QJJUQ
         VT/VJKa7kJfV3rVlur2+2cUd/lBFGjLfZkFv95+uo5ULw6WqozFPctQo0iy7izYbYw
         nX0emcMIi7FXA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthias Maennich <maennich@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mptcp@lists.01.org, netdev@vger.kernel.org
Subject: Re: [PATCH] kbuild: replace LANG=C with LC_ALL=C
In-Reply-To: <20210424114841.394239-1-masahiroy@kernel.org>
References: <20210424114841.394239-1-masahiroy@kernel.org>
Date:   Sun, 25 Apr 2021 21:13:15 +1000
Message-ID: <871raybos4.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Masahiro Yamada <masahiroy@kernel.org> writes:
> LANG gives a weak default to each LC_* in case it is not explicitly
> defined. LC_ALL, if set, overrides all other LC_* variables.
>
>   LANG  <  LC_CTYPE, LC_COLLATE, LC_MONETARY, LC_NUMERIC, ...  <  LC_ALL
>
> This is why documentation such as [1] suggests to set LC_ALL in build
> scripts to get the deterministic result.
>
> LANG=C is not strong enough to override LC_* that may be set by end
> users.
>
> [1]: https://reproducible-builds.org/docs/locales/
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
>
>  arch/powerpc/boot/wrapper                          | 2 +-

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers

>  scripts/nsdeps                                     | 2 +-
>  scripts/recordmcount.pl                            | 2 +-
>  scripts/setlocalversion                            | 2 +-
>  scripts/tags.sh                                    | 2 +-
>  tools/testing/selftests/net/mptcp/mptcp_connect.sh | 2 +-
>  usr/gen_initramfs.sh                               | 2 +-
>  7 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
> index 41fa0a8715e3..cdb796b76e2e 100755
> --- a/arch/powerpc/boot/wrapper
> +++ b/arch/powerpc/boot/wrapper
> @@ -191,7 +191,7 @@ if [ -z "$kernel" ]; then
>      kernel=vmlinux
>  fi
>  
> -LANG=C elfformat="`${CROSS}objdump -p "$kernel" | grep 'file format' | awk '{print $4}'`"
> +LC_ALL=C elfformat="`${CROSS}objdump -p "$kernel" | grep 'file format' | awk '{print $4}'`"
>  case "$elfformat" in
>      elf64-powerpcle)	format=elf64lppc	;;
>      elf64-powerpc)	format=elf32ppc	;;
> diff --git a/scripts/nsdeps b/scripts/nsdeps
> index e8ce2a4d704a..04c4b96e95ec 100644
> --- a/scripts/nsdeps
> +++ b/scripts/nsdeps
> @@ -44,7 +44,7 @@ generate_deps() {
>  		for source_file in $mod_source_files; do
>  			sed '/MODULE_IMPORT_NS/Q' $source_file > ${source_file}.tmp
>  			offset=$(wc -l ${source_file}.tmp | awk '{print $1;}')
> -			cat $source_file | grep MODULE_IMPORT_NS | LANG=C sort -u >> ${source_file}.tmp
> +			cat $source_file | grep MODULE_IMPORT_NS | LC_ALL=C sort -u >> ${source_file}.tmp
>  			tail -n +$((offset +1)) ${source_file} | grep -v MODULE_IMPORT_NS >> ${source_file}.tmp
>  			if ! diff -q ${source_file} ${source_file}.tmp; then
>  				mv ${source_file}.tmp ${source_file}
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 867860ea57da..0a7fc9507d6f 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -497,7 +497,7 @@ sub update_funcs
>  #
>  # Step 2: find the sections and mcount call sites
>  #
> -open(IN, "LANG=C $objdump -hdr $inputfile|") || die "error running $objdump";
> +open(IN, "LC_ALL=C $objdump -hdr $inputfile|") || die "error running $objdump";
>  
>  my $text;
>  
> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
> index bb709eda96cd..db941f6d9591 100755
> --- a/scripts/setlocalversion
> +++ b/scripts/setlocalversion
> @@ -126,7 +126,7 @@ scm_version()
>  	fi
>  
>  	# Check for svn and a svn repo.
> -	if rev=$(LANG= LC_ALL= LC_MESSAGES=C svn info 2>/dev/null | grep '^Last Changed Rev'); then
> +	if rev=$(LC_ALL=C svn info 2>/dev/null | grep '^Last Changed Rev'); then
>  		rev=$(echo $rev | awk '{print $NF}')
>  		printf -- '-svn%s' "$rev"
>  
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index fd96734deff1..db8ba411860a 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -326,5 +326,5 @@ esac
>  
>  # Remove structure forward declarations.
>  if [ -n "$remove_structs" ]; then
> -    LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
> +    LC_ALL=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
>  fi
> diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
> index 10a030b53b23..1d2a6e7b877c 100755
> --- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
> +++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
> @@ -273,7 +273,7 @@ check_mptcp_disabled()
>  	ip netns exec ${disabled_ns} sysctl -q net.mptcp.enabled=0
>  
>  	local err=0
> -	LANG=C ip netns exec ${disabled_ns} ./mptcp_connect -t $timeout -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
> +	LC_ALL=C ip netns exec ${disabled_ns} ./mptcp_connect -t $timeout -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
>  		grep -q "^socket: Protocol not available$" && err=1
>  	ip netns delete ${disabled_ns}
>  
> diff --git a/usr/gen_initramfs.sh b/usr/gen_initramfs.sh
> index 8ae831657e5d..63476bb70b41 100755
> --- a/usr/gen_initramfs.sh
> +++ b/usr/gen_initramfs.sh
> @@ -147,7 +147,7 @@ dir_filelist() {
>  	header "$1"
>  
>  	srcdir=$(echo "$1" | sed -e 's://*:/:g')
> -	dirlist=$(find "${srcdir}" -printf "%p %m %U %G\n" | LANG=C sort)
> +	dirlist=$(find "${srcdir}" -printf "%p %m %U %G\n" | LC_ALL=C sort)
>  
>  	# If $dirlist is only one line, then the directory is empty
>  	if [  "$(echo "${dirlist}" | wc -l)" -gt 1 ]; then
> -- 
> 2.27.0
