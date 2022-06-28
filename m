Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6362E55E94D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347121AbiF1OAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346506AbiF1OAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:00:32 -0400
Received: from sym2.noone.org (sym.noone.org [178.63.92.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54ABE369D4;
        Tue, 28 Jun 2022 07:00:30 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4LXR7Z2Gb9zvjfm; Tue, 28 Jun 2022 16:00:26 +0200 (CEST)
Date:   Tue, 28 Jun 2022 16:00:26 +0200
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Al Cooper <alcooperx@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vineet Gupta <vgupta@kernel.org>,
        Richard Genoud <richard.genoud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Baruch Siach <baruch@tkos.co.il>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Taichi Sugaya <sugaya.taichi@socionext.com>,
        Takao Orito <orito.takao@socionext.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Pali Rohar <pali@kernel.org>,
        Andreas Farber <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hammer Hsieh <hammerh0314@gmail.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Timur Tabi <timur@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <robh@kernel.org>,
        sascha hauer <sha@pengutronix.de>, peng fan <peng.fan@nxp.com>,
        kevin hilman <khilman@kernel.org>,
        ulf hansson <ulf.hansson@linaro.org>,
        len brown <len.brown@intel.com>, pavel machek <pavel@ucw.cz>,
        joerg roedel <joro@8bytes.org>, will deacon <will@kernel.org>,
        andrew lunn <andrew@lunn.ch>,
        heiner kallweit <hkallweit1@gmail.com>,
        eric dumazet <edumazet@google.com>,
        jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>,
        linus walleij <linus.walleij@linaro.org>,
        hideaki yoshifuji <yoshfuji@linux-ipv6.org>,
        david ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org,
        linux-rpi-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-snps-arc@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-actions@lists.infradead.org,
        linux-unisoc@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        sparclinux@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH v1 2/2] serial: Set probe_no_timeout for all DT based
 drivers
Message-ID: <20220628140025.qpom64ptru4ub6fu@distanz.ch>
References: <20220628020110.1601693-1-saravanak@google.com>
 <20220628020110.1601693-3-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628020110.1601693-3-saravanak@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-28 at 04:01:03 +0200, Saravana Kannan <saravanak@google.com> wrote:
> diff --git a/drivers/tty/serial/8250/8250_acorn.c b/drivers/tty/serial/8250/8250_acorn.c
> index 758c4aa203ab..5a6f2f67de4f 100644
> --- a/drivers/tty/serial/8250/8250_acorn.c
> +++ b/drivers/tty/serial/8250/8250_acorn.c
> @@ -114,7 +114,6 @@ static const struct ecard_id serial_cids[] = {
>  static struct ecard_driver serial_card_driver = {
>  	.probe		= serial_card_probe,
>  	.remove		= serial_card_remove,
> -	.id_table	= serial_cids,

Is this change intentional? All other drivers are only changed to set
.probe_no_time and I don't see anything mentioned in the commit message
re. this driver's change.
