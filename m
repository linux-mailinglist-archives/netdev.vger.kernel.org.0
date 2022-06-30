Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF2D561746
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbiF3KH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235001AbiF3KHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:07:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2A114338E
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656583657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iHHsVWq+17Tq1wbvtNYtaq26FE2gZ31r5CIj41Mi7No=;
        b=fSc+oE5sECz1kTz27hQrusaWsaFXWBFM49bUr2DyUXIovyj4fC6jg9WB0zRctfnLXrgzHS
        FqCtkRLTIVe3KZz0rXZgL49hGQ1kbStIHduY9mln4EJ5u1Qtgh6uSkd/QN+tNiBDDcfG3X
        slVT1Ze33sFCUu56XsJD3ZCKLxP+MBc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-WVLpXZmQPuavTCxP6ALiPw-1; Thu, 30 Jun 2022 06:07:35 -0400
X-MC-Unique: WVLpXZmQPuavTCxP6ALiPw-1
Received: by mail-qk1-f198.google.com with SMTP id k190-20020a37bac7000000b006af6d953751so5985412qkf.13
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:07:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=iHHsVWq+17Tq1wbvtNYtaq26FE2gZ31r5CIj41Mi7No=;
        b=T7bF1wXi9qVL6w9YcNxWIgP4IhWMOwEVj5YiytF/JTgQ0ev19+L5Q0Kq0xyJYrIahm
         nid9yvIqmW7wtLhc/FH3PDfaHqno5Ja6cOZip8sPLzzizjLXXq/cKZnz2Td1wW966r1C
         ODksYDxyd8W5Q372TIfwwAvDHy/QZcu0GsnuhOIjTmdte4uRxgG+BP2SPmmdiwVP2VlB
         P2fnoHNB6rEFW/G77f+AVDABwFDd+2SHhQrsepHhson4CggGLtMH2qrTrrKNraQFgmD+
         GBOT1EzC116l8UrAWtAtLOdewwyt8GCEKw5uiMjP1DMu3pEwtDr8XTr1sqhWy7oLT8G+
         oiiQ==
X-Gm-Message-State: AJIora9HpKB8i1sFQUToCVLwYq6VQA4x50oK0XEq49DDwNr2wf9gCavX
        kleFw5DilLLYYvndLJvXeENZ+N9RHt9VjXQfT+4tnBkvOZIZGNqwJ5jxr2x2t/8qlVr86MXqns6
        tg7T3IWAckwLpVkmx
X-Received: by 2002:ad4:5aee:0:b0:470:69fd:3242 with SMTP id c14-20020ad45aee000000b0047069fd3242mr10443066qvh.34.1656583655147;
        Thu, 30 Jun 2022 03:07:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uPAFlkBurgmI1SylspEFkrFfb6VIvA01/OXvp4LAj2WXsdMeyJRR3PrP/j+i/+vdbZezmJjA==
X-Received: by 2002:ad4:5aee:0:b0:470:69fd:3242 with SMTP id c14-20020ad45aee000000b0047069fd3242mr10443052qvh.34.1656583654927;
        Thu, 30 Jun 2022 03:07:34 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id ea23-20020a05620a489700b006af33e58b42sm7884602qkb.43.2022.06.30.03.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 03:07:34 -0700 (PDT)
Message-ID: <def83ec35ee0b0d4ba3932c0251f067a07cb6ff5.camel@redhat.com>
Subject: Re: [PATCH] net: hinic: avoid kernel hung in hinic_get_stats64()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Qiao Ma <mqaio@linux.alibaba.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, gustavoars@kernel.org,
        cai.huoqing@linux.dev, aviad.krawczyk@huawei.com,
        zhaochen6@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 30 Jun 2022 12:07:30 +0200
In-Reply-To: <07736c2b7019b6883076a06129e06e8f7c5f7154.1656487154.git.mqaio@linux.alibaba.com>
References: <07736c2b7019b6883076a06129e06e8f7c5f7154.1656487154.git.mqaio@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-29 at 15:28 +0800, Qiao Ma wrote:
> When using hinic device as a bond slave device, and reading device stats of
> master bond device, the kernel may hung.
> 
> The kernel panic calltrace as follows:
> Kernel panic - not syncing: softlockup: hung tasks
> Call trace:
>   native_queued_spin_lock_slowpath+0x1ec/0x31c
>   dev_get_stats+0x60/0xcc
>   dev_seq_printf_stats+0x40/0x120
>   dev_seq_show+0x1c/0x40
>   seq_read_iter+0x3c8/0x4dc
>   seq_read+0xe0/0x130
>   proc_reg_read+0xa8/0xe0
>   vfs_read+0xb0/0x1d4
>   ksys_read+0x70/0xfc
>   __arm64_sys_read+0x20/0x30
>   el0_svc_common+0x88/0x234
>   do_el0_svc+0x2c/0x90
>   el0_svc+0x1c/0x30
>   el0_sync_handler+0xa8/0xb0
>   el0_sync+0x148/0x180
> 
> And the calltrace of task that actually caused kernel hungs as follows:
>   __switch_to+124
>   __schedule+548
>   schedule+72
>   schedule_timeout+348
>   __down_common+188
>   __down+24
>   down+104
>   hinic_get_stats64+44 [hinic]
>   dev_get_stats+92
>   bond_get_stats+172 [bonding]
>   dev_get_stats+92
>   dev_seq_printf_stats+60
>   dev_seq_show+24
>   seq_read_iter+964
>   seq_read+220
>   proc_reg_read+164
>   vfs_read+172
>   ksys_read+108
>   __arm64_sys_read+28
>   el0_svc_common+132
>   do_el0_svc+40
>   el0_svc+24
>   el0_sync_handler+164
>   el0_sync+324
> 
> When getting device stats from bond, kernel will call bond_get_stats().
> It first holds the spinlock bond->stats_lock, and then call
> hinic_get_stats64() to collect hinic device's stats.
> However, hinic_get_stats64() calls `down(&nic_dev->mgmt_lock)` to
> protect its critical section, which may schedule current task out.
> And if system is under high pressure, the task cannot be woken up
> immediately, which eventually triggers kernel hung panic.
> 
> Fixes: edd384f682cc ("net-next/hinic: Add ethtool and stats")
> Signed-off-by: Qiao Ma <mqaio@linux.alibaba.com>

It does not apply cleanly to the net tree (but it does to net-next)

This looks like -net material, please reabase the patch and re-post it
explicitly targeting the net tree.

Thanks!

Paolo

