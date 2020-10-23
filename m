Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788DB296885
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 04:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374626AbgJWCZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 22:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374619AbgJWCZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 22:25:51 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A45C0613CE;
        Thu, 22 Oct 2020 19:25:51 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id 1so76794ple.2;
        Thu, 22 Oct 2020 19:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KjJoVXKZw+OhDsOpPv8sfQYL74BmYXzx3D9nmlB/2u4=;
        b=AMGyGgFHhCXF/3hwlZEdT2UFYQii6MCtwJZeAoriX9i4jnjm2IDwXAYZ75jidqqbhv
         55MgKX2VuSq5BSkdAGJkpuwtuwNoLQCdbNcV3pl+Q7VQaaZE3v3XnlS5sLSW8e+z+OwT
         H1BCFfKae5nCGdECbaly5gMfe+mU0Q5vbcWUBkmwAP+OcG40RRqp5q/LvE87V3x+bMGY
         B0Nn7O8LZMNGOM5IMXczS5KkHxTUB3O1962ctehp7L2V6rQxRofi7lxQdubfZnUTn/CT
         QHnPtGwt3N3xZf71cId5fTD1HCA+SsgzRo+qxz2/fOqsQBXowa5DGB/8cH9BJZmjfHyS
         58gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KjJoVXKZw+OhDsOpPv8sfQYL74BmYXzx3D9nmlB/2u4=;
        b=rlMBcUM2OOYbWx8YXlj8vtDJiTpu0sPIaba50K8ovkdWIwoVn+ETHscc+bZpkPzsyt
         lRL+U5Uk6sFWtAsFdAQCMUiWHhTZAHgoR3XI0WLVYFSaGg5YHEnA6UtzLX0HPsZP4Zoo
         w01U2lJemJVVJWDekwvnlN+x2PNH+FErWHo975QBBC2O4KlnvosBbLl99i9qp4rfx0XA
         etrTC1ZSO9A15yt7kSrYHYPzfNfd2jc1iTZAX8Peg973bEb3jN+BqfUkLeVsArpBjDTl
         9u1geWtDpcepWPAm1MHef3vaHVU2MjRU8pA8+jhq3vYFzFJsDawH8l1GnM23xW47Jnea
         pp8w==
X-Gm-Message-State: AOAM533aD4PQoOPM3pUCjXRUrYaFBqqw6vf2yiaI6XBDzRIJb5WZVtTH
        m68WDMify/WIU4a8ytnJaUkq8kuC/r6y6TAvuzA=
X-Google-Smtp-Source: ABdhPJynkuR073dStCSsoqO7f7ihpmRsroaYN7Vk55GisWZaRmbDMi7zUrkhZjQic/m/rlRt4z2UzDGvPBogQGwBKeU=
X-Received: by 2002:a17:902:d90d:b029:d5:ee36:3438 with SMTP id
 c13-20020a170902d90db02900d5ee363438mr52574plz.77.1603419950826; Thu, 22 Oct
 2020 19:25:50 -0700 (PDT)
MIME-Version: 1.0
References: <20201022072814.91560-1-xie.he.0141@gmail.com> <CAJht_ENMQ3nZb1BOCyyVzJjBK87yk+E1p+Jv5UQuZ1+g1jK1cg@mail.gmail.com>
 <20201022082239.2ae23264@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAJht_EM638CQDb5opnVxfQ81Z2U9hGZbnE581RFZrAQvenn+qQ@mail.gmail.com>
 <20201022174451.1cd858ae@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <CAJht_EOo50TxEUJmQMBBnaH4FW_2Afpcrr0pStFEXH1Bg3vteg@mail.gmail.com>
In-Reply-To: <CAJht_EOo50TxEUJmQMBBnaH4FW_2Afpcrr0pStFEXH1Bg3vteg@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 22 Oct 2020 19:25:40 -0700
Message-ID: <CAJht_EMuVzRSp+OmKFY0nPnkC0a39k93KQAeaOFghLBy6TXgiQ@mail.gmail.com>
Subject: Re: [PATCH net RFC] net: Clear IFF_TX_SKB_SHARING for all Ethernet
 devices using skb_padto
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 6:56 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> My patch isn't complete. Because there are so many drivers with this
> problem, I feel it's hard to solve them all at once. So I only grepped
> "skb_padto" under "drivers/net/ethernet". There are other drivers
> under "ethernet" using "skb_pad", "skb_put_padto" or "eth_skb_pad".
> There are also (fake) Ethernet drivers under "drivers/net/wireless". I
> feel it'd take a long time and also be error-prone to solve them all,
> so I feel it'd be the best if there are other solutions.

BTW, I also see some Ethernet drivers calling skb_push to prepend
strange headers to the skbs. For example,

drivers/net/ethernet/mellanox/mlxsw/switchx2.c prepends a header of
MLXSW_TXHDR_LEN (16).

We can't send shared skbs to these drivers either because they modify the skbs.

It seems to me that many drivers have always assumed that they can
modify the skb whenever needed. They've never considered there might
be shared skbs. I guess adding IFF_TX_SKB_SHARING to ether_setup was a
bad idea. It not only made the code less clean, but also didn't agree
with the actual situations of the drivers.
