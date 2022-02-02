Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15C84A7AA9
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 22:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347720AbiBBVxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 16:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBBVxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 16:53:46 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5625C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 13:53:46 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id h7so846796iof.3
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 13:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rXPadwPktQm/NFIaexbAa5ouHkmmT5UwgFJJAcVKcrE=;
        b=biqNtqM4PMVgqGuqDixEz/WyWxFw9OjPaCjjPxJDQSXG4e/apaiQgu27z2QT097qMA
         oIQzE2Daw3MON2RgD9hOVzul1iRw2VfqUf1EHFiGmEuzrXe3FT6+88XC3p9uWLLQ4eDX
         TMREtzi9vBASlrBBRoQha/pIQFw7iS10+W5Cqis0LO8jKSDwgzHDLKahmzYbHkMEsGf7
         7vpLcr/bJcelDY6Hs3S3LCQs9b1MCGizCuUKZGI97ShMaO3Uh6L/qCLUmpQUW0D/FwXy
         l175FiOZ2A8QjcXIMJ/zHRh/iVgmg7/oieQhCcMC6J6jGayxs8MWo5o8m71POztHT7Y3
         SkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rXPadwPktQm/NFIaexbAa5ouHkmmT5UwgFJJAcVKcrE=;
        b=YSv3J7PSznvCiGf4gNXsvqt4FOaMQaBnsldWhjmOMr16VKZSMTzvMYq2qAXSnw9q37
         x6voSk+k1gqlbIW4/rIQynMH9EdulOqui5KFowL+n0/WtmNKCJkVUg3gsk3OQaI10dJ1
         4aUw0SuADgDehhxBV+ImQH+Bp/T4MyehqXDTr81+FrcfBy0EG82V29v/+322uBp+QWNG
         Uas/lQvY6wTydC6i/ZidUQNmH+J+PEn375yJm87h03L2Oea/oMFgmdzlhLyGutw0COON
         Qxgju1sLh93Om2+lpMLS92X3ftMFS9YnowALqN1jlc+2cRNvKcVz9nmmj5NA3Mk7m8TV
         iSqw==
X-Gm-Message-State: AOAM531TQxtEMCkSIiltHip8MAwjVZM/QM10e19PYc67K9n2nIQaJjEu
        8OUW3s7r4NZJSZrWVmymZRSFwgi/Yes=
X-Google-Smtp-Source: ABdhPJx4f2irrJ9PdzfyIQzfbGLD9q1rw3yJyydj6OVBgZ8czB1ezUsBi1NU+3QQHu6/LGCZJQaKAQ==
X-Received: by 2002:a6b:4e17:: with SMTP id c23mr17242956iob.152.1643838826092;
        Wed, 02 Feb 2022 13:53:46 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id s18sm3019912iov.5.2022.02.02.13.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 13:53:45 -0800 (PST)
Message-ID: <56c1a061-fc2c-6f2e-af44-8f8ee5041ba0@gmail.com>
Date:   Wed, 2 Feb 2022 14:53:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH iproute2] lib/bpf: Fix log level in verbose mode with
 libbpf
Content-Language: en-US
To:     Paul Chaignon <paul@isovalent.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <haliu@redhat.com>
References: <20220202181146.GA75915@Mem>
 <c40e7fc2-e395-6999-9967-3e76e0bcfd3f@gmail.com> <20220202210705.GB96712@Mem>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220202210705.GB96712@Mem>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/22 2:07 PM, Paul Chaignon wrote:
> On Wed, Feb 02, 2022 at 12:10:03PM -0700, David Ahern wrote:
>> On 2/2/22 11:11 AM, Paul Chaignon wrote:
>>> diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
>>> index 50ef16bd..bb6399bf 100644
>>> --- a/lib/bpf_libbpf.c
>>> +++ b/lib/bpf_libbpf.c
>>> @@ -305,7 +305,7 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
>>>  
>>>  	attr.obj = obj;
>>>  	if (cfg->verbose)
>>> -		attr.log_level = 2;
>>> +		attr.log_level = 1;
>>>  
>>>  	ret = bpf_object__load_xattr(&attr);
>>>  	if (ret)
>>
>> ip and tc do not have verbosity flags, but there is show_details. Why
>> not tie the log_level to that?
> 
> I'm not sure I understand what you're proposing. This code is referring
> to the "verbose" parameter of the tc filter command, as in e.g.:
> 
>     tc filter replace dev eth0 ingress bpf da obj prog.o sec sec1 verbose
> 
> Are you proposing we replace that parameter with the existing -details
> option?
> 

just proposing that log_level not be hardcoded and coming from the
command line. Connecting with verbose arg makes more sense. How to
extend it to let the user control verbosity
