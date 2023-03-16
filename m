Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DB96BDCDD
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjCPXYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjCPXYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:24:04 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45574252A6;
        Thu, 16 Mar 2023 16:24:03 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z21so13985678edb.4;
        Thu, 16 Mar 2023 16:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679009041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CqCtQMVO3PCNmsjowvSiFVl0zPMhdzWcCNuKutfxoQE=;
        b=a26VvhgERM18IXZx6e9ovqkeYzHc7Q79T+JbGF5qTRVWuj7YmEP2IgF007SC9Q6DwJ
         R22xbtM4DrKfg550WSHdK5o4aNooUnEUVvIN2HW4oUW1/HbsCIShguSYqQ8Df+RGNbIa
         Rumq5GOaf8lc/ZeVWQWSeTpNjWZ5a7uPSOWDZWunVRfeW5RL/FCJ7xyPyEhaAzczLW5V
         pGwTmppDOn1HUNG+j3EuHBVLiw8HGco13gpCvl4Mpph2TnYiZRYQ0QMgEw5dBei5G+fW
         tVxYtSAhlG9XncSVQU4F2c3lBUD43CjnYIQwsuauipKDhtlK+2jGLdyluPN6ob9RlSYH
         ijmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679009041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CqCtQMVO3PCNmsjowvSiFVl0zPMhdzWcCNuKutfxoQE=;
        b=R2gc6CGW9dc8ekBnZGb4iAHnzGOHPn6U+xlf5HfjZSz8HFW2uS8S6JjjKXAv+KJ4d2
         5P5Li+ESvE9E2jV8MTaDvGToaAsZG9Kv4uuOrr/YqlQc7tZAdxP1ergf0s8A6hR5Ajmp
         PNtDjtOFmsmJtLmn9LXN/F05R4gnTnm/0X0LIlwjCenq4P4ibroaC2uGaiQf+rE0FmtT
         vW8MfCpkgsaE7maslnJI4YsCsTmb6BPzjzpR4Ut2aQOV1PFtz0x0LKF+8ccoi/GqwaWE
         SE9Z9UlUxdrUjk/lLtUefRL7aRs+TJtGQei609ijRDwpdG8r5S+FuM5M8YCkUy5ofbDs
         Of4A==
X-Gm-Message-State: AO0yUKUT5JucT0gpBg/KceePO5iqZHaUXJXHjnhuIx5jNZ+uqxgr+rMf
        XsTuKVREwoLgL44ZGOB4mQWGTjXeJ0I2Ysjz2/U=
X-Google-Smtp-Source: AK7set8OQ9tCVJIvhtKpLllhpwxhWA6V/V4IiZFkSYa64gdCP3kpWTBJOtxzdxCmo0bdt83921jleBfgD+zsOC3kQmU=
X-Received: by 2002:a17:906:8552:b0:8ab:b606:9728 with SMTP id
 h18-20020a170906855200b008abb6069728mr6256473ejy.5.1679009041332; Thu, 16 Mar
 2023 16:24:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
 <20230315223607.50803-3-alexei.starovoitov@gmail.com> <CAEf4BzbrDu_GWWURnf4U=ji_8r6Cnqp-y8ye89xYuV4rTwzz9A@mail.gmail.com>
 <CAADnVQJ_MtYtkPBJCsWvgWS0D4Cg7k6Wc-kxwV01w0CoJGx9=w@mail.gmail.com>
In-Reply-To: <CAADnVQJ_MtYtkPBJCsWvgWS0D4Cg7k6Wc-kxwV01w0CoJGx9=w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Mar 2023 16:23:49 -0700
Message-ID: <CAEf4BzbEr2wJrTiwgFOh4VCmyLf6DVQkiNWYRcHZPhzezJhG7A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Add test for bpf_kfunc_exists().
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Thu, Mar 16, 2023 at 3:35=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Mar 16, 2023 at 1:34=E2=80=AFPM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Mar 15, 2023 at 3:36=E2=80=AFPM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Add load and run time test for bpf_kfunc_exists() and check that the =
verifier
> > > performs dead code elimination for non-existing kfunc.
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> >
> > we have prog_tests/ksyms_btf.c and progs/test_ksyms_weak.c which do
> > these kind of tests for variable ksyms, let's just add kfunc ksyms
> > there (user-space part has also checking that captured pointer value
> > is correct and stuff like that, we probably want that for kfuncs as
> > well)
>
> That's where initially I tried to place the test, but test_ksyms_weak.c
> is used in light skeleton as well which is pickier about
> resolving ksyms.
> libbpf was lucky in that sense.
> It does:
>       if (btf_is_var(t))
>           err =3D bpf_object__resolve_ksym_var_btf_id(obj, ext);
>       else
>           err =3D bpf_object__resolve_ksym_func_btf_id(obj, ext);
> while gen_loader for lksel assumes bpf_call insn as the only option for k=
func.
> I figured I'll add basic support for kfunc detection first and
> address lksel later when I have more time.
> Hence the reason to pick:
>  .../selftests/bpf/progs/task_kfunc_success.c       | 14 +++++++++++++-
> as a location for the test.

ok, sounds good, maybe mention this limitation in the commit message?
