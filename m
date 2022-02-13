Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536CB4B3C24
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 16:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbiBMPk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 10:40:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiBMPk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 10:40:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C2F15F8CB
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 07:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644766849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YbJQamN+sKTyPLg9NaZqK73U4/0pTwLbVitSiQ2XTUQ=;
        b=fQb4lUhB3CJSc6lMP42ml+SNWTD7lQfHO+JZorTWFFSDki+TIlwJV8NDPxgLqJBhny9UkE
        lHWcwFjiTFyvo7Rd2+ZnhZLyh1CSSmncs39I8jDRQ6kpB9S/kox+XR12LUcKWCSyc5InaJ
        2Z3a2OGqgIk1aWntJDlzOrk6grPHrtw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-tkDqp9SYOWyYN8nJVh53tA-1; Sun, 13 Feb 2022 10:40:48 -0500
X-MC-Unique: tkDqp9SYOWyYN8nJVh53tA-1
Received: by mail-ed1-f72.google.com with SMTP id r11-20020a508d8b000000b00410a4fa4768so1404267edh.9
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 07:40:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=YbJQamN+sKTyPLg9NaZqK73U4/0pTwLbVitSiQ2XTUQ=;
        b=OYWtIpqaupYWvlb1QoWEH8AAbtfDLI57z9VH7/Xc5zbohmHysUPkF9NnSYth7rAUzN
         Vt8VSY1xbfLx/w0zL5fZfwh+xNAlZzQAdl3381NX9VcY4aUPKSwZLE4khxTKPhs4lLbC
         TcbjPrm7Tvpi3TqnMqdRiMp6tylTuKX5s31+zLjh56E9NMEdWvV6R02Hf2vfYzOkK2nJ
         IlQ+5pTIGmgsP1XahzuNmwOnmbh9SjQpNJj5M7njoDfOKwcSL9yoQHeECNybylO204FR
         bnq98GY9MaXgLCcSauAjlOMX+q9pN7j/OXzME/QSc17uLrUQxBVPPu2RPNZlZQbeFkrF
         idqg==
X-Gm-Message-State: AOAM530Mm7tx16b97CPvsIR3sUByvF098CCFTf0MVjD2ZDzuuC0YIivE
        ESTAa0Ysc2ARQdQRBDVQHhXDt+mN6aCSOnUaJXufZlS3RZBdddZvAREBXfnbc1Qm4MjsQTZbn7P
        hxAZp/S53eKodNhQw
X-Received: by 2002:a17:907:7da4:: with SMTP id oz36mr2649739ejc.59.1644766846504;
        Sun, 13 Feb 2022 07:40:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwS5JxYITvy8PL5O+WqNK+RIJFpmYH6pkBtbVT2ImKcZolo5sUDL9u5Au9blkyr/mvITCERRQ==
X-Received: by 2002:a17:907:7da4:: with SMTP id oz36mr2649715ejc.59.1644766845992;
        Sun, 13 Feb 2022 07:40:45 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ed9sm8898476edb.59.2022.02.13.07.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 07:40:45 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 69FBF1031BE; Sun, 13 Feb 2022 16:40:44 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal =?utf-8?Q?Such?= =?utf-8?Q?=C3=A1nek?= 
        <msuchanek@suse.de>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: BTF compatibility issue across builds
In-Reply-To: <Ygdjt0Qbki0tHG4k@syu-laptop.lan>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
 <CAEf4BzZ6CrNGWt3DENvCBXpUKrvNiZwoK87rR75izP=CDf8YoQ@mail.gmail.com>
 <87a6ex8gm8.fsf@toke.dk>
 <CAEf4BzYJCHB-oYqFqJTfHU4D795ewgkndQtR1Po5H521fH0oMg@mail.gmail.com>
 <87v8xl6jlw.fsf@toke.dk> <Ygdjt0Qbki0tHG4k@syu-laptop.lan>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 13 Feb 2022 16:40:44 +0100
Message-ID: <87ee467p1f.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shung-Hsi Yu <shung-hsi.yu@suse.com> writes:

> On Sat, Feb 12, 2022 at 12:58:51AM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>=20
>> > On Fri, Feb 11, 2022 at 9:20 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> >>
>> >> > On Thu, Feb 10, 2022 at 2:01 AM Michal Such=C3=A1nek <msuchanek@sus=
e.de> wrote:
>> >> >>
>> >> >> Hello,
>> >> >>
>> >> >> On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
>> >> >> >
>> >> >> >
>> >> >> > On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
>> >> >> > > Hi,
>> >> >> > >
>> >> >> > > We recently run into module load failure related to split BTF =
on openSUSE
>> >> >> > > Tumbleweed[1], which I believe is something that may also happ=
en on other
>> >> >> > > rolling distros.
>> >> >> > >
>> >> >> > > The error looks like the follow (though failure is not limited=
 to ipheth)
