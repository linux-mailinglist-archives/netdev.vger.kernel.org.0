Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C46E2BBFF8
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 15:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgKUOjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 09:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbgKUOjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 09:39:06 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4228C0613CF
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 06:39:05 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id l7so3128268qtp.8
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 06:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n3GN5ag7w/wmSbkon3rNMaVWarNxifm5CeHo4XxKJKY=;
        b=mFS/GMFurBjFhClcIh+6UfN7IEyZosJOHREcx179zijn/cwLamsL8Z2+BfxubvciQs
         siEuqF05iHfUhh6xzPo9C3VEcCtHUk+w++qegEYA7Y1XjUOgvTSyg5qC50LG85R9I2FC
         UkBwWQacWbZI3+ViS9Rmwz27zRJ6KyH0IPv1NPF/TKXfEuxsXKEOuAQFc4kWTo+s28v7
         ZXUb0PENIqUtdsg4tX8kDN3s7QzDv+VwUDolr8y61r+1fPQZddhtMHbIsRXJ4PaMu5GS
         CNyFW5QDgNI4AETKeKlW4qhdZ2LLXVoXE6me2PUjde36qc1uJ/HIEm7iJ1tCSsUjCmh8
         YH/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n3GN5ag7w/wmSbkon3rNMaVWarNxifm5CeHo4XxKJKY=;
        b=rSehN7q8ApX4TFMYTQx30TjMr3sXizGjnb4zOtQkJ2xStDZ50joETJaL1D6BNLlFRj
         Zi55eWBABp1WZIISHFcGxWrujHFC0ufTNveySFw5uAgPtqJW8y0pQaMtErBt3yJDhtPz
         MLddZb6qafy5V1kYx0NBMX90P99Ov+eClruxGh6SDBZj67XfJuuHqS6dpypL9dkiqiB6
         Etfsb7L3Ex/5SnMDAKzz/lkihtRS5zk/3geM0bpfE/f8ciypQ0rC5kGp893HhtmnxM80
         WydMVerLicoecLyupKK5Q84I5NyjjPA6/H2idZLkmXrtXM5PorRQEclZbieoveTkTXq9
         alAg==
X-Gm-Message-State: AOAM530/LGYUaLiFFSI+TEXxjldHxnYsIpeOcrRSTnQe31NOmOhUGqF1
        qaHgS1uoOk2yJ5dyTy3ESDqTCX4pplpoIg==
X-Google-Smtp-Source: ABdhPJxOAHAa4g9tdN5PZb+kVIweaVSL1RU9VUm0SIbE+lZUcsns+fzXkbGp+uQVVTUDhm27JTyiGA==
X-Received: by 2002:aed:3fb7:: with SMTP id s52mr21512772qth.100.1605969544970;
        Sat, 21 Nov 2020 06:39:04 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id a85sm4194692qkg.3.2020.11.21.06.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Nov 2020 06:39:04 -0800 (PST)
Subject: Re: [PATCH v3 net-next 0/3] net/sched: fix over mtu packet of defrag
 in
To:     Cong Wang <xiyou.wangcong@gmail.com>, wenxu <wenxu@ucloud.cn>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1605829116-10056-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpV1Lyw4yNUEof1kERA1vWLediDGAsfHf_UVxuS2HMNHYg@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <0378358c-89fd-4931-bfac-f77af051023a@mojatatu.com>
Date:   Sat, 21 Nov 2020 09:39:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <CAM_iQpV1Lyw4yNUEof1kERA1vWLediDGAsfHf_UVxuS2HMNHYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-20 2:28 p.m., Cong Wang wrote:
> On Thu, Nov 19, 2020 at 3:39 PM <wenxu@ucloud.cn> wrote:
>>
>> From: wenxu <wenxu@ucloud.cn>
>>
>> Currently kernel tc subsystem can do conntrack in act_ct. But when several
>> fragment packets go through the act_ct, function tcf_ct_handle_fragments
>> will defrag the packets to a big one. But the last action will redirect
>> mirred to a device which maybe lead the reassembly big packet over the mtu
>> of target device.
>>
>> The first patch fix miss init the qdisc_skb_cb->mru
>> The send one refactor the hanle of xmit in act_mirred and prepare for the
>> third one
>> The last one add implict packet fragment support to fix the over mtu for
>> defrag in act_ct.
> 
> Overall it looks much better to me now, so:
> 
> Acked-by: Cong Wang <cong.wang@bytedance.com>

LGTM as well.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
