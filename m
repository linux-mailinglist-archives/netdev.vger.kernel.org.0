Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6F16A73B3
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 19:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjCASnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 13:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCASnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 13:43:20 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142761A647;
        Wed,  1 Mar 2023 10:43:19 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id d30so57849336eda.4;
        Wed, 01 Mar 2023 10:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677696197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NeBOkrsW3y7Vj5BOWZGuYQDb9cRvWdipWp5l5oMe1Dw=;
        b=UYPp6L2OHH31SkRLN9/1JN6l4ky4pJlY3zflrwmT8bS7wXotZykhn8IAOAXtaNmUpa
         ZLyMvZ1PXjtpuHjOhKOovbRF21h9h7ZrRq+EFSqAPPWwBasd0TFRLVbCmVHXzOZNqkfr
         X6NmnR970m64YtBHM1icA11VohnSxgb/pEv+nBQ5xDW8IvEFKfDeAWieDLKHz/9KVnWn
         eu75OS+CCUFq0QG9JeOwCmRsR2hjRHt1qcE9gbP2LOm+puj15d0LVw1ugRIQOcjsljvZ
         MKNblL1Lhe4Gax/SVLn97+Y23Os1zCFlsKSTUSTCY9IqUg0c8UinaIkO73N5cvX8/mO2
         re9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677696197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NeBOkrsW3y7Vj5BOWZGuYQDb9cRvWdipWp5l5oMe1Dw=;
        b=FB5d3jboXUZjwT0mtZhxGTZufzkwd0Xn9nm/p/lFeThOmbVgx8DQfma9u4UEWn7YHp
         ZdXMwAupGdBwofr3JJzMqoELgSbUg8n0ySDDoxwXlbE+bYBYskgL6Syi2mSR1hcehT8Z
         vbhZ3QD+EozaEzuZpkFmK1nE05X/GIotiJawOPdMn2KmSo3q5IxDnjpV2tXQ7aVKRSju
         Qq6wt8rqk8VU4E2FbJIjyBZ2SnUqTNVlqFfzq2q48ZKVUy2+F5Q7pruteePBccJt6HWw
         2DaPbYTHyePrjG9RVXwqeeW7fu8DIcOWb4w405s2GZS7LtLer7AsYbGUlWcrLHsIu4g8
         Y5Gg==
X-Gm-Message-State: AO0yUKVX4Khvcz5e8kD4/E8C0Q1ahbTbwLOX6mjjqmklKHnPWSbiv5de
        D7SvyAbW+HAoftSK3cPxjZfSY0P4EfeiHDAxQ9Q=
X-Google-Smtp-Source: AK7set9ofmAMqc8kBuhyL5cs0fdSAtiNorCZ8oWvIGdSpFlQFhFd85+Jx7A9dXe+YHZ9PCr95uccB5oEliHgk9sX78M=
X-Received: by 2002:a50:ab12:0:b0:4bc:7781:5103 with SMTP id
 s18-20020a50ab12000000b004bc77815103mr1589692edc.5.1677696197414; Wed, 01 Mar
 2023 10:43:17 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-11-joannelkoong@gmail.com> <CAADnVQJCYcPnutRvjJgShAEokfrXfC4DToPOTJRuyzA1R64mBg@mail.gmail.com>
In-Reply-To: <CAADnVQJCYcPnutRvjJgShAEokfrXfC4DToPOTJRuyzA1R64mBg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Mar 2023 10:43:05 -0800
Message-ID: <CAEf4BzaL-o1b51s1Hx_vN9q51Vnp7GBNziYc0ffBfMeQbG5HGQ@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 10/10] selftests/bpf: tests for using dynptrs
 to parse skb and xdp buffers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 1, 2023 at 10:08=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Mar 1, 2023 at 7:51=E2=80=AFAM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > 5) progs/dynptr_success.c
> >    * Add test case "test_skb_readonly" for testing attempts at writes
> >      on a prog type with read-only skb ctx.
> >    * Add "test_dynptr_skb_data" for testing that bpf_dynptr_data isn't
> >      supported for skb progs.
>
> I added
> +dynptr/test_dynptr_skb_data
> +dynptr/test_skb_readonly
> to DENYLIST.s390x and applied.
>
> Thank you so much for all the hard work to make it happen.
> Great milestone!

Yep, a lot of iterators work is made much easier thanks to the
foundations laid by your (Joanne's) dynptr work. Thank you!
