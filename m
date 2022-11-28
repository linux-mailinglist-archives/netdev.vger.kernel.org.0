Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CBB63B199
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbiK1SsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiK1Sr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:47:59 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4B711179;
        Mon, 28 Nov 2022 10:47:58 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id ho10so28219470ejc.1;
        Mon, 28 Nov 2022 10:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SFZ8YOO/uIBYO8TLUtu4aCzGnQUOMfflMlsmwWHSXZg=;
        b=FUvBEHtfQi+6gzH8dSZCCe8YRtcmwDDc+FSvcOfkOBgIzGWp1gfRKFgXqM8Kk5DSJr
         oWFKYH4Ze27tUv3dNb6K3X6F7bYte9QUutWovBnvXY/ulneCQgdYXWXrjBCuOlZU4qqz
         IDUlr7FmeQZgJu+UE81axsaV6ffbSQQRMrH22EO4NRYuLDwabwYWNTxF/8eLyMDpwFxM
         9I/nm2e1Ob+yoyJRSjAYpuxF0zBI85fuXTILqzOeLrfYUSztpa81l6/ZTKMRAC0Uu0No
         aR8FjaKVuI8vf/zrpjx6NUe9iiqwS0MRZ9CKGJuFehlJvkHqM45uZzsqJrF+Oqb+iz4+
         /k+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SFZ8YOO/uIBYO8TLUtu4aCzGnQUOMfflMlsmwWHSXZg=;
        b=NCTpsptbPivr0fu+EaSMXx61QRRoDfWcW44T+yqQ09kiOJGnzxGWf4IJm5oMB/jdxH
         Z0KjSQfdzCgkFylb07eNCCTg7+jRdCMrRtzk6GWv02UZ7xj2BmCN/menXb/4fDsmT1KW
         eWSL5iYjOc76a0NMi+ZE9d/jkvm1VbvC+x5cCSXQq0BHwJ7I0R2fV2jjsA/2VF8/MXds
         Zah4RdjC97qLQpxpzSuTzAVS7CKsonyeX96rZvilJ8pfsyrjI0oAf1Uh/XMFkLaXMoWI
         dQiddpYHViMt4aRX+/AZrf8nrbZ5WrxdCUbnLfdHpizCAwwZ3QweZkKDw8gfiD7UQm9m
         TV/w==
X-Gm-Message-State: ANoB5pls7c54/kwdJeCsMiuE5Rn9Ytx2s17nm5ClzX0kzjdWt103lJAW
        a1t8E+1DAkEYlyNZiJjJ3BEgxSy9k9sLPoqH8cJYBnOapDk=
X-Google-Smtp-Source: AA0mqf6SXIDsl+LM5XloVbmgdLPOwHCFBrWHCOg/Se1pwmJIbeUO0FutJC0213+SXdNRfjubTeNx48zaK5bAiULq9qA=
X-Received: by 2002:a17:906:f896:b0:7bb:cdd8:94e7 with SMTP id
 lg22-20020a170906f89600b007bbcdd894e7mr17449701ejb.369.1669661276179; Mon, 28
 Nov 2022 10:47:56 -0800 (PST)
MIME-Version: 1.0
References: <20221127190244.888414-1-christoph.fritz@hexdev.de>
 <202211281549.47092.pisa@cmp.felk.cvut.cz> <CAEVdEgBWVgVFF2utm4w5W0_trYYJQVeKrcGN+T0yJ1Qa615bcQ@mail.gmail.com>
 <202211281852.30067.pisa@cmp.felk.cvut.cz>
In-Reply-To: <202211281852.30067.pisa@cmp.felk.cvut.cz>
From:   Ryan Edwards <ryan.edwards@gmail.com>
Date:   Mon, 28 Nov 2022 13:47:45 -0500
Message-ID: <CAEVdEgBtikDjQ-cVOq-MkoS_0q_hGJRVSS=9L=htHhh7YvSUgA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/2] LIN support for Linux
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Christoph Fritz <christoph.fritz@hexdev.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Richard Weinberger <richard@nod.at>,
        Andreas Lauser <andreas.lauser@mbition.io>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

