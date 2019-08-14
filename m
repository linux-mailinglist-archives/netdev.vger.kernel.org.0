Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0E28DC2D
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbfHNRsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:48:00 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46579 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbfHNRr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:47:59 -0400
Received: by mail-pl1-f194.google.com with SMTP id c2so50986416plz.13;
        Wed, 14 Aug 2019 10:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fS4kPQgZt3DYEbiPq0u7VTrMe5Szw8IiQ2K8G8ytzN0=;
        b=qqCcc3/z5ALNGuVHqSIXZOlPMuXnpQ2BAkWhbpWcBXFq0VFyR77U+QQ5UDIFq2s0f+
         fGERmyWFCuO7bQ4sUePSDnzJq1PCvC3vUeUteUFWL6lJifUyGrKscNXz0O7ud87pf7oS
         +kvhAuKOrqQ66p/etrZCH5732GQipm/UHb51ydymptCv3g9aEo/V8AFEC1aoHh1zWwL8
         raHsFlfAgpvPFzDBJraXETwU2+fRmLMVKAop5cgh/BJXSLRZ0dm6m1awB0HjbqH5U3b8
         bmxpbbx5BA0TW0tgnEUGkVNEVI3D5LCo3+H4jN8eToC4jFhGiNk2Nwk32u/H30eDPVOk
         9RRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fS4kPQgZt3DYEbiPq0u7VTrMe5Szw8IiQ2K8G8ytzN0=;
        b=Sm0yCwVIRwM+02SXo/By7u/zjnq6U2em3xBnPEqnSoiyMbl23PV6kqaCwEV5QwC/B1
         Wpe7XYzjp7ABrHpf/UeLPoK+gBx2pSMzHebbkgDGijgp9oEtnmGju5Dw8e3BAULwC0K7
         Sw8L9YyeFQeExOIFQAeijrMlt+t065vggXxpdJfnbQikHTUO7CGT6fy5OX+Qah9mU2ux
         dGIEf4G/d3N17+9rcEk1NfQiqmUa4C9owp7OMxgLKC/hmQkrag17W/1aSrYuMmtZQAwl
         ckcUGzD+H3wI4l4MMMIt42PqqlSEs1CrPkibnGvE2XQECmy/KL75iBoUwtRz2sW9FpJ4
         cfkQ==
X-Gm-Message-State: APjAAAXiFZL1+9x50sbKPD+BCPgb/9ZX1wdj30KXEuLcJ956sACBoX9w
        xqLfPlciYlqCfhhJK3nL+i4=
X-Google-Smtp-Source: APXvYqw8tyzctYSrXEsuQU1pWrz6KxdPqPff/4U9AE5+in/Fck2jAE7bmz5hRvmGRLIz/tRPDc3qcg==
X-Received: by 2002:a17:902:f81:: with SMTP id 1mr523335plz.191.1565804879200;
        Wed, 14 Aug 2019 10:47:59 -0700 (PDT)
Received: from [10.69.78.41] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w189sm436879pfb.35.2019.08.14.10.47.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 10:47:58 -0700 (PDT)
Subject: Re: [PATCH v4 02/14] net: phy: adin: hook genphy_{suspend,resume}
 into the driver
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        hkallweit1@gmail.com, andrew@lunn.ch
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-3-alexandru.ardelean@analog.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <0dcd91ae-16fe-ff94-0257-f5a7613c3d4a@gmail.com>
Date:   Wed, 14 Aug 2019 10:47:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812112350.15242-3-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2019 4:23 AM, Alexandru Ardelean wrote:
> The chip supports standard suspend/resume via BMCR reg.
> Hook these functions into the `adin` driver.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
