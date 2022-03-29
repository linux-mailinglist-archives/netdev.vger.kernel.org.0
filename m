Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6ACE4EB729
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 01:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241309AbiC2Xx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 19:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241278AbiC2Xxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 19:53:40 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908DD220313;
        Tue, 29 Mar 2022 16:51:44 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id 9so19791432iou.5;
        Tue, 29 Mar 2022 16:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RDogiJksgjzBWpwHPtzcTuV6/G2WximRelWOGofFAwA=;
        b=eE9f8EWWk2jX0JwQUKtnzgRnYi2N0AvWuh6ToR3VtYtAx9khkdxlw7CLNFueZZ06Fw
         chf2vahBcCfJ9ZH0fsDoguL9rhNY6DywAtKvL9L8/mA9DksssSdIG/c4/Dctl3QfUNl2
         VBa2XOM1p4dCRF+peXurjcOqOZ93XNZMmiXDaUGkG2nC94q6ppM3k9Z0W2mnHl2EgOdh
         /eTdjPoEguFRuIJiq67YBKc1oIN7XJnYo1J8OJwRMaO/Z8IrqAHxAjfV9KegXGfRoBqU
         GRaq1Xbb6J7KLMqTWqjAKhiAhDWpX2GxM95KbLx8RT0RozT4+ho3+VIxYmK6S2YXVU+N
         MChA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RDogiJksgjzBWpwHPtzcTuV6/G2WximRelWOGofFAwA=;
        b=70NGCoUIFoUyAkrRgEQH9bU0N+6fIMXDk3RaioiYmSl2US3+5n5flND1LDtCWgakSo
         H06/RCgmdb67kwUx0KYNWdq3ULb2NttTkMkRQctUHifs8iUGu8ZUYZ7ScHjbOXw4VAPP
         ynWENuRY55uIvHH77RA9eJ+vea0dvCv9YTGsVX3zAm931Wxqy+MwpL6HvAjBbrKOh9Y9
         Ea5VfmmZagXAE+wruPrZ87dquvAJy5iBXSCm5LCDqSmFCck8oj1PWYDbPGlcmD1FZRMH
         OBNRoZNcJnaazBj0GPe7VrkvnOryhTO6A+cYiiZrDDaSl/lFloZQ1Kkg8Jsm4Cv29G25
         Hg/w==
X-Gm-Message-State: AOAM5333+pKUgrMkKtIuW/0OxmvRxsQIgnmVLEzxSuZ4Un7iTcMPx65R
        aaW7WfWN3OJ9jrjQOrW6yCcaRBzV2Oevc3eYozs=
X-Google-Smtp-Source: ABdhPJyeOFDxVD5tZQV3SlV4JtXzW4tlmY2Yr1iyvweyD/ph7Dk90xBFCNcaXZEuGWOqIT4nYr/YPbiOeF0msD+cjC0=
X-Received: by 2002:a05:6638:3395:b0:323:8a00:7151 with SMTP id
 h21-20020a056638339500b003238a007151mr2661460jav.93.1648597903968; Tue, 29
 Mar 2022 16:51:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220328175033.2437312-1-roberto.sassu@huawei.com> <20220328175033.2437312-6-roberto.sassu@huawei.com>
In-Reply-To: <20220328175033.2437312-6-roberto.sassu@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 29 Mar 2022 16:51:32 -0700
Message-ID: <CAEf4BzY9d0pUP2TFkOY41dbjyYrsr5S+sNCpynPtg_9XZHFb-Q@mail.gmail.com>
Subject: Re: [PATCH 05/18] bpf-preload: Generate static variables
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        Mimi Zohar <zohar@linux.ibm.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
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

On Mon, Mar 28, 2022 at 10:52 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> The first part of the preload code generation consists in generating the
> static variables to be used by the code itself: the links and maps to be
> pinned, and the skeleton. Generation of the preload variables and methods
> is enabled with the option -P added to 'bpftool gen skeleton'.
>
> The existing variables maps_link and progs_links in bpf_preload_kern.c have
> been renamed respectively to dump_bpf_map_link and dump_bpf_prog_link, to
> match the name of the variables in the main structure of the light
> skeleton.
>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  kernel/bpf/preload/bpf_preload_kern.c         |  35 +-
>  kernel/bpf/preload/iterators/Makefile         |   2 +-
>  .../bpf/preload/iterators/iterators.lskel.h   | 378 +++++++++---------
>  .../bpf/bpftool/Documentation/bpftool-gen.rst |   5 +
>  tools/bpf/bpftool/bash-completion/bpftool     |   2 +-
>  tools/bpf/bpftool/gen.c                       |  27 ++
>  tools/bpf/bpftool/main.c                      |   7 +-
>  tools/bpf/bpftool/main.h                      |   1 +
>  8 files changed, 254 insertions(+), 203 deletions(-)
>

[...]

> +__attribute__((unused)) static void
> +iterators_bpf__assert(struct iterators_bpf *s)
> +{
> +#ifdef __cplusplus
> +#define _Static_assert static_assert
> +#endif
> +#ifdef __cplusplus
> +#undef _Static_assert
> +#endif
> +}
> +
> +static struct bpf_link *dump_bpf_map_link;
> +static struct bpf_link *dump_bpf_prog_link;
> +static struct iterators_bpf *skel;

I don't understand what is this and what for? You are making an
assumption that light skeleton can be instantiated just once, why? And
adding extra bpftool option to light skeleton codegen just to save a
bit of typing at the place where light skeleton is actually
instantiated and used doesn't seems like a right approach.

Further, even if this is the way to go, please split out bpftool
changes from kernel changes. There is nothing requiring them to be
coupled together.

[...]
