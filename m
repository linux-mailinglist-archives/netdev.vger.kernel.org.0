Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000B2683A79
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 00:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjAaXbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 18:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjAaXbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 18:31:14 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723004ABC6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 15:31:12 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id t16so20259633ybk.2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 15:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uZuKj3Dqn8WEeTcU/YSrHNVZVkAqLPkzNxn4NneuSWw=;
        b=fqrh2iml8OrelG0vuxo7YcazKyilfztdMrq+1ZguRFCjB3vNJAdKsSwQOCtuUe/4+Y
         Vhqo80xKCPA9oArEKit1KngHF0miEeh+IcKudVkPWScHFXxUxxSivp7b81a1xapVd2wl
         mfuoD5m69wnDRyu3v4RDuXmtCB/Z+KmY8opY/MkO1bG4SW/XcfN5CMsal5GnOcPFwK5u
         3C2IVRnP/QNBsDkvo/5YDr4tGZeDw9LXGSXIjmdPB41HqG6fJyRzfbc9n/H62VWKm1sN
         6xMc5XD8PSO3mz2+AXwzMe520/90pCB7IJunPIVxcF2bH//qcU9/vLFnweOdVcS2pmEW
         H0IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uZuKj3Dqn8WEeTcU/YSrHNVZVkAqLPkzNxn4NneuSWw=;
        b=2bpeNF03CcDj9QoRF3EI+3mB4PJY2//m62lwONtv0uTgzP267zFwcocRMsPMVOp6jD
         yHK55O2uGSKpqwa8JbFIx8pHaWSwO4NAuTV9tNuuAMUW8cWqNYszmy5N8vOxB0K65p5k
         VuXt7lu5qNWgfkcaWWL+JPTlSHLPNDkEB6GEg6dN3D7vpMdFTrWhfIUf+z0bkgwmnkcs
         QMmKDk1nZuRjdLUF+btCvHt6AZaOZ7cJsA35GZMjRGA1lflF2kLQdvZHFYfa4cY8F69J
         Lhstwrqmx8jP/lb+tSE5Rgrzo7h8zhZHBFD/pDi79C69vNK7Sc5WPCd5cU4Aimm/XN9c
         I11A==
X-Gm-Message-State: AO0yUKWXMuif0bQE7LqlKEu3VqBlrHo831HiJDWkJtHkJNTU9xpuRlX5
        zB4B9f+aupnvHCkJIySSoEmGy8ePLPw7NAc1K5O3yg==
X-Google-Smtp-Source: AK7set+mzJ9QB4VCZdVcEapkj2Bv+GKNr1/7nxGSU6Pe+CbdJLZr32PNDu5/XJ7LhpBwXua5/nUYq3EZhCBHFhbeu4o=
X-Received: by 2002:a25:ae06:0:b0:803:a6eb:f94b with SMTP id
 a6-20020a25ae06000000b00803a6ebf94bmr110245ybj.509.1675207871713; Tue, 31 Jan
 2023 15:31:11 -0800 (PST)
MIME-Version: 1.0
References: <Y9eYNsklxkm8CkyP@nanopsycho> <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk> <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk> <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <87h6w6vqyd.fsf@toke.dk> <Y9kn6bh8z11xWsDh@nanopsycho> <87357qvdso.fsf@toke.dk>
 <CAM0EoMmx9U5TN6+Lb4sKPhR2PLN_vptVQMBzc0EtoSa6W-hsZA@mail.gmail.com> <87o7qe2u4c.fsf@toke.dk>
In-Reply-To: <87o7qe2u4c.fsf@toke.dk>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 31 Jan 2023 18:31:00 -0500
Message-ID: <CAM0EoM=qeA1zO-FZNjppzc9V7i3dScCT5rFXbqL=ERcnCuZxfA@mail.gmail.com>
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

On Tue, Jan 31, 2023 at 5:54 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Jamal Hadi Salim <jhs@mojatatu.com> writes:
>
> > So while going through this thought process, things to consider:
> > 1) The autonomy of the tc infra, essentially the skip_sw/hw  controls
> > and their packet driven iteration. Perhaps (the patch i pointed to
> > from Paul Blakey) where part of the action graph runs in sw.
>
> Yeah, I agree that mixed-mode operation is an important consideration,
> and presumably attaching metadata directly to a packet on the hardware
> side, and accessing that in sw, is in scope as well? We seem to have
> landed on exposing that sort of thing via kfuncs in XDP, so expanding on
> that seems reasonable at a first glance.

There is  built-in metadata chain id/prio/protocol (stored in cls
common struct) passed when the policy is installed. The hardware may
be able to handle received (probably packet encapsulated, but i
believe that is vendor specific) metadata and transform it into the
appropriate continuation point. Maybe a simpler example is to look at
the patch from Paul (since that is the most recent change, so it is
sticking in my brain); if you can follow the example,  you'll see
there's some state that is transferred for the action with a cookie
from/to the driver.

> > 2) The dynamicity of being able to trigger table offloads and/or
> > kernel table updates which are packet driven (consider scenario where
> > they have iterated the hardware and ingressed into the kernel).
>
> That could be done by either interface, though: the kernel can propagate
> a bpf_map_update() from a BPF program to the hardware version of the
> table as well. I suspect a map-based API at least on the BPF side would
> be more natural, but I don't really have a strong opinion on this :)

Should have mentioned this earlier as requirement:
Speed of update is _extremely_ important, i.e how fast you can update
could make or break things; see talk from Marcelo/Vlad[1]. My gut
feeling is dealing with feedback from some vendor firmware/driver
interface that the entry is really offloaded may cause challenges for
ebpf by stalling the program. We have seen upto several ms delays on
occasions.

cheers,
jamal
[1] https://netdevconf.info/0x15/session.html?Where-turbo-boosting-TC-flowe=
r-control-path-had-led-us-to
