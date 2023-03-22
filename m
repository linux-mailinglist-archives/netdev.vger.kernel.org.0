Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0832D6C53E2
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjCVSkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCVSkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:40:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DF4509A2
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:40:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CB7B62214
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 18:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8809C433EF;
        Wed, 22 Mar 2023 18:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679510443;
        bh=x3g9RyP2HtNT3pqQVnu/z8rsXL3i8NvRUeh2u9qsn68=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bBYajE4jA27p82TaEHAyCtLzDmPWuOV8YTJL23NWVeboCLSGsV55tituvLGt1trhQ
         DLvsyvFVtIWmXAMPJF4i2IkNcG2caRRYc9D6WZhiZQVLrUZN/hlcl39kOxi1B3U/4d
         abzDYMiGCqKJty6xyhyU6aebzFWIHE4PNZvX+TP+pEJzTTLPOBrGK0ZNaER8CDJHdn
         cb3Ucr2XF/j2DhWa4jKWYcJuAKb/Lt8jTnady2PiyYUbK6BwH0tgQ5Rz4c4vCvBl9u
         /yJ1kye2fDapLeQujfRRKc5GnDMIdXwcGayrTvbUV4Ft8eOGuFlaUWJn/jIlcIZVfX
         FSwzPzmhCeaiQ==
Date:   Wed, 22 Mar 2023 11:40:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v6 net-next 1/7] netlink: Add a macro to set policy
 message with format string
Message-ID: <20230322114041.71df75d1@kernel.org>
In-Reply-To: <pj41zlsfdxymx0.fsf@u570694869fb251.ant.amazon.com>
References: <20230320132523.3203254-1-shayagr@amazon.com>
        <20230320132523.3203254-2-shayagr@amazon.com>
        <ed1b26c32307ecfc39da3eaba474645280809dec.camel@redhat.com>
        <pj41zlsfdxymx0.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 14:39:49 +0200 Shay Agroskin wrote:
> > You should use '__extack' even above, to avoid multiple 
> > evaluation of
> > the 'extack' expression.  
> 
> I've got to admit that I don't understand the cost of such 
> evaluations. I thought that it was added to help readers of the 
> source code to understand what is the type of this attribute and 
> have a better warning message when the wrong variable is passed 
> (kind of typing in Python which isn't strictly needed).
> What cost is there for casting a pointer ?

It's not about the cost, the macros are unfolded by the preprocessor,
in the unlikely case someone passes extack++ as an argument using it
twice inside the body of the macro will increment the value twice.

#define MACRO(arg) function_bla(arg, arg) // use arg twice

int a = 1;
MACRO(a++);
print(a); // should print 2, will print 3
