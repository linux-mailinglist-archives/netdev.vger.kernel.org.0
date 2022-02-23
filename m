Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EF34C05C3
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiBWAHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiBWAHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:07:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A01BC68
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 16:06:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23F97B81CBC
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 00:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2AAC340E8;
        Wed, 23 Feb 2022 00:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645574806;
        bh=wUjxgH5lunUTQR8Gh1Q+N0bazUGjtBbX0JhIEwO0IyQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NMv50HStcwi5k276UT2QgmYCaP5rRPxJIIjlAoK3b17T+xi4F94MKL15fti9juzaY
         MBUHqEQl98kNhDv4NVLpfQGhg4WcvGe6jIy8yhZ3vxku1M519XVZI1MKbXRdAQtUOq
         fgUsCx0ExI9HZwNLLQEX7L1LUzPgzBOOcu9r9KMioYGI0odNephBPxx0RgW0na2q+G
         DuqXCANCa7uXmtsWdelZ3fP2Z4p7aPlvTNtbtnMMZjzeBAFotjETg4qwvmzf1XKVSU
         lKjbuvPRfInCQAwCEadYfBC94zH4CG5kWvfcm3z/AQ4jHScWNaMIZQ4yX0EYbGPEuz
         kAP4jJAYZwPMg==
Date:   Tue, 22 Feb 2022 16:06:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: sparx5: Support offloading of bridge
 port flooding flags
Message-ID: <20220222160645.6cf87b45@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222143525.ubtovkknjxfiflij@wse-c0155>
References: <20220222143525.ubtovkknjxfiflij@wse-c0155>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Feb 2022 15:35:25 +0100 Casper Andersson wrote:
>  static void sparx5_attr_stp_state_set(struct sparx5_port *port,
> @@ -72,6 +88,9 @@ static int sparx5_port_attr_set(struct net_device *dev, const void *ctx,
>  	struct sparx5_port *port = netdev_priv(dev);
>  
>  	switch (attr->id) {
> +	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
> +		return sparx5_port_attr_pre_bridge_flags(port, 

nit: trailing white space here, please keep Horatiu's review tag when
reposting

> +							 attr->u.brport_flags);
