Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC88A44396D
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 00:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhKBXTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 19:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbhKBXTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 19:19:20 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB00C061714;
        Tue,  2 Nov 2021 16:16:45 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id m14so457915pfc.9;
        Tue, 02 Nov 2021 16:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+v3yyZb0G5ns3De2ViS1173mJGx1xEPY475SSam2m5g=;
        b=SF2dqR4dgG9rM0vR9eefug4g+O9kU9qYOWMEoOz2wbSuLFA8ca30anZ0TdZIMaPO4R
         ojGkfnb4+3VRJegLz0xdbh5f/8kROMMnZRvTjh3k1BlJdK5HdZ0daJYGTGj1hLYIsoad
         hpRlMTUs+dyMSX97A6O33DnuHcEy+SLIocMlLaFOxEPxQsyTqtfStfFOTGM9NAOrZFQO
         ghF3CvprRhTwz/XbRmLIHTgD/x6aOx56nikjyRTCm3pVnlvwqcqLQn6oZPCyuvBZCeT5
         PaYs3QQXtLinxhSDxLN28Lz/+UTCtRMLDMMEoSoMmPP9VVr3w5vVj6CX2tK75zvrkXlB
         WLRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+v3yyZb0G5ns3De2ViS1173mJGx1xEPY475SSam2m5g=;
        b=rsSMMEjW7rDM6hRtqdh3fQmJj15ncQynBvMsUqwlVvkVt5odM+ewPnZTTWSZyQL9kx
         LHWuwNMcuNN6NFarfu5XM+rfrVYdFMpUAOqXKZRJ3MwUh+vrHPyJ+Sr1LeyerYeADVWW
         ecJYaS7re7K/6uydtAG7nelPeoHWZs8k07qORi6At9msZ822Cce62KOFvLrSc0yIw8RH
         FgkvegW0axFlSDuSBQ2hICkn94VBbWF66yyr00DaxSDn6ZQVUZ8IswA7hNHgDOKoOSKe
         XVHdWsWvi8CAlkXH/JEfl+qhkGEkmhiN7n3Vz6xteEnmWu9Z0KAzNb8k9rNHA2ySkgdf
         d9Yg==
X-Gm-Message-State: AOAM530VbU9+yd8aCOl7ac/s+KrxoaTbydwxEysk14jWvfYhOkZ0R8RH
        D3eGf98gXjJQ9yss48MmYOL/1yYiG44=
X-Google-Smtp-Source: ABdhPJycVc1WWKH4xHo3jje11uwkkvWEP89/xmIDAoqSRyAVxzmpdso/95EiY7QTSSRHFxnB6tctyQ==
X-Received: by 2002:aa7:8149:0:b0:44c:916c:1fdb with SMTP id d9-20020aa78149000000b0044c916c1fdbmr40818515pfn.34.1635895004963;
        Tue, 02 Nov 2021 16:16:44 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9df1])
        by smtp.gmail.com with ESMTPSA id b4sm225352pfl.60.2021.11.02.16.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 16:16:44 -0700 (PDT)
Date:   Tue, 2 Nov 2021 16:16:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next v1 0/6] Introduce unstable CT lookup helpers
Message-ID: <20211102231642.yqgocduxcoladqne@ast-mbp.dhcp.thefacebook.com>
References: <20211030144609.263572-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030144609.263572-1-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 30, 2021 at 08:16:03PM +0530, Kumar Kartikeya Dwivedi wrote:
> This series adds unstable conntrack lookup helpers using BPF kfunc support.  The
> patch adding the lookup helper is based off of Maxim's recent patch to aid in
> rebasing their series on top of this, all adjusted to work with kfunc support
> [0].
> 
> This is an RFC series, as I'm unsure whether the reference tracking for
> PTR_TO_BTF_ID will be accepted.

Yes. The patches look good overall.
Please don't do __BPF_RET_TYPE_MAX signalling. It's an ambiguous name.
_MAX is typically used for a different purpose. Just give it an explicit name.
I don't fully understand why that skip is needed though.
Why it's not one of existing RET_*. Duplication of return and
being lazy to propagate the correct ret value into get_kfunc_return_type ?

> If not, we can go back to doing it the typical
> way with PTR_TO_NF_CONN type, guarded with #if IS_ENABLED(CONFIG_NF_CONNTRACK).

Please don't. We already have a ton of special and custom types in the verifier.
refcnted PTR_TO_BTF_ID sounds as good way to scale it.

> Also, I want to understand whether it would make sense to introduce
> check_helper_call style bpf_func_proto based argument checking for kfuncs, or
> continue with how it is right now, since it doesn't seem correct that PTR_TO_MEM
> can be passed where PTR_TO_BTF_ID may be expected. Only PTR_TO_CTX is enforced.

Do we really allow to pass PTR_TO_MEM argument into a function that expects PTR_TO_BTF_ID ?
That sounds like a bug that we need to fix.
