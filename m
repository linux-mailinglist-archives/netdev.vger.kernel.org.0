Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8D83772B9
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 17:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhEHPrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 11:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhEHPrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 11:47:24 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6140FC061574;
        Sat,  8 May 2021 08:46:21 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id b15so560871plh.10;
        Sat, 08 May 2021 08:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KfhtNlcH1LavtRhBCBbzFfApyHHSn0GdaQcOh0LMGmo=;
        b=Mf7tRNLAjIURyR9wQ8GLU6ORB9wN/FVLl8nmpewHGkLBuqCeGe2zNDXyDxn0ppRqH9
         ARsGepMviSe0tQq0/AprdsV+pzA5GOO+kEhoUKF5z8QDcP/m0PKhEJ/aQ4NzlHAIadwn
         9g66fni9EK7+eDBgax0hn6+YQ+OBD2HWx/+QK5XufnyC0B5HbE+dVGdVVVtyJ/tCT28b
         m7bp/hG0bptctUn1h3+LJICsMZHBQ6lDQsZ6KWCByRPFJsRD04i8sQl9diIfHAVrU+Hw
         0YwGNqAuaMdA5vKQ1XX5COLXnaXerNCv+mVd9zuLi2H4lM6bInCa2yIeQXS6aUdNCstE
         KjsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KfhtNlcH1LavtRhBCBbzFfApyHHSn0GdaQcOh0LMGmo=;
        b=d5/+aDAeFFwL9huyjq82IVxxDEWea9DToz+5puaXDksh8+LNrOUHrJKoGSvwna6unZ
         kHdSJLzrAd2VgJFQOjpVsTVw0TM0YZbUhPB7dGUnJy+pB2o7tbhA0Sx3iNm6Azngdzkv
         mI98IUA36YYeKIdsgeffMqxawF70cR/gThsnLsOANY6/Z2vVVa/anKNZF5tAvQ3fZLNP
         rtxx+vYhsUX04w2vdWXrvy4eM8DXwVC7X5MDZloA2hx+TSCpV4clMEeIj/mLylr9GxCr
         vRSxQpHwqoEGlzV5n+xIXO1V/Np4FtM0+oNgQ4C48hWdc0GfggkQCwmaZDaeY+DZeb2Y
         32yw==
X-Gm-Message-State: AOAM533KGqe9JraxvhH0bQrFcgBUbWGi1IdcFyUK8bmiMQ/bXBNyoz5V
        XrJKprK3cbb7HHeFu1x4LwzNTFWJ/qI=
X-Google-Smtp-Source: ABdhPJxPjEc5uuUElaRHX/CCRaDFOuNLajA3T/33gAvUKxN+g40sltfYb2yiFBd7yeVFllobjjxVoQ==
X-Received: by 2002:a17:90a:3042:: with SMTP id q2mr29833584pjl.21.1620488780585;
        Sat, 08 May 2021 08:46:20 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id gf21sm7032774pjb.20.2021.05.08.08.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 08:46:20 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 02/28] net: mdio: ipq8064: add regmap
 config to disable REGCACHE
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-2-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a0fd68e4-4c1d-8d25-bb9e-a1351e92787c@gmail.com>
Date:   Sat, 8 May 2021 08:46:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508002920.19945-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2021 5:28 PM, Ansuel Smith wrote:
> mdio drivers should not use REGCHACHE. Also disable locking since it's
> handled by the mdio users and regmap is always accessed atomically.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
