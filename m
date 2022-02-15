Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7914B777C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243312AbiBOS6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 13:58:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240892AbiBOS6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 13:58:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71A80B1A86
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 10:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644951479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4NN/PLxgYA4HlzU34uDVXrX6PaTPClCNOKsQOBycxaM=;
        b=dvISCY2ZPNoQVqOxtLD2x3qEBv5bz4YKPdwfQ5Pv03NBbTENLeIyDmpcSfjRZh6fkQkpq6
        0GSJ5J2j9Ciruz3p81Uwzx5pi6wpJtl+ks0jQe5ToV9wPQNpC7nybzyaxEfGYXYF1BWXUT
        T0s6j8aIJTNNWnkxl9gIyU0ESpmedG4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-ShI5FWoWOGiD6sXYSn6xdg-1; Tue, 15 Feb 2022 13:57:58 -0500
X-MC-Unique: ShI5FWoWOGiD6sXYSn6xdg-1
Received: by mail-ed1-f69.google.com with SMTP id e10-20020a056402190a00b00410f20467abso365129edz.14
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 10:57:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=4NN/PLxgYA4HlzU34uDVXrX6PaTPClCNOKsQOBycxaM=;
        b=oK+2hLVVCOZiuJjOQGXfqV5OWRITcPS3lvOi14AZag6AekgybpN6m+9CUF6t2q0csd
         Ps/ZOX/GKz+uODLw0fBq9buYqKd6PPdyguKpc5XzfXSRD4m+HFGcpVSwIyl5hsJ7Xvfn
         +hIBJGHNauMHWdH8WPTNPxSHk0irUbxsYGADDdjsxUoNiN40ROIZGNdIbGTJyKYTEs4y
         A9VEAX/iWxt2R7x2JtQGGcb8f/qXQqmUZOdeQGCfrZslO9agy6yfyJxrskfNqgSN9FCB
         nC53zYSM1LRF7hSGDB44/80b9V9LbchtLnVla1z0U15SyQZd2NkAM6edqdJpM6fiH8gs
         h+rA==
X-Gm-Message-State: AOAM531RC2tw6072GXTlHActDY5J1YmcbuNUVKwa3GmeOn3MCeB3IMBk
        QBelD/t7qD1aBbkj0phjQuMWZ3vQ3aAUdeRx0gzZzANkMy9DvFMhG1j5iQ2Y+N2VYsbD3D2p0Gh
        6/jSMvQ/NBcp+JFA4
X-Received: by 2002:a05:6402:d0d:: with SMTP id eb13mr325606edb.83.1644951476964;
        Tue, 15 Feb 2022 10:57:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfoYVBtG846aw1+FuncHNy7nmD8h9kbvqmckfT1MVerVU2dxaG0afItFUFBFKeJqSDRKSAGw==
X-Received: by 2002:a05:6402:d0d:: with SMTP id eb13mr325576edb.83.1644951476513;
        Tue, 15 Feb 2022 10:57:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q4sm11989015ejb.109.2022.02.15.10.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 10:57:55 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 034C912E4C4; Tue, 15 Feb 2022 19:57:54 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Yonghong Song <yhs@fb.com>, Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Connor O'Brien <connoro@google.com>,
        Michal =?utf-8?Q?Such=C3=A1nek?= <msuchanek@suse.de>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: BTF compatibility issue across builds
In-Reply-To: <0867c12a-9aa3-418d-9102-3103cb784e99@fb.com>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
 <bb445e64-de50-e287-1acc-abfec4568775@fb.com>
 <CAADnVQJ+OVPnBz8z3vNu8gKXX42jCUqfuvhWAyCQDu8N_yqqwQ@mail.gmail.com>
 <992ae1d2-0b26-3417-9c6b-132c8fcca0ad@fb.com>
 <YgdIWvNsc0254yiv@syu-laptop.lan>
 <8a520fa1-9a61-c21d-f2c4-d5ba8d1b9c19@fb.com>
 <YgwBN8WeJvZ597/j@syu-laptop>
 <0867c12a-9aa3-418d-9102-3103cb784e99@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 15 Feb 2022 19:57:54 +0100
Message-ID: <87h7905559.fsf@toke.dk>
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

Yonghong Song <yhs@fb.com> writes:

