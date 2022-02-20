Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDB94BCB58
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 01:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbiBTA3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 19:29:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbiBTA3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 19:29:23 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399A842A12;
        Sat, 19 Feb 2022 16:29:03 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id s1so11939847iob.9;
        Sat, 19 Feb 2022 16:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gjWwit/P/Hck0yYwXZ993+ts+Fn/F5y63skMO8AWSWs=;
        b=MHXW/va5SEYUdNXAKqgu/Tav/Kdp5YIhOhb9zDeXbiSj2o+2DPKPqmgG8gOTdHITZW
         vTfANhfKRy/PwdFoINmgQXieGStAxrA89BWVrmRqPVdQjEeNAcWDptVtcB4ItP3dv+zW
         osuf43l7rJIYVL3M0LexBpw2etd+DRP5t+BewjXeqOf06YabWR8Wt3Uyim+i9ymSPMLA
         rioCLdWmQT4k/JnpcvAgxtA6Xx7P8wmr1vow0lsYVsuHhP1zvDiq+Bh6ZjB/rPDLaxiX
         2zcHMtNU2huHr7u8eH9z+3Djf9isWIy2EYo32fru0pt/mh6vF6U1fJ1/wWz4H3E9OrFv
         wxaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gjWwit/P/Hck0yYwXZ993+ts+Fn/F5y63skMO8AWSWs=;
        b=QyBncPkW15NDuZ5rZn9DkSM9SWF5VY+wqIjhW5tyNWde9wG/hwPG2aTa5LXlvrrrpW
         or06EuqkA8vKwbqNtyslvzQ/PpV2Sczut8tEFqN12+/EzRTSzMBhcBtNX4i3X03+Mbrf
         wEK/MYD6s69/2MAqO2RSSXMlhFXqwqB0OaE0MSrR8a2GNIl0pmzWXzMmHbUY2nXgbrTx
         Rpr7KKS8T/MPgCNvdKe1rLcIgrxIImjXk2b2O6QNaimUfmH19EC3gc2RgTObHfawelV5
         cEFxkaM6k+JaJoKE/ZiioAFiwBnFuhwxpMcSEtuSDk/bYCC5OxJpFjtuDA/bIRTODO3O
         4OCg==
X-Gm-Message-State: AOAM531+Ym1mYIp9AWRgS1iuvGtCTm2kujNOr4EJT5npL/qeZE1RDPV1
        l5b5o8AMxFEFoS9YXUWM9wIb7RyowpqrJUyScs0=
X-Google-Smtp-Source: ABdhPJw8RrIW958BALZ8dQ/SqknwOgIQoHtus31OtmV+SUQfn988lJZzebr4QBHxR30AQhC5NgITWvbXaiecyr1C9fw=
X-Received: by 2002:a6b:e901:0:b0:640:7bf8:f61d with SMTP id
 u1-20020a6be901000000b006407bf8f61dmr6530164iof.112.1645316942504; Sat, 19
 Feb 2022 16:29:02 -0800 (PST)
MIME-Version: 1.0
References: <YfK18x/XrYL4Vw8o@syu-laptop> <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz> <bb445e64-de50-e287-1acc-abfec4568775@fb.com>
 <CAADnVQJ+OVPnBz8z3vNu8gKXX42jCUqfuvhWAyCQDu8N_yqqwQ@mail.gmail.com>
 <992ae1d2-0b26-3417-9c6b-132c8fcca0ad@fb.com> <YgdIWvNsc0254yiv@syu-laptop.lan>
 <8a520fa1-9a61-c21d-f2c4-d5ba8d1b9c19@fb.com> <YgwBN8WeJvZ597/j@syu-laptop>
 <0867c12a-9aa3-418d-9102-3103cb784e99@fb.com> <87h7905559.fsf@toke.dk>
In-Reply-To: <87h7905559.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 19 Feb 2022 16:28:51 -0800
Message-ID: <CAEf4Bzbi7XiNVKYmhmiywsU0PWVg30=EOhsBWFd_xsj2vpy1xg@mail.gmail.com>
Subject: Re: BTF compatibility issue across builds
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "Connor O'Brien" <connoro@google.com>,
        =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
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

On Tue, Feb 15, 2022 at 10:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Yonghong Song <yhs@fb.com> writes:
>
> > On 2/15/22 11:38 AM, Shung-Hsi Yu wrote:
> >> On Fri, Feb 11, 2022 at 10:36:28PM -0800, Yonghong Song wrote:
> >>> On 2/11/22 9:40 PM, Shung-Hsi Yu wrote:
> >>>> On Thu, Feb 10, 2022 at 02:59:03PM -0800, Yonghong Song wrote:
> >>>>> On 2/10/22 2:34 PM, Alexei Starovoitov wrote:
> >>>>>> On Thu, Feb 10, 2022 at 10:17 AM Yonghong Song <yhs@fb.com> wrote:
> >>>>>>> On 2/10/22 2:01 AM, Michal Such=C3=A1nek wrote:
> >>>>>>>> On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
> >>>>>>>>> On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
> >>>>>>>>>> Hi,
> >>>>>>>>>>
> >>>>>>>>>> We recently run into module load failure related to split BTF =
on openSUSE
> >>>>>>>>>> Tumbleweed[1], which I believe is something that may also happ=
en on other
> >>>>>>>>>> rolling distros.
> >>>>>>>>>>
> >>>>>>>>>> The error looks like the follow (though failure is not limited=
 to ipheth)
