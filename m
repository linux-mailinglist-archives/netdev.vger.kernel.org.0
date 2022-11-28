Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B6863B0BE
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbiK1SJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbiK1SIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:08:53 -0500
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739E02B248;
        Mon, 28 Nov 2022 09:52:41 -0800 (PST)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 6FEC130B2958;
        Mon, 28 Nov 2022 18:52:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=RSV1N
        jCeUvW8maK2FjLAmRmGIs7ggAy5Dtyq2eTt6xY=; b=rcZLJWRsqfGgqJoU5azNi
        OHmLK7OH38mfOxeFYO3aBjj7M+v/KJw/YMSRXoGvLZTMNz2BdiryMWOnm1JxGwGK
        +NzZU6truRUrEdT8VECLRfEtS9QaPxlTWrcnlmJWQVMsguA7v7k4R8xg2syxnxzk
        N0Ig1I4W+RLzFLCXagFfb6gU2JZoH7emQI7BZKiLtogOEtiTRy46iOZWOLdMkGeX
        HIMefNCtQjpvQgRKdia0NY6Z3zpD84tCp5TtfytLWgkE36kK0Cd9LN3NNT3jaDS8
        LpfnDehix8doi7i1QkTg2obyvKZDbeP9BU9N89ioNf1X9xdcuQgA9OFaBLoSQFHC
        Q==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 1216930ADE53;
        Mon, 28 Nov 2022 18:52:38 +0100 (CET)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 2ASHqbJD003854;
        Mon, 28 Nov 2022 18:52:37 +0100
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 2ASHqaS0003853;
        Mon, 28 Nov 2022 18:52:36 +0100
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Ryan Edwards <ryan.edwards@gmail.com>
Subject: Re: [RFC][PATCH 0/2] LIN support for Linux
Date:   Mon, 28 Nov 2022 18:52:30 +0100
User-Agent: KMail/1.9.10
Cc:     Christoph Fritz <christoph.fritz@hexdev.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Richard Weinberger <richard@nod.at>,
        Andreas Lauser <andreas.lauser@mbition.io>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221127190244.888414-1-christoph.fritz@hexdev.de> <202211281549.47092.pisa@cmp.felk.cvut.cz> <CAEVdEgBWVgVFF2utm4w5W0_trYYJQVeKrcGN+T0yJ1Qa615bcQ@mail.gmail.com>
In-Reply-To: <CAEVdEgBWVgVFF2utm4w5W0_trYYJQVeKrcGN+T0yJ1Qa615bcQ@mail.gmail.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202211281852.30067.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ryan, 

On Monday 28 of November 2022 18:02:04 Ryan Edwards wrote:
> On Mon, Nov 28, 2022 at 10:09 AM Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
...
> > > I already did some tests letting hexLIN and PCAN talk to each other in
> > > a real time manner. Please see my preliminary PDF docu at
> > > https://hexdev.de/hexlin/
>
> Marc gave me a heads on on this discussion and I have some insight.
>
> I've spent quite a bit of time trying to craft a solution for the LIN
> problem.  Even with a TTY solution the best I was able to achieve was
> 40ms turnaround between the header and response which exceeded the
> timeout of the master. 

This is indication of some serious problem. We have been able to
achieve right timing even from userspace on PC 10 years ago
when RT task priorities are used and mlock all even on standard kernel...
Yes under load that could be a problem but on RT kernel and in kernel
slLIN driver it was reliable even on relatively slow MPC5200.

See FIGURE 3: Master: MPC5200 with slLIN; Slave: MPC5200 with slLIN
of our comprehensive RTLWS 20212 UART-based LIN-bus Support for Linux
with SocketCAN Interface article. For the complete protocol designed
on basis of Oliver's proposal and then our finalization see complete
report for VolkWagen. The timing is shown there as well
Figure 5.2: Master: MPC5200 with sllin; Slave: MPC5200 with sllin

https://github.com/lin-bus/linux-lin/wiki

The problem with typical UARTs is then when they have enabled FIFO
then drivers select trigger level higher than one and sometimes
even minimal level is 1/4 of Rx FIFO depth. Then when trigger
level is not reached the Rx interrupt waits for eventual
more characters to come for (typically) 3 character times.
So this is a problem. Because of 1/4 FIFO minimal threshold
for 16C450+ UARTs, it is only solution to achieve right slave/response
function to switch off the FIFO, there some internal API for that
but not exposed o drivers. For 16V450, there is option

  echo 1 >/sys/class/tty/ttyS0/rx_trig_bytes

See https://github.com/lin-bus/linux-lin/issues/13

> This was in userspace and I assume that a 
> kernel solution would better be able to meet the timing but this
> solution would only work for devices with embedded UART.

Yes, and on fully preemptive it is not problem. We run control
loops in userpace at 5 kHz on Xilinx Zynq systems and used
up to 30 kHz on PC for mainboard without MSI issues.
So this seems that problems are in programing area.

We have achieved correct slLIN functionality on more embedded systems,
AM335x, MPC5200 etc. But it required to check UART driver
and found how to set Rx trigger level to 1 or disable FIFO.
Often by nasty parch. But most hardware could provide
knob to tune required parameters. Some RFC for the proposed API
there

   https://marc.info/?l=linux-serial&m=164259988122122&w=2

int (*rx_trigger)(struct uart_port *, int mode, int *rx_trigger_bytes,
                  int *rx_trigger_iddle_time)

I think that all/the most of the UART HW I have seen can
adjust what necessary, in the worst case by switching FIFO
off in UART_RX_TRIGGER_MODE_CHECK_ROUND_DOWN mode.

> I did create a solution that uses the gs_usb driver using "pseduo" CAN
> frames that currently supports slave and monitor mode.  I had no use
> cases for master mode up to this point so it has not yet been
> implemented.  The framework is there if it needs to be added.

The set of frames has been defined in slLIN 10 years ago and
there is even defined control for LIN 1.0 and 2.0 check sum
selection for individual IDs. I do not insist that our design
is the best mapping but try to compare it to yours and describe
advantages that the best decision can be made for futire.

> The README contains the HOWTO on usage of the driver.  Right now it's
> a hack but could be better designed using message flags or a seperate
> CAN channel.
>
> In my design the device contains a slave response table which is
> configured via CAN frames via socketcan.  Currently up to 10 master
> frames can be responded to. 

I think that even on embedded HW it is not problem to keep
data for all 64 LIN IDs. So I would not complicate thing with some mapping
etc. We have reused already present BCM (SocketCAN Broadcast Manager)
to periodically send LIN headers.

> It also allows the LIN node to be put 
> into monitor mode and gate those messages to the host via a CAN
> message.
>
> https://github.com/ryedwards/budgetcan_fw

Great, version connected over USB with local response table
is more reliable with timing than software solution on big(err)
complex system like Linux kernel is. So if the well defined
open protocol is designed or some CAN USB devices one is reused
for LIN than it is advantage.

I would be happy if the project moves forward. The critical is
some settlement on unified API. Please, compare and map functionality
between our solution and your proposal and we can discuss what
worth to keep or change. slLIN solution seems to be used in more
project not only that two for Volkswagen and Digiteq Automotive,
I have directly participated.

Best wishes,

                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    RISC-V education: https://comparch.edu.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

