Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DCF5F7B1D
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 18:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiJGQAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 12:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJGP77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 11:59:59 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811942648D
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 08:59:54 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id l5so5973919oif.7
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 08:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7phJ8Bu0o5fGj/CGhfFW//+/olDYZlVnBdrHTNHzDdA=;
        b=iAIYiJOS7VSLmaxCXlM0CCXPzNVb1Rnc2RLcnqYBt8X8nUewEFESqx7N9jp2XRJA0M
         iGul9JVWT5gyoLFHE5fRSC2u3hIH4rUUjaOcUbrA4T2SahUeWhsPdYW0U09O5YG5kXhz
         9paSHPv5fzYYcJdg3vVYEyQZqVDKvpUhq/qYAamnyP1Zkcj++Tx9Dsw/aDAgpZZoxs65
         4KsQ0Ft02CU1PWGwJK1AT0f7AfYmRiSDsgo6PdMY0pV+irARCribjFC0oL+XOcPxjVQo
         XQvmBMEwEi7zG/jGa8Zu7586tOoDAj8QHekBRFAANLQLm1et6xcX9DOhsBgYc4ZB46Zx
         TB0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7phJ8Bu0o5fGj/CGhfFW//+/olDYZlVnBdrHTNHzDdA=;
        b=Q0N8iZohMCYTrlVGdGN1hzj0BIx7ZRE/7VNJp8BWm4fhfQwWDQHFaHfY3rJgBdoPq3
         jnz7r+suPvHhjRCtriF+0SkT2acWfNMPf/9kQP8VJcmZA5hKJUY54sS62mfNYzEEe/MN
         CADiKnw5xss/2csrLtoCUOF2X2LJI+imskp1M97jU42XbC6sSM1u9xXyvY1guv+2kLzL
         OmETLxRyPUeX6tDh/+6FHey6TmXgX7WyaHTIYo5uM5BZKMtTr6+x2xwr48XhBkRVbZdT
         ToCMmzMgnJruN5AkGkJzUmUTFoos0fgCFT74+9M0rcNCRF9MZL+1GRZer6Gm1cgBrbFO
         fuAw==
X-Gm-Message-State: ACrzQf1cvnXQbmFHLoSgl1iBFXZ9wBeArYfmFp/KAmxUNiZ1behsoCN8
        nKwl+s/bHZUZT0bgIx1gLoh//aioOcN3FXop4dl5bQ==
X-Google-Smtp-Source: AMsMyM5QS6JNyS1OcYtsorK6/pHDjfBZszNUODO9QsS3aLgsKeUvfZVL2rgkJQeTSk/hdY211pHD7WGn76b5yH2b3QU=
X-Received: by 2002:a05:6808:1997:b0:34f:d372:b790 with SMTP id
 bj23-20020a056808199700b0034fd372b790mr2762500oib.2.1665158393865; Fri, 07
 Oct 2022 08:59:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220914141923.1725821-1-simon.horman@corigine.com>
 <eeb0c590-7364-a00e-69fc-2326678d6bdf@ovn.org> <PH0PR13MB4793A85169BB60B8609B192194499@PH0PR13MB4793.namprd13.prod.outlook.com>
 <0aac2127-0b14-187e-0adb-7d6b8fe8cfb1@ovn.org> <e71b2bf2-cfd5-52f4-5fd4-1c852f2a8c6c@ovn.org>
 <00D45065-3D74-4C4C-8988-BFE0CEB3BE2F@redhat.com> <fe0cd650-0d4a-d871-5c0b-b1c831c8d0cc@ovn.org>
 <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com>
 <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com> <CALnP8ZaZ5zGD4sP3=SSvC=RBmVOOcc9MdA=aaYRQctaBOhmHfQ@mail.gmail.com>
In-Reply-To: <CALnP8ZaZ5zGD4sP3=SSvC=RBmVOOcc9MdA=aaYRQctaBOhmHfQ@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 7 Oct 2022 11:59:42 -0400
Message-ID: <CAM0EoM=zWBzivTkEG7uBJepZ0=OZmiuqDF3RmgdWA=FgznRF6g@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH] tests: fix reference output for meter offload stats
To:     Marcelo Leitner <mleitner@redhat.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Tianyu Yuan <tianyu.yuan@corigine.com>,
        Simon Horman <simon.horman@corigine.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 7, 2022 at 11:01 AM Marcelo Leitner <mleitner@redhat.com> wrote:
>
> On Fri, Oct 07, 2022 at 04:39:25PM +0200, Davide Caratti wrote:
> > On Fri, Oct 7, 2022 at 3:21 PM Marcelo Leitner <mleitner@redhat.com> wrote:
> > >
> > > (+TC folks and netdev@)
> > >
> > > On Fri, Oct 07, 2022 at 02:42:56PM +0200, Ilya Maximets wrote:
> > > > On 10/7/22 13:37, Eelco Chaudron wrote:
> >
> > [...]
> >
> > > I don't see how we could achieve this without breaking much of the
> > > user experience.
> > >
> > > >
> > > > - or create something like act_count - a dummy action that only
> > > >   counts packets, and put it in every datapath action from OVS.
> > >
> > > This seems the easiest and best way forward IMHO. It's actually the
> > > 3rd option below but "on demand", considering that tc will already use
> > > the stats of the first action as the flow stats (in
> > > tcf_exts_dump_stats()), then we can patch ovs to add such action if a
> > > meter is also being used (or perhaps even always, because other
> > > actions may also drop packets, and for OVS we would really be at the
> > > 3rd option below).
> >
> > Correct me if I'm wrong, but actually act_gact action with "pipe"
> > control action should already do this counting job.
>
> act_gact is so transparent that I never see it/remembers about it :)
> Yup, although it's not offloadabe with pipe control actio AFAICT.
>

It's mostly how people who offload (not sure about OVS) do it;
example some of the switches out there.
The action index, whatever that action is, could be easily mapped
to a stats index in hardware. If you are sharing action instances
(eg policer index 32) across multiple flows then of course in hw
you are using only that one instance of the meter. If you want
to have extra stats that differentiate between the flows then
add a gact (PIPE as Davide mentioned) and the only thing it
will do is count and nothing else.

cheers,
jamal
