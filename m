Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199D06E1F98
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 11:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjDNJpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 05:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjDNJpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 05:45:07 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1085260;
        Fri, 14 Apr 2023 02:45:04 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id gw13so10005219wmb.3;
        Fri, 14 Apr 2023 02:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681465503; x=1684057503;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6qy4bLky1iKHhaOxiP+dgxaMOWcfhl18VGnOVmDjYdY=;
        b=OSk2V2zPl4m8MSI8EKk29CbUkD5yPcI/woegkzsQEgWljBofygTGaOVm8ISbYmSLVJ
         oLqXHbqLI2wbe1+ODaaKG2ANxaTi/k2R/f0nvuuriPyj6WosRYv8QsV/0f7z2q0aTaw7
         gJ8vghPZ94e98h+tKYZw66ZzfIOO3TPpMATwowovw49cvMg6NEtp6c5gIK1fRb40qN7X
         og56Fqy/D1jCKu8+X6t32YECoYilnqITlX0vy9uvdI50jLeDWnb5qWavUZi9LiKdjPjQ
         bGyICU4W4K3lSuB6PHfl25GhpAzMnrNXTIpuRTqyBM1DJdeZ/zvcdJPG35+P6PnkGc0b
         LUZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681465503; x=1684057503;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6qy4bLky1iKHhaOxiP+dgxaMOWcfhl18VGnOVmDjYdY=;
        b=UKXt/4578+e6tF2/3fP1oRowsta53vtng1Cjw1qJtWOQDsTGRZ61tDcvTw66eBZT+z
         VJPBC6W/Va/NTBnbdWMDkDmw+y1cnEMhS+z4LdqqfeJUgCpl8wyHmlNmsdkDUpt+1MjI
         kv2OmH9VXmbIoW7TcrWXUQhakD//IWvWOQBxy7VJl3Na5uObZ5F1Rdck18BEwAALv9hn
         QzSSrTT6DFhAbyaNXgyaPUJofmvm9QfMP2J7eKvG5HUrw9nFJLRYY6XU9DpZugo6hb+o
         Yd5Zl6/0Myxql67hkv8vd+N8CkU3oYcNwEoJ+9VD0Xms6FQEqJDNWa5ueLwmuZCGX86T
         AvIA==
X-Gm-Message-State: AAQBX9cBeuKRft6KaEO743F3RyxO3pKbjsASgMHe4dvEgZCulKNWIOc6
        ckPxapQUSFnRI8cYCuxXO9c=
X-Google-Smtp-Source: AKy350aE8I7xLEaGZwye0Ass314qVwp6cCaYgbwZrTUpPzjsHTEtmDrO8YPQawejPtn7pvNXsKNMAQ==
X-Received: by 2002:a1c:4b19:0:b0:3f0:6b33:a5e1 with SMTP id y25-20020a1c4b19000000b003f06b33a5e1mr4027298wma.9.1681465502551;
        Fri, 14 Apr 2023 02:45:02 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id v5-20020a05600c444500b003f09cda253esm7654623wmn.34.2023.04.14.02.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 02:45:02 -0700 (PDT)
Date:   Fri, 14 Apr 2023 10:44:59 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Ding Hui <dinghui@sangfor.com.cn>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ecree.xilinx@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pengdonglin@sangfor.com.cn,
        huangcun@sangfor.com.cn
Subject: Re: [RFC PATCH net] sfc: Fix use-after-free due to selftest_work
Message-ID: <ZDkgm/Ub/zXIU7+p@gmail.com>
Mail-Followup-To: Ding Hui <dinghui@sangfor.com.cn>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ecree.xilinx@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pengdonglin@sangfor.com.cn,
        huangcun@sangfor.com.cn
References: <20230412005013.30456-1-dinghui@sangfor.com.cn>
 <ZDew+TqjrcK+zSgW@gmail.com>
 <7a1de6be-8956-b1d5-6351-c7c2fb3bf9f4@sangfor.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a1de6be-8956-b1d5-6351-c7c2fb3bf9f4@sangfor.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 04:35:08PM +0800, Ding Hui wrote:
