Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD06566552
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 10:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiGEIor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 04:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiGEIoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 04:44:46 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F47DECC
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 01:44:44 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id o2so15354853yba.7
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 01:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2nqg94hUDjf5VEy31mCYebRLyQWKOgGJpJElSft6kJk=;
        b=oVdJFaZLt6iik+gYVPoDhE3E0/T/qMpp81wNqUxEUTmekiaqU9ynpZ0mDpnp2WD8cV
         1XxBK2Tr40GZWioBld+i2V2kPexOZDXUouMVZ8Ta2CmvZ6vewWiUjnGTEovIbce1WKpR
         nRulH13G0QJpSAV8IrG/vyGQL8xWb2qk/6ax3FTz3YAu5ngRNie2xDTdyn/3wo8LdI4n
         4XMCNJA3C+XzvqbqeIqouGJjzVPFaCYGN7b0gBNrXW2dEfwZAh5IeAKq/qf7jDjP6DxQ
         sJuscQX3dxs/MUyavOF2DrQo82K7EPd+OrV7QEVmkdbS/+lXRLFYmWGyqUhmElgGNChc
         XHOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2nqg94hUDjf5VEy31mCYebRLyQWKOgGJpJElSft6kJk=;
        b=ukNQGvpbFXoh0RdMXy074IaqC6mBIbwk99sEqlGGNdyzNa2b3/HTp38ZlcDYzE7w+E
         J+GKqaEDjAXOHR625NDRcn9ofIYOi2wZ71FQlthpgMluTBzhYp0N2+4zfh7OielmMqD7
         6p+1tuHM1FA99Ab5riqdRPSduAG48r879ccasM5dd0LegraUkz7cSvQpK06IUS8K/h5Y
         3TV/gEIYqR3cjbZY2vtCKTmDnb1LjDpymHKOZ1MoMGpQnU/W8acIDyXLsdQMfAKos2gh
         TiVyGc8LkjsorrQZ1JtydHF5Pq4tftGR+7MYESTW4ZWxhZv6PW/eOA1CXnOkK6xU/Vf8
         94OA==
X-Gm-Message-State: AJIora+n/tZOjXOg+3sNTfPFcB52kFN7MMx/TFBO8YB/ApieYaLMq+2s
        e+6/5qamlDWvzNsVqPZHs9zi0UIKrWk1Xm3HtRoZcA==
X-Google-Smtp-Source: AGRyM1s3KR9timt0Nv154BBVjZtVup9YxTIdAuMg5rdc0L5tuSQBdw4qLUFuMUr86cFiFJimYkgebSO//Pbzv6BbJEU=
X-Received: by 2002:a25:abce:0:b0:66e:38e8:d286 with SMTP id
 v72-20020a25abce000000b0066e38e8d286mr12961807ybi.447.1657010683689; Tue, 05
 Jul 2022 01:44:43 -0700 (PDT)
MIME-Version: 1.0
References: <YrQP3OZbe8aCQxKU@atomide.com> <CAGETcx9aFBzMcuOiTAEy5SJyWw3UfajZ8DVQfW2DGmzzDabZVg@mail.gmail.com>
 <Yrlz/P6Un2fACG98@atomide.com> <CAGETcx8c+P0r6ARmhv+ERaz9zAGBOVJQu3bSDXELBycEGfkYQw@mail.gmail.com>
 <CAL_JsqJd3J6k6pRar7CkHVaaPbY7jqvzAePd8rVDisRV-dLLtg@mail.gmail.com>
 <CAGETcx9ZmeTyP1sJCFZ9pBbMyXeifQFohFvWN3aBPx0sSOJ2VA@mail.gmail.com>
 <Yr6HQOtS4ctUYm9m@atomide.com> <Yr6QUzdoFWv/eAI6@atomide.com>
 <CAGETcx-0bStPx8sF3BtcJFiu74NwiB0btTQ+xx_B=8B37TEb8w@mail.gmail.com>
 <CAGETcx-Yp2JKgCNfaGD0SzZg9F2Xnu8A3zXmV5=WX1hY7uR=0g@mail.gmail.com>
 <20220701150848.75eeprptmb5beip7@bogus> <CAGETcx_Y-9WBeRwf22v3NSuY8PGpPrTxtx_uBqe_Q7rD6mEQMQ@mail.gmail.com>
In-Reply-To: <CAGETcx_Y-9WBeRwf22v3NSuY8PGpPrTxtx_uBqe_Q7rD6mEQMQ@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 5 Jul 2022 01:44:07 -0700
Message-ID: <CAGETcx8hECfU9-rXpXnnB5m4HcTBJVKNuG77FjhpqRcBkOOotw@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
To:     Sudeep Holla <sudeep.holla@arm.com>
Cc:     Tony Lindgren <tony@atomide.com>, Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        David Ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>
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

