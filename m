Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1DF1D1941
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388395AbgEMPXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731638AbgEMPXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:23:48 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F4BC061A0C;
        Wed, 13 May 2020 08:23:47 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id d207so9188839wmd.0;
        Wed, 13 May 2020 08:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aP5RqJaHjw0SSvS8jFa4SufpVRHV3wMOfmjoi5Yc1f4=;
        b=ktSXpuEIWmOyZetJtmtSOLnT96UirVaLdRpcXWTE/gYQC1WX1lHtfWkkUtx3Kfvp0S
         RL0FBNdf5vCW2FR41NIuumOgKvTuRUjtFFS/fA2Yphvfhpc4c6vHIuyy054G1B67Clz/
         Zqf0aNveo38QkOin7+9hk1I9AxhhNxfybUbb8CtvSQSXOxu/0KmHavMD3kiZlx04xwB8
         F3DhQX60hJ4YWPRdI5cmLK+U/WrFzCsOPHO1z4jKgROLch25aU4EiGazMvSmRKXEcrff
         TSWqovL29eEUyHBp8T5smBLlqePqhRdgFfW/1yoXCgvZI5PAkLcK6wQRY6EqqsLt7LOe
         3MPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aP5RqJaHjw0SSvS8jFa4SufpVRHV3wMOfmjoi5Yc1f4=;
        b=WDif4wpAROpbSq77A1ZLhqUhT3xtOjOn09zmqcCjwHih8x9KuHaq/UcteyYDzBGdXA
         30lIjjsFHkLuiDghK//IUC2G5daMstFwLiMwz2BBsvjEXyheuHOkG9D+0P6Ryriwg28/
         67KtAC918es6ppqA6Q+wZPBCqBYL09AZzT0r0hsXU1Mj+1iNDEWv8EeLjavI9aHuSBcp
         2dXu/371LkdFnskzzTFlDTlQDLPpPpVhYkR1MyK4a45SwtxgVfVOOV0Y2Ul6qJu6g4cW
         ja1usf8DxVsAFTrjCQtKYGfhoDZjVsLRs3J6EO08jYS97A31o7UoOD9NoDW8VB+mtTad
         Vb5Q==
X-Gm-Message-State: AGi0PubjhkEl1AOJ2yPMc4oYcPGdR02lxHmzLd5MyHbCgwBR6v7hqIfN
        GQuc+ad94muwzq7oNu2Ezq4=
X-Google-Smtp-Source: APiQypIa+86lv9x3CvtVmHtTwH5kxANcv58nv4VNDEBhX9EOGhGzbMBwX6Z3SwoBXqiXgPA8mEKURA==
X-Received: by 2002:a7b:c5d4:: with SMTP id n20mr45268150wmk.92.1589383426466;
        Wed, 13 May 2020 08:23:46 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b2sm25421028wrm.30.2020.05.13.08.23.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 08:23:45 -0700 (PDT)
Subject: Re: [PATCH v1] net: phy: at803x: add cable test support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michael Walle <michael@walle.cc>
Cc:     "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
References: <20200513120648.14415-1-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0c80397b-58b8-0807-0b98-695db8068e25@gmail.com>
Date:   Wed, 13 May 2020 08:23:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513120648.14415-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2020 5:06 AM, Oleksij Rempel wrote:
> The cable test seems to be support by all of currently support Atherso
> PHYs, so add support for all of them. This patch was tested only on
> AR9331 PHY with following results:
> - No cable is detected as short
> - A 15m long cable connected only on one side is detected as 9m open.
> - A cable test with active link partner will provide no usable results.

How does this relate to Michael's recent work here:

https://www.spinics.net/lists/kernel/msg3509304.html
-- 
Florian
