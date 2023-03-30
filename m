Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622956D07C7
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 16:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbjC3OMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 10:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjC3OMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 10:12:33 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35049753;
        Thu, 30 Mar 2023 07:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680185549; x=1711721549;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kO4E2os91lsLJi4GETLgzZoX+IuPasmc8YqBoRB7b00=;
  b=YjmVZbB9p8GOqedbjsJWgP5gK4UzjooKWaQ5jHxbMfBMwIkGfr7CDHt5
   i4MDk2mGjtNCZam3vNk9mTEZwKqBYDwQ1ODciIxUf+upwS4f+loWLFV0P
   /YUwR+g/dZLkywCzFHqvdvMJS6JG6Hfap5szhRDxXTbdWNaCcJeQSbSQA
   NwScCxiX9LJ4iPv8AdVKlf/eu8gaTC8fuwUvZ2933E6kvryWMjDECmcSH
   bzaQlmsPjFUu4R5dfb9Pts+LqfgLmrg350CY6riomvqwk4QKAuClRRXNa
   HZPjkkOpXog5AO/ofRQhdw2bpP3vHlueqSTe9UY3jJLZoI+l6KdqvyvFF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="343651670"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="343651670"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 06:54:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="828344122"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="828344122"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 30 Mar 2023 06:54:52 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 30 Mar 2023 16:54:51 +0300
Date:   Thu, 30 Mar 2023 16:54:51 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 6/7] net: dsa: mv88e6xxx: provide software
 node for default settings
Message-ID: <ZCWUq3yEn74JRW0w@kuha.fi.intel.com>
References: <ZB3YGWTWLYyecgw7@shell.armlinux.org.uk>
 <ZCFvtuyelA+WoeqK@kuha.fi.intel.com>
 <ZCF2BLvGoaD/RGCS@shell.armlinux.org.uk>
 <ZCGkhUh20OK6rEck@kuha.fi.intel.com>
 <ZCGpDlaJ7+HmPQiB@shell.armlinux.org.uk>
 <ZCG6D7KV/0W0FUoI@shell.armlinux.org.uk>
 <ZCLZFA964zu/otQJ@kuha.fi.intel.com>
 <ZCLqXRKHh+VjCg8v@shell.armlinux.org.uk>
 <ZCRGHlERlLNuPHgE@kuha.fi.intel.com>
 <ZCRMTP1QJ0deQhOH@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCRMTP1QJ0deQhOH@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 03:33:48PM +0100, Russell King (Oracle) wrote:
> On Wed, Mar 29, 2023 at 05:07:26PM +0300, Heikki Krogerus wrote:
> > On Tue, Mar 28, 2023 at 02:23:41PM +0100, Russell King (Oracle) wrote:
> > > On Tue, Mar 28, 2023 at 03:09:56PM +0300, Heikki Krogerus wrote:
> > > > The problem is that the function you are proposing will be exploited
> > > > silently - people will use NULL as the parent without anybody
> > > > noticing. Everything will work for a while, because everybody will
> > > > first only have a single device for that driver. But as time goes by
> > > > and new hardware appears, suddenly there are multiple devices for
> > > > those drivers, and the conflict start to appear.
> > > 
> > > So, an easy solution would be to reject a call to
> > > fwnode_create_named_software_node() when parent is NULL, thereby
> > > preventing named nodes at the root level.
> > > 
> > > > At that point the changes that added the function call will have
> > > > trickled down to the stable trees, so the distros are affected. Now we
> > > > are no longer talking about a simple cleanup that fixes the issue. In
> > > > the unlikely, but possible case, this will turn into ABI problem if
> > > 
> > > There is no such thing as stable APIs for internal kernel interfaces.
> > > 
> > > Documentation/process/stable-api-nonsense.rst
> > > 
> > > > As you pointed out, this kind of risks we have to live with kbojects,
> > > > struct device stuff and many others, but the thing is, with the
> > > > software node and device property APIs right now we don't. So the fact
> > > > that a risk exists in one place just isn't justification to accept the
> > > > same risk absolutely everywhere.
> > > 
> > > Meanwhile, firmware descriptions explicitly permit looking up nodes by
> > > their names, but here we are, with the software node maintainers
> > > basically stating that they don't wish to support creating software
> > > nodes with explicit names.
> > 
> > If you want to name the nodes then you just go ahead and name them,
> > nobody is preventing you and you can already do that, but if you do
> > so, then you will take full responsibility of the entire software node
> > - that is what you are naming here - instead of just the fwnode that
> > it contains. The users of the node can deal with the fwnode alone, but
> > you as the creator of the software node have to take proper ownership
> > of it.
> > 
> > > > Russell, if you have some good arguments for accepting your proposal,
> > > > I assure you I will agree with you, but so far all you have given are
> > > > attacks on a sketch details and statements like that "I think you're
> > > > making a mountain out of a mole". Those just are not good enough.
> > > 
> > > Basically, I think you are outright wrong for all the reasons I have
> > > given in all my emails on this subject.
> > > 
> > > Yes, I accept there is a *slight* risk of abuse, but I see it as no
> > > different from the risk from incorrect usage of any other kernel
> > > internal interface. Therefore I just do not accept your argument
> > > that we should not have this function, and I do not accept your
> > > reasoning.
> > 
> > I would not be so against the function if there wasn't any other way
> > to handle your case, but there is.
> > 
> > You really can not claim that the existing API is in any way inferior,
> > or even more complex, compared to your function before you actually
> > try it. You simply can not make judgement based on a sketch that is
> > basically just showing you the functions and structures that you need.
> > 
> > If there are issues with the API, then we need to of course fix those
> > issues, but please keep in mind that still does not mean we have any
> > need for the function you are proposing.
> > 
> > Please also note that helpers are welcome if you feel we need them. If
> > you want to add for example an allocation routine that duplicates also
> > the properties in one go, then that alone would reduce the complexity
> > needed in the drivers that create the nodes. I think in most cases,
> > possibly also in yours, that alone would allow most stuff to be
> > handled from stack memory.
> > 
> > fwnode_create_software_node() is there just to support the legacy
> > device properties. You really should not be using even that. If you
> > need to deal with software nodes then you deal with them with struct
> > software_node.
> 
> You forgot to explain how to free them once they're done, because
> struct swnode will contain a pointer to the struct software_node
> which can be a dangling stale reference - and there's no way for
> code outside swnode.c to know when that reference has gone.
> 
> That is another reason why I prefer my existing solution. That
> problem is taken care of already by the existing code - and as
> it's taken care of there, and properly, there's less possibilities
> for users of swnode to get it wrong.

We need an improved release mechanism, yes.

My idea with the new dynamic allocation routine was that it could be
introduced together with a release callback that we add to the struct
software_node.

The idea of adding the release callback to the structure was actually
considered already some time ago - I think it was discussed at least
shortly also on the public ACPI mailing list. The idea back then
included a default release function that simply frees the struct
software_node instance. That default release function we could then
assign to the release callback in that new software node
allocation/creation routine. That way the drivers should be able to
continue to rely on the underlying code to take care of freeing the
node instance.

Back then there was nobody who really needed that functionality, so
nobody even tried to implement it. Now we of course clearly do need
something like it.

I think the release callback together with the default release
function should work. Let me know what you guys think.

thanks,

-- 
heikki
