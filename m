Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71462688ADD
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 00:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjBBXem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 18:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbjBBXek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 18:34:40 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5C4123
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 15:34:39 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id gr7so10733668ejb.5
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 15:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z4q9xrprj5sfZQAA9ynRhR4bt9VZSqLQHD25hdnloeo=;
        b=i6FnSKfRwCl3MDk7Lmd3pNRurz4rk2w7bo+XVTXZCHZPpqb8jqvK0Gcr0MsorYuVSi
         SQgqdWo2mAkwXPoa7dnzcYeo9+oT75houh+vVz4zQVJrwfaroii2SNRnRhxdCZfatUhT
         DLgn3vo7yjrpHlr8VmO1Ixa8+9S5Pvy5+xoaSVLm27hHlnNVryBVXjkQWLeEZkO6MDqs
         UtlhuEzZkqJthrRNZnVz2vTr78dkp15FKuqF+1xBcltSOMPEilUwd9zcDdeleP+83Qbb
         +8Py6XfKNZnAKxW5CFvRJys/X8hIwIrG/KK0d9omH+QdVVU8XrBXPOjm+yC9WOhoIUQG
         ZEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z4q9xrprj5sfZQAA9ynRhR4bt9VZSqLQHD25hdnloeo=;
        b=1L29wM2m8rFUrmtkFmgbdmDxSSXAH7nU1dTcxYkFZmu0FjtHIC3dAas6dgKbCTPzv0
         p/qTeSM7N5jtncNTl4IHhOQDYtcwnRFLAnRcA+dJ1wnRzLuH7trZ6lrTdUP/ANTUFjyb
         jEOAImWZK03a3sTTUk3MHyEmn0sOFaKyy7lgIR3ZVir23FiOUZ0CT5XBFk7AcvjX9x40
         tzTOkc72iM8EXNwoUo8QEeJCKkSwOe3hoDy56eGpk7XP2dmwLUpiDvQcPf8AQ22yI37L
         l9AGkE8YEJVbsFpxTz5BwXMoU1Tkq923g4aydzLwBYC7QPbsgWj3Lr+wiomAC+u8c1Eq
         NZuQ==
X-Gm-Message-State: AO0yUKW2sWW+cB+bEBL4i/S0yu5N3thN4zgav2ParILFz/gKvIK0zNs1
        c8IvNC7M+gcsCg2d01G6PIkCddZn5EJFS55Gr+QkDg==
X-Google-Smtp-Source: AK7set/htwu4FL+zX6LXsWHi9TuV06z2b9HCx+owU5EooMZyQujva6NvIy8ICXsSFVgVeCxcQuXd3xMSC0iM7KCYYHk=
X-Received: by 2002:a17:906:c1c8:b0:78d:b819:e0e7 with SMTP id
 bw8-20020a170906c1c800b0078db819e0e7mr2162407ejb.83.1675380877860; Thu, 02
 Feb 2023 15:34:37 -0800 (PST)
MIME-Version: 1.0
References: <Y9eYNsklxkm8CkyP@nanopsycho> <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk> <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk> <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <87h6w6vqyd.fsf@toke.dk> <Y9kn6bh8z11xWsDh@nanopsycho> <87357qvdso.fsf@toke.dk>
 <CAM0EoMmx9U5TN6+Lb4sKPhR2PLN_vptVQMBzc0EtoSa6W-hsZA@mail.gmail.com>
 <87o7qe2u4c.fsf@toke.dk> <CAM0EoM=qeA1zO-FZNjppzc9V7i3dScCT5rFXbqL=ERcnCuZxfA@mail.gmail.com>
 <87r0v91cns.fsf@toke.dk> <CAM0EoMnaQBwnV6e=DU-xY1OowY9-znxp0SXhqnNW0xz+2R5DNw@mail.gmail.com>
In-Reply-To: <CAM0EoMnaQBwnV6e=DU-xY1OowY9-znxp0SXhqnNW0xz+2R5DNw@mail.gmail.com>
From:   Tom Herbert <tom@sipanda.io>
Date:   Thu, 2 Feb 2023 15:34:26 -0800
Message-ID: <CAOuuhY9Xy_FThzG3unN_YJx0i2guJnYmTf1qP21m0iTjzz814A@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, pratyush@sipanda.io, xiyou.wangcong@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com, stefanc@marvell.com,
        seong.kim@amd.com, mattyk@nvidia.com, dan.daly@intel.com,
        john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 2, 2023 at 10:51 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> Sorry I was distracted somewhere else.
