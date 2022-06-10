Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB89C547061
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 02:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350661AbiFJX5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 19:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235486AbiFJX5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 19:57:08 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA26B179960;
        Fri, 10 Jun 2022 16:57:07 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id v1so788736ejg.13;
        Fri, 10 Jun 2022 16:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jQmPRsTR95ymz+EPvppaVNmzqWaaicoojJhIHHo9hvI=;
        b=pWoyzC8h/FhE6fU9Yh3CiG/b9TsFgd5VDusl8nHM1Heuatmuka6s14VpcXnC8xpKDh
         wRa6T9khqo3gG7zDZUp1+w3EE1bL01z3yI3RICEuvO9hDnRobOJLXux4looeAGsQIf51
         jYVEfZlEd6FF8heTjX8bdo4yrcYAq67wkaHvEyehY9ta3EKJwi6Xa4O6R/e7qmpDbWLs
         cJFP9nwXQtPqvPuzlsNeq1L2S0ILfAhQRZXZKfS9juVBzNYbr6D1DC0WPkamN8/8bV+7
         PwNE5rQaiqla7aum1tRJX1O+C8opIL74OpyHlK46s1KwmHh+N7NfgfuJTkxOizjbVQPA
         pCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jQmPRsTR95ymz+EPvppaVNmzqWaaicoojJhIHHo9hvI=;
        b=PyLqe+/jwcV21mvsoNztjXyDF1lFlEGllomMlaYcZAwH71kd9qvKRx78fjODtQyhnd
         hQYHDygGTq2xGBiOTiNdW39RXaKhTBJm8xe5enif9+KOUUQdGFowi6uDhE5Yaf8cIXE/
         vh25TUPEcodNBMpbooeAwpIUczI1fSbi5NUSTqT1AtWlVO8tHuy9WPH8QXrs7BrGpMz2
         TSH0e39LsxzUtzjWkcNAFJ2u2m1hIKcYr/mhe/ZqAE8gud6DQndSxo20DLvKiR3+59TX
         7RFkr+2vfnda8MNMLsIRgYr6Uye6n5jp2qbnr4dBaajmgwhbC1R4r3jxc2fpkAPtmRsh
         ow/Q==
X-Gm-Message-State: AOAM532933s8Dm6Q3D8mwqDFzwHTnUGud4TPw2gfEow7fN/AHK1EgCNM
        rh/8QcOIw+Do0Cbn33o/o/2juHUvf6l8c3O1/qI=
X-Google-Smtp-Source: ABdhPJwNEr9ctOLJamvMSijPc7FQAKaxX0cnirbr532zEVadx9l03L/RdP5Ck+qc6L27B8L2cezX93j48N0bJi0QeZ8=
X-Received: by 2002:a17:906:51d0:b0:6ff:2415:fc18 with SMTP id
 v16-20020a17090651d000b006ff2415fc18mr2360086ejk.94.1654905426298; Fri, 10
 Jun 2022 16:57:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220610135916.1285509-1-roberto.sassu@huawei.com>
 <20220610135916.1285509-2-roberto.sassu@huawei.com> <ce56c551-019f-9e10-885f-4e88001a8f6b@iogearbox.net>
 <4b877d4877be495787cb431d0a42cbc9@huawei.com> <1a5534e6-4d63-7c91-8dcd-41b22f1ea2ba@iogearbox.net>
 <CACYkzJ7-b7orpuUf-Uy7zLGufi8JJFGyWeH0SKwS_GsZVdQWeg@mail.gmail.com>
In-Reply-To: <CACYkzJ7-b7orpuUf-Uy7zLGufi8JJFGyWeH0SKwS_GsZVdQWeg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Jun 2022 16:56:54 -0700
Message-ID: <CAADnVQLL_5NHxNJytDrZCKkQpHx6zLTJYVFzYwPxyWVJZHE-FQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] bpf: Add bpf_verify_signature() helper
To:     KP Singh <kpsingh@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>
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

On Fri, Jun 10, 2022 at 4:53 PM KP Singh <kpsingh@kernel.org> wrote:
> > >>> +static const struct bpf_func_proto bpf_verify_signature_proto = {
> > >>> +   .func           = bpf_verify_signature,
> > >>> +   .gpl_only       = false,
> > >>> +   .ret_type       = RET_INTEGER,
> > >>> +   .arg1_type      = ARG_PTR_TO_MEM,
> > >>> +   .arg2_type      = ARG_CONST_SIZE_OR_ZERO,
> > >>
> > >> Can verify_pkcs7_signature() handle null/0 len for data* args?
> > >
> > > Shouldn't ARG_PTR_TO_MEM require valid memory? 0 len should
> > > not be a problem.
> >
> > check_helper_mem_access() has:
> >
> >       /* Allow zero-byte read from NULL, regardless of pointer type */
> >       if (zero_size_allowed && access_size == 0 &&
> >           register_is_null(reg))
> >               return 0;
>
> Daniel, makes a fair point here. Alexei, what do you think?
>
> I wonder if some "future" signature verification would need even more
> / different arguments so a unified bpf_verify_signature might get more
> complex / not easy to extend.

You mean a pkcs7 specific helper for now?
Makes sense.
