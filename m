Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF6F2CF412
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387790AbgLDS3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgLDS3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:29:34 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0868EC0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 10:28:54 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 131so4301689pfb.9
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 10:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uo2S/pzZkMYLk7oMgFf8RVIYenb5tiumKMbBcyGd4Qw=;
        b=eCzeIp/6oDkjtUdjHoWCt527dnvsnlGCngITZQOcaD7Kw26+tHfAXsL6yyprqSku9w
         9CPQ1WR/QfnTnZ7f0GAWmBbaTsZmu/Mrvixb0sCx/QbBrJ8//vYShY1raHZV57gIIZRH
         jqt+KWeBtATFiyOZEUed8Ilb7jRn2xqjoxL3uDzpKjWEQqe4MMWXz14ZnO4MpkrbzKtp
         vsjrZQThaMhnI+lU+Qcxh1NgFUWq47Vz08cakQxvqeeZ6F1aCsJjY08b3oqgLBNeplyF
         BtXC9FqZEbi7Bs5lYbN6kCA6iH7csJVaua1bvL53s0OEOySFVPl+gcF+OlAnMHaxF4fd
         NGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uo2S/pzZkMYLk7oMgFf8RVIYenb5tiumKMbBcyGd4Qw=;
        b=Kr5tntNun9eCInynDUqVqASraXstV3FhZEOSCp13Y1LHylwePuLVlSVbrshmSBuj9S
         HCKiQFCS9SjabmvojHSysoheoPnP7u8g91EkwPMdkWEWks8OQppjAp0Gmuk4hW79Rrvh
         tPc4LOk5bRC0SuSA/apMmII/OLqOKJvtRsubH7fpuMxOecUPQqAw4ci4yj7AYyMdlD2b
         rcpqQxeKEG9QMJr8qrmtCaOdpuuN64RlgkdqVJ81Pu8/Df7b9xNZAJUSkhdivxC57ILw
         oZOWUo/TgbfzfOcR5UUZDCVsKl7biKqFMD2ZVFtTGW8Iwmsc3lh2tnXFvZ0w12hIrHtJ
         Hi8w==
X-Gm-Message-State: AOAM530HYwYtD1ZsNBPoHP+t79grhE5BXC0ftSW7m0sqO3giL5btMYaJ
        7bAY7oi1PHkPuegxKN4JEiRk3UhHqvU=
X-Google-Smtp-Source: ABdhPJyS6oJUcDsDAXGWk0A0a0znIwtKzEhEDP1TJD92v03VAxSF6uW0r6Gwb2D/fIIW3bzGdUTd4w==
X-Received: by 2002:a63:b1c:: with SMTP id 28mr8604144pgl.206.1607106533049;
        Fri, 04 Dec 2020 10:28:53 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id nm6sm2686821pjb.25.2020.12.04.10.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 10:28:52 -0800 (PST)
Subject: Re: [PATCH net-next] bcm63xx_enet: alloc rx skb with NET_IP_ALIGN
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20201204054616.26876-1-liew.s.piaw@gmail.com>
 <20201204054616.26876-3-liew.s.piaw@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <eb1285d6-d08b-2746-71be-83fb4660fda7@gmail.com>
Date:   Fri, 4 Dec 2020 10:28:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204054616.26876-3-liew.s.piaw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/3/2020 9:46 PM, Sieng Piaw Liew wrote:
> Use netdev_alloc_skb_ip_align on newer SoCs with integrated switch
> (enetsw) when refilling RX. Increases packet processing performance
> by 30% (with netif_receive_skb_list).
> 
> Non-enetsw SoCs cannot function with the extra pad so continue to use
> the regular netdev_alloc_skb.
> 
> Tested on BCM6328 320 MHz and iperf3 -M 512 to measure packet/sec
> performance.
> 
> Before:
> [ ID] Interval Transfer Bandwidth Retr
> [ 4] 0.00-30.00 sec 120 MBytes 33.7 Mbits/sec 277 sender
> [ 4] 0.00-30.00 sec 120 MBytes 33.5 Mbits/sec receiver
> 
> After (+netif_receive_skb_list):
> [ 4] 0.00-30.00 sec 155 MBytes 43.3 Mbits/sec 354 sender
> [ 4] 0.00-30.00 sec 154 MBytes 43.1 Mbits/sec receiver
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
