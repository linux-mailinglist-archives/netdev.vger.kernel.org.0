Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A63E58E40C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 02:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiHJAZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 20:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiHJAZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 20:25:18 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C236403
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 17:25:14 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-328303afa6eso127182157b3.10
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 17:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=1VUI2HFiheDo58arrnc79/Qbxj5WTqZQ2QhX4iv40Nk=;
        b=ABPWt08krXKfSXeDcebcG/m72KIW6vO/4ih2HdtXW6Xcflaa31kKaLJUzYJyA+hjN5
         /hos42tL2v9m84JqszthxP3dn6c/aGKTK66PuFX4Z0fjxJzOK5uctw+SStmmWvgWafd7
         MKbDZ8Sg0XjW/oLYmkjK93RHOUprdKYO8gm7b5y2cWYfPwkQcxfkl1aJQz7u3MOHnZCH
         rdFJVgtMvEFznU1m+kpmWML4RW6xlptVIsorWBXGkpapFj7ucqQosGltArtrkMjUMvr8
         bzpYAIDT8iGLrKJTU7i0DiQ4ZrsFOu903DZ2B9J+RQpVsmlU48hAaJ4q+isVtpHsUKog
         1ADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=1VUI2HFiheDo58arrnc79/Qbxj5WTqZQ2QhX4iv40Nk=;
        b=rQoYIwBuyJwKPGc/e7UcGlkpQIWZratnbY2XaWXzJjkeXwZ2MlgUDvpb5MsaMgm7Zj
         JqFUCH1YTCH1tAzv9UqzybVH3/ZS3+AhNwlI6+rIcnoRO4hOjQCIHa05ChpjxhLWsxd9
         bM0FPdxzPZkCgItCjHfTGmylnnY+RA9WTOIywyc5NmJtUkwcgWuwD303WOqqcI4d/Hu1
         TRFJVwzKVLTahYa+gadjfSYEzSu7GseSH3Ci4RGPv18PGLo/Ih7fpuT/bSLyv45a6AgW
         bJVZrvaa1KXcYVcbtTZQq0AqCpIL9ieCNG4llFL6nPwXVpWzBJa6d54xmpLy9KQEyoE7
         z2Dg==
X-Gm-Message-State: ACgBeo18sLZBZx0W27m8o7ZY8bHKsSExzQjxPfA+zPDVJUuz3XpOu4pj
        fTFE5N0Vf3hv4up6SdhM3WO8wAm9pE9YC02HYpKJ0w==
X-Google-Smtp-Source: AA6agR6ldAkTAJtS3AzePk06qtNOc1jE0hT59EJbzuTuMPqiGKi5H6FdfLEZjbfEkE01KyVeWy2EIeHuNtHBK05yhwk=
X-Received: by 2002:a0d:fd05:0:b0:329:3836:53ac with SMTP id
 n5-20020a0dfd05000000b00329383653acmr23670331ywf.455.1660091113143; Tue, 09
 Aug 2022 17:25:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220727185012.3255200-1-saravanak@google.com>
 <YuI6shUi6iJdMSfB@kroah.com> <CAD=FV=W1P=4vzyTYQ+yVC=fH-7i=hjCAk7FV8jcGcGY+xa62pA@mail.gmail.com>
In-Reply-To: <CAD=FV=W1P=4vzyTYQ+yVC=fH-7i=hjCAk7FV8jcGcGY+xa62pA@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 9 Aug 2022 17:24:37 -0700
Message-ID: <CAGETcx9+ST9OwoO8H3EMoODCW3AUtvFcwPmYDaB266fdgoXtEQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] Bring back driver_deferred_probe_check_state() for now
To:     Doug Anderson <dianders@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        netdev <netdev@vger.kernel.org>,
        Stephen Boyd <swboyd@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 9, 2022 at 4:47 PM Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Thu, Jul 28, 2022 at 12:29 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Jul 27, 2022 at 11:50:08AM -0700, Saravana Kannan wrote:
> > > More fixes/changes are needed before driver_deferred_probe_check_state()
> > > can be deleted. So, bring it back for now.
> > >
> > > Greg,
> > >
> > > Can we get this into 5.19? If not, it might not be worth picking up this
> > > series. I could just do the other/more fixes in time for 5.20.
> >
> > Wow, no, it is _WAY_ too late for 5.19 to make a change like this,
> > sorry.
> >
> > What is so broken that we need to revert these now?  I could do so for
> > 5.20-rc1, and then backport to 5.19.y if that release is really broken,
> > but this feels odd so late in the cycle.

Greg,

I didn't realize the patches I'm trying to revert never landed on
5.19. So you can ignore this thread.

>
> I spent a bunch of time bisecting mainline today on my
> sc7180-trogdor-lazor board. When building the top of Linus's tree
> today the display doesn't come up. I can make it come up by turning
> fw_devlink off (after fixing a regulator bug that I just posted a fix
> for).
>
> I found that the first bad commit was commit 5a46079a9645 ("PM:
> domains: Delete usage of driver_deferred_probe_check_state()")
>
> ...but only when applied to mainline. When I cherry-pick that back to
> v5.19-rc1 (and pick another bugfix needed to boot my board against
> v5.19-rc1) then it works OK. After yet more bisecting, I found that on
> trogdor there's a bad interaction with the commit e511a760 ("arm64:
> dts: qcom: sm7180: remove assigned-clock-rate property for mdp clk").
> That commit is perfectly legit but I guess it somehow changed how
> fw_devlink was interpreting things?
>
> Sure enough, picking this revert series fixes things on Linus's tree.
> Any chance we can still get the revert in for v5.20-rc1? ;-)

I guess it's 6.0 now. But I'm almost done with my actual fixes that
rewrite some parts of fw_devlink to make it a lot more robust. So, I'm
not sure if all these reverts need to land anymore.

I'm hoping to send out the proper fixes by the end of this week. Maybe
you can try that out and let me know if it solves your issues (I
expect it to).

I'm surprised that specific clock patch has an impact though. It's
just touching properties that fw_devlink doesn't parse.

-Saravana
