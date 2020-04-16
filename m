Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6D71AD045
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbgDPTVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727844AbgDPTVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 15:21:51 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7637C061A0C;
        Thu, 16 Apr 2020 12:21:51 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id z9so1784023pjd.2;
        Thu, 16 Apr 2020 12:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dFDogiNpUViieseD8B7i4gvtR0lN48l0uboJ699HzYA=;
        b=F8w4ZBPU9xUvd/XqTVXfpEGzJ6UvGc18kyPdt9NNzgZIPgK2YGN7E7UUf5suhykuBc
         HVC3T0kfNEMVm5PARoiA0pEsZu3SG+q1xTTwu5cDM1kK+ZkcXk6CM9TN6nmWcH5UJk6+
         Uvl3ZZW8R7LXNE39U3AA/kjFZ5qREJlqJpOOYG8si0uNNGqCV4yT7HP7TFN0juFWgWb8
         I79Maxj70yPJa8T8s0FnOb6Vt0zCnRl7OHWEEKVBPOB6gS2HZKGGYwFmOfB510roPZcd
         OY8WgwoTyzpRUmPNVwfjCVSd7wevVFMStKScXQeiTyny63qVw09vNOorv0PSJbmhIQUt
         xvQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dFDogiNpUViieseD8B7i4gvtR0lN48l0uboJ699HzYA=;
        b=UJKHBqYetIUaXt59vyE48U8iEaGGu+0wKwD25i3yDrfZC/xXRCKiWYV6XpvkrdEn8Z
         K2GsuhH2qbW4TSgpfgn2KN/Q4kivj4KUeKhyccss5iVYsihmDCM1TUAKBjyDtRU6znSG
         RTae+ADYG1BHt0QSNHO4tFkaTIcMSvbzMGkj/Ai6HAH4wfJDTxJd5lO7I3PoYTanTMiE
         Syt2+qmen9jkkTTDK8YeSJKafJbdQd2baMspAtmE1OZX6/bsxenLpmBsISkG1H6woA9L
         saCfmbnwRV6GaB4mb8HNG7Nhjua3IP+jAaOLv8tg9ohwz5qeZzaVpraYdl18gnJrBfqT
         QUow==
X-Gm-Message-State: AGi0PubiqmxKMQV3P8hdfyxaohLpfpJkyJMPrX4IJj9o1nDMHCsTOPqJ
        JSzZYOii4cjV9Z8ubdlnw2w=
X-Google-Smtp-Source: APiQypJIFpvXsaqK1CuKunLdTv+/kNGuIhIdVi5mAVZbcf9+poZ592wZxOzGRpiFbGsZPU0pwfeTRg==
X-Received: by 2002:a17:90a:fa87:: with SMTP id cu7mr6856550pjb.92.1587064911434;
        Thu, 16 Apr 2020 12:21:51 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mq18sm3834503pjb.6.2020.04.16.12.21.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 12:21:50 -0700 (PDT)
Subject: Re: [PATCH 2/5] net: macb: mark device wake capable when
 "magic-packet" property present
To:     nicolas.ferre@microchip.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        harini.katakam@xilinx.com
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        pthombar@cadence.com, sergio.prado@e-labworks.com,
        antoine.tenart@bootlin.com, linux@armlinux.org.uk, andrew@lunn.ch,
        michal.simek@xilinx.com, Rafal Ozieblo <rafalo@cadence.com>
References: <cover.1587058078.git.nicolas.ferre@microchip.com>
 <3d41fc5ef84dfb2b1fa4bb41c0212417023d4d97.1587058078.git.nicolas.ferre@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <631f9716-bb21-4309-ee6e-ef2594b93a4b@gmail.com>
Date:   Thu, 16 Apr 2020 12:21:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <3d41fc5ef84dfb2b1fa4bb41c0212417023d4d97.1587058078.git.nicolas.ferre@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/2020 10:44 AM, nicolas.ferre@microchip.com wrote:
> From: Nicolas Ferre <nicolas.ferre@microchip.com>
> 
> Change the way the "magic-packet" DT property is handled in the
> macb_probe() function, matching DT binding documentation.
> Now we mark the device as "wakeup capable" instead of calling the
> device_init_wakeup() function that would enable the wakeup source.
> 
> For Ethernet WoL, enabling the wakeup_source is done by
> using ethtool and associated macb_set_wol() function that
> already calls device_set_wakeup_enable() for this purpose.
> 
> That would reduce power consumption by cutting more clocks if
> "magic-packet" property is set but WoL is not configured by ethtool.
> 
> Fixes: 3e2a5e153906 ("net: macb: add wake-on-lan support via magic packet")
> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
> Cc: Harini Katakam <harini.katakam@xilinx.com>
> Cc: Rafal Ozieblo <rafalo@cadence.com>
> Cc: Sergio Prado <sergio.prado@e-labworks.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
