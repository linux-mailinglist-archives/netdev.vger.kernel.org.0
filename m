Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC036D84CD
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjDERWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbjDERWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:22:41 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3A459E6;
        Wed,  5 Apr 2023 10:22:31 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-946a769ae5cso57922166b.1;
        Wed, 05 Apr 2023 10:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680715349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qudjHEfwZN2ELTS5uL0dbGd2njDQoDIllVRSFmZf91w=;
        b=pQd8omNiHGbe69W3r4RWtZbX1dS4H8lNwaGQ59NIJzC+zxvDCBDY73YiP51VPWnGuM
         AU+AfrzuScmL6CQk4Vob1cwXbMMjvXSby4qzfrIYUH1w+YHiIxw7DiX/SKiTKd/DsHrN
         HjC6thTdZDXvU7/1IHDxh7Jr4c1xJtsycc2D4YmIQRiB43vw5a8u0atQIPqwgcghsa3Y
         R4pGpQSWYGgdRF2LpF1sAsQnjUwugZfYOJfmmtJOmPy/hJi4g2f+5WmxnVUxPfbDpTAc
         QuzofrHDZJL7zi9PQwWXoeoMnGtSxFZwsYJVhLKEFOHITMaFUIT3X+TcRd66I67+Hh5o
         KuDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680715349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qudjHEfwZN2ELTS5uL0dbGd2njDQoDIllVRSFmZf91w=;
        b=fJ/s3WSgZ1aVwyHsg7d8+5wxQt118FBIV1VaoiTWriVMvZJsVQRs7XCEtBl1eQs0q0
         n93Q+NLHaERsce+yQg5soflGcrXRQHvgwbIZyq/4CPFGcuIby+natqfizBzNQS3s/SwT
         4CbqYeiod+2XTPCCuUigIk7RvVdvOS99DtsX8vnkK0ZZ2iskL0EJ+4KX6Ev1veA9ovDC
         9lurIzsWL8vxvdS33fS/TE0rZjdrVfUi7l8EUIWmLG0Lzcc2NFNJulj8iDfzAGgZjSwV
         8yqvqubISKMLQzWJ+g5sUfZEiEOR/n4n8zZcb7CF43UkZ3zIX3CRUrq8QvmwDn6DjQiZ
         FWjw==
X-Gm-Message-State: AAQBX9cY1FbgIiiddCSU57kaSX/0CM6IKEf3FV2zeCpwxGbs6e5pc8Nu
        mQEIPwTOYEjn9OvUirEZdym+qLO0R7IWRlI0AEraXgPoSzk=
X-Google-Smtp-Source: AKy350aJRbu5NiZ90m6GXPJ7LXg82miPFAUuzYzMhf/xsH4Vf1FM0wA53TwtvvJDOvTMUmkoHUSS3Y67P58vi9Hcaho=
X-Received: by 2002:a50:aa93:0:b0:4c0:71e6:9dc5 with SMTP id
 q19-20020a50aa93000000b004c071e69dc5mr1566796edc.1.1680715349174; Wed, 05 Apr
 2023 10:22:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
 <20230404145131.GB3896@maniforge> <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
 <CAADnVQKLe8+zJ0sMEOsh74EHhV+wkg0k7uQqbTkB3THx1CUyqw@mail.gmail.com> <20230404185147.17bf217a@kernel.org>
In-Reply-To: <20230404185147.17bf217a@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Apr 2023 10:22:16 -0700
Message-ID: <CAEf4BzY3-pXiM861OkqZ6eciBJnZS8gsBL2Le2rGiSU64GKYcg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the verifier.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Vernet <void@manifault.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 6:51=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Tue, 4 Apr 2023 17:16:27 -0700 Alexei Starovoitov wrote:
> > > Added David's acks manually (we really need to teach pw-apply to do
> > > this automatically...) and applied.
> >
> > +1
> > I was hoping that patchwork will add this feature eventually,
> > but it seems faster to hack the pw-apply script instead.
>
> pw-apply can kind of do it. It exports an env variable called ADD_TAGS
> if it spots any tags in reply to the cover letter.
>
> You need to add a snippet like this to your .git/hooks/applypatch-msg:
>
>   while IFS=3D read -r tag; do
>     echo -e Adding tag: '\e[35m'$tag'\e[0m'
>       git interpret-trailers --in-place \
>           --if-exists=3DaddIfDifferent \
>           --trailer "$tag" \
>           "$1"
>   done <<< "$ADD_TAGS"
>
> to transfer those tags onto the commits.
>
> Looking at the code you may also need to use -M to get ADD_TAGS
> exported. I'm guessing I put this code under -M so that the extra curl
> requests don't slow down the script for everyone. But we can probably
> "graduate" that into the main body if you find it useful and hate -M :)

So I'm exclusively using `pw-apply -c <patchworks-url>` to apply
everything locally. I'd expect that at this time the script would
detect any Acked-by replies on *cover letter patch*, and apply them
across all patches in the series. Such that we (humans) can look at
them, fix them, add them, etc. Doing something like this in git hook
seems unnecessary?

So I think the only thing that's missing is the code that would fetch
all replies on the cover letter "patch" (e.g., like on [0]) and just
apply it across everything. We must be doing something like this for
acks on individual patches, so I imagine we are not far off to make
this work, but I haven't looked at pw-apply carefully enough to know
for sure.

  [0] https://patchwork.kernel.org/project/netdevbpf/cover/20230404045029.8=
2870-1-alexei.starovoitov@gmail.com/
