Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3493B46A0
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 17:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhFYPed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 11:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhFYPec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 11:34:32 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61200C061766
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 08:32:11 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n23so6537133wms.2
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 08:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mFzT6pv8CC87cHK04Jv1CeT+CD9fTxFZC5Ewe+N2u6w=;
        b=gQrCisuq9gjWqBNWWKG7GepHgNrfhn+FOh73iZdGcRt00yUL0Vj7uhpwoHP/HIHkdo
         UXwKN/jKsjkHUJywh1EueezAxT4Cr3bNrCi9ze6hBESIRM2ItMvO7p+0+321gp5lrMhp
         /xzjHHN84l6+emHuoOq2SlRMlOe6RcU1t0IQYlTDgo44yGGrt3huvmB7neSV7Bx4U5W7
         uEjgC7tyYxlFEARE7x9lY/++4JD848cYNZBiNNkuU/t7UJBZEr/RjE+T3hZhXER1+IcE
         eTlQFPTH7ItNXtDrGG0WjkVjCgyYCQEp/BD0yy/Att/uy5AF8forzFwoUBUXBOR/BzhP
         stQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mFzT6pv8CC87cHK04Jv1CeT+CD9fTxFZC5Ewe+N2u6w=;
        b=YXnUFsC3u5ZlJ+63m3iFK4x8YNCUU+E7wD1fo8YPNqDLOXt5xMeMPpWLlHoJLXcoy8
         bui3bALGxUM1bY57TeA3NzVfD9yDCWDpK6mNPEDIXsbqGt9ugXvXeiKQKd6Rlqz/yc/b
         tent5EeL53rpxcPagPaXGPKg/RF4/ADCfFvnNtuoBYy17f5dU93APa1BjQrZmtnNEfjQ
         +3WdUifEUVE+ZbdEK9muB8Eh/nGjLjgDirVG2tv8Rh1oI/OUXVZ1XufIcKO/stuy2BD9
         6VLDYmD7RwFbYO2FkXTphyo3/RyoXjUPdqi8LH94Ecta1vOuGMX4jKfJEOBmg7QGunZV
         W+4g==
X-Gm-Message-State: AOAM5319C5eMuQdqi499v+yg9wevOsdAaNTFcIas5BFXzG1GUZZ6kPPi
        AZnaj4RzgU0W45AK8oJmKE+iHw==
X-Google-Smtp-Source: ABdhPJz/6Upyz/UC5eot3d9nnDv9G36yvRoecBp+33QVzZIe9nLdoe2QUFh8lE3k63kot9hiyufr+g==
X-Received: by 2002:a05:600c:1d1a:: with SMTP id l26mr11249715wms.21.1624635129852;
        Fri, 25 Jun 2021 08:32:09 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:78f3:e334:978:3783? ([2a01:e0a:410:bb00:78f3:e334:978:3783])
        by smtp.gmail.com with ESMTPSA id p13sm4865079wrx.30.2021.06.25.08.32.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 08:32:09 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: Issues during assigning addresses on point to point interfaces
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Phil Sutter <phil@nwl.cc>
References: <20210606151008.7dwx5ukrlvxt4t3k@pali>
 <20210624124545.2b170258@dellmb>
 <d3995a21-d9fe-9393-a10e-8eddccec2f47@6wind.com>
 <20210625084031.c33yovvximtabmf4@pali>
 <d3dd210c-bf0f-7b48-6562-23e87c2ad55a@6wind.com>
 <20210625152737.6gslduccvguyrr77@pali>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <c4b854ef-6646-7ae8-b4a7-cb04b7b73222@6wind.com>
Date:   Fri, 25 Jun 2021 17:32:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625152737.6gslduccvguyrr77@pali>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 25/06/2021 à 17:27, Pali Rohár a écrit :
[snip]
>>> Hello Nicolas!
>>>
>>> See my original email where I put also rtnetlink packets (how strace see
>>> them). Seems that there is a bug in handling them (or bug in iproute2)
>>> as setting just peer (remote) IPv6 address is ignored:
>>> https://lore.kernel.org/netdev/20210606151008.7dwx5ukrlvxt4t3k@pali/
>>>
>>> Do you have any idea if this is affected by that "issue in the uAPI"?
>>> And what is the way how to fix it?
>> What about forcing IFA_LOCAL address to :: in your case?
> 
> It does not work. ip address returns error:
> 
>     $ sudo ip address add :: peer fe80::8 dev ppp0
>     RTNETLINK answers: Cannot assign requested address
So this trick could probably be used to handle your case, without breaking
anything, as it's not a valid command today.


Regards,
Nicolas
