Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A5C4F1FAD
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 00:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbiDDWzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 18:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236194AbiDDWxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 18:53:39 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E834C436;
        Mon,  4 Apr 2022 15:12:24 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id r2so13042614iod.9;
        Mon, 04 Apr 2022 15:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TBuUg5HYufdLmJmO7llDJ0ZgAOW1xjLS+Cy/OQQ/Wyg=;
        b=GooeJiC4ZAPspVuTVNQvv7NdlE5ceHPrkdLYDEsWRdXY8uUa9uEfz0v0hHFkV6WnR0
         cxBSQMM8nsvhiOvoMznzysX07jXQSYv82sgr0LIZfmAQqccZ2ZGZ2UVc0xPuOCYqH0x5
         3gKT8wWJUJ+qDJU4JM8NfVisrZ0f2cCi8flD0lcm4sGTpwoE0POkWhnvuQm1QtZciCLw
         E6jP67cP2I8LtloDMnKaMLJ/atr+huF1Ovmo5IBcNG/MdmsQV39CcEYvZ7JdMUMNl+pL
         St8Hy5/Ap9zYAP/zyJtVV7G0MsIp51are0I7jyabYzmxGCaOelY4Z+E/MR9mHHUGUZ7C
         W2kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TBuUg5HYufdLmJmO7llDJ0ZgAOW1xjLS+Cy/OQQ/Wyg=;
        b=smSloOTFy++wIRfp87QlQqvdo4c+M/q14OI1TtCmNJGCwC3kwnKO7370yYsg3myj07
         zBT8KLg7eUqAtwe4tAsPyTNyt8scOTrvdJtScEAlkig7l+aK3knamh6e9WyDPOtbYKD0
         4wGG2R/VPb35v2FzhnY/iRz+gRxEqwpWhGT8X3fPuVDCPX0tNYAvnBw1f8DtF/tBaPkg
         sI5KlOrNZpidxyCJu9Vsr6uILPkkvY++EyueBcvzwnelan9pG9zyCgOLXGEqED67DUkY
         Ps5c+EFbG/nN4KeHX2Ye/udNdwS9kIB2KhYZLXH5HUoF9x/yPiRYWGhMbXCiXizYc8Kc
         GTbA==
X-Gm-Message-State: AOAM5301cJABUliuraEGREZmopDKeI6ZFxJTRRM873NBZFsy3Qj2YC4X
        OxC+kndkHAyz7KC1TrqHCvPEsmJbQruwugWW3Ky4ePib
X-Google-Smtp-Source: ABdhPJypb05hTKSqXsPjjhYi8r7X55BK378TLiKhUw9uXejM4tFODx+of0bQoY0eZj0w9Amg00/oqsFioCzH1K21/bo=
X-Received: by 2002:a05:6602:3c6:b0:63d:cac9:bd35 with SMTP id
 g6-20020a05660203c600b0063dcac9bd35mr231062iov.144.1649110344198; Mon, 04 Apr
 2022 15:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220404164514.1814897-1-ytcoode@gmail.com>
In-Reply-To: <20220404164514.1814897-1-ytcoode@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 4 Apr 2022 15:12:13 -0700
Message-ID: <CAEf4BzZrc=wr4FLkWkOSEeprzybA8JTipsnr_U1kYA0785WkTw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix issues in parse_num_list()
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Mon, Apr 4, 2022 at 9:45 AM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> There are some issues in parse_num_list():
>
> 1. The end variable is assigned twice when parsing_end is true.
> 2. The function does not check that parsing_end should finally be false.
>
> Clean up parse_num_list() and fix these issues.

It would be great to also explain user-visible bug. What do you do to
trigger bugs? Can you please put that into the commit message, in a
before/after fashion? Thanks!

>
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  tools/testing/selftests/bpf/testing_helpers.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/testing_helpers.c b/tools/testing/selftests/bpf/testing_helpers.c
> index 795b6798ccee..82f0e2d99c23 100644
> --- a/tools/testing/selftests/bpf/testing_helpers.c
> +++ b/tools/testing/selftests/bpf/testing_helpers.c
> @@ -20,16 +20,16 @@ int parse_num_list(const char *s, bool **num_set, int *num_set_len)
>                 if (errno)
>                         return -errno;
>
> -               if (parsing_end)
> -                       end = num;
> -               else
> +               if (!parsing_end) {
>                         start = num;
> +                       if (*next == '-') {
> +                               s = next + 1;
> +                               parsing_end = true;
> +                               continue;
> +                       }
> +               }
>
> -               if (!parsing_end && *next == '-') {
> -                       s = next + 1;
> -                       parsing_end = true;
> -                       continue;
> -               } else if (*next == ',') {
> +               if (*next == ',') {
>                         parsing_end = false;
>                         s = next + 1;
>                         end = num;
> @@ -60,7 +60,7 @@ int parse_num_list(const char *s, bool **num_set, int *num_set_len)
>                         set[i] = true;
>         }
>
> -       if (!set)
> +       if (!set || parsing_end)
>                 return -EINVAL;
>
>         *num_set = set;
> --
> 2.35.1
>
