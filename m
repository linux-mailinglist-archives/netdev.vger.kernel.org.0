Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B07AEBF254
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 14:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfIZMAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 08:00:44 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36317 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfIZMAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 08:00:43 -0400
Received: by mail-lf1-f68.google.com with SMTP id x80so1495880lff.3;
        Thu, 26 Sep 2019 05:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7XWikGZouALuaXU8QmpV5uGjR79Qy2+P6Xqtc8grImI=;
        b=sFUC245uUPv8Jm5DxG0weHF5VxJhXxBTLmRx3nXHvoxzSuhNd29acmLw6qDZAyxufI
         SSKZ8dbk/lqXeqsCsUY4LUnUV77oL7v/d0VSQr8atsQ2ikUOq0O+NnnMdSNzirB0eaip
         5xgv/+2DjGZF9XxDIVQd8GOsn7/Ic/G4PQ6uSmqAW7HFXFOP1/dX3H3tqTFy+x7OVvHq
         8KlDu/O+pKmVIYh1K15y5Ifbi83Y1l/vT+UiwKUMMZ8j12sOJj+H4d7z576rUZbuPW5l
         YQzZvoXuxxus7Mh7/mVq7uKBeQtW3eeMOR/NL2PxViqOSHkR9SgWwrBO/1WVoIR7FuEk
         Bg+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7XWikGZouALuaXU8QmpV5uGjR79Qy2+P6Xqtc8grImI=;
        b=MddKTboGiGNU1cYx4YqBF2JLexif9XvTzUG+oWNVkvqfyaqzM7paV7iNVdWcxz+Pxu
         ooHGnSqReZwMJKsh0Rl5Y6L5jcCse8XRMOe/JiE69nI6tfmJsqFeS7D/FCR5B9li5slX
         YZP3CrWnON4RMLLj47Rf1ioTKTWSkGJ5s9OTguUPsoiAp9IKYBC6rFCUdJkvvu+Lu+mc
         wxqeOt3zsF/hDpKyC1y/MR28CPZ280kfAZ/F+LuLf5DnOOxGW4cUHoXPbg/H79uPvvnv
         vpPLRpypWQI0uk2uDfnbByg7pktO+sOh4p3zQyFxNInPGi7Ue+70YaH8OUrnlY7+RIy5
         adlg==
X-Gm-Message-State: APjAAAU5X9MKxUgE3qt9DHzyRTFOlQJsG7KqubrJn+Ddq7tTq/QsFnsh
        eqgparPEj66CoFQB1tIHKjk=
X-Google-Smtp-Source: APXvYqydhbk75lEKQ+0ee3AlhEdA+ZAXZR7K2+v7lAdPiWV4nE2zXFJ8N+zIgKY7bBCLDWVGIZybdg==
X-Received: by 2002:a19:2c1:: with SMTP id 184mr1989422lfc.100.1569499241445;
        Thu, 26 Sep 2019 05:00:41 -0700 (PDT)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id f5sm486379lfh.52.2019.09.26.05.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 05:00:40 -0700 (PDT)
Subject: Re: [PATCH RFC] cfg80211: add new command for reporting wiphy crashes
To:     Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hostap@lists.infradead.org,
        openwrt-devel@lists.openwrt.org
References: <20190920133708.15313-1-zajec5@gmail.com>
 <20190920140143.GA30514@w1.fi>
 <4f6f37e5-802c-4504-3dcb-c4a640d138bd@milecki.pl>
 <9ece533700be8237699881312a99cc91c6a71d36.camel@sipsolutions.net>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <09503390-91f0-3789-496a-6e9891156c5e@gmail.com>
Date:   Thu, 26 Sep 2019 14:00:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
In-Reply-To: <9ece533700be8237699881312a99cc91c6a71d36.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.09.2019 13:55, Johannes Berg wrote:
> On Thu, 2019-09-26 at 13:52 +0200, Rafał Miłecki wrote:
>>
>> Indeed my main concert is AP mode. I'm afraid that cfg80211 doesn't
>> cache all settings, consider e.g. nl80211_start_ap(). It builds
>> struct cfg80211_ap_settings using info from nl80211 message and
>> passes it to the driver (rdev_start_ap()). Once it's done it
>> caches only a small subset of all setup data.
>>
>> In other words driver doesn't have enough info to recover interfaces
>> setup.
> 
> So the driver can cache it, just like mac80211.
> 
> You can't seriously be suggesting that the driver doesn't *have* enough
> information - everything passed through it :)

Precisely: it doesn't store (cache) enough info.


>> I meant that hardware has been recovered & is operational again (driver
>> can talk to it). I expected user space to reconfigure all interfaces
>> using the same settings that were used on previous run.
>>
>> If driver were able to recover interfaces setup on its own (with a help
>> of cfg80211) then user space wouldn't need to be involved.
> 
> The driver can do it, mac80211 does. It's just a matter of what the
> driver will do or not.
> 
>> First of all I was wondering how to handle interfaces creation. After a
>> firmware crash we have:
>> 1) Interfaces created in Linux
>> 2) No corresponsing interfaces in firmware
> 
>> Syncing that (re-creating in-firmware firmwares) may be a bit tricky
>> depending on a driver and hardware.
> 
> We do that in mac80211, it works fine. Why would it be tricky?

In brcmfmac on .add_virtual_intf() we:
1) Send request to the FullMAC firmware
2) Wait for a reply
3) On success we create interface
4) We wake up .add_virtual_intf() handler

I'll need to find a way to skip step 3 in recovery path since interface
on host side already exists.


> If something fails, I think we force that interface to go down.
> 
>> For some cases it could be easier to
>> delete all interfaces and ask user space to setup wiphy (create required
>> interfaces) again. I'm not sure if that's acceptable though?
>>
>> If we agree interfaces should stay and driver simply should configure
>> firmware properly, then we need all data as explained earlier. struct
>> cfg80211_ap_settings is not available during runtime. How should we
>> handle that problem?
> 
> You can cache it in the driver in whatever format makes sense.
> 
>> I was aiming for a brutal force solution: just make user space
>> interfaces need a full setup just at they were just created.
> 
> You can still do that btw, just unregister and re-register the wiphy.

OK, so basically I need to work on caching setup data. Should I try
doing that at my selected driver level (brcmfmac)? Or should I focus on
generic solution (cfg80211) and consider offloading mac80211 if
possible?
