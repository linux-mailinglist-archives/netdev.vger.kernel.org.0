Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBF13FE10C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 19:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344734AbhIARRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 13:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235197AbhIARRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 13:17:54 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA43EC061575;
        Wed,  1 Sep 2021 10:16:57 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id c17so166360pgc.0;
        Wed, 01 Sep 2021 10:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0gLwa7TL8+Ri7GHLtgKluOhMesmdRPej1IJ5VwUJq5A=;
        b=BNc72ORT/0Gz8OavpXb8ehxzu5n3jyg9EgAEm7tmImEuiYHf8/i3dRdbjorNepuh/n
         LcufB+hWgT2XUObgCOLhjBxk2Ugwia8st/2Zn7iqCZNGB79fCMCJP6cqvxBtlW8PltJA
         v3PNcxek0Vu902PXDqHghZiukxgJZZjRMc1shTnW3ym+DSbO7sficl7j8dP5YCUbQWwV
         +8LaNSNeDcaEmk4M9OVSaDw2yJS5CYTVUduym0ea75oDtvhBxOJIhPWTSqywERgFMFOu
         FxCOTBOjzeCJiAuf8qFiapWsSIsUZ8XBBxKyPN8dvtSVGMcssKNebd5H621t2wpSrRQ1
         RQTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0gLwa7TL8+Ri7GHLtgKluOhMesmdRPej1IJ5VwUJq5A=;
        b=LVJE3/teBLzveHcxdz8LFWH8XRq6hPL7LWiYg6VpN74J0TnkhjBYU3Oo1JP4RpRhRn
         uGciBldtjn3Ahmr/KGMOoEZxVtGZu/e2O4VWIKOUkRszA6fr3O8eaID83bbw6PMvoTaE
         jZtcOB3Qi+AbBpZSjq5RbicoVsZc6XAu2CzlPeztw0eFSG9iDg3U73NYlXgaIgpOOzqR
         ETxGXIa0xmlafA3auJ9Yv0TzOwJTnyXvNAhCUaXOK7JPesN5sTcMP2qZiGdqORC78MiQ
         hu4yJMVCT0nvQWNmySRjgv6yWFvgJWuwmutXVUcsNdelJxuSLFWI4G39RZ6U/NIBt2Yy
         ZGFA==
X-Gm-Message-State: AOAM532z5k3hprQ1/S104P73oPy2e2tVNMObfM/dwgCQePhXh7e4Tb48
        tqhErk3+kjwJ+16m3xW4hjk=
X-Google-Smtp-Source: ABdhPJxmr/SBwIy7LbCSgzbKDGI36jZnNigrO8lkETew8cgQSGLqcFFaAzugkum1lbItxZblc8LvdQ==
X-Received: by 2002:a05:6a00:234f:b0:3eb:3ffd:6da2 with SMTP id j15-20020a056a00234f00b003eb3ffd6da2mr408061pfj.15.1630516617140;
        Wed, 01 Sep 2021 10:16:57 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id 138sm82493pfz.187.2021.09.01.10.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 10:16:56 -0700 (PDT)
Message-ID: <9f9b4bb7-2fae-3ce5-b6ce-3372e8de1196@gmail.com>
Date:   Wed, 1 Sep 2021 10:16:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH net 1/2] net: dsa: b53: Fix calculating number of switch
 ports
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        stable@vger.kernel.org
References: <20210901092141.6451-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210901092141.6451-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2021 2:21 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> It isn't true that CPU port is always the last one. Switches BCM5301x
> have 9 ports (port 6 being inactive) and they use port 5 as CPU by
> default (depending on design some other may be CPU ports too).
> 
> A more reliable way of determining number of ports is to check for the
> last set bit in the "enabled_ports" bitfield.
> 
> This fixes b53 internal state, it will allow providing accurate info to
> the DSA and is required to fix BCM5301x support.
> 
> Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

For a bug fix, this looks appropriate to me, and for net-next, we need 
to remove the dev->num_ports and b53_for_each_port() entirely as there 
is no need to duplicate what DSA already maintains for us. Thanks!

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
