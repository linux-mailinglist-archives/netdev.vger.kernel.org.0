Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFE8578638
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiGRPZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbiGRPZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:25:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27A03286FF
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658157918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qNCpXXx/UVAScX22Wy0a2l/ouu+CQDoAik/pVsqQbrE=;
        b=fmLd6EYd1+kRZ5QwaHyW/GsEeMeBrvVdgyeGGQEfXDzBU2SuZJhshsXjzAqN5xM3pPA4t6
        YIWk/Q6Eii7Z8Nc0kG4TfO/GxbhxnJ1cb4p23pHpXj4DvxvmB7XSRawZkT8uFxjoJOdmUq
        Vi2tYvNc6Ru3Z9fDTFBRta9Dm2R1b9k=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-fflxwXsDPpyriysWsdhrQA-1; Mon, 18 Jul 2022 11:25:13 -0400
X-MC-Unique: fflxwXsDPpyriysWsdhrQA-1
Received: by mail-vk1-f198.google.com with SMTP id 3-20020a1f0203000000b003753417905cso788354vkc.2
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qNCpXXx/UVAScX22Wy0a2l/ouu+CQDoAik/pVsqQbrE=;
        b=EaxImx4Kr/NUcer+zi/Ps9E2uZcgK3HsVvFDLzmQX4o86yq0RccuqJRrApJwcK79uD
         7lpIE5dTGjhReA2VNBY23Iu0tHTsS1TINstHw5YLiHcbziJt70nec7MxXL6ssEHlMD0O
         bRLXTVs4xr8FOeoxE3XDWqVq1aPNMwBxxbnjbrhOXAPY9yRrQ5wlMZh09Bg1qmnamu2o
         pAshZ30k9Q3LfSoKI+Q0TmVwHPE2zxrzdUgVHqCtjBM3A2BwNa7AiFwlyyDykXGMOY3g
         wr784GQy3la/0J3mHSNXkSgijljYgcG9H1yFLgcTb/IBgARX5kHYinA//cw3quHCqFVQ
         VL3A==
X-Gm-Message-State: AJIora9y9fjVXDekyoYJdCVQ9pwX6KmbaYZzd1tDX9rhIIIrU4DrTwJc
        U2Z2Yjae8mb96rdvt/8hAD6hqsc1zApGe7wz1Z18yzaqhrHuRGku+s4iDfdWGJhT6urHaSPuCFG
        XZfD942QRdyJyphd0mOKqSmxraN5u/y3X
X-Received: by 2002:ab0:2714:0:b0:383:63cc:70e7 with SMTP id s20-20020ab02714000000b0038363cc70e7mr10319471uao.97.1658157912168;
        Mon, 18 Jul 2022 08:25:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vQvotaRoyIf2nMEL/TrLxO/+smhp3pgFkVffKPh5ZGRbIJX5oDe2aU0aj6XtvxQJlPnKTVdYY0+aNRWws2JW4=
X-Received: by 2002:ab0:2714:0:b0:383:63cc:70e7 with SMTP id
 s20-20020ab02714000000b0038363cc70e7mr10319431uao.97.1658157911235; Mon, 18
 Jul 2022 08:25:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220715125013.247085-1-mlombard@redhat.com> <5a469c5a.8b85.1821171d9de.Coremail.chen45464546@163.com>
 <CAFL455nnc04q8TohH+Qbv36Bo3=KKxMWr=diK_F5Ds5K-h5etw@mail.gmail.com> <22bf39a6.8f5e.18211c0898a.Coremail.chen45464546@163.com>
In-Reply-To: <22bf39a6.8f5e.18211c0898a.Coremail.chen45464546@163.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 18 Jul 2022 17:25:00 +0200
Message-ID: <CAFL455mXFY5AFOoXxhpUY6EkPzc1677cRPQ8UX-RSykhm_52Nw@mail.gmail.com>
Subject: Re: Re: [PATCH V3] mm: prevent page_frag_alloc() from corrupting the memory
To:     Chen Lin <chen45464546@163.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

po 18. 7. 2022 v 16:40 odes=C3=ADlatel Chen Lin <chen45464546@163.com> naps=
al:
>
> But the original intention of page frag interface is indeed to allocate m=
emory
> less than one page. It's not a good idea to  complicate the definition of
> "page fragment".

I see your point, I just don't think it makes much sense to break
drivers here and there
when a practically identical 2-lines patch can fix the memory corruption bu=
g
without changing a single line of code in the drivers.

By the way, I will wait for the maintainers to decide on the matter.

Maurizio

