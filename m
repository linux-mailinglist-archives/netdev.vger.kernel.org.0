Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FD136103E
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 18:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhDOQgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 12:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhDOQgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 12:36:35 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C999BC061574;
        Thu, 15 Apr 2021 09:36:10 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id p2so1813398pgh.4;
        Thu, 15 Apr 2021 09:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xpLp18sMQ5PmZ6Zf0JUY6KPpGa5tNuFDxpQOSqk79K8=;
        b=CtzJ4hExyDcCHoEt5Dw1HoIez7zshFPJcw6MDrrarcaDJkMnGDXsmDq20IbAL4G7Wk
         0Hc6ZTklwxVLdIT0GscspC1io3M1s2TcUPrK1wCJEUSb+/3VIuvF03DbQ5Wz2AghQYdm
         JNUseYXPoAkZpoBEYv9oR3RolFgUGcLBbM9vUbHkOg6xHDEq2RNl+uBJgOseHpIie1TF
         UedBPqeakxxd4TMj5pO1RSUcpZ9HP6L2/qe7HFoYcWMognpdtzLbysQkv3VWp3upChsz
         n0wHWHz/aaybdka51hy8ODgGT/uvSCZ3croJ8KvU6r9OpXxyMjfMKHE+ysE7KYrPtDcW
         2g3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xpLp18sMQ5PmZ6Zf0JUY6KPpGa5tNuFDxpQOSqk79K8=;
        b=W9nCMSvU6wpzK3jDEM6ad/rs+WNh4MGkDhxFbNXscg+MeOZn22/qSgerPHnA1iIT+U
         8Lz/k0j6XybSHw2PzRKgdRyohmkHZ+tpFCcfPRV3hdJs1Qvjvqv/RsI/ShIcRcxLZHkV
         2VJdAcrlhYGC4JWKr8coSor3PUs7VyheHVG7jPd9PInKkuyYpsk1SGkp0EL3hWEeatWQ
         PtKB+2dJKp/cdqhirSABEU4Ss1ENHERL97FLFk7b44uUaA7vus0ZyUfv1b+XjxHljz+/
         5VNuGsDEALuYzZs9WqVo3emyszlywFc9dG/KYLg/ne8rhNegJfp5WTpUJ1/fcIgzwUg3
         rZbQ==
X-Gm-Message-State: AOAM531pvnybELSAC4FRwdeZVtGnstxPJbiYuoQwr015jFbC8ivFNuVl
        B620JTD76zptAKVmUHYo8SkcmveWsNY=
X-Google-Smtp-Source: ABdhPJxlSveTFMbYbQw93g0Tf2/9MuFzPejwxz3/CcEC7snEHSyuytPQUSPELNbLOxPREAt69IyWeA==
X-Received: by 2002:a63:f451:: with SMTP id p17mr4220611pgk.150.1618504569824;
        Thu, 15 Apr 2021 09:36:09 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 8sm2654128pfw.118.2021.04.15.09.36.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 09:36:09 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 3/5] net: dsa: Only notify CPU ports of
 changes to the tag protocol
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
References: <20210415092610.953134-1-tobias@waldekranz.com>
 <20210415092610.953134-4-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ce97cdd1-4acf-e3ba-d776-38dd8bf80dd3@gmail.com>
Date:   Thu, 15 Apr 2021 09:36:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415092610.953134-4-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2021 2:26 AM, Tobias Waldekranz wrote:
> Previously DSA ports were also included, on the assumption that the
> protocol used by the CPU port had to the matched throughout the entire
> tree.
> 
> As there is not yet any consumer in need of this, drop the call.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
