Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46861641CEE
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 13:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiLDMhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 07:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDMhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 07:37:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A282514D1F
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 04:37:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46D31B80918
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 12:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B333AC433C1;
        Sun,  4 Dec 2022 12:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670157421;
        bh=zq4kpyIlpyDER0xwasILJtRKnjzdidPO8D8zQ84IqwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fuRJOLAsrMHAezJW4l71rAkQSSw6/4qnhh3j5QqncQBdmtONQTGuJq6W+6DwvGstE
         buqB6g/aHzdHz9pZW08CqQ9UUFnI8xBBjR1IHzR15oyHqC0IB4HnxvWeTzRAk3YX1t
         UG8JOSc+LX2MUx0Ev0BfBavdXAfmlZx9HWAXaJefZ3GEQrrY992NRUML7UX0EkdKlk
         +shUWuCla5FmQ50XO8UQfJqjpSCz5IMOCrKHSogJhWEIhSxd7XoaAp2l0zu7llzpvY
         +ry7T13+ITfd5iqg6nQydEvWrwdDb4s5Jc3cMX0L40zVdHdRyRqvNG81LpKV6lo7fw
         pgBGJPKYp0Rwg==
Date:   Sun, 4 Dec 2022 14:36:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Diana Wang <na.wang@corigine.com>
Subject: Re: [PATCH net-next] nfp: add support for multicast filter
Message-ID: <Y4yUY/fOlcWvm3ip@unreal>
References: <20221202094214.284673-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202094214.284673-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 10:42:14AM +0100, Simon Horman wrote:
> From: Diana Wang <na.wang@corigine.com>
> 
> Rewrite nfp_net_set_rx_mode() to implement interface to delivery
> mc address and operations to firmware by using general mailbox
> for filtering multicast packets.
> 
> The operations include add mc address and delete mc address.
> And the limitation of mc addresses number is 1024 for each net
> device.
> 
> User triggers adding mc address by using command below:
> ip maddress add <mc address> dev <interface name>
> 
> User triggers deleting mc address by using command below:
> ip maddress del <mc address> dev <interface name>
> 
> Signed-off-by: Diana Wang <na.wang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net.h  |  5 ++
>  .../ethernet/netronome/nfp/nfp_net_common.c   | 63 +++++++++++++++++--
>  .../net/ethernet/netronome/nfp/nfp_net_ctrl.h | 15 +++++
>  3 files changed, 79 insertions(+), 4 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
