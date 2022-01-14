Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D02048E368
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 05:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbiANEuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 23:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiANEuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 23:50:35 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1027BC061574;
        Thu, 13 Jan 2022 20:50:35 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id x83so1799903pgx.4;
        Thu, 13 Jan 2022 20:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t7qIz+X+QglQoyCXVE8p/RRZbcs9mwrC8OUUePFdTgE=;
        b=cGqRbF39YENIq3LINuO+JIV8FPElEWoDwWxuMpD9o+0C55/GJ0vr0oZ+sQlSWpEGAZ
         wxlZuoT9JGXT8je5ku6LMfKDfYmZaR8fZHtoKha5XqTkzTa9uSqJ+q2fU9qoDSqu2dc3
         nwZ7Rv/IRqiOao8t/2dkwCp8w8ApdGfKloG5shGW42Hhu7rxvLmbJVljsFTTG1OPAcw0
         ulufF1CON0vOLUa8v/tRRKWOdLATYm5HWqxm4hfnc0vKjqJhV+sOyVxmVDwFujMZE6rn
         vYX/GTcxOBmTy42qiQEDU8dkwgOU8695kF02ljAmmqXtfPTZDHSBSRkn0RqFYNWU4LqR
         FmqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t7qIz+X+QglQoyCXVE8p/RRZbcs9mwrC8OUUePFdTgE=;
        b=pg/bzYEjJ84/HbYDoYPXVl8Drpr/GEViyqlvtY/oHSSnj8aLcRzecxIDok/IFooy2u
         ZYzfnjP5ZATJbdT6wK9NqHjdFSvCczTVf8+eRMmhh8zbJrTMV8Id8N3caw89UOETZzFQ
         sVlUSJUd0rKTEXNt0/NfmIVtaagC1aTPPfC2F7EH7VMUzQBizmNTXZMlxXZeMSJIs/wG
         dSsg7KV6chHhoiJ4psbPbPBnKwZJ+B10BKuFf+5zqVKKThM8uo4hdzY0PrmCh7F4hOMr
         OEKSFtH4EVkWF4RVyH293TzRm2xbYhlJTXfm9W2VjJQPOw0AfTXZSoxlOVrc5DVplDdi
         VuFA==
X-Gm-Message-State: AOAM533KVHI75iBZtL63uE3Z0hH7ljwv5n82aXpU7lj3nX2e42mGu1dz
        38hbODP0xWknxCW1l1JRoWOUybU8GSEasg==
X-Google-Smtp-Source: ABdhPJyqFviXQgbKM8eEzQ+2rgTCgI9dOBdOYEpCFXed/8nKMozZ/PWf94RAPHeB38p6kHv5WZ5LNg==
X-Received: by 2002:a63:86c1:: with SMTP id x184mr6336670pgd.324.1642135834324;
        Thu, 13 Jan 2022 20:50:34 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id k8sm3900534pjj.3.2022.01.13.20.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 20:50:33 -0800 (PST)
Date:   Fri, 14 Jan 2022 10:19:50 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v7 02/10] bpf: Populate kfunc BTF ID sets in
 struct btf
Message-ID: <20220114044950.24jr6juxbuzxskw2@apollo.legion>
References: <20220111180428.931466-1-memxor@gmail.com>
 <20220111180428.931466-3-memxor@gmail.com>
 <20220113223211.s2m5fkvafd6fk4tv@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113223211.s2m5fkvafd6fk4tv@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 04:02:11AM IST, Alexei Starovoitov wrote:
> On Tue, Jan 11, 2022 at 11:34:20PM +0530, Kumar Kartikeya Dwivedi wrote:
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  include/linux/btf.h     |  46 ++++++++
> >  include/linux/btf_ids.h |  13 ++-
> >  kernel/bpf/btf.c        | 253 +++++++++++++++++++++++++++++++++++++++-
> >  kernel/bpf/verifier.c   |   1 +
> >  4 files changed, 305 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > index 0c74348cbc9d..95a8238272af 100644
> > --- a/include/linux/btf.h
> > +++ b/include/linux/btf.h
> > @@ -12,11 +12,40 @@
> >  #define BTF_TYPE_EMIT(type) ((void)(type *)0)
> >  #define BTF_TYPE_EMIT_ENUM(enum_val) ((void)enum_val)
> >
> > +enum btf_kfunc_hook {
> > +	BTF_KFUNC_HOOK_XDP,
> > +	BTF_KFUNC_HOOK_TC,
> > +	BTF_KFUNC_HOOK_STRUCT_OPS,
> > +	BTF_KFUNC_HOOK_MAX,
> > +};
>
> The enum doesn't have to be in .h, right?
> Would be cleaner to reduce its scope to btf.c
>

