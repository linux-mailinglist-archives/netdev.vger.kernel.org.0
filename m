Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A58683951
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 23:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjAaWYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 17:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbjAaWYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 17:24:22 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309C2102
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:24:02 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-501c3a414acso222405217b3.7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LlaPlFB8818t1wzzymvspb3+l27A6eip/nhMGLNbvFw=;
        b=vkIZVH7dA1Ehq7v63gSOuApnrxZoOL90CAeA8DSKwyHiPjcPUjGXX3q6P47QI0C5a3
         Wm2GISA9/Az2cHgPt0mshnV3chJklGEKvMCL0fjxRJ0x2z09hjoNsWOXAEmGRaaVxhqC
         RUtVRasFPkiBDrVtr8D2zf4lD15piBpLV3JNYKRqnmA6lHEhDWUiUABNwvF78hVjimnE
         6IN4tIOJcpDOnupRPxKWB7dlgjLbzXtrr0B+R7D4HX3WS2Hn0DHqD0NvK/psNJyXNqrS
         kzJnBB3miByzF8ZjhGnevWW1EUIc38P6PPXVk6NNl1IaQT1E1nEd8P2tWTnOagCWMukJ
         yArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LlaPlFB8818t1wzzymvspb3+l27A6eip/nhMGLNbvFw=;
        b=k6UiX1Pzm8FvrOPCFFPzwA1GuwKZpR8d0hc36PIOj2o5BY1h1DPQrTcftI4HW20CCj
         Yea08Ud3ueIBVRKesp5vQooNpgxmo0QY9xg1h6YAycbRPsnl4XNjs83B409sB8H0axDr
         76feltVAulf2ka77X3OU95VIyWPWnXuzjUGkGbWdH6A/Uqxe3WyzS88DOjU6uPVDss+O
         +vyb5sjGX7NO6QF4Pj4HHd3L4rTk6qbrhVu1ClpoeVLppV/LLOOWOO5L3PIbq2fMKeam
         C1ELAT1OQRV2YDpv0BIpqG7upr7W46+ZM979RuQiSyOaz5gK5dOyvsM77djW32ZWDRL8
         tlyw==
X-Gm-Message-State: AO0yUKVC49MWIxLQxidPkMD41h8K1PZsLeEzFuiAy+g5W1IArxkGp82h
        V8aYRVboZDEmgt4qPQS3fBsu9hzHqofieUYSpE3kLA==
X-Google-Smtp-Source: AK7set911AWAwDGwYbDWt93g5yhk6s+r6xm1JbEMa5RQ6RonaCv8UBL6uglLkeFUaT4ps6Xa8PCawrgnWWPAg04F0EU=
X-Received: by 2002:a81:a96:0:b0:39f:ddab:af27 with SMTP id
 144-20020a810a96000000b0039fddabaf27mr5395ywk.17.1675203841190; Tue, 31 Jan
 2023 14:24:01 -0800 (PST)
MIME-Version: 1.0
References: <Y9eYNsklxkm8CkyP@nanopsycho> <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk> <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk> <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <87h6w6vqyd.fsf@toke.dk> <Y9kn6bh8z11xWsDh@nanopsycho> <87357qvdso.fsf@toke.dk>
In-Reply-To: <87357qvdso.fsf@toke.dk>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 31 Jan 2023 17:23:49 -0500
Message-ID: <CAM0EoMmx9U5TN6+Lb4sKPhR2PLN_vptVQMBzc0EtoSa6W-hsZA@mail.gmail.com>
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

So while going through this thought process, things to consider:
1) The autonomy of the tc infra, essentially the skip_sw/hw  controls
and their packet driven iteration. Perhaps (the patch i pointed to
from Paul Blakey) where part of the action graph runs in sw.
2) The dynamicity of being able to trigger table offloads and/or
kernel table updates which are packet driven (consider scenario where
they have iterated the hardware and ingressed into the kernel).

cheers,
jamal