>> >> >> > >
>> >> >> > >      BPF:[103111] STRUCT BPF:size=3D152 vlen=3D2 BPF: BPF:Inva=
lid name BPF:
>> >> >> > >
>> >> >> > >      failed to validate module [ipheth] BTF: -22
>> >> >> > >
>> >> >> > > The error comes down to trying to load BTF of *kernel modules =
from a
>> >> >> > > different build* than the runtime kernel (but the source is th=
e same), where
>> >> >> > > the base BTF of the two build is different.
>> >> >> > >
>> >> >> > > While it may be too far stretched to call this a bug, solving =
this might
>> >> >> > > make BTF adoption easier. I'd natively think that we could fur=
ther split
>> >> >> > > base BTF into two part to avoid this issue, where .BTF only co=
ntain exported
>> >> >> > > types, and the other (still residing in vmlinux) holds the une=
xported types.
>> >> >> >
>> >> >> > What is the exported types? The types used by export symbols?
>> >> >> > This for sure will increase btf handling complexity.
>> >> >>
>> >> >> And it will not actually help.
>> >> >>
>> >> >> We have modversion ABI which checks the checksum of the symbols th=
at the
>> >> >> module imports and fails the load if the checksum for these symbol=
s does
>> >> >> not match. It's not concerned with symbols not exported, it's not
>> >> >> concerned with symbols not used by the module. This is something t=
hat is
>> >> >> sustainable across kernel rebuilds with minor fixes/features and w=
hat
>> >> >> distributions watch for.
>> >> >>
>> >> >> Now with BTF the situation is vastly different. There are at least=
 three
>> >> >> bugs:
>> >> >>
>> >> >>  - The BTF check is global for all symbols, not for the symbols the
>> >> >>    module uses. This is not sustainable. Given the BTF is supposed=
 to
