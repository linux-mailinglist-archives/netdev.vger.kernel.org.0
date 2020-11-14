Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007812B2B02
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 04:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgKND05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 22:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKND05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 22:26:57 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4814FC0613D1;
        Fri, 13 Nov 2020 19:26:57 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id z2so10262415ilh.11;
        Fri, 13 Nov 2020 19:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nPr8do3i7ibeVJp7gfGqtwo9siwfRgIw3wBmWl2rbCc=;
        b=QRUTRyAQM0wG2BcqtfOKc16g335/LhmkJJrpXwAUzrIEds0XUIvFKbdr9psite2t2R
         PoT4MuNurcawnMELboJKbgsmIWbCY3evtrgOQXliu7jvMQD5IYCi7i2ZVQwnJC8Xjg/y
         z+kxTyvQ/GxWIGslyrrqrNvuVS9QWZRtzYQp/k4bSCE2607+jwv0h7PQ4UIqi0E5DUQB
         LOIQBLbymWBHZXkMqvzirh48GFE8EtlFaKeGuIg3xsgOgjaKibqxakbQdUuMlb5EasC1
         PQ3AjgZchf7+LZzcBn4Sc1Khujo+SAtoP+Dwb/YWtukVgEM14c7Ner7MWXq3fhYLK0m8
         TNNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nPr8do3i7ibeVJp7gfGqtwo9siwfRgIw3wBmWl2rbCc=;
        b=M3qf9DWVVBF+mQN3MpGWbeSlBU3gmI8C4LwhxlSYXSKkJRzixPzr1FDtOcirXQOc11
         JrPKDpSiHTlhyPTKaYgTT/+q2sGXaZHzb6jgh5Q4ZnKAkguGxMgXDEX24e9yTMJkIX3f
         PxCEMLYGadfrjMFdnrtYdwVGu22Y3d7/ja4JLeY6syoGOsmzwBibqyTmp13dSCuh9xaD
         KPiALQUBbzSSp/eKRSCyRZwNZmh88urZd6eP7azcI4CMG92cAMS53f+bxvUwfvWzIe2a
         B/hPw+lfXmzqqPPWZOBxs+ujkhATYlpfyh5aFbPx+BEJNUVi/jpT2FqBEGlkCh5YVNnb
         dm2A==
X-Gm-Message-State: AOAM530egemUzWFyBWhzJLoKRkMjFx4PORrUEXZ5KLiDAOZrgGuWEcOU
        x32EX2L5LP7RN80bf1r563KSupUKHMQ=
X-Google-Smtp-Source: ABdhPJxQoG9fQuTxUlgZj65ZTyEXdHec3HpcbUF5AiI9laPgpwY4pxu3YeCZ5jbTZxSg3txqQoEh+A==
X-Received: by 2002:a92:d811:: with SMTP id y17mr2203120ilm.107.1605324416514;
        Fri, 13 Nov 2020 19:26:56 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:99e7:10e8:ee93:9a3d])
        by smtp.googlemail.com with ESMTPSA id j5sm5279256ioa.28.2020.11.13.19.26.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 19:26:55 -0800 (PST)
Subject: Re: [PATCHv4 iproute2-next 1/5] configure: add check_libbpf() for
 later libbpf support
To:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201029151146.3810859-1-haliu@redhat.com>
 <20201109070802.3638167-1-haliu@redhat.com>
 <20201109070802.3638167-2-haliu@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8443c959-2ab5-0963-120e-b278e8bac360@gmail.com>
