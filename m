Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E5E5CFB0
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfGBMmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:42:23 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39275 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfGBMmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 08:42:23 -0400
Received: by mail-qt1-f195.google.com with SMTP id i34so18207334qta.6;
        Tue, 02 Jul 2019 05:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x3LZzViuZUg2mLa3zMKZEbZrrDd07dQcCRhiLsF8NxA=;
        b=XLCts/r1KWC2c0MMDqqiVkBXRczb0ax5ii4Ofa5fcOJUAVmBaOIicYl0ydbNCBWd8D
         uVaqoLbc0TyQYUulFQ5Q0cczUbI7gFe9xWjmHsyVNtVlKo78LG9dmKjSlCyGFr1K6Hj4
         ncHV7hKEreDOU71+bIBNOVPfoFULBuB2m0BpNzABgwDCtx/uLn7R/LFvhYlpGJyad5ZY
         TOxtXx95znxnyon76eE+9VcC7PedLh/DEMsw/S7vlUgyb6oLudjzZ0ew7Im4XxuBjoEI
         PIJspWj2UCjqibTEqEvkH1w5PE+0kuUQ41DxPcd/ofGYe5CN7gVAFriYO6njf/yPYGIJ
         gh+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x3LZzViuZUg2mLa3zMKZEbZrrDd07dQcCRhiLsF8NxA=;
        b=q6P42B5sn36F0S9KuJwl/hTxSGtwCYhWgVQVuvUBypiaTG5/JzBW1+DNwEIOEmonsq
         QqZSZSCFyGxKjps4bv0EpCxBBwoTIRYQ0MwEMQPYoUxCdaATairA9sbc0d0kKwy4Dm52
         6OfRWgXp51DcAnC1Fh4LwcjgFsomwvGYPCrYBQhm8n+Q+xfAR01UtfOsVRjGMsVkU3gV
         Xp/Og6js0bnm14PLF7aAFB9dDEKHwXmlnOxC3qyzjxgsFmrAYOiNtbSW6yHfCaB44bJI
         sZumZCuznb3/bur45GLnvojwMqcnZ9Dksh2bWooDXD/kUsH67xy0MAKZLDky0iXqb93O
         1Z/g==
X-Gm-Message-State: APjAAAW4sOp7hDnKKyFgIVx+rN3KWz8VouK2iPJf69XyAZUqHonjrpsy
        xWjpEm5uJmWNKI0UFJ6pZxRCFSaGqbk=
X-Google-Smtp-Source: APXvYqyARj26X1pWg9x2+9g2DkJCFon7eMR5fozQVgXUFxCkQWxXGzAD2MJb2DNMuKClOvqPbKGMsQ==
X-Received: by 2002:ac8:768b:: with SMTP id g11mr26011093qtr.182.1562071342327;
        Tue, 02 Jul 2019 05:42:22 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11c1::1019? ([2620:10d:c091:480::c41e])
        by smtp.gmail.com with ESMTPSA id l63sm6070734qkb.124.2019.07.02.05.42.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 05:42:21 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Daniel Drake <drake@endlessm.com>, Chris Chiu <chiu@endlessm.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <20190627095247.8792-1-chiu@endlessm.com>
 <CAD8Lp44R0a1=fVi=fGv69w1ppdcaFV01opkdkhaX-eJ=K=tYeA@mail.gmail.com>
Message-ID: <4c99866e-55b7-8852-c078-6b31dce21ee4@gmail.com>
Date:   Tue, 2 Jul 2019 08:42:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAD8Lp44R0a1=fVi=fGv69w1ppdcaFV01opkdkhaX-eJ=K=tYeA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 4:27 AM, Daniel Drake wrote:
> Hi Chris,
> 
> On Thu, Jun 27, 2019 at 5:53 PM Chris Chiu <chiu@endlessm.com> wrote:
>> The WiFi tx power of RTL8723BU is extremely low after booting. So
>> the WiFi scan gives very limited AP list and it always fails to
>> connect to the selected AP. This module only supports 1x1 antenna
>> and the antenna is switched to bluetooth due to some incorrect
>> register settings.
>>
>> This commit hand over the antenna control to PTA, the wifi signal
>> will be back to normal and the bluetooth scan can also work at the
>> same time. However, the btcoexist still needs to be handled under
>> different circumstances. If there's a BT connection established,
>> the wifi still fails to connect until disconneting the BT.
>>
>> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> 
> Really nice work finding this!
> 
> I know that after this change, you plan to bring over the btcoexist
> code from the vendor driver (or at least the minimum required code)
> for a more complete fix, but I'm curious how you found these magic
> register values and how they compare to the values used by the vendor
> driver with btcoexist?

We definitely don't want to bring over the vendor code, since it's a
pile of spaghetti, but we probably need to get something sorted. This
went down the drain when the bluetooth driver was added without taking
it into account - long after this driver was merged.

Cheers,
Jes

