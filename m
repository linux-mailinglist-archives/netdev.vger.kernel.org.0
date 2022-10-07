Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A145F7A31
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 17:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiJGPBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 11:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiJGPBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 11:01:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59427DD897
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 08:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665154896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EFV6S6f0TjTN8FXxp6obvTNw8TtgyUV+Wd8LBgcgjiQ=;
        b=i51xduMQhsIprvH4Mdbkljm+bUSPiNnBfcIsEwKbsXS2xOlYhrlQ05XsNzAEvNLeo5mFe5
        yOVIv/E8M9dYlHcxkWhpTr+xN+Bc+fkUSs4vQDiKaP7EpoLFMc9t4boN4C/jINIjYA5Xp0
        NBp3Zjw7g4wpJJf+ZqbDnAJEVqlMXAY=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-318-NmxYMbR-MLKpQMQAAcTaxg-1; Fri, 07 Oct 2022 11:01:34 -0400
X-MC-Unique: NmxYMbR-MLKpQMQAAcTaxg-1
Received: by mail-io1-f69.google.com with SMTP id d24-20020a05660225d800b006a466ec7746so3383229iop.3
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 08:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EFV6S6f0TjTN8FXxp6obvTNw8TtgyUV+Wd8LBgcgjiQ=;
        b=yNCAAFOunDy8KmIdCV+ZqeB5O0lHLRZT4gnRCBiwGAqYX5Y7P5fWGmWzqcntcpJ9ua
         xqYNX6GqZPTGhhWImffgfuRpj5s8l2S5L26w7+4D3V5+PHWlayC7wa677Iy7nThX6hRk
         xgJGpCdJTK/48ffsKrr7j9VSc9svVcs4cY56vLIKjcLvkNMfaqLqN3wF3g8hjZKWAJV9
         J8zhQm2srJK/qraS1uOVvtWTW1fpZ+NCyIdtTiF5TCvPSUXyvKXrdPsTw2SNBTqqNSNz
         eP+O+rUe+EbILfKfO1AXoKb6oH8aVDm17ucLhEofhIWU2Y8rguFVQWE89FVmEQveozzE
         Pnkg==
X-Gm-Message-State: ACrzQf3TVIatBVizUyJ7FIfrrxqA0l5o8UO6+odoyxiYNc9FoA/c9vRS
        3dUr4iZjan7rxOIp/3UnWIeVYKu798WoyBNdcPCuLvZdi5a9nxitzGhQ+jBDXIavr3OiFVkN4Ju
        gerhT4iHzztoxLjMI271d4gtuy3biwaQa
X-Received: by 2002:a05:6e02:1688:b0:2f8:3768:a620 with SMTP id f8-20020a056e02168800b002f83768a620mr2542636ila.98.1665154893892;
        Fri, 07 Oct 2022 08:01:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5MMKEHny44Sz47Wz5xBo4i5a9Vp7gDSPQ/kY+iuHKtO5nM5NX8XLvCyVklWN94njJYvAQ++wlArEK/HltmjUI=
X-Received: by 2002:a05:6e02:1688:b0:2f8:3768:a620 with SMTP id
 f8-20020a056e02168800b002f83768a620mr2542607ila.98.1665154893676; Fri, 07 Oct
 2022 08:01:33 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 7 Oct 2022 08:01:33 -0700
From:   Marcelo Leitner <mleitner@redhat.com>
References: <20220914141923.1725821-1-simon.horman@corigine.com>
 <eeb0c590-7364-a00e-69fc-2326678d6bdf@ovn.org> <PH0PR13MB4793A85169BB60B8609B192194499@PH0PR13MB4793.namprd13.prod.outlook.com>
 <0aac2127-0b14-187e-0adb-7d6b8fe8cfb1@ovn.org> <e71b2bf2-cfd5-52f4-5fd4-1c852f2a8c6c@ovn.org>
 <00D45065-3D74-4C4C-8988-BFE0CEB3BE2F@redhat.com> <fe0cd650-0d4a-d871-5c0b-b1c831c8d0cc@ovn.org>
 <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com> <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
Date:   Fri, 7 Oct 2022 08:01:32 -0700
Message-ID: <CALnP8ZaZ5zGD4sP3=SSvC=RBmVOOcc9MdA=aaYRQctaBOhmHfQ@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH] tests: fix reference output for meter offload stats
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Tianyu Yuan <tianyu.yuan@corigine.com>,
        Simon Horman <simon.horman@corigine.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
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

On Fri, Oct 07, 2022 at 04:39:25PM +0200, Davide Caratti wrote:
> On Fri, Oct 7, 2022 at 3:21 PM Marcelo Leitner <mleitner@redhat.com> wrote:
> >
> > (+TC folks and netdev@)
> >
> > On Fri, Oct 07, 2022 at 02:42:56PM +0200, Ilya Maximets wrote:
> > > On 10/7/22 13:37, Eelco Chaudron wrote:
>
> [...]
>
> > I don't see how we could achieve this without breaking much of the
> > user experience.
> >
> > >
> > > - or create something like act_count - a dummy action that only
> > >   counts packets, and put it in every datapath action from OVS.
> >
> > This seems the easiest and best way forward IMHO. It's actually the
> > 3rd option below but "on demand", considering that tc will already use
> > the stats of the first action as the flow stats (in
> > tcf_exts_dump_stats()), then we can patch ovs to add such action if a
> > meter is also being used (or perhaps even always, because other
> > actions may also drop packets, and for OVS we would really be at the
> > 3rd option below).
>
> Correct me if I'm wrong, but actually act_gact action with "pipe"
> control action should already do this counting job.

act_gact is so transparent that I never see it/remembers about it :)
Yup, although it's not offloadabe with pipe control actio AFAICT.

  Marcelo

