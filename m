Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3444D2ECE
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbiCIMOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiCIMOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:14:40 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A774EA09;
        Wed,  9 Mar 2022 04:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646828020; x=1678364020;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NxvyaH3e4/PtErqMJQl+2Rz010Co0lkGzj2KC5uXBsM=;
  b=DhZKW7tS74+F8THhsgLE2oL3MyoGFyzLwl14qPNyeEREKGMfujJcg1QC
   QD8eCqvv6nepxxcIBDlnZ9+pt8BJzNqgRKDgJnhDukTJazt/G4MiQh0CX
   bePB1OJjfHDmGxhaglUYheagwe9PAv0/2rZ/a5eynhdX2TCc7To+UTVnZ
   35dRmA64rpLkkufjEjJpOEbbo5EjG43FnAg0Pnh/GeqG22ATqRpgJYn41
   W9Diw9R+urP6RCLzdosh0xBRPJZZCNx9t7rousWdPeg2VaIspGMPJ2ygK
   /t74bu28bYGyQm12xiqdAOR2sH2mSyRHb3vK2lHRkWIKzNTHZCFd+Iel6
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,167,1643698800"; 
   d="scan'208";a="165084468"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Mar 2022 05:13:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 9 Mar 2022 05:13:40 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 9 Mar 2022 05:13:39 -0700
Date:   Wed, 9 Mar 2022 13:16:32 +0100
From:   'Horatiu Vultur' <horatiu.vultur@microchip.com>
To:     David Laight <David.Laight@aculab.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Message-ID: <20220309121632.d77v2x27kfaqiuzo@soft-dev3-1.localhost>
References: <20220308165727.4088656-1-horatiu.vultur@microchip.com>
 <YifMSUA/uZoPnpf1@lunn.ch>
 <20220308223000.vwdc6tk6wa53x64c@soft-dev3-1.localhost>
 <c85c188f9074456e92e9c4f8d8290ec2@AcuMS.aculab.com>
 <20220309091129.b5q3gtiuqlk5skka@soft-dev3-1.localhost>
 <45a9f88b140d44af8522e7d8a6abcbbf@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <45a9f88b140d44af8522e7d8a6abcbbf@AcuMS.aculab.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/09/2022 09:57, David Laight wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: 'Horatiu Vultur'
> > Sent: 09 March 2022 09:11
> >
> > The 03/08/2022 22:46, David Laight wrote:
> > >
> > > From: Horatiu Vultur
> > > > Sent: 08 March 2022 22:30
> > > >
> > > > The 03/08/2022 22:36, Andrew Lunn wrote:
> > > > >
> > > > > >  static int lan966x_port_inj_ready(struct lan966x *lan966x, u8 grp)
> > > > > >  {
> > > > > > -     u32 val;
> > > > > > +     unsigned long time = jiffies + usecs_to_jiffies(READL_TIMEOUT_US);
> > > > > > +     int ret = 0;
> > > > > >
> > > > > > -     return readx_poll_timeout_atomic(lan966x_port_inj_status, lan966x, val,
> > > > > > -                                      QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp),
> > > > > > -                                      READL_SLEEP_US, READL_TIMEOUT_US);
> > > > > > +     while (!(lan_rd(lan966x, QS_INJ_STATUS) &
> > > > > > +              QS_INJ_STATUS_FIFO_RDY_SET(BIT(grp)))) {
> > > > > > +             if (time_after(jiffies, time)) {
> > > > > > +                     ret = -ETIMEDOUT;
> > > > > > +                     break;
> > > > > > +             }
> > > > >
> > > > > Did you try setting READL_SLEEP_US to 0? readx_poll_timeout_atomic()
> > > > > explicitly supports that.
> > > >
> > > > I have tried but it didn't improve. It was the same as before.
> > >
> > > How many times round the loop is it going ?
> >
> > In the tests that I have done, I have never seen entering in the loop.
> 
> In which case I'd do an initial status check before even
> faffing with 'jiffies'.

That is a good idea. I will do this change in the next version.

> 
> It might even be that the status read is so slow that space
> is always available by the time it is processed.
> PCIe reads can be horribly slow.
> Into our fgpa they end up being slower than old ISA bus cycles.
> Probably several thousand cpu clocks.
> 
>         David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

-- 
/Horatiu
