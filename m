Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA593CAFA1
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 01:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhGOX0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 19:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhGOX0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 19:26:17 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583C4C06175F;
        Thu, 15 Jul 2021 16:23:22 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id p14-20020a17090ad30eb02901731c776526so7649998pju.4;
        Thu, 15 Jul 2021 16:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OHLxbEHcuy/epAhqi+X1cyVeqb/rYsg9Kd81gx+RI/4=;
        b=uh5ow60hJ6hNJw1yd7Jc6JRGCHiZ2jlliwoe2AuF4D3P3u3GiFvp6a2MEeZPXR+aYQ
         sZEKQMm2CYMGdH7ApyYty8GCwsdeeslHZv+qZHyUyZm0cNBMcqdvGkYKiaHqLmNuPVDi
         jwtK1M+bV4BfzBh2wKg7vpUwN7hxTg4Awb8Dm6QwWGgmmfZSUPjQTS94SHtkb5orWyPU
         CdJqKVLSmQ8lsqXnXQgqbhmZ8kKpsoltuJOoL0Z1yVt2niZMWRZb/JLIvGVgb9UPfJDB
         XKjbQv/rC3cwLrIe16kNzNEGoIuELkwu9mEZYweLvQfl3w+k4p0T2xa5qazruj3auv7w
         B+ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OHLxbEHcuy/epAhqi+X1cyVeqb/rYsg9Kd81gx+RI/4=;
        b=Emind3PhDsOEdMTZ0WkNttCls3ODVVUJKn4DO6YoBpW9XEhY+y7pQqehW632/xqb1m
         9/BruGgku0H9DB1GPtWcOpd4pJGzR8JFteUH8ax/WVyLRcvXIdrhBIehC+PC2/bauGtQ
         SxhEZswHmSfNqtmOAalKS16+9/fgQ/AdpeynQilf2HF/RqiC7BEih/GjaHiKW8/Vj3np
         Hh7JzbMIY6y2VCpcIfBXG+vDOLvXRjaz5UWp4FGD+f4NBplQsQmGYMteJH59+fbnxkUH
         YVpkETzNvJ08FcS3bZrQ59pmYNZSWH+bTba92KM26Y4Yq3szckBgqNbol7DMuPghVkRE
         HSig==
X-Gm-Message-State: AOAM531ll+WArCwom5hkBJk1edhelSKPSx/ehndyGEEPu23rq5zFq+lO
        vN0OoLjJi9vJ7jZGke5X0B8gIw8PF8g3bA==
X-Google-Smtp-Source: ABdhPJwJX0fLU0RghmINCZrNSM9KUgBxkJITney1y+lB8T84CKmymak7oxFm8TpzPWbYbN6FVZUrIA==
X-Received: by 2002:a17:902:ecce:b029:12b:1c81:2741 with SMTP id a14-20020a170902ecceb029012b1c812741mr5250911plh.3.1626391401418;
        Thu, 15 Jul 2021 16:23:21 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y6sm6347099pjr.48.2021.07.15.16.23.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 16:23:20 -0700 (PDT)
Subject: Re: [PATCH 0/2] Fixes for KSZ DSA switch
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, woojung.huh@microchip.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d205b518-fb47-9065-1e82-de0f9286cb60@gmail.com>
Date:   Thu, 15 Jul 2021 16:23:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/21 12:17 PM, Lino Sanfilippo wrote:
> These patches fix issues I encountered while using a KSZ9897 as a DSA
> switch with a broadcom GENET network device as the DSA master device.
> 

Is this off the shelf hardware that can be interfaced to a Raspberry Pi
4 or is this a custom design that only you have access to?

> PATCH 1 fixes an invalid access to an SKB in case it is scattered.
> PATCH 2 fixes incorrect hardware checksum calculation caused by the DSA
> tag.
> 
> The patches have been tested with a KSZ9897 and apply against net-next.
> 
> Lino Sanfilippo (2):
>   net: dsa: tag_ksz: linearize SKB before adding DSA tag
>   net: dsa: tag_ksz: dont let the hardware process the layer 4 checksum
> 
>  net/dsa/tag_ksz.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> 
> base-commit: 5e437416ff66981d8154687cfdf7de50b1d82bfc
> 


-- 
Florian
