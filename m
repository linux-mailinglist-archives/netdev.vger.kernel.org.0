Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2043F1EB69D
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 09:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgFBHhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 03:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgFBHhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 03:37:11 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A818C061A0E
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 00:37:11 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g10so1862519wmh.4
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 00:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xqds7VbU+K4A2laqYmDPq+zdOfWX/VjHAo0lo4mVXR0=;
        b=anQ2chfqCtHiZ4pB5qiENxzfk8kF2TaVNvzhYEztrPanUnTZOwgh9uLDEQQUB0D9Nm
         epHJcbtRVzaKPvJAQQ6gnjksaOc6SJjLnX4DJq3azYt54ilj0wLyXuKTfuoyLODJbWm0
         cbky1C0TxwTgECHxolmkjGf913LY89hRXbYtg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xqds7VbU+K4A2laqYmDPq+zdOfWX/VjHAo0lo4mVXR0=;
        b=LrWcIBBkcTDbvtpd/4nt66W5gC49iFfPHrcWQMjCL4EQP6TOppl7SurFtHUkVQp3os
         ZW68J+Js5VmIb9Iib7d7t6PlhT9EZOk+HhEMEeM9Kk+pYT41uwmrPqpD/JuAHFi//Qy+
         UVI954d5LMrh8Lk8hiI3rLO4CZbvLxW3x/7EQUtIcX4+64vHrzMlgpdS8NTc70AmS4Wj
         JSoMLMxaOcK/EpOisitNUXZyG0mkjfhzfXSBOKSZQ9WyTxyjCs//TmS0gQaRIHSkXace
         8BGxeloahYRuvh/16qr9nNTXeDCDNBmYZH5+rtXDD5jGfeyfMsNo+Lc3wsAMYLCy8I0B
         dnDw==
X-Gm-Message-State: AOAM532W8w3QVPkguq4gAuHWVUuosZIXpZWJLaBYttiPF9FrYM0kwvsV
        1sJFZMG2QwOA8j0U3+FM/NsCRMCcu34=
X-Google-Smtp-Source: ABdhPJxVmq6mSWg/iUiuouLU0cmof6ha99AdKRzM2oufoIVIFhcGa8uQFobYRnwf9lC+PgvBrVralA==
X-Received: by 2002:a05:600c:2110:: with SMTP id u16mr2832929wml.26.1591083430327;
        Tue, 02 Jun 2020 00:37:10 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 23sm2333774wmo.18.2020.06.02.00.37.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 00:37:09 -0700 (PDT)
Subject: Re: [PATCH] ipv4: nexthop: Fix deadcode issue by performing a proper
 NULL check
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     David Miller <davem@davemloft.net>, patrickeigensatz@gmail.com
Cc:     dsahern@kernel.org, scan-admin@coverity.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200601111201.64124-1-patrick.eigensatz@gmail.com>
 <20200601.110654.1178868171436999333.davem@davemloft.net>
 <4e6ba1a8-be3b-fd22-e0b8-485d33bb51eb@cumulusnetworks.com>
Message-ID: <beb306e9-228f-6810-fc77-972e5acb5863@cumulusnetworks.com>
Date:   Tue, 2 Jun 2020 10:37:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <4e6ba1a8-be3b-fd22-e0b8-485d33bb51eb@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/06/2020 10:23, Nikolay Aleksandrov wrote:
> On 01/06/2020 21:06, David Miller wrote:
>> From: patrickeigensatz@gmail.com
>> Date: Mon,  1 Jun 2020 13:12:01 +0200
>>
>>> From: Patrick Eigensatz <patrickeigensatz@gmail.com>
>>>
>>> After allocating the spare nexthop group it should be tested for kzalloc()
>>> returning NULL, instead the already used nexthop group (which cannot be
>>> NULL at this point) had been tested so far.
>>>
>>> Additionally, if kzalloc() fails, return ERR_PTR(-ENOMEM) instead of NULL.
>>>
>>> Coverity-id: 1463885
>>> Reported-by: Coverity <scan-admin@coverity.com>
>>> Signed-off-by: Patrick Eigensatz <patrickeigensatz@gmail.com>
>>
>> Applied, thank you.
>>
> 
> Hi Dave,
> I see this patch in -net-next but it should've been in -net as I wrote in my
> review[1]. This patch should go along with the recent nexthop set that fixes
> a few bugs, since it could result in a null ptr deref if the spare group cannot
> be allocated.

Obviously I forgot to mention in my review that it should go to -stable with the
nexthop fix set.

> How would you like to proceed? Should it be submitted for -net as well?
> 
> Thanks,
>  Nik
> 
> [1] https://lkml.org/lkml/2020/6/1/391
> 

