Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0C34B3194
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 00:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354290AbiBKX7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 18:59:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347596AbiBKX7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 18:59:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AE32D62
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 15:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644623938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i9jA+96/Jprj8bAz/BjNKVCdwJgPgeH8b3zEaKMPpYE=;
        b=QTUTNWnKixkpDEpgR1ziVsXdNh7OLuNVvLYy/s/uBrdt8slPSD5cgK+fYDHUDFy8/ayzsw
        rjQyu7IIVlfKm6JsKLHslRVpnZ83ijD2DD4WsvRjVeUib0pBS5IHff+dZP8JTtarBv0tBV
        QOayDgfCli1gnj96OtcYTk1VmOIzxS8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-d-6MZeewO7eIXDh8q9cE-g-1; Fri, 11 Feb 2022 18:58:57 -0500
X-MC-Unique: d-6MZeewO7eIXDh8q9cE-g-1
Received: by mail-ed1-f71.google.com with SMTP id b26-20020a056402139a00b004094fddbbdfso6285403edv.12
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 15:58:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=i9jA+96/Jprj8bAz/BjNKVCdwJgPgeH8b3zEaKMPpYE=;
        b=591XKtYBR2FZfb4Cluz/l6Lts21p/BhpWODcA+XXS4GIPj+nBo1mNWQxjkItlQcGvp
         hVrHImDN4RsRc29vA+3G58DgDtdeIHjf2XOBVUg+bZu/LuJLsKIRDv4m7AU6cIPwIicl
         ps1eXzk3chBNSBC1LwjngYU0pH3oQT1PzGoFa+611NqsEfo67g3EwU6JNYCMh6KmtK0S
         YkwbH1NU9D09f5cka/P4wC91C00KDbUczBXe2DhzigJLWEr/KsVVpS1+DKguCYqxVtbz
         vCSlZKrWOcZ9kuOCW8RE6KYQaiA/TbcqUA3YK2v1sQl3HX7Odsvp6BfXpOLT3rh46hYn
         gjdA==
X-Gm-Message-State: AOAM532WnhvIxdS+rYRmPs2ncXk1qSJsNiwA+4afzaeRxM4R2AzfcpBV
        u51CHCbdX3KhOMz5q7UECwJz0HQkJ7soDZyyVwPBiX3jhvyZEj7k0k+kjVzI67KmQJL8/qvq9pH
        P2S3s5MTvWBmxyrHf
X-Received: by 2002:a05:6402:490:: with SMTP id k16mr4400482edv.204.1644623934903;
        Fri, 11 Feb 2022 15:58:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxxdoPzAxwGhzRv/W37UgGSGb7H6JE3CKofQSeEsHRYqdHiBu2ZsRGlgxcQPDeVnnwzn7SAaQ==
X-Received: by 2002:a05:6402:490:: with SMTP id k16mr4400400edv.204.1644623933217;
        Fri, 11 Feb 2022 15:58:53 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l7sm11349032edb.53.2022.02.11.15.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 15:58:52 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F05DA102E52; Sat, 12 Feb 2022 00:58:51 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Michal =?utf-8?Q?Such=C3=A1nek?= <msuchanek@suse.de>,
        Yonghong Song <yhs@fb.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: BTF compatibility issue across builds
In-Reply-To: <CAEf4BzYJCHB-oYqFqJTfHU4D795ewgkndQtR1Po5H521fH0oMg@mail.gmail.com>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
 <CAEf4BzZ6CrNGWt3DENvCBXpUKrvNiZwoK87rR75izP=CDf8YoQ@mail.gmail.com>
 <87a6ex8gm8.fsf@toke.dk>
 <CAEf4BzYJCHB-oYqFqJTfHU4D795ewgkndQtR1Po5H521fH0oMg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 12 Feb 2022 00:58:51 +0100
Message-ID: <87v8xl6jlw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Feb 11, 2022 at 9:20 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Thu, Feb 10, 2022 at 2:01 AM Michal Such=C3=A1nek <msuchanek@suse.d=
e> wrote:
>> >>
>> >> Hello,
>> >>
>> >> On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
>> >> >
>> >> >
>> >> > On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
>> >> > > Hi,
>> >> > >
>> >> > > We recently run into module load failure related to split BTF on =
openSUSE
>> >> > > Tumbleweed[1], which I believe is something that may also happen =
on other
>> >> > > rolling distros.
>> >> > >
>> >> > > The error looks like the follow (though failure is not limited to=
 ipheth)
>> >> > >
>> >> > >      BPF:[103111] STRUCT BPF:size=3D152 vlen=3D2 BPF: BPF:Invalid=
 name BPF:
