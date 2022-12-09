Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BBA648500
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiLIPZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiLIPZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:25:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B188B1A6;
        Fri,  9 Dec 2022 07:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670599504; x=1702135504;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WmwpTYyxcVQtiW1tL9fJMr4BDXHV7YEW8emRKA6pCLM=;
  b=FHKGNhcF5a/VoIsDn+xf7QSag4dlUuYqcc9B7X8JHvKzBa+4FQRqWd2D
   ZPQJluuiEAJc2e5HOwuqIp1N6giVYbSTxv+TWQDknKimEXPf92piFEAck
   5zVUUC4U8zPyJ/lp2Y5ZbFgjg6U2/qtVRXdzOZc+gs06kqvxtIdLk6jnU
   vJSaLF7GPQr/TYxvpCuc3oe5Ug0KVhVK2N+766+zz7HFLhoqu/Ei9OqtM
   tnpn6Fq6I3tiOHmEbnZjvO3YycLEF9nj9PCP4AFObm6d4M6LUYG60A+Y/
   cpb13kEvfWeHtK6fGKBwMy/uX4Tb8SptGTW4BmMMpe+jb56fn3msW+C/z
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="190905714"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 08:25:03 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 08:25:02 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Fri, 9 Dec 2022 08:25:02 -0700
Date:   Fri, 9 Dec 2022 16:30:10 +0100
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
Message-ID: <20221209153010.f4r577ilnlein77e@soft-dev3-1>
References: <adb8e2312b169d13e756ff23c45872c3@walle.cc>
 <20221209092904.asgka7zttvdtijub@soft-dev3-1>
 <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
 <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
 <20221209125611.m5cp3depjigs7452@skbuf>
 <a821d62e2ed2c6ec7b305f7d34abf0ba@walle.cc>
 <20221209142058.ww7aijhsr76y3h2t@soft-dev3-1>
 <20221209144328.m54ksmoeitmcjo5f@skbuf>
 <20221209145720.ahjmercylzqo5tla@soft-dev3-1>
 <20221209145637.nr6favnsofmwo45s@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221209145637.nr6favnsofmwo45s@skbuf>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/09/2022 16:56, Vladimir Oltean wrote:
> 
> On Fri, Dec 09, 2022 at 03:57:20PM +0100, Horatiu Vultur wrote:
> > The 12/09/2022 16:43, Vladimir Oltean wrote:
> > >
> > > On Fri, Dec 09, 2022 at 03:20:58PM +0100, Horatiu Vultur wrote:
> > > > On ocelot, the vcap is enabled at port initialization, while on other
> > > > platforms(lan966x and sparx5) you have the option to enable or disable.
> > >
> > > Even if that wasn't the case, I'd still consider enabling/disabling VCAP
> > > lookups privately in the ocelot driver when there are non-tc users of
> > > traps, instead of requiring users to do anything with tc.
> >
> > I was thinking also about this, such the ptp to enable the VCAP
> > privately. But then the issue would be if a user adds entries using tc
> > and then start ptp, then suddently the rules that were added using tc
> > could be hit. That is the reason why expected the user to enable the
> > tcam manually.
> 
> I don't understand, tc rules which do what? Why would those rules only
> be hit after PTP is enabled and not before?

Because you have not enabled the vcap.

For example this rule:
tc filter add dev eth0 ingress chain 8000000 prio 1 handle 1 protocol all
flower skip_sw dst_mac 00:11:22:33:44:55/ff:ff:ff:ff:ff:ff action trap
action goto chain 8100000

This will not be hit until you add this rule:
tc filter add dev eth0 ingress prio 1 handle 2 matchall skip_sw action goto chain 8000000

Because this rule will enable the HW. Just to aligned to a SW
implementation of the tc, we don't enable the vcap until there is a rule
in chain 0 that has an action to go to chain 8000000 were it resides
IS2 rules.

So for example, on a fresh started lan966x the user will add the following
rule:
tc filter add dev eth0 ingress chain 8000000 prio 1 handle 1 protocol
all flower skip_sw dst_mac 00:11:22:33:44:55/ff:ff:ff:ff:ff:ff action
trap action goto chain 8100000

He expects this rule not to be hit as there is no rule in chain 0. Now if
PTP is started and it would enable vcap, then suddenly this rule may be
hit.

I hope this helps a little bit.

-- 
/Horatiu