> >>>>>>>>>>
> >>>>>>>>>>          BPF:[103111] STRUCT BPF:size=3D152 vlen=3D2 BPF: BPF:=
Invalid name BPF:
> >>>>>>>>>>
> >>>>>>>>>>          failed to validate module [ipheth] BTF: -22
> >>>>>>>>>>
> >>>>>>>>>> The error comes down to trying to load BTF of *kernel modules =
from a
> >>>>>>>>>> different build* than the runtime kernel (but the source is th=
e same), where
> >>>>>>>>>> the base BTF of the two build is different.
> >>>>>>>>>>
> >>>>>>>>>> While it may be too far stretched to call this a bug, solving =
this might
> >>>>>>>>>> make BTF adoption easier. I'd natively think that we could fur=
ther split
> >>>>>>>>>> base BTF into two part to avoid this issue, where .BTF only co=
ntain exported
> >>>>>>>>>> types, and the other (still residing in vmlinux) holds the une=
xported types.
> >>>>>>>>>
> >>>>>>>>> What is the exported types? The types used by export symbols?
> >>>>>>>>> This for sure will increase btf handling complexity.
> >>>>>>>>
> >>>>>>>> And it will not actually help.
> >>>>>>>>
> >>>>>>>> We have modversion ABI which checks the checksum of the symbols =
that the
> >>>>>>>> module imports and fails the load if the checksum for these symb=
ols does
> >>>>>>>> not match. It's not concerned with symbols not exported, it's no=
t
> >>>>>>>> concerned with symbols not used by the module. This is something=
 that is
> >>>>>>>> sustainable across kernel rebuilds with minor fixes/features and=
 what
> >>>>>>>> distributions watch for.
> >>>>>>>>
> >>>>>>>> Now with BTF the situation is vastly different. There are at lea=
st three
> >>>>>>>> bugs:
> >>>>>>>>
> >>>>>>>>      - The BTF check is global for all symbols, not for the symb=
ols the
> >>>>>>>>        module uses. This is not sustainable. Given the BTF is su=
pposed to
> >>>>>>>>        allow linking BPF programs that were built in completely =
different
> >>>>>>>>        environment with the kernel it is completely within the s=
cope of BTF
> >>>>>>>>        to solve this problem, it's just neglected.
> >>>>>>>>      - It is possible to load modules with no BTF but not module=
s with
> >>>>>>>>        non-matching BTF. Surely the non-matching BTF could be di=
scarded.
> >>>>>>>>      - BTF is part of vermagic. This is completely pointless sin=
ce modules
> >>>>>>>>        without BTF can be loaded on BTF kernel. Surely it would =
not be too
> >>>>>>>>        difficult to do the reverse as well. Given BTF must pass =
extra check
> >>>>>>>>        to be used having it in vermagic is just useless moise.
> >>>>>>>>
> >>>>>>>>>> Does that sound like something reasonable to work on?
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> ## Root case (in case anyone is interested in a verbose versio=
n)
> >>>>>>>>>>
> >>>>>>>>>> On openSUSE Tumbleweed there can be several builds of the same=
 source. Since
