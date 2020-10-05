Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605F02842DC
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 01:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgJEXO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 19:14:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgJEXO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 19:14:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F53E207F7;
        Mon,  5 Oct 2020 23:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601939697;
        bh=SKwPm6yRQ8NNFsrWr4UKkDn7WSJhJ29usJiduw2w3K4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IuCmXMYJ/XM9fyDGcwXioto8Fk488Hi6ZP12DBrrASyArVEZwb/u5hk6/Arh2ECAT
         5t+d7zIiDXgrEPFyn28mL5Ks2tjGCZOl8W0On9LC2SqhJCYCP8nuaePod9XwBD2HVM
         oWEnjLgBH2GFYLQIs0pQ0nsUCU7MIm/hDowjedIA=
Date:   Mon, 5 Oct 2020 16:14:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Fabian Frederick <fabf@skynet.be>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, pshelar@ovn.org, dev@openvswitch.org,
        yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru
Subject: Re: [PATCH 1/9 net-next] net: netdevice.h: sw_netstats_rx_add
 helper
Message-ID: <20201005161455.62c59f5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201005203418.55128-1-fabf@skynet.be>
References: <20201005203418.55128-1-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  5 Oct 2020 22:34:18 +0200 Fabian Frederick wrote:
> +static inline void dev_sw_netstats_rx_add(struct net_device *dev, unsigned int len)
> +{
> +	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
> +
> +	u64_stats_update_begin(&tstats->syncp);
> +	tstats->rx_bytes += len;
> +	tstats->rx_packets++;
> +	u64_stats_update_end(&tstats->syncp);
> +

checkpatch points out there is an unnecessary empty line here

> +}
