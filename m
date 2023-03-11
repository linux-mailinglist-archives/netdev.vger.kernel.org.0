Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10836B5EE0
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 18:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjCKRdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 12:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjCKRdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 12:33:11 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11EC768B;
        Sat, 11 Mar 2023 09:32:57 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id q16so7811910wrw.2;
        Sat, 11 Mar 2023 09:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678555976;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BS/U63CP8kyc4s3+ndFwYv3c/IbBKEKDtQ8znLZINo4=;
        b=RX+BkKj+x9TiMv3r/lL//tQpdeczI/eIoOk8GNW2B997wf/HecmbDllwY2uelEG6SW
         NFzKMG9Y8UUTaOLQdyxRPlkDNP1u2gbO2I6JCDlC9f8n0tVMzUtVmkPrYMQ/5gTTvIex
         B7MpIpXwFxRMt4Za9+FOvX04zp7uhkrZF+ENEt6FiCUbmO97P3IiIUFHVUKwj/V2aZEO
         ubZie3KLAa3d3xuXS3uikY5XNveSErnSmyofgMAptn+7YChpYU7HHwVPbpFGXsb5GHU8
         pN427twy0g9FmB350c4j7aDVbOSqRrNc7uvq+AaCQtSGNScLHq5tbsThpFh3D5t1SlDX
         SKgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678555976;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BS/U63CP8kyc4s3+ndFwYv3c/IbBKEKDtQ8znLZINo4=;
        b=k27fKIcNLaJ7DBpSSNN9sUAx5dSKJnwfSON9vafBEa77ouhTtGcNikTNPYthj6XOL/
         EvEyn0JEtCD9QX1gIG7nzma0QaFeKasEKFReEPNMuNk9jTOnwzzBcrSnQohqlCYFaCI/
         D93l4MHQ9zmTxD+K1W810AE3on+l2g5WEx1Zl6gNqDgE5NwqEljSU+ibzjhq5C0ghTM+
         gEQAHMwLX9OvNUbjwGRtqrZKe9r8Oh8vCYABag8Hcx14Re9udnAt9xvIStHUfQK0Ne8S
         6eYlLJ0JgKz8FfrxK685q/jgH3/7hk99un1giy6EelAlSvOkVCXcT5RXDadSS6IWDvej
         vJKQ==
X-Gm-Message-State: AO0yUKWoKoRAEmMz6z7Rus3QZ08INf2v5rvumVA+dbIWrr9L2+P6KsNV
        9TWMAYu4kBZoer9o4crtvlU=
X-Google-Smtp-Source: AK7set9ukWzDo0xy6J7gbHp7jIKCnz8dTe9J/CWuuqUqxE+n+q/r8zAWdbMSQuUV7O2FnpyIFohiiA==
X-Received: by 2002:a5d:5145:0:b0:2c7:a0e:347b with SMTP id u5-20020a5d5145000000b002c70a0e347bmr19984098wrt.8.1678555976064;
        Sat, 11 Mar 2023 09:32:56 -0800 (PST)
Received: from ?IPv6:2a02:168:6806:0:cb1:a328:ee29:2bd6? ([2a02:168:6806:0:cb1:a328:ee29:2bd6])
        by smtp.gmail.com with ESMTPSA id a10-20020adfe5ca000000b002cde25fba30sm3059307wrn.1.2023.03.11.09.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 09:32:55 -0800 (PST)
Message-ID: <49a9154ae4e2b3e6bc85e560368f6474f97cea88.camel@gmail.com>
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
Date:   Sat, 11 Mar 2023 18:32:54 +0100
In-Reply-To: <2f64385a350359c5755eb4d2479e2efef7a96216.camel@gmail.com>
References: <100c439a-2a4d-4cb2-96f2-5bf273e2121a@lunn.ch>
         <712bc92ca6d576f33f63f1e9c2edf0030b10d3ae.camel@gmail.com>
         <db6b8a09-b680-4baa-8963-d355ad29eb09@lunn.ch>
         <0e10aa8492eadb587949d8744b56fccaabbd183b.camel@gmail.com>
         <72530e86-9ba9-4a01-9cd2-68835ecae7a0@lunn.ch>
         <09d65e1ee0679e1e74b4f3a5a4c55bd48332f043.camel@gmail.com>
         <70f5bca0-322c-4bae-b880-742e56365abe@lunn.ch>
         <10da10caea22a8f5da8f1779df3e13b948e8a363.camel@gmail.com>
         <4abd56aa-5b9f-4e16-b0ca-11989bb8c764@lunn.ch>
         <bff0e542b8c04980e9e3af1d3e6bf739c87eb514.camel@gmail.com>
         <a57a216d-ff5a-46e6-9780-e53772dcefc8@lunn.ch>
         <2f64385a350359c5755eb4d2479e2efef7a96216.camel@gmail.com>
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

On Sat, 2023-03-11 at 17:11 +0100, Klaus Kudielka wrote:
> On Sat, 2023-03-11 at 16:39 +0100, Andrew Lunn wrote:
>=20
> > If there is no DT node, by default, all 32 addresses on the bus are
> > scanned. However, DSA makes another assumption. There is a one to one
> > mapping between port number and PHY address on the MDIO bus. Port 0
> > uses MDIO address 0. Port 7 uses MDIO address 7 etc. If you have an 8
> > port switch, there is no point scanning addresses 8 to 31, they will
> > never be used.
> >=20
> > The mdio bus structure has a member phy_mask. This is a bitmap. If bit
> > N is set, address N is not scanned. So i suggest you extend
> > mv88e6xxx_mdio_register() to set phy_mask based on
> > mv88e6xxx_num_ports(chip).
> >=20
>=20
> What you are proposing here would not show any improvement on the
> Omnia, as only the 6 ports would be scanned - right?=20
>=20

Well, maybe I misunderstood the argument with DT completely, so I gave it a=
 try:

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3797,6 +3797,7 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_c=
hip *chip,
        bus->read_c45 =3D mv88e6xxx_mdio_read_c45;
        bus->write_c45 =3D mv88e6xxx_mdio_write_c45;
        bus->parent =3D chip->dev;
+       bus->phy_mask =3D GENMASK(31, mv88e6xxx_num_ports(chip));
=20
        if (!external) {
                err =3D mv88e6xxx_g2_irq_mdio_setup(chip, bus);

>=20

Now THAT one makes a difference! With this on top, I'm back at normal boot =
time!
I hope this is what you had in mind?

Best regards, Klaus

