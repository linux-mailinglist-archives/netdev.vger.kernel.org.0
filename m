Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900805065E2
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 09:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349397AbiDSHcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 03:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349399AbiDSHcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 03:32:23 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC67C329BE
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 00:29:40 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id ay36-20020a05600c1e2400b0038ebc885115so544886wmb.1
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 00:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst.fr; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iPg4GAXhj4CWyp1VfgiAr0TxQ5d3+sxUJDJLVeV60no=;
        b=h1fB/R87kv6DeYZJY/lvfyS+u/WhMqwlqQyq846AEEQaZUM0cZ+OJTpjgqqsIAe0oW
         g5MnpGUWIK/7aeMBuXU51yDHXKzD6qjGQli/VxUMZnnxC2EkysgEWuIT5H4kagJFV4kU
         0QPv3LOe8tNeBa0tccv8U1lioCNkWWalbuYH14UDV9BHMejMY7BDRUx/CP1pRsSsMztA
         6ShW64/gSQgU5BVPojbroDbjUTe7estuQPCCtVMbjzqFzp6cz10f7V2vlivM4SEMUJXd
         s74OBKJtrZZEVuY1QTq44HbOrFBX3ndMoDJ89makbtOuIT8YeD/DlXvNyT8bSMN+62bg
         NpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iPg4GAXhj4CWyp1VfgiAr0TxQ5d3+sxUJDJLVeV60no=;
        b=DQMXvf/c7WAX0M978s6UoRCkrAo4M3GKJG9N0Ksnm0jMpF++0/8Jx6wng6YgKxawZP
         PQQAu+CVwSIB3336DHK3V1DUrZHZBH3TNuq4XjnSmLappSmSeCdAQqeOstLOJoNgOMJ/
         NF0mfM9jPmKpOg2gbi+cQoI9WnDwbU3Og9zk9v3+ujQkUAenYOoh+a3ZBJTzK26Byf7Z
         vHKIscfR3tywF9KW4K54FFu/Y+l0ubTQeVREMPwDLMnfDPTFV0g8sTjwQXULf/H5TUhg
         /5soTpzyq7IfgPcaFmM6wIJkxdTcW38m0NU4gdFJvdyG3l+kDxqS2hIjwfppSMR3oMNy
         KsDA==
X-Gm-Message-State: AOAM530ZhxNlNA+y9K0ddH+7aGkDqA5ZC/9buuzGadaprj48EBnl4X6Q
        zGJrEuyGsByo3mXHWtG4uKELXQ==
X-Google-Smtp-Source: ABdhPJwrEMJBCve8f9P/zsP/ooKICAp+w4oydl4NMWE9TCcFoBKXRM839c+GRxKJvsrZwTpNVEWSkg==
X-Received: by 2002:a05:600c:1c1f:b0:38e:c425:5b1a with SMTP id j31-20020a05600c1c1f00b0038ec4255b1amr14669826wms.69.1650353379026;
        Tue, 19 Apr 2022 00:29:39 -0700 (PDT)
Received: from [10.4.59.131] (wifirst-46-193-244.20.cust.wifirst.net. [46.193.244.20])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c3b1500b003928f20b7besm7897855wms.42.2022.04.19.00.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 00:29:38 -0700 (PDT)
Message-ID: <d63921e9-2306-a153-48fe-a1f65157aafa@wifirst.fr>
Date:   Tue, 19 Apr 2022 09:29:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 net-next 1/4] rtnetlink: return ENODEV when ifname does
 not exist and group is given
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Brian Baboch <brian.baboch@wifirst.fr>
References: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
 <20220415165330.10497-2-florent.fourcot@wifirst.fr>
 <20220415122432.5db0de59@hermes.local>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
In-Reply-To: <20220415122432.5db0de59@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,


>> +		if (link_specified)
>> +			return -ENODEV;
> 
> Please add extack error message as well?
> Simple errno's are harder to debug.


What kind of message have you in mind for that one? Something like 
"Interface not found" does not have extra information for ENODEV code.

At this place, one gave interface index or interface name, and nothing 
matched.


Thanks,

-- 
Florent Fourcot.
