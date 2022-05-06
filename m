Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3766A51E1F0
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444745AbiEFWbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiEFWbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:31:51 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D64E27CF2;
        Fri,  6 May 2022 15:28:07 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id i22so5678700ila.1;
        Fri, 06 May 2022 15:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/CpZb7ndIc4uJklRh3E2E3FxIA3evq19i2HXND3IGGM=;
        b=XQmwAQZRnspOZgGEkNJfozpbymc7/+2whzFBzNafyIdZXmMi8y3qIQvNvSCdhbCsdj
         sNQ++eNXwFyYq1h8mxiQ25SqJTej/E8q3yz3AtMzim8qYnLOSEn4ge8i5Raua6S2LGlp
         WeebU+Avzw/RC1YqzbVomcb9S0Inf1SqC3aVamAoavU85dLTdK3e/Ro4GTH50k56t+fT
         4nsLLPyi/sBqAkJnAL0TAtULZkPkfe/Jujxq6/HUIMAyhm92NcDXgQuKAuoBHwS0CZoP
         guNUPzOwKGzqWCZ2n5/cTu97kQ/c3fJL1o1rcekcaV4T/ERlUuT4mINsfzXpngJSF5bG
         O4zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/CpZb7ndIc4uJklRh3E2E3FxIA3evq19i2HXND3IGGM=;
        b=4wdh3QUSoe2vCp7fhxdYoiyXkuyZCZ9RqRmjhdh7j/vnogcHAf5inBPRD/QtsIysUL
         XBrzaglnmAx9cj5D03SK3XaZxJ8epCb0PxcWemI95rkElCt0R7BmRNCy+gJ7q8x22zMw
         J7l/8FJOsLrnViC2+sgg7+IltdbUT6i7WIkqGipjqO3Ic+bokU6D/uJLrMKZCPVCPrc7
         fqGvPvmnSyn9Fqdb3RqEaomOFjXJKJSohGf681uHnopuNWAvqIH7l65GavMvG6g/cU+d
         Zo/S8+dHJfh8g1VS2AGL+k418ST1wyQWEScEmf5ecgoiA7Lt/t085NVggphTrbREJfCM
         MFkA==
X-Gm-Message-State: AOAM530QapC7C6qOLaQ7xRuCXhMxgGhC1m7xXWs4VjQxtWNirmbNFTjR
        /qdKmwEIbJe2+vuC+lFdMw9Jl7Pjwfudk6ePmr0=
X-Google-Smtp-Source: ABdhPJwn1AU5H30RtqOr1eEKJRqZ/2BWjSzr83c7iU7JLwiXoTWyLrGA562VPTJ7mtv5W41hOYry7ewwGYRMp/vHOAc=
X-Received: by 2002:a05:6e02:1b82:b0:2cf:199f:3b4b with SMTP id
 h2-20020a056e021b8200b002cf199f3b4bmr2135689ili.71.1651876086469; Fri, 06 May
 2022 15:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
 <20220502211235.142250-7-mathew.j.martineau@linux.intel.com> <108060a1-8e8c-6d2b-a3a0-a18dab3e409b@linux.intel.com>
In-Reply-To: <108060a1-8e8c-6d2b-a3a0-a18dab3e409b@linux.intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 May 2022 15:27:55 -0700
Message-ID: <CAEf4BzbqfV1FySVu69-am6hz2ykPWXspqyFV8eG_Gapwp0kUqw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 6/8] selftests: bpf: verify token of struct mptcp_sock
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Alexei Starovoitov <ast@kernel.org>, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>
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

On Mon, May 2, 2022 at 3:14 PM Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
>
> On Mon, 2 May 2022, Mat Martineau wrote:
>
> > From: Geliang Tang <geliang.tang@suse.com>
> >
> > This patch verifies the struct member token of struct mptcp_sock. Add a
> > new function get_msk_token() to parse the msk token from the output of
> > the command 'ip mptcp monitor', and verify it in verify_msk().
> >
>
> Daniel, Andrii,
>
> The z15 CI build failed on this commit, not due to any endianness issue
> but because it appears the z15 CI VM has an older iproute2 version (5.5.0)
> than the x86_64 VM (where the build succeeded).
>
> Do you need us (MPTCP) to change anything?
>

I'll defer to Ilya (cc'ed).

> Thanks!
>
> > Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> > Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > ---
> > .../testing/selftests/bpf/bpf_mptcp_helpers.h |  1 +
> > .../testing/selftests/bpf/prog_tests/mptcp.c  | 66 +++++++++++++++++++
> > .../testing/selftests/bpf/progs/mptcp_sock.c  |  5 ++
> > 3 files changed, 72 insertions(+)
>
> --
> Mat Martineau
> Intel
