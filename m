Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849766D335C
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 21:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDATMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 15:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjDATMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 15:12:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA3CB767;
        Sat,  1 Apr 2023 12:12:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65E3960F92;
        Sat,  1 Apr 2023 19:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C12EC433EF;
        Sat,  1 Apr 2023 19:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680376333;
        bh=QtwyPrGEdHyQPr04TPdFEBNu5kDohW2eNusKx77tLHM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=smderBX8iFt85qDNjnQBDPzcBY7d8v47qr9nmrovmfpcAD6H40UujiTjN5OhRpmYN
         A6yEMfOjqO7UYgAxc4iO3cPNOTaJAlYUZL6lTOjvPLYeue3u8RFe2Zvk38VBEhSaVV
         sBaBJNIXvKSb568j3U5A/20L7/cxonIJTcm1JhL42XCM+biMJEM0PbIIyFFPw0RNIl
         kP+e2CAUQz7xbz0WLzAGYLSi5NxLEg1ZSKLtu7UqXT32C6aoDAQX3Sc9pyzLioTCAI
         PnNKjvJFv606wMKLDLaRZ/eab4l7QDgp61xYiRCR4UkRTknBJDr5zEve+/c1313IVE
         OPbUhF9A0zEqg==
Date:   Sat, 1 Apr 2023 12:12:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Message-ID: <20230401121212.454abf11@kernel.org>
In-Reply-To: <88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
        <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
        <20230331210920.399e3483@kernel.org>
        <88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
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

On Sat, 1 Apr 2023 18:24:11 +0000 Anjali Kulkarni wrote:
> > nit: slight divergence between __u32 and u32 types, something to clean
> > up if you post v5  
>
> Thanks so much! Will do. Any comments on the connector patches?

patch 3 looks fine as far as I can read thru the ugly in place casts
patch 5 looks a bit connector specific, no idea :S
patch 6 does seem to lift the NET_ADMIN for group 0
        and from &init_user_ns, CAP_NET_ADMIN to net->user_ns, CAP_NET_ADMIN
        whether that's right or not I have no idea :(

Also, BTW, on the coding level:

+static int cn_bind(struct net *net, int group)
+{
+	unsigned long groups = 0;
+	groups = (unsigned long) group;
+
+	if (test_bit(CN_IDX_PROC - 1, &groups))

Why not just

+static int cn_bind(struct net *net, int group)
+{
+	if (group == CN_IDX_PROC)

?

Who are you hoping will merge this?
