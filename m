Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC14A635233
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 09:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbiKWIU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 03:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236346AbiKWIUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 03:20:24 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFD6F1DA6;
        Wed, 23 Nov 2022 00:20:19 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oxkzQ-00HThe-3M; Wed, 23 Nov 2022 16:20:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Nov 2022 16:20:16 +0800
Date:   Wed, 23 Nov 2022 16:20:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     tgraf@suug.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] lib/test_rhashtable: Remove set but unused variable
 'insert_retries'
Message-ID: <Y33XwExuTXehapvV@gondor.apana.org.au>
References: <20221123035951.10720-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123035951.10720-1-jiapeng.chong@linux.alibaba.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 11:59:51AM +0800, Jiapeng Chong wrote:
>
> @@ -447,9 +447,7 @@ static int __init test_rhashtable_max(struct test_obj *array,
>  
>  		obj->value.id = i * 2;
>  		err = insert_retry(&ht, obj, test_rht_params);
> -		if (err > 0)
> -			insert_retries += err;
> -		else if (err)
> +		if (err)

This is wrong as you will now abort on a retried insertion.  You
should instead test for err < 0.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