>> >> > >
>> >> > >      failed to validate module [ipheth] BTF: -22
>> >> > >
>> >> > > The error comes down to trying to load BTF of *kernel modules fro=
m a
>> >> > > different build* than the runtime kernel (but the source is the s=
ame), where
>> >> > > the base BTF of the two build is different.
>> >> > >
>> >> > > While it may be too far stretched to call this a bug, solving thi=
s might
>> >> > > make BTF adoption easier. I'd natively think that we could furthe=
r split
>> >> > > base BTF into two part to avoid this issue, where .BTF only conta=
in exported
>> >> > > types, and the other (still residing in vmlinux) holds the unexpo=
rted types.
>> >> >
>> >> > What is the exported types? The types used by export symbols?
>> >> > This for sure will increase btf handling complexity.
>> >>
>> >> And it will not actually help.
>> >>
>> >> We have modversion ABI which checks the checksum of the symbols that =
the
>> >> module imports and fails the load if the checksum for these symbols d=
oes
>> >> not match. It's not concerned with symbols not exported, it's not
>> >> concerned with symbols not used by the module. This is something that=
 is
>> >> sustainable across kernel rebuilds with minor fixes/features and what
>> >> distributions watch for.
>> >>
>> >> Now with BTF the situation is vastly different. There are at least th=
ree
>> >> bugs:
>> >>
>> >>  - The BTF check is global for all symbols, not for the symbols the
>> >>    module uses. This is not sustainable. Given the BTF is supposed to
>> >>    allow linking BPF programs that were built in completely different
>> >>    environment with the kernel it is completely within the scope of B=
TF
>> >>    to solve this problem, it's just neglected.
>> >
>> > You refer to BTF use in CO-RE with the latter. It's just one
>> > application of BTF and it doesn't follow that you can do the same with
>> > module BTF. It's not a neglect, it's a very big technical difficulty.
>> >
>> > Each module's BTFs are designed as logical extensions of vmlinux BTF.
>> > And each module BTF is independent and isolated from other modules
>> > extension of the same vmlinux BTF. The way that BTF format is
>> > designed, any tiny difference in vmlinux BTF effectively invalidates
>> > all modules' BTFs and they have to be rebuilt.
>> >
>> > Imagine that only one BTF type is added to vmlinux BTF. Last BTF type
>> > ID in vmlinux BTF is shifted from, say, 1000 to 1001. While previously
>> > every module's BTF type ID started with 1001, now they all have to
>> > start with 1002 and be shifted by 1.
>> >
>> > Now let's say that the order of two BTF types in vmlinux BTF is
>> > changed, say type 10 becomes type 20 and type 20 becomes type 10 (just
>> > because of slight difference in DWARF, for instance). Any type
>> > reference to 10 or 20 in any module BTF has to be renumbered now.
>> >
>> > Another one, let's say we add a new string to vmlinux BTF string
>> > section somewhere at the beginning, say "abc" at offset 100. Any
>> > string offset after 100 now has to be shifted *both* in vmlinux BTF
>> > and all module BTFs. And also any string reference in module BTFs have
>> > to be adjusted as well because now each module's BTF's logical string
>> > offset is starting at 4 logical bytes higher (due to "abc\0" being
>> > added and shifting everything right).
>> >
>> > As you can see, any tiny change in vmlinux BTF, no matter where,
>> > beginning, middle, or end, causes massive changes in type IDs and
>> > offsets everywhere. It's impractical to do any local adjustments, it's
>> > much simpler and more reliable to completely regenerate BTF
>> > completely.
>>
>> This seems incredibly brittle, though? IIUC this means that if you want
>> BTF in your modules you *must* have not only the kernel headers of the
>> kernel it's going to run on, but the full BTF information for the exact
>
> From BTF perspective, only vmlinux BTF. Having exact kernel headers
> would minimize type information duplication.

Right, I meant you'd need the kernel headers to compile the module, and
the vmlinux BTF to build the module BTF info.

>> kernel image you're going to load that module on? How is that supposed
>> to work for any kind of environment where everything is not built
>> together? Third-party modules for distribution kernels is the obvious
>> example that comes to mind here, but as this thread shows, they don't
>> necessarily even have to be third party...
>>
>> How would you go about "completely regenerating BTF" in practice for a
>> third-party module, say?
>
> Great questions. I was kind of hoping you'll have some suggestions as
> well, though. Not just complaints.

Well, I kinda took your "not really a bug either" comment to mean you
weren't really open to changing the current behaviour. But if that was a
misunderstanding on my part, I do have one thought:

The "partial BTF" thing in the modules is done to save space, right?
I.e., in principle there would be nothing preventing a module from
including a full (self-contained) set of BTF in its .ko when it is
compiled? Because if so, we could allow that as an optional mode that
can be enabled if you don't mind taking the size hit (any idea how large
that usually is, BTW?). And then we could teach 'modprobe' to do a fresh
deduplication of this full BTF set against the vmlinux BTF before
loading such a module into the kernel.

Or am I missing some reason why that wouldn't work?

-Toke

