Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2A4582318
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiG0J2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbiG0J15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:27:57 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C57847BB6
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:27:55 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id i14so29347788yba.1
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bBFDz2W5xcHE0ZM3OCmaQTYQarGqNZfYlbjkrHAkU7Y=;
        b=GzP/fohU8r+nSa3pQEBIHnxBWxZwdz999gax3ajvKKV/3qdNXgkMNf+4icGDdVliom
         bSnb1aJALnTPPwUJAbpGuWaJJZ9qjslqNlGZZAneOAIusIAWv1CUuTznA9SxSf6+mIh2
         pqhUvsR4XeiSykRLGwKylGq9JxhtxOWhs99agWtcf4xdfPblA4Wo+3WABwYAmdva9L0J
         WvKFgZo2Q/IJkcXb3a3GjoXn0WD+wzQDWCfiux1tarsXAr2hhDUGBq7rwGFG8tURaiPF
         pK8/1x0OC8CDhcC+tZW4s05T4/N2tzLIO2a2LvZLqCsmQI478xmdYM+ibJPHWyDy5TvS
         m9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bBFDz2W5xcHE0ZM3OCmaQTYQarGqNZfYlbjkrHAkU7Y=;
        b=iOEas6gbpfCNHsZ7KizB321XMsj7ocYSvUkD9ptpHQDwiCrYzlMW8TCfKe1Oa+clxB
         Y1T+idPzKKFZ+pX0/XTj73cjRvaKoOQ4lKjkw4IBlMlvg3x6ZM0og6+mMfLfsQsAU/vm
         DlTiHidi/jLadLBbrIgIzxtgSjkwV9f7GfV5sDaYS7htrWcvxltdf6ZGERgxYTdl3a5A
         yOuxH0ipN5pa1rJfKiYDT480ZaGG5nDvUmaAU8FTsGw+X7DcE8CLaAUbKZuF5bDjIf0E
         jcldqgSXXq8X/ea1t3Q+21NO9wCztC5lzVx8A8uKYWaNPwEk/GgXU79rFAPbv7TfZwls
         kMIg==
X-Gm-Message-State: AJIora8XkerH6GnXfks4dMIiK2b+NjEvUTlLg9+p+uWoL8hfuQCVGseg
        8ymPi86zyuSFsEilikr3vqLFlLCvMjDdmhR5z6PZXw==
X-Google-Smtp-Source: AGRyM1ug6YIa7Qapp9b4B5y5/JmJxQbX5IwK+4B6dyOrtwMDpXUoAPCGrqsdEXvxbtlSDQIZ8jY0SSTJaKISEH9GcuU=
X-Received: by 2002:a25:ab84:0:b0:671:748b:ffab with SMTP id
 v4-20020a25ab84000000b00671748bffabmr5212697ybi.427.1658914074600; Wed, 27
 Jul 2022 02:27:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1658815925.git.cdleonard@gmail.com> <ad19d5c8a24054d48e1c35bb0ec92075b9f0dc6a.1658815925.git.cdleonard@gmail.com>
 <CANn89i+ByJsdKLXi982jq0H3irYg_ANSEdmL2zwZ_7G-E_g2eg@mail.gmail.com>
 <CANn89i+=LVDFx_zjDy6uK+QorR+fosdkb8jqNMO6syqOsS7ZqQ@mail.gmail.com> <dd2ca85e-ab29-2973-f129-9afafb405851@gmail.com>
In-Reply-To: <dd2ca85e-ab29-2973-f129-9afafb405851@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Jul 2022 11:27:43 +0200
Message-ID: <CANn89iLUuSWFHbZnb9DSJfR58bCU=pq+uPmT6s45=nrDzMWYYg@mail.gmail.com>
Subject: Re: [PATCH v6 21/26] selftests: net/fcnal: Initial tcp_authopt support
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 10:29 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>
>
> On 7/26/22 10:27, Eric Dumazet wrote:
> > On Tue, Jul 26, 2022 at 9:06 AM Eric Dumazet <edumazet@google.com> wrote:
> >>
> >> On Tue, Jul 26, 2022 at 8:16 AM Leonard Crestez <cdleonard@gmail.com> wrote:
> >>>
> >>> Tests are mostly copied from tcp_md5 with minor changes.
> >>>
> >>> It covers VRF support but only based on binding multiple servers: not
> >>> multiple keys bound to different interfaces.
> >>>
> >>> Also add a specific -t tcp_authopt to run only these tests specifically.
> >>>
> >>
> >> Thanks for the test.
> >>
> >> Could you amend the existing TCP MD5 test to make sure dual sockets
> >> mode is working ?
> >>
> >> Apparently, if we have a dual stack listener socket (AF_INET6),
> >> correct incoming IPV4 SYNs are dropped.
>
> >>   If this is the case, fixing MD5 should happen first ;
>
> I remember looking into this and my conclusion was that ipv4-mapped-ipv6
> is not worth supporting for AO, at least not in the initial version.
>
> Instead I just wrote a test to check that ipv4-mapped-ipv6 fails for AO:
> https://github.com/cdleonard/tcp-authopt-test/blob/main/tcp_authopt_test/test_verify_capture.py#L191
>
> On a closer look it does appear that support existed for
> ipv4-mapped-ipv6 in TCP-MD5 but my test didn't actually exercise it
> correctly so the test had to be fixed.
>
>
> Do you think it makes sense to add support for ipv4-mapped-ipv6 for AO?
> It's not particularly difficult to test, it was skipped due to a lack of
> application use case and to keep the initial series smaller.

I think this makes sense. ipv4-mapped support is definitely used.

>
> Adding support for this later as a separate commit should be fine. Since
> ivp4-mapped-ipv6 addresses shouldn't appear on the wire giving them
> special treatment "later" should raise no compatibility concerns.
>
>
> >> I think that we are very late in the cycle (linux-5.19 should be
> >> released in 5 days), and your patch set should not be merged so late.
>
> This was posted in order to get code reviews, I'm not actually expecting
> inclusion.

To be clear, I am supporting this work and would like to see it being
merged hopefully soon ;)
