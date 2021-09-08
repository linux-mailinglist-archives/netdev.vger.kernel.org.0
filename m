Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F116F404176
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 00:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348425AbhIHXBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 19:01:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33300 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348275AbhIHXAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 19:00:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7Cew9e3UlL5P09S1oK6yvHHk9eW+3ig/EHObaHl7uN0=; b=E4Qbf0R1jMJ2BNuiIIqQQ771eY
        sQGaw9vSomjmLbAmMkpy9F3TRnJn6NeIrTlAmB1GlITkteIsivc5u5hGX7hJ5CYo8BV0kmLe5C+Zc
        hKrbRJsnJjvVWYNA9w2o3mZ37y/Eg69FucZu0Z0G7zVatQmrcsjo9w03Ybl+WPlNgq58=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mO6XP-005obr-TM; Thu, 09 Sep 2021 00:59:27 +0200
Date:   Thu, 9 Sep 2021 00:59:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
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
Message-ID: <YTlAT+1wkazy3Uge@lunn.ch>
References: <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB4951AA3C65DD8E7612F5F396EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <YTkQTQM6Is4Hqmxh@lunn.ch>
 <20210908152027.313d7168@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908152027.313d7168@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 03:20:27PM -0700, Jakub Kicinski wrote:
> On Wed, 8 Sep 2021 21:34:37 +0200 Andrew Lunn wrote:
> > Since we are talking about clocks and dividers, and multiplexors,
> > should all this be using the common clock framework, which already
> > supports most of this? Do we actually need something new?
> 
> Does the common clock framework expose any user space API?

Ah, good point. No, i don't think it does, apart from debugfs, which
is not really a user space API, and it contains read only descriptions
of the clock tree, current status, mux settings, dividers etc.

So probably anybody implemented the proposed API the Linux way will
use the common clock framework and its internal API, and debug the
implementation via debugfs.

PHY drivers already do use it, e.g. when the PHY is using a clock
provided by the MAC, it uses the API to enable/disable and set ifs
frequency as needed.

    Andrew
