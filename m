Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3DD6BEE5A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCQQc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCQQc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:32:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCC426B3;
        Fri, 17 Mar 2023 09:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=uL4B13zyBU0yjJDVy+7HVAkMTN+tZmR6y/W18ImmG+I=; b=SP
        kxu96clENFbmFYwiQtXr1xU6Q63CIZS2ngq6hIzjuL4/gktuEWo4phTdFYFopg0CHDpY3+4HHVtMD
        LLssbKRfGLNnC7Jk1zZADfsOb/2gwTV2xhIhWqWz4vXaA+sT9RuxiCQi53/aS1YiaKdBaNgL4iMpb
        EMGWnJnxOFH9N/g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pdCzp-007dCU-QT; Fri, 17 Mar 2023 17:32:01 +0100
Date:   Fri, 17 Mar 2023 17:32:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: tag_brcm: legacy: fix daisy-chained switches
Message-ID: <00783066-a99c-4bab-ae60-514f4bce687b@lunn.ch>
References: <20230317120815.321871-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230317120815.321871-1-noltari@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 01:08:15PM +0100, Álvaro Fernández Rojas wrote:
> When BCM63xx internal switches are connected to switches with a 4-byte
> Broadcom tag, it does not identify the packet as VLAN tagged, so it adds one
> based on its PVID (which is likely 0).
> Right now, the packet is received by the BCM63xx internal switch and the 6-byte
> tag is properly processed. The next step would to decode the corresponding
> 4-byte tag. However, the internal switch adds an invalid VLAN tag after the
> 6-byte tag and the 4-byte tag handling fails.
> In order to fix this we need to remove the invalid VLAN tag after the 6-byte
> tag before passing it to the 4-byte tag decoding.

Is there an errata for this invalid VLAN tag? Or is the driver simply
missing some configuration for it to produce a valid VLAN tag?

The description does not convince me you are fixing the correct
problem.

	Andrew
