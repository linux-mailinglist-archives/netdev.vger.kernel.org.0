Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69645A6D67
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 17:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbfICP7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 11:59:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44549 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfICP7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 11:59:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id 30so7124029wrk.11
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 08:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=doEXvD9ohBmcCvnOgHklhHYhj4U2HVc9bRnTXyDOsj8=;
        b=ai21DDIpqlEq0sdGgELLie+7u2+wXcNmNkVMrW2wOo0q7YJysCFRwiDMeW8mquI8K/
         4CMTPfCMVwoJ8NHfojJ7go5+Vs+bTI7RVOWapZ1XLYlzaa7yz9XR43VlRf/Tj7HBVoYz
         BIAsGVVmUCewybSESKx1Le6P4L5WirOtVyKPJoR7LOcITnNgun1MoWom5EkPsSVZWmUM
         LIfPkjtz2iAwJE0qYK1eCaaCLpeAX6nxdqlbks/EohxnQcYbRROpQUjJu2bJ+K5FXlEW
         dPM1hL7AAanAg72q7dnODBXSMiP3NdZhZNfCwqDbjw5jI7UtmhQQXVsSvkt6MxN4H54g
         dhsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=doEXvD9ohBmcCvnOgHklhHYhj4U2HVc9bRnTXyDOsj8=;
        b=ALC4VjMAsPQaSvRcbytpO6mDPj1fgKM74uxGj/rgCWx8JL0YqDrK2eLdjreeVyq/CR
         4x68wO4OGapqjNNtrEdhlnJ5ZTshZNnQyAJ2TU2z1wuDU7Xdy2QE9LxkQDd9F2Spqzs+
         xSJsL6pYVQ/8iYAVC6kz2m14qxgqxZspdEboWbw7BcM4EhUH1/4XDS0ZlVub/sdWld5A
         kVyvg/xHTqIUr8XQI6W3z8BxScgSjTvalvpgkM43aTbQnlXzOc+p7Fmkp67aByZZyanJ
         79AVXjygg1if88P4f7Jcyf3g5YnWG8ZBONYakZ5yjb9JQestY7ESzqC1fb+5XJ3b43Ue
         6WRw==
X-Gm-Message-State: APjAAAW1mEXrKtTeO/Os7D2PjBiHTBe4uBjKzMj0dqyW8skfTven/rZw
        cEIZPut0Q3ivt61d22EYHvg=
X-Google-Smtp-Source: APXvYqxPhiZap2ZdEQ5guDIB4FvgRxTN1VkVnI0Xz6tquSxKFR2Qwat0YlJpFuPCn36KUdVukLvF5w==
X-Received: by 2002:adf:fe07:: with SMTP id n7mr28846905wrr.90.1567526362304;
        Tue, 03 Sep 2019 08:59:22 -0700 (PDT)
Received: from [192.168.8.147] (83.173.185.81.rev.sfr.net. [81.185.173.83])
        by smtp.gmail.com with ESMTPSA id v4sm19525041wrg.56.2019.09.03.08.59.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 08:59:21 -0700 (PDT)
Subject: Re: [PATCH] Clock-independent TCP ISN generation
To:     Cyrus Sh <sirus.shahini@gmail.com>, davem@davemloft.net
Cc:     shiraz.saleem@intel.com, jgg@ziepe.ca, arnd@arndb.de,
        netdev@vger.kernel.org, sirus@cs.utah.edu
References: <70c41960-6d14-3943-31ca-75598ad3d2d7@gmail.com>
 <fa0aadb3-9ada-fb08-6f32-450f5ac3a3e1@gmail.com>
 <bf10fbfb-a83f-a8d8-fefc-2a2fd1633ef8@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2cbd5a8f-f120-a7df-83a3-923f33ca0a10@gmail.com>
Date:   Tue, 3 Sep 2019 17:59:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <bf10fbfb-a83f-a8d8-fefc-2a2fd1633ef8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/19 5:39 PM, Cyrus Sh wrote:
> 
> 
> On 9/3/19 1:41 AM, Eric Dumazet wrote:
>> Clock skew seems quite secondary. Some firewall rules should prevent this kind of attacks ?
> 
> Can you provide any reference to somewhere that explains these firewall rules
> and how to exactly use them to prevent this specific type of attack?
> 

You could add a random delay to all SYN packets, if you believe your host has clock skews.

