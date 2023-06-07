Return-Path: <netdev+bounces-8761-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ACEF72595B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADB891C20D7C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 578C88F4D;
	Wed,  7 Jun 2023 09:04:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA0D882D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:04:52 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEB526AB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 02:04:50 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1q6p5x-0007kJ-H9; Wed, 07 Jun 2023 17:04:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Jun 2023 17:04:45 +0800
Date: Wed, 7 Jun 2023 17:04:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: netdev@vger.kernel.org, David George <David.George@sophos.com>,
	Markus Trapp <markus.trapp@secunet.com>
Subject: Re: [PATCH] xfrm: Use xfrm_state selector for BEET input
Message-ID: <ZIBILXgGQx4OF9UA@gondor.apana.org.au>
References: <ZAr3rc+QvKs50xkm@gondor.apana.org.au>
 <ZH8OSd1ElPIKCFa+@gauss3.secunet.de>
 <ZIBCFyszqwJlZd/V@gondor.apana.org.au>
 <ZIBEMe8SXYMIuOqK@gauss3.secunet.de>
 <ZIBE62PYoLGzHgz7@gondor.apana.org.au>
 <ZIBGgjWwILqQziGe@gauss3.secunet.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIBGgjWwILqQziGe@gauss3.secunet.de>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 10:57:38AM +0200, Steffen Klassert wrote:
>
> > With BEET the inner addresses are stored in the IPsec SA rather
> > than the actual packet.  So the family is also fixed for a given
> > SA (which we call xfrm_state).
> 
> Right, Good point.

We should probably add some checks in xfrm_user to ensure that
BEET-mode SAs come with valid inner addresses (and family) just
in case user-space tries something funny on us.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

