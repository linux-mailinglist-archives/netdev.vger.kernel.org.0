Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2486037A39D
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhEKJ3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhEKJ3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 05:29:40 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1194C06175F
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 02:28:31 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l2so19387648wrm.9
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 02:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maxiluxsystems-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jcvkcbwx8TNOgxL6sbvrjek3om65F3KTx/QSqV58Ulc=;
        b=b9j8uYVgy7y7xvTjsYN5twr1o2g1kBTPBJiDZulwWLQxwBQ+ddefqtyNGmPAZFrFgQ
         Bapn4iOlqHT2LKmmjp/zzH67ncCV78uwqm3X648Ow1rb3aXsVgLVAemFB4ZuLniQePaA
         DEVJOrFkOI2plQ71H9eANzjr4yX4BfEAAtC/ZcZzW7FkKK0SJRFZ4okXMvW6qGlHsROg
         DtuT76pnBvMZFCi3cOtgDhqdkiO89zK/g8/pYQj40sBrNOJX+wMAWy4OY9xuBFB2iiuz
         JKL3q2cWr+JW+ndOikH095Ja0zkFSUCQT7+In00X1et1z1ZtMvf6RLwU/G8/DLU2YyM0
         ntBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jcvkcbwx8TNOgxL6sbvrjek3om65F3KTx/QSqV58Ulc=;
        b=Kr4xqwBAwrOpoW/QLKn/dW6mkeit30Ct3YOWEbl6uEQLdd3zx91FNMLE5IBGikPoKr
         9A2AVWAkD3pPyTi3KsMnstdBiayZcRb4vEnbYoDwGKH8YPw4+IHQoJA7ZAwNnWwnvydn
         db3tOBUOoy4ne7JE7W/GNTmjJqwX8bItoDgmpi5VXAgDcenJSs7qpvIBsACiX10iE7bZ
         JdU+7cpUgDrSOyXfYKglQPLSln38SLDe8zh70ayG/AxRQqbBOAVfXRpnUgqM8IunJW+u
         vWPhqX7isi8LnJGC88Fe7XGio5AOrYWwizQyJmQmyHjMh/wmp5U0WO8n8B0hjDO+3SlJ
         +9CQ==
X-Gm-Message-State: AOAM532tnwbFToB4TugVxG0fMHcGAv538wXpxlxnbpClw9YszphpAgRr
        ld72VgXx1y6l2GjJknUc4n5qzg==
X-Google-Smtp-Source: ABdhPJyeqsQM2+n//hY38yLue+nL8Z1J2bnHJftN2p1TjSDe6JkkdRbkQLIV7O1E+8ZJWJS0HlYLAQ==
X-Received: by 2002:a5d:44cc:: with SMTP id z12mr37240047wrr.114.1620725310338;
        Tue, 11 May 2021 02:28:30 -0700 (PDT)
Received: from bigthink (92.41.10.184.threembb.co.uk. [92.41.10.184])
        by smtp.gmail.com with ESMTPSA id y2sm3288584wmq.45.2021.05.11.02.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 02:28:30 -0700 (PDT)
Date:   Tue, 11 May 2021 10:28:28 +0100
From:   Torin Cooper-Bennun <torin@maxiluxsystems.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: CAN: TX frames marked as RX after the sending socket is closed
Message-ID: <20210511092828.okg6p7n6efoi2yf2@bigthink>
References: <20210510142302.ijbwowv4usoiqkxq@bigthink>
 <20210510181807.sel6igxglzwqoi44@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510181807.sel6igxglzwqoi44@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 08:18:07PM +0200, Marc Kleine-Budde wrote:
