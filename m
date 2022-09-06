Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB6B5ADE08
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 05:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238358AbiIFD3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 23:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238278AbiIFD2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 23:28:20 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84E76D559;
        Mon,  5 Sep 2022 20:27:50 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id q81so7953947iod.9;
        Mon, 05 Sep 2022 20:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=edqEW8K/wxMVRZ77yuARzYVZRubfPFDmCU9QJYmWr3A=;
        b=MLwGeAaD9znffyX/kWEqH875dsCLjLaKVS4+g2FKPQR7nWcZ7pD6/jY9dFb61amb4t
         hJlTn4vnrh/k8Wuko4UunAbnzAP2Ypu4ybqL5zfK3z6lq0GlOVfWyORMIfOJn6RSDixy
         mfs2zYMPGjd+EXtn9USuUM5909gZ8I9dLsNuFYsnjwoE4glRl8VT/PwuJcQUpKy5JDb+
         slCkhaOv0wplD3HU88SF5Q4+kqG1/usozqeZ+WSA93AHZNJcmYva96j4WUXQnkTexw8J
         WgtiRWEzHwDTbqhFnLd46Z8SJYeIe/IgxrRxSNdKqcBALSjNRF+P5t9nfmDMZl6A671+
         wKrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=edqEW8K/wxMVRZ77yuARzYVZRubfPFDmCU9QJYmWr3A=;
        b=x9S0xf30rZFMZ7k/ewMIWJPkz3YTHwU6CL278RDDNzpdFGWcJkNJhHxNu2LpVc7SzA
         RNZJfIZ+HwNGx9C/9EHyotC6LWACxesw7K2hSAUL71pWZFMGC9b+dVN1W+RlzP/F+hz+
         L63hDjS1U20Ycbc1s7P9pr22V4N9d703aG6YfNmLUXiMXjQOoRNK/yBaphQyypgsXnrl
         ncKLgy9OIYKNMveWvmFn1jEbsYKD4VO4bcHR80JWfsnCxGQKd9Q3XwgoxluTb4eVQ2J+
         smxXKyxCDZXT5VxPINsfp7Iicyt+kcYn/1TDE2GPaqMMhEuVOVNY0qhjgbED8o1R/dCV
         SqRg==
X-Gm-Message-State: ACgBeo3uhPmvHtJzA+pKXQPnzFnXpgGZXyWlGrnogwNQpVch1Nl7iV7i
        6lmVZ+0afNXvn4+yY3M4YMOKwGS4xJLaqYw8M/I=
X-Google-Smtp-Source: AA6agR4hdPeg8VFYGGLwYbUrwahqoCx4oP7yfw2h/x1rR+5//miHeZ4c2j3vtktiaeBEAjP14I7O2+M5eP10fGewESw=
X-Received: by 2002:a05:6638:3802:b0:351:d8a5:6d58 with SMTP id
 i2-20020a056638380200b00351d8a56d58mr5441296jav.206.1662434870210; Mon, 05
 Sep 2022 20:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
 <20220902132938.2409206-2-benjamin.tissoires@redhat.com> <CAP01T75KTjawtsvQmhZhj0=tEJVwc7UewRqdT1ui+uKONg07Zw@mail.gmail.com>
In-Reply-To: <CAP01T75KTjawtsvQmhZhj0=tEJVwc7UewRqdT1ui+uKONg07Zw@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Tue, 6 Sep 2022 05:27:14 +0200
Message-ID: <CAP01T74zEuSfTYhkKieU1B5YwzdXhKWxPX55AabV84j-=virwA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v10 01/23] selftests/bpf: regroup and declare
 similar kfuncs selftests in an array
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
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

On Tue, 6 Sept 2022 at 05:25, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> On Fri, 2 Sept 2022 at 15:29, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > Similar to tools/testing/selftests/bpf/prog_tests/dynptr.c:
> > we declare an array of tests that we run one by one in a for loop.
> >
> > Followup patches will add more similar-ish tests, so avoid a lot of copy
> > paste by grouping the declaration in an array.
> >
> > To be able to call bpf_object__find_program_by_name(), we need to use
> > plain libbpf calls, and not light skeletons. So also change the Makefile
> > to not generate light skeletons.
> >
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >
> > ---
>
> I see your point, but this is also a test so that we keep verifying
> kfunc call in light skeleton.
> Code for relocating both is different in libbpf (we generate BPF ASM
> for light skeleton so it is done inside a loader BPF program instead
> of userspace).

Err, hit send too early.
We can probably use a macro to hide how program is called, then do
X(prog1)
X(prog2)
in a series, won't look too bad and avoids duplication at the same time.

> You might then be able to make it work for both light and normal skeleton.
>
WDYT?
