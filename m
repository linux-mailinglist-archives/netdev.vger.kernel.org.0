Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B681C6B6773
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 16:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjCLPPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 11:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCLPPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 11:15:49 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2888634339;
        Sun, 12 Mar 2023 08:15:45 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id bh21-20020a05600c3d1500b003ed1ff06fb0so920591wmb.3;
        Sun, 12 Mar 2023 08:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678634143;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HKhPGEn48aizwdQtbeZiRqDsuVUTk1YIcEaDe2udzRA=;
        b=gEuJTs8rAj1FCry+rF1CeDbSIJK4LxGMUnOjarG4/VP8KKgqsJUS97hWWDm/LLbiLW
         DNQ0Lgv+r71NlgTtrHCdRkFUVfk67F+DDREcWS4aUT+4VSSOCJmJZsO8W0QkU9rwf7Pt
         Cn53G5xe1ZmguLXX7D5vjKUUiGAvx0jMMHBtIGc0xb6cQC0pyqgYzQq/5exWq7S2NgAw
         puJNDQ7cMwLtW2DmEDwPz2M617RtRbHrqK+okSwZHzrkzpQJMYdHvGJ3PJY/Qo8cR4bp
         uGPv8bwajsDGqCgW0wzlKakgzcPmmU6xg/kmQMWn5STGhVY0qNHM1t9MX50d2RvaCpBy
         MmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678634143;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HKhPGEn48aizwdQtbeZiRqDsuVUTk1YIcEaDe2udzRA=;
        b=d3j/NQgOVFtSKNl9uIpAW3NHgNUa4qxG3bFfqpvOcnKHoQbWzyXFCe7LLdBOm/5W0r
         R6qaCWam3JmtfA6kaAL+In1FyTt6DrLNF1HrfkenW8Mkedu3h6Y+HyoTQmRoOtW54Vm0
         1LP5BQAZtGkTec2h/kAjO7U8r/w3gFD+w+aHizl5cM4jFSVsGYim68BdmSlwkq8usbr/
         bAky7fXt0uF80Ynds0K2q96Zc4+U5JeU1y2/ITV/9sPGvFUe7bkUKQnxiD6B2kyZpt/c
         UEOK7QSklP/W3TPoeS6qPFx3HlegdXffuyEaEEM/iAe3Vht7qpWr7d3rGmGxhiT/GYbF
         QHKg==
X-Gm-Message-State: AO0yUKU4AWnY4MOYz2Mt4NYA9EWu6FkK+y/H0USxsQDx91Xaniqw1+sw
        jEKnC8BmmrG9zbHYljR2cRc=
X-Google-Smtp-Source: AK7set/bjPBg/zjhzM6DAttzOabIYrkqkkyVgJDWMpQSEhOR00TB9rrFvoFv2QmmclSj+Zkfo4wXvg==
X-Received: by 2002:a05:600c:46cc:b0:3ed:1f9c:aeff with SMTP id q12-20020a05600c46cc00b003ed1f9caeffmr2414620wmo.36.1678634143542;
        Sun, 12 Mar 2023 08:15:43 -0700 (PDT)
Received: from ?IPv6:2a02:168:6806:0:1606:cc8d:640:3d4d? ([2a02:168:6806:0:1606:cc8d:640:3d4d])
        by smtp.gmail.com with ESMTPSA id v7-20020a05600c444700b003e204fdb160sm6741547wmn.3.2023.03.12.08.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 08:15:42 -0700 (PDT)
Message-ID: <024b696003d8403d62c45411c813058684e0418c.camel@gmail.com>
Subject: Re: [PATCH net-next v2 4/6] net: mdio: scan bus based on bus
 capabilities for C22 and C45
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-aspeed@lists.ozlabs.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Date:   Sun, 12 Mar 2023 16:15:41 +0100
In-Reply-To: <0a1ec04fe494fcd8c68d03e4f544d7162c0e4f39.camel@gmail.com>
References: <db6b8a09-b680-4baa-8963-d355ad29eb09@lunn.ch>
         <0e10aa8492eadb587949d8744b56fccaabbd183b.camel@gmail.com>
         <72530e86-9ba9-4a01-9cd2-68835ecae7a0@lunn.ch>
         <09d65e1ee0679e1e74b4f3a5a4c55bd48332f043.camel@gmail.com>
         <70f5bca0-322c-4bae-b880-742e56365abe@lunn.ch>
         <10da10caea22a8f5da8f1779df3e13b948e8a363.camel@gmail.com>
         <4abd56aa-5b9f-4e16-b0ca-11989bb8c764@lunn.ch>
         <bff0e542b8c04980e9e3af1d3e6bf739c87eb514.camel@gmail.com>
         <a57a216d-ff5a-46e6-9780-e53772dcefc8@lunn.ch>
         <2f64385a350359c5755eb4d2479e2efef7a96216.camel@gmail.com>
         <29ee3cc4-a1d6-4a07-8d90-4b2f26059e7d@lunn.ch>
         <0a1ec04fe494fcd8c68d03e4f544d7162c0e4f39.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-03-12 at 10:04 +0100, Klaus Kudielka wrote:
> On Sun, 2023-03-12 at 03:53 +0100, Andrew Lunn wrote:
> >=20
> > Correct. But their also should not of been any noticeable slow down,
> > because there should not be any additional scanning when everything is
> > described in DT. And the move of the MDIO bus registration from probe
> > to setup should actually make it faster than before.
> >=20
>=20
> But then, why *do* I see such a big difference on the Omnia?
>=20
> mdiobus_scan_bus_c45() takes:
> ~2.7 seconds without phy_mask patch
> ~0.2 seconds with phy_mask patch

Following up myself, the answer is in the call path
mv88e6xxx_mdios_register()
	 -> mv88e6xxx_mdio_register()
		-> of_mdiobus_register()

A child node "mdio" would be needed for the scan to be limited by
the device tree. And this one is *not* in armada-385-turris-omnia.dts.

My (incorrect) understanding was, the child node "ports" would trigger
that behaviour.

Best regards, Klaus

