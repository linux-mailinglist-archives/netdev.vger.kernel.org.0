Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64E45846AC
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbiG1TuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiG1TuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:50:09 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B544E95
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 12:50:08 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-10e4449327aso3597875fac.4
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 12:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=spQC5DgL3oN87S+iC1PglEQ45W/HemORZipZMoLzdbo=;
        b=Z3pjI6O9fsHjdX0fd0JMIbiPAuKOZ/jbEfl+8fap+JTqPS44WCC2h0P3V5kbBPb8+x
         arHLTqP0WBbd1ANzqmqVf3CJdfq4Eu3ef4vNfoui4p1Udt5gPsH7EG0SqQOaR3IhuH8N
         D3/Xkt0ez0WrkBj88iC2DELqeI5DtwtnnjysXHyjGzp17v1YBh3wthJ3nNjclGdJYO1P
         Rr3s7wCu9ShcLlg/vhVslWrAbQltfKGVxZZe7rTTele1mdU0JwPiLZ4+1kn7b1VLu1uc
         lu/QZxTE8JLiSmEFJHk/7HPfs3bC86fobhGfCdZvzOfJXVmhd69YkZPhH/detcDK9qZz
         tHGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=spQC5DgL3oN87S+iC1PglEQ45W/HemORZipZMoLzdbo=;
        b=Q73gpmNVe2UCjKjTbVZVvb7GCl5c3qrzC4S+lHvVGy6AgcCMIr3lZLku9/ikfzl+1j
         oP9spgyf5ACsyZ/V0lkPSW0usq4vlC4qXwN5Qjba95zk10wUNlW5usWMGK1A/HQbACSk
         vMOt+JgGBU5TURpfgwQ1H/DIo66HdHdyoS1/lYX/pr4McCHWclJawYRldmgln5xL+Ybd
         g3Y8LpwDufSHv2fGNQKBujcVi4Z9XVBi+8ZXu4GNd0pwPHkCvuFRmPqbxAQeuxh2KzG1
         /FBHLUJbuYY/VidX59/OpGGDBSq5UR4bX8URYhDrizHw6RYf4nItJBWWKPgiq1rzTZNH
         miiQ==
X-Gm-Message-State: AJIora9ziB2+WovO5EFpv1jJGPow3mXVm1riRIPExGF52YGbSTpgQzRF
        RpL1FGu2d95L7/hrSWGBNMqiQnD93gU5UiJATmnB/XSVPQnBLw==
X-Google-Smtp-Source: AGRyM1vSA2JOkaQqBtH9qzmnpbRJvsTC0Bp3SA27Hwqk66QdtarAJd6bAmkwBF0NfeyH35IKczAxtPrwNVBfqOoDbk8=
X-Received: by 2002:a05:6870:a182:b0:10b:efbe:e65d with SMTP id
 a2-20020a056870a18200b0010befbee65dmr519829oaf.5.1659037807922; Thu, 28 Jul
 2022 12:50:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220727064321.2953971-1-mw@semihalf.com> <20220727064321.2953971-7-mw@semihalf.com>
 <20220727143147.u6yd6wqslilspyhw@skbuf> <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
 <20220727163848.f4e2b263zz3vl2hc@skbuf> <CAPv3WKe+e6sFd6+7eoZbA2iRTPhBorD+mk6W+kJr-f9P8SFh+w@mail.gmail.com>
 <CAHp75VfGfKx1fggoE7wf4ndmUv4FEVfV=-EaO0ypescmNqDFkw@mail.gmail.com>
 <CAPv3WKeXtwJRPSaERzo+so+_ZAPSNk5RjxzE+N7u-uNUTMaeKA@mail.gmail.com>
 <20220728091643.m6c5d36pseenrw6l@skbuf> <CAPv3WKd0rbwN2AyGRSG1hUji3KzCdG2S=HfCxk7=Ut3VbmPXGA@mail.gmail.com>
 <20220728191630.wjmm4mfbhrvbolqq@skbuf>
In-Reply-To: <20220728191630.wjmm4mfbhrvbolqq@skbuf>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 28 Jul 2022 21:49:58 +0200
Message-ID: <CAPv3WKdKj+7d03EQ5rCdmqYgK3hKNV7YEYJ8OqaN5pzM5j2ZvA@mail.gmail.com>
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to fwnode_find_net_device_by_node()
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 28 lip 2022 o 21:16 Vladimir Oltean <olteanv@gmail.com> napisa=C5=82(=
a):
>
> On Thu, Jul 28, 2022 at 06:56:48PM +0200, Marcin Wojtas wrote:
> > There was a regression even for OF in v1, but after switching to
> > device_match_fwnode() it works indeed. Anyway patch v4 is imo useful,
> > I'll only reword the commit message.
>
> Do you mean patch 4 or patch v4? If patch 4, of course it's useful, but

Patch 4/8 in v4 :) I'm working on it right now to submit asap.

> not for avoiding a regression with OF (case in which I drop all my claims
> made earlier about fw_find_net_device_by_node), but rather to actually

Change in the mvpp2 driver:
-       dev->dev.of_node =3D port_node;
+       device_set_node(&dev->dev, port_fwnode);
is desired and correct anyway, so as a low-cost change I think it can
be included in this series (which is in fact preparation-to-ACPI
support). I will update the commit message. accordingly.

> get something working with actual ACPI (although perhaps not in this
> series, you'll need to add ACPI IDs in the mv88e6xxx driver some time

v1 added all of this, but we agreed that ACPI-specific bits should be
sent separately later, after extending the ACPI Specification.

> later as well, maybe you could focus this series just on converting DSA
> to play nice with fwnodes). If you're already thinking about the v4 of
> this patch set, I'll respond to that in a separate email shortly.
