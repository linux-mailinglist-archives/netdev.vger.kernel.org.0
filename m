Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD4C5660CB
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 03:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbiGEBvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 21:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiGEBvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 21:51:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E5CDF4B;
        Mon,  4 Jul 2022 18:51:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53D26B812AC;
        Tue,  5 Jul 2022 01:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D97C3411E;
        Tue,  5 Jul 2022 01:50:58 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Zr3SHVNW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656985857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WbSjik6ZXhz2AWMzWDAKphgd0y+QDxfwhl3vmZPu1E4=;
        b=Zr3SHVNWmr/ail6wyTbTnCa3YlnZ7OaQZdCH1M6xZc7p423Gb0d79HA5prheHQwyMzH9NU
        IXTopJB5lZXrdKt7MvjWFXtKZPgjyM0Y6Qq91dy64kjzmRKuzYCSZazRlhap6W+fhwpQKf
        HM4k8X98DhL2XrSRDCkvUloWToUXnpc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d1aa160f (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 5 Jul 2022 01:50:57 +0000 (UTC)
Date:   Tue, 5 Jul 2022 03:50:53 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireguard: Kconfig: select CRYPTO_CHACHA_S390
Message-ID: <YsOY/eWq7gRjXJK1@zx2c4.com>
References: <20220704191535.76006-1-vdronov@redhat.com>
 <YsOKj/GE2Mb2UsYa@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YsOKj/GE2Mb2UsYa@zx2c4.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 02:49:19AM +0200, Jason A. Donenfeld wrote:
> Hi Vladis,
> 
> On Mon, Jul 04, 2022 at 09:15:35PM +0200, Vladis Dronov wrote:
> > Select the new implementation of CHACHA20 for S390 when available,
> > it is faster than the generic software implementation.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Link: https://lore.kernel.org/linux-kernel/202207030630.6SZVkrWf-lkp@intel.com/
> > Signed-off-by: Vladis Dronov <vdronov@redhat.com>
> > ---
> >  drivers/net/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > index b2a4f998c180..8c1eeb5a8db8 100644
> > --- a/drivers/net/Kconfig
> > +++ b/drivers/net/Kconfig
> > @@ -94,6 +94,7 @@ config WIREGUARD
> >  	select CRYPTO_CURVE25519_NEON if ARM && KERNEL_MODE_NEON
> >  	select CRYPTO_CHACHA_MIPS if CPU_MIPS32_R2
> >  	select CRYPTO_POLY1305_MIPS if MIPS
> > +	select CRYPTO_CHACHA_S390 if S390
> >  	help
> >  	  WireGuard is a secure, fast, and easy to use replacement for IPSec
> >  	  that uses modern cryptography and clever networking tricks. It's
> > -- 
> > 2.36.1
> 
> Thanks for the patch. Queued up as:
> https://git.zx2c4.com/wireguard-linux/commit/?id=1b4ab028730cd00c144eaa51160865504b780961
> 
> I'll include this in my series to net.git soon.

This actually leads to a minor problem:

  WARNING: unmet direct dependencies detected for CRYPTO_CHACHA_S390
    Depends on [n]: CRYPTO [=y] && CRYPTO_HW [=n] && S390 [=y]

This is of course harmless, since this doesn't *actually* depend on
CRYPTO_HW. In fact, the dependency on CRYPTO_HW is entirely a mistake
here that was repeated a few times. I cleaned this up and fixed it in
this patch:

    https://lore.kernel.org/linux-crypto/20220705014653.111335-1-Jason@zx2c4.com/

So hopefully Herbert will take that for 5.19 and then we'll be all set
here.

Jason
