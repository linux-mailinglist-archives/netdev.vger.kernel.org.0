Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8BB6E1EC7
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 10:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjDNIvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 04:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDNIvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 04:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3E5ED
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 01:51:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 754C1615AF
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 08:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0B0C433EF;
        Fri, 14 Apr 2023 08:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681462289;
        bh=CUcWreOPpnrS0ErusrVd2gMFL5BYqlnIIkRcXfFDY9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hUeFACfG1gHrzDF+Om4eQ3a2f8mlq9ghW9yejWf039NQBv1kO5TdpHN+/uT9ntDBj
         5OQjkvOxVjwU+wgIw+ZaqdAgmxywGk6V3b4WszW1RVHq5WAeT6e/gqNzGZLAlsv4DG
         8KyYyKcvyCJ6oJ1vr1JkWqYK9g6GRUedOeWcKvrskUuS/R0GUxj20Re8Der8Hflhge
         QsOcokt/X1InVuc+tIhG2MJKrnKXDhtTwV0eCTEY/4iUMlsiflTGKCQzql/MHtOmhC
         2CMLEPfgrPiva3D9kX6R4vBLx88Zg2GqidOM9nBl4iFv9bM6Ojoxq01S0rIyGtoGSz
         eiK9xloXOYOog==
Date:   Fri, 14 Apr 2023 11:51:25 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, drivers@pensando.io,
        jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 13/14] pds_core: publish events to the clients
Message-ID: <20230414085125.GY17993@unreal>
References: <20230406234143.11318-14-shannon.nelson@amd.com>
 <20230409171143.GH182481@unreal>
 <f5fbc5c7-2329-93e6-044d-7b70d96530be@amd.com>
 <20230413085501.GH17993@unreal>
 <20230413081410.2cbaf2a2@kernel.org>
 <20230413164434.GT17993@unreal>
 <20230413095509.7f15e22c@kernel.org>
 <20230413170704.GV17993@unreal>
 <20230413101015.0427a6c8@kernel.org>
 <d6a65f08-4494-8d54-7799-a819f6f2e566@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6a65f08-4494-8d54-7799-a819f6f2e566@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 04:42:08PM -0700, Shannon Nelson wrote:
> On 4/13/23 10:10 AM, Jakub Kicinski wrote:
> > 
> > On Thu, 13 Apr 2023 20:07:04 +0300 Leon Romanovsky wrote:
> > > > Hm, my memory may be incorrect and I didn't look at the code but
> > > > I thought that knob came from the "hit-less upgrade" effort.
> > > > And for "hit-less upgrade" not respawning the devices was the whole
> > > > point.
> > > > 
> > > > Which is not to disagree with you. What I'm trying to get at is that
> > > > there are different types of reset which deserve different treatment.
> > > 
> > > I don't disagree with you either, just have a feeling that proposed
> > > behaviour is wrong.
> > 
> > Shannon, can you elaborate on what the impact of the reset is?
> > What loss of state and/or configuration is possible?
> 
> The device has a couple different cases that might generate the RESET
> message:
>  - crashed and recovered, no state saved
>  - FW restarted, some or all state saved
> There are some variations on this, but these are the two general cases.
> 
> We can see in the existing ionic driver there already is some handling of
> this where the driver sees the FW come back and is able to replay the Rx
> filters and Rx mode configurations.  If and when we are able to add an Eth
> client through pds_core it will want this message so that it can replay
> configuration in the same way.  This case will also want the Link Down event
> so that it can do the right thing with the netdev.

I don't see how you can replay ALL (ethtool, devlink, ip, e.t.c) states
without net core involvement. The real fun will be with many offloaded
features, where you must preserve everything while keeping upper layer
in-sync with HW.

Thanks

> 
> For the VFio/Migration support (pds_vfio) the RESET message is essentially a
> no-op if nothing is happening.  But if the system is in the middle of a
> migration it offers the ability to "cleanly" fail the migration and let the
> system get ready to try again.

> 
> For the vDPA case (pds_vdpa) we can trigger the config_cb callback to get
> the attention of the stack above us to suggest it look at current status and
> respond as needed, whether that is a Link Change or a Reset.
> 
> sln
