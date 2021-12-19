Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED4547A23D
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 22:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236651AbhLSVPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 16:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbhLSVPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 16:15:15 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0A5C061574;
        Sun, 19 Dec 2021 13:15:15 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id cf39so17292585lfb.8;
        Sun, 19 Dec 2021 13:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=c10ecvo5UjN4Ro5cVBAvLjgD2mKtd5KBCV5gn7sfPMg=;
        b=V7oaEaFhbHKw2ap3bwOVtpaHENd0lblzM2LwSwiO1Is3FYnzkOQ+EQVwdn8LGj2NV1
         16qAshAIfM8UNU52uu//5CFNN/53b80TMOjtP/jOGDx+v8njQat3mXdXc9Sq5lA66FWR
         52uxTrCn6xWsGnTNrq3mqW15lpzcTLSk6P9iUWY+LKbsN2zIMGR6BKoO+idWD6JrpIL6
         ueDSndyCDCcTtoCSY2cltwuEEbIzIIriihrAGM/wRGSW0nHOjYevLkHB2NI+LQ9OtLgh
         yJTqVV+VkjhP8VbAli1M+SFnbzX0lF5cm4MxQNfR4dqlBnDp5fpeSC5xDSlkS5W+4vpq
         9bsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c10ecvo5UjN4Ro5cVBAvLjgD2mKtd5KBCV5gn7sfPMg=;
        b=8I2qBCL+FdSgkUzyGghT/caWq5lCgHzWVmqiys5YteOoMyQrQFU2O/Aa+wIb/i1LMF
         TLigI6M8Wo8az8yGeq8KjDyZdZMW8UtEdxWI+r6DKLH+cOle+S4wNTI76p0qL7oeX2Qz
         JkS2QZ/4J+0TJqx5W0pBJ+Cg2kOMMZDJd7izYdW3SossB1wneW1/N4UFKW5ExUq9FM0n
         zaXeVc8tnG8+rTFqSiv/XaLhUGqovnhudcNAMy91N9f0rD86F1uV+z33WNyN/Pkt2g4H
         iGNKHLRcOhc1jgsLsnPVn5sfYRijgw+uIM9DlaqrKdqYClVjLg+hf4tPkVy2sRYGm8Xz
         6OfA==
X-Gm-Message-State: AOAM531CBZqzXl6gxBBHwsAGBpXQT6vv2yWFtZpqYJVgvqtemBYUUiFd
        Ctnc5OoLcc35/i0ezBPHc9PckAy269t7UA==
X-Google-Smtp-Source: ABdhPJypV3QWjZq1BiXNvnrelfAivORV8DuiG8Cau4RSSMHoqU46kFp+rslESJbMTfk50vvxDEgZLA==
X-Received: by 2002:a05:6512:50b:: with SMTP id o11mr12590930lfb.230.1639948513631;
        Sun, 19 Dec 2021 13:15:13 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.239])
        by smtp.gmail.com with ESMTPSA id k14sm968969lfu.307.2021.12.19.13.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Dec 2021 13:15:13 -0800 (PST)
Message-ID: <e76e2f18-01ad-0938-6ec1-4eaa42b9b9a2@gmail.com>
Date:   Mon, 20 Dec 2021 00:15:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [syzbot] KMSAN: uninit-value in asix_mdio_read (2)
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        syzbot <syzbot+f44badb06036334e867a@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux@rempel-privat.de, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <13821c8b-c809-c820-04f0-2eadfdef0296@gmail.com>
 <000000000000e99dbc05d3755514@google.com> <Yb9pIs2nmm8oEViQ@lunn.ch>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <Yb9pIs2nmm8oEViQ@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19/21 20:17, Andrew Lunn wrote:
> On Sat, Dec 18, 2021 at 05:03:09PM -0800, syzbot wrote:
>> Hello,
>> 
>> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
>> 
>> Reported-and-tested-by: syzbot+f44badb06036334e867a@syzkaller.appspotmail.com
> 
> So it looks like you were right. But maybe ret < sizeof(smsr) would be
> better?
> 

I agree, this looks much cleaner.

Also, the bug you mentioned in previous email is also real, so I will 
prepare a patch series if you haven't fixed it by yourself :)



With regards,
Pavel Skripkin
