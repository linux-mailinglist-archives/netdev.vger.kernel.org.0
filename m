Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15351557CBC
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiFWNQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiFWNQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:16:31 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB77B39BAE;
        Thu, 23 Jun 2022 06:16:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 3350D9C022D;
        Thu, 23 Jun 2022 09:16:29 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id SWXShlcTgTum; Thu, 23 Jun 2022 09:16:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 9F7769C024D;
        Thu, 23 Jun 2022 09:16:28 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 9F7769C024D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1655990188; bh=lqMiz49VFoiiAzMzALh28rmRxGLLRsDC1FYZkrRivw0=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=C4KqhinlFVQ5m7XVtibz4midEm8Wf1LsfZZXbz5hYnwd4dijzdt4P7Kt4R/b7EYSF
         njxcJgrdi87m0OZciCKhaoM4Bw23kw7VmCjSkjNiD1TpZEfnXiEAXGY736IccvuePF
         Trt70N2EVE6VJtXZqOpGgA0xBL/ARMVBEU21lwgPI80aU3L6oODVR0NHbGKCuDG+0E
         rkCTz4m1PKjiiFDgvkHpVtF1cczLR4eYlwSg8YiIwbcUREN2KkD1YODOTI3EUdDiho
         Ps0ufOCwWC9Bu6YomB20gnjFUKCQ2x3jfx3Ds/95ql4CIo6m7R+dYhu1SE1r3FB0Nq
         eYUbTeRe2CScQ==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NlG6Uq43pGof; Thu, 23 Jun 2022 09:16:28 -0400 (EDT)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 7C03A9C022D;
        Thu, 23 Jun 2022 09:16:28 -0400 (EDT)
Date:   Thu, 23 Jun 2022 09:16:28 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux <linux@armlinux.org.uk>, hkallweit1 <hkallweit1@gmail.com>
Message-ID: <1572348291.280163.1655990188458.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <YrRfzph6jyg2pUyO@lunn.ch>
References: <YqzAKguRaxr74oXh@lunn.ch> <20220623085125.1426049-1-enguerrand.de-ribaucourt@savoirfairelinux.com> <YrRfzph6jyg2pUyO@lunn.ch>
Subject: Re: [PATCH 1/2] net: dp83822: disable false carrier interrupt
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.15_GA_4272 (ZimbraWebClient - FF100 (Linux)/8.8.15_GA_4257)
Thread-Topic: dp83822: disable false carrier interrupt
Thread-Index: DLB6aCKOt/IFmvEdyadwXEEsBnR2Sg==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Original Message -----
> From: "Andrew Lunn" <andrew@lunn.ch>
> To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>
> Cc: "davem" <davem@davemloft.net>, "netdev" <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>,
> "linux" <linux@armlinux.org.uk>, "hkallweit1" <hkallweit1@gmail.com>
> Sent: Thursday, June 23, 2022 2:42:54 PM
> Subject: Re: [PATCH 1/2] net: dp83822: disable false carrier interrupt

> On Thu, Jun 23, 2022 at 10:51:25AM +0200, Enguerrand de Ribaucourt wrote:
> > When unplugging an Ethernet cable, false carrier events were produced by
> > the PHY at a very high rate. Once the false carrier counter full, an
> > interrupt was triggered every few clock cycles until the cable was
> > replugged. This resulted in approximately 10k/s interrupts.

> > Since the false carrier counter (FCSCR) is never used, we can safely
> > disable this interrupt.

> > In addition to improving performance, this also solved MDIO read
> > timeouts I was randomly encountering with an i.MX8 fec MAC because of
> > the interrupt flood. The interrupt count and MDIO timeout fix were
> > tested on a v5.4.110 kernel.

> Since this is version 2, you should add v2 into the subject line. See
> the submitting patches document in the kernel documentation.

> Also, with patch sets, please include a patch 0/X which describes the
> big picture.

> This is also a bug fix, you are stopping an interrupt storm. So please
> include a Fixes: tag indicating where the issue was introduced.

> The code itself looks good, it is just getting the processes right.

> Andrew

Sorry, I'm still not familiar with the process. I resubmitted the patches
with your recommendations.

Thank you very much for your advice.
Enguerrand
