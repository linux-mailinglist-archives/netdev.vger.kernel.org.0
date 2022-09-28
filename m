Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0962D5ED27F
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 03:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbiI1BKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 21:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiI1BKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 21:10:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DA63AB27
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 18:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB148B81E7F
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04674C433C1;
        Wed, 28 Sep 2022 01:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664327443;
        bh=g9j82cPBYottCx8xmBQoSti2S3WVUyOFIE3mId3Q2RI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xqe+muXAlti0pcfCbJ/soK5GSVnbRnroWiAsECCnis7Qj6HguZl3oHLJMlFE3ZXFF
         9Rt7JUo9SObY1sNY8X3OFBtIR3N1tZ6CDzqTZ2SmuxzAkF3KgZuJNiI1V+qlyDcnLZ
         mxdqlAhFXL69ODUw3S9emlG937GnFrO5kBSHhzxDm5Th5iAFkfhsXXft7vWgumPR+B
         Mkys+Lwz+E+1AWyJBRbb+QnINIXWq8QnmyB5z1uQrnFvRynr79283q74+AGfFkeXCT
         vAYGgSO9A8V46kBaQjiJR6wtg/uJYaWo1+0rPaQAoh6a6KzdUVHQXOZiDTK7hQkiDA
         Z5aD28cC952Gw==
Date:   Tue, 27 Sep 2022 18:10:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next v2 3/7] net: devlink: add port_init/fini()
 helpers to allow pre-register/post-unregister functions
Message-ID: <20220927181041.7be7b305@kernel.org>
In-Reply-To: <20220927075645.2874644-4-jiri@resnulli.us>
References: <20220927075645.2874644-1-jiri@resnulli.us>
        <20220927075645.2874644-4-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 09:56:41 +0200 Jiri Pirko wrote:
> To be consistent with devlink regions, devlink port regions are going to
> be forbidden to be created once devlink port is registered. Prepare for
> this and introduce new set of helpers to allow driver to initialize
> devlink pointer and region list before devlink_register() is called
> That allows port regions to be created before devlink port registration
> and destroyed after devlink port unregistration.

The patches look good but I think the commit message needs an update,
no?  We no longer plan to forbid the late registration IIRC.
