Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83797332735
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 14:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhCINcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 08:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhCINby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 08:31:54 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE26C06174A;
        Tue,  9 Mar 2021 05:31:54 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so5206546pjv.1;
        Tue, 09 Mar 2021 05:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=hzSCIKRAepKDBSqSG3kIFxZmTW4GplrRyROpRrL9fZk=;
        b=VoUC+t+4QQEB+uwm9H46DQTFa9Lxcv65xlBoQILewDayS5eF40i8muFvUZwnMdTwEp
         vndo1PrFpuvtxtttpGyVTXNI7XzW/5br+dEfWiRiPld2yrEHih/GMnxBJmXplP9KNYzu
         0xC0a8SyJu3hpz3MXIFpaAlQgV8QL64PiJYqt9v1CHJTlgW8hgB6KbQ0qOxmv6RFGk2t
         fBxGvLENa4EPpuyVJ+kkUeXFo5rLymW/ZOcZrLKoi8m7DpQus3oAbCYnkEv7CDKeM3d2
         ihIqn6jFUMPv74suxw+3gSNUecSlJs5f6okTzGOy8RLA/2OHV2XB5rXSTkIjfuUMw5vy
         +llw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hzSCIKRAepKDBSqSG3kIFxZmTW4GplrRyROpRrL9fZk=;
        b=AfR/x8OcmUHua7ETCZ2Why3d5rpL/hwE4IeVIhgZttIx+0qWSbi4V5mGD+z9Ls8x8v
         BXwlsrZkitdej1FGT1NuNI93icV0AjeBBFzSxZn4fkaeeSD/HLdlxj/Al0Ta9rpEiUph
         bht1DNa5/FMcSHW0sJxFpDKv52feaaQzZ6z5tLXTK5Up53ZuZPu/uRQukcIYOqL5aCgZ
         RKI1hBJRfpLSagZFJnsqcf+SklAIZHrU2MJL4/ahduAK1Wvdl9AqrXHj3LavjwALlL4q
         i6m47sL0Vgy9qB4j3KSIgiYJs8F/YMZbIyXxJ5o6+xtOYoKvDbAD51fiF4/KQjb8Kl5o
         OQ/g==
X-Gm-Message-State: AOAM5317E5WN+NWzkpZ4t626xN140RzaiLkxGluufeE3qODUMLIJ/VHm
        hzi36mIbEe8nHBCWBQNp+yAyYNObh64hDd2A
X-Google-Smtp-Source: ABdhPJxXio9p1SubQUEusIhDTwHFOdEwz2dvRviAy6id3mJP4DBEq5QQnW53AW5uv2HMkG4gCfbSsw==
X-Received: by 2002:a17:90a:314:: with SMTP id 20mr4869559pje.72.1615296713955;
        Tue, 09 Mar 2021 05:31:53 -0800 (PST)
Received: from [166.111.139.108] ([166.111.139.108])
        by smtp.gmail.com with ESMTPSA id d25sm2133784pfo.218.2021.03.09.05.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 05:31:53 -0800 (PST)
Subject: Re: [PATCH] net: bridge: fix error return code of
 do_update_counters()
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, roopa@nvidia.com,
        nikolay@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210309022854.17904-1-baijiaju1990@gmail.com>
 <20210309110121.GD10808@breakpoint.cc>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <e0f4d41e-b600-ce3b-b2e8-ca5c12f151dc@gmail.com>
Date:   Tue, 9 Mar 2021 21:31:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20210309110121.GD10808@breakpoint.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/3/9 19:01, Florian Westphal wrote:
> Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>> When find_table_lock() returns NULL to t, no error return code of
>> do_update_counters() is assigned.
> Its -ENOENT.
>
>>   	t = find_table_lock(net, name, &ret, &ebt_mutex);
>                                         ^^^^^
>
> ret is passed to find_table_lock, which passes it to
> find_inlist_lock_noload() which will set *ret = -ENOENT
> for NULL case.

Thanks for the reply!
I did not notice "&ret" in find_table_lock()...
I am sorry for the false positive.


Best wishes,
Jia-Ju Bai
