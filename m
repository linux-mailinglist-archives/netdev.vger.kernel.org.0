Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5916549CFC
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348391AbiFMTKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349240AbiFMTIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:08:44 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BF05002C
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:06:02 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id h5so7986720wrb.0
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KoHbfQqPxgY9yzkcDMM8WJkeOP/2rasHhf0aBaG7YMk=;
        b=CGQlrM5BP7x7O5U5HXhVD5E6vhiC48JFPNq/iEHbZugUGF1PH9mRo1PEbdLg95PhIT
         85sgUpFKPx6kQ0goj4wa4ZGoO+Agj+ijb78wILvKTIUWV4R1ylkwaTwj+QJNJ59U3kV2
         EvmdCDyDRC6z34zBOyxBfhggAWuE5PeN3eIW7NxGN0nA1/Ff9Mlb5Dpwf6qQHpvIU873
         CYR4KBRtjQ6a/yi3Qft7sU6fZOAU5sBJsiPl6NCNDhcKTH294QdGfYDpV70YW4zda0vY
         0pahJvLUSaRLuf63uiUYZCaC4Jvi0Vs7J+7ZzBHghgaKHmKJvIquFADEf+ZbvuP2pIaT
         t5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KoHbfQqPxgY9yzkcDMM8WJkeOP/2rasHhf0aBaG7YMk=;
        b=SKMppKoWm0sUi8GIQKEm8RohjffPitcpsjntr+BFLotMt+kBxAelrmckj+2awnz2xm
         2cILItSgpUowBAG0VsshZhQ84x1NFCzMpvfGMAfKZVp5UAiZnY8KgbV9f6IdvCFhV1u4
         rDeWKVAc+ofaBIZre3DpXTYBl0c/0OjIbDPwVy2mzKFajrJIV5c3x+pydwEwCQ79ZwG4
         8RMU/+FCKxDIM+8K9fy17aFaJPdWzaqozVz1N7yIPI2uVRZCE7B6gKwp4Q6iZ3/aAEWE
         BLyADBou19Na7IqxmOt4ww69dwK+gCvjKJyLr/YhKVV78y8NRBO2hhAhZ631fL/+eGRM
         n3gg==
X-Gm-Message-State: AJIora9/JtdBmcU/GXj0E4vbvLMbw+Sk/ZM3cJa7U1V9JRR78gXpHWhK
        C4wK4xDvzCE7xChXFuHJjO7E2znrjED+7ovFcXIEpg==
X-Google-Smtp-Source: AGRyM1vH+ZqkS8LKL5LOCrHzAkkw8d8wc3YcYVokHj4BKFHYsc3/bdOlTwXRmbj6z9xJr4PtQ+69Y4b8cHmSbVkBgOY=
X-Received: by 2002:adf:f688:0:b0:215:6e4d:4103 with SMTP id
 v8-20020adff688000000b002156e4d4103mr779245wrp.372.1655139960476; Mon, 13 Jun
 2022 10:06:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220610194435.2268290-7-yosryahmed@google.com>
 <202206110544.D5cTU0WQ-lkp@intel.com> <CAJD7tkZqCrqx0UFHVXv3VMNNk8YJrJGtVVy_tP3GDTryh375PQ@mail.gmail.com>
 <20220611195706.j62cqsodmlnd2ba3@macbook-pro-3.dhcp.thefacebook.com>
In-Reply-To: <20220611195706.j62cqsodmlnd2ba3@macbook-pro-3.dhcp.thefacebook.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 13 Jun 2022 10:05:24 -0700
Message-ID: <CAJD7tkba1Ojd+jd7WCa5Lc4sr=3e=4E4_UviHyhLtPfxZcyzpA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/8] cgroup: bpf: enable bpf programs to
 integrate with rstat
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     kernel test robot <lkp@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Michal Hocko <mhocko@kernel.org>, kbuild-all@lists.01.org,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 11, 2022 at 12:57 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jun 10, 2022 at 02:30:00PM -0700, Yosry Ahmed wrote:
> >
> > AFAICT these failures are because the patch series depends on a patch
> > in the mailing list [1] that is not in bpf-next, as explained by the
> > cover letter.
> >
> > [1] https://lore.kernel.org/bpf/20220421140740.459558-5-benjamin.tissoires@redhat.com/
>
> You probably want to rebase and include that patch as patch 1 in your series
> preserving Benjamin's SOB and cc-ing him on the series.
> Otherwise we cannot land the set, BPF CI cannot test it, and review is hard to do.

Sounds good. Will rebase do that and send a v3.
