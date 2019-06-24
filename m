Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B253A50347
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 09:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfFXH0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 03:26:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:58276 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726418AbfFXH0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 03:26:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 83EDBADFE;
        Mon, 24 Jun 2019 07:26:04 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 1AD6BE0138; Mon, 24 Jun 2019 09:26:04 +0200 (CEST)
Date:   Mon, 24 Jun 2019 09:26:04 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: Re: [PATCH net-next 13/18] ionic: Add initial ethtool support
Message-ID: <20190624072604.GA27240@unicorn.suse.cz>
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-14-snelson@pensando.io>
 <20190621023205.GD21796@unicorn.suse.cz>
 <4588d437-6308-0b6c-50e9-964a877b833f@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4588d437-6308-0b6c-50e9-964a877b833f@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 03:30:20PM -0700, Shannon Nelson wrote:
> On 6/20/19 7:32 PM, Michal Kubecek wrote:
> > On Thu, Jun 20, 2019 at 01:24:19PM -0700, Shannon Nelson wrote:
> > > +	if (ring->tx_pending > IONIC_MAX_TXRX_DESC ||
> > > +	    ring->tx_pending < IONIC_MIN_TXRX_DESC ||
> > > +	    ring->rx_pending > IONIC_MAX_TXRX_DESC ||
> > > +	    ring->rx_pending < IONIC_MIN_TXRX_DESC) {
> > > +		netdev_info(netdev, "Descriptors count must be in the range [%d-%d]\n",
> > > +			    IONIC_MIN_TXRX_DESC, IONIC_MAX_TXRX_DESC);
> > > +		return -EINVAL;
> > > +	}
> > The upper bounds have been already checked in ethtool_set_ringparam() so
> > that the two conditions can never be satisfied here.
> > 
> > ...
> > > +static int ionic_set_channels(struct net_device *netdev,
> > > +			      struct ethtool_channels *ch)
> > > +{
> > > +	struct lif *lif = netdev_priv(netdev);
> > > +	bool running;
> > > +
> > > +	if (!ch->combined_count || ch->other_count ||
> > > +	    ch->rx_count || ch->tx_count)
> > > +		return -EINVAL;
> > > +
> > > +	if (ch->combined_count > lif->ionic->ntxqs_per_lif)
> > > +		return -EINVAL;
> > This has been already checked in ethtool_set_channels().
> 
> That's what I get for copying from an existing driver.  I'll check those and
> clean them up.

The checks in general code were only added recently so most drivers
probably still have their own checks.

Michal Kubecek
