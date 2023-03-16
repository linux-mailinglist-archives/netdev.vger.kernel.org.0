Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758EE6BDBC4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 23:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCPWfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 18:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjCPWfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 18:35:54 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63352C0819;
        Thu, 16 Mar 2023 15:35:53 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id cy23so13503141edb.12;
        Thu, 16 Mar 2023 15:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679006152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3MeZF1Bnltb4cTSt6wYxqidPGeVX12qy/3riQTBs+FQ=;
        b=e7JBBD55E/sbAUTrjA4yCKyh/iwLIcYSJ7Dh7f+m8efvZ7fi0iAHU7FysC5bTxnp4C
         5rOQnabWMZskVnGcZQYof7yQnfusUnSBM2oU2K5L8pTmeD71YHUFT5LdRcoCreODWRQ+
         +WfXGmjaotOb4piSeovkFZyRDixX4jYuS+C0QsiDVP/B4qtClqVPy7O4m9rC2aH1w9pR
         qKX6HnsIuvvrx6OkKF8/4cjJKwKR8D9KmRyQt/Q5MT7gs12ZqvhMqdOmgQDfZGfQ9AOn
         w/Z+XG8NWLBBd+rxVgWHktK4OeGQj8+y/MxHcbvrE4FDZvnhpYFXwmKm9an1JdBJ6+nk
         tnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679006152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3MeZF1Bnltb4cTSt6wYxqidPGeVX12qy/3riQTBs+FQ=;
        b=RYWhjrcqKhLGeeijOFvdMvZ1F9Qyp4aGBKOdkD60VD2e5VngCBx0LuTuxWjKqTzzNs
         eNuk65mGBE/olfm/VoVJGsS5LKisMvhom5WleMMmXG2BUpgOPFVlEoNNZrXwVsgzmoyU
         S+GEM9cJAIHnsBoTccuNiWt66ECmwNU8LDyjW8feYvQjyYVx/tA3JfPk8wxmpchBneff
         on7scrDFXMXNjVHR7l7odwXrHgyDiOuEDS8ucQRD242A9v7vqI9NzW8MXs9AUmhW9h9M
         0K2iY8OsI0D9ozgQ719Y1K4c+i4SSvwlVrqv0iYl4fmOyOitRQRPcaSFyJgqb52AlKW0
         IzGw==
X-Gm-Message-State: AO0yUKUNrDakL0y2gE5I837czZK5Qr6JGMAn/aBmuWX3gv8jmg1jDz7e
        X9Y8BOCcbiGlMnPXsrdoh4PpYtz/KIauEc13dMw=
X-Google-Smtp-Source: AK7set8Op/1RlWsPUJUsv5X6cNJgoSQ0K4GG8P8w/ls9UTWCcbGsRXbveRRq+GxzCwpzdJtn++ZTgXJBpAa01IuA7sE=
X-Received: by 2002:a50:f602:0:b0:4fb:f19:881 with SMTP id c2-20020a50f602000000b004fb0f190881mr643969edn.3.1679006151854;
 Thu, 16 Mar 2023 15:35:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
 <20230315223607.50803-3-alexei.starovoitov@gmail.com> <CAEf4BzbrDu_GWWURnf4U=ji_8r6Cnqp-y8ye89xYuV4rTwzz9A@mail.gmail.com>
In-Reply-To: <CAEf4BzbrDu_GWWURnf4U=ji_8r6Cnqp-y8ye89xYuV4rTwzz9A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 Mar 2023 15:35:40 -0700
Message-ID: <CAADnVQJ_MtYtkPBJCsWvgWS0D4Cg7k6Wc-kxwV01w0CoJGx9=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Add test for bpf_kfunc_exists().
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        David Vernet <void@manifault.com>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
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

On Thu, Mar 16, 2023 at 1:34=E2=80=AFPM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Mar 15, 2023 at 3:36=E2=80=AFPM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Add load and run time test for bpf_kfunc_exists() and check that the ve=
rifier
> > performs dead code elimination for non-existing kfunc.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
>
> we have prog_tests/ksyms_btf.c and progs/test_ksyms_weak.c which do
> these kind of tests for variable ksyms, let's just add kfunc ksyms
> there (user-space part has also checking that captured pointer value
> is correct and stuff like that, we probably want that for kfuncs as
> well)

That's where initially I tried to place the test, but test_ksyms_weak.c
is used in light skeleton as well which is pickier about
resolving ksyms.
libbpf was lucky in that sense.
It does:
      if (btf_is_var(t))
          err =3D bpf_object__resolve_ksym_var_btf_id(obj, ext);
      else
          err =3D bpf_object__resolve_ksym_func_btf_id(obj, ext);
while gen_loader for lksel assumes bpf_call insn as the only option for kfu=
nc.
I figured I'll add basic support for kfunc detection first and
address lksel later when I have more time.
Hence the reason to pick:
 .../selftests/bpf/progs/task_kfunc_success.c       | 14 +++++++++++++-
as a location for the test.
