Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFBF8DC79
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbfHNR5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:57:22 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38388 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfHNR5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:57:22 -0400
Received: by mail-pf1-f194.google.com with SMTP id o70so8682227pfg.5;
        Wed, 14 Aug 2019 10:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sIldc6jXRVC+lc5RXzHPawmulDQAg2ryD/pxJXvuiCs=;
        b=YJFXtt1RDHo959PWO3AFv7MofCfpVwLKxjA96ZyJOqdmhhuHf+wIQAIoYCViqNdyIF
         ZbYoPlCmRrRTYp3+D8Wdm+JBeuahcKM6ev1UUZUq2Sji/qYto3IUJG/4Jo5K/dGyi/1h
         ONsO3ZGK1OqvcQdT945itNVbn+uFv9hXUMPHSfAplJVKQbNyTASAjFzZTQJ1vEM3Zb+n
         ghG/wtZSXe452RqBPrdcgMvdXeh3zKsOFg98TTHKy0Fz3pSIeQiOl36xtc2dEadqNQNC
         M196mMf+sENYUsiXfU0PhduLdcWQ7L3sQn7eZciQX6iutdAFud1A3hdWjZbgzOUiZSA/
         IkMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sIldc6jXRVC+lc5RXzHPawmulDQAg2ryD/pxJXvuiCs=;
        b=a5e2KxSf7qvYGadSRxGMBqatayiViS7or28ecx0PanJU61I9wWmaYAYXwjtfsGQCiO
         8Ga6SS57zBoGDePjmNeuZz43ml6DJOS7fD1Hgj0N6j/U4HcWHu/+yX70uU0qGfw3ZYEB
         9lls/34WQ04/6JWCdbgrd/UwYvT1Jf9kCTYvlVJgEUWh1PpsFKBniDv4DOfCyMJ8qQKv
         1ndxJo+j5ENaiEq805HwKTwrF7sbw6Pq4tbGscPkmkq5EEkg0/nYM3CP88p2A0UkxDto
         xkP//L+Tq/bIxY2BUvLaaW7ojgga6ngozNNnVQNisoZM1rNRqzQBAM/EWfkRTsNDz1ts
         JLyw==
X-Gm-Message-State: APjAAAVNzYr8zUtE2+E3Adkw8uXoFw1VphPYq/ZpxhnbDeaD4UiinSqO
        Lq8Op5S5UTVM4Hv4K/SPGkQ=
X-Google-Smtp-Source: APXvYqzR1ylXu1qwGC1icAsBippCSTq3LnRyKggFv9kuJvHWldmJnszQA/sOj5+6L00hsuGg/h+CDw==
X-Received: by 2002:a63:484d:: with SMTP id x13mr359782pgk.122.1565805441682;
        Wed, 14 Aug 2019 10:57:21 -0700 (PDT)
Received: from [10.69.78.41] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q63sm522617pfb.81.2019.08.14.10.57.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 10:57:21 -0700 (PDT)
Subject: Re: [PATCH v4 11/14] net: phy: adin: implement Energy Detect
 Powerdown mode
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        hkallweit1@gmail.com, andrew@lunn.ch
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-12-alexandru.ardelean@analog.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <f13feaee-0bad-a774-5527-296b6f74c91b@gmail.com>
Date:   Wed, 14 Aug 2019 10:57:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812112350.15242-12-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2019 4:23 AM, Alexandru Ardelean wrote:
> The ADIN PHYs support Energy Detect Powerdown mode, which puts the PHY into
> a low power mode when there is no signal on the wire (typically cable
> unplugged).
> This behavior is enabled by default, but can be disabled via device
> property.

We could consider adding a PHY tunable, having this as a Device Tree
property amounts to putting a policy inside DT, which is frowned upon.

> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Other than that, the code looks fine:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
