Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25D3654CE9
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 08:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiLWHjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 02:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiLWHjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 02:39:15 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2360A31342
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 23:39:15 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 17so4321848pll.0
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 23:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FA3Upgc6ssVe6xdA6JsVzh+Jt01y4Sqla6SzmXxN8g4=;
        b=vEB8Uzl9vY9nFk2qr5qnMKufBVt0p9QAaVvDrH4DemwYgfNK7N0YX/xnomNhC/xTTL
         roXzvIplSwSMpCGxoARG08eZpDE1T+19szBMbk0zc4KcmmR2b4OMZMKPcq4csrBwjO/a
         fp+xxrOFSU6sg99h++InHBt9mE1TuCRX8FazaiHK4BKU1KqhL4UYUruHLrs654GnB0TE
         rrq1pC3kMoIj+fvCqOofRqJUAEPQlJsIQ5nv6VN3MKzV8LqjaH/fdY8B+TwjQCPOmd7y
         9rc+M7H642JfsI2vne32JJk2ylFSaC9hk5KyHKbBTY3YYOhisb6k2qB62QnWUtkrnRjA
         7dHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FA3Upgc6ssVe6xdA6JsVzh+Jt01y4Sqla6SzmXxN8g4=;
        b=G6e2nZIxptTqzd1DpEr2I9K7fCCbrD5/96qmfhsY7wnRLk33+g7XfaRe2lBHT6TB2N
         /yo3hv/GCU3w9wxMgsSrFSRhGNf9jygeCbkXVUog0kIuCiNDmuxKL52wAgpKOnSCUkk/
         cKA/53Pygpe/fTJHbB7rrUiMQamSOR5kx7JWhVsFAQBQdA2UTQHcieCSZZ6tkkMPTvTl
         Np5MhY8V2/RZ4WG0ElxF2ZDvr5fusZE8Pgg05Wt6TfeUTjwXnVOAxtN1kLTX/hdhs1gi
         DupJGMue5dVFh+UL0s4VEvWBHeI7ZeW7H3I+xvVGvS8bEUajzVUGWmdXJ1he8cKYLBI4
         Mfhg==
X-Gm-Message-State: AFqh2kqWtKmbwgLzbPFTJKZieWN77nydMWQ6H8TXu1DMvNpHZwTAlNOM
        NHCgGyXvtIGMLqqgLkibko0V73b7asZG46tvDf0lJw==
X-Google-Smtp-Source: AMrXdXvDj0D6mEXUNNu6qGMXLoMu/FdEZ4pbbuy35Y4YNHmOWTPoYDiaqmoAxQk43wJi6/6n/NRUNy34u1Azpqdc3mM=
X-Received: by 2002:a17:90b:8b:b0:219:19c1:1ae7 with SMTP id
 bb11-20020a17090b008b00b0021919c11ae7mr675588pjb.13.1671781154551; Thu, 22
 Dec 2022 23:39:14 -0800 (PST)
MIME-Version: 1.0
References: <20221222060427.21626-1-jasowang@redhat.com> <20221222060427.21626-5-jasowang@redhat.com>
 <CAJs=3_D6sug80Bb9tnAw5T0_NaL_b=u8ZMcwZtd-dy+AH_yqzQ@mail.gmail.com>
 <CACGkMEv4YxuqrSx_HW2uWgXXSMOFCzTJCCD_EVhMwegsL8SoCg@mail.gmail.com>
 <CAJs=3_Akv1zoKy_HARjnqMdNsy_n34TzzGA6a25xrkF2rCnqwg@mail.gmail.com> <CACGkMEvtgr=pDpcZeE4+ssh+PiL0k2B2+3kzdDmEvxxe=2mtGA@mail.gmail.com>
In-Reply-To: <CACGkMEvtgr=pDpcZeE4+ssh+PiL0k2B2+3kzdDmEvxxe=2mtGA@mail.gmail.com>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Fri, 23 Dec 2022 09:38:37 +0200
Message-ID: <CAJs=3_BqDqEoXGiU9zCNfGNqEjd1eijqkE_8_mb3nC=GwQoxHA@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq command
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
        eperezma@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This needs to be proposed to the virtio spec first. And actually we
> need more than this:
>
> 1) we still need a way to deal with the device without this feature
> 2) driver can't depend solely on what is advertised by the device (e.g
> device can choose to advertise a very long timeout)

I think that I wasn't clear, sorry.
I'm not talking about a new virtio feature, I'm talking about a situation when:
* virtio_net issues a control command.
* the device gets the command, but somehow, completes the command
after timeout.
* virtio_net assumes that the command failed (timeout), and issues a
different control command.
* virtio_net will then call virtqueue_wait_for_used, and will
immediately get the previous response (If I'm not wrong).

So, this is not a new feature that I'm proposing, just a situation
that may occur due to cvq timeouts.

Anyhow, your solution calling BAD_RING if we reach a timeout should
prevent this situation.

Thanks
