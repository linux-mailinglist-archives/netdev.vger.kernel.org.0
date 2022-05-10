Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D386F522655
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 23:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbiEJVb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 17:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbiEJVbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 17:31:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4CF4B43E;
        Tue, 10 May 2022 14:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ABF061694;
        Tue, 10 May 2022 21:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5728C385CA;
        Tue, 10 May 2022 21:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652218264;
        bh=qMN+5WDoS3UIEh8Xz7V+tC8QRCRZGmauwtSb43rY0QI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dbb4gITNAKvNAM2A7SQHuN4sjH0ThxDvf1mYtJsvVK8M9WSOtokL91cedxypRFt2G
         a8HN4fRmmy+PI8pJABzCSGpcPEISz3tdnM5ruPnfS12BZ0VGadXUzdbwQu9BnqBTrA
         e4PxJcV6XAaU/Su2GdYfC8RwXFIodXbm3YldBLJkWe1V+XuUpyuGG5Tg7qYdtn8Xig
         puIMhAAznC/E6xm8Vio1vMva2QHCr75oouro6gqs6xuNwKHPI+2mZC6sKErcVfZnOt
         LTbFjJQqMTLK7leDW1amQ7OE8PrtCHs5ubIsChp9DvZaTjBo2yYdK+qAL8+e1daem/
         VYFh6wA8mD9Eg==
Date:   Tue, 10 May 2022 14:31:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Matti Vaittinen <Matti.Vaittinen@fi.rohmeurope.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        hariprasad <hkelam@marvell.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 06/22] octeontx2: use bitmap_empty() instead of
 bitmap_weight()
Message-ID: <20220510143102.3da4498e@kernel.org>
In-Reply-To: <20220510154750.212913-7-yury.norov@gmail.com>
References: <20220510154750.212913-1-yury.norov@gmail.com>
        <20220510154750.212913-7-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 May 2022 08:47:34 -0700 Yury Norov wrote:
> bitmap_empty() is better than bitmap_weight() because it may return
> earlier, and improves on readability.

resend patches 6 and 9 separately please. if you CC the ML only on 
a portion of the patches our build bot will ignore it.
