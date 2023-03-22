Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468576C4FB5
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjCVPvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCVPvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:51:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D8323C56
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:51:09 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1pf0jv-0007NF-6k; Wed, 22 Mar 2023 16:51:03 +0100
Message-ID: <e47793af-b409-5e88-c74c-73e76f5e11d1@pengutronix.de>
Date:   Wed, 22 Mar 2023 16:51:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net 1/2] net: dsa: realtek: fix out-of-bounds access
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
 <20230316210736.1910b195@kernel.org>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20230316210736.1910b195@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.03.23 05:07, Jakub Kicinski wrote:
> On Wed, 15 Mar 2023 14:09:15 +0100 Ahmad Fatoum wrote:
>> -	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
>> +	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv) + var->chip_data_sz, GFP_KERNEL);
> 
> size_add() ?
> Otherwise some static checker is going to soon send us a patch saying
> this can overflow. Let's save ourselves the hassle.

The exact same line is already in realtek-smi. Would you prefer I send
a follow-up patch for net-next which switches over both files to size_add
or should I send a v2?

Cheers,
Ahmad



> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

