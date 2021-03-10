Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5351334538
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 18:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhCJRef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 12:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhCJRed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 12:34:33 -0500
X-Greylist: delayed 314 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 Mar 2021 09:34:33 PST
Received: from mout2.freenet.de (mout2.freenet.de [IPv6:2001:748:100:40::2:4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786ACC061760;
        Wed, 10 Mar 2021 09:34:33 -0800 (PST)
Received: from [195.4.92.121] (helo=sub2.freenet.de)
        by mout2.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (port 25) (Exim 4.92 #3)
        id 1lK2e3-0000ej-PH; Wed, 10 Mar 2021 18:29:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=freenet.de;
         s=mjaymdexmjqk; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=q7ePmDwrGPTPwx8vF9Ni7o69iUtpkLSvw/EkKc2uyD0=; b=P4PnhK351YlZZhF0oJdPTBejTF
        CFcQcTu/OawkVpHDsaSVLfKVUEC/c1iY15ZHvTj+Z5kOqXqHcBsiqEbKE8587gqr4d/GjQvyvGGgW
        2AACeo743Gd/kJEu57UElHj8LDQeEUTiv9oDGs9wAOpaGLsS5VCN7kofaAsD6hJhDiur0ZiuJy8kY
        KfCaZl/B4YTvjD0S21fU+z3GPvpjxrKkPphnwVGCWmURcdOjVB16sJ3tqBHnVaMZlIDsihruaLVPt
        Se+qz0ySGbdNGeULDjVbBA4veZFwYrFQXnKvS9o9M0HYlogdApwtM+1E9Bbo+QLn/uT3rSvxciDwk
        roVXfLJQ==;
Received: from [2a02:8071:ac9:c400:c5bc:3e4e:6545:1c8] (port=36040 helo=[127.0.0.1])
        by sub2.freenet.de with esmtpsa (ID viktor.jaegerskuepper@freenet.de) (TLSv1.2:ECDHE-RSA-CHACHA20-POLY1305:256) (port 465) (Exim 4.92 #3)
        id 1lK2e3-000089-U0; Wed, 10 Mar 2021 18:29:16 +0100
Subject: Re: [PATCH bpf-next 1/4] tools/resolve_btfids: Build libbpf and
 libsubcmd in separate directories
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org
References: <20210205124020.683286-1-jolsa@kernel.org>
 <20210205124020.683286-2-jolsa@kernel.org>
From:   =?UTF-8?B?VmlrdG9yIErDpGdlcnNrw7xwcGVy?= 
        <viktor_jaegerskuepper@freenet.de>
Message-ID: <5a48579b-9aff-72a5-7b25-accb40c4dd52@freenet.de>
Date:   Wed, 10 Mar 2021 18:27:57 +0100
MIME-Version: 1.0
In-Reply-To: <20210205124020.683286-2-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Originated-At: 2a02:8071:ac9:c400:c5bc:3e4e:6545:1c8!36040
X-FNSign: v=2 s=B6B3C0C1ABCA8C6255EC655CF8A62A164EA711662018F797B1C4279D3CA80E8B
X-Scan-TS: Wed, 10 Mar 2021 18:29:15 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Setting up separate build directories for libbpf and libpsubcmd,
> so it's separated from other objects and we don't get them mixed
> in the future.
> 
> It also simplifies cleaning, which is now simple rm -rf.
> 
> Also there's no need for FEATURE-DUMP.libbpf and bpf_helper_defs.h
> files in .gitignore anymore.
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

when I invoke 'git status' on the master branch of my local git repository
(cloned from stable/linux.git), which I have used to compile several kernels,
it lists two untracked files:

	tools/bpf/resolve_btfids/FEATURE-DUMP.libbpf
	tools/bpf/resolve_btfids/bpf_helper_defs.h

'git status' doesn't complain about these files with v5.11, and I can't get rid
of them by 'make clean' with v5.11 or v5.12-rc1/rc2. So I used 'git bisect' and
found that this is caused by commit fc6b48f692f89cc48bfb7fd1aa65454dfe9b2d77,
which links to this thread.

Looking at the diff it's obvious because of the change in the .gitignore file,
but I don't know why these files are there and I have never touched anything in
the 'tools' directory.

Can I savely delete the files? Do I even have to delete them before I compile
v5.12-rcX?

Thanks,
Viktor

>  tools/bpf/resolve_btfids/.gitignore |  2 --
>  tools/bpf/resolve_btfids/Makefile   | 26 +++++++++++---------------
>  2 files changed, 11 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/bpf/resolve_btfids/.gitignore b/tools/bpf/resolve_btfids/.gitignore
> index a026df7dc280..25f308c933cc 100644
> --- a/tools/bpf/resolve_btfids/.gitignore
> +++ b/tools/bpf/resolve_btfids/.gitignore
> @@ -1,4 +1,2 @@
> -/FEATURE-DUMP.libbpf
> -/bpf_helper_defs.h
>  /fixdep
>  /resolve_btfids
> diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> index bf656432ad73..1d46a247ec95 100644
> --- a/tools/bpf/resolve_btfids/Makefile
> +++ b/tools/bpf/resolve_btfids/Makefile
> @@ -28,22 +28,22 @@ OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
>  LIBBPF_SRC := $(srctree)/tools/lib/bpf/
>  SUBCMD_SRC := $(srctree)/tools/lib/subcmd/
>  
> -BPFOBJ     := $(OUTPUT)/libbpf.a
> -SUBCMDOBJ  := $(OUTPUT)/libsubcmd.a
> +BPFOBJ     := $(OUTPUT)/libbpf/libbpf.a
> +SUBCMDOBJ  := $(OUTPUT)/libsubcmd/libsubcmd.a
>  
>  BINARY     := $(OUTPUT)/resolve_btfids
>  BINARY_IN  := $(BINARY)-in.o
>  
>  all: $(BINARY)
>  
> -$(OUTPUT):
> +$(OUTPUT) $(OUTPUT)/libbpf $(OUTPUT)/libsubcmd:
>  	$(call msg,MKDIR,,$@)
> -	$(Q)mkdir -p $(OUTPUT)
> +	$(Q)mkdir -p $(@)
>  
> -$(SUBCMDOBJ): fixdep FORCE
> -	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT)
> +$(SUBCMDOBJ): fixdep FORCE | $(OUTPUT)/libsubcmd
> +	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
>  
> -$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
> +$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)/libbpf
>  	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)  OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
>  
>  CFLAGS := -g \
> @@ -57,23 +57,19 @@ LIBS = -lelf -lz
>  export srctree OUTPUT CFLAGS Q
>  include $(srctree)/tools/build/Makefile.include
>  
> -$(BINARY_IN): fixdep FORCE
> +$(BINARY_IN): fixdep FORCE | $(OUTPUT)
>  	$(Q)$(MAKE) $(build)=resolve_btfids
>  
>  $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
>  	$(call msg,LINK,$@)
>  	$(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
>  
> -libsubcmd-clean:
> -	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT) clean
> -
> -libbpf-clean:
> -	$(Q)$(MAKE) -C $(LIBBPF_SRC) OUTPUT=$(OUTPUT) clean
> -
> -clean: libsubcmd-clean libbpf-clean fixdep-clean
> +clean: fixdep-clean
>  	$(call msg,CLEAN,$(BINARY))
>  	$(Q)$(RM) -f $(BINARY); \
>  	$(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
> +	$(RM) -rf $(OUTPUT)/libbpf; \
> +	$(RM) -rf $(OUTPUT)/libsubcmd; \
>  	find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
>  
>  tags:
> 