On Tue, Jan 31, 2023 at 12:01 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Jiri Pirko <jiri@resnulli.us> writes:
>
> > Tue, Jan 31, 2023 at 01:17:14PM CET, toke@redhat.com wrote:
> >>Jamal Hadi Salim <jhs@mojatatu.com> writes:
> >>
> >>> Toke, i dont think i have managed to get across that there is an
> >>> "autonomous" control built into the kernel. It is not just things tha=
t
> >>> come across netlink. It's about the whole infra.
> >>
> >>I'm not disputing the need for the TC infra to configure the pipelines
> >>and their relationship in the hardware. I'm saying that your
> >>implementation *of the SW path* is the wrong approach and it would be
> >>better done by using BPF (not talking about the existing TC-BPF,
> >>either).
> >>
> >>It's a bit hard to know your thinking for sure here, since your patch
> >>series doesn't include any of the offload control bits. But from the
> >>slides and your hints in this series, AFAICT, the flow goes something
> >>like:
> >>
> >>hw_pipeline_id =3D devlink_program_hardware(dev, p4_compiled_blob);
> >>sw_pipeline_id =3D `tc p4template create ...` (etc, this is generated b=
y P4C)
> >>
> >>tc_act =3D tc_act_create(hw_pipeline_id, sw_pipeline_id)
> >>
> >>which will turn into something like:
> >>
> >>struct p4_cls_offload ofl =3D {
> >>  .classid =3D classid,
> >>  .pipeline_id =3D hw_pipeline_id
> >>};
> >>
> >>if (check_sw_and_hw_equivalence(hw_pipeline_id, sw_pipeline_id)) /* som=
e magic check here */
> >>  return -EINVAL;
> >>
> >>netdev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_P4, &ofl);
> >>
> >>
> >>I.e, all that's being passed to the hardware is the ID of the
> >>pre-programmed pipeline, because that programming is going to be
> >>out-of-band via devlink anyway.
> >>
> >>In which case, you could just as well replace the above:
> >>
> >>sw_pipeline_id =3D `tc p4template create ...` (etc, this is generated b=
y P4C)
> >>
> >>with
> >>
> >>sw_pipeline_id =3D bpf_prog_load(BPF_PROG_TYPE_P4TC, "my_obj_file.o"); =
/* my_obj_file is created by P4c */
> >>
> >>and achieve exactly the same.
> >>
> >>Having all the P4 data types and concepts exist inside the kernel
> >>*might* make sense if the kernel could then translate those into the
> >>hardware representations and manage their lifecycle in a uniform way.
> >>But as far as I can tell from the slides and what you've been saying in
> >>this thread that's not going to be possible anyway, so why do you need
> >>anything more granular than the pipeline ID?
> >
> > Toke, I understand what what you describe above is applicable for the P=
4
> > program instantiation (pipeline definition).
> >
> > What is the suggestion for the actual "rule insertions" ? Would it make
> > sense to use TC iface (Jamal's or similar) to insert rules to both BPF =
SW
> > path and offloaded HW path?
>
> Hmm, so by "rule insertions" here you're referring to populating what P4
> calls 'tables', right?
>
> I could see a couple of ways this could be bridged between the BPF side
> and the HW side:
>
> - Create a new BPF map type that is backed by the TC-internal data
>   structure, so updates from userspace go via the TC interface, but BPF
>   programs access the contents via the bpf_map_*() helpers (or we could
>   allow updating via the bpf() syscall as well)
>
> - Expose the TC data structures to BPF via their own set of kfuncs,
>   similar to what we did for conntrack
>
> - Scrap the TC interface entirely and make this an offload-enabled BPF
>   map type (using the BPF ndo and bpf_map_dev_ops operations to update
>   it). Userspace would then populate it via the bpf() syscall like any
>   other map.
>
>
> I suspect the map interface is the most straight-forward to use from the
> BPF side, but informing this by what existing implementations do
> (thinking of the P4->XDP compiler in particular) might be a good idea?
>
> -Toke
>
