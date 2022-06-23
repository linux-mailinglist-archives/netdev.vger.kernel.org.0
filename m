Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BACA557542
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 10:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiFWIWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 04:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiFWIWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 04:22:23 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5A648327
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 01:22:21 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id e4so21863226ybq.7
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 01:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9PjNiNhLCuh9WhzT1AaONPfu5Pj4HpLdf/1QRxDQ9sQ=;
        b=pzqGfXQLba3va5/8Sml5dTqasBd22VtMC6LsIY9XM86NydlS9zpVJnL7w7xX6iuDe8
         X7CBtL21Xt/roY99vHIUugx0rcpAIZr/MRxvyoGKpsUZLiqAk//S2jlQpBwrNnHk7wGm
         RQTEw34L8DZMyPfA1AsauTTsxDs05tA56d4f5svcOAWjw1Odk+3DTByfTvJrYBNr/zRF
         iPbOdMh47ENO95zTpdz/17l4CgcdpExtT5e0NypAQFBQc/j/g67fTa8i40rOqRH7rdeC
         +qNvOlp6pV5Z2uaLHf2Y3ZncmyJaUhr6W/xXlsYAJCLg8Ts5Y0LhOT8aCUZsWexiZHkk
         67Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9PjNiNhLCuh9WhzT1AaONPfu5Pj4HpLdf/1QRxDQ9sQ=;
        b=a6+48sfOrqI85bp8SsYKbGzkH6KsU0eDRBd85hcLYTtKEbbv4c2VsNfsL9hb4p9Fkc
         /BNOewR0BkxKNiEf4KM6Xb3PTu5gOA/aNFvdkRONT9tzKLNIOVGFBZmVZMNKx6LM/Bn9
         nMig6vubPKWI6dwvtk3ZBdwhCrFFxV0g+hdZQKBfossoYSKxp/QuWzBhp1CTVp1i1DBh
         VFsvNrES1/kVGt+VER579IBLXOtePSRoX5lDKJTfSMlvesCu8MkFOjVmECVI9rkMUjtu
         dn/k5ruw5XVbaMHmAhtvRRYfG5ymfV5jzoHuxmLN8gR4Fypzo5vTI07g6KxgFDYDccre
         JyNA==
X-Gm-Message-State: AJIora9ME2YUE4of2yLkSsg4ZeZ9p4JZ8xfc9Qvf9uTYE9wkl+9RfUAU
        UfDiDj61RTrc2rzJyP9MYYAxx5rDGNp00onaVeTOkA==
X-Google-Smtp-Source: AGRyM1vxaAj9yCr/MgE5OXOPyoZP2NZubFdKuQ3kk1yDt2x8rBApcAn2+N11GLiK2OWn/arC4N2rlY0DEOynYw1Ms08=
X-Received: by 2002:a25:9e82:0:b0:669:b38d:e93e with SMTP id
 p2-20020a259e82000000b00669b38de93emr775933ybq.242.1655972540895; Thu, 23 Jun
 2022 01:22:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-2-saravanak@google.com> <YrFzK6EiVvXmzVG6@atomide.com>
 <CAGETcx_1USPRbFKV5j00qkQ-QXJkp7=FAfnFcfiNnM4J5KF1cQ@mail.gmail.com>
 <YrKhkmj3jCQA39X/@atomide.com> <CAGETcx_11wO-HkZ2QsBF8o1+L9L3Xe1QBQ_GzegwozxAx1i0jg@mail.gmail.com>
 <YrQP3OZbe8aCQxKU@atomide.com>
In-Reply-To: <YrQP3OZbe8aCQxKU@atomide.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 23 Jun 2022 01:21:43 -0700
Message-ID: <CAGETcx9aFBzMcuOiTAEy5SJyWw3UfajZ8DVQfW2DGmzzDabZVg@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
To:     Tony Lindgren <tony@atomide.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
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

