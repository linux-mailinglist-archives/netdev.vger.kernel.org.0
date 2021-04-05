Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA8F353B6A
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 06:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhDEEyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 00:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230036AbhDEEyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 00:54:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E3DC61398;
        Mon,  5 Apr 2021 04:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617598443;
        bh=VzTVAnybf+oOGdlUEfj0vhEj5VpT1Xt7TmY+rOpnhVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JRoC0fS68b3QvsXfLiL4nLpRYfxZYVeNLgr/F0hkzyhU5Ee5zf0vXE/AwKY3evxyK
         pSo0KvGbnHgDxXEoiDz9iiZRUixzwbGjC1NZG4aC6e4Qshe44eKtAQfBoYi8wFmoEA
         iUzZ5QPZRIof6Gsq/1NpLVLAJ2SiSirPUYr5Kwue6zj0mYUtUIpEJd6brfRw+374Yq
         rLARe584e4oIDnnLvKI7RABDFK6ljaPtUDQqAL8LdSdCtWCLbEpDaBh88P+yky7maY
         +6C5IxTkznqZRWb8DP8jIhjYHWVE8AYPsimWsEML0mTYhMZ7EH/OSAZBoOqbYv7kIs
         SWGIKEpyReR0A==
Date:   Mon, 5 Apr 2021 07:53:59 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, drivers@pensando.io,
        Allen Hubbe <allenbh@pensando.io>
Subject: Re: [PATCH net-next 05/12] ionic: add hw timestamp support files
Message-ID: <YGqX511MvGNiLMXi@unreal>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-6-snelson@pensando.io>
 <20210404230526.GB24720@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210404230526.GB24720@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 04, 2021 at 04:05:26PM -0700, Richard Cochran wrote:
> On Thu, Apr 01, 2021 at 10:56:03AM -0700, Shannon Nelson wrote:
> > @@ -0,0 +1,589 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright(c) 2017 - 2021 Pensando Systems, Inc */
> > +
> > +#include <linux/netdevice.h>
> > +#include <linux/etherdevice.h>
> > +
> > +#include "ionic.h"
> > +#include "ionic_bus.h"
> > +#include "ionic_lif.h"
> > +#include "ionic_ethtool.h"
> > +
> > +static int ionic_hwstamp_tx_mode(int config_tx_type)
> > +{
> > +	switch (config_tx_type) {
> > +	case HWTSTAMP_TX_OFF:
> > +		return IONIC_TXSTAMP_OFF;
> > +	case HWTSTAMP_TX_ON:
> > +		return IONIC_TXSTAMP_ON;
> > +	case HWTSTAMP_TX_ONESTEP_SYNC:
> > +		return IONIC_TXSTAMP_ONESTEP_SYNC;
> > +#ifdef HAVE_HWSTAMP_TX_ONESTEP_P2P
> > +	case HWTSTAMP_TX_ONESTEP_P2P:
> > +		return IONIC_TXSTAMP_ONESTEP_P2P;
> > +#endif
> 
> This ifdef is not needed.  (I guess you have to support older kernel
> versions, but my understanding of the policy is that new code
> shouldn't carry such stuff).

The HAVE_HWSTAMP_TX_ONESTEP_P2P don't exist in the kernel and the ifdef should
be deleted.

Thanks
