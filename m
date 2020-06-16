Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136361FAF93
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 13:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgFPLz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 07:55:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:44132 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgFPLzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 07:55:25 -0400
IronPort-SDR: v7bwRE7z84WGNk5SbG7E6nnw5XjXuFXRPj3eZhp9WW77LYIVv3TTmQz1WhibWyHmZOy17SRhfj
 Ai7/ylbqDrxg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 04:55:24 -0700
IronPort-SDR: Gdf9x4vhfnBK9yRrH1GCDkAox6VRqjPK7PHG807wKts5Ku+qezPDs6y+HiDDjjwBUyh5Szfsp6
 Ch44Km7jqGsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,518,1583222400"; 
   d="scan'208";a="382851130"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 16 Jun 2020 04:55:21 -0700
Received: by lahna (sSMTP sendmail emulation); Tue, 16 Jun 2020 14:55:20 +0300
Date:   Tue, 16 Jun 2020 14:55:20 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Yehezkel Bernat <yehezkelshb@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] thunderbolt: Get rid of E2E workaround
Message-ID: <20200616115520.GK2795@lahna.fi.intel.com>
References: <20200615130139.83854-5-mika.westerberg@linux.intel.com>
 <CA+CmpXtpAaY+zKG-ofPNYHTChTiDtwCAnd8uYQSqyJ8hLE891Q@mail.gmail.com>
 <20200615135112.GA1402792@kroah.com>
 <CA+CmpXst-5i4L5nW-Z66ZmxuLhdihjeNkHU1JdzTwow1rNH7Ng@mail.gmail.com>
 <20200615142247.GN247495@lahna.fi.intel.com>
 <CA+CmpXuN+su50RYHvW4S-twqiUjScnqM5jvG4ipEvWORyKfd1g@mail.gmail.com>
 <20200615153249.GR247495@lahna.fi.intel.com>
 <CA+CmpXtRZ4JMe2V2-kWiYWR0pnnzLQMbXQESni6ne8eFeDCCXg@mail.gmail.com>
 <20200615155512.GS247495@lahna.fi.intel.com>
 <CA+CmpXtOAUnSdhjwi5HXaJhPzbUUsZZsitFifyhyPk+X2c=wYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CmpXtOAUnSdhjwi5HXaJhPzbUUsZZsitFifyhyPk+X2c=wYw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 10:54:52PM +0300, Yehezkel Bernat wrote:
> On Mon, Jun 15, 2020 at 6:55 PM Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> >
> > On Mon, Jun 15, 2020 at 06:41:32PM +0300, Yehezkel Bernat wrote:
> > > > I think you are talking about the "prtstns" property in the network
> > > > driver. There we only set TBNET_MATCH_FRAGS_ID (bit 1). This is the
> > > > thing that get exposed to the other side of the connection and we never
> > > > announced support for full E2E.
> > >
> > >
> > > Ah, yes, this one, Thanks!
> > > As Windows driver uses it for flagging full-E2E, and we completely drop E2E
> > > support here, it may worth to mention there that this is what bit 2 is used in
> > > Windows so any reuse should consider the possible compatibility issue.
> >
> > Note we only drop dead code in this patch. It is that workaround for
> > Falcon Ridge controller we actually never used.
> >
> > I can add a comment to the network driver about the full E2E support
> > flag as a separate patch if you think it is useful.
> >
> > The network protocol will be public soon I guess because USB4 spec
> > refers to "USB4 Inter-Domain Specification, Revision 1.0, [to be
> > published] – (USB4 Inter-Domain Specification)" so I would expect it to
> > be explained there as well.
> 
> I see. I leave it for your decision, then.
> Thanks for bearing with me.

OK, I think it makes sense to add the comment so I'll do that as
a separate patch (will probably go next week since I have some other
patches to deal with this week, and Friday is holiday in Finland).
