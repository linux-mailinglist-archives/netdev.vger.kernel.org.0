Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6123E1D0573
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 05:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgEMDUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 23:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725898AbgEMDUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 23:20:14 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26067C061A0C;
        Tue, 12 May 2020 20:20:14 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k19so6264319pll.9;
        Tue, 12 May 2020 20:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XD38n6V2qgxBXjjSdcj6JhmtoFkm4TOzDKrNrbaIs58=;
        b=GCL+RLNGTfuzoG5Yzug/3bMHJ6vKT724tq3dBa5FfW7CopyevpsfdnHx+5sOgs8MqM
         8LUxoZnoJmX6tAA6FqskPW9f4Y96qZfgXwufvUEOcquHDo3qgEBXKBd9Ml2ehw0F5S/h
         +Ksz0ZWtMOTkHAl74wn1J0fgDTPn/MDGWDEwWwKTI+sFzkGxg0SOUpnr++Jl3VKkhyIN
         ShMbvhaiymMxF4kRztcLrLkioA0GJ4mj+NxXlKq3p7kcw+63Id4VDJhQwobcw0+I2oUM
         ZQnIB/qNNhS++NT09sKaoR/y7kMrZbxO28526lYidPseVuoY9uXK8VGJKU3snpIhX64Y
         1GCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XD38n6V2qgxBXjjSdcj6JhmtoFkm4TOzDKrNrbaIs58=;
        b=SulV17PjaG0rRo6eE04IK9uy5WCQY6hsxBJuN+wAq0PMPdtuTI3C0HxiG9T9quzIRi
         seATxXsVKvJOOUaYb0rqOKezsLrcoSZGd6WC6Z5q3Bb9L+Gjr3wujB4L65VOmszenK4Q
         DSQMewPTcbGfMXNRiGaNMFY/RE/OROELKpUgvtlpevuzkPR5YUb51VDQ5/RE7UyuxD2l
         8yPC15kEbJtQHeOG2iAnyBWRSoOCsUGU/s0xdjwYMJj1yWgjBb3O9ZTn+3JJuDK73ufq
         Xq7Gqa08+A2O8isOF0MFp1cvaAN0k+Zsl/Ma3SrEUHZYBEU5nO/Rqs3t3FzS1dYINfrV
         8rdg==
X-Gm-Message-State: AOAM531rxFOtxdAU4WzbZeosRjJNjQsEKKWBUnMND0jMLi7kOpWqfYbn
        3+0PglGbfTXQ59z7KyrSgTo=
X-Google-Smtp-Source: ABdhPJxWJquSm8ASVk33Y1E9Tt7eLgRGCFaCdLv9wK04M5FlZPcxFjH1w7Xx8sX2SX2BKqMVTdMMPA==
X-Received: by 2002:a17:902:ab96:: with SMTP id f22mr6160334plr.221.1589340013659;
        Tue, 12 May 2020 20:20:13 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a2sm11679287pgh.57.2020.05.12.20.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 20:20:12 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 2/3] net: dsa: felix: Configure Time-Aware
 Scheduler via taprio offload
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
 <20200513022510.18457-3-xiaoliang.yang_1@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c0408d43-d8a3-31ab-82ea-e5940a97be47@gmail.com>
Date:   Tue, 12 May 2020 20:20:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513022510.18457-3-xiaoliang.yang_1@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/2020 7:25 PM, Xiaoliang Yang wrote:
> Ocelot VSC9959 switch supports time-based egress shaping in hardware
> according to IEEE 802.1Qbv. This patch add support for TAS configuration
> on egress port of VSC9959 switch.
> 
> Felix driver is an instance of Ocelot family, with a DSA front-end. The
> patch uses tc taprio hardware offload to setup TAS set function on felix
> driver.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
