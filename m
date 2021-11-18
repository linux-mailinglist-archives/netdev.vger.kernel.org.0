Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B03455398
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 04:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242846AbhKRECX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241854AbhKRECS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 23:02:18 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038C6C061570;
        Wed, 17 Nov 2021 19:59:19 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so8612150otj.7;
        Wed, 17 Nov 2021 19:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3csdrUkEiqgecODjgMVvXkfgX1bYlCv03T1npf4OHH4=;
        b=gDvuLzNGjaCPJ7s1a6QCESsQCXzqPoYd1Z3y+cVqnPFweZ3KF9mK97h5q5ygwLQ2dm
         fSXvOr4Yk77x+ldNzGbykfaypOQS7ox4FG8XOT4fH/IZhwihbZxIVX8e410odQ+RN5lv
         l34z2DfVhW2x4tCNqiBdJ5yvVt9JaEjpq7DDDln9ddJCNPUgp9lHaa+9jbrz7t5bCFve
         /UZpqaG5Gocks7ISVx9borl14M48QDQe0XlFoGIuZBCrNRUcQTD3c/XZkfbJ0f6qQL3p
         gfpGST5i3XiIbzbSMN7xk/jRG9C9OXJswI+5rD+lRs4oCDRI+o5xkGhT+9jb0CazvuL4
         woCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3csdrUkEiqgecODjgMVvXkfgX1bYlCv03T1npf4OHH4=;
        b=0cTMi2a0zIE6imtPw7qZd9qaGqD+cI84x0WavX+GyZCpNLM/gUNcYJdbww/ep6AhXl
         BkPlJ8lF2mFr/MDoR89W/Z5IU7Iu6fEnes2HDGweo4xUmw8bRu1Q/ZXDETDVODOlw+fP
         aC/hI/3QcwFsZF752nFNIsWBiFc8azQAO1Vw6GWLAZWz5okW34+BXcFD0P2spm1I9t2n
         wJZzY+MHa0jjQXYRC3zzTsSRA+EURn9/l6Ew2a/F8F76B52+wdgurLP1TGGab1xbyfU/
         VCVPJBEoDnpllNdw2rPLNlw3M4HFmWNBgGFMlvn3HXMrdHarJYS6kOVbHLWI91zAG5+R
         Z2Fw==
X-Gm-Message-State: AOAM530EDM42EkBlQisTBQqT6YLpLR/BqO/QpsTp9n/CgutImTtT6Bw6
        vxz3qCksOWpsa5QUeb5vYZI=
X-Google-Smtp-Source: ABdhPJzs0eduI9P6BQMig5j96CAcJULB4ZP4FJyPapS0yAtaB366OwMbMT+Amrd3AQBpr8dGyLx7Bw==
X-Received: by 2002:a05:6830:2681:: with SMTP id l1mr18676407otu.378.1637207958396;
        Wed, 17 Nov 2021 19:59:18 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id t14sm389292oth.81.2021.11.17.19.59.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 19:59:17 -0800 (PST)
Message-ID: <a8d9f99d-8aa8-3186-fcca-c0f7b7f37327@gmail.com>
Date:   Wed, 17 Nov 2021 20:59:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2] ipv4/raw: support binding to nonlocal addresses
Content-Language: en-US
To:     Riccardo Paolo Bestetti <pbl@bestov.io>,
        Denis Kirjanov <dkirjanov@suse.de>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <CFSH0AY7X60L.1KW9K4CV82NQG@enhorning>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CFSH0AY7X60L.1KW9K4CV82NQG@enhorning>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/21 5:14 PM, Riccardo Paolo Bestetti wrote:
>>> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
>>> index 1e44a43acfe2..e540b0dcf085 100644
>>> --- a/net/ipv4/ping.c
>>> +++ b/net/ipv4/ping.c
>>> @@ -311,15 +311,11 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
>>>   		pr_debug("ping_check_bind_addr(sk=%p,addr=%pI4,port=%d)\n",
>>>   			 sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port));
>>>   
>>> -		if (addr->sin_addr.s_addr == htonl(INADDR_ANY))
>>> -			chk_addr_ret = RTN_LOCAL;
>>> -		else
>>> -			chk_addr_ret = inet_addr_type(net, addr->sin_addr.s_addr);
>>
>> That was done intentionally in commit 0ce779a9f501
>>
> 
> Should I remove this from the patch? Is there a particular reason why
> this was done in ping.c but not in the other places?
> 

exactly. I did not see the big deal about changing it.

