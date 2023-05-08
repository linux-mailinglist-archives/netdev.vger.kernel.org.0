Return-Path: <netdev+bounces-775-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 188FC6F9E18
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 05:10:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D1E2280EB4
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 03:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C380E125D4;
	Mon,  8 May 2023 03:10:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B261D320A
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 03:10:36 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DF37EC8
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 20:10:30 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1pvrGN-006K04-9S; Mon, 08 May 2023 11:10:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 08 May 2023 11:10:12 +0800
Date: Mon, 8 May 2023 11:10:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tobias Brunner <tobias@strongswan.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, netdev@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec] af_key: Reject optional tunnel/BEET mode templates
 in outbound policies
Message-ID: <ZFhoFBrOREHcify3@gondor.apana.org.au>
References: <6dcb6a58-2699-9cde-3e34-57c142dbcf14@strongswan.org>
 <ZEdmdDAwnuslrdvA@gondor.apana.org.au>
 <8b8dbbc4-f956-8cbf-3700-1da366357a6f@strongswan.org>
 <ZEePE9LMA0pWxz9r@gondor.apana.org.au>
 <5d5bf4d9-5b63-ae0d-2f65-770e911ea7d6@strongswan.org>
 <ZFTd459F8fi+KfxM@gondor.apana.org.au>
 <46fcb205-989e-4ea7-463d-e72b85db9e71@strongswan.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46fcb205-989e-4ea7-463d-e72b85db9e71@strongswan.org>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 01:36:15PM +0200, Tobias Brunner wrote:
> xfrm_state_find() uses `encap_family` of the current template with
> the passed local and remote addresses to find a matching state.
> If an optional tunnel or BEET mode template is skipped in a mixed-family
> scenario, there could be a mismatch causing an out-of-bounds read as
> the addresses were not replaced to match the family of the next template.
> 
> While there are theoretical use cases for optional templates in outbound
> policies, the only practical one is to skip IPComp states in inbound
> policies if uncompressed packets are received that are handled by an
> implicitly created IPIP state instead.
> 
> Signed-off-by: Tobias Brunner <tobias@strongswan.org>
> ---
>  net/key/af_key.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