> >>>>>>>>>> the source is the same, the binaries are simply replaced when =
a package with
> >>>>>>>>>> a larger build number is installed during upgrade.
> >>>>>>>>>>
> >>>>>>>>>> In our case, a rebuild is triggered[2], and resulted in change=
s in base BTF.
> >>>>>>>>>> More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_check_=
pec(u8 cpec,
> >>>>>>>>>> struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_has=
hinfo *h,
> >>>>>>>>>> struct sock *sk) was added to the base BTF of 5.15.12-1.3. Tho=
se functions
> >>>>>>>>>> are previously missing in base BTF of 5.15.12-1.1.
> >>>>>>>>>
> >>>>>>>>> As stated in [2] below, I think we should understand why rebuil=
d is
> >>>>>>>>> triggered. If the rebuild for vmlinux is triggered, why the mod=
ules cannot
> >>>>>>>>> be rebuild at the same time?
> >>>>>>>>
> >>>>>>>> They do get rebuilt. However, if you are running the kernel and =
install
> >>>>>>>> the update you get the new modules with the old kernel. If the i=
nstall
> >>>>>>>> script fails to copy the kernel to your EFI partition based on t=
he fact
> >>>>>>>> a kernel with the same filename is alreasy there you get the sam=
e.
> >>>>>>>>
> >>>>>>>> If you have 'stable' distribution adding new symbols is normal a=
nd it
> >>>>>>>> does not break module loading without BTF but it breaks BTF.
> >>>>>>>
> >>>>>>> Okay, I see. One possible solution is that if kernel module btf
> >>>>>>> does not match vmlinux btf, the kernel module btf will be ignored
> >>>>>>> with a dmesg warning but kernel module load will proceed as norma=
l.
> >>>>>>> I think this might be also useful for bpf lskel kernel modules as
> >>>>>>> well which tries to be portable (with CO-RE) for different kernel=
s.
> >>>>>>
> >>>>>> That sounds like #2 that Michal is proposing:
> >>>>>> "It is possible to load modules with no BTF but not modules with
> >>>>>>     non-matching BTF. Surely the non-matching BTF could be discard=
ed."
> >>>>
> >>>> Since we're talking about matching check, I'd like bring up another =
issue.
> >>>>
> >>>> AFAICT with current form of BTF, checking whether BTF on kernel modu=
le
> >>>> matches cannot be made entirely robust without a new version of btf_=
header
> >>>> that contain info about the base BTF.
> >>>
> >>> The base BTF is always the one associated with running kernel and typ=
ically
> >>> the BTF is under /sys/kernel/btf/vmlinux. Did I miss
> >>> anything here?
> >>>
> >>>> As effective as the checks are in this case, by detecting a type nam=
e being
> >>>> an empty string and thus conclude it's non-matching, with some (bad)=
 luck a
> >>>> non-matching BTF could pass these checks a gets loaded.
> >>>
> >>> Could you be a little bit more specific about the 'bad luck' a
> >>> non-matching BTF could get loaded? An example will be great.
> >>
> >> Let me try take a jab at it. Say here's a hypothetical BTF for a kerne=
l
> >> module which only type information for `struct something *`:
> >>
> >>    [5] PTR '(anon)' type_id=3D4
> >>
> >> Which is built upon the follow base BTF:
> >>
> >>    [1] INT 'unsigned char' size=3D1 bits_offset=3D0 nr_bits=3D8 encodi=
ng=3D(none)
> >>    [2] PTR '(anon)' type_id=3D3
> >>    [3] STRUCT 'list_head' size=3D16 vlen=3D2
> >>          'next' type_id=3D2 bits_offset=3D0
> >>          'prev' type_id=3D2 bits_offset=3D64
> >>    [4] STRUCT 'something' size=3D2 vlen=3D2
> >>          'locked' type_id=3D1 bits_offset=3D0
> >>          'pending' type_id=3D1 bits_offset=3D8
> >>
> >> Due to the situation mentioned in the beginning of the thread, the *ru=
ntime*
> >> kernel have a different base BTF, in this case type IDs are offset by =
1 due
> >> to an additional typedef entry:
> >>
> >>    [1] TYPEDEF 'u8' type_id=3D1
> >>    [2] INT 'unsigned char' size=3D1 bits_offset=3D0 nr_bits=3D8 encodi=
ng=3D(none)
> >>    [3] PTR '(anon)' type_id=3D3
> >>    [4] STRUCT 'list_head' size=3D16 vlen=3D2
> >>          'next' type_id=3D2 bits_offset=3D0
> >>          'prev' type_id=3D2 bits_offset=3D64
> >>    [5] STRUCT 'something' size=3D2 vlen=3D2
> >>          'locked' type_id=3D1 bits_offset=3D0
> >>          'pending' type_id=3D1 bits_offset=3D8
> >>
> >> Then when loading the BTF on kernel module on the runtime, the kernel =
will
> >> mistakenly interprets "PTR '(anon)' type_id=3D4" as `struct list_head =
*`
> >> rather than `struct something *`.
> >>
> >> Does this should possible? (at least theoretically)
> >
> > Thanks for explanation. Yes, from BTF type resolution point of view,
> > yes it is possible.
>
> Could we add a marker or something to prevent this from happening?
> Something like putting the hash of the entire BTF structure into the
> header and referring to that from the "child"; or really any other way
> of detecting that the combined BTF you're constructing is going to be
> wrong?
>

Extending BTF format (including its header) is quite disrupting to the
entire ecosystem around BTF. Given split BTF is only used for kernel
modules, I think it's a better approach to add checksum to module's
ELF itself (as an extra BTF-related section, .BTF.base_checksum or
whatever) and check it during kernel module loading time.

As for having full BTF. You can do that, and it will work for generic
CO-RE approach, but it might not work for kfunc and other things that
expect that, say, struct task_struct has one specific ID that
corresponds to task_struct BTF ID in vmlinux BTF. If kernel module is
loaded against vmlinux BTF that has just slightly different definition
of task_struct (e.g., one field was added at the end), dedup algorithm
will detect those differences and will preserve module's definition of
task_struct as a separate type, which won't be recognized by kernel as
task_struct.

But again, given it's all module-specific, we can utilize custom
.BTF.* sections to record any such information without disrupting any
other user of BTF, including all the BPF applications out there.

> -Toke
>