>> >> >>    allow linking BPF programs that were built in completely differ=
ent
>> >> >>    environment with the kernel it is completely within the scope o=
f BTF
>> >> >>    to solve this problem, it's just neglected.
>> >> >
>> >> > You refer to BTF use in CO-RE with the latter. It's just one
>> >> > application of BTF and it doesn't follow that you can do the same w=
ith
>> >> > module BTF. It's not a neglect, it's a very big technical difficult=
y.
>> >> >
>> >> > Each module's BTFs are designed as logical extensions of vmlinux BT=
F.
>> >> > And each module BTF is independent and isolated from other modules
>> >> > extension of the same vmlinux BTF. The way that BTF format is
>> >> > designed, any tiny difference in vmlinux BTF effectively invalidates
>> >> > all modules' BTFs and they have to be rebuilt.
>> >> >
>> >> > Imagine that only one BTF type is added to vmlinux BTF. Last BTF ty=
pe
>> >> > ID in vmlinux BTF is shifted from, say, 1000 to 1001. While previou=
sly
>> >> > every module's BTF type ID started with 1001, now they all have to
>> >> > start with 1002 and be shifted by 1.
>> >> >
>> >> > Now let's say that the order of two BTF types in vmlinux BTF is
>> >> > changed, say type 10 becomes type 20 and type 20 becomes type 10 (j=
ust
>> >> > because of slight difference in DWARF, for instance). Any type
>> >> > reference to 10 or 20 in any module BTF has to be renumbered now.
>> >> >
>> >> > Another one, let's say we add a new string to vmlinux BTF string
>> >> > section somewhere at the beginning, say "abc" at offset 100. Any
>> >> > string offset after 100 now has to be shifted *both* in vmlinux BTF
>> >> > and all module BTFs. And also any string reference in module BTFs h=
ave
>> >> > to be adjusted as well because now each module's BTF's logical stri=
ng
>> >> > offset is starting at 4 logical bytes higher (due to "abc\0" being
>> >> > added and shifting everything right).
>> >> >
>> >> > As you can see, any tiny change in vmlinux BTF, no matter where,
>> >> > beginning, middle, or end, causes massive changes in type IDs and
>> >> > offsets everywhere. It's impractical to do any local adjustments, i=
t's
>> >> > much simpler and more reliable to completely regenerate BTF
>> >> > completely.
>> >>
>> >> This seems incredibly brittle, though? IIUC this means that if you wa=
nt
>> >> BTF in your modules you *must* have not only the kernel headers of the
>> >> kernel it's going to run on, but the full BTF information for the exa=
ct
>> >
>> > From BTF perspective, only vmlinux BTF. Having exact kernel headers
>> > would minimize type information duplication.
>>=20
>> Right, I meant you'd need the kernel headers to compile the module, and
>> the vmlinux BTF to build the module BTF info.
>>=20
>> >> kernel image you're going to load that module on? How is that supposed
>> >> to work for any kind of environment where everything is not built
>> >> together? Third-party modules for distribution kernels is the obvious
>> >> example that comes to mind here, but as this thread shows, they don't
>> >> necessarily even have to be third party...
>> >>
>> >> How would you go about "completely regenerating BTF" in practice for a
>> >> third-party module, say?
>> >
>> > Great questions. I was kind of hoping you'll have some suggestions as
>> > well, though. Not just complaints.
>>=20
>> Well, I kinda took your "not really a bug either" comment to mean you
>> weren't really open to changing the current behaviour. But if that was a
>> misunderstanding on my part, I do have one thought:
>>=20
>> The "partial BTF" thing in the modules is done to save space, right?
>> I.e., in principle there would be nothing preventing a module from
>> including a full (self-contained) set of BTF in its .ko when it is
>> compiled? Because if so, we could allow that as an optional mode that
>> can be enabled if you don't mind taking the size hit (any idea how large
>> that usually is, BTW?).
>
> This seems quite nice IMO as no change need to be made on the generation
> side of existing BTF tooling. I test it out on openSUSE Tumbleweed 5.16.5
> kernel modules, and for the sake of completeness, includes both the case
> where BTF is stripped and using a pre-trained zstd dictionary as well.
>
> Uncompressed, no BTF                             362MiB -27%
> Uncompressed, parital BTF                        499MiB +0%
> Uncompressed, self-contained BTF                1026MiB +105%
>
> Zstd compressed, no BTF                           95MiB -35%
> Zstd compressed, partial BTF                     147MiB +0%
> Zstd compressed, self-contained BTF              361MiB +145%
> Zstd compressed (trained), self-contained BTF    299MiB +103%
>
> So we'd expect quite a bit of hit as the size of kernel module would doub=
le.
>
> For servers and workstation environment an additional ~200MiB of disk spa=
ce
> seems like tolerable trade-off if it can get third-party kernel module to
> work. But I cannot speak for other kind of use cases.

Well, there are also in-between tradeoffs (i.e., you can build a subset
of the modules with self-contained BTF and a subset with partial BTF
depending on what fits your build environment).

We could also come up with more optimisations later if needed; one thing
that comes to mind is adding the option to build a set of modules
together and have them deduplicate BTF between them, but still be
self-contained as a group. E.g., all netfilter modules could share a
common BTF set if you can be sure they will always be rebuilt together.
Once we have the deduplication logic in 'modprobe' this could be made
infinitely complex (recursive groups of deduplicated chunks of BTF!),
but that's probably overdoing it ;)

>> And then we could teach 'modprobe' to do a fresh deduplication of this
>> full BTF set against the vmlinux BTF before loading such a module into t=
he
>> kernel.
>>=20
>> Or am I missing some reason why that wouldn't work?
>
> One minor problem would be this is essentially introducing a new kernel
> module BTF format that uses exactly the same header.
>
> Ever since the introduction of split BTF, we're reusing btf_header but
> acting as if there's an extra hidden flag indicating whether the BTF is
> self-contained or partial. So far we could implicitly guess the value of =
the
> flag since BTF in vmlinux is always self-contained and BTF in kernel modu=
le
> is always partial; but if self-contained BTF on kernel module is introduc=
ed
> this will no longer be the case.
>
> Not sure if it'd be a issue in practice though, as we could go through the
> type info and see whether there's any type ID that is too large and cannot
> be found.

Yeah, one option could be to just discover it when parsing the BTF: if
it's not self-contained, assume it's referring to the vmlinux BTF and
act accordingly. As long as there is no risk of "false positives" where
the loader detects the wrong thing, but I don't think this detection
would add any failure cases that are not present already today?

Another option would be to but self-contained BTF in a different
section. Or we could amend the header as you say, but with what?

-Toke

