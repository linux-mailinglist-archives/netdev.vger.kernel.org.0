Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771D754722A
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 07:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiFKFRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 01:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiFKFRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 01:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E704FD
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 22:16:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B084760BDC
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 05:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5A6C34116;
        Sat, 11 Jun 2022 05:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654924618;
        bh=cnCcU7kEkd/YpUBh0g4Tg0wcApGar3d/Q7Gwh6O0I+g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O7e+7CWWkJRZu+cv5CGfAIbdjK90vkqrlhQpDDCCyb/OF1jIMYEPKkWHT5mWKpBu1
         coTklTNE8rCpvP6G/Hdpw0HXvI4vhRDI2bRQqk9A8aF01+q29FcHg/PESTGQx3vRmP
         6AMnO2xKPTqPgqIvTGwCETeYFxQqRlBhme+JBb9UrvhAoy1TvBZjGbAzGg0/q9JDhF
         B28tbvEFFECjKsFLKc4Aun39MS+VVAwK88I23NjCXCS43CHa7WApkhGbKrJiyLlZCw
         nv+XvT/338arFkWYHYcxAtBFvi6LciunmVjbOWs0ciXYC78mIqKOnZQykB704lBfV5
         XbgZZ0XAQ2y6A==
Date:   Fri, 10 Jun 2022 22:16:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: error on unsupported IP setsockopts in IPv6
Message-ID: <20220610221656.2f08c7a8@kernel.org>
In-Reply-To: <20220609152525.GA6504@debian>
References: <20220609152525.GA6504@debian>
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

On Thu, 9 Jun 2022 17:26:10 +0200 Richard Gobert wrote:
> The IP_TTL and IP_TOS sockopts are unsupported for IPv6 sockets,
> this bug was reported previously to the kernel bugzilla [1].
> Make the IP_TTL and IP_TOS sockopts return an error for AF_INET6 sockets.
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=212585

This is a little risky because applications may set both v4 and v6
options and expect the correct one to "stick". Obviously it's not 
the way we would have written this code today, but is there any harm?
Also why just those two options?
