Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77A04B3050
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 23:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354042AbiBKWUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 17:20:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240543AbiBKWUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 17:20:40 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB12CD48;
        Fri, 11 Feb 2022 14:20:38 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id f13so7945321ilq.5;
        Fri, 11 Feb 2022 14:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9siwtivQEhD1dyb4soeM55JqK6NlVyt4V4X0wv3BpNw=;
        b=A4icLPJIgBKKkZfOSDL2IOYv6Wa+EJ7KALt2bGG7bPkca+yqja4IkoCq810ljRM9OW
         DGYRkw3/nSEZscP8W7IALMHgufpy47ATk31v+30Rp/40ZaEDflKpXr40oC1ZfPrrVt31
         +DbhusP1oUaz6jtcEce0ExnsOuX5BHFiFu1MjlfsIr2xBf2ZKpCa5kYSPkq9jkat9vzF
         +tDmsNMHbvHXIYl7WknrGKmmqR36+mGjoL9xeY4Q6Ez8xWdcitT5drZkWIf/AgbCohxG
         st+IDVWi95TvJeGJ+0TelObuuQnbNdjEbkZ0bPxrt71BthxJ7T6zSjj3o6rVi93vJ09m
         rx5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9siwtivQEhD1dyb4soeM55JqK6NlVyt4V4X0wv3BpNw=;
        b=j5aL61X7JGON7/fFXIOL+yuTfRaEYfkYNQdkkrrZ8r+oqPENj6/5g+RHGADCHJkDdz
         25240yjK/hve2nbPyspjbG65GUStqfqXk6zhruKWYWY06EkJF7Ka3onUH1LL6PzMWg0/
         /ewQO0Dedcn5F1BTDBpCOosXcHKizv2jTqyoZg2bdSPWa7sn3z2+7HUNt/9OyNAwS0Yo
         u68Uy+o8cafGMo9EcTz3NLEOIAPlk6TQy6rwqM7VJ+/d4KdR064xjqX5ndDygbHs1Ulv
         a23GwXB4gc2J37pkEAH9cn+jotfFcz0XmJeWoh9yXSgjgTzF4YyGoWl2+Lw5ttZR3Jt3
         C4eg==
X-Gm-Message-State: AOAM530Akc7DaXvzH54YlfprdiVCj2vpJ0wAGXQy7K/D7Rjk+Vzo9PvW
        u22GCFdmWaOfLus75SSO5o6OelWIsU+zDufmQso=
X-Google-Smtp-Source: ABdhPJw+k+qWxEU8aWcQwWOZYFMNxB07IHYoicVRR1l7Y+qaHnOohM2UOCHKK+SYy8VeINFIXCxJpYnrKaj0zgb5XeY=
X-Received: by 2002:a05:6e02:1565:: with SMTP id k5mr2043491ilu.239.1644618038239;
 Fri, 11 Feb 2022 14:20:38 -0800 (PST)
MIME-Version: 1.0
References: <YfK18x/XrYL4Vw8o@syu-laptop> <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz> <CAEf4BzZ6CrNGWt3DENvCBXpUKrvNiZwoK87rR75izP=CDf8YoQ@mail.gmail.com>
 <87a6ex8gm8.fsf@toke.dk>
In-Reply-To: <87a6ex8gm8.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Feb 2022 14:20:27 -0800
Message-ID: <CAEf4BzYJCHB-oYqFqJTfHU4D795ewgkndQtR1Po5H521fH0oMg@mail.gmail.com>
Subject: Re: BTF compatibility issue across builds
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>,
        Yonghong Song <yhs@fb.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 9:20 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Thu, Feb 10, 2022 at 2:01 AM Michal Such=C3=A1nek <msuchanek@suse.de=
> wrote:
> >>
> >> Hello,
> >>
> >> On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
> >> >
> >> >
> >> > On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
> >> > > Hi,
> >> > >
> >> > > We recently run into module load failure related to split BTF on o=
penSUSE
> >> > > Tumbleweed[1], which I believe is something that may also happen o=
n other
> >> > > rolling distros.
> >> > >
> >> > > The error looks like the follow (though failure is not limited to =
ipheth)
> >> > >
> >> > >      BPF:[103111] STRUCT BPF:size=3D152 vlen=3D2 BPF: BPF:Invalid =
name BPF:
> >> > >
> >> > >      failed to validate module [ipheth] BTF: -22
> >> > >
> >> > > The error comes down to trying to load BTF of *kernel modules from=
 a
