Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C653301C12
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 14:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbhAXNOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 08:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbhAXNOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 08:14:36 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11B0C061573
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 05:13:55 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id p5so4970746qvs.7
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 05:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Nbxhn4VP7zJDahUqJndaPR5tPlO5TE2OK8Z4fBgHugg=;
        b=NxMWl9C9913xr0PWjKlElMJCqypbz5K/TcKLSFtoF1iz/oVdrzAk8UK4FE9/fS8ynO
         5DpQUDSevX9R3/KJ+PPVo8RT77fv8iP7fdV36n2Mm21+33Rm/xdpVLGGM/6ABOcoyCpR
         yz3KIZIaQxA7JEudT/5TmYZLrm0FoN6MPkfrFAxl/9iXJJyY1VU1pUEDJjIqETY0Upmp
         rznfXmL+VKzjKAKQM8FceQLC4ry/mNIvvxn/8OkM95Q9guG2WdJROwAeZeWX10A4tdXq
         IAQ8r1rEhNH3xcKKpjH6r80oGSJkYP9h9qbjfh4oO2yUGO9Kv1GGuXIWVQyknDFzXk1M
         CIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nbxhn4VP7zJDahUqJndaPR5tPlO5TE2OK8Z4fBgHugg=;
        b=N9hEUW2Q3y1YI3vhjwwV0ya/W8FtXxQM1lj9/Vma0zVf1d8jZh5E+xFRQWCaQbFyr8
         oP3IO/rJ6XCPuYFTayPoX36eR5cZBZXhSH1aEZXCoBkRC938a7n0o9PH/5herF5OGN7t
         hydVQ7UOPXAVLVzYkGWVQ7zO7uKnkyWa7zuFFFxuEAcuIfNPSKTgAQV09l0JMqa1VgmJ
         dkKqRIqh0hsEp1gzrr8/mzUmyfy09a5sUwIHg4T1r2qylaGAOZfV2BeAMq3b89ZUwZ1m
         rNetxmcbyG52Awo3eFHyVHjW/l1gWDeZpgnT8Z/uk3DXhAM/u9TjewPHkQoiDleGxGB0
         QRJQ==
X-Gm-Message-State: AOAM533ePxf3Y2GBSa9biaZgWFY78pWFjiOHTXMig13HBOgYaG3NqHOn
        uP+pinQu5stwopN8A3Q0C/fzgA==
X-Google-Smtp-Source: ABdhPJwHxX4lxHIEsU9+kZBzTA3wZkuR9JTDTPUytIt8tc0XJG4b1sKNDDaOyVmnzJ0jNpU3w9f1Kw==
X-Received: by 2002:a0c:9122:: with SMTP id q31mr234839qvq.23.1611494035119;
        Sun, 24 Jan 2021 05:13:55 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id a188sm2132419qkg.33.2021.01.24.05.13.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 05:13:54 -0800 (PST)
Subject: Re: tc: u32: Wrong sample hash calculation
To:     Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Russell Stuart <russell-lartc@stuart.id.au>
References: <20210118112919.GC3158@orbyte.nwl.cc>
 <8df2e0cc-3de4-7084-6859-df1559921fc7@mojatatu.com>
 <20210120152359.GM3158@orbyte.nwl.cc>
 <7d493e9f-23ee-34cf-fbdd-b13a4d3bb4af@mojatatu.com>
 <20210122135936.GZ3158@orbyte.nwl.cc>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <f56cd351-f5f5-b8dd-9164-9161d4971a71@mojatatu.com>
Date:   Sun, 24 Jan 2021 08:13:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210122135936.GZ3158@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Phil,

On 2021-01-22 8:59 a.m., Phil Sutter wrote:
> Jamal,
> 
> On Fri, Jan 22, 2021 at 06:25:22AM -0500, Jamal Hadi Salim wrote:
> [...]
>> My gut feel is user space is the right/easier spot to fix this
>> as long as it doesnt break the working setup of 8b.
> 
> One last attempt at clarifying the situation:
> 
> Back in 2004, your commit 4e54c4816bf ("[NET]: Add tc extensions
> infrastructure.")[1] was applied which commented out the old hash
> folding and introduced the shift/cutoff we have today:
> 
> |  @@ -90,10 +101,12 @@ static struct tc_u_common *u32_list;
> |
> |  static __inline__ unsigned u32_hash_fold(u32 key, struct tc_u32_sel *sel)
> |  {
> | -	unsigned h = key & sel->hmask;
> | +	unsigned h = (key & sel->hmask)>>sel->fshift;
> |
> | +	/*
> |  	h ^= h>>16;
> |  	h ^= h>>8;
> | +	*/
> |  	return h;
> |  }
> 
> In a later commit, the new code was made compile-time selected via '#ifdef
> fix_u32_bug'. In that same commit, I don't see a related #define though.
> 
> Do you remember why this was changed? Seems like the old code was
> problematic somehow.
> 

Vague recollection that it didnt work. I will have to dig deeper in old
email exchanges. Its been like close to 20 years (if you consider there
was work in progress about 1-2 years before that final submission) ;->

cheers,
jamal

