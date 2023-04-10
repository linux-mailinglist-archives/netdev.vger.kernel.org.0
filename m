Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087C06DCBBF
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 21:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjDJTl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 15:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjDJTl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 15:41:27 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FE910D7;
        Mon, 10 Apr 2023 12:41:26 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id qa44so14589250ejc.4;
        Mon, 10 Apr 2023 12:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681155685; x=1683747685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RjhJwY4FOIXlFms6KNtP2v8GLCyXxsPBLdVucUFB1rs=;
        b=bEiwZG8qAJ1SYniRZo2X2drYcl/1FgZawxbTemLDbO1FDvEpyTzPW2SAkEx/N8UKRB
         ES+oAJ8DNLdzeOJtj3+C9nKo7TTsLWf0zXoQJYrgV/M+aEOtvLtKHZHN0aJ+Wkj+y4Ii
         EIbc4pEF9ANRKrXIbMFcWi8h28HLrOydqjceezZUS3quoRrC2dKGbP8Ron+PnxSEsqce
         fYPGJEj1LY4nmquXFcxjrOWHwD0xF2hUtk0ST+ziSqJZNCYzolfwLdTSVYJmSDIsvPm6
         6cpdOGUm8my/qACr0j86oUDEzqoQeeFRxAZDUmJ5BsF8HqcBz+yd02/v+pQnygeaalPx
         qInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681155685; x=1683747685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RjhJwY4FOIXlFms6KNtP2v8GLCyXxsPBLdVucUFB1rs=;
        b=jRkFs5wAY95q7Ow8Yw5Y6v7OSbWg8HNBIMZjxcyQat5S0ET8by4AtxRJuRXg2VdRQh
         mPMMvmoQspYtQZCMe8VIvXrJZ8lMscdBzAQC8Ya1ACisbPkPfSK0D47xJdCjvBnj9Tel
         3O7TuBCd7f4Mz7Elnbe6pOpu2MxRXQGKBTa1IyA/dLaMIU1b3mEB9YIcjIAE2gBwEzvY
         umFqpLZOj9UROq1pf1irgIJcYCFnJ2pr1AdKfVzTQphMd1kcOR46DPvYTYUDWZdHd/oW
         yhQpv+v9qWPnXUF4rhSQ+fDjJUolsjCQEwTJAYMgbHX8aU0keQ6pYzbyw0lZnHE6y8gp
         H4KQ==
X-Gm-Message-State: AAQBX9f70Z4j5b++hk6ShhrbIA1nbBuv0qFsRJdXfUxF5ZXjlCoFT7h9
        8RIweGU6jlAtJRN8uzLvgMk=
X-Google-Smtp-Source: AKy350beX6hSTgfjbEsLFR7OM2BItSH2dXbo/HD1madrhv8PglCTV4Cl+pNuo6iaZMPno/QLB+zI1A==
X-Received: by 2002:a17:906:c0a:b0:946:2fa6:3b85 with SMTP id s10-20020a1709060c0a00b009462fa63b85mr43779ejf.36.1681155684604;
        Mon, 10 Apr 2023 12:41:24 -0700 (PDT)
Received: from krava (ip-94-113-247-30.net.vodafone.cz. [94.113.247.30])
        by smtp.gmail.com with ESMTPSA id v21-20020a170906859500b0094a7c882638sm1573383ejx.90.2023.04.10.12.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 12:41:24 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 10 Apr 2023 20:41:21 +0100
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
Subject: Re: [PATCH v3 0/2] Fix failure to access u32* argument of tracked
 function
Message-ID: <ZDRmYaKnkQ9DpTeK@krava>
References: <20230410085908.98493-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410085908.98493-1-zhoufeng.zf@bytedance.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 04:59:06PM +0800, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> When access traced function arguments with type is u32*, bpf verifier failed.
> Because u32 have typedef, needs to skip modifier. Add btf_type_is_modifier in
> is_int_ptr. Add a selftest to check it.
> 
> Feng Zhou (2):
>   bpf/btf: Fix is_int_ptr()
>   selftests/bpf: Add test to access u32 ptr argument in tracing program
> 
> Changelog:
> v2->v3: Addressed comments from jirka
> - Fix an issue that caused other test items to fail
> Details in here:
> https://lore.kernel.org/all/20230407084608.62296-1-zhoufeng.zf@bytedance.com/

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka

> 
> v1->v2: Addressed comments from Martin KaFai Lau
> - Add a selftest.
> - use btf_type_skip_modifiers.
> Some details in here:
> https://lore.kernel.org/all/20221012125815.76120-1-zhouchengming@bytedance.com/
> 
>  kernel/bpf/btf.c                                    |  8 ++------
>  net/bpf/test_run.c                                  |  8 +++++++-
>  .../testing/selftests/bpf/verifier/btf_ctx_access.c | 13 +++++++++++++
>  3 files changed, 22 insertions(+), 7 deletions(-)
> 
> -- 
> 2.20.1
> 
