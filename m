Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DFF295E73
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 14:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898260AbgJVMgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 08:36:05 -0400
Received: from relay-b02.edpnet.be ([212.71.1.222]:52703 "EHLO
        relay-b02.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503967AbgJVMgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 08:36:05 -0400
X-Greylist: delayed 662 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Oct 2020 08:36:04 EDT
X-ASG-Debug-ID: 1603369500-0a7b8d0d7c36c4c0001-BZBGGp
Received: from zotac.vandijck-laurijssen.be (94.105.104.9.dyn.edpnet.net [94.105.104.9]) by relay-b02.edpnet.be with ESMTP id CkAr1VGAGZZ7h2KM; Thu, 22 Oct 2020 14:25:00 +0200 (CEST)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: 94.105.104.9.dyn.edpnet.net[94.105.104.9]
X-Barracuda-Apparent-Source-IP: 94.105.104.9
Received: from x1.vandijck-laurijssen.be (x1.vandijck-laurijssen.be [IPv6:fd01::1a1d:eaff:fe02:d339])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id 7DB4D10E746F;
        Thu, 22 Oct 2020 14:25:00 +0200 (CEST)
Date:   Thu, 22 Oct 2020 14:24:53 +0200
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     yegorslists@googlemail.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] can: j1939: convert PGN structure to a table
Message-ID: <20201022122453.GA31522@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: [PATCH] can: j1939: convert PGN structure to a table
Mail-Followup-To: Marc Kleine-Budde <mkl@pengutronix.de>,
        yegorslists@googlemail.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201022102946.18916-1-yegorslists@googlemail.com>
 <32bad1a4-4daf-8ebe-e469-175e0339b292@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <32bad1a4-4daf-8ebe-e469-175e0339b292@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: 94.105.104.9.dyn.edpnet.net[94.105.104.9]
X-Barracuda-Start-Time: 1603369500
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 2435
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: SPAM GLOBAL 0.9974 1.0000 4.3124
X-Barracuda-Spam-Score: 4.31
X-Barracuda-Spam-Status: No, SCORE=4.31 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.85450
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 12:33:45 +0200, Marc Kleine-Budde wrote:
> On 10/22/20 12:29 PM, yegorslists@googlemail.com wrote:
> > From: Yegor Yefremov <yegorslists@googlemail.com>
> > 
> > Use table markup to show the PGN structure.
> > 
> > Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
> > ---
> >  Documentation/networking/j1939.rst | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
> > index faf2eb5c5052..f3fb9d880910 100644
> > --- a/Documentation/networking/j1939.rst
> > +++ b/Documentation/networking/j1939.rst
> > @@ -71,10 +71,14 @@ PGN
> >  
> >  The PGN (Parameter Group Number) is a number to identify a packet. The PGN
> >  is composed as follows:
> > -1 bit  : Reserved Bit
> > -1 bit  : Data Page
> > -8 bits : PF (PDU Format)
> > -8 bits : PS (PDU Specific)
> > +
> > +  ============  ==============  ===============  =================
> > +  PGN
> > +  ----------------------------------------------------------------
> > +  25            24              23 ... 16        15 ... 8
> 
> ICan you add a row description that indicated that these numbers are. They are
> probably bit positions within the CAN-ID?

This is true for up to 99.9%, depending on who you ask.
this maps indeed to the bit positions in the CAN-ID, as in J1939-21.
The trouble is that PGN's are also communicated as such in the payload,
e.g. in the TP and ETP (see J1939-81 if i remember correctly).
Since only PGN is written there, without SA, the bit position relative
to the CAN-ID are ... making things look fuzzy.

So I the best I can propose is to add a 2nd row :-)

> 
> > +  ============  ==============  ===============  =================
> > +  R (Reserved)  DP (Data Page)  PF (PDU Format)  PS (PDU Specific)
> > +  ============  ==============  ===============  =================
> >  
> >  In J1939-21 distinction is made between PDU1 format (where PF < 240) and PDU2
> >  format (where PF >= 240). Furthermore, when using the PDU2 format, the PS-field
> > 
> 
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
> 



