Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DAD4BB808
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbiBRL32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:29:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiBRL31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:29:27 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73ED727AFF1;
        Fri, 18 Feb 2022 03:29:10 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id p9so14299050ejd.6;
        Fri, 18 Feb 2022 03:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0FW/pU/f32V5+RIYnmQVW0sV/WL9/PnhYjJBJ0552cI=;
        b=Nc3L9PI1T2qbTsfrZZIfEVMfH4hzjOxTjxf7aqWZogkvqv/pR4A0e5OStS0tk6nKXu
         nzaYwx484mNgD9RZta2nT8Phada2G6gc1s43Tke1qYwscBLbMeylyydcc3YVxYoHOK4R
         xKbcStRnnUCAoFlugCuOPxqGGE0dKahfpu2U5/jn9LWSwgGpNECNOAP/xazJyr1xOlky
         8tp4Y4c1wSMn56L1ISQG9d+Dt2klROs8QrhYRxpCrS+hl9FNxE+CmubStR7Uz/CAXT15
         j2bOqc00mLUzwsT46UPkq6KvCjuvYeLXrDnIXwcW5YTxKruBzI3sCLfGR0+5TzjcO6py
         d6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0FW/pU/f32V5+RIYnmQVW0sV/WL9/PnhYjJBJ0552cI=;
        b=6fzxGUyZWPkecFWkGOOrJYTb+2E1MuDPjq+LRi2nz5jHJXlnV4Dl8OVDEWovVJtR03
         3S2JxRzH318yoWSxPSqm8x/7utAnsMLfyBSMvS6wlCu6i32X5BPG0ruqNZ5fNj7PDmRE
         0oKWksbEKExN1smv9EXMDE9ecxeuFbbP94biCPf3gsYUZYFdSJBVjGTh58woqbkIa+G1
         c57HAxWzH9OLSAr4bdKvt01nofm4CNteWj/kunI6Yp9VIgnsFWBw1XeHu7BAxZ0h8KNp
         sW9jYAUAsQSakm/OWRKAD8aq+J+qQj/87TJ7IARuTWWEzLE8dbTMX4N49MyiXzAfRpmF
         23Zg==
X-Gm-Message-State: AOAM5314juBUlc+U6F4DHcZ0SXDHb+Mu3JsYSLsxtHn4u+jS5AcCoTYt
        1Z29WeJB6wrtjoQ5RuGdcRYBaoVIy7shLXDvLYo=
X-Google-Smtp-Source: ABdhPJwGfrdenixaslfGWFGSsI5SffGvoPfA9HDVXTQR/cJyp/DbTfwwF7iXzIUFhK/MD7pjXgHnLKHL84fjvE1TH9Q=
X-Received: by 2002:a17:906:4116:b0:6cd:1980:5ad0 with SMTP id
 j22-20020a170906411600b006cd19805ad0mr6390417ejk.595.1645183748929; Fri, 18
 Feb 2022 03:29:08 -0800 (PST)
MIME-Version: 1.0
References: <20220217160528.2662513-1-hardware.evs@gmail.com> <AM6PR04MB39761CAFB51985AFC203C535EC379@AM6PR04MB3976.eurprd04.prod.outlook.com>
In-Reply-To: <AM6PR04MB39761CAFB51985AFC203C535EC379@AM6PR04MB3976.eurprd04.prod.outlook.com>
From:   EVS Hardware Dpt <hardware.evs@gmail.com>
Date:   Fri, 18 Feb 2022 12:28:57 +0100
Message-ID: <CAEDiaShTrWgA75e8x2deHMHF-53LFiusrVHTxP_Jy4gvaLg_9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
 rx_extra_headroom config from devicetree.
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Madalin, Guys

I know, but it's somewhat difficult to use those parameters on kernel's
command line.
I don't think it's wrong to also add that in devicetree.
No removal, just an added feature.

For ethernet node in devicetree, there are a lot of configuration stuff lik=
e
max-frame-size to allow configuration of MTU
(and so potentially enable jumbo) and it's regarded as fine.

It's also the goal of this patch. Allow an easy configuration of
fsl_fm_max_frm from a dts. I added rx_extra_headroom for the sake of
completeness.

So I plead for this addition because I don't think it's wrong to do that an=
d
I consider it's nicer to add an optional devicetree property rather than
adding a lot of obscure stuff on kernel's command line.

Hope you'll share my point of view.

Have a nice weekend Madalin, Guys,
Fred.

Le ven. 18 f=C3=A9vr. 2022 =C3=A0 08:23, Madalin Bucur <madalin.bucur@nxp.c=
om> a =C3=A9crit :
>
> > -----Original Message-----
> > From: Fred Lefranc <hardware.evs@gmail.com>
> > Subject: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
> > rx_extra_headroom config from devicetree.
> >
> > Allow modification of two additional Frame Manager parameters :
> > - FM Max Frame Size : Can be changed to a value other than 1522
> >   (ie support Jumbo Frames)
> > - RX Extra Headroom
> >
> > Signed-off-by: Fred Lefranc <hardware.evs@gmail.com>
>
> Hi, Fred,
>
> there are module params already for both, look into
>
> drivers/net/ethernet/freescale/fman/fman.c
>
> for fsl_fm_rx_extra_headroom and fsl_fm_max_frm.
>
> Regards,
> Madalin
