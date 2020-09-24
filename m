Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA272775A5
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgIXPnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgIXPnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 11:43:39 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A43C0613D3;
        Thu, 24 Sep 2020 08:43:38 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id q8so4448841lfb.6;
        Thu, 24 Sep 2020 08:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DHCvK2vCMj9Av+BIZ0E8U7AElH6avY5LDEpUV+Neh3E=;
        b=axdDe2+aLvLUU+DBLQEdremX6Ihphk9P6EpX/+CXLCVmTx/fYX2Kwz5l/AFCkrw79L
         OhOXKMeimtniSL+yA7W90u+LcehFuHzM8B4Qbb15dToXoDG1HQaGQD3FMA3r8IijkZuS
         Z4Ctt98xiVIbkTXnvPKC4i35l3qSD5p1wkADYuGZeOIMnqdpNFpsOIy4s3bWv+CyzQxA
         e1vPHGSZGdRtqAaUBw5AXZO9+BviRZX6FpF2U82RTTPJZPvKWZ6ZQD+ufRieyH3TSyL8
         knt5BwKJv3/lmbXf892IOaDea82ezBJKPaa7mstaHJ6CoNAe12YO/s3JyJYp0e7RpGFq
         Qy2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DHCvK2vCMj9Av+BIZ0E8U7AElH6avY5LDEpUV+Neh3E=;
        b=P9XPYnkNvyO6QFNxWqakUB8atA/GGiIqpse1o6cMjL4Ijft1YNvJjkZgTclbjKglje
         FKpQmB36ng+XANvIcuvT6AYub8loLCE/IJG8n+qCfZ8Z9UJqtgVCr0hUb5kN1/J/TDK+
         fz4C/iB+PPJDr13Y/3KyazqeZ5htiH5Xo0mLD8/P1e1+kHV0GqtgwZdz3aoou2UG9ERX
         66W1gfpjXRrhxEFKPBrLGpOxut6BjxpgP5QnGT6fgteQPAJc3P3yzvGtHRipomSvOe5k
         htoZJuVd92wVhvq5ToCkPdNDQPs73TC3a1KiSn5Gbn0JsIPT6F/6tIbknNcFT1P18Jp/
         pZUw==
X-Gm-Message-State: AOAM531V/0shuQupmquyZWjdGdd8cUlkrn8ivBAOWno0HMfIR3P4RonR
        oNxjStGuXYmUfnWQz8+u+7WFRnNcgGfnCp9gd9g=
X-Google-Smtp-Source: ABdhPJyLGVPLMTDRG7N8HKyB+9HidFKYkd3IT/B/TCnGDHIGvZvW+ZdNLId/Jd4IOW/bTEo88OM9sC/mY8CNx2aOSDc=
X-Received: by 2002:a19:8089:: with SMTP id b131mr21111lfd.390.1600962216779;
 Thu, 24 Sep 2020 08:43:36 -0700 (PDT)
MIME-Version: 1.0
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079991808.8301.6462172487971110332.stgit@toke.dk> <20200924001439.qitbu5tmzz55ck4z@ast-mbp.dhcp.thefacebook.com>
 <874knn1bw4.fsf@toke.dk>
In-Reply-To: <874knn1bw4.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 24 Sep 2020 08:43:25 -0700
Message-ID: <CAADnVQJmYosGXCnAY4UmhLE+xdQHb1DVOSC5yaZJh7OHzJcUvw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 04/11] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 7:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> ...which I just put down to random breakage, turned off the umh and
> continued on my way (ignoring the failed test). Until you wrote this I
> did not suspect this would be something I needed to pay attention to.
> Now that you did mention it, I'll obviously go investigate some more, my
> point is just that in this instance it's not accurate to assume I just
> didn't run the tests... :)

Ignoring failures is the same as not running them.
I expect all developers to confirm that they see "0 FAILED" before
sending any patches.

>
> > I think I will just start marking patches as changes-requested when I s=
ee that
> > they break tests without replying and without reviewing.
> > Please respect reviewer's time.
>
> That is completely fine if the tests are working in the first place. And
> even when they're not (like in this case), pointing it out is fine, and
> I'll obviously go investigate. But please at least reply to the email,
> not all of us watch patchwork regularly.

Please see Documentation/bpf/bpf_devel_QA.rst.
patchwork status is the way we communicate the intent.
If the patch is not in the queue it won't be acted upon.
