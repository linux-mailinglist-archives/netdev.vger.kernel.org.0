Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B56595D64
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbiHPNaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbiHPNad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:30:33 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77D1B8A62
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:30:31 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so3727750wmb.4
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc;
        bh=hc7qC7bI2uO2D4Qa+zC5gvmq4/4IvbZWBk2kTcS1e4g=;
        b=p1uIS7iPRm5FqeZyBT0Rono6HWbv5ulB/bs5oZgYh6d9a1ptIjWxTqIf5fdui0UI7P
         UiKMVSr+4RtXLv4oOr9y9VG9zkJ7wYmACViu7FoZAAHh0fx2AK3IeW287cwTA94pjy7W
         58dOOYI3IkZoR37TVr4OI4CDMlz7EA6HMoFO3Ex0IHnawCAeW+LTa/T3QasiPuhhYTYG
         mUk4SHi+5Q/GbXbDglXaTas5nW1FpgGGNDDHSmOKsKRkDWE1GvW1FLM0ls2tIh887+7e
         gGI8c1mDEYenpo65eLgr7mEvWZmy3MQSEE91lN0cZg0rhMVt+ckyO47lwF8zoDEr71bJ
         5C6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc;
        bh=hc7qC7bI2uO2D4Qa+zC5gvmq4/4IvbZWBk2kTcS1e4g=;
        b=S8vV7vnrZbxUFX26IjhAkgW5oiGYNrTN2F6zbmsawKAy1DNsIv48DTsGPSr1YQmkS/
         x1BbMrTPuDgyIMmwardIfBzvDQQlYUXRZaBBdnQc4Wt1g78zyZFGSA2/yEZH8SDZDXRC
         SciW5lcvkx4Wk2tjlSwGiv4F843dx/RrX/hg8qrEx5MCQfOwSJxre+QLXfBWttzYz7bh
         UZVx5Wf0ZeR1jcCpqjtLwar0yvXVT2lfMq1pN6JXTRi+5B+puMWkV1p9HsECfohYaagm
         pbIu5uGoOzrxyhBtxCuFJ3FonWNPbv//mAE2Bbs9kbUlrTAr7Zrg9cIFv7oBN14cM9F8
         pzVw==
X-Gm-Message-State: ACgBeo0vd6N2dFuRF5u3P/efPH2+qWeAVk9DtwVxPtNzmM/S1A0tY9Yd
        fGooP9Du8SLMsmGkRJ3P0heLfQ==
X-Google-Smtp-Source: AA6agR5brmQT0VGVlB3KYey11S8HsfHLRIqrWymjHMuDRQM1mXOpHIasTetNNd2nw2J4QFqsRY8/MA==
X-Received: by 2002:a1c:f217:0:b0:3a4:bfd4:21b4 with SMTP id s23-20020a1cf217000000b003a4bfd421b4mr12934932wmc.96.1660656630403;
        Tue, 16 Aug 2022 06:30:30 -0700 (PDT)
Received: from localhost (2a02-8388-6582-fe80-0000-0000-0000-0002.cable.dynamic.v6.surfer.at. [2a02:8388:6582:fe80::2])
        by smtp.gmail.com with ESMTPSA id n6-20020a05600c3b8600b003a608d69a64sm1870148wms.21.2022.08.16.06.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 06:30:29 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 16 Aug 2022 15:30:26 +0200
Message-Id: <CM7HN6H9EAN4.2008QGJVIO14X@otso>
Subject: Re: [PATCH v1 0/3] Bring back driver_deferred_probe_check_state()
 for now
From:   "Luca Weiss" <luca.weiss@fairphone.com>
To:     "Saravana Kannan" <saravanak@google.com>
Cc:     "Tony Lindgren" <tony@atomide.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Kevin Hilman" <khilman@kernel.org>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        "Pavel Machek" <pavel@ucw.cz>, "Len Brown" <len.brown@intel.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "Russell King" <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <naresh.kamboju@linaro.org>,
        <kernel-team@android.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <netdev@vger.kernel.org>
X-Mailer: aerc 0.11.0
References: <20220727185012.3255200-1-saravanak@google.com>
 <Yvonn9C/AFcRUefV@atomide.com> <CM6REZS9Z8AC.2KCR9N3EFLNQR@otso>
 <CAGETcx_6oh=GVLP7-1gN_4DW7UHJ1MZQ6T1U2hupc_ZYDnXcNA@mail.gmail.com>
