Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8AA4D2B72
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiCIJJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiCIJJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:09:36 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E3014F29C;
        Wed,  9 Mar 2022 01:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646816918; x=1678352918;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w7iza/zSYzgNpQ1Yq4u/4l41Ldi1VH8IMiOYWwqOtRU=;
  b=pi75kxqi5e1OtL5/M6GAyQmMNdVNwLzB0n/+uVzFphzA7QGBwkT7Uxlu
   W/kOzGuK+sLDURauWqcfjHoCBUtVN0BbLdmGq2z8V7WBXnNiBF2rbda/0
   vC+eWX6rpgdIL2/QBfrYp4FDcS4qL+KAxjqkVpDD9r1a0gZDnyprCfIQZ
   c5SEyYr6I69y5+xjItza91X6XvmdV8Boyljf2vLyOsxFLab8Tj9scLdC1
   Jr0WABpbg6mm8H596oOfTnIES+1MIti9wOtm0B2U/wrCE8nLYd9VjRe9c
   kRuyb6XB4UkHnBHFwE4LBUouOzS4/1/nBw5yCqOAZ031tIQW0TaeExmKC
   A==;
X-IronPort-AV: E=Sophos;i="5.90,167,1643698800"; 
   d="scan'208";a="155781418"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Mar 2022 02:08:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 9 Mar 2022 02:08:37 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 9 Mar 2022 02:08:37 -0700
Date:   Wed, 9 Mar 2022 10:11:29 +0100
From:   'Horatiu Vultur' <horatiu.vultur@microchip.com>
To:     David Laight <David.Laight@aculab.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Message-ID: <20220309091129.b5q3gtiuqlk5skka@soft-dev3-1.localhost>
References: <20220308165727.4088656-1-horatiu.vultur@microchip.com>
 <YifMSUA/uZoPnpf1@lunn.ch>
 <20220308223000.vwdc6tk6wa53x64c@soft-dev3-1.localhost>
 <c85c188f9074456e92e9c4f8d8290ec2@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <c85c188f9074456e92e9c4f8d8290ec2@AcuMS.aculab.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/08/2022 22:46, David Laight wrote:
> 
> From: Horatiu Vultur
> > Sent: 08 March 2022 22:30
> >
> > The 03/08/2022 22:36, Andrew Lunn wrote:
> > >
> > > >  static int lan966x_port_inj_ready(struct lan966x *lan966x, u8 grp)
> > > >  {
> > > > -     u32 val;
> > > > +     unsigned long time = jiffies + usecs_to_jiffies(READL_TIMEOUT_US);
> > > > +     int ret = 0;
> > > >
> > > > -     return readx_poll_timeout_atomic(lan966x_port_inj_status, lan966x, val,
> > > > -                                      QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp),
> > > > -                                      READL_SLEEP_US, READL_TIMEOUT_US);
> > > > +     while (!(lan_rd(lan966x, QS_INJ_STATUS) &
> > > > +              QS_INJ_STATUS_FIFO_RDY_SET(BIT(grp)))) {
> > > > +             if (time_after(jiffies, time)) {
> > > > +                     ret = -ETIMEDOUT;
> > > > +                     break;
> > > > +             }
> > >
> > > Did you try setting READL_SLEEP_US to 0? readx_poll_timeout_atomic()
> > > explicitly supports that.
> >
> > I have tried but it didn't improve. It was the same as before.
> 
> How many times round the loop is it going ?

In the tests that I have done, I have never seen entering in the loop.

> 
> It might be that by the time readx_poll_timeout_atomic()
> gets around to reading the register the fifo is actually ready.
> 
> The there is the delay between detecting 'ready' and writing
> the next data.
> That delay might be cumulative and affect performance.

There is also a small delay between writting the word and checking if
more words can be written.

> 
> OTOH spinning waiting for fifo space is just plain horrid.

Yes, I agree with you.

> Reminds me of 3C509 drivers :-)

> 
>         David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

-- 
/Horatiu
