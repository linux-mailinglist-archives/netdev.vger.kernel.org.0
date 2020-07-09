Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D1E2194D7
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 02:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgGIAIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 20:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgGIAIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 20:08:15 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF2CC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 17:08:15 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id j20so200357pfe.5
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 17:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=j1T68WPU1Q0aeLtsir+g+TaJRzzJbPMsVNVzePh8sxs=;
        b=djbzOkJisYcgxf1Dewj4sRK9BG/FnwqG0ELxCWXoVhAsHgh3bci1z3/8R5mwf30uUq
         YO9avQMAqrL2Gjju73prnId065F8HEWJWsrOaJYHOSfqcKU1Y1ltrmLRbsLn5GHC4sa+
         lcK2WfAIFxQowRmR61pLLM/Ltf8+BMpK2j0D63aGWVQss+IsMkVTDfIX88BbxDEXTANe
         yFM8N8wJEjE03tEM7aFZ4vzvZGkxj/ZVDpPmVHCmCF2UeZ+V/DhWV1f6Zeufi8TzyLYi
         DQPqhqEX71cJswtG5ETJQ7ZU4E3SeTscMNpVOk/SeE7ftycEBYYnPsC2aAthvyHY86Ll
         vMDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j1T68WPU1Q0aeLtsir+g+TaJRzzJbPMsVNVzePh8sxs=;
        b=Kde+jFVJR6UZEw5lxd/9IW0/7sn1yYP6erPLq9MDEmt9jXP28/Ty01H+foIuLRR6NK
         y1vz9I4UlpW5gqTF2H6K+oGt5jEXnsvLbEK3pbZumUbZEFPO4ZZ45LDdjuOK6b6LBIxA
         LsxmIHXPUurKPypqpdTjxkS1C9nk2AL/xilZ1f9OU5eu+ayCjFPg6BWE+otPkIUotH0s
         xuK+UEeZBJt7M4jJCGW8CAv3JQiCS1p7V2ZbPBquXdLubQy2l4H6vJgjJxpPhmBmLz6t
         ZAvU6BDQoOvChIlfjP173wfYzF1/SXjUYeZnkBeX6xGqp+F9N90ZO12TaX6Nxi8mPQHY
         Y/CQ==
X-Gm-Message-State: AOAM533kbYuAA1awzL86gvD6MERkxc+ciwuumOroKXwvAoQw6OScYNbf
        5JLbLZXR9NiuvBZgJTV3amqjjzgY
X-Google-Smtp-Source: ABdhPJxcoXtUJ9LFKHoQGilEkgQyKNxkfvTuK2SJzaQNRpYi//HFei2BRWoKUuMRODJGAAjLLWVC4g==
X-Received: by 2002:a65:408b:: with SMTP id t11mr50844334pgp.407.1594253294743;
        Wed, 08 Jul 2020 17:08:14 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p10sm546746pjp.52.2020.07.08.17.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 17:08:14 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
 <554197ce-cef1-0e75-06d7-56dbef7c13cc@gmail.com>
 <d1716bc1-a975-54a3-8b7e-a3d3bcac69c5@alibaba-inc.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <91fc642f-6447-4863-a182-388591cc1cc0@gmail.com>
Date:   Wed, 8 Jul 2020 17:08:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <d1716bc1-a975-54a3-8b7e-a3d3bcac69c5@alibaba-inc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 4:59 PM, YU, Xiangning wrote:

> 
> Yes, we are touching a cache line here to make sure aggregation tasklet is scheduled immediately. In most cases it is a call to test_and_set_bit(). 


test_and_set_bit() is dirtying the cache line even if the bit is already set.

> 
> We might be able to do some inline processing without tasklet here, still we need to make sure the aggregation won't run simultaneously on multiple CPUs. 

I am actually surprised you can reach 8 Mpps with so many cache line bouncing around.

If you replace the ltb qdisc with standard mq+pfifo_fast, what kind of throughput do you get ?

