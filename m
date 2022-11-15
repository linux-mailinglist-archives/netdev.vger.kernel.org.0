Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7F562916F
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 06:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiKOFSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 00:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiKOFSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 00:18:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46AC1DF19
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 21:18:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E405B811FF
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A841CC433D6;
        Tue, 15 Nov 2022 05:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668489486;
        bh=arqRUFX1wYG6wG0Ya1t0rErRKFJyaXMpJvVM297Vks8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AjJ8ilFNoCsL0CoNn3865mZy4igj7AR5FfKCnlFCuPpZEKVA8iORUJgF4JUC8mDf2
         xMH1Lz5g97SGjvG+HQgEyP7VQAnZZ26Ye+bZ8qZjb+rTtr02PfJSO/S1qTLWssGBIY
         S1gxQwcqbJzucZoyPGowlAXBmxXMOyrngxOi1LpaejT/vNOdJwQ9+AXpKXeMDxeSay
         QgGn1vIc8LeO8osCpnMGSfH7WoHdvxsiRXduSCA4nlByHlHWxaLDD0Scwi6VKlwD9G
         LdsOSz9gVHfvUk/XCMxv6tyRaTfXibfpbGcL3HSIj5d1vM4W2BpDWr5zCKp9T4kQod
         2XDXVUFENvXPg==
Date:   Mon, 14 Nov 2022 21:18:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     "Hans J. Schultz" <netdev@kapio-technology.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <20221114211804.478206da@kernel.org>
In-Reply-To: <20221114185704.796b5c14@kernel.org>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
        <20221114185704.796b5c14@kernel.org>
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

On Mon, 14 Nov 2022 18:57:04 -0800 Jakub Kicinski wrote:
> On Sat, 12 Nov 2022 21:37:46 +0100 Hans J. Schultz wrote:
> > This patchset adds MAB [1] offload support in mv88e6xxx.
> > 
> > Patch #1: Fix a problem when reading the FID needed to get the VID.
> > 
> > Patch #2: The MAB implementation for mv88e6xxx.
> > 
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=a35ec8e38cdd1766f29924ca391a01de20163931  
> 
> Vladimir, Ido, ack?

Ah, either way a v9 will be needed:

drivers/net/dsa/mv88e6xxx/switchdev.c:33:5: warning: no previous prototype for function 'mv88e6xxx_handle_violation' [-Wmissing-prototypes]
int mv88e6xxx_handle_violation(struct mv88e6xxx_chip *chip, int port,
    ^
drivers/net/dsa/mv88e6xxx/switchdev.c:33:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
int mv88e6xxx_handle_violation(struct mv88e6xxx_chip *chip, int port,
^
