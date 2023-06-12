Return-Path: <netdev+bounces-10095-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41FD872C35E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:47:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50FEC28106F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F95118C25;
	Mon, 12 Jun 2023 11:47:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E965AD3C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:46:59 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A92E10D4
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 04:46:40 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id E99CE206BC;
	Mon, 12 Jun 2023 13:46:37 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id krln-obdjx8S; Mon, 12 Jun 2023 13:46:37 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 63230201AA;
	Mon, 12 Jun 2023 13:46:37 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
	by mailout2.secunet.com (Postfix) with ESMTP id 5D5A680004A;
	Mon, 12 Jun 2023 13:46:37 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 13:46:37 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 12 Jun
 2023 13:46:36 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id A05883182B1E; Mon, 12 Jun 2023 13:46:36 +0200 (CEST)
Date: Mon, 12 Jun 2023 13:46:36 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <netdev@vger.kernel.org>, David George <David.George@sophos.com>, "Markus
 Trapp" <markus.trapp@secunet.com>
Subject: Re: [PATCH] xfrm: Use xfrm_state selector for BEET input
Message-ID: <ZIcFnC/W7i6/Nu2C@gauss3.secunet.de>
References: <ZAr3rc+QvKs50xkm@gondor.apana.org.au>
 <ZH8OSd1ElPIKCFa+@gauss3.secunet.de>
 <ZIBCFyszqwJlZd/V@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZIBCFyszqwJlZd/V@gondor.apana.org.au>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 04:38:47PM +0800, Herbert Xu wrote:
> On Tue, Jun 06, 2023 at 12:45:29PM +0200, Steffen Klassert wrote:
> >
> > the assumption that the L4 protocol on BEET mode can be
> > just IPIP or BEETPH seems not to be correct. One of
> > our testcaces hit the second WARN_ON_ONCE() in
> > xfrm_prepare_input. In that case the L4 protocol
> > is UDP. Looks like we need some other way to
> > dertermine the inner protocol family.
> 
> Oops, that was a thinko on my part:
> 
> ---8<---
> For BEET the inner address and therefore family is stored in the
> xfrm_state selector.  Use that when decapsulating an input packet
> instead of incorrectly relying on a non-existent tunnel protocol.
> 
> Fixes: 5f24f41e8ea6 ("xfrm: Remove inner/outer modes from input path")
> Reported-by: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks a lot Herbert!

