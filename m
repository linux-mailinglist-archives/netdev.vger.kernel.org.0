Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF3E6C71B1
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjCWUe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjCWUe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:34:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE798FF0E
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 13:34:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D338628A0
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 20:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C9DC433EF;
        Thu, 23 Mar 2023 20:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679603664;
        bh=LV+wPG6mP4ZGZkf70LwDcE+PYbxFku3PzFdtmsHbi4o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EQTXQigv7VN9ZWyM58fTMwQogL7bs/pPDr2SB+HTTv3Mr6J01ui1S9CLUC9SSwFXZ
         f4JVplJIg78G0wAxX4EiljH/UM7TMoUDA2/7qLvDOeYbVad6rUyMh08JARVkgjuVe7
         nKwb+q37NIPZaG0kIEvk008gEOavYExBbmhgRlRjA1VYsC6CTFW86XyGVEmmQpNdz4
         xgR842TdDn5x83w8BsZC7L5LNq39FRuWGslPXKAlU/u2HnFcxTDCDc2hLrJfnHQ0u4
         IKppPJLv1gjIbGBUfwNqfrg05FtzlKrI7T0QuRkp496Cf3SpUE6/vywb45Fc83hX25
         YERJP37A1qgyg==
Date:   Thu, 23 Mar 2023 13:34:22 -0700
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
        "Florian Westphal" <fw@strlen.de>
Subject: Re: [PATCH v6 net-next 1/7] netlink: Add a macro to set policy
 message with format string
Message-ID: <20230323133422.110d6cab@kernel.org>
In-Reply-To: <pj41zla6032qn4.fsf@u570694869fb251.ant.amazon.com>
References: <20230320132523.3203254-1-shayagr@amazon.com>
        <20230320132523.3203254-2-shayagr@amazon.com>
        <ed1b26c32307ecfc39da3eaba474645280809dec.camel@redhat.com>
        <pj41zlsfdxymx0.fsf@u570694869fb251.ant.amazon.com>
        <20230322114041.71df75d1@kernel.org>
        <pj41zlmt432zea.fsf@u570694869fb251.ant.amazon.com>
        <20230323095454.048d7130@kernel.org>
        <pj41zla6032qn4.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 21:44:52 +0200 Shay Agroskin wrote:
> > That's why we have the local variable called __extack, that we 
> > *can*
> > use multiple times, because it's a separate variable, (extack) 
> > is
> > evaluated only once, to initialize it...
> >
> > We don't need to copy the string formatting, unless I'm missing
> > something. Paolo was just asking for:  
> 
> There is an issue with shadowing __extack by NL_SET_ERR_MSG_FMT 
> causing the changes to __extack not to be propagated back to the 
> caller.
> I'm not that big of an expert in C but changing __extack -> 
> _extack fixes the shadowing issue.
> 
> Might not be the most robust solution, though it might suffice for 
> this use case.

TBH the hierarchy should be the other way around, NL_SET_ERR_MSG_FMT()
should be converted to be:

#define NL_SET_ERR_MSG_FMT(extack, attr, msg, args...) \
	NL_SET_ERR_MSG_ATTR_POL_FMT(extack, NULL, NULL, msg, ##args)

and that'd fix the shadowing, right?
