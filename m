Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED0D457C91
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 09:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbhKTIeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 03:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236995AbhKTIeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 03:34:16 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEC6C061574
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 00:31:13 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id u18so22293255wrg.5
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 00:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=WK97Zv5yzw/1OR7PMuqSW8mkH6syt2WCqDJO8zcx0FI=;
        b=PY11Aso8jxXjC5Do3JWd6POmH4fE3WC8j3+S1jj94GGeWuBSuSLJyzeVIPC2lzi10m
         Ixc7kMhRRdw0WfOh9bvcRe0edojAsSQCpfnR+IexZEidB9GlJ9mP4L11fPdJ8EZDCBwA
         mYjI+ewvcfq9onogJ5u4QRye5lVD7EjpUkWjJhrKL5rg15n37KlKuYZl2jwJGDgm9O7q
         5UOlnRsdkn/YFtt3i2C7aChTgxDZsyPTomztCiV4nyzXNsceGCdDq9xf/1wmiiYzIKaL
         NyZ6662cTNdBPigNMkYOCeCNXsfOP34tD2YJCoPtJ+6v3ISuQ4i8L632hyJqsTcWht3I
         ajVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=WK97Zv5yzw/1OR7PMuqSW8mkH6syt2WCqDJO8zcx0FI=;
        b=mZAQoXgWrme/od6eoFA3geo2ZaixOQlxMENtl28lGnnMb1x7r6DdMdj+tdyyQkn18v
         qNw9s6kf9fXdu5+V93TxHQO6DMiP7iLUKPHzkkWSG2GKkyY5mzk1GwPpVUBYzliCJhis
         qGiiBURKf9s6Qvbhq4Wn4tiuHfGX18SHdjjHD9NzAcp4o6wxLP9LQkNXzJ/3Kg1G1P/q
         OQ3c+jp01oUTU6/YnTI4nDoWD6JKqb9SI3b8/tnYbdCWiqJRKtperSCRrPWBN0yuRvCL
         2P19gRe4/z+I4VVzW2UWVZjVktGSs0W5JOIpsmFKudiCBaQtvVl9C5pGrTjYco7asDo/
         NUsQ==
X-Gm-Message-State: AOAM530wRLOp2YgFnEHNmaZcLD/KMhWZGGABgFi/JpMoaTDYsQiZCXZ+
        Vo/SwnKitRT8zoGB6bI/XEw=
X-Google-Smtp-Source: ABdhPJyDhvm6mVwFI3veALgAuGt5h+MU2qAWCNZj1KOOZgMAY56IeBI8OzRirpR0diJ/HZc1NYbRcQ==
X-Received: by 2002:a5d:40cf:: with SMTP id b15mr15584754wrq.161.1637397071617;
        Sat, 20 Nov 2021 00:31:11 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id 10sm2505852wrb.75.2021.11.20.00.31.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 20 Nov 2021 00:31:11 -0800 (PST)
Date:   Sat, 20 Nov 2021 08:31:07 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        Dinan Gunawardena <dinang@xilinx.com>
Subject: Re: Bad performance in RX with sfc 40G
Message-ID: <20211120083107.z2cm7tkl2rsri2v7@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        Dinan Gunawardena <dinang@xilinx.com>
References: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 04:14:35PM +0100, Íñigo Huguet wrote:
> Hello,
> 
> Doing some tests a few weeks ago I noticed a very low performance in
> RX using 40G Solarflare NICs. Doing tests with iperf3 I got more than
> 30Gbps in TX, but just around 15Gbps in RX. Other NICs from other
> vendors could send and receive over 30Gbps.
> 
> I was doing the tests with multiple threads in iperf3 (-P 8).
> 
> The models used are SFC9140 and SFC9220.
> 
> Perf showed that most of the time was being expended in
> `native_queued_spin_lock_slowpath`. Tracing the calls to it with
> bpftrace I got that most of the calls were from __napi_poll > efx_poll
> > efx_fast_push_rx_descriptors > __alloc_pages >
> get_page_from_freelist > ...
> 
> Please can you help me investigate the issue? At first sight, it seems
> a not very optimal memory allocation strategy, or maybe a failure in
> pages recycling strategy...

Apologies for the late reply. I'm having trouble digging out a
machine to test this.
If you're testing without the IOMMU enabled I suspect the recycle ring
size may be too small. Can your try the patch below?

Martin

diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 68fc7d317693..e37702bf3380 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -28,7 +28,7 @@ MODULE_PARM_DESC(rx_refill_threshold,
  * the number of pages to store in the RX page recycle ring.
  */
 #define EFX_RECYCLE_RING_SIZE_IOMMU 4096
-#define EFX_RECYCLE_RING_SIZE_NOIOMMU (2 * EFX_RX_PREFERRED_BATCH)
+#define EFX_RECYCLE_RING_SIZE_NOIOMMU 1024
 
 /* RX maximum head room required.
  *


> 
> This is the output of bpftrace, the 2 call chains that repeat more
> times, both from sfc
> 
> @[
>     native_queued_spin_lock_slowpath+1
>     _raw_spin_lock+26
>     rmqueue_bulk+76
>     get_page_from_freelist+2295
>     __alloc_pages+214
>     efx_fast_push_rx_descriptors+640
>     efx_poll+660
>     __napi_poll+42
>     net_rx_action+547
>     __softirqentry_text_start+208
>     __irq_exit_rcu+179
>     common_interrupt+131
>     asm_common_interrupt+30
>     cpuidle_enter_state+199
>     cpuidle_enter+41
>     do_idle+462
>     cpu_startup_entry+25
>     start_kernel+2465
>     secondary_startup_64_no_verify+194
> ]: 2650
> @[
>     native_queued_spin_lock_slowpath+1
>     _raw_spin_lock+26
>     rmqueue_bulk+76
>     get_page_from_freelist+2295
>     __alloc_pages+214
>     efx_fast_push_rx_descriptors+640
>     efx_poll+660
>     __napi_poll+42
>     net_rx_action+547
>     __softirqentry_text_start+208
>     __irq_exit_rcu+179
>     common_interrupt+131
>     asm_common_interrupt+30
>     cpuidle_enter_state+199
>     cpuidle_enter+41
>     do_idle+462
>     cpu_startup_entry+25
>     secondary_startup_64_no_verify+194
> ]: 17119
> 
> --
> Íñigo Huguet
