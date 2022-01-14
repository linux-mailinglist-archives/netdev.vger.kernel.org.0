Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B44548E38A
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 06:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiANFWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 00:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiANFWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 00:22:14 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866E6C061574;
        Thu, 13 Jan 2022 21:22:13 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id p37so1811998pfh.4;
        Thu, 13 Jan 2022 21:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hFEux4lGDMtlyP0qdztGJ0HFS8ku9s5gPosIQG83maw=;
        b=jVVkr8cN5FcsuVLMNxO19jJzPfe83VU2iCj8cZX+cjmBalCjDH1s67TJhGezHY37v3
         zkxNacxMdBodDbhWHRH7P2phh6cDQaHKWdBtVvBlIjEVohtQAk/C0hLRuoUZT2UenVhA
         Q2KBoNXvW5wnFFy5Wq2rMfovkGy+iP/IuV7xbpCTukhzVQkOcHu3X20rnPaKistHI92G
         Ujp7ka1opnwg7v3ZEPgwtbTdLWtjX3Ys2hFaqxngtd4WmJk9MhWDxq1IpdO+T9ZceRwr
         39DUo9mt4AhgOEazwVhAXAzW4rpuRaMKn21IbaldxKbpVVbGjbMvLMXryar2+DS87vTO
         S9NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hFEux4lGDMtlyP0qdztGJ0HFS8ku9s5gPosIQG83maw=;
        b=zbky1a3LVavg3Pvf2ZYRdGYjUMkbm8EQu8/gWVsACPlWQTjRqaUqmu4pyjdLCobm0Y
         6b+Zq0TLJAGOEBXFPr4gktjmtrZ+lcs95VFBrO3rFN78Q2h9NWjaenyyv29yn2r5yszK
         XuoDYhDOIQiIfSshbohNDgUyjfC70gn7/qSxXNwZemBdzzoOUjJZYYWorhyYGvlcCmX6
         0AZRCcJ/qIwexcwiiqqk7kPpFmNO4fpjkn4New8LxQdeEVIL2Jkx9XcXxHfieOxrDZGf
         uOws7fi6+sYDwHkb2ASxA/QjYazWT5MAVsiJSLb2XSn6Yco6uFI0uPu953jFdcmmzNtK
         yaMw==
X-Gm-Message-State: AOAM5330GC5/CtpbWtQDWyXB2/2W7hRQh/pwScOb/JjjSF84v2N9eODm
        4Hw0Ysju4oao4v6U7MZ7sG0UyWTOoLNijQ==
X-Google-Smtp-Source: ABdhPJzntD98Ne1CHNfo2imjoX+LsQ+68qoQ8AQNy+kb8aiSKaXDzVfGi5N7PvecCiPzdwOuilP76A==
X-Received: by 2002:a05:6a00:1795:b0:4c1:e2f6:d0c8 with SMTP id s21-20020a056a00179500b004c1e2f6d0c8mr6450033pfg.47.1642137732909;
        Thu, 13 Jan 2022 21:22:12 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id c82sm4239299pfc.1.2022.01.13.21.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 21:22:12 -0800 (PST)
Date:   Fri, 14 Jan 2022 10:51:29 +0530
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
Message-ID: <20220114052129.dwx7tvdjrwokw5sc@apollo.legion>
References: <20220111180428.931466-1-memxor@gmail.com>
 <20220111180428.931466-3-memxor@gmail.com>
 <20220113223211.s2m5fkvafd6fk4tv@ast-mbp.dhcp.thefacebook.com>
 <20220114044950.24jr6juxbuzxskw2@apollo.legion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114044950.24jr6juxbuzxskw2@apollo.legion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 10:19:50AM IST, Kumar Kartikeya Dwivedi wrote:
> On Fri, Jan 14, 2022 at 04:02:11AM IST, Alexei Starovoitov wrote:
> > On Tue, Jan 11, 2022 at 11:34:20PM +0530, Kumar Kartikeya Dwivedi wrote:
> > > [...]
> > > +	/* Make sure all updates are visible before we go to MODULE_STATE_LIVE,
> > > +	 * pairs with smp_rmb in btf_try_get_module (for success case).
> > > +	 *
> > > +	 * btf_populate_kfunc_set(...)
> > > +	 * smp_wmb()	<-----------.
> > > +	 * mod->state = LIVE	    |		if (mod->state == LIVE)
> > > +	 *			    |		  atomic_inc_nz(mod)
> > > +	 *			    `--------->	  smp_rmb()
> > > +	 *					  btf_kfunc_id_set_contains(...)
> > > +	 */
> > > +	smp_wmb();
> >
> > This comment somehow implies that mod->state = LIVE
> > and if (mod->state == LIVE && try_mod_get) can race.
> > That's not the case.
> > The patch 1 closed the race.
> > btf_kfunc_id_set_contains() will be called only on LIVE modules.
> > At that point all __init funcs of the module including register_btf_kfunc_id_set()
> > have completed.
> > This smp_wmb/rmb pair serves no purpose.
> > Unless I'm missing something?
> >
>
> Right, I'm no expert on memory ordering, but even if we closed the race, to me
> there seems to be no reason why the CPU cannot reorder the stores to tab (or its
> hook/type slot) with mod->state = LIVE store.
>
> Usually, the visibility is handled by whatever lock is used to register the
> module somewhere in some subsystem, as the next acquirer can see all updates
> from the previous registration.
>
> In this case, we're directly assigning a pointer without holding any locks etc.
> While it won't be concurrently accessed until module state is LIVE, it is
> necessary to make all updates visible in the right order (that is, once state is
> LIVE, everything stored previously in struct btf for module is also visible).
>
> Once mod->state = LIVE is visible, we will start accessing kfunc_set_tab, but if
> previous stores to it were not visible by then, we'll access a badly-formed
> kfunc_set_tab.
>
> For this particular case, you can think of mod->state = LIVE acting as a release
> store, and the read for mod->state == LIVE acting as an acquire load.
>

Also, to be more precise, we're now synchronizing using btf_mod->flags, not
mod->state, so I should atleast update the comment, but the idea is the same.

> But I'm probably being overtly cautious, please let me know why.
>

--
Kartikeya
