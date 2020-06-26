Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CBA20AAAE
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 05:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgFZD3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 23:29:30 -0400
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:56424 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728333AbgFZD3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 23:29:30 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 07C1C100E7B40;
        Fri, 26 Jun 2020 03:29:29 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3871:3872:3874:4225:4321:5007:6742:7576:7875:7903:8603:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12297:12438:12663:12740:12760:12895:13439:14181:14659:14721:21080:21451:21627:21990:30054:30055:30064:30079:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: pail55_290cbf926e52
X-Filterd-Recvd-Size: 4319
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Fri, 26 Jun 2020 03:29:26 +0000 (UTC)
Message-ID: <2b2a00cc0198328f1a0f3c9ccb6004a611a60011.camel@perches.com>
Subject: Re: [net-next v3 13/15] iecm: Add ethtool
From:   Joe Perches <joe@perches.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Date:   Thu, 25 Jun 2020 20:29:25 -0700
In-Reply-To: <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> From: Alice Michael <alice.michael@intel.com>
> 
> Implement ethtool interface for the common module.
[]
> diff --git a/drivers/net/ethernet/intel/iecm/iecm_ethtool.c b/drivers/net/ethernet/intel/iecm/iecm_ethtool.c
[]
> +/* Stats associated with a Tx queue */
> +static const struct iecm_stats iecm_gstrings_tx_queue_stats[] = {
> +	IECM_QUEUE_STAT("%s-%u.packets", q_stats.tx.packets),
> +	IECM_QUEUE_STAT("%s-%u.bytes", q_stats.tx.bytes),
> +};
> +
> +static const struct iecm_stats iecm_gstrings_rx_queue_stats[] = {
> +	IECM_QUEUE_STAT("%s-%u.packets", q_stats.rx.packets),
> +	IECM_QUEUE_STAT("%s-%u.bytes", q_stats.rx.bytes),
> +	IECM_QUEUE_STAT("%s-%u.generic_csum", q_stats.rx.generic_csum),
> +	IECM_QUEUE_STAT("%s-%u.basic_csum", q_stats.rx.basic_csum),
> +	IECM_QUEUE_STAT("%s-%u.csum_err", q_stats.rx.csum_err),
> +	IECM_QUEUE_STAT("%s-%u.hsplit_buf_overflow", q_stats.rx.hsplit_hbo),
> +};
> +
> +#define IECM_TX_QUEUE_STATS_LEN		ARRAY_SIZE(iecm_gstrings_tx_queue_stats)
> +#define IECM_RX_QUEUE_STATS_LEN		ARRAY_SIZE(iecm_gstrings_rx_queue_stats)
> +
> +/**
> + * __iecm_add_stat_strings - copy stat strings into ethtool buffer
> + * @p: ethtool supplied buffer
> + * @stats: stat definitions array
> + * @size: size of the stats array
> + *
> + * Format and copy the strings described by stats into the buffer pointed at
> + * by p.
> + */
> +static void __iecm_add_stat_strings(u8 **p, const struct iecm_stats stats[],
> +				    const unsigned int size, ...)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < size; i++) {
> +		va_list args;
> +
> +		va_start(args, size);
> +		vsnprintf((char *)*p, ETH_GSTRING_LEN,
> +			  stats[i].stat_string, args);
> +		*p += ETH_GSTRING_LEN;
> +		va_end(args);
> +	}
> +}

Slightly dangerous to have a possible mismatch between the varargs
and the actual constant format spec.

Perhaps safer to use something like:

static const struct iecm_stats iecm_gstrings_tx_queue_stats[] = {
	IECM_QUEUE_STAT("packets", q_stats.tx.packets),
	IECM_QUEUE_STAT("bytes", q_stats.tx.bytes),
};

Perhaps use const char * and unsigned int instead of varargs
so this formats the output without va_start/end

	snprintf(*p, ETH_GSTRING_LEN, "%s-%u.%s", type, index, stats[i].stat_string);

> static void __iecm_add_stat_strings(u8 **p, const struct iecm_stats stats[],
> +
> +/**
> + * iecm_add_stat_strings - copy stat strings into ethtool buffer
> + * @p: ethtool supplied buffer
> + * @stats: stat definitions array
> + *
> + * Format and copy the strings described by the const static stats value into
> + * the buffer pointed at by p.
> + *
> + * The parameter @stats is evaluated twice, so parameters with side effects
> + * should be avoided. Additionally, stats must be an array such that
> + * ARRAY_SIZE can be called on it.
> + */
> +#define iecm_add_stat_strings(p, stats, ...) \
> +	__iecm_add_stat_strings(p, stats, ARRAY_SIZE(stats), ## __VA_ARGS__)
> +

> 

