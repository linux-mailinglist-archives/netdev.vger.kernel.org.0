Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0E36E0843
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 09:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjDMHxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 03:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjDMHxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 03:53:05 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BA826A5;
        Thu, 13 Apr 2023 00:53:04 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v27so4060552wra.13;
        Thu, 13 Apr 2023 00:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681372382; x=1683964382;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uSLy2WsB4UzKKQsE4fvl7v4qRk9XqoClOF9Wj2xWvTs=;
        b=s3PhcPrXtkgN5343ur5rfuKQeUndGpWQ3OSNTsWRknwFlIiD+XoKPeoGiDzH4kpfed
         rGD6xFRV0vKVFgCVbd+7moMT6FYbuhmwiypofrJK+iH3/Mze4f3pBZQ24ylgV8s4euPk
         EoA2YUt1ods/AiQNMx1NzMAyDjnSpx5SzvABxIs3fsE+SD+uA1jgcO2CJCfWXmOAACgA
         5EwdNoy72VMI/2hrDBMziIc7dxLa7h6iHwSgiNEZB6MGW5R2MUPhX62SnAcMxzELcEMI
         zSEAFDdStEARLHsb0FmTJAsFB8lI8exflsvSePhlZLGjFoH/0sNDpuqhbw+2WIMziHtr
         bFvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681372382; x=1683964382;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uSLy2WsB4UzKKQsE4fvl7v4qRk9XqoClOF9Wj2xWvTs=;
        b=N3+f1LIpaRB5hC3Wx3QVrhfp3cpNmwHyUWN6J/pSt5Hjgizoj7pAe5jU2RMjL9zFpf
         UTFfHCA38+VFlu6rmaPlCG3/w7VXDyGeI/5MIMNOXTgmOEEpTYmQVbrN7MV7aDreu1Ob
         dr+d+4f6lt96FA3lNdrwnVIwz2BgvDF34KCY/3ihoDOY3B01+Sfw7NqcWUSQxImj6S2s
         gcPLXC7QKL7p3kSJ2gxQG48tP/K2Z1z/iRwA1R9jmXi1JgMM5kG1up/hIbPwmxINVElN
         wglwCZ0nwGrT8BIl8oZi3+2Vqjxi8yONnS4cEdMZTRA4OFWBa8aKcM88/iHdowz2nyTU
         hWyQ==
X-Gm-Message-State: AAQBX9fxOFjEHR/HoiF4+ytql3I4xOLYfdklUzdF4bGyhb9FYyEAA4/W
        vkmwnoho5QCkqB0dU0kEB7E+K7e/XSU=
X-Google-Smtp-Source: AKy350arb+tJHmHkiyThOD6+pblRSFVoy0iHcmzU3pa1c1ABy/nKXf0qfcSH7YEvO00mLvVlvXxLfg==
X-Received: by 2002:a5d:4091:0:b0:2ef:af48:7b0e with SMTP id o17-20020a5d4091000000b002efaf487b0emr660557wrp.69.1681372382441;
        Thu, 13 Apr 2023 00:53:02 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id e1-20020a056000120100b002ef349e73cbsm688184wrx.19.2023.04.13.00.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 00:53:02 -0700 (PDT)
Date:   Thu, 13 Apr 2023 08:52:59 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Ding Hui <dinghui@sangfor.com.cn>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ecree.xilinx@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pengdonglin@sangfor.com.cn,
        huangcun@sangfor.com.cn
Subject: Re: [RFC PATCH net] sfc: Fix use-after-free due to selftest_work
Message-ID: <ZDe02xqrX/pP0vEN@gmail.com>
Mail-Followup-To: Jacob Keller <jacob.e.keller@intel.com>,
        Ding Hui <dinghui@sangfor.com.cn>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ecree.xilinx@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pengdonglin@sangfor.com.cn,
        huangcun@sangfor.com.cn
References: <20230412005013.30456-1-dinghui@sangfor.com.cn>
 <30e4bf50-7950-0b3c-67b5-6028b7114da2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30e4bf50-7950-0b3c-67b5-6028b7114da2@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 03:34:51PM -0700, Jacob Keller wrote:
