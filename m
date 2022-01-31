Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FA64A4F3A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbiAaTNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiAaTNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 14:13:34 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EE1C061714;
        Mon, 31 Jan 2022 11:13:33 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so79050pjj.4;
        Mon, 31 Jan 2022 11:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=YZVTL02trY93bXBvFab8GWC4SGTBEHx7xoM5zz31pOg=;
        b=eI59J5vvr0A8RKxUqyE9NUAu6vFBo9JLnOmw0puMQZUEm4dF2MWwJqfR/ZL08CAxWZ
         BnWoSz1sTio7BAV9whmwWT6xUhgWC6Lo5BK4+b2sM6VIImC2/K/OnoTgvKSA94C7mdon
         itSGEALfsQg4ZMdAZ+hZz6HnPPJcZllFKFyICnD2+E8AyYxfPrqC9UOqTS0CeUtdusV1
         D4fD1+rjOl4c4TOP+xFamd2c429GVwsIuvmsUAgjkAklhb5p0GonFbMhGG1gbEVHUG3W
         T9o9E6puaKCHgmEkfQ64cDBJQP0R4HnPSY65B2EhBCUypXC4/lvWzE2EgRcc1SWQbOpz
         19og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=YZVTL02trY93bXBvFab8GWC4SGTBEHx7xoM5zz31pOg=;
        b=tMwOS60CYJSxnMF/9HU/pNASKNCaxS0wnSwG/xP3O9xaKN8uOYMFSFYjxpeCHegtBJ
         uy4VOzgllGRHfNcvvGCoW4sQRCzoJl8Fe+/K7Sp10Cl34rcc23xIcqVtCI3DaKPNJYUG
         IpqUi0ABLz1iNdAOkAsXtRY4YLwwaraEVz60aZEBGxotqhUiKqu6rY4zMJLiBCIz8f+O
         pj1mQoOeHlBxZVSIIN6fqGNnpXGsG4kFRj8He5RX7nBt5hUk6jE2AGoYw/zcymjBWxlr
         J67/tGEzGLlQ0P2t1LySEQous7A5LKCBfbn66BJ/6pfQYuEux7PgevaYLLdM8IXx4+/H
         WwYQ==
X-Gm-Message-State: AOAM5338CrTSd3g9i0zFsEVF+WKG3A2TWzAJIfUsDF8IDHDmfd5Sym4s
        rUdBL8NTKbyn9LAm6SsYGwM=
X-Google-Smtp-Source: ABdhPJxZc+Bj3ecmVnKia223vAFW8JsKNa9KxQkDpM9AJ8KxEqdBZ0FJgWcicwws5wLqU29X67c1ZA==
X-Received: by 2002:a17:902:e885:: with SMTP id w5mr22303795plg.155.1643656413464;
        Mon, 31 Jan 2022 11:13:33 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id mj23sm95941pjb.54.2022.01.31.11.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 11:13:32 -0800 (PST)
Date:   Mon, 31 Jan 2022 11:13:20 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Einon <mark.einon@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Chris Snook <chris.snook@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>, drivers@pensando.io,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Rob Herring <robh@kernel.org>, l.stelmach@samsung.com,
        rafal@milecki.pl, Florian Fainelli <f.fainelli@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Chan <michael.chan@broadcom.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Slark Xiao <slark_xiao@163.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Liming Sun <limings@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Gary Guo <gary@garyguo.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, intel-wired-lan@lists.osuosl.org,
        linux-hyperv@vger.kernel.org, oss-drivers@corigine.com,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH net-next] net: kbuild: Don't default net vendor configs
 to y
Message-ID: <20220131191320.GA24296@hoboy.vegasvil.org>
References: <20220131172450.4905-1-saeed@kernel.org>
 <e9e124b0-4ea0-e84c-cd8e-1c6ad4df9d74@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e9e124b0-4ea0-e84c-cd8e-1c6ad4df9d74@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 10:04:40AM -0800, Shannon Nelson wrote:
> Is there a particular reason to change this?
> Broken compiles?  Bad drivers?  Over-sized output?

Having default Y is a PITA to people working on an embedded design
that has just one working MAC.  It means having to scroll through tons
of empty stuff when doing `make menuconfig`

Thanks,
Richard
