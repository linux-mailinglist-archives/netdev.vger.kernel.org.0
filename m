Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0664722FE4A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 02:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgG1ADU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 20:03:20 -0400
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:35802 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726171AbgG1ADU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 20:03:20 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 0EE3F18225DF5;
        Tue, 28 Jul 2020 00:03:19 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3868:3871:3872:4321:4605:5007:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12297:12438:12740:12760:12895:13069:13311:13357:13439:14096:14097:14180:14181:14659:14721:14877:21060:21080:21627:21939:21987:30012:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: owner27_5f0264426f65
X-Filterd-Recvd-Size: 2596
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Tue, 28 Jul 2020 00:03:17 +0000 (UTC)
Message-ID: <940c318b59c3c3e945c80216699299d051f8b4c5.camel@perches.com>
Subject: Re: [PATCH][next] ath11k: Use fallthrough pseudo-keyword
From:   Joe Perches <joe@perches.com>
To:     Julian Calaby <julian.calaby@gmail.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date:   Mon, 27 Jul 2020 17:03:16 -0700
In-Reply-To: <CAGRGNgW4VB1F9TdHf1Kg6WQtgHyH-ZKAnZ0kU5eKQaqUWHwbqg@mail.gmail.com>
References: <20200727194415.GA1275@embeddedor>
         <70ed74d65b5909615c7a9430f3479695465d3b1d.camel@perches.com>
         <CAGRGNgW4VB1F9TdHf1Kg6WQtgHyH-ZKAnZ0kU5eKQaqUWHwbqg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-07-28 at 09:44 +1000, Julian Calaby wrote:
> Hi Joe,
> 
> On Tue, Jul 28, 2020 at 5:48 AM Joe Perches <joe@perches.com> wrote:
> > On Mon, 2020-07-27 at 14:44 -0500, Gustavo A. R. Silva wrote:
> > > Replace the existing /* fall through */ comments and its variants with
> > > the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
> > > fall-through markings when it is the case.
> > []
> > > diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
> > []
> > > @@ -159,7 +159,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
> > >                       break;
> > >               }
> > >               /* follow through when ring_num >= 3 */
> > > -             /* fall through */
> > > +             fallthrough;
> > 
> > Likely the /* follow through ... */ comment can be deleted too
> 
> If the "when ring_num >= 3" comment is needed, how should this get
> formatted? Maybe something like:
> 
> fallthrough; /* when ring_num >= 3 */

Likely, or just removed as the test above is fairly clear

Existing code:

	case HAL_WBM2SW_RELEASE:
		if (ring_num < 3) {
			params.intr_batch_cntr_thres_entries =
					HAL_SRNG_INT_BATCH_THRESHOLD_TX;
			params.intr_timer_thres_us =
					HAL_SRNG_INT_TIMER_THRESHOLD_TX;
			break;
		}
		/* follow through when ring_num >= 3 */
		/* fall through */
	case HAL_REO_EXCEPTION:


