Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9813602A6
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 08:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhDOGsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 02:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhDOGsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 02:48:17 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA62C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 23:47:55 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id m9so9410629wrx.3
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 23:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iCQdv8HoumdliWIWYQS4JumgYscFa/gV1zbXETxIh14=;
        b=B2MkUL56cNMV2Wi9qkiYMT7W+fp3gYeH1OAKqRAibh6m9lLYSVBS9dUcftDTJxqCK/
         uMf0fz/qXjik60mQRVtn7RKPq37jNjMmRmUy9vEMV+shsg85qW+qoPLrjbaQdHeB4Rwz
         3wohVkMSajyxlVSqj2IHBBfw25bwsOvpzdS1xSVpLn2UBprIMxlQMf5qwpDxdOyWDcob
         mT2cCN2jjLPAXkymUQk6rdu+zChldll5/YRm9gdlI53ypgG3Q8OLDtv7ERGydY4hCsbm
         M9hhBq3Y6F9vr0eeXyS4Hp+e7vsCIv0hasT6olWC2pMHeATVEJg496WVUSonArP7Hkee
         G/aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iCQdv8HoumdliWIWYQS4JumgYscFa/gV1zbXETxIh14=;
        b=rT8JGSrCe7BAXBmj6+epkWAJoxuYp8HgRPjWQu4p+beVm744PHvc5fkSQQKxo1FJeh
         /r+G7BqpZgVALIzR2IFCJPfB9irZPqnJV8XdzlVHAwuTskpLy82glKVx+uQ1gpzCYyNi
         3h9O4nlQPQfdoGzVJQ7Mk4GTJzI4+aH6gj5rUxj27UG9VGGHQSp83MAim8T39GeUVzZP
         +AvyTw4KftjReT83RdKjokZ56zXY1lp4K1bxjaeaaonUebwu+GoxyaYZMQpAp+AgM9F2
         gUyQKVtOo5h/IulNO9KsXmhBZgPzdvVAzjpL+ke6FBMQ2RvKbq7tFCG1Ep/MmTuOqs2k
         wgtw==
X-Gm-Message-State: AOAM533LCGxxZPEBN+3ENIu0053ER7ePpEqpCgkBXRjRtbTL1Lkk0KJS
        RVEGI6hsyWJ4sEONQEW6fwpNKSPryv0=
X-Google-Smtp-Source: ABdhPJwnD6ZdYtiRJ+3Fi0pyL2wmHfsQieYswynWzhX4QG8BmOMsMmRDF3s6VRwPD7Wq1rO23Voyzw==
X-Received: by 2002:adf:ef8b:: with SMTP id d11mr1672499wro.107.1618469273863;
        Wed, 14 Apr 2021 23:47:53 -0700 (PDT)
Received: from [192.168.1.101] ([37.166.86.66])
        by smtp.gmail.com with ESMTPSA id b14sm1623025wrf.75.2021.04.14.23.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 23:47:53 -0700 (PDT)
Subject: Re: [PATCH net v2] net: core: make napi_disable more robust
To:     Lijun Pan <lijunp213@gmail.com>, netdev@vger.kernel.org
References: <20210414080845.11426-1-lijunp213@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1917fb7e-e8e5-a65a-7232-ddd6407fcc53@gmail.com>
Date:   Thu, 15 Apr 2021 08:47:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210414080845.11426-1-lijunp213@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/14/21 10:08 AM, Lijun Pan wrote:
> There are chances that napi_disable can be called twice by NIC driver.
> This could generate deadlock. For example,
> the first napi_disable will spin until NAPI_STATE_SCHED is cleared
> by napi_complete_done, then set it again.
> When napi_disable is called the second time, it will loop infinitely
> because no dev->poll will be running to clear NAPI_STATE_SCHED.
> 
> Though it is driver writer's responsibility to make sure it being
> called only once, making napi_disable more robust does not hurt, not
> to say it can prevent a buggy driver from crashing a system.

This is hard to digest. A buggy driver has plenty of ways to crash the system.

If you need help to fix the buggy driver, please ask for help.

