Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAE31F4788
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 21:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbgFITvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 15:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730897AbgFITvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 15:51:21 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9276FC05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 12:51:20 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b5so21335pfp.9
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 12:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=PvVOzgJ68WE49s5jKzncGGZwU8aMtTqDY6u9p5soGZw=;
        b=ol2GAxHPqxdKFl2aX8xMk6I67dEKOfjIHLlLJzq5L5RA644Ma96dDFbWkQ+Yypu6x2
         dEDyCM3nTNFVPDkZSuVthD5zPYKLVa8Njtm5HMmeZ5He1vt0i5GWA+450cRZm5a0cfBL
         suAylNXd8jmvPv+6eDkCza5zkKf0Pt4BpIBbVJusWus1B4uCWN4Ed1V3o7yRehRqXUhU
         1kPTjbxQv4w6jJVGet5nRGcxH4nWg6BfCnmuD/CDmzij8NE2sUo+I/3xR1iLQpr77rz4
         rw0XsXAqLyKaoA09vlOLiNCA/o9OhDtuA4z00YHZiHHAL+bMgbQlOs4l/rjPqECDLeeC
         E7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PvVOzgJ68WE49s5jKzncGGZwU8aMtTqDY6u9p5soGZw=;
        b=ZAaIFYpEfPhdwTt51JmV0D1rLugJAbDeE9GXjA/E5VyyT5XeYw0X1/VWHllK4IBO5I
         sYAN3HkHXtQ2+78DCHUBkXd9OJ8X6l+deaHjSrcY8u+yk1g7glvVEdLHFMx7viBe5Q8O
         89gU631QkNrwSoWZDf1hMScij5EP1IyqMXvo1c9yeSb9NRKrvl2KwahqxUEpkyatU2tV
         ohvVH9Um9NuUgStNUM50ltPxotBpAOdVvyFC4TRHl4JDyYgcXQSid9Hd+k21WTUa1Hw4
         AqGYl268E09SuO6FvJwpjioyP/dx1z4dfSCHOoY8NDknW0DTJgLLN898K7RBzi7s5UZ/
         iP/w==
X-Gm-Message-State: AOAM533qpARqFMNubZBxOO4vuU6Phbg/GySP1B6nbnEpNLqnZ4NT9hOr
        JZ1A2B6SU80bsILXA8kqSfLK7tEgw2Q=
X-Google-Smtp-Source: ABdhPJzdzU4RfSz5/aSfBUtfTvzo2/uVExAL/5DTwk5KqdKeCozsdgGVwrlUWIJ4/oIrFdeHSu45kg==
X-Received: by 2002:a62:bd07:: with SMTP id a7mr26362341pff.311.1591732279184;
        Tue, 09 Jun 2020 12:51:19 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id w11sm10564388pfi.93.2020.06.09.12.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 12:51:18 -0700 (PDT)
Subject: Re: [PATCH net 1/1] ionic: wait on queue start until after IFF_UP
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200609034143.7668-1-snelson@pensando.io>
 <20200609.124709.1693195732249155694.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <99c98b8c-f8c3-b1be-9878-1ad0caf85656@pensando.io>
Date:   Tue, 9 Jun 2020 12:51:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200609.124709.1693195732249155694.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/20 12:47 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Mon,  8 Jun 2020 20:41:43 -0700
>
>> The netif_running() test looks at __LINK_STATE_START which
>> gets set before ndo_open() is called, there is a window of
>> time between that and when the queues are actually ready to
>> be run.  If ionic_check_link_status() notices that the link is
>> up very soon after netif_running() becomes true, it might try
>> to run the queues before they are ready, causing all manner of
>> potential issues.  Since the netdev->flags IFF_UP isn't set
>> until after ndo_open() returns, we can wait for that before
>> we allow ionic_check_link_status() to start the queues.
>>
>> On the way back to close, __LINK_STATE_START is cleared before
>> calling ndo_stop(), and IFF_UP is cleared after.  Both of
>> these need to be true in order to safely stop the queues
>> from ionic_check_link_status().
>>
>> Fixes: 49d3b493673a ("ionic: disable the queues on link down")
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> What will make sure the queues actually get started if this
> event's queue start gets skipped in this scenerio?
>
> This code is only invoked when the link status changes or
> when the firmware is started.

If the link is already seen as up before ionic_open() is called it 
starts the queues at that point.

If link isn't seen until after ionic_open(), then the queues are started 
in this periodic link check.

sln

