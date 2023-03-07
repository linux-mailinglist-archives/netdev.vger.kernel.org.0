Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61CC6AE431
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjCGPNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjCGPMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:12:53 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C83E99253;
        Tue,  7 Mar 2023 07:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aCuAQ+9ZexTOZhRkrKAZ7NnOk4pWsiuK/duImLCmS0k=; b=f4i0DLE5xGih8HU+T9zCUyzciK
        fZ/a8LnfuHbUX3MuoX/dbvG3wwp1wnEuvwv+DhpGYcBbMaM7lWUBDQEbZeDGGSiF5UuN5872nN3Qq
        sagW+IkXxmqF5jK5mXOX9NvqTjXvYmyb2wGlF6cK0zFIGxnO8yMhoytA09EmrzmFXcZA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZYNU-006fbt-1f; Tue, 07 Mar 2023 15:33:20 +0100
Date:   Tue, 7 Mar 2023 15:33:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Michael Walle <michael@walle.cc>, sean.anderson@seco.com,
        davem@davemloft.net, edumazet@google.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com, tobias@waldekranz.com
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Message-ID: <7013dea3-a026-4a0c-81e0-7ebe6f708e39@lunn.ch>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
 <20230307112307.777207-1-michael@walle.cc>
 <684c859a-02e2-4652-9a40-9607410f95e6@lunn.ch>
 <20230307140535.32ldprkyblpmicjg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307140535.32ldprkyblpmicjg@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - Atomic (why only atomic?) (read) access to paged registers

I would say 'atomic' is wrong, you cannot access paged registers at
all.

> are we ok with the implications?

I am. Anybody doing this level of debugging should be able to
recompile the kernel to enable write support. It does limit debugging
in field, where maybe you cannot recompile the kernel, but to me, that
is a reasonable trade off.

   Andrew