> On 2/15/22 11:38 AM, Shung-Hsi Yu wrote:
>> On Fri, Feb 11, 2022 at 10:36:28PM -0800, Yonghong Song wrote:
>>> On 2/11/22 9:40 PM, Shung-Hsi Yu wrote:
>>>> On Thu, Feb 10, 2022 at 02:59:03PM -0800, Yonghong Song wrote:
>>>>> On 2/10/22 2:34 PM, Alexei Starovoitov wrote:
>>>>>> On Thu, Feb 10, 2022 at 10:17 AM Yonghong Song <yhs@fb.com> wrote:
>>>>>>> On 2/10/22 2:01 AM, Michal Such=C3=A1nek wrote:
>>>>>>>> On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
>>>>>>>>> On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> We recently run into module load failure related to split BTF on=
 openSUSE
>>>>>>>>>> Tumbleweed[1], which I believe is something that may also happen=
 on other
>>>>>>>>>> rolling distros.
>>>>>>>>>>
>>>>>>>>>> The error looks like the follow (though failure is not limited t=
o ipheth)
>>>>>>>>>>
>>>>>>>>>>          BPF:[103111] STRUCT BPF:size=3D152 vlen=3D2 BPF: BPF:In=
valid name BPF:
>>>>>>>>>>
>>>>>>>>>>          failed to validate module [ipheth] BTF: -22
>>>>>>>>>>
>>>>>>>>>> The error comes down to trying to load BTF of *kernel modules fr=
om a
>>>>>>>>>> different build* than the runtime kernel (but the source is the =
same), where
>>>>>>>>>> the base BTF of the two build is different.
>>>>>>>>>>
>>>>>>>>>> While it may be too far stretched to call this a bug, solving th=
is might
>>>>>>>>>> make BTF adoption easier. I'd natively think that we could furth=
er split
>>>>>>>>>> base BTF into two part to avoid this issue, where .BTF only cont=
ain exported
>>>>>>>>>> types, and the other (still residing in vmlinux) holds the unexp=
orted types.
>>>>>>>>>
>>>>>>>>> What is the exported types? The types used by export symbols?
>>>>>>>>> This for sure will increase btf handling complexity.
>>>>>>>>
>>>>>>>> And it will not actually help.
>>>>>>>>
>>>>>>>> We have modversion ABI which checks the checksum of the symbols th=
at the
>>>>>>>> module imports and fails the load if the checksum for these symbol=
s does
>>>>>>>> not match. It's not concerned with symbols not exported, it's not
>>>>>>>> concerned with symbols not used by the module. This is something t=
hat is
>>>>>>>> sustainable across kernel rebuilds with minor fixes/features and w=
hat
>>>>>>>> distributions watch for.
>>>>>>>>
>>>>>>>> Now with BTF the situation is vastly different. There are at least=
 three
>>>>>>>> bugs:
>>>>>>>>
>>>>>>>>      - The BTF check is global for all symbols, not for the symbol=
s the
>>>>>>>>        module uses. This is not sustainable. Given the BTF is supp=
osed to
>>>>>>>>        allow linking BPF programs that were built in completely di=
fferent
>>>>>>>>        environment with the kernel it is completely within the sco=
pe of BTF
>>>>>>>>        to solve this problem, it's just neglected.
>>>>>>>>      - It is possible to load modules with no BTF but not modules =
with
>>>>>>>>        non-matching BTF. Surely the non-matching BTF could be disc=
arded.
>>>>>>>>      - BTF is part of vermagic. This is completely pointless since=
 modules
>>>>>>>>        without BTF can be loaded on BTF kernel. Surely it would no=
t be too
>>>>>>>>        difficult to do the reverse as well. Given BTF must pass ex=
tra check
>>>>>>>>        to be used having it in vermagic is just useless moise.
>>>>>>>>
>>>>>>>>>> Does that sound like something reasonable to work on?
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> ## Root case (in case anyone is interested in a verbose version)
>>>>>>>>>>
>>>>>>>>>> On openSUSE Tumbleweed there can be several builds of the same s=
ource. Since
>>>>>>>>>> the source is the same, the binaries are simply replaced when a =
package with
>>>>>>>>>> a larger build number is installed during upgrade.
>>>>>>>>>>
>>>>>>>>>> In our case, a rebuild is triggered[2], and resulted in changes =
in base BTF.
>>>>>>>>>> More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_check_pe=
c(u8 cpec,
>>>>>>>>>> struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_hashi=
nfo *h,
>>>>>>>>>> struct sock *sk) was added to the base BTF of 5.15.12-1.3. Those=
 functions
