Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D440F5F5F82
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 05:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiJFDVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 23:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiJFDUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 23:20:21 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C0137184;
        Wed,  5 Oct 2022 20:20:03 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id qn17so1820761ejb.0;
        Wed, 05 Oct 2022 20:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kl6vLfdqF2ET91PW5YnTTZdZIlk/zQZbqzIMjm66yoQ=;
        b=LCGVxeH+I4troi2RSQVpOlQ4NXWo4rUpqYlePzuFwhfd3YM1bvNwKSeMEjZI0q24SP
         +qtaaZ3R0ASA1zYCA5habCPd53q7y2OOhMZdeuXeVSlceNjJcu+r60+BZ7xbkCZZG02W
         fzRxSPk9odnHvPGk0Hh3dKWNBrgvEshZgIRsoerQv7DQ9KqX8hvGIMAx7KoiFezmg2BV
         PvK8gPWyoQW5VD+dxvSetip9GHk5SVZ+Be+WYKHRz6XAtKZraACH0ApGUcON4zKHdOQ8
         cv43eQvR0hPXZXQJ7ReYg9KnyHC+yjEWxN1z1QL/I6YWcF00RZQs6heW7xJz0/iqukLc
         TdgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kl6vLfdqF2ET91PW5YnTTZdZIlk/zQZbqzIMjm66yoQ=;
        b=hO44sABYmL35LI6TlXR3SAtTyZ8PVEB2SkEYh+SDhMssvY1gihBds1ZSm7EhPwuY0X
         5mzW++ClvG2BrAwVXslSrchePd5dZScZq08c7WOsPzEQVMnBjUdLBQb2Fe0yFGx+/Yyf
         PDzv5Dti0RyLEjNCf1rE77mtFc402bY2wtDr0GeTOzPN7DRJHVQXx9zUP9EcnrkhuYY7
         QLR9IdslXJByET5T7BXsqpjqTbgLikkP+MQ9vichQiQ4tQxV55gM8GZlE4T50n2IqKEy
         N1Enu7KibtdATzCvmN5yxzxUuLK7V0LYJbT/9urgMj/FUTnMx35I+ezuo67CChZbCdjL
         k9CA==
X-Gm-Message-State: ACrzQf3iyDwbjVw3k+SOvyKJUWs+yqiIBAVGKYKA7MfER+RuBNlPXAhM
        XeAsbJUUlo3txRoW9nQbwgN2eoHv4SyTZ6kYbWE=
X-Google-Smtp-Source: AMsMyM52AMLw4wsHPohN75FiHI1iNrPiQ09Y5txe8ACilx95hcRB8aI46GleO2bO3O6vJHWyCBcozYbTfkATrZ3ogi4=
X-Received: by 2002:a17:907:72c1:b0:783:34ce:87b9 with SMTP id
 du1-20020a17090772c100b0078334ce87b9mr2186260ejc.115.1665026401784; Wed, 05
 Oct 2022 20:20:01 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-11-daniel@iogearbox.net>
In-Reply-To: <20221004231143.19190-11-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Oct 2022 20:19:49 -0700
Message-ID: <CAEf4Bzapj27OtLZPo9Gd8F0LWj+VKiXfRwPhN0uWip+WxhyyVA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/10] bpf, selftests: Add various BPF tc link selftests
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 4, 2022 at 4:12 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add a big batch of selftest to extend test_progs with various tc link,
> attach ops and old-style tc BPF attachments via libbpf APIs. Also test
> multi-program attachments including mixing the various attach options:
>
>   # ./test_progs -t tc_link
>   #179     tc_link_base:OK
>   #180     tc_link_detach:OK
>   #181     tc_link_mix:OK
>   #182     tc_link_opts:OK
>   #183     tc_link_run_base:OK
>   #184     tc_link_run_chain:OK
>   Summary: 6/0 PASSED, 0 SKIPPED, 0 FAILED
>
> All new and existing test cases pass.
>
> Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

Few small things.

First, please make sure to not use CHECK and CHECK_FAIL.

Second, it's kind of sad that we need to still check
ENABLE_ATOMICS_TESTS guards. I'd either not do that at all, or I
wonder if it's cleaner to do it in one header and just re-#define
__sync_fetch_and_xxx to be no-ops. This will make compilation not
break. And then tests will just be failing at runtime, which is fine,
because they can be denylisted. WDYT?

>  .../selftests/bpf/prog_tests/tc_link.c        | 756 ++++++++++++++++++
>  .../selftests/bpf/progs/test_tc_link.c        |  43 +
>  2 files changed, 799 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_link.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_tc_link.c
>

[...]