> >> > > different build* than the runtime kernel (but the source is the sa=
me), where
> >> > > the base BTF of the two build is different.
> >> > >
> >> > > While it may be too far stretched to call this a bug, solving this=
 might
> >> > > make BTF adoption easier. I'd natively think that we could further=
 split
> >> > > base BTF into two part to avoid this issue, where .BTF only contai=
n exported
> >> > > types, and the other (still residing in vmlinux) holds the unexpor=
ted types.
> >> >
> >> > What is the exported types? The types used by export symbols?
> >> > This for sure will increase btf handling complexity.
> >>
> >> And it will not actually help.
> >>
> >> We have modversion ABI which checks the checksum of the symbols that t=
he
> >> module imports and fails the load if the checksum for these symbols do=
es
> >> not match. It's not concerned with symbols not exported, it's not
> >> concerned with symbols not used by the module. This is something that =
is
> >> sustainable across kernel rebuilds with minor fixes/features and what
> >> distributions watch for.
> >>
> >> Now with BTF the situation is vastly different. There are at least thr=
ee
> >> bugs:
> >>
> >>  - The BTF check is global for all symbols, not for the symbols the
> >>    module uses. This is not sustainable. Given the BTF is supposed to
> >>    allow linking BPF programs that were built in completely different
> >>    environment with the kernel it is completely within the scope of BT=
F
> >>    to solve this problem, it's just neglected.
> >
> > You refer to BTF use in CO-RE with the latter. It's just one
> > application of BTF and it doesn't follow that you can do the same with
> > module BTF. It's not a neglect, it's a very big technical difficulty.
> >
> > Each module's BTFs are designed as logical extensions of vmlinux BTF.
> > And each module BTF is independent and isolated from other modules
> > extension of the same vmlinux BTF. The way that BTF format is
> > designed, any tiny difference in vmlinux BTF effectively invalidates
> > all modules' BTFs and they have to be rebuilt.
> >
> > Imagine that only one BTF type is added to vmlinux BTF. Last BTF type
> > ID in vmlinux BTF is shifted from, say, 1000 to 1001. While previously
> > every module's BTF type ID started with 1001, now they all have to
> > start with 1002 and be shifted by 1.
> >
> > Now let's say that the order of two BTF types in vmlinux BTF is
> > changed, say type 10 becomes type 20 and type 20 becomes type 10 (just
> > because of slight difference in DWARF, for instance). Any type
> > reference to 10 or 20 in any module BTF has to be renumbered now.
> >
> > Another one, let's say we add a new string to vmlinux BTF string
> > section somewhere at the beginning, say "abc" at offset 100. Any
> > string offset after 100 now has to be shifted *both* in vmlinux BTF
> > and all module BTFs. And also any string reference in module BTFs have
> > to be adjusted as well because now each module's BTF's logical string
> > offset is starting at 4 logical bytes higher (due to "abc\0" being
> > added and shifting everything right).
> >
> > As you can see, any tiny change in vmlinux BTF, no matter where,
> > beginning, middle, or end, causes massive changes in type IDs and
> > offsets everywhere. It's impractical to do any local adjustments, it's
> > much simpler and more reliable to completely regenerate BTF
> > completely.
>
> This seems incredibly brittle, though? IIUC this means that if you want
> BTF in your modules you *must* have not only the kernel headers of the
> kernel it's going to run on, but the full BTF information for the exact

From BTF perspective, only vmlinux BTF. Having exact kernel headers
would minimize type information duplication.

> kernel image you're going to load that module on? How is that supposed
> to work for any kind of environment where everything is not built
> together? Third-party modules for distribution kernels is the obvious
> example that comes to mind here, but as this thread shows, they don't
> necessarily even have to be third party...
>
> How would you go about "completely regenerating BTF" in practice for a
> third-party module, say?

Great questions. I was kind of hoping you'll have some suggestions as
well, though. Not just complaints.

>
> -Toke
>
