Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157F91FD7F7
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 23:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgFQVyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 17:54:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:60762 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgFQVyW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 17:54:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 95581ABE4;
        Wed, 17 Jun 2020 21:54:22 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 07DD4602E9; Wed, 17 Jun 2020 23:54:17 +0200 (CEST)
Date:   Wed, 17 Jun 2020 23:54:17 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Aya Levin <ayal@mellanox.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend net] net: ethtool: add missing
 NETIF_F_GSO_FRAGLIST feature string
Message-ID: <20200617215417.kx3fz2jw3qijqz7p@lion.mk-sys.cz>
References: <9oPfKdiVuoDf251VBJXgNs-Hv-HWPnIJk52x-SQc1frfg8QSf9z3rCL-CBSafkp9SO0CjNzU8QvUv9Abe4SvoUpejeob9OImDPbflzRC-0Y=@pm.me>
 <20200617211844.kupsyijuurjpb5kd@lion.mk-sys.cz>
 <5u_BsHq6Jk0q09sGWsVKfvv0NRa5kBHjxdOr9VpNknRnxHpbRO_80JSHl_AWS-C_wBS7B15KetRleLaluF8tOysTNYyLVRUG4BRFQZxnhXw=@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5u_BsHq6Jk0q09sGWsVKfvv0NRa5kBHjxdOr9VpNknRnxHpbRO_80JSHl_AWS-C_wBS7B15KetRleLaluF8tOysTNYyLVRUG4BRFQZxnhXw=@pm.me>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 09:38:47PM +0000, Alexander Lobakin wrote:
> Hi Michal,
> 
> On Thursday, 18 June 2020, 0:18, Michal Kubecek <mkubecek@suse.cz> wrote:
> 
> > On Wed, Jun 17, 2020 at 08:42:47PM +0000, Alexander Lobakin wrote:
> >
> > > Commit 3b33583265ed ("net: Add fraglist GRO/GSO feature flags") missed
> > > an entry for NETIF_F_GSO_FRAGLIST in netdev_features_strings array. As
> > > a result, fraglist GSO feature is not shown in 'ethtool -k' output and
> > > can't be toggled on/off.
> > > The fix is trivial.
> > >
> > > Fixes: 3b33583265ed ("net: Add fraglist GRO/GSO feature flags")
> > > Signed-off-by: Alexander Lobakin alobakin@pm.me
> > >
> > > ----------------------------------------------------------------------------------------------------------------
> > >
> > > net/ethtool/common.c | 1 +
> > > 1 file changed, 1 insertion(+)
> > > diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> > > index 423e640e3876..47f63526818e 100644
> > > --- a/net/ethtool/common.c
> > > +++ b/net/ethtool/common.c
> > > @@ -43,6 +43,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
> > > [NETIF_F_GSO_SCTP_BIT] = "tx-sctp-segmentation",
> > > [NETIF_F_GSO_ESP_BIT] = "tx-esp-segmentation",
> > > [NETIF_F_GSO_UDP_L4_BIT] = "tx-udp-segmentation",
> > >
> > > -   [NETIF_F_GSO_FRAGLIST_BIT] = "tx-gso-list",
> > >     [NETIF_F_FCOE_CRC_BIT] = "tx-checksum-fcoe-crc",
> > >     [NETIF_F_SCTP_CRC_BIT] = "tx-checksum-sctp",
> > >
> >
> > Reviewed-by: Michal Kubecekmkubecek@suse.cz
> 
> Thanks!
> 
> > AFAICS the name for NETIF_F_GSO_TUNNEL_REMCSUM_BIT is also missing but
> > IMHO it will be better to fix that by a separate patch with its own
> > Fixes tag.
> 
> Oh, nice catch! I'll make a separate for this one.
> I also wanted to add any sort of static_assert() / BUILD_BUG_ON() to
> prevent such misses, but don't see any easy pattern to check for now,
> as netdev_features_strings[] is always NETDEV_FEATURE_COUNT-sized.

The key problem is that unlike e.g. link modes, new netdev features are
not always added at the end. So even if we changed
netdev_features_strings[] array to have size determined automatically
from initializers, adding new netdev feature somewhere in the middle
(e.g. GSO one) without updating netdev_features_strings[] would not be
caught as simple array size check would not notice the hole (actually,
there are also two intended holes in the array).

Michal
