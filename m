Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEA25F7510
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 10:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiJGIJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 04:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiJGIJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 04:09:13 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4DEB8C18
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 01:09:11 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 10so6195452lfy.5
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 01:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=1LM8BrE+lT990zTpq2Ri2Btyxx5NaMTdCH1GeUVOqNY=;
        b=Q+Mxgbs1wqmWg2gKZgO+D7/+ztdce2XtH6jkL4cZXqmxJXMWL26/W9X4JeW2ebBqCY
         6FUJZniHBI6ajqXzvruG/vwiL2xXs0Ny8DLFayb5IRt42bVoDhfL14vRY0WxMvtUpVon
         7FtLSENL5ubITuNSSVX4b5IK4uREb2lYAWAmvlaZD/ZgxZdAkD0R/1XeSnF2QVNx8Egf
         F4lLqEMUHvlOrB2WZCJU+IrADmhh9fxSajuZd6rr5UtEih/ihAkO+xxH6vCj02a+JolO
         J6RwrehyZCOP7HXmQ94k6irpUwNLQH6ZuxsNY5wFsrh0vsZRl6I/6vVIiygPSNQj86w1
         sfHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=1LM8BrE+lT990zTpq2Ri2Btyxx5NaMTdCH1GeUVOqNY=;
        b=WB1XtahSBpMns1WcEQFYdrd/Tfjle1hPueP32agPpD2A9qcelTu1XAeiaylwoI8FUm
         vWdDPqluC7L3T/LVT6SZu6/Lkls3oL/EVX01AL9dqcbWDmB6kNFtqgPQ175k6jhK9S3z
         Gefmp5vtgQkR4+80WEYV0lKvO/+f+2SqDBOhnGIFEfpOTMmphxYhPdD/NeAtO8qhAqnP
         J7bMMFndnTyCR304Zfht2zPKKcxC05DBR/r61c6mxI8KcSNvPUWN/XxgVLbi7YbyjSdG
         sAjy5U53OcDE/Bp1m9UlDHiWuCdBIUUkkcZfg2pJZulM53rL8zCxM94shjMAJeEdfuAg
         Q+Qg==
X-Gm-Message-State: ACrzQf1v2++vLoMrd8fH3dWnxHG23Ftdqq4/O4q0tYUHhcARU8jEovN1
        HyICXaxfh2zn5UBiDw8OwcUhcMaQLo9KiVuXBYcG0s8J4rI=
X-Google-Smtp-Source: AMsMyM6KBsKXnn9vdqw62b7sBvhG0nwAVh/808VwVz1ttzXzdGm9XUpAy8ohl4M6IJqYNvCWiyjGSsrXfoLIQXY0R3U=
X-Received: by 2002:a05:6512:2014:b0:4a2:6c86:d995 with SMTP id
 a20-20020a056512201400b004a26c86d995mr1500447lfb.632.1665130139329; Fri, 07
 Oct 2022 01:08:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220928152509.141490-1-shenwei.wang@nxp.com> <YzT2An2J5afN1w3L@lunn.ch>
 <PAXPR04MB9185141B58499FD00C43BB6889579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <YzWcI+U1WYJuZIdk@lunn.ch> <PAXPR04MB918545B92E493CB57CDE612B89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <ae658987-8763-c6de-7198-1a418e4728b4@redhat.com> <PAXPR04MB918584422BE4ECAF79C0295A89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <afb652db-05fc-d3d6-6774-bfd9830414d9@redhat.com> <PAXPR04MB9185743919EC6DDA54FAC3B7895B9@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <4f7cf74d-95ca-f93f-7328-e0386348a06e@redhat.com> <AS8PR04MB9176281109667B36CB694763895A9@AS8PR04MB9176.eurprd04.prod.outlook.com>
 <AS8PR04MB917670AAD2045CEBC122FEE1895A9@AS8PR04MB9176.eurprd04.prod.outlook.com>
 <PAXPR04MB918565DF416D879FF9232A6C895D9@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <eb8d097b-e53b-ed09-f598-71cac24edb7c@redhat.com>
In-Reply-To: <eb8d097b-e53b-ed09-f598-71cac24edb7c@redhat.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Fri, 7 Oct 2022 11:08:23 +0300
Message-ID: <CAC_iWjJ7AgpSZeOW+K8nMwgmZ-zC3h_nsfvGsJRrY2Aq2UVqSA@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Shenwei Wang <shenwei.wang@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        brouer@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper,

On Thu, 6 Oct 2022 at 11:37, Jesper Dangaard Brouer <jbrouer@redhat.com> wr=
ote:
>
>
>
> On 05/10/2022 14.40, Shenwei Wang wrote:
> > Hi Jesper,
> >
> > Here is the summary of "xdp_rxq_info" testing.
> >
> >                skb_mark_for_recycle           page_pool_release_page
> >
> >               Native        SKB-Mode           Native          SKB-Mode
> > XDP_DROP     460K           220K              460K             102K
> > XDP_PASS     80K            113K              60K              62K
> >
>
> It is very pleasing to see the *huge* performance benefit that page_pool
> provide when recycling pages for SKBs (via skb_mark_for_recycle).
> I did expect a performance boost, but not around a x2 performance boost.

Indeed that's a pleasant surprise.  Keep in mind that if we convert
more driver we
can also get rid of copy_break code sprinkled around in drivers.

