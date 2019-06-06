Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960EE38131
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfFFWrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:47:04 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40574 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbfFFWrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:47:03 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so17793pla.7
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 15:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VlvxfZ7xE+qTJw5yk4wXY0WeYbAQ1gN/1ZVsmv6gPCU=;
        b=GyNXRbzAe4HMcJeWNj8RdNTv2w1e3n6ctMtGv27RC55adLZZ+OJ1K+aJwzRJut0gJo
         6jPTzf7Q9X/czUAwmetp787gqZfE775CIOqHs1Kn5ob39bUZYVuqfWYWQRCQF0nB92pn
         QAvdlkylRBBPKRxvMLXkbcZd7Dldrs6hrBmLJtKHsY2qVj8+v4WFxau/voaA5Q73yeyp
         JiHZYj6z+Wupcs4qO6JLbDWh67BxgeCD6MEOHSpw2sZMNHnBw70b4uxM81mWECOncek+
         hl1E7UMud0ZqY9hdp2Y5HtgYJXdc0prtY2QzF5UuPH/ZWGIzTKupgY/f8zfEmekCBoGV
         t+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VlvxfZ7xE+qTJw5yk4wXY0WeYbAQ1gN/1ZVsmv6gPCU=;
        b=B1Sj4V5e5sKTpYKZJrUhxCo0ikvldGzrvYMujvW/ifpqXL4C9/hYnhfjIYkU4scy/4
         GPU8LjZS2NGDM2yIv+LC55MhZVAKExgHtRJmdf9aQWrZGL01sYG0bzhCJ5PWclyI1X8+
         4qUZvR2VNsd0hx5fnaIfrDxqnARFPdaW79++FfI3DL8vJovRjFZL56w3K8Mgii4/sPBR
         XFQkisNdNZP/zgXd/avrIAf3oZ88/ODlJGrn50HuiLXto7k+jPAMYUqPsdLCSGSkcbei
         UGUUuOHT90aTv6mA2Ers9GLpHIXkGRfZnBHtkc+hvIDtaeacWGfNRrb5bqJPG2i1psR5
         MIYg==
X-Gm-Message-State: APjAAAVotD/qJsH3XsNR8F8fwQen1fWWNrM3yoFVvhiHSeGc0/EOA+qb
        25zaA2u+Sa0cFHIZZ43DVKXlEmNWqYc=
X-Google-Smtp-Source: APXvYqys/gSNBSWBiL5EatHVLxv+0XRNavT7wK3hE87pp25QHa5tyuYA3YguY+CNPizkjPQyrqg2Ww==
X-Received: by 2002:a17:902:102c:: with SMTP id b41mr3446360pla.204.1559861222946;
        Thu, 06 Jun 2019 15:47:02 -0700 (PDT)
Received: from [172.27.227.250] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id t124sm172160pfb.80.2019.06.06.15.47.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 15:47:02 -0700 (PDT)
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
References: <cover.1559851514.git.sbrivio@redhat.com>
 <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
 <fbe7cbf3-c298-48d5-ad1b-78690d4203b5@gmail.com>
 <20190606231834.72182c33@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <05041be2-e658-8766-ba77-ee01cdfe62bb@gmail.com>
Date:   Thu, 6 Jun 2019 16:47:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190606231834.72182c33@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/19 3:18 PM, Stefano Brivio wrote:
> On Thu, 6 Jun 2019 14:57:33 -0600
> David Ahern <dsahern@gmail.com> wrote:
> 
>>> This will cause a non-trivial conflict with commit cc5c073a693f
>>> ("ipv6: Move exception bucket to fib6_nh") on net-next. I can submit
>>> an equivalent patch against net-next, if it helps.
>>>   
>>
>> Thanks for doing this. It is on my to-do list.
>>
>> Can you do the same for IPv4?
> 
> You mean this same fix? On IPv4, for flushing, iproute2
> uses /proc/sys/net/ipv4/route/flush in iproute_flush_cache(), and that
> works.
> 
> Listing doesn't work instead, for some different reason I haven't
> looked into yet. That doesn't look as critical as the situation on IPv6
> where one can't even flush the cache: exceptions can also be fetched
> with 'ip route get', and that works.
> 
> Still, it's bad, I can look into it within a few days.
> 

I meant the ability to dump the exception cache.

Currently, we do not get the exceptions in a fib dump. There is a flag
to only show cloned (cached) entries, but no way to say 'no cloned
entries'. Maybe these should only be dumped if the cloned flag is set.
That's the use case I was targeting:
1. fib dumps - RTM_F_CLONED not set
2. exception dump - RTM_F_CLONED set