>>>>>>>>>> are previously missing in base BTF of 5.15.12-1.1.
>>>>>>>>>
>>>>>>>>> As stated in [2] below, I think we should understand why rebuild =
is
>>>>>>>>> triggered. If the rebuild for vmlinux is triggered, why the modul=
es cannot
>>>>>>>>> be rebuild at the same time?
>>>>>>>>
>>>>>>>> They do get rebuilt. However, if you are running the kernel and in=
stall
>>>>>>>> the update you get the new modules with the old kernel. If the ins=
tall
>>>>>>>> script fails to copy the kernel to your EFI partition based on the=
 fact
>>>>>>>> a kernel with the same filename is alreasy there you get the same.
>>>>>>>>
>>>>>>>> If you have 'stable' distribution adding new symbols is normal and=
 it
>>>>>>>> does not break module loading without BTF but it breaks BTF.
>>>>>>>
>>>>>>> Okay, I see. One possible solution is that if kernel module btf
>>>>>>> does not match vmlinux btf, the kernel module btf will be ignored
>>>>>>> with a dmesg warning but kernel module load will proceed as normal.
>>>>>>> I think this might be also useful for bpf lskel kernel modules as
>>>>>>> well which tries to be portable (with CO-RE) for different kernels.
>>>>>>
>>>>>> That sounds like #2 that Michal is proposing:
>>>>>> "It is possible to load modules with no BTF but not modules with
>>>>>>     non-matching BTF. Surely the non-matching BTF could be discarded=
."
>>>>
>>>> Since we're talking about matching check, I'd like bring up another is=
sue.
>>>>
>>>> AFAICT with current form of BTF, checking whether BTF on kernel module
>>>> matches cannot be made entirely robust without a new version of btf_he=
ader
>>>> that contain info about the base BTF.
>>>
>>> The base BTF is always the one associated with running kernel and typic=
ally
>>> the BTF is under /sys/kernel/btf/vmlinux. Did I miss
>>> anything here?
>>>
>>>> As effective as the checks are in this case, by detecting a type name =
being
>>>> an empty string and thus conclude it's non-matching, with some (bad) l=
uck a
>>>> non-matching BTF could pass these checks a gets loaded.
>>>
>>> Could you be a little bit more specific about the 'bad luck' a
>>> non-matching BTF could get loaded? An example will be great.
>>=20
>> Let me try take a jab at it. Say here's a hypothetical BTF for a kernel
>> module which only type information for `struct something *`:
>>=20
>>    [5] PTR '(anon)' type_id=3D4
>>=20
>> Which is built upon the follow base BTF:
>>=20
>>    [1] INT 'unsigned char' size=3D1 bits_offset=3D0 nr_bits=3D8 encoding=
=3D(none)
>>    [2] PTR '(anon)' type_id=3D3
>>    [3] STRUCT 'list_head' size=3D16 vlen=3D2
>>          'next' type_id=3D2 bits_offset=3D0
>>          'prev' type_id=3D2 bits_offset=3D64
>>    [4] STRUCT 'something' size=3D2 vlen=3D2
>>          'locked' type_id=3D1 bits_offset=3D0
>>          'pending' type_id=3D1 bits_offset=3D8
>>=20
>> Due to the situation mentioned in the beginning of the thread, the *runt=
ime*
>> kernel have a different base BTF, in this case type IDs are offset by 1 =
due
>> to an additional typedef entry:
>>=20
>>    [1] TYPEDEF 'u8' type_id=3D1
>>    [2] INT 'unsigned char' size=3D1 bits_offset=3D0 nr_bits=3D8 encoding=
=3D(none)
>>    [3] PTR '(anon)' type_id=3D3
>>    [4] STRUCT 'list_head' size=3D16 vlen=3D2
>>          'next' type_id=3D2 bits_offset=3D0
>>          'prev' type_id=3D2 bits_offset=3D64
>>    [5] STRUCT 'something' size=3D2 vlen=3D2
>>          'locked' type_id=3D1 bits_offset=3D0
>>          'pending' type_id=3D1 bits_offset=3D8
>>=20
>> Then when loading the BTF on kernel module on the runtime, the kernel wi=
ll
>> mistakenly interprets "PTR '(anon)' type_id=3D4" as `struct list_head *`
>> rather than `struct something *`.
>>=20
>> Does this should possible? (at least theoretically)
>
> Thanks for explanation. Yes, from BTF type resolution point of view,
> yes it is possible.

Could we add a marker or something to prevent this from happening?
Something like putting the hash of the entire BTF structure into the
header and referring to that from the "child"; or really any other way
of detecting that the combined BTF you're constructing is going to be
wrong?

-Toke

