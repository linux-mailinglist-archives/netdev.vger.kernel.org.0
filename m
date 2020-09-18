Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BE426EFBA
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgIRChp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgIRChm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:37:42 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93A8C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:37:41 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gf14so2216395pjb.5
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pyvmbRRRXfL+hz1A+sHcG8BaSWMkod3SBcCgg/IIxEA=;
        b=DR/h6sNbheIT1nLioHbJacVevghREtTAoOF//8Lg4oscYrl7WEvBdGZUjsfQ3/z7MQ
         VIlqqTwGCNPH10YrBc/8AvZzQDeZcYS659CFphKDqlsl4AE2eSvQnpbcCZXf06e9zb/H
         TOEM12k1ootBBe55vmc0lEDgiybdgVuK8khPA+/O+FLoupzR74vbzVFt0axJiCTwoChi
         xCINLL0nrt6/HntXIDA1PueqtSeM9LlOJ2ctIv/zeu2X0SrN80ZKJBomaOtFI4yAkyvx
         AuVX7lS6zfDbmzXKR61thdC4oNKiHRVhxuUqSCwwDEEteaY+fofbLxSYYOKDI9GeFKiU
         itAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pyvmbRRRXfL+hz1A+sHcG8BaSWMkod3SBcCgg/IIxEA=;
        b=be7OfbXYYQKEKOSaPNI79F5Q7dXa6RMT6WzxYaQjTZSF90mF4elj8u6neDn4QZ3nW8
         J/daeN9SGmV63OTiZBRGHohaETqs/WYzVegVSpkQTKdiAElc2LxC9asxkEZtcl6htx9p
         OjusBFwt09QCqRFwz0pwcnj+k32HSCqbtrVgyXSXP+tIGmdxpKEIxrnLQyM63ohMJwaO
         kKtsBkQuaNtUReJvZQ/Gujw/aKEn+l5f5FDMQbaOTN5OVNnH6B8SDg7BfyoztEJJcBRG
         1K4F2NIjG5ts6tymGmm15COkbPq9BEREKfs0hYgOfLSctekKViIPY1ycT+tOg72h39mI
         ZbHg==
X-Gm-Message-State: AOAM532zeLrKbZfh9Jz8+gwWlK5AdcMGfzKp6jRV0qqRoqDGaRiAOahM
        ekpCHCguc5tT3igZDYXNYcM=
X-Google-Smtp-Source: ABdhPJxD9je4SCz7w0H7Sz7H17yU0YSChpmX6YnBaAjggsWz8e/mXuLzaPaIJE7vGqWauHY/7atpEg==
X-Received: by 2002:a17:902:24c:b029:d0:cb2d:f270 with SMTP id 70-20020a170902024cb02900d0cb2df270mr31843332plc.9.1600396661511;
        Thu, 17 Sep 2020 19:37:41 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5sm1046935pgf.21.2020.09.17.19.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 19:37:40 -0700 (PDT)
Subject: Re: [PATCH v2 net 3/8] net: dsa: seville: fix buffer size of the
 queue system
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, kuba@kernel.org
References: <20200918010730.2911234-1-olteanv@gmail.com>
 <20200918010730.2911234-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1d8f0d55-009e-75d5-0b47-a2e6f4e2793d@gmail.com>
Date:   Thu, 17 Sep 2020 19:37:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918010730.2911234-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 6:07 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The VSC9953 Seville switch has 2 megabits of buffer split into 4360
> words of 60 bytes each.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
