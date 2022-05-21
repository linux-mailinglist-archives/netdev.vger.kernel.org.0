Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62F552FE8F
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 19:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344169AbiEUR1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 13:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344163AbiEUR1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 13:27:11 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9713CA49
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 10:27:10 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id g184so10272175pgc.1
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 10:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p4WDxDiVWNzE6Ed2dTUVBgIIJHIgebfp/UAmQKOT05M=;
        b=fPEyMLlxWQWAP61tegfSgblAyQRGWS1gLk+IYo8FzrHb137M1pKE57MzOeT6CgkF0w
         KL47Lp1v4aywQVaRRlRdjf1takPPiEduvQT1831MzX4SI0nP15DQUnPdzwmj7E6fbPyq
         S/Mk615aGcTCzUfkg638OhEyqEQefR73dhf29jdYiDGVvnriwdMUua0tTVyCEHG0Yplv
         vKrTnQo5y90cGdxZ7pnoSdIxfF/ps1UYJf2o+xlRXoj4kCiSO/0hIWkqzuAedC61CGaG
         zW+7ElQsGWG3LeWg1wCVsH52TSY7f3Uw1Hz0P7biiIjgmbRsuTHh2NsE8LW7eyqwh11A
         vGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p4WDxDiVWNzE6Ed2dTUVBgIIJHIgebfp/UAmQKOT05M=;
        b=06F0z7DOCro1OzB+B//QANeRWaiiU0wcYzN8lpTRDYjd36juakg4IXxI8We3uoH9G1
         DWeVPBOs1/Z5DpVB+fsoPg+df5WD9PVInqGEByMFbSlttnu8qc2ztx6ENvIvnGmioglZ
         iiya2DOhXLPa/DVFuEO2pu7IF7ZQPc+rA0KWyedwTZhn/npdmeRitPVcq3/NTUPGwtoI
         PsRO65Kv/mBhYclqjcsiRwfjVOjoLAp1yCe0nAvKtbLab9M48YSTSLg2L12hdnWow1G7
         bKL7NqMU0xNn867K2M0L1HXo6/46Xjd64WQ+OVg3Jlyz/TPgCCjkuLJFjOY1JUqb7C+S
         AnNQ==
X-Gm-Message-State: AOAM533gXIo2PJP8KrGPH3Xqymxx3XPc9qmaoVWbmHAxdiO454+jU4ok
        FK2McbdcJJaSYEur0VedWOVzvDwCLwAffYP+4a7k5w==
X-Google-Smtp-Source: ABdhPJylwWu979YYJ1WKcQb/5oA+gVrS/LbsKuwQwjq0aRbd2SzVL5AVfi8W1hSLM0CvVCSx8ehGnX8hgBnqpDHgv2g=
X-Received: by 2002:a63:31d3:0:b0:3f5:d1f4:5f95 with SMTP id
 x202-20020a6331d3000000b003f5d1f45f95mr13297421pgx.178.1653154030048; Sat, 21
 May 2022 10:27:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220519074351.829774-1-william.xuanziyang@huawei.com>
 <CAMZdPi9z=OM0=yZbBu0eDvFd30efNpt3qmDHuCTj6LGJxdBTbw@mail.gmail.com>
 <20220520172556.1d62b899@kernel.org> <20220520180111.7e9b2b84@kernel.org>
In-Reply-To: <20220520180111.7e9b2b84@kernel.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Sat, 21 May 2022 19:26:34 +0200
Message-ID: <CAMZdPi85RJUXWkaJV8EZO00eM_RaGj=3ix0L-H3ynDpRxKBWFw@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: wwan: t7xx: fix GFP_KERNEL usage in
 spin_lock context
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>,
        chandrashekar.devegowda@intel.com,
        chiranjeevi.rapolu@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, haijun.liu@mediatek.com,
        johannes@sipsolutions.net, linuxwwan@intel.com,
        m.chetan.kumar@linux.intel.com, netdev@vger.kernel.org,
        pabeni@redhat.com, ricardo.martinez@linux.intel.com,
        ryazanov.s.a@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le sam. 21 mai 2022 =C3=A0 03:01, Jakub Kicinski <kuba@kernel.org> a =C3=A9=
crit :
>
> On Fri, 20 May 2022 17:25:56 -0700 Jakub Kicinski wrote:
> > On Thu, 19 May 2022 09:29:12 +0200 Loic Poulain wrote:
> > > On Thu, 19 May 2022 at 09:26, Ziyang Xuan <william.xuanziyang@huawei.=
com> wrote:
> > > >
> > > > t7xx_cldma_clear_rxq() call t7xx_cldma_alloc_and_map_skb() in spin_=
lock
> > > > context, But __dev_alloc_skb() in t7xx_cldma_alloc_and_map_skb() us=
es
> > > > GFP_KERNEL, that will introduce scheduling factor in spin_lock cont=
ext.
> > > >
> > > > Because t7xx_cldma_clear_rxq() is called after stopping CLDMA, so w=
e can
> > > > remove the spin_lock from t7xx_cldma_clear_rxq().
> > > >
> > > > Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
> > > > Suggested-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> > > > Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> > >
> > > Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> >
> > Wait, you reviewed two different fixes for the same issue?
> > Please say something when that happens I thought both are needed :/


Right, I've actually overlooked that the other patch has only one
atomic user, which becomes useless with this change.

>
>
> FWIW I pushed out the other one before I realized (they both apply
> without conflicts so I thought they fixed different issues)
> If this one is preferred please respin and squash a revert of
>
>
> 9ee152ee3ee3 into it.

Yes this one is preferred, I'll respin it. Sorry for this.

Thanks,
Loic
