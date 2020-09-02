Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAF925A5F9
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 09:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgIBHEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 03:04:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:42800 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgIBHEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 03:04:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BC3C2B14F;
        Wed,  2 Sep 2020 07:04:00 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 91D4660326; Wed,  2 Sep 2020 09:03:59 +0200 (CEST)
Date:   Wed, 2 Sep 2020 09:03:59 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Kevin Yang <yyd@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Networking <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH ethtool] ethtool: add support show/set-hwtstamp
Message-ID: <20200902070359.upkax24olhzksxhi@lion.mk-sys.cz>
References: <20200901212009.1314401-1-yyd@google.com>
 <20200901220200.GB3050651@lunn.ch>
 <CAPREpbaFi6Tqw+YKx=1c1nFRtUt9G2gRW2BT83siqojy=DOEmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPREpbaFi6Tqw+YKx=1c1nFRtUt9G2gRW2BT83siqojy=DOEmA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 08:36:08PM -0400, Kevin Yang wrote:
> On Tue, Sep 1, 2020 at 6:02 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > On Tue, Sep 01, 2020 at 05:20:09PM -0400, Kevin(Yudong) Yang wrote:
> > > Before this patch, ethtool has -T/--show-time-stamping that only
> > > shows the device's time stamping capabilities but not the time
> > > stamping policy that is used by the device.
> >
> > How does this differ from hwstamp_ctl(1)?
> 
> They are pretty much the same, both use ioctl(SIOCSHWTSTAMP).
> 
> Adding this to ethtool is because:
> - This time stamping policy is a hardware setting aligned with ethtool's
> purpose "query and control network device driver and hardware settings"
> - ethtool is widely used, system administrators don't need to install
> another binary to control this feature.

Adding this feature to ethtool IMHO makes good sense, I'm just not sure
if it's necessary to add new subcommands, perhaps we could add the
"show" part to -T / --show-time-stamping and add --set-time-stamping.

However, I don't like the idea of adding a new ioctl based interface to
ethtool while we are working on replacing and deprecating existing one.
I would much rather like adding this to the netlink interface (which
would, of course, require also kernel side implementation).

Michal
