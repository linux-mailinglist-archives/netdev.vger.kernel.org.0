Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1312CC358
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbgLBRUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730573AbgLBRUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:20:11 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0221C0613CF;
        Wed,  2 Dec 2020 09:19:31 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t37so1474849pga.7;
        Wed, 02 Dec 2020 09:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lb1TixJdDgHpz8VRboBx5x4l5NaR15Ck5CwsssBAGFk=;
        b=qFyVfFIdKGzxlIXV8iBnn8r33OIZOD4LqVq++WA88m1MBaKJid7qKd25uHpsbypTyj
         o95OOQqFYWwTaxjmhm49ZsemuZiG2zeEGSaggF4r2Ao6v3jIE4LGskn4ZxwdhmEbVuc7
         +42h++TVAsSnfF3ntkrPjU6qP+bLZPdRutF26brfIXQZ21WyItU7czgMb9MA2jRTVP+/
         otZOntbcwKOHVNoc/LbHq/ALhFDbVJE63JzDCSXAue5OStRaRetijDTMRZdy8nA1Px6T
         lbZD5C7eVRyunV/zP1B+Fv8Ux1divEtSpt4C8kxnRASJorGFfCQJN9ltAecge8MomaB6
         4yYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lb1TixJdDgHpz8VRboBx5x4l5NaR15Ck5CwsssBAGFk=;
        b=NvtiVs+fCunj/6i5Q5u6H8VWVYhPVgCW22A/9FmYr2XXYYVdR8zFJov4zuhNcbrYaw
         J6WdVSetinO7ziNuGTtJFtpBizCtMJtmWXzng2WytgRez2C4eW79WH4KLcpFOy9dUaxh
         bni4M0Pm/7eS3qpBxi+QPhh7sJW43/I2SkSPuFxkX9r8aSBI47mXq8ye+Cq5Um9XextU
         N2CcgJR8bFSFJoM0NQQG2zDB+Cu03RRfKunXMWuUwOhuo5ThSz0esn9u0JRdokTI9Xdm
         XAV9BDu26YlLP/UZTCmcV9b519hK4APx2035YOJB0fGuPbLL4HQaCAFq1Ckqc960fT01
         FVMA==
X-Gm-Message-State: AOAM531x+OvuiMXONrX01If5LXPQD5+Gsxj994Wdn8YPml5U+tTFRBO4
        rrMwbjbz4beiCnXj3eJXXFNwtbytdGg=
X-Google-Smtp-Source: ABdhPJzfr7hYqKg1Q7LET0QkF+1UOe12/eVTDyIwig8JByRQ5H+mEsvJe9HXsWuGOZp/qA/aPmDwkw==
X-Received: by 2002:aa7:9387:0:b029:18b:42dd:41c with SMTP id t7-20020aa793870000b029018b42dd041cmr3554296pfe.60.1606929570781;
        Wed, 02 Dec 2020 09:19:30 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u6sm359059pfb.197.2020.12.02.09.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 09:19:29 -0800 (PST)
Subject: Re: [PATCH v3 net-next 1/2] net: dsa: add optional stats64 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20201202140904.24748-1-o.rempel@pengutronix.de>
 <20201202140904.24748-2-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <222e8546-2bf2-fe0b-871d-7866ed87b54e@gmail.com>
Date:   Wed, 2 Dec 2020 09:19:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201202140904.24748-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/2020 6:09 AM, Oleksij Rempel wrote:
> Allow DSA drivers to export stats64
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
