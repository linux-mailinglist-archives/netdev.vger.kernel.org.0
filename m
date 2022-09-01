Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA9F5A8BB2
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 05:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiIADAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 23:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbiIADAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 23:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D47923BE6;
        Wed, 31 Aug 2022 20:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E656461DE1;
        Thu,  1 Sep 2022 03:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A1B0C43141;
        Thu,  1 Sep 2022 03:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662001217;
        bh=E4sWarekeoZpoGBo9Rql8TrQJ5vx9I2kRDxyj+UhVp4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n3OeEjzyk7MYCVzL8NUM9dngu5HefGCLHYHh9ubmFud/XsSguLHtndiAXqZAXmvSl
         tQXAO4VzET9IGPXzHwOo1nsH0Yp83aKha3Utf20dbKKWoWXYPBXtsWYn4XzWJF4yOA
         5HN3xZvGl4VV21mWpkGTzsMJP6ecyuU+qHAAUTzWOG/TyjwNgeuZz86Ix5sWSrdOuD
         wtJ7Mu8UG0tSZXw/2DJzTKkJsK11t1OQUL7wtM77VaqGuBTfPmaq0yXk+8f6vpO/VY
         D2FUAGfq6nRLoj1ThL7wzYr0I9IuppSoU+7n2ElSeUSAqrFEzLgnLT9Z74FtX6uGph
         bCFnf9POCSPzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 37884E924DD;
        Thu,  1 Sep 2022 03:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net-next: Fix IP_UNICAST_IF option behavior for connected
 sockets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166200121722.29714.6463904188878717399.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 03:00:17 +0000
References: <20220829111554.GA1771@debian>
In-Reply-To: <20220829111554.GA1771@debian>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 29 Aug 2022 13:18:51 +0200 you wrote:
> The IP_UNICAST_IF socket option is used to set the outgoing interface
> for outbound packets.
> 
> The IP_UNICAST_IF socket option was added as it was needed by the
> Wine project, since no other existing option (SO_BINDTODEVICE socket
> option, IP_PKTINFO socket option or the bind function) provided the
> needed characteristics needed by the IP_UNICAST_IF socket option. [1]
> The IP_UNICAST_IF socket option works well for unconnected sockets,
> that is, the interface specified by the IP_UNICAST_IF socket option
> is taken into consideration in the route lookup process when a packet
> is being sent. However, for connected sockets, the outbound interface
> is chosen when connecting the socket, and in the route lookup process
> which is done when a packet is being sent, the interface specified by
> the IP_UNICAST_IF socket option is being ignored.
> 
> [...]

Here is the summary with links:
  - [v2] net-next: Fix IP_UNICAST_IF option behavior for connected sockets
    https://git.kernel.org/netdev/net-next/c/0e4d354762ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


