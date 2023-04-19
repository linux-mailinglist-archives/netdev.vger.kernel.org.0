Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F106E7D0C
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbjDSOkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbjDSOk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDD961BD;
        Wed, 19 Apr 2023 07:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07C026371E;
        Wed, 19 Apr 2023 14:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 679B3C433D2;
        Wed, 19 Apr 2023 14:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681915219;
        bh=L3rmvVZzfFOX0gs6NRkifbKhhR41UPWGrCyt1hya6Iw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OhbXDJNmnHv2BcsaGT0H4H6trflzXqzYp61LXriJT9xmSVBmzJuCyYBljVwSS7KGD
         YE/8LxhP49ks/v9HL7+sl6q1cyGQ6Gfjn3zANvrRMuKjv7Q1aD1g+O7bDJKkH8KL8l
         KFvbDQrLI7kMNPqIbzexYcA7LE9efEhEEj08ufDhBtR/nT2XcFmNYwTOspc/g38ePo
         ecF3UqKy4NTj9rCDz8Gi3pUEQmS0z8tHzNEfa8MBc8els0KEbnOjtkMn0Jn1DYsQFg
         tfXHuhBhnUaDoyIrv9yJE0PjIgRLKGReCyi8WXsVtUphUYmY6oCWGL9Zj+g543hmh8
         +JEVI6phI6wMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BBE4C395EA;
        Wed, 19 Apr 2023 14:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/xsk: fix munmap for hugepage allocated
 umem
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168191521930.31115.14808766624287897927.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 14:40:19 +0000
References: <20230418143617.27762-1-magnus.karlsson@gmail.com>
In-Reply-To: <20230418143617.27762-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, tirthendu.sarkar@intel.com,
        kal.conley@dectris.com, bpf@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 18 Apr 2023 16:36:17 +0200 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix the unmapping of hugepage allocated umems so that they are
> properly unmapped. The new test referred to in the fixes label,
> introduced a test that allocated a umem that is not a multiple of a 2M
> hugepage size. This is fine for mmap() that rounds the size up the
> nearest multiple of 2M. But munmap() requires the size to be a
> multiple of the hugepage size in order for it to unmap the region. The
> current behaviour of not properly unmapping the umem, was discovered
> when further additions of tests that require hugepages (unaligned mode
> tests only) started failing as the system was running out of
> hugepages.
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/xsk: fix munmap for hugepage allocated umem
    https://git.kernel.org/bpf/bpf-next/c/2ddade322925

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


