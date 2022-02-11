Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4450F4B2BA6
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 18:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351995AbiBKRUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 12:20:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243921AbiBKRUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 12:20:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14CAC95
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644600037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/XYxOnFvWmBDRRN9eJZCbsz4PFzMIS6mW4rnl0OwGOQ=;
        b=OaosaSdU3vJ9WNTGR50zDXyUT9TTp3rXlBoJiZ8CcQE5sJkQDgTzFy2uI/sAX5WHuZPHlV
        gIWCRAtem4BPpZcdrb21X0NKijtA5ZmoBK9vcdtk5II17pNadrC6WF8RGaU2R5wWWUs6/I
        fyfs9On+27VTWxTDXkYJEBBpZ2MuOLM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-9mw3cifINaSAq5dH3BmOnQ-1; Fri, 11 Feb 2022 12:20:36 -0500
X-MC-Unique: 9mw3cifINaSAq5dH3BmOnQ-1
Received: by mail-ej1-f70.google.com with SMTP id v2-20020a170906292200b006a94a27f903so4409498ejd.8
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:20:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/XYxOnFvWmBDRRN9eJZCbsz4PFzMIS6mW4rnl0OwGOQ=;
        b=2uYYlqubnKDvOHXHH5efrUcNEz/YMMPuSVx496o3A50yGCC/jaBAOsK53iX3YF28Rd
         J9exte6igg9DMx9AzwgYTjsGXpxq6+akchaD20lcnL11ivd4B8xpIipEHnoXdBuI7zRV
         Y7QwQTtMc1jNSnX9RD1B4zkOcbvplkJmBpFf6f3lREeneH7PlwTYgUcppX9i2a+hw2Sv
         uw7FMnal4pRz9S0pT48h/80gRPvtmwp2LBPt93zV9RiCEvuWPPB274uFRYuXwOpKZclW
         6G/XfBYU7ZUgUganjD4fC/emGh1+hXTIaFsyaYkMBVorqN5DVIX7NcUFmbKXgA6u0QLo
         2PeA==
X-Gm-Message-State: AOAM530yaWaAENDiVSBkhg3iOrV16LZjdtrq3yXRfwy0MG5IZ7DtAETp
        Km2v1vY/UQ608b4auVWptmYGecXWesDQD7Cn+gztEl6lfnQL+Y7Qc/7NH3Pj++tzZKDvCynYUb5
        QCUxmqUsLu17WIWKq
X-Received: by 2002:a17:907:6d93:: with SMTP id sb19mr2245844ejc.634.1644600034055;
        Fri, 11 Feb 2022 09:20:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy2aDAkzQMMZGknbEbqOfslhVJ3HUi+miJl4LbtRA1wHdBmcLzjsR/yXVQi1PnKJkwoLKYg5g==
X-Received: by 2002:a17:907:6d93:: with SMTP id sb19mr2245780ejc.634.1644600033033;
        Fri, 11 Feb 2022 09:20:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 27sm557023eji.66.2022.02.11.09.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 09:20:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7F5F8102D5F; Fri, 11 Feb 2022 18:20:31 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal =?utf-8?Q?Such?= =?utf-8?Q?=C3=A1nek?= 
        <msuchanek@suse.de>
Cc:     Yonghong Song <yhs@fb.com>, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: BTF compatibility issue across builds
In-Reply-To: <CAEf4BzZ6CrNGWt3DENvCBXpUKrvNiZwoK87rR75izP=CDf8YoQ@mail.gmail.com>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
 <CAEf4BzZ6CrNGWt3DENvCBXpUKrvNiZwoK87rR75izP=CDf8YoQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Feb 2022 18:20:31 +0100
Message-ID: <87a6ex8gm8.fsf@toke.dk>
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