Date:   Fri, 13 Nov 2020 20:26:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201109070802.3638167-2-haliu@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/20 12:07 AM, Hangbin Liu wrote:
> This patch adds a check to see if we have libbpf support. By default the
> system libbpf will be used, but static linking against a custom libbpf
> version can be achieved by passing LIBBPF_DIR to configure.
> 
> Add another variable LIBBPF_FORCE to control whether to build iproute2
> with libbpf. If set to on, then force to build with libbpf and exit if
> not available. If set to off, then force to not build with libbpf.
> 
> Signed-off-by: Hangbin Liu <haliu@redhat.com>
> 
> v4:
> 1) Remove duplicate LIBBPF_CFLAGS
> 2) Remove un-needed -L since using static libbpf.a
> 3) Fix == not supported in dash
> 4) Extend LIBBPF_FORCE to support on/off, when set to on, stop building when
>    there is no libbpf support. If set to off, discard libbpf check.
> 5) Print libbpf version after checking
> 
> v3:
> Check function bpf_program__section_name() separately and only use it
> on higher libbpf version.
> 
> v2:
> No update
> ---
>  configure | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 108 insertions(+)
> 
> diff --git a/configure b/configure
> index 307912aa..3081a2ac 100755
> --- a/configure
> +++ b/configure
> @@ -2,6 +2,11 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # This is not an autoconf generated configure
>  #
> +# Influential LIBBPF environment variables:
> +#   LIBBPF_FORCE={on,off}   on: require link against libbpf;
> +#                           off: disable libbpf probing
> +#   LIBBPF_LIBDIR           Path to libbpf to use
> +
>  INCLUDE=${1:-"$PWD/include"}
>  
>  # Output file which is input to Makefile
> @@ -240,6 +245,106 @@ check_elf()
>      fi
>  }
>  
> +have_libbpf_basic()
> +{
> +    cat >$TMPDIR/libbpf_test.c <<EOF
> +#include <bpf/libbpf.h>
> +int main(int argc, char **argv) {
> +    bpf_program__set_autoload(NULL, false);
> +    bpf_map__ifindex(NULL);
> +    bpf_map__set_pin_path(NULL, NULL);
> +    bpf_object__open_file(NULL, NULL);
> +    return 0;
> +}
> +EOF
> +
> +    $CC -o $TMPDIR/libbpf_test $TMPDIR/libbpf_test.c $LIBBPF_CFLAGS $LIBBPF_LDLIBS >/dev/null 2>&1
> +    local ret=$?
> +
> +    rm -f $TMPDIR/libbpf_test.c $TMPDIR/libbpf_test
> +    return $ret
> +}
> +
> +have_libbpf_sec_name()
> +{
> +    cat >$TMPDIR/libbpf_sec_test.c <<EOF
> +#include <bpf/libbpf.h>
> +int main(int argc, char **argv) {
> +    void *ptr;
> +    bpf_program__section_name(NULL);
> +    return 0;
> +}
> +EOF
> +
> +    $CC -o $TMPDIR/libbpf_sec_test $TMPDIR/libbpf_sec_test.c $LIBBPF_CFLAGS $LIBBPF_LDLIBS >/dev/null 2>&1
> +    local ret=$?
> +
> +    rm -f $TMPDIR/libbpf_sec_test.c $TMPDIR/libbpf_sec_test
> +    return $ret
> +}
> +
> +check_force_libbpf_on()
> +{
> +    # if set LIBBPF_FORCE=on but no libbpf support, just exist the config
> +    # process to make sure we don't build without libbpf.
> +    if [ "$LIBBPF_FORCE" = on ]; then
> +        echo "	LIBBPF_FORCE=on set, but couldn't find a usable libbpf"
> +        exit 1
> +    fi
> +}
> +
> +check_libbpf()
> +{
> +    # if set LIBBPF_FORCE=off, disable libbpf entirely
> +    if [ "$LIBBPF_FORCE" = off ]; then
> +        echo "no"
> +        return
> +    fi
> +
> +    if ! ${PKG_CONFIG} libbpf --exists && [ -z "$LIBBPF_DIR" ] ; then
> +        echo "no"
> +        check_force_libbpf_on
> +        return
> +    fi
> +
> +    if [ $(uname -m) = x86_64 ]; then
> +        local LIBBPF_LIBDIR="${LIBBPF_DIR}/lib64"
> +    else
> +        local LIBBPF_LIBDIR="${LIBBPF_DIR}/lib"
> +    fi
> +
> +    if [ -n "$LIBBPF_DIR" ]; then
> +        LIBBPF_CFLAGS="-I${LIBBPF_DIR}/include"
> +        LIBBPF_LDLIBS="${LIBBPF_LIBDIR}/libbpf.a -lz -lelf"
> +        LIBBPF_VERSION=$(PKG_CONFIG_LIBDIR=${LIBBPF_LIBDIR}/pkgconfig ${PKG_CONFIG} libbpf --modversion)
> +    else
> +        LIBBPF_CFLAGS=$(${PKG_CONFIG} libbpf --cflags)
> +        LIBBPF_LDLIBS=$(${PKG_CONFIG} libbpf --libs)
> +        LIBBPF_VERSION=$(${PKG_CONFIG} libbpf --modversion)
> +    fi
> +
> +    if ! have_libbpf_basic; then
> +        echo "no"
> +        echo "	libbpf version $LIBBPF_VERSION is too low, please update it to at least 0.1.0"
> +        check_force_libbpf_on
> +        return
> +    else
> +        echo "HAVE_LIBBPF:=y" >>$CONFIG
> +        echo 'CFLAGS += -DHAVE_LIBBPF ' $LIBBPF_CFLAGS >> $CONFIG
> +        echo 'LDLIBS += ' $LIBBPF_LDLIBS >>$CONFIG
> +    fi
> +
> +    # bpf_program__title() is deprecated since libbpf 0.2.0, use
> +    # bpf_program__section_name() instead if we support
> +    if have_libbpf_sec_name; then
> +        echo "HAVE_LIBBPF_SECTION_NAME:=y" >>$CONFIG
> +        echo 'CFLAGS += -DHAVE_LIBBPF_SECTION_NAME ' >> $CONFIG
> +    fi
> +
> +    echo "yes"
> +    echo "	libbpf version $LIBBPF_VERSION"
> +}
> +
>  check_selinux()
>  # SELinux is a compile time option in the ss utility
>  {
> @@ -385,6 +490,9 @@ check_setns
>  echo -n "SELinux support: "
>  check_selinux
>  
> +echo -n "libbpf support: "
> +check_libbpf
> +
>  echo -n "ELF support: "
>  check_elf
>  
> 

Something is off with the version detection.

# LIBBPF_LIBDIR=/tmp/libbpf ./configure
TC schedulers
 ATM	no

libc has setns: yes
SELinux support: no
libbpf support: yes
	libbpf version 0.1.0
ELF support: yes

/tmp/libbpf has an install of top of tree as of today which is:

/tmp/libbpf/usr/lib64/libbpf.so.0.3.0

This is using Ubuntu 20.10.

