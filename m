Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257C84D3C28
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbiCIViN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237273AbiCIViM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:38:12 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EFDFABC0
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:37:11 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id q11so3093026pln.11
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 13:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wlzgTk54ceIcRNUIRfltpizWVBeZoYCRZ8q4Bed9oLE=;
        b=VbMpg2UEFOZKZXQ5NwnPX9SeOVkeE9/ZhzMl1B8h7Hb0C9SPsw2hRuqRoes9stgpG9
         1FB3SRLXSUXMvALYlhQ9dXYr+e7EVet/DAaXZ4MzxtD8V2glb/+okoXBx/eKxbS3DCX5
         KFPv/VFcQ6+a0U1htGoniK7qBY9J7FkUfYYchQY5l0XQDrRHg6X93ApRbOKYQHQnHk9T
         cv5WoO3ZM2UwLm4Dc0JHLIF9gbBvNm/yb2rrlfUUKBMFd+JffuJu/mF/sd4nz1jpquGH
         5FhAWy1r/wN12TTsYuzFc6O1eCQHBMYn42rOLHw7ydiupIAp0bEGo2xnTFr1ZN9K+n72
         576g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wlzgTk54ceIcRNUIRfltpizWVBeZoYCRZ8q4Bed9oLE=;
        b=OM349QI+S3A3zGdvfIe90InoBFoLqY1cWg7pKo215BzvZbXXfJhc7BA6+5VP/m5YJa
         yMJYDPyZ1jvNfiQQi8pX/kiF7d5wxAXTm90if+q1VUcM/fp1CL7yaCgAsC02BB7p7apC
         9Ix8S2DG5KCucsc1GU0O0A3rIehJzx42O/O2MqlciquPi09gr5hzbv4VkDOPkzXGHZLy
         EfpBed9tJeIcD4XmBQGnwho+WSc22yf8OULMBfxJXe3AfkjsG+d+LLIgnVlMILdmJzxW
         bgWQRfObWT+KoYjePdMoHxnO/7o0LJE++pirpBT8ls0s0Z/gagp8pPOUceaObohwBYNL
         Yh/Q==
X-Gm-Message-State: AOAM531CKDtzPUAzcf5Yfq8IjmQarfJzL2L0/6XiIa1Q890V8szDd2UQ
        d6Eoj3bVkzxzBRHxIkc0TJoBZg==
X-Google-Smtp-Source: ABdhPJwGMmx8SPY+CM0XimNEXYg9jCyiePtDuMoMlCxK7GllqQ3cz2ZD/SGfSjxiutbYdowCWGKajQ==
X-Received: by 2002:a17:90b:4f44:b0:1bf:61b2:4560 with SMTP id pj4-20020a17090b4f4400b001bf61b24560mr12287231pjb.245.1646861831400;
        Wed, 09 Mar 2022 13:37:11 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6da3a1a3bsm4189545pfk.8.2022.03.09.13.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 13:37:11 -0800 (PST)
Message-ID: <8fdab42f-171f-53d7-8e0e-b29161c0e3e2@linaro.org>
Date:   Wed, 9 Mar 2022 13:37:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: ipv6: fix invalid alloclen in __ip6_append_data
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com" 
        <syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com>
References: <20220308000146.534935-1-tadeusz.struk@linaro.org>
 <14626165dad64bbaabed58ba7d59e523@AcuMS.aculab.com>
 <6155b68c-161b-0745-b303-f7e037b56e28@linaro.org>
 <66463e26-8564-9f58-ce41-9a2843891d1a@kernel.org>
 <45522c89-a3b4-4b98-232b-9c69470124a3@linaro.org>
 <ff2e1007-5883-5178-6415-326d6ae69c34@kernel.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <ff2e1007-5883-5178-6415-326d6ae69c34@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/22 21:01, David Ahern wrote:
> On 3/8/22 12:46 PM, Tadeusz Struk wrote:
>> That fails in the same way:
>>
>> skbuff: skb_over_panic: text:ffffffff83e7b48b len:65575 put:65575
>> head:ffff888101f8a000 data:ffff888101f8a088 tail:0x100af end:0x6c0
>> dev:<NULL>
>> ------------[ cut here ]------------
>> kernel BUG at net/core/skbuff.c:113!
>> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
>> CPU: 0 PID: 1852 Comm: repro Not tainted
>> 5.17.0-rc7-00020-gea4424be1688-dirty #19
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35
>> RIP: 0010:skb_panic+0x173/0x175
>>
>> I'm not sure how it supposed to help since it doesn't change the
>> alloclen at all.
> 
> alloclen is a function of fraglen and fraglen is a function of datalen.

Ok, but in this case it doesn't affect the alloclen and it still fails.

-- 
Thanks,
Tadeusz
