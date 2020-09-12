Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AA22676B1
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgILAH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgILAH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 20:07:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B822821D91;
        Sat, 12 Sep 2020 00:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599869246;
        bh=VCGP0Ta3jQDrjHrzSsQ9OcoT49InoTvXuygrTfWMD8A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dLSHmzd75PWWSQYaZnUuYMAknfMqdHTcFspPYbmdjqcwYlrTEU6KK3K76Bb7nkHZs
         dlL93jhzmW1+9B/jShxxUFOeFDyeCVcD3FN+q8lWAJueCuOabfuRfIYqUxdYMSngXd
         kr+4m1SNYj/JoGO3U03Z1Ecc+Z/LdRqJE1+WX+po=
Date:   Fri, 11 Sep 2020 17:07:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200911234932.ncrmapwpqjnphdv5@skbuf>
References: <20200911232853.1072362-1-kuba@kernel.org>
        <20200911234932.ncrmapwpqjnphdv5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Sep 2020 02:49:32 +0300 Vladimir Oltean wrote:
> On Fri, Sep 11, 2020 at 04:28:45PM -0700, Jakub Kicinski wrote:
> > Hi!
> > 
> > This is the first (small) series which exposes some stats via
> > the corresponding ethtool interface. Here (thanks to the
> > excitability of netlink) we expose pause frame stats via
> > the same interfaces as ethtool -a / -A.
> > 
> > In particular the following stats from the standard:
> >  - 30.3.4.2 aPAUSEMACCtrlFramesTransmitted
> >  - 30.3.4.3 aPAUSEMACCtrlFramesReceived
> > 
> > 4 real drivers are converted, hopefully the semantics match
> > the standard.
> > 
> > v2:
> >  - netdevsim: add missing static
> >  - bnxt: fix sparse warning
> >  - mlx5: address Saeed's comments
> 
> DSA used to override the "ethtool -S" callback of the host port, and
> append its own CPU port counters to that.
> 
> So you could actually see pause frames transmitted by the host port and
> received by the switch's CPU port:
> 
> # ethtool -S eno2 | grep pause
> MAC rx valid pause frames: 1339603152
> MAC tx valid pause frames: 0
> p04_rx_pause: 0
> p04_tx_pause: 1339603152
> 
> With this new command what's the plan?

Sounds like something for DSA folks to decide :)

What does ethtool -A $cpu_port control? 
The stats should match what the interface controls.
