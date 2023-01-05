Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6A465E274
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 02:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjAEBWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 20:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjAEBWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 20:22:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B442F783;
        Wed,  4 Jan 2023 17:22:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EAA38CE193C;
        Thu,  5 Jan 2023 01:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08456C433EF;
        Thu,  5 Jan 2023 01:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672881763;
        bh=ExpxEIguBmVK6mxVxd9YEswT2YfPe7zBo9G4esPP838=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=gB2WDuUS6KfnjtiNTPNPRUmG7LTic9mE03cppW5NPP7t0t9t+u0GUaulFtbsBOxF5
         5XNUk7b41IY8FT4LCmSZ4RXd4Wb2AAJjc46tBcGlaZ9jY7CNjvyVhwo7u5SFa+Lqub
         l0Evofho7p9aeXb89IXIyVlCwB/+hdM6az/Qdsx81px8S6ON12J+VwJSWK6RzIvQq7
         9bNjQz5Bv8YHpEQNtJoNDD8DAzGWXvU6Q9fcrdoKd3teJuMECR/9VUCJ1IwbroM3yx
         cLuUFfL9KBkwJawIdgpQSJpSpOObUvt+w+zuTVD5Aq/xf/6OqxDzIzGK/fLar6AZ/H
         Qwnjxb/zz8D6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6A2FE57249;
        Thu,  5 Jan 2023 01:22:42 +0000 (UTC)
Subject: Re: [GIT PULL v2] virtio,vhost,vdpa: fixes, cleanups
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230103104946-mutt-send-email-mst@kernel.org>
References: <20230103104946-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230103104946-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: a26116c1e74028914f281851488546c91cbae57d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 41c03ba9beea760bd2d2ac9250b09a2e192da2dc
Message-Id: <167288176293.29184.569668467593245088.pr-tracker-bot@kernel.org>
Date:   Thu, 05 Jan 2023 01:22:42 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        angus.chen@jaguarmicro.com, colin.i.king@gmail.com,
        dave@stgolabs.net, dengshaomin@cdjrlc.com, dmitry.fomichev@wdc.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        harshit.m.mogalapalli@oracle.com, jasowang@redhat.com,
        lulu@redhat.com, mst@redhat.com, pizhenwei@bytedance.com,
        rafaelmendsr@gmail.com, ricardo.canuelo@collabora.com,
        ruanjinjie@huawei.com, set_pte_at@outlook.com, sgarzare@redhat.com,
        shaoqin.huang@intel.com, si-wei.liu@oracle.com,
        stable@vger.kernel.org, sunnanyong@huawei.com,
        wangjianli@cdjrlc.com, wangrong68@huawei.com,
        weiyongjun1@huawei.com, yuancan@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 3 Jan 2023 10:49:46 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/41c03ba9beea760bd2d2ac9250b09a2e192da2dc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
