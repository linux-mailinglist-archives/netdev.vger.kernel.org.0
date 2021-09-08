Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E4C4041A8
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 01:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241864AbhIHXPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 19:15:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33320 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233315AbhIHXPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 19:15:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bapeTSXWnVrReW5xragxY89xR94ididCYWaqgoqyVsI=; b=KPNr47v/1s3mRi92jt5Y8SCPJM
        q8Y2fQggZY8Hz6Qtlqt4yPloNEXQXzVQbPw5f+n30ONGiqbeTOIkBkoFXl16JZss6HWK+fuHB5WSB
        y0Ij4PgxST1QDpTJyv9ElkH8eWVGeJKPtNwzAqjlpfD22Ye//MW9ash7bj8ID2GEuBwI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mO6m4-005oeL-2W; Thu, 09 Sep 2021 01:14:36 +0200
Date:   Thu, 9 Sep 2021 01:14:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Saeed Mahameed <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Message-ID: <YTlD3Gok7w/MF+g2@lunn.ch>
References: <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB4951AA3C65DD8E7612F5F396EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210908151852.7ad8a0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908151852.7ad8a0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> As you said, pin -> ref mapping is board specific, so the API should
> not assume knowledge of routing between Port and ECC.

That information will probably end up in device tree. And X different
implementations of ACPI, unless somebody puts there foot down and
stops the snow flakes.

> Imagine a system with two cascaded switch ASICs and a bunch of PHYs.
> How do you express that by pure extensions to the proposed API?

Device tree is good at that. ACPI might eventually catch up.

How complex a setup do we actually expect? Can there be multiple
disjoint SyncE trees within an Ethernet switch cluster? Or would it be
reasonable to say all you need to configure is the clock source, and
all other ports of the switches are slaves if SyncE is enabled for the
port? I've never see any SOHO switch hardware which allows you to have
disjoint PTP trees, so it does not sound too unreasonable to only
allow a single SyncE tree per switch cluster.

Also, if you are cascading switches, you generally don't put PHYs in
the middle, you just connect the SERDES lanes together.

	 Andrew
