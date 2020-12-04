Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ED92CEB6A
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 10:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387953AbgLDJva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 04:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387656AbgLDJv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 04:51:29 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB12C061A4F
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 01:50:48 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id e25so6483388wme.0
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 01:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ypvE7mQb7ApOobv61zRPY+utR2AGjd09jIazBujb+2k=;
        b=cWo51lhg/s5ytFZCR6E2WhldLoUOvJUPvrjwGYHA/fDDHfWW4REeOvC8q6QRJ46VI9
         owg+xV/3VhfnCRJBHxkSqtVFp97f6Z/8c95s1Ua6Ch35tqlPSX5YkSD6AwgMp+zyRLVd
         Ea06x/qcs8VEugyLp2x2jZVJliPq8N3kNK1utbkelPuuYQYxEhH1FrVtAU+eB8VzNNAG
         VUjlzv/2j/h0gyz3OlX8AfW+54Aov7NehapFdVwBIgiqu9az8x7+s1pv7sSSVv2RCTUT
         hmMeNcQMJr4CUBNp5bzZxRcRGqmUieqJPpshXqN9+UzGtx4Z+E2vjctbab8h/NwQEtbx
         W+ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ypvE7mQb7ApOobv61zRPY+utR2AGjd09jIazBujb+2k=;
        b=iP4R3c1QnqMLPXWMgpokK5PT6QVd4G3Vlxx8EmsVmv/cFPzyg5s7qdfZbYNcusd/ix
         b0qBdMFtlpRLWoIrfnv6IyfEwfzQwZ9/863F52HSs5Q69Wdb6fboXsXrx0pdviGTVUrH
         trhFModSMbZKLwNrRXva0eGXzIb4Rcjro6wgFYDhgxmZsDMs7MMNGZZdNc9u2cK/CO3E
         TWUzLTonyjddw9zIGQhaIPTmScEPfyKQE5NUdwMqbeL1eNb4B7HGBKAtAYHfS4cNYsmG
         NyCozpCjSFy0lW8Rp8xHFRlMstHK22WXP4tdyPfgjtqSh2n/6v0IckX/335ouQcAMNZk
         jtPg==
X-Gm-Message-State: AOAM532g2tkWouNLMSGmjOi1iHWkT+BveJ3jeymbyYL/Cs3/QGhar79n
        uL25qQ9+6r8mnVUM5jaDWLOVJJxXOn8=
X-Google-Smtp-Source: ABdhPJxpxJU3STq/Hwrc3bMkSguG72vi6aCXIuaSgVFuP0zDWACaIOqW4cAM5H63+nvQjZDQ5vEgbQ==
X-Received: by 2002:a7b:cb13:: with SMTP id u19mr3295186wmj.102.1607075447360;
        Fri, 04 Dec 2020 01:50:47 -0800 (PST)
Received: from [192.168.8.116] ([37.166.39.226])
        by smtp.gmail.com with ESMTPSA id n14sm2468908wmi.1.2020.12.04.01.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 01:50:46 -0800 (PST)
Subject: Re: [PATCH net-next] bcm63xx_enet: batch process rx path
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20201204054616.26876-1-liew.s.piaw@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3caedd41-669e-94be-9214-e93eed5ae073@gmail.com>
Date:   Fri, 4 Dec 2020 10:50:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201204054616.26876-1-liew.s.piaw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/20 6:46 AM, Sieng Piaw Liew wrote:
> Use netif_receive_skb_list to batch process rx skb.
> Tested on BCM6328 320 MHz using iperf3 -M 512, increasing performance
> by 12.5%.
> 



Well, the real question is why you do not simply use GRO,
to get 100% performance gain or more for TCP flows.


netif_receive_skb_list() is no longer needed,
GRO layer already uses batching for non TCP packets.

We probably should mark is deprecated.

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 916824cca3fda194c42fefec7f514ced1a060043..6fdbe231b7c1b27f523889bda8a20ab7eaab65a6 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -391,7 +391,7 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
                skb->protocol = eth_type_trans(skb, dev);
                dev->stats.rx_packets++;
                dev->stats.rx_bytes += len;
-               netif_receive_skb(skb);
+               napi_gro_receive_skb(&priv->napi, skb);
 
        } while (--budget > 0);
 
