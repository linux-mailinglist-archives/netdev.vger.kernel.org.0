Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2991B326259
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 13:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhBZMLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 07:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbhBZMLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 07:11:17 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B51C061574;
        Fri, 26 Feb 2021 04:10:36 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id w7so7244966wmb.5;
        Fri, 26 Feb 2021 04:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O8grGw91Md2y89hra9UyHWr6e2gg7S6aJOWyyIS8g3Q=;
        b=OtQ7UHJfBBiVUhEyqFppblMyT1dIYIbsf8ZPCPK66/0T0rx+cqwxXFWooYXeVBRKzq
         96E9e7/B5lujgYGhTYX+1syVeiIuIdMOciCEkpZnQIddjjGE7DStXnqi0yIs5IOSdvrR
         00lnbYlHWEbgCVdBVE45GIiXcjXBS7wcRIFtEOkslR1JglGG1SW13wJbH2h60bpz6A2O
         GcWwvfVu4WlpXBOTEMMt4qmdH26P3chY7IE24nDtFnxhbhgB+weGD7Rc23e3Hi1jJJVc
         wLAlW3q08rS6xDEmZCqMn5rP4jBTQ1HOoDivqYZwzpXae+PPFks/SiA5kr+o2LbzPDhC
         rpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O8grGw91Md2y89hra9UyHWr6e2gg7S6aJOWyyIS8g3Q=;
        b=BDC66o5yaVBr3lYbF12VHxApOvELhSIBqpgeHnvTcfE4ZbYyf2wq814bhC9WdPK0uN
         1X6JNHNn2oiRwzyzRT45x7jbm1O3ywSeo5LT5/ZBkq1mNIyB789AqYabMq+lkSw0sKRp
         pIZLNL+wXv/kk12zDkAJvbtXIlfxuUoGPQyaXO1Io7DphKTI6Vo/1h76RZT6/KpejNnW
         /egGly79gfvU4oq2+a+NcTW2/95P5sfhiJuswCkiaQ8egyvt34jEEkzHa1Oa6RaSop/6
         1vP5+CzrONvPy5qtDX5OS6B73i7JZO1zT3vM/Xr9HqdEMidgFXl/qSg5GsMoaM5DMPT/
         B7Kg==
X-Gm-Message-State: AOAM530zx3My1WC/qpp2m1Q4zmxZmmX7D5oIa31yFcpd5vC6Ykyqh6Sk
        A7yaN9xmb8+zZO7egUdwvgrx7eTUyOvDbg==
X-Google-Smtp-Source: ABdhPJxEgUewsPLnX1CqGAn5g/rmXTcK3TCeazb5KytZIK5nb4TH4LKJKDGW0KWn4FXYKBwpZ2HmAw==
X-Received: by 2002:a7b:c083:: with SMTP id r3mr2626403wmh.177.1614341435432;
        Fri, 26 Feb 2021 04:10:35 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:3483:8cf6:25ff:155b? (p200300ea8f395b0034838cf625ff155b.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:3483:8cf6:25ff:155b])
        by smtp.googlemail.com with ESMTPSA id x13sm18160074wmj.2.2021.02.26.04.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 04:10:35 -0800 (PST)
To:     Kalle Valo <kvalo@codeaurora.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     bhelgaas@google.com, Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
References: <20210225174041.405739-1-kai.heng.feng@canonical.com>
 <20210225174041.405739-3-kai.heng.feng@canonical.com>
 <87o8g7e20e.fsf@codeaurora.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 3/3] PCI: Convert rtw88 power cycle quirk to shutdown
 quirk
Message-ID: <0e8ba5a4-0029-6966-e4ab-265a538f3b3d@gmail.com>
Date:   Fri, 26 Feb 2021 13:10:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <87o8g7e20e.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.02.2021 08:12, Kalle Valo wrote:
> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
> 
>> Now we have a generic D3 shutdown quirk, so convert the original
>> approach to a PCI quirk.
>>
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
>>  drivers/net/wireless/realtek/rtw88/pci.c | 2 --
>>  drivers/pci/quirks.c                     | 6 ++++++
>>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> It would have been nice to CC linux-wireless also on patches 1-2. I only
> saw patch 3 and had to search the rest of patches from lkml.
> 
> I assume this goes via the PCI tree so:
> 
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> 

To me it looks odd to (mis-)use the quirk mechanism to set a device
to D3cold on shutdown. As I see it the quirk mechanism is used to work
around certain device misbehavior. And setting a device to a D3
state on shutdown is a normal activity, and the shutdown() callback
seems to be a good place for it.
I miss an explanation what the actual benefit of the change is.
