Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9495C69D8B7
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 03:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjBUCob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 21:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbjBUCo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 21:44:29 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56EB23653;
        Mon, 20 Feb 2023 18:44:19 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pUId3-00DlGh-7N; Tue, 21 Feb 2023 10:43:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Feb 2023 10:43:41 +0800
Date:   Tue, 21 Feb 2023 10:43:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 01/21] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
Message-ID: <Y/Qv3eEk+1zytBGG@gondor.apana.org.au>
References: <20230215183335.800122-1-dima@arista.com>
 <20230215183335.800122-2-dima@arista.com>
 <Y/NAXtPrOkzjLewO@gondor.apana.org.au>
 <bd40ff2f-b015-4ed4-7755-f9d547c8b868@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd40ff2f-b015-4ed4-7755-f9d547c8b868@arista.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 04:57:20PM +0000, Dmitry Safonov wrote:
. 
> Do you have a timeline for that work?
> And if you don't mind I keep re-iterating, as I'm trying to address TCP
> reviews and missed functionality/selftests.

I'm hoping to get it ready for the next merge window.
 
> 1) before your per-request key patches - it's not possible.
> 2) after your patches - my question would be: "is it better to
> kmalloc(GFP_ATOMIC) in RX/TX for every signed TCP segment, rather than
> pre-allocate it?"
> 
> The price of (2) may just well be negligible, but worth measuring before
> switching.

Please keep in mind that you're already performing crypto which
is usually a lot slower than a kmalloc.  In any case, if there is
any optimisation to be done to make the kmalloc faster by using
pools, then that optimisation should go into mm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
