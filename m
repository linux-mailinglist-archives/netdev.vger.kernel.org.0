Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF8026AF00
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgIOU6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbgIOU5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:57:22 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC735C06174A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 13:57:16 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f18so2645686pfa.10
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 13:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Op3M2buZBNHAA3h6SnszooROqIE76wP3kayGu1+tIgQ=;
        b=Z2Bl/OpDosliUR7vLATGSufowOr+nwbAmeNmntnjDUjHePWj9IuOGttU4ELhcDTtfU
         /0YKwsuRtw+6W/3OatTuP6VrTXqmI3V0sfBOXVsrVI8poXfoH7NkSaqFDkIpzy0KBqQr
         I7FDQSFmhypIlHtL/4gz3FndnaUrshEVHSV4xX8X0KEDC1PLqPO98sRyEbp2Avou1kw8
         8/pTsc3Nh+BRStYAgfEaEie1FRKcymEf6H//dfNnrJkkx6VNPk8vLdqLES7qwFBWl0IY
         R5p8c9BxH5NwWM2vipNip1MbEVLlaW/1HZCXijkU506H1tC1wzqDslL89Yq3ea4VKsZR
         MURA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Op3M2buZBNHAA3h6SnszooROqIE76wP3kayGu1+tIgQ=;
        b=TmTp9zMkoU45VDHRnnE9RYxPB2TGx/1On1rHOw1bSQbYX1bLs9g7bMJXkx3jB0dFhu
         NnC1mUuEhrvizcIrRFPi/02k1FqVJ4eTmOLZm6rmZ03/E/3gIInlUFUKk6XN9wH6Tz11
         Lz7ixnQhJYvIvN/PXYvPFWMOTTVIBO2zyAGCOGFgOeWmKo0idccVMfMprGuizlG2ocNr
         611wdVgUmOm8+2KPByin/HXduqLogDhbHLMu2f46aqjaR9RtfdVlAoUpN9Ln+U18gD4C
         rgDL70oBWrHvRpI0kFcWz/8HIp6DmfrmkRdTcI4PzDw0hVXHnpRmT3NZ15iC5dfIghZp
         DeyQ==
X-Gm-Message-State: AOAM530R8ZIuM+B6LR3kaW3YTs91JfOUoVVDj1mEWN3Q2Zafbyb2WR8n
        l+cl1pYOxORYF02V46DNf9Y5DvNs9/Kisg==
X-Google-Smtp-Source: ABdhPJyP4hFTO/U2YM28oVlanzSQGJbVXpdmrRjvptgIq/WkQMmcIZXM5IWIBt1uMrqTdoXtz7LsLQ==
X-Received: by 2002:aa7:9f0a:0:b029:13e:d13d:a107 with SMTP id g10-20020aa79f0a0000b029013ed13da107mr19525819pfr.35.1600203436008;
        Tue, 15 Sep 2020 13:57:16 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id j6sm14040680pfi.129.2020.09.15.13.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 13:57:15 -0700 (PDT)
Subject: Re: [PATCH v2 net-next] ionic: dynamic interrupt moderation
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200915013345.27309-1-snelson@pensando.io>
 <20200915.132837.1353627986155410882.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <0f6203ca-e9d2-c7b6-f4b6-e4573b3d1cfa@pensando.io>
Date:   Tue, 15 Sep 2020 13:57:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200915.132837.1353627986155410882.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/20 1:28 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Mon, 14 Sep 2020 18:33:45 -0700
>
>> Use the dim library to manage dynamic interrupt
>> moderation in ionic.
>>
>> v2: untangled declarations in ionic_dim_work()
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> Acked-by: Jakub Kicinski <kuba@kernel.org>
> This doesn't apply cleanly to net-next, please respin.

Oh, sorry, will do.

sln

