Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C7046DCB5
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbhLHULs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbhLHULs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 15:11:48 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EC8C061746;
        Wed,  8 Dec 2021 12:08:16 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id q74so8563095ybq.11;
        Wed, 08 Dec 2021 12:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1GRf70MVkpQen5zrvydg9VRDxc0nOXuGTMCudfxmXfg=;
        b=Ittu6FxYt6yLXABuYjyTOpuoiAjJ1PW45qqiKZVES95ewN3PsMEK8CSS/M0poDAz1L
         +4izX89Rnvw1tm56XMfQs28bGFdLpqwbxibwz5PmNu30D4uZnWd9DzrN36WN9NXgrvCz
         WH8IdPgjifp0dkhNeAXNiCuov2eDcgpQgiv1vPgT1R0RwlBJh404PhdpLTjQbG3+Xebz
         Qbrq+ddbvV1GXkEW3H8PfQNWPInirOTJ4Lk7tu89qsuv+VsoWd5W9nTryd1GLU3Y2utE
         EFvPQS9NncfrQcT4qPz5Z5t1sLeRp0AvOaYWdSG00JBKGCFTHg/A5WxDPXtc3yU+llue
         ztFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1GRf70MVkpQen5zrvydg9VRDxc0nOXuGTMCudfxmXfg=;
        b=5zOT8H1vaC1x/UvSeXBAbBnpkPF7y2EQBrYxuhaKof0RCH89AY8jfRONGENaWfhZWw
         98CNDjoYzsFng4tmdpbJD+LRpGQotQ8em/3I3vQYEHORjkrJfs9KVmWoGn2cqcO/3w2h
         iLFNztbYn1EUemNPn1dcEZydpYsSivg6ZatOoYDTj0FbQwVtamzVoHlT3XhZ/8k2lD2x
         nptkyjcHbe+MF3dRAtusyyWTf0cz8JZcm8kvxUKvnL7Cy0onMWmb58BoGOkp84mMLk3y
         WWQNyaOvt2WSLoPQuu57f+B80MHKrjlvBqtGxMIW5PqP+knDdRykcLAM6aUoDR1gQCgS
         ocRg==
X-Gm-Message-State: AOAM533Fmb9nCmqGsd9CCmrWqQ02Wv7ler6HgoTaZdpR74Y8NRXB4U+j
        qt+CLAW7wPzVHMyucaXgrtCavTsWxM/Qs+J0C9g=
X-Google-Smtp-Source: ABdhPJwpEiEHfL1tEtarmqYMFMLPXmFtju/Er8A4PNF/1EkIvg1S/gnT8yncHa37EezAC0OwnQ0RDTQr58wublyfULE=
X-Received: by 2002:a25:e406:: with SMTP id b6mr1001564ybh.529.1638994095505;
 Wed, 08 Dec 2021 12:08:15 -0800 (PST)
MIME-Version: 1.0
References: <20211130142215.1237217-1-houtao1@huawei.com> <20211130142215.1237217-5-houtao1@huawei.com>
 <CAEf4BzZLsV_MoUz4VwspzVUbJaXVn0YVsKvf=bL-WPspbw6WGA@mail.gmail.com> <97a9166f-7eec-49e2-1f94-ae2fc21dcf02@huawei.com>
In-Reply-To: <97a9166f-7eec-49e2-1f94-ae2fc21dcf02@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Dec 2021 12:08:04 -0800
Message-ID: <CAEf4BzYtKNs8ORZxSgFtWZA49-Rjp5UVww_s9MWKq2DNUMts_w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] selftests/bpf: add benchmark for
 bpf_strncmp() helper
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 5:47 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Hi,
>
> On 12/7/2021 11:01 AM, Andrii Nakryiko wrote:
> > On Tue, Nov 30, 2021 at 6:07 AM Hou Tao <houtao1@huawei.com> wrote:
> >> Add benchmark to compare the performance between home-made strncmp()
> >> in bpf program and bpf_strncmp() helper. In summary, the performance
> >> win of bpf_strncmp() under x86-64 is greater than 18% when the compared
> >> string length is greater than 64, and is 179% when the length is 4095.
> >> Under arm64 the performance win is even bigger: 33% when the length
> >> is greater than 64 and 600% when the length is 4095.
> snip
> >> +
> >> +long hits = 0;
> >> +char str[STRNCMP_STR_SZ];
> >> +
> >> +char _license[] SEC("license") = "GPL";
> >> +
> >> +static __always_inline int local_strncmp(const char *s1, unsigned int sz,
> >> +                                        const char *s2)
> >> +{
> >> +       int ret = 0;
> >> +       unsigned int i;
> >> +
> >> +       for (i = 0; i < sz; i++) {
> >> +               /* E.g. 0xff > 0x31 */
> >> +               ret = (unsigned char)s1[i] - (unsigned char)s2[i];
> > I'm actually not sure if it will perform subtraction in unsigned form
> > (and thus you'll never have a negative result) and then cast to int,
> > or not. Why not cast to int instead of unsigned char to be sure?
> It is used to handle the character which is greater than or equal with 0x80.
> When casting these character into int, the result will be a negative value,
> the compare result will always be negative and it is wrong because
> 0xff should be greater than 0x31.

I see about (unsigned char) cast, but I was worried that subtraction
result won't be negative I've tested with

$ cat test.c
#include <stdio.h>

int main() {
        int x = (unsigned char)190 - (unsigned char)255;
        printf("%d\n", x);
}


Seems like it behaves sanely (at least on this particular compiler),
so I'm fine with it.
