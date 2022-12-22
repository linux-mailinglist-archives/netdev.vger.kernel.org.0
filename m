Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754986544A8
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 16:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiLVPzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 10:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiLVPzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 10:55:43 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608E51A80F
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 07:55:38 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id x66so1513540pfx.3
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 07:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RVaV7gXLAFZP6vBGDynJRLj4x0H9TKcM19ib2OhgZ/w=;
        b=EAlNqUp4R98KPIi17pVdCnGeg5YLtNQ9E22YaC1IFqgL+oNc1/lrrzl9VI+JoE13lK
         VjR+L7aPwZEWakcgUqLmXMSQGZRe1ByvOVnPjx0FkqCB0YAvQ7g/QYD/oKpltY7og9uh
         fj46XAgcvN9T82QeRZ5TYiGWzLt1NDC0/jcMQbA9nah/zSLLM65bkL3BEYwGTTT7JE+E
         fRlmfJcYb3OfKXRLNLFyF4BtRo8cQ20YymZrzvB0pjm3rlMM1g90MHpr4pb/vujzl5KI
         RnxT1tJKm6B06dpjlVt6MNAwhdgkmhFEuC/piaLlUHv3zKIhCnj8rgzUXt+u0NHtQ6be
         E5Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RVaV7gXLAFZP6vBGDynJRLj4x0H9TKcM19ib2OhgZ/w=;
        b=0tr9kHIs5PL0xYFIa+rS0v1popSbUqj40KNyEBW6SiO/jYDn1YSvG0zzhZwBOacSbg
         9i39pV8sOiJJJ5BeAIS5GfdtvC5qlOEUe5YZlAApqrnIG83PpRf9asrkIHgj3Ema+Eg1
         j/URu7HGTI8UeHcSgaa/mvkK0WzedzafICyYBotHVONyjs4NH4dzah3IVfZmzSXb3aaz
         cXX+Chwh943mQMGYTJw9QL2FrEBU5yNNY+FWYPhHYpvg3DbPp/G+i/GXjl8si1gkgRvw
         kPvMmyLaHy/EGvrx+TgFGS/kC+jOPR1XOzqBMqxEMCbDh65obrha+MdawyaSu7+sFYHF
         PTew==
X-Gm-Message-State: AFqh2kqZyHiBDiJXRcQTgHt6QdVPRI8SnO3g97x9m3ASZoUbJcpFZyF0
        9Zqxwx+pPdPxYxMjGIHZxXX2VzWDl2PkXM0eiQ2Jsg==
X-Google-Smtp-Source: AMrXdXvFRr7/qzMUTbWIbPlyXiSK1LlPeSwNSmbVaA49P8mvF4F6AzosMjY/nVV12nHcybLxRklk9IDiMv161RPdSo4=
X-Received: by 2002:a63:40c5:0:b0:489:17a2:a53d with SMTP id
 n188-20020a6340c5000000b0048917a2a53dmr317357pga.255.1671724537702; Thu, 22
 Dec 2022 07:55:37 -0800 (PST)
MIME-Version: 1.0
References: <20221222060427.21626-1-jasowang@redhat.com> <20221222060427.21626-5-jasowang@redhat.com>
 <CAJs=3_D6sug80Bb9tnAw5T0_NaL_b=u8ZMcwZtd-dy+AH_yqzQ@mail.gmail.com> <CACGkMEv4YxuqrSx_HW2uWgXXSMOFCzTJCCD_EVhMwegsL8SoCg@mail.gmail.com>
In-Reply-To: <CACGkMEv4YxuqrSx_HW2uWgXXSMOFCzTJCCD_EVhMwegsL8SoCg@mail.gmail.com>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Thu, 22 Dec 2022 17:54:59 +0200
Message-ID: <CAJs=3_Akv1zoKy_HARjnqMdNsy_n34TzzGA6a25xrkF2rCnqwg@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq command
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
        eperezma@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My point is that the device may complete the control command after the timeout,
so, if I'm not mistaken, next time we send a control command and call
virtqueue_wait_for_used we'll get the previous response.
