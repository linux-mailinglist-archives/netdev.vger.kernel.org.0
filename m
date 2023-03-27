Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEA76CABE3
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjC0Rdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjC0Rda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:33:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A337AF
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:33:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E44FB81733
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 17:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FCBC433D2;
        Mon, 27 Mar 2023 17:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679938404;
        bh=oQUUoLcduMMy2X1ptMcWIy3qKqq4Ar4Eq352Kc497W0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VuFbiop/HkMDZuP65Z2UR6jim2DlLzXUX1HPIW+B3pxyBV8CopmDUHP2eOd3mOz4F
         xwqUu8WUwVDamAObpzkMFxH4kq0zKmDVw+H70PK5NpJ3XcQp8So9DeFlX5i1nnKHYK
         BrR8rJ7wSEq2wON4HvYxtfMHNQ9PBHd1RY+nfsRMYQY0fu6NlChDWX6doIUozMnnwh
         AZmasR5w4UtOfPyojlJX3WNeEgizrd+r5QZ5LDquJpDQLMpegynT8T/gMdKFo2I4yU
         /Tg1Csk18Wfh+JbvAFWkuoP6R8cY45wfcgnABnzhMg4YZGXsDECkrrV1GZ8vthmqsU
         DsPkqLWbOdYKw==
Date:   Mon, 27 Mar 2023 10:33:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Saeed Bshara" <saeedb@amazon.com>,
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
        "Florian Westphal" <fw@strlen.de>
Subject: Re: [PATCH v6 net-next 1/7] netlink: Add a macro to set policy
 message with format string
Message-ID: <20230327103322.4f294683@kernel.org>
In-Reply-To: <pj41zlr0tdaq1w.fsf@u570694869fb251.ant.amazon.com>
References: <20230320132523.3203254-1-shayagr@amazon.com>
        <20230320132523.3203254-2-shayagr@amazon.com>
        <ed1b26c32307ecfc39da3eaba474645280809dec.camel@redhat.com>
        <pj41zlsfdxymx0.fsf@u570694869fb251.ant.amazon.com>
        <20230322114041.71df75d1@kernel.org>
        <pj41zlmt432zea.fsf@u570694869fb251.ant.amazon.com>
        <20230323095454.048d7130@kernel.org>
        <pj41zla6032qn4.fsf@u570694869fb251.ant.amazon.com>
        <20230323133422.110d6cab@kernel.org>
        <pj41zlr0tdaq1w.fsf@u570694869fb251.ant.amazon.com>
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

On Sat, 25 Mar 2023 16:49:34 +0300 Shay Agroskin wrote:
> > TBH the hierarchy should be the other way around, 
> > NL_SET_ERR_MSG_FMT()
> > should be converted to be:
> >
> > #define NL_SET_ERR_MSG_FMT(extack, attr, msg, args...) \
> >         NL_SET_ERR_MSG_ATTR_POL_FMT(extack, NULL, NULL, msg, 
> >         ##args)
> >
> > and that'd fix the shadowing, right?  
> 
> Well ... It will but it will contradict the current order of calls 
> as I see it.
> 
> NL_SET_ERR_MSG_FMT_MOD calls NL_SET_ERR_MSG_FMT which can be 
> described as 'the former extends the latter'.
> 
> On the other hand NL_SET_ERR_MSG_ATTR_POL implements the message 
> setting by itself and doesn't use NL_SET_ERR_MSG to set the 
> message.
> 
> So it seems like we already have two approaches for macro ordering 
> here and following your suggestion would create another type of 
> call direction of 'the former shrinks the latter by setting to 
> NULL its attributes'.
> Overall given the nature of C macros and the weird issues arise by 
> shadowing variables (ending up for some reason in not modifying 
> the pointer at all..) I'd say I mostly prefer V7 version which 
> re-implements the message setting and avoids creating such very 
> hard to find issues later.
> 
> Then again I'd follow your implementation suggestion if you still 
> prefer it (also I can modify the macro NL_SET_ERR_MSG to call 
> NL_SET_ERR_MSG_ATTR_POL to be consistent with the other change)

Alright, it doesn't matter all that much.
