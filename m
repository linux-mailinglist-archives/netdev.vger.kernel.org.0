Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16CC26EF63
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgIRCfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbgIRCfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:35:09 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A88BC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:35:09 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t7so2346234pjd.3
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c3KPkuTYP8KL96kbFfvBR4qDqKSNlCX3Z/Nq/kaNB6U=;
        b=AxpNVm9Z5/ICf4XV06VmyEPMQiAwvzSJ5tgHYptFH0ZEWB/W3ECRGX0ECAsbBLVLek
         MKPial5h4RtCTmO1KzpBKBOsmF4eSBs8a3iXN2NAyN6Azj74aPh6jd2WK9s7bzfttjaD
         wHfm/5gd8lPdqB2vHyK8PZ5JGB8n6ZHGGQT0RfvRYk/k2ksgcuwcUw/WFuTBgVQmF7wr
         8I7dUj/DLIAJ0yM7XEOKzYP28Arb/eFFenhmHVyHsiaxq030RuBufe5BMqD8lSe78Xn4
         fTZ/wN5BPVN/wexgBacMxl2IRrreAsRic4j162P0pkaB5YfogKYghVvkEA0J7+xplJgv
         L1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c3KPkuTYP8KL96kbFfvBR4qDqKSNlCX3Z/Nq/kaNB6U=;
        b=gagSWSckrGAzAA0ltzwsjNfEFEXddl1T4JsHbBXRg7AdXxAKH4jmkrhS2kQhsjDqcv
         +ZRqst0cS4TLFmsTuaLk9QN1p+0UCgPo5+pA+Hzm4apRwoPlY6mNNzCb5hNAUe9XkAJo
         /rAxmvucSDroGyTQ6FmAH4YPspCLokkp7fBXtEksQNJl+hhLpKJE2FTdE5lPY6e4S457
         pHl7EQpCrr/NNiXiHlUtX7YH1WrswxaVSS3IBGe6UgmzZUs/2i+A1uLAed2w1ZVw7t5T
         J50uw6/kZaLFErwreMe9ZV+EFa3IV/TEOkr3lZzrGNlNG6zrPDZDOfVPOOQKeafAWRc9
         vWGg==
X-Gm-Message-State: AOAM532jRsk/MhJXhNRPv1VDG3h5r76+XZY3s+CY5tab8b/gkdZn6LA4
        RrF9NthIJ1o5lR9CnQjEboM=
X-Google-Smtp-Source: ABdhPJwriWbstZ1EqFNpDq7vk9Nt3G/8ru46b5cPgwVT/i8fgUg6PfQlIs2rHOkgnHd2/Dv6XfDrLg==
X-Received: by 2002:a17:902:eb0b:b029:d1:8c50:b1ed with SMTP id l11-20020a170902eb0bb02900d18c50b1edmr30844039plb.41.1600396509156;
        Thu, 17 Sep 2020 19:35:09 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k27sm1006578pgb.12.2020.09.17.19.35.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 19:35:08 -0700 (PDT)
Subject: Re: [PATCH v2 net 4/8] net: mscc: ocelot: check for errors on memory
 allocation of ports
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, kuba@kernel.org
References: <20200918010730.2911234-1-olteanv@gmail.com>
 <20200918010730.2911234-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2f3d6720-724c-7f87-b2ce-3289698c84b2@gmail.com>
Date:   Thu, 17 Sep 2020 19:35:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918010730.2911234-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 6:07 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Do not proceed probing if we couldn't allocate memory for the ports
> array, just error out.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
