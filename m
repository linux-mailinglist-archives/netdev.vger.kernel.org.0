Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8181D057A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 05:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgEMDUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 23:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725898AbgEMDUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 23:20:30 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4074C061A0C;
        Tue, 12 May 2020 20:20:30 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x77so7389831pfc.0;
        Tue, 12 May 2020 20:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0+fq0SWZom53mrI0MDxCTWruDdUGMiC4XGijKt8h7F8=;
        b=qjLuj90hab+z3Z8p1wS9vgchxqXyn7+6L5o91q6cHgEQUNWIC6IPVCQYyTom4ZVglU
         lgkmZD9BAIBP3ZavB+VSOAmsKB2GWboN3Fbeqls9bdu2lyLY+MUODKwpa45rO7JXsiL+
         QyDmZOGMJ2d6KDdqfOimHO+Sbm3UKZZ9Zc8HSEirQCN+A+ADsrIwPIrLpFTlwDvDnfWv
         62hnhkFi8SZAG1rQswRrSpPIyPIEMpc5W6Gdux4v+9smmYjwoQXYOG6ogoKceslM721Y
         r5uUZSKIya9gB3tfEu700vuYxaolaZRbnpeSgCeaiO314jwjxn8KM0fbiJ8A3CmbVZNU
         VpLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0+fq0SWZom53mrI0MDxCTWruDdUGMiC4XGijKt8h7F8=;
        b=VdoLroyrSP/6bm2+DdoZmVVpSEWMLyfUCulxSIvVO0OU8o2PHdOVFRuToPYRYQIXBI
         Go1TDgTVZPaLa+pIENQnA8y9FwTjVsZV8Vu/HRwm+lykqKhmrsoJ3537E3XkR8R9lePO
         M9Rvqz5m0zySD7XbnOyXQFKrMM36muudRIyyOLf1R4+CCTq7HgAAcsC5I0D4CmcCsdpj
         Z2D5/nSmF3S9Lg5vKSgSvZp35/9EVXCD+rs21oPUY7AvC6YrGnE9Z7ntktjFuHfDU5yJ
         VmonJyBmHaEIraSwCXXTxIhaY3AiZ4HzvxfXnqCIPsMVGQljET4r2v7NJq2Y1mB5lkIk
         0kjw==
X-Gm-Message-State: AGi0Pubke/hayG9ceo9t72H6YmLClzDYERSf24QfJN4cccuk2pyhlyyx
        b7yYSdcPdDzdTiOvyTwl/6s=
X-Google-Smtp-Source: APiQypJKRPbZ3L0II/TLLHwduNXNhBAT0cLaYcIUvYrGfZloBaOQgYDb9w2joIINXYKGhqxE24Bwqw==
X-Received: by 2002:a63:d74a:: with SMTP id w10mr22730750pgi.417.1589340030193;
        Tue, 12 May 2020 20:20:30 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 62sm13111349pfu.181.2020.05.12.20.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 20:20:28 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 3/3] net: dsa: felix: add support Credit Based
 Shaper(CBS) for hardware offload
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, po.liu@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com, mingkai.hu@nxp.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        linux-devel@linux.nxdi.nxp.com
References: <20200513022510.18457-1-xiaoliang.yang_1@nxp.com>
 <20200513022510.18457-4-xiaoliang.yang_1@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <751e0ca4-1e4f-9874-23f6-d42d5e0d4b8a@gmail.com>
Date:   Tue, 12 May 2020 20:20:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513022510.18457-4-xiaoliang.yang_1@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/2020 7:25 PM, Xiaoliang Yang wrote:
> VSC9959 hardware support the Credit Based Shaper(CBS) which part
> of the IEEE-802.1Qav. This patch support sch_cbs set for VSC9959.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