On Fri, Jul 1, 2022 at 12:13 PM Saravana Kannan <saravanak@google.com> wrote:
>
> On Fri, Jul 1, 2022 at 8:08 AM Sudeep Holla <sudeep.holla@arm.com> wrote:
> >
> > Hi, Saravana,
> >
> > On Fri, Jul 01, 2022 at 01:26:12AM -0700, Saravana Kannan wrote:
> >
> > [...]
> >
> > > Can you check if this hack helps? If so, then I can think about
> > > whether we can pick it up without breaking everything else. Copy-paste
> > > tab mess up warning.
> >
> > Sorry for jumping in late and not even sure if this is right thread.
> > I have not bisected anything yet, but I am seeing issues on my Juno R2
> > with SCMI enabled power domains and Coresight AMBA devices.
> >
> > OF: amba_device_add() failed (-19) for /etf@20010000
> > OF: amba_device_add() failed (-19) for /tpiu@20030000
> > OF: amba_device_add() failed (-19) for /funnel@20040000
> > OF: amba_device_add() failed (-19) for /etr@20070000
> > OF: amba_device_add() failed (-19) for /stm@20100000
> > OF: amba_device_add() failed (-19) for /replicator@20120000
> > OF: amba_device_add() failed (-19) for /cpu-debug@22010000
> > OF: amba_device_add() failed (-19) for /etm@22040000
> > OF: amba_device_add() failed (-19) for /cti@22020000
> > OF: amba_device_add() failed (-19) for /funnel@220c0000
> > OF: amba_device_add() failed (-19) for /cpu-debug@22110000
> > OF: amba_device_add() failed (-19) for /etm@22140000
> > OF: amba_device_add() failed (-19) for /cti@22120000
> > OF: amba_device_add() failed (-19) for /cpu-debug@23010000
> > OF: amba_device_add() failed (-19) for /etm@23040000
> > OF: amba_device_add() failed (-19) for /cti@23020000
> > OF: amba_device_add() failed (-19) for /funnel@230c0000
> > OF: amba_device_add() failed (-19) for /cpu-debug@23110000
> > OF: amba_device_add() failed (-19) for /etm@23140000
> > OF: amba_device_add() failed (-19) for /cti@23120000
> > OF: amba_device_add() failed (-19) for /cpu-debug@23210000
> > OF: amba_device_add() failed (-19) for /etm@23240000
> > OF: amba_device_add() failed (-19) for /cti@23220000
> > OF: amba_device_add() failed (-19) for /cpu-debug@23310000
> > OF: amba_device_add() failed (-19) for /etm@23340000
> > OF: amba_device_add() failed (-19) for /cti@23320000
> > OF: amba_device_add() failed (-19) for /cti@20020000
> > OF: amba_device_add() failed (-19) for /cti@20110000
> > OF: amba_device_add() failed (-19) for /funnel@20130000
> > OF: amba_device_add() failed (-19) for /etf@20140000
> > OF: amba_device_add() failed (-19) for /funnel@20150000
> > OF: amba_device_add() failed (-19) for /cti@20160000
> >
> > These are working fine with deferred probe in the mainline.
> > I tried the hack you have suggested here(rather Tony's version),
>
> Thanks for trying that.
>
> > also
> > tried with fw_devlink=0 and fw_devlink=1
>
> 0 and 1 aren't valid input to fw_devlink. But yeah, I don't expect
> disabling it to make anything better.
>
> > && fw_devlink.strict=0
> > No change in the behaviour.
> >
> > The DTS are in arch/arm64/boot/dts/arm/juno-*-scmi.dts and there
> > coresight devices are mostly in juno-cs-r1r2.dtsi
>
> Thanks
>
> > Let me know if there is anything obvious or you want me to bisect which
> > means I need more time. I can do that next week.
>
> I'll let you know once I poke at the DTS. We need to figure out why
> fw_devlink wasn't blocking these from getting to the error (same as in
> Tony's case). But since these are amba devices, I think I have some
> guesses.
>
> This is an old series that had some issues in some cases and I haven't
> gotten around to looking at it. You can give that a shot if you can
> apply it to a recent tree.
> https://lore.kernel.org/lkml/20210304195101.3843496-1-saravanak@google.com/

I rebased it to driver-core-next and tested the patch  (for
correctness, not with your issue though). I'm fairly sure it should
help with your issue. Can you give it a shot please?

https://lore.kernel.org/lkml/20220705083934.3974140-1-saravanak@google.com/T/#u

-Saravana

>
> After looking at that old patch again, I think I know what's going on.
> For normal devices, the pm domain attach happens AFTER the device is
> added and fw_devlink has had a chance to set up device links. And if
> the suppliers aren't ready, really_probe() won't get as far as
> dev_pm_domain_attach(). But for amba, the clock and pm domain
> suppliers are "grabbed" before adding the device.
>
> So with that old patch + always returning -EPROBE_DEFER in
> amba_device_add() if amba_read_periphid() fails should fix your issue.
>
> -Saravana