Ok, will do.

> >  		 */
> > -		if ((btf_mod->flags & BTF_MODULE_F_LIVE) && try_module_get(btf_mod->module))
> > +		if ((btf_mod->flags & BTF_MODULE_F_LIVE) && try_module_get(btf_mod->module)) {
> > +			/* pairs with smp_wmb in register_btf_kfunc_id_set */
> > +			smp_rmb();
>
> Doesn't look necessary. More below.
>
> > +/* This function must be invoked only from initcalls/module init functions */
> > +int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
> > +			      const struct btf_kfunc_id_set *kset)
> > +{
> > +	enum btf_kfunc_hook hook;
> > +	struct btf *btf;
> > +	int ret;
> > +
> > +	btf = btf_get_module_btf(kset->owner);
> > +	if (IS_ERR_OR_NULL(btf))
> > +		return btf ? PTR_ERR(btf) : -ENOENT;
> > +
> > +	hook = bpf_prog_type_to_kfunc_hook(prog_type);
> > +	ret = btf_populate_kfunc_set(btf, hook, kset);
> > +	/* Make sure all updates are visible before we go to MODULE_STATE_LIVE,
> > +	 * pairs with smp_rmb in btf_try_get_module (for success case).
> > +	 *
> > +	 * btf_populate_kfunc_set(...)
> > +	 * smp_wmb()	<-----------.
> > +	 * mod->state = LIVE	    |		if (mod->state == LIVE)
> > +	 *			    |		  atomic_inc_nz(mod)
> > +	 *			    `--------->	  smp_rmb()
> > +	 *					  btf_kfunc_id_set_contains(...)
> > +	 */
> > +	smp_wmb();
>
> This comment somehow implies that mod->state = LIVE
> and if (mod->state == LIVE && try_mod_get) can race.
> That's not the case.
> The patch 1 closed the race.
> btf_kfunc_id_set_contains() will be called only on LIVE modules.
> At that point all __init funcs of the module including register_btf_kfunc_id_set()
> have completed.
> This smp_wmb/rmb pair serves no purpose.
> Unless I'm missing something?
>

Right, I'm no expert on memory ordering, but even if we closed the race, to me
there seems to be no reason why the CPU cannot reorder the stores to tab (or its
hook/type slot) with mod->state = LIVE store.

Usually, the visibility is handled by whatever lock is used to register the
module somewhere in some subsystem, as the next acquirer can see all updates
from the previous registration.

In this case, we're directly assigning a pointer without holding any locks etc.
While it won't be concurrently accessed until module state is LIVE, it is
necessary to make all updates visible in the right order (that is, once state is
LIVE, everything stored previously in struct btf for module is also visible).

Once mod->state = LIVE is visible, we will start accessing kfunc_set_tab, but if
previous stores to it were not visible by then, we'll access a badly-formed
kfunc_set_tab.

For this particular case, you can think of mod->state = LIVE acting as a release
store, and the read for mod->state == LIVE acting as an acquire load.

But I'm probably being overtly cautious, please let me know why.

> > +	/* reference is only taken for module BTF */
> > +	if (btf_is_module(btf))
> > +		btf_put(btf);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(register_btf_kfunc_id_set);
> >
> >  #ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index bfb45381fb3f..b5ea73560a4d 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -1783,6 +1783,7 @@ static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
> >
> >  		mod = btf_try_get_module(btf);
> >  		if (!mod) {
> > +			verbose(env, "failed to get reference for BTF's module\n");
>
> This one is highly unlikely, right?
> One can see it only with a specially crafted test like patch 10.
> Normal users will never see it. Why add it then?
> Also there are two places in verifier.c that calls btf_try_get_module().
> If it's a real concern, both places should have verbose().
> But I would not add it in either.

Ok, I'll drop this.

Thanks!
--
Kartikeya
