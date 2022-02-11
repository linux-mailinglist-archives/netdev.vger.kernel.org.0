Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0411B4B253C
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349840AbiBKMKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:10:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349830AbiBKMKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:10:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93064E56;
        Fri, 11 Feb 2022 04:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E97A8B8286C;
        Fri, 11 Feb 2022 12:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97F82C36AE2;
        Fri, 11 Feb 2022 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644581410;
        bh=dYAix+TuKS0jPLaVuDad3pyeN494Utdl/SInaNktn6M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iniemvu2Y0/YMuB8E0Lv2S1WPlP/DMvV7SqPDqyW+UA5KXS43u6JxyxqtvAxpB/ti
         dHQcR/19KSItio8N3/FrfT9DQqC2X07W3cDTrf91b/1vxazNsDiGinDdcB+LXVZSeY
         yiqRojV4q3wPzuxkVA1yfR98VDzAHAfS0zF+rViXK2zGCCO7D2UUEWgS30l2m9XXMO
         3GeKXw8cmykgfBp9e2lD3QY0zC50slf11gdfybzP6S44c2Fz1O1rqbADf5l49YyNon
         ev4kcjLWsd840aCsUGV1/EN07Pv1v6dfuEHSiaq2hUtYex4R9ANTlJBcWhVen+/h36
         ig/ZEoSwxDxMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81855E6BBCA;
        Fri, 11 Feb 2022 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: Avoid overwriting the copies of clcsock callback
 functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164458141052.22011.5045828646528972174.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Feb 2022 12:10:10 +0000
References: <1644415853-46641-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1644415853-46641-1-git-send-email-guwen@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 22:10:53 +0800 you wrote:
> The callback functions of clcsock will be saved and replaced during
> the fallback. But if the fallback happens more than once, then the
> copies of these callback functions will be overwritten incorrectly,
> resulting in a loop call issue:
> 
> clcsk->sk_error_report
>  |- smc_fback_error_report() <------------------------------|
>      |- smc_fback_forward_wakeup()                          | (loop)
>          |- clcsock_callback()  (incorrectly overwritten)   |
>              |- smc->clcsk_error_report() ------------------|
> 
> [...]

Here is the summary with links:
  - [net] net/smc: Avoid overwriting the copies of clcsock callback functions
    https://git.kernel.org/netdev/net/c/1de9770d121e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