> On Thu, Feb 10, 2022 at 2:01 AM Michal Such=C3=A1nek <msuchanek@suse.de> =
wrote:
>>
>> Hello,
>>
>> On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
>> >
>> >
>> > On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
>> > > Hi,
>> > >
>> > > We recently run into module load failure related to split BTF on ope=
nSUSE
>> > > Tumbleweed[1], which I believe is something that may also happen on =
other
>> > > rolling distros.
>> > >
>> > > The error looks like the follow (though failure is not limited to ip=
heth)
>> > >
>> > >      BPF:[103111] STRUCT BPF:size=3D152 vlen=3D2 BPF: BPF:Invalid na=
me BPF:
>> > >
>> > >      failed to validate module [ipheth] BTF: -22
>> > >
>> > > The error comes down to trying to load BTF of *kernel modules from a
>> > > different build* than the runtime kernel (but the source is the same=
), where
>> > > the base BTF of the two build is different.
>> > >
>> > > While it may be too far stretched to call this a bug, solving this m=
ight
>> > > make BTF adoption easier. I'd natively think that we could further s=
plit
>> > > base BTF into two part to avoid this issue, where .BTF only contain =
exported
>> > > types, and the other (still residing in vmlinux) holds the unexporte=
d types.
>> >
>> > What is the exported types? The types used by export symbols?
>> > This for sure will increase btf handling complexity.
>>
>> And it will not actually help.
>>
>> We have modversion ABI which checks the checksum of the symbols that the
>> module imports and fails the load if the checksum for these symbols does
>> not match. It's not concerned with symbols not exported, it's not
>> concerned with symbols not used by the module. This is something that is
>> sustainable across kernel rebuilds with minor fixes/features and what
>> distributions watch for.
>>
>> Now with BTF the situation is vastly different. There are at least three
>> bugs:
>>
>>  - The BTF check is global for all symbols, not for the symbols the
>>    module uses. This is not sustainable. Given the BTF is supposed to
>>    allow linking BPF programs that were built in completely different
>>    environment with the kernel it is completely within the scope of BTF
>>    to solve this problem, it's just neglected.
>
> You refer to BTF use in CO-RE with the latter. It's just one
> application of BTF and it doesn't follow that you can do the same with
> module BTF. It's not a neglect, it's a very big technical difficulty.
>
> Each module's BTFs are designed as logical extensions of vmlinux BTF.
> And each module BTF is independent and isolated from other modules
> extension of the same vmlinux BTF. The way that BTF format is
> designed, any tiny difference in vmlinux BTF effectively invalidates
> all modules' BTFs and they have to be rebuilt.
>
> Imagine that only one BTF type is added to vmlinux BTF. Last BTF type
> ID in vmlinux BTF is shifted from, say, 1000 to 1001. While previously
> every module's BTF type ID started with 1001, now they all have to
> start with 1002 and be shifted by 1.
>
> Now let's say that the order of two BTF types in vmlinux BTF is
> changed, say type 10 becomes type 20 and type 20 becomes type 10 (just
> because of slight difference in DWARF, for instance). Any type
> reference to 10 or 20 in any module BTF has to be renumbered now.
>
> Another one, let's say we add a new string to vmlinux BTF string
> section somewhere at the beginning, say "abc" at offset 100. Any
> string offset after 100 now has to be shifted *both* in vmlinux BTF
> and all module BTFs. And also any string reference in module BTFs have
> to be adjusted as well because now each module's BTF's logical string
> offset is starting at 4 logical bytes higher (due to "abc\0" being
> added and shifting everything right).
>
> As you can see, any tiny change in vmlinux BTF, no matter where,
> beginning, middle, or end, causes massive changes in type IDs and
> offsets everywhere. It's impractical to do any local adjustments, it's
> much simpler and more reliable to completely regenerate BTF
> completely.

This seems incredibly brittle, though? IIUC this means that if you want
BTF in your modules you *must* have not only the kernel headers of the
kernel it's going to run on, but the full BTF information for the exact
kernel image you're going to load that module on? How is that supposed
to work for any kind of environment where everything is not built
together? Third-party modules for distribution kernels is the obvious
example that comes to mind here, but as this thread shows, they don't
necessarily even have to be third party...

How would you go about "completely regenerating BTF" in practice for a
third-party module, say?

-Toke

