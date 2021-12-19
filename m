Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788DE479EEF
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 04:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhLSDBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 22:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhLSDBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 22:01:31 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0E2C061574;
        Sat, 18 Dec 2021 19:01:31 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso9485841pji.0;
        Sat, 18 Dec 2021 19:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fngRf2Md8koYZeb8D7KOm28z/NY6gvIrL1L5qAu1hDc=;
        b=m7f+k+TgTgdHdFqqeo16zolcWGgIdr2Yd9oy38nbZH8e/uuQ0lsh/93EyBudOgUT7p
         pfCBN6tnH0etdAGXQZmXJitKznEFAZKrSV0+fRBw7vhkL5L9tAzCKb5cX6jGEP+mcey6
         +Of92tUuGGgt58D+v5IUXJgPkcUZb4o7DJTg7IJAnRGPK71ddHNh71l/WrKrYbJYgKXR
         APak3XWHlrSDjPRiyFl1uGPqrjTYdUj16NTQ1tCKMFmuynBGYRG5aB+awd//3oyN9dpS
         ScMlKefnvj2CbwEuEEqHrXVV8V0hppctAz607qCEMwFDW4BEH0mAxlgzndD/dw8mgBZM
         cNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fngRf2Md8koYZeb8D7KOm28z/NY6gvIrL1L5qAu1hDc=;
        b=wHWNukTOmStXbuWDeo+MZlmXrrZQM2sXvuczeQ1cb7IfIwzIJtx8HgPG1bQJEpEaop
         GyJVNgO6Ptzrei+ZeN9rFW1HwWd8tVCL76KE0XyBdyT8GDAuGWgf9hEMVkNtk7kv1VDO
         2MaeZ0Hsvop3qONp2Yx8CHyw3FFVzoeSCkeZI+f/h0EEhcGXnL/MKZlWd1Brg//TVTls
         hO23xuulWpS6ZrFmpBXHyyp34K1hKoVRwRl1WkOQMXc927oNHSPMZ0NWI2IYhiwh85j1
         eiktvtkzd9Y1vo3zMG7fFc9fSfyATM3BpJ5RGJiTEMKXIf0LaS3RjrisffJI0JappRE1
         NFGQ==
X-Gm-Message-State: AOAM530aPGTfegZQRMS9HcnEfG5Y6OAxQk56r+FIjWGrieeyX6EMsktv
        LsFg6KPG8ljyRswtxkiyVUs=
X-Google-Smtp-Source: ABdhPJyjYg4T9Gs6+2xLWWK3QK5emmwhw+y70oO/N85uuh6dyYTVCllKwKA20Ci0e3CM2tRJ47vfvg==
X-Received: by 2002:a17:90a:880a:: with SMTP id s10mr20505132pjn.214.1639882890621;
        Sat, 18 Dec 2021 19:01:30 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id n22sm14088709pfu.2.2021.12.18.19.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 19:01:30 -0800 (PST)
Date:   Sun, 19 Dec 2021 08:31:28 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v4 05/10] bpf: Add reference tracking support to
 kfunc
Message-ID: <20211219030128.2s23lzhup6et4rsu@apollo.legion>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-6-memxor@gmail.com>
 <20211219022248.6hqp64a4nbhyyxeh@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211219022248.6hqp64a4nbhyyxeh@ast-mbp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 19, 2021 at 07:52:48AM IST, Alexei Starovoitov wrote:
> On Fri, Dec 17, 2021 at 07:20:26AM +0530, Kumar Kartikeya Dwivedi wrote:
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 965fffaf0308..015cb633838b 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -521,6 +521,9 @@ struct bpf_verifier_ops {
> >  				 enum bpf_access_type atype,
> >  				 u32 *next_btf_id);
> >  	bool (*check_kfunc_call)(u32 kfunc_btf_id, struct module *owner);
> > +	bool (*is_acquire_kfunc)(u32 kfunc_btf_id, struct module *owner);
> > +	bool (*is_release_kfunc)(u32 kfunc_btf_id, struct module *owner);
> > +	bool (*is_kfunc_ret_type_null)(u32 kfunc_btf_id, struct module *owner);
>
> Same feedback as before...
>
> Those callbacks are not necessary.
> The existing check_kfunc_call() is just as inconvenient.
> When module's BTF comes in could you add it to mod's info instead of
> introducing callbacks for every kind of data the module has.
> Those callbacks don't server any purpose other than passing the particular
> data set back. The verifier side should access those data sets directly.

Ok, interesting idea. So these then go into the ".modinfo" section? I think then
we can also drop the check_kfunc_call callback?

--
Kartikeya
