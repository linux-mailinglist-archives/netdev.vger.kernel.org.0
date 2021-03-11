Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA26336A97
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhCKDVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhCKDVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 22:21:31 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC6AC061574;
        Wed, 10 Mar 2021 19:21:21 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id e2so4264516pld.9;
        Wed, 10 Mar 2021 19:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Ivcy7Ra48iIN4fx9xpDqQ0r9uvJj0RhC3xsJ+4+M9iU=;
        b=hYxB/u6+hGcYGbqzJPZ4n+/YI9KIHDNbEmLn8g+mdbX+cCoWaGweefCTDixi2LzIhS
         0JvxCVfQO1M5ROnGAZ5hGSPutHS465fxaAXVosQn6JdE9A8vE3Nq4KdZ+SBqjW3oMESa
         bt9oWgULGfJ825ReLVN2CZSWltXvVe+3FxIY+4RZ4KMG5zJzKWGz87XOT22ejroq0WmZ
         QCPMxFyy4piD0WzUSC5td3xRyCjt9D4nU8SQY0nGj58WFFVr0s8t0ac+bWDwpZlFJzky
         d+C6x3YJ8WRlk/2DuWBgsJc3EBvRBop9NdCmAufc4sIAY1ANG6McLtnv8gw4TTKHR+ON
         yFDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ivcy7Ra48iIN4fx9xpDqQ0r9uvJj0RhC3xsJ+4+M9iU=;
        b=jBZ2eIp24TkEtBa89UfJOH/q6wkcQTULwlqtmCA0Rz09vHkHESIkkRRus9QEfiKYwv
         yNmq9gz9n7zDy7YvzKOdzW7WfagCnVw2za72oa8rjU7fnp8HhMFi4+2QFAnO7w/k4JCD
         1GImHTIoIajk1oCVnDa+y41ePArlvaN1U3BmMOZMFrq6JIl4aKop05YEzi5EIjtwN/Bf
         41ZuBFbOBLmHivzoA/0DZe3Y2Wnk12+ep24uT1E3Uq8OTf7XmUM5jIAvlzsqA4JKw5dD
         aQVoJHhZj2TbOQiCjiCVoGD9dpJmezZ1cxPQvP9MN/mLcFCvTjKPPRtxfr9RnckA6iLx
         sbTA==
X-Gm-Message-State: AOAM532jWyk7qQbtSqT/wzN3xG7SD/DS0/15RYDd1IDm6lZJdi6G195M
        EXG9wgx9mA/XsK6jcJjm7tiVaytxmJI=
X-Google-Smtp-Source: ABdhPJyj+GyJRKG6iL6Nx3uSY7ZT0SWl2tNgBCpdqHyf/QQZBu1QJgB57lu9L31MorFZqGua4kz9eQ==
X-Received: by 2002:a17:90a:a584:: with SMTP id b4mr6724628pjq.186.1615432880340;
        Wed, 10 Mar 2021 19:21:20 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y16sm778432pgl.58.2021.03.10.19.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 19:21:19 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: mt7530: setup core clock even in TRGMII
 mode
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210311012108.7190-1-ilya.lipnitskiy@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <79be95b7-0c56-f831-2f3f-5a41006d0037@gmail.com>
Date:   Wed, 10 Mar 2021 19:21:17 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210311012108.7190-1-ilya.lipnitskiy@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/2021 5:21 PM, Ilya Lipnitskiy wrote:
> A recent change to MIPS ralink reset logic made it so mt7530 actually
> resets the switch on platforms such as mt7621 (where bit 2 is the reset
> line for the switch). That exposed an issue where the switch would not
> function properly in TRGMII mode after a reset.
> 
> Reconfigure core clock in TRGMII mode to fix the issue.
> 
> Tested on Ubiquiti ER-X (MT7621) with TRGMII mode enabled.
> 
> Fixes: 3f9ef7785a9c ("MIPS: ralink: manage low reset lines")
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