On Thu, Jun 23, 2022 at 12:01 AM Tony Lindgren <tony@atomide.com> wrote:
>
> * Saravana Kannan <saravanak@google.com> [220622 19:05]:
> > On Tue, Jun 21, 2022 at 9:59 PM Tony Lindgren <tony@atomide.com> wrote:
> > >
> > > Hi,
> > >
> > > * Saravana Kannan <saravanak@google.com> [220621 19:29]:
> > > > On Tue, Jun 21, 2022 at 12:28 AM Tony Lindgren <tony@atomide.com> wrote:
> > > > >
> > > > > Hi,
> > > > >
> > > > > * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > > > > > Now that fw_devlink=on by default and fw_devlink supports
> > > > > > "power-domains" property, the execution will never get to the point
> > > > > > where driver_deferred_probe_check_state() is called before the supplier
> > > > > > has probed successfully or before deferred probe timeout has expired.
> > > > > >
> > > > > > So, delete the call and replace it with -ENODEV.
> > > > >
> > > > > Looks like this causes omaps to not boot in Linux next.
> > > >
> > > > Can you please point me to an example DTS I could use for debugging
> > > > this? I'm assuming you are leaving fw_devlink=on and not turning it
> > > > off or putting it in permissive mode.
> > >
> > > Sure, this seems to happen at least with simple-pm-bus as the top
> > > level interconnect with a configured power-domains property:
> > >
> > > $ git grep -A10 "ocp {" arch/arm/boot/dts/*.dtsi | grep -B3 -A4 simple-pm-bus
> >
> > Thanks for the example. I generally start looking from dts (not dtsi)
> > files in case there are some DT property override/additions after the
> > dtsi files are included in the dts file. But I'll assume for now
> > that's not the case. If there's a specific dts file for a board I can
> > look from that'd be helpful to rule out those kinds of issues.
> >
> > For now, I looked at arch/arm/boot/dts/omap4.dtsi.
>
> OK it should be very similar for all the affected SoCs.
>
> > > This issue is no directly related fw_devlink. It is a side effect of
> > > removing driver_deferred_probe_check_state(). We no longer return
> > > -EPROBE_DEFER at the end of driver_deferred_probe_check_state().
> >
> > Yes, I understand the issue. But driver_deferred_probe_check_state()
> > was deleted because fw_devlink=on should have short circuited the
> > probe attempt with an  -EPROBE_DEFER before reaching the bus/driver
> > probe function and hitting this -ENOENT failure. That's why I was
> > asking the other questions.
>
> OK. So where is the -EPROBE_DEFER supposed to happen without
> driver_deferred_probe_check_state() then?

device_links_check_suppliers() call inside really_probe() would short
circuit and return an -EPROBE_DEFER if the device links are created as
expected.

>
> > > > > On platform_probe() genpd_get_from_provider() returns
> > > > > -ENOENT.
> > > >
> > > > This error is with the series I assume?
> > >
> > > On the first probe genpd_get_from_provider() will return -ENOENT in
> > > both cases. The list is empty on the first probe and there are no
> > > genpd providers at this point.
> > >
> > > Earlier with driver_deferred_probe_check_state(), the initial -ENOENT
> > > ends up getting changed to -EPROBE_DEFER at the end of
> > > driver_deferred_probe_check_state(), we are now missing that.
> >
> > Right, I was aware -ENOENT would be returned if we got this far. But
> > the point of this series is that you shouldn't have gotten that far
> > before your pm domain device is ready. Hence my questions from the
> > earlier reply.
>
> OK
>
> > Can I get answers to rest of my questions in the first reply please?
> > That should help us figure out why fw_devlink let us get this far.
> > Summarize them here to make it easy:
> > * Are you running with fw_devlink=on?
>
> Yes with the default with no specific kernel params so looks like
> FW_DEVLINK_FLAGS_ON.
>
> > * Is the"ti,omap4-prm-inst"/"ti,omap-prm-inst" built-in in this case?
>
> Yes
>
> > * If it's not built-in, can you please try deferred_probe_timeout=0
> > and deferred_probe_timeout=30 and see if either one of them help?
>
> It's built in so I did not try these.
>
> > * Can I get the output of "ls -d supplier:*" and "cat
> > supplier:*/status" output from the sysfs dir for the ocp device
> > without this series where it boots properly.
>
> Hmm so I'm not seeing any supplier for the top level ocp device in
> the booting case without your patches. I see the suppliers for the
> ocp child device instances only.

Hmmm... this is strange (that the device link isn't there), but this
is what I suspected.

Now we need to figure out why it's missing. There are only a few
things that could cause this and I don't see any of those. I already
checked to make sure the power domain in this instance had a proper
driver with a probe() function -- if it didn't, then that's one thing
that'd could have caused the missing device link. The device does seem
to have a proper driver, so looks like I can rule that out.

Can you point me to the dts file that corresponds to the specific
board you are testing this one? I probably won't find anything, but I
want to rule out some of the possibilities.

All the device link creation logic is inside drivers/base/core.c. So
if you can look at the existing messages or add other stuff to figure
out why the device link isn't getting created, that'd be handy. In
either case, I'll continue staring at the DT and code to see what
might be happening here.

-Saravana
