Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF1E6CF9E8
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjC3EBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjC3EA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:00:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE8755AA
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 21:00:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 783DA61ED5
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8811AC433D2;
        Thu, 30 Mar 2023 04:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680148849;
        bh=rRC4bi5AJ3d81LQsWOmqgbzKwz0Z/y+D909+VbKFSc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cRxYgdnvZB1r+UuAJexVSmHRcPS2AO4QSsifpo2rUZylly4yKUVpMY85u8WxR9nEE
         VBs+eB1/hprJldrxbq+9c8j5AY+YgDXOyhA5gFQxmGtfgTBPqmVzgKrhm55n4szZ45
         DBhy8+hGOXiZO8jr3SEnagHCX3mFb0LTI/txWFy6Np0Ylaha+1L0FUyR4qCDr/Bb0p
         sc1dOppu1dxfR9vkwxk0qe3FBzIAQdkW0G8OkWocK8+yHFULzjUu9ZRUh1ZOSC+f5F
         QgFBvpyDMaDL/Qbh2uwr28srtzjkw3VpUKGxYESNtCJs4atF/yLzCta/8aJooRsXjY
         JD4pNiOcwnBrw==
Date:   Wed, 29 Mar 2023 21:00:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Message-ID: <20230329210048.0054e01b@kernel.org>
In-Reply-To: <DM6PR13MB37058BF030C43EAFA45DE4CAFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-3-louis.peens@corigine.com>
        <20230329122422.52f305f5@kernel.org>
        <DM6PR13MB37057AA65195F85CC16E34BCFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20230329194126.268ffd61@kernel.org>
        <DM6PR13MB3705B02A219219A4897A66C5FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20230329201225.421e2a84@kernel.org>
        <DM6PR13MB37058BF030C43EAFA45DE4CAFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 03:33:30 +0000 Yinjun Zhang wrote:
> > Why?  
> 
> I have to say most of other vendors behave like this. It's more practical
> and required by users.

That's not really a practical explanation. Why does anyone want traffic
to flow thru a downed port. Don't down the port, if you want it to be
up, I'd think.

This patch is very unlikely to be accepted upstream.
Custom knobs to do weird things are really not our favorite.
