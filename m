Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F424F750E
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 07:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbiDGFJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 01:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiDGFJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 01:09:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25375617C
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 22:07:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8744CB825C7
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 05:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058B1C385A0;
        Thu,  7 Apr 2022 05:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649308067;
        bh=LbEwUjUPE0dOCpIIuqIbkna5vEZhLZsVkSCRyB3qC/w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eWKNsXHGTN3qhfhmOUuBtqb8x4+AVG9NjYqIOes7PvtQlNGkRFPmtzpPMTMSmQfCQ
         qVur+GKDwqYdMgGtGNBc+tmon505J3bwrxsPmZjUjbzYIai9NuVfwwKmb8Tr2NgEZN
         Aju7BXXXaTIfQC5SDc8xeKH43o40L0TNKV2scksj5KQ+dtZnvXgbSimF0WLIg/3qiZ
         pKqOzqNFQvoMKY+OFgc1yvi/Ygyfb9ncdyIT4y6ZtO3G6xmygxfUV4J1NFhSchw0Gc
         LcCQJZn6pp04vQ1Ff3XceJvY1hv6NROBlQXWrswGb+lMuebgcOWh6ZCQAM7I6BI1gp
         cUyiPlRs8kvpw==
Date:   Wed, 6 Apr 2022 22:07:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH RESEND net-next v4] net: remove noblock parameter from
 skb_recv_datagram()
Message-ID: <20220406220745.2fe27055@kernel.org>
In-Reply-To: <20220404163022.88751-1-socketcan@hartkopp.net>
References: <20220404163022.88751-1-socketcan@hartkopp.net>
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

On Mon,  4 Apr 2022 18:30:22 +0200 Oliver Hartkopp wrote:
> skb_recv_datagram() has two parameters 'flags' and 'noblock' that are
> merged inside skb_recv_datagram() by 'flags | (noblock ? MSG_DONTWAIT : 0)'
> 
> As 'flags' may contain MSG_DONTWAIT as value most callers split the 'flags'
> into 'flags' and 'noblock' with finally obsolete bit operations like this:
> 
> skb_recv_datagram(sk, flags & ~MSG_DONTWAIT, flags & MSG_DONTWAIT, &rc);
> 
> And this is not even done consistently with the 'flags' parameter.
> 
> This patch removes the obsolete and costly splitting into two parameters
> and only performs bit operations when really needed on the caller side.
> 
> One missing conversion thankfully reported by kernel test robot. I missed
> to enable kunit tests to build the mctp code.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>

We may have missed the pw bot's reply. Either that or vger ate it for
me. Looks like this is commit f4b41f062c42 ("net: remove noblock
parameter from skb_recv_datagram()") in net-next. Thanks!
