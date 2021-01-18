Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B80E2FAD9B
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390871AbhARW4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390779AbhARW42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 17:56:28 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EFFC061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 14:55:48 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id 15so19303394oix.8
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 14:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=++t0weJ0eGGG2lvfHIvbpFBaKhkeutcMrpKfJR3mZFc=;
        b=ovzlwnTG9zusxi3X/BNn7x2smDBtnMWr1rrOi9gc7kMircqW8n0htXkuzCX6mQYa+I
         o5t3PLMhOOawlTwTsNdTDMxBzq5c4cfmL1GT2JEUeoW7G8twcwRY1gIyUViAubR25r5g
         9Is1LJ96F306wnhrl0jeVr1eifIUSfeqX3OUskSR5ZeYSX6rt5c/OEMv74HHssaraoIq
         0OeDBOZYS/Cjk2f3Pbn+YvxgC5T3aexi7efRdhuwcPDwznLBDQfJel6k4JOJLtF61O4b
         3XZcPeKbymYXNbXdC1KAnKGyTJZkbJQGzBsE6wXugdU/SpQWml+LjyF6V1XmytLE0jbN
         6Aig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=++t0weJ0eGGG2lvfHIvbpFBaKhkeutcMrpKfJR3mZFc=;
        b=DrPLKECsJS+gcMRMs0enpbdpQDFad5QxlD5T84frfuaTz1n9yZ38awB1a6ke1nFLXB
         moyAEmxavUr63M9Xcs6ShS4W0gN0lar5DOyVNhh9HOlDe8qIN9ZQ4fwkytnDtQ8eIxXK
         0RFWJORvowLMJh8sbSL/dhm7sdSQ+8EJh3gHw5s+x78Jb6059dcJ5yK9PwX+2GzCM12i
         bnOiFAiRnYRBX/XwDum48azfZdr6URJyBcQqQ/0Ga8diCunwKNms4GyBb/tuj5gxoGmi
         5rn2MY7MYREsZtG6KR3KDHzZWAnHr9bGhIetdpKG8veU6WbTvjzxlAhCRlrBNYVGDNhO
         XMHQ==
X-Gm-Message-State: AOAM531hjAKVQZ2INXY4A26gqjywKd13M5vQk5SDHZj02VSnJkoYdASv
        1854UYsWGEAHlDInfX3GMVE=
X-Google-Smtp-Source: ABdhPJz6zSScR1Td7AEOw8NastCmzwGNTtxcLM09j/p4HiPohcSVSNUUYIG2YvIpTMQnf1UhO0+4eg==
X-Received: by 2002:a05:6808:a90:: with SMTP id q16mr905405oij.107.1611010547739;
        Mon, 18 Jan 2021 14:55:47 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.224])
        by smtp.googlemail.com with ESMTPSA id s24sm3554609oij.20.2021.01.18.14.55.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 14:55:47 -0800 (PST)
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114074804.GK3565223@nanopsycho.orion>
 <20210114153013.2ce357b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210115143906.GM3565223@nanopsycho.orion>
 <20210115112617.064deda8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210118130009.GU3565223@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2d9674de-9710-3172-3ff7-073634ad1068@gmail.com>
Date:   Mon, 18 Jan 2021 15:55:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210118130009.GU3565223@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 6:00 AM, Jiri Pirko wrote:
> 
>> Reconfiguring routing is not the end of the world.
> Well, yes, but you don't really want netdevices to come and go then you
> plug in/out cables/modules. That's why we have split implemented as we

And you don't want a routing daemon to use netdevices which are not
valid due to non-existence. Best case with what you want is carrier down
on the LC's netdevices and that destroys routing.

> do. I don't understand why do you think linecards are different.

I still don't get why you expect linecards to be different than any
other hotplug device.
