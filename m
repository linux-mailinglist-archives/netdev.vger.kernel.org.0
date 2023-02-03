Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCD7689325
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjBCJJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbjBCJJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:09:21 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0911717F
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:09:20 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l37-20020a05600c1d2500b003dfe46a9801so1846467wms.0
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 01:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TTEFguO7zgpryihfaUdW7/wFD9Fer9IvXnh5N1+G9Jw=;
        b=pdj6CxBrWwEQgM/p2N9SoNKzRdTjm+qySKENErr1dUkO9RUUNzgFgT0J10wiDE1+j1
         5wvPikPFrbiTsXRnt1B0qtGLDtgVfpqqoovq27Wg03Z23xCQ4XOyLr4MET/qEKvDLys2
         3JBlyg75Xo8IDTOBNRxrxImqFT+3eSobiSB0rwDs+hrkT7BkiEYWasU1df1bnVfne5iO
         amePTkSzq192G26lOL81EORkTFVBBtnDc2/CS//6+reL1RT1oGVOnEohcIwD98CcUYno
         mZI9X6dg4JIxqUfgzvNarCzH5L7RoGkWOFHFzypTyjVNS+YcEL9kzowdeIQYTAtVBtFT
         KRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TTEFguO7zgpryihfaUdW7/wFD9Fer9IvXnh5N1+G9Jw=;
        b=tcVQQBBVznbtKMg+LlJRkW1LOJ7yHNdMjmifSlCgmy59+IpVbosulPENtO/7QqyCmk
         7+8BDWwRK1zV8uYWPH0Cif7AlFZ/uqaOlrHuQFIYqTUEfn8+mQQEMR0xL0OhhuRtaPdY
         JjA2AbxNUWMIg0t1O57uQ/5EdB37UW1e5SwGo1555gunHIi9Pl7DrUlVY4jeN42ZZNPf
         cZmXmMwsyuMu+qZvgxQxkEICNz+P1f82ex51mjIypIdlzAiOpL4dFn3Mvk9Bj47VQ24x
         w9teGz6F8+YGa+ni0gxj8zbFadKJ/lGPaM5mEa4boYXoHisSljPaFkGsz78Rp6z2G2jh
         ILeQ==
X-Gm-Message-State: AO0yUKUi+ZWbWrlYKgq3zg7WajTZHiZGPV3/Ojb2LJtkMzyl7pnsKRsU
        Rg6T08SAkBYXi+W4U54vQoQ=
X-Google-Smtp-Source: AK7set+8ldP69Owt88BxfrvAxFOaiGG1DG/2CD+ENTqHMQXI0cTyyz9455Ts8lAsbsL7A8uXuePoaw==
X-Received: by 2002:a05:600c:b86:b0:3db:2dbb:d70e with SMTP id fl6-20020a05600c0b8600b003db2dbbd70emr8828518wmb.6.1675415359084;
        Fri, 03 Feb 2023 01:09:19 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id p16-20020a05600c469000b003a84375d0d1sm7727176wmo.44.2023.02.03.01.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 01:09:18 -0800 (PST)
Date:   Fri, 3 Feb 2023 09:09:16 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        yangbo.lu@nxp.com, mlichvar@redhat.com,
        gerhard@engleder-embedded.com, ecree.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alex.maftei@amd.com
Subject: Re: PTP vclock: BUG: scheduling while atomic
Message-ID: <Y9zPPON16NEbzw86@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com, yangbo.lu@nxp.com,
        mlichvar@redhat.com, gerhard@engleder-embedded.com,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alex.maftei@amd.com
References: <69d0ff33-bd32-6aa5-d36c-fbdc3c01337c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69d0ff33-bd32-6aa5-d36c-fbdc3c01337c@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 05:02:07PM +0100, Íñigo Huguet wrote:
> Hello,
> 
> Our QA team was testing PTP vclocks, and they've found this error with sfc NIC/driver:
>   BUG: scheduling while atomic: ptp5/25223/0x00000002
> 
> The reason seems to be that vclocks disable interrupts with `spin_lock_irqsave` in
> `ptp_vclock_gettime`, and then read the timecounter, which in turns ends calling to
> the driver's `gettime64` callback.
> 
> Vclock framework was added in commit 5d43f951b1ac ("ptp: add ptp virtual clock driver
> framework").

Looking at that commit we'll face the same spinlock issue in
ptp_vclock_adjfine and ptp_vclock_adjtime.

> At first glance, it seems that vclock framework is reusing the already existing callbacks
> of the drivers' ptp clocks, but it's imposing a new limitation that didn't exist before:
> now they can't sleep (due the spin_lock_irqsave). Sfc driver might sleep waiting for the
> fw response.
> 
> Sfc driver can be fixed to avoid this issue, but I wonder if something might not be
> correct in the vclock framework. I don't have enough knowledge about how clocks
> synchronization should work regarding this, so I leave it to your consideration.

If the timer hardware is local to the CPU core a spinlock could work.
But if it global across CPUs, or like in our case remote behind a PCI bus,
using a spinlock is too much of a restriction.
I also wonder why the spinlock was used, and if that limitation can be
reduced.

Martin

> These are the logs with stack traces:
>  BUG: scheduling while atomic: ptp5/25223/0x00000002
>  [...skip...]
>  Call Trace:
>   dump_stack_lvl+0x34/0x48
>   __schedule_bug.cold+0x47/0x53
>   __schedule+0x40e/0x580
>   schedule+0x43/0xa0
>   schedule_timeout+0x88/0x160
>   ? __bpf_trace_tick_stop+0x10/0x10
>   _efx_mcdi_rpc_finish+0x2a9/0x480 [sfc]
>   ? efx_mcdi_send_request+0x1d5/0x260 [sfc]
>   ? dequeue_task_stop+0x70/0x70
>   _efx_mcdi_rpc.constprop.0+0xcd/0x3d0 [sfc]
>   ? update_load_avg+0x7e/0x730
>   _efx_mcdi_rpc_evb_retry+0x5d/0x1d0 [sfc]
>   efx_mcdi_rpc+0x10/0x20 [sfc]
>   efx_phc_gettime+0x5f/0xc0 [sfc]
>   ptp_vclock_read+0xa3/0xc0
>   timecounter_read+0x11/0x60
>   ptp_vclock_refresh+0x31/0x60
>   ? ptp_clock_release+0x50/0x50
>   ptp_aux_kworker+0x19/0x40
>   kthread_worker_fn+0xa9/0x250
>   ? kthread_should_park+0x30/0x30
>   kthread+0x146/0x170
>   ? set_kthread_struct+0x50/0x50
>   ret_from_fork+0x1f/0x30
>  BUG: scheduling while atomic: ptp5/25223/0x00000000
>  [...skip...]
>  Call Trace:
>   dump_stack_lvl+0x34/0x48
>   __schedule_bug.cold+0x47/0x53
>   __schedule+0x40e/0x580
>   ? ptp_clock_release+0x50/0x50
>   schedule+0x43/0xa0
>   kthread_worker_fn+0x128/0x250
>   ? kthread_should_park+0x30/0x30
>   kthread+0x146/0x170
>   ? set_kthread_struct+0x50/0x50
>   ret_from_fork+0x1f/0x30