Thanks
/Ilias
>
> I guess this platform have a larger overhead for DMA-mapping and
> page-allocation.
>
> IMHO it would be valuable to include this result as part of the patch
> description when you post the XDP patch again.
>
> Only strange result is XDP_PASS 'Native' is slower that 'SKB-mode'. I
> cannot explain why, as XDP_PASS essentially does nothing and just follow
> normal driver code to netstack.
>
> Thanks a lot for doing these tests.
> --Jesper
>
> > The following are the testing log.
> >
> > Thanks,
> > Shenwei
> >
> > ### skb_mark_for_recycle solution ###
> >
> > ./xdp_rxq_info --dev eth0 --act XDP_DROP --read
> >
> > Running XDP on dev:eth0 (ifindex:2) action:XDP_DROP options:read
> > XDP stats       CPU     pps         issue-pps
> > XDP-RX CPU      0       466,553     0
> > XDP-RX CPU      total   466,553
> >
> > ./xdp_rxq_info -S --dev eth0 --act XDP_DROP --read
> >
> > Running XDP on dev:eth0 (ifindex:2) action:XDP_DROP options:read
> > XDP stats       CPU     pps         issue-pps
> > XDP-RX CPU      0       226,272     0
> > XDP-RX CPU      total   226,272
> >
> > ./xdp_rxq_info --dev eth0 --act XDP_PASS --read
> >
> > Running XDP on dev:eth0 (ifindex:2) action:XDP_PASS options:read
> > XDP stats       CPU     pps         issue-pps
> > XDP-RX CPU      0       80,518      0
> > XDP-RX CPU      total   80,518
> >
> > ./xdp_rxq_info -S --dev eth0 --act XDP_PASS --read
> >
> > Running XDP on dev:eth0 (ifindex:2) action:XDP_PASS options:read
> > XDP stats       CPU     pps         issue-pps
> > XDP-RX CPU      0       113,681     0
> > XDP-RX CPU      total   113,681
> >
> >
> > ### page_pool_release_page solution ###
> >
> > ./xdp_rxq_info --dev eth0 --act XDP_DROP --read
> >
> > Running XDP on dev:eth0 (ifindex:2) action:XDP_DROP options:read
> > XDP stats       CPU     pps         issue-pps
> > XDP-RX CPU      0       463,145     0
> > XDP-RX CPU      total   463,145
> >
> > ./xdp_rxq_info -S --dev eth0 --act XDP_DROP --read
> >
> > Running XDP on dev:eth0 (ifindex:2) action:XDP_DROP options:read
> > XDP stats       CPU     pps         issue-pps
> > XDP-RX CPU      0       104,443     0
> > XDP-RX CPU      total   104,443
> >
> > ./xdp_rxq_info --dev eth0 --act XDP_PASS --read
> >
> > Running XDP on dev:eth0 (ifindex:2) action:XDP_PASS options:read
> > XDP stats       CPU     pps         issue-pps
> > XDP-RX CPU      0       60,539      0
> > XDP-RX CPU      total   60,539
> >
> > ./xdp_rxq_info -S --dev eth0 --act XDP_PASS --read
> >
> > Running XDP on dev:eth0 (ifindex:2) action:XDP_PASS options:read
> > XDP stats       CPU     pps         issue-pps
> > XDP-RX CPU      0       62,566      0
> > XDP-RX CPU      total   62,566
> >
> >> -----Original Message-----
> >> From: Shenwei Wang
> >> Sent: Tuesday, October 4, 2022 8:34 AM
> >> To: Jesper Dangaard Brouer <jbrouer@redhat.com>; Andrew Lunn
> >> <andrew@lunn.ch>
> >> Cc: brouer@redhat.com; David S. Miller <davem@davemloft.net>; Eric Dum=
azet
> >> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> >> <pabeni@redhat.com>; Alexei Starovoitov <ast@kernel.org>; Daniel Borkm=
ann
> >> <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John
> >> Fastabend <john.fastabend@gmail.com>; netdev@vger.kernel.org; linux-
> >> kernel@vger.kernel.org; imx@lists.linux.dev; Magnus Karlsson
> >> <magnus.karlsson@gmail.com>; Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>;=
 Ilias
> >> Apalodimas <ilias.apalodimas@linaro.org>
> >> Subject: RE: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
> >>
> >>
> >>
> >>> -----Original Message-----
> >>> From: Shenwei Wang
> >>> Sent: Tuesday, October 4, 2022 8:13 AM
> >>> To: Jesper Dangaard Brouer <jbrouer@redhat.com>; Andrew Lunn
> >> ...
> >>> I haven't tested xdp_rxq_info yet, and will have a try sometime later=
 today.
> >>> However, for the XDP_DROP test, I did try xdp2 test case, and the
> >>> testing result looks reasonable. The performance of Native mode is
> >>> much higher than skb- mode.
> >>>
> >>> # xdp2 eth0
> >>>   proto 0:     475362 pkt/s
> >>>
> >>> # xdp2 -S eth0             (page_pool_release_page solution)
> >>>   proto 17:     71999 pkt/s
> >>>
> >>> # xdp2 -S eth0             (skb_mark_for_recycle solution)
> >>>   proto 17:     72228 pkt/s
> >>>
> >>
> >> Correction for xdp2 -S eth0  (skb_mark_for_recycle solution)
> >> proto 0:          0 pkt/s
> >> proto 17:     122473 pkt/s
> >>
> >> Thanks,
> >> Shenwei
> >
>
