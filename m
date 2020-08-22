Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C2724E867
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 17:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgHVPpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 11:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbgHVPpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 11:45:35 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE08CC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 08:45:35 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id t7so3944899otp.0
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 08:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BOUMiCXf9j7Wt8uOl48K1yzTZg6ycoY2LCI3OS07QwU=;
        b=RYEZJ7+vYiZXk9huKRDhpEe5/bIaYN7b6sN+feZsU2Si+P1uDBxv6lVE3wPV1ztAFP
         bjezMJHG3S46TfQsy/vSdYqxmreJty4sk3a9idOD69SpPUOANUJa+hpBHnwLBdmM0TXo
         4cdXOB3HlhfQ/yrIKP5xefEFds2FRNkslosQyyifowZ7JFZSA5u1UVgH0nV3b1/MTUOV
         hn8h18/X1LJL54IN/UsBu+052NRH5zl5JMTtm2RMtNEDcrbSuEcIeOyEFIQoZzK9sZnB
         59sdNWLfTKh8QqZ9bAfIBiZuQNTEJ1TROCBrvbydP7Hg4Gp59i9BAC/Q8NPCbeTzaehG
         pB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BOUMiCXf9j7Wt8uOl48K1yzTZg6ycoY2LCI3OS07QwU=;
        b=rbyOwkpfpo4sagvfEGrrVwSgIeD9kp6kcDbKj65RC41SnhlVxt90FnJO0hGBup1L5o
         1ylWqSKKWbyRhQiuz5SgcPnm4XZZwl5nCPhXhkQ0Gxh10HcwXJHDpgFxQpO3DCmivw9K
         BNxMi8eb5bASYHfrnfweWP6CGXo/N+tvAcVuB0quAeUtg8BolWfmM7RhPqLfg/O9LC96
         HSkYN6+P8F2+w9idaYxoREgR9txPRjzKfJUB6WCVAJ40q5jvZr+fGWx7VYJXzPb3DLrp
         Zv3SD/g3WSMnB/lrFN8QlBOVVwvW6LuqgfL/V4dSnAKNyYly3L7lIkyM3wcsbdjQiLYH
         V6KQ==
X-Gm-Message-State: AOAM530DQjzZaUBEe8QsaTLF5oMnVOe06F8VfKUAWWLWytx54MIUj7T5
        EPXu0MXionDPY6OGS9f6sOU=
X-Google-Smtp-Source: ABdhPJyTKEfbC9AHlbf4MivzlLGBeWpIYZs5IQUBN/OW06XMV3Bv7y2pF9afGp5u/zarC0bZilGJvA==
X-Received: by 2002:a9d:ed0:: with SMTP id 74mr5186078otj.269.1598111135144;
        Sat, 22 Aug 2020 08:45:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:284:8202:10b0:a888:bc35:d7d6:9aca])
        by smtp.googlemail.com with ESMTPSA id 95sm189330otw.26.2020.08.22.08.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2020 08:45:34 -0700 (PDT)
Subject: Re: [PATCH net v2] net: nexthop: don't allow empty NHA_GROUP
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        syzbot+a61aa19b0c14c8770bd9@syzkaller.appspotmail.com
References: <20200822103340.184978-1-nikolay@cumulusnetworks.com>
 <20200822120636.194237-1-nikolay@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <197f8d43-d6fa-e701-92ba-81148fc139a5@gmail.com>
Date:   Sat, 22 Aug 2020 09:45:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200822120636.194237-1-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/20 6:06 AM, Nikolay Aleksandrov wrote:
> Currently the nexthop code will use an empty NHA_GROUP attribute, but it
> requires at least 1 entry in order to function properly. Otherwise we
> end up derefencing null or random pointers all over the place due to not
> having any nh_grp_entry members allocated, nexthop code relies on having at
> least the first member present. Empty NHA_GROUP doesn't make any sense so
> just disallow it.
> Also add a WARN_ON for any future users of nexthop_create_group().
> 

...

> 
> CC: David Ahern <dsahern@gmail.com>
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Reported-by: syzbot+a61aa19b0c14c8770bd9@syzkaller.appspotmail.com
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
> Tested on 5.3 and latest -net by adding a nexthop with an empty NHA_GROUP
> (purposefully broken iproute2) and then adding a route which uses it.
> 
> v2: no changes, include stack trace in commit message
> 
>  net/ipv4/nexthop.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

Thanks, Nik
