Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A368764378B
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiLEV7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiLEV7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:59:46 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0840819A;
        Mon,  5 Dec 2022 13:59:45 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so16186980pje.5;
        Mon, 05 Dec 2022 13:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sXTgHGkIn9AhAzxhCQIsbw3eRAhTdrwQh9s5Ax3GiLA=;
        b=IKzztMWjAp+1B2x3JkBXLdVmjR66kLJOW1rd0oWVobJgKA1Gw+jY6XShIg3njUIYg5
         Pze2gEMMik+x9MgDtUO6r2tWlo3V9Ag/q3X6iHOadeOb/zZoUi7OqcIvM9UPnGuvohJO
         9tfACJFsVcGdn5mbSeJ/ZF/VBHvJfdXEBPV+V41P4YX+9Y6YXfZeTHK2iNHiIvL3dnJj
         GIwYVGV5jetCdhOE3av5PpdE5VMN5yuqNeF+k1wvyeQtmngXbwkQQBkK/CUxkGAUqrUZ
         Fl6uV5Wg0D0o5mwZss2nfiTG4cpErP2i3FcU+oloz47y/Bvy5szmJy4gYLrm6Uo7nwNp
         2jUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sXTgHGkIn9AhAzxhCQIsbw3eRAhTdrwQh9s5Ax3GiLA=;
        b=4SrsekAYsGH4yNAlC9MQuW6hu747kBB8Z60tJZhS5NQ7fX84PNNZZvNGnIlgNSR7zI
         ke+FS+c9tZqRjIRa0FQwzLA+ISIN0vP6cEvumQmR/F35DuOUUAPM/YZ7/Sc4IWAmoZe7
         dbqBflN+vJ7wXlNY7r17dyYBQ9b4Kf/0GZaWxByyYz98IMXOn1e7LpyBSkBiV72SuEHw
         cfas0NvpfoKdTBtBDfeVD+pUMKcDMWw5qtt4xNtfyCNPk030UJIeVeo2B4nfXoAYEcK+
         p7NqkyxdyYA/mkZ4aw+TI6YjaFJfJQyN1tWeOKMt7nBgpolKnJHanaMiFlUHE7RgVNkm
         hjIg==
X-Gm-Message-State: ANoB5pl19OJbNSikYYKFaIURyzp2oVU207+Ng2Sh2XFZqNhs6BnG1eS4
        0GuYipoNrF5XSy1AqTI76rA=
X-Google-Smtp-Source: AA0mqf4sXm/lDSJ+nfmn3ME0dNTpUezIOtnE0o0XXZBahaRtrZPmYhBo83v6CHngYspslj/HlrCjWg==
X-Received: by 2002:a17:902:ef85:b0:189:c8ff:f260 with SMTP id iz5-20020a170902ef8500b00189c8fff260mr12052416plb.24.1670277584296;
        Mon, 05 Dec 2022 13:59:44 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:11da])
        by smtp.gmail.com with ESMTPSA id jc18-20020a17090325d200b001891a17bd93sm11127565plb.43.2022.12.05.13.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:59:43 -0800 (PST)
Date:   Mon, 5 Dec 2022 13:59:39 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH HID for-next v2 1/4] bpf: do not rely on
 ALLOW_ERROR_INJECTION for fmod_ret
Message-ID: <Y45py14LVP/bn2r5@macbook-pro-6.dhcp.thefacebook.com>
References: <20221205164856.705656-1-benjamin.tissoires@redhat.com>
 <20221205164856.705656-2-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205164856.705656-2-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 05:48:53PM +0100, Benjamin Tissoires wrote:
