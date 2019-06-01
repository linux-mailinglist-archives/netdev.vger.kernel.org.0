Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B29F31910
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 04:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfFACib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 22:38:31 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44422 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfFACib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 22:38:31 -0400
Received: by mail-pg1-f196.google.com with SMTP id n2so5019818pgp.11
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 19:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f/LmFdMx4pFU8BT/jdIEKQ3okQ8GXiXd3SGx/YxIvlk=;
        b=qQ+bl2DVh7PVKmInhCfCUxjh/NkVCTtRUz5rpEf9TXkQUAxFSWAg5fUTrWo+SUPwWu
         LoItM3w5K492xtgfd5kA3Qv0KzvVDxZ6s5gd+fYw6g7zodhwbyYRDxK44cpLo5L9xOo2
         vSle6X3yCOSRRRPgJ4aOx0goJkVN22eYK8Vp//6EqjhxcHl6GXAfybpwio9PLFKDZLjT
         nYyTXU5e1Xqr4frliLmhEAkDQpXenyNYpHHjzR26GYAzJm1BMV89nV+GbHH0OMy9TPnr
         H9Ahrs8t4I3sHlPUdyP0wcsER7v3YFvwpLHm+paQCmTmhRdZsmTWnNcSC1EnSf3YoEX+
         MPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f/LmFdMx4pFU8BT/jdIEKQ3okQ8GXiXd3SGx/YxIvlk=;
        b=eNRZB0D1Ps4kBqL5dR1IEwFQcDx1vlOytC4RYVuwpFGkWIe4/rkDQWCnc9THPNhAFY
         BGkbVYsC4BzGAY3WewkC4yswSPZ82++j3aAONxLlBNrL2adw//T5RsiUgwU0qXmpyqQz
         jgVwp9Lv/hhpIR0E8RxI+PSOm5uC/atllpCuR3cDHX2sC+osqLojQnPcZ4YhN3qdMSu+
         /c3EjutyBy6SHN7NxAB7CWX9gv/DuvbW1l8aZJdsxUJEx5bZ7FtHSCvyC6KAlAnhblJB
         jDN48NZhsWwNam+EXYlujpzLwMlrErDC/sq5DRPe3G//9xscb8WRYWBEm3iKncywFsj3
         hb2Q==
X-Gm-Message-State: APjAAAVSrrMp0EqOuCWU7vtenO79MFYlNSgbLSOk2BDqVh6y2ncLHTLJ
        /u0LVBzIruwg0mvEQZlZ3qg=
X-Google-Smtp-Source: APXvYqzoGk2+7srsp511ZPmuqF3LkyZ8BWH0h9QALrDFCav5jJ/yvpEM4U8Z7tAegm9GgaZxg7puzQ==
X-Received: by 2002:a63:f64e:: with SMTP id u14mr10306589pgj.107.1559356710326;
        Fri, 31 May 2019 19:38:30 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id p63sm8545111pfb.70.2019.05.31.19.38.28
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 19:38:29 -0700 (PDT)
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        alexei.starovoitov@gmail.com
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, idosch@mellanox.com,
        saeedm@mellanox.com, kafai@fb.com, weiwan@google.com
References: <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
 <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com>
 <CAADnVQ+KqC0XCgKSBcCHB8hgQroCq=JH7Pi5NN4B9hN3xtUvYw@mail.gmail.com>
 <20190531.142936.1364854584560958251.davem@davemloft.net>
 <ace2225d-f0fe-03b3-12ee-b442265211dd@gmail.com>
 <68a9a65c-cd69-6cb8-6aab-4be470b039a8@gmail.com>
 <9f57c949-66b6-20d9-2cab-960074616e71@gmail.com>
 <b044ed92-28b3-4743-db87-db84f0c8606b@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <84ec7694-bfa7-97a4-5a35-96a65d305fa5@gmail.com>
Date:   Fri, 31 May 2019 19:38:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b044ed92-28b3-4743-db87-db84f0c8606b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/31/19 7:34 PM, Eric Dumazet wrote:
> 
> 
> On 5/31/19 7:29 PM, David Ahern wrote:
>> On 5/31/19 7:04 PM, Eric Dumazet wrote:
>>>
>>> I have a bunch (about 15 ) of syzbot reports, probably caused to your latest patch series.
>>>
>>> Do we want to stabilize first, or do you expect this new patch series to fix
>>> these issues ?
>>>
>>
>> Please forward. I will take a look.
>>
> 
> I will release one of them, I suspect they are duplicates.
> 
> This is why I was looking at rt6_get_pcpu_route()
> 
> I thought we were lacking a READ_ONCE() but this does not seem needed.
> 
> https://patchwork.ozlabs.org/patch/1108632/
> 

I will release a second report, please not they are no repro yet.
