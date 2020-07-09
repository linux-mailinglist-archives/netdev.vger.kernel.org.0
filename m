Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E57A21AA6A
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 00:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgGIWWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 18:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgGIWWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 18:22:10 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626D0C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 15:22:10 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m22so1580225pgv.9
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 15:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=GoXtqEjVvsMOdMLzwhP4omsWynXn8W5TGbLTcJ+zO4k=;
        b=Lgtrpc/f0gviNRHkJZmxqJiNU0IYYune7Xr79yIn0jQnRH4lzri+yLb5F5gLjDWG9C
         7GKvGHmseZtoiZGZZjPFI93La8OhTJaIc1XiBPR7RjUeW/Q6lGMkU7mJtDSQutvlvVhr
         4MPlk6T1wcQb16sWZ5KiXR4PPwd1pdFOZsdhjAnvCT+QZS1GKBY/BOZcZdvD2mvkj9rM
         MbrS5Fc2duLpn8C4k6fSjIEApadT2X0KFcWcEQe6ePcCPqKkn/e3q17xDe0XdN+YPgKo
         rKi+TDhu+ZNr9QH/0xNgBdvvKY59waOpVWqBzGV82/KmPm6GQawGjDw3esiBu1FXqYHS
         sx9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GoXtqEjVvsMOdMLzwhP4omsWynXn8W5TGbLTcJ+zO4k=;
        b=jDLzD1qQpE2bFJJZoFLlhkxx2X3rSQDHeIQAfo7S7sZ8uPiNQZV2TeLqfnunECJRO3
         v2/Cfpm+TPCYcc7GiN0FtiEscuEqEMT2LvPQcZpuRN/jK3XHXI/53Qj0C1vZJ8+DtUQV
         BxxkGEbmhYW/GiS6s/Wc3VGPB9AwInlWlZjdfpsdK+i/5VdjfrhcuTyYyjfsK0ViO9+c
         LD/6yh8Oo2x7II+FzIRiiyJyJCTixTLNWe+bGlkDyf76g7f/B4XkFPQCtow73XW72rTL
         /xio5ez9y+EFnsA7/imi9LhLdg2G0K38sxk6ZKVpS+6P0LR4S9d+JpDq3pA3xF1ePisE
         BRQw==
X-Gm-Message-State: AOAM5336vYbByRcrU5GeFPWCWjrMz3SQqm45NGV+lVbJRBTpIEh+g277
        soXfQM3VN0DQ16XahmOBZZyUoemv
X-Google-Smtp-Source: ABdhPJxnf1etKwFXoCTsdzXD0x41huDBD+Jytl9DdJMBhdGSI2Pi9hGS/OzT6Vv4XN5kcb80Hh4E0A==
X-Received: by 2002:a63:a558:: with SMTP id r24mr57492418pgu.70.1594333329478;
        Thu, 09 Jul 2020 15:22:09 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g18sm3863230pfk.40.2020.07.09.15.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 15:22:08 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
 <554197ce-cef1-0e75-06d7-56dbef7c13cc@gmail.com>
 <d1716bc1-a975-54a3-8b7e-a3d3bcac69c5@alibaba-inc.com>
 <91fc642f-6447-4863-a182-388591cc1cc0@gmail.com>
 <387fe086-9596-c71e-d1d9-998749ae093c@alibaba-inc.com>
 <c4796548-5c3b-f3db-a060-1e46fb42970a@gmail.com>
 <7ea368d0-d12c-2f04-17a7-1e31a61bbe2b@alibaba-inc.com>
 <825c8af6-66b5-eaf4-2c46-76d018489ebd@gmail.com>
 <345bf201-f7cf-c821-1dba-50d0f2b76101@alibaba-inc.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ad26a7a3-38b1-5cbc-b4ed-ea5626a74bd8@gmail.com>
Date:   Thu, 9 Jul 2020 15:22:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <345bf201-f7cf-c821-1dba-50d0f2b76101@alibaba-inc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/20 11:20 AM, YU, Xiangning wrote:
> 
> 
> On 7/9/20 10:15 AM, Eric Dumazet wrote:
>>
>> Well, at Google we no longer have this issue.
>>
>> We adopted EDT model, so that rate limiting can be done in eBPF, by simply adjusting skb->tstamp.
>>
>> The qdisc is MQ + FQ.
>>
>> Stanislas Fomichev will present this use case at netdev conference 
>>
>> https://netdevconf.info/0x14/session.html?talk-replacing-HTB-with-EDT-and-BPF
>>
> This is cool, I would love to learn more about this!
> 
> Still please correct me if I'm wrong. This looks more like pacing on a per-flow basis, how do you support an overall rate limiting of multiple flows? Each individual flow won't have a global rate usage about others.
> 


No, this is really per-aggregate rate limiting, multiple TCP/UDP flows can share the same class.

Before that, we would have between 10 and 3000 HTB classes on a host.
We had internal code to bypass the HTB (on bond0 device) for non throttled packets,
since HTB could hardly cope with more than 1Mpps.

Now, an eBPF program (from sch_handle_egress()) using maps to perform classification
and (optional) rate-limiting based on various rules.

MQ+FQ is already doing the per-flow pacing (we have been using this for 8 years now)

The added eBPF code extended this pacing to be per aggregate as well.

