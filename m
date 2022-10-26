Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8B960EB8D
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 00:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiJZWZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 18:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbiJZWZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 18:25:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB699B870
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 15:25:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A9A1620DD
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 22:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB58BC433D6;
        Wed, 26 Oct 2022 22:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666823127;
        bh=Sc4aRtXyDwyNHpCMuFWsllIr40tLoHZx8GQm8e5492Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LhpBEfTEs9irlR5o73bJ/sD0Z3ZL/jA9r1c/UbHsn6QOVPp3BZ86bIOkm2/tSJDKe
         xGe8VDUD/xFzE+YbaGuKKNNUMLt7/RSuCvURttHC+GJTnHdj76JkWF/P/Uy/m11DyG
         3uzY/X5vtnKFikt9vQ3JYQTniD8O+/uvTZoUs8Ch9EO2QaHZ5yRajpYzZpkCRFDhPx
         1QD6fY7PjszWT24huywCahD3K+U1fVkt338oMSnSQfzBAwVorkc1sC+FLoDdYennid
         ZeUOcNaEHPO5Xx0745js1Gio80wCFU8F37dmGGPrnw5CEuvcGADtOdtWgmwHwjxoon
         Kc5CaOMJSJ4Qg==
Date:   Wed, 26 Oct 2022 23:25:22 +0100
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Nole Zhang <peng.zhang@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next 0/3] nfp: support VF multi-queues configuration
Message-ID: <20221026222522.herpgpxy3izhy6be@sx1>
References: <20221019140943.18851-1-simon.horman@corigine.com>
 <20221019180106.6c783d65@kernel.org>
 <20221020013524.GA27547@nj-rack01-04.nji.corigine.com>
 <20221025075141.v5rlybjvj3hgtdco@sx1>
 <DM6PR13MB370566F6E88DB8A258B93F29FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221025110514.urynvqlh7kasmwap@sx1>
 <DM6PR13MB3705B01B27C679D20E0224F4FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221026142221.7vp4pkk6qgbwcrjk@sx1>
 <20221026130741.1b8f118c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221026130741.1b8f118c@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26 Oct 13:07, Jakub Kicinski wrote:
>On Wed, 26 Oct 2022 15:22:21 +0100 Saeed Mahameed wrote:
>> >Sorry, I thought you meant each VF creates a devlink obj. So still one devlink obj
>> >and each VF registers a devlink port, right? But the configuration is supposed to
>> >be done before VFs are created, it maybe not appropriate to register ports before
>> >relevant VFs are created I think.
>>
>> Usually you create the VFs unbound, configure them and then bind them.
>> otherwise a query will have to query any possible VF which for some vendors
>> can be thousands ! it's better to work on created but not yet deployed vfs
>
>And the vendors who need to configure before spawning will do what,
>exactly? Let's be practical.
>
>> >> can you provide an example of how you imagine the reosurce vf-max-queue
>> >> api
>> >> will look like ?
>> >
>> >Two options,
>> >one is from VF's perspective, you need configure one by one, very straightforward:
>> >```
>> >pci/xxxx:xx:xx.x:
>> >  name max_q size 128 unit entry
>> >    resources:
>> >      name VF0 size 1 unit entry size_min 1 size_max 128 size_gran 1
>> >      name VF1 size 1 unit entry size_min 1 size_max 128 size_gran 1
>> >      ...
>>
>> the above semantics are really weird,
>> VF0 can't be a sub-resource of max_q !
>>
>> sorry i can't think of a way where devlink resoruce semantics can work for
>> VF resource allocation.
>
>It's just an API section. New forms of configuration can be added.
>In fact they should so we can stop having this conversation.
>
>> Unless a VF becomes a resource and it's q_table becomes a sub resource of that
>> VF, which means you will have to register each vf as a resource individually.
>>
>> Note that i called the resource "q_table" and not "max_queues",
>> since semantically max_queues is a parameter where q_table can be looked at
>> as a sub-resource of the VF, the q_table size decides the max_queues a VF
>> will accept, so there you go !
>
>Somewhere along the way you missed the other requirements to also allow
>configuring guaranteed count that came from brcm as some point.
>

max_q and guarantee can be two separate attributes of a devlink port,
anyway see below before you answer, because i don't really care if it
devlink port or resource, but please don't allow the two suggested devlink
resource options to make it upstream as is, please, let's be practical and
correct.

>> arghh weird.. just make it an attribute for devlink port function and name it
>> max_q as god intended it to be ;)
>
>Let's not equate what fits the odd world of Melvidia FW with god.
>
>> Fix your FW to allow changing VF maxqueue for unbound VFs if needed.
>
>Not every device out there is all FW. Thankfully.

This has nothing to do with FW, all devices should be flexible enough to allow
configuring VFs after spawning.
anyway, my point is max_q isn't a resource period, you have to come-up with 
"q_table" concept. and sure, change the API to make it fit your needs, that's
acceptable when you want it to be acceptable, fine, but please don't allow
wrong semantics, I am interested in this feature for mlx5 as well, i don't care
if it's going to be resource or port, all I care about using the right
semantics, for that i suggested the devlink port option and the right semantics
for the devlink resource option, so i am being practical.

