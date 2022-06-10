Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BE0546F7C
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 00:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244326AbiFJWCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 18:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347622AbiFJWBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 18:01:47 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD6628991;
        Fri, 10 Jun 2022 15:01:41 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id b81so135267vkf.1;
        Fri, 10 Jun 2022 15:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w2a8MMLStqGJpbQ4JSgaViyo56QdxV8uBLXeFRfLzZA=;
        b=otobDhQqCuLfav9uUR0LrUWEU/Vv3KserzOoodVW5JloOdft+NWYyD00xC8miK8//j
         HmZSu6kZABFqN6MXEhJPaMmfs+bd+xydaN/JHYlJCIY8npPigfQ2KZLLXcenSYTwVkUq
         I2a3L/3o8koe0w8G4Mz5rgxhMJlVekxoOQtX7vFkcmhyXw5cbVKlwUa8DQVDGiwkgS7F
         zumoO+oB44mWtrGgrziT24sqpb3OlVbwbWyL/Rqmy8fsyP5e8ESQorvaumG9uGnFNtus
         84Yum2l5n9qrc5gyIlqqRVEjSaIKkCYHSfIegEFFitE2qbNRFDpG1uR9yQZLygLeEdzl
         /BhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w2a8MMLStqGJpbQ4JSgaViyo56QdxV8uBLXeFRfLzZA=;
        b=P3MoD/+L4dlssZjgECw282S+lJnY3cy7qHLQedxuFZkbc4yKBB3ykPFq/Gx0KmM3sq
         ZFxLWxJdvnU1PAeSWEHCRFvlgEQncBXWNYhWrCreLStpWLElseX++b/9PgkQVuUnhGRl
         U3ZEYYxaaJouWjlHB8OXofUwMM+rHiIq2OwWZtv3ODzpBhZxkjT0NTizGha58xwPpz1F
         FvE89pyRqMbVXAzwZrtHQleP3LH/r2Y6ScA7JbG4ho9rnbxNARHWwiEGOisjbfVhxQX/
         TnOtzWYVOoGf/vqkkKKeuNZ+B1ekipXMXrNI+3dzNhO2QcZQZdJ3tdPRHnKu+ATt44ce
         L5Bw==
X-Gm-Message-State: AOAM530SD/Ad2CCHKnPQF/UfOEAm9riFxY+qwzM0Ba/Cxx9iY8LFH85L
        U7kzBy03+iOBXy45J9TlTNMQxfkn4Hw6CtkKQns=
X-Google-Smtp-Source: ABdhPJxXS7fcyS0Zk2DkkIeJOAb7As0nkwoPY81uVrTfRSK9ZYOewpLGdt4u0//afvJme9m/O3YWa5SpnD6y7auFvoA=
X-Received: by 2002:a1f:4c87:0:b0:365:4211:1121 with SMTP id
 z129-20020a1f4c87000000b0036542111121mr1997736vka.12.1654898500633; Fri, 10
 Jun 2022 15:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210604063116.234316-1-memxor@gmail.com> <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
 <20220610125830.2tx6syagl2rphl35@apollo.legion> <CAJnrk1YCBn2EkVK89f5f3ijFYUDhLNpjiH8buw8K3p=JMwAc1Q@mail.gmail.com>
 <CAJnrk1YCSaRjd88WCzg4ccv59h0Dn99XXsDDT4ddzz4UYiZmbg@mail.gmail.com>
 <20220610193418.4kqpu7crwfb5efzy@apollo.legion> <e82d41e4-c1c0-7387-8c83-b71ecb9d92d2@iogearbox.net>
In-Reply-To: <e82d41e4-c1c0-7387-8c83-b71ecb9d92d2@iogearbox.net>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 10 Jun 2022 15:01:29 -0700
Message-ID: <CAJnrk1Y_u_-RN6xTqVhJ12hrP2U+QPmHJxHMTMq+8D1XPXXbJQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/7] Add bpf_link based TC-BPF API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
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

On Fri, Jun 10, 2022 at 1:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hi Joanne, hi Kumar,
>
> On 6/10/22 9:34 PM, Kumar Kartikeya Dwivedi wrote:
> > On Sat, Jun 11, 2022 at 12:37:50AM IST, Joanne Koong wrote:
> >> On Fri, Jun 10, 2022 at 10:23 AM Joanne Koong <joannelkoong@gmail.com> wrote:
> >>> On Fri, Jun 10, 2022 at 5:58 AM Kumar Kartikeya Dwivedi
> >>> <memxor@gmail.com> wrote:
> >>>> On Fri, Jun 10, 2022 at 05:54:27AM IST, Joanne Koong wrote:
> >>>>> On Thu, Jun 3, 2021 at 11:31 PM Kumar Kartikeya Dwivedi
> >>>>> <memxor@gmail.com> wrote:
> [...]
> >>>> I can have a look at resurrecting it later this month, if you're ok with waiting
> >>>> until then, otherwise if someone else wants to pick this up before that it's
> >>>> fine by me, just let me know so we avoid duplicated effort. Note that the
> >>>> approach in v2 is dead/unlikely to get accepted by the TC maintainers, so we'd
> >>>> have to implement the way Daniel mentioned in [0].
> >>>
> >>> Sounds great! We'll wait and check back in with you later this month.
> >>>
> >> After reading the linked thread (which I should have done before
> >> submitting my previous reply :)),  if I'm understanding it correctly,
> >> it seems then that the work needed for tc bpf_link will be in a new
> >> direction that's not based on the code in this v2 patchset. I'm
> >> interested in learning more about bpf link and tc - I can pick this up
> >> to work on. But if this was something you wanted to work on though,
> >> please don't hesitate to let me know; I can find some other bpf link
> >> thing to work on instead if that's the case.
>
> The tc ingress/egress overhaul we also discussed at lsf/mm/bpf in our session
> with John and pretty much is along the lines as in the earlier link you sent.
> We need it from Cilium & Tetragon as well, so it's wip from our side at the
> moment, modulo the bpf link part. Would you be okay if I pinged you once something
> that is plateable is ready?
Yeah definitely! Thanks for letting me know!
>
> Thanks,
> Daniel
