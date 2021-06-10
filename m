Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FC93A3607
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhFJVfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbhFJVfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 17:35:30 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B45AC061574;
        Thu, 10 Jun 2021 14:33:21 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id h1so1752544plt.1;
        Thu, 10 Jun 2021 14:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BkmsrmT6fuXGNrlHXcAKvLyJZ4AEYI2iH2SKvMajdQQ=;
        b=bHmf5/GOMFfbz1oUA84e+L0Nifd4JaN0lS458FrFqoZwyLDfVh85itsJWjdZ3Ovd7k
         k4sLkOmxpNmRncQr9qFEk3B40rZSJXJ7/14UKSzIsOUFKw93FKQnZz7Oms9ub7/goTjX
         6bvCXoJcsJWFMMeFym85P5SFR0+c/YOXXJRZ764XTFICVbaIPC5fO9hm/+7qbsAXNINI
         SA67qdaNYajwhCffJk0FESHG8+imI7waKS1AxjAxrkOdQLWHHPp8h32WEuBY7/L23f5q
         SFSusfrfXwD25pYRZcviYsH+H8X4zpdeVTUNBuf+0ajMPxjaFlLqGROtHwXy/ft67wPD
         noUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BkmsrmT6fuXGNrlHXcAKvLyJZ4AEYI2iH2SKvMajdQQ=;
        b=DM7t3P6dGMxk6qlIkFLymVH1EGuHePMl8fjWqvr75hV/DHJP4RlsIQQAZsSSc3P04L
         pIE7v8dt/gzOcER3XSXC4nY6qndstfvOXSRfbGYVSVG61VArTqtyZuhndPXLpmSzKfF3
         nBWOkvCalU4nBnpXTATj0boct4ZatQwsw0g+SNvTGn9idg+IYOTfxb2w6tcWA4kPoWUl
         FjQjt34kNyNIGXhztN87vXyoaAvMBZH3zFYLZvxIrAIRvJz9fy4N+eeCDs8z1MNDCYjz
         38FBPRzZn09h777DasKNwl1p7Fczue45V0doTRsFCjEqPE7s08A7YmRD82UgzwFHERsB
         q61Q==
X-Gm-Message-State: AOAM532Fvx4jZHPGy0+r+Qct1vetHGtjkUokme5DYabe8DlrUQtsUNKB
        8+d4tVY2lwyfODMUc8qKRIFuAXR1QgW+jQ==
X-Google-Smtp-Source: ABdhPJyRHwUGjSdWXa8AF+8oaLqybbVMjAtOecL98HYc/DFkz9glTAmQKKinNKpsq0DzrbQpev8hkg==
X-Received: by 2002:a17:902:9b83:b029:ef:4dd5:beab with SMTP id y3-20020a1709029b83b02900ef4dd5beabmr727670plp.76.1623360799585;
        Thu, 10 Jun 2021 14:33:19 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id y15sm3330142pji.47.2021.06.10.14.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 14:33:19 -0700 (PDT)
Subject: Re: Kernel Panic in skb_release_data using genet
To:     Maxime Ripard <maxime@cerno.tech>,
        nicolas saenz julienne <nsaenz@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20210524130147.7xv6ih2e3apu2zvu@gilmour>
 <a53f6192-3520-d5f8-df4b-786b3e4e8707@gmail.com>
 <20210524151329.5ummh4dfui6syme3@gilmour>
 <1482eff4-c5f4-66d9-237c-55a096ae2eb4@gmail.com>
 <6caa98e7-28ba-520c-f0cc-ee1219305c17@gmail.com>
 <20210528163219.x6yn44aimvdxlp6j@gilmour>
 <77d412b4-cdd6-ea86-d7fd-adb3af8970d9@gmail.com>
 <9e99ade5-ebfc-133e-ac61-1aba07ca80a2@gmail.com>
 <483c73edf02fa0139aae2b81e797534817655ea0.camel@kernel.org>
 <20210602132822.5hw4yynjgoomcfbg@gilmour>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <681f7369-90c7-0d2a-18a3-9a10917ce5f3@gmail.com>
Date:   Thu, 10 Jun 2021 14:33:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210602132822.5hw4yynjgoomcfbg@gilmour>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2021 6:28 AM, Maxime Ripard wrote:
> On Tue, Jun 01, 2021 at 11:33:18AM +0200, nicolas saenz julienne wrote:
>> On Mon, 2021-05-31 at 19:36 -0700, Florian Fainelli wrote:
>>>> That is also how I boot my Pi4 at home, and I suspect you are right, if
>>>> the VPU does not shut down GENET's DMA, and leaves buffer addresses in
>>>> the on-chip descriptors that point to an address space that is managed
>>>> totally differently by Linux, then we can have a serious problem and
>>>> create some memory corruption when the ring is being reclaimed. I will
>>>> run a few experiments to test that theory and there may be a solution
>>>> using the SW_INIT reset controller to have a big reset of the controller
>>>> before handing it over to the Linux driver.
>>>
>>> Adding a WARN_ON(reg & DMA_EN) in bcmgenet_dma_disable() has not shown
>>> that the TX or RX DMA have been left running during the hand over from
>>> the VPU to the kernel. I checked out drm-misc-next-2021-05-17 to reduce
>>> as much as possible the differences between your set-up and my set-up
>>> but so far have not been able to reproduce the crash in booting from NFS
>>> repeatedly, I will try again.
>>
>> FWIW I can reproduce the error too. That said it's rather hard to reproduce,
>> something in the order of 1 failure every 20 tries.
> 
> Yeah, it looks like it's only from a cold boot and comes in "bursts",
> where you would get like 5 in a row and be done with it for a while.

Here are two patches that you could try exclusive from one another

1) Limit GENET to a single queue

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index fcca023f22e5..e400c12e6868 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3652,6 +3652,12 @@ static int bcmgenet_change_carrier(struct
net_device *dev, bool new_carrier)
        return 0;
 }

+static u16 bcmgenet_select_queue(struct net_device *dev, struct sk_buff
*skb,
+                                struct net_device *sb_dev)
+{
+       return 0;
+}
+
 static const struct net_device_ops bcmgenet_netdev_ops = {
        .ndo_open               = bcmgenet_open,
        .ndo_stop               = bcmgenet_close,
@@ -3666,6 +3672,7 @@ static const struct net_device_ops
bcmgenet_netdev_ops = {
 #endif
        .ndo_get_stats          = bcmgenet_get_stats,
        .ndo_change_carrier     = bcmgenet_change_carrier,
+       .ndo_select_queue       = bcmgenet_select_queue,
 };

 /* Array of GENET hardware parameters/characteristics */

2) Ensure that all TX/RX queues are disabled upon DMA initialization

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index fcca023f22e5..7f8a5996fbbb 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3237,15 +3237,21 @@ static void bcmgenet_get_hw_addr(struct
bcmgenet_priv *priv,
 /* Returns a reusable dma control register value */
 static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
 {
+       unsigned int i;
        u32 reg;
        u32 dma_ctrl;

        /* disable DMA */
        dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
+       for (i = 0; i < priv->hw_params->tx_queues; i++)
+               dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
        reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
        reg &= ~dma_ctrl;
        bcmgenet_tdma_writel(priv, reg, DMA_CTRL);

+       dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
+       for (i = 0; i < priv->hw_params->rx_queues; i++)
+               dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
        reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
        reg &= ~dma_ctrl;
        bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
-- 
Florian
