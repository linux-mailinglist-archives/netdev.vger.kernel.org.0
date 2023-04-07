Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1AB6DAAEC
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 11:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240571AbjDGJdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 05:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbjDGJdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 05:33:49 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0784DA9;
        Fri,  7 Apr 2023 02:33:48 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id d17so41829991wrb.11;
        Fri, 07 Apr 2023 02:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680860026; x=1683452026;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OYgztIeWnyctC1xAXIkENttsLePYFO0qvVqXrHUGTFE=;
        b=Myq5QxowIaJrw1tkaMLL/nI0FbFDeDAb21nb7UhWvyGUx2/X2kEyBIOe04o9H2fW2R
         wOOWzVOSttAV1C+Qk1hg3FaCQYldAitdI9pEh4JnlmQxIuXxAxLw3zG3F8jtvJK45dZl
         AwbOb8TmdBWl0sdt/YWl5CRv8+B/anV//+cs4iSSPREllQ2N0mr401FzyshkaTc+SyL6
         lhQ8ZzNFbkxmMA9XB8uJmAs8tNoJfSWTJhGgmtFEfmHxhNvqTQXGNbdmiNV0pWYdIKC0
         L288Q7X0UN0n1JS4lJds5cFfNCjxA53ntuT1YAi7gUKd2zzWkGxsPOR4tCcmE7wU0o/9
         Iduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680860026; x=1683452026;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OYgztIeWnyctC1xAXIkENttsLePYFO0qvVqXrHUGTFE=;
        b=mITEd6ZUr8N0JCThAYWRNvMHKLhr/GtkpdOtC+b4pqY2vAdu24x4nY3RaCxR6ULgRu
         avaWtqfw3vsbt86XvuW0gQlEQoj2VAPEzS4vkyUWNsxz2L9fxk6hcSLCHatIfymVbSpb
         jwTCmemJBuCqcSdXSj9fClacbSva6D92aTYWihQEJDQGhvOOXHXy3OMD3ykZ9LzywZsH
         jWIy7OUQAn30rxCfzSrt9o0bJ3t2s00DSYcahXf694UPuIaXlc7e//zfI6MoAxkzXpcI
         V8P9GaEIXaKaDCis0xCQriPdOPsQKIVRajmlfvO4ONyBYQ+hV++VdeM32UoWRJOdCNSm
         nTmw==
X-Gm-Message-State: AAQBX9eGUje78P1cmLFoNeOOO2WOpOGgSWQXpyI1ha5RnuTM5MVX63Vs
        0NJ1aPY/Bi1HMgA8nA9DkK4=
X-Google-Smtp-Source: AKy350aFIipI7sQMqgOhqjQg9W6ev4YprQm5udW9oq1kqk3vDY8cnmI0fLS8MR+L6VXejMvIzN33Mw==
X-Received: by 2002:a5d:40c3:0:b0:2c7:e5f:e0e0 with SMTP id b3-20020a5d40c3000000b002c70e5fe0e0mr1239375wrq.65.1680860026321;
        Fri, 07 Apr 2023 02:33:46 -0700 (PDT)
Received: from krava ([82.153.29.117])
        by smtp.gmail.com with ESMTPSA id f4-20020adff8c4000000b002cff06039d7sm4097349wrq.39.2023.04.07.02.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 02:33:45 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 7 Apr 2023 10:33:43 +0100
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, yangzhenze@bytedance.com,
        wangdongdong.6@bytedance.com, zhouchengming@bytedance.com
Subject: Re: [PATCH v2 0/2] Fix failure to access u32* argument of tracked
 function
Message-ID: <ZC/jd2gN3kJ+tPWF@krava>
References: <20230407084608.62296-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407084608.62296-1-zhoufeng.zf@bytedance.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 04:46:06PM +0800, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> When access traced function arguments with type is u32*, bpf verifier failed.
> Because u32 have typedef, needs to skip modifier. Add btf_type_is_modifier in
> is_int_ptr. Add a selftest to check it.
> 
> Feng Zhou (2):
>   bpf/btf: Fix is_int_ptr()
>   selftests/bpf: Add test to access u32 ptr argument in tracing program

hi,
it breaks several tests in test_progs suite:

#11/36   bpf_iter/link-iter:FAIL
#11      bpf_iter:FAIL
test_dummy_st_ops_attach:FAIL:dummy_st_ops_load unexpected error: -13
#63/1    dummy_st_ops/dummy_st_ops_attach:FAIL
test_dummy_init_ret_value:FAIL:dummy_st_ops_load unexpected error: -13
#63/2    dummy_st_ops/dummy_init_ret_value:FAIL
test_dummy_init_ptr_arg:FAIL:dummy_st_ops_load unexpected error: -13
#63/3    dummy_st_ops/dummy_init_ptr_arg:FAIL
test_dummy_multiple_args:FAIL:dummy_st_ops_load unexpected error: -13
#63/4    dummy_st_ops/dummy_multiple_args:FAIL
test_dummy_sleepable:FAIL:dummy_st_ops_load unexpected error: -13
#63/5    dummy_st_ops/dummy_sleepable:FAIL
#63      dummy_st_ops:FAIL
test_fentry_fexit:FAIL:fentry_skel_load unexpected error: -13
#69      fentry_fexit:FAIL
test_fentry_test:FAIL:fentry_skel_load unexpected error: -13
#70      fentry_test:FAIL

jirka

> 
> Changelog:
> v1->v2: Addressed comments from Martin KaFai Lau
> - Add a selftest.
> - use btf_type_skip_modifiers.
> Some details in here:
> https://lore.kernel.org/all/20221012125815.76120-1-zhouchengming@bytedance.com/
> 
>  kernel/bpf/btf.c                                    |  5 ++---
>  net/bpf/test_run.c                                  |  8 +++++++-
>  .../testing/selftests/bpf/verifier/btf_ctx_access.c | 13 +++++++++++++
>  3 files changed, 22 insertions(+), 4 deletions(-)
> 
> -- 
> 2.20.1
> 
