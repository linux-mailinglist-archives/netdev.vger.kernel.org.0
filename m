Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E98688719
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjBBSvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbjBBSvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:51:10 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE21116327
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:51:07 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id 129so3487231ybb.0
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 10:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ef/uItQ/j4ylczbodt4SFlpEdIJcWYs6W0Yic3rwWk=;
        b=zLduayALE4gY3yc2zlruip3D8/jIYYiR60w/G3MhNlwMNhy20fbeW21BSJYVb8I3Yf
         9laKiN/2XbJ8w3hOWmnIjREuO8ykJcQHuu32CEdeP55bIT06rblVJbZxG1/TOq3wvf6n
         rehKpyJO6PsVph5Pj5hKQ5IgPU5m5n7V7GtISB00LSWTSUpiJJa+KlKJ71laQCEnrAjQ
         TjNwi7iYd0e8923hOEgJjY46w72AG4tjJf+wTv8YMCXEUJc0YTqsJQHU6/KbyNxV1aX3
         vcJGNfJOWNLmDnfwCS4oePRL8nxhLNkage8UcqXxCvbormLZsoL//UjNrn3ukyGRMUPa
         FMnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ef/uItQ/j4ylczbodt4SFlpEdIJcWYs6W0Yic3rwWk=;
        b=nkTBjJaEH1jCZpY9t4qanCmUVuQN1N/GcnKfE1aQQaJ6/9fiw0MDqxtKuOr5i1bPP4
         OYCrsR/DsWGcbOjO1LDWdcFkbh8pqBENgXUgFhR6KiIDyxGe2vgIpGO+wzODy6m165PM
         WNorW2E9WyjDLNvU7p/x9GV7KBzHlZ/kj4ZYS/Y3qQYmlTkrGcRdEuTWeGK8ye0Znf/G
         J/O6pJud6lmq6OknzPJCpKiB5WAUYCAKQ2HM27zj+YJaCK1npBxFiGghkR3vrSAC+fUi
         NZqiW1RAhbCu3bmcjgsvuBzUsYNaChGMqpExYvc2WhvdkKxnzM9crbLUE8wf0LBLEpdK
         rqcA==
X-Gm-Message-State: AO0yUKW+3kE+2/xpXM0U6WPgP7r8q6s0RUliUY55hHu0WyLk0Tmk5qF+
        /iF/kT/3Ll9LwHdEO75DJlm29xlYwyB3x/Mo0vXcDg==
X-Google-Smtp-Source: AK7set/+1aD3F1Oxu2Y1sCbVFHSZis2aoXqFlnl5DgsyDFFEd1OtiuEOtPyyUpk2t/jjQ0vCSOhZIF7V1oa7QbxaWZI=
X-Received: by 2002:a5b:945:0:b0:80b:cdc5:edf with SMTP id x5-20020a5b0945000000b0080bcdc50edfmr729447ybq.259.1675363867215;
 Thu, 02 Feb 2023 10:51:07 -0800 (PST)
MIME-Version: 1.0
References: <Y9eYNsklxkm8CkyP@nanopsycho> <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk> <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk> <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <87h6w6vqyd.fsf@toke.dk> <Y9kn6bh8z11xWsDh@nanopsycho> <87357qvdso.fsf@toke.dk>
 <CAM0EoMmx9U5TN6+Lb4sKPhR2PLN_vptVQMBzc0EtoSa6W-hsZA@mail.gmail.com>
 <87o7qe2u4c.fsf@toke.dk> <CAM0EoM=qeA1zO-FZNjppzc9V7i3dScCT5rFXbqL=ERcnCuZxfA@mail.gmail.com>
 <87r0v91cns.fsf@toke.dk>
In-Reply-To: <87r0v91cns.fsf@toke.dk>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 2 Feb 2023 13:50:55 -0500
Message-ID: <CAM0EoMnaQBwnV6e=DU-xY1OowY9-znxp0SXhqnNW0xz+2R5DNw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry I was distracted somewhere else.
I am not sure i fully grokked your proposal but I am willing to go
through this thought exercise with you (perhaps a higher bandwidth
media would help); however,  we should put some parameters so it
doesnt become a perpetual discussion:

The starting premise is that posted code meets our requirements so
whatever we do using ebpf has to meet our requirements; we dont want
to get into a wrestling match with any of the ebpf constraints.
Actually, I am ok with some limited degree of square hole round peg
situation but it cant be interfering in getting work done. I would
also be ok with small surgeries into the ebpf core if needed to meet
our requirements.
Performance and maintainability are also on the table.

Let me know what you think.

cheers,
jamal

On Wed, Feb 1, 2023 at 1:08 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Jamal Hadi Salim <jhs@mojatatu.com> writes:
>
> > On Tue, Jan 31, 2023 at 5:54 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Jamal Hadi Salim <jhs@mojatatu.com> writes:
> >>
> >> > So while going through this thought process, things to consider:
> >> > 1) The autonomy of the tc infra, essentially the skip_sw/hw  control=
s
> >> > and their packet driven iteration. Perhaps (the patch i pointed to
> >> > from Paul Blakey) where part of the action graph runs in sw.
> >>
> >> Yeah, I agree that mixed-mode operation is an important consideration,
> >> and presumably attaching metadata directly to a packet on the hardware
> >> side, and accessing that in sw, is in scope as well? We seem to have
> >> landed on exposing that sort of thing via kfuncs in XDP, so expanding =
on
> >> that seems reasonable at a first glance.
> >
> > There is  built-in metadata chain id/prio/protocol (stored in cls
> > common struct) passed when the policy is installed. The hardware may
> > be able to handle received (probably packet encapsulated, but i
> > believe that is vendor specific) metadata and transform it into the
> > appropriate continuation point. Maybe a simpler example is to look at
> > the patch from Paul (since that is the most recent change, so it is
> > sticking in my brain); if you can follow the example,  you'll see
> > there's some state that is transferred for the action with a cookie
> > from/to the driver.
>
> Right, that roughly fits my understanding. Just adding a kfunc to fetch
> that cookie would be the obvious way to expose it to BPF.
>
> >> > 2) The dynamicity of being able to trigger table offloads and/or
> >> > kernel table updates which are packet driven (consider scenario wher=
e
> >> > they have iterated the hardware and ingressed into the kernel).
> >>
> >> That could be done by either interface, though: the kernel can propaga=
te
> >> a bpf_map_update() from a BPF program to the hardware version of the
> >> table as well. I suspect a map-based API at least on the BPF side woul=
d
> >> be more natural, but I don't really have a strong opinion on this :)
> >
> > Should have mentioned this earlier as requirement:
> > Speed of update is _extremely_ important, i.e how fast you can update
> > could make or break things; see talk from Marcelo/Vlad[1]. My gut
> > feeling is dealing with feedback from some vendor firmware/driver
> > interface that the entry is really offloaded may cause challenges for
> > ebpf by stalling the program. We have seen upto several ms delays on
> > occasions.
>
> Right, understandable. That seems kinda orthogonal to which API is used
> to expose this data, though? In the end it's all just kernel code, and,
> well, if updating things in an offloaded map/table is taking too long,
> we'll have to either fix the underlying code to make it faster, or the
> application will have keep things only in software? :)
>
> -Toke
>
