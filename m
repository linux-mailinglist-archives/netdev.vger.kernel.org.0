Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9831D78D5
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 14:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgERMnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 08:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgERMnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 08:43:03 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9898BC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 05:43:03 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id w18so9603326ilm.13
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 05:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HBzhdniF/JGNWqglYqOvZ95Ha4ifl+EMjjc4IaDK52A=;
        b=JpQZuuajEMdtkOVungaqZech90Cmi1eLJbKw+CX//ctofNlti0SdUMTk8DT64x0BSw
         t3J4ELqFPBssa3jxs4emLg6/X4m+VPrYNn1dSt2+GRwY0NrR+puK/SKnrmaAoR58RJoT
         Jm+2W6M649ylqz4yPLq+yvJbAdrWe3Dz1RZlKKjmkQsKCZu34nVd4LOfPHR561We+HUZ
         wodZIE2rtg4cE3/kp7yfXGhhCDmnxwZB/TQyaw4nil87EypYUYXAIs1oZZcX9Ds74lQ7
         9lagRum+MSF+b3GiBP971Yizbzb7FTnYbh3l+0ddIfQ4ewI4FpGNj/tW+/NqwKNgNpli
         1+aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HBzhdniF/JGNWqglYqOvZ95Ha4ifl+EMjjc4IaDK52A=;
        b=T83xIeSpCurdzjgpAe1ySOvChvKwidGB7k2NwdyEdLp26Nh/vkcx1B1A+eU4Y5wXYE
         K6/15g5RBcNALCbQTNMJRZA+k07qdSCOdIHvjMlID1k438WSj9EnXYP46UuQfmNYPk8p
         +UTKsmJ5WTvzFWNNY6WPO0HM7XQZBnUra3zwGKixVQfzo+D4NPLIcH9k9zVCjvSMQtxE
         y6ZWkSxJWIupXglf7QN2dAzbFr1ZAicqCAHfEw20d1HDDbxyr/PV1+nzRFk7RUtisaAm
         VVByeWZu90sAWL6Z1k0Se1anEo1QecKAlXDYC3y5UCjWRYc3YYC7GArbaBpl7Due71Ap
         Y96g==
X-Gm-Message-State: AOAM530GzeY5/PX9Ow5+jZGbXgG1CQtGo493hDxD7WG6CmuRI5OwAK3y
        jJTUWCWESxV0OKUfOBzrx73t1UxBg+gSeA==
X-Google-Smtp-Source: ABdhPJwZF+HpcBcZNXJcFrFG5UTwSdttwHBvI9xLPJP0QAVf5nGvuuE96UdcA0ZGU52X8U06RrVAHA==
X-Received: by 2002:a92:988a:: with SMTP id a10mr12789415ill.301.1589805782995;
        Mon, 18 May 2020 05:43:02 -0700 (PDT)
Received: from [10.0.0.248] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id d10sm4750795ilr.2.2020.05.18.05.43.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 05:43:01 -0700 (PDT)
Subject: Re: [PATCH net 1/1] net sched: fix reporting the first-time use
 timestamp
To:     Roman Mashak <mrv@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel@mojatatu.com, Jiri Pirko <jiri@resnulli.us>
References: <1589719591-32491-1-git-send-email-mrv@mojatatu.com>
 <CAM_iQpXx-yBm2jQ57L+vkiU+hR4VExgzFrntw3R2HmOFpzF5Ug@mail.gmail.com>
 <85y2pqm4jq.fsf@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <25cff61e-5068-e25d-4554-a3ed3ccb0373@mojatatu.com>
Date:   Mon, 18 May 2020 08:43:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <85y2pqm4jq.fsf@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-17 9:10 p.m., Roman Mashak wrote:
> Cong Wang <xiyou.wangcong@gmail.com> writes:
> 
>> On Sun, May 17, 2020 at 5:47 AM Roman Mashak <mrv@mojatatu.com> wrote:
>>>
>>> When a new action is installed, firstuse field of 'tcf_t' is explicitly set
>>> to 0. Value of zero means "new action, not yet used"; as a packet hits the
>>> action, 'firstuse' is stamped with the current jiffies value.
>>>
>>> tcf_tm_dump() should return 0 for firstuse if action has not yet been hit.
>>
>> Your patch makes sense to me.
>>
>> Just one more thing, how about 'lastuse'? It is initialized with jiffies,
>> not 0, it seems we should initialize it to 0 too, as it is not yet used?
> 
> Yes, exactly. I was planning to send a separate patch for this.
> 
> Thanks for review, Cong.
> 

For these corner cases, firstuse using zero to indicate
"has not been used" is not ambigious.
lastuse has ambiguity because zero now has two meanings
if you check for the corner case in the kernel.
1)Zero is a legit value when dumping or
getting (example an action was just hit when you dumped).
2) zero also now means "has not been used".

My suggestion is to leave this alone in the kernel.
In user space/iproute2 check if lastused and created
are equal and declare "has not been used".

cheers,
jamal


