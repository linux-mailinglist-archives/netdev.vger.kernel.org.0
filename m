Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FA96D7C92
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbjDEM2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238036AbjDEM1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:27:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CAE4ECF;
        Wed,  5 Apr 2023 05:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XMhGMpvRCw9ZdTDV2vCr97P+WoVe706J2XlL4hwYhII=; b=EegSUHRUQBVSxhxSK6puYe5k07
        pC01JJ6PYaTWSo+WfyAzrRtI/fIJEg3TkL3jcTzNlNibC+42oJGjX23WhJJYwjShuKJh17JnhQ1oS
        mL2fOO9oawb7XAJKD60Z0iXLEBm7dy7QpYMKkXkMFjq1uvpH4IEu+xaWxl4OZawZA6Wg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pk2ES-009WEM-Dx; Wed, 05 Apr 2023 14:27:20 +0200
Date:   Wed, 5 Apr 2023 14:27:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 05/12] net: phy: add phy_id_broken support
Message-ID: <6461467c-8f9d-41b6-b060-08190126e81f@lunn.ch>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
 <20230405-net-next-topic-net-phy-reset-v1-5-7e5329f08002@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405-net-next-topic-net-phy-reset-v1-5-7e5329f08002@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 11:26:56AM +0200, Marco Felsch wrote:
> Some phy's don't report the correct phy-id, e.g. the TJA1102 dual-port
> report 0 for the 2nd port. To fix this a driver needs to supply the
> phyid instead and tell the phy framework to not try to readout the
> phyid. The latter case is done via the new 'phy_id_broken' flag which
> tells the phy framework to skip phyid readout for the corresponding phy.

In general, we try to avoid work around for broken hardware in the
core. Please try to solve this within nxp-tja11xx.c.

      Andrew
