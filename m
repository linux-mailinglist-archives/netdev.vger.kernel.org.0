Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B09357A2EB
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbiGSP0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238776AbiGSP0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:26:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC6F3C147;
        Tue, 19 Jul 2022 08:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xd6JOh2ogmzno7JiKf5wuULMA33C+xbv3lIK5al2QXc=; b=i32h8wZiik/h9yAFCrH1ENYGdB
        lV/LOT/exzjtFFUWAb6GZFxIBJw7nfYYGwt6NocMjKxF01DnePD3jB5o8mcMot5KEbnmw5dmEWb9f
        pnSz7KtKPSG7cJeSTWLY4lSNT5FEMCH722uygPQTVbw+9h2buPL+VlaFREMDyRSjFUWg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oDp6j-00Apuf-9j; Tue, 19 Jul 2022 17:25:57 +0200
Date:   Tue, 19 Jul 2022 17:25:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antonio Quartulli <antonio@openvpn.net>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Message-ID: <YtbNBUZ0Kz7pgmWK@lunn.ch>
References: <20220719014704.21346-1-antonio@openvpn.net>
 <20220719014704.21346-2-antonio@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719014704.21346-2-antonio@openvpn.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void ovpn_get_drvinfo(struct net_device *dev,
> +			     struct ethtool_drvinfo *info)
> +{
> +	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
> +	strscpy(info->version, DRV_VERSION, sizeof(info->version));
> +	strscpy(info->bus_info, "ovpn", sizeof(info->bus_info));

version is generally considered useless information if it comes from
the driver. You have no idea if this is version 42 in net-next, or
some backported version in an enterprise kernel with lots of out of
tree patches. The driver is not standalone, it runs inside the
kernel. So in order to understand a bug report, you need to know what
kernel it is. If you don't fill in version, the core will with the
kernel version, which is much more useful.

       Andrew
