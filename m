Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4092D5213A1
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240989AbiEJL1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 07:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240988AbiEJL1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 07:27:41 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698282ABBF4
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 04:23:42 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y21so19604414edo.2
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 04:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=LctLxw6WJgRnNRfVYjXR7qnVGoqfoOtpSvD0+ebnLhE=;
        b=RIz6tvyYGEz0K9vamq4/wwycNP/liF7QX/Z9HdwDgI5dUlz7Cbb4ZSh4cNdQ30NHYW
         g9CLZq6b4CTTxObQIfLBGIszm9KrxVisfOV8iHosRpUmBar4igC6mTznUVX9pZfDEU93
         /DGLoowijKW/LABhcbEPyHE6QhwnURkNuGr8ltIteK+1seVYbLQU6QCryseLVIQhObYH
         2QByimVv6/9QYX37sDPKysqJK2l1ssVq7oX4HcpUDUE1O0BJHgx/eUP+pCPo3N2sGHnQ
         f9CSJfFClBUf+lGIzgSaw1RW2zuguTXrBvpkZa0j4YI6AytU5S3ystD1DTZNdKkaGaOz
         ilaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LctLxw6WJgRnNRfVYjXR7qnVGoqfoOtpSvD0+ebnLhE=;
        b=5KNgENUuoh0byvSQHYt2oKZh2yUnYYLAG9sycwWWcVx1uoEd5OyGFqSHF5Oha4mRFW
         2ASgJ9p9vHHbaTn9vHoVHHonhhT0MCJracfnEq54DSPRxal8zUbnMOvd1MTnNItxrI8k
         gcloB1MVhRdr7Z0P0OU61o6zkbNDWgLs0TtvN9pOxmyFsI69Xo4tfqgrBr+mSBTIdUNV
         jUmjrLWum3VmAwOc+Ss497AQzcjYwOFaryTgYW0292jX1m9ULG9zriwgSkH3lbMlL99u
         ELsFTpfrttd3Iu2Ji3gjnlgbbC/udp2sM1N92A3Ax09vOqFK+L1N8nfwsMwtYPdZnUBZ
         TlMw==
X-Gm-Message-State: AOAM531Y0etyxYBgFUaehQPPdflhp2ExCbdSeh5Mps1WbkdRQMwU6LDO
        peCl1O11y4LDOn4el8hYjhc=
X-Google-Smtp-Source: ABdhPJx6UaT/4WcJPNkyHKS8PFV8NwNi6CQ1w7jE7XdU0y7DVeuGveGz5acydbQS1rzlPg9qfPzVJg==
X-Received: by 2002:aa7:c70f:0:b0:425:f70d:b34 with SMTP id i15-20020aa7c70f000000b00425f70d0b34mr23171384edq.306.1652181820868;
        Tue, 10 May 2022 04:23:40 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id n12-20020a1709065e0c00b006f3ef214e0bsm6107300eju.113.2022.05.10.04.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 04:23:40 -0700 (PDT)
Message-ID: <bc628101-8772-9994-3aa7-c141ae151f15@gmail.com>
Date:   Tue, 10 May 2022 13:23:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: Optimizing kernel compilation / alignments for network
 performance
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com>
 <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com> <YnP1nOqXI4EO1DLU@lunn.ch>
 <510bd08b-3d46-2fc8-3974-9d99fd53430e@gmail.com>
 <CAK8P3a0Rouw8jHHqGhKtMu-ks--bqpVYj_+u4-Pt9VoFOK7nMw@mail.gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <CAK8P3a0Rouw8jHHqGhKtMu-ks--bqpVYj_+u4-Pt9VoFOK7nMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6.05.2022 10:45, Arnd Bergmann wrote:
> On Fri, May 6, 2022 at 9:44 AM Rafał Miłecki <zajec5@gmail.com> wrote:
>>
>> On 5.05.2022 18:04, Andrew Lunn wrote:
>>>> you'll see that most used functions are:
>>>> v7_dma_inv_range
>>>> __irqentry_text_end
>>>> l2c210_inv_range
>>>> v7_dma_clean_range
>>>> bcma_host_soc_read32
>>>> __netif_receive_skb_core
>>>> arch_cpu_idle
>>>> l2c210_clean_range
>>>> fib_table_lookup
>>>
>>> There is a lot of cache management functions here.
> 
> Indeed, so optimizing the coherency management (see Felix' reply)
> is likely to help most in making the driver faster, but that does not
> explain why the alignment of the object code has such a big impact
> on performance.
> 
> To investigate the alignment further, what I was actually looking for
> is a comparison of the profile of the slow and fast case. Here I would
> expect that the slow case spends more time in one of the functions
> that don't deal with cache management (maybe fib_table_lookup or
> __netif_receive_skb_core).
> 
> A few other thoughts:
> 
> - bcma_host_soc_read32() is a fundamentally slow operation, maybe
>    some of the calls can turned into a relaxed read, like the readback
>    in bgmac_chip_intrs_off() or the 'poll again' at the end bgmac_poll(),
>    though obviously not the one in bgmac_dma_rx_read().
>    It may be possible to even avoid some of the reads entirely, checking
>    for more data in bgmac_poll() may actually be counterproductive
>    depending on the workload.

