Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3925340ECE2
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 23:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239699AbhIPVsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 17:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbhIPVsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 17:48:05 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB672C061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 14:46:44 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id j6so7227413pfa.4
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 14:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KwmQaaY2xyRkmDA83EoBJb9N7/sEkBvqoNxQ3QK3dRA=;
        b=St2H/u8aa2xWuIptYLzuEuXwKVxfrSO6pzCp49SIhDtFyOW59V4MfJcm8bBZ9z8iiL
         HzJqsRThB3aXkXf4lVjr7wWlUIdfUnlDGnsifHPKP8umuMYwFLxUQbFm0iXmT1axGgGd
         d6PlNGiYO7P8+iAwsJs5esblHP+MCq2pSVI4w32+h40neeqZMa96GLrAeX8nGBr1xUR3
         dwhovFw6t35dBZVG2QBItumjCNB/ENOT/NGrXKnW1sf6sJTb2lTmgHlB0TTRDnK6CZpi
         tl70zCuA2DkoUJEzBBF4vkMPj2HEw5IpXp+v1uakYOOVudu/URC4jXk/Rde5SgQxCwic
         D4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KwmQaaY2xyRkmDA83EoBJb9N7/sEkBvqoNxQ3QK3dRA=;
        b=RHTF1vEPrWUIspEXPyNNEIBG9d+o/4hKznaIkXKI6Ur1k8bk1R06HUK1UerypWkOZM
         PiJDFr8/Ya6CKW100H+CNlm/qdLIgrYuy52unVHZdjZUaz2EZWqjTDQtf3TrNv41QBnL
         T/i7Dvm+fpQYo9Vtjo+yTfUT/VZG/JAGTUiPtcUpIsQVgytNRVsL+yvBDSMsVciXAwvq
         ybeIJ5FzCzZo9fmZ57JjsMXbyW3C+5tKzUjgTHVF1hE0tUFvctA1OPBfGO+fwyXJ3AYn
         rzftKZ7ZQ/jsLGcYq+VgQURSHAiy9fP6c97iyu2rNULj9yLMESBICRs14LjxcppWzmum
         kERQ==
X-Gm-Message-State: AOAM530S5lhUh7041VU+DPIbgkB11UBiR6MK7ivGVKqa7VB6q34VbNiF
        SSpxYQtxCghK0eo0Y/ZApbs=
X-Google-Smtp-Source: ABdhPJy77b3lDuMT4kiYvV9TdlUJ43ODrSJGMyvVTrGJaCBRbNHFiJqk7P0dCOZCOvHCdr6dVMh1QA==
X-Received: by 2002:a63:1259:: with SMTP id 25mr6913768pgs.48.1631828804387;
        Thu, 16 Sep 2021 14:46:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l9sm8757777pjz.55.2021.09.16.14.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 14:46:42 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] net: dsa: b53: Clean up CPU/IMP ports
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210916120354.20338-1-zajec5@gmail.com>
 <7c5e1cf8-2d98-91df-fc6b-f9edfa0f23c9@gmail.com>
Message-ID: <a8a684ce-bede-b1f1-1f7a-31e71dca3fd3@gmail.com>
Date:   Thu, 16 Sep 2021 14:46:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <7c5e1cf8-2d98-91df-fc6b-f9edfa0f23c9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/21 9:23 AM, Florian Fainelli wrote:
> On 9/16/21 5:03 AM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> This has been tested on:
>>
>> 1. Luxul XBR-4500 with used CPU port 5
>> [    8.361438] b53-srab-switch 18007000.ethernet-switch: found switch: BCM53012, rev 0
>>
>> 2. Netgear R8000 with used CPU port 8
>> [    4.453858] b53-srab-switch 18007000.ethernet-switch: found switch: BCM53012, rev 5  
> 
> These look good at first glance, let me give them a try on 7445 and 7278
> at least before responding with Reviewed-by/Tested-by tags, thanks!
> 
Found some issues on 7445 and 7278 while moving to the latest net-next
which I will be addressing but this worked nicely.

What do you think about removing dev->enabled_ports and
b53_for_each_port entirely and using a DSA helper that iterates over the
switch's port list? Now that we have dev->num_ports accurately reflect
the number of ports it should be equivalent.
-- 
Florian
