Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B824F686BB6
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBAQa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBAQaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:30:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40B335AD
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 608526187D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA59CC433EF;
        Wed,  1 Feb 2023 16:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675269023;
        bh=4sQ5UVeTOpzuYPyk/FbW6K6vTPbFMGRcSGr04OQluCo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HLEOEx2nkFGhb+ECMO/kzckN6oUufp2BxARGOqxAUvroEzeN8pvVZSK/UteaBDuWV
         BF0HeL9PPvQtIYlj/fZjorCQGdwej+sSaD1Rq3Its0nvBMIlgpg6toXd/ntE3ouG48
         dM4uBB6p0lonxkXKsHsp+VMgr+EvRnfOyFLpduTXMgwIL76qckfr8+BIW75VkxYFUi
         99t7QnuDoEDjvWmMJSLNH+CIqJV2UyBtKUf3bX37UFoc+7/VmodWJKntVDS0G+VdSn
         ZERw3+hOGY2U7AuZP4yhOaeEUVBMdxRTSRw06kj/nLdQuorU8AkFfV0lmY5/o/DUrU
         FHLNUNpFS4yng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7AF5E21ED4;
        Wed,  1 Feb 2023 16:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH ethtool-next v6 0/2] add netlink support for rss get
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167526902374.23236.9492682925665270615.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 16:30:23 +0000
References: <20230123212501.1471308-1-sudheer.mogilappagari@intel.com>
In-Reply-To: <20230123212501.1471308-1-sudheer.mogilappagari@intel.com>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mkubecek@suse.cz,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Mon, 23 Jan 2023 13:24:59 -0800 you wrote:
> These patches add netlink based handler to fetch RSS information
> using "ethtool -x <eth> [context %d]" command.
> 
> Output without --json option
> $ethtool -x eno2
> RX flow hash indirection table for eno2 with 8 RX ring(s):
>     0:      0     0     0     0     0     0     0     0
>     8:      1     1     1     1     1     1     1     1
>    ...skip similar lines...
>   120:      7     7     7     7     7     7     7     7
> RSS hash key:
> be:c3:13:a6:59:9a:c3:c5:d8:60:75:2b:4c:b2:12:cc:5c:4e:34:
> 8a:f9:ab:16:c7:19:5d:ab:1d:b5:c1:c7:57:c7:a2:e1:2b:e3:ea:
> 02:60:88:8e:96:ef:2d:64:d2:de:2c:16:72:b6
> RSS hash function:
>     toeplitz: on
>     xor: off
>     crc32: off
> 
> [...]

Here is the summary with links:
  - [RESEND,ethtool-next,v6,1/2] Move code that print rss info into common file
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=d139d369c150
  - [RESEND,ethtool-next,v6,2/2] netlink: add netlink handler for get rss (-x)
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