I'll experiment with that, hopefully I can optimize it a bit.


> - The higher-end networking SoCs are usually cache-coherent and
>    can avoid the cache management entirely. There is a slim chance
>    that this chip is designed that way and it just needs to be enabled
>    properly. Most low-end chips don't implement the coherent
>    interconnect though, and I suppose you have checked this already.

To my best knowledge Northstar platform doesn't support hw coherency.

I just took an extra look at Broadcom's SDK and them seem to have some
driver for selected chipsets but BCM708 isn't there.

config BCM_GLB_COHERENCY
	bool "Global Hardware Cache Coherency"
	default n
	depends on BCM963158 || BCM96846 || BCM96858 || BCM96856 || BCM963178 || BCM947622 || BCM963146  || BCM94912 || BCM96813 || BCM96756 || BCM96855


> - bgmac_dma_rx_update_index() and bgmac_dma_tx_add() appear
>    to have an extraneous dma_wmb(), which should be implied by the
>    non-relaxed writel() in bgmac_write().

I tried dropping wmb() calls.
With wmb(): 421 Mb/s
Without: 418 Mb/s


I also tried dropping bgmac_read() from bgmac_chip_intrs_off() which
seems to be a flushing readback.

With bgmac_read(): 421 Mb/s
Without: 413 Mb/s


> - accesses to the DMA descriptor don't show up in the profile here,
>    but look like they can get misoptimized by the compiler. I would
>    generally use READ_ONCE() and WRITE_ONCE() for these to
>    ensure that you don't end up with extra or out-of-order accesses.
>    This also makes it clearer to the reader that something special
>    happens here.

Should I use something as below?

FWIW it doesn't seem to change NAT performance.
Without WRITE_ONCE: 421 Mb/s
With: 419 Mb/s


diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 87700072..ce98f2a9 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -119,10 +119,10 @@ bgmac_dma_tx_add_buf(struct bgmac *bgmac, struct bgmac_dma_ring *ring,

  	slot = &ring->slots[i];
  	dma_desc = &ring->cpu_base[i];
-	dma_desc->addr_low = cpu_to_le32(lower_32_bits(slot->dma_addr));
-	dma_desc->addr_high = cpu_to_le32(upper_32_bits(slot->dma_addr));
-	dma_desc->ctl0 = cpu_to_le32(ctl0);
-	dma_desc->ctl1 = cpu_to_le32(ctl1);
+	WRITE_ONCE(dma_desc->addr_low, cpu_to_le32(lower_32_bits(slot->dma_addr)));
+	WRITE_ONCE(dma_desc->addr_high, cpu_to_le32(upper_32_bits(slot->dma_addr)));
+	WRITE_ONCE(dma_desc->ctl0, cpu_to_le32(ctl0));
+	WRITE_ONCE(dma_desc->ctl1, cpu_to_le32(ctl1));
  }

  static netdev_tx_t bgmac_dma_tx_add(struct bgmac *bgmac,
@@ -387,10 +387,10 @@ static void bgmac_dma_rx_setup_desc(struct bgmac *bgmac,
  	 * B43_DMA64_DCTL1_ADDREXT_MASK;
  	 */

-	dma_desc->addr_low = cpu_to_le32(lower_32_bits(ring->slots[desc_idx].dma_addr));
-	dma_desc->addr_high = cpu_to_le32(upper_32_bits(ring->slots[desc_idx].dma_addr));
-	dma_desc->ctl0 = cpu_to_le32(ctl0);
-	dma_desc->ctl1 = cpu_to_le32(ctl1);
+	WRITE_ONCE(dma_desc->addr_low, cpu_to_le32(lower_32_bits(ring->slots[desc_idx].dma_addr)));
+	WRITE_ONCE(dma_desc->addr_high, cpu_to_le32(upper_32_bits(ring->slots[desc_idx].dma_addr)));
+	WRITE_ONCE(dma_desc->ctl0, cpu_to_le32(ctl0));
+	WRITE_ONCE(dma_desc->ctl1, cpu_to_le32(ctl1));

  	ring->end = desc_idx;
  }
