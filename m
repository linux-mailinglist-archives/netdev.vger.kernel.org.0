Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C650564A2FB
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 15:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiLLOP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 09:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbiLLOP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 09:15:57 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0A1DF65;
        Mon, 12 Dec 2022 06:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670854553; x=1702390553;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LiT7T/L83R8Piurzl2HyKJ/SptmTCfBC/qecg42VBGM=;
  b=N5q8Wa1g33Ji7aHwkGWoGTvXriCas2FJPRBNVOnjxjAIq4dO+iK5WxeR
   yCIlet+rl/nxVOWJN4PteSqXkLhMk3sP/jyERWSP3+NplL3POgH+CEU3e
   tjS8lVHR1Z3ChMyIJUH0wXi9caScwDHQIKGRYwHqi+PsdH44rtuIj39bc
   +9YO1wTT7lugetGCMP7N6NvR0JLG8kc2dUhZ46++l5iFCloYA8vRNh5Gh
   AhmRARRY6iwfO2bUnywXgiBN3wxuIkZMiD7M3HgwKlqDOe9wIDEB0+8l9
   CS4FRZuuf8KYFQ9uQEBeO3pPSWLnGhLSmO46Ok1QAXowX58kn+XAXRxwB
   g==;
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="127698932"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2022 07:15:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 07:15:42 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Mon, 12 Dec 2022 07:15:42 -0700
Date:   Mon, 12 Dec 2022 15:20:50 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Michael Walle <michael@walle.cc>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <lars.povlsen@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20221212142050.frjlp3nfko5tos7i@soft-dev3-1>
References: <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
 <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
 <20221209125611.m5cp3depjigs7452@skbuf>
 <a821d62e2ed2c6ec7b305f7d34abf0ba@walle.cc>
 <20221209142058.ww7aijhsr76y3h2t@soft-dev3-1>
 <20221209144328.m54ksmoeitmcjo5f@skbuf>
 <20221209145720.ahjmercylzqo5tla@soft-dev3-1>
 <20221209145637.nr6favnsofmwo45s@skbuf>
 <20221209153010.f4r577ilnlein77e@soft-dev3-1>
 <20221209152713.qmbnovdookrmzvkx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221209152713.qmbnovdookrmzvkx@skbuf>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/09/2022 17:27, Vladimir Oltean wrote:
> 
Sorry for late reply!

> On Fri, Dec 09, 2022 at 04:30:10PM +0100, Horatiu Vultur wrote:
> > For example this rule:
> > tc filter add dev eth0 ingress chain 8000000 prio 1 handle 1 protocol all
> > flower skip_sw dst_mac 00:11:22:33:44:55/ff:ff:ff:ff:ff:ff action trap
> > action goto chain 8100000
> >
> > This will not be hit until you add this rule:
> > tc filter add dev eth0 ingress prio 1 handle 2 matchall skip_sw action goto chain 8000000
> >
> > Because this rule will enable the HW. Just to aligned to a SW
> > implementation of the tc, we don't enable the vcap until there is a rule
> > in chain 0 that has an action to go to chain 8000000 were it resides
> > IS2 rules.
> >
> > So for example, on a fresh started lan966x the user will add the following
> > rule:
> > tc filter add dev eth0 ingress chain 8000000 prio 1 handle 1 protocol
> > all flower skip_sw dst_mac 00:11:22:33:44:55/ff:ff:ff:ff:ff:ff action
> > trap action goto chain 8100000
> >
> > He expects this rule not to be hit as there is no rule in chain 0. Now if
> > PTP is started and it would enable vcap, then suddenly this rule may be
> > hit.
> 
> Is it too restrictive to only allow adding offloaded filters to a chain
> that has a valid goto towards it, coming (perhaps indirectly) from chain 0?

We were thinking to do something like this. With a small difference, to
allow the user to add filters to a chain, but offload them in HW only when
there is a valid goto towards. Instead of checking if there is a goto to
that chain. But I think we need to spend a little bit more time on this.
Any suggestion is more than welcome.

-- 
/Horatiu
