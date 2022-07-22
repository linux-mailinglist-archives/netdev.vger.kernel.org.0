Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250F257DA2E
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 08:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiGVGVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 02:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGVGVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 02:21:12 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB2B237F6;
        Thu, 21 Jul 2022 23:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658470871; x=1690006871;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h4H/Zx6LklP4XR6ejecTuQCa5GmpUXVBaolU3VL7Erc=;
  b=GVamgSV0ApJWtOa7FKkXZRCqcii9nsGghSxlR3rH6af2DOFuIlPw7z48
   zKU0U2RD1Cv46+SypbdqOhQxEsuxaID06mSUUeUx4FBCOXrU8WXVplGv+
   e0/mRKv/NXC6Kay06LlH52i1uFz/naxuJsrx+XvMXRG9JUwZOw70+9p0m
   lMMDZVmkEYuj01ag1g9EbcOpXr7xtWKW55qyKMfObIBGJbJHmZCcEfdqq
   VVladwrwEuidj9qfLMYl5YiN8PO0SOalMNAb2yP2JSua91+bbP+kWiU5r
   j1budkMm08754jgqWLV61dVl144uTteMGNXoxyxLmS9aej5SSaAaJqvTq
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="348948853"
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="348948853"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 23:21:10 -0700
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="626439407"
Received: from punajuuri.fi.intel.com (HELO paasikivi.fi.intel.com) ([10.237.72.43])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 23:21:02 -0700
Received: from paasikivi.fi.intel.com (localhost [127.0.0.1])
        by paasikivi.fi.intel.com (Postfix) with SMTP id 8778B20359;
        Fri, 22 Jul 2022 09:21:00 +0300 (EEST)
Date:   Fri, 22 Jul 2022 06:21:00 +0000
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 2/6] software node: allow named software node to
 be created
Message-ID: <YtpBzCf+Vc3yWSUF@paasikivi.fi.intel.com>
References: <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
 <20220715204841.pwhvnue2atrkc2fx@skbuf>
 <YtVSQI5VHtCOTCHc@smile.fi.intel.com>
 <YtVfppMtW77ICyC5@shell.armlinux.org.uk>
 <YtWp3WkpCtfe559l@smile.fi.intel.com>
 <YtWwbMucEyO+W8/Y@shell.armlinux.org.uk>
 <YtW9goFpOLGvIDog@smile.fi.intel.com>
 <YtXE0idsKe6FZ+n4@shell.armlinux.org.uk>
 <YtZwU9BKAO/WSRmK@paasikivi.fi.intel.com>
 <20220720225652.4uo6fcdcunenej3j@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720225652.4uo6fcdcunenej3j@skbuf>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thu, Jul 21, 2022 at 01:56:52AM +0300, Vladimir Oltean wrote:
> Hi Sakari,
> 
> On Tue, Jul 19, 2022 at 08:50:27AM +0000, Sakari Ailus wrote:
> > Basically what your patch is doing is adding a helper function that creates
> > an fwnode with a given name. This functionality was there previously through
> > software_node_register_nodes(), with node allocation responsibility residing
> > on the caller. It's used e.g. here:
> > drivers/media/pci/intel/ipu3/cio2-bridge.c .
> > 
> > The larger question is perhaps when can you safely remove software nodes.
> > And which of these two APIs would be preferred. I haven't checked how many
> > users each has. There's no refcounting nor locking for software nodes, so
> > once made visible to the rest of the kernel, they're always expected to be
> > there, unchanged, or at least it needs to be known when they can be removed.
> 
> Just for my clarity, are you saying that this printf selftest is
> violating the software nodes' expectation to always be there unchanged
> and never be removed?

No. This is the other case, i.e. it's known the nodes can be removed.

> 
> static void __init fwnode_pointer(void)
> {
> 	const struct software_node softnodes[] = {
> 		{ .name = "first", },
> 		{ .name = "second", .parent = &softnodes[0], },
> 		{ .name = "third", .parent = &softnodes[1], },
> 		{ NULL /* Guardian */ }
> 	};
> 	const char * const full_name = "first/second/third";
> 	const char * const full_name_second = "first/second";
> 	const char * const second_name = "second";
> 	const char * const third_name = "third";
> 	int rval;
> 
> 	rval = software_node_register_nodes(softnodes);
> 	if (rval) {
> 		pr_warn("cannot register softnodes; rval %d\n", rval);
> 		return;
> 	}
> 
> 	test(full_name_second, "%pfw", software_node_fwnode(&softnodes[1]));
> 	test(full_name, "%pfw", software_node_fwnode(&softnodes[2]));
> 	test(full_name, "%pfwf", software_node_fwnode(&softnodes[2]));
> 	test(second_name, "%pfwP", software_node_fwnode(&softnodes[1]));
> 	test(third_name, "%pfwP", software_node_fwnode(&softnodes[2]));
> 
> 	software_node_unregister_nodes(softnodes);
> }
> 
> The use case in this patch set is essentially equivalent to what printf
> does: exposing the software nodes to the rest of the kernel and to user
> space is probably not necessary, it's just that we need to call a
> function that parses their structure (essentially an equivalent to
> calling "test" above). Could you indicate whether there is a better
> alternative of doing this?

I'm actually not suggesting to do otherwise. What I wanted to say was that
it'd be best to settle with a single API to create software nodes while
keeping in mind serialising access to the data structure as well as
the lifetime of the software nodes.

This patch is adding another API function to register software nodes which
expands the scope of another that effectively did not allow sub-nodes.
Lifetime management currently doesn't really exist for ACPI nodes (device
or data) and only exists in somewhat unsatisfactory form for DT nodes. That
might be still the best model for software nodes.

Perhaps the API this patch adds is nicer to use than
software_node_register_nodes() and better lends itself for adding
refcounting later on.

I wonder what Andy or Heikki think.

-- 
Kind regards,

Sakari Ailus