> I am not sure i fully grokked your proposal but I am willing to go
> through this thought exercise with you (perhaps a higher bandwidth
> media would help); however,  we should put some parameters so it
> doesnt become a perpetual discussion:
>
> The starting premise is that posted code meets our requirements so
> whatever we do using ebpf has to meet our requirements; we dont want
> to get into a wrestling match with any of the ebpf constraints.
> Actually, I am ok with some limited degree of square hole round peg
> situation but it cant be interfering in getting work done. I would
> also be ok with small surgeries into the ebpf core if needed to meet
> our requirements.

Can you elaborate on what the problems are with using eBPF? I know
there is at least one P4->eBPF compiler, what is lacking that doesn't
meet your requirements?

> Performance and maintainability are also on the table.

Performance of the software datapath is of paramount importance. My
fundamental concern here is that if we push an underperforming
software solution, then the patches don't just enable offload, they'll
be used to *justify* it. That is, the hardware vendors might go to
their customers and show how much better the offload is than the slow
software solution; whereas if they compared to a higher performing
software solution it might meet the performance requirements of the
customer thereby saving them the cost and complexity of offload. Note
we've already been down this path once with DPDK once being touted as
being "10x faster than the kernel" with little regard to whether the
kernel could be tuned or adapted-- of course, we subsequently invented
XDP and pretty much closed the gap.

Tom

>
> Let me know what you think.
>
> cheers,
> jamal
>
> On Wed, Feb 1, 2023 at 1:08 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
> >
> > Jamal Hadi Salim <jhs@mojatatu.com> writes:
> >
> > > On Tue, Jan 31, 2023 at 5:54 PM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> > >>
> > >> Jamal Hadi Salim <jhs@mojatatu.com> writes:
> > >>
> > >> > So while going through this thought process, things to consider:
> > >> > 1) The autonomy of the tc infra, essentially the skip_sw/hw  contr=
ols
> > >> > and their packet driven iteration. Perhaps (the patch i pointed to
> > >> > from Paul Blakey) where part of the action graph runs in sw.
> > >>
> > >> Yeah, I agree that mixed-mode operation is an important consideratio=
n,
> > >> and presumably attaching metadata directly to a packet on the hardwa=
re
> > >> side, and accessing that in sw, is in scope as well? We seem to have
> > >> landed on exposing that sort of thing via kfuncs in XDP, so expandin=
g on
> > >> that seems reasonable at a first glance.
> > >
> > > There is  built-in metadata chain id/prio/protocol (stored in cls
> > > common struct) passed when the policy is installed. The hardware may
> > > be able to handle received (probably packet encapsulated, but i
> > > believe that is vendor specific) metadata and transform it into the
> > > appropriate continuation point. Maybe a simpler example is to look at
> > > the patch from Paul (since that is the most recent change, so it is
> > > sticking in my brain); if you can follow the example,  you'll see
> > > there's some state that is transferred for the action with a cookie
> > > from/to the driver.
> >
> > Right, that roughly fits my understanding. Just adding a kfunc to fetch
> > that cookie would be the obvious way to expose it to BPF.
> >
> > >> > 2) The dynamicity of being able to trigger table offloads and/or
> > >> > kernel table updates which are packet driven (consider scenario wh=
ere
> > >> > they have iterated the hardware and ingressed into the kernel).
> > >>
> > >> That could be done by either interface, though: the kernel can propa=
gate
> > >> a bpf_map_update() from a BPF program to the hardware version of the
> > >> table as well. I suspect a map-based API at least on the BPF side wo=
uld
> > >> be more natural, but I don't really have a strong opinion on this :)
> > >
> > > Should have mentioned this earlier as requirement:
> > > Speed of update is _extremely_ important, i.e how fast you can update
> > > could make or break things; see talk from Marcelo/Vlad[1]. My gut
> > > feeling is dealing with feedback from some vendor firmware/driver
> > > interface that the entry is really offloaded may cause challenges for
> > > ebpf by stalling the program. We have seen upto several ms delays on
> > > occasions.
> >
> > Right, understandable. That seems kinda orthogonal to which API is used
> > to expose this data, though? In the end it's all just kernel code, and,
> > well, if updating things in an offloaded map/table is taking too long,
> > we'll have to either fix the underlying code to make it faster, or the
> > application will have keep things only in software? :)
> >
> > -Toke
> >
