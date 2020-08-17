Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE3824653A
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 13:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgHQLTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 07:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgHQLTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 07:19:21 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECEAC061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 04:19:21 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id m7so14537756qki.12
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 04:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6WbE05yPaHsMFllWFVMKb+4EzF/ACuAIf8fcfGat4hw=;
        b=q9h1A6n0AgIyn1EFNKq7mGbrZ69QGK8IZCYK5qeRT7VO0PT4XFRqfwEZzpqADt4ILK
         03YSQ2wPDzinzReS1swbs4zwYlkdIOl/w4E8mfmjEEP0//EKbSVr6IG8bHogybPcFk3F
         Mfn3G5jf7YHZhKsC4IJGY8iGpb7XP9UnWYlrWlUiypTjIMpIZ4kPQRhjQar1kB3v5eje
         FC3RSImLAXTRARQuWWBexa1ZisP9baN3jI5pddGBtq6NFMbA0iEbYNBA27ZDRFqEQAf/
         T6vQnQ0AjH3FkijxdjWc2ddm4tGIHB+1vaBqu/GNTaP5syW0PfZlOlsnD8xTWjBtxbo5
         7XUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6WbE05yPaHsMFllWFVMKb+4EzF/ACuAIf8fcfGat4hw=;
        b=rZejTUAvLvUe9wDj4AOYvn5ARUxeLAlmi3Rt0633fb8bT0JFVYizlpaus/fd9a4fFL
         DsFsFM1Pw/F5sH7vgFH5z1EJepT8Q0w84L4DK/hOE2diYE5PmG0k/8loMIkSLvfdPUY2
         WmWO+LAy8rLLGK7IhOyrar3HY7lowfCF17W9O6FPyiGCOYUAgMuax3UKsg3p6z15xWgI
         V4tcyJyJJeInuUulmwxUAElaICeVCk1PpYNeeRpEVUt8Clr2tKXsf0Cbv7q9sHnDRyJR
         LKWkzLkh7bCTF3QEnX29BOngkOHRJGKZy9xDNRXZIlL2owY6DuY37qbaT9NrmBH/K2lW
         b6UQ==
X-Gm-Message-State: AOAM532Ab392gT5MQzonQjfWdF9ySit0Pfma1/ylJPOI4u3WeeCHATh0
        EIY/EhbR/lMS3rmavpt5Drk7EA==
X-Google-Smtp-Source: ABdhPJxlCK1H2BvepztZAV+qijlF0LsqQKUMm9sqMlCNUzHRTMR6OcVtRu1edYW3XTNxQkDsemCsgA==
X-Received: by 2002:a37:a354:: with SMTP id m81mr12437396qke.277.1597663160021;
        Mon, 17 Aug 2020 04:19:20 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-06-184-148-45-213.dsl.bell.ca. [184.148.45.213])
        by smtp.googlemail.com with ESMTPSA id t1sm16989558qkt.119.2020.08.17.04.19.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 04:19:19 -0700 (PDT)
Subject: Re: [PATCH net-next 1/1] net/sched: Introduce skb hash classifier
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ariel Levkovich <lariel@mellanox.com>
References: <20200807222816.18026-1-jhs@emojatatu.com>
 <CAM_iQpU6j2TVOu2uYFcFWhBdMj_nu1TuLWfnR3O+2F2CPG+Wzw@mail.gmail.com>
 <3ee54212-7830-8b07-4eed-a0ddc5adecab@mojatatu.com>
 <CAM_iQpU6KE4O6L1qAB5MjJGsc-zeQwx6x3HjgmevExaHntMyzA@mail.gmail.com>
 <64844778-a3d5-7552-df45-bf663d6498b6@mojatatu.com>
 <CAM_iQpVBs--KBGe4ZDtUJ0-FsofMOkfnUY=bWJjE0_dFYmv5SA@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <c8722128-71b7-ad83-b142-8d53868dafc6@mojatatu.com>
Date:   Mon, 17 Aug 2020 07:19:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVBs--KBGe4ZDtUJ0-FsofMOkfnUY=bWJjE0_dFYmv5SA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-16 2:59 p.m., Cong Wang wrote:
> On Thu, Aug 13, 2020 at 5:52 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:


[..]
>> How do you know whether to use hash or mark or both
>> for that specific key?
> 
> Hmm, you can just unconditionally pass skb->hash and skb->mark,
> no? Something like:
> 
> if (filter_parameter_has_hash) {
>      match skb->hash with cls->param_hash
> }
> 
> if (filter_parameter_has_mark) {
>      match skb->mark with cls->param_mark
> }
> 
 >
> fw_classify() uses skb->mark unconditionally anyway, without checking
> whether it is set or not first.
> 

There is no ambiguity of intent in the fw case, there is only one field.
In the case of having multiple fields it is ambigious if you 
unconditionally look.

Example: policy says to match skb mark of 5 and hash of 3.
If packet arrives with skb->mark is 5 and skb->hash is 3
very clearly matched the intent of the policy.
If packet arrives withj skb->mark 7 and hash 3 it clearly
did not match the intent. etc.

> But if filters were put in a global hashtable, the above would be
> much harder to implement.
> 

Ok, yes. My assumption has been you will have some global shared
structure where all filters will be installed on.

I think i may have misunderstood all along what you were saying
which is:

a) add the rules so they are each _independent with different
    priorities_ in a chain.

b)  when i do lookup for packet arrival, i will only see a filter
  that matches "match mark 5 and hash 3" (meaning there is no
  ambiguity on intent). If packet data doesnt match policy then
  i will iterate to another filter on the chain list with lower
  priority.

Am i correct in my understanding?

If i am - then we still have a problem with lookup scale in presence
of a large number of filters since essentially this approach
is linear lookup (similar problem iptables has). I am afraid
a hash table or something with similar principle goals is needed.

> 
>> You can probably do some trick but I cant think of a cheap way to
>> achieve this goal. Of course this issue doesnt exist if you have
>> separate classifiers.
>>
>> 2) If you decide tomorrow to add tcindex/prio etc, you will have to
>> rework this as well.
>>
>> #2 is not as a big deal as #1.
> 
> Well, I think #2 is more serious than #1, if we have to use a hashtable.
> (If we don't have to, then it would be much easier to extend, of course.)
>

In both cases youd have to extend the existing code.

cheers,
jamal
