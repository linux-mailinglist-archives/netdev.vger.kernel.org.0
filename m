Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A31269182
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgINQ3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgINQ1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 12:27:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4273F217BA;
        Mon, 14 Sep 2020 16:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600100820;
        bh=RsPOSnwEfB4jmnRCxdJ9v6CFMT39KVzekk1n7z9V92U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KvkPLBIG+R6vvwpD7aFEO5Eo3uphQX5xB91TDBq+2SzJSnwbpJyx4OH7XgzW7wPLO
         DEBWMZdsye/jPnKaGT+8DDCGOs3flhbihUJzMCq/sIoYN6+SHMaKYZgwMyGxuIcC1r
         wdymttXDCLmqd04l2O43PvNwe3NYHDFq9TTLS9yk=
Date:   Mon, 14 Sep 2020 09:26:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200914092658.6224045f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914020814.GE3463198@lunn.ch>
References: <20200911232853.1072362-1-kuba@kernel.org>
        <20200911234932.ncrmapwpqjnphdv5@skbuf>
        <20200914020814.GE3463198@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 04:08:14 +0200 Andrew Lunn wrote:
> > DSA used to override the "ethtool -S" callback of the host port, and
> > append its own CPU port counters to that.  
> 
> That was always a hack. It was bound to break sooner or later.
> 
> Ido planned to add statistics to devlink. I hope we can make use of
> that to replace the CPU port statistics, and also add DSA port
> statistics, since these interfaces do exist in devlink.

I considered devlink but it really doesn't make much sense to me to
configure something via ethtool and have its stats in devlink. If
devlink was the way to go then the config interface should have been
added there, too. And it wasn't (we just merged ethtool-nl for pause 
a couple of releases ago). Besides, doesn't it go against our "Linux 
is in control policy" to facilitate ports that don't have netdevs?
Especially making a precedent like this for completely symmetrical
pause frame config and stats does not seem like the right trade off 
to me.
