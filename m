Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA9B6214A4
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbiKHODj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbiKHODh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:03:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE067664
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=t5xhlebnR9LBNcAaa8tDHu1DPQcNgfH1fddZ3T6DTJU=; b=Vv+8vbVmQ0hxA8kL0jzW/pAMrj
        KE/hh5UdJjLvzkk318G/J22mwSC8IE/tknfACd+w+pXk4LeiZJmoODH3HhDF27T9PxuQ7maH6cQjG
        xmhO24lb8Ckvo9166YccLdUFXc9R2hJG34WIcI/YAQPU1mAgL+Jg3ZuHH5YmDhVYiwvA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osPC6-001pE8-5I; Tue, 08 Nov 2022 15:03:14 +0100
Date:   Tue, 8 Nov 2022 15:03:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] net: dsa: mv88e6071: Set .set_max_frame_size callback
Message-ID: <Y2phohBqYR5juqBn@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-10-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108082330.2086671-10-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 09:23:30AM +0100, Lukasz Majewski wrote:
> The .set_max_frame_size is now set to the
> mv88e6185_g1_set_max_frame_size() function.
> 
> The global switch control register (0x4 offset) used
> as well as the bit (10) are the same.
> 
> The only difference is the misleading suffix (1632)
> as the mv88e6071/mv88e6020 supports 2048 bytes
> as a maximal size of the frame.

Are you really sure that different members of the 6250 family have
different maximum frame sizes?

Marvells GPL DSDT SDK has:

#define G1_DEV_88ESPANNAK_FAMILY  (DEV_88E3020 | DEV_88E6020 | DEV_88E6070 | DEV_88E6071 | DEV_88E6220  | DEV_88E6250 )

The differences within a family tend to be the number of ports, if PTP
is provided, if AVB is provided etc.

   Andrew
