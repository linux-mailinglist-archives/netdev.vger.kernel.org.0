Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5549F4C0
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 23:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbfH0VJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 17:09:41 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:34897 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfH0VJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 17:09:41 -0400
Received: by mail-wm1-f46.google.com with SMTP id l2so546759wmg.0;
        Tue, 27 Aug 2019 14:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+B2wB2GTqpND8w0IW6Qck36+/TjuYm3B66Fsdg7FXWo=;
        b=UITFoLLXJUA6vbdatFUMetI8NTy87NA2+0/5G9hOmz8Mfd0/L824VuipjDPpRiprmM
         aeuUAq8r1qdUAd6czv/XHW8gUD39BHff52XiDHibvvFVjJLoXqEogWXvhq/vBqX3lSAD
         u09x/NFELfpsAqM8btPi9+tYR65NXsZpehvtbzCMqNGYc8CZQfRiM/Dz9PovwPGDAKUR
         dUZ2EVQbfgDsiZ6Q6jN7HXugyk2AIrSn+CMiviwPpvvnLiC6Wt6k7AYwHzFAq8jWxevg
         K9QconDBgV5vBwApb5jBwgmFvWCNo9wsG/hVcbrWG+UYyYA6VFP5apsp1+hKpmxv2OYJ
         oUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+B2wB2GTqpND8w0IW6Qck36+/TjuYm3B66Fsdg7FXWo=;
        b=YEIG1RE1oSFxTgMIZVvQNbEZvXUhNeG1ZIaaeuLpY+NiKAsZ0kGCAEZMfaN5QtyIfI
         9O/QWdkDZwTepn9tNEuPjxn+fHnfX0QA0J+sXxbEOXMSk+GcRWsM6+P68k/JRwJ/yIRq
         yR1R2pybRfi9T5YMA9fcj7xABKm/EpubQWVjJqAi5BvJxxhb8nQksRBZMsNYIBGjb61k
         9PN7XurHLW1Svde/kzxdhRvBKg0zH0NethTa7OVMI1VkuOKS3Hr/qRbSnnvhPG+fBfOH
         5v5Kr08IvftG74txkcCaT/RoDUTt7l5DicgQdAaZlhYF4No4yyhqNH2KiLCx2JY4CMVr
         MAHQ==
X-Gm-Message-State: APjAAAWO2LG0n0wcoOb+p/9FLYZv+lSARTi/oRgR0XhQP7la+gbZBlg3
        gAKkx0Dv5bNG5Xhf0OZ1kndoonX8
X-Google-Smtp-Source: APXvYqwOoTEvnBxrtV3Ggx0IgwKDLyXObcAl9kk1qfVAxKYBwW3uh65HUt+lRp3vuWWKOcgt0u+b4g==
X-Received: by 2002:a1c:c706:: with SMTP id x6mr579525wmf.104.1566940179017;
        Tue, 27 Aug 2019 14:09:39 -0700 (PDT)
Received: from [192.168.8.147] (212.160.185.81.rev.sfr.net. [81.185.160.212])
        by smtp.gmail.com with ESMTPSA id a6sm254165wmj.15.2019.08.27.14.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2019 14:09:38 -0700 (PDT)
Subject: Re: Unable to create htb tc classes more than 64K
To:     Dave Taht <dave.taht@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Akshat Kakkar <akshat.1984@gmail.com>,
        Anton Danilov <littlesmilingcloud@gmail.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
 <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
 <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com>
 <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com>
 <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com>
 <CAM_iQpXBhrOXtfJkibyxyq781Pjck-XJNgZ-=Ucj7=DeG865mw@mail.gmail.com>
 <CAA5aLPjO9rucCLJnmQiPBxw2pJ=6okf3C88rH9GWnh3p0R+Rmw@mail.gmail.com>
 <CAM_iQpVtGUH6CAAegRtTgyemLtHsO+RFP8f6LH2WtiYu9-srfw@mail.gmail.com>
 <9cbefe10-b172-ae2a-0ac7-d972468eb7a2@gmail.com>
 <CAA93jw6TWUmqsvBDT4tFPgwjGxAmm_S5bUibj16nwp1F=AwyRA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <48a3284b-e8ba-f169-6a2d-9611f8538f07@gmail.com>
Date:   Tue, 27 Aug 2019 23:09:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAA93jw6TWUmqsvBDT4tFPgwjGxAmm_S5bUibj16nwp1F=AwyRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/19 10:53 PM, Dave Taht wrote:
> 
> Although this is very cool, I think in this case the OP is being
> a router, not server?

This mechanism is generic. EDT has not been designed for servers only.

One HTB class (with one associated qdisc per leaf) per rate limiter
does not scale, and consumes a _lot_ more memory.

We have abandoned HTB at Google for these reasons.

Nice thing with EDT is that you can stack arbitrary number of rate limiters,
and still keep a single queue (in FQ or another layer downstream)

