Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275652C2989
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388998AbgKXO0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:26:18 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:55414 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388969AbgKXO0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 09:26:17 -0500
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0AOEGZiR017030;
        Tue, 24 Nov 2020 15:24:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=STMicroelectronics;
 bh=/Lr2yKdeXEPI/ALwJxE9iloE/mG9CzbQupaWiqLE3wM=;
 b=G38+FG9jP/010Etf8q+4RN8sdlaTwcdjAdhjhmB9/fagRQTrGL4phffCwVXN7RkYUrEF
 AKkoUw57L0qtNJZIU3nJCYOMXt71Rw9WVgD2ZX4dpd/7uq5B5zmLqOIu7RRyFbcYJnCg
 R6QrqiX3rltVYf44Vys7ThcAQjaCYaR1BGzjwCexgHqc/xkKAWkxBtLaxXtQ0aUFlIti
 ZGpAY31DgioYTOVnkpxbR7VhdfA1TcjznugPG1Lm2C+aGYFaInoJkZQH0lMXuD9PxbVU
 VeyyRuP0jgnqvDtv3exNGj96b6CunQNT2nInKWBHy8x+NXFWgv6Db5xtiz+OLvtkg+us qg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 34y0fgsrnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 15:24:19 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id E17DD10002A;
        Tue, 24 Nov 2020 15:24:18 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag1node3.st.com [10.75.127.3])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 9045E2B8A38;
        Tue, 24 Nov 2020 15:24:18 +0100 (CET)
Received: from [10.129.7.42] (10.75.127.48) by SFHDAG1NODE3.st.com
 (10.75.127.3) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Nov
 2020 15:24:15 +0100
Message-ID: <e2b2b623700401538fe91e70495c348c08b5d2e3.camel@st.com>
Subject: Re: [PATCH] net: stmmac: add flexible PPS to dwmac 4.10a
From:   Antonio Borneo <antonio.borneo@st.com>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        has <has@pengutronix.de>
Date:   Tue, 24 Nov 2020 15:23:27 +0100
In-Reply-To: <42960ede-9355-1277-9a6f-4eac3c22365c@pengutronix.de>
References: <20191007154306.95827-1-antonio.borneo@st.com>
         <20191007154306.95827-5-antonio.borneo@st.com>
         <20191009152618.33b45c2d@cakuba.netronome.com>
         <42960ede-9355-1277-9a6f-4eac3c22365c@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG1NODE3.st.com
 (10.75.127.3)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-24 at 15:15 +0100, Ahmad Fatoum wrote:
> Hello Jakub,
> 
> On 10.10.19 00:26, Jakub Kicinski wrote:
> > On Mon, 7 Oct 2019 17:43:06 +0200, Antonio Borneo wrote:
> > > All the registers and the functionalities used in the callback
> > > dwmac5_flex_pps_config() are common between dwmac 4.10a [1] and
> > > 5.00a [2].
> > > 
> > > Reuse the same callback for dwmac 4.10a too.
> > > 
> > > Tested on STM32MP15x, based on dwmac 4.10a.
> > > 
> > > [1] DWC Ethernet QoS Databook 4.10a October 2014
> > > [2] DWC Ethernet QoS Databook 5.00a September 2017
> > > 
> > > Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
> > 
> > Applied to net-next.
> 
> This patch seems to have been fuzzily applied at the wrong location.
> The diff describes extension of dwmac 4.10a and so does the @@ line:
> 
>   @@ -864,6 +864,7 @@ const struct stmmac_ops dwmac410_ops = {
> 
> The patch was applied mainline as 757926247836 ("net: stmmac: add
> flexible PPS to dwmac 4.10a"), but it extends dwmac4_ops instead:
> 
>   @@ -938,6 +938,7 @@ const struct stmmac_ops dwmac4_ops = {
> 
> I don't know if dwmac4 actually supports FlexPPS, so I think it's
> better to be on the safe side and revert 757926247836 and add the
> change for the correct variant.

Agree,
the patch get applied to the wrong place!

Antonio

> 
> Cheers,
> Ahmad
> 
> 


