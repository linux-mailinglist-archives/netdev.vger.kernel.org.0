Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72EE213162B
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 17:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgAFQhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 11:37:31 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46428 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAFQhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 11:37:31 -0500
Received: by mail-pf1-f195.google.com with SMTP id n9so19321136pff.13
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 08:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B54SpMl8Jg6NijMpoV/ttfdLWXtnJiktgmOztXkZ5jY=;
        b=qvYyjs2n9BSRWvXnPQ3cpOgfCpA8tm3271s+6t75t/jDQeTPancxh9M8vkr5/AfKR/
         Bx5Sx7ir3NGDuzJbhXhKIClnF0ZzkKZ9NFj8U2nG8Ehx1WQS3bZiWAy84cDgd88BzqwB
         mTFuPRaMsR0zuaULkBjfdde7EeDVrPanF1Uo+zlQcLVjEMQwMQYtonw5murWRckkp+Oa
         05xHvVqtJJt2E+ld80Z0eA1rOUDc4TVwfDN1uTJTysO6FBraqsGAIfEWLmHwkCBk+qoL
         fkvhlPLGMZjYmQ8MgCbHJuRFK8R2eoaI2BQe4bWyJbKhjqPd9I+eZnhdSk+90Yv0qYNh
         qwqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B54SpMl8Jg6NijMpoV/ttfdLWXtnJiktgmOztXkZ5jY=;
        b=oLKPbGl1Lu5C6Eb1a4z9CygOF9AXkNTPR/g9SozyrZnCoMafBPnzEC0+uMY/G00QBP
         ud+9VoOONNv/5blcAUhBNToPQzk0nFfjvqBr7pBOjwy/+OpPDJKvoW7XrXKuy+CKhKF5
         0Umt9CnjK805HiYjdznvZZiPmLUXzxfX1cnkO0+aWBy+Hy8SU4UZ58tYk+JAOg7MKeQZ
         Wc50FInAfCjO+I+bA8wjrJA7+KnIM1dWGIoveeI+lvpT14TBCwDPUUaoD8SvvV8ueUaU
         EZvOrJL26EI/rhjx7kBP2esZocFMMNeqBgGzH3QcXCbp5FWg3vwEaVX5NSMLpwYZhTYY
         cAFg==
X-Gm-Message-State: APjAAAV0jw8CrAFBpBbc4BCV57kbEG5MneJjwb1De3++UWu5u8G+HW6u
        Fy/RKIHrz8DrQBPwOR7aGUQ=
X-Google-Smtp-Source: APXvYqxzaN9grNdSmEWMBxqGd8IF09MtHUEmEacOItUghKeksMbPsUhSyMGtuLHxHieb37js+7tiMw==
X-Received: by 2002:aa7:8b17:: with SMTP id f23mr111654542pfd.197.1578328650846;
        Mon, 06 Jan 2020 08:37:30 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:25de:66a4:163b:14df? ([2601:282:800:7a:25de:66a4:163b:14df])
        by smtp.googlemail.com with ESMTPSA id x197sm81822955pfc.1.2020.01.06.08.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2020 08:37:30 -0800 (PST)
Subject: Re: [patch net-next 0/4] net: allow per-net notifier to follow netdev
 into namespace
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, saeedm@mellanox.com, leon@kernel.org,
        tariqt@mellanox.com, ayal@mellanox.com, vladbu@mellanox.com,
        michaelgur@mellanox.com, moshe@mellanox.com, mlxsw@mellanox.com
References: <20191220123542.26315-1-jiri@resnulli.us>
 <72587b16-d459-aa6e-b813-cf14b4118b0c@gmail.com>
 <20191221081406.GB2246@nanopsycho.orion>
 <e66fee63-ad27-c5e0-8321-76999e7d82c9@gmail.com>
 <20200106091519.GB9150@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b3fe2a66-baaf-86bb-5347-1ffcaadb3d14@gmail.com>
Date:   Mon, 6 Jan 2020 09:37:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200106091519.GB9150@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/20 2:15 AM, Jiri Pirko wrote:
> 
> I do not follow. This patchset assures that driver does not get
> notification of namespace it does not care about. I'm not sure what do
> you mean by "half of the problem".

originally, notifiers were only global. drivers registered for them, got
the replay of existing data, and notifications across namespaces.

You added code to allow drivers to register for events in a specific
namespace.

Now you are saying that is not enough as devices can be moved from one
namespace to another and you want core code to automagically register a
driver for events as its devices are moved.

My point is if a driver is trying to be efficient and not handle events
in namespaces it does not care about (the argument for per-namespace
notifiers) then something needs to track that a driver no longer cares
about events in a given namespace once all devices are moved out of Only
the driver knows that and IMHO the driver should be the one managing
what namespaces it wants events.

Example:
driver A has 2 devices eth0, eth1. It registers for events ONLY in
init_net. eth0 is moved to ns0. eth1 is moved to ns1. On the move, core
code registers driver A for events in ns0 and ns1.

Driver A now no longer cares about events in init_net, yet it still
receives them. If this is not a big concern for driver A, then why the
namespace only registration? ie., just use the global and move on. If it
is a concern (your point in this thread), you have not solved the
unregister problem.

ie., I don't like the automagic registration in the new namespace.
drivers should be explicit about what it wants.

> 
> 
>> driver cares for granularity, it can deal with namespace changes on its
>> own. If that's too much, use the global registration.

