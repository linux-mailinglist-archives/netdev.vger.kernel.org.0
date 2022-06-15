Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE91454BF6D
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 03:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345178AbiFOBwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 21:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiFOBwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 21:52:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF6ACD2;
        Tue, 14 Jun 2022 18:52:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9A2C619B0;
        Wed, 15 Jun 2022 01:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF64FC3411F;
        Wed, 15 Jun 2022 01:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655257943;
        bh=9zr1Qys8+OeE2eqRt/+VCrHA+Ge7aWOMj0KzcfgZX4A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rXagdTT5+47yI7dGWUQYXuoJM+LDL7f3J4/UtFO6PYX585JPikq31smDXJ/wL4jrK
         VccYhm47X+w+WwLRzEBw9o1G6RRNYnaRRbtEKy63WZ/XKIXngvjjtV/MQZtj40SfbQ
         YMQfDQlL/WaXFssxFJRnb9nuhQdwDAGotCa33zXslnQfFWyjrIBycCivnUBo8wv6jZ
         afBiSgDK/9Y5FTZMrVv4fwR+ob2YwgPE6oD6KcUUvitVXykwlMe75hdUQQUTA6Mw53
         vA4FGMUMUGHoSXrMRzRu1DhU39HAnCJe9flvy79Ge4GAcEeKh+mxC9InSSI8c1XyWQ
         bM+atrzXYZg3w==
Date:   Tue, 14 Jun 2022 18:52:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: add remote fault support
Message-ID: <20220614185221.79983e9b@kernel.org>
In-Reply-To: <YqdQJepq3Klvr5n5@lunn.ch>
References: <20220608093403.3999446-1-o.rempel@pengutronix.de>
        <YqS+zYHf6eHMWJlD@lunn.ch>
        <20220613125552.GA4536@pengutronix.de>
        <YqdQJepq3Klvr5n5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jun 2022 16:56:37 +0200 Andrew Lunn wrote:
> That would suggest we
> want a ETHTOOL_LINK_MODE_REMOTE_FAULT_BIT, which we can set in
> supported and maybe see in lpa?

Does this dovetail well with ETHTOOL_A_LINKSTATE_EXT_STATE /
ETHTOOL_A_LINKSTATE_EXT_SUBSTATE ?

That's where people who read extended link state out of FW put it
(and therefore it's read only now).

In case I'm just confused and this is different we should prolly
add a paragraph in docs to disambiguate.
