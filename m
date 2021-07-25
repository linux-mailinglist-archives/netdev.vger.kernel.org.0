Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91B93D4FB1
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 21:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhGYTGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 15:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhGYTGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 15:06:32 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF429C061757;
        Sun, 25 Jul 2021 12:47:00 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id z6-20020a9d24860000b02904d14e47202cso7869147ota.4;
        Sun, 25 Jul 2021 12:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VeZWPhsf+UxEhhOjwlwIVeUOu2AI3fn4qRU/WSvFopQ=;
        b=qFSeiaLrU2hQGry4BAWsunWWxW3JeMucElv2gemNGYWBDARmoVcrZylwDmpjWqCp9f
         O/p7h80N2k7YsasIufiLCJFh77GVnZrlBm0eh59QRIy7rMOX0cK01UAm90OH7lnZKt/i
         ruDtwgFAV34OeRVK/f00TEOUJrkGcYlstPjhIMeAP1riDhaj/OuWtGNRNl/oKOXqPNO9
         29WyTDpMCHwEnumuXOGFgr4lvkUmXGVvoVhKu0isa+5Qy1XObzp77YRb+UvjRpsWHxPP
         T8iOITAcuE7zq3LTSC9Tz+Nfta71/L7XCXMYTdT9YwjH9pX3zq/RdZMDk3StpCU77jl+
         j42A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VeZWPhsf+UxEhhOjwlwIVeUOu2AI3fn4qRU/WSvFopQ=;
        b=kIM/dCcIfSfWPDMhiWsps/ceZbGWlC5tdheBY4mnyZUFQUAUP/akvJLOFfCpY0BEkM
         NN/KniY6EiLUoA67Me8if07WwqLPn3zckAqbOdkrAK2bFbRZ48tE5oppA4V6yAEP9yEb
         m+Wu3Eu9Wv5E4WOd4QjWwDRe5lmFWOwRBUm7x5xJl1qLw0Bs9/Dqfn3fJtMvXdrRNMr6
         29UavwLT6BTwN3Q8SZfOIt1hJS74ZnSqIHae9bISauoF2aN/7XgtpU4GiT4tM6nGWfhX
         wShRNPkfSdmdSoEG/XR6xlxxQ9wbg3FJg3yTePMDuhYG9qJqbO+FBcmcvl29J8H9VYLl
         TlOg==
X-Gm-Message-State: AOAM531177q1ziKQOc7XVsQef7BBMnkGZfLmSn+jxv9LkN1duS+8i9On
        bnymXAz+vqqNPkbY9+9EzbhH7gA1phE=
X-Google-Smtp-Source: ABdhPJwwWW+Vr+4VCWALaqrlSdJB5raI2ZBVlZZzHg3aEJ/ZWKJNilDcx8dKKs7pRnf9DilSWLBNug==
X-Received: by 2002:a9d:7982:: with SMTP id h2mr9036623otm.291.1627242419881;
        Sun, 25 Jul 2021 12:46:59 -0700 (PDT)
Received: from 2603-8090-2005-39b3-0000-0000-0000-100a.res6.spectrum.com (2603-8090-2005-39b3-0000-0000-0000-100a.res6.spectrum.com. [2603:8090:2005:39b3::100a])
        by smtp.gmail.com with ESMTPSA id s8sm5751923oie.43.2021.07.25.12.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jul 2021 12:46:59 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH] wireless: rtl8187: replace udev with usb_get_dev()
To:     htl10@users.sourceforge.net,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        Salah Triki <salah.triki@gmail.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210724183457.GA470005@pc>
 <53895498.1259278.1627160074135@mail.yahoo.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e761905b-0449-9463-c3ab-923aff36e4df@lwfinger.net>
Date:   Sun, 25 Jul 2021 14:46:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <53895498.1259278.1627160074135@mail.yahoo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/21 3:54 PM, Hin-Tak Leung wrote:
> 
> 
> On Saturday, 24 July 2021, 19:35:12 BST, Salah Triki <salah.triki@gmail.com> wrote:
> 
> 
>  > Replace udev with usb_get_dev() in order to make code cleaner.
> 
>  > Signed-off-by: Salah Triki <salah.triki@gmail.com>
>  > ---
>  > drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 4 +---
>  > 1 file changed, 1 insertion(+), 3 deletions(-)
> 
>  > diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c 
> b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
>  > index eb68b2d3caa1..30bb3c2b8407 100644
>  > --- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
>  > +++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
>  > @@ -1455,9 +1455,7 @@ static int rtl8187_probe(struct usb_interface *intf,
> 
>  >     SET_IEEE80211_DEV(dev, &intf->dev);
>  >     usb_set_intfdata(intf, dev);
>  > -    priv->udev = udev;
>  > -
>  > -    usb_get_dev(udev);
>  > +    priv->udev = usb_get_dev(udev);
> 
>  >     skb_queue_head_init(&priv->rx_queue);
> 
>  > --
>  > 2.25.1
> 
> It is not cleaner - the change is not functionally equivalent. Before the 
> change, the reference count is increased after the assignment; and after the 
> change, before the assignment. So my question is, does the reference count 
> increasing a little earlier matters? What can go wrong between very short time 
> where the reference count increases, and priv->udev not yet assigned? I think 
> there might be a race condition where the probbe function is called very shortly 
> twice.
> Especially if the time of running the reference count function is non-trivial.
> 
> Larry, what do you think?

My belief was that probe routines were called in order, which was confirmed by 
GregKH. As a result, there can be no race condition, and the order of setting 
the reference count does not matter. On the other hand, the current code is not 
misleading, nor unclear. Why should it be changed?

NACK on the patch.

Larry

