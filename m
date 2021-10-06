Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EFD42372F
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 06:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhJFEq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 00:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhJFEqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 00:46:54 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A0BC061749;
        Tue,  5 Oct 2021 21:45:02 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id u32so2456661ybd.9;
        Tue, 05 Oct 2021 21:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2r0wsq1VoxUgj9ToITCdfTBtyHuV+Nv0K4rnfv8zwfs=;
        b=MKl/7lOWDeyEnrNn1l88kRGnTK3liSTzIeN/bGgVp6AAnXfNZC/C7JNa14reckAZyS
         olt2ZMH2cV4++qKBw5dlVcaltkQgRl1+g7QXQ0bHzD19/tSB3Dj2Jl4+sKNJphOgR/5t
         52RZsK5pGsNDzq2OSizGZbfV26yJ/zmKKKOjF3646pgOJSvAsACXtnT3Ytt/wKUVn6LL
         2mq/MWBNVlPwM/OZZzeqze94CuW7LcqtWLdCxu6SeS6rlAKyPiVCJHFT/RAs/Rm5NMeq
         smjvv3wvFqQJvYfxxhGxSyq69gmrLyoul3UYfJO9VVRZg7eFbwlqZrw1dl+rcibGKCWg
         dULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2r0wsq1VoxUgj9ToITCdfTBtyHuV+Nv0K4rnfv8zwfs=;
        b=rTsGMSMwB3gAGXXPwVhlXoA1e3xmjT99xte5jmFiDd5roRVd/u6b/KEx2wVD4AVdfU
         V0GbD0x2R+DP0fIkBatqoAM6X8QnyQP+Zq40ZDHzKXxyL8nfVfnjIz541fQvuyNtsyk9
         cIDIOer9VCZmlAV0f00Mlq6kAWq4pTdIRSu+2EW7S/dz9Of+VOv8LfFg6Bg0WC4+WMqp
         d7n3FmXfVY+enEVGK8mg/XbiTrMngRAN6POwxCgR0NX147LUMI0gVVvc1rVXioOIhHWO
         HhLRByMZ0ECoxVM3UrrBwgpWlaZBkx7SdO1yfMzIHvO/QkPP6fILhST4v9Smly/UCCac
         7dPA==
X-Gm-Message-State: AOAM533BU1TA/trSIOgz4nLLCP5Ij/dMQh3VjzbqtIYwIzQfbeXrIWFZ
        Ezvv5oDkGhyp9HqcDbOemnWrvIpP33Kh+D+yQcU=
X-Google-Smtp-Source: ABdhPJxGOubbIMaKnS+py6S5KNWHaBnRgtpkkP/B8yVg2w6oPl5hNjK3t1iFX9lXXHlTjaBDuyh1NyjgGeh39skXggQ=
X-Received: by 2002:a25:e7d7:: with SMTP id e206mr26038949ybh.267.1633495501568;
 Tue, 05 Oct 2021 21:45:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211006002853.308945-1-memxor@gmail.com> <20211006002853.308945-7-memxor@gmail.com>
In-Reply-To: <20211006002853.308945-7-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Oct 2021 21:44:50 -0700
Message-ID: <CAEf4BzZLMkQA3Sb9=Ojpif1UiZo6ecbXCAz7u_Qi7_GEEYfs1A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 6/6] bpf: selftests: Fix memory leak in test_ima
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> The allocated ring buffer is never freed, do so in the cleanup path.
>
> Fixes: f446b570ac7e (bpf/selftests: Update the IMA test to use BPF ring buffer)
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---

Please stick to "selftests/bpf: " prefix which we use consistently for
BPF selftests patches.

Other than that LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/testing/selftests/bpf/prog_tests/test_ima.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
> index 0252f61d611a..97d8a6f84f4a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
> +++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
> @@ -43,7 +43,7 @@ static int process_sample(void *ctx, void *data, size_t len)
>  void test_test_ima(void)
>  {
>         char measured_dir_template[] = "/tmp/ima_measuredXXXXXX";
> -       struct ring_buffer *ringbuf;
> +       struct ring_buffer *ringbuf = NULL;
>         const char *measured_dir;
>         char cmd[256];
>
> @@ -85,5 +85,6 @@ void test_test_ima(void)
>         err = system(cmd);
>         CHECK(err, "failed to run command", "%s, errno = %d\n", cmd, errno);
>  close_prog:
> +       ring_buffer__free(ringbuf);
>         ima__destroy(skel);
>  }
> --
> 2.33.0
>
