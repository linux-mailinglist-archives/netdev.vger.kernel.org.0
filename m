Return-Path: <netdev+bounces-8756-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23B017258AF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:54:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27427280E1D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 903268C15;
	Wed,  7 Jun 2023 08:54:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8667A882D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:54:01 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB40B2122
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:53:26 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1q6osV-0007Pr-4n; Wed, 07 Jun 2023 16:50:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Jun 2023 16:50:51 +0800
Date: Wed, 7 Jun 2023 16:50:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: netdev@vger.kernel.org, David George <David.George@sophos.com>,
	Markus Trapp <markus.trapp@secunet.com>
Subject: Re: [PATCH] xfrm: Use xfrm_state selector for BEET input
Message-ID: <ZIBE62PYoLGzHgz7@gondor.apana.org.au>
References: <ZAr3rc+QvKs50xkm@gondor.apana.org.au>
 <ZH8OSd1ElPIKCFa+@gauss3.secunet.de>
 <ZIBCFyszqwJlZd/V@gondor.apana.org.au>
 <ZIBEMe8SXYMIuOqK@gauss3.secunet.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIBEMe8SXYMIuOqK@gauss3.secunet.de>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 10:47:45AM +0200, Steffen Klassert wrote:
>
> Hm, I thought about that one too. But x->sel.family can
> also be AF_UNSPEC, in which case we used the address
> family of the inner mode before your change.

It must not be AF_UNSPECT for BEET.  How would you even get the
inner addresses if it were UNSPEC?

With BEET the inner addresses are stored in the IPsec SA rather
than the actual packet.  So the family is also fixed for a given
SA (which we call xfrm_state).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

