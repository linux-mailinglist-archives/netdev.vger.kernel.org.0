Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27CBF601A5E
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiJQUg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbiJQUd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:33:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC4580523;
        Mon, 17 Oct 2022 13:32:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ACE0B81ACC;
        Mon, 17 Oct 2022 20:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7EC3C43470;
        Mon, 17 Oct 2022 20:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666038616;
        bh=MVYPKmuYR19Dqm773+dw9TnYJkuQpy7J6elSN50RiUE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QSSWkI2NS0jem6Xc5G3zJfkfSfEqPAuZp/i9ICadMkOqh8+zcLRGjSSefKv/HSszd
         bGbu/opmQTjE9exj0CsoIodAWpTfHyHXEn0Z3Fhw2jyzn3zsuiBRKiTqf5c75enaYM
         cqKzkHs8DLTm+q8Lmu7cJvagZYKFLvnm0hxRf8o93WNXC9CM54LbEB4bHexXWi1MLR
         tiPyZAxCBfwsNs22iZWpQE7u00KCQppjj6NzhUJrkFhFNZLa/7yvweGv4RrbDRXs0F
         ytMg0uL0W0OzGHefWW0mwJNooPn3iiBo5ifoj2vMuFo+f9k2FQKhNcfuFOhjQTy46W
         DQ6AME6b1jemA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B681BE270EF;
        Mon, 17 Oct 2022 20:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: L2CAP: fix use-after-free in l2cap_conn_del()
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166603861674.10129.97922978333278137.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Oct 2022 20:30:16 +0000
References: <20221017075813.6071-1-shaozhengchao@huawei.com>
In-Reply-To: <20221017075813.6071-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, marcel@holtmann.org, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Mon, 17 Oct 2022 15:58:13 +0800 you wrote:
> When l2cap_recv_frame() is invoked to receive data, and the cid is
> L2CAP_CID_A2MP, if the channel does not exist, it will create a channel.
> However, after a channel is created, the hold operation of the channel
> is not performed. In this case, the value of channel reference counting
> is 1. As a result, after hci_error_reset() is triggered, l2cap_conn_del()
> invokes the close hook function of A2MP to release the channel. Then
>  l2cap_chan_unlock(chan) will trigger UAF issue.
> 
> [...]

Here is the summary with links:
  - Bluetooth: L2CAP: fix use-after-free in l2cap_conn_del()
    https://git.kernel.org/bluetooth/bluetooth-next/c/42cf46dea905

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


