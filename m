Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62245681509
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjA3Pbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjA3Pbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:31:34 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED3A3EC5A
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 07:31:31 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-50aa54cc7c0so136724447b3.8
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 07:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KqRG3fN1QTVEpbMpVo91jx4E11H8mSK6Lp1I8G44ibo=;
        b=xL/Ws5ZTGosMU/54DELI0vOB+Sqfqip3w0Ur33spR6zr3RwFOpEVRKYSovWOiHoKBQ
         PIrSEy3MKJ2XYsY8GdxvT8q3r9gevTBiirigyOziPUx/LObbZXtVUwMXpMc5vFZjkEL8
         C1M8xTkzez5IOdSQwSxHdgrv5GI6eVLWhIFujW63ya1dhlgcp7LpBfi5FAzI8jmk2PfN
         ZWvy8NNFRijXbweL2KlrJZn5s5rmv/VHUG2OqxNfGFVE2o9wZhNwhb4TEcxnTDM9Y0+X
         MACDAW2Ujts1W5Ds+1ql5h35uKoj/9Q5Kqw6zTJy5U2Av12zLkng3W0RRoBIb/aDgx47
         83UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KqRG3fN1QTVEpbMpVo91jx4E11H8mSK6Lp1I8G44ibo=;
        b=rk7rW7HJwz292KuRapvVgOhxH+nRORxPJe6JWZYwOO6QWeTWb/rSsDDBKEX0jB5DAU
         a12h6Lt4JbN3YcrPeIC8k03GtSZI62vbxSJ2NjGRsN4Q76vA2MjebF3QtG/0wGuhLOtD
         BLV4uWOdiYvKXWNAub5lrhWKmKaVNaIZDGxvGogIlhsZ+4DeqVXH0mN0wkeyTY8vqkxj
         kdYO624KWYu9LxjRJeFj/vIOCLB3cqRqa+nKb1w2b2+e+U6XWiD01WDrg6+W8Hf3/E5c
         lsBbZEs8rTGjS92+7jooMBTZmHCv5xcg0NDxSXz9NWoaZGuIhEM46L3vQ3cp7ObJlX9u
         FDgA==
X-Gm-Message-State: AFqh2koyKKANctKQv0iqqWGeu+8idE8HH9BA3TX9KnRIYOLQSPFJlB7c
        CpmLnYU/SOpCCviju5wdGp0Og+yrngxThtBw30VxRg==
X-Google-Smtp-Source: AMrXdXuaJDl8YKQlWmV0YYfpyCU0QtAJI80dt7u/ZQu0S+nW94QqziLtzhPhqO7+3fUcN+MC5FEMjvkKbl3AhqK1uf0=
X-Received: by 2002:a81:5a86:0:b0:4dd:4477:47b6 with SMTP id
 o128-20020a815a86000000b004dd447747b6mr5816919ywb.395.1675092690339; Mon, 30
 Jan 2023 07:31:30 -0800 (PST)
MIME-Version: 1.0
References: <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch> <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk> <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <Y9fXQo1kmIXfs7eS@lunn.ch>
In-Reply-To: <Y9fXQo1kmIXfs7eS@lunn.ch>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 30 Jan 2023 10:31:18 -0500
Message-ID: <CAM0EoMn_LEpPjFmtxeFHFUwRdhL2CFjpwSKzUUEkOA6Bstqm7A@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
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

On Mon, Jan 30, 2023 at 9:42 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Hi Jamal
>
> I'm mostly sat watching and eating popcorn, and i have little
> knowledge in the area.
>
> > Jiri, i think one of the concerns you have is that there is no way to
> > generalize the different hardware by using a single abstraction since
> > all hardware may have different architectures (eg whether using RMT vs
> > DRMT, a mesh processing xbar, TCAM, SRAM, host DRAM,  etc) which may
> > necessitate doing things like underlying table reordering, merging,
> > sorting etc. The consensus is that it is the vendor driver that is
> > responsible for =E2=80=9Ctransforming=E2=80=9D P4 abstractions into wha=
tever your
> > hardware does.
>
> What is the complexity involved in this 'transformation'? Are we
> talking about putting a P4 'compiler' into each driver, each vendor
> having there own compiler? Performing an upcall into user space with a
> P4 blob and asking the vendor tool to give us back a blob for the
> hardware? Or is it relatively simple, a few hundred lines of code,
> simple transformations?
>

The current model is you compile the kernel vs hardware output as two
separate files. They are loaded separately
The compiler has a vendor specific backend and a P4TC one. There has
to be a authentication sync that the two are one and the same;
essentially each program/pipeline has a name and an ID and some hash
for validation. See slide #49 in the presentation at
https://netdevconf.info/0x16/session.html?Your-Network-Datapath-Will-Be-P4-=
Scripted
Only the vendor will be able to create something reasonable for their
specific hardware.
The issue is how to load the hardware part - the three methods were
discussed are listed in slides 50-52. The vendors seem to be in
agreement that the best option is #1.

BTW, these discussions happen in a high bandwidth medium at the moment
every two weeks here:
https://www.google.com/url?q=3Dhttps://teams.microsoft.com/l/meetup-join/1.=
&sa=3DD&source=3Dcalendar&ust=3D1675366175958603&usg=3DAOvVaw1UZo8g5Ir6OcC-=
SRFM9PF1
It would be helpful if other folks will show up in those meetings.

> As far as i know, all offloading done so far in the network stack has
> been purely in kernel. We transform a kernel representation of
> networking state into something the hardware understands and pass it
> to the hardware. That means, except for bugs, what happens in SW
> should be the same as what happens in HW, just faster.

Exactly - that is what is refered to as "hardcoding" in slides 43-44
with what P4TC would do described in slide #45.

> But there have
> been mention of P4 extensions. Stuff that the SW P4 implementation
> cannot do, but the hardware can, and vendors appear to think such
> extensions are part of their magic sauce. How will that work? Is the
> 'compiler' supposed to recognise plain P4 equivalent of these
> extensions and replace it with those extensions?

I think the "magic sauce" angle is mostly the idea of how one would
implement foobar differently than the other vendor. If someone uses a
little ASIC and the next person uses FW to program a TCAM they may
feel they have an advantage in their hardware that the other guy
doesnt have.  At the end of the day that thing looks like a box with
input Y that produces output X. In P4 they call them "externs".  From
a P4TC backend perspective, we hope that we can allow foobar to be
implemented by multiple vendors without caring about the details of
the implementation. The vendor backend can describe it to whatever
detail it wants to its hardware.

> I suppose what i'm trying to get at, is are we going to enforce the SW
> and HW equivalence by doing the transformation in kernel, or could we
> be heading towards in userspace we take our P4 and compile it with one
> toolchain for the SW path, another toolchain for the HW path, and we
> have no guarantee that the resulting blobs actually came from the same
> sources and are supposed to be equivalent? And that then makes the SW
> path somewhat pointless?

See above - the two have to map to the same equivalence and validated as su=
ch.
It is also about providing a singular interface through the kernel as
opposed to dealing
with multiple vendor APIs.

cheers,
jamal
