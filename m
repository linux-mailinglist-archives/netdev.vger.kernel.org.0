Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04B06C8B33
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 07:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbjCYGBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 02:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCYGBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 02:01:10 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974D719685;
        Fri, 24 Mar 2023 23:01:08 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pfwx2-008XUY-Ph; Sat, 25 Mar 2023 14:00:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 25 Mar 2023 14:00:28 +0800
Date:   Sat, 25 Mar 2023 14:00:28 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     willy@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, viro@zeniv.linux.org.uk,
        hch@infradead.org, axboe@kernel.dk, jlayton@kernel.org,
        brauner@kernel.org, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH 23/28] algif: Remove hash_sendpage*()
Message-ID: <ZB6N/H27oeWqouyb@gondor.apana.org.au>
References: <ZBPTC9WPYQGhFI30@gondor.apana.org.au>
 <3763055.1679676470@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3763055.1679676470@warthog.procyon.org.uk>
X-Spam-Status: No, score=4.3 required=5.0 tests=HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 04:47:50PM +0000, David Howells wrote:
>
> I must be missing something, I think.  What's particularly optimal about the
> code in hash_sendpage() but not hash_sendmsg()?  Is it that the former uses
> finup/digest, but the latter ony does update+final?

A lot of hardware hashes can't perform partial updates, so they
will always fall back to software unless you use finup/digest.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
