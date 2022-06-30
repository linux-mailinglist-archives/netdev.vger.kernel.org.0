Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1C85616E3
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 11:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiF3J46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 05:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbiF3J45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 05:56:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6323043399
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 02:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656583015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CDu+zCVL/iHOE4iiWUZjPtowW+QlF+sjQdHuJYh9AdU=;
        b=eO03aUtnys/vdryqr0BX3lAkt9jUSKzwUf9sEukQTZoEUISAGEthZxH54uarpYZUk3i8gb
        FyaKt1wqf1R/O5aSZfVo6NBEKQaqawCwIS3hlHsJMRt4cvhTnqIELIaobYXMP8t6VftVkZ
        5ABq4AV4v7W6Y1UOCC4IbDnMNFB5Z3o=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-zqf64UEyNd630qFgcVj7AA-1; Thu, 30 Jun 2022 05:56:53 -0400
X-MC-Unique: zqf64UEyNd630qFgcVj7AA-1
Received: by mail-qv1-f71.google.com with SMTP id m7-20020ad45dc7000000b0047042480dbfso17828301qvh.9
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 02:56:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CDu+zCVL/iHOE4iiWUZjPtowW+QlF+sjQdHuJYh9AdU=;
        b=XwHScdeoxtcf2wLHUlAkhz41Lnjus7P1KIHwQNW8EjkkvalpqyYLcpycVxTvF4DY8u
         vi+GBZoEHKNOAfZgOsCnIJAmXsb+JifzWswreWxCbkEUsAk25f25lftapm1nZCV+eM4r
         rAu4WsyG8yooLLTCRRI+0j8E+4lNwh7Y57nhf2I9oGCtJimD1RDOIy0IMFNv3Ft0E9ey
         rxLLMEQ6vLGe8stg1Ey+Z5tX8np6uQgdJZAvDIOLkG3g+mjpWk8ybhm9Nmepwc6zVjca
         vUDYmgeo9iH8159rqiMStZfhjDj4r98vIoPTOqr6CdN7j9Vo5YpTTY/CfJsHEUBd6AaY
         bXMg==
X-Gm-Message-State: AJIora/KSYmKDaTMC1GdAFkqaCkgIRJt1vTv4qrmORzYDwzcmdXC9da3
        02s7XalYjnVbBkeMHvrK301WS5ta2N2iO6Ky7qQ7vfjTUDu3aDLAAiiSHS0fppq1l+B1gbBPPxa
        MQZ1MHxdKmE0QJP0v
X-Received: by 2002:ac8:5298:0:b0:319:63c3:8b1d with SMTP id s24-20020ac85298000000b0031963c38b1dmr6624864qtn.261.1656583013345;
        Thu, 30 Jun 2022 02:56:53 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vDeUZ5o9LgiRwYosHFqD2jL02bO5En5FUz0PWgFnCB07gQjcN/TW5qNV4yFvA2a5vWanzumQ==
X-Received: by 2002:ac8:5298:0:b0:319:63c3:8b1d with SMTP id s24-20020ac85298000000b0031963c38b1dmr6624851qtn.261.1656583013075;
        Thu, 30 Jun 2022 02:56:53 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id g6-20020ac842c6000000b00317ccc66971sm11586812qtm.52.2022.06.30.02.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 02:56:52 -0700 (PDT)
Message-ID: <64e59afe33fff04861c800853a549f7979270f79.camel@redhat.com>
Subject: Re: [PATCH] net: hinic: avoid kernel hung in hinic_get_stats64()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Qiao Ma <mqaio@linux.alibaba.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, gustavoars@kernel.org,
        cai.huoqing@linux.dev, aviad.krawczyk@huawei.com,
        zhaochen6@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 30 Jun 2022 11:56:48 +0200
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

Side note: it looks like that after this patch every section protected
by the mgmt_lock is already under rtnl lock protection, so you could
probably remove the hinic specific lock (in a separate, net-next,
patch).

Please double check the above as I skimmed upon that quickly.

Thanks,

Paolo

