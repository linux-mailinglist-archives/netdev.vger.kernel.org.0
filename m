Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13C71F9A03
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 16:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgFOOWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 10:22:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:17447 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729733AbgFOOWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 10:22:52 -0400
IronPort-SDR: XCUN/hN6A/HSr/hv5/HKxhbE2/XEJjh2ojJJUBlKzRTlTuB6Rv5Ov7Vae6fVT0hLYfozlvUsQU
 MWF1VWaNedDg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 07:22:51 -0700
IronPort-SDR: e+z4N+ZRnRkdSSdt5CNKWCaqHTEqQWyUWRcVkB7hfbR1P8XG3L/HOifT43u+USQ1v25wgqWxYm
 TnLVDCAfMW0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,514,1583222400"; 
   d="scan'208";a="382560521"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 15 Jun 2020 07:22:48 -0700
Received: by lahna (sSMTP sendmail emulation); Mon, 15 Jun 2020 17:22:47 +0300
Date:   Mon, 15 Jun 2020 17:22:47 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Yehezkel Bernat <yehezkelshb@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] thunderbolt: Get rid of E2E workaround
Message-ID: <20200615142247.GN247495@lahna.fi.intel.com>
References: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
 <20200615130139.83854-5-mika.westerberg@linux.intel.com>
 <CA+CmpXtpAaY+zKG-ofPNYHTChTiDtwCAnd8uYQSqyJ8hLE891Q@mail.gmail.com>
 <20200615135112.GA1402792@kroah.com>
 <CA+CmpXst-5i4L5nW-Z66ZmxuLhdihjeNkHU1JdzTwow1rNH7Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CmpXst-5i4L5nW-Z66ZmxuLhdihjeNkHU1JdzTwow1rNH7Ng@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 05:18:38PM +0300, Yehezkel Bernat wrote:
> On Mon, Jun 15, 2020 at 4:51 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jun 15, 2020 at 04:45:22PM +0300, Yehezkel Bernat wrote:
> > > On Mon, Jun 15, 2020 at 4:02 PM Mika Westerberg
> > > <mika.westerberg@linux.intel.com> wrote:
> > > >
> > > > diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
> > > > index ff397c0d5c07..5db2b11ab085 100644
> > > > --- a/include/linux/thunderbolt.h
> > > > +++ b/include/linux/thunderbolt.h
> > > > @@ -504,8 +504,6 @@ struct tb_ring {
> > > >  #define RING_FLAG_NO_SUSPEND   BIT(0)
> > > >  /* Configure the ring to be in frame mode */
> > > >  #define RING_FLAG_FRAME                BIT(1)
> > > > -/* Enable end-to-end flow control */
> > > > -#define RING_FLAG_E2E          BIT(2)
> > > >
> > >
> > > Isn't it better to keep it (or mark it as reserved) so it'll not cause
> > > compatibility issues with older versions of the driver or with Windows?
> >
> >
> > How can you have "older versions of the driver"?  All drivers are in the
> > kernel tree at the same time, you can't ever mix-and-match drivers and
> > kernels.
> >
> > And how does Windows come into play here?
> >
> 
> As much as I remember, this flag is sent as part of creating the
> interdomain connection.
> If we reuse this bit to something else, and the other host runs an
> older kernel or
> Windows, this seems to be an issue.
> But maybe I don't remember it correctly.

We never send this flag anywhere. At the moment we do not announce
support the "full E2E" in the network driver. Basically this is dead
code what we remove.
