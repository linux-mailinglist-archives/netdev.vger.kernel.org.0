Return-Path: <netdev+bounces-4099-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D0270AD76
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 12:31:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06A0C281024
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 10:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C323A59;
	Sun, 21 May 2023 10:31:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500DBA29
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 10:31:14 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5BEE7A;
	Sun, 21 May 2023 03:28:14 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f41d087b3bso49835875e9.0;
        Sun, 21 May 2023 03:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684664893; x=1687256893;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EDi/bV4t8FuHg0kLhL6xrOY9UnW1rRP8TKkwFlbWsok=;
        b=WGEiRTS0hwmpHaG4o6Qd+CjuRerdMAMZCmtvy+JKDEX51m7rMBkqEybPP1OkUyRpry
         rrpQwhrW1DmXyj+bNT6LP2ZtMfj+kgERp1HRbnOB83XR9mrrPJ8WYVsMUm65BOyqZSmA
         gAMXDDbceLKcAMkIvkphCUjUi4n9xkQPgTKbj/XnjXwsvxTvghHT0m/ZqA1PRqAkM17b
         ix/giuz9empZ5F+c3TZ1xM7+fMhJC8KuotY5Ujg+Qpty3Q5wKRk2DW2+O6KKjTfYkHhU
         nvsm264cRKutBCXMR0KbMcfAziHwR+r4n1GSo1RLjOSoeKRNSLsNeuJ0U2OjY+TSORFT
         mogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684664893; x=1687256893;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EDi/bV4t8FuHg0kLhL6xrOY9UnW1rRP8TKkwFlbWsok=;
        b=QAGLnvKl+LXCWWlx2hoygasuWhm1wcz2FUTX3OOYcF3fJxbYXFFw5UIuswYWU3lQ1U
         FuSwM8spUJQi6ZUswXesQrc0R1iERAGoeWLvv0azaf4PXZqOz7qpdpzJNIaOsrgoGEnu
         iNBkssfhpWeDMWUe/J8v9tNJC2VqTzwzNhOopwaDuy8zDO11UOI/mfcfgYQt0Ic+NdDV
         gIuCPJygf8WHbaWiakW6Gof3xgDJWv8S0/ERXKdtSlKUPr9zGpPy0GqME6o2r2r2H3Fn
         07v7+5ShXO879HLj6BhAmvi4am9KvMWfVpAa4h19eevde4YLUxTe2Himd2tN3j0b9rt/
         EQsA==
X-Gm-Message-State: AC+VfDyYKsuTiu809ia5dZa5cHPeT55M56xLwmGwSkyhMvltH0FK4aqa
	vqNBMp4i8oyQs2ijS5VhInA=
X-Google-Smtp-Source: ACHHUZ5+rx9X9ugCqBQMsdH8+Y+g0erFQZ4tqSfXn10BM4X5Xjd6W89H6Vc4p7ud3qN1lcPDY+YAPQ==
X-Received: by 2002:a7b:cb91:0:b0:3f6:1a9:b9db with SMTP id m17-20020a7bcb91000000b003f601a9b9dbmr1289831wmi.21.1684664892392;
        Sun, 21 May 2023 03:28:12 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id y21-20020a7bcd95000000b003f4e8530696sm4740414wmj.46.2023.05.21.03.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 03:28:11 -0700 (PDT)
Date: Sun, 21 May 2023 13:28:09 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Woojung Huh <woojung.huh@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	UNGLinuxDriver@microchip.com,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 1/2] net: dsa: microchip: ksz8: Make flow
 control, speed, and duplex on CPU port configurable
Message-ID: <20230521102809.i3o55e4nuuy7dtdu@skbuf>
References: <20230519124700.635041-1-o.rempel@pengutronix.de>
 <20230519124700.635041-2-o.rempel@pengutronix.de>
 <20230519143004.luvz73jiyvnqxk4y@skbuf>
 <20230519185015.GA18246@pengutronix.de>
 <20230519203449.pc5vbfgbfc6rdo6i@skbuf>
 <20230520050317.GC18246@pengutronix.de>
 <20230520151708.24duenxufth4xsh5@skbuf>
 <20230521043841.GA22442@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230521043841.GA22442@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 21, 2023 at 06:38:41AM +0200, Oleksij Rempel wrote:
> Looks good, I like the idea with "wacky" registers!
> 
> Would you prefer that I start working on adapting your patch set to the
> KSZ8873? Or should I make a review to move forward the existing patch set?
> 
> Just a heads up, I don't have access to the KSZ87xx series switches, so
> I won't be able to test the changes on these models.
> 
> Let me know what you think and how we should proceed.

If we convert to regfields, the entire driver will need to be converted
(all switch families). I'd say make a best effort full conversion, and
if something breaks on the families which you could not test, surely
someone will jump to correct it. Since your KSZ8873 also has wacky registers
(btw, feel free to rename the concept to something more serious), I think
that not a lot can go wrong with a blind conversion as long as it's tested
on other hardware.

BTW, revisiting, I already found a bug in the conversion (patch 2/4):

+	} else if (mii_sel == bitval[P_RMII_SEL]) {
 		interface = PHY_INTERFACE_MODE_RGMII;
 	} else {
+		ret = ksz_regfields_read(dev, port, RF_RGMII_ID_IG_ENABLE, &ig);
+		if (WARN_ON(ret))
+			return PHY_INTERFACE_MODE_NA;
+
+		ret = ksz_regfields_read(dev, port, RF_RGMII_ID_IG_ENABLE, &eg);
						    ~~~~~~~~~~~~~~~~~~~~~
						    should have been RF_RGMII_ID_EG_ENABLE
+		if (WARN_ON(ret))
+			return PHY_INTERFACE_MODE_NA;
+
 		interface = PHY_INTERFACE_MODE_RGMII;
-		if (data8 & P_RGMII_ID_EG_ENABLE)
+		if (eg)
 			interface = PHY_INTERFACE_MODE_RGMII_TXID;
-		if (data8 & P_RGMII_ID_IG_ENABLE) {
+		if (ig) {
 			interface = PHY_INTERFACE_MODE_RGMII_RXID;
-			if (data8 & P_RGMII_ID_EG_ENABLE)
+			if (eg)
 				interface = PHY_INTERFACE_MODE_RGMII_ID;
 		}
 	}

