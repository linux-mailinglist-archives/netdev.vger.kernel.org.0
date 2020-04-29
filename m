Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F09F1BD3BD
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 06:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgD2EbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 00:31:13 -0400
Received: from smtprelay0037.hostedemail.com ([216.40.44.37]:43600 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726305AbgD2EbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 00:31:13 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id C1819181D341E;
        Wed, 29 Apr 2020 04:31:12 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1381:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3872:3873:4250:4321:4605:5007:7875:10004:10400:10848:11026:11232:11473:11658:11914:12043:12048:12296:12297:12438:12555:12740:12760:12895:12986:13069:13138:13161:13229:13231:13311:13357:13439:14181:14659:14721:14777:21080:21433:21627:30029:30046:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: salt06_61b932e2e7907
X-Filterd-Recvd-Size: 2810
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Wed, 29 Apr 2020 04:31:11 +0000 (UTC)
Message-ID: <0dcf9712a49968da1935061de130bc3668e63088.camel@perches.com>
Subject: Re: [PATCH 1/3] staging: qlge: Remove multi-line dereferences from
 qlge_main.c
From:   Joe Perches <joe@perches.com>
To:     Rylan Dmello <mail@rylan.coffee>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 28 Apr 2020 21:31:10 -0700
In-Reply-To: <aae9feb569c60758ab09c923c09b600295f4cb32.1588132908.git.mail@rylan.coffee>
References: <aae9feb569c60758ab09c923c09b600295f4cb32.1588132908.git.mail@rylan.coffee>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-04-29 at 00:04 -0400, Rylan Dmello wrote:
> Fix checkpatch.pl warnings:
> 
>   WARNING: Avoid multiple line dereference - prefer 'qdev->func'
>   WARNING: Avoid multiple line dereference - prefer 'qdev->flags'

Assuming you are doing this for exercise:

It'd be better to unindent all the switch/case
blocks for the entire function so more functions
fit on single lines

	switch (foo) {
	case bar:
		{
			...;

should be:

	switch (foo) {
	case bar: {
		...;

goto exit; might as well be break; and remove
the exit label too.

> Signed-off-by: Rylan Dmello <mail@rylan.coffee>
> ---
>  drivers/staging/qlge/qlge_main.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index d7e4dfafc1a3..10daae025790 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -396,8 +396,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
>  			 * the route field to NIC core.
>  			 */
>  			cam_output = (CAM_OUT_ROUTE_NIC |
> -				      (qdev->
> -				       func << CAM_OUT_FUNC_SHIFT) |
> +				      (qdev->func << CAM_OUT_FUNC_SHIFT) |
>  					(0 << CAM_OUT_CQ_ID_SHIFT));
>  			if (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
>  				cam_output |= CAM_OUT_RV;
> @@ -3432,9 +3431,9 @@ static int ql_request_irq(struct ql_adapter *qdev)
>  				     &qdev->rx_ring[0]);
>  			status =
>  			    request_irq(pdev->irq, qlge_isr,
> -					test_bit(QL_MSI_ENABLED,
> -						 &qdev->
> -						 flags) ? 0 : IRQF_SHARED,
> +					test_bit(QL_MSI_ENABLED, &qdev->flags)
> +						? 0
> +						: IRQF_SHARED,
>  					intr_context->name, &qdev->rx_ring[0]);
>  			if (status)
>  				goto err_irq;

