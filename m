Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305C6621334
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbiKHNr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbiKHNr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:47:56 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87795984E
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MLGWxDrN+XKnIjy/oUcLdgf9BFSSw8wy1ruvM9/BBkE=; b=Z8dWvDq1TFYFW1J0MH0sx2P9zm
        JCcZMc4+phIuyD+7xWG2yHQyKaKy3yYY4+nS2UkmiN612ZnHohOMwb0hSeSxq+6YTQWXa/++PuPGm
        4E6ccUjELj/9R71b/rvLJieFFisGyUoLZSoiSHsrqxTJoH3ZJs3P8DjWVtc8YmQBvMXk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osOwu-001p6p-R4; Tue, 08 Nov 2022 14:47:32 +0100
Date:   Tue, 8 Nov 2022 14:47:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 6/9] net: dsa: marvell: Provide per device information
 about max frame size
Message-ID: <Y2pd9CFMzI5UZSiD@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-7-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108082330.2086671-7-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 09:23:27AM +0100, Lukasz Majewski wrote:
> Different Marvell DSA switches support different size of max frame
> bytes to be sent.
> 
> For example mv88e6185 supports max 1632B, which is now in-driver
> standard value. On the other hand - mv88e6071 supports 2048 bytes.
> 
> As this value is internal and may be different for each switch IC
> new entry in struct mv88e6xxx_info has been added to store it.
> 
> When the 'max_frame_size' is not defined (and hence zeroed by
> the kvzalloc()) the default of 1632 bytes is used.

I would prefer every entry states the value. That both simplifies the
code, and probably reduces the likelihood of somebody forgetting to
set it when adding a new chip.

    Andrew
