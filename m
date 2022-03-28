Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2C64E9EDC
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241481AbiC1SVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240614AbiC1SVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:21:47 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F5E237D5
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:20:06 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id a17so17922774edm.9
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=LWChrUtNlDhcBPRxCF0qjl5iT5wCuOPcJ3dqocrGVgo=;
        b=Nxa5y5l+bT6SvRxEAinZOnLTkVrVgKZo4qIJovaxeSMTfuXX2Rr8TSBi+VDXP7KfV6
         ce/bAikyROsZT15/VZHEtlKH34dUF/qSi4FPIletQOMtfGSyfYS22X7UzKDD1BOIzD4q
         CJa0F19c7K/IeTav1Cj44EdlDtV+vw7PEluorLB2KyCdmt/RpGlzw1DFSkZSwjgQ8XC2
         3jGsvsol5oLX4nYwjblFbVItbFhJqKU2lk7gXWxcjLq3d/oMtZ6nUjLJTEFK5eYwAGku
         5EbZT+lVwscyV28kR8YMeH1uXA0LrU6FNqZfwxn3lc0UjxuKPUIQw4oNUn5WNnymmPUU
         TjMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LWChrUtNlDhcBPRxCF0qjl5iT5wCuOPcJ3dqocrGVgo=;
        b=fCcmVyE3vPRsQLeJqNreayYX7ewSrm4UM/9UUcHQptsCgClQdPRpYfWYVjSDIOMeTR
         mwLC/X0aRM/DXEzb/ql9I6ZD3wEueZ5d/XEe+RtkjTYl2jKyWVaCE8kvFrA4DVVNEa5B
         YSnHMQy9K+omSAcZhIcaoSBLC/uvDngnC5Yq95TmdbMbroxAWYY/m2VZLbvd7o8qxH2p
         rAYFOqAClMw85sU7JOX3rngrh/C1o/SOkKbs3iyZuW5rXWIUCwiSlwMbbnhfYI6Zv9av
         hqbe/eeh+MSOqxrlwz/qvKoFF1a3UUmZ8xHMAddSqH8DKYY/giQsqP2q+S7lcgbssdT6
         40KA==
X-Gm-Message-State: AOAM530s5ta0B0f++xQZ7P7YzHhMmQJxnVdyP8HN6ZO0EUizIMnhyibz
        i6W4hnYvx9LpNSHTiUK1U36QgA==
X-Google-Smtp-Source: ABdhPJxLBPkaytucNbL+wnKlm4YXIAA8QRnRTGtlKciknymn5L/0guEAuhFrS0zIKIxC0ThVp8HkDw==
X-Received: by 2002:a05:6402:2318:b0:413:7645:fa51 with SMTP id l24-20020a056402231800b004137645fa51mr18184325eda.201.1648491604836;
        Mon, 28 Mar 2022 11:20:04 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm6059413ejz.57.2022.03.28.11.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Mar 2022 11:20:04 -0700 (PDT)
Message-ID: <8bd7362f-0a23-e11c-445b-1e61d08bb70a@blackwall.org>
Date:   Mon, 28 Mar 2022 21:20:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [RFC 2/2] net: bridge: add a software fast-path implementation
Content-Language: en-US
To:     Felix Fietkau <nbd@nbd.name>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        netdev@vger.kernel.org
References: <20220210142401.4912-1-nbd@nbd.name>
 <20220210142401.4912-2-nbd@nbd.name>
 <bc499a39-64b9-ceb4-f36f-21dd74d6272d@nvidia.com>
 <e8f1e8f5-8417-84a8-61c3-793fa7803ac6@nbd.name>
 <0b4318af-4c12-bd5a-ae32-165c70af65b2@nvidia.com>
 <6d85d6a5-190e-2dfd-88f9-f09899c98ee7@nbd.name>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <6d85d6a5-190e-2dfd-88f9-f09899c98ee7@nbd.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/03/2022 18:15, Felix Fietkau wrote:
> 
> Hi Nik,
> 
> I'd like to follow up on our discussion regarding bridge offloading.
> I managed to come up with a user space + eBPF implementation that replaces this code and shows mostly the same performance gain as my previous kernel space implementation.
> 
> At first I tried to use generic XDP, but after getting it working, performance was pretty bad (due to headroom issues) and I was told that this is by design and nobody should use it in production.
> 
> Then I reworked the code to use tc classifier instead and it worked much better.
> 
> It's not fully ready yet, I need to add some more tests for incompatible features, but I'm getting there...
> The code is here: https://github.com/nbd168/bridger
> 
> There's one thing I haven't been able to figure out yet: What's the proper way to keep bridge fdb entries alive from user space without modifying them in any other way?
> 
> - Felix

Hi Felix,
That's very nice! Interesting work. One way it's usually done is through periodic NTF_USE (refresh),
another would be to mark them externally learned and delete them yourself (user-space aging).
It really depends on the exact semantics you'd like.

Cheers,
 Nik
