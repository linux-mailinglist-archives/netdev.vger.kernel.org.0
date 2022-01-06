Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643604861A0
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 09:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbiAFIqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 03:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiAFIqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 03:46:14 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D54FC061245;
        Thu,  6 Jan 2022 00:46:14 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so7664144pjf.3;
        Thu, 06 Jan 2022 00:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1g5znKzwVQyr8JGP5wcK15N7YAYxTOvtUNrF3FkqxRY=;
        b=JH/D/kUpLjMHVnIfOml1ThcJW6vnsVYO6KpdEkaMwA8vmt0UA6B5l0VRLCHp2HdbLU
         YFyXYYfVm+uPcIcPAK5k/qzr03bvOLcq4ZCCxwXmbqOdb8IZWFwhjgsngABwc2NfhUhs
         Oqp7w09d5h6bXzsLg9v1k7AxpMgQoWQI6AHk9/sflpU43TMonN5sFE2Tt/rTRm8h4VwZ
         Jf4feFkYymFirSFQhZqkIt1nl7zFTK/q05hxM52UyNOXuOdX6SWt5l4lVT9mxAPbTAsL
         cYwOomWWJBoVI0b9es4cvr5UANj+uo5iseXIyT4CYzORvm8p7ktSngIO8BDSiylk/1FC
         eEqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1g5znKzwVQyr8JGP5wcK15N7YAYxTOvtUNrF3FkqxRY=;
        b=JSzxZ6lKFR6AbnAWSmprioQTCLd1Sn8U+1x1FKLrmzSQvDfBf6jXALPMfofBZ7XmcI
         Cns7frgErj//TsAG83+aCfOsh7iLXNXV/P2y6kg1QQKd6HnAG6mOJt+r3E8wAGr02rWS
         bIuPxcdE3UcMNG0INIk5LyV4pNe72C39vw2aKvZR+TMk8eaL7pHTEPlS2lH1NNJj7D4B
         Pef1LaLG5xypIrlAip9cEPz7pEswG84GYL4ZRoFkMVqZOTgtr6MpuNFDf9g6HRMdqcji
         iSX1r+QH3WCTPRgeOo/eCGvssPSfEdzeAleK9wHswkuNNFyKHHg7m1qSyMiV/hpGcm2q
         ZjZw==
X-Gm-Message-State: AOAM532jWubzod2fgjXfz0oUX1WAeK1Hj4OWFrHkvv3Vyk5hWdi0sUnP
        Xt/a7nKIhkIjJdc46sL726k=
X-Google-Smtp-Source: ABdhPJxpyep5VpI9kuAAse0CHM21bIuGT22lH6M4En5sJ46+Rc2z/NIwgQTLE/FGKb7PnP34L5UZvw==
X-Received: by 2002:a17:90b:4a51:: with SMTP id lb17mr8892950pjb.101.1641458773528;
        Thu, 06 Jan 2022 00:46:13 -0800 (PST)
Received: from localhost ([103.4.221.252])
        by smtp.gmail.com with ESMTPSA id c24sm1485243pgj.57.2022.01.06.00.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 00:46:13 -0800 (PST)
Date:   Thu, 6 Jan 2022 14:16:03 +0530
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
Subject: Re: [PATCH bpf-next v6 02/11] bpf: Fix UAF due to race between
 btf_try_get_module and load_module
Message-ID: <20220106084603.pgyziuv7wdts4yt7@apollo.legion>
References: <20220102162115.1506833-1-memxor@gmail.com>
 <20220102162115.1506833-3-memxor@gmail.com>
 <20220105061040.snl7hqsogeqxxruo@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105061040.snl7hqsogeqxxruo@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:40:40AM IST, Alexei Starovoitov wrote:
> On Sun, Jan 02, 2022 at 09:51:06PM +0530, Kumar Kartikeya Dwivedi wrote:
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 33bb8ae4a804..b5b423de53ab 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -6338,7 +6338,10 @@ struct module *btf_try_get_module(const struct btf *btf)
> >  		if (btf_mod->btf != btf)
> >  			continue;
> >
> > -		if (try_module_get(btf_mod->module))
> > +		/* We must only consider module whose __init routine has
> > +		 * finished, hence use try_module_get_live.
> > +		 */
> > +		if (try_module_get_live(btf_mod->module))
>
> Instead of patch 1 refactoring for this very specific case can we do:
> 1.
> if (try_module_get(btf_mod->module)) {
>      if (btf_mod->module->state != MODULE_STATE_LIVE)
>         module_put(btf_mod->module);
>      else
>         res = btf_mod->module;
>
> 2.
> preempt_disable();
> if (btf_mod->module->state == MODULE_STATE_LIVE &&
>     try_module_get(btf_mod->module)) ...
> preempt_enable();
>
> 3. add
> case MODULE_STATE_LIVE:
> to btf_module_notify()
> and have an extra flag in struct btf_module to say that it's ready?
>
> I'm mainly concerned about:
> -EXPORT_SYMBOL(try_module_get);
> +EXPORT_SYMBOL(__try_module_get);
> in the patch 1. Not that I care about out of tree modules,
> but we shouldn't be breaking them without a reason.

Alright, we could also export try_module_get, but let's go with option 3.

--
Kartikeya
