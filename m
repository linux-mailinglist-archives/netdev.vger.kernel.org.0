Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DF92169B0
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 12:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgGGKF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 06:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgGGKF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 06:05:59 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021B6C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 03:05:58 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id o11so44545914wrv.9
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 03:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xkz5ETWjNrQFf/cWgOKpyYJFf+I8t8uMaY0GHfvAid8=;
        b=DTzEgPwy/cHXdWlqhXWIXJKAxLqCuIslFEY+kwOzxfW/OcBINiMF4r+HmMasVqMNjv
         eDpv95PZz8ICKNh1alcgRwzMFEm4ra7z1FPqlC3zthvkri1JKyQPx+m2N8MOEQBf/mCW
         mEReFLDLtVwijxm9qG8/vFL4kpKQEouKpl61dQeeFsN3LtnWuZ80fb1jhmUnBrjedeiP
         flWCc3HKnO1HCaXX/Fu+64dc9nSDP5yrzK8rVD3z6IVhHT45QUVw9tTbZn/rxSxapt+E
         /JMV8dkIWRgn0IAaM4YQRKWBvWMMKVbF9KsTzGEMIHhrG2soAnx60zSht2HaWql3CC2s
         SDAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xkz5ETWjNrQFf/cWgOKpyYJFf+I8t8uMaY0GHfvAid8=;
        b=n1f+yFO4gRlcqO49lv3Jylo8TFgd/KS1rkRJVYbMyip5AjXbY7PMiJXV5KyX6CmQ/9
         u7n0Feq2auGPwHLcvfgAKDJHMpgGERS4De3DXr+cwyISYLKkBzQG7k0DJgVl/jjsNeXS
         5MsORNKYlGdbZ/ZSdp9Er0o+5juaeL6VK+pRlglGI/23mwhrE8N4jgSNdZrpWdZl0Bua
         Qq0X3/RuQHhXJSVdB+NykQtJ4V2OOGy9kE0kgymmuRzuPz7JdWwb9es5jjted9Z1x07M
         090mitnOxJe81fLzWBZCMqKMQnaTdJqFyMaISPKX5gtXyZXYEvpFHbWGPf4LImJa2xQS
         KO0A==
X-Gm-Message-State: AOAM533bYvSolDDnWYVWkbLxGWUYhnGv2rA7UyXJLlV7Dn9WXSL3WNIX
        B9LYVp+aygM/bcK4WwqJH2JWeQ==
X-Google-Smtp-Source: ABdhPJyo1bovtIZX7f5FW4bTTU8pb0NefoN7dDQ3mNWUgDXp4rJVDmXSpMzdtj2d5IHDlAw0Ecev6Q==
X-Received: by 2002:a5d:6045:: with SMTP id j5mr52202442wrt.209.1594116357547;
        Tue, 07 Jul 2020 03:05:57 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 65sm401073wma.48.2020.07.07.03.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 03:05:56 -0700 (PDT)
Date:   Tue, 7 Jul 2020 12:05:56 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org,
        kuba@kernel.org, xiyou.wangcong@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [PATCH net-next v2 0/3] ] TC datapath hash api
Message-ID: <20200707100556.GB2251@nanopsycho.orion>
References: <20200701184719.8421-1-lariel@mellanox.com>
 <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 03, 2020 at 01:22:47PM CEST, jhs@mojatatu.com wrote:
>Hi,
>
>Several comments:
>1) I agree with previous comments that you should
>look at incorporating this into skbedit.
>Unless incorporating into skbedit introduces huge
>complexity, IMO it belongs there.
>
>2) I think it would make sense to create a skb hash classifier
>instead of tying this entirely to flower i.e i should not
>have to change u32 just so i can support hash classification.

Well, we don't have multiple classifiers for each flower match, we have
them all in one classifier. It turned out to be very convenient and
intuitive for people to use one classifier to do the job for them.
Modularity is nice, but useability is I think more important in this
case. Flower turned out to do good job there.

+ Nothing stops you from creating separate classifier to match on hash
as you wanted to :)


