Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDB56A7D55
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 10:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjCBJKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 04:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjCBJKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 04:10:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF802A6C2;
        Thu,  2 Mar 2023 01:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9083A6153A;
        Thu,  2 Mar 2023 09:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118F2C433EF;
        Thu,  2 Mar 2023 09:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677748212;
        bh=UZHjTt3WcAHN0hlxS276lYr5jPZwtybl0ohiW2kCEiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N1x2z3qXQML4+BOJD7c4cF7FwMgMh8QfPe2mlaTVD8B7t6djp/P7UqujWYwC9gjUG
         6xd4i4FZVm3LkaQjKgJ0HtC2RbpPuv5ycZmCWy84ZYinZzhcG4L6ZMSFxfHJU0D3I2
         bY1UjGO68LlkSzeikb6tDF08t+oPLJ5KB1JMlJXgCXTWbNfEHW0YVew6ZxXwbQsV40
         RKO65PdWaVB3K5Y1SgAuCR2oMm6JIs5YW7cGg4W6bFCyKRW2IBQm3AOLlJDX2aR+wm
         LpJ1kG4yXWAck9Shifpf6M9Ln4TLJeRofygXvesY+dC6H6UXHz4oZeiyo2SVKfX9zT
         LRXHhJPWM3KgA==
Date:   Thu, 2 Mar 2023 11:10:08 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND net v1 0/2] iavf: fix double-broken HW hash report
Message-ID: <20230302091008.GA561905@unreal>
References: <20230301115908.47995-1-aleksander.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301115908.47995-1-aleksander.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 12:59:06PM +0100, Alexander Lobakin wrote:
> Currently, passing HW hash from descriptors to skb is broken two times.
> The first bug effectively disables hash from being filled at all, unless
> %NETIF_F_RXHASH is *disabled* via Ethtool. The second incorrectly says
> that IPv6 UDP packets are L3, which also triggers CPU hashing when
> needed (the networking core treats only L4 HW hash as "true").
> The very same problems were fixed in i40e and ice, but not in iavf,
> although each of the original commits bugged at least two drivers.
> It's never too late (I hope), so fix iavf this time.
> 
> Alexander Lobakin (2):
>   iavf: fix inverted Rx hash condition leading to disabled hash
>   iavf: fix non-tunneled IPv6 UDP packet type and hashing
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
