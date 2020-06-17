Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231C51FD333
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgFQRLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:11:53 -0400
Received: from relay-b02.edpnet.be ([212.71.1.222]:50196 "EHLO
        relay-b02.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgFQRLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:11:52 -0400
X-ASG-Debug-ID: 1592413155-0a7b8d5f421573b30001-BZBGGp
Received: from zotac.vandijck-laurijssen.be ([213.219.130.186]) by relay-b02.edpnet.be with ESMTP id 6FAs6WMCRd9eJOIK; Wed, 17 Jun 2020 18:59:15 +0200 (CEST)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: UNKNOWN[213.219.130.186]
X-Barracuda-Apparent-Source-IP: 213.219.130.186
Received: from x1.vandijck-laurijssen.be (x1.vandijck-laurijssen.be [IPv6:fd01::1a1d:eaff:fe02:d339])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id 9D7CFF5FA5D;
        Wed, 17 Jun 2020 18:59:08 +0200 (CEST)
Date:   Wed, 17 Jun 2020 18:59:02 +0200
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        wg@grandegger.com, kernel@martin.sperl.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Add Microchip MCP25XXFD CAN driver
Message-ID: <20200617165902.GB14228@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: [PATCH 0/6] Add Microchip MCP25XXFD CAN driver
Mail-Followup-To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        wg@grandegger.com, kernel@martin.sperl.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200610074442.10808-1-manivannan.sadhasivam@linaro.org>
 <fbbca009-3c53-6aa9-94ed-7e9e337c31a4@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fbbca009-3c53-6aa9-94ed-7e9e337c31a4@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: UNKNOWN[213.219.130.186]
X-Barracuda-Start-Time: 1592413155
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 2219
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.5260 1.0000 0.7500
X-Barracuda-Spam-Score: 0.75
X-Barracuda-Spam-Status: No, SCORE=0.75 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.82618
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On do, 11 jun 2020 18:26:19 +0200, Marc Kleine-Budde wrote:
> On 6/10/20 9:44 AM, Manivannan Sadhasivam wrote:
> > Hello,
> > 
> > This series adds CAN network driver support for Microchip MCP25XXFD CAN
> > Controller with MCP2517FD as the target controller version. This series is
> > mostly inspired (or taken) from the previous iterations posted by Martin Sperl.
> > I've trimmed down the parts which are not necessary for the initial version
> > to ease review. Still the series is relatively huge but I hope to get some
> > reviews (post -rcX ofc!).
> > 
> > Link to the origial series posted by Martin:
> > https://www.spinics.net/lists/devicetree/msg284462.html
> > 
> > I've not changed the functionality much but done some considerable amount of
> > cleanups and also preserved the authorship of Martin for all the patches he has
> > posted earlier. This series has been tested on 96Boards RB3 platform by myself
> > and Martin has tested the previous version on Rpi3 with external MCP2517FD
> > controller.
> 
> I initially started looking at Martin's driver and it was not using several
> modern CAN driver infrastructures. I then posted some cleanup patches but Martin
> was not working on the driver any more. Then I decided to rewrite the driver,
> that is the one I'm hoping to mainline soon.
> 
> Can you give it a try?
> 
> https://github.com/marckleinebudde/linux/commits/v5.6-rpi/mcp25xxfd-20200607-41

Hi Marc,

I'm in the process of getting a Variscite imx8m mini SOM online, with
MCP2517FD. The 4.19 kernel that comes with it, has a driver that is
clearly inspired by the one of Martin Sperl (not investigated too much
yet). I have problems of probing the chip when the bus is under full
load (under not full load, the probing only occasionally fails) due to
the modeswitch test.

Is there a real difference in yours between the rpi and sunxi branches?
Is there much evolution since -36 or would you mind to backport your
latest -42 to 4.19?

I will work on this the upcoming days. I can't do extensive tests, but
rather a works-for-me test that includes bitrate probe.
I only have 1 such board right now, and no other FD hardware.

Kurt
> 
> Marc
