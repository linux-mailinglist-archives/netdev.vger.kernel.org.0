Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2142C4810
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgKYTLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgKYTLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 14:11:16 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD6AC0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 11:11:16 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id k1so3676516eds.13
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 11:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7DhcRtZIkYFvLBdD9gC75AyNB9/kGI5nTlbPIxqDd2I=;
        b=jfPPA5ZlaT4BXPaVV7qPWImKpr8BeVK4gxSsXag79r0NWsiK3tCwB/72EWO7q3FwHD
         VWXTm3sMz9Hlt03DiSY5335butrVOVGUzbQkzVoYJXSkLlW34aQ1rJczvWGBxewwaRCC
         LeuI9MUumJfUXq7x9TRkqbR2LpK1ac25JXXTEAt6shNjYGTcYrOJjyCK0WD/+zx7N6dl
         HjiS3ON7Tl7k/8jLqYpHUdV8HhepMtypvo7aIVMFMORvvA10ts2LclA80o8f8bpE000C
         suy2o3hwobJYPz+84QvTlNN4tEtAjHQY/sGEst3hH07SMrQ8t8s7ODApEgfTZBRHmVbX
         SmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7DhcRtZIkYFvLBdD9gC75AyNB9/kGI5nTlbPIxqDd2I=;
        b=IkVuAlx+1bRhc4z2bAcB/tVeVgMisyj0EMN3UXIAYI4fSPeyLXXriq2dsvqCXJMatQ
         GL/zqMzCDqfahVINKsdYK9cf/1ex40aUIQ6zhFqEAnfLCeT2LKijGRxp3o1t7lJlGx8O
         pJR9sUTy/C2KQPkZxTmbLDT+iPK/1QJMdp4MGMR+IUQWZnfeNcP6R4ez9lchHDILJFZM
         9u30nwIq1t/s8lM91w10zFh8inl1wcdmy0aNHwSgBmWfmSWc+DZCym5REgU+xdKC7ic2
         7awBrff7btZNLjeFHhqwxEGv61ge73oKjtwHzVikjsCLfs3/E/5Usd+tu3nOylY4OSyx
         tpjA==
X-Gm-Message-State: AOAM531ikcf5sln+k4/8E7xcyQkQkcmGkwyC6Yn/NpC+XVy8MapkGVd6
        VMKTFf344b4Nd5KzZWWOI4vLNEJYyRHivRTZgUZ4/A==
X-Google-Smtp-Source: ABdhPJyBXyIucQjz6/GJNE0dZVNWhaACR5d9ba6DON2ni8TMXq40NLSibPgbh4F5mRvngRigyCrZOnLlbeaOMTbBSPY=
X-Received: by 2002:aa7:d407:: with SMTP id z7mr5004116edq.234.1606331474522;
 Wed, 25 Nov 2020 11:11:14 -0800 (PST)
MIME-Version: 1.0
References: <20201125173846.3033449-1-awogbemila@google.com>
 <20201125173846.3033449-5-awogbemila@google.com> <8ebc0d23-c513-2667-c59f-f42538c770f1@gmail.com>
In-Reply-To: <8ebc0d23-c513-2667-c59f-f42538c770f1@gmail.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 25 Nov 2020 11:11:03 -0800
Message-ID: <CAL9ddJfG9+WLonJnJe8b8ckJXH7xw2=0QM_cVGYYqdfix9C9WQ@mail.gmail.com>
Subject: Re: [PATCH net-next v8 4/4] gve: Add support for raw addressing in
 the tx path
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Code does not match the comment (Give packets to NIC.
>     Even if this packet failed to send the doorbell
>     might need to be rung because of xmit_more.)
>
> You probably meant :
>
>     if (nsegs) {
>         netdev_tx_sent_queue(tx->netdev_txq, skb->len);
>         skb_tx_timestamp(skb);
>         tx->req += nsegs;
>         if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
>             return NETDEV_TX_OK;
>     }
>     gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
>     return NETDEV_TX_OK;
>
>
> Or
>
>     if (nsegs) {
>         netdev_tx_sent_queue(tx->netdev_txq, skb->len);
>         skb_tx_timestamp(skb);
>         tx->req += nsegs;
>     }
>     if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
>         return NETDEV_TX_OK;
>
>     gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
>     return NETDEV_TX_OK;
>
> Also you forgot to free the skb if it was not sent (in case of mapping error in gve_tx_add_skb_no_copy())
>
> So you probably need to call dev_kfree_skb_any(), or risk leaking memory and freeze sockets.
>
>     if (nsegs) {
>         netdev_tx_sent_queue(tx->netdev_txq, skb->len);
>         skb_tx_timestamp(skb);
>         tx->req += nsegs;
>     } else {
>         dev_kfree_skb_any(skb);
>     }
>     if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
>         return NETDEV_TX_OK;
>
>     gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
>     return NETDEV_TX_OK;

Right, thanks for the examples Eric. I think I understand this a
little better now.
I'm trying to think about whether your second example might be better
than the first one because in the case of nsegs=0 the first example
rings the doorbell immediately regardless of xmit_more, while in the
second example, if there is xmit_more then we can delay ringing the
doorbell until we try again  - and we would be guaranteed to try again
because of xmit_more right?
My hunch for which is better is based on how __netdev_tx_sent_queue works.
