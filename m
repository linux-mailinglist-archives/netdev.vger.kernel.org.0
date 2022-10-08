Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAF45F8508
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 13:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiJHLjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 07:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiJHLjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 07:39:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5860E4CA22
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 04:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665229142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Lj7mfu9WoCvUvg2WluRtFFFaquziqpdBQujzD6fBSc=;
        b=OC0auufATCvvbGis2lLifvwY5aDBwyGQ8wdlnIEFOMyRkQtBqmWOTq6Hs6WH790Zz1iREB
        5kqDI604WbBF0QFZpNHDGMw1VFCrwFuGZLHN9XBbxgeYAwlp/KY9Z8vXs2Qee5IF0vONB5
        9hDwet15IIrE2bx1LHQE47QQRZd00Wg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-627-sJ-16Z38PwOq23IPN3P5MQ-1; Sat, 08 Oct 2022 07:39:01 -0400
X-MC-Unique: sJ-16Z38PwOq23IPN3P5MQ-1
Received: by mail-ed1-f69.google.com with SMTP id f18-20020a056402355200b0045115517911so5655389edd.14
        for <netdev@vger.kernel.org>; Sat, 08 Oct 2022 04:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Lj7mfu9WoCvUvg2WluRtFFFaquziqpdBQujzD6fBSc=;
        b=fbH2o7auT8o/I+eeTX8GmDWdsNvS7ZrJA6uRCwp1pX/LDIdUlq0G6DBDbzkUzB8IAr
         gjAQQVR8iw+i2CrchhwntX0oysyps5A3EbQXkm/K0S5IfWk1L4Vt4pW0ZcajbwKrK0hk
         x5UDc/VsKGy+X+zcEMdnVtIKOdG4JKca45ZKCyBLCmLMF4rE1vaL3lbDcKJC/lXweGeF
         elrg4PclXUTeir+pknTvijZ4lHJw2RBtCv9y0QuKw7+AkeZBFvDW3HAmnO5IdDhm0u29
         ksgLGf2x8x6nmfG7bgbbvCOyRh/DMsgpqE8XOUG6OK/PwRLZCes77w9x4eLwncO7SjJE
         ifQg==
X-Gm-Message-State: ACrzQf0eT6Kqq2GnLPcc43TL3wTnAgkFxRs5+4bBVqWjCdHy3i01BUNx
        CLL5SzO6DZ39AJuu2r3RNdFLDWd6cAf8u2K2bbgCYmGV6iddXXFJrhYWbQIcNwaXsvosnHGtqRA
        crOLKoJZJPj+YRrie
X-Received: by 2002:a17:907:7b94:b0:731:1b11:c241 with SMTP id ne20-20020a1709077b9400b007311b11c241mr7784337ejc.676.1665229137430;
        Sat, 08 Oct 2022 04:38:57 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5piSQ6FSRP7rJHbUqDHTZbDXLGTfj03VpyaOLE57kNaM8/3eiVgY/morhn3dVUeJTbDWltIA==
X-Received: by 2002:a17:907:7b94:b0:731:1b11:c241 with SMTP id ne20-20020a1709077b9400b007311b11c241mr7784300ejc.676.1665229136473;
        Sat, 08 Oct 2022 04:38:56 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 23-20020a170906311700b00780a26edfcesm2638074ejx.60.2022.10.08.04.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Oct 2022 04:38:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B32FF68277F; Sat,  8 Oct 2022 13:38:54 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joe Stringer <joe@cilium.io>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach
 tc BPF programs
In-Reply-To: <CAADnVQLpcLWrL-URhRgqCQa6XRZzib4BorZ2QKpPC+Uw_JNW=Q@mail.gmail.com>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net>
 <20221006050053.pbwo72xtzoza6gfl@macbook-pro-4.dhcp.thefacebook.com>
 <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net>
 <CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com>
 <14f368eb-9158-68bc-956c-c8371cfcb531@iogearbox.net>
 <875ygvemau.fsf@toke.dk> <Y0BaBUWeTj18V5Xp@google.com>
 <87tu4fczyv.fsf@toke.dk>
 <CAADnVQLH9R94iszCmhYeLKnDPy_uiGeyXnEwoADm8_miihwTmQ@mail.gmail.com>
 <8cc9811e-6efe-3aa5-b201-abbd4b10ceb4@iogearbox.net>
 <CAADnVQLpcLWrL-URhRgqCQa6XRZzib4BorZ2QKpPC+Uw_JNW=Q@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 08 Oct 2022 13:38:54 +0200
