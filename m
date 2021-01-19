Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC342FC4A5
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbhASXSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730428AbhASXSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:18:22 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFD3C0613C1
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:17:42 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 15so13946487pgx.7
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bS1EXwVf9++GgF5w+IZun5/4T2TdIFJKa7KEA0Lv/a0=;
        b=hpJ1Iih2ZaQEskGl2DHiWyn7xFj/Lcyv7+Vmc8dg7UpM8J6zHqS55XGjX5lABSsUj7
         betvSSBD/2tezHHac3ucSyYM2tGVQhGZJHcDF1Scn2efK3eBL1stepK7jDFiTgkU3xnm
         KH6gfJHEaFnogsEFC+TvSQjtV77nNnkZSveERxnT83zPxBB+II4d0H6ZusGnCxKMTNEF
         NvtZ5u33IE6a0L4wShAotvpgBnzrpF86s1V4rA24hU8Gj1w20VTOJrSPo/8zghmVoYVg
         J9b1aA9mp9nsWfPoxwAYc/dtYC+Y8DV9ZRIwxNQeVWoKfSVEfX+1pO8I1qg6Rn6ByGzI
         Drfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bS1EXwVf9++GgF5w+IZun5/4T2TdIFJKa7KEA0Lv/a0=;
        b=Duiuum8M5i7glSAohy5swgekSMceU+I+Qa2a9JcizZVv/Njy25Gv8Kd0VV4EU1qLwu
         3NhPvO9bBejI2BgZCfPyORJJ6Hqf1EzZn+6Jygrf9hEFK1MghkVlepCyFn1Ta5NZCiid
         epYJ4GG2sCOZSnJGby4m1EBx3P3OzYusQ7MEqvi+PVOVZuEX0JrgXnjps4gKowaKHRzi
         YxFZa5X+e57PLdQH+Jx2sNfRq8Q+HFe2nvPp8cYasC+bg3ZIyTNc69NoLEgGbYDM5Ua+
         on7ouuI2xD9GRM8jkeoiMqH+bRt2wa+kM0YYBytb4hz1JzcPnWznobic9p4uG0sUwTm/
         x2Ow==
X-Gm-Message-State: AOAM530hOtnUNtUoTY2o+sfh7lwWPjmK7uPv2rV/Rvxu/oLibZgBE6Ag
        kRFsT+MuEpPXmsAWjt+7j+o=
X-Google-Smtp-Source: ABdhPJyFL6mbd3Li1/SfH8DdjGECbDytJ+kxzF2HBOs7sLl1SLKsrQDsJsnaAOa51gtU0ZhYPrMOfA==
X-Received: by 2002:a63:5d10:: with SMTP id r16mr6493408pgb.406.1611098261910;
        Tue, 19 Jan 2021 15:17:41 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p13sm64427pju.20.2021.01.19.15.17.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 15:17:41 -0800 (PST)
Subject: Re: [PATCH v4 net-next 13/16] net: mscc: ocelot: export struct
 ocelot_frame_info
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
References: <20210119230749.1178874-1-olteanv@gmail.com>
 <20210119230749.1178874-14-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <36d77745-9b59-79ff-4f0b-9613149495b3@gmail.com>
Date:   Tue, 19 Jan 2021 15:17:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119230749.1178874-14-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/2021 3:07 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Because felix DSA must now be able to extract a frame in 2 stages over
> MMIO (first the XFH then the frame data), it needs access to this
> internal ocelot structure that holds the unpacked information from the
> Extraction Frame Header.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
