Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802F629E4A4
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbgJ2Hkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727881AbgJ2HYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:54 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6503BC0613D9;
        Wed, 28 Oct 2020 20:00:44 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id v18so1688437ilg.1;
        Wed, 28 Oct 2020 20:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i7Ow4u8D0fPuatR4zr61n5yn7HZVU4bz/5N1zCK4uDg=;
        b=tfv2tW0V63nM1QaVvsGOSxrXlN5OWEfwILkpQqP+xG8LFg0VPuxxs7y1w58/kkpcSt
         A9Lm7CfX8gwpUl26fxo96fqKnzGQ1gw06YFhurabE6zE8eVnroVd8UbY5gRHsrBsSkI9
         kkpKDIFRpPMjXTo4xTKb4rwtEHBCwuwHyZmmHmBPkPt9uBeWGoGIkmQMB432E2eATYkA
         p+3OxrFQh9ilDuIxbqcdIM/0qb12lfVOgaQU4vsh6WOvyRTDzonThcG8udNpWqYA3Zrq
         9lQ47z6KdDupbHd4qhfQWYbp2mQnDTWYC7yYsfOV/9Wsj4fEMQpWZ8af9DgafZvRfXDK
         1B/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i7Ow4u8D0fPuatR4zr61n5yn7HZVU4bz/5N1zCK4uDg=;
        b=jr8X2NsxIkOVYkBi70IsNdkjEbpbORM7pWW0LmXS49bRoqqEO4UkxnCIaexG5QYAok
         XADl6uRlRij/ickq+axTezyxSelJI1XaoFTLstX33YyyFhCo53fQ17NEQngUf7CgKozQ
         IaQ/02Ek6UHfUMhjqKZBiNN3+3iEoiJ3BytkJ2DbK8E1xBqZyDL3S0/egFri7suEqQCw
         nyh7fIkdWV9l/4kUKgWZdSdFYp7zK2mcasQyn9yipwyCF4se+CTlT0bxuhLP0DGGaaCC
         a3sgR9y10Vx4eBoI5Qmx/5jpZSiBFSM1aHrUf+I9WKlvzVDVrdQiYc75lxMqmEXAm0Hz
         TgqA==
X-Gm-Message-State: AOAM530TlWMwjAEFkLLS+54PxeFcBa97M5TsTMqCqZA8NadyhnX3JlOr
        V8H0epcvu4k+8UQm3WYNNvs=
X-Google-Smtp-Source: ABdhPJxPDHG0VzcdukFd916I+eL89yTe7xAZEpusFO5fCilAL0gHYMv3LZ/3lbmAhLS2C1CJE2S11w==
X-Received: by 2002:a92:5e5c:: with SMTP id s89mr1600768ilb.179.1603940443245;
        Wed, 28 Oct 2020 20:00:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e1b0:db06:9a2d:91c5])
        by smtp.googlemail.com with ESMTPSA id x13sm978846iob.8.2020.10.28.20.00.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 20:00:42 -0700 (PDT)
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201028132529.3763875-1-haliu@redhat.com>
 <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com>
 <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
 <7a412e24-0846-bffe-d533-3407d06d83c4@gmail.com>
 <20201029024506.GN2408@dhcp-12-153.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <99d68384-c638-1d65-5945-2814ccd2e09e@gmail.com>
Date:   Wed, 28 Oct 2020 21:00:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201029024506.GN2408@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/20 8:45 PM, Hangbin Liu wrote:
> On Wed, Oct 28, 2020 at 08:20:55PM -0600, David Ahern wrote:
>>>> root@u2010-sfo3:~/iproute2.git# make -j 4
>>>> ...
>>>> /usr/bin/ld: ../lib/libutil.a(bpf_libbpf.o): in function `load_bpf_object':
>>>> bpf_libbpf.c:(.text+0x3cb): undefined reference to
>>>> `bpf_program__section_name'
>>>> /usr/bin/ld: bpf_libbpf.c:(.text+0x438): undefined reference to
>>>> `bpf_program__section_name'
>>>> /usr/bin/ld: bpf_libbpf.c:(.text+0x716): undefined reference to
>>>> `bpf_program__section_name'
>>>> collect2: error: ld returned 1 exit status
>>>> make[1]: *** [Makefile:27: ip] Error 1
>>>> make[1]: *** Waiting for unfinished jobs....
>>>> make: *** [Makefile:64: all] Error 2
>>>
>>> You need to update libbpf to latest version.
>>
>> nope. you need to be able to handle this. Ubuntu 20.10 was just
>> released, and it has a version of libbpf. If you are going to integrate
>> libbpf into other packages like iproute2, it needs to just work with
>> that version.
> 
> OK, I can replace bpf_program__section_name by bpf_program__title().

I believe this one can be handled through a compatability check. Looks
the rename / deprecation is fairly recent (78cdb58bdf15f from Sept 2020).


>>
>>>
>>> But this also remind me that I need to add bpf_program__section_name() to
>>> configure checking. I will see if I missed other functions' checking.
>>
>> This is going to be an on-going problem. iproute2 should work with
>> whatever version of libbpf is installed on that system.
> 
> I will make it works on Ubuntu 20.10, but with whatever version of libbpf?
> That looks hard, especially with old libbpf.
> 

I meant what comes with the OS. I believe I read that Fedora 33 was just
released as well. Does it have a version of libbpf? If so, please verify
it compiles and works with that version too. Before committing I will
also verify it compiles and links against a local version of libbpf (top
of tree) just to get a range of versions.
