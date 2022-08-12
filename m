Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483B5590A0D
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 03:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbiHLB70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 21:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236346AbiHLB7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 21:59:22 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CC2A1D77;
        Thu, 11 Aug 2022 18:59:20 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id i84so16076930ioa.6;
        Thu, 11 Aug 2022 18:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=kA8/ZzUkIirFuUdvC9t2YcX215gChYzmInjE04Di1Uk=;
        b=aUfVP5Fy475KqO1Cx89rRHAlbx8ssSfBG0vDEioz80ORKM+spXwwyFBQdhcv/lpt3Y
         3l6Vupd/y+glwa5tEwE6jGU4R0owP4n6VEoJqZ5gGBIinQ0Fi1HVJFxpbN0InmB/sU9c
         wcMK1uhRdHNleGASKgZTTjaCNIJOtUAd3vI7NWod9uRfq/0q09Ei9WbxhvNutuafBgWZ
         yHZhWxhfSkOcfYDBhum+GRhBMNS/PJ1jhlIRKfUB6q1660CaWq2APq67xKGMcBVHEd2y
         LFE4e/hVeRWgUkC3dGbief7ohaIinrUyRNmZAEY8/T/Vo1c23f2EhtHWCirO37NEBTQL
         PL4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=kA8/ZzUkIirFuUdvC9t2YcX215gChYzmInjE04Di1Uk=;
        b=c8fKnrlH1v2sl4HXCWrNWdv2U21wE6Ll2DPlqYjK+rrM+KKgrK+qaY0A1wuhHShysW
         Vc8fo+iR2tHMEsOTSV9+DhxDQ/s+eSspVp1ZXSNS6/jQkeAgGxjJkWbsS6PkUiVhKaX/
         gysT8AkVRjmTQWp0gypGvEgbeM4C2FtuFw2iVF/UJITImU5vVx855QcP8dk2iOnDHsLJ
         QGED/4xI5zueyRvp3WKpEporZWwmlXC57YjKq/uxma52olmVt6QqjYIBhvDE39dybcXK
         ngDQ9OsS3T6t1HbnwkFgQr31fkW69VYM1LRLIP3b03e0rjGN4UgH2a6ZlNRIok/1S9m7
         UAvQ==
X-Gm-Message-State: ACgBeo3PwwF1Uxml/LXb/fUPqLfBtOnGUOaJNUt4YcrXb/Ssg0hyumGk
        eUT07FEmfEh0EHBZqwvhg6WkFNtGM5kxB2wokImG9TAdzqQ=
X-Google-Smtp-Source: AA6agR6tBLeKEUcisOGjq4NAlEVc/OdfGzJcAV/IdiGqxYK4G7pYE0qYch3ZT9J5QURokvZS077PwiAkNvzMmCC0cpo=
X-Received: by 2002:a05:6602:2d92:b0:67c:b00:422 with SMTP id
 k18-20020a0566022d9200b0067c0b000422mr776746iow.187.1660269559919; Thu, 11
 Aug 2022 18:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220811034020.529685-1-liuhangbin@gmail.com> <CAEf4Bzb+vfjrZv+3fmg8wmDQc5iBXO+xubKCdL-4BsgxGmuyOg@mail.gmail.com>
In-Reply-To: <CAEf4Bzb+vfjrZv+3fmg8wmDQc5iBXO+xubKCdL-4BsgxGmuyOg@mail.gmail.com>
From:   Hangbin Liu <liuhangbin@gmail.com>
Date:   Fri, 12 Aug 2022 09:59:08 +0800
Message-ID: <CAPwn2JTLZDtq3qc5tNrCkK3_Gqnp2h6vGn2a8q03gZuo_2zC4A@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next] libbpf: Add names for auxiliary maps
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf@vger.kernel.org
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

On Fri, Aug 12, 2022 at 6:15 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> Applied to bpf-next. But let's also do the same for bpf_prog_load().
> We can make probe_kern_prog_name() use sys_bpf_prog_load() directly
> and avoid calling bpf_prog_load() and thus avoiding circular
> dependency.

Ah, yes, we can do it this way. I will post the patch today.
