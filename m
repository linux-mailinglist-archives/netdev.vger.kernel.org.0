Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B71D6E7229
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 06:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjDSERu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 00:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjDSERu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 00:17:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101D81705
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 21:17:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A14B63AE2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 04:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44788C433EF;
        Wed, 19 Apr 2023 04:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681877867;
        bh=WCZizawbn2noxLM8rlOnIZ5BegISwBuau8GtopjJNSE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TRfrj6/6OzlHEXbR+F8nFzg8ANx1T6Ris+tDJLn0v6arH5aTkRf2FhT8oLWSoD7SX
         gi2fcOMDTsxtwl/WnE16eT7NnK490JKedexXr3KhAV/SHD1VucvOcJ5ezBqtXDDEl6
         Ml9AbooWT+Hvvnm8yWFT5ibz9ehADuEP96140F5dkT6kunLqWh14JrRR4CLAZJtqmO
         wMN6j7z1Tseczwa2cX2whD98wRtTGlkgHCL1aRIhZHelqHzKfEjW5UcszdOsd0hhXU
         GInwQHha7aUVCm9DHVVrvXdvKki1h3GnSwjulGHnaMI2aSSXL5iI1H99uriJetAknq
         3MKOYClaq8keA==
Date:   Tue, 18 Apr 2023 21:17:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv5 net-next] bonding: add software tx timestamping
 support
Message-ID: <20230418211746.2aa60760@kernel.org>
In-Reply-To: <ZD9pbffw3s1HVwvE@Laptop-X1>
References: <20230418034841.2566262-1-liuhangbin@gmail.com>
        <20230418205023.414275ab@kernel.org>
        <ZD9pbffw3s1HVwvE@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Apr 2023 12:09:17 +0800 Hangbin Liu wrote:
> > I'll apply Jay's ack from v4 since these are not substantial changes.
> > Thanks!  
> 
> Sorry, not sure if I missed something. bond_ethtool_get_ts_info() could be
> called without RTNL. And we have ASSERT_RTNL() in v4.

Are there any documented best practices on when to keep an ack?
I'm not aware of such a doc, it's a bit of a gray zone.
IMHO the changes here weren't big enough to drop Jay's tag.
