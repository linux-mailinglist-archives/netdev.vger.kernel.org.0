Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB02852CB3E
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbiESEm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbiESEmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:42:25 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115776005E;
        Wed, 18 May 2022 21:42:24 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id o190so4588030iof.10;
        Wed, 18 May 2022 21:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3p2RmX54Nl+qu0eLlsWLYFrSbWckEmVL0yWxFMlgwAA=;
        b=Ohmbav6isHcmvaBs0lKmpTanHP10xbh/uPwF9AWkcAMlnEiRUp1upwyCGCufmfGy/8
         5db2cyJyJMTObsO/D41xiGiu7fbHqI01IYdfZeqyc7PmoplvtlGFZhLHpZvNj8vVR8Py
         leCDf/HfYu4J0sgJw5wt0f0g9vBl7e/kdver89gBRFrUlT9YV+YAAvOBpfBMw3jjqyby
         EY8+uoEjlGCdMAP8opZ3+XciFZJMFJ5Eo6FbQx+4v9V6XfanPSmpUyEtlQn3bWG4Exxt
         c9ulomqH+h4NKCSRlm789FzZ8t1Zxq4MpElHrAwY8Fy5SbbiOAu/5e6H99BNpMxsY/18
         cEbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3p2RmX54Nl+qu0eLlsWLYFrSbWckEmVL0yWxFMlgwAA=;
        b=qJUqF72t6cKEfM58tfu8/9ZI2DOIix8mk6gFgXaI9aCzhcODz1EFRW1OVeb8rPmKvy
         rLn0bdUL3YCQiaPeOkqyiMPXYLLpGLI1Rwp4lgG0ah4cK9Id79pdkH2tjzwbfUDSlDKr
         Rk51x2aLEYbrhIubYH1+gmNs/FuEogn7L/evBnULC0aKXFlX4sln+ZbAoZXjwdbbLaBr
         mUgA0jj590SG2mTtxrZ8N7bAB/BxsIT6ixMjaxZS64MpFu2krAa/1YNvphmGQCLyvyCZ
         BUESUKBHIWcEgkXhwBm5Y90NgJV3r6MH0Jv3A9974jotXHjsyoGtuGuSg0BQtqPsgmZL
         TNgA==
X-Gm-Message-State: AOAM532XKrim+4LCvaOFC0RzdPgwRVZ2h3RPr3YvOxG8G8g2Sm4MxxZy
        AyHSEHFmJfj5XqPlcmPobjlIcX3Rtee4iLVudXE=
X-Google-Smtp-Source: ABdhPJxyfAkP3RamK35fbam2DglCrWDBTRYIhHWBrCHtJFJtFRXSXHaIfrTBTl6mBKsGOsTtHsxIvp8iJsUdhdeVPxo=
X-Received: by 2002:a02:9f87:0:b0:32e:69ae:23df with SMTP id
 a7-20020a029f87000000b0032e69ae23dfmr1620828jam.237.1652935343429; Wed, 18
 May 2022 21:42:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220503171437.666326-1-maximmi@nvidia.com> <CAEf4BzbSO8oLK3_4Ecrx-c-o+Z6S8HMm3c_XQhZUQgpU8hfHoQ@mail.gmail.com>
 <a330e7d6-e064-5734-4430-9d7a3d141c04@nvidia.com> <CAEf4BzYnVK_1J_m-W8UxfFZNhZ1BpbRs=zQWwN3eejvSBJRrXw@mail.gmail.com>
 <13051d07-babc-1991-104b-f4969ac24b9b@nvidia.com> <48df5a60-f6e2-de05-1413-4511825511a5@nvidia.com>
 <ab156744-21fe-61dd-8471-8626c88e6218@nvidia.com>
In-Reply-To: <ab156744-21fe-61dd-8471-8626c88e6218@nvidia.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 May 2022 21:42:12 -0700
Message-ID: <CAEf4BzbQ853vZyq1aYS8NQz_sAO0EVBUgOnHg8-ivS19nc1eFA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 0/5] New BPF helpers to accelerate synproxy
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, pabeni@redhat.com
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

On Wed, May 18, 2022 at 6:43 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> On 2022-05-16 20:17, Maxim Mikityanskiy wrote:
> > On 2022-05-11 14:48, Maxim Mikityanskiy wrote:
> >> On 2022-05-11 02:59, Andrii Nakryiko wrote:
> >>> On Tue, May 10, 2022 at 12:21 PM Maxim Mikityanskiy
> >>> <maximmi@nvidia.com> wrote:
> >>>>
> >>>> On 2022-05-07 00:51, Andrii Nakryiko wrote:
> >>>>>
> >>>>> Is it expected that your selftests will fail on s390x? Please check
> >>>>> [0]
> >>>>
> >>>> I see it fails with:
> >>>>
> >>>> test_synproxy:FAIL:ethtool -K tmp0 tx off unexpected error: 32512
> >>>> (errno 2)
> >>>>
> >>>> errno 2 is ENOENT, probably the ethtool binary is missing from the
> >>>> s390x
> >>>> image? When reviewing v6, you said you added ethtool to the CI image.
> >>>> Maybe it was added to x86_64 only? Could you add it to s390x?
> >>>>
> >>>
> >>> Could be that it was outdated in s390x, but with [0] just merged in it
> >>> should have pretty recent one.
> >>
> >> Do you mean the image was outdated and didn't contain ethtool? Or
> >> ethtool was in the image, but was outdated? If the latter, I would
> >> expect it to work, this specific ethtool command has worked for ages.
> >
> > Hi Andrii,
> >
> > Could you reply this question? I need to understand whether I need to
> > make any changes to the CI before resubmitting.
>
> I brought up a s390x VM to run the test locally, and there are two
> issues with the latest (2022-05-09) s390x image:
>
> 1. It lacks stdbuf. stdbuf is used by
> tools/testing/selftests/bpf/vmtest.sh to run any test, and this is
> clearly broken. Hence two questions:
>
> 1.1. How does CI work without stdbuf in the image? I thought it used the
> same vmtest.sh script, is that right?

no, CI doesn't use vmtest.sh. vmtest.sh is an approximation of what CI
is doing, but it doesn't share the code/scripts (it does use the same
kernel config and VM image, though)

>
> 1.2. Who can add stdbuf to the image (to fix local runs)?
>

For s390x things I usually ping Ilya. Ilya, can you help here please?

> 2. It lacks iptables needed by my test, so if I resubmit my series, it
> will fail on the CI again. Who can add iptables to the image?

Ditto, I'll defer to Ilya for this.

>
> I also compared the old (2021-03-24) and the new (2022-05-09) s390x
> images, and ethtool was indeed added only after my submission, so that
> explains the current CI error.
>
> > Thanks,
> > Max
>
