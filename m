Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663B5364A2B
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 20:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbhDSS41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 14:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhDSS40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 14:56:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C8A96127C;
        Mon, 19 Apr 2021 18:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618858556;
        bh=yOf+U6tLhDqpZbEGGjSPL8C+qjxVMiQGiSAd3s3RK1U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KkDoKIWKS4T30OtUWNTuzYunhbN7kqjTY1CSQ0DbiyCliPzSx3B7HzrwRBVu6u9/q
         MAFjoD9wXRWuLzSnEV5U1JLnMsYltr1K4PiWpjOHugzx+pwyPyTfHv7dpbmd/lLYWF
         HQ2xVPn3qVrOt4BR5b2X2TaYBuWsmPqUlthSl7xOlXoUkIQCtPVdwyJjTtNslRKxJj
         jI6tngouOpmGW/PYg0AdBkVjnMVkS9khCr3DzegvuJajt8alNEcOZKGzOIco4ZJ/KZ
         EeZKwLK14nwzBwlXlNBcPvdYyPFcU5REG8jVSdDLES4rCrjJDpOFqRzLzfji8129Vp
         LRMx9URv61Wqw==
Date:   Mon, 19 Apr 2021 11:55:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next v2 6/9] ethtool: add interface to read RMON
 stats
Message-ID: <20210419115554.000e05dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YHvoABffbJQxKmfI@shredder>
References: <20210416192745.2851044-1-kuba@kernel.org>
        <20210416192745.2851044-7-kuba@kernel.org>
        <YHvoABffbJQxKmfI@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Apr 2021 11:04:16 +0300 Ido Schimmel wrote:
> On Fri, Apr 16, 2021 at 12:27:42PM -0700, Jakub Kicinski wrote:
> > +/**
> > + * struct ethtool_rmon_hist_range - byte range for histogram statistics
> > + * @low: low bound of the bucket (inclusive)
> > + * @high: high bound of the bucket (inclusive)
> > + */
> > +struct ethtool_rmon_hist_range {
> > +	u16 low;
> > +	u16 high;  
> 
> Given ETHTOOL_A_STATS_GRP_HIST_BKT_{LOW,HI} are u32, should this also be
> u32?

I felt a little bad about wasting memory in each driver. It's around
40B per driver. I thought we can adjust when needed given this is
internal to the kernel, and static checkers should have no problem
detecting truncation (or any rudimentary testing).
