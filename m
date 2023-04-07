Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4A06DB00C
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240688AbjDGQBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240628AbjDGQBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:01:44 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29714EED
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 09:01:17 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-5131c8656d8so95722a12.3
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 09:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680883277;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N1Uez3TXMrT2npohTcaUYZfKhTFgEr4nUA9RHREMDAI=;
        b=XV1AWys35Q8M+z9Awh9qIXAKt3InWnPR8JVYfu4ywKURVkg+6nOl2WkYEtowGo08eb
         ox6d6+WNsaZeia5ZY27kThubyPKCgxwp0dGwahMqL5X3TiyvtnvUhFUoRep53qmR1Sl6
         RrO2PkFU5bEujD19FaPqGpgxPGUGqpClK36dcgh4fqWJjrh9HNlZEsF52P4wmeI55X+H
         66LAOF73Rfj4PpFzQXXndBWo0TVeEz9LUsNZ+54XkEqWNlOibvjNeZJQqKo40Ty6sHp0
         rGLkcETJj/AfZm0m/vp52FAh1tctF/GODM3vLjOZIjXGyXVxxEgPQpOzWpqaMG63FXIN
         FVBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680883277;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N1Uez3TXMrT2npohTcaUYZfKhTFgEr4nUA9RHREMDAI=;
        b=5wEHjhfdKv3VFaSsuOX7BprvWwLQX9wgyuYmj/FYAwMrj1ZHO0Y5dh4+mQbQzupOmV
         PCI4pG1hokc/5l9uZdZ9anwnIeW1w2siAb9n5KUaOSLGG6lKUZlrVq4qUXgf9sa0u6Lx
         XdmQSyROx7b3W0iMc/GB0W8bpNAtuX2XfESjrF+027MruPI2HA25C/9HpSUFQJuJvdD2
         z9iUxhSRT7tcMpWE3DhEpIV4kL6XK/sBZ/j9zf4qjUpz3EmzlaxMIKvDylw3g1NuDd+l
         0scx5hPu3gFbCXOUt2q0wIGimu7PlcRMRBQapaF+msqYL5fGFtJMZREhhayIGJgc9Hc2
         Ff1g==
X-Gm-Message-State: AAQBX9fUC1gqvH+WMJ/Su00gSxoHRZrMNeJyCKhq+YRqcmU2cV/lum/v
        YcqGDjopzlgSAnnkwwMXnJBJBA==
X-Google-Smtp-Source: AKy350ab2Po7AEL6zrXZ7DUwTatEwwhjKdorVTUMiwVWZB6L9JgmUhz21TiUxbPEGkl9xzmQzgV8pg==
X-Received: by 2002:a62:4ecd:0:b0:627:f659:a771 with SMTP id c196-20020a624ecd000000b00627f659a771mr2487474pfb.12.1680883276930;
        Fri, 07 Apr 2023 09:01:16 -0700 (PDT)
Received: from [10.4.75.112] ([139.177.225.245])
        by smtp.gmail.com with ESMTPSA id n8-20020a63f808000000b0051416609fb7sm2752389pgh.61.2023.04.07.09.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 09:01:16 -0700 (PDT)
Message-ID: <1a6c00f5-1e92-ecf7-f296-503ca89e4220@bytedance.com>
Date:   Sat, 8 Apr 2023 00:01:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: Re: [PATCH v2 0/2] Fix failure to access u32* argument of tracked
 function
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, yangzhenze@bytedance.com,
        wangdongdong.6@bytedance.com, zhouchengming@bytedance.com
References: <20230407084608.62296-1-zhoufeng.zf@bytedance.com>
 <ZC/jd2gN3kJ+tPWF@krava> <5a996423-8876-a1e1-9bf1-3af3ba309c1a@bytedance.com>
In-Reply-To: <5a996423-8876-a1e1-9bf1-3af3ba309c1a@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2023/4/7 18:49, Feng Zhou 写道:
> 在 2023/4/7 17:33, Jiri Olsa 写道:
>> On Fri, Apr 07, 2023 at 04:46:06PM +0800, Feng zhou wrote:
>>> From: Feng Zhou<zhoufeng.zf@bytedance.com>
>>>
>>> When access traced function arguments with type is u32*, bpf 
>>> verifier failed.
>>> Because u32 have typedef, needs to skip modifier. Add 
>>> btf_type_is_modifier in
>>> is_int_ptr. Add a selftest to check it.
>>>
>>> Feng Zhou (2):
>>>    bpf/btf: Fix is_int_ptr()
>>>    selftests/bpf: Add test to access u32 ptr argument in tracing 
>>> program
>> hi,
>> it breaks several tests in test_progs suite:
>>
>> #11/36   bpf_iter/link-iter:FAIL
>> #11      bpf_iter:FAIL
>> test_dummy_st_ops_attach:FAIL:dummy_st_ops_load unexpected error: -13
>> #63/1    dummy_st_ops/dummy_st_ops_attach:FAIL
>> test_dummy_init_ret_value:FAIL:dummy_st_ops_load unexpected error: -13
>> #63/2    dummy_st_ops/dummy_init_ret_value:FAIL
>> test_dummy_init_ptr_arg:FAIL:dummy_st_ops_load unexpected error: -13
>> #63/3    dummy_st_ops/dummy_init_ptr_arg:FAIL
>> test_dummy_multiple_args:FAIL:dummy_st_ops_load unexpected error: -13
>> #63/4    dummy_st_ops/dummy_multiple_args:FAIL
>> test_dummy_sleepable:FAIL:dummy_st_ops_load unexpected error: -13
>> #63/5    dummy_st_ops/dummy_sleepable:FAIL
>> #63      dummy_st_ops:FAIL
>> test_fentry_fexit:FAIL:fentry_skel_load unexpected error: -13
>> #69      fentry_fexit:FAIL
>> test_fentry_test:FAIL:fentry_skel_load unexpected error: -13
>> #70      fentry_test:FAIL
>>
>> jirka
>>
>
> I tried it, and it did cause the test to fail. Bpfverify reported an 
> error,
> 'R1 invalid mem access'scalar', let me confirm the reason.

I used btf_type_skip_modifiers，but did not delete
the previous "t = btf_type_by_id (btf, t- > type);"
resulting in some testcases failing. I will send a
v3 nextweek, thank you for your suggestion.


>>> Changelog:
>>> v1->v2: Addressed comments from Martin KaFai Lau
>>> - Add a selftest.
>>> - use btf_type_skip_modifiers.
>>> Some details in here:
>>> https://lore.kernel.org/all/20221012125815.76120-1-zhouchengming@bytedance.com/ 
>>>
>>>
>>>   kernel/bpf/btf.c                                    |  5 ++---
>>>   net/bpf/test_run.c                                  |  8 +++++++-
>>>   .../testing/selftests/bpf/verifier/btf_ctx_access.c | 13 
>>> +++++++++++++
>>>   3 files changed, 22 insertions(+), 4 deletions(-)
>>>
>>> -- 
>>> 2.20.1
>>>
>