In-Reply-To: <CAGETcx_6oh=GVLP7-1gN_4DW7UHJ1MZQ6T1U2hupc_ZYDnXcNA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

On Tue Aug 16, 2022 at 1:36 AM CEST, Saravana Kannan wrote:
> On Mon, Aug 15, 2022 at 9:57 AM Luca Weiss <luca.weiss@fairphone.com> wro=
te:
> >
> > On Mon Aug 15, 2022 at 1:01 PM CEST, Tony Lindgren wrote:
> > > * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > > > More fixes/changes are needed before driver_deferred_probe_check_st=
ate()
> > > > can be deleted. So, bring it back for now.
> > > >
> > > > Greg,
> > > >
> > > > Can we get this into 5.19? If not, it might not be worth picking up=
 this
> > > > series. I could just do the other/more fixes in time for 5.20.
> > >
> > > Yes please pick this as fixes for v6.0-rc series, it fixes booting fo=
r
> > > me. I've replied with fixes tags for the two patches that were causin=
g
> > > regressions for me.
> > >
> >
> > Hi,
> >
> > for me Patch 1+3 fix display probe on Qualcomm SM6350 (although display
> > for this SoC isn't upstream yet, there are lots of other SoCs with very
> > similar setup).
> >
> > Probe for DPU silently fails, with CONFIG_DEBUG_DRIVER=3Dy we get this:
> >
> > msm-mdss ae00000.mdss: __genpd_dev_pm_attach() failed to find PM domain=
: -2
> >
> > While I'm not familiar with the specifics of fw_devlink, the dtsi has
> > power-domains =3D <&dispcc MDSS_GDSC> for this node but it doesn't pick
> > that up for some reason.
> >
> > We can also see that a bit later dispcc finally probes.
>
> Luca,
>
> Can you test with this series instead and see if it fixes this issue?
> https://lore.kernel.org/lkml/20220810060040.321697-1-saravanak@google.com=
/
>

Unfortunately it doesn't seem to work with the 9 patches, and the
attached diff also doesn't seem to make a difference. I do see this in
dmesg which I haven't seen in the past:

[    0.056554] platform 1d87000.phy: Fixed dependency cycle(s) with /soc@0/=
ufs@1d84000
[    0.060070] platform ae00000.mdss: Fixed dependency cycle(s) with /soc@0=
/clock-controller@af00000
[    0.060150] platform ae00000.mdss: Failed to create device link with ae0=
0000.mdss
[    0.060188] platform ae00000.mdss: Failed to create device link with ae0=
0000.mdss
[    0.061135] platform c440000.spmi: Failed to create device link with c44=
0000.spmi
[    0.061157] platform c440000.spmi: Failed to create device link with c44=
0000.spmi
[    0.061180] platform c440000.spmi: Failed to create device link with c44=
0000.spmi
[    0.061198] platform c440000.spmi: Failed to create device link with c44=
0000.spmi
[    0.061215] platform c440000.spmi: Failed to create device link with c44=
0000.spmi
[    0.061231] platform c440000.spmi: Failed to create device link with c44=
0000.spmi
[    0.061252] platform c440000.spmi: Failed to create device link with c44=
0000.spmi

Also I'm going to be on holiday from today for about 2 weeks so I won't
be able to test anything in that time.

And in case it's interesting, here's the full dmesg to initramfs:
https://pastebin.com/raw/Fc8W4MVi

Regards
Luca

> You might also need to add this delta on top of the series if the
> series itself isn't sufficient.
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 2f012e826986..866755d8ad95 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -2068,7 +2068,11 @@ static int fw_devlink_create_devlink(struct device=
 *con,
>                 device_links_write_unlock();
>         }
>
> -       sup_dev =3D get_dev_from_fwnode(sup_handle);
> +       if (sup_handle->flags & FWNODE_FLAG_NOT_DEVICE)
> +               sup_dev =3D fwnode_get_next_parent_dev(sup_handle);
> +       else
> +               sup_dev =3D get_dev_from_fwnode(sup_handle);
> +
>         if (sup_dev) {
>                 /*
>                  * If it's one of those drivers that don't actually bind =
to
>
> -Saravana

