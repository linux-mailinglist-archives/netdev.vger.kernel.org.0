Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5873B2525
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhFXCnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbhFXCnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 22:43:52 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2C9C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 19:41:33 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ji1so7086545ejc.4
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 19:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t5yU4VNCFXj8gX5a2epQpgz96V1dLxQZPsWYLsxFdgg=;
        b=Et++QnyDd9L4pOu9fEFAjTGysR5Tz9E2KZmoJkdrxAlKCYbST6FXREEOgxoKpGGj05
         A90pCfDI4SdcJY+F6LV4GeeJAQF2fMW+TahVDSuVXNANhvdNw0zs725LwdkwGChNzlNu
         ovJK8f+MSbHULjzHrctEqd5kGlm30gIhIrL9s1lzCIBcYSqy7g8xr3Auzxjkn0xjs4jX
         2iQt9/NCqOVUniMQW7GtJ7IoV1KKMXwDjPoYc6FMTY7he2qzIeIXcmd74M613TwlXWk0
         cHAcSyRJ9bz2pLhM2Ng0Nr73c5Pdp9awcyycj4cq/KXW+xU7ZgqhOgYxQo+DFTfty9My
         a6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t5yU4VNCFXj8gX5a2epQpgz96V1dLxQZPsWYLsxFdgg=;
        b=XfqRPlYyEUr2nDURFhJb5Wztf5z3odY5CnDcL2NaGmpBcDyTeujWr1hbjUcIUt6iWU
         DbwQcTtWD2X80p5UbgmYWG2asOO7jptVnz5lEmaGDRFplrJ9rF7kXUPNP84UmZcj4+iS
         Q4xqTV1XnsxDExzWPKVPxtLK2N91UuVaZG3Fk0Zj+REGsdFbhY7KHA5O76M2A7TyBHs7
         OpQRqGkehFgvveIRng1DXFfv07zDOr+MQMwrbeQNN5yYqH+jjakzF9hW7avNKNBW/Rb+
         05czClYPsvgO4toXUlWAaXjngo0uDx2gsmyk52aZj2PFWBBJaDWT627iIZMXumam/d1E
         R1+Q==
X-Gm-Message-State: AOAM5324xiNcfxbSKN+9NeJFgP7dCAyMCv69/szyo+c76ss4IMmcql8a
        dMl8ftLxolptFHRsuv/87WjcbmysaIOQVA==
X-Google-Smtp-Source: ABdhPJxoBhSy3nhPW/1t3eSR4SsseTSIkNvZS7eB9QDk2fKrrv1ajP3yDrMM2nePpcOPtk08nb2KZA==
X-Received: by 2002:a17:906:1c84:: with SMTP id g4mr2840532ejh.99.1624502491725;
        Wed, 23 Jun 2021 19:41:31 -0700 (PDT)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id f14sm977340edd.69.2021.06.23.19.41.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 19:41:30 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id p10-20020a05600c430ab02901df57d735f7so5196759wme.3
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 19:41:30 -0700 (PDT)
X-Received: by 2002:a1c:7c0b:: with SMTP id x11mr1342824wmc.183.1624502490152;
 Wed, 23 Jun 2021 19:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210623214438.2276538-1-kuba@kernel.org> <CA+FuTSergCOgmYCGzT4vrYfoBB_vk-SwF45z2_XEBXNbyHvGUQ@mail.gmail.com>
In-Reply-To: <CA+FuTSergCOgmYCGzT4vrYfoBB_vk-SwF45z2_XEBXNbyHvGUQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 23 Jun 2021 22:40:53 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeT9WWQYjDMCAOqjLuT-LjYOO+yrfE=qU=cwXRt+ExCug@mail.gmail.com>
Message-ID: <CA+FuTSeT9WWQYjDMCAOqjLuT-LjYOO+yrfE=qU=cwXRt+ExCug@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: ip: avoid OOM kills with large UDP sends
 over loopback
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, brouer@redhat.com, Dave Jones <dsj@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >                         if (transhdrlen) {
> > -                               skb = sock_alloc_send_skb(sk,
> > -                                               alloclen + hh_len + 15,
> > +                               skb = sock_alloc_send_skb(sk, alloclen,
> >                                                 (flags & MSG_DONTWAIT), &err);
> >                         } else {
> >                                 skb = NULL;
> >                                 if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
> >                                     2 * sk->sk_sndbuf)
> > -                                       skb = alloc_skb(alloclen + hh_len + 15,
> > +                                       skb = alloc_skb(alloclen,
> >                                                         sk->sk_allocation);
> >                                 if (unlikely(!skb))
> >                                         err = -ENOBUFS;
>
> Is there any risk of regressions? If so, would it be preferable to try
> regular alloc and only on failure, just below here, do the size and SG
> test and if permitted jump back to the last of the three alloc_len
> options?

sk_page_frag_refill when using frags will try also try large allocations first
(SKB_FRAG_PAGE_ORDER == order-3) , but can degrade more gracefully
under memory pressure than this header alloc. Which can only succeed
or fail for the total size. So without memory pressure this only takes two
extra allocations for a 64KB skb.
