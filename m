Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE735F7C5A
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 19:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiJGRhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 13:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJGRhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 13:37:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F61D18D9
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 10:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665164237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hm4aIqzWb4fLk3y65i8PKThHd0IR6DDCnV7n47sp29o=;
        b=LTgWzrWOIGnp1IhfHE5QYq6sb96GZ/7fYg+zxY0jByWBicAsuVBR/xEua/3Ruo2tstcp8o
        S/WRRG29oA/FrHWTZ6ETN0tHI3iTQzqa+xsgeuj9UJHDlIQfznJJBuw6+8+YnQ7u6+r8Ay
        p/+ap+eMx/Q3Ur5pZAvHlQEJTKydBiw=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-304-VC8selYcPzeZPu6PSPGlnA-1; Fri, 07 Oct 2022 13:37:16 -0400
X-MC-Unique: VC8selYcPzeZPu6PSPGlnA-1
Received: by mail-io1-f71.google.com with SMTP id a15-20020a6b660f000000b006a0d0794ad1so3630871ioc.6
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 10:37:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hm4aIqzWb4fLk3y65i8PKThHd0IR6DDCnV7n47sp29o=;
        b=rogIf0wD39+eD4kGvdLVYnAyk4FNzrif/UJVG0MoHvm8ihITaqZH49ftMxJ5Uykd8J
         Z4VTvKA7Ox8KasA2PSpY9b5SnLgCILYlKlUVQBXZHrDbLLDXqBvf247S7bTUHdaGbxkn
         t2uuFcxcas7LRRNBT67/WVexi4EEL4N+q6eon1JtVeTjqw23nAeYFtktwqAZP2gR0vrb
         yMOHXo4qSIu/J+iNpZu3XA+P7QoQWTD4A6E1uFfa2mBB/76nLSThaE7sfpmMGzjCeh+F
         BPrA6o56zUKgLutFeKyMXxaYMWfTJhkvqW/6Dvdr8/VrgWIO9NDkwQVzv9ON7tGR8ewy
         RPbA==
X-Gm-Message-State: ACrzQf3ne5jPLVCbNVGodi5Bz3DPMYIbsT6QRAFZjDTC3+iNKyN33jSL
        9yvoUk/mPAaCJzRWuNpDw4cr81aajAdV0A8FSWN+J1OXpEjvkueyG0FeoaKrLa62aX6pYE0lKoa
        68KFBvow+MOHIUsiC0T9KXounTk5am/Rt
X-Received: by 2002:a05:6638:3452:b0:363:69f8:549f with SMTP id q18-20020a056638345200b0036369f8549fmr3260833jav.190.1665164235953;
        Fri, 07 Oct 2022 10:37:15 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6W+PmphrS8oHu7rguQuAS4V2ObAYL6BRDkBURZYfBxrmS0ronbnmhfOc525G6lMkgT3oqdMnUn6RmUrvBjDv8=
X-Received: by 2002:a05:6638:3452:b0:363:69f8:549f with SMTP id
 q18-20020a056638345200b0036369f8549fmr3260823jav.190.1665164235679; Fri, 07
 Oct 2022 10:37:15 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 7 Oct 2022 10:37:15 -0700
From:   Marcelo Leitner <mleitner@redhat.com>
References: <eeb0c590-7364-a00e-69fc-2326678d6bdf@ovn.org> <PH0PR13MB4793A85169BB60B8609B192194499@PH0PR13MB4793.namprd13.prod.outlook.com>
 <0aac2127-0b14-187e-0adb-7d6b8fe8cfb1@ovn.org> <e71b2bf2-cfd5-52f4-5fd4-1c852f2a8c6c@ovn.org>
 <00D45065-3D74-4C4C-8988-BFE0CEB3BE2F@redhat.com> <fe0cd650-0d4a-d871-5c0b-b1c831c8d0cc@ovn.org>
 <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com>
 <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
 <CALnP8ZaZ5zGD4sP3=SSvC=RBmVOOcc9MdA=aaYRQctaBOhmHfQ@mail.gmail.com> <CAM0EoM=zWBzivTkEG7uBJepZ0=OZmiuqDF3RmgdWA=FgznRF6g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAM0EoM=zWBzivTkEG7uBJepZ0=OZmiuqDF3RmgdWA=FgznRF6g@mail.gmail.com>
Date:   Fri, 7 Oct 2022 10:37:15 -0700
Message-ID: <CALnP8ZY2M3+m_qrg4ox5pjGJ__CAMKfshD+=OxTHCWc=EutapQ@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH] tests: fix reference output for meter offload stats
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Tianyu Yuan <tianyu.yuan@corigine.com>,
        Simon Horman <simon.horman@corigine.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 07, 2022 at 11:59:42AM -0400, Jamal Hadi Salim wrote:
> On Fri, Oct 7, 2022 at 11:01 AM Marcelo Leitner <mleitner@redhat.com> wrote:
> >
> > On Fri, Oct 07, 2022 at 04:39:25PM +0200, Davide Caratti wrote:
> > > On Fri, Oct 7, 2022 at 3:21 PM Marcelo Leitner <mleitner@redhat.com> wrote:
> > > >
> > > > (+TC folks and netdev@)
> > > >
> > > > On Fri, Oct 07, 2022 at 02:42:56PM +0200, Ilya Maximets wrote:
> > > > > On 10/7/22 13:37, Eelco Chaudron wrote:
> > >
> > > [...]
> > >
> > > > I don't see how we could achieve this without breaking much of the
> > > > user experience.
> > > >
> > > > >
> > > > > - or create something like act_count - a dummy action that only
> > > > >   counts packets, and put it in every datapath action from OVS.
> > > >
> > > > This seems the easiest and best way forward IMHO. It's actually the
> > > > 3rd option below but "on demand", considering that tc will already use
> > > > the stats of the first action as the flow stats (in
> > > > tcf_exts_dump_stats()), then we can patch ovs to add such action if a
> > > > meter is also being used (or perhaps even always, because other
> > > > actions may also drop packets, and for OVS we would really be at the
> > > > 3rd option below).
> > >
> > > Correct me if I'm wrong, but actually act_gact action with "pipe"
> > > control action should already do this counting job.
> >
> > act_gact is so transparent that I never see it/remembers about it :)
> > Yup, although it's not offloadabe with pipe control actio AFAICT.
> >
>
> It's mostly how people who offload (not sure about OVS) do it;
> example some of the switches out there.

You mean with OK, DROP, TRAP or GOTO actions, right?

Because for PIPE, it has:
                } else if (is_tcf_gact_pipe(act)) {
                        NL_SET_ERR_MSG_MOD(extack, "Offload of
\"pipe\" action is not supported");
                        return -EOPNOTSUPP;

Or maybe I'm missing something.

> The action index, whatever that action is, could be easily mapped
> to a stats index in hardware. If you are sharing action instances
> (eg policer index 32) across multiple flows then of course in hw
> you are using only that one instance of the meter. If you want
> to have extra stats that differentiate between the flows then
> add a gact (PIPE as Davide mentioned) and the only thing it
> will do is count and nothing else.

Yup, makes sense. And talking with Ilya, that's what OVS already does for DPDK
as well.

Thanks,
Marcelo

