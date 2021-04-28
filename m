Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE87C36DC50
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 17:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbhD1Ps1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 11:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240436AbhD1PsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 11:48:17 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EC9C061574;
        Wed, 28 Apr 2021 08:45:41 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id s15so4648896plg.6;
        Wed, 28 Apr 2021 08:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2vZ0AKnDboqjZbAiNJuZQzrB4J8YOa93Uv14IQ2XAKM=;
        b=izXA7UyMQ8IO+w9Vejf83Fpxa8aWNYO/isxt2+aD00Jlm1fuGsu/nHVRp47b9Jkbvj
         UKmS7c7B6aZpouWRPbey8PJP4hYL1RjvCUwBMKIy2zEamVS5so2Bn2gT4f0VWlkmtzCa
         cBIxue37ILLxqtIXPHmZa16j8G46jppfb8i9zSBdeUPcjaWbMQntlHWdEM0Ipyv7UBX2
         6z6cAKkPIz3jyJsEMx9eL6k2XsX+QV3bRelGkf0MN91Lb/Ejkz/Vbv0BK9eqh5jTw09e
         oD3rriFghsp8SsUd4L5UXueg8BamgbMHeOcCqjjl2Sushb0tFE0OzdSA1j+4csymT1xP
         n7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2vZ0AKnDboqjZbAiNJuZQzrB4J8YOa93Uv14IQ2XAKM=;
        b=ts8zlUdy7hvWwSvV2J8hmQfeODE9lqZ5Q+NKmLZdWX9ii/0xg47PEn4fGJlt/RQMDP
         C9X3KipEJT5/qCKMwZW+W1THi7HnPWRGsTAWotIPwSEQ21lqd7Ptob1qJyhu3j0rLzBJ
         bPyLq1QtF9Ks+AAIYZPyZR0eiQpwWneHu3qM4e/GR+ZZSYZfCxcxK994lWCRKg2QqQ20
         YJK3TGQtT9TyqTERSqpK/2abSc1CSdPihz+IJZmLvh10ox3V1N/gx2JvD2G1GeR4Y5tf
         ZRX7buXwIOf9dhZl1jccmWs7lI392ajTnYXGHyranIdrDKM8R6UxyFP4cPBZFKGltTji
         d5/A==
X-Gm-Message-State: AOAM530k1iRjVhc1mXzjjj944Dl/5uJvPmE9soSx/+WpCWmgEfWGfKv7
        7Ql4m78+d0Ngmvf0PLXiCd0=
X-Google-Smtp-Source: ABdhPJynZNJb778mZIb2o57QU61Urns28Nq7jYy1utTOz/bhRRDmdNkfs39njlfpGeGDVg8d2Zuosw==
X-Received: by 2002:a17:902:c38b:b029:ed:442a:276e with SMTP id g11-20020a170902c38bb02900ed442a276emr13576805plg.51.1619624741222;
        Wed, 28 Apr 2021 08:45:41 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id j7sm128440pfd.129.2021.04.28.08.45.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 08:45:40 -0700 (PDT)
Subject: Re: [PATCH net-next v1 1/1] net: selftest: fix build issue if INET is
 disabled
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
References: <20210428130947.29649-1-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3fff9119-9f0e-33b1-64d0-a0a06c0f75ec@gmail.com>
Date:   Wed, 28 Apr 2021 08:45:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210428130947.29649-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/2021 6:09 AM, Oleksij Rempel wrote:
> In case ethernet driver is enabled and INET is disabled, selftest will
> fail to build.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: 3e1e58d64c3d ("net: add generic selftest support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
