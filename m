Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411A064838D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 15:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiLIOQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 09:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiLIOQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 09:16:16 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DC664D0;
        Fri,  9 Dec 2022 06:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670595353; x=1702131353;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q4a9U1SZ0Rp7ftX9JdBYHlEBnCnbX6tXmyOibpHi2+M=;
  b=IravYnSqmliil7Q4B85Nd9h4Mtewnm9OVLHxgEC9vHtLFY0Hv+cQe6gG
   2YyYFQG7mFAK5/l4i1OuA69wFUkcIzmPZU8EUPcgU76vo6VxdCs2NQ0kw
   peCHh/khoDt6JVk40idnE6NOO65S6GRE1jBJO9Ylcv0zQMQ643ytRCk0T
   vMqN22ub2z3R9tzIr9v18TFqGuY7/4PWhdfd4nZBHCasm0np7BOxuKHFe
   jnWlgP0Mp+Xsc+MksXx6tUbv6gxh0xnJZ5s2ODbmNxqx+pLwJzY7kCm0S
   /GguS3lFTdJA5O4OwWXt8cuUrQu/pm9se/XRu2dbP6GveWefjQX4+5+oa
   A==;
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="190897842"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 07:15:52 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 07:15:51 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Fri, 9 Dec 2022 07:15:51 -0700
Date:   Fri, 9 Dec 2022 15:20:58 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        <Steen.Hegelund@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <daniel.machon@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>,
        <lars.povlsen@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20221209142058.ww7aijhsr76y3h2t@soft-dev3-1>
References: <20221203104348.1749811-5-horatiu.vultur@microchip.com>
 <20221208092511.4122746-1-michael@walle.cc>
 <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
 <20221208130444.xshazhpg4e2utvjs@soft-dev3-1>
 <adb8e2312b169d13e756ff23c45872c3@walle.cc>
 <20221209092904.asgka7zttvdtijub@soft-dev3-1>
 <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
 <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
 <20221209125611.m5cp3depjigs7452@skbuf>
 <a821d62e2ed2c6ec7b305f7d34abf0ba@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <a821d62e2ed2c6ec7b305f7d34abf0ba@walle.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/09/2022 15:05, Michael Walle wrote:
> 
> Am 2022-12-09 13:56, schrieb Vladimir Oltean:
> > On Fri, Dec 09, 2022 at 01:58:57PM +0100, Horatiu Vultur wrote:
> > > > Does it also work out of the box with the following patch if
> > > > the interface is part of a bridge or do you still have to do
> > > > the tc magic from above?
> > > 
> > > You will still need to enable the TCAM using the tc command to have it
> > > working when the interface is part of the bridge.
> > 
> > FWIW, with ocelot (same VCAP mechanism), PTP traps work out of the box,
> > no need to use tc. Same goes for ocelot-8021q, which also uses the
> > VCAP.
> > I wouldn't consider forcing the user to add any tc command in order for
> > packet timestamping to work properly.

On ocelot, the vcap is enabled at port initialization, while on other
platforms(lan966x and sparx5) you have the option to enable or disable.

> 
> +1
> Esp. because there is no warning. I.e. I tried this patch while
> the interface was added on a bridge and there was no error
> whatsoever.

What error/warning were you expecting to see here?

> Also, you'd force the user to have that Kconfig option
> set.



> 
> -michael
> 

-- 
/Horatiu