> The current way of expressing that a non-bpf kernel component is willing
> to accept that bpf programs can be attached to it and that they can change
> the return value is to abuse ALLOW_ERROR_INJECTION.
> This is debated in the link below, and the result is that it is not a
> reasonable thing to do.
> 
> Reuse the kfunc declaration structure to also tag the kernel functions
> we want to be fmodret. This way we can control from any subsystem which
> functions are being modified by bpf without touching the verifier.
> 
> 
> Link: https://lore.kernel.org/all/20221121104403.1545f9b5@gandalf.local.home/
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  include/linux/btf.h   |  3 +++
>  kernel/bpf/btf.c      | 41 +++++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c | 17 +++++++++++++++--
>  net/bpf/test_run.c    | 14 +++++++++++---
>  4 files changed, 70 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index f9aababc5d78..f71cfb20b9bf 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -412,8 +412,11 @@ struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
>  u32 *btf_kfunc_id_set_contains(const struct btf *btf,
>  			       enum bpf_prog_type prog_type,
>  			       u32 kfunc_btf_id);
> +u32 *btf_kern_func_is_modify_return(const struct btf *btf,
> +				    u32 kfunc_btf_id);
>  int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
>  			      const struct btf_kfunc_id_set *s);
> +int register_btf_fmodret_id_set(const struct btf_kfunc_id_set *kset);
>  s32 btf_find_dtor_kfunc(struct btf *btf, u32 btf_id);
>  int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dtors, u32 add_cnt,
>  				struct module *owner);
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 35c07afac924..a22f3f45aca3 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -204,6 +204,7 @@ enum btf_kfunc_hook {
>  	BTF_KFUNC_HOOK_STRUCT_OPS,
>  	BTF_KFUNC_HOOK_TRACING,
>  	BTF_KFUNC_HOOK_SYSCALL,
> +	BTF_KFUNC_HOOK_FMODRET,
>  	BTF_KFUNC_HOOK_MAX,
>  };
>  
> @@ -7448,6 +7449,19 @@ u32 *btf_kfunc_id_set_contains(const struct btf *btf,
>  	return __btf_kfunc_id_set_contains(btf, hook, kfunc_btf_id);
>  }
>  
> +/* Caution:
> + * Reference to the module (obtained using btf_try_get_module) corresponding to
> + * the struct btf *MUST* be held when calling this function from verifier
> + * context. This is usually true as we stash references in prog's kfunc_btf_tab;
> + * keeping the reference for the duration of the call provides the necessary
> + * protection for looking up a well-formed btf->kfunc_set_tab.
> + */

There is no need to copy paste that comment from btf_kfunc_id_set_contains().
One place is enough.

> +u32 *btf_kern_func_is_modify_return(const struct btf *btf,
> +				    u32 kfunc_btf_id)

How about btf_kfunc_is_modify_return ? 
For consistency.

> +{
> +	return __btf_kfunc_id_set_contains(btf, BTF_KFUNC_HOOK_FMODRET, kfunc_btf_id);
> +}
> +
>  /* This function must be invoked only from initcalls/module init functions */
>  int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
>  			      const struct btf_kfunc_id_set *kset)
> @@ -7478,6 +7492,33 @@ int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
>  }
>  EXPORT_SYMBOL_GPL(register_btf_kfunc_id_set);
>  
> +/* This function must be invoked only from initcalls/module init functions */
> +int register_btf_fmodret_id_set(const struct btf_kfunc_id_set *kset)
> +{
> +	struct btf *btf;
> +	int ret;
> +
> +	btf = btf_get_module_btf(kset->owner);
> +	if (!btf) {
> +		if (!kset->owner && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
> +			pr_err("missing vmlinux BTF, cannot register kfuncs\n");
> +			return -ENOENT;
> +		}
> +		if (kset->owner && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES)) {
> +			pr_err("missing module BTF, cannot register kfuncs\n");
> +			return -ENOENT;
> +		}
> +		return 0;
> +	}
> +	if (IS_ERR(btf))
> +		return PTR_ERR(btf);
> +
> +	ret = btf_populate_kfunc_set(btf, BTF_KFUNC_HOOK_FMODRET, kset->set);
> +	btf_put(btf);
> +	return ret;
> +}

This is a bit too much copy-paste from register_btf_kfunc_id_set().
Please share the code. Like:

int __register_btf_kfunc_id_set(enum btf_kfunc_hook hook, const struct btf_kfunc_id_set *kset)
{
  ...
}

int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
                              const struct btf_kfunc_id_set *kset)
{
  hook = bpf_prog_type_to_kfunc_hook(prog_type);
  return __register_btf_kfunc_id_set(hook, kset);
}

int register_btf_fmodret_id_set(const struct btf_kfunc_id_set *kset)
{
  return __register_btf_kfunc_id_set(BTF_KFUNC_HOOK_FMODRET, kset);
}
