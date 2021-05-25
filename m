Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42C438F830
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhEYC3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhEYC3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:29:01 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248C8C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:27:32 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so12283368pjv.1
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mbg8TjI4QV05sjqs5gnZ8QRHKPttv4dB3FqapsBYtAQ=;
        b=cm5stgqSdld2pSUbB6Fscf5Swjzg4IyZMLB4Aw5EghWRle7kwEwY5/NnKbP5xmcxm9
         A1HgC68tR0sS6ACi8U/+JYHJSbHuJhEWBW0iArbcbhklnrB3NhoyHirUoYMqxNYEQFyI
         Mue3HYbA3HgJ/4hRqLbOhknSUp2FXkxE0nh8HtC+I3AybjYYyi23oym1dDOJOKwJ8WaZ
         Gg10fkNCgSb/hL9XXKMh76TWGsWoyNQaKP2+xEHIMAW18ft/0AVyHwg7jVyBV2XbtKHN
         Ze4HSVeaP2W5jpWJIbdotQR3y/VrJTw3i3b5tHOVl8PDhCYGdWywETrpKlXfzLZwFLJQ
         0p4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mbg8TjI4QV05sjqs5gnZ8QRHKPttv4dB3FqapsBYtAQ=;
        b=N9L0VGcpYlqlfWb9cgFWmpAMATk+a+/QvHQw6XrSrHpveXZvtaAxWlpRSp/ihgPXB4
         iOrWPLlEPBl1IWul0oxzLhHU3uWCHNLvCJXyqTnblf2dZ5zz5fun63cc7ac7I4ySqZn7
         1w+jlov9V9ws/rxIZhjMdIvsE9DdAtHUmaVVMVTXRcajc2lxNrtM/ABOE3WsGfAv5BjE
         d4GdyKlqvvR0JUD0Nqb1IsDIf8cMJlPEm78VEYtInj+E8Ndj+93BLtOZriMy0EaFlyVZ
         gEL434Q42niomT0nrjYDCPdYNmQD4XxBwrRkSJla0gnVo8j3weP8+ALU77TN6nmnPNDB
         77UA==
X-Gm-Message-State: AOAM533RWfwwyQJyrXcAnx6vvDHZjj9MXz9GlVGjhoGrapNW9JsjwYRq
        c2yqLUbAM1Iy4ahXpUlcrfU=
X-Google-Smtp-Source: ABdhPJwM4oSBo+Wi/o3ipAuhWociZe/3/HfysnYcXHoTFr9qhSVFNmLIU7obh/dIR7/qVYn9l6DjLw==
X-Received: by 2002:a17:90a:728f:: with SMTP id e15mr2290579pjg.137.1621909651719;
        Mon, 24 May 2021 19:27:31 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 25sm11928367pfh.39.2021.05.24.19.27.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 19:27:31 -0700 (PDT)
Subject: Re: [PATCH net-next 11/13] net: dsa: sja1105: register the MDIO buses
 for 100base-T1 and 100base-TX
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-12-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c29b87f0-a6f6-10cc-624d-b9c4779675c5@gmail.com>
Date:   Mon, 24 May 2021 19:27:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524232214.1378937-12-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The SJA1110 contains two types of integrated PHYs: one 100base-TX PHY
> and multiple 100base-T1 PHYs.
> 
> The access procedure for the 100base-T1 PHYs is also different than it
> is for the 100base-TX one. So we register 2 MDIO buses, one for the
> base-TX and the other for the base-T1. Each bus has an OF node which is
> a child of the "mdio" subnode of the switch, and they are recognized by
> compatible string.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
