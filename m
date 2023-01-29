Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D84467FE77
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 12:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjA2LT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 06:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjA2LTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 06:19:55 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D93A1EFF4
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 03:19:54 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-4fd37a1551cso124487047b3.13
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 03:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UVQgk6DCHgP9qFK+5wRnTlgCY/ts9g6JohPvOVsg9E8=;
        b=w/FGnieO4aQepw+S5jrkwDR7WB48sAxrckiI+C7fx+AE1anjBB9mcMx24vlU7Q4Kgr
         9+dQmmAtTclPbCfaoyPtLByTq51SuODHM5aCxQDsp1RV7xfZy0VG1tDXFTXGvS19OO90
         EiRxLR9+H6AeFGo8LNIGnDRbPuZawFwYjCMXIsuPmaZgFfOsZlsAZ+4DvUo07ZMIki0y
         Wg9mLye8r3IDuZcJdDapafCr3frnp5Caf1GhOuEKm/Y8OWfZHalmd60KImLZkvb2mXvN
         jicKtT5q1MBpGrj1lIkfiTTqjJekJj3UQkLMNQFXbtHbGLAohkqC5xoPNm1JK9xJPEqA
         qzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UVQgk6DCHgP9qFK+5wRnTlgCY/ts9g6JohPvOVsg9E8=;
        b=W//mecplCPXZNAceS7K/GFKuRZdI6zqMSV+xOgNTE6ppw4zKj8NATaEDGJEKajnSe9
         00DrVFxxIZ6rp+MyLJy4hAp9osaIVGr5DIBMJSitGCyNEmRwkNFnzYM/+/UpWEwqVosf
         52Y7h8+g2kwgVQkISxD4jq6w+EISbz12TbKGQR1DTz87ofPN/uGo0ELd/gYsEJ+L/Wpo
         +A5ZE/bNAToBt5pYO+tikXUPK7nPu9MZuoczDisrgu1P8NWJgQjVHSB3RgHjsQMqsAGc
         XrUi/bBO8T9n56GiEY3bxVhdGI6iIC1RbuntrVFQn0A00oH93PfpBYE1oeVCO4UD8g8u
         9Syg==
X-Gm-Message-State: AO0yUKWW6aJ9WpiSsdnc11pjQFKYsyWV4i/U5eKaeZPYihl4WJtvSxs4
        sP+Eu0iqmKEUedmyMpikB72ssc2g8NWxkxLWtr7E1Q==
X-Google-Smtp-Source: AK7set+BDUi95WlI4yaplK68C/y8J3yFgK2P6/NQjZycE4wc4NQ52GqPWtZymFt3kUERutgcFqUf9mIiynaNWbkF7Ls=
X-Received: by 2002:a81:ab53:0:b0:506:3a16:693d with SMTP id
 d19-20020a81ab53000000b005063a16693dmr2732083ywk.360.1674991193500; Sun, 29
 Jan 2023 03:19:53 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho> <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com> <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch> <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
In-Reply-To: <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 29 Jan 2023 06:19:42 -0500
Message-ID: <CAM0EoM=sbtTUwPZd7QsApqQh-WxQxQ0Ecw1YR4GHu87vmunqvw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, John - to answer your question on P4runtime; that runs on top
of netlink. Netlink can express
a lot more than P4runtime so we are letting it sit in userspace. I
could describe the netlink interfaces but easier if you look at the
code and ping me privately unless there are more folks interested in
that to which i can respond on the list.

cheers,
jamal

On Sun, Jan 29, 2023 at 6:11 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On Sun, Jan 29, 2023 at 12:39 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Willem de Bruijn wrote:
> > > On Sat, Jan 28, 2023 at 10:10 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > > >
> >
> > [...]
> >
> >
> > Also there already exists a P4 backend that targets BPF.
> >
> >  https://github.com/p4lang/p4c
>
> There's also one based on rust - does that mean we should rewrite our
> code in rust?
> Joking aside - rust was a suggestion made at a talk i did. I ended up
> adding a slide for the next talk which read:
>
> Title: So... how is this better than KDE?
>   Attributed to Rusty Russell
>      Who attributes it to Cort Dougan
>       s/KDE/[rust/ebpf/dpdk/vpp/ovs]/g
>
> We have very specific goals - of which the most important is met by
> what works today and we are reusing that.
>
> cheers,
> jamal
>
> > So as a SW object we can just do the P4 compilation step in user
> > space and run it in BPF as suggested. Then for hw offload we really
> > would need to see some hardware to have any concrete ideas on how
> > to make it work.
> >
>
>
> > Also P4 defines a runtime API so would be good to see how all that
> > works with any proposed offload.