Message-ID: <87sfjysfxt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Oct 7, 2022 at 12:37 PM Daniel Borkmann <daniel@iogearbox.net> wr=
ote:
>>
>> On 10/7/22 8:59 PM, Alexei Starovoitov wrote:
>> > On Fri, Oct 7, 2022 at 10:20 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> [...]
>> >>>> I was thinking a little about how this might work; i.e., how can the
>> >>>> kernel expose the required knobs to allow a system policy to be
>> >>>> implemented without program loading having to talk to anything other
>> >>>> than the syscall API?
>> >>>
>> >>>> How about we only expose prepend/append in the prog attach UAPI, and
>> >>>> then have a kernel function that does the sorting like:
>> >>>
>> >>>> int bpf_add_new_tcx_prog(struct bpf_prog *progs, size_t num_progs, =
struct
>> >>>> bpf_prog *new_prog, bool append)
>> >>>
>> >>>> where the default implementation just appends/prepends to the array=
 in
>> >>>> progs depending on the value of 'appen'.
>> >>>
>> >>>> And then use the __weak linking trick (or maybe struct_ops with a m=
ember
>> >>>> for TXC, another for XDP, etc?) to allow BPF to override the functi=
on
>> >>>> wholesale and implement whatever ordering it wants? I.e., allow it =
can
>> >>>> to just shift around the order of progs in the 'progs' array whenev=
er a
>> >>>> program is loaded/unloaded?
>> >>>
>> >>>> This way, a userspace daemon can implement any policy it wants by j=
ust
>> >>>> attaching to that hook, and keeping things like how to express
>> >>>> dependencies as a userspace concern?
>> >>>
>> >>> What if we do the above, but instead of simple global 'attach first/=
last',
>> >>> the default api would be:
>> >>>
>> >>> - attach before <target_fd>
>> >>> - attach after <target_fd>
>> >>> - attach before target_fd=3D-1 =3D=3D first
>> >>> - attach after target_fd=3D-1 =3D=3D last
>> >>>
>> >>> ?
>> >>
>> >> Hmm, the problem with that is that applications don't generally have =
an
>> >> fd to another application's BPF programs; and obtaining them from an =
ID
>> >> is a privileged operation (CAP_SYS_ADMIN). We could have it be "attach
>> >> before target *ID*" instead, which could work I guess? But then the
>> >> problem becomes that it's racy: the ID you're targeting could get
>> >> detached before you attach, so you'll need to be prepared to check th=
at
>> >> and retry; and I'm almost certain that applications won't test for th=
is,
>> >> so it'll just lead to hard-to-debug heisenbugs. Or am I being too
>> >> pessimistic here?
>> >
>> > I like Stan's proposal and don't see any issue with FD.
>> > It's good to gate specific sequencing with cap_sys_admin.
>> > Also for consistency the FD is better than ID.
>> >
>> > I also like systemd analogy with Before=3D, After=3D.
>> > systemd has a ton more ways to specify deps between Units,
>> > but none of them have absolute numbers (which is what priority is).
>> > The only bit I'd tweak in Stan's proposal is:
>> > - attach before <target_fd>
>> > - attach after <target_fd>
>> > - attach before target_fd=3D0 =3D=3D first
>> > - attach after target_fd=3D0 =3D=3D last
>>
>> I think the before(), after() could work, but the target_fd I have my do=
ubts
>> that it will be practical. Maybe lets walk through a concrete real examp=
le. app_a
>> and app_b shipped via container_a resp container_b. Both want to install=
 tc BPF
>> and we (operator/user) want to say that prog from app_b should only be i=
nserted
>> after the one from app_a, never run before; if no prog_a is installed, w=
e ofc just
>> run prog_b, but if prog_a is inserted, it must be before prog_b given th=
e latter
>> can only run after the former. How would we get to one anothers target f=
d? One
>> could use the 0, but not if more programs sit before/after.
>
> I read your desired use case several times and probably still didn't get =
it.
> Sounds like prog_b can just do after(fd=3D0) to become last.
> And prog_a can do before(fd=3D0).
> Whichever the order of attaching (a or b) these two will always
> be in a->b order.

I agree that it's probably not feasible to have programs themselves
coordinate between themselves except for "install me last/first" type
semantics.

I.e., the "before/after target_fd" is useful for a single application
that wants to install two programs in a certain order. Or for bpftool
for manual/debugging work.

System-wide policy (which includes "two containers both using BPF") is
going to need some kind of policy agent/daemon anyway. And the in-kernel
function override is the only feasible way to do that.

> Since the first and any prog returning !TC_NEXT will abort
> the chain we'd need __weak nop orchestrator prog to interpret
> retval for anything to be useful.

If we also want the orchestrator to interpret return codes, that
probably implies generating a BPF program that does the dispatching,
right? (since the attachment is per-interface we can't reuse the same
one). So maybe we do need to go the route of the (overridable) usermode
helper that gets all the program FDs and generates a BPF dispatcher
program? Or can we do this with a __weak function that emits bytecode
inside the kernel without being unsafe?

Anyway, I'm OK with deferring the orchestrator mechanism and going with
Stanislav's proposal as an initial API.

-Toke

