Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15BF6A9C08
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 17:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjCCQq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 11:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjCCQq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 11:46:28 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8E75CC32;
        Fri,  3 Mar 2023 08:45:55 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A01BDFF809;
        Fri,  3 Mar 2023 16:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677861908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fk/rzQMf5+dVvCZ+KR9/MtNF55SHNmrM2/qr5Tb85/c=;
        b=UJtDyjQZ9XqjZV7+8twZoQcleitOjjIB1CENZAh+q8QUu1nL/kJIXtE5DFJ3M7UuWKIwU7
        ev3QMUS7SAAQ9tWtiPctj5d0wd2wni2Pf0uBxQLQfEPgFpP3J5G4VUj6/LKEQ3NXPZ4sG+
        pMJAKZoe883nQfxCkgeFmSDBl8wDToTxl71Uj0NDjGXmAfBdRRUSvfZsrlyzHtR3zFfTXX
        ichaS252M4Cp5qy5wzpUthhqZ6YkDcrFyHOK9TILazcof41Bn0Bq6BBrqvFMKt5nIgjtFx
        kumoR6O1nNQUmNGNxPdXhJ+grKM9w9EI/sxmn/6QNBypGt6xlkC4t9R9xOUAnQ==
Date:   Fri, 3 Mar 2023 17:45:02 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>, thomas.petazzoni@bootlin.com,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sven Eckelmann <sven@narfation.org>,
        Wang Yufen <wangyufen@huawei.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: Re: [PATCH v2 0/4] Up until now, there was no way to let the user
 select the layer at which time stamping occurs.  The stack assumed that PHY
 time stamping is always preferred, but some MAC/PHY combinations were
 buggy.
Message-ID: <20230303174502.1317e444@kmaincent-XPS-13-7390>
In-Reply-To: <20230303164248.499286-1-kory.maincent@bootlin.com>
References: <20230303164248.499286-1-kory.maincent@bootlin.com>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Mar 2023 17:42:37 +0100
K=C3=B6ry Maincent <kory.maincent@bootlin.com> wrote:

Oops, sorry some bug in my cover letter subject.


Regards,
K=C3=B6ry
