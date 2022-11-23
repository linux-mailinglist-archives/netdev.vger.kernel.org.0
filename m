Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1585B634F29
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbiKWEpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiKWEpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:45:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0ADCC16E;
        Tue, 22 Nov 2022 20:45:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B535FB81E5F;
        Wed, 23 Nov 2022 04:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE638C433C1;
        Wed, 23 Nov 2022 04:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669178747;
        bh=Lt0VpRPIdgR0tpk4SuGH/LkrbNuZe5tFow9WfSwLb0w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DAiQkYzZIvJRYAfqgb+GC6C/E+VO34lSUQ6UxaweX2ualiHKNFjuvtwQXSYU90DXF
         NLgLwCTse64JXSoXE0MfG7MwF5MzwyLR0tZe4zdn4sfPRuaS+18FRKjdQxst5sVj+0
         Lr1DSTjtjPujjBzMp34uhEnRBW0abZZDLO7n2Q+hpyOyyB6E34udkyQyBtULE034g9
         iN9LekEKbdBRsIA8LodOaX9pOZMqyx7jNDxnEJ8KlvtJz9mDgqhdI+E6fVghqX0geO
         aoi/+z7ylgIvUh0qVuEi/cVvxwOvKFP1pytSEWwP4L6qajnwPBHuI+8Dg+OC+5TtmU
         7SD9vreLriBrw==
Date:   Tue, 22 Nov 2022 20:45:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next 1/4] net: microchip: sparx5: Support for
 copying and modifying rules in the API
Message-ID: <20221122204545.40597627@kernel.org>
In-Reply-To: <20221122145938.1775954-2-steen.hegelund@microchip.com>
References: <20221122145938.1775954-1-steen.hegelund@microchip.com>
        <20221122145938.1775954-2-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Nov 2022 15:59:35 +0100 Steen Hegelund wrote:
> This adds support for making a copy of a rule and modify keys and actions
> to differentiate the copy.

gcc says:

drivers/net/ethernet/microchip/vcap/vcap_api.c:1479:16: warning: Using plain integer as NULL pointer
