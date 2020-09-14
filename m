Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5BD26958D
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 21:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgINTUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 15:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgINTUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 15:20:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB917217BA;
        Mon, 14 Sep 2020 19:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600111218;
        bh=pF1E9P9UzQnPYMTIBChc2kY99iMq+NKgxRJO+6djr0c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SLY4ageUJVdU7xnJLuWFVB/TtLAyDrJi0xYprh2cD+14OY28Rcf96fQMGTUkzGBuk
         i2TFe1zW3tGIBAHY26VciFJn/uPws0hZSukTpUVTMtcQdMXr9+78lyYupP6xg3juBV
         pxNT/GK+0yvYjXlnI1O+jjqSNp+wi8dXhIJ3xzPs=
Date:   Mon, 14 Sep 2020 12:20:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200914122016.759eb786@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914173650.GD3485708@lunn.ch>
References: <20200911232853.1072362-1-kuba@kernel.org>
        <20200911234932.ncrmapwpqjnphdv5@skbuf>
        <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200912001542.fqn2hcp35xkwqoun@skbuf>
        <20200911174246.76466eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <08108451-6f6a-6e89-4d2d-52e064b1342c@gmail.com>
        <20200914085306.5e00833b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200914173650.GD3485708@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 19:36:50 +0200 Andrew Lunn wrote:
> > > Can we consider using get_ethtool_stats and ETH_SS_PAUSE_STATS as a 
> > > stringset identifier? That way there is a single point within driver to 
> > > fetch stats.  
> > 
> > Can you say more? There are no strings reported in this patch set.  
> 
> Let me ask another question. Is pause stats the end of the story? Or
> do you plan to add more use case specific statistics?
> 
> ethtool -T|--show-time-stamping could show statistics for PTP frames
> sent/received?
> 
> ethtool --show-eee could show statistics for sleep/wake cycles?
> 
> ethtool --show-rxfh-indir could show RSS statistics?

I don't have a need for any of these. But they may make sense.

I'll add FEC stats next:

  30.5.1.1.17 aFECCorrectedBlocks
  30.5.1.1.18 aFECUncorrectableBlocks

I was tempted to add RMON stats, cause a lot of MACs expose those,
but I don't actually have a use for them personally, so it's lower 
prio.

> Would you add a new ethtool op for each of these? Or maybe we should
> duplex them all through get_ethtool_stats()?

I don't see a problem with an op for each of those. It makes for 
natural querying granularity. Works quite well for drivers converted
here, IMHO. 
