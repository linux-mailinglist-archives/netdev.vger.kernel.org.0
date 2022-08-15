Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AC7595254
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiHPGFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiHPGE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:04:26 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AF36C104
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 16:37:00 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-32fd97c199fso85846667b3.6
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 16:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=fVxetOgUQ7E/da9h0YyyPZnmDSU85aoRWSOGJovfDo4=;
        b=KTUwHeoXz1fmYUOVhvzKJVtvXyuG8JHUHX6QB6FOxUcDm+t/hWHwoYNXr85HrUdaEK
         tILQMJn5QrnwvIaiiGvh/gmofiK9boSEgGXMH8Td1nph3IGh7K9bPlvKvjyubLDSc0aS
         fgP5ZpT/qNqLdbxAcPOnXoC06oDNK7j8waNQN+CBuASLQjDxP44f8T2h1FoyDYuG2qG0
         BpVB8cB/sRH0nhHBKOSHQriJwZq8WNgL2+bZYuBEh1Bbls5R4A/XDMEyrwthkWrfMF+H
         T+itPy2imckkoWZbnfArIsJ7JKc+W9DP9rqWida20tZuDHZyrdibJlDrRnzcRORJzbga
         q56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=fVxetOgUQ7E/da9h0YyyPZnmDSU85aoRWSOGJovfDo4=;
        b=MCnJWENefczR14chEAcyuoTx6RlK3lN0tsOGmkiLEK62BTdbvEJrwLAScjQdAhmEnk
         W6xKFig7HYmlIIJEYo+iyOyNQPQRrWH3xDej0UnXIigNk8SaBW7wrriwAdmyDAnH43x6
         VL+GY6iIuyfdbpto9AnbJ+X2g0gCog6mAE6JpvUmUri22Wz0uhICF4QAIqpm/5YS7+Cw
         RRXbm/0PFp7DgEV7XPMSFi1XwHsj4GtRxA9oAsAHiAEwLeYEUkDy/WVSZXLhLLBJ2AiW
         AJ9B43Sb+Tno3RjGMGrQLllJM5L7fqO/6bTat9oZKxZjxf0Pb3hfAFWPJoE1FIhvBqzY
         wQKw==
X-Gm-Message-State: ACgBeo1Tw+x7OXeAl2xApUzdNb3EQtKRzUEtSZfyKtkAUb2b09ruHOmp
        yDXqbO74KN/qRH+/DQ4LNVpozNzVUBRO2vMLzW/HEQ==
X-Google-Smtp-Source: AA6agR5Np2WgcNsV8TjcwUEqg6oN6k4lKO8Wo6VF8E9ds7ny2Mlu9nLypvijdRBumVPbsaC27C1JZ/SudORTFk2byw8=
X-Received: by 2002:a81:d8a:0:b0:333:38da:2a44 with SMTP id
 132-20020a810d8a000000b0033338da2a44mr1203503ywn.518.1660606619221; Mon, 15
 Aug 2022 16:36:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220727185012.3255200-1-saravanak@google.com>
 <Yvonn9C/AFcRUefV@atomide.com> <CM6REZS9Z8AC.2KCR9N3EFLNQR@otso>
In-Reply-To: <CM6REZS9Z8AC.2KCR9N3EFLNQR@otso>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 15 Aug 2022 16:36:23 -0700
Message-ID: <CAGETcx_6oh=GVLP7-1gN_4DW7UHJ1MZQ6T1U2hupc_ZYDnXcNA@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] Bring back driver_deferred_probe_check_state() for now
To:     Luca Weiss <luca.weiss@fairphone.com>
Cc:     Tony Lindgren <tony@atomide.com>,
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
        Paolo Abeni <pabeni@redhat.com>, naresh.kamboju@linaro.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 9:57 AM Luca Weiss <luca.weiss@fairphone.com> wrote:
>
> On Mon Aug 15, 2022 at 1:01 PM CEST, Tony Lindgren wrote:
> > * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > > More fixes/changes are needed before driver_deferred_probe_check_state()
> > > can be deleted. So, bring it back for now.
> > >
> > > Greg,
> > >
> > > Can we get this into 5.19? If not, it might not be worth picking up this
> > > series. I could just do the other/more fixes in time for 5.20.
> >
> > Yes please pick this as fixes for v6.0-rc series, it fixes booting for
> > me. I've replied with fixes tags for the two patches that were causing
> > regressions for me.
> >
>
> Hi,
>
> for me Patch 1+3 fix display probe on Qualcomm SM6350 (although display
> for this SoC isn't upstream yet, there are lots of other SoCs with very
> similar setup).
>
> Probe for DPU silently fails, with CONFIG_DEBUG_DRIVER=y we get this:
>
> msm-mdss ae00000.mdss: __genpd_dev_pm_attach() failed to find PM domain: -2
>
> While I'm not familiar with the specifics of fw_devlink, the dtsi has
> power-domains = <&dispcc MDSS_GDSC> for this node but it doesn't pick
> that up for some reason.
>
> We can also see that a bit later dispcc finally probes.

Luca,

Can you test with this series instead and see if it fixes this issue?
https://lore.kernel.org/lkml/20220810060040.321697-1-saravanak@google.com/

You might also need to add this delta on top of the series if the
series itself isn't sufficient.
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2f012e826986..866755d8ad95 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2068,7 +2068,11 @@ static int fw_devlink_create_devlink(struct device *con,
                device_links_write_unlock();
        }

-       sup_dev = get_dev_from_fwnode(sup_handle);
+       if (sup_handle->flags & FWNODE_FLAG_NOT_DEVICE)
+               sup_dev = fwnode_get_next_parent_dev(sup_handle);
+       else
+               sup_dev = get_dev_from_fwnode(sup_handle);
+
        if (sup_dev) {
                /*
                 * If it's one of those drivers that don't actually bind to

-Saravana
