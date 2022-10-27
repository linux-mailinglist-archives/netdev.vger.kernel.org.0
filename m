Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297F660F2D1
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 10:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbiJ0IrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 04:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235010AbiJ0IrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 04:47:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0CE15F31D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 01:46:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EAB162209
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 08:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616D8C433C1;
        Thu, 27 Oct 2022 08:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666860418;
        bh=gIJSpyewWOolqKWna94XAYihykuuJlEYF+BCaYcBnTk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r30NwQ6gtVYu/OHYCR0tD6P/Zv6TBnW6na0IIH4Exzhyiko0rgISwMuYbvVIgexjw
         gUkqKBK0vLCRdvzf9cmSXB318z7Jgk/lWg9pMihPNOcBQEOplsNNIiHiZmak7qS4Qc
         JQemS2ffOKPcd/2SQeB4YJQ9xNRITB//gNjoBim5Zw7Kwj2iwLyJ1sQcmSC8eDvG29
         6m/yhEKaqc4sQMHbkmrPlxDiXbLu25UMeftksXRyWE+umlJ9qmxWofGuEXrXQv1Xsh
         dYV3G5rw04KMTHXShXf0JyED8STOZR/4t/A/s8c7mBiIOUI9Kbv0WDnblRbzvYmXlx
         S/rkrnuR3kWfQ==
Date:   Thu, 27 Oct 2022 09:46:54 +0100
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
Message-ID: <20221027084654.uomwanu3ubuyh5z4@sx1>
References: <20221019140943.18851-1-simon.horman@corigine.com>
 <20221019180106.6c783d65@kernel.org>
 <20221020013524.GA27547@nj-rack01-04.nji.corigine.com>
 <20221025075141.v5rlybjvj3hgtdco@sx1>
 <DM6PR13MB370566F6E88DB8A258B93F29FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221025110514.urynvqlh7kasmwap@sx1>
 <DM6PR13MB3705B01B27C679D20E0224F4FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221026142221.7vp4pkk6qgbwcrjk@sx1>
 <DM6PR13MB370531053A394EE41080158FFC339@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <DM6PR13MB370531053A394EE41080158FFC339@DM6PR13MB3705.namprd13.prod.outlook.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27 Oct 02:11, Yinjun Zhang wrote:
>On Wed, 26 Oct 2022 15:22:21 +0100, Saeed Mahameed wrote:
>> On 25 Oct 11:39, Yinjun Zhang wrote:
>> >On Date: Tue, 25 Oct 2022 12:05:14 +0100, Saeed Mahameed wrote:
>>
>> Usually you create the VFs unbound, configure them and then bind them.
>> otherwise a query will have to query any possible VF which for some vendors
>> can be thousands ! it's better to work on created but not yet deployed vfs
>
>Usually creating and binding are not separated, that's why `sriov_drivers_autoprobe`
>is default true, unless some particular configuration requires it, like mlnx's msix
>practice.
>
>>
>> >Two options,
>> >one is from VF's perspective, you need configure one by one, very
>> straightforward:
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
>
>Sorry, I admit the naming is not appropriate here. It should be "total_q_for_VF "
>for parent resource, and "q_for_VFx" for the sub resources.
>
>>
>> Note that i called the resource "q_table" and not "max_queues",
>> since semantically max_queues is a parameter where q_table can be looked
>> at
>> as a sub-resource of the VF, the q_table size decides the max_queues a VF
>> will accept, so there you go !
>
>Queue itself is a kind of resource, why "q_table"? Just because the unit is entry?
>I think we need introduce a new generic unit, so that its usage won't be limited.
>
it's all abut semantics, yes q is a resource, but max_q is not.
if you want to go with q as a resource, then you will have to start
assigning individual queues to vfs one by one.. hence q_table per VF will
make it easier to control q table size per vf, with max size and guaranteed
size.
  
>> arghh weird.. just make it an attribute for devlink port function and name it
>> max_q as god intended it to be ;). Fix your FW to allow changing VF
>> maxqueue for
>> unbound VFs if needed.
>>
>
>It's not the FW constraints, the reason I don't prefer port way is it needs:
>1. separate VF creating and binding, which needs extra operation
>2. register extra ports for VFs
>Both can be avoided when using resource way.
>

Thanks, good to know it's not a FW/ASIC constraint, 
I am trying to push for one unified orchestration model for all VFs,SFs and the
upcoming intel's SIOV function.

create->configure->deploy. This aligns with all standard virtualization
orchestration modles, libvirt, kr8, etc .. 

Again i am worried we will have to support a config query for ALL possible
functions prior to creation.

Anyway i am flexible, I am ok with having a configure option prior to
creation as long as it doesn't create clutter, and user confusion, and it's
semantically correct.

we can also extend devlink port API to allow configure ops on "future"
ports and we can always extend the API to accept yaml file as an extension
of what Jakub suggested in LPC, to avoid one by one configurations.



