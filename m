Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CF5668657
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 23:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239903AbjALWHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 17:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbjALWG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 17:06:29 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633FC76ADD
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 13:55:09 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id s67so13720710pgs.3
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 13:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gI3VA8VR1tTNE2kKsuPUsOqOlYtUfcBQRHlOmEvp2Cg=;
        b=CzLyu/40zsXjRUBwyJ/UQvN7BQhvw18AaW5MRlrox20fTcC9UCnFaHKeB2xfnSvAdK
         lWJ3T57GJGtQx6FdhAvUO8gJ0IYk5v2f/RrBwwz1lytHR91j1MJhGEmDWgm5qLsKNU5U
         kDjrPKpu3metucIHXPbxosrxycAzUU/6k4t63L4X92o/XQc8lyvyz47WI4nbfJwwufkU
         kZpFA6jqrT0TCN96AVSI0J3ecicyFe/9CtO1Hg2EpgAsFV5RrUFN3B/Tf7NQDY76GzP7
         ysjaFBQUYD2ecvbn64qpGh+IVZRtWsVZQh+PhGoQhJphNOhVMgAq3zMdy/MbuVqSRtPp
         2ZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gI3VA8VR1tTNE2kKsuPUsOqOlYtUfcBQRHlOmEvp2Cg=;
        b=Kd67w6H/zBPys2lYmKiJhHk2KeYCZmNdj+lhhzzA9lR3d4zJWIkFMoBvwp9ZXGQ4kB
         TUy3QRUw3KJfImRT9LQBTsqgeXAClPK8xSswXYE9sCFTUEf4zDIAp5fNIQDtuxeDLxkG
         x676zbWvfHTBV2HMyHDD2aAnHBLAj9U+yRUpxJiNlgtI/VNvZwwEnEA/tZI455sIsrC4
         1zCAf8fg5kiTnFxhxFFokOREmb23HHHSeifZtZyv+D0SW5zHpGf0L8Gq8y6gG/Z90qvm
         vuxaVRHZnK8aKWuWy0g7rnze3ETz4HgnqFxYKrAwxZ4tgqGfAKsLpukTSQMbfUKwdlYX
         5kug==
X-Gm-Message-State: AFqh2kqcvwD2qVTs2wfsQm/6lVLRqxtLb4Doo7rJ3WXW3gH890C+/0kp
        WGbqYwYnfKSlvVFI1bzGA2oR5rWnn6X68qi39wo=
X-Google-Smtp-Source: AMrXdXvRUxgB/A1wiEGutxN5gy2Ibqk63xMEvWBz7ARLT4iQcOYZqL9ZvRYP9gz4u2/A8Hq++s7+VPXnlIoZC8lLwac=
X-Received: by 2002:aa7:973d:0:b0:582:197f:580f with SMTP id
 k29-20020aa7973d000000b00582197f580fmr4323067pfg.2.1673560508776; Thu, 12 Jan
 2023 13:55:08 -0800 (PST)
MIME-Version: 1.0
References: <20230112105440.1786799-1-vladimir.oltean@nxp.com>
 <0031e545f7f26a36a213712480ed6d157d0fc47a.camel@gmail.com>
 <20230112185355.yltldjsbxe66q54w@skbuf> <CAKgT0UfnRceCA__HkpVnONO_AAp+wt+1GC2b6-vNk8oPh6aV9g@mail.gmail.com>
 <20230112213629.4luzdpktiq7ho3pk@skbuf>
In-Reply-To: <20230112213629.4luzdpktiq7ho3pk@skbuf>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 12 Jan 2023 13:54:57 -0800
Message-ID: <CAKgT0UdJRkds8FFGHppLWOQoAEgjRw6SjccaxPGBg4d7OWpaqg@mail.gmail.com>
Subject: Re: [PATCH net] net: enetc: avoid deadlock in enetc_tx_onestep_tstamp()
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 1:36 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Thu, Jan 12, 2023 at 01:29:21PM -0800, Alexander Duyck wrote:
> > One other question I had. How do you handle the event that
> > enetc_start_xmit returns NETDEV_TX_BUSY or causes the packet to go
> > down the drop_packet_err path?
>
> We don't. If the enetc_start_xmit() asks the qdisc to requeue the skb
> via NETDEV_TX_BUSY, we aren't going to do that, because we aren't the
> qdisc, or if the packet just gets dropped without being mapped into the
> TX ring, ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS will remain set with no
> possibility of ever becoming unset ever again.

That is a separate issue then right? Just wanted to confirm I wasn't
missing something. I am assuming that leaving it set forever would be
a bad thing.

If NETDEV_TX_BUSY is triggered it is a memory leak if it is hit from
the enetc_tx_onestep_tstamp function correct?

Also what mechanism do you have in place to clean out the tx_skb queue
and clear the flag if the ring is stopped due to something such as
enetc_close being called? It seems like this is missing some logic to
handle the event that somebody were to do a ip link set <iface>
down/up as the stale packets would be left in the ring unless I am
missing something else.
