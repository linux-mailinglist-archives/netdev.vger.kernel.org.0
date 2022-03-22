Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A964E3F5E
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 14:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbiCVNVD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Mar 2022 09:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiCVNVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 09:21:02 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF5C67D38;
        Tue, 22 Mar 2022 06:19:29 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 9495630AE012;
        Tue, 22 Mar 2022 14:19:27 +0100 (CET)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 0472330AE009;
        Tue, 22 Mar 2022 14:19:24 +0100 (CET)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 22MDJNFf027861;
        Tue, 22 Mar 2022 14:19:23 +0100
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 22MDJNRV027860;
        Tue, 22 Mar 2022 14:19:23 +0100
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: Re: [PATCH v8 0/7] CTU CAN FD open-source IP core SocketCAN driver, PCI, platform integration and documentation
Date:   Tue, 22 Mar 2022 14:19:23 +0100
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
References: <cover.1647904780.git.pisa@cmp.felk.cvut.cz> <202203220918.33033.pisa@cmp.felk.cvut.cz> <20220322092212.f5eaxm5k45j5khra@pengutronix.de>
In-Reply-To: <20220322092212.f5eaxm5k45j5khra@pengutronix.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <202203221419.23089.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

On Tuesday 22 of March 2022 10:22:12 Marc Kleine-Budde wrote:
> > We have HW timestamping implemented for actual stable CTU CAN FD IP core
> > version, support for variable number of TX buffers which count can be
> > parameterized up to 8 in the prepared version and long term desire to
> > configurable-SW defined multi-queue which our HW interface allows to
> > dynamically server by á TX buffers. But plan is to keep combinations
> > of the design and driver compatible from the actual revision.
>
> Is the number of RX and TX buffers and TX queues auto detectable by
> software, or do we need DT bindings for this?

we plan to count info available through field in the registers.
See paragraph 3.1.39 TXTB_INFO

http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/doc/Datasheet.pdf

The bits are read as zeros on the older version so if the zero
is found older default 4 will be chosen by the driver.
So I prefer no side information channel DTC etc.
Even on the actual PCI integration you can read number
of channels from the support PCI BAR range and locate
actual cores on the other BAR.

> The net-next merge window closed with Monday evening, so this driver
> will go into net-next for v5.19.

My shame. I hoped to get driver into mainline till Embedded World
Conference 2022 where we participate with our RISC-V education tools
and materials so that I could report to others in the RISC-V camp
and even CiA that we are finally easily to use.

On the other hand more time gives time for better review and possible
cleanup. But I would wait with features addition till some base
accepted to the next or mainline. I hope that interfaces will not
change too much before inclusion that actual tested code can
get in.

> > > BTW: The PROP_SEG/PHASE_SEG1 issue is known:
> > > > +A curious reader will notice that the durations of the segments
> > > > PROP_SEG +and PHASE_SEG1 are not determined separately but rather
> > > > combined and +then, by default, the resulting TSEG1 is evenly divided
> > > > between PROP_SEG +and PHASE_SEG1.
> > >
> > > and the flexcan IP core in CAN-FD mode has the same problem. When
> > > working on the bit timing parameter, I'll plan to have separate
> > > PROP_SEG/PHASE_SEG1 min/max in the kernel, so that the bit timing
> > > algorithm can take care of this.
> >
> > Hmm, when I have thought about that years ago I have not noticed real
> > difference when time quanta is move between PROP_SEG and PHASE_SEG1.
> > So for me it had no influence on the algorithm computation and
> > could be done on the chip level when minimal and maximal sum is
> > respected. But may it be I have overlooked something and there is
> > difference for CAN FD.  May it be my colleagues Jiri Novak and
> > Ondrej Ille are more knowable.
>
> Jiri, Ondrej, I'm interested in details :)
>
> > As for the optimal timequantas per bit value, I agree that it
> > is not so simple. In the fact SJW and even tipple-sampling
> > should be defined in percentage of bit time
>
> I thought of specifying SJW in a relative value, too.
>
> > and then all should be optimized together
>
> SJW has no influence on the bit rate and sample point. Although SJW is
> max phase seg 2, so it's maximum is influenced by the sample point.
>
> > and even combination with slight bitrate error should be preferred
> > against other exact matching when there is significant difference in
> > the other parameters values.
>
> Since linux-4.8, i.e.
>
> | 7da29f97d6c8 can: dev: can-calc-bit-timing(): better sample point
> | calculation
>
> the algorithm optimizes for best bit minimal absolute bit rate error
> first and then for minimal sample point error. The sample point must be
> <= the nominal sample point. I have some experiments where the algorithm
> optimizes the absolute sample point error.

Yes but you do not need exact bitrate even when it is available.
I do no look into standards now, but I think 1% error should not be
a problem. May it be even 3% error when whole jitter and clocks
frequency errors fit below it should work (5 (bit stuff) x 3% = 15%
is less than 100% - 80% (typical SP) and with well tuned SF even 25
or 50% of the last bit could be accepted that communication can
at leas sometimes succeed). So allow error of 0.1% as better than
too low or too high TQ per bit or strange SJW can be acceptable.
On the other hand if CAN is used with time triggered stuff or keep/
synchronize whole plant global time then 0.1% is too much.
So at the end in this case really tuning for concrete application
comes into play. But in kernel algorithm is there to make most
common usages easy...

> For more complicated bit timing optimization you need to combine the
> bitrate error and the sample point error into a function that needs to
> be minimized.

Yes.

> > By the way we have received report from Andrew Dennison about
> > successful integration of CTU CAN FD into Litex based RISC-V
> > system. Tested with the Linux our Linux kernel driver.
>
> That sounds interesting!

I hope that community joint forces can reach state where
CAN FD will be solved on all FPGA and combinations easily
and open source way. We need to find way for funding
of certification and long term sustainability.
But at least our previous release and actual public
code is game level save point.

Best wishes,

                Pavel
--
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

