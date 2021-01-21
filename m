Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B97A2FF2B3
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 19:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389491AbhAUSCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 13:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389439AbhAUSBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 13:01:52 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED410C06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 10:01:11 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id y19so5814232iov.2
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 10:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j4qyNKroZf0PR1hUuEzsx/1WQ9PqO3whBh/bYKsXNk4=;
        b=NwrMlXcOlysV4djOofPixbwvOb/eBpqs+bb7+bWOAoZNWmZReC52iZGxNDK9o01pX8
         /qLR8LIa+yMXpxbfxe8xVuck43q5hxfGQ32mw0u9aNYHiQMhWh7cqAcCHltql3kPsNho
         5ZYHbyKB6Vfoo1syuKP5tlH0NP7+iz4Y/xXjs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j4qyNKroZf0PR1hUuEzsx/1WQ9PqO3whBh/bYKsXNk4=;
        b=Bs7uUNYcomkVy6cBQcsq/sFnxjUF99zlLUh06HHLRmxCVuzGfPkuSDqVrWey3RV0qN
         ACZ/9SXB0jwJ2az/pjkYJnT3jF5FKi1DsXkHOrb6Qqq/VsnFJY4ZG4Mpr17ehuKqWbRx
         FI/nLjwBI0mkilUWQHJ8WJi149KYnrZpcZwpzWpJWccUUxZR0H2nJkW7UVrIJ8/tKm6G
         FXxy7Ph+vMu2lW3W2/+OasgHrKBLewpKBJ3ZepKykTqIvhezxHfZKsMdTS7ofY71359I
         ImeM15ERRlSP7ktkk1CzC+rHVY1Wlfegw5S2q+EdNpUOk0/zScJhL6g/jJ5Ra0VrG4hV
         DPqg==
X-Gm-Message-State: AOAM533OBHjK+bDS42/YbxIUgR0OMGEe0wsEgIKpMOZetH3xSt1L7ddD
        42uT8vWnYhg8v5UeU04UER5Q8g==
X-Google-Smtp-Source: ABdhPJznJJ/QBvTZQKHvjFLkKK9F4sWWxADtpcCtMpyGjJNm2zXjMNAkOgY6mRvBBmnE/WFugEH1Gw==
X-Received: by 2002:a92:cb47:: with SMTP id f7mr778660ilq.169.1611252071329;
        Thu, 21 Jan 2021 10:01:11 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s10sm2888397iob.4.2021.01.21.10.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 10:01:10 -0800 (PST)
Subject: Re: rpc_xprt_debugfs_register() - atomic_inc_return() usage
To:     Trond Myklebust <trondmy@hammerspace.com>,
        "Anna.Schumaker@netapp.com" <Anna.Schumaker@netapp.com>
Cc:     "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <06c8f6ff-f821-e909-d40c-9de98657729f@linuxfoundation.org>
 <020aee05c808b3725db5679967406a918840f86f.camel@hammerspace.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5952caee-edb4-e9ec-6621-fb50cfe3384f@linuxfoundation.org>
Date:   Thu, 21 Jan 2021 11:01:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <020aee05c808b3725db5679967406a918840f86f.camel@hammerspace.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/21 10:56 AM, Trond Myklebust wrote:
> On Wed, 2021-01-20 at 16:52 -0700, Shuah Khan wrote:
>> Hi Anna and Trond,
>>
>> I came across the following while reviewing atomic_inc_return()
>> usages
>> that cast return value to unsigned
>>
>> rpc_xprt_debugfs_register()'s atomic_inc_return() usage looks a bit
>> odd.
>>
>> - cur_id isn't initialized
>> - id = (unsigned int)atomic_inc_return(&cur_id);
>>
>> Please note that id is int. Is it expected that cur_id could
>> overflow?
>> Is there a maximum limit for this value?
>>
> 
> Yes, we do expect cur_id to eventually overflow (once you have created
> 2 billion RPC client instances), however the atomic increment
> operations are expected to handle this correctly according to the
> maintainers (I already asked them in a different context). Furthermore,
> the code itself doesn't care about strict sequentiality. All it wants
> from the counter is uniqueness, with that uniqueness condition actually
> being enforced by the subsequent debugfs_create_file() call.
> 
> IOW: I don't think this is a real problem.
> 

Great. Thank you for a detailed explanation.

-- Shuah
