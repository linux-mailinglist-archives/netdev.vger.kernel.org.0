Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFA43315F7
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhCHSZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhCHSZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 13:25:27 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9819AC06174A;
        Mon,  8 Mar 2021 10:25:27 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id o38so6935490pgm.9;
        Mon, 08 Mar 2021 10:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yAN0scPXMGXF3LJkgy7SJ6e6nyviExU5JvHmcgxFGKA=;
        b=Yh9kD5gOl8uHv2pg5TZeK98DXgETC6e4Uh5tTZPwpYxvldZiNLIrx6iN5rLs0nKQIX
         IaE7mRxCRmiKU8/hcCn67b9sKQrQcziRJBGLfGOeCl/HE36FFH4XcacaQkFlKlMob76m
         7zNSq8I/h7uqWIhUW1LAtK2c7zzqBAxGdqXL4qSgOnLubCU5gFfFSS7CMGbZqqaFThVD
         q8bd+ixEkO4W0o2sIVjurFqi2J3Ciqyuuc4oh/VkR0zcE17r5Fk6hGwlMeOpnVM5RZAL
         F9i5VuqTXKGQsN/UnH7diLRS7orrlUYbg7to6woIlFizLfTolSJIM3gPTjiRTSRuxe4p
         6CYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yAN0scPXMGXF3LJkgy7SJ6e6nyviExU5JvHmcgxFGKA=;
        b=Y+8rSFUWE3fKgSYndFL8m2lp0td7rqpuoX7T9lq4TVPuBcphTjpetUMnt/9FoOA+f3
         31Z8r6eFZ5UFVBBI9iYhxH+vkxtzPGZi26eqbo5ujidpvDX+FR/P4DhyQ2A836ZFYVUe
         hHe9y2rkQkGRkmMxDiEqECJLAsB7eXvGFsBNN1KtAfRFviFmKofzU/Ra4qayU6lNJfwW
         pAcR894ObqLMJF+9mB3dy4c8X0iw1DomOGHK7/uZkqG/iMVce/a4o3PBPNSk5Rn9dnfX
         ypjX66PD46jg5aU3pUTTmdXG1oLUa1OKZvU1udIcGxlgkBEGvveDBFun4OruItyUxSpW
         5a9w==
X-Gm-Message-State: AOAM5316l5P2SD7yjVwDSRZo+VFEeYBxA6UxQvJAEnvx8eY9VUyxV79x
        NmJ/DZhNuchxaIbwJ52TZtCw3oCI1gQ=
X-Google-Smtp-Source: ABdhPJwAAeAq7JnefWnT8IecHo++ScGbzEcE2o0kSgbzSdfwxZdx4kUQzSqQS4JRBUAwAYHyaFHZbw==
X-Received: by 2002:a62:5ec1:0:b029:1ee:7baf:8ed3 with SMTP id s184-20020a625ec10000b02901ee7baf8ed3mr138594pfb.62.1615227926861;
        Mon, 08 Mar 2021 10:25:26 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t18sm5285234pfq.147.2021.03.08.10.25.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 10:25:26 -0800 (PST)
Subject: Re: [PATCH] net: dsa: b53: relax is63xx() condition
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        jonas.gorski@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210308180803.19123-1-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <895b26cc-3a4f-ec3b-f604-063a77a3d984@gmail.com>
Date:   Mon, 8 Mar 2021 10:25:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210308180803.19123-1-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/21 10:08 AM, Álvaro Fernández Rojas wrote:
> BCM63xx switches are present on bcm63xx and bmips devices.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Since you are targeting net-next, please make it clear in the patch
subject next time:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/netdev-FAQ.rst#n28
-- 
Florian
