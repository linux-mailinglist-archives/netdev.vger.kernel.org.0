Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2D960E156
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbiJZM7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbiJZM7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:59:05 -0400
X-Greylist: delayed 2319 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Oct 2022 05:59:04 PDT
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720FFF708D;
        Wed, 26 Oct 2022 05:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VmW7slGrlHih0la8kVFS+GRtfhTJQ7NbG+NrGY/e2fI=; b=2V8CaKkStK9p7hGGf/GDc7y4hD
        ptn2HtcVKpuLimf6QGkrJrJ1m9WwfA/TFwMhWSilB7Fnopl8flAFLH0Td/sWY9QaoxpUPxYx4GXTs
        gvWwYF8K687CLK2NouX0GJlEkMoWWsRPQA45Q9gjhuyqTh4eML/DupyiHUVLDbLKicM4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1onfyr-000clS-1Y; Wed, 26 Oct 2022 14:58:01 +0200
Date:   Wed, 26 Oct 2022 14:58:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        saeedm@nvidia.com, corbet@lwn.net, michael.chan@broadcom.com,
        huangguangbin2@huawei.com, chenhao288@hisilicon.com,
        moshet@nvidia.com, linux@rempel-privat.de,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: linkstate: add a statistic for PHY
 down events
Message-ID: <Y1ku2QvMmQdWTa57@lunn.ch>
References: <20221026020948.1913777-1-kuba@kernel.org>
 <20221026074032.GF8675@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026074032.GF8675@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What is the best way to implement it on devices without dedicated HW
> counter? I assume in most cases only PHY driver would not real state of
> link.

I would hook into the PHY state machine. PHY_RUNNING means the link is
up. If it transitions to PHY_NOLINK the link has been lost.

    Andrew
