Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7386A6231E9
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 18:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiKIRwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 12:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiKIRwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 12:52:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B8BBB3;
        Wed,  9 Nov 2022 09:52:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2292161BFD;
        Wed,  9 Nov 2022 17:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02531C433C1;
        Wed,  9 Nov 2022 17:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668016337;
        bh=Ono1kNVfR6Namsb8ySxxpO8fNUGXE2tq+pYK2FjJB8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m/VflAVs4MSTQcGLOSsqCL33hBaOHQTgATIF8SXG8oZ8KsTmUoSJMsa5HnDXiaBov
         G9lueQZnLwXTLZQWDnWcYmXjrWNO99inXrbiFcAWSzf9MMNaThu9ZWGrZsiZQpEvLl
         0+1Kag9+Ucpcprd4AqPoMWNfcK2a2d3KoMk30bMSnTpFYGkYbihqJK2MneeVRGJtZv
         wVbdqxk/DprHE5r9ZRxJj4HOfE5RuOK6/16gzqXzXVbTMtA8ZB4rZ9D1vwlBLZyXC7
         355/fAjp9GXrq6XRiifQpUjkN266RFe5SON3vMebYS8oZqc3XG0qbARS7OfO0K/SFz
         2NAERFy8Hyxdg==
Date:   Wed, 9 Nov 2022 19:52:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Tom Rix <trix@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marco Bonelli <marco@mebeim.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1] ethtool: ethtool_get_drvinfo: populate
 drvinfo fields even if callback exits
Message-ID: <Y2vozcC2ahbhAvhM@unreal>
References: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 12:57:54PM +0900, Vincent Mailhol wrote:
> If ethtool_ops::get_drvinfo() callback isn't set,
> ethtool_get_drvinfo() will fill the ethtool_drvinfo::name and
> ethtool_drvinfo::bus_info fields.
> 
> However, if the driver provides the callback function, those two
> fields are not touched. This means that the driver has to fill these
> itself.

Can you please point to such drivers? One can argue that they don't need
to touch these fields in a first place and ethtool_drvinfo should always
overwrite them.

Thanks
