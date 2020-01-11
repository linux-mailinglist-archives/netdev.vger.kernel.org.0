Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4955613816D
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 14:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgAKN1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 08:27:45 -0500
Received: from mx3.wp.pl ([212.77.101.9]:26582 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729013AbgAKN1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 08:27:45 -0500
Received: (wp-smtpd smtp.wp.pl 25287 invoked from network); 11 Jan 2020 14:27:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1578749261; bh=saJZ03Jk+Uudsh+OW8YaAgNrV0VFbZUt+Pm52nCWqHI=;
          h=From:To:Cc:Subject;
          b=TRi+wMjzOoQCvXbk8xktoZe9A+sAxolCswVlz7ijiMzE6uy3TTUITxV3nj2z7xFCG
           7vKznWdVihJkBHwBlOl+AzoM9VxnE/0p13cA8leQI+vIJH/9mA5O1bNC00lgZ3f0Ug
           f1Uq5MBz/VeLR4nLuc2wd8N86ZaQWclFLMo99xBk=
Received: from c-73-93-4-247.hsd1.ca.comcast.net (HELO cakuba.netronome.com) (kubakici@wp.pl@[73.93.4.247])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <sunil.kovvuri@gmail.com>; 11 Jan 2020 14:27:41 +0100
Date:   Sat, 11 Jan 2020 05:27:24 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christina Jacob <cjacob@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH 14/17] octeontx2-pf: Add basic ethtool support
Message-ID: <20200111052724.768f5e25@cakuba.netronome.com>
In-Reply-To: <CA+sq2Ccr5jB1cBN62Y56C=19L-P7hgYPrD9o7EJN71Kroou9Ew@mail.gmail.com>
References: <1578656521-14189-1-git-send-email-sunil.kovvuri@gmail.com>
        <1578656521-14189-15-git-send-email-sunil.kovvuri@gmail.com>
        <20200110112808.4970c92e@cakuba.netronome.com>
        <CA+sq2Ccr5jB1cBN62Y56C=19L-P7hgYPrD9o7EJN71Kroou9Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 7f6e80926fbbdc8a4a0d974ea9bcb3ce
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [8SNE]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Jan 2020 14:17:45 +0530, Sunil Kovvuri wrote:
> On Sat, Jan 11, 2020 at 12:58 AM Jakub Kicinski wrote:
> > On Fri, 10 Jan 2020 17:11:58 +0530, sunil.kovvuri@gmail.com wrote:  
> > > +static const struct otx2_stat otx2_dev_stats[] = {
> > > +     OTX2_DEV_STAT(rx_bytes),
> > > +     OTX2_DEV_STAT(rx_frames),
> > > +     OTX2_DEV_STAT(rx_ucast_frames),
> > > +     OTX2_DEV_STAT(rx_bcast_frames),
> > > +     OTX2_DEV_STAT(rx_mcast_frames),
> > > +     OTX2_DEV_STAT(rx_drops),
> > > +
> > > +     OTX2_DEV_STAT(tx_bytes),
> > > +     OTX2_DEV_STAT(tx_frames),
> > > +     OTX2_DEV_STAT(tx_ucast_frames),
> > > +     OTX2_DEV_STAT(tx_bcast_frames),
> > > +     OTX2_DEV_STAT(tx_mcast_frames),
> > > +     OTX2_DEV_STAT(tx_drops),
> > > +};  
> >
> > Please don't duplicate the same exact stats which are exposed via
> > ndo_get_stats64 via ethtool.  
> 
> ndo_stats64 doesn't have separate stats for ucast, mcast and bcast on Rx and
> Tx sides, they are combined ones. Hence added separate stats here.
> The ones repeated here are bytes, frames and drops which are added to have
> full set of stats at one place which could help anyone debugging pkt
> drop etc issues.

Same exact as in bytes, frames, and drops are exactly the same rather
than e.g. one being counted by hardware and the other by software.

No objection to reporting the *cast stats broken out via ethtool.
