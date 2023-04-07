Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E262E6DB397
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 20:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbjDGSvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 14:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbjDGSvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 14:51:39 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4E8C16A
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 11:49:54 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id ch3so649766ybb.4
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 11:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680893353; x=1683485353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0t5i43wGGIz6RL/As6jYxd4q/8/bvGtJKBPYe204Cnk=;
        b=gKmjpf6w1ICxLZDfP31MkmQ5Vt8VhgqY243vOu354bZO1tNUMd87r1SkzNhbua3W7v
         4i/r5IDyc+e8Xs5/JeoxeEzQPHRM9r0GWhB8dpCpiiZ+qDDhQPEU2Z6XgHUtbr1BDR76
         7xvbLSUABgvNRiKQN1JU6K6k4qUY9i6Zox54pXUUcSYygaaYt+KevKoy57YX7kg1r/bF
         sknTeqa2uT/LGK2Q0J8ABtlnk5Fo6RyIqYec4Kn891Btj14UzlUXFESR9hd8V+PjuPsx
         WFUMxCyoL3L5ZNzRKF/8vdAmBfWOSDsyXfYl/mGvo8VqHTxS1RupoWqkDQOccBHSkdeH
         UK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680893353; x=1683485353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0t5i43wGGIz6RL/As6jYxd4q/8/bvGtJKBPYe204Cnk=;
        b=1FzRsjK1mD+6Wq4f22jVsxuCTddmwdl7fd10DN03yZfzaQzpT41LGYjbcxSS/Sewpk
         PXDn/fNHZcTRV2dsZVl4VqiG0M46UstkLwqFRhwm2wwL4mr1m6wk+Vu3rhXWfD1DnDeM
         PKixEz04Ipew4LnzcY/uqp57R5D9VOwCp9Mdcr9t0awfffpSSTlLkVOgKOH9VL2Ih0Pj
         Es2RSgXBIDX4DO0xP82jdgP6QrByi4N2c0aPF1yIT2HXqvb5efikmNTcOOcvRJVJ798A
         XKMKZv4ErQTswGf6MMMMHCVC7e6bLjRR0joHQ3rPXAE1Fy5PN8qJxVUJjCFJ3rhgcbab
         dTKQ==
X-Gm-Message-State: AAQBX9drcuxNxYDnV+op/JDR2pz13ev+N4BQXz3HT73axrIC9mlZYmcs
        slrxPrBUdb3qaSr64gGXGH1NdKo8SznZm+AkqeQEnA==
X-Google-Smtp-Source: AKy350aDFkhaRl1uGFXVUcmJBDtXUukJIAeZfOkdqca1DflfNE/k1pKD3feoPUtE71Whm6fpzx6vbkGZKotrisBxfOg=
X-Received: by 2002:a25:ca85:0:b0:b8b:f52c:a785 with SMTP id
 a127-20020a25ca85000000b00b8bf52ca785mr2379050ybg.7.1680893352900; Fri, 07
 Apr 2023 11:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
 <20230403103440.2895683-7-vladimir.oltean@nxp.com> <CAM0EoMn9iwTBUW-OaK2sDtTS-PO2_nGLuvGmrqY5n8HYEdt7XQ@mail.gmail.com>
 <20230407164103.vstxn2fmswno3ker@skbuf>
In-Reply-To: <20230407164103.vstxn2fmswno3ker@skbuf>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 7 Apr 2023 14:49:01 -0400
Message-ID: <CAM0EoM=go4RNohHpt6Z9wFk0AU81gJY3puBTUOC6F0xMocJouQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 6/9] net/sched: mqprio: allow per-TC user
 input of FP adminStatus
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
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

On Fri, Apr 7, 2023 at 12:41=E2=80=AFPM Vladimir Oltean <vladimir.oltean@nx=
p.com> wrote:
>
> On Fri, Apr 07, 2023 at 12:22:26PM -0400, Jamal Hadi Salim wrote:
> > > +enum {
> > > +       TC_FP_EXPRESS =3D 1,
> > > +       TC_FP_PREEMPTIBLE =3D 2,
> > > +};
> >
> > Suggestion: Add a MAX to this enum (as is traditionally done)..
>
> Max what? This doesn't count anything, it just expresses whether the
> quality of one traffic class, from the Frame Preemption standard's
> perspective, is express or preemptible...
>
> > > @@ -145,13 +149,94 @@ static int mqprio_parse_opt(struct net_device *=
dev, struct tc_mqprio_qopt *qopt,
> > >         return 0;
> > >  }
> > >
> > > +static const struct
> > > +nla_policy mqprio_tc_entry_policy[TCA_MQPRIO_TC_ENTRY_MAX + 1] =3D {
> > > +       [TCA_MQPRIO_TC_ENTRY_INDEX]     =3D NLA_POLICY_MAX(NLA_U32,
> > > +                                                        TC_QOPT_MAX_=
QUEUE),
> >
> > And use it here...
>
> Where? Above or below the comment? I think you mean below (for the
> policy of TCA_MQPRIO_TC_ENTRY_FP)?
>

That was what I meant. I misread that code thinking it was a nested
TLV range check. If it is only going to be those two specific values,
I understand - but then wondering why you
need a u32; wouldnt a u8 be sufficient? The only reason you would need
a MAX is if it is possible that new values greater than
TC_FP_PREEMPTIBLE showing up in the future.

> > Out of curiosity, could you have more that 16 queues in this spec? I
> > noticed 802.1p mentioned somewhere (typically 3 bits).
>
> "This spec" is IEEE 802.1Q :) It doesn't say how many "queues" (struct
> netdev_queue) there are, and this UAPI doesn't work with those, either.
> The standard defines 8 priority values, groupable in (potentially fewer)
> traffic classes. Linux liked to extend the number of traffic classes to
> 16 (and the skb->priority values are arbitrarily large IIUC) and this is
> where that number 16 came from. The number of 16 traffic classes still
> allows for more than 16 TXQs though.
>
> > Lead up question: if the max is 16 then can preemptible_tcs for example=
 be u32?
>
> I don't understand this question, sorry. preemptible_tcs is declared as
> "unsigned long", which IIUC is at least 32-bit.

I meant: if you only had 16 possible values, meaning 16 bits are
sufficient, (although i may be misunderstanding the goal of those
bits) why not be explicit and use the proper type/size?

cheers,
jamal

> >
> > > +       [TCA_MQPRIO_TC_ENTRY_FP]        =3D NLA_POLICY_RANGE(NLA_U32,
> > > +                                                          TC_FP_EXPR=
ESS,
> > > +                                                          TC_FP_PREE=
MPTIBLE),
