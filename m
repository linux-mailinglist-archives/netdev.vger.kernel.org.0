Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A096E235A
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 14:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjDNMd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 08:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjDNMdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 08:33:55 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137DDD7;
        Fri, 14 Apr 2023 05:33:54 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e7so7262171wrc.12;
        Fri, 14 Apr 2023 05:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681475632; x=1684067632;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uvla7Msf6LOpeHcLRGRKcL7v0vF3JDugFuz78yM9KIU=;
        b=NQhC3LioBxqP5wS6z1zTGCLGpP9u7qtQp6NE4y6GgZ5i1FTeSulJDZ1+U+ZTbF2lZo
         98MNM9RHown12DA4B68j6B6c3aZTearTVTQ8xdfHRizaWsXG50fq8sV15U5f8yKXPt96
         BGk+rqxtv2K+ng3K2uSwtYtLVsgTBE1N1YDBZ2HqloaulvO4yvZJuyTPK3yVUFgv9etm
         NABoDDzlFK8IuHWk1PXw/Zk7g755c56dK7QHmWNqXrApTxMH4FtZfH5F5n2iHrmq1nsP
         B8Pif8XYBlbigR/aMoukP1xhotqjWw2Q5qYVIX8KKgQKLJ2N7aGCVKYU0Wx6iPeUvkKZ
         rykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681475632; x=1684067632;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uvla7Msf6LOpeHcLRGRKcL7v0vF3JDugFuz78yM9KIU=;
        b=ZBzGrJr+38zEA043bh7vjVmnHBgWt+Bk5TC7DC20anBrmCMRZluAIe63dI1XzMasIv
         dCpiG7Yn9GcFipstgomq8e1MALN+1BPGmuFeihgWxZ3V++ogP8uZ2MxslO/bLWti/9QL
         YzPSgWf+3R/ErIr8w9G1xJIyIhvUx0KRaU5zjzeXiLlqCXdLVN1C6THtO43o9D0QtL0M
         E4PQiKwrXNfAkeZQfZqKMu0FaK53f69SlYW10GomSTTiY14EFyTFRpTmM4UPhIiFvJ/C
         vJGYg2OOOoqVYySxpkDngL1nHXv8/J3S8wpsoil1/apNSCz/sFsaIKAhDUsmlnMT5neH
         QTow==
X-Gm-Message-State: AAQBX9ffBqPNo9XJ1rYmQ6TJzwbQouTua/LjRyFrvzokSyK5+SWo4yav
        /U2sPLr07iTNjlOcrGHMe28PIjDogmc=
X-Google-Smtp-Source: AKy350YSVk92XEpl/If1YXc0KdX/7n2Wb8XRQ9z2MdBpMmH2b6qLBPJHlfdYrXCW4umj+QJWV98Ppg==
X-Received: by 2002:a5d:6d45:0:b0:2f2:1379:6b18 with SMTP id k5-20020a5d6d45000000b002f213796b18mr4681992wri.9.1681475632388;
        Fri, 14 Apr 2023 05:33:52 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id t5-20020adfeb85000000b002e71156b0fcsm3481033wrn.6.2023.04.14.05.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 05:33:51 -0700 (PDT)
Date:   Fri, 14 Apr 2023 13:33:49 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Ding Hui <dinghui@sangfor.com.cn>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ecree.xilinx@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pengdonglin@sangfor.com.cn,
        huangcun@sangfor.com.cn
Subject: Re: [RFC PATCH net] sfc: Fix use-after-free due to selftest_work
Message-ID: <ZDlILcEDU16YgTT/@gmail.com>
Mail-Followup-To: Ding Hui <dinghui@sangfor.com.cn>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ecree.xilinx@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pengdonglin@sangfor.com.cn,
        huangcun@sangfor.com.cn
References: <20230412005013.30456-1-dinghui@sangfor.com.cn>
 <ZDew+TqjrcK+zSgW@gmail.com>
 <7a1de6be-8956-b1d5-6351-c7c2fb3bf9f4@sangfor.com.cn>
 <ZDkgm/Ub/zXIU7+p@gmail.com>
 <a7cb0d9e-7519-f90c-bd58-eab9ee82b3dc@sangfor.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7cb0d9e-7519-f90c-bd58-eab9ee82b3dc@sangfor.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 07:03:41PM +0800, Ding Hui wrote:
