Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8812821AC
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 07:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbgJCFvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 01:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCFvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 01:51:18 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F571C0613D0;
        Fri,  2 Oct 2020 22:51:18 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f18so2920525pfa.10;
        Fri, 02 Oct 2020 22:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=U+/EF2NGSw6neafVxjjcMYfRuR3DJX5CJ+tBNvZuiek=;
        b=eDbrYQ1/6M4Lf6dtXjKmLkb9Mpk8YOQkWgLQJl7Oybb05dEBctkf1oZygTp3ea4U8f
         b3yZcFTPBznd6uF9FFO/lpuyPcWr2iurLrwLPyBknKv8/VyV2/sbbpO6bP90/BInq29w
         VQljsPxkIwjV9HjOZMB2tV+Xz6bWfJ0eafxtyOQm97yO09RiL3AIfjft1VcCc+NU+XSH
         WESdAhGBYBMYW2F3voe9glrz/Jsquhvm5ZFpUJUK2ppJGPNnItFyRCV8o8AObWEw7kdq
         bzBk18xgA7yASU/6crkWS18fPEYV4QFgB10WUxn1uxLu0qGV3DuRE2dCby+taRQe7wD0
         E+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=U+/EF2NGSw6neafVxjjcMYfRuR3DJX5CJ+tBNvZuiek=;
        b=XwiwD//6QkObxTCXlnyeqmVob0VAg8FirmlMB09W4VSHHBx4y3V/o+slpsbD8jdX3p
         13i+gk+reqJl7KqHITgs3AFVC3iKyCrdIXvyQXyf+r2lmX2B0Gyd2VFvTCqZtsfTAG9Z
         1NHWZI1yreifSVl8Yxf9855YytbJ/IUonPBgiInLpkoIrZ3GPEgFXP095kFW0Y2skeH8
         S8nlP1IxLYCDNyCBBj8NO3Qs4Wy+GC4prVRNnJjNzQBntdQVsIWwWTBA+fouGj0HaUCD
         1y6otM5tKxmYMGq77c3DiTAebqrje+B8bA5acJ/GPe/YaffvtcCJITKyKANkZaSIVQBW
         UJjA==
X-Gm-Message-State: AOAM532sHjlCda8kdWJGHM9pc/Pot1GXkGZvtFxELLhEdG8nQn2RjgbQ
        f45+R4LHvyza90aCfy03ttMpDajjIsKbA1Ref0M=
X-Google-Smtp-Source: ABdhPJziRclfzdzIVFLhkgcO4yRti4HLZ85RSEV/uXYO2t1/x37D1oe8GpDX/yrv1LkEUj6D6VYeNQ==
X-Received: by 2002:a63:f807:: with SMTP id n7mr5433763pgh.311.1601704277432;
        Fri, 02 Oct 2020 22:51:17 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.217.69])
        by smtp.gmail.com with ESMTPSA id d17sm4215270pfq.157.2020.10.02.22.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 22:51:16 -0700 (PDT)
Subject: Re: [PATCH v2] net: usb: rtl8150: prevent set_ethernet_addr from
 setting uninit address
To:     Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201001073221.239618-1-anant.thazhemadam@gmail.com>
 <20201001.191522.1749084221364678705.davem@davemloft.net>
 <83804e93-8f59-4d35-ec61-e9b5e6f00323@gmail.com>
 <20201002115453.GA3338729@kroah.com>
 <a19aa514-14a9-8c92-d41a-0b9e17daa8e3@gmail.com>
 <20201002142901.GA3901@carbon>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <dbd92308-2443-0c1d-92f1-f506339e0a5e@gmail.com>
Date:   Sat, 3 Oct 2020 11:21:12 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201002142901.GA3901@carbon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 02-10-2020 19:59, Petko Manolov wrote:
> On 20-10-02 17:35:25, Anant Thazhemadam wrote:
>> Yes, this clears things up for me. I'll see to it that this gets done in a v3.
> If set_ethernet_addr() fail, don't return error, but use eth_hw_addr_random() 
> instead to set random MAC address and continue with the probing.
>
> You can take a look here:
> https://lore.kernel.org/netdev/20201002075604.44335-1-petko.manolov@konsulko.com/
>
>
> cheers,
> Petko
Thank you for this reference. :)

Thanks,
Anant
