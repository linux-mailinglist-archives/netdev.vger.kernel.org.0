Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1D02B2AE5
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 03:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgKNCwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 21:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgKNCwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 21:52:15 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F698C0613D1;
        Fri, 13 Nov 2020 18:52:15 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id z2so10223889ilh.11;
        Fri, 13 Nov 2020 18:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ycIyPMDjkSS7PdzQwF+KR5TdpC11byyZf5kQwCB3Uww=;
        b=YTQx+SsiKyBIRWywtlSXtPw1Aa1ndy7wddrYsevbLv3qEpfat6e6H0iZoMqJv6SbBk
         Nxo1p3uSbAIWSBxssTRzwVlZHkeV3Ek87bGcKhKhMTTSqGv5rCGZkaYLj+FCqmulnFqt
         pUe98HjK2bxEHQKmGvvtPKYasNzdfMpwmUfgJKWMK2HsjVtrkIGrJwmPsCCme13koneS
         MSkZ9W5oT7Ypavl25QxwocQ7ieOBXYNn92FDUrpmrTpEWblY53D57Lf5AhESBpcn4Ha7
         V9ShbIHz1ZnvM/iZsrgabkzA5tL6PTUxbBh6Ul7LteJzjb5uF/kVVjUxyphJj4tPPLzE
         +95Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ycIyPMDjkSS7PdzQwF+KR5TdpC11byyZf5kQwCB3Uww=;
        b=NW8bDPWjg/OLcBss0OYj+UKjve3MMXKr8fvPy2vGnduY9w8roP3Ow5IKGNGvRUPP5q
         RrNriHXFVkkaJmmCeAo6aGA94pZeoYp8fn+1II9gYfWazIY3iEsJ4zUHzlOBm2pjEMVx
         vKM54bDQkxLv4h/ABa+X1LdbvNHe1kEnHDj6nW/O3gVL4GrRpOO5l23Qq4EcRfUeg7fB
         FnqXN6UltOuMqtWh3gwIhAMSOAit/U11OkBUj68lrG9KSOXlQa8mMoo06PsGm4ZJZWi3
         fjIjAg7mOuu6SFI2EdJBiwZtZXzW6I5ByGhqB1HPYvi684XBWxEroDOx1w2KVkh19Byi
         q8Gg==
X-Gm-Message-State: AOAM531sNWVPMYX8R6Gs3kd7vpHAeDnKAoX1dcYhcAZGsNhWqjNLIJ2p
        ntcLEsIBmXFeA8IZ13ThC4Q=
X-Google-Smtp-Source: ABdhPJxs2blg1UPLBx8x5sB7WrDxyuLggjwojuwo7PZGH8HuErJjf7rf8jKIoCxIwzRtsmV99luHnQ==
X-Received: by 2002:a92:1599:: with SMTP id 25mr2099167ilv.271.1605322334605;
        Fri, 13 Nov 2020 18:52:14 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:99e7:10e8:ee93:9a3d])
        by smtp.googlemail.com with ESMTPSA id z18sm5254773iol.32.2020.11.13.18.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 18:52:13 -0800 (PST)
Subject: Re: [net-next,v2,4/5] seg6: add support for the SRv6 End.DT4 behavior
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
 <20201107153139.3552-5-andrea.mayer@uniroma2.it>
 <20201110151255.3a86afcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201113022848.dd40aa66763316ac4f4ffd56@uniroma2.it>
 <34d9b96f-a378-4817-36e8-3d9287c5b76b@gmail.com>
 <20201113085547.68e04931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <bd3712b6-110b-acce-3761-457a6d2b4463@uniroma2.it>
 <09381c96-42a3-91cd-951b-f970cd8e52cb@gmail.com>
 <20201113114036.18e40b32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201113134010.5eb2a154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201114000024.614c6c097050188abc87a7ff@uniroma2.it>
 <20201113155437.7d82550b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201114025058.25ae815024ba77d59666a7ab@uniroma2.it>
 <20201113180126.33bc1045@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201114032948.895abbf4d9a12758fc702ce6@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1303ab2b-e165-43e5-d16b-ade5eb0fc87d@gmail.com>
Date:   Fri, 13 Nov 2020 19:52:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201114032948.895abbf4d9a12758fc702ce6@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/20 7:29 PM, Andrea Mayer wrote:
> Hi Jakub,
> 
> On Fri, 13 Nov 2020 18:01:26 -0800
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
>>> UAPI solution 2
>>>
>>> we turn "table" into an optional parameter and we add the "vrftable" optional
>>> parameter. DT4 can only be used with the "vrftable" (hence it is a required
>>> parameter for DT4).
>>> DT6 can be used with "vrftable" (new vrf mode) or with "table" (legacy mode)
>>> (hence it is an optional parameter for DT6).
>>>
>>> UAPI solution 2 examples:
>>>
>>> ip -6 route add 2001:db8::1/128 encap seg6local action End.DT4 vrftable 100 dev eth0
>>> ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 vrftable 100 dev eth0
>>> ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 table 100 dev eth0
>>>
>>> IMO solution 2 is nicer from UAPI POV because we always have only one 
>>> parameter, maybe solution 1 is slightly easier to implement, all in all 
>>> we prefer solution 2 but we can go for 1 if you prefer.
>>
>> Agreed, 2 looks better to me as well. But let's not conflate uABI with
>> iproute2's command line. I'm more concerned about the kernel ABI.
> 
> Sorry I was a little imprecise here. I reported only the user command perspective.
> From the kernel point of view in solution 2 the vrftable will be a new
> [SEG6_LOCAL_VRFTABLE] optional parameter.
> 
>> BTW you prefer to operate on tables (and therefore require
>> net.vrf.strict_mode=1) because that's closer to the spirit of the RFC,
>> correct? As I said from the implementation perspective passing any VRF
>> ifindex down from user space to the kernel should be fine?
> 
> Yes, I definitely prefer to operate on tables (and so on the table ID) due to
> the spirit of the RFC. We have discussed in depth this design choice with
> David Ahern when implementing the DT4 patch and we are confident that operating
> with VRF strict mode is a sound approach also for DT6. 
> 

I like the vrftable option. Straightforward extension from current table
argument.
