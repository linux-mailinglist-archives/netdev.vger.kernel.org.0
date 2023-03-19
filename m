Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4EC6C0286
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 16:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjCSPAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 11:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCSPAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 11:00:15 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EED14EA2;
        Sun, 19 Mar 2023 08:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1679237954; i=frank-w@public-files.de;
        bh=FaY0Xl4jfnqhSvRMHOlCX3MBxMkltd1/bLTF73k4weg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=DKFNt2WZoREtt+jN1ck1xolqt6Qiz6THIkpIfPuXTRq/Uc2Abd6AVHAGEKUFA9/89
         mDb2dUp8omXPHSnEqsDO4Jg4+9/KA/w8LGg/x7jyHmLWKbd0MT9t6HHS6N4o+fbAIo
         6ToGjm0KteUH2KrWCh6YAzXSwt0wgQuR1Q0KxiE9qC2oR1J6Fhz7v9C0AM7pTc8wT8
         fdY8DslxjZSMD9zrQXZURZDOotWTQz87LR2VyIfy1ZbYU3ZydesjbWMNNQ/JFLARkE
         Zd4Tw3q0DnX5kTQGDYh9WtCtu48YS0Zfe0oeIaIWSoLF9wiJTh0G5V42Fved085/gg
         f28dTjnZCv1lA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.158.68] ([217.61.158.68]) by web-mail.gmx.net
 (3c-app-gmx-bs27.server.lan [172.19.170.79]) (via HTTP); Sun, 19 Mar 2023
 15:59:14 +0100
MIME-Version: 1.0
Message-ID: <trinity-a9f91337-a6df-4c4d-86ba-f5ff5118c3cd-1679237954332@3c-app-gmx-bs27>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Aw: [PATCH net-next v14 7/9] net: pcs: add driver for MediaTek
 SGMII PCS
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 19 Mar 2023 15:59:14 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <cf8a52216cfe4651695669936bd4bb1b9500c57b.1679230025.git.daniel@makrotopia.org>
References: <cover.1679230025.git.daniel@makrotopia.org>
 <cf8a52216cfe4651695669936bd4bb1b9500c57b.1679230025.git.daniel@makrotopia.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:QlaKsSUYzhoHNVHDU4Rq0bkFMZFnwpaPu5MLgsBtp8NUsWc9o5S8LdeCQ2xzWzeAFwRt4
 Mxc17gdJOEOGXzEsWcJo6EZGPoMqwW0V1U3GeuO4/Z3SJzOql+e3/TBcCdOl7ocqDQckGIofFMMg
 3NFdoHc56LvqaiWj9Fh3f0NxCmZzPeIKfy5rbdVf/OC1ZYe/xa4tHtlGCYGHeD0NIj9VAJXJCXGV
 10Q2a3270UkO09xLwG9GMB1QW5JC+XRdTnC4+GAAjp53h3eL4e+Z9Qn/Ex1nrdoRI3WEn+uj18cS
 6s=
UI-OutboundReport: notjunk:1;M01:P0:eznMuFIIR60=;TcBxrqYLL8IXUHWdmSvm7sSx/yF
 klFeVRm/A0/rGq75P4jMohykpfRmQu+2ALaAOa3bZwmBn2mmTg7EbnW31GiYPZKTTK/OXwmte
 i6jI3k856t7uBjZ2/Ow0CWz8kctXTcAP5pvb7nlSLpRI8gEwu7q7OLweDs6JCNdVCutHR2cK6
 BvRCjnj4nHV+8tUDVxN/9jma+ruVIfhAfq6s47UjEmF0q8txpN3kl6c7uRGuCS25GT94PoGsJ
 YJikkrCtnxWJhKbfmODBjtpb5NxPDttiCmspJOVzqEMfYHZDpBQHtoDmMMbVgLfJP8HtdnSuX
 j1MBV3b1qujWoxgn6bYcWNgggB3BQhkoNhn4JTaFGJqogbcb/UgxGuPdr3jK1bfcv7clyIsIB
 og00aDaCWKv6QPj3rYgPZFGE/rEkunnVxTmCYK1GXZiFruHEOGfZ0iKXw3tYKEK8mZ7XtDsD8
 y0I6y82h4nLMHKpd7PSA6Uxmj2JaMnm9Pbf8eFfGiFmxHirQVUp+NkkGGe5ynTGO2XbLta4YK
 oQswLwvbhxPJ7nMo8urh1zgga8HJr9d/c237oduv+CWbLbjX++y3ugeMr03dH2jtj5gYCLNCu
 nUOeEbao8xek3yAbDGG//Wd0DSJZgCAcIlRWekai9264JvYYZqnQcKc2VeD+hOHc/vqBZ+CxW
 0vjxH/RoASEFfmiF/RgJExNW2f8TuQljfXEZFHj0seGiKiUblwKBgrUwb4nEUKinDOb3/0YDF
 i58Clg6jjcTcj/4H0oiT8GF1DWIr5nSPOzR8kV8Owol1ZEd+sWEuUAICL7DJLgk2YTqorPoNB
 qxzuVLOiT1e2eGOsRbC7JoOQ==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

as Patches are the same as v13

Tested-By: Frank Wunderlich <frank-w@public-files.de>

regards Frank