Hello Pavel,

On Mon, Nov 28, 2022 at 12:52 PM Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
>
> Hello Ryan,
>
> On Monday 28 of November 2022 18:02:04 Ryan Edwards wrote:
> > On Mon, Nov 28, 2022 at 10:09 AM Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
> > Marc gave me a heads on on this discussion and I have some insight.
> >
> > I've spent quite a bit of time trying to craft a solution for the LIN
> > problem.  Even with a TTY solution the best I was able to achieve was
> > 40ms turnaround between the header and response which exceeded the
> > timeout of the master.
>
> This is indication of some serious problem. We have been able to
> achieve right timing even from userspace on PC 10 years ago
> when RT task priorities are used and mlock all even on standard kernel...
> Yes under load that could be a problem but on RT kernel and in kernel
> slLIN driver it was reliable even on relatively slow MPC5200.
>
> See FIGURE 3: Master: MPC5200 with slLIN; Slave: MPC5200 with slLIN
> of our comprehensive RTLWS 20212 UART-based LIN-bus Support for Linux
> with SocketCAN Interface article. For the complete protocol designed
> on basis of Oliver's proposal and then our finalization see complete
> report for VolkWagen. The timing is shown there as well
> Figure 5.2: Master: MPC5200 with sllin; Slave: MPC5200 with sllin
>
> https://github.com/lin-bus/linux-lin/wiki
>
> The problem with typical UARTs is then when they have enabled FIFO
> then drivers select trigger level higher than one and sometimes
> even minimal level is 1/4 of Rx FIFO depth. Then when trigger
> level is not reached the Rx interrupt waits for eventual
> more characters to come for (typically) 3 character times.
> So this is a problem. Because of 1/4 FIFO minimal threshold
> for 16C450+ UARTs, it is only solution to achieve right slave/response
> function to switch off the FIFO, there some internal API for that
> but not exposed o drivers. For 16V450, there is option
>
>   echo 1 >/sys/class/tty/ttyS0/rx_trig_bytes
>
> See https://github.com/lin-bus/linux-lin/issues/13

This test was done 2-3 years ago on a RaspberryPi.  I was testing as a
slave and had a hard time responding to the master any faster than
40ms.  I assume based on the work that you've done that I must have
not been accessing the TTY correctly.  Wish I would have found the
work already done on linux-lin.  Would have saved me some time and
headaches.

> > The README contains the HOWTO on usage of the driver.  Right now it's
> > a hack but could be better designed using message flags or a seperate
> > CAN channel.
> >
> > In my design the device contains a slave response table which is
> > configured via CAN frames via socketcan.  Currently up to 10 master
> > frames can be responded to.
>
> I think that even on embedded HW it is not problem to keep
> data for all 64 LIN IDs. So I would not complicate thing with some mapping
> etc. We have reused already present BCM (SocketCAN Broadcast Manager)
> to periodically send LIN headers.
>
> > It also allows the LIN node to be put
> > into monitor mode and gate those messages to the host via a CAN
> > message.
> >
> > https://github.com/ryedwards/budgetcan_fw
>
> Great, version connected over USB with local response table
> is more reliable with timing than software solution on big(err)
> complex system like Linux kernel is. So if the well defined
> open protocol is designed or some CAN USB devices one is reused
> for LIN than it is advantage.
>
> I would be happy if the project moves forward. The critical is
> some settlement on unified API. Please, compare and map functionality
> between our solution and your proposal and we can discuss what
> worth to keep or change. slLIN solution seems to be used in more
> project not only that two for Volkswagen and Digiteq Automotive,
> I have directly participated.
>

I think that what I have built is a high level embedded solution.  The
fundamental code is the same as it was developed from the state
diagram in the LIN specification.

I understand now that this project is to build on and implement the
work already done on slLIN.  I'll review the slLIN driver and see if
there is any input I can provide based on the work I've done in my
code.  I'd be very interested if the driver could be implemented in a
way that easily allows for dynamic slave repsonses.

Thanks,

--Ryan
