Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2B26DA9C2
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239550AbjDGIKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239188AbjDGIKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6E59EC1
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CCC064BDB
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4622C4339B;
        Fri,  7 Apr 2023 08:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680855018;
        bh=M3FVLrWoL8L6ucBL8nar6UNRbFleifV3TQlg1VdWlTU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DMDX3S/yoh6B3u2aXq8C4AsQb4Kr+LiV8zKJDG2C0AiIVyZa9MIpqlvkRFjlS2RPF
         av9H7U3sXhGToNNoRVG/Uef8jtfjMFL8dD9jgmykiGB++sI7uSRXQ09Nnv12pgpJGG
         OHwySWMlVdC836PWmJ2KAINC22QEaLcMUCBiMgOsFYtSo7RkOTRhlOMyG40kS7CRkl
         kPR+//jwTV+FQKav8PbChqE93Q0qwBL9fdsF7XdwFMVnJ4/Zn3nxG1w/krupdsiOsA
         NRfCv793CJ56NifGzJd2vx61Ajz+VvUeXWysN3xOs83TycsJFvUfgfevGoTYxzYQWP
         sRDzbJ+rFfMRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 85FE5E4F14C;
        Fri,  7 Apr 2023 08:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net 0/3] bonding: fix ns validation on backup slaves
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168085501854.4864.1968178476177065803.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Apr 2023 08:10:18 +0000
References: <20230406082352.986477-1-liuhangbin@gmail.com>
In-Reply-To: <20230406082352.986477-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jtoppins@redhat.com, pabeni@redhat.com,
        edumazet@google.com, liali@redhat.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Apr 2023 16:23:49 +0800 you wrote:
> The first patch fixed a ns validation issue on backup slaves. The second
> patch re-format the bond option test and add a test lib file. The third
> patch add the arp validate regression test for the kernel patch.
> 
> Here is the new bonding option test without the kernel fix:
> 
> ]# ./bond_options.sh
> TEST: prio (active-backup miimon primary_reselect 0)           [ OK ]
> TEST: prio (active-backup miimon primary_reselect 1)           [ OK ]
> TEST: prio (active-backup miimon primary_reselect 2)           [ OK ]
> TEST: prio (active-backup arp_ip_target primary_reselect 0)    [ OK ]
> TEST: prio (active-backup arp_ip_target primary_reselect 1)    [ OK ]
> TEST: prio (active-backup arp_ip_target primary_reselect 2)    [ OK ]
> TEST: prio (active-backup ns_ip6_target primary_reselect 0)    [ OK ]
> TEST: prio (active-backup ns_ip6_target primary_reselect 1)    [ OK ]
> TEST: prio (active-backup ns_ip6_target primary_reselect 2)    [ OK ]
> TEST: prio (balance-tlb miimon primary_reselect 0)             [ OK ]
> TEST: prio (balance-tlb miimon primary_reselect 1)             [ OK ]
> TEST: prio (balance-tlb miimon primary_reselect 2)             [ OK ]
> TEST: prio (balance-tlb arp_ip_target primary_reselect 0)      [ OK ]
> TEST: prio (balance-tlb arp_ip_target primary_reselect 1)      [ OK ]
> TEST: prio (balance-tlb arp_ip_target primary_reselect 2)      [ OK ]
> TEST: prio (balance-tlb ns_ip6_target primary_reselect 0)      [ OK ]
> TEST: prio (balance-tlb ns_ip6_target primary_reselect 1)      [ OK ]
> TEST: prio (balance-tlb ns_ip6_target primary_reselect 2)      [ OK ]
> TEST: prio (balance-alb miimon primary_reselect 0)             [ OK ]
> TEST: prio (balance-alb miimon primary_reselect 1)             [ OK ]
> TEST: prio (balance-alb miimon primary_reselect 2)             [ OK ]
> TEST: prio (balance-alb arp_ip_target primary_reselect 0)      [ OK ]
> TEST: prio (balance-alb arp_ip_target primary_reselect 1)      [ OK ]
> TEST: prio (balance-alb arp_ip_target primary_reselect 2)      [ OK ]
> TEST: prio (balance-alb ns_ip6_target primary_reselect 0)      [ OK ]
> TEST: prio (balance-alb ns_ip6_target primary_reselect 1)      [ OK ]
> TEST: prio (balance-alb ns_ip6_target primary_reselect 2)      [ OK ]
> TEST: arp_validate (active-backup arp_ip_target arp_validate 0)  [ OK ]
> TEST: arp_validate (active-backup arp_ip_target arp_validate 1)  [ OK ]
> TEST: arp_validate (active-backup arp_ip_target arp_validate 2)  [ OK ]
> TEST: arp_validate (active-backup arp_ip_target arp_validate 3)  [ OK ]
> TEST: arp_validate (active-backup arp_ip_target arp_validate 4)  [ OK ]
> TEST: arp_validate (active-backup arp_ip_target arp_validate 5)  [ OK ]
> TEST: arp_validate (active-backup arp_ip_target arp_validate 6)  [ OK ]
> TEST: arp_validate (active-backup ns_ip6_target arp_validate 0)  [ OK ]
> TEST: arp_validate (active-backup ns_ip6_target arp_validate 1)  [ OK ]
> TEST: arp_validate (interface eth1 mii_status DOWN)                 [FAIL]
> TEST: arp_validate (interface eth2 mii_status DOWN)                 [FAIL]
> TEST: arp_validate (active-backup ns_ip6_target arp_validate 2)  [FAIL]
> TEST: arp_validate (interface eth1 mii_status DOWN)                 [FAIL]
> TEST: arp_validate (interface eth2 mii_status DOWN)                 [FAIL]
> TEST: arp_validate (active-backup ns_ip6_target arp_validate 3)  [FAIL]
> TEST: arp_validate (active-backup ns_ip6_target arp_validate 4)  [ OK ]
> TEST: arp_validate (active-backup ns_ip6_target arp_validate 5)  [ OK ]
> TEST: arp_validate (interface eth1 mii_status DOWN)                 [FAIL]
> TEST: arp_validate (interface eth2 mii_status DOWN)                 [FAIL]
> TEST: arp_validate (active-backup ns_ip6_target arp_validate 6)  [FAIL]
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net,1/3] bonding: fix ns validation on backup slaves
    https://git.kernel.org/netdev/net/c/4598380f9c54
  - [PATCHv2,net,2/3] selftests: bonding: re-format bond option tests
    https://git.kernel.org/netdev/net/c/481b56e0391e
  - [PATCHv2,net,3/3] selftests: bonding: add arp validate test
    https://git.kernel.org/netdev/net/c/2e825f8accb4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


