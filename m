Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D5E67F607
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 09:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbjA1IQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 03:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjA1IQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 03:16:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07919F771
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 00:16:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9C19B8121F
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE405C433D2;
        Sat, 28 Jan 2023 08:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674893802;
        bh=rgb7Z2BpO91SLQ6mfmuqc5dA0hwnEqCp7Lbu0c9nw3Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dW8ehTo67EzIo1IAuJZJJZGifbP9aWgOqjZ3dBcCah+3NEwY1dmbt8Cfnls8Da8p+
         E6YX/RsLyyXvScmguJpof3VyKH6sf9auqtNkc5fojfKnt+aJHpZr7JIt1y8jV3IZ/a
         VxKNK2prNyp9Q7Kq98+G9QhBIKCsI9YaeQ+o68Ogg6sr5vGxLs1idITUColNc7fJQH
         mDm4pbdll2JtcxDP9vRQSLjlkRqV1PQQlgQz2GWpxzhW02w9JUvQMrLIAnKHyWh/NA
         g/VRC9rcFDqQA8kfSayCB0CNQVsjZqWKiyDiz+TGEWv/Cv0UZ06W5CRw6tDmuMU4ll
         FkeHb+ioju3yA==
Date:   Sat, 28 Jan 2023 00:16:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v5 0/6] net/sched: cls_api: Support hardware
 miss to tc action
Message-ID: <20230128001640.7d7ad66c@kernel.org>
In-Reply-To: <20230125153218.7230-1-paulb@nvidia.com>
References: <20230125153218.7230-1-paulb@nvidia.com>
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

On Wed, 25 Jan 2023 17:32:12 +0200 Paul Blakey wrote:
> This series adds support for hardware miss to instruct tc to continue execution
> in a specific tc action instance on a filter's action list. The mlx5 driver patch
> (besides the refactors) shows its usage instead of using just chain restore.
> 
> Currently a filter's action list must be executed all together or
> not at all as driver are only able to tell tc to continue executing from a
> specific tc chain, and not a specific filter/action.
> 
> This is troublesome with regards to action CT, where new connections should
> be sent to software (via tc chain restore), and established connections can
> be handled in hardware.

I'll mark this as Deferred - would be great if Red Hat OvS offload
folks and/or another vendor and/or Jamal gave their acks.
