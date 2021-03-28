Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1596334BA4A
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 01:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhC1A4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 20:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhC1Az4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 20:55:56 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3521C0613B1
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 17:55:55 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id t16so4812629qvr.12
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 17:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hHMbTWgTgI+fMsb5YeenlXfQ2mARrtDf2ZGncxZDz3Y=;
        b=vzwVpKVbrIXpuZVmw9RVofcnv0InV6Kn0JfS/9cJfeI6mE0KYawinEg2BltnIJZ7dA
         q/TUqXaGW5Gy1HZ2iU0G5KSDVImjVcEX7uiEFh9T+rNs74cR4yxnsfIgbEt4e8iEghre
         NUAUNa95+NgmqDq6hKltk6ArSkZJvXOEWFyK+OFUBapdS8AxjPYkso2pu6kASAnyzscX
         PaYYQMX9afhYRUHAQA6xiG+q3nrFS36D+6fOVqxLmK2kqTX/XHwOI06CQErQoaLzt1gL
         SdV3bHsqnj6B9bbN5au8eGuYCAMa9cqAQ0E4GUOTVb2S1yecUROlF+9sUQQlnHkdDhHA
         WCnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hHMbTWgTgI+fMsb5YeenlXfQ2mARrtDf2ZGncxZDz3Y=;
        b=t20CWY4A7gEAFr8U+o4lOLNEQ0bCZs1MaSP1Be5JZXjMXOQqxmprVLZgacHKDBYaK1
         mc68MSCssqD6Xe3wHVgGrKx/NbBgFUp0DNHOo24jbDOBVeL5+yvEL10lTXv4HBUlDCi8
         i7cxY/Rr/VCcYWTxVg4x2C8mYj2Z9tTo+0cz+iJMw/vu6HoLJX7/XwIdjT/Oy1eKk6P8
         dbJMmxhDZCecLodFWSZTxru34j/Se6HXBN4Y6vqPYiBOGFOwA4tH9GI1qWnkI9yhnug7
         boEA7HiUKCuXhBjFM9WD0TDFhMgoYowtUrXc3b86zGAxiaNdhln2g+5UWpcRzt5boUJO
         AKhg==
X-Gm-Message-State: AOAM532dXPZCbAlJRCdaQqCHnQP12RyBseEQ86hhpeoAqgFAsCYA8WOv
        DANrx35SD8D4qM4dyVBFHLfGPw==
X-Google-Smtp-Source: ABdhPJwZJgg7I4hQBpNOAAOh4Kyx653zmqC68CtUbPVH4CkL5nJTQxkx0RfzUN60yD7wBHvadXAzjA==
X-Received: by 2002:a05:6214:2ea:: with SMTP id h10mr10596773qvu.55.1616892955263;
        Sat, 27 Mar 2021 17:55:55 -0700 (PDT)
Received: from [192.168.2.61] (bras-base-kntaon1617w-grc-23-174-92-112-157.dsl.bell.ca. [174.92.112.157])
        by smtp.googlemail.com with ESMTPSA id g11sm9994764qkk.5.2021.03.27.17.55.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Mar 2021 17:55:54 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] selftests: tc-testing: add action police
 selftest for packets per second
To:     Simon Horman <simon.horman@netronome.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Ido Schimmel <idosch@idosch.org>,
        Baowen Zheng <baowen.zheng@corigine.com>
References: <20210326130938.15814-1-simon.horman@netronome.com>
 <20210326130938.15814-2-simon.horman@netronome.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <0cd65f9e-1cc0-630b-89eb-9065c30d0259@mojatatu.com>
Date:   Sat, 27 Mar 2021 20:55:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210326130938.15814-2-simon.horman@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-26 9:09 a.m., Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Add selftest cases in action police for packets per second.
> These tests depend on corresponding iproute2 command support.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>

Gracias.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

