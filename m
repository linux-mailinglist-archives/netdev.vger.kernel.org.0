Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B79541554C
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 03:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbhIWCAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 22:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbhIWCAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 22:00:12 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71106C061574;
        Wed, 22 Sep 2021 18:58:41 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y4so4317357pfe.5;
        Wed, 22 Sep 2021 18:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BULErLHVQJdMPODSCdmMhke1jEOXzKYKC6Do8994JJk=;
        b=gksRgCkLLXg/sUM2Nt+EIaHYcFqu2yDwCXamivVaB+0DA/g0KBjbyOobcT5xgGFwgz
         zQ1ICWMMVTCW29OcF6Tzc99G6ySvL0ce4jhxse4kLK7nnwCzGYUSOh3YyShHj/F5oeM+
         sAnrBYWmEgOnMZWBM9renUbvSPaA6spP+NVd9EXb2rHkSjQQVaEkVjd2gup2oHAEJNPP
         kCd68BUu2fukXWIdkkvKHldg8tQbzUWkz3yNZQ9GPdTU681QnO/XUSAJtBEvP5l0Ol0I
         ncRd6Rm2iDuqsWjHF6yNNNpVg0fUnQZNW8CQXirVl7RA5BAp0NS/LDqBDqj7JgBTeFR2
         8Ibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BULErLHVQJdMPODSCdmMhke1jEOXzKYKC6Do8994JJk=;
        b=nH6uxhmtWvBPCeprtc3Ghx+Z1QeAbevndgJA3Kasjg36DtnxB8GTA9ri+vfjXxn5Bf
         vCI0ArnpprzpUT81xxnmBXIZ4mDHOrywTiBRjVT/Aoe9AIk63TZ2f8jP7LzqSp6uS2Tg
         UrvmZwdtFIAnp2sVpOZyv3pKWld8PmoBC5aNP/7bHdn/RgJ5qFvDf06N2mk8TLEHUx65
         unwaD7A5ztzfjWMdh6ytUDwKmoAzjZWxXytF5tvK25Ao1pSWIZ+Ijaj3Ge0rxEmJFBOj
         hdMTP0roaH3c8urtBOhqKj9IioX99/fJn/cu6jtwN9hM5She9Vm1d7pJSCY58matCU6o
         VIPw==
X-Gm-Message-State: AOAM530nsDrVQrUPYUusfDPHSv22NtJF3OJ+rQGbJUvOZNstCeil9F3y
        RrCfiXSnJMDPoJIU4jMVnhw=
X-Google-Smtp-Source: ABdhPJyD2LH+UTz/9etn7impHfw9lp6fF+kkLXEXMgETykjkfqtWaPJVBAxVV8lYTsS3QYVf/2X6QA==
X-Received: by 2002:a62:ddd8:0:b0:435:4de8:2652 with SMTP id w207-20020a62ddd8000000b004354de82652mr1708812pff.53.1632362321019;
        Wed, 22 Sep 2021 18:58:41 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i2sm1402145pfa.34.2021.09.22.18.58.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 18:58:40 -0700 (PDT)
Message-ID: <78621e42-e41e-3581-221f-648a93deb384@gmail.com>
Date:   Wed, 22 Sep 2021 18:58:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH v4 net-next 2/8] net: mscc: ocelot: add MAC table write
 and lookup operations
Content-Language: en-US
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org, po.liu@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com
References: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
 <20210922105202.12134-3-xiaoliang.yang_1@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210922105202.12134-3-xiaoliang.yang_1@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/22/2021 3:51 AM, Xiaoliang Yang wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> ocelot_mact_write() can be used for directly modifying an FDB entry
> situated at a given row and column, as opposed to the current
> ocelot_mact_learn() which calculates the row and column indices
> automatically (based on a 11-bit hash derived from the {DMAC, VID} key).
> 
> ocelot_mact_lookup() can be used to retrieve the row and column at which
> an FDB entry with the given {DMAC, VID} key is found.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