> On 2023/4/14 17:44, Martin Habets wrote:
> > On Thu, Apr 13, 2023 at 04:35:08PM +0800, Ding Hui wrote:
> > > On 2023/4/13 15:37, Martin Habets wrote:
> > > > On Wed, Apr 12, 2023 at 08:50:13AM +0800, Ding Hui wrote:
> > > > > There is a use-after-free scenario that is:
> > > > > 
> > > > > When netif_running() is false, user set mac address or vlan tag to VF,
> > > > > the xxx_set_vf_mac() or xxx_set_vf_vlan() will invoke efx_net_stop()
> > > > > and efx_net_open(), since netif_running() is false, the port will not
> > > > > start and keep port_enabled false, but selftest_worker is scheduled
> > > > > in efx_net_open().
> > > > > 
> > > > > If we remove the device before selftest_worker run, the efx is freed,
> > > > > then we will get a UAF in run_timer_softirq() like this:
> > > > > 
> > > > > [ 1178.907941] ==================================================================
> > > > > [ 1178.907948] BUG: KASAN: use-after-free in run_timer_softirq+0xdea/0xe90
> > > > > [ 1178.907950] Write of size 8 at addr ff11001f449cdc80 by task swapper/47/0
> > > > > [ 1178.907950]
> > > > > [ 1178.907953] CPU: 47 PID: 0 Comm: swapper/47 Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
> > > > > [ 1178.907954] Hardware name: SANGFOR X620G40/WI2HG-208T1061A, BIOS SPYH051032-U01 04/01/2022
> > > > > [ 1178.907955] Call Trace:
> > > > > [ 1178.907956]  <IRQ>
> > > > > [ 1178.907960]  dump_stack+0x71/0xab
> > > > > [ 1178.907963]  print_address_description+0x6b/0x290
> > > > > [ 1178.907965]  ? run_timer_softirq+0xdea/0xe90
> > > > > [ 1178.907967]  kasan_report+0x14a/0x2b0
> > > > > [ 1178.907968]  run_timer_softirq+0xdea/0xe90
> > > > > [ 1178.907971]  ? init_timer_key+0x170/0x170
> > > > > [ 1178.907973]  ? hrtimer_cancel+0x20/0x20
> > > > > [ 1178.907976]  ? sched_clock+0x5/0x10
> > > > > [ 1178.907978]  ? sched_clock_cpu+0x18/0x170
> > > > > [ 1178.907981]  __do_softirq+0x1c8/0x5fa
> > > > > [ 1178.907985]  irq_exit+0x213/0x240
> > > > > [ 1178.907987]  smp_apic_timer_interrupt+0xd0/0x330
> > > > > [ 1178.907989]  apic_timer_interrupt+0xf/0x20
> > > > > [ 1178.907990]  </IRQ>
> > > > > [ 1178.907991] RIP: 0010:mwait_idle+0xae/0x370
> > > > > 
> > > > > I am thinking about several ways to fix the issue:
> > > > > 
> > > > > [1] In this RFC, I cancel the selftest_worker unconditionally in
> > > > > efx_pci_remove().
> > > > > 
> > > > > [2] Add a test condition, only invoke efx_selftest_async_start() when
> > > > > efx->port_enabled is true in efx_net_open().
> > > > > 
> > > > > [3] Move invoking efx_selftest_async_start() from efx_net_open() to
> > > > > efx_start_all() or efx_start_port(), that matching cancel action in
> > > > > efx_stop_port().
> > > > 
> > > > I think moving this to efx_start_port() is best, as you say to match
> > > > the cancel in efx_stop_port().
> > > > 
> > > 
> > > If moving to efx_start_port(), should we worry about that IRQ_TIMEOUT
> > > is still enough?
> > 
> > 1 second is a long time for a machine running code, so it does not worry me.
> > 
> > > I'm not sure if there is a long time waiting from starting of schedule
> > > selftest_work to the ending of efx_net_open().
> > 
> > I see your point. Looking at efx_start_all() there is the call to
> > efx_start_datapath() after the call to efx_net_open(), which takes a
>                                          ^^^^^^^^^^^^
> Do you mean efx_start_port()?

Woops, yes that what I meant.

> > relatively long time (well under 200ms though).
> > Logically it would be better to move efx_selftest_async_start() after this
> > call. What do you think?
> 
> Agree with you.
> 
> > The point here is that efx_start_all() calls efx_start_port() early, and
> > efx_stop_all() also calls efx_stop_port() early. The calling sequence is
> > correct but they are not the strict inverse of each other.
> > 
> 
> Yeah, that is what I noticed monitor_work does.
> Then I'll move efx_selftest_async_start() into efx_start_all(), follows
> the monitor_work.

Sounds good.

Thanks,
Martin

> -- 
> Thanks,
> - Ding Hui
