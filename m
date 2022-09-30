Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB795F1107
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 19:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbiI3Rjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 13:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiI3Rjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 13:39:45 -0400
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014FE63F8;
        Fri, 30 Sep 2022 10:39:37 -0700 (PDT)
Received: by mail-qk1-f174.google.com with SMTP id 3so3257924qka.5;
        Fri, 30 Sep 2022 10:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=N8mI8UTtYw4tqhx/SpyLW2KXywh682BjJEpPuPB5RK8=;
        b=zza6M3ytDEKAzydyndqKGKalgkEdTflvG+1mVsOmpzJVSEfQyM1NmEn0S1pOg53NiD
         n/oKD0SJf++HmZZOxUNk1xbMU3bRVVVEPkWuQ/LRqYNiRangkq8Cv0vcmzWrUv0sE+eF
         ylZZEiuf9HiDn3otQKqX+Gt4ZRdzOtbLICSZzYpXc3Bn5CMALFP1gRWoeFJDHrXI9dEw
         vzTiteAg/odRDSxTW0++J+kmhxVN0+IZOeWFg8kSpiCrbFxBnJK7Kw2pwwsKWQQ18Y+9
         oP9yfzSwcQdb2PnGJ91lhFK55L/UKW076ReFyudxrgfX4R6Aas6AcWUcvQ1UoDnDgKwE
         sRMg==
X-Gm-Message-State: ACrzQf3heoTHuLle29KFoFXqqdcVVzcLFeyqdrSGJR3fLN/BZBK2uQyc
        q/JzPuKmsdju9DRQIrk3cF+FvFuzKujEzwH56jg=
X-Google-Smtp-Source: AMsMyM5Be2M9430vaNDQKWi5Jn7X5sqcjjBRWlaB305zeNKwPI8Niz3+jSeejZPUTnTD+6uF7YXR9Lo8HGSlB5J32Ng=
X-Received: by 2002:a05:620a:46ac:b0:6ce:3e55:fc21 with SMTP id
 bq44-20020a05620a46ac00b006ce3e55fc21mr6841047qkb.285.1664559576163; Fri, 30
 Sep 2022 10:39:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220928210059.891387-1-daniel.lezcano@linaro.org>
 <d0be3159-8094-aed1-d9b1-c4b16d88d67c@linaro.org> <CAJZ5v0hOFoe0KqEimFv9pgmiAOzuRoLjdqoScr53ErNFU4AAPA@mail.gmail.com>
 <ae86fc5a-0521-3dde-c2ea-8679c0ec4831@linaro.org> <CAJZ5v0jrWamTTXcHabSk=6cmm4pEx0_ebiECKZRfrX_vS85YYg@mail.gmail.com>
In-Reply-To: <CAJZ5v0jrWamTTXcHabSk=6cmm4pEx0_ebiECKZRfrX_vS85YYg@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 30 Sep 2022 19:39:25 +0200
Message-ID: <CAJZ5v0gnfK2MBuzZi-C03VVO+b4dthckJcdj3zLo3q-qAUyy_g@mail.gmail.com>
Subject: Re: [PATCH v7 00/29] Rework the trip points creation
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Kaestle <peter@piie.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Amit Kucheria <amitk@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-rpi-kernel@lists.infradead.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 9:35 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Thu, Sep 29, 2022 at 4:57 PM Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
> >
> > On 29/09/2022 15:58, Rafael J. Wysocki wrote:
> > > On Thu, Sep 29, 2022 at 2:26 PM Daniel Lezcano
> > > <daniel.lezcano@linaro.org> wrote:
> > >>
> > >>
> > >> Hi Rafael,
> > >>
> > >> are you happy with the changes?
> > >
> > > I'll have a look and let you know.
> >
> > Great, thanks
>
> Well, because you have not added the history of changes to the
> patches, that will take more time than it would otherwise.

Done.  I've sent ACKs and still had a comment on one patch (minor but
still).  When that is addressed, the four initial core patches should
be good to go in.

I'm trusting you regarding the thermal/of changes (even though I think
that it would be good if someone involved in that code could review
them) and if you are confident about all of the driver changes, they
are fine with me too.
