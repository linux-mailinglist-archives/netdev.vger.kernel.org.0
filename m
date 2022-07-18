Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00421577FA9
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiGRKap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbiGRKao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:30:44 -0400
X-Greylist: delayed 629 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Jul 2022 03:30:43 PDT
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1511C93E
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 03:30:43 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 7D47230B294D;
        Mon, 18 Jul 2022 12:20:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=8G2Wg
        NH3o1qs58CmHGVus2NDDqZZPoXKTvvlVcc9B34=; b=eUqGtdyUSn2/2BoEKd+5J
        fhaQwkXGjAZ0yOw+e2ejH8qjo6OfrpdRRfXie5E7gdZqmI6Nb2lsLPuL5foJrQRS
        kkf+2syNojymXh0LMtDjG8xJg/d8lJNEV1wwn6q7o/5CwYLdcgFVwSLXc+F2bZg8
        OOjq3fcMgiwNDdTlMo2K3Pfwt1xmtYqchAD1cLSwMeE5tOdc17WIC2wqmL/Zj5vL
        GLToGhqrBdMDOa55YxCkazwGaCuKwvl+eRHrHpW5b4kWid/QeTuEno0fqEcUgdBB
        K1iZ34vN8kHdU4Ivzdql6qQq9FRXl0V7RKbgDo0HZxzHIm2Usi9QZTdzLdcyqlEd
        g==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 8D49D30AE002;
        Mon, 18 Jul 2022 12:20:12 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 26IAKCaG029044;
        Mon, 18 Jul 2022 12:20:12 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 26IAKCvg029043;
        Mon, 18 Jul 2022 12:20:12 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: Re: [PATCH] can: xilinx_can: add support for RX timestamps on Zynq
Date:   Mon, 18 Jul 2022 12:20:06 +0200
User-Agent: KMail/1.9.10
Cc:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Martin Jerabek <martin.jerabek01@gmail.com>,
        Vikram Garhwal <fnu.vikram@xilinx.com>
References: <20220716120408.450405-1-matej.vasilevski@seznam.cz> <20220718083312.4izyuf7iawfbhlnf@pengutronix.de>
In-Reply-To: <20220718083312.4izyuf7iawfbhlnf@pengutronix.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202207181220.06765.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

On Monday 18 of July 2022 10:33:12 Marc Kleine-Budde wrote:
> On 16.07.2022 14:04:09, Matej Vasilevski wrote:
> > This patch adds support for hardware RX timestamps from Xilinx Zynq CAN
> > controllers. The timestamp is calculated against a timepoint reference
> > stored when the first CAN message is received.
> >
> > When CAN bus traffic does not contain long idle pauses (so that
> > the clocks would drift by a multiple of the counter rollover time),
> > then the hardware timestamps provide precise relative time between
> > received messages. This can be used e.g. for latency testing.
>
> Please make use of the existing cyclecounter/timecounter framework. Is
> there a way to read the current time from a register? If so, please
> setup a worker that does that regularly.
>
> Have a look at the mcp251xfd driver as an example:

Matej Vasilevski has looked at the example. But there is problem
that we know no method how to read actual counter value at least for
Xilinx Zynq 7000. May be we overlooked something or there
is hidden test register.

So actual support is the best approach we have found so far.
It is usable and valuable for precise relative time measurement
when bus is not idle for longer time. With expected clock
precision there should be no skip when at least one message
for each second or more is received.

The precision degrades to software software timer with
one half of timestamp counter period jitter for really
long gaps between messages. 

I understand that you do not like the situation,
if you think that it is not acceptable for mainline
even with config option under experimental then
never mind. We want to document this work on Linux
CAN mailing list. It worked for us in far past
when we used XCAN for CAN latency testing.

We have CTU CAN FD now which has in the default config
64 bits timestamps. It is readable and synchronized
(single counter) over all channels in our can latency
tester design for Zynq. 100 MHz timestamps base is
shared even over all CTU CAN FD cores when they
are integrated to PCIe card.

It could be intersting if XCAN or followups
on later Xilinx systems has additional registers
to read time base.

But I pose no UltraScale or later board at the
moment. I have organized the purchase of more
ones in 2016, but they stay in group which
break cooperation on the projects long time ago.

Best wishes,

                Pavel
-- 
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