> 
> 
> On 4/11/2023 5:50 PM, Ding Hui wrote:
> > There is a use-after-free scenario that is:
> > 
> > When netif_running() is false, user set mac address or vlan tag to VF,
> > the xxx_set_vf_mac() or xxx_set_vf_vlan() will invoke efx_net_stop()
> > and efx_net_open(), since netif_running() is false, the port will not
> > start and keep port_enabled false, but selftest_worker is scheduled
> > in efx_net_open().
> > 
> > If we remove the device before selftest_worker run, the efx is freed,
> > then we will get a UAF in run_timer_softirq() like this:
> > 
> > [ 1178.907941] ==================================================================
> > [ 1178.907948] BUG: KASAN: use-after-free in run_timer_softirq+0xdea/0xe90
> > [ 1178.907950] Write of size 8 at addr ff11001f449cdc80 by task swapper/47/0
> > [ 1178.907950]
> > [ 1178.907953] CPU: 47 PID: 0 Comm: swapper/47 Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
> > [ 1178.907954] Hardware name: SANGFOR X620G40/WI2HG-208T1061A, BIOS SPYH051032-U01 04/01/2022
> > [ 1178.907955] Call Trace:
> > [ 1178.907956]  <IRQ>
> > [ 1178.907960]  dump_stack+0x71/0xab
> > [ 1178.907963]  print_address_description+0x6b/0x290
> > [ 1178.907965]  ? run_timer_softirq+0xdea/0xe90
> > [ 1178.907967]  kasan_report+0x14a/0x2b0
> > [ 1178.907968]  run_timer_softirq+0xdea/0xe90
> > [ 1178.907971]  ? init_timer_key+0x170/0x170
> > [ 1178.907973]  ? hrtimer_cancel+0x20/0x20
> > [ 1178.907976]  ? sched_clock+0x5/0x10
> > [ 1178.907978]  ? sched_clock_cpu+0x18/0x170
> > [ 1178.907981]  __do_softirq+0x1c8/0x5fa
> > [ 1178.907985]  irq_exit+0x213/0x240
> > [ 1178.907987]  smp_apic_timer_interrupt+0xd0/0x330
> > [ 1178.907989]  apic_timer_interrupt+0xf/0x20
> > [ 1178.907990]  </IRQ>
> > [ 1178.907991] RIP: 0010:mwait_idle+0xae/0x370
> > 
> > I am thinking about several ways to fix the issue:
> > 
> > [1] In this RFC, I cancel the selftest_worker unconditionally in
> > efx_pci_remove().
> > 
> > [2] Add a test condition, only invoke efx_selftest_async_start() when
> > efx->port_enabled is true in efx_net_open().
> > 
> > [3] Move invoking efx_selftest_async_start() from efx_net_open() to
> > efx_start_all() or efx_start_port(), that matching cancel action in
> > efx_stop_port().
> > 
> > [4] However, I also notice that in efx_ef10_set_mac_address(), the
> > efx_net_open() depends on original port_enabled, but others are not,
> > if we change all efx_net_open() depends on old state like
> > efx_ef10_set_mac_address() does, the UAF can also be fixed in theory.
> > 
> > But I'm not sure which is better, is there any suggestions? Thanks.
> > 
> 
> I think this fix makes the most sense to me.

For me this is too late. It leaves a gap where the selftest timer is still running
but the NIC has already stopped sending events. So we could still get a
failure "channel %d timed out waiting for event queue" from the selftest.

Martin

> 
> > Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> > ---
> 
> net patches need a Fixes tag indicating what commit this fixes. This
> being RFC is likely why that was left off?
> 
> >  drivers/net/ethernet/sfc/efx.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> > index 884d8d168862..dd0b2363eed1 100644
> > --- a/drivers/net/ethernet/sfc/efx.c
> > +++ b/drivers/net/ethernet/sfc/efx.c
> > @@ -876,6 +876,8 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
> >  	efx->state = STATE_UNINIT;
> >  	rtnl_unlock();
> >  
> > +	efx_selftest_async_cancel(efx);
> > +
> >  	if (efx->type->sriov_fini)
> >  		efx->type->sriov_fini(efx);
> >  
