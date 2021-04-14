Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDD935F4AE
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 15:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351249AbhDNNUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 09:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhDNNUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 09:20:33 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EF7C061574;
        Wed, 14 Apr 2021 06:20:12 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id g9so3830968wrx.0;
        Wed, 14 Apr 2021 06:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0bIhqwWNYbt6GC/BDwzGF9VeJCYSVuIr4dNVR3W4qu4=;
        b=RLqpk2TDhznv3HVhQAh/yRcKatVDxw5lYudoekV8tLzuGOYToMr6Szobqts5IhaT1/
         qxh10Kv4xBSplRbvwTnjyoMAsAi6HuQLM7HGQCNYPkdlq6jdtSahCg4D9c4tvC5Wxcyj
         Z2TvDa01ZqwkcNcZ7nkWy+mHFJQyh0m50Eeq2aAiTo26EMQpVRQp/7DwYt+dlTO1CNnA
         dX1XGFpEQiHZLotKVlCXfLTvoXJqaqMrLXuZQL5SLMtQJgmz1UbP+h++34ZiMqnaE45F
         sSzj9KwoK2UTqo6UOd0YPrWGUjVM0Du1xdNpYIc+7u4BFPfyhhMs3bnejVw7SEIdpAsn
         7DBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0bIhqwWNYbt6GC/BDwzGF9VeJCYSVuIr4dNVR3W4qu4=;
        b=oKPf1xMtCKx4FxVZvn32vIrr/k5mTnTq25iWKgD3aLtFX6CKFSWZTbZbuNtZE6TEVH
         Ww7lMIeLQr03me+xfwREc8H3LcKrOLxs/9QNEqSSjcxTBxdVRoqWAQeNDt6yK0znBL6A
         3rLGAVv/Trlszn8HWur06psA9gpTGojgc4v9zUv8dYN/JGBgeMUrpNQVulnG8RFtMKkI
         fgwcUGHliJ1+NqlAusT9gNe/vzhf3JUwce1lbfNJKeK3ad+U2as/wmhrzngIGtFwxPeA
         7BMjO4a0f6D294ta3hAmX89g0z5mFAfDZSQP+ZfVz8FC53tEjM9XJP+ORQB4Ht2QZZAS
         4Qcw==
X-Gm-Message-State: AOAM533xRR+cRp8xHx9TkLnL4nC+V1XVUbTHad/AM9ZmqwSXp1KI8k5E
        CICzjAPQ++cknGIVJ/whDE29mcXbpjy+jzyhYkU=
X-Google-Smtp-Source: ABdhPJxmJuvEpV8sgv2ZqRq2dUAwfJegUEE+z2dqxRneV2ErYGAytezOtr0nnRBQt1kDVVApl8JmywvGkps1tKZC2tY=
X-Received: by 2002:a5d:590d:: with SMTP id v13mr10412881wrd.85.1618406410336;
 Wed, 14 Apr 2021 06:20:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210409003904.8957-1-TheSven73@gmail.com> <0bf00feb-a588-12e1-d606-4a5d7d45e0b3@linux.ibm.com>
In-Reply-To: <0bf00feb-a588-12e1-d606-4a5d7d45e0b3@linux.ibm.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 14 Apr 2021 09:19:59 -0400
Message-ID: <CAGngYiXyQEui8+OiVQXe1UeypQvny_hr=qtuOri7r2guxVDm9g@mail.gmail.com>
Subject: Re: [PATCH net v1] lan743x: fix ethernet frame cutoff issue
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Julian,

On Wed, Apr 14, 2021 at 8:53 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
>
> On a cursory glance, using __netdev_alloc_skb_ip_align() here should
> allow you to get rid of all the RX_HEAD_PADDING gymnastics.
>
> And also avoid the need for setting RX_CFG_B_RX_PAD_2_, as the
> NET_IP_ALIGN part would no longer get dma-mapped.

That's an excellent suggestion, and I'll definitely keep that in mind
for the future.

In this case, I'm not sure if it could work. This NIC has multi-buffer
frames. The dma-ed skbs represent frame fragments. A flag in the
descriptor ring indicates if an skb is "first". If first, we can
reserve the padding. Otherwise, we cannot. because that would corrupt
a fragment in the middle. At the time of skb allocation, we do not
know whether that skb will be "first".

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/microchip/lan743x_main.c?h=v5.12-rc7#n2125

Maybe I'm missing a trick here? Feel free to suggest improvements,
it's always much appreciated.

Sven
