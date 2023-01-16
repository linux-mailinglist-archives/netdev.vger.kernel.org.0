Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A7E66B872
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 08:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbjAPHwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 02:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbjAPHwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 02:52:20 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FB210AA1;
        Sun, 15 Jan 2023 23:51:58 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 13D06B8B;
        Mon, 16 Jan 2023 08:51:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673855516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wex/E6ADFcsrQWYTNlA0xrKfTIWSKEBPY4LIi/xz/m4=;
        b=gvFMHaDms+nw59CSILYnAkCxJenNCQWr8lE3DeHdKlcmYNCeRTEiSZg8NL/YT27hks8eVM
        3M90hSRPSzkdi4xbr2cE/muF4A1OLTrsC3p9OyihQEspNjRTBuKeJui2F2W1Usz155OazF
        d4QTJ6fYpzWMIDU735/fsaVnkmUPGTK017U8u+WKMuUxzCBUvFZ2qA9DLBlyrl3HMsORW5
        xbW7BsYEVfujReNcbKKw3NFU3VsvSYT1zngjoNPuhAzUtV/TcmjAN/Ka/wsGIQWYAz7P0e
        /uI69FttYFKwZ+CXZi8PnHLaEH4dGoxKW5gLOpRdlHF4/JnJQfAzHOhTOFoUZw==
MIME-Version: 1.0
Date:   Mon, 16 Jan 2023 08:51:55 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
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
        linux-mediatek@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: Re: [PATCH RFC net-next v2 11/12] net: dsa: Separate C22 and C45 MDIO
 bus transaction methods
In-Reply-To: <20230103155633.tfdxncl75s4tb2ln@skbuf>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-11-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-11-ddb37710e5a7@walle.cc>
 <20230103153134.utalc6kw3l34dp4s@skbuf> <Y7ROa8ql9R5SHPsK@lunn.ch>
 <20230103155633.tfdxncl75s4tb2ln@skbuf>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <6208c429b0b5541a4f6d2a8556ae1fcb@walle.cc>
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

Hi,

Am 2023-01-03 16:56, schrieb Vladimir Oltean:
>> So Luiz patches may allow a C45 bus, but are there any drivers today
>> actually using it?
> 
> I sent a private email to Luiz a few minutes ago asking him to confirm.

Any news here? Do we need the c45 methods?

-michael
