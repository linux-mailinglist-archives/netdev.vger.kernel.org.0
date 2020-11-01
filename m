Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FEF2A1F90
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 17:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgKAQkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 11:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgKAQkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 11:40:13 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61009C0617A6;
        Sun,  1 Nov 2020 08:40:13 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id t11so11638345edj.13;
        Sun, 01 Nov 2020 08:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5/7I/4sJjBsyQIB7ggeyfTDJYKRm63XHUDMoRFuDTi0=;
        b=e/MbS5+9XeYky4usRyFX9nS8KCD1oNnIG/+2/kIPK4pZNNM/ziOP6yLkPU2Oq1ub3u
         XLM2CZmQo/3CT81kOgkShh+JrzDlpH6htRaKyv1um+5fjiWZymgpusZYd0FTzpfsJkTz
         7JVb3aYZuzREVsbEgBxAthKf/VTNtgJoZMCGiv1azQ5oLfIO051tHk164TwaXJ1TJhzQ
         4uINsCRTbyT5wFnnyH838+NH/DGFpu5SEvVxFeKVSoeQybS41IumUlf1nXvoFTMUZfjJ
         U7nxEg656r3woRI/reL7kP5BtZXaOeXy/NMLLC7SWrj+4vni7Vznjnm3l+gCKH6/rDh+
         J3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5/7I/4sJjBsyQIB7ggeyfTDJYKRm63XHUDMoRFuDTi0=;
        b=RnSMZjtDMOfb+gJnBtbyShNROuOtLsW/MaojHIihqggnquUqxxW2Ea4DV7sstsLOI/
         ESL9atDTv1t10Cl7aE3jy/JuTZA9bP31zrm3XMrCnkHqViC642QBkQV4C1UaZHbT2F/b
         O6l+8R5Zbqqwghctea9mF7xXRZe4ZW3ZMy9sG16eQ4fqS5gHLTRWbqWdetngt/mXEvvz
         VTJL/YSQvUC+mF7UrIDNFjdRLtC6fjRMAF/29Di1YQJjJRXn1H9sGQx1BbCdrAKLzTFx
         wtAI8FLMht3HAAICBHIZ/Qg+VT+n/HyaWcZdsZxEnQryIJeF0K+b51k80V47vwC653IC
         9Rlg==
X-Gm-Message-State: AOAM531A2clFKJqbd/46Me891GFIpQqGOuZ/180IgRwuMi3g7I3J5fE1
        ZUrxwC4oCYqtHYkqZehhlPA=
X-Google-Smtp-Source: ABdhPJxNwu/8khahL8Fsdsk/Gneg7Dx4ewQwAL86z/h+94S/u0iwEwNqW8qlCK7MWFsRDiE6eYpTZw==
X-Received: by 2002:a50:d805:: with SMTP id o5mr12758372edj.142.1604248811757;
        Sun, 01 Nov 2020 08:40:11 -0800 (PST)
Received: from ?IPv6:2a01:110f:b59:fd00:c94a:5ae2:2301:3939? ([2a01:110f:b59:fd00:c94a:5ae2:2301:3939])
        by smtp.gmail.com with ESMTPSA id j6sm4508849edy.87.2020.11.01.08.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 08:40:11 -0800 (PST)
Subject: Re: [PATCH RFC leds + net-next 2/7] leds: trigger: netdev: simplify
 the driver by using bit field members
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Whitten <ben.whitten@gmail.com>
References: <20201030114435.20169-1-kabel@kernel.org>
 <20201030114435.20169-3-kabel@kernel.org>
 <64419e33-ffcd-4082-01bd-3370dae86b4b@gmail.com>
 <20201031004556.32c61a9d@kernel.org>
From:   Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <d5a60a5e-5254-b8cb-5bba-53011d657c90@gmail.com>
Date:   Sun, 1 Nov 2020 17:40:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201031004556.32c61a9d@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/20 12:45 AM, Marek Behún wrote:
> On Fri, 30 Oct 2020 23:37:52 +0100
> Jacek Anaszewski <jacek.anaszewski@gmail.com> wrote:
> 
>> Hi Marek,
>>
>> Bitops are guaranteed to be atomic and this was done for a reason.
> 
> Hmm okay...
> Sooo, netdev_trig_work cannot be executed at the same time as the
> link/linkup/rx/tx changing stuff from netdev_trig_notify,
> interval_store or netdev_led_attr_store, because all these functions
> ensure cancelation of netdev_trig_work by calling
> cancel_delayed_work_sync. Doesn't this somehow prevent the need for
> memory barriers provided by atomic bitops?

That's true. But unless there is proven decline in performance related
to use of bitops, I don't see any gain in removing those from this
trigger. They improve code readability.

> BTW Jacek what do you think about the other patches?

I like the idea, but I'd need to spend more time reviewing it.
One thing coming to mind at first glance - it would be good to get rid
of blink_set op at this occasion since this is just another case of
trigger offloading. It would however need touching many drivers, so
that could possibly be done as a follow-up.

-- 
Best regards,
Jacek Anaszewski
