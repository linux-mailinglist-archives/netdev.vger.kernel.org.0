Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0CC4AE94B
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbiBIF15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:27:57 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbiBIFU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:20:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FB0C03C182
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:20:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9123FB81ED5
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 608C3C340F0;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644384028;
        bh=I+3iilKRwOruga4VmzbqLtsEMa1skYUe2PrCG/exCkw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RjgBKevRpvfOOM7AoDHgjNGE25g05rNeo2to0R2Z39esBXVImbdmEN6jhFhGbJ/hU
         CbslD3RIn9V7w2wcaNgdlYQdz7p9XO2BiLWJmz42urW2zswnIzmXxrS7xKB6nerqJa
         a9NQ2k9zy5kGbQAASPdjg2ZqUpZ0OhYEyIgbdjns7LseCaD5nkPZOBu6EvIPuv4DjS
         b7JRV5bM5eIzINHEwTivbDK2X+ilrLC6N8CAuS8cbb6UewjdJ7mB+P5QM3t3tzjm5q
         9YNVOHRduF8j4kLYdnKNA6oDnSzM30ZV+y6vtRrY3HImyQPL1sybGGWYpfmqe3EbnM
         HR8cnCJ/HdXYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BEAEE5D07D;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ibmvnic: don't release napi in __ibmvnic_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164438402830.12376.7927524472924321207.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 05:20:28 +0000
References: <20220208001918.900602-1-sukadev@linux.ibm.com>
In-Reply-To: <20220208001918.900602-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, brking@linux.ibm.com, drt@linux.ibm.com,
        ricklind@linux.ibm.com, abdhalee@in.ibm.com, vaish123@in.ibm.com,
        abdhalee@linux.vnet.ibm.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  7 Feb 2022 16:19:18 -0800 you wrote:
> If __ibmvnic_open() encounters an error such as when setting link state,
> it calls release_resources() which frees the napi structures needlessly.
> Instead, have __ibmvnic_open() only clean up the work it did so far (i.e.
> disable napi and irqs) and leave the rest to the callers.
> 
> If caller of __ibmvnic_open() is ibmvnic_open(), it should release the
> resources immediately. If the caller is do_reset() or do_hard_reset(),
> they will release the resources on the next reset.
> 
> [...]

Here is the summary with links:
  - [net,1/1] ibmvnic: don't release napi in __ibmvnic_open()
    https://git.kernel.org/netdev/net/c/61772b0908c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


