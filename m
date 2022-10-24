Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32361609CE2
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 10:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiJXIgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 04:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiJXIgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 04:36:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258806049F
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 01:36:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17534B80F93
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AB6C433D6;
        Mon, 24 Oct 2022 08:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666600607;
        bh=4j6eoOd9dczQxFK8Ab8Eaf0T1aN4zudn+Om6XVuDdIk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U3uhXzu4dfnWMVKy6M2EX/iciHwrqFliySQMTiLCkToPIWYlh8jjExPvKSvqUUF1K
         LRZeU+G1593sIqKvfmjipIP/L3/ZnyRH1K/Q2nRXZPVi4OZ2F8JrQwn+XYBk1yJejX
         CkE8+73Oy2Ko5Pfe/51pgYkFdwUf+RNrVIdtUf6GNcUcqAmWNxezMhMauizWhoj6De
         4/vGCz7oP3sRqJ2v3OFdXPv5N2T41LshZR/m1SuULf8WSVasDsEY2Ic8ufCihebp/N
         DNsoIY0Hhb0SUW0UBD/9WPm5MKuPlIeUzyAHljOi4ZTuqImunMzTprIpIWHArklbO5
         CJUhRmBOTCcyw==
Date:   Mon, 24 Oct 2022 11:36:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Gal Pressman <gal@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Peng Zhang <peng.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 2/3] devlink: Add new "max_vf_queue" generic
 device param
Message-ID: <Y1ZOm7QrbB0bf/H8@unreal>
References: <20221019140943.18851-1-simon.horman@corigine.com>
 <20221019140943.18851-3-simon.horman@corigine.com>
 <3c830f86-a814-d564-df7d-670d294b8890@nvidia.com>
 <20221024014713.GA20243@nj-rack01-04.nji.corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024014713.GA20243@nj-rack01-04.nji.corigine.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 09:47:13AM +0800, Yinjun Zhang wrote:
> On Sun, Oct 23, 2022 at 02:28:24PM +0300, Gal Pressman wrote:
> > [Some people who received this message don't often get email from gal@nvidia.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> > 
> > On 19/10/2022 17:09, Simon Horman wrote:
> > > From: Peng Zhang <peng.zhang@corigine.com>
> > >
> > > VF max-queue-number is the MAX num of queues which the VF has.
> > >
> > > Add new device generic parameter to configure the max-queue-number
> > > of the each VF to be generated dynamically.
> > >
> > > The string format is decided ad vendor specific. The suggested
> > > format is ...-V-W-X-Y-Z, the V represents generating V VFs that
> > > have 16 queues, the W represents generating W VFs that have 8
> > > queues, and so on, the Z represents generating Z VFs that have
> > > 1 queue.

<...>

> > 
> > Does this command have to be run before the VFs are created? What
> > happens to existing VFs?
> 
> Yes in our current implementation, but it's up to the vendor's
> implementation I think.

All vendors should give same look and feel for the users. It is very
frustrating to find that same command should be run in different point
of time just to perform same thing.

Thanks
