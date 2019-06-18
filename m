Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A89A449C63
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 10:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbfFRIwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 04:52:32 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54585 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729143AbfFRIwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 04:52:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id g135so2261835wme.4
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 01:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FoFfV+QYBdm2iXMDi6fJfB/aTki92d70Dc5Smq4tiTE=;
        b=YfNgQ/KGpQP9wTgKR8XjKreC89v5z7uAHAEHgAzuWivBp2fdNTN7pd3U0naQs3mAV8
         2IyWh1LXyVSHaM2aGVRKHtfMQmrJUm69w9r1O0afSL7ox9skAH8cH5vNb3Ou/duUmSIy
         T23YvL5E0zoSsdtGjpWRks8+puVx9d+0NqI1DXIpWaZ5iqOcd2iGLo+VT3rgXFSrExM+
         39FxrGAvbvApzCWhVPS0zcUGVatQ7Q8WHhFVz6XMmNFBip5YKA1Eyi3e0No1vFANg6bk
         /f493M9nBMuh2gzjCjFeJ+AqWbVOEMNjnkwhq1qfZKL1fFIIpeHBqw6tLKRRW5kZ2d1A
         d72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FoFfV+QYBdm2iXMDi6fJfB/aTki92d70Dc5Smq4tiTE=;
        b=iLNrebQMsZXT+oGt2cxiS0dRZ2Ddm8BReGyfyfyMOPuA9OdEy4JRwCtSfL9my78NUG
         EriiwnydIGGeGpfwZUFd2g3Koz40HrQXBRrGHRMKTgN5ogdwJmi2jDpdDgVeZhbUF8gN
         iUKzdPAB6AKHbXmnHrkPNZuf9NH5T1GUJobzAD3BZg4sDIjfNbD3F5Pl1Jj8RdurRnNL
         r8NVH1NYJQMIcftg5SrKEcqxbEn+XEbKKyadBD2XS1xSx9PqqzWM61EwPVjG5zyinfpN
         SQYykVsBn8YhfdBn/6umQmCGIAYl3c+MeSXIWcRioW6N8f0Ev7yK4Dq9c2Z9AWguV1+O
         Pk1g==
X-Gm-Message-State: APjAAAXe7yrv8py3K2aEZ4296UjKJ6Dkys3qiTs8vmmfBeAehzWvea/b
        4a09ZD5mobpHSYxO/onAuLLThunMNHM=
X-Google-Smtp-Source: APXvYqySuz/WyihayTEH7P1P/tladNJgj1Ct3NPu/R7zUxg9jfDqSe6EEtO7cRGM4AwYLPDsLiictw==
X-Received: by 2002:a1c:20d0:: with SMTP id g199mr2383355wmg.79.1560847949555;
        Tue, 18 Jun 2019 01:52:29 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:dc55:7bd7:5678:42e4? ([2a01:e35:8b63:dc30:dc55:7bd7:5678:42e4])
        by smtp.gmail.com with ESMTPSA id w2sm12838638wrr.31.2019.06.18.01.52.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 01:52:28 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [RFC PATCH net-next 1/1] tc-testing: Restore original behaviour
 for namespaces in tdc
To:     Lucas Bates <lucasb@mojatatu.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, kernel@mojatatu.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>
References: <1559768882-12628-1-git-send-email-lucasb@mojatatu.com>
 <30354b87-e692-f1f0-fed7-22c587f9029f@6wind.com>
 <CAMDBHYJdeh_AO-FEunTuTNVFAEtixuniq1b6vRqa_oS_Ru5wjg@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <0bd19bf9-f499-dc9f-1b26-ee0a075391ac@6wind.com>
Date:   Tue, 18 Jun 2019 10:52:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAMDBHYJdeh_AO-FEunTuTNVFAEtixuniq1b6vRqa_oS_Ru5wjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 17/06/2019 à 04:04, Lucas Bates a écrit :
> On Fri, Jun 14, 2019 at 5:37 AM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
[snip]
> The tests that make use of DEV2 are intended to be run with a physical
> NIC.  This feature was originally submitted by Chris Mi from Mellanox
> back in 2017 (commit 31c2611b) to reproduce a kernel panic, with d052
> being the first test case submitted.
Ok.

> 
> Originally they were silently skipped, but once I added TdcResults.py
> this changed so they would be tracked and reported as skipped.
> 
>> From my point of view, if all tests are not successful by default, it scares
>> users and prevent them to use those tests suite to validate their patches.
> 
> For me, explicitly telling the user that a test was skipped, and /why/
> it was skipped, is far better than excluding the test from the
> results: I don't want to waste someone's time with troubleshooting the
> script if they're expecting to see results for those tests when
> running tdc and nothing appears, or worse yet, stop using it because
> they think it doesn't work properly.
> 
> I do believe the skip message should be improved so it better
> indicates why those tests are being skipped.  And the '-d' feature
> should be documented.  How do these changes sound?
If the error message is clear enough, I agree with you. The skip message should
not feel like an error message ;-)


Thank you,
Nicolas
