Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB741F6B8D
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 22:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKJVKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 16:10:51 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34545 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbfKJVKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 16:10:50 -0500
Received: by mail-pg1-f193.google.com with SMTP id z188so2103196pgb.1
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 13:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uO9zmV9a2x6iKxFuEwh3fTFyRX731Ma1YCTw6lzpfWw=;
        b=W5ws8lnbtSrsmuwCCsiepkAnIXAkxti/Bcl1lvcYbUvLq8FAFf007u0QZQ3mGM3Ct6
         iN0J2rRzgowARRuiuFDw7s53E2PPAqpuxkAxmKA0JCaSt0lH5gILJcTyqJUAS+pwS4g5
         0Eap82DCAVms4lCVIxzDNeBca8tID/NK8pEwFNXm6MQTbfExcFOWLEbDbi6BIWR4hlej
         VpdjUYBJKLo0Bm4PFI2Fgmz6VqaefAfnEONqCl7jQpXQWI3nrkJ4BfxZbLieL0M3K7xb
         W/a/qEWUioNz1WC37V4wjxsZinX+OCKPRA5zZ58Js7Tb7TopFwWJ7qF48EeNgX3f3vjz
         ZBcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uO9zmV9a2x6iKxFuEwh3fTFyRX731Ma1YCTw6lzpfWw=;
        b=VK4MKzQH1o2hr2Oaj6TdD0ttT9vbhAciI4H4rSBy70fqfVR4/xNOxs7mPqwDm66HWD
         LrLd+GMqffHPALO6uZX/yAPdpaWeM5DpZI3DHfj8xcXeBecx/cZCXiSEmHjNRU6y4gBm
         YidpRq1sPZRCHgP0P2LUaNpb2+n1bWjih6ItoQnfCThxSc0X5O6B+ZtsC3dX3QxOCgvx
         kd1jmK9H/s+jCvBkqJXDSahtAOJJI5TgEdM/KYaYXwC9hEXk0QRrcO9f5b4x8J9g6AJ7
         S2huQbKNjEEoQhHRca7u+hfJb4kk7dIXhBnlRMnhvmIIs4oH5guI90phn+ZcR0tfT/hH
         NQUw==
X-Gm-Message-State: APjAAAVqiaoFoTZxN0o2Ja16ETfwunddD5IXIf3qaJs+9hoPFYHHQpTc
        +99jGSfS2/XBF6rPJ0/oQGg=
X-Google-Smtp-Source: APXvYqwIj/ZfLnC37FiBgWYyMsU4SVx6LwZyKpCh+b7EG6SXhjYl5I/7qmn8wYtdNjZxv/WRxNQFug==
X-Received: by 2002:a63:7887:: with SMTP id t129mr25071872pgc.144.1573420249978;
        Sun, 10 Nov 2019 13:10:49 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id z10sm4616119pgg.39.2019.11.10.13.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Nov 2019 13:10:49 -0800 (PST)
Subject: Re: [PATCH V3 net-next 1/7] net: bcmgenet: Avoid touching
 non-existent interrupt
To:     Stefan Wahren <wahrenst@gmx.net>,
        Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org
References: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
 <1573326009-2275-2-git-send-email-wahrenst@gmx.net>
 <fa75d3ae-147b-8537-9cc5-522a7dc5a5d2@gmail.com>
 <3aaf1b3d-7425-5073-f5cf-5ae672f4b008@gmx.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <56e0a8ba-e6ed-9a43-5cba-a2119e0fda84@gmail.com>
Date:   Sun, 10 Nov 2019 13:10:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3aaf1b3d-7425-5073-f5cf-5ae672f4b008@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/2019 12:57 PM, Stefan Wahren wrote:
> Hi Florian,
> 
> Am 10.11.19 um 21:23 schrieb Florian Fainelli:
>>
>> On 11/9/2019 11:00 AM, Stefan Wahren wrote:
>>> As platform_get_irq() now prints an error when the interrupt does not
>>> exist, we are getting a confusing error message in case the optional
>>> WOL IRQ is not defined:
>>>
>>>   bcmgenet fd58000.ethernet: IRQ index 2 not found
>>>
>>> Fix this by using the platform_get_irq_optional().
>>>
>>> Fixes: 7723f4c5ecdb8d83 ("driver core: platform: Add an error message to platform_get_irq*()")
>>> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
>> I still don't think this warrant a Fixes tag, as this is not a bug
>> per-se, just a minor annoyance:
> 
> this confuses me. In V2 you said this about patch "net: bcmgenet: Fix
> error handling on IRQ retrieval".
> 
> Is it possible you commented the wrong patch last time?

In v2, on patch 1, I wrote this:

Not sure if the Fixes tag is necessary here, this is kind of an
exceptional case anyway since you should be specifying valid interrupt
resources to begin with.

and on v2, on patch 2, I just suggested using
platform_get_irq_optional() but did not comment on your choice of Fixes:
tag, but now I just did, and for the same reasons as patch #1, I think
this is not necessary.
-- 
Florian
