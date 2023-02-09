Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D58368FDD0
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 04:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbjBIDQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 22:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjBIDQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 22:16:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E4912A;
        Wed,  8 Feb 2023 19:16:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02854B81FDD;
        Thu,  9 Feb 2023 03:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D72FC433D2;
        Thu,  9 Feb 2023 03:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675912566;
        bh=oioOUpXBgqk+ntD7avwTrjrv0/4Gn8Lkv52+XQkqGec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W6JEjvv4wEpn/T39tpLjeqHGULZruqdCO9s7KZiTP66kdPtNzqaOPggEKOT2pVNgj
         yTEnSPZb6WfbMvIBShjbRO4p+ywCny9Uwfwl+IlQSDPl2+PtvUPuD7PWu/etkOZF2h
         Uq/ahPtLcro+hzlYeVmoqz8O9x7s12IwM6dbnXmLy7j4ky6CJNUpSWu4Z1ndy+WVtA
         5ictdv1cn1/bEHDp3KKkMN3RazX79DfZSQo99/Qn4JY+vdqYQIDwZ9zCi4bl0A125W
         6ifUwjcPYjqaTSCPSIy1ss2SZkOMiKczRtdUAqHQbKZvety6ko1Iz9mApKNJbpginP
         yLHYiSiv0Rt9w==
Date:   Wed, 8 Feb 2023 19:16:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next netdev notifier deadlock 2023-02-07
Message-ID: <20230208191605.719b19db@kernel.org>
In-Reply-To: <20230208191250.45b23b6f@kernel.org>
References: <20230208005626.72930-1-saeed@kernel.org>
        <20230208191250.45b23b6f@kernel.org>
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

On Wed, 8 Feb 2023 19:12:50 -0800 Jakub Kicinski wrote:
> On Tue,  7 Feb 2023 16:56:26 -0800 Saeed Mahameed wrote:
> > @@ -674,6 +675,7 @@ struct mlx5e_resources {
> >  	} hw_objs;
> >  	struct devlink_port dl_port;
> >  	struct net_device *uplink_netdev;
> > +	struct mutex uplink_netdev_lock;  
> 
> Is this your preferred resolution?

Ooh, maybe I'm not supposed to pull? 
Jiri's changes have Change-Ids on them:

    Signed-off-by: Jiri Pirko <jiri@nvidia.com>
    Change-Id: Ib33aa071464a65962a3857cbef02ff68f153090a
    Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
    Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
