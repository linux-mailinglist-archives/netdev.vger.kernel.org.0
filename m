Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D236C4E09
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjCVOmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjCVOlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:41:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E345664E8;
        Wed, 22 Mar 2023 07:41:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F3CC6CE1DC6;
        Wed, 22 Mar 2023 14:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 066DDC433EF;
        Wed, 22 Mar 2023 14:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679496029;
        bh=bIHOw1f+pQw6OcOxZqQmBQFwstyNxXQuPXOXY7Oxae4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EnHxDtGP8WHoD8sRxvKlQ7DpirwpCE/ryDAG2U5jQGbxuo7lqVW3/Awgx2JR52wa8
         YAFDylZHPOCyYVF1R4FAdezajtFN4cXgDFPqxZ5cfBmRzEOpIXiSMH1PMkCgGtqKWx
         45WtBsUodh3GZKoopx/PKc/5QnwpbVEK7C35LEu8ZFvrMy8uVkMyXo/j/dhQmnkAPK
         Tqy0ntXH6UOiOWSb0OQJME5+ega75UkNnh+WvSrfeT7f0flvLnllDOD/kIn+yAQ7WO
         hQ5FreT7f9Aczl7zCbF0wiqIrfIVX/T6vteIYUm3h1jCUQaYvZCCeYDSKGXMeIDF7q
         +lVR5E8bt6ddg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC1CEE66C90;
        Wed, 22 Mar 2023 14:40:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net-zerocopy: Reduce compound page head access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167949602889.14303.13192517538159198890.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 14:40:28 +0000
References: <20230321081202.2370275-1-lixiaoyan@google.com>
In-Reply-To: <20230321081202.2370275-1-lixiaoyan@google.com>
To:     Coco Li <lixiaoyan@google.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        asml.silence@gmail.com, shakeelb@google.com,
        socketcan@hartkopp.net, viro@zeniv.linux.org.uk,
        netdev@vger.kernel.org, inux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 21 Mar 2023 16:12:01 +0800 you wrote:
> From: Xiaoyan Li <lixiaoyan@google.com>
> 
> When compound pages are enabled, although the mm layer still
> returns an array of page pointers, a subset (or all) of them
> may have the same page head since a max 180kb skb can span 2
> hugepages if it is on the boundary, be a mix of pages and 1 hugepage,
> or fit completely in a hugepage. Instead of referencing page head
> on all page pointers, use page length arithmetic to only call page
> head when referencing a known different page head to avoid touching
> a cold cacheline.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net-zerocopy: Reduce compound page head access
    https://git.kernel.org/netdev/net-next/c/593ef60c7445
  - [net-next,2/2] selftests/net: Add SHA256 computation over data sent in tcp_mmap
    https://git.kernel.org/netdev/net-next/c/5c5945dc695c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


