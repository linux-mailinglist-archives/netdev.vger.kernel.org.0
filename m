Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2BEF5A1BC3
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244274AbiHYV5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244249AbiHYV47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:56:59 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B8E5853C;
        Thu, 25 Aug 2022 14:56:58 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id w19so42104867ejc.7;
        Thu, 25 Aug 2022 14:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=xRUl7QGewtJmylCUM+rfOCstJR9UgslfLxf7gT5F90g=;
        b=GZGp07GBTpTjaJoIdqES47TWEiCxFWnuOOJoosqV9QVnXUabMYfFc8hZ71MPb+8biZ
         x7RUNVXXZMfsTxsdJbz6W1+ukzwUhuKKuuyLZ08RFBmjgyfA9rQbfN0ihT3LmGkljO7S
         mxXGQTKhjqHnlieX76H6tVbFLHbJze/W0qXKNRy1dxUenzsdC+omk0fO5g/HJqlpa4W8
         yzSKNq0Uoq0RzUHx+kiCPTzSKTIV8J1MDBPHpkXVCkFfjEddUxsBtVBmgWJoYFbAtXL6
         s9KZ79sLgTwrM2nOoFXDRWdq6MqopHmMenhVfvOIFhv6RX2lwXLgLc24Q4/0EnuC+M7E
         hG2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=xRUl7QGewtJmylCUM+rfOCstJR9UgslfLxf7gT5F90g=;
        b=jyl2o+QXpN+wQm9XWSWqfMm7OCZJndKwiRlKHqb2AyPiQIgnAJNxkQjEVO6f3ndz+Z
         2n1S0JDREViESTzrFNgTH79bwZw4OQws7gAtllCswi/0X0mjaqv8azUok6MyqD9UDhVB
         w6bdGmqxvDD4gEbr0ARh2tmSElsWLn5QTecA+HODTBYJ62XCEp7+oAMbtklH/AT8z/qs
         OAF3C27fuZZmgkxDRG4MNHAtDR+DWMsCDLgOmMMCg+S5Lg3t5K6HOz72xwD1huUef3Rh
         YaJJsPy1SaK7G3jxBdgNBARFknpZfHIMAUjppJ0J1yVvh8jR27gnTBqOfnr5HiYtM3w+
         NxPQ==
X-Gm-Message-State: ACgBeo0uGbvowtvZxRfl0Uo6wr8ME/WKJfDGxSvTeEi3HILySJVuV7bX
        w3CqjiIohmVAJbIq0IRa0TOFiOfNnTj34vDMMS4=
X-Google-Smtp-Source: AA6agR5vaRU1YhCk8Vf6GHvIFPxoYILydursm2av9IttKqB+ZJff6NNSrHOuMAYdxe+NySUrNG8xVZIvuvw3IxoonjE=
X-Received: by 2002:a17:907:6096:b0:73d:9d12:4b04 with SMTP id
 ht22-20020a170907609600b0073d9d124b04mr3745892ejc.745.1661464616973; Thu, 25
 Aug 2022 14:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220825213905.1817722-1-haoluo@google.com>
In-Reply-To: <20220825213905.1817722-1-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 25 Aug 2022 14:56:45 -0700
Message-ID: <CAEf4BzaQOj3QqEbKKXhgUmWMF3gef-8+a-dYoe_t4=g+cM2KaQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] Add CGROUP prefix to cgroup_iter_order
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 2:39 PM Hao Luo <haoluo@google.com> wrote:
>
> As suggested by Andrii, add 'CGROUP' to cgroup_iter_order. This fix is
> divided into two patches. Patch 1/2 fixes the commit that introduced
> cgroup_iter. Patch 2/2 fixes the selftest that uses the
> cgroup_iter_order. This is because the selftest was introduced in a

but if you split rename into two patches, you break selftests build
and thus potentially bisectability of selftests regressions. So I
think you have to keep both in the same patch.

With that:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> different commit. I tested this patchset via the following command:
>
>   test_progs -t cgroup,iter,btf_dump
>
> Hao Luo (2):
>   bpf: Add CGROUP to cgroup_iter order
>   selftests/bpf: Fix test that uses cgroup_iter order
>
>  include/uapi/linux/bpf.h                      | 10 +++---
>  kernel/bpf/cgroup_iter.c                      | 32 +++++++++----------
>  tools/include/uapi/linux/bpf.h                | 10 +++---
>  .../selftests/bpf/prog_tests/btf_dump.c       |  2 +-
>  .../prog_tests/cgroup_hierarchical_stats.c    |  2 +-
>  .../selftests/bpf/prog_tests/cgroup_iter.c    | 10 +++---
>  6 files changed, 33 insertions(+), 33 deletions(-)
>
> --
> 2.37.2.672.g94769d06f0-goog
>
