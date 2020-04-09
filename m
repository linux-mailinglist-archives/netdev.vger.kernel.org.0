Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869CA1A3CBE
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 01:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgDIXHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 19:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726795AbgDIXHB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 19:07:01 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D154206C0;
        Thu,  9 Apr 2020 23:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586473621;
        bh=bNIJSPD7Pmyz9VhhBGCfVWHHSxWOuET1XisWlfyo9KU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KNWDxLaleJQt0YpBcnMvOfbOPq8W0zKx5FnppXX7LRF7L7IwvbmMckdGPp75Hyf8O
         Lq0ODS76RNtPjr7Ngc0fSVqbtQhmeUeJhHNRUHMCx6xsfw5ZDhSAlbt3TqJR3i3S/V
         WqUzDIlrH8dcEHpGpBxNecfYNAfJdJRF/V1cmgVA=
Date:   Thu, 9 Apr 2020 16:06:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Tal Gilboa <talgi@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net v2 1/2] docs: networking: convert DIM to RST
Message-ID: <20200409160658.1b940fcf@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1210a28bfe1a67818f3f814e38f52923cbd201c0.camel@mellanox.com>
References: <20200409212159.322775-1-kuba@kernel.org>
        <1210a28bfe1a67818f3f814e38f52923cbd201c0.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Apr 2020 22:46:55 +0000 Saeed Mahameed wrote:
> On Thu, 2020-04-09 at 14:21 -0700, Jakub Kicinski wrote:
> > Convert the Dynamic Interrupt Moderation doc to RST and
> > use the RST features like syntax highlight, function and
> > structure documentation, enumerations, table of contents.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> > ---
> > v2:
> >  - remove the functions/type definition markup
> >  - change the contents definition (the :local: seem to
> >    not work too well with kdoc)
> > ---
> >  Documentation/networking/index.rst            |  1 +
> >  .../networking/{net_dim.txt => net_dim.rst}   | 90 +++++++++------
> > ----
> >  MAINTAINERS                                   |  1 +
> >  3 files changed, 45 insertions(+), 47 deletions(-)
> >  rename Documentation/networking/{net_dim.txt => net_dim.rst} (79%)
> > 
> > diff --git a/Documentation/networking/index.rst
> > b/Documentation/networking/index.rst
> > index 50133d9761c9..6538ede29661 100644
> > --- a/Documentation/networking/index.rst
> > +++ b/Documentation/networking/index.rst
> > @@ -22,6 +22,7 @@ Linux Networking Documentation
> >     z8530book
> >     msg_zerocopy
> >     failover
> > +   net_dim  
> 
> net_dim is a performance feature, i would move further down the list
> where the perf features such as scaling and offloads are .. 

I mean.. so is msg_zerocopy just above ;-)  I spotted slight
alphabetical ordering there, which may have not been intentional,
that's why I put it here. Marking with # things out of order, but 
based on just the first letter:

#  netdev-FAQ
   af_xdp
   bareudp
   batman-adv
   can
   can_ucan_protocol
   device_drivers/index
   dsa/index
   devlink/index
   ethtool-netlink
   ieee802154
   j1939
   kapi
#  z8530book
   msg_zerocopy
#  failover
   net_dim
   net_failover
   phy
   sfp-phylink
#  alias
#  bridge
   snmp_counter
#  checksum-offloads
   segmentation-offloads
   scaling
   tls
   tls-offload
#  nfc
   6lowpan

My feeling is that we should start considering splitting kernel-only
docs and admin-only docs for networking, which I believe is the
direction Jon and folks want Documentation/ to go. But I wasn't brave
enough to be the first one. Then we can impose some more structure,
like putting all "performance" docs in one subdir..?

WDYT?
