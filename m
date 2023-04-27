Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D243B6F05B0
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 14:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243936AbjD0MZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 08:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243155AbjD0MZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 08:25:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A39D30E8;
        Thu, 27 Apr 2023 05:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=m4dujXhDiI928l3aXo4S8q8B9XNo05BTOL1sZVi2mk8=; b=beBdi3RogRxbSXGsZLYiqcgSIJ
        L8qjkhDFZlMp/N5opjGQ6Nf6JPKkruZRXBGBQw+uyIdaOQkrUwXt73PSJdxpED/tOqPXZkmR5AUjd
        99A3fOqMBdFYgv7ViwBogz6c04RSYTsFTlY4l/3bAcz/SEq1Vo7rMdCVIc1Toq7WqhIE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ps0gJ-00BLoK-Iy; Thu, 27 Apr 2023 14:25:03 +0200
Date:   Thu, 27 Apr 2023 14:25:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net v2 2/3] r8152: fix the poor throughput for 2.5G
 devices
Message-ID: <622f88b1-9607-48d6-b44d-8aeec8acfd34@lunn.ch>
References: <20230426122805.23301-400-nic_swsd@realtek.com>
 <20230427121057.29155-405-nic_swsd@realtek.com>
 <20230427121057.29155-407-nic_swsd@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427121057.29155-407-nic_swsd@realtek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -7554,6 +7558,11 @@ static void r8156_hw_phy_cfg(struct r8152 *tp)
>  				      ((swap_a & 0x1f) << 8) |
>  				      ((swap_a >> 8) & 0x1f));
>  		}
> +
> +		/*  set intr_en[3] */
> +		data = ocp_reg_read(tp, OCP_INTR_EN);
> +		data |= INTR_SPEED_FORCE;

Which is more meaningful, set intr_en[3], or data |= INTR_SPEED_FORCE
I would say the second. The code is now pretty readable, it says
what it is doing. So if you want to add a comment, you really should
be commenting on why, not what.

   Andrew
