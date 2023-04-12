Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12AE56DF6EE
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjDLNWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjDLNWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:22:18 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086009EFD;
        Wed, 12 Apr 2023 06:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681305718; x=1712841718;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=OPaJB6Rawo57Mhn6OmatsXFomMBlxxHp8ieaH0gHRmY=;
  b=VtKrLYLj8uGU7d3BG0JEPsoqP4EVhKXdkmhRoUqJwgf6tHqVWdnsDdmH
   LWzxxlfDhiGywy8/JcMDqILowYza/TG7BgJRrH+fwB/8Fstp9rqG1pSOR
   tOPn2Rho8ZadCxrcztZUdJcc7rdzhSs7CO1k8El2x+fzip9+ndpSdCBxA
   z3jLGETF7tR6DeQ/BRC3NlNdzSk6oepxvhSlxbuq4zzwnxKUxAs/ipN/B
   HcEDpw+WYArhsVP3S83wDwyN7CKUTHkEVg0FzmHQgRnNv5ti7gIxDvW/L
   EC9Sf4AAg6BjXdoOOH3nJw7nh6NmV4lyNWu+kzc5+c1JFVnboP+HUaxeF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="345683541"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="345683541"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 06:20:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="719373457"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="719373457"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008.jf.intel.com with ESMTP; 12 Apr 2023 06:20:36 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pmaOo-00Fx3H-0Q;
        Wed, 12 Apr 2023 16:20:34 +0300
Date:   Wed, 12 Apr 2023 16:20:33 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Donald Hunter <donald.hunter@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [BUG] net, pci: 6.3-rc1-4 hangs during boot on PowerEdge R620
 with igb
Message-ID: <ZDawIXBd7gcA8DCk@smile.fi.intel.com>
References: <20230410213754.GA4064490@bhelgaas>
 <m27cuih96y.fsf@gmail.com>
 <CAL_Jsq+nLP6rh3pdK3-5a8-mjR=dF48i-Z8d8u7N=fuYoCk92A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_Jsq+nLP6rh3pdK3-5a8-mjR=dF48i-Z8d8u7N=fuYoCk92A@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 02:02:03PM -0500, Rob Herring wrote:
> On Tue, Apr 11, 2023 at 7:53 AM Donald Hunter <donald.hunter@gmail.com> wrote:
> > Bjorn Helgaas <helgaas@kernel.org> writes:
> > > On Mon, Apr 10, 2023 at 04:10:54PM +0100, Donald Hunter wrote:
> > >> On Sun, 2 Apr 2023 at 23:55, Bjorn Helgaas <helgaas@kernel.org> wrote:
> > >> > On Sat, Apr 01, 2023 at 01:52:25PM +0100, Donald Hunter wrote:
> > >> > > On Fri, 31 Mar 2023 at 20:42, Bjorn Helgaas <helgaas@kernel.org> wrote:
> > >> > > >
> > >> > > > I assume this igb NIC (07:00.0) must be built-in (not a plug-in card)
> > >> > > > because it apparently has an ACPI firmware node, and there's something
> > >> > > > we don't expect about its status?
> > >> > >
> > >> > > Yes they are built-in, to my knowledge.
> > >> > >
> > >> > > > Hopefully Rob will look at this.  If I were looking, I would be
> > >> > > > interested in acpidump to see what's in the DSDT.
> > >> > >
> > >> > > I can get an acpidump. Is there a preferred way to share the files, or just
> > >> > > an email attachment?
> > >> >
> > >> > I think by default acpidump produces ASCII that can be directly
> > >> > included in email.  http://vger.kernel.org/majordomo-info.html says
> > >> > 100K is the limit for vger mailing lists.  Or you could open a report
> > >> > at https://bugzilla.kernel.org and attach it there, maybe along with a
> > >> > complete dmesg log and "sudo lspci -vv" output.
> > >>
> > >> Apologies for the delay, I was unable to access the machine while travelling.
> > >>
> > >> https://bugzilla.kernel.org/show_bug.cgi?id=217317
> > >
> > > Thanks for that!  Can you boot a kernel with 6fffbc7ae137 reverted
> > > with this in the kernel parameters:
> > >
> > >   dyndbg="file drivers/acpi/* +p"
> > >
> > > and collect the entire dmesg log?
> >
> > Added to the bugzilla report.
> 
> Rafael, Andy, Any ideas why fwnode_device_is_available() would return
> false for a built-in PCI device with a ACPI device entry? The only
> thing I see in the log is it looks like the parent PCI bridge/bus
> doesn't have ACPI device entry (based on "[    0.913389] pci_bus
> 0000:07: No ACPI support"). For DT, if the parent doesn't have a node,
> then the child can't. Not sure on ACPI.

Thanks for the Cc'ing. I haven't checked anything yet, but from the above it
sounds like a BIOS issue. If PCI has no ACPI companion tree, then why the heck
one of the devices has the entry? I'm not even sure this is allowed by ACPI
specification, but as I said, I just solely used the above mail.

-- 
With Best Regards,
Andy Shevchenko


