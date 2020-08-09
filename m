Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A69824006F
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 01:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgHIXlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 19:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbgHIXll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 19:41:41 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C7AC061756
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 16:41:41 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id s15so3456941qvv.7
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 16:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aGkWFRCdAxvTBF8EM+6jTK5jtDJpgzum4St7QwRRznI=;
        b=W3ImDcocFqyIVmhzpxx/zE0RI6o/rjfwCMhUG9VIUenCN7GucbaVJaB+kI3+s/vnM2
         zRPoXDO1Th/hkvmDROkaZzYJAX5m4G9w4Ll8t3Ti7o+OJRCi2OCXwvGK/6Hms+DyyvHe
         JVQY5WMvNOQfNQqe4tLjx3rOPiExNPMFEgfE4RnN4bA2UH/vq5sDFupBac7Csk23gNQc
         eiyul1Op9su8QP8x29iBFp+W6Zel8Z5i49SPIhPdZW59w9f6SxiuppQ7hvrgoJPWb4PZ
         I6IQqFAN49Jh8rrhPB7oxDhMiDIXmgIX1+m2aeKzGfrbz6tdfGn1TRASN/+G6+CAmBTP
         s9ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aGkWFRCdAxvTBF8EM+6jTK5jtDJpgzum4St7QwRRznI=;
        b=Xn0+IYNPe5kIOwIXkeBk9x8af+aJV4rqShu3rIYCMvlVZ40NGXGC6lKALR6+xhl4iO
         5yuEF4KkS315lDPjPuQxR5QVLbO353x0YQYG5zh1xnN/5VVZalgXLwkwyMCyGM4qpP92
         JAG4Q8LzRgc0x6WG+bt0SksWBn/IxhxYWXd3IEbBeHHliwvOeDYDP4TNGVoznA38v9nk
         o3hetr8O5SSGKSyDIytnQ5TeMM6i29b1B0sGe3btgayfozu7EDPzcAgcr6ACNM+UNR/U
         yvw93i2Y7SnMLSSneYvthceHnIUevwzi3orhjCEN74dIKznWJxdTJP/DO9r2+tIQxy75
         BVTQ==
X-Gm-Message-State: AOAM5336H+AbfDtPYiEqfUp9X4Xp7ptgLyhBXBxzYiToFRVtPpmsoIWx
        8fh5VnLmHHvIkvZxw3RIjf2zKA==
X-Google-Smtp-Source: ABdhPJxbGuEo6oeJFwiQ+bjXtgX0IQFn633m3+gv4Am64qowhQ7m+RkG4UGr65jD8dCDBia1K5jiyQ==
X-Received: by 2002:ad4:5812:: with SMTP id dd18mr25832357qvb.23.1597016500780;
        Sun, 09 Aug 2020 16:41:40 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-06-184-148-45-213.dsl.bell.ca. [184.148.45.213])
        by smtp.googlemail.com with ESMTPSA id e23sm13851165qto.15.2020.08.09.16.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2020 16:41:40 -0700 (PDT)
Subject: Re: [PATCH net-next 1/1] net/sched: Introduce skb hash classifier
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ariel Levkovich <lariel@mellanox.com>
References: <20200807222816.18026-1-jhs@emojatatu.com>
 <CAM_iQpU6j2TVOu2uYFcFWhBdMj_nu1TuLWfnR3O+2F2CPG+Wzw@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <3ee54212-7830-8b07-4eed-a0ddc5adecab@mojatatu.com>
Date:   Sun, 9 Aug 2020 19:41:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpU6j2TVOu2uYFcFWhBdMj_nu1TuLWfnR3O+2F2CPG+Wzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-09 2:15 p.m., Cong Wang wrote:
> On Fri, Aug 7, 2020 at 3:28 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>
>> From: Jamal Hadi Salim <jhs@mojatatu.com>
>>
>> his classifier, in the same spirit as the tc skb mark classifier,
>> provides a generic (fast lookup) approach to filter on the hash value
>> and optional mask.
>>
>> like skb->mark, skb->hash could be set by multiple entities in the
>> datapath including but not limited to hardware offloaded classification
>> policies, hardware RSS (which already sets it today), XDP, ebpf programs
>> and even by other tc actions like skbedit and IFE.
> 
> Looks like a lot of code duplication with cls_fw, is there any way to
> reuse the code?
> 

Yeah, it was the simplest way to code this.
They are very similar since they both use 32 bit keys.
I am not exactly thrilled by the current 255 buckets(limited by rcu
structure) - it limits performance in presence of large number
of entries (since they can only be spread across 255 buckets).
If we have a million entries, there will be a lot of hash collisions.

> And I wonder if it is time to introduce a filter to match multiple skb
> fields, as adding a filter for each skb field clearly does not scale.
> Perhaps something like:
> 
> $TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle X skb \
> hash Y mark Z flowid 1:12
> 

Interesting idea. Note: my experience is that typical setup is
to have only one of those (from offload perspective). Ariel,
are your use cases requiring say both fields?

 From policy perspective, i think above will get more complex
mostly because you have to deal with either mark or hash
being optional. It also opens doors for more complex matching
requirements. Example "match mark X AND hash Y" and
"match mark X OR hash Y".
The new classifier will have to deal with that semantic.

With fw and hash being the complex/optional semantics are easy:

"match mark X AND hash Y":
$TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle X 
skbhash flowid 1:12 action continue
$TC filter add dev $DEV1 parent ffff: protocol ip prio 4 handle Y fw 
flowid 1:12 action ok

"match mark X OR hash Y":
$TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle X 
skbhash flowid 1:12 action ok
$TC filter add dev $DEV1 parent ffff: protocol ip prio 4 handle Y fw 
flowid 1:12 action ok

Then the question is how to implement? is it one hash table for
both or two(one for mark and one for hash), etc.

cheers,
jamal
