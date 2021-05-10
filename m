Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F09379A5B
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 00:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhEJWsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 18:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhEJWsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 18:48:12 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFFCC061574
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 15:47:07 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id a2so17036433qkh.11
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 15:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RjGA+D8UakMnaRH20guHctDz02c9/2UHmjiF5bEhFdU=;
        b=KP614GEH2mPSo6u2CfQWrQCPMBYS//dU03EXr27FkUfo35mu51yL+C+K2rbK4p0DS/
         RuF1c/fnk2JxE4A/GrRvem6dbM58KwSR0ioDU8i0A9CPf/vv1HCa4YkHTFh12ypa6QFV
         aQwYF+4zYfwa3LAOBRlMUkfIHY1/sVNxA4aBYm/yyPV01KUSxuUOTKkX5uSZDioVz/9K
         OA2dM5zpizizjHuC6Fj1almeFoaKFzC/vU9MbZj5iOPwLvF64wBeyqtVKed3n0Shra+h
         kCXiiUhQEcC6cETd3SRU+ne/hnzX6A+DavmnRd76V6qpMxwPNc9LBNiu2Nf1rw3Cyxu4
         mU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RjGA+D8UakMnaRH20guHctDz02c9/2UHmjiF5bEhFdU=;
        b=INsAOd8D0JmMS2UvnzJjYuDs86rz3aXuDKtVSZVjMd0F+U7IrLHUgwKMQKGezILZZY
         evqzjleGayNQrYXVM9GEZHGefJ7N+lua1uxcqf4hXN7qbVpbmVxZaGJBPnO08Ca15p+i
         +a7nqWbjj8ISTxqMUltJ7yxvVAmizl40eFLqCyNsJkicUWOkm1fbKRhUwedqe7r/SyNv
         BoY3yvDmtiyUuH6+WfrDIhvzTM0WaMK7fm3pMsCBtkvysbvXujva0BaqLjaVQBXkzDnG
         wgoYgejmR3xzAXGjVy24lHEGXN7XlC3fHJDpgeTjTl0nIZtqZqhdj/QZ175MyXmJzv1u
         y6AA==
X-Gm-Message-State: AOAM533EvgdpZMhisVhSOhBWwLjdNk8S+zPENYkROfEnUp1NFgYxuo7h
        HawTtp4foA6Ed8yqWEZSQqvcU/LXF98KsQ==
X-Google-Smtp-Source: ABdhPJxxF47vJP5sR62T2645CnbBa/iY1WtDBH0yuP4YroPZ9sGv2teERNk2TbCzhKkbiTWTpEasLQ==
X-Received: by 2002:a37:e12:: with SMTP id 18mr24478336qko.419.1620686826441;
        Mon, 10 May 2021 15:47:06 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-25-174-95-97-70.dsl.bell.ca. [174.95.97.70])
        by smtp.googlemail.com with ESMTPSA id t6sm12652980qkh.29.2021.05.10.15.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 15:47:05 -0700 (PDT)
Subject: Re: [RFC net-next] net/flow_offload: allow user to offload tc action
 to net device
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Simon Horman <simon.horman@netronome.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
References: <20210429081014.28498-1-simon.horman@netronome.com>
 <2d2e4ae2-5de0-8c58-cd7a-ee3c841afd45@mojatatu.com>
Message-ID: <b21cf5f8-86dd-d676-754a-ea1bc4780dec@mojatatu.com>
Date:   Mon, 10 May 2021 18:47:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <2d2e4ae2-5de0-8c58-cd7a-ee3c841afd45@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-10 6:37 p.m., Jamal Hadi Salim wrote:
> On 2021-04-29 4:10 a.m., Simon Horman wrote:
>> From: Baowen Zheng <baowen.zheng@corigine.com>
>>
>

> In both cases, dumping just the actions reduces the amount
> of data crossing from hw->kernel->userspace.
> If you have a lot of flows this becomes extremely valuable.

Bah. I meant dumping either the meters or counters should
be sufficient - each has an index which can be mapped to
a specific flow.

cheers,
jamal
