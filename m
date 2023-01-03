Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F5A65BDEE
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 11:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbjACKWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 05:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237419AbjACKVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 05:21:17 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B90DF28;
        Tue,  3 Jan 2023 02:21:10 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 7021D126D;
        Tue,  3 Jan 2023 11:21:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672741268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0NIrlOvbk7vZkei/UjaLevKnqZdjT8W2kPPgWX5gcEM=;
        b=RIvoOPSAjkHkWRfLX6Q0K/aek6FQU3XreYN5YNfAte2T/48X3VC8QQcEpd8jPJCFiyZzWo
        YiNwIusJEscDbzhm+hLbf6HNICx53SmA+YBP6AkQJq43zwVjNQZv+E9+UWk/k+GVe5vHsB
        PpYh33/dKsFzSAcgjfwdUsLd5q72TbERdzSx/SCAm4zwGljRFXGGLdVqfy4IcIf2W5lAZO
        XjMLUaTiUPYAyq3PtzHwPIZ0R9tR/KsXvd4mja00tvj0OPMSluRJXfI+WgaY/465OcIWYl
        25I7JQyqJw8aSZmYLqPK7a2CXyNMEgcEPOPRNCX0T6YnECO/Wo1QlrI2Qv3cuQ==
MIME-Version: 1.0
Date:   Tue, 03 Jan 2023 11:21:08 +0100
From:   Michael Walle <michael@walle.cc>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
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
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH RFC net-next v2 03/12] net: mdio: mdiobus_register: update
 validation test
In-Reply-To: <Y7P/45Owf2IezIpO@shell.armlinux.org.uk>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-3-ddb37710e5a7@walle.cc>
 <Y7P/45Owf2IezIpO@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <37247c17e5e555dddbc37c3c63a2cadb@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Am 2023-01-03 11:13, schrieb Russell King (Oracle):
> On Wed, Dec 28, 2022 at 12:07:19AM +0100, Michael Walle wrote:
>> +	if (!bus || !bus->name)
>> +		return -EINVAL;
>> +
>> +	/* An access method always needs both read and write operations */
>> +	if ((bus->read && !bus->write) ||
>> +	    (!bus->read && bus->write) ||
>> +	    (bus->read_c45 && !bus->write_c45) ||
>> +	    (!bus->read_c45 && bus->write_c45))
> 
> I wonder whether the following would be even more readable:
> 
> 	if (!bus->read != !bus->write || !bus->read_c45 != !bus->write_c45)

That's what Andrew had originally. But there was a comment from Sergey 
[1]
which I agree with. I had a hard time wrapping my head around that, so I
just listed all the possible bad cases.

I don't have a strong opinion, though.

> which essentially asserts that the boolean of !method for the read and
> write methods must match.

Maybe with that as a comment?

-michael

[1] 
https://lore.kernel.org/netdev/ae79823f-3697-feee-32e6-645c6f4b4e93@omp.ru/
