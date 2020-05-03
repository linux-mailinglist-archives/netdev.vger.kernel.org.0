Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B8F1C3009
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbgECW3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729151AbgECW3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:29:48 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615FFC061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:29:48 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id r14so4649704pfg.2
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 15:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wJu+Mse3+NxOsWcoCT2fh+j7ralApV2yA4IYrpFU9Cg=;
        b=Hf6iZ/fCyPJbvCd3eeGzGm9COJeMBhYzYQvxom2LVTBth7SK6loXC5OdfRFH8HD6MI
         aSjEgC3M+5Xb4G7Opb3Lu0K/E1iv2IMpi1ENjOt6wLCcyXcSccAN6gaBqzDBgZ34vHSQ
         MmOmqxqCfuLq4m5VYc5k4ec+klVUSwKqqLl7v0vyjdisbc4FC120CC4xLXd9QSl9JcQ9
         AK+rIlvc2BIGvrJ6fYaT34u0mlCUNirj6HoDp7CiNfeN9BUjDHwsWjWfjH9B4SeDYBPL
         RqxvzVlnjAuufi6ftZh9yImCat77w6da+BXpH3TllOuYh9DnqMvG0yKVOoH3tC41Ll1z
         6ZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wJu+Mse3+NxOsWcoCT2fh+j7ralApV2yA4IYrpFU9Cg=;
        b=dKy8vj3E92qx4E9JFho5CSQc3Q9rv46IwR6UDRHdslw8JEwKrgtoBp+C6xtuHOfTF+
         q6nXCyF76zkakeNM/ymOEOmemnJNvQGGxMet0EYaLpjDgUUrxF9oZY7xMC2tKPfiOgH4
         kmtrFzQQec1bDlO7/qKQSGuR/qcRx0sEn+jvCgK9OnBKCI/rRzorZ74sbPCN3EZMcKIK
         e180JoAm8AEJSlC5evuSfcQiyK8SM6BhcI4ApBLg3rt9Qgcn1MGhPrykpd1tcWHJ8U3r
         SDCqOus9w9IlhCZ8m/7csu5XC2iTDabmp+148hDTia6JqoPKnBt1IojzhNCDL+luT0zm
         m/fA==
X-Gm-Message-State: AGi0PuZ20tRXNFlVJt9xabmRxp5dVKVkrxgpdrjUTFFXrOeyTd+gE/3s
        +TOWTnZbreFf1xiq73EfosI=
X-Google-Smtp-Source: APiQypL4eJ8NBPAq8LH9NcYtYmIyg16jgLhhTaB3wUGYY2V4+6dcvd1z/MruXkNlihMcjvWfGGxMfQ==
X-Received: by 2002:a62:24a:: with SMTP id 71mr14001331pfc.98.1588544987885;
        Sun, 03 May 2020 15:29:47 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 6sm4725426pgw.47.2020.05.03.15.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2020 15:29:47 -0700 (PDT)
Subject: Re: [PATCH net 1/2] net: dsa: ocelot: the MAC table on Felix is twice
 as large
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     idosch@idosch.org, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com, jiri@mellanox.com,
        kuba@kernel.org
References: <20200503222027.12991-1-olteanv@gmail.com>
 <20200503222027.12991-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <00eebd56-79e3-9e06-cb1a-777587bfe51d@gmail.com>
Date:   Sun, 3 May 2020 15:29:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503222027.12991-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2020 3:20 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When running 'bridge fdb dump' on Felix, sometimes learnt and static MAC
> addresses would appear, sometimes they wouldn't.
> 
> Turns out, the MAC table has 4096 entries on VSC7514 (Ocelot) and 8192
> entries on VSC9959 (Felix), so the existing code from the Ocelot common
> library only dumped half of Felix's MAC table. They are both organized
> as a 4-way set-associative TCAM, so we just need a single variable
> indicating the correct number of rows.
> 
> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
