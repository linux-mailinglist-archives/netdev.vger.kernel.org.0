Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A31725533D
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 05:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgH1DR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 23:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727926AbgH1DR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 23:17:59 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25CBC061264;
        Thu, 27 Aug 2020 20:17:58 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id v15so4795323pgh.6;
        Thu, 27 Aug 2020 20:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Acgh+gXWCp44sH5EdKE9He1TE2jOtN1C7UKDtNZ4sIE=;
        b=vBN+Y/SotcpwEh6AMhqSlwWaxtcKoaSUbWfMUtuyZdHzKW5TfZ8DJz8Yx+xxylqzlQ
         GQ3i2zd4QOhUoP1slCQrO0l9o+TZIAv0hMQWzlvDoP/+Y2Lk6/mYQ/Qv+4OmcCDre5Db
         86nL0TrsL7Z2RKM+k48xlfBjHeTO4jW831d4bgsJ24G4Ln6vNvdhhLZ02FV6nNe2ODe3
         GegnjDvKkF+10p0vYUELejAwpAZl+loZPNXIQ7jL2JQh0bQSoUO33pRCMvoe/dcSmt2a
         pflAAVAsfudXZVOBsr0Jjcaw7cAC7XVqhJ1X2LyMAzlbWlHQdBT7IpNVDrNwmPxOsZZo
         AXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Acgh+gXWCp44sH5EdKE9He1TE2jOtN1C7UKDtNZ4sIE=;
        b=hrHxzL4IhPabYPnMJ/F+cAKEppymoULE4TdQP9FRED2sNLrXidTBVLD50xTamu9w/G
         Xy/rIczUTMIPqJPRLU+LTol7pN0PNU2/iZEG2FXzd4mVuSXQM7P16HTUwH2+Jom5DJuF
         vgWdMfvE2MULTio4ZmuJybmri1a4bgDoXXNGiT1+X6GIaNrJgptmF1d1yk3l8SLfe6Sk
         54Tcit1aMsG6sqsfvPyMOsc6m0ZQapoLTCtoai3BZwjSscHOPeZvsWTsJP9I/BWuJCyV
         EWpKk4VoOo2yQicYyWxMLBLdh+gLHuE0IaZB1+GD31gXJlgtGMfzC/zycVDX44EawzLo
         VJzQ==
X-Gm-Message-State: AOAM533jNae/sr7W4URrk0VzmLLMMFTsEQi7pivhbFot6FgbjRcwf3JA
        bmmXDWuwyJrqAhwJ8jQ9PzfhKHaDoAA=
X-Google-Smtp-Source: ABdhPJzxETbPjbkS1YYjBk/nb7tJpKyjonV9BeZNuwBds+ecpSdljYXHyFI8GAVk1R06F32B7QfSfQ==
X-Received: by 2002:a62:cdc2:: with SMTP id o185mr16431736pfg.170.1598584677717;
        Thu, 27 Aug 2020 20:17:57 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s198sm3743784pgc.4.2020.08.27.20.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 20:17:56 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: mt7530: fix advertising unsupported
To:     Landen Chao <landen.chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     opensource@vdorst.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        frank-w@public-files.de, dqfext@gmail.com
References: <20200827091547.21870-1-landen.chao@mediatek.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <95e3cc4b-e9a2-b9b0-2f7f-4c1e4d2b8bb6@gmail.com>
Date:   Thu, 27 Aug 2020 20:17:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200827091547.21870-1-landen.chao@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/2020 2:15 AM, Landen Chao wrote:
> 1000baseT_Half

Looks like this part of the commit subject spilled into the commit message.

> 
> Remove 1000baseT_Half to advertise correct hardware capability in
> phylink_validate() callback function.
> 
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> Signed-off-by: Landen Chao <landen.chao@mediatek.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