> I have a git feeling that I've found the problem. Can you revert
> e940e0895a82 ("can: skb: can_skb_set_owner(): fix ref counting if socket
> was closed before setting skb ownership") and check if that fixes your
> problem? This might trigger the problem described in the patch:
> 
> | WARNING: CPU: 0 PID: 280 at lib/refcount.c:25 refcount_warn_saturate+0x114/0x134
> | refcount_t: addition on 0; use-after-free.
> | Modules linked in: coda_vpu(E) v4l2_jpeg(E) videobuf2_vmalloc(E) imx_vdoa(E)
> | CPU: 0 PID: 280 Comm: test_can.sh Tainted: G            E     5.11.0-04577-gf8ff6603c617 #203
> | Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> | Backtrace:
> | [<80bafea4>] (dump_backtrace) from [<80bb0280>] (show_stack+0x20/0x24) r7:00000000 r6:600f0113 r5:00000000 r4:81441220
> | [<80bb0260>] (show_stack) from [<80bb593c>] (dump_stack+0xa0/0xc8)
> | [<80bb589c>] (dump_stack) from [<8012b268>] (__warn+0xd4/0x114) r9:00000019 r8:80f4a8c2 r7:83e4150c r6:00000000 r5:00000009 r4:80528f90
> | [<8012b194>] (__warn) from [<80bb09c4>] (warn_slowpath_fmt+0x88/0xc8) r9:83f26400 r8:80f4a8d1 r7:00000009 r6:80528f90 r5:00000019 r4:80f4a8c2
> | [<80bb0940>] (warn_slowpath_fmt) from [<80528f90>] (refcount_warn_saturate+0x114/0x134) r8:00000000 r7:00000000 r6:82b44000 r5:834e5600 r4:83f4d540
> | [<80528e7c>] (refcount_warn_saturate) from [<8079a4c8>] (__refcount_add.constprop.0+0x4c/0x50)
> | [<8079a47c>] (__refcount_add.constprop.0) from [<8079a57c>] (can_put_echo_skb+0xb0/0x13c)
> | [<8079a4cc>] (can_put_echo_skb) from [<8079ba98>] (flexcan_start_xmit+0x1c4/0x230) r9:00000010 r8:83f48610 r7:0fdc0000 r6:0c080000 r5:82b44000 r4:834e5600
> | [<8079b8d4>] (flexcan_start_xmit) from [<80969078>] (netdev_start_xmit+0x44/0x70) r9:814c0ba0 r8:80c8790c r7:00000000 r6:834e5600 r5:82b44000 r4:82ab1f00
> | [<80969034>] (netdev_start_xmit) from [<809725a4>] (dev_hard_start_xmit+0x19c/0x318) r9:814c0ba0 r8:00000000 r7:82ab1f00 r6:82b44000 r5:00000000 r4:834e5600
> | [<80972408>] (dev_hard_start_xmit) from [<809c6584>] (sch_direct_xmit+0xcc/0x264) r10:834e5600 r9:00000000 r8:00000000 r7:82b44000 r6:82ab1f00 r5:834e5600 r4:83f27400
> | [<809c64b8>] (sch_direct_xmit) from [<809c6c0c>] (__qdisc_run+0x4f0/0x534)
> 
> Can you give me feedback if
> 1. the revert "fixes" your problem
> 2. the revert triggers the above backtrace

Always trust your git, it seems... I can confirm this revert both
'fixes' the problem and triggers that backtrace originating from
m_can_tx_handler. I got two of those backtraces during the run, and
sandwiched between them a backtrace from the rx path:

| WARNING: CPU: 2 PID: 22 at lib/refcount.c:28 refcount_warn_saturate+0x13c/0x174
| refcount_t: underflow; use-after-free.
| Modules linked in: can_raw can sha256_generic cfg80211 rfkill 8021q garp stp llc tcan4x5x m_can can_dev spidev v3d raspberrypi_hwmon vc4 gpu_sched cec i2c_bcm2835 bcm2835_isp(C) drm_kms_helper spi_bcm2835 bcm2835_codec(C) v4l2_mem2mem bcm2835_v4l2(C) bcm2835_mmal_vchiq(C) videobuf2_vmalloc videobuf2_dma_contig videobuf2_memops videobuf2_v4l2 videobuf2_common videodev snd_bcm2835(C) mc vc_sm_cma(C) snd_soc_core snd_compress snd_pcm_dmaengine rpivid_mem snd_pcm snd_timer snd syscopyarea sysfillrect sysimgblt fb_sys_fops nvmem_rmem uio_pdrv_genirq uio i2c_dev drm drm_panel_orientation_quirks backlight fuse ip_tables x_tables ipv6
| CPU: 2 PID: 22 Comm: ksoftirqd/2 Tainted: G        WC        5.13.0-rc1-v7l+ #1
| Hardware name: BCM2711
| Backtrace: 
| [<c0bdc4bc>] (dump_backtrace) from [<c0bdc830>] (show_stack+0x20/0x24)
|  r7:ffffffff r6:00000000 r5:60000013 r4:c12e85a4
| [<c0bdc810>] (show_stack) from [<c0be0eec>] (dump_stack+0xc4/0xf0)
| [<c0be0e28>] (dump_stack) from [<c0221194>] (__warn+0xfc/0x158)
|  r9:ef41b540 r8:00000009 r7:0000001c r6:00000009 r5:c075c064 r4:c0e6bfc8
| [<c0221098>] (__warn) from [<c0bdd004>] (warn_slowpath_fmt+0xa4/0xe4)
|  r7:c075c064 r6:0000001c r5:c0e6bfc8 r4:c0e6c004
| [<c0bdcf64>] (warn_slowpath_fmt) from [<c075c064>] (refcount_warn_saturate+0x13c/0x174)
|  r8:00000001 r7:c1323d40 r6:c3f90000 r5:c3eb4e40 r4:c37de240
| [<c075bf28>] (refcount_warn_saturate) from [<c0a3ea80>] (sock_efree+0x50/0x90)
| [<c0a3ea30>] (sock_efree) from [<c0a470a8>] (skb_release_head_state+0x50/0xe4)
| [<c0a47058>] (skb_release_head_state) from [<c0a48fe4>] (consume_skb+0x38/0xe0)
|  r5:c3eb4e40 r4:c37de240
| [<c0a48fac>] (consume_skb) from [<bf32a920>] (can_receive+0xc8/0xf4 [can])
|  r5:c3eb4e40 r4:c37de240
| [<bf32a858>] (can_receive [can]) from [<bf32aa50>] (can_rcv+0x44/0xc0 [can])
|  r9:ef41b540 r8:c3f906a0 r7:c3f90680 r6:00000040 r5:bf32aa0c r4:c37de240
| [<bf32aa0c>] (can_rcv [can]) from [<c0a655ac>] (__netif_receive_skb_one_core+0x68/0x90)
|  r5:bf32aa0c r4:c3f90000
| [<c0a65544>] (__netif_receive_skb_one_core) from [<c0a65620>] (__netif_receive_skb+0x20/0x70)
|  r5:00000001 r4:c37de240
| [<c0a65600>] (__netif_receive_skb) from [<c0a656b0>] (netif_receive_skb+0x40/0x180)
|  r5:00000001 r4:c37de240
| [<c0a65670>] (netif_receive_skb) from [<bf2ae9dc>] (can_rx_offload_napi_poll+0x58/0xb4 [can_dev])
|  r4:c3f90000
| [<bf2ae984>] (can_rx_offload_napi_poll [can_dev]) from [<c0a66d74>] (__napi_poll+0x38/0x1dc)

--
Regards,

Torin Cooper-Bennun
Software Engineer | maxiluxsystems.com

