Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766F660E337
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbiJZOWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbiJZOWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:22:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E34D117001
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A7956CE2302
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 14:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62C3C433D6;
        Wed, 26 Oct 2022 14:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666794146;
        bh=wyyqZ+jKFItnpHqyyOCXXw1N0jiuoWCr4BaivprN+4Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NsSK1QYzaE4hV5iCci1vRPcr/mXIRLrxSy8q3La0QObdSPUxE6cYExwtKJcNL59YK
         AXhj9/Dd59lnYYpWxQJHq4zh2VmiHLSUkcgEVKaz6LO0JMiLV8XJP8zsL/2km/SxzK
         HUZ/NzOtW+G2TyHNHrZb4QMgh2yC3RPTnn2b4H50GBKqAJxhwjNvT0sc34Jn4YXGPe
         ZugS0o2hfUZCEkuxngaTNKZ0bq6s8m73WH0uFZ4/+VPLq975JdmMFNSgdMvqszYOpU
         u6jRrCCVYBGUOmDcMsXw+uB720VWGpey9kNhSPg3bbgyncu5EkJFBzFe8sZPeQztrI
         ipMVU3Rd7inZw==
Date:   Wed, 26 Oct 2022 15:22:21 +0100
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
Message-ID: <20221026142221.7vp4pkk6qgbwcrjk@sx1>
References: <20221019140943.18851-1-simon.horman@corigine.com>
 <20221019180106.6c783d65@kernel.org>
 <20221020013524.GA27547@nj-rack01-04.nji.corigine.com>
 <20221025075141.v5rlybjvj3hgtdco@sx1>
 <DM6PR13MB370566F6E88DB8A258B93F29FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221025110514.urynvqlh7kasmwap@sx1>
 <DM6PR13MB3705B01B27C679D20E0224F4FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <DM6PR13MB3705B01B27C679D20E0224F4FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25 Oct 11:39, Yinjun Zhang wrote:
>On Date: Tue, 25 Oct 2022 12:05:14 +0100, Saeed Mahameed wrote:
>> On 25 Oct 10:41, Yinjun Zhang wrote:
>> >On Tue, 25 Oct 2022 08:51:41 +0100, Saeed Mahameed wrote:
>> >> The problem with this is that this should be a per function parameter,
>> >> devlink params or resources is not the right place for this as this
>> >> should be a configuration of a specific devlink object that is not the
>> >> parent device (namely devlink port function), otherwise we will have to
>> >> deal with ugly string parsing to address the specific vf attributes.
>> >>
>> >> let's use devlink port:
>> >> https://www.kernel.org/doc/html/latest/networking/devlink/devlink-
>> >> port.html
>> >>
>> >> devlink ports have attributes and we should extend attributes to act like
>> >> devlink parameters.
>> >>
>> >>    devlink port function set DEV/PORT_INDEX [ queue_count count ] ...
>> >>
>> >> https://man7.org/linux/man-pages/man8/devlink-port.8.html
>> >
>> >Although the vf-max-queue is a per-VF property, it's configured from PF's
>> >perspective, so that the overall queue resource can be reallocated among
>> VFs.
>> >So a devlink object attached to the PF is used to configure, and resource
>> seems
>> >more appropriate than param.
>> >
>>
>> devlink port function is an object that's exposed on the PF. It will give
>> you a handle on the PF side to every sub-function (vf/sf) exposed via the
>> PF.
>
>Sorry, I thought you meant each VF creates a devlink obj. So still one devlink obj
>and each VF registers a devlink port, right? But the configuration is supposed to
>be done before VFs are created, it maybe not appropriate to register ports before
>relevant VFs are created I think.
>

Usually you create the VFs unbound, configure them and then bind them.
otherwise a query will have to query any possible VF which for some vendors
can be thousands ! it's better to work on created but not yet deployed vfs

>>
>> can you provide an example of how you imagine the reosurce vf-max-queue
>> api
>> will look like ?
>
>Two options,
>one is from VF's perspective, you need configure one by one, very straightforward:
>```
>pci/xxxx:xx:xx.x:
>  name max_q size 128 unit entry
>    resources:
>      name VF0 size 1 unit entry size_min 1 size_max 128 size_gran 1
>      name VF1 size 1 unit entry size_min 1 size_max 128 size_gran 1
>      ...

the above semantics are really weird, 
VF0 can't be a sub-resource of max_q ! 

sorry i can't think of a way where devlink resoruce semantics can work for
VF resource allocation.

Unless a VF becomes a resource and it's q_table becomes a sub resource of that
VF, which means you will have to register each vf as a resource individually.

Note that i called the resource "q_table" and not "max_queues",
since semantically max_queues is a parameter where q_table can be looked at
as a sub-resource of the VF, the q_table size decides the max_queues a VF
will accept, so there you go ! 
arghh weird.. just make it an attribute for devlink port function and name it
max_q as god intended it to be ;). Fix your FW to allow changing VF maxqueue for
unbound VFs if needed.


>```
>another is from queue's perspective, several class is supported, not very flexible:
>```
>pci/xxxx:xx:xx.x:
>  name max_q_class size 128 unit entry
>    resources:
>      # means how many VFs possess max-q-number of 16/8/..1 respectively
>      name _16 size 0 unit entry size_min 0 size_max 128 size_gran 1
>      name _8 size 0 unit entry size_min 0 size_max 128 size_gran 1
>      ...
>      name _1 size 0 unit entry size_min 0 size_max 128 size_gran 1
>```

weirder.

