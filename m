Return-Path: <netdev+bounces-12113-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB2273638D
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:23:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F42191C209F4
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 06:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00BE91FDC;
	Tue, 20 Jun 2023 06:23:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81FE1FD0
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:23:32 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF77FE2
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:23:29 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f9b258f3d8so13462785e9.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1687242208; x=1689834208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HHtZ/7kai8AdlwB6ECvM+0r/hcvDqi/hBh3JE5IiBfY=;
        b=CTSbyApXi75VWD9ukVSnGUDu4AQZVjI6uxpiEkxfT/V5s2Z4fqlVnNVh1p8N3lyBUW
         q9/c6Gjsc1gACGNAgph3XoscjmCz/2ba5aVf9cbTMed8CAycaC44zVU7/4Y4797AviTs
         qcAhujLOn3rwZsAPiUQoePWiEePz+NukGXU/dL6sej+k6UvTxDXOWCRfEsz9naYzV74g
         KBI0sVq4D52xCXOLEa8VkbAWBKWP0KODTVpGJnqGkLKbGErzZCQYznJKg9m+ILQBz6c5
         ljwZ0Pboy6rMFVHnEBJHEXUqThxOBC1Uc8iIK5a55oIY9Qxc51MNCbJVc9gj57+Kq6S7
         VbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687242208; x=1689834208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HHtZ/7kai8AdlwB6ECvM+0r/hcvDqi/hBh3JE5IiBfY=;
        b=eN3lsk99GQxBQ7v+t9P8Dy/IGO73zm5TKm3QH5RFd8IasCVYJUxlNPSgLkDTkw1IGA
         flqXZkfAqeVWxZC8LJJv/OMTqfTvYryk3jpLs9LPO4rW0jfhiNyPlUDYPdoYWyvUPljt
         rjHPAlEy3J31WCrm6B2h0aoNdE7MYgrfNfpujS7lcDCXBRMWm3g3/jGJsJ8/Fnvh4h0/
         r8ft4lkWCNtSQY2kjdF3xiHSg0w55ecJ6LPd36Vg+OH9JIvjEF74CXXF32kZLiCWKQ06
         taddMGcdwU93zdoVRxI5ZZGYUzGqwFIbsDrAICqElRG8NE+zQlQa6QnKs7fm5ddpxhzE
         Xa7A==
X-Gm-Message-State: AC+VfDyplWTuAfQb82jFA5T4Yv4tSTBh0oh8m6OtHJGEWrHnA7gvvEt6
	67FSBEb+lTnuJDCedVljjyP+9g==
X-Google-Smtp-Source: ACHHUZ6okj2iePElN87Ne7tNGgS1kwGjgTyB4DWgIONiMGfFBfbm9faOFZMEbOcqxaHc8YGXG/0sjw==
X-Received: by 2002:a1c:ed10:0:b0:3f7:e660:cdc5 with SMTP id l16-20020a1ced10000000b003f7e660cdc5mr9431138wmh.9.1687242208054;
        Mon, 19 Jun 2023 23:23:28 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q19-20020a1cf313000000b003f7361ca753sm12343185wmq.24.2023.06.19.23.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 23:23:27 -0700 (PDT)
Date: Tue, 20 Jun 2023 08:23:26 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com
Subject: Re: [RFC PATCH net-next 1/2] devlink: Hold a reference on parent
 device
Message-ID: <ZJFF3gh6LNCVXPzd@nanopsycho>
References: <20230619125015.1541143-1-idosch@nvidia.com>
 <20230619125015.1541143-2-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619125015.1541143-2-idosch@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mon, Jun 19, 2023 at 02:50:14PM CEST, idosch@nvidia.com wrote:
>Each devlink instance is associated with a parent device and a pointer
>to this device is stored in the devlink structure, but devlink does not
>hold a reference on this device.
>
>This is going to be a problem in the next patch where - among other
>things - devlink will acquire the device lock during netns dismantle,
>before the reload operation. Since netns dismantle is performed
>asynchronously and since a reference is not held on the parent device,
>it will be possible to hit a use-after-free.
>
>Prepare for the upcoming change by holding a reference on the parent
>device.
>
>Unfortunately, with this patch and this reproducer [1], the following
>crash can be observed [2]. The last reference is released from the
>device asynchronously - after an RCU grace period - when the netdevsim
>module is no longer present. This causes device_release() to invoke a
>release callback that is no longer present: nsim_bus_dev_release().
>
>It's not clear to me if I'm doing something wrong in devlink (I don't
>think so), if it's a bug in netdevsim or alternatively a bug in core
>driver code that allows the bus module to go away before all the devices
>that were connected to it are released.
>
>The problem can be solved by devlink holding a reference on the backing
>module (i.e., dev->driver->owner) or by each netdevsim device holding a
>reference on the netdevsim module. However, this will prevent the
>removal of the module when devices are present, something that is
>possible today.
>
>[1]
>#!/bin/bash
>
>for i in $(seq 1 1000); do
>        echo "$i"
>        insmod drivers/net/netdevsim/netdevsim.ko
>        echo "10 0" > /sys/bus/netdevsim/new_device
>        rmmod netdevsim
>done
>
>[2]
>BUG: unable to handle page fault for address: ffffffffc0490910
>#PF: supervisor instruction fetch in kernel mode
>#PF: error_code(0x0010) - not-present page
>PGD 12e040067 P4D 12e040067 PUD 12e042067 PMD 100a38067 PTE 0
>Oops: 0010 [#1] PREEMPT SMP
>CPU: 0 PID: 138 Comm: kworker/0:2 Not tainted 6.4.0-rc5-custom-g42e05937ca59 #299
>Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc37 04/01/2014
>Workqueue: events devlink_release
>RIP: 0010:0xffffffffc0490910
>Code: Unable to access opcode bytes at 0xffffffffc04908e6.
>RSP: 0018:ffffb487802f3e40 EFLAGS: 00010282
>RAX: ffffffffc0490910 RBX: ffff92e6c0057800 RCX: 0001020304050608
>RDX: 0000000000000001 RSI: ffffffff92b7d763 RDI: ffff92e6c0057800
>RBP: ffff92e6c1ef0a00 R08: ffff92e6c0055158 R09: ffff92e6c2be9134
>R10: 0000000000000018 R11: fefefefefefefeff R12: ffffffff934c3e80
>R13: ffff92e6c2a1a740 R14: 0000000000000000 R15: ffff92e7f7c30b05
>FS:  0000000000000000(0000) GS:ffff92e7f7c00000(0000) knlGS:0000000000000000
>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>CR2: ffffffffc04908e6 CR3: 0000000101f1a004 CR4: 0000000000170ef0
>Call Trace:
> <TASK>
> ? __die+0x23/0x70
> ? page_fault_oops+0x181/0x470
> ? exc_page_fault+0xa6/0x140
> ? asm_exc_page_fault+0x26/0x30
> ? device_release+0x23/0x90
> ? device_release+0x34/0x90
> ? kobject_put+0x7d/0x1b0
> ? devlink_release+0x16/0x30
> ? process_one_work+0x1e0/0x3d0
> ? worker_thread+0x4e/0x3b0
> ? rescuer_thread+0x3a0/0x3a0
> ? kthread+0xe5/0x120
> ? kthread_complete_and_exit+0x20/0x20
> ? ret_from_fork+0x1f/0x30
> </TASK>
>Modules linked in: [last unloaded: netdevsim]
>
>Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

