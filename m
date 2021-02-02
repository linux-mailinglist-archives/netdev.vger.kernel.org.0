Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1305830CB6E
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 20:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbhBBTYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 14:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbhBBOAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 09:00:02 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4EDC06178B
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 05:59:21 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id v3so14942938qtw.4
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 05:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kPXwFAu2mSrtvutDiYBx8OuUL9CmPDdbnQK2i+UmkYk=;
        b=zuFV28T2I7xVe0xPTYjyDCvA7+35EDesPy8rWCBqQyf6aEFplyp5zuFnargCMAtCA0
         DWK/Kz+MKadzGb0gtir9bQOeWapuVvcN893nQc1K4Dk2LnlF7m1E6+l+AyZqSA69qO/v
         mxP329wd8qQp8Y9tqoCtTQ4rpm/2yU2Bn/NubsnCH8cWyGABy1yHittB///MXGPy7Kgw
         miB12Jgbr448vdVrJZqGOCiEutGLsOI7nuZHey9S8RPenIxKAl9WvhlXFGQyRL3lKV8r
         cLq3qu7/yFX4vpI0du4YELYrQuEgwPhkPHhxxbBVdew3P07I4HV26zAEP+qlBMff1l6s
         BRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kPXwFAu2mSrtvutDiYBx8OuUL9CmPDdbnQK2i+UmkYk=;
        b=sGTB8S11DnsqNmRtFia7YVw2yLwq7tBhcGQiLP87aXl8pcGIWc+rnA7kMjd8k8U71k
         MNjN7Fs6vZTIZNZeSUz7/49INCNV4lNE7Z/70AGO5HuVIvB7BLpTZhpThi8vh/ZtnOrI
         hoKWLdKsT3XOZdZAe4zV3v6qOeAfLhiwX8DfcT9KKw7wbZ6/YrWoI+VqytkgOkXpadry
         5M/XR/6YQ0/vNE5WcYz8psoqSJCJnVhT5sYjZW10JPdAVV8Xuk7LVtdEsoGuNPdX9bxU
         3UB5j8L/fekMQ++WVmNpFyg7dkpgP7qq630lREN0NhB+GWCrBXx+ZFQYLxKG0lxlnUfh
         s9aA==
X-Gm-Message-State: AOAM530jq+yjnRMlmLAu/bqMDdNxZfEzL/QTQYCYeP0eJb3cFDfsAmKb
        +FNI/vC5ADUzKFx7gqGZQB+Ozg==
X-Google-Smtp-Source: ABdhPJzuL3KeTmHqfNLEvV/OLT1sw00uMgsDQbBfC5NLtnuYPfROPxun6kO98Bz0BBTwloNtVwIaNA==
X-Received: by 2002:ac8:7453:: with SMTP id h19mr12075052qtr.354.1612274360324;
        Tue, 02 Feb 2021 05:59:20 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id c22sm3453828qtp.19.2021.02.02.05.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 05:59:19 -0800 (PST)
Subject: Re: [PATCH net-next v2] net/sched: act_police: add support for
 packet-per-second policing
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Baowen Zheng <baowen.zheng@corigine.com>
References: <20210129102856.6225-1-simon.horman@netronome.com>
 <0c47b7d7-dc2b-3422-62ff-92fea8300036@mojatatu.com>
 <20210201123352.GB25935@netronome.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <35f88b4d-4505-a80d-f76c-f131919fa86a@mojatatu.com>
Date:   Tue, 2 Feb 2021 08:59:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210201123352.GB25935@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-01 7:33 a.m., Simon Horman wrote:
> On Fri, Jan 29, 2021 at 09:30:00AM -0500, Jamal Hadi Salim wrote:

>> Ido's comment is important: Why not make packet rate vs byte rate
>> mutually exclusive? If someone uses packet rate then you make sure
>> they dont interleave with attributes for byte rate and vice-versa.
>>
> 
> Sorry, I somehow missed Ido's email until you and he pointed it out
> in this thread.
>

This one i think is still important. Potential for misconfig
exists with both on.
The check for exclusivity is rather simple in init().
Also please see if you can add a test in the policer tests in tdc.


> Regarding splitting up the policer action. I think there is some value to
> the current setup in terms of code re-use and allowing combinations of
> features. But I do agree it would be a conversation worth having at some
> point.

Sounds reasonable.

cheers,
jamal
