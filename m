Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A742484E09
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 07:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbiAEGKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 01:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiAEGKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 01:10:44 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA9CC061761;
        Tue,  4 Jan 2022 22:10:43 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id g2so34659574pgo.9;
        Tue, 04 Jan 2022 22:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c7gkEmC5tF+7d71r6EPg3NkvqUoiequVOGJzgTvDk+c=;
        b=IoQhgL5UTwmFiWWTFwmdM/ZcX9KrhlOee5HY8XAFvwpx9KtdR3hJKzFdCNCtq5KOtJ
         bt9oHS1KGB8EI2JRiWsuRTN19A6MZVyQFIlTjc/lAcwpBj15o+YLekcil2zEnmqk1W11
         pIbDTQL8RaVmIy+5HdHDfqYkE8ZRq+3MnS0INWsSg+4dLIWuiiF12nLFjm7V4dhchtAj
         VNghQ187pwtJ1EZTBplDq7htRknLl/7J4mjJEAjtRrSV0otnAk+R77jj3SVwdln0Vp36
         3Tu9GHE3f3DWpLFZFCeTOkIIGTxJTUfNRnzT5cGrK1dHXSFXJNrjaZ51Vo1Avp5Z0yDn
         kuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c7gkEmC5tF+7d71r6EPg3NkvqUoiequVOGJzgTvDk+c=;
        b=MavaoVRhBLsInTOV8TzmmaUMq7utJKpsOIHPpE825EdZ4aUlCv4p6V3Vx0f/U8aNIP
         y4IPRe4tldqFB19Vv9TcxQtInq1jizb6bwf+7nGkkQyMMc46gcOHTMNTzYMSwJOvlU/0
         0TviYJnGq8fuQoO2tWhGkp78etWZrNQ+2wgS3tZo6bBi+/692zla4IUfOGB2w9iR0AtI
         AXk13fbo5rCYIse1qOLJJEMLOKrzmFdd9Rs+HLztsWBAVkmHCV5fKPHw5fTmP0CvFc1O
         TI17XGM7bSdtxaAYuMotokvlFsQnjm1ezx7OVIkpFOMXwjBdhT1Afxnvlr/rs4wDS5dr
         K5+A==
X-Gm-Message-State: AOAM533uTd/1YfVtXmjedYbRRsn7P4718Ic3/D1syEpaqn1IliPo5ISV
        GOAf9st9drvB5qXOuOzMhUQ=
X-Google-Smtp-Source: ABdhPJyzZJacIPo/b67svzzDsjhSvPjeMM6e8PFo5exAA4ToVis09ZcyjZTAYpW4MA4DliZlFrT6Dg==
X-Received: by 2002:a63:90c3:: with SMTP id a186mr46234178pge.323.1641363043318;
        Tue, 04 Jan 2022 22:10:43 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1a5b])
        by smtp.gmail.com with ESMTPSA id o11sm44875071pfu.150.2022.01.04.22.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 22:10:42 -0800 (PST)
Date:   Tue, 4 Jan 2022 22:10:40 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
Message-ID: <20220105061040.snl7hqsogeqxxruo@ast-mbp.dhcp.thefacebook.com>
References: <20220102162115.1506833-1-memxor@gmail.com>
 <20220102162115.1506833-3-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220102162115.1506833-3-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 02, 2022 at 09:51:06PM +0530, Kumar Kartikeya Dwivedi wrote:
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 33bb8ae4a804..b5b423de53ab 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6338,7 +6338,10 @@ struct module *btf_try_get_module(const struct btf *btf)
>  		if (btf_mod->btf != btf)
>  			continue;
>  
> -		if (try_module_get(btf_mod->module))
> +		/* We must only consider module whose __init routine has
> +		 * finished, hence use try_module_get_live.
> +		 */
> +		if (try_module_get_live(btf_mod->module))

Instead of patch 1 refactoring for this very specific case can we do:
1.
if (try_module_get(btf_mod->module)) {
     if (btf_mod->module->state != MODULE_STATE_LIVE)
        module_put(btf_mod->module);
     else
        res = btf_mod->module;

2. 
preempt_disable();
if (btf_mod->module->state == MODULE_STATE_LIVE &&
    try_module_get(btf_mod->module)) ...
preempt_enable();

3. add
case MODULE_STATE_LIVE:
to btf_module_notify()
and have an extra flag in struct btf_module to say that it's ready?

I'm mainly concerned about:
-EXPORT_SYMBOL(try_module_get);
+EXPORT_SYMBOL(__try_module_get);
in the patch 1. Not that I care about out of tree modules,
but we shouldn't be breaking them without a reason.
