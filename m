Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745842B02F6
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgKLKmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbgKLKmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 05:42:33 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C37C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 02:42:32 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id h2so4857696wmm.0
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 02:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UsUbCOg2Y1nmo2EpoGtPOX93VT/7o3P8eP4uLn/BOnI=;
        b=n3FJBazGCZqJXjbpwl2r7F5U5miuQkUAkWdohTZ/dbQAHQrZ20nMVXRKU7YGxRfv6H
         OmzpK9McrPPkGCZKvjO4im7QbnAxiHS2EOHbi8Jtr1gtKIYqTjz8NoCFc+Wac1D9ehOR
         PCKeLQM7YJdYAu6EAJ7qc1H6hMeMmZBWkSdVQYZIiNWXpUjjSiucG0IG9zBUK3ms4F/P
         ukqNj1xGBP07vb/AtQlJGT/LnTPwnTqMVA+NeGCcpK4Y+O5bMLX9i86KcTF2t2oHtvQP
         +mhZlGATNQxdSTeLrqRghsCNb9uL4GAqY2V2yODSlVvluZ8cbmaDtoeGPEeWtdVUgQzb
         LxKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UsUbCOg2Y1nmo2EpoGtPOX93VT/7o3P8eP4uLn/BOnI=;
        b=L59Y+Qqh5KwmfYwUhJBPbtXKuSTHmEckHVf6UiAXEeo+PlNqFYmAwUv6PSEr6E+IW6
         eeeGK801chVc3WUMCVTA+2D8glKQJxK/SMbHT2CsvysmZQfmpwSiheFVZynmWMEHxaP3
         pSX3zlo73iyp6DL00mDMoOu2RYt91iqdGk12isuiUowvZI45yuZq0sg6DNOU0NzzQZ2W
         8Y52PG3aTsXchWkmkNk3eAW1O9HXf2P62pAkjdDwMNxTXvdUil6Yt7WaOOMEk6Vb6z55
         +55OHyRcVXaGUWpB4btyermA+EtI+7e37DOQfjIx8diVI1kE1Mu+xkSk3sG+T4MI3HTs
         OhPA==
X-Gm-Message-State: AOAM531bP02GZ9qs9T2KWMh+64ssbJCSF6aJ9KpNnWqf3UwyTjTatdhF
        k2RuhCfCOTgPPnqzr6ptZIg0IWRAPMg=
X-Google-Smtp-Source: ABdhPJxyZ3lP/o+yI9U5eu8n3/45X2psJ4ohWZTO7uYujduku0uW64RrTJ5hGRfmZlDAUZ7yce0niw==
X-Received: by 2002:a05:600c:d2:: with SMTP id u18mr9042303wmm.102.1605177751109;
        Thu, 12 Nov 2020 02:42:31 -0800 (PST)
Received: from [192.168.8.114] ([37.173.54.223])
        by smtp.gmail.com with ESMTPSA id w11sm6093738wmg.36.2020.11.12.02.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 02:42:30 -0800 (PST)
Subject: Re: net: fec: rx descriptor ring out of order
To:     Kegl Rohit <keglrohit@gmail.com>,
        Fabio Estevam <festevam@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
 <CAOMZO5CYVDmCh-qxeKw0eOW6docQYxhZ5WA6ruxjcP+aYR6=LA@mail.gmail.com>
 <CAMeyCbhFfdONLEDYtqHxVZ59kBsH6vEaDBsvc5dWRinNY7RSgA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ba3b594f-bfdb-c8d6-ea1e-508040cf0414@gmail.com>
Date:   Thu, 12 Nov 2020 11:42:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CAMeyCbhFfdONLEDYtqHxVZ59kBsH6vEaDBsvc5dWRinNY7RSgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/12/20 7:52 AM, Kegl Rohit wrote:
> On Wed, Nov 11, 2020 at 11:18 PM Fabio Estevam <festevam@gmail.com> wrote:
>>
>> On Wed, Nov 11, 2020 at 11:27 AM Kegl Rohit <keglrohit@gmail.com> wrote:
>>>
>>> Hello!
>>>
>>> We are using a imx6q platform.
>>> The fec interface is used to receive a continuous stream of custom /
>>> raw ethernet packets. The packet size is fixed ~132 bytes and they get
>>> sent every 250µs.
>>>
>>> While testing I observed spontaneous packet delays from time to time.
>>> After digging down deeper I think that the fec peripheral does not
>>> update the rx descriptor status correctly.
>>
>> What is the kernel version that you are using?
> 
> Sadly stuck at 3.10.108.
> https://github.com/gregkh/linux/blob/v3.10.108/drivers/net/ethernet/freescale/fec_main.c
> The rx queue status handling did not change much compared to 5.x. Only
> the NAPI handling / clearing IRQs was changed more than once.
> I also backported the newer NAPI handling style / clearing irqs not in
> the irq handler but in napi_poll() => same issue.
> The issue is pretty rare => To reproduce i have to reboot the system
> every 3 min. Sometimes after 1~2min on the first, sometimes on the
> ~10th reboot it will happen.
> 

Is seems some rmb() & wmb() are missing.

Honestly 3.10 is way too old for us spending much time on this issue.

I would try this :

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index fbd0d7df67d8dec64f712602cb0c17e3cb585e2b..99767728f2b501813f9d4a833fa3146caea50ed6 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -344,6 +344,7 @@ fec_enet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
         */
        status |= (BD_ENET_TX_READY | BD_ENET_TX_INTR
                        | BD_ENET_TX_LAST | BD_ENET_TX_TC);
+       wmb();
        bdp->cbd_sc = status;
 
        if (fep->bufdesc_ex) {
@@ -810,10 +811,12 @@ fec_enet_rx(struct net_device *ndev, int budget)
         */
        bdp = fep->cur_rx;
 
-       while (!((status = bdp->cbd_sc) & BD_ENET_RX_EMPTY)) {
-
-               if (pkt_received >= budget)
+       while (pkt_received < budget) {
+               status = bdp->cbd_sc;
+               rmb();
+               if (status & BD_ENET_RX_EMPTY)
                        break;
+
                pkt_received++;
 
                /* Since we have allocated space to hold a complete frame,
@@ -918,7 +921,6 @@ rx_processing_done:
 
                /* Mark the buffer empty */
                status |= BD_ENET_RX_EMPTY;
-               bdp->cbd_sc = status;
 
                if (fep->bufdesc_ex) {
                        struct bufdesc_ex *ebdp = (struct bufdesc_ex *)bdp;
@@ -927,6 +929,9 @@ rx_processing_done:
                        ebdp->cbd_prot = 0;
                        ebdp->cbd_bdu = 0;
                }
+               /* This needs to be the final write, otherwise NIC could catch garbage values in surrounding fields */
+               wmb();
+               bdp->cbd_sc = status;
 
                /* Update BD pointer to next entry */
                if (status & BD_ENET_RX_WRAP)
