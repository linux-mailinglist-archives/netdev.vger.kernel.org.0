Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BD0583B0C
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 11:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbiG1JQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 05:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234498AbiG1JQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 05:16:50 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD822ED61;
        Thu, 28 Jul 2022 02:16:49 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v17so1409899edc.1;
        Thu, 28 Jul 2022 02:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JZTA7sEcHuVqwTMiR1b8+prdzq1UFACrZShtnQ4d+7c=;
        b=nJ9Uke5NT0UcAlgmdam92O+ZHX2NpLHhczrE0gUcNOCPMfzHGIOG9YocdeyQbtoLTz
         8vjMnEobYzSP4ERrc5FipEB+I0Yee9TZ5EMZPrOH8JVPwaRdWMtoGWC2ppPvSB/JjSzc
         3FUj3EnN59v4hYK7Rbqh+jrEYCtphYZq+MPIxesSUPBMGalYZOlP+QBweYlXo89+IzeL
         PJCH2sKt8kRenCqbt9OFy/uuwla5bRYEYhFDzfqJLiX/RW35dOKMQJH54+kaoKFLNwIm
         3N1uBYEO5VOSgrXe+hx8fAfhezbA8yytLn+H2hXEuzqqx9YS2e5/EgY4d56tRdliWFaB
         FKbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JZTA7sEcHuVqwTMiR1b8+prdzq1UFACrZShtnQ4d+7c=;
        b=k77y6O4WkpHfe1xGBdlT84UQf1t7btP7E/SxQxaN65Cx9w8fQWHHmqcAqY9CTxsWzJ
         1qZUVewNyj/eskth2/LZDM3W4wmmHKUHQz1HMln6Zn6EtTfSihABo30UPC4baGtzyDC3
         h/oJaHuNgkcqWjTW1qPVync3VQeQWrt1vbwxGQsvkfXcXu+6fah8ZPjQ2yd4qcYC3OCa
         o8fwzd9r1Xc4vuveGrkpcxCuOYhaldbQpOZNRvFChUFM6vE6ZEbtKicvr9shOaycXIFI
         Lqp/iVaAE7su1RxRXFWFwtbzdd9f6xsW12Geg7eLO5kaa8lNRCUdJggKT9vKJbpDAlfE
         7azg==
X-Gm-Message-State: AJIora/UbRBKCDXUPJc9LC5938w2biCBw2+4hRgIrPI5FZQ5cZt1wZmh
        jdILDTE+XfNFXn08APhP1tY=
X-Google-Smtp-Source: AGRyM1tNG+TryxoFZgHQXlJfYIOTGQ9vYAe1Tx7wFmjpKwlDfGfCBm+FFFUsEqoLp8uxgulIBXwoGA==
X-Received: by 2002:a05:6402:27c9:b0:43a:d14b:1fa5 with SMTP id c9-20020a05640227c900b0043ad14b1fa5mr26427584ede.245.1658999807913;
        Thu, 28 Jul 2022 02:16:47 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id u1-20020a170906408100b0072fa1571c99sm190099ejj.137.2022.07.28.02.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 02:16:46 -0700 (PDT)
Date:   Thu, 28 Jul 2022 12:16:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marcin Wojtas <mw@semihalf.com>
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
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to
 fwnode_find_net_device_by_node()
Message-ID: <20220728091643.m6c5d36pseenrw6l@skbuf>
References: <20220727064321.2953971-1-mw@semihalf.com>
 <20220727064321.2953971-7-mw@semihalf.com>
 <20220727143147.u6yd6wqslilspyhw@skbuf>
 <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
 <20220727163848.f4e2b263zz3vl2hc@skbuf>
 <CAPv3WKe+e6sFd6+7eoZbA2iRTPhBorD+mk6W+kJr-f9P8SFh+w@mail.gmail.com>
 <CAHp75VfGfKx1fggoE7wf4ndmUv4FEVfV=-EaO0ypescmNqDFkw@mail.gmail.com>
 <CAPv3WKeXtwJRPSaERzo+so+_ZAPSNk5RjxzE+N7u-uNUTMaeKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKeXtwJRPSaERzo+so+_ZAPSNk5RjxzE+N7u-uNUTMaeKA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 08:52:04AM +0200, Marcin Wojtas wrote:
> Yes, indeed. After recent update, I think we can assume the current
> implementation of fwnode_find_parent_dev_match should work fine with
> all existing cases.

What you should really be fixing is the commit message of patch 4,
that's what threw me off:

| As a preparation to switch the DSA subsystem from using
| of_find_net_device_by_node() to its more generic fwnode_
| equivalent, the port's device structure should be updated
| with its fwnode pointer, similarly to of_node - see analogous
| commit c4053ef32208 ("net: mvpp2: initialize port of_node pointer").
| 
| This patch is required to prevent a regression before updating
| the DSA API on boards that connect the mvpp2 port to switch,
| such as Clearfog GT-8K or CN913x CEx7 Evaluation Board.

There's no regression to speak of. DSA didn't work with ACPI before, and
fwnode_find_net_device_by_node() still works with the plain dev->of_node
assignment.
