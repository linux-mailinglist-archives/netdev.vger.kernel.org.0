Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3EB5AA697
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 05:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbiIBDv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 23:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbiIBDvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 23:51:11 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F17953037;
        Thu,  1 Sep 2022 20:50:55 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id n202so701813iod.6;
        Thu, 01 Sep 2022 20:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=E+LJ1geH9sHZ7zNZY9aNOFdRivMlaRJnVrHaJZ75NKo=;
        b=nRy9G0eht6ytO52NCU/doiQCtMeaRAV6V7krSlmSA9qcUj7j3ecvqgG1ge+ubUm4hy
         5zTEUU2+pN2G9UjF/E1TmIyiq2Gtmx0YhQVHIuwxsTaygjYaZSspj1di9q324yvyHLOs
         onkk7PntBDcPqCBMReGZ5Kx+7NwYsGoO6vm00HM1pp3JzxLVuDF5vGFxvOLmqc1dnknH
         vdmXethcA7SAPx10M2RQkjSXVHxCcjMzI/ZvksBqpGZsPJvqn0pJGHV0vOSCiSGioJS/
         UbfCnamfaV1Into6YeCLtbsjys6xcHUKFr2MT9AU/SAm9XZXLaA3eLvR/YlyAKFCnfHy
         Fgpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=E+LJ1geH9sHZ7zNZY9aNOFdRivMlaRJnVrHaJZ75NKo=;
        b=AgEYTiyfAdDw0NWjJPXEVo7Tj2KSOOPbBouarQIE8qToZJe3D+wri0Eudj9KY5xwN3
         352IgrPwPnyY5RuoRM5O/IlkOlv4tUJENMaX1sKyTTf2H+gJ947XHZUcsrAIXlf3urhF
         TADQYSBamnrlGT0n7OPzT1jcFRQXrw4sVBBpVUJeqJXtHxg5B2Dph0b/rMrfxEGqZn0P
         gbv6EizHn7/EfBRL33dnK5YDa6UzPWvemF9bUvarXinCenDGRD/SvfZzFQKeV0tRzHB3
         OG8qbcpX1gD9LoQF3EytG+xmYXaDaBDW2G+DOi0NASgJgnPsRn/OnCsyZ4mUfIU+okMw
         iI+A==
X-Gm-Message-State: ACgBeo0jX18X2szq0twvLakogsDczJSfB+fszslNj+eS1zLIdRxaWTt0
        J4R0xLfZkhc2BhecvTH2bRwXl0pBQAqda1qliRg=
X-Google-Smtp-Source: AA6agR7DtugthLRfnyg7YwsykX98zovzEb5HyhodkBFu5mzFBonF8cErMKxWUkl202KP0GIgPA2dBHRGOzjeT5EVFI4=
X-Received: by 2002:a6b:2ac4:0:b0:688:3a14:2002 with SMTP id
 q187-20020a6b2ac4000000b006883a142002mr15979839ioq.62.1662090654002; Thu, 01
 Sep 2022 20:50:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
 <20220824134055.1328882-2-benjamin.tissoires@redhat.com> <CAADnVQKgkFpLh_URJn6qCiAONteA1dwZHd6=4cZn15g1JCAPag@mail.gmail.com>
 <CAP01T75ec_T0M6DU=JE2tfNsWRZuPSMu_7JHA7ZoOBw5eDh1Bg@mail.gmail.com>
 <CAO-hwJLd9wXx+ppccBYPKZDymO0sk++Nt2E3-R97PY7LbfJfTg@mail.gmail.com>
 <CAADnVQK8dS+2KbWsqktvxoNKhHtdD5UPiaWVfNu=ESdn_OHpgQ@mail.gmail.com>
 <CAO-hwJK9uHTWCg3_6jrPF6UKiamkNfj=cuH5mHauoLX+0udV9w@mail.gmail.com>
 <CAADnVQLuL045Sxdvh8kfcNkmD55+Wz8fHU3RtH+oQyOgePU5Pw@mail.gmail.com> <CAO-hwJJJJRtoq2uTXRKCck6QSH8SFDSTpHmvTyOieczY7bdm8g@mail.gmail.com>
In-Reply-To: <CAO-hwJJJJRtoq2uTXRKCck6QSH8SFDSTpHmvTyOieczY7bdm8g@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 2 Sep 2022 05:50:18 +0200
Message-ID: <CAP01T77SJyiDxv0A++_mNw7JZ-Mzh4B1FAM6zLiP6n75MNY0uQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 01/23] bpf/verifier: allow all functions to
 read user provided context
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
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
        LKML <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
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

On Thu, 1 Sept 2022 at 18:48, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> [...]
> If the above is correct, then yes, it would make sense to me to have 2
> distinct functions: one to check for the args types only (does the
> function definition in the problem matches BTF), and one to check for
> its use.
> Behind the scenes, btf_check_subprog_arg_match() calls
> btf_check_func_arg_match() which is the one function with entangled
> arguments type checking and actually assessing that the values
> provided are correct.
>
> I can try to split that  btf_check_func_arg_match() into 2 distinct
> functions, though I am not sure I'll get it right.

FYI, I've already split them into separate functions in my tree
because it had become super ugly at this point with all the new
support and I refactored it to add the linked list helpers support
using kfuncs (which requires some special handling for the args), so I
think you can just leave it with a "processing_call" check in for your
series for now.

> Maybe the hack about having "processing_call" for
> btf_check_func_arg_match() only will be good enough as a first step
> towards a better solution?
>
> > And may cleanup the rest of that function ?
> > Like all of if (is_kfunc) applies only to 'calling' case.
> > Other ideas?
> >
>
> I was trying to understand the problem most of today, and the only
> other thing I could think of was "why is the assumption that
> PTR_TO_CTX is not NULL actually required?". But again, this question
> is "valid" in the function declaration part, but not in the caller
> insn part. So I think splitting btf_check_subprog_arg_match() in 2 is
> probably the best.
>
> Cheers,
> Benjamin
>
