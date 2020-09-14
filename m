Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACA4269231
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgINQzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgINQyg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 12:54:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6471206E9;
        Mon, 14 Sep 2020 16:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600102475;
        bh=fP15H/15dS+xAJ3djePwiOgB85avh1CjcAz7gaPQ9vE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BaX+END4hylE7AEpC6Bgxe8geQkcjG2cTCCovXempYQLsn17Wgcs1IgGI/COABLXI
         DzkPskSrYtvMXkRRuK0Yp5TceNualpVgMeuVocZcIJ809n7g5XrUQs8lWuFaCGGbC/
         AOPuphdsxkZ9FSl3ShzeEBKt1me2mUmWLDpkOPjM=
Date:   Mon, 14 Sep 2020 09:54:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200914095432.091d9545@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b3f766f9-498a-a529-0e37-c6afa440dbd5@gmail.com>
References: <20200911232853.1072362-1-kuba@kernel.org>
        <20200911234932.ncrmapwpqjnphdv5@skbuf>
        <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200912001542.fqn2hcp35xkwqoun@skbuf>
        <20200911174246.76466eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <08108451-6f6a-6e89-4d2d-52e064b1342c@gmail.com>
        <20200914085306.5e00833b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b3f766f9-498a-a529-0e37-c6afa440dbd5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 09:25:44 -0700 Florian Fainelli wrote:
> >> Can we consider using get_ethtool_stats and ETH_SS_PAUSE_STATS as a
> >> stringset identifier? That way there is a single point within driver to
> >> fetch stats.  
> > 
> > Can you say more? There are no strings reported in this patch set.  
> 
> What I am suggesting is that we have a central and unique method for 
> drivers to be called for all ethtool statisitcs to be obtained, and not 
> create another ethtool operation specifically for pause stats.

That won't work for statistics which correspond to a non-singleton
object, like queue stats.

> Today we have get_ethtool_stats and a stringset argument that tells you 
> which type of statistic to return. I am not suggesting that we return 
> strings or that it should be necessary for fetching pause stats.

A multiplexer call or a call that dumps everything and then core picks
out what it needs?
