Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 788733AC87
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 02:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbfFJANF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 20:13:05 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:45055 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFJANF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 20:13:05 -0400
Received: by mail-oi1-f195.google.com with SMTP id e189so5030529oib.11;
        Sun, 09 Jun 2019 17:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZY2Fx0K0tPufKRHglI4CEFMtmYuRgEIluvYk2snoK+s=;
        b=JX4TcRdUV25LIJFzcwIAlzUOYawxxsU31Dyj/1SRZVJ40/u0n+o2x6HEegmuHLdv3d
         +4+TNsUIlh5Ic7V/2Iu7hFNmwtC/hEK5AfzBdvyXLJdzVrmyrrNrlOYcQHuw69ujK6AZ
         EFY59hD8CDlSeFJQBMsK7Uo2lhTwiDA4PnGbHjvtz+E9QkzjZFENWlTqhXwXT00Tppcz
         90lGQu7JRWfOvzOxZ/0bzMc0L0cfBY8no9CIq9U7uQ1kzl3CgeytxxD+oC2m7x+qe0eC
         HvZPdjtlDvMsTln9MxYYFW7bcX8Oij8c87i1QKAPZ2Jbe7T5iez4I/WQVM1gXPvA7GFj
         L1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZY2Fx0K0tPufKRHglI4CEFMtmYuRgEIluvYk2snoK+s=;
        b=W+BMDM2Sj3pLtqySuBfbQnga0vMNyAoejC77AsuqF4PrmCwHC1GscQAGkgzi2VL4EL
         dhZ/HxGbgxC60vo1OgGXw4ch/SUkREAiXAwdXgHwGpua04kMbzFT/v05R+jX/DnR6HKP
         FVJSlumRTblv1TSFoCFT4Rekz7AWcAY+1+X6CUEck3RpK60JAnQCQ1iZClBC6kDMgZGj
         axpQXTajv4JpCJlyVmLlHX926VGiHn9sCu5jsOM0pJSCwmM5nBQfLKVqrrU1KV1c8Qlu
         xLbv1KCBt008ad98AmR71x60mosGFhBiBYmib9qB+H5JyOOu4WVCLO1YSzbwVOgc31NP
         C5fQ==
X-Gm-Message-State: APjAAAWnMv/zJoCXVtw6qQTUp6DMZkjEh8ohRWxcZzzV3IIwYmHsHqGz
        +DBuRtC/MWY7m0vkbmM3LCWwtlbh
X-Google-Smtp-Source: APXvYqy8SMuSyjsNcoKNl/6HJW/MQE4JcdMYkD8tSiMr0mi8kzGqqtrwAik6qWrpSnwadLRw6lKgZA==
X-Received: by 2002:aca:f183:: with SMTP id p125mr10622543oih.13.1560125584546;
        Sun, 09 Jun 2019 17:13:04 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id x7sm666152oif.27.2019.06.09.17.13.03
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 17:13:03 -0700 (PDT)
Subject: Re: Should b44_init lead to WARN_ON in drivers/ssb/driver_gpio.c:464?
To:     =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>,
        H Buus <ubuntu@hbuus.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <946c86bf-7e90-a981-b9fc-757adb98adfa@hbuus.com>
 <20190609235711.481bbac9@wiggum>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <4fdd3b06-f3f7-87e0-93be-c5d6f2bf5ab4@lwfinger.net>
Date:   Sun, 9 Jun 2019 19:13:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190609235711.481bbac9@wiggum>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/19 4:57 PM, Michael Büsch wrote:
> On Sun, 9 Jun 2019 17:44:10 -0400
> H Buus <ubuntu@hbuus.com> wrote:
> 
>> I have an old 32 bit laptop with a BCM4401-B0 100Base-TX ethernet
>> controller. For every kernel from 4.19-rc1 going forward, I get a
>> warning and call trace within a few seconds of start up (see dmesg
>> snippet below). I have traced it to a specific commit (see commit
>> below). On the face of it, I would think it is a regression, but it
>> doesn't seem to cause a problem, since networking over ethernet is working.
> 
> 
> This warning is not a problem. The commit just exposes a warning, that
> has always been there.
> I suggest we just remove the WARN_ON from ssb_gpio_init and
> ssb_gpio_unregister.
> I don't see a reason to throw a warning in that case.

Michael,

I agree. Do you want to prepare the patch, or should I?

Larry

