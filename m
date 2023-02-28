Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B2F6A606E
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 21:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjB1UdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 15:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjB1UdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 15:33:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48136211F6
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 12:33:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF75F611BF
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 20:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA096C433EF;
        Tue, 28 Feb 2023 20:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677616396;
        bh=AtnFPYJLTvZEq/j/I4ecMSJJLZx4NuQYJK35f03fuvk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GNrhOyqt8xaeA5vNc/Ks32h91ykuRZ1HC+KtGoc51CI5sXG81yCSMjRhv+MDPTT4I
         jzC5BgHMo8z1lNqLXMi80uUjAiwrsXeQDfuZa/Ma5wgPGAhpN3De+mFqrOLZNp7u4V
         7vDrbU6phFtVKaii9ap7Wg76Qryne43QnO+vOcoIe8ByNMnnZmqPt7+9jtB6X1qRQA
         fespjCC8IRLlaxVjCoajAHv7AtTxmr0sp2Yrg3ijYNwkFoPD4FwUQO/5HczwcKnm5T
         LetTGyHs/W/2k8Dfo0UyehrgO1eRdVk+3nPVoHZzSE9zKqFxPLxDU12SaPfZeIkLVA
         U2IPyoM5B78mg==
Date:   Tue, 28 Feb 2023 12:33:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     nick black <dankamongmen@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeffrey Ji <jeffreyji@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH] [net] add rx_otherhost_dropped sysfs entry
Message-ID: <20230228123314.315ef444@kernel.org>
In-Reply-To: <Y/386wA5az1Yixyp@schwarzgerat.orthanc>
References: <Y/p5sDErhHtzW03E@schwarzgerat.orthanc>
        <20230227102339.08ddf3fb@kernel.org>
        <Y/z2olg1C4jKD5m9@schwarzgerat.orthanc>
        <20230227104054.4a571060@kernel.org>
        <Y/386wA5az1Yixyp@schwarzgerat.orthanc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Feb 2023 08:08:59 -0500 nick black wrote:
> --- net/core/net-sysfs.c
> +++ net/core/net-sysfs.c
> @@ -714,6 +714,10 @@ NETSTAT_ENTRY(rx_compressed);
>  NETSTAT_ENTRY(tx_compressed);
>  NETSTAT_ENTRY(rx_nohandler);
>  

I'd skip the empty line here to make it clear that the comment pertains
to what's above it, otherwise people may miss it.

When reposting pls make a new thread (patchwork won't pick up patches
sent with Re: at all:
https://patchwork.kernel.org/project/netdevbpf/patch/Y/386wA5az1Yixyp@schwarzgerat.orthanc/

> +/* end of old stats -- new stats via rtnetlink only. we do not want
> + * more sysfs entries.
> + */
