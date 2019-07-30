Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F51A7AAA2
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbfG3OLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:11:09 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43822 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfG3OLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:11:09 -0400
Received: by mail-io1-f66.google.com with SMTP id k20so128334823ios.10
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w0WXSE7XZiVUIQakspH9Ed3qfCCormJcw/LZBxNg5to=;
        b=OwG+t6CNfnN+SHjeWh6oKEPBozJyFV1E43f7aodz8FtZN5wB+hNrLl/O54IVW8mGLR
         APYzdRAkruf1/7TWGSIgePjsrPt5a0hcEfE65XrXHMOOl2V87R+TZB9CinnKHHq1A4dx
         1rtSHl9LWCgiTNRqMuEXcNn/Oyp5gHyJdQDdF+VRcy+8RF3w7wP9jLLu+wVZekQ1z8PX
         r9Q45gEozGw4JFHRdfVuOsXJkjXA9M5Qxt2OJ1Z7q1z/r3NuQdCiBFlpLaTQ1tOcAXxc
         Yhts+wLTMLHNRS50OHWxWNTPlWelJv1rKYGpAwSBcFK2sufM2kEjpPi0z2pyNP+UIUjL
         MshA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w0WXSE7XZiVUIQakspH9Ed3qfCCormJcw/LZBxNg5to=;
        b=SVDadKH1EJ6H50oi9kZZkcUUuFoT4bbK1my6ggpl4DTja0kln3bsgYrAbak/W9y4yY
         8Oln5evj/i9jT6huSiNOdBWzB9GnqZTZTp13GGbP/mAQgdBRW6PFdX7oNHSjAKbZedsn
         M3poto0wdQI6EiiVgnGiFp3XGZHs/bC7gi9BmqdIlQyXG3F3jScxT9ZmIBBqtZGJRxLF
         Wld0GGotZ3HneLUIz3L4n7+0cO+5VsHnYgx2i6KEHBTmagSTm4Cs/ZJ9q+bhgs56zHpC
         18AzMzIfu+WUKHYSymJN5UNk0ZhtBHhZjN32E4w7ucvlp17CaphEHCA+XBDkf/lo4ffF
         NMzg==
X-Gm-Message-State: APjAAAV3WWdIPRftjzVWn5biCjIgNYkoHdp7yII965tlCKL8uwb8wa4h
        sXJtxSMxXF+8ynYf288YIIyNyDhEK1M=
X-Google-Smtp-Source: APXvYqzfNPpv9meKkF4VqgnXI4EMgGdGUbdKtPPnnYEk7jv2a+8jsSCsUkNzr1Jw7VJG2HkZPHXNxw==
X-Received: by 2002:a02:cc6c:: with SMTP id j12mr75016508jaq.102.1564495867665;
        Tue, 30 Jul 2019 07:11:07 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:48fd:47f6:b7d0:19dc? ([2601:282:800:fd80:48fd:47f6:b7d0:19dc])
        by smtp.googlemail.com with ESMTPSA id s4sm84121727iop.25.2019.07.30.07.11.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 07:11:07 -0700 (PDT)
Subject: Re: net: ipv6: Fix a bug in ndisc_send_ns when netdev only has a
 global address
To:     Mark Smith <markzzzsmith@gmail.com>,
        Su Yanjun <suyj.fnst@cn.fujitsu.com>
Cc:     netdev@vger.kernel.org
References: <CAO42Z2yN=FfueKAjb0KjY8-CdiKuvkJDr2iJdJR4XdKM90HJRg@mail.gmail.com>
 <93c401b9-bf8b-4d49-9c3b-72d09073444e@cn.fujitsu.com>
 <CAO42Z2x163LCaYrB2ZEm9i-A=Pw1xcudbGSua5TxxEHdc4=O2g@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8e63c39f-3117-7446-e204-df076f43a454@gmail.com>
Date:   Tue, 30 Jul 2019 08:11:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAO42Z2x163LCaYrB2ZEm9i-A=Pw1xcudbGSua5TxxEHdc4=O2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/19 4:28 AM, Mark Smith wrote:
> Hi Su,
> 
> On Tue, 30 Jul 2019 at 19:41, Su Yanjun <suyj.fnst@cn.fujitsu.com> wrote:
>>
>>
>> 在 2019/7/30 16:15, Mark Smith 写道:
>>> Hi,
>>>
>>> I'm not subscribed to the Linux netdev mailing list, so I can't
>>> directly reply to the patch email.
>>>
>>> This patch is not the correct solution to this issue.
>>>
> 
> <snip>
> 
>> In linux implementation, one interface may have no link local address if
>> kernel config
>>
>> *addr_gen_mode* is set to IN6_ADDR_GEN_MODE_NONE. My patch is to fix
>> this problem.
>>
> 
> So this "IN6_ADDR_GEN_MODE_NONE" behaviour doesn't comply with RFC 4291.
> 
> As RFC 4291 says,
> 
> "All interfaces are *required* to have *at least one* Link-Local
> unicast address."
> 
> That's not an ambiguous requirement.

Interesting. Going back to the original commit:

commit bc91b0f07ada5535427373a4e2050877bcc12218
Author: Jiri Pirko <jiri@resnulli.us>
Date:   Fri Jul 11 21:10:18 2014 +0200

    ipv6: addrconf: implement address generation modes

    This patch introduces a possibility for userspace to set various (so far
    two) modes of generating addresses. This is useful for example for
    NetworkManager because it can set the mode to NONE and take care of link
    local addresses itself. That allow it to have the interface up,
    monitoring carrier but still don't have any addresses on it.

So the intention of IN6_ADDR_GEN_MODE_NONE was for userspace to control
it. If an LLA is required (4291 says yes, 4861 suggests no) then the
current behavior is correct and if IN6_ADDR_GEN_MODE_NONE is used by an
admin some userspace agent is required to add it for IPv6 to work on
that link.

> 
> This specific, explicit requirement goes as back as far as RFC 2373
> from 1998, the ancestor of RFC 4291. It is also heavily implied in RFC
> 1884s, 2.7 A Node's Required Addresses.
> 
>> And what you say is related to the lo interface.  I'm not sure whether
>> the lo interface needs a ll adreess.
>>
> 
> It is an IPv6 enabled interface, so it requires a link-local address,
> per RFC 4291. RFC 4291 doesn't exclude any interfaces types from the
> LL address requirement.

There is no 'link' for loopback, so really no point in generating an LLA
for it.

