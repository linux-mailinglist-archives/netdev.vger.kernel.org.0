Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8ED4A7470
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 16:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241541AbiBBPRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 10:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiBBPRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 10:17:21 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE77EC061714;
        Wed,  2 Feb 2022 07:17:20 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id v74so19083132pfc.1;
        Wed, 02 Feb 2022 07:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gjQNFw/Fp3MO2yyuXpW642AA94J7qHf7TT53TRKjI7Y=;
        b=qnCHM5SY/YCvlEKbicyw5bEBLDVCcxSTc3cpUOS3mnpX9g+wGvBeEoDy0ZZ7sSLGrX
         W0wPMIX1wfs3UKEgk4Ys3ZjoQFYgi6BYzE5YSGh3rcWwyDOKJ/h7sDWh/Vl5bYcmkGqL
         amCWnBg10PPx9oZP3w5X6KJwTHGFuqwKqWGf+GwUsrrBlniZLbqySYaXdD8YL+LdPnwv
         5tbLs+p6PmAw5L7Y0CsezUd5kCqEUFJtoLAuqdmoZ7jsYzVtVE3AFLBbqHeaGuSP2vGy
         tXJbq5Gf2GdUD02aDhKZJyCYFGR0hhEE3zq31L68Wq49WW9FLW7GxfmnykbmMBlieMF9
         XaUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gjQNFw/Fp3MO2yyuXpW642AA94J7qHf7TT53TRKjI7Y=;
        b=UeJpExhPoYhilbv7fSDEICdpgoHseaMXd3i/o9rNoaQvVstyLtmZYElodi7DY1rs2Z
         aEfiQ3ZPReOy7fFePVcjf3XMuCjdpgXl+mJ40TGT2pBNwmIEqPDm09sM9Ay0+ky376Wx
         BjndUAeL3LYI4z3VWzuY6hl1DB+kOjFtHzEBwkzVmMAIVD+O/fPmCs/pEwd2XbUZRCVq
         sb4ERkIizuj4OqQlq+ceI430wyZidJT9Fo4Xli042Qy9dmhELPPFt0uAS8sJt8R4iVwa
         b5yvB3vnClEPs0DvrOvB5FKlB8YSyC3nwnKiQivrfUKpORaeYT8IP+DrRn2kY01W7bG6
         5ZUQ==
X-Gm-Message-State: AOAM532LTDtjuBknRsttvEv9mtORedYs+fQTl2t/RM9JDnoP08uzwZfQ
        jeXiXjidghTW1Ay0gGQLWn8=
X-Google-Smtp-Source: ABdhPJyXTrBYN22CJnV1AiS1a3klGMo9MFYNpVzHW8Jr8yAJkP4fXxNhmbqwlGMH/GxhG7ABXi2bmw==
X-Received: by 2002:a63:5b58:: with SMTP id l24mr24861240pgm.418.1643815040089;
        Wed, 02 Feb 2022 07:17:20 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h18sm26265177pfh.51.2022.02.02.07.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 07:17:19 -0800 (PST)
Date:   Wed, 2 Feb 2022 07:17:07 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
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
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Rob Herring <robh@kernel.org>,
        "l.stelmach@samsung.com" <l.stelmach@samsung.com>,
        "rafal@milecki.pl" <rafal@milecki.pl>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Chan <michael.chan@broadcom.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Slark Xiao <slark_xiao@163.com>,
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
        Gary Guo <gary@garyguo.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: Re: [PATCH net-next] net: kbuild: Don't default net vendor configs
 to y
Message-ID: <20220202151707.GA2365@hoboy.vegasvil.org>
References: <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
 <20220131121027.4fe3e8dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7dc930c6-4ffc-0dd0-8385-d7956e7d16ff@gmail.com>
 <20220131151315.4ec5f2d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <dd1497ca-b1da-311a-e5fc-7c7265eb3ddf@gmail.com>
 <20220202044603.tuchbk72iujdyxi4@sx1>
 <20220201205818.2f28cfe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220202051609.h55eto4rdbfhw5t7@sx1>
 <8566b1e3-2c99-1e63-5606-aad8525a5378@csgroup.eu>
 <20220202064950.qyomo7ns27mbedds@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202064950.qyomo7ns27mbedds@sx1>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 10:49:50PM -0800, Saeed Mahameed wrote:
> I can't think of a clever easily verifiable way to map boards to their VENDORS.
> Add to that dispersing the VENDORS configs accurately.

Just an idea...

1. make foo_defconfig
2. for each vendor, do scripts/config --disable vendor
3. make savedefconfig
4. compare defconfig with foo_defconfig
   difference means some MAC was removed

HTH,
Richard
