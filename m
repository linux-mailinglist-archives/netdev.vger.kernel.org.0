Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3651629F2C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiKOQif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiKOQic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:38:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4D01A068;
        Tue, 15 Nov 2022 08:38:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB506618EA;
        Tue, 15 Nov 2022 16:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA828C433C1;
        Tue, 15 Nov 2022 16:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668530310;
        bh=PsKz0EwnOL+DBT0MFmKu4L0TmsnsvB7Jr/ekWkAjNxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ks2Z9l6QYQt199L9alM5h8Hau57hpmt8G7ISHXSVqrQWTkX3n6CzUdrn+sXFcYNeX
         Znzr6o6ukDOZV2/V9ei2TaixFDYzpPAuLUP2OTIvARKV4K4nQAo1968PrhKBgg0Pnw
         ub8M+4fir6nL+LlSdqFnI8eBDB4eaTvCyTQsJwgTiF86NvMXgd1OeUFc8hKhIZrq5I
         hWCaIYe2s0G1rfCRqrjHCDbZCYYWSRu5x6MALALo994Khgo23X43nKygs3smJHi/74
         m4a/1m5+GeuECE8YYO3nLXVT2fXCf/WJAGo24dp3xR/PXxMPmBsThB4zUS/EZ+tekW
         /Ajv+NChXuz2A==
Date:   Tue, 15 Nov 2022 08:38:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: use more appropriate NET_NAME_* constants
 for user ports
Message-ID: <20221115083828.06cebab1@kernel.org>
In-Reply-To: <20221115074356.998747-1-linux@rasmusvillemoes.dk>
References: <20221111161729.915233-1-linux@rasmusvillemoes.dk>
        <20221115074356.998747-1-linux@rasmusvillemoes.dk>
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

On Tue, 15 Nov 2022 08:43:55 +0100 Rasmus Villemoes wrote:
> +	if (port->name) {
> +		name = port->name;
> +		assign_type = NET_NAME_PREDICTABLE;
> +	} else {
> +		name = "eth%d";
> +		assign_type = NET_NAME_ENUM;

Per Andrew's comment lets make the change in two steps.
Which one should come first is a judgment call :)
