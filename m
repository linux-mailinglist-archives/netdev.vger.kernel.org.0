Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA70252E66
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 14:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgHZMNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 08:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729864AbgHZMND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 08:13:03 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C5BC061574;
        Wed, 26 Aug 2020 05:13:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id q14so1552638wrn.9;
        Wed, 26 Aug 2020 05:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=moFYsbC846LP1g5s/UEInDQ9XX1XjMRNrZrZCmJ3G1E=;
        b=d4tdmmS7mLH6wb0Ad9FaA154xnrjsqFP5axJ5Gfa8VP0TfsKdTeT5jFEaRoRjdRsOO
         Oe7Yn7kM71WqpQyzPc0uftt/CbTA7X1VJs9HBsITXrF3P4We8+pwjv9Zu6CEp4sBr5hG
         7WinhWLGdwyUFA5UJVgn1RdJqL2NmeXko7VCWsTpJ4IA4MH81zX0AubFt3Y2fbP7WWs6
         zsquuNr7uQENJWKOq5T3X0v+wVEo8+xmrwXgiRvB3kNHQ0M6GcI+vLnDMgGslGzxdHJt
         M43GeaRxp89nq1wu+mU6nS9Bbbz7qxXA6OYRQf+Xy9niW7ANEx8fp44CzqOB9KQWfRuV
         H0Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=moFYsbC846LP1g5s/UEInDQ9XX1XjMRNrZrZCmJ3G1E=;
        b=gCuop3w6he+3oCEvPxf6fORB79qXjMFgw6e2Tp91mqYGgw6SdttytWxwkUOa3yoXAW
         P/th871UjXWqX30R7z7wQeyFdYI7jL9GVL9UUJxZ5rrRPPDMxBUsHFeRaXKZOQWQ/8RX
         AIrQ36baRSEE3WsMEvGOjKtRw/LX1C1JNpLgLglSnmaWqsYoQvcbJWXP9m0YCfPJMqIt
         GnwYCXsaUaoEc18cOgUxYkJBtiliaLG+RB/tu+yU3Lpc4nZlxyCNf5EosYpk8qGTQlhR
         W5L7q5+Fs/RAI5grf5qhzvhIYaLA724oYnsVJOImi8j5PaC5YTwawW+ybg+/D+ge7BPN
         QA/A==
X-Gm-Message-State: AOAM533KfYKsDZlcZhOiZpUHJkFq5bFHwI8mclh2aGkn+cNkCtiiDA5F
        Jb9uDn9eEDxwn3nF8uIVtqc=
X-Google-Smtp-Source: ABdhPJyDfDAHIaoOc7H8/lHZUnbWL+KeSH8e4U0TKTxtxE+/o5a/KwnrIwO7Rx8HaxYlC8TAXtJqIQ==
X-Received: by 2002:a5d:574e:: with SMTP id q14mr4916236wrw.281.1598443981771;
        Wed, 26 Aug 2020 05:13:01 -0700 (PDT)
Received: from [10.55.3.147] ([173.38.220.45])
        by smtp.gmail.com with ESMTPSA id q6sm5470867wma.22.2020.08.26.05.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 05:13:01 -0700 (PDT)
Subject: Re: [net-next v5 1/2] seg6: inherit DSCP of inner IPv4 packets
To:     David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     andrea.mayer@uniroma2.it
References: <20200825160236.1123-1-ahabdels@gmail.com>
 <efaf3273-e147-c27e-d5b8-241930335b82@gmail.com>
 <75f7be67-2362-e931-6793-1ce12c69b4ea@gmail.com>
 <71351d27-0719-6ed9-f5c6-4aee20547c58@gmail.com>
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
Message-ID: <ab0869f7-9e69-b6fd-af5c-8e3ce432452b@gmail.com>
Date:   Wed, 26 Aug 2020 14:12:59 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <71351d27-0719-6ed9-f5c6-4aee20547c58@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 26/08/2020 02:45, David Ahern wrote:
> On 8/25/20 5:45 PM, Ahmed Abdelsalam wrote:
>>
>> Hi David
>>
>> The seg6 encap is implemented through the seg6_lwt rather than
>> seg6_local_lwt.
> 
> ok. I don't know the seg6 code; just taking a guess from a quick look.
> 
>> We can add a flag(SEG6_IPTUNNEL_DSCP) in seg6_iptunnel.h if we do not
>> want to go the sysctl direction.
> 
> sysctl is just a big hammer with side effects.
> 
> It struck me that the DSCP propagation is very similar to the TTL
> propagation with MPLS which is per route entry (MPLS_IPTUNNEL_TTL and
> stored as ttl_propagate in mpls_iptunnel_encap). Hence the question of
> whether SR could make this a per route attribute. Consistency across
> implementations is best.
>SRv6 does not have an issue of having this per route.
Actually, as SRv6 leverage IPv6 encapsulation, I would say it should 
consistent with ip6_tunnel not MPLS.

In ip6_tunnel, both ttl and flowinfo (tclass and flowlabel) are provided.

Ideally, SRv6 code should have done the same with:
TTL       := VLAUE | DEFAULT | inherit.
TCLASS    := 0x00 .. 0xFF | inherit
FLOWLABEL := { 0x00000 .. 0xfffff | inherit | compute.

>> Perhaps this would require various changes to seg6 infrastructure
>> including seg6_iptunnel_policy, seg6_build_state, fill_encap,
>> get_encap_size, etc.
>>
>> We have proposed a patch before to support optional parameters for SRv6
>> behaviors [1].
>> Unfortunately, this patch was rejected.
>>
> 
> not sure I follow why the patch was rejected. Does it change behavior of
> existing code?
>

The comment from David miller was "People taking advantage of this new 
flexibility will write applications that DO NOT WORK on older kernels."

Perhaps, here we can a bit of discussion. Because also applications that 
leverage SRv6 encapsulation will not work on kernels before 4.10. 
Applications that leverage SRv6 VPN behvaiors will not work on kernels 
before 4.14. Applications that leverages SRv6 capabilites in iptables 
will not work on kernels before 4.16.

So when people write an application they have minimum requirement (e.g., 
kernel 5.x)

I would like to get David miller feedback as well as yours on how we 
should proceed and I can work on these features.

> I would expect that new attributes can be added without affecting
> handling of current ones. Looking at seg6_iptunnel.c the new attribute
> would be ignored on older kernels but should be fine on new ones and
> forward.
> 
> ###
> 
> Since seg6 does not have strict attribute checking the only way to find
> out if it is supported is to send down the config and then read it back.
> If the attribute is missing, the kernel does not support. Ugly, but one
> way to determine support. The next time an attribute is added to seg6
> code, strict checking should be enabled so that going forward as new
> attributes are added older kernels with strict checking would reject it.
> 
