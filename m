Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEF41B2E0B
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbgDURQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729437AbgDURQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 13:16:14 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDBFC061A41;
        Tue, 21 Apr 2020 10:16:13 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id nu11so1637845pjb.1;
        Tue, 21 Apr 2020 10:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SuckAMHK0J9TxQjKnzD2CE098tmVLnHq2SeW0xvPDps=;
        b=cMMkRxQ86GGlqNkJGvwQoeUvGlDud6Uro3gXunD/gzd9NLLvSi2bb53jKBZvZBny/G
         C+/pdqoL3eXoxp4VXCIWbjivQct4e76nTJkpQTiKLo/21f6/a04orlW+5dBfQIg99DGW
         bz0wZs0rQHSgVwEWp7RY6t6uxClwfK8lwoGkX/Xik0Q+AE3Uldi/aZkhJRqdwz3uRSJv
         lbsDr4kdMsbqsEVrdjsZ3d+oXFVQdpvt8elBeSq82VHg8ne/GfA5YAJ2OdhQRw/OM7P1
         1PSiigkkgxGR1INAezSEOscuHTw6kBYbFibicTzh3fYX0kEEYf4ehOsEXucrU+C/GfLf
         FDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SuckAMHK0J9TxQjKnzD2CE098tmVLnHq2SeW0xvPDps=;
        b=liexCCUIuPeh5uFXSQP/N11DzWxvnY5E//y4XMeJSjJ1i6jKGS+3wLBtNVUJiX67Ct
         M8a+MX6VHcwxRfUUp3dQuvc/Ekt7zSa2lR/WOBABh03u8hOPFBp0Mcnm01oD/XMdfCzZ
         4fRzfkGjHnG2Qkawp+Zy/5fXufzjcK3MrJygdefZAisZjnTfeNSiO+2DsvPQO0dIbDVS
         /xazlHFP8nvyct8Vd0zHYJwdc3K9re1IAA2gKm9rfFQi1dVmwS9VjXxT0lcOwN5D0syl
         Ufq2xIhbK81kQwS1OzQhSU7rgwMGY4JlH+gOmBPk6a21oi9wJRU5zjZba28i9DUQSdIM
         x6EQ==
X-Gm-Message-State: AGi0PuYtz5PS8u3TKdnGbCkiPjSnVU8OJzrUcOezKt9QAKoWA6Nof9Jw
        8ZLXo1pMpTvL68hHCX5vRJs=
X-Google-Smtp-Source: APiQypIFAPwJpPEVEHOCEKVvNouwB6PiSYEfQcX5nw02w8SVidnCIWD7Km2Q1I3UFRGQQGJ1VYqjdw==
X-Received: by 2002:a17:902:7489:: with SMTP id h9mr20122939pll.212.1587489373350;
        Tue, 21 Apr 2020 10:16:13 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q2sm2972804pfl.174.2020.04.21.10.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 10:16:12 -0700 (PDT)
Subject: Re: [PATCH v2 4/7] net: macb: fix macb_suspend() by removing call to
 netif_carrier_off()
To:     nicolas.ferre@microchip.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        harini.katakam@xilinx.com
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        sergio.prado@e-labworks.com, antoine.tenart@bootlin.com,
        linux@armlinux.org.uk, andrew@lunn.ch, michal.simek@xilinx.com
References: <cover.1587463802.git.nicolas.ferre@microchip.com>
 <da134cb7ffbdfcad1f8e7f2348b66c31f3a35680.1587463802.git.nicolas.ferre@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d74ac8a0-8990-be30-0fb5-d6a1f0b043a0@gmail.com>
Date:   Tue, 21 Apr 2020 10:16:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <da134cb7ffbdfcad1f8e7f2348b66c31f3a35680.1587463802.git.nicolas.ferre@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/21/2020 3:41 AM, nicolas.ferre@microchip.com wrote:
> From: Nicolas Ferre <nicolas.ferre@microchip.com>
> 
> As we now use the phylink call to phylink_stop() in the non-WoL path,
> there is no need for this call to netif_carrier_off() anymore. It can
> disturb the underlying phylink FSM.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
> Cc: Harini Katakam <harini.katakam@xilinx.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
