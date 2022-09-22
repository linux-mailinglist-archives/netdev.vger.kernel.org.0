Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAA75E6BBA
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 21:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiIVTbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 15:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiIVTbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 15:31:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1254F106F76
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:31:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8F02B839F0
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 19:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0BBC433C1;
        Thu, 22 Sep 2022 19:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663875089;
        bh=YdZpuyJppl5ko9DB7QVMT7xPoujjvL0zrcYY8DW8oVw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OB2VyfHsJgvPsgspux8ORE/zrzSWU0+q2J9fR44YQgZUeFkkxGBZ9mf/JgZRMSkBX
         BOg7fmg99+1JScRGvYowm9/j/nSRJTXymynt6dX/uqGdHaBAvetCkphlkvq46ODegs
         GPCw0dSxXexUGSMMDlVk81cgZl629j4+pI6HWxZa4XuoaRl0rwj02iNYcY9aJx30QH
         NAaoGi+OXILpF4CEw78WdfjF8sN4jOfelHnPcXkblD/hFt17g7YUDu+pr/Rfc2aPPC
         6yRRUIKIifjJ9T1+h9N9dRwBM1cGfKwBibzWjQS4k/SQa8kYoZRqkIWKMn/o8qJO+e
         YATbQ5/auC+hQ==
Date:   Thu, 22 Sep 2022 22:31:24 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Diana Wang <na.wang@corigine.com>,
        Peng Zhang <peng.zhang@corigine.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: driver uABI review list? (was: Re: [PATCH/RFC net-next 0/3] nfp:
 support VF multi-queues configuration)
Message-ID: <Yyy4DFQgLlEQky9Z@unreal>
References: <20220920151419.76050-1-simon.horman@corigine.com>
 <20220921063448.5b0dd32b@kernel.org>
 <YyyHg/lvzXHKNPe9@unreal>
 <YyydRHGFm/M6rSP5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyydRHGFm/M6rSP5@lunn.ch>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 07:37:08PM +0200, Andrew Lunn wrote:
> On Thu, Sep 22, 2022 at 07:04:19PM +0300, Leon Romanovsky wrote:
> > On Wed, Sep 21, 2022 at 06:34:48AM -0700, Jakub Kicinski wrote:
> > > On Tue, 20 Sep 2022 16:14:16 +0100 Simon Horman wrote:
> > > > this short series adds the max_vf_queue generic devlink device parameter,
> > > > the intention of this is to allow configuration of the number of queues
> > > > associated with VFs, and facilitates having VFs with different queue
> > > > counts.
> > 
> > <...>
> > 
> > > Would it be helpful for participation if we had a separate mailing 
> > > list for discussing driver uAPI introduction which would hopefully 
> > > be lower traffic?
> > 
> > Please don't. It will cause to an opposite situation where UAPI
> > discussions will be hidden from most people. IMHO, every net vendor
> > should be registered to netdev mailing list and read, review and
> > participate.
> 
> Good in theory, but how often do you really see it happen?

I agree that the situation in netdev is not ideal, but it can be
improved by slightly changing acceptance criteria. 

As a rough idea (influenced by DRM subsystem), require cross-vendor
review prior merge. It doesn't need to be universal, and can be
applicable only to most active companies. If reviews are not happening
in sensible time frame, there are ways "to punish" vendor that was
asked to review.

Thanks
