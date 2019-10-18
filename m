Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C68DC08F
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 11:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633038AbfJRJID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 05:08:03 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33768 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438664AbfJRJID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 05:08:03 -0400
Received: by mail-lj1-f196.google.com with SMTP id a22so5455018ljd.0
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 02:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=FNbBApr+hLXckmR1k7ezbuvsfY9Cot5o3bI+y3XumsA=;
        b=O+Tc4v7Im+BGKk14Z+0KVP5MFtcmg8jnf/Cma/mvCLLTNdU+tRplZTPMLwuNlb/IQ7
         4Q5s3iFxkYDRaXkUOeo+VMPK84PeY5c5QtiQT9+nPd/U5dJjxog9CS5DgR1x74E1hEQm
         1njvycQ/jqcW8gqN9Ck3THM9IB0BaxfR7jpp0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=FNbBApr+hLXckmR1k7ezbuvsfY9Cot5o3bI+y3XumsA=;
        b=rDG7GAozeEoCGtyZrjlgv7uhTFphFZXpbBs7A7Eusip/+C5HdyLHdg+91kVJzVbbYY
         ROLj5jGRERQJtE/wT816zSw9ZB++lhk5fVCWW//91XWs64A8bQaBW3chuEbl7yTNCZkL
         FE1u+poKbByR5LFWL1A0ELNAgtkYSMg4Ey4hc0JcSXsAxBSmsbTo4B39U2cpmYWoIf9t
         AS0WkqHS4fLyDpcXbgGBNT/wW+xN/7XGMbYrQNALhRqz4Vr0Fc9CKpFzWoLvojaIT64W
         6vsLJq8gza+2YaXIrQeiw1T5pg0bOtf3EYGXQLTt/5Skm7pTea5lkqrnhZAZo2pTCeYC
         AIhg==
X-Gm-Message-State: APjAAAU/VMlVZVcrS1mqFfYtWkMwws6f+h73GPoAefGT6A8mYMykYuzx
        SRr8MGcm2uRpQyaH5tkAyMKnqz250WHwWw==
X-Google-Smtp-Source: APXvYqw7E9cYYY6FRoqF3UcS67LZUoOUFZTzhRcRYxOYoFT6ut0iZqIwp8eUPrJ0yU2fwDFeLPE8YQ==
X-Received: by 2002:a2e:5d5b:: with SMTP id r88mr5481960ljb.170.1571389681287;
        Fri, 18 Oct 2019 02:08:01 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 21sm1958541ljq.15.2019.10.18.02.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 02:08:00 -0700 (PDT)
References: <20191017094416.7688-1-jakub@cloudflare.com> <1651dcc4-51a8-dfb2-a4ba-87c61fc0e2b4@fb.com>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next] scripts/bpf: Print an error when known types list needs updating
In-reply-to: <1651dcc4-51a8-dfb2-a4ba-87c61fc0e2b4@fb.com>
Date:   Fri, 18 Oct 2019 11:07:59 +0200
Message-ID: <87o8yectg0.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, Oct 17, 2019 at 07:11 PM CEST, Andrii Nakryiko wrote:
> On 10/17/19 2:44 AM, Jakub Sitnicki wrote:

[...]

>> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
>> index 75b538577c17..26c202261c5f 100644
>> --- a/tools/lib/bpf/Makefile
>> +++ b/tools/lib/bpf/Makefile
>> @@ -169,7 +169,8 @@ $(BPF_IN): force elfdep bpfdep bpf_helper_defs.h
>>   
>>   bpf_helper_defs.h: $(srctree)/include/uapi/linux/bpf.h
>>   	$(Q)$(srctree)/scripts/bpf_helpers_doc.py --header 		\
>> -		--file $(srctree)/include/uapi/linux/bpf.h > bpf_helper_defs.h
>> +		--file $(srctree)/include/uapi/linux/bpf.h > $@.tmp
>> +	@mv $@.tmp $@
>
> This is unnecessary. Let's add ".DELETE_ON_ERROR:" at the end Makefile 
> instead to trigger this auto-deletion of failed targets automatically.

Thanks for the hint. Will respin it.

-Jakub
