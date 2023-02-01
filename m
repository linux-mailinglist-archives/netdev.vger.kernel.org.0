Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6463C685EC3
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjBAFMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBAFMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:12:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A2F4FAC9;
        Tue, 31 Jan 2023 21:12:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9079D60DD9;
        Wed,  1 Feb 2023 05:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1CAC4339B;
        Wed,  1 Feb 2023 05:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675228350;
        bh=dCvAXFb7n0pTDR7I1XIOIx81VjpvtEQ2CQmuCT9smWo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eQCpJVdML9zqf4pQZylD0Pm9/OrJzmYjR5PMfnOnC9j8Wo40tZLjKTkSQyAPr0aba
         t8n85lnDreCnpa5ZF3rpVB4Un2SgskxfdU8XHbebDcxevii38U6h+Wg1CN/R78J2aN
         6799SeKE77Y5URHqijOJbAmAT+p+inZIn3iUWp6hwdamrDMMglVPjbjs4KUYxqIvg1
         NnWuSIoVauDT181iaIy1JNzuxZZpoI3YZQEg7GKKA5BbbvuGAHu8I/NajdgPLjSd4b
         roiGr5JpsIO6TM3MBXnLPJ7IT0BKbqqvE+7HnUDguGWiw0W18XGTrpud0scImtogU+
         8qCGz1kmPtE3A==
Date:   Tue, 31 Jan 2023 21:12:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>, leon@kernel.org
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH net-next v9 0/8] Add Auxiliary driver support
Message-ID: <20230131211228.78dae343@kernel.org>
In-Reply-To: <20230131052557.99119-1-ajit.khaparde@broadcom.com>
References: <20230131052557.99119-1-ajit.khaparde@broadcom.com>
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

On Mon, 30 Jan 2023 21:25:49 -0800 Ajit Khaparde wrote:
> Add auxiliary device driver for Broadcom devices.
> The bnxt_en driver will register and initialize an aux device
> if RDMA is enabled in the underlying device.
> The bnxt_re driver will then probe and initialize the
> RoCE interfaces with the infiniband stack.
> 
> We got rid of the bnxt_en_ops which the bnxt_re driver used to
> communicate with bnxt_en.
> Similarly  We have tried to clean up most of the bnxt_ulp_ops.
> In most of the cases we used the functions and entry points provided
> by the auxiliary bus driver framework.
> And now these are the minimal functions needed to support the functionality.
> 
> We will try to work on getting rid of the remaining if we find any
> other viable option in future.

Better :)

Leon, looks good to you as well?

Note to DaveM/self - this needs to be pulled rather than applied:

> The following are changes since commit 90e8ca0abb05ada6c1e2710eaa21688dafca26f2
>  Merge branch 'devlink-next'
> and are available in the git repository at:
>  https://github.com/ajitkhaparde1/net-next/tree/aux-bus-v9
