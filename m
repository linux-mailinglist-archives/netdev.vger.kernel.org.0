Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D8726EF51
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgIRCex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729466AbgIRCes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:34:48 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A2CC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:34:48 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k13so2192042plk.3
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L5nwAk3oTiS8xFXf/TO1NHQdbhWEcRojG2/O4bjbM3c=;
        b=fIxkMhQVPLy++huSJdfmGLjHfGzVOESQNsEeAOfT2UKM6D5V3yyewaiu7lrbeV+BPi
         o3hDhhgbZ8xSgemDesRtnuOYD3fuD0lBIg1Nb/s3pWq8B09uZHQWKCi6qo0YsEXrD+CG
         cxsIPDBxwusywTEetpFD+EoZaUecn2mOtlj3sSAFDicZ6OEwaALpXQUv1ItAJ90nXQwl
         Za/w6DfNomLikE3F3LOf5i6xjpjU+v5LrvnuTQyF5PJtjYQjUEAr7uj+5dirVWw+nPny
         8i0OU47DGu9I36amab8h28A/q4TKa9rf6giux5VJ/bX3sZcSeqGsMzmcrRNP4x8kYtKv
         hT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L5nwAk3oTiS8xFXf/TO1NHQdbhWEcRojG2/O4bjbM3c=;
        b=OaqOYSOxtVGM4eLug2aJWYvW8wwRSGHk1Foo6ADaZPhaeyrMYnCAQVCvcPCU6jDb8O
         3ftXJClISfDjXp+XwTp8zEWcnm9opvlC4RXs7zwwUp6VEQYfXhdEFKiCdpypgbLIqL2F
         O7VYWb3Awz1zBQFycwOjVEyooTemFawxFm+x2ptbHUY1XY/XxFgJl4K/utrm2J1AY0Do
         dQpjMKr5W74kMrLmqaPjaymJgg5/vimQPyBkHhKHLRBgt8jxbO5d+Xi+n9yFMFYvxbGW
         aszZ0f/o+2PZ1AjjfK+rQdOQeMfaDvBOsafD2l+m1+4/zb/+5nKDzv6cg6cTAHU2nvMH
         VXFQ==
X-Gm-Message-State: AOAM530aH9mRNE/rk2YtEGy4tbR642J98uJ5obY2T95aTYfwkYGBQhbW
        A/gxBj2ge6DBoXU5mjgAjWk=
X-Google-Smtp-Source: ABdhPJzyRD2XRaec30QUSAg2l2QAXHkORttjB2z/7NUYJzNq5kIcRlUJqhaqKha6ROd3L3W5+rHaBQ==
X-Received: by 2002:a17:90a:e2cc:: with SMTP id fr12mr11004999pjb.125.1600396488081;
        Thu, 17 Sep 2020 19:34:48 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q16sm1115116pfj.117.2020.09.17.19.34.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 19:34:47 -0700 (PDT)
Subject: Re: [PATCH v2 net 6/8] net: mscc: ocelot: refactor ports parsing code
 into a dedicated function
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, kuba@kernel.org
References: <20200918010730.2911234-1-olteanv@gmail.com>
 <20200918010730.2911234-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8c2f363e-86e5-2c74-990b-e012b84eafe8@gmail.com>
Date:   Thu, 17 Sep 2020 19:34:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918010730.2911234-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 6:07 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> mscc_ocelot_probe() is already pretty large and hard to follow. So move
> the code for parsing ports in a separate function.
> 
> This makes it easier for the next patch to just call
> mscc_ocelot_release_ports from the error path of mscc_ocelot_init_ports.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
