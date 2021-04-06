Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7236355F4D
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244235AbhDFXSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236118AbhDFXSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 19:18:10 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B189C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 16:18:02 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mj7-20020a17090b3687b029014d162a65b6so267255pjb.2
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 16:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ZwPO/ECxWQJ/VIuOPmB5Uj2YCppB4Z6mlKudY4PZAx0=;
        b=TVEGMnjFPZP20vDGM6n7GvpfDHash5aSUBiADv4gqv8bHfQOR3Xo1HHyVsp0phTsJk
         jcCMEhKWhR+j6v2xS6JqaLZKX21aNd5ww6qa21rjaTiPJVhjx5HTeHUw62BGJA0fuzw+
         Ami1nRmNSAUu566kQHRO2hdeun4AhN1sj/EUbovGsXGvmp8m00jmESAFoF3O9HE0sZcF
         an77GnawBPDMfor9m7q8fuHMwxf3l3w65U7PsKqyffSINbVuRugBaxGoYkwaE2g0QszG
         fOVY6GP+0fIMStPaTlVg6a1RsB5XkiXWAjUf57btkDBiDfcVTO1kyyBIkDuMfnNPpO05
         kSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZwPO/ECxWQJ/VIuOPmB5Uj2YCppB4Z6mlKudY4PZAx0=;
        b=ec9Cvr1XJkEDE+3h04ooK4OgNBJV2TiAIpPu2ZPatHtlBGJSz4eNw5ZQuW5vqkVXN6
         L6T77S1FxILx9bf0U/282ZiVhmFWEw5r9dNFysyC3s1NrNx/Dnr2BTESWVBrCUEH07g+
         7vplDFF10hQbGlfdW8LX5gBia6wIyas35edem1Cd917meC8TKem8+2Wb9UShCOFm7XBk
         ekk8KIDH0BbuXjYkpTARaKBT22D7+mNoB6L2VjTcRcn2LvvNkohxLS+vppx4nMs+YPz1
         fzEV7F875NCUGc9ntTE0pdZFCRBADGKcxy7CtFFQJPRDjhJ9ZBYr2Un7ZNC0R2FP6En1
         jpHQ==
X-Gm-Message-State: AOAM533EhsOyoeh3OWGJRSXfeEOo9DDODHDQ55brSSEdaZlE05ngEVJW
        rYrRk7MhojvE2SktbctO1FfYgMakATYo5A==
X-Google-Smtp-Source: ABdhPJzWGd0Qpk6F/VgR3FdCXNUp3ZRSlm8AlGc3eXZ7RFkK+TIhJnWMydw0Ikam4MN/HhpwKLKRBA==
X-Received: by 2002:a17:902:e5d2:b029:e9:3900:558f with SMTP id u18-20020a170902e5d2b02900e93900558fmr528463plf.15.1617751081843;
        Tue, 06 Apr 2021 16:18:01 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id d2sm18951201pgp.47.2021.04.06.16.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 16:18:01 -0700 (PDT)
Subject: Re: [PATCH net-next 05/12] ionic: add hw timestamp support files
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-6-snelson@pensando.io>
 <20210404230526.GB24720@hoboy.vegasvil.org>
 <9b5d20f4-df9f-e9e1-bc6d-d5531b87e8c4@pensando.io>
 <20210405181719.GA29333@hoboy.vegasvil.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <ac71c8ad-e947-9b16-978f-c320c709615e@pensando.io>
Date:   Tue, 6 Apr 2021 16:18:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210405181719.GA29333@hoboy.vegasvil.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/21 11:17 AM, Richard Cochran wrote:
> On Mon, Apr 05, 2021 at 09:16:39AM -0700, Shannon Nelson wrote:
>> On 4/4/21 4:05 PM, Richard Cochran wrote:
>>> This check is unneeded, because the ioctl layer never passes NULL here.
>> Yes, the ioctl layer never calls this with NULL, but we call it from within
>> the driver when we spin operations back up after a FW reset.
> So why not avoid the special case and pass a proper request?

We do this because our firmware reset path is a special case that we 
have to handle, and we do so by replaying the previous configuration 
request.  Passing the NULL request gives the code the ability to watch 
for this case while keeping the special case handling simple: the code 
that drives the replay logic doesn't need to know the hwstamp details, 
it just needs to signal the replay and let the hwstamp code keep track 
of its own data and request history.

I can update the comment to make that replay case more obvious.

sln



