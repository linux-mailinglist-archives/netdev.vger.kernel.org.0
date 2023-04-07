Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B444E6DB5D2
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 23:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjDGVkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 17:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjDGVke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 17:40:34 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216057683
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 14:40:32 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 72so24764ybe.6
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 14:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680903631; x=1683495631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdqeypLdeZy5Pw+OePubCqs35FYO2gFErqIeJGhxJpQ=;
        b=ZSwsypCndkNbHiRgIvnilV+q+5NvrXqB0Q+KexWLRVBZ5TQywZEhyBpq5ceFcoml20
         Jwq8LRiyNdeGwc/hekLVC8yme8O7cPXFJ/eIuz7YJVXB1wvaoqvtpxNIVEZgV8NYvUoF
         I/1WBFg7OGqcWcAnIGxruh55gh032yHBuu7OKMUjSUJPGWMLlgJfrcy7I/iYB7YN25zq
         f+8FPLnfqCTmXAJI63NpdNf2Pd2mBwitztlS+zd69g5HSMdz4e98eNBVRRcKXSSS5UVN
         RcFFuIwjax5b2O21NbrVKbl/nxQqOTU0PcE6RWmhtcTZ8LD/Nee3x3Qus9o5piVrF6Of
         EiNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680903631; x=1683495631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vdqeypLdeZy5Pw+OePubCqs35FYO2gFErqIeJGhxJpQ=;
        b=s67xSD6Vik6ZaGbH2+nS8bYLp96qF8cQpRUVVW//cXX1fT4TDOpiyzZF2tWYr5JsDn
         2DmIodjDP+xeZk4Gr8xjkLB/Fx62s1r0Kg7u98vnVnrMsRfa2o6axF7RGNTybAck9wnL
         M8DcMH8RSNwtrw+7unwxVr3dOO6Ce1BObYYSe9Pj0oRuAX29eunrFX+v3MKgJCxJQO6w
         ykY954ciEEyhqoQlkZ7JSpjDJm3xMO1RjRN6H0i/FP/vEouyhPhPSJqv4DtXoARfNUuk
         zP6VfoEXbiPqFeydUyjx43g/HVDuYoFp5MuBsvRORMxcmffTm5ZbY7dEe9kXZsi30HCD
         NH5g==
X-Gm-Message-State: AAQBX9fC2PfODMgsg1UWrvpK+jaEI/1GB9kgzFGS4Z2V5Lb1U1G5HJ5a
        C/4BUpHefJNQKpDK+47s5iqcssgQjOsABE2ZztSucgdjdAR83zjDrdCdKA==
X-Google-Smtp-Source: AKy350boNNoanJqFs2LgfEj0xnxKGIDS5WnPRfv1kFZkGMahUmCQT/4a4ZZCYW+3Y1u7mRk4dHUrdB8zOSOlHUXrX+A=
X-Received: by 2002:a25:6c07:0:b0:b8b:eea7:525b with SMTP id
 h7-20020a256c07000000b00b8beea7525bmr2495945ybc.7.1680903631291; Fri, 07 Apr
 2023 14:40:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
 <20230403103440.2895683-7-vladimir.oltean@nxp.com> <CAM0EoMn9iwTBUW-OaK2sDtTS-PO2_nGLuvGmrqY5n8HYEdt7XQ@mail.gmail.com>
 <20230407164103.vstxn2fmswno3ker@skbuf> <CAM0EoM=go4RNohHpt6Z9wFk0AU81gJY3puBTUOC6F0xMocJouQ@mail.gmail.com>
 <20230407193056.3rklegrgmn2yecuu@skbuf>
