Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE0C23D6F9
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 08:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgHFGnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 02:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgHFGnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 02:43:12 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30736C061574;
        Wed,  5 Aug 2020 23:43:11 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z18so39292106wrm.12;
        Wed, 05 Aug 2020 23:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=46ceznf8owg3s+9NXjpM+2fx/1Tzs0h2vk3bq2eXF5Y=;
        b=NBq6G2HtRLOhigjZvBcapT0e6ZDZndnZ9JxRXY2wmvxGRm08XiFcmmLI+1EaM6lUWu
         d5bPfa7bWn+r4wFAl8QCpqE9DcQ/hLvDKwy+PVZM8aTfLL2me3VzjuirayqTMthN+jNV
         e0T5MpMnkbhmOBXXZsrurSg0Acbubp00avvhOa+GGxIpyP9UKdRduTPyvwvF+dziGhM6
         x3+hMMQ1iao3AZ6ho+HaVCtxwMirT98P9EvzKvEzn4sv8gYILdNK7YyBe4tqTBedSVjw
         pUzbjYGiwY/beqgBlwE7yJ7QQrc7R46kf4tZN71ya4rzUtF5HJ0NOUqmJwwfpMrJg/f6
         C3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=46ceznf8owg3s+9NXjpM+2fx/1Tzs0h2vk3bq2eXF5Y=;
        b=K6+jCTfc4NH6tyaN27rsIhSMwpA0bk3V4fvYJHksL45KiGe7eSBQtsZKYuHylchQx8
         R8pAWx22ufRBnwvCdiY+4fsYUoRZVtyYXhr/P7lT3PohxaBAlIyRt393Lky0EpNA9XTR
         vdEaTsp9pZWEY3YS7g8Vl1y8je4xYlhtTj9vrM8hA5RitugKdvns1Xcs/VLKh5EIbheS
         s3UMlKR9dqNMuxEuFCXsi/YN8mfBmR/lAYTIkKe3KfE+R1w4kIy5aZIw4UU5Wz7pQ3HD
         xdxTT5UQLmuwlT93DKQdyWBwfecEQ8QOpgP4TMBV37APYKlvpNPfQo1kByfCNl7HYv8C
         57qg==
X-Gm-Message-State: AOAM530dHhfLDkHpSE51mlNTmDt3kz3yCtGv0bhwn6X3WdEvGYb5AK2o
        N5q+fTzYXY54SvT1/1/4sc4=
X-Google-Smtp-Source: ABdhPJye8C37Sx0qqiJv6SzW3H9qWEUK13htKqhKpm4l+PD6kzn0IUxj9AOwz6xO6vMJPqOd0IhhbQ==
X-Received: by 2002:a5d:4603:: with SMTP id t3mr6382527wrq.175.1596696189840;
        Wed, 05 Aug 2020 23:43:09 -0700 (PDT)
Received: from [10.55.3.148] ([173.38.220.41])
        by smtp.gmail.com with ESMTPSA id p15sm5237192wrj.61.2020.08.05.23.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 23:43:09 -0700 (PDT)
Subject: Re: [PATCH] seg6: using DSCP of inner IPv4 packets
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
References: <20200804074030.1147-1-ahabdels@gmail.com>
 <20200805.174049.1470539179902962793.davem@davemloft.net>
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
Message-ID: <7f8b1def-0a65-d2a4-577e-5f928cee0617@gmail.com>
Date:   Thu, 6 Aug 2020 08:43:06 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200805.174049.1470539179902962793.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

SRv6 as defined in [1][2] does not mandate that the hop_limit of the 
outer IPv6 header has to be copied from the inner packet.

The only thing that is mandatory is that the hop_limit of the inner 
packet has to be decremented [3]. This complies with the specification 
defined in the Generic Packet Tunneling in IPv6 [4]. This part is 
actually missing in the kernel.

For the hop_limit of the outer IPv6 header, the other SRv6 
implementations [5][6] by default uses the default ipv6 hop_limit. But 
they allow also to use a configurable hop_limit for the outer header.

In conclusion the hop limit behavior in this patch is intentional and in 
my opnion correct.

If you agree I can send two patches to:
- decrement hop_limit of inner packet
- allow a configurable hop limit of outer IPv6 header


[1] https://tools.ietf.org/html/rfc8754
[2] 
https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming-16
[3] 
https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming-16#section-5
[4] https://tools.ietf.org/html/rfc2473#section-3.1
[5]https://github.com/FDio/vpp/blob/8bf80a3ddae7733925a757cb1710e25776eea01c/src/vnet/srv6/sr_policy_rewrite.c#L110
[6] 
https://www.cisco.com/c/en/us/td/docs/routers/asr9000/software/asr9k-r6-6/segment-routing/configuration/guide/b-segment-routing-cg-asr9000-66x/b-segment-routing-cg-asr9000-66x_chapter_011.html#id_94209


On 06/08/2020 02:40, David Miller wrote:
> From: Ahmed Abdelsalam <ahabdels@gmail.com>
> Date: Tue,  4 Aug 2020 07:40:30 +0000
> 
>> This patch allows copying the DSCP from inner IPv4 header to the
>> outer IPv6 header, when doing SRv6 Encapsulation.
>>
>> This allows forwarding packet across the SRv6 fabric based on their
>> original traffic class.
>>
>> Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>
> 
> You have changed the hop limit behavior here and that neither seems
> intentional nor correct.
> 
> When encapsulating ipv6 inside of ipv6 the inner hop limit should be
> inherited.  You should only use the DST hop limit when encapsulating
> ipv4.
> 
> And that's what the existing code did.
> 

