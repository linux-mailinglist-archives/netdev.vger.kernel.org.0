Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D8A58447D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbiG1Q5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiG1Q5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:57:03 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A071858B50
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:56:59 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-10bd4812c29so2992466fac.11
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+neT7drnhUVN6IEwt5cqIrCpyz1zNkYGzrU5Sn+25po=;
        b=N/sgs+QuFpuUwFiUZBjJm6IQrlOlMhIiDya+kN2jqxag5eodzaya5QHHvG90yHGR6J
         ilM6y/ORThHfyVxS8edWpoQPrqBRXQiG9Wo7TpM26TPXMMvOZWJFi4ILQ1s/nARzg30c
         Jz9kIepJRc+HYrdrE5UP2EoKTLpt++h1/3cnDxUP7bFAR+uGKhL2Cb4OQdr2JkMAR1xf
         yaN/x3fcTzhubwXLDbPNia9IbwL/tUfDyMNVSoYLqEjY9NvkcrtSTP4CJbHyx1luCNbk
         5aW0yJzTpZ5Q1duc0tw4HOY+tlAl9w1M1fcmapGLnqz6FyOj+iSeG7NOC/mY1Y9kvowb
         izaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+neT7drnhUVN6IEwt5cqIrCpyz1zNkYGzrU5Sn+25po=;
        b=lFPpQt2P8JDQlaQlUbh3Bl0DJyuGtTymxuLtIczsxCRE/a3R+Wvakx6LUWfcZGqpq2
         HGFsz+pSH9lGopRfl5H7KsoBYcWZU31hDXuYBQeBTc0tn2l0rp9qQEAPrSk9AO/wDcoR
         Nq9CT8hvCUtyvC6a9k2SzvJ7uJlPbPYqOjfIY+tX5Piw/050V6sNiwInATqguDE8N7yC
         Hz8lLULadWJJYlEtAi8IP7anMgjc9/2vbFcJpuaApkcyLFmB4PT20hi15932GXgEKUH5
         nDShcBJ63UHSP0E28NBIWTjZsS9urU8N7UvyBKFRp1LugsB6XqJvOeaBK/bBghGHyNTV
         726g==
X-Gm-Message-State: AJIora8M/COR61y3D5txDGFze8SnwxFDJH/5eUBIazHjOf5yuitTf3Bh
        3Wt59sz9jd+BFWEtg6PIe9yx+KxzDNIBLFT8UlXIlg==
X-Google-Smtp-Source: AGRyM1s2wYwcYRLI1t8oGbHlSkYF7nki9R79iqP4GkO+sJM610lF9/jDXBRf6KuYUgt99I2pgHY/3R8xIXBCqcBgUmo=
X-Received: by 2002:a05:6870:4186:b0:101:17ef:d966 with SMTP id
 y6-20020a056870418600b0010117efd966mr173601oac.97.1659027418891; Thu, 28 Jul
 2022 09:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220727064321.2953971-1-mw@semihalf.com> <20220727064321.2953971-7-mw@semihalf.com>
 <20220727143147.u6yd6wqslilspyhw@skbuf> <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
 <20220727163848.f4e2b263zz3vl2hc@skbuf> <CAPv3WKe+e6sFd6+7eoZbA2iRTPhBorD+mk6W+kJr-f9P8SFh+w@mail.gmail.com>
 <CAHp75VfGfKx1fggoE7wf4ndmUv4FEVfV=-EaO0ypescmNqDFkw@mail.gmail.com>
 <CAPv3WKeXtwJRPSaERzo+so+_ZAPSNk5RjxzE+N7u-uNUTMaeKA@mail.gmail.com> <20220728091643.m6c5d36pseenrw6l@skbuf>
In-Reply-To: <20220728091643.m6c5d36pseenrw6l@skbuf>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 28 Jul 2022 18:56:48 +0200
Message-ID: <CAPv3WKd0rbwN2AyGRSG1hUji3KzCdG2S=HfCxk7=Ut3VbmPXGA@mail.gmail.com>
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

czw., 28 lip 2022 o 11:16 Vladimir Oltean <olteanv@gmail.com> napisa=C5=82(=
a):
>
> On Thu, Jul 28, 2022 at 08:52:04AM +0200, Marcin Wojtas wrote:
> > Yes, indeed. After recent update, I think we can assume the current
> > implementation of fwnode_find_parent_dev_match should work fine with
> > all existing cases.
>
> What you should really be fixing is the commit message of patch 4,
> that's what threw me off:
>
> | As a preparation to switch the DSA subsystem from using
> | of_find_net_device_by_node() to its more generic fwnode_
> | equivalent, the port's device structure should be updated
> | with its fwnode pointer, similarly to of_node - see analogous
> | commit c4053ef32208 ("net: mvpp2: initialize port of_node pointer").
> |
> | This patch is required to prevent a regression before updating
> | the DSA API on boards that connect the mvpp2 port to switch,
> | such as Clearfog GT-8K or CN913x CEx7 Evaluation Board.
>
> There's no regression to speak of. DSA didn't work with ACPI before, and
> fwnode_find_net_device_by_node() still works with the plain dev->of_node
> assignment.

There was a regression even for OF in v1, but after switching to
device_match_fwnode() it works indeed. Anyway patch v4 is imo useful,
I'll only reword the commit message.

Thanks,
Marcin
