Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5DF44CE2B
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 01:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhKKAQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 19:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbhKKAQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 19:16:50 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DF9C061766;
        Wed, 10 Nov 2021 16:14:02 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id q17so4309659plr.11;
        Wed, 10 Nov 2021 16:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4xw9KKTY+RnOSMKZ1a6CWSpNS+Pk9GVsvV7dPNOyn1k=;
        b=hBBTABDqpuPxyOUnQ38hH91zj+bdJ2bBCi2F8DV7QcHe98ZuNsrPUFiPyGjbF1GeSS
         FoErFNP/vkhtCnO6CIOdr7ZmqNUNZSAK7QkNNmWG03RuB8feo3xOLbl7d4kOXhEBY2fU
         xCzWXwHI305xnpi9P41p8vdf6eqT2t+T8msGztNxyTt3Xz/H8nSOc34MdLAcPTf0sh4S
         3zgwU835Sy5/UkDh4IcliSx6S2fYOjtZDce7S5GfhucikJe2bgot5+iHpFmFm9zfD0nN
         1LdTZ5WqEw62GFHlZfVjKrms5/qVncmLj0SEVhwZ3oYwLdfUVy4AlIgXKPKGXD5ssWqc
         nybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4xw9KKTY+RnOSMKZ1a6CWSpNS+Pk9GVsvV7dPNOyn1k=;
        b=nUmzKC+WAz9tFJPocg7DkjSrqM99lkMGEft9Z+iCyAxh17KDd22C6/iQGtZZ0MHy3M
         BxGsZiW168Wr1/Cxj8Usv3kzZtmufIfsDSSfZKDkdE6LUfWfoFC3njmlqkA9ewZZQC3r
         K0umPbkP0fvxbYl4/Ar056+8QfqSJ8KJhf8WjvwyUfebLId/MXJpo7F0FwWqvhPMMN0c
         kwsrfesLpEmRfiD66qUQgJ2wkSDaSsNpgXJE4HGHvI0m2C1sd7zh3mn/rEmwmuWhYU7b
         q1eIaBIsKY/zVDZly4Dn2IuD5qfSIkDMwuhPfV7jUwESHaMtxJ9RFYl1FcJzPy5yXOCX
         s6rQ==
X-Gm-Message-State: AOAM532BQQfPpgiXTL3YLrNklMUyJY57xIecnUl7XU+PE556L8JybE7V
        nNTl8Tla9kPgwBEghEJi2xI=
X-Google-Smtp-Source: ABdhPJzMey32c/wx1NBp6k41zkmEdSOJdPvXVm9vrCNiwW5Rk05Suz5tLtbzfDrxUhsorGr/O47DUQ==
X-Received: by 2002:a17:90a:6f61:: with SMTP id d88mr3574220pjk.109.1636589642230;
        Wed, 10 Nov 2021 16:14:02 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id t4sm747576pfq.163.2021.11.10.16.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 16:14:01 -0800 (PST)
Date:   Thu, 11 Nov 2021 05:43:59 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH net v2] bpf: Fix build when CONFIG_BPF_SYSCALL is disabled
Message-ID: <20211111001359.3v2yjha5nxkdtoju@apollo.localdomain>
References: <20211110205418.332403-1-vinicius.gomes@intel.com>
 <20211110212553.e2xnltq3dqduhjnj@apollo.localdomain>
 <CAADnVQKqjLM1P7X+iTfnH-QFw5=z5L_w8MLsWtcNWbh5QR7VVg@mail.gmail.com>
 <878rxvbmcm.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rxvbmcm.fsf@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 05:21:53AM IST, Vinicius Costa Gomes wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> >> Thanks for the fix.
> >>
> >> But instead of moving this to core.c, you can probably make the btf.h
> >> declaration conditional on CONFIG_BPF_SYSCALL, since this is not useful in
> >> isolation (only used by verifier for module kfunc support). For the case of
> >> kfunc_btf_id_list variables, just define it as an empty struct and static
> >> variables, since the definition is still inside btf.c. So it becomes a noop for
> >> !CONFIG_BPF_SYSCALL.
> >>
> >> I am also not sure whether BTF is useful without BPF support, but maybe I'm
> >> missing some usecase.
> >
> > Unlikely. I would just disallow such config instead of sprinkling
> > the code with ifdefs.
>
> Is something like this what you have in mind?
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 6fdbf9613aec..eae860c86e26 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -316,6 +316,7 @@ config DEBUG_INFO_BTF
>  	bool "Generate BTF typeinfo"
>  	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
>  	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
> +	depends on BPF_SYSCALL
>  	help
>  	  Generate deduplicated BTF type information from DWARF debug info.
>  	  Turning this on expects presence of pahole tool, which will convert
>
>

BTW, you will need a little more than that, I suspect the compiler optimizes out
the register/unregister call so we don't see a build failure, but adding a side
effect gives me errors, so something like this should resolve the problem (since
kfunc_btf_id_list variable definition is behind CONFIG_BPF_SYSCALL).

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 203eef993d76..e9881ef9e9aa 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -254,6 +254,8 @@ void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
                                 struct kfunc_btf_id_set *s);
 bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
                              struct module *owner);
+extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
+extern struct kfunc_btf_id_list prog_test_kfunc_list;
 #else
 static inline void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
                                             struct kfunc_btf_id_set *s)
@@ -268,13 +270,13 @@ static inline bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist,
 {
        return false;
 }
+struct kfunc_btf_id_list {};
+static struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list __maybe_unused;
+static struct kfunc_btf_id_list prog_test_kfunc_list __maybe_unused;
+
 #endif

 #define DEFINE_KFUNC_BTF_ID_SET(set, name)                                     \
        struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list), (set),     \
                                         THIS_MODULE }
-
-extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
-extern struct kfunc_btf_id_list prog_test_kfunc_list;
-
 #endif

--
Kartikeya
