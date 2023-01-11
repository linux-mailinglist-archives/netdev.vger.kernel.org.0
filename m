Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A3666594D
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 11:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbjAKKrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 05:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237980AbjAKKrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 05:47:25 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F4412AA2
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 02:47:23 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 7so10262572pga.1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 02:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GjitaCz/hk6YfV1W4HIZDAHa41L/xLHca2rqUeyrDp8=;
        b=MjKTVmUUeXgoQSe88e85BwskYnR3J484S2tD0q6TtMMOscV//tk6F6fm/qWp0/iS0s
         IfdMkLmbmMGZv7KtapSrco89tlsROXPE6aI7h7I8J5gtjVuDoedqep7TCe0MC1ZxtKfS
         WUrf/1wx31DN8zCbKiCB7PmAWEPCc9rOZwf4xNtpLw1Gqnd2KATdjOAIxTv7gerRxsJ4
         vIKPlwvqKzzXxsQDaDFSIc9iNDi8uQDrYWzm0EcS2offltZZE4K2sl6aqQq1Bu2UAuMI
         b9RxP1eVogrPeicR135p9c4QhhRGOtE1P4Wv70NvOk/Ct83Z3ZNfarpCI38mg8DnhdCB
         zhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GjitaCz/hk6YfV1W4HIZDAHa41L/xLHca2rqUeyrDp8=;
        b=kXqQDmobR49yL3RV0K5LiV1EuoOBv+m/di9JfMM+LCmusaHM5RYlk8MvkowDgedqev
         eBMAb1eqphe7TqSZJFIYnEjTWuJwlFWWIVOIQQok0wonZELMyCKuQaUqb0wXlwGA+XW6
         9kczpzFoEvpmhTMNQLgRdPJo8gBRshneIapjurBQ0NUn7t2iBX3TsCVhARx/VdarZC6l
         lU2DkfsyIlBXn5JpOcOCVKWt+bQDgCyUTjFerY1pXGarXQ6QjoMZuKTcnPLcKlyHqoFg
         DEsGWbV++E32ZRH0DNhYzjQRXLMAk8nmUa88rDi1RAPLGW7shypdbBUUJ1hF0jaofHIg
         xn6A==
X-Gm-Message-State: AFqh2kq/cVi4rYoER44h11jjyFO9yvbvm4jl9ORwT5XdK51GeOisLI1q
        8yxlKpSYDZ1qVOM0IZQhlMxy9Luzq8nIqPsyVem6PQ==
X-Google-Smtp-Source: AMrXdXsKLd/a7djt6fm62b5uPSdYXm9jYzDZvmKt35kqXvcCsEgx//F7llRyFrDnBRvtY68bOcPjna9LtM8fNKoHPl4=
X-Received: by 2002:a65:5b42:0:b0:489:88ed:9b28 with SMTP id
 y2-20020a655b42000000b0048988ed9b28mr4258688pgr.61.1673434043284; Wed, 11 Jan
 2023 02:47:23 -0800 (PST)
MIME-Version: 1.0
References: <20230111064842.5322-1-anand@edgeble.ai> <7148963.18pcnM708K@diego>
 <CACF1qnd=o+QWuofgAb+YXOs1R_dOuCPxWrb-+YEhuN4z8OnTrA@mail.gmail.com> <2917690.KRxA6XjA2N@diego>
In-Reply-To: <2917690.KRxA6XjA2N@diego>
From:   Anand Moon <anand@edgeble.ai>
Date:   Wed, 11 Jan 2023 16:17:13 +0530
Message-ID: <CACF1qnffL-YFJeoeU1nNJueKdb86bDfP2TuR4h1jn8ZZgHfCWw@mail.gmail.com>
Subject: Re: [PATCHv4 linux-next 3/4] Rockchip RV1126 has GMAC 10/100/1000M
 ethernet controller
To:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Johan Jonker <jbx6244@gmail.com>,
        Jagan Teki <jagan@edgeble.ai>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiko

On Wed, 11 Jan 2023 at 16:13, Heiko St=C3=BCbner <heiko@sntech.de> wrote:
>
> Am Mittwoch, 11. Januar 2023, 11:31:40 CET schrieb Anand Moon:
> > Hi Heiko,
> >
> > Thanks for your review comments.
> >
> > On Wed, 11 Jan 2023 at 15:41, Heiko St=C3=BCbner <heiko@sntech.de> wrot=
e:
> > >
> > > Hi,
> > >
> > > Am Mittwoch, 11. Januar 2023, 07:48:38 CET schrieb Anand Moon:
> > > > Add Ethernet GMAC node for RV1126 SoC.
> > > >
> > > > Signed-off-by: Anand Moon <anand@edgeble.ai>
> > > > Signed-off-by: Jagan Teki <jagan@edgeble.ai>
> > >
> > > patches 2-4 have this Signed-off-by from Jagan again where he is not
> > > not the author but also not the sender.
> >
> > We both work to fix this patch hence Jagan's SoB was added.
>
> ok, then I think the correct way to express that would be:
>
> Co-Developed-by: Jagan Teki <jagan@edgeble.ai>
> Signed-off-by: Jagan Teki <jagan@edgeble.ai>
> Signed-off-by: Anand Moon <anand@edgeble.ai>
>
Yes, you are right.

Thanks
-Anand
