Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC4F4C12E8
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240532AbiBWMkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240514AbiBWMkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:40:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBCEA27A4;
        Wed, 23 Feb 2022 04:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 047A7B81F4F;
        Wed, 23 Feb 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DFF6C340EB;
        Wed, 23 Feb 2022 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645620010;
        bh=xAWTzVPDXmXhJ2MJWWWr9xM51emUCAMzZ4hRhwiBQhI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O4lathYsI/baO1ETy4btTo5MEvk82pEqN4d0PoPP0qFlJocE0VeBj7oVxILehU+fN
         TyaWTI3bZKr6bKz4feNb0Xr5AtVXLMf4eXuXM9RP2Nn44RJfWJ2L9jf7tslPcrem8/
         3WkvOpHJu1K607ijzLwcf/QY8Znt8tD3S+kYqpapUcTlWFt2GOXRhUb8FT5DynphTj
         4r10OJp/AwP5MY7EZZD214ST0TpJFAawf0qZDXt11NgcIZ66loewBSNWfHrZ26Gkww
         7Xd+HEP2vP2NSA0Azirg/evL/LsmKSEuuFOra7J0oyEqfbTG7Q62q1Z4RTl6MHXRD0
         g4X2RorJQKCaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7E7F6E5D09D;
        Wed, 23 Feb 2022 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] vhost/vsock: don't check owner in vhost_vsock_stop() while
 releasing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164562001051.25344.13267452544338970366.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 12:40:10 +0000
References: <20220222094742.16359-1-sgarzare@redhat.com>
In-Reply-To: <20220222094742.16359-1-sgarzare@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     mst@redhat.com, stefanha@redhat.com, jasowang@redhat.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com,
        kvm@vger.kernel.org, mail@anirudhrb.com,
        syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, michael.christie@oracle.com,
        dan.carpenter@oracle.com, stable@vger.kernel.org
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

On Tue, 22 Feb 2022 10:47:42 +0100 you wrote:
> vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
> ownership. It expects current->mm to be valid.
> 
> vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
> the user has not done close(), so when we are in do_exit(). In this
> case current->mm is invalid and we're releasing the device, so we
> should clean it anyway.
> 
> [...]

Here is the summary with links:
  - [v2] vhost/vsock: don't check owner in vhost_vsock_stop() while releasing
    https://git.kernel.org/netdev/net/c/a58da53ffd70

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


