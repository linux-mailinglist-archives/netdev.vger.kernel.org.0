Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7438864F802
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 07:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiLQGo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 01:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLQGoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 01:44:39 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990905F88
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 22:44:37 -0800 (PST)
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id B1A3B20034;
        Sat, 17 Dec 2022 14:44:29 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1671259471;
        bh=dCmqYW6G9cXSdrt/GzjLyEOcLdcRGHjfVPYVNRaR2GI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References;
        b=CQaoHTTlEJuU7hCS/1Q/8H4JsSIM7+AH+NRYTPSf+o3TBo7yxb9eRuCcX7LWP0hCG
         d2SQVhAtnkGwS/452TS6ZvFIkuI3RhTeKDimN9xoGtdpm2ZWcvy/eMLa0T5yQ5uMs4
         Q/S6tdeA8aHz8ApWVbi2UlW2wHPlvfWNrqsn+IyliMspv7yqYXCRr4HIXgWmiACXjq
         BcvlD8uViBZBd1DeMvPSRb8whCR3oW1quaZI50Sg9xTpkh3W9qWoAzyIIRp18fVW4i
         rHU0wclcPrRP5xGMquvW5uYCDewZqjO9wVFyEL6ApTojYUYg2T6ZRisHq7GWIQr6g0
         vQqj6ik2dHwuA==
Message-ID: <6d07e45e6237f24ec32a723e747dd070fb53bea7.camel@codeconstruct.com.au>
Subject: Re: [PATCH net] mctp: serial: Fix starting value for frame check
 sequence
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Harsh Tyagi <harshtya@google.com>
Date:   Sat, 17 Dec 2022 14:44:29 +0800
In-Reply-To: <2eecaca2d1066d51d136a8d95b5cd2fd19e5e111.camel@gmail.com>
References: <20221216034409.27174-1-jk@codeconstruct.com.au>
         <2eecaca2d1066d51d136a8d95b5cd2fd19e5e111.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Alexander.

> Since the starting value isn't unique would it possibly be worthwhile
> to look at adding a define to include/linux/crc-ccitt.h to be used to
> handle the cases where the initial value is 0xffff? I notice there
> seems to only be two starting values 0 and 0xffff for all callers so
> it might make sense to centralize it in one place.

Yep, that would make sense if they're commonly used values, but I'm not
sure that would be suitable to include that in this fix, as it would
just add disruption to any backport work.

Cheers,


Jeremy