>So policy would be something of the sort:
>
>$ tc filter add dev ens1f0_0 ingress \
>prio 1 chain 0 proto ip \
>flower ip_proto tcp \
>action skbedit hash bpf object-file <file> \
>action goto chain 2
>
>$ tc filter add dev ens1f0_0 ingress \
>prio 1 chain 2 proto ip \
>handle 0x0 skbhash  flowid 1:11 mask 0xf  \
>action mirred egress redirect dev ens1f0_1
>
>$ tc filter add dev ens1f0_0 ingress \
>prio 1 chain 2 proto ip \
>handle 0x1 skbhash  flowid 1:11 mask 0xf  \
>action mirred egress redirect dev ens1f0_2
>
>IOW, we maintain current modularity as opposed
>to dumping everything into flower.
>Ive always wanted to write the skbhash classifier but
>time was scarce. At one point i had some experiment
>where I would copy skb hash into mark in the driver
>and use fw classifier for further processing.
>It was ugly.
>
>cheers,
>jamal
>
>On 2020-07-01 2:47 p.m., Ariel Levkovich wrote:
>> Supporting datapath hash allows user to set up rules that provide
>> load balancing of traffic across multiple vports and for ECMP path
>> selection while keeping the number of rule at minimum.
>> 
>> Instead of matching on exact flow spec, which requires a rule per
>> flow, user can define rules based on hashing on the packet headers
>> and distribute the flows to different buckets. The number of rules
>> in this case will be constant and equal to the number of buckets.
>> 
>> The datapath hash functionality is achieved in two steps -
>> performing the hash action and then matching on the result, as
>> part of the packet's classification.
>> 
>> The api allows user to define a filter with a tc hash action
>> where the hash function can be standard asymetric hashing that Linux
>> offers or alternatively user can provide a bpf program that
>> performs hash calculation on a packet.
>> 
>> Usage is as follows:
>> 
>> $ tc filter add dev ens1f0_0 ingress \
>> prio 1 chain 0 proto ip \
>> flower ip_proto tcp \
>> action hash bpf object-file <file> \
>> action goto chain 2
>> 
>> $ tc filter add dev ens1f0_0 ingress \
>> prio 1 chain 0 proto ip \
>> flower ip_proto udp \
>> action hash bpf asym_l4 basis <basis> \
>> action goto chain 2
>> 
>> $ tc filter add dev ens1f0_0 ingress \
>> prio 1 chain 2 proto ip \
>> flower hash 0x0/0xf  \
>> action mirred egress redirect dev ens1f0_1
>> 
>> $ tc filter add dev ens1f0_0 ingress \
>> prio 1 chain 2 proto ip \
>> flower hash 0x1/0xf  \
>> action mirred egress redirect dev ens1f0_2
>> 
>> Ariel Levkovich (3):
>>    net/sched: Introduce action hash
>>    net/flow_dissector: add packet hash dissection
>>    net/sched: cls_flower: Add hash info to flow classification
>> 
>>   include/linux/skbuff.h              |   4 +
>>   include/net/act_api.h               |   2 +
>>   include/net/flow_dissector.h        |   9 +
>>   include/net/tc_act/tc_hash.h        |  22 ++
>>   include/uapi/linux/pkt_cls.h        |   4 +
>>   include/uapi/linux/tc_act/tc_hash.h |  32 +++
>>   net/core/flow_dissector.c           |  17 ++
>>   net/sched/Kconfig                   |  11 +
>>   net/sched/Makefile                  |   1 +
>>   net/sched/act_hash.c                | 389 ++++++++++++++++++++++++++++
>>   net/sched/cls_api.c                 |   1 +
>>   net/sched/cls_flower.c              |  16 ++
>>   12 files changed, 508 insertions(+)
>>   create mode 100644 include/net/tc_act/tc_hash.h
>>   create mode 100644 include/uapi/linux/tc_act/tc_hash.h
>>   create mode 100644 net/sched/act_hash.c
>> 
>
