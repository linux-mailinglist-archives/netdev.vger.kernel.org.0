Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377EF579174
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbiGSDsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiGSDsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:48:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AF92018B;
        Mon, 18 Jul 2022 20:48:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BF3E6148D;
        Tue, 19 Jul 2022 03:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74356C341C6;
        Tue, 19 Jul 2022 03:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658202496;
        bh=BiRI6dOA+2XNqBoOR1k5PTxKo8LdwxUSf3mdzgDWbnA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F+CF/J+pN+DErWBK2f1D/Ta37qGWByTFnDuvVbg+h4lCFhFp5zsh0+F6aUBpTg3mk
         3jmwTurZF9YxXtSk+yz4r03bNs1mhYBog4nnnqdcc8TkqElsEAoPWeKU459Z3Fl2cp
         YOadD9c629dk3x3LkeLUFaEonbrlu5TYe2E8muX9faKz45UH1Kr9YGKzlrzSafLoyT
         jRkwie0wqSIQTX/NrQLYmLxggKyYjo75ZBZF/93S8hQ1KnTo42HMchxojq0+MPTR4B
         BhpkCSMG25ScZtp2uSJPQrrFg/zEPcFktB2geHYz/9mx/QfbQUC5usxkTQ0NlliykL
         vjWbWWe2yNpEQ==
Date:   Mon, 18 Jul 2022 20:48:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jason@zx2c4.com
Subject: Re: [PATCH 0/2] crypto: make the sha1 library optional
Message-ID: <YtYpfqhtN5gH1yR5@sol.localdomain>
References: <YtEqWH2JzolCfLRA@gondor.apana.org.au>
 <e90e0d6e-b4e5-b708-a431-cec27379bf51@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e90e0d6e-b4e5-b708-a431-cec27379bf51@infradead.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 10:49:07AM -0700, Randy Dunlap wrote:
> 
> 
> On 7/15/22 01:50, Herbert Xu wrote:
> > Eric Biggers <ebiggers@kernel.org> wrote:
> >> This series makes it possible to build the kernel without SHA-1 support,
> >> although for now this is only possible in minimal configurations, due to
> >> the uses of SHA-1 in the networking subsystem.
> >>
> >> Eric Biggers (2):
> >>  crypto: move lib/sha1.c into lib/crypto/
> >>  crypto: make the sha1 library optional
> >>
> >> crypto/Kconfig          | 1 +
> >> init/Kconfig            | 1 +
> >> lib/Makefile            | 2 +-
> >> lib/crypto/Kconfig      | 3 +++
> >> lib/crypto/Makefile     | 3 +++
> >> lib/{ => crypto}/sha1.c | 0
> >> net/ipv6/Kconfig        | 1 +
> >> 7 files changed, 10 insertions(+), 1 deletion(-)
> >> rename lib/{ => crypto}/sha1.c (100%)
> >>
> >>
> >> base-commit: 79e6e2f3f3ff345947075341781e900e4f70db81
> > 
> > All applied.  Thanks.
> 
> Eric,
> linux-next-20220718 has a build error:
> 
> ERROR: modpost: missing MODULE_LICENSE() in lib/crypto/libsha1.o

Thanks, https://lore.kernel.org/r/20220719030415.32113-1-ebiggers@kernel.org
fixes this.

- Eric
