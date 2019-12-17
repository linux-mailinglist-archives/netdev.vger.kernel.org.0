Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 180B3121FCF
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfLQAeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:34:19 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38748 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfLQAeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:34:19 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so6540006pfc.5;
        Mon, 16 Dec 2019 16:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1h1Iwz1p6Zo/ukp1R0ap2/6hRtPwN7RSZ1DZgQh/1Ao=;
        b=AQU2XrRvMlB7dwKwoq8N+9eEDeEofQgPyRwFOSUuiRQRnqcfy2VPD5+4q8FNeLttR2
         KrGhzqeKXQwIttvZJ1gQQkyvnawZGVAzzlpNmva4JVtPX3WC+JIjB7B0mGHg6BDCkOrg
         avtmcmNJUDx0Z/h8VmEJKIjaxscmC46lEwG9lP29+8Eqhg9eWpn2+ibKwfqYS+1gI+kV
         hlpHiSEhm2F9++xEzTNRRTqeDrq/r+5GbOqRVaNsxEprKdTm89dRxBLK3MvUxNINPrEH
         GayEpxD+rIyYw7AM7uwWOhla5gqpLdUbDLN7C42qJWW7RCdG1waYWI/m8QoEh0864dIy
         jsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1h1Iwz1p6Zo/ukp1R0ap2/6hRtPwN7RSZ1DZgQh/1Ao=;
        b=QXjlHimY+QWpf0O5QWapWll8rpUKpzwztxXeAB36Q/ETW81bQ4LXvhZoq021nTofE6
         0bDwIRpvej6n3z6yk4Z+63+Rln1monXcOmyY/H2YKM6X+SRQY+jvtixlkq6KIYoycyvZ
         QnyhuS4GVxA5Qt5HR3jBhSYCICaPIgqM746kSlr0dCDjSsbwG7Yuy1PkVh2cgvBZZnn0
         njYbLUKr8wQUHG/ly5Ge1/Pd659mvai4fSB5Arr3GhpnLDgvwWFxgBRJbenIy/dFfCLy
         HFvri+UR+AWYrEMEHQueEhcopJacwuOxifyX1UwuXWYZqjycJF/pFdHbpccifnIan1yp
         fItQ==
X-Gm-Message-State: APjAAAVUiH9GiS4NNRQtz64YQ4duyVLjv0xczyZVKH5yCSuYBUaLljVt
        +kayLiIyeeasQLT3/ZOqrj7hPGoH
X-Google-Smtp-Source: APXvYqy0zzm+r1BfaDsZX2/8BwRZ68vXgSLCGDStwzafK3/dJpDA2vCVBryTrlCrXkh1nTIxyBLRSw==
X-Received: by 2002:a63:1c13:: with SMTP id c19mr22113706pgc.450.1576542858306;
        Mon, 16 Dec 2019 16:34:18 -0800 (PST)
Received: from [192.168.84.57] ([107.84.158.73])
        by smtp.gmail.com with ESMTPSA id w11sm23787440pfn.4.2019.12.16.16.34.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 16:34:17 -0800 (PST)
Subject: Re: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
To:     Alexei Starovoitov <ast@fb.com>, Martin Lau <kafai@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004758.1653342-1-kafai@fb.com>
 <b321412c-1b42-45a9-4dc6-cc268b55cd0d@gmail.com>
 <20191216191357.ftadvchztbpggcus@kafai-mbp.dhcp.thefacebook.com>
 <d7bcc8c2-f531-91f5-47e6-d18d8a99c1e1@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d34fddb1-4477-12e7-8391-368fdf8ab964@gmail.com>
Date:   Mon, 16 Dec 2019 16:34:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d7bcc8c2-f531-91f5-47e6-d18d8a99c1e1@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/19 3:08 PM, Alexei Starovoitov wrote:
> On 12/16/19 11:14 AM, Martin Lau wrote:
>> At least for bpf_dctcp.c, I did not expect it could be that close to tcp_dctcp.c
>> when I just started converted it.  tcp_cubic/bpf_cubic still has some TBD
>> on jiffies/msec.
>>
>> Agree that it is beneficial to have one copy.   It is likely
>> I need to make some changes on the tcp_*.c side also.  Hence, I prefer
>> to give it a try in a separate series, e.g. revert the kernel side
>> changes will be easier.
> 
> I've looked at bpf_cubic.c and bpf_dctcp.c as examples of what this
> patch set can do. They're selftests of the feature.
> What's the value of keeping them in sync with real kernel cc-s?
> I think it's fine if they quickly diverge.
> The value of them as selftests is important though. Quite a bit of BTF
> and verifier logic is being tested.
> May be add a comment saying that bpf_cubic.c is like cubic, but doesn't
> have to be exactly cubic ?
> 

The reason I mentioned this is that I am currently working on a fix of Hystart
logic, which is quite broken at the moment.

(hystart_train detection triggers in cases it should not)

But yes, if we add a comment warning potential users, this should be fine.
