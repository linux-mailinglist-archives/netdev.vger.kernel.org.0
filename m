Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D366E18CE5
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 17:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfEIPXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 11:23:50 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43009 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfEIPXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 11:23:50 -0400
Received: by mail-qt1-f194.google.com with SMTP id r3so2906230qtp.10
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 08:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z/eturOh5afNaJOq4qaChlqlzinQMKuYlPoIHF4BAeE=;
        b=QGwQjoY4XHWX3mB1L7Ow0JRiNn4tHIMq7g21jGsMiho5IeUaYQwHp4FZr9JZt+tymL
         jpdQ9ldmK1SQbbwBosjauChprdfLJtSS8tREp3vdBm65oEcSxK/Pg32ZFzyJlY3f9nHx
         BPr194gWn9fBx8hbtPWwiv2+27/8unUJjrhnxzBiUPWxKfMeGr6dKZ1eXNzUKtCgdj0V
         H+1mSoodPw8ldqYPaco3NG6V/dYF7ogGpgpRvzLrX4bnPPsMCRnaA/n2N5aiBzUDkf5a
         0Ccx/Nc5oDuuOfhFHohSb/Y7Cyc68iE4wM84m1qknqgxuS4qIK9ub7C+rD8R7GKpLlcY
         v9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z/eturOh5afNaJOq4qaChlqlzinQMKuYlPoIHF4BAeE=;
        b=aIKVcV/9uTadxy4MqrPZUrbVZsHA1wfF3PRpvSamQxskYRxRQMnaTCvVTsRoqptv+M
         MyS5tXCjBIpFZ6h3Q6XFgF9yetpLLh7ImTK+88FzkW3uWwzviaLnXsuTIvdzCRahvxsY
         vPWSEKlizALh6qL8HFZlyj9E1s/BMNkuTQ1gsqXYSWyWCutwPaS/P0TnniR3r80HaWvt
         yjpsjR2Jc7xFYqeljXd82qOxUnLYVKfDQKBwYAbJgSNJ7Bi1sCZVLwkYDmP+rSBCxLbs
         +nQims+PCrXWQ4ctz7oL4vS/QaY1Cl2FrJmf5rZ9z6JtLisImDdvXVvKxRI5RrjJ9ZOA
         pe3A==
X-Gm-Message-State: APjAAAX2LB78VvsMc5TuQkhZgmz31uLgUROHGEST1LtggSRocO9T1NbD
        HSsFz4aUdeJbpu2jS0xYwlWMvw==
X-Google-Smtp-Source: APXvYqy/r71ow/vYHPMSRDTvvHv5NlbjNxSEHrMDUFpM8BKRIxK7+WHhTHpwsXZLhI+e1kGGmM4AkA==
X-Received: by 2002:a0c:d7cc:: with SMTP id g12mr4181464qvj.220.1557415429536;
        Thu, 09 May 2019 08:23:49 -0700 (PDT)
Received: from [10.0.0.169] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id e3sm694449qkn.93.2019.05.09.08.23.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 08:23:48 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 2/3] flow_offload: restore ability to collect
 separate stats per action
To:     Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Anjali Singhai Jain <anjali.singhai@intel.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <alpine.LFD.2.21.1905031603340.11823@ehc-opti7040.uk.solarflarecom.com>
 <20190504022759.64232fc0@cakuba.netronome.com>
 <db827a95-1042-cf74-1378-8e2eac356e6d@mojatatu.com>
 <1b37d659-5a2b-6130-e8d6-c15d6f57b55e@solarflare.com>
 <ab1f179e-9a91-837b-28c8-81eecbd09e7f@mojatatu.com>
 <1c0d0a0a-a74b-c887-d615-0f0c0d2e1b9a@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7d0a0e7b-3b74-d384-75f8-6cde603f81ee@mojatatu.com>
Date:   Thu, 9 May 2019 11:23:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1c0d0a0a-a74b-c887-d615-0f0c0d2e1b9a@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-08 1:07 p.m., Edward Cree wrote:
> On 08/05/2019 15:02, Jamal Hadi Salim wrote:
>> The lazy thing most people have done is essentially assume that
>> there is a stat per filter rule...
>> I wouldnt call it the 'the right thing'
> Yup, that's why I'm trying to not do that ;-)

Thank you ;->

> 
>> Yes, the index at tc semantics level is per-action type.
>> So "mirred index 1" and "drop index 1" are not the same stats counter.
> Ok, then that kills the design I used here that relied entirely on the
>   index to specify counters.
> I guess instead I'll have to go with the approach Pablo suggested,
>   passing an array of struct flow_stats in the callback, thus using
>   the index into that array (which corresponds to the index in
>   f->exts->actions) to identify different counters.
> Which means I will have to change all the existing drivers, which will
>   largely revert (from the drivers' perspective) the change when Pablo
>   took f->exts away from them — they will go back to calling something
>   that looks a lot like tcf_exts_stats_update().
> However, that'll mean the API has in-tree users, so it might be
>   considered mergeable(?)

I would say yes, but post the patches and lets have the stakeholders
chime in.
Would it be simpler to just restore the f->exts?


cheers,
jamal
