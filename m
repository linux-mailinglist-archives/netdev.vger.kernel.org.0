Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A7A65C0A8
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 14:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237802AbjACNRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 08:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237801AbjACNQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 08:16:46 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA130EA0;
        Tue,  3 Jan 2023 05:16:00 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id t17so73408993eju.1;
        Tue, 03 Jan 2023 05:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NnoWPE1jQ3kYm5s0XhMv2bhJOZqz4qyCDxQboi65+Mo=;
        b=UVPg7nDcLHGMAlKprdPNpgabezsSufjZR4E62AZgq39xyQprvB5VqdG9vBkhqtebgE
         S8lOGYELvqj+RU6B5KVEs9bquQYKobh3in0rnI8lEI/rJ+czEiK4hbrtMmA4q5E/ir4o
         sEgbZSppvAYuxEvJzQttVIhPCxA/0a+nxpqMiLByU6lOwvDjJ2VhirGWBoO5zJOTLQpY
         knwwZh8kclvnuU7BpRIhnC1RupIEKmMhqXvUoyei7DTtCSSCa4dgukDfvevQM6PItaKu
         +iw4V9WS7eIgMu1Ncr0En28bpSdFK19XV9EZiCoelZDSnfPQwDXp8G8kBAo9nsGHWKKg
         U1Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NnoWPE1jQ3kYm5s0XhMv2bhJOZqz4qyCDxQboi65+Mo=;
        b=Ky4qKwb0VmuuuD7/eI8V4fDy60hRGH6vcIh+1BBUHiL18LSF86QLSUcN9a+FaXFvVI
         jit4H9Of/uLx2yEWMHJBM27sGV8EGg459h/mi1N5qzYYt+3N+zqAs5tn0X7s6BCCIcad
         pNLCrxT8Vn/SzM4vblsNHYGqifDVLIZyh8mKZyNNhsqNXgHyqSK4i8zdL/KUusxQD2Wp
         aJsOv4t2ZWh4mw6ItZVusPtDyqjn+Z1zVfzA6fGLPCqteLmVuslTICBJJquiiY5OryEa
         ig1HAE4laYXPBvm2tQqEoJ79tICznRR4mRlXXpT6Mhh1YqQYRQpUacR6Un1Ln3FnlK9M
         +h+w==
X-Gm-Message-State: AFqh2kqUSsIcV55O46HKfc4cCu8LXgvm1Md9ewTWwyMaGiGoeh7v3vDH
        w6l1T7/5RtjlrAIqVQWAtNs=
X-Google-Smtp-Source: AMrXdXvgiqj2LSEPUaEw6z2sRd7nVp5kdlIihi8FpByYeNs/V+YRRvBDcz75iq0OtJOTq78Ige/l/g==
X-Received: by 2002:a17:906:19db:b0:7c0:8578:f4c0 with SMTP id h27-20020a17090619db00b007c08578f4c0mr34871936ejd.67.1672751759096;
        Tue, 03 Jan 2023 05:15:59 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id hk25-20020a170906c9d900b007c094d31f35sm13973542ejb.76.2023.01.03.05.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 05:15:58 -0800 (PST)
Date:   Tue, 3 Jan 2023 15:15:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH RFC net-next v2 06/12] net: mdio: mdio-bitbang: Separate
 C22 and C45 transactions
Message-ID: <20230103131555.5i4tj7sk72gmed5d@skbuf>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-6-ddb37710e5a7@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v2-6-ddb37710e5a7@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 12:07:22AM +0100, Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> The bitbbanging bus driver can perform both C22 and C45 transfers.
> Create separate functions for each and register the C45 versions using
> the new driver API calls.
> 
> The SH Ethernet driver places wrappers around these functions. In
> order to not break boards which might be using C45, add similar
> wrappers for C45 operations.
> 
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Incomplete conversion, this breaks the build. Need to update all users
of the bitbang driver (also davinci_mdio). Something like the diff below
fixes that, but it leaves the davinci_mdio driver in a partially
converted state (if data->manual_mode is true, new API is used,
otherwise old API is used). So another patch to convert the other case
will likely be needed.

diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index 946b9753ccfb..23169e36a3d4 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -225,7 +225,7 @@ static int davinci_get_mdio_data(struct mdiobb_ctrl *ctrl)
 	return test_bit(MDIO_PIN, &reg);
 }
 
-static int davinci_mdiobb_read(struct mii_bus *bus, int phy, int reg)
+static int davinci_mdiobb_read_c22(struct mii_bus *bus, int phy, int reg)
 {
 	int ret;
 
@@ -233,7 +233,7 @@ static int davinci_mdiobb_read(struct mii_bus *bus, int phy, int reg)
 	if (ret < 0)
 		return ret;
 
-	ret = mdiobb_read(bus, phy, reg);
+	ret = mdiobb_read_c22(bus, phy, reg);
 
 	pm_runtime_mark_last_busy(bus->parent);
 	pm_runtime_put_autosuspend(bus->parent);
@@ -241,8 +241,8 @@ static int davinci_mdiobb_read(struct mii_bus *bus, int phy, int reg)
 	return ret;
 }
 
-static int davinci_mdiobb_write(struct mii_bus *bus, int phy, int reg,
-				u16 val)
+static int davinci_mdiobb_write_c22(struct mii_bus *bus, int phy, int reg,
+				    u16 val)
 {
 	int ret;
 
@@ -250,7 +250,41 @@ static int davinci_mdiobb_write(struct mii_bus *bus, int phy, int reg,
 	if (ret < 0)
 		return ret;
 
-	ret = mdiobb_write(bus, phy, reg, val);
+	ret = mdiobb_write_c22(bus, phy, reg, val);
+
+	pm_runtime_mark_last_busy(bus->parent);
+	pm_runtime_put_autosuspend(bus->parent);
+
+	return ret;
+}
+
+static int davinci_mdiobb_read_c45(struct mii_bus *bus, int phy, int devad,
+				   int reg)
+{
+	int ret;
+
+	ret = pm_runtime_resume_and_get(bus->parent);
+	if (ret < 0)
+		return ret;
+
+	ret = mdiobb_read_c45(bus, phy, devad, reg);
+
+	pm_runtime_mark_last_busy(bus->parent);
+	pm_runtime_put_autosuspend(bus->parent);
+
+	return ret;
+}
+
+static int davinci_mdiobb_write_c45(struct mii_bus *bus, int phy, int devad,
+				    int reg, u16 val)
+{
+	int ret;
+
+	ret = pm_runtime_resume_and_get(bus->parent);
+	if (ret < 0)
+		return ret;
+
+	ret = mdiobb_write_c45(bus, phy, devad, reg, val);
 
 	pm_runtime_mark_last_busy(bus->parent);
 	pm_runtime_put_autosuspend(bus->parent);
@@ -573,8 +607,10 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 	data->bus->name		= dev_name(dev);
 
 	if (data->manual_mode) {
-		data->bus->read		= davinci_mdiobb_read;
-		data->bus->write	= davinci_mdiobb_write;
+		data->bus->read		= davinci_mdiobb_read_c22;
+		data->bus->write	= davinci_mdiobb_write_c22;
+		data->bus->read_c45	= davinci_mdiobb_read_c45;
+		data->bus->write_c45	= davinci_mdiobb_write_c45;
 		data->bus->reset	= davinci_mdiobb_reset;
 
 		dev_info(dev, "Configuring MDIO in manual mode\n");
