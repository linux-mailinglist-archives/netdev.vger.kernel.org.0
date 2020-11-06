Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89FE2A9AA2
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgKFRRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 12:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbgKFRRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 12:17:21 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B98C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 09:17:21 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 13so1924658pfy.4
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 09:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=kHXd+f6wsACiiEFKkCc7f8tpTMwMlQ140PnYPzDuSsQ=;
        b=J5BHiJJtZ/39aOxYr2bZpsdtvPnsKoJN4knF1+T1EzehA/gbqrDypzQSawr1f4FfjL
         snkk9hLxJtKvxDWO7UE3w+yqOe9k8PJu1r46Aqz0mLsKcU7OIGG2g3krn8tAohQ+zVQU
         +WdjU6O70DdrFm8gePQh25u6EGXyI88iXFXjE/eLemoveupZ1Bhtmcwcs7evUeWkBjWF
         DfHuudl/ZN5sR0QZzW1UwZCMdPbXsGamEUZzBGLUdwo0gDi1FcCV1fSuxfH0X13DCGQO
         pP0VK3Er3mn8qblCA/I+7KNxnfWEKUcRSHUxIhPrcANfWTT7yZmy67auilFkDiVZKbRE
         0rxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=kHXd+f6wsACiiEFKkCc7f8tpTMwMlQ140PnYPzDuSsQ=;
        b=O+kprHp83MARMKtiW+RGf6MkarsvqKUQalyh8bPL8+p8VfZUjt3ew/rgwoG3lKI6L0
         VMdX9UPzYjxP1//sk+Ye5gFIp3vTXoWCLKVJYBGoE9jgGPzj3O44tlc30xC9K0QhW1L2
         YkAFUWR+cVR7aTEiLXCG2AZFomLIhCY11vjnlqHirYcUMNi9+8oBQjBs8MphbburxXpJ
         xuTULkyZBDUFQEx+XOtD0pDzaVmf5jkTq1Ezwff/hYuHdzrExEb1/1jHcTwQo5HMSoa+
         LencQSv6aVYD7+3Wojq8+GWca54H5zffapGOit5XIsbM85wEsLWYiIFnN2I43F+6Yc81
         pZ8w==
X-Gm-Message-State: AOAM533H7nnWuD2K1n4Lhun7QG34wYhdDHPJZ52hzmrGcNwmgyvX8PN6
        msxvEwmFo/Mh58dm6MR1AOM9c2zZiRUtdQ==
X-Google-Smtp-Source: ABdhPJwv6I9cSMPu0ecApmGZLfFmsBBrTQu1eU5BUdSrbzDixTXAYfCJwrLeJeEW7O1Kg3DBbP3fqw==
X-Received: by 2002:a17:90a:7522:: with SMTP id q31mr597499pjk.158.1604683041250;
        Fri, 06 Nov 2020 09:17:21 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id m11sm2412973pgs.56.2020.11.06.09.17.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 09:17:20 -0800 (PST)
Subject: Re: [PATCH v2 net-next 6/8] ionic: flatten calls to ionic_lif_rx_mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20201106001220.68130-1-snelson@pensando.io>
 <20201106001220.68130-7-snelson@pensando.io>
 <20201106090341.02ac148c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <ab750bf3-2e7f-d64a-f2c4-863feacfec04@pensando.io>
Date:   Fri, 6 Nov 2020 09:17:52 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201106090341.02ac148c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/6/20 9:03 AM, Jakub Kicinski wrote:
> On Thu,  5 Nov 2020 16:12:18 -0800 Shannon Nelson wrote:
>> +			work = kzalloc(sizeof(*work), GFP_ATOMIC);
>> +			if (!work) {
>> +				netdev_err(lif->netdev, "%s OOM\n", __func__);
>> +				return;
>> +			}
> Can you drop this message (can be a follow up, since you're just moving
> it).
>
> AFAICT ATOMIC doesn't imply NOWARN so the message is redundant no?

Yes, this can probably be cleaned up.  There are several of these left 
over from the very early version of this driver that I'd like to clean 
up, but haven't yet bubbled up high enough on my priority-vs-time list.  
I'll try to get to them in the next week or so.

sln

