Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C90D162E03
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgBRSN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:13:58 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:40792 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgBRSN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 13:13:58 -0500
Received: by mail-wm1-f41.google.com with SMTP id t14so3969115wmi.5
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 10:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4722oNtei3tHBXGwWpb0asIxc2KR2GcXyviu8ZJnGm4=;
        b=bzcTsYIf+hihcOhIUTeX+vvX/ChqoAy/MxNLj+aMFpCnbqzzDgp50dHiBX5PgS8aUg
         dvFRgZYTzA9ABruXYh/uXgcpCFgp0H4KuXEwH1ilV3GfXL3c0rtAloMhZ3zQNWmukF0u
         3EzSyYCDjNMurXZQdpqAUdS5fzSUt+SbbSe3X9jHEAxU0aiH3gTZJ2/d45Fg3ZA4NtM+
         yWhY0eohv3SNHHFtP9t2Mi1uKP4pYgiYV3i01xDQ60K3HN/yHED3e9+e4tO/h1ImdFHU
         jnV5lofXhgj+HOJ/c+TAlSc6BL02fCV1GZKpkV9FzWprzBfw+gFp2zoezutVAHChGLtA
         VMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4722oNtei3tHBXGwWpb0asIxc2KR2GcXyviu8ZJnGm4=;
        b=YVcQHJbJRoX/R/08n2F1WqjLwvaCyR63Zwfpi2ao3cbYEsv4tNJnWd92n54bFCoUaB
         qlsYhGp1hRp4jNPKAkmesNpMEZzrySpSQKj/Ma0sWAsw5OD3/gAZN0ARfqjcwqjrvfcw
         D/u97GNk4QdLzRBzQCfLjDdUSaP+r0Cn56dmtLUAHo5GtwAM2Qz5vNL7efOeroVGoJwF
         V/c13ED2jpX+epka8vUdWcwVrSbme1cX/fVLwl2UdNkrJbO7/Z1PzsrSy4d/xFb7CnMA
         gcz3T32kZFkjehRCqSAQC7Sy1w8hM2liuAN6YCXWkJKFhjeAKlBTObM3OC+xP3fwD1jF
         H2hw==
X-Gm-Message-State: APjAAAULfcNN3xHvmZkPqJKzmAUKScLBHdk3KVUnEq5wumPqN01vWcmk
        zFhEp9fbBEN2J9s+hF+LaPA3e/MT
X-Google-Smtp-Source: APXvYqyPVKJ5C1c9yGnmcHIxSM/kp0cULXlmd1nLLTjkK3RBBLl/laCKKUN67NKfe+v59xn7Eh1APw==
X-Received: by 2002:a05:600c:22d1:: with SMTP id 17mr4687632wmg.91.1582049636692;
        Tue, 18 Feb 2020 10:13:56 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id h10sm4447157wml.18.2020.02.18.10.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 10:13:56 -0800 (PST)
Subject: Re: Question related to GSO6 checksum magic
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <29eb3035-1777-8b9a-c744-f2996fc5fae1@gmail.com>
 <142527b01cfab091b2715d093f75fc1c1c4aa939.camel@linux.intel.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ce436d3f-6280-6d5b-32ac-f47344481334@gmail.com>
Date:   Tue, 18 Feb 2020 19:13:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <142527b01cfab091b2715d093f75fc1c1c4aa939.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.02.2020 22:01, Alexander Duyck wrote:
> On Tue, 2020-02-11 at 20:48 +0100, Heiner Kallweit wrote:
>> Few network drivers like Intel e1000e or r8169 have the following in the
>> GSO6 tx path:
>>
>> ipv6_hdr(skb)->payload_len = 0;
>> tcp_hdr(skb)->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
>> 				       &ipv6_hdr(skb)->daddr,
>> 				       0, IPPROTO_TCP, 0);
>> (partially also w/o the payload_len assignment)
>>
>> This sounds like we should factor it out to a helper.
>> The code however leaves few questions to me, but I'm not familiar enough
>> with the net core low-level details to answer them:
>>
>> - This code is used in a number of drivers, so is it something that
>>   should be moved to the core? If yes, where would it belong to?
>>
>> - Is clearing payload_len needed? IOW, can it be a problem if drivers
>>   miss this?
>>
>> Thanks, Heiner
> 
> The hardware is expecting the TCP header to contain the partial checksum
> minus the length. It does this because it reuses the value when it
> computes the checksum for the header of outgoing TCP frames and it will
> add the payload length as it is segmenting the frames.
> 
> An alternative approach would be to pull the original checksum value out
> and simply do the checksum math to subtract the length from it. If I am
> not mistaken there are some drivers that take that approach for some of
> the headers.
> 
> - Alex
> 
I submitted a series that adds a helper for what we talked about, see
https://marc.info/?l=linux-usb&m=158197558425809
Status in patchwork is "needs review / ack". Would be great if you could
have a look at it.

Thanks, Heiner
