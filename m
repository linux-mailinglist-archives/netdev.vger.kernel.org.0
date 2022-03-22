Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99B34E3A63
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiCVIUH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Mar 2022 04:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiCVIUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:20:06 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028F15A5A3;
        Tue, 22 Mar 2022 01:18:36 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 3027330AE012;
        Tue, 22 Mar 2022 09:18:35 +0100 (CET)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 41F7530AE000;
        Tue, 22 Mar 2022 09:18:34 +0100 (CET)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 22M8IYRq010948;
        Tue, 22 Mar 2022 09:18:34 +0100
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 22M8IXBX010947;
        Tue, 22 Mar 2022 09:18:33 +0100
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: Re: [PATCH v8 0/7] CTU CAN FD open-source IP core SocketCAN driver, PCI, platform integration and documentation
Date:   Tue, 22 Mar 2022 09:18:32 +0100
User-Agent: KMail/1.9.10
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Drew Fustini <pdp7pdp7@gmail.com>
References: <cover.1647904780.git.pisa@cmp.felk.cvut.cz> <20220322074622.5gkjhs25epurecvx@pengutronix.de>
In-Reply-To: <20220322074622.5gkjhs25epurecvx@pengutronix.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <202203220918.33033.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

thanks for positive reply for our years effort.

On Tuesday 22 of March 2022 08:46:22 Marc Kleine-Budde wrote:
> On 22.03.2022 00:32:27, Pavel Pisa wrote:
> > This driver adds support for the CTU CAN FD open-source IP core.
>
> The driver looks much better now. Good work. Please have a look at the
> TX path of the mcp251xfd driver, especially the tx_stop_queue and
> tx_wake_queue in mcp251xfd_start_xmit() and mcp251xfd_handle_tefif(). A
> lockless implementation should work in your hardware, too.

Is this blocker for now? I would like to start with years tested base.

We have HW timestamping implemented for actual stable CTU CAN FD IP core 
version, support for variable number of TX buffers which count can be 
parameterized up to 8 in the prepared version and long term desire to 
configurable-SW defined multi-queue which our HW interface allows to 
dynamically server by á TX buffers. But plan is to keep combinations
of the design and driver compatible from the actual revision.

I would be happy if we can agree on some base/minimal support and get
it into mainline and use it as base for the followup patch series.

I understand that I have sent code late for actual merge window,
but I am really loaded by teaching, related RISC-V simulator
https://github.com/cvut/qtrvsim , ESA and robotic projects
at company. So I would prefer to go step by step and cooperate
on updates and testing with my diploma students.

> BTW: The PROP_SEG/PHASE_SEG1 issue is known:
> > +A curious reader will notice that the durations of the segments PROP_SEG
> > +and PHASE_SEG1 are not determined separately but rather combined and
> > +then, by default, the resulting TSEG1 is evenly divided between PROP_SEG
> > +and PHASE_SEG1.
>
> and the flexcan IP core in CAN-FD mode has the same problem. When
> working on the bit timing parameter, I'll plan to have separate
> PROP_SEG/PHASE_SEG1 min/max in the kernel, so that the bit timing
> algorithm can take care of this.

Hmm, when I have thought about that years ago I have not noticed real
difference when time quanta is move between PROP_SEG and PHASE_SEG1.
So for me it had no influence on the algorithm computation and
could be done on the chip level when minimal and maximal sum is
respected. But may it be I have overlooked something and there is
difference for CAN FD.  May it be my colleagues Jiri Novak and 
Ondrej Ille are more knowable.

As for the optimal timequantas per bit value, I agree that it
is not so simple. In the fact SJW and even tipple-sampling
should be defined in percentage of bit time and then all should
be optimized together and even combination with slight bitrate
error should be preferred against other exact matching when
there is significant difference in the other parameters values.

But I am not ready to dive into it till our ESA space NanoXplore
FPGA project passes final stage... 

By the way we have received report from Andrew Dennison about
successful integration of CTU CAN FD into Litex based RISC-V
system. Tested with the Linux our Linux kernel driver.

The first iteration there, but he reported that some corrections
from his actual development needs to be added to the public
repo still to be usable out of the box

  https://github.com/AndrewD/litecan

Best wishes,

                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://dce.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

