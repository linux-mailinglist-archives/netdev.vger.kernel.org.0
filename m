Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC914A606B
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 16:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240531AbiBAPqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 10:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240503AbiBAPqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 10:46:38 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614A9C061714;
        Tue,  1 Feb 2022 07:46:38 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id x11so15704204plg.6;
        Tue, 01 Feb 2022 07:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1duiPJ9D66APDOG7Cvkpnw8gTrrTPpxxkkLXVcyp5tw=;
        b=nqkFhijWUsAOnFQSY7L7+PowKwdvHdK6mYqeIIu5lFEA9EF9QMNkf7Bt/Zx/QDohq6
         YivAU+vRTU1EuuvUH66yetuUUDOhpWh1a/uCc8loQ3/9Cvk9APRyLAXnx/l59lMt4Dcm
         V0SmMxn9cjPWWBt/gcpFD8KO1JmU+NYm9TSGXbHj/FS9QNs1E8XtO3wlJeg5rLUG6c9O
         GBE1BtLn45PDjPgxoVJsunD3YhQnrreRscE0qeYB5YVZoMVQIL5aQ5cxul8S+UQtdHdI
         7jJRpxUO6bPC+A2/WHNlrA/CsCPLWOie7tOtSrT2dAXkAfpkgXwdtBsiQGOCgN3OK34s
         gJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1duiPJ9D66APDOG7Cvkpnw8gTrrTPpxxkkLXVcyp5tw=;
        b=R7gfBMjlaF5BkhVtMRZGOC7QtQHr9Vu9+K1tweocQVBsGcX9Y/KvmlxnuXnqTrfyWo
         9o7EYypqCsfNLCuMZP2xpkavDRBH8Z9EHWDKXPHknXQyl8T6STzV+fZPDSfXLu4dtCoL
         rA8bSR+L9TzZu7AGEvvdD/fj5u+WWg4aMUebwWxMBUEgpS/zwD7mBV/n8cwSBUmr+GSK
         No4Rn78oLLUtB0JEjjUEagREHqNHFj8i1pOK1Mi7UIQVZUWDCP95+4TBIfcOOyGE8E7f
         qpskGXnx22WBOvUz0dlgroziaZrrByGBJseMQQTBgJWTNR5Fop7NHe2I74IljRTKO37b
         XDFQ==
X-Gm-Message-State: AOAM532hfQ4PhMHNFrzgD8eIsR7/IMEJfSQ+HXw+uQ5ByFjUDZE5FxoD
        L0KnqjWrIJVqyx3ZUItEvMo=
X-Google-Smtp-Source: ABdhPJzsNX0ywpu34jXrUJ51YqKK9UTipV04rCv1O/FWGJmbyHYcax9i3DTkKCaIHErb5dmhU7X9lA==
X-Received: by 2002:a17:90b:4d05:: with SMTP id mw5mr3003128pjb.34.1643730397808;
        Tue, 01 Feb 2022 07:46:37 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id m21sm23278793pfk.26.2022.02.01.07.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 07:46:37 -0800 (PST)
Date:   Tue, 1 Feb 2022 07:46:24 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Hisashi T Fujinaka <htodd@twofifty.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        David Awogbemila <awogbemila@google.com>,
        Linus Walleij <linus.walleij@linaro.org>, rafal@milecki.pl,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-sunxi@lists.linux.dev, Jiri Pirko <jiri@resnulli.us>,
        l.stelmach@samsung.com, Shay Agroskin <shayagr@amazon.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, Jon Mason <jdmason@kudzu.us>,
        Shannon Nelson <snelson@pensando.io>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Chris Snook <chris.snook@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Gabriel Somlo <gsomlo@gmail.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Shai Malin <smalin@marvell.com>,
        Maxime Ripard <mripard@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, drivers@pensando.io,
        Omkar Kulkarni <okulkarni@marvell.com>,
        linux-arm-kernel@lists.infradead.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        David Arinzon <darinzon@amazon.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Catherine Sullivan <csully@google.com>,
        linux-hyperv@vger.kernel.org, oss-drivers@corigine.com,
        Noam Dagan <ndagan@amazon.com>, Rob Herring <robh@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Dexuan Cui <decui@microsoft.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>, Joel Stanley <joel@jms.id.au>,
        Simon Horman <simon.horman@corigine.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Liming Sun <limings@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Mark Einon <mark.einon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Slark Xiao <slark_xiao@163.com>, Gary Guo <gary@garyguo.net>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Marcin Wojtas <mw@semihalf.com>,
        David Thompson <davthompson@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [Intel-wired-lan] [PATCH net-next] net: kbuild: Don't default
 net vendor configs to y
Message-ID: <20220201154624.GA4432@hoboy.vegasvil.org>
References: <20220131172450.4905-1-saeed@kernel.org>
 <20220131095905.08722670@hermes.local>
 <CAMuHMdU17cBzivFm9q-VwF9EG5MX75Qct=is=F2h+Kc+VddZ4g@mail.gmail.com>
 <20220131183540.6ekn3z7tudy5ocdl@sx1>
 <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
 <09c97169-5f9a-fc8f-dea5-5423e7bfef34@twofifty.com>
 <Yfj2GTH3tHraprl0@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yfj2GTH3tHraprl0@unreal>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 10:58:01AM +0200, Leon Romanovsky wrote:
> No, kernel configs never were declared as ABI as "regular" users are not
> supposed to touch it. They use something provided by the distro.

+1
