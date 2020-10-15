Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5821928EB39
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 04:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbgJOCcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 22:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgJOCcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 22:32:14 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81652C061755;
        Wed, 14 Oct 2020 19:32:14 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id a23so1186501qkg.13;
        Wed, 14 Oct 2020 19:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CIr+KzzkGzxVzUKpACDGhDNN7lFkJAx5/cWwJGHb2V0=;
        b=BINzPpqRkAE9sw37b5ly+SWHWjeebbr9Syrlvx7cZz6OluSviavis0kwpdZeRAZEte
         0gle+dtW+7ZulTpXIQWZW+4BqoUijrvRoMjsXM/sOEd/wPfxQwjvCza/T3YwZQAqo6KP
         3VoGPt95/VyALRh/odJXQRXyz7fq2JaAsDTlE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CIr+KzzkGzxVzUKpACDGhDNN7lFkJAx5/cWwJGHb2V0=;
        b=r9ZI50ZunRZtBVXeKVHN79Dz21qIeXtrTXmHdqJurQan+GLGoYrml4XCjl+znd5JM2
         326hNG6wGtcEBMX0A3vfC7QpHVnAYucs8YsA01tZXAy5/Wydj3EshOMEqNs3gcxHAR6+
         dSoN2YNtwb37yGQJnvJlhKbLWyNiltVhHsxusOx7GP12jimNt2YWuEkNVDE/NfmNIa0b
         XpZv7+ZoxevDGDfbsQFzDc9eUaa81rmRldavj9ZcxsPn7BtzN+ogOJvMEnGEp6GYK0PY
         h+t9hjTYmyh4J8HKcixFKCwc1avOe2xy9uUA+FKDeGmkIVIqKncN77UUATu5rcqi+mFo
         JttA==
X-Gm-Message-State: AOAM530BGI0pPw9axOgRj1AN2y4ap6sf2P6zbJXQhAUceoR+Qot9CRJ+
        cmn/5cYLvBr74a/WhYM0UyzkoLbTtDcoxG0e3nUiYSV89jPO0A==
X-Google-Smtp-Source: ABdhPJw2ZXQ6BTTznI/MCwya60LRb1O3iWIUSvksi/jv8O1ajQsODW8OpsUs5R1pMDhFcxGeMKPzKqr4aKg8nCJAYhM=
X-Received: by 2002:a37:46c4:: with SMTP id t187mr1977786qka.465.1602729133521;
 Wed, 14 Oct 2020 19:32:13 -0700 (PDT)
MIME-Version: 1.0
References: <20201014060632.16085-1-dylan_hung@aspeedtech.com>
 <20201014060632.16085-2-dylan_hung@aspeedtech.com> <CACPK8Xe_O44BUaPCEm2j3ZN+d4q6JbjEttLsiCLbWF6GnaqSPg@mail.gmail.com>
 <PS1PR0601MB1849DAC59EDA6A9DB62B4EE09C050@PS1PR0601MB1849.apcprd06.prod.outlook.com>
 <CACPK8Xd_DH+VeaPmXK2b5FXbrOpg_NmT_R4ENzY-=uNo=6HcyQ@mail.gmail.com> <PS1PR0601MB184990423661220EACDBF4BB9C020@PS1PR0601MB1849.apcprd06.prod.outlook.com>
In-Reply-To: <PS1PR0601MB184990423661220EACDBF4BB9C020@PS1PR0601MB1849.apcprd06.prod.outlook.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Thu, 15 Oct 2020 02:32:01 +0000
Message-ID: <CACPK8XePVhxtV5EXGH8ycHrG03M1JBp4920Hi9EQQfw5mCxJxg@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: ftgmac100: Fix Aspeed ast2600 TX hang issue
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 at 01:49, Dylan Hung <dylan_hung@aspeedtech.com> wrote:
> > > I was encountering this issue when I was running the iperf TX test.  The
> > symptom is the TX descriptors are consumed, but no complete packet is sent
> > out.
> >
> > What parameters are you using for iperf? I did a lot of testing with
> > iperf3 (and stress-ng running at the same time) and couldn't reproduce the
> > error.
> >
>
> I simply use "iperf -c <server ip>" on ast2600.  It is very easy to reproduce. I append the log below:
> Noticed that this issue only happens when HW scatter-gather (NETIF_F_SG) is on.

Ok. This appears to be on by default in the
drivers/net/ethernet/faraday/ftgmac100.c:

        netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
                NETIF_F_GRO | NETIF_F_SG | NETIF_F_HW_VLAN_CTAG_RX |
                NETIF_F_HW_VLAN_CTAG_TX;

> [AST /]$ iperf3 -c 192.168.100.89
> Connecting to host 192.168.100.89, port 5201
> [  4] local 192.168.100.45 port 45346 connected to 192.168.100.89 port 5201
> [ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
> [  4]   0.00-1.00   sec  44.8 MBytes   375 Mbits/sec    2   1.43 KBytes
> [  4]   1.00-2.00   sec  0.00 Bytes  0.00 bits/sec    2   1.43 KBytes
> [  4]   2.00-3.00   sec  0.00 Bytes  0.00 bits/sec    0   1.43 KBytes
> [  4]   3.00-4.00   sec  0.00 Bytes  0.00 bits/sec    1   1.43 KBytes
> [  4]   4.00-5.00   sec  0.00 Bytes  0.00 bits/sec    0   1.43 KBytes
> ^C[  4]   5.00-5.88   sec  0.00 Bytes  0.00 bits/sec    0   1.43 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-5.88   sec  44.8 MBytes  64.0 Mbits/sec    5             sender
> [  4]   0.00-5.88   sec  0.00 Bytes  0.00 bits/sec                  receiver
> iperf3: interrupt - the client has terminated

I just realised my test machine must be on a 100Mbit network. I will
try testing on a gigabit network.

> > We could only reproduce it when performing other functions, such as
> > debugging/booting the host processor.
> >
> Could it be another issue?

I hope not! We have deployed your patch on our systems and I will let
you know if we see the bug again.

> > > > > +/*
> > > > > + * test mode control register
> > > > > + */
> > > > > +#define FTGMAC100_TM_RQ_TX_VALID_DIS (1 << 28) #define
> > > > > +FTGMAC100_TM_RQ_RR_IDLE_PREV (1 << 27) #define
> > > > > +FTGMAC100_TM_DEFAULT
> > > > \
> > > > > +       (FTGMAC100_TM_RQ_TX_VALID_DIS |
> > > > FTGMAC100_TM_RQ_RR_IDLE_PREV)
> > > >
> > > > Will aspeed issue an updated datasheet with this register documented?
> >
> > Did you see this question?
> >
> Sorry, I missed this question.  Aspeed will update the datasheet accordingly.

Thank you.
