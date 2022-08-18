Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA6E599138
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 01:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345772AbiHRXbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 19:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345778AbiHRXbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 19:31:14 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F16DDA87
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 16:31:13 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id o2so4069826lfb.1
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 16:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Rzm+KtIn754eMjCxQ82CIRKVVENOEzFQwaupdFFD6rg=;
        b=XlDDcYz7LkA3r9vk4JO6QqADVToOD+VhNaUP+9CpFskuaiTzzxtBqRPuyWO+AI8iu3
         OK3BAJujEr552Csc777cr9/3osRvBPGE++t6VCyDNk9XHRlWxwEk81fUpLrjFovfYNQD
         u62b13bTPH+lPwlL0RxEEx4zcZpHNydQjhhUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Rzm+KtIn754eMjCxQ82CIRKVVENOEzFQwaupdFFD6rg=;
        b=zs1joPjyA1mVVENu/opiIFNWpVaOv76TEAIBTzKIOYToHGaMl+WOq5uKp8FFOUNnsF
         X582PlA67hMGL3jwi4yGiQ79UdIaoCHL1pMfF+QHjFjxIlKIGi10EupbuAAKGGLng0oB
         CR0Ep2Ij88G8WZvrkp/sXqRkQXb1o/MU2A6/ICDYQl9cgimNme3btFX1ovEBNk4kiaV1
         RAcDPGEcxjpY6039CtMKx1ZGpWCn3hG7Wi0ogGJmyoIAsGonIQ2Gr0GQiM1RVbz897yH
         CakY6GY+zmAsIZHkpjVL8DOx3UlCaS8J9LtqCjOoJhC+NB65Kiw9ZzbGUSMv6GTBoUNM
         MFMw==
X-Gm-Message-State: ACgBeo2B2LrdovPnA9vQkf80WgPRiavbvhkrPO5ADXbgYsFfsF91Ze6x
        S4Z6wN8IQIFGsb298yRG2Pnyntrpi6bJoxyQCf4=
X-Google-Smtp-Source: AA6agR4JusrVU5qPj0FR3O7wweeE6dprenKcgyzc2uilu3MwhULDF4Tjno7jyfQXe7i9hfVP5njN6Q==
X-Received: by 2002:a05:6512:2285:b0:48a:e48b:4aa5 with SMTP id f5-20020a056512228500b0048ae48b4aa5mr1857775lfu.556.1660865471581;
        Thu, 18 Aug 2022 16:31:11 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id p3-20020a05651212c300b0048b18d65998sm399086lfg.38.2022.08.18.16.31.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 16:31:11 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id e15so4098658lfs.0
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 16:31:11 -0700 (PDT)
X-Received: by 2002:a05:6000:1541:b0:222:cf65:18d7 with SMTP id
 1-20020a056000154100b00222cf6518d7mr2611729wry.659.1660865460285; Thu, 18 Aug
 2022 16:31:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220727185012.3255200-1-saravanak@google.com>
 <Yvonn9C/AFcRUefV@atomide.com> <CM6REZS9Z8AC.2KCR9N3EFLNQR@otso>
 <CAGETcx_6oh=GVLP7-1gN_4DW7UHJ1MZQ6T1U2hupc_ZYDnXcNA@mail.gmail.com> <CM7HN6H9EAN4.2008QGJVIO14X@otso>
In-Reply-To: <CM7HN6H9EAN4.2008QGJVIO14X@otso>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 18 Aug 2022 16:30:47 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XYVwaXZxqUKAuM5c7NiVjFz5C6m6gAHSJ7rBXBF94_Tg@mail.gmail.com>
Message-ID: <CAD=FV=XYVwaXZxqUKAuM5c7NiVjFz5C6m6gAHSJ7rBXBF94_Tg@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] Bring back driver_deferred_probe_check_state() for now
To:     Luca Weiss <luca.weiss@fairphone.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        kernel-team@android.com, LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Aug 16, 2022 at 6:31 AM Luca Weiss <luca.weiss@fairphone.com> wrote:
>
> Hi Saravana,
>
> On Tue Aug 16, 2022 at 1:36 AM CEST, Saravana Kannan wrote:
> > On Mon, Aug 15, 2022 at 9:57 AM Luca Weiss <luca.weiss@fairphone.com> wrote:
> > >
> > > On Mon Aug 15, 2022 at 1:01 PM CEST, Tony Lindgren wrote:
> > > > * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > > > > More fixes/changes are needed before driver_deferred_probe_check_state()
> > > > > can be deleted. So, bring it back for now.
> > > > >
> > > > > Greg,
> > > > >
> > > > > Can we get this into 5.19? If not, it might not be worth picking up this
> > > > > series. I could just do the other/more fixes in time for 5.20.
> > > >
> > > > Yes please pick this as fixes for v6.0-rc series, it fixes booting for
> > > > me. I've replied with fixes tags for the two patches that were causing
> > > > regressions for me.
> > > >
> > >
> > > Hi,
> > >
> > > for me Patch 1+3 fix display probe on Qualcomm SM6350 (although display
> > > for this SoC isn't upstream yet, there are lots of other SoCs with very
> > > similar setup).
> > >
> > > Probe for DPU silently fails, with CONFIG_DEBUG_DRIVER=y we get this:
> > >
> > > msm-mdss ae00000.mdss: __genpd_dev_pm_attach() failed to find PM domain: -2
> > >
> > > While I'm not familiar with the specifics of fw_devlink, the dtsi has
> > > power-domains = <&dispcc MDSS_GDSC> for this node but it doesn't pick
> > > that up for some reason.
> > >
> > > We can also see that a bit later dispcc finally probes.
> >
> > Luca,
> >
> > Can you test with this series instead and see if it fixes this issue?
> > https://lore.kernel.org/lkml/20220810060040.321697-1-saravanak@google.com/
> >
>
> Unfortunately it doesn't seem to work with the 9 patches

I also tried with the 9 patches, plus an extra fix that Saravana
provided. They didn't fix my use case either. Do we want to land the
reverts as a stopgap so that people aren't broken?

For reference, the device tree for the device I'm testing on is
`arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts`. The device
that's not probing is the bridge chip, AKA 2-002d. Presumably
something about the bridge chip cycles is confusing things since the
remote endpoint that sn65dsi86 needs is actually a child of sn65dsi86
(the panel).

-Doug
