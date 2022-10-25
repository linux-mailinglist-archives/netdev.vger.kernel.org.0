Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A77760CA98
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiJYLFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiJYLF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:05:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2645FA598C
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:05:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B485561876
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 11:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708BFC433D6;
        Tue, 25 Oct 2022 11:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666695918;
        bh=ZVfo0fFPGF4iN6CJo9eW2SZwKf7TboUHZS2u+o7WCk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DXr9/feha1uWK6r5X7GeM8DokhgQSPYJeMpfZBcXDCczMBjEP680ZENJAvqlQOoCm
         eK52uwtjy2j351gvGUd1feEMZ4iXlxmPxlqQ62FUE4NmB6g1zU2hg+zVhyXt+USII4
         Hn30tn908aSkYpq2U017oMVY1estCyxumLCj6DKiPEE2ulbLS4a5oKQ3oziEtd5nde
         6Z16epob5eHsCqVY32jP3ljrzaLQ8+WmISbZCCf7dqb7aHZYC21gaA6t++VDCbO2XK
         mxs/MDAYeGkMGmvVHJo1nsEXbNItHMj+u+e2WbotLlHBTokEidd03NwgKvWbs+lRn/
         R2K7nA4gO1TyQ==
Date:   Tue, 25 Oct 2022 12:05:14 +0100
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
Message-ID: <20221025110514.urynvqlh7kasmwap@sx1>
References: <20221019140943.18851-1-simon.horman@corigine.com>
 <20221019180106.6c783d65@kernel.org>
 <20221020013524.GA27547@nj-rack01-04.nji.corigine.com>
 <20221025075141.v5rlybjvj3hgtdco@sx1>
 <DM6PR13MB370566F6E88DB8A258B93F29FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <DM6PR13MB370566F6E88DB8A258B93F29FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25 Oct 10:41, Yinjun Zhang wrote:
>On Tue, 25 Oct 2022 08:51:41 +0100, Saeed Mahameed wrote:
>> On 20 Oct 09:35, Yinjun Zhang wrote:
>> >On Wed, Oct 19, 2022 at 06:01:06PM -0700, Jakub Kicinski wrote:
>> >> On Wed, 19 Oct 2022 16:09:40 +0200 Simon Horman wrote:
>> >> > this short series adds the max_vf_queue generic devlink device
>> parameter,
>> >> > the intention of this is to allow configuration of the number of queues
>> >> > associated with VFs, and facilitates having VFs with different queue
>> >> > counts.
>> >> >
>> >> > The series also adds support for multi-queue VFs to the nfp driver
>> >> > and support for the max_vf_queue feature described above.
>> >>
>> >> I appreciate CCing a wider group this time, but my concerns about using
>> >> devlink params for resource allocation still stand. I don't remember
>> >> anyone refuting that.
>> >>
>> >> https://lore.kernel.org/all/20220921063448.5b0dd32b@kernel.org/
>> >
>> >Sorry this part was neglected, we'll take a look into the resource APIs.
>> >Thanks.
>> >
>>
>> The problem with this is that this should be a per function parameter,
>> devlink params or resources is not the right place for this as this
>> should be a configuration of a specific devlink object that is not the
>> parent device (namely devlink port function), otherwise we will have to
>> deal with ugly string parsing to address the specific vf attributes.
>>
>> let's use devlink port:
>> https://www.kernel.org/doc/html/latest/networking/devlink/devlink-
>> port.html
>>
>> devlink ports have attributes and we should extend attributes to act like
>> devlink parameters.
>>
>>    devlink port function set DEV/PORT_INDEX [ queue_count count ] ...
>>
>> https://man7.org/linux/man-pages/man8/devlink-port.8.html
>
>Although the vf-max-queue is a per-VF property, it's configured from PF's
>perspective, so that the overall queue resource can be reallocated among VFs.
>So a devlink object attached to the PF is used to configure, and resource seems
>more appropriate than param.
>

devlink port function is an object that's exposed on the PF. It will give
you a handle on the PF side to every sub-function (vf/sf) exposed via the
PF.

can you provide an example of how you imagine the reosurce vf-max-queue api
will look like ? 
