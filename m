Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB3B16A760
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbgBXNjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:39:42 -0500
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:33427 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725535AbgBXNjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:39:42 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 32A44837F24A;
        Mon, 24 Feb 2020 13:39:41 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1381:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6119:7903:9040:9389:10004:10400:10848:11026:11232:11658:11914:12043:12048:12296:12297:12740:12760:12895:13018:13019:13069:13095:13161:13229:13311:13357:13439:14659:14721:21080:21433:21611:21627:21740:30012:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:18,LUA_SUMMARY:none
X-HE-Tag: toe07_5458a77d0305a
X-Filterd-Recvd-Size: 1927
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Mon, 24 Feb 2020 13:39:39 +0000 (UTC)
Message-ID: <84410699e6acbffca960aa2944e9f5869478b178.camel@perches.com>
Subject: Re: [PATCH v4] staging: qlge: emit debug and dump at same level
From:   Joe Perches <joe@perches.com>
To:     Kaaira Gupta <kgupta@es.iitr.ac.in>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 24 Feb 2020 05:38:09 -0800
In-Reply-To: <20200224082448.GA6826@kaaira-HP-Pavilion-Notebook>
References: <20200224082448.GA6826@kaaira-HP-Pavilion-Notebook>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-02-24 at 13:54 +0530, Kaaira Gupta wrote:
> Simplify code in ql_mpi_core_to_log() by calling print_hex_dump()
> instead of existing functions so that the debug and dump are
> emitted at the same KERN_<LEVEL>
[]
> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
[]
> @@ -1324,27 +1324,10 @@ void ql_mpi_core_to_log(struct work_struct *work)
>  {
>  	struct ql_adapter *qdev =
>  		container_of(work, struct ql_adapter, mpi_core_to_log.work);
> -	u32 *tmp, count;
> -	int i;
>  
> -	count = sizeof(struct ql_mpi_coredump) / sizeof(u32);
> -	tmp = (u32 *)qdev->mpi_coredump;
> -	netif_printk(qdev, drv, KERN_DEBUG, qdev->ndev,
> -		     "Core is dumping to log file!\n");

There is no real need to delete this line.

And if you really want to, it'd be better to mention
the removal in the commit message description.

As is for this change, there is no "debug" and "dump"
as the commit message description shows, just "dump".




