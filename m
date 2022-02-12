Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25214B32E1
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 04:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiBLDjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 22:39:37 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiBLDjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 22:39:35 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1CAD98
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 19:39:31 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id s2so218597pfg.12
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 19:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oqdkR58UK3kjW1XBm1BWQqHCRPBTO2ZBlDkNE40lOk0=;
        b=qtaw2ZItX+pv8sJHQ72a2xHQlP/sygLvHzVrYuScGNyqwpAlfNuFkI+QDOnC85lgVS
         XHQcHgokHMd+X1l4BG/xPgkjX40J33X/fjx2eempXrxN3Im6+vMDqx+Q27y46iOkDiez
         er6Kiag1ZT6aidJOwcCU3ezQvyD8g3eKKapGwBqPutdrtWU4SgDJ6nD/zc1tryFZ8TO+
         aaLkQ2kOQoYsFMwZzytYqBR5z2CucLAavZCGqjpwlLYfGi7G7xQIUbs7lwqjfPigZtkv
         E0EdLuPASBEonpCH99C0Z4M2Q2dARf8Ylsh5eS0Qg1pIaauQXgTPZzegX18ym/+F8Drl
         SsjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oqdkR58UK3kjW1XBm1BWQqHCRPBTO2ZBlDkNE40lOk0=;
        b=ENdy+nqXc9HNsqE5PBdxKFd1Qxa2rnRvg79O8tPYCLM7UKRGZ7eKLeuFQ5TIOzVa5y
         k27ftoKeEVySqhKBxb+wEooFk6AaOUWKSW8ab4Rp7ywjY3N7RF3MkZkIOdgZerlFN+u7
         gwfSTBv08z/NuZ4bHjkUaBRHLHq6BUKJsrbEyVbnErPq9hi/H4VoJERey8Obj0Er8pDM
         LvnI8yJa5PkJNbLumaGwsDMIFAVVrEUkLcCMX7Z703+GJd3bSXxYFj0J6tciAlF3VdtW
         67r2tpDNqsCkWkDnWWWBnRsFWoilEwP3RfBGHMIpzdHztn9o9rhrPA0u/2mu3HZq01Di
         tApQ==
X-Gm-Message-State: AOAM533vShA9IgI5GEVdnCPB/q24HuvTiTclaanhY1BmuufcfUTALdTE
        4vlPthLS0hi9g+D5LDCJNVVu7d/56rZOdRnmGZU=
X-Google-Smtp-Source: ABdhPJzT9V6bi0XVWI59nHo211ROkNnEcfm0nyZ1eoShb+BIentE6jOQAEiAcfpMP9DSImmX2QuJM3xr04kAfrAZ2Hg=
X-Received: by 2002:a05:6a00:793:: with SMTP id g19mr4629015pfu.21.1644637171165;
 Fri, 11 Feb 2022 19:39:31 -0800 (PST)
MIME-Version: 1.0
References: <CAJq09z7Hu-dswU41km=L2YFbKyHUJ9JkDjUGwQN5RQqowY0=1A@mail.gmail.com>
 <20220211051140.3785-1-luizluca@gmail.com> <87fsopwxtn.fsf@bang-olufsen.dk>
In-Reply-To: <87fsopwxtn.fsf@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 12 Feb 2022 00:39:20 -0300
Message-ID: <CAJq09z61iuJXwsPZLe0+drKgTXBmYoH81CWuBPL7=5Bb46vLUA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: OF-ware slave_mii_bus (RFC)
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -924,7 +926,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
> >
> >               dsa_slave_mii_bus_init(ds);
> >
> > -             err = mdiobus_register(ds->slave_mii_bus);
> > +             dn = of_get_child_by_name(ds->dn, "mdio");
>
> of_node_put(dn) after registration? Or else who will put it?

Thanks Alvin, I'll need some help here.

Is it expected for every code that receives a device_node and keeps a
reference to it to call of_node_get()?  I checked of_get_child_by_name
and it seems it just parses the device_node but does not save it.
I'll put it after the registration.

I got confused looking at the dsa_port->dn usage. It is initialized at
dsa_switch_parse_ports_of() with:

for_each_available_child_of_node() {
      ...
      dsa_port_parse_of(dp, port);
}

dsa_port_parse_of(dp, dn) {
      dp->dn = dn;
      ...
}

But nobody calls of_node_put(port) when there is no error.

Should it have used a of_node_put(port) after dsa_port_parse_of() is
called and 'dp->dn = of_node_get(dn)' with a corresponding
of_node_put() when the port is destroyed?

And I dropped "ds->dn" as I can use "ds->dev->of_node". The code
indicates it can be null but it looks like all methods I use seem to
play nice with null values. It's getting even smaller:

 #include <linux/slab.h>
#include <linux/rtnetlink.h>
#include <linux/of.h>
+#include <linux/of_mdio.h>
#include <linux/of_net.h>
#include <net/devlink.h>
#include <net/sch_generic.h>
@@ -869,6 +870,7 @@ static int dsa_switch_setup_tag_protocol(struct
dsa_switch *ds)
static int dsa_switch_setup(struct dsa_switch *ds)
{
       struct dsa_devlink_priv *dl_priv;
+       struct device_node *dn;
       struct dsa_port *dp;
       int err;

@@ -924,7 +926,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)

               dsa_slave_mii_bus_init(ds);

-               err = mdiobus_register(ds->slave_mii_bus);
+               dn = of_get_child_by_name(ds->dev->of_node, "mdio");
+
+               err = of_mdiobus_register(ds->slave_mii_bus, dn);
+               of_node_put(dn);
               if (err < 0)
                       goto free_slave_mii_bus;
       }

Regards,

Luiz
