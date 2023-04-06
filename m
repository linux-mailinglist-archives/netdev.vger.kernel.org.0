Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2BD66D93E8
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 12:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbjDFKZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 06:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237010AbjDFKZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 06:25:35 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F8A55B4;
        Thu,  6 Apr 2023 03:25:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680776692; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Cjs+XBV8Gu0KGOQFrhBmtUdPH6mSx/zabc0UXppUBcomoj8H64sVduwwQBzhN5QIjQV6bg/8iFJkZlzrURFcxDGpuY99MdR4ZTeJX4A6LIX9rf9U3DauKgjFpiDH+WRvhVIvGZNSmX9SCtFFuaFyJnhZjFA9GNiqE+cu9zdYvpY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680776692; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=aKkAM3NtQAerwJ+wJavlq1ECKj7FR7c0TY3j7Hm+11M=; 
        b=jH3ESseDVSFPtC7Et2RwsXwcCPqjCkMqq88JY8BdHPEijMeskkGShBZIuO40LMeHnvOCWKlNzm+dbBTrlYfku9dG9LuP7p9Ho7Uy3q4j4AD8LMz4f9YJpf5vkVT2S8DVEXkDL7+9BUYclT6acBRIl3wmMHnx75gDpXeZyTgtPQQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680776692;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=aKkAM3NtQAerwJ+wJavlq1ECKj7FR7c0TY3j7Hm+11M=;
        b=cBhKMOAQ/qPqFfGu9Tir3tuBiWJl7fiTNs47Logi6CaloU7PzCCXbUVoq2ZwbxtD
        mpN4ngp/yWDywmSXIUPABRocell4f2WPuJzJDnOyDj7u5LRBbyd/oYU8SiksYyCO7FA
        V0HT1m/fMrUiDwALPniZmemNdHhUld7QDdB10xsw=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680776691384567.9733051958792; Thu, 6 Apr 2023 03:24:51 -0700 (PDT)
Message-ID: <79934b31-47ed-f2c7-03b6-fb2c2e95aa2d@arinc9.com>
Date:   Thu, 6 Apr 2023 13:24:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: fix port specifications
 for MT7988
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230406100445.52915-1-arinc.unal@arinc9.com>
Content-Language: en-US
In-Reply-To: <20230406100445.52915-1-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port 6 configuration is shared so it's simpler to put a label.

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 6fbbdcb5987f..009f2c0948d6 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2548,7 +2548,7 @@ static void mt7988_mac_port_get_caps(struct dsa_switch *ds, int port,
  	phy_interface_zero(config->supported_interfaces);
  
  	switch (port) {
-	case 0 ... 4: /* Internal phy */
+	case 0 ... 3: /* Internal phy */
  		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
  			  config->supported_interfaces);
  		break;
@@ -2710,37 +2710,50 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
  	struct mt7530_priv *priv = ds->priv;
  	u32 mcr_cur, mcr_new;
  
-	switch (port) {
-	case 0 ... 4: /* Internal phy */
-		if (state->interface != PHY_INTERFACE_MODE_GMII &&
-		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
+	if (priv->id == ID_MT7988) {
+		switch (port) {
+		case 0 ... 3: /* Internal phy */
+			if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
+				goto unsupported;
+			break;
+		case 6: /* Port 6, a CPU port. */
+			goto port6;
+		default:
  			goto unsupported;
-		break;
-	case 5: /* Port 5, a CPU port. */
-		if (priv->p5_interface == state->interface)
+		}
+	} else {
+		switch (port) {
+		case 0 ... 4: /* Internal phy */
+			if (state->interface != PHY_INTERFACE_MODE_GMII)
+				goto unsupported;
  			break;
+		case 5: /* Port 5, a CPU port. */
+			if (priv->p5_interface == state->interface)
+				break;
  
-		if (mt753x_mac_config(ds, port, mode, state) < 0)
-			goto unsupported;
+			if (mt753x_mac_config(ds, port, mode, state) < 0)
+				goto unsupported;
  
-		if (priv->p5_intf_sel == P5_INTF_SEL_GMAC5 ||
-		    priv->p5_intf_sel == P5_INTF_SEL_GMAC5_SGMII)
-			priv->p5_interface = state->interface;
-		break;
-	case 6: /* Port 6, a CPU port. */
-		if (priv->p6_interface == state->interface)
+			if (priv->p5_intf_sel == P5_INTF_SEL_GMAC5 ||
+			priv->p5_intf_sel == P5_INTF_SEL_GMAC5_SGMII)
+				priv->p5_interface = state->interface;
  			break;
+		case 6: /* Port 6, a CPU port. */
+port6:
+			if (priv->p6_interface == state->interface)
+				break;
  
-		if (mt753x_mac_config(ds, port, mode, state) < 0)
-			goto unsupported;
+			if (mt753x_mac_config(ds, port, mode, state) < 0)
+				goto unsupported;
  
-		priv->p6_interface = state->interface;
-		break;
-	default:
+			priv->p6_interface = state->interface;
+			break;
+		default:
  unsupported:
-		dev_err(ds->dev, "%s: unsupported %s port: %i\n",
-			__func__, phy_modes(state->interface), port);
-		return;
+			dev_err(ds->dev, "%s: unsupported %s port: %i\n",
+				__func__, phy_modes(state->interface), port);
+			return;
+		}
  	}
  
  	mcr_cur = mt7530_read(priv, MT7530_PMCR_P(port));

Arınç