> On 2023/4/13 15:37, Martin Habets wrote:
> > On Wed, Apr 12, 2023 at 08:50:13AM +0800, Ding Hui wrote:
> > > There is a use-after-free scenario that is:
> > > 
> > > When netif_running() is false, user set mac address or vlan tag to VF,
> > > the xxx_set_vf_mac() or xxx_set_vf_vlan() will invoke efx_net_stop()
> > > and efx_net_open(), since netif_running() is false, the port will not
> > > start and keep port_enabled false, but selftest_worker is scheduled
> > > in efx_net_open().
> > > 
> > > If we remove the device before selftest_worker run, the efx is freed,
> > > then we will get a UAF in run_timer_softirq() like this:
> > > 
> > > [ 1178.907941] ==================================================================
> > > [ 1178.907948] BUG: KASAN: use-after-free in run_timer_softirq+0xdea/0xe90
> > > [ 1178.907950] Write of size 8 at addr ff11001f449cdc80 by task swapper/47/0
> > > [ 1178.907950]
> > > [ 1178.907953] CPU: 47 PID: 0 Comm: swapper/47 Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
> > > [ 1178.907954] Hardware name: SANGFOR X620G40/WI2HG-208T1061A, BIOS SPYH051032-U01 04/01/2022
> > > [ 1178.907955] Call Trace:
> > > [ 1178.907956]  <IRQ>
> > > [ 1178.907960]  dump_stack+0x71/0xab
> > > [ 1178.907963]  print_address_description+0x6b/0x290
> > > [ 1178.907965]  ? run_timer_softirq+0xdea/0xe90
> > > [ 1178.907967]  kasan_report+0x14a/0x2b0
> > > [ 1178.907968]  run_timer_softirq+0xdea/0xe90
> > > [ 1178.907971]  ? init_timer_key+0x170/0x170
> > > [ 1178.907973]  ? hrtimer_cancel+0x20/0x20
> > > [ 1178.907976]  ? sched_clock+0x5/0x10
> > > [ 1178.907978]  ? sched_clock_cpu+0x18/0x170
> > > [ 1178.907981]  __do_softirq+0x1c8/0x5fa
> > > [ 1178.907985]  irq_exit+0x213/0x240
> > > [ 1178.907987]  smp_apic_timer_interrupt+0xd0/0x330
> > > [ 1178.907989]  apic_timer_interrupt+0xf/0x20
> > > [ 1178.907990]  </IRQ>
> > > [ 1178.907991] RIP: 0010:mwait_idle+0xae/0x370
> > > 
> > > I am thinking about several ways to fix the issue:
> > > 
> > > [1] In this RFC, I cancel the selftest_worker unconditionally in
> > > efx_pci_remove().
> > > 
> > > [2] Add a test condition, only invoke efx_selftest_async_start() when
> > > efx->port_enabled is true in efx_net_open().
> > > 
> > > [3] Move invoking efx_selftest_async_start() from efx_net_open() to
> > > efx_start_all() or efx_start_port(), that matching cancel action in
> > > efx_stop_port().
> > 
> > I think moving this to efx_start_port() is best, as you say to match
> > the cancel in efx_stop_port().
> > 
> 
> If moving to efx_start_port(), should we worry about that IRQ_TIMEOUT
> is still enough?

1 second is a long time for a machine running code, so it does not worry me.

> I'm not sure if there is a long time waiting from starting of schedule
> selftest_work to the ending of efx_net_open().

I see your point. Looking at efx_start_all() there is the call to
efx_start_datapath() after the call to efx_net_open(), which takes a
relatively long time (well under 200ms though).
Logically it would be better to move efx_selftest_async_start() after this
call. What do you think?

The point here is that efx_start_all() calls efx_start_port() early, and
efx_stop_all() also calls efx_stop_port() early. The calling sequence is
correct but they are not the strict inverse of each other.

Martin

> 
> -- 
> Thanks,
> - Ding Hui
