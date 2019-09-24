Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEB8BD1CC
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392161AbfIXSXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:23:14 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:44866 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfIXSXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 14:23:14 -0400
Received: by mail-io1-f45.google.com with SMTP id j4so6791553iog.11
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 11:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JCRwRvIn5WnSIjJ8UCyA8yQaqy8F1gjAcRkVOQB7q9I=;
        b=Ep9nbVOXt43g2GclKMujhZBtqpVD24/fugjF20R07gEhpQOmpgtpTnMiipYTlVRUsh
         x0q1dnIC70qIcrWtw7LA9CSHAIi0jLFwtDGGedygehl5k1u3uvQec64chGwkXexJ7E70
         aHb8Qxu2dI/iGt/P03nuAL0MHi1aovz5lzpuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JCRwRvIn5WnSIjJ8UCyA8yQaqy8F1gjAcRkVOQB7q9I=;
        b=VM3CuZsUQjYwCVnYoLf9DgJ9JFKOLx7S29N/fRANQ3sdjgXcedUL9mTxpSmE7u5QeV
         BxtCddQIHaQUCihmCyNsRT/ZxNsBoMYKNctl++SyXkJTy5kK4kf6Uj9fdayyJfGDggqk
         /tcZyLF/gzE6m/9dX3gthNBQfEPSKznvjtVIsLqc0Heaf7ffDlsCK1hjDBnaJsD7SoFJ
         rgnTCuDK0C0o5fdyxJwQGaHrcB1JjryFIUJOF5P+vBSA8MEo6S0dkm0sxh5hNKo2lArT
         BfZM8z+RAvBDi8n3OgBgDGRWGi6LtnrbeJQ08dZQdo4cXc/pCyBzQhWSwaQk92/MH03a
         ErWg==
X-Gm-Message-State: APjAAAVqa/k/wB7MqfB1E2o5mhGWydWjuQnA3EUX9ZNbxbyEcCdw9Ymp
        +2P+jlmvhPB8/POHu+xEIYWIyw==
X-Google-Smtp-Source: APXvYqxK0F4oMWpvW+erHciK5obgRJA5cW6Px156FnlU93cw6O2tYswirK5NqitWoQDlIgoeKiloJw==
X-Received: by 2002:a02:246:: with SMTP id 67mr106308jau.121.1569349393695;
        Tue, 24 Sep 2019 11:23:13 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f26sm1242052ion.4.2019.09.24.11.23.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 11:23:13 -0700 (PDT)
Subject: Re: Linux 5.4 - bpf test build fails
To:     Tim.Bird@sony.com, cristian.marussi@arm.com,
        alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        "skh >> Shuah Khan" <skhan@linuxfoundation.org>
References: <742ecabe-45ce-cf6e-2540-25d6dc23c45f@linuxfoundation.org>
 <1d1bbc01-5cf4-72e6-76b3-754d23366c8f@arm.com>
 <34a9bd63-a251-0b4f-73b6-06b9bbf9d3fa@linuxfoundation.org>
 <a603ee8e-b0af-6506-0667-77269b0951b2@linuxfoundation.org>
 <c3dda8d0-1794-ffd1-4d76-690ac2be8b8f@arm.com>
 <ECADFF3FD767C149AD96A924E7EA6EAF977BCBF5@USCULXMSG01.am.sony.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d4c916ec-14a5-1076-7b84-3ca42026dd19@linuxfoundation.org>
Date:   Tue, 24 Sep 2019 12:23:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ECADFF3FD767C149AD96A924E7EA6EAF977BCBF5@USCULXMSG01.am.sony.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/19 12:07 PM, Tim.Bird@sony.com wrote:
> 
> 
>> -----Original Message-----
>> From: Cristian Marussi on Tuesday, September 24, 2019 7:30 AM
>>
>> Hi Shuah
>>
>> On 24/09/2019 17:39, Shuah Khan wrote:
>>> On 9/24/19 10:03 AM, Shuah Khan wrote:
>>>> On 9/24/19 9:52 AM, Cristian Marussi wrote:
>>>>> Hi Shuah
>>>>>
>>>>> On 24/09/2019 16:26, Shuah Khan wrote:
>>>>>> Hi Alexei and Daniel,
>>>>>>
>>>>>> bpf test doesn't build on Linux 5.4 mainline. Do you know what's
>>>>>> happening here.
>>>>>>
>>>>>>
>>>>>> make -C tools/testing/selftests/bpf/
>>>>>
>>>>> side question, since I'm writing arm64/ tests.
>>>>>
>>>>> my "build-testcases" following the KSFT docs are:
>>>>>
>>>>> make kselftest
>>>>> make TARGETS=arm64 kselftest
>>>>> make -C tools/testing/selftests/
>>>>> make -C tools/testing/selftests/ INSTALL_PATH=<install-path> install
>>>>> make TARGETS=arm64 -C tools/testing/selftests/
>>>>> make TARGETS=arm64 -C tools/testing/selftests/
>>>>> INSTALL_PATH=<install-path> install
>>>>> ./kselftest_install.sh <install-path>
>>>
>>> Cristian,
>>>
>>> That being said, I definitely want to see this list limited to
>>> a few options.
>>>
>>> One problem is that if somebody wants to do just a build, there
>>> is no option from the main makefile. I have sent support for that
>>> a few months ago and the patch didn't got lost it appears. I am
>>> working on resending those patches. The same is true for install.
>>> I sent in a patch for that a while back and I am going to resend.
>>> These will make it easier for users.
>>>
>>> I would really want to get to supporting only these options:
>>>
>>> These are supported now:
>>>
>>> make kselftest
>>> make TARGETS=arm64 kselftest (one or more targets)
>>>
>>> Replace the following:
>>>
>>> make -C tools/testing/selftests/ with
>>>
>>> make kselftes_build option from main makefile
>>>
>>> Replace this:
>>> make -C tools/testing/selftests/ INSTALL_PATH=<install-path> install
>>>
>>> with
>>> make kselftest_install
>>
>> Yes these top level options would be absolutely useful to avoid multiplication
>> of build targets to support and test.
>>
>> Moreover, currently, since there was a lot of test growing into arm64/
>> inside subdirs like arm64/signal, I support (still under review in fact) in the
>> arm64/
>> toplevel makefile the possibility of building/installing by subdirs only, in order
>> to be able to limit what you want to build/install of a TARGET (resulting in
>> quicker devel),
>> issuing something like:
>>
>> make TARGETS=arm64 SUBTARGETS=signal -C tools/testing/selftests/
>>
>> if possible, that would be useful if kept functional even in the
>> new schema. I mean being able to still issue:
>>
>> make TARGETS=arm64 SUBTARGETS=signal kselftes_build
> 
>  From a user perspective, instead of adding a new SUBTARGETS variable,
> I would prefer something like the following:
> 
> make TARGET=arm64/signal kselftest_build
> 
> If you just add a single flat subsidiary namespace, then it doesn't support further
> increasing the directory depth in the future.
> 

TARGETS is make variable. Adding sub-targets might not be easy without
cluttering the selftests main Makefile. I will have to look into it.

thanks,
-- Shuah

