Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB03C60F5B2
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 12:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbiJ0KtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 06:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiJ0KtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 06:49:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869A389912
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 03:49:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DB566226B
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 10:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8A2C433D7;
        Thu, 27 Oct 2022 10:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666867758;
        bh=7ktDbx7UcZwUlWaKMDWHBLfkDiVSmTtLq1nFLWMBrwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rFeLzOjli3sPlmAgIEi5JTrb7GkfqRs/eJn33vaCaZfGirhLqgINBpWRKR9Z8GoBR
         CSYHSf0lUOQxb0VOXfv02WiQZrKaFd5bBtfwCb2i6Ee+ssAf9tWRq01yc5U22VQgRD
         0ZwjzkNV8B9hnmpxgNi/KboP9bAY5el+y6J1J2HSADY66PPzzVvbCyV/W83mL4bsC7
         Y2kFvSVXu18O+vS5ccIWkM7CcWOakkLyw4rrLBFZSSMJsyZh0kd3VwieV1iAvhcr58
         OOIy2Pow2+k8xmd++pqiOf7KC1ULLh/fqEA7BvAytFncOQT6xv4B6EitIbHfP8tCvK
         VaUtig74shGBA==
Date:   Thu, 27 Oct 2022 11:49:14 +0100
From:   Saeed Mahameed <saeed@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <20221027104914.fasecsmjsksbrace@sx1>
References: <20221019180106.6c783d65@kernel.org>
 <20221020013524.GA27547@nj-rack01-04.nji.corigine.com>
 <20221025075141.v5rlybjvj3hgtdco@sx1>
 <DM6PR13MB370566F6E88DB8A258B93F29FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221025110514.urynvqlh7kasmwap@sx1>
 <DM6PR13MB3705B01B27C679D20E0224F4FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221026142221.7vp4pkk6qgbwcrjk@sx1>
 <DM6PR13MB370531053A394EE41080158FFC339@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221027084654.uomwanu3ubuyh5z4@sx1>
 <DM6PR13MB370569B90708587836E9ED6AFC339@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <DM6PR13MB370569B90708587836E9ED6AFC339@DM6PR13MB3705.namprd13.prod.outlook.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27 Oct 09:46, Yinjun Zhang wrote:
>On Thu, 27 Oct 2022 09:46:54 +0100, Saeed Mahameed wrote:
><...>
>> if you want to go with q as a resource, then you will have to start
>> assigning individual queues to vfs one by one.. hence q_table per VF will
>> make it easier to control q table size per vf, with max size and guaranteed
>> size.
>
>Excuse my foolishness, I still don't get your q_table. What I want is allocating
>a certain amount of queues from a queue pool for different VFs, can you
>provide an example of q_table?
>

queue pool and queue table are the same concept. Q as a resource is an
individual entity, so it can't be used as the abstract.
for simplicity you can just call the resource "queues" plural, maybe .. 

Also do we want to manage different queue types separately ?
Rx/Tx/Cq/EQ/command etc ?

how about the individual max sizes of these queues ? 

BTW do you plan to have further customization per VF? not in particular
resource oriented customization, more like capability control type of
configs, for example enabling/disabling crypto offloads per VF? admin
policies ? etc .. 
If so i would be happy if we collaborated on defining the APIs.

><...>
>>
>> Thanks, good to know it's not a FW/ASIC constraint,
>> I am trying to push for one unified orchestration model for all VFs,SFs and
>> the
>> upcoming intel's SIOV function.
>>
>> create->configure->deploy. This aligns with all standard virtualization
>> orchestration modles, libvirt, kr8, etc ..
>>
>> Again i am worried we will have to support a config query for ALL possible
>> functions prior to creation.
>>
>> Anyway i am flexible, I am ok with having a configure option prior to
>> creation as long as it doesn't create clutter, and user confusion, and it's
>> semantically correct.
>
>Thanks for your ok and thanks to Leon's explanation, I understand your
>create->config->deploy proposal. But I have to say the resource way
>doesn't break it, you can config it after creating, and it's not constrained
>to it, you can config it before creating as well.
>

Think about the poor admin who will need to have different config steps for
different port flavors.

