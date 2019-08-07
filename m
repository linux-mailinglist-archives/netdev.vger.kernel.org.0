Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B93684BCA
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 14:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387433AbfHGMkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 08:40:02 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45851 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfHGMkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 08:40:02 -0400
Received: by mail-ot1-f66.google.com with SMTP id x21so10293464otq.12
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 05:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1LF63m6Z522x+mF2vTQno8mzlSYyS7ItCKpMekRicXY=;
        b=OITIig0enzgIC/vOt+OkDGK6TjEBWRCGJKXikZyEmjw1EqmWER1gMUltWJmCLJwRo/
         W+H519naenKAZa0gQ3ByQ0sBv5Dcxbnf/fVh0I7ejcgmjm/7j4s9vGQoaCGbK3d/mEHe
         RzYr4ZuIOf5o7gcB3Y7EpywiwqaUrtaU3Gkj4YKw86Q/3qUUKtC7MuTjCaL0S47cDXWM
         M4L9AfEt0sfqOBXfASwMcp4Jm+GznTbPuBAqEpDIie6C3nSbodU8uVHwdLUp3955cDa6
         AS4+jXsAy9R9Sby2Sk4LUcETB7ASc+pRhspy17Hs1ENr31Lt0NkBrIgdhXNj+uz+ihVL
         eNTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1LF63m6Z522x+mF2vTQno8mzlSYyS7ItCKpMekRicXY=;
        b=N4YA40ieoPj1YVc0rH2gITVK1wKBvf/7tkodKBePSpTX8+uusPid23PFWpYUvUPn0i
         UO1tQGplpMDOLU7tsiJv6uUskii8S3XiCIgmMooWgyZqcj3u4Y2UY8XlpQn4RD3kai0x
         uSXuF834OkxV43vFXwOr6VyQWjPgbgxURWqc0Gw/f4rp2f2VUc5rLP3HxOJlMO11HfJr
         BqZLMrKvB72bRd4pWNhRV3Oh2CFaBZigEzUysvpLyCRlChqYADzcXBnUrMPutRWSWaol
         ao7cVMrTiPbMBcGpRroR68w4qDmkIPAEduLSa5TlS+tciNqi49Tw6x/HQzivO2WUtWuN
         D4BQ==
X-Gm-Message-State: APjAAAUex66+hcHclZy/e2dooU1Vr1tgaotZ4uY5KaqP2Bvdpct5yklU
        6/9oSu9edew4gx3zqdDwKm3a9pVr
X-Google-Smtp-Source: APXvYqy4Dy/XaDy/y370ckdnrdi6fqlIqg/qzqULuwBMnGje/y3Wi9WF/8hON0yhH0DYt99osJg7yg==
X-Received: by 2002:a02:7f15:: with SMTP id r21mr5514679jac.120.1565181601388;
        Wed, 07 Aug 2019 05:40:01 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:45c:880a:7d5d:4794? ([2601:282:800:fd80:45c:880a:7d5d:4794])
        by smtp.googlemail.com with ESMTPSA id f17sm87193330ioc.2.2019.08.07.05.40.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 05:40:00 -0700 (PDT)
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
To:     Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
References: <20190806191517.8713-1-dsahern@kernel.org>
 <20190806153214.25203a68@cakuba.netronome.com>
 <20190807062712.GE2332@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dd568650-d5e7-62ee-4fde-db7b68b8962d@gmail.com>
Date:   Wed, 7 Aug 2019 06:39:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190807062712.GE2332@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 12:27 AM, Jiri Pirko wrote:
> Wed, Aug 07, 2019 at 12:32:14AM CEST, jakub.kicinski@netronome.com wrote:
>> On Tue,  6 Aug 2019 12:15:17 -0700, David Ahern wrote:
>>> From: David Ahern <dsahern@gmail.com>
>>>
>>> Prior to the commit in the fixes tag, the resource controller in netdevsim
>>> tracked fib entries and rules per network namespace. Restore that behavior.
>>>
>>> Fixes: 5fc494225c1e ("netdevsim: create devlink instance per netdevsim instance")
>>> Signed-off-by: David Ahern <dsahern@gmail.com>
>>
>> Thanks.
>>
>> Let's see what Jiri says, but to me this patch seems to indeed restore
>> the original per-namespace accounting when the more natural way forward
>> may perhaps be to make nsim only count the fib entries where
> 
> I think that:
> 1) netdevsim is a glorified dummy device for testing kernel api, not for
>    configuring per-namespace resource limitation.
> 2) If the conclusion os to use devlink instead of cgroups for resourse
>    limitations, it should be done in a separate code, not in netdevsim.
> 
> I would definitelly want to wait what is the result of discussion around 2)
> first. But one way or another netdevsim code should not do this, I would
> like to cutout the fib limitations from it instead, just to expose the
> setup resource limits through debugfs like the rest of the configuration
> of netdevsim.
> 
> 

This is the most incredulous response. You break code you don't
understand and argue that it should be left broken in older releases and
ripped out in later ones rather than fixed back to its intent.

Again, the devlink resource controller was added by me specifically to
test the ability to fail in-kernel fib notifiers. When I add the nexthop
in-kernel notifier, netdevsim again provides a simple means of testing it.

It satisfies all of the conditions and intents of netdevsim - test
kernel APIs without hardware.
