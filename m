Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5A222E7B4
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 10:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgG0I1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 04:27:51 -0400
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:48704 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726139AbgG0I1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 04:27:50 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id C23DD1730850;
        Mon, 27 Jul 2020 08:27:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3870:3872:3873:4321:4605:5007:10004:10400:10848:11026:11232:11473:11658:11914:12043:12297:12438:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: sleet04_270be7a26f5f
X-Filterd-Recvd-Size: 2386
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Mon, 27 Jul 2020 08:27:48 +0000 (UTC)
Message-ID: <ae9d562ec9ef765dddd1491d4cfb5f6d18f7025f.camel@perches.com>
Subject: Re: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg
 uses
From:   Joe Perches <joe@perches.com>
To:     Pkshih <pkshih@realtek.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Mon, 27 Jul 2020 01:27:47 -0700
In-Reply-To: <1595830034.12227.7.camel@realtek.com>
References: <cover.1595706419.git.joe@perches.com>
         <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
         <1595830034.12227.7.camel@realtek.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-07-27 at 06:07 +0000, Pkshih wrote:
> On Sat, 2020-07-25 at 12:55 -0700, Joe Perches wrote:
> > Make these statements a little simpler.
[]
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
[]
> > @@ -874,11 +874,10 @@ static void halbtc_display_wifi_status(struct
> > btc_coexist *btcoexist,
> >  	seq_printf(m, "\n %-35s = %s / %s/ %s/ AP=%d ",
> >  		   "Wifi freq/ bw/ traffic",
> >  		   gl_btc_wifi_freq_string[wifi_freq],
> > -		   ((wifi_under_b_mode) ? "11b" :
> > -		    gl_btc_wifi_bw_string[wifi_bw]),
> > -		   ((!wifi_busy) ? "idle" : ((BTC_WIFI_TRAFFIC_TX ==
> > -					      wifi_traffic_dir) ? "uplink" :
> > -					     "downlink")),
> > +		   wifi_under_b_mode ? "11b" : gl_btc_wifi_bw_string[wifi_bw],
> > +		   (!wifi_busy ? "idle" :
> > +		    wifi_traffic_dir == BTC_WIFI_TRAFFIC_TX ? "uplink" :
> > +		    "downlink"),
> 
> I think this would be better
> 
> +		   !wifi_busy ? "idle" :
> +		   (wifi_traffic_dir == BTC_WIFI_TRAFFIC_TX ? "uplink" :
> +		    "downlink"),

It seems most repeated test1 ? : test2 ? : test3 ?:
uses do not have the style you suggest in the kernel.