In-Reply-To: <20230407193056.3rklegrgmn2yecuu@skbuf>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 7 Apr 2023 17:40:20 -0400
Message-ID: <CAM0EoM=miaB=xjp1vyPSfxLO3dBmBq4Loo7Mb=RZ5KuxHrwQaA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 6/9] net/sched: mqprio: allow per-TC user
 input of FP adminStatus
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 7, 2023 at 3:31=E2=80=AFPM Vladimir Oltean <olteanv@gmail.com> =
wrote:
>
> On Fri, Apr 07, 2023 at 02:49:01PM -0400, Jamal Hadi Salim wrote:
> > On Fri, Apr 7, 2023 at 12:41=E2=80=AFPM Vladimir Oltean <vladimir.oltea=
n@nxp.com> wrote:
> > > On Fri, Apr 07, 2023 at 12:22:26PM -0400, Jamal Hadi Salim wrote:
> > > > > +enum {
> > > > > +       TC_FP_EXPRESS =3D 1,
> > > > > +       TC_FP_PREEMPTIBLE =3D 2,
> > > > > +};
> > > >
> > > > Suggestion: Add a MAX to this enum (as is traditionally done)..
> > >
> > > Max what? This doesn't count anything, it just expresses whether the
> > > quality of one traffic class, from the Frame Preemption standard's
> > > perspective, is express or preemptible...
> > >
> > > > > @@ -145,13 +149,94 @@ static int mqprio_parse_opt(struct net_devi=
ce *dev, struct tc_mqprio_qopt *qopt,
> > > > >         return 0;
> > > > >  }
> > > > >
> > > > > +static const struct
> > > > > +nla_policy mqprio_tc_entry_policy[TCA_MQPRIO_TC_ENTRY_MAX + 1] =
=3D {
> > > > > +       [TCA_MQPRIO_TC_ENTRY_INDEX]     =3D NLA_POLICY_MAX(NLA_U3=
2,
> > > > > +                                                        TC_QOPT_=
MAX_QUEUE),
> > > >
> > > > And use it here...
> > >
> > > Where? Above or below the comment? I think you mean below (for the
> > > policy of TCA_MQPRIO_TC_ENTRY_FP)?
> >
> > That was what I meant. I misread that code thinking it was a nested
> > TLV range check. If it is only going to be those two specific values,
> > I understand - but then wondering why you need a u32; wouldnt a u8 be
> > sufficient?
>
> I believe netlink isn't exactly optimized for passing small values; the
> netlink attributes are going to be aligned to NLA_ALIGNTO (4) anyway,
> so it's not like this is going to save space or something. Also, there's
> a policy restricting the maximum, so arbitrarily large values cannot be
> passed now, but could be passed later if needed. I did not see any good
> enough reason to close that door.
>
> > The only reason you would need a MAX is if it is possible that new
> > values greater than TC_FP_PREEMPTIBLE showing up in the future.
>
> Even if someone wants to add TC_FP_KINDA_PREEMPTIBLE =3D 3 and
> TC_FP_PREEMPTIBLE_WITH_STRIPES =3D 4 in the future, I'm still not sure ho=
w
> a MAX definition exported by the kernel is going to help them?
>
> I mean, about the only thing that it would avoid is that I wouldn't be
> changing the policy definition, but that's rather minor and doesn't
> justify exporting something to UAPI?

Yes, it is minor (and usually minor things generate the most emails;->).
I may be misunderstanding what you mean by "doesnt justify exporting
something to UAPI"  - those definitions are part of uapi and are
already
being exported.

> The changed MAX value is only a
> property of the kernel headers that the application is compiled with -
> it doesn't give the capability of the running kernel.
>

Maybe I am missing something or not communicating effectively. What i
am suggesting is something very trivial:

enum {
TC_FP_EXPRESS =3D 1,
TC_FP_PREEMPTIBLE =3D 2,
TC_FP_MAX
};

 [TCA_MQPRIO_TC_ENTRY_FP] =3D NLA_POLICY_RANGE(NLA_U32,
    TC_FP_EXPRESS,
    TC_FP_MAX),

And in a newer revision with TC_FP_PREEMPTIBLE_WITH_STRIPES:

enum {
TC_FP_EXPRESS =3D 1,
TC_FP_PREEMPTIBLE =3D 2,
TC_FP_PREEMPTIBLE_WITH_STRIPES =3D 3,
TC_FP_MAX
};
etc.

Saves you one line in a patch for when TC_FP_PREEMPTIBLE_WITH_STRIPES shows=
 up.

> To see whether TC_FP_PREEMPTIBLE_WITH_STRIPES is supported, the
> application would have to try it and see if it fails. Which is also the
> case right now with TC_FP_PREEMPTIBLE.

You may be referring to the combination of  iproute2/kernel.
In all cases, NLA_POLICY_RANGE will take care of rejecting something
out of bound.

> > > > Lead up question: if the max is 16 then can preemptible_tcs for exa=
mple be u32?
> > >
> > > I don't understand this question, sorry. preemptible_tcs is declared =
as
> > > "unsigned long", which IIUC is at least 32-bit.
> >
> > I meant: if you only had 16 possible values, meaning 16 bits are
> > sufficient, (although i may be misunderstanding the goal of those
> > bits) why not be explicit and use the proper type/size?
>
> If you think it's valuable to change the type of preemptible_tcs from
> unsigned long to u16 and that's a more "proper" type, I can do so.

No, no, it is a matter of taste and opinion. You may have noticed,
trivial stuff like this gets the most comments and reviews normally(we
just spent like 4-5 emails on this?). Poteto/potato: IOW, if i was to
do it i would have used a u16 or u32 because i feel it would be more
readable. I would have used NLA_U8 because i felt it is more fitting
and i would have used a max value because it would save me one line in
a patch in the future. I think weve spent enough electrons on this - I
defer to you.

cheers,
jamal
