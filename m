Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31166C6E2C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjCWQzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjCWQzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:55:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47398B5
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 09:54:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDC25B812A5
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 16:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F15DC433EF;
        Thu, 23 Mar 2023 16:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679590496;
        bh=AG+rpzLNpv4x2E7NX1mCHpKhMdcR6O7O2/+7wf3QgS0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XDSY965pMw/iKkRN7tAWKYu5HOBr+p2J9kUw905iLz6y/M4e8CDD6nITNEcXIHi6D
         Ey4wFlOGntjtJXgWsvgy95Az0/ef6b/29e9TfDERlBQ3WjRpI4yhrG9vlt2rsDj+QU
         lg7wu4xTk4elodAQNCMz42U+XNj0oxs1cLXWabjoTFrgv+C+yRuv6dh30bMaV7w1GC
         I0nNZm+rwbdePL9KPooWL2k6vIjB8VZlQfU0XGSyoUi0jFjRUUEr21SpLbfSNp6bqH
         EHzsN4vjUw9Kk1/sqs3cuU45B4ietMwp6CGctRJmVIrLS8bCRUwli8OOvUoB+azv3P
         9FaQ0a3C8uHDg==
Date:   Thu, 23 Mar 2023 09:54:54 -0700
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
Message-ID: <20230323095454.048d7130@kernel.org>
In-Reply-To: <pj41zlmt432zea.fsf@u570694869fb251.ant.amazon.com>
References: <20230320132523.3203254-1-shayagr@amazon.com>
        <20230320132523.3203254-2-shayagr@amazon.com>
        <ed1b26c32307ecfc39da3eaba474645280809dec.camel@redhat.com>
        <pj41zlsfdxymx0.fsf@u570694869fb251.ant.amazon.com>
        <20230322114041.71df75d1@kernel.org>
        <pj41zlmt432zea.fsf@u570694869fb251.ant.amazon.com>
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

On Thu, 23 Mar 2023 18:38:59 +0200 Shay Agroskin wrote:
> Couldn't find a way to avoid both code duplication and evaluating 
> extact only once \= Submitted a new patchset with the modified 
> version of this macro.

That's why we have the local variable called __extack, that we *can*
use multiple times, because it's a separate variable, (extack) is
evaluated only once, to initialize it...

We don't need to copy the string formatting, unless I'm missing
something. Paolo was just asking for:

-	NL_SET_ERR_MSG_FMT(extack, fmt, ##args);
+	NL_SET_ERR_MSG_FMT(__extack, fmt, ##args);

that's it.
