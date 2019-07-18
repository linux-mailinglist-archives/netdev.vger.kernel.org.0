Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B56FE6C7EA
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 05:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389357AbfGRDbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 23:31:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49398 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387728AbfGRDbL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 23:31:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=74k0MW/dWr92M0KcbLT426aOOybqRXRrkqwfS/oc/cw=; b=l4jeBLblA5HQcCuWoJ/ocuyLD4
        g7HnX6PG+jTnTSr82YrvQTJFRIXqvPcPLVRXmXeCwV5mhX8+bJSG8TMdfQgHioExg1a2rwaylrH+F
        c1jMIhShleX3FTBVR8k9wtZnyVCET8hPsivyxA0eZGQO0BoUQTygVSxPvCxbz365m6ws=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hnx8P-00031i-Rn; Thu, 18 Jul 2019 05:31:09 +0200
Date:   Thu, 18 Jul 2019 05:31:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
Message-ID: <20190718033109.GI6962@lunn.ch>
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io>
 <20190709023050.GC5835@lunn.ch>
 <79f2da6f-4568-4bc8-2fa4-3aa5a41bbff1@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79f2da6f-4568-4bc8-2fa4-3aa5a41bbff1@pensando.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 10:32:38PM -0700, Shannon Nelson wrote:
> On 7/8/19 7:30 PM, Andrew Lunn wrote:
> >>+static int ionic_nway_reset(struct net_device *netdev)
> >>+{
> >>+	struct lif *lif = netdev_priv(netdev);
> >>+	int err = 0;
> >>+
> >>+	if (netif_running(netdev))
> >>+		err = ionic_reset_queues(lif);
> >What does ionic_reset_queues() do? It sounds nothing like restarting
> >auto negotiation?
> >
> >      Andrew
> Basically, it's a rip-it-all-down-and-start-over way of restarting the
> connection, and is also useful for fixing queues that are misbehaving.  It's
> a little old-fashioned, taken from the ixgbe example, but is effective when
> there isn't an actual "restart auto-negotiation" command in the firmware.

O.K. More comments please.

Did you consider throwing the firmware away and just letting Linux
control the hardware? It would make this all much more transparent and
debuggable.

	Andrew
