Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D16268F9C9
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 22:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjBHVhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 16:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbjBHVhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 16:37:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1DD2200A
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 13:37:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33C26B81FBA
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 21:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACE2C433EF;
        Wed,  8 Feb 2023 21:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675892229;
        bh=8j/yZHlxFjtl7wvCtsLD7PF5uLgzwhzSOjMg38bSy0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a1xLsVQuutDIxplWnLhtT3naBbobiOg7bFBcoMM+dTBPom8wnTL8A9UJjOCEUrDdX
         HX9v6kEMAILwrPdA3lKLyq2poa6j38bt4dwbDDHIZea6RmrdtdC3yh8q2M1bs9swWU
         XY/HUilVkEDPv+QUnujmOQpsRHs4bWqgvynw1K9xwek7BOyPvsGbNvcperVNmFq0H/
         6KBx1vXY5kH6JwYcNU9c3pgTR4nGS9oxmDqIicoqMg3lh2TvUzF+XhUK074AMIK9od
         4VDv9+loXjV86YI2OUGR8ZZSV3iCuBGcFF0yXmodP/5qUIId418c6bZRqh1BQRDSbX
         FcyAfEPdkp3vQ==
Date:   Wed, 8 Feb 2023 13:37:08 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+QWBFoz66KrsU7V@x130>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
 <20230206184227.64d46170@kernel.org>
 <Y+OFspnA69XxCnpI@unreal>
 <Y+OJVW8f/vL9redb@corigine.com>
 <Y+ONTC6q0pqZl3/I@unreal>
 <Y+OP7rIQ+iB5NgUw@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y+OP7rIQ+iB5NgUw@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Feb 13:05, Simon Horman wrote:
>On Wed, Feb 08, 2023 at 01:53:48PM +0200, Leon Romanovsky wrote:
>> On Wed, Feb 08, 2023 at 12:36:53PM +0100, Simon Horman wrote:
>> > On Wed, Feb 08, 2023 at 01:21:22PM +0200, Leon Romanovsky wrote:
>> > > On Mon, Feb 06, 2023 at 06:42:27PM -0800, Jakub Kicinski wrote:
>> > > > On Mon,  6 Feb 2023 16:36:02 +0100 Simon Horman wrote:
>> > > > > +VF assignment setup
>> > > > > +---------------------------
>> > > > > +In some cases, NICs could have multiple physical ports per PF. Users can assign VFs to
>> > > > > +different ports.
>> > > >
>> > > > Please make sure you run make htmldocs when changing docs,
>> > > > this will warn.
>> > > >
>> > > > > +- Get count of VFs assigned to physical port::
>> > > > > +
>> > > > > +    $ devlink port show pci/0000:82:00.0/0
>> > > > > +    pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical port 0 splittable true lanes 4
>> > > >
>> > > > Physical port has VFs? My knee jerk reaction is that allocating
>> > > > resources via devlink is fine but this seems to lean a bit into
>> > > > forwarding. How do other vendors do it? What's the mapping of VFs
>> > > > to ports?
>> > >
>> > > I don't understand the meaning of VFs here. If we are talking about PCI
>> > > VFs, other vendors follow PCI spec "9.3.3.3.1 VF Enable" section, which
>> > > talks about having one bit to enable all VFs at once. All these VFs will
>> > > have separate netdevs.
>> >
>> > Yes, that is the case here too (before and after).
>> >
>> > What we are talking about is the association of VFs to physical ports
>> > (in the case where a NIC has more than one physical port).
>>
>> We have devices with multiple ports too, but don't have such issues.
>> So it will help if you can provide more context here.
>>
>> I'm failing to see connection between physical ports and physical VFs.
>>
>> Are you saying that physical ports are actual PCI VFs, which spans L2 VFs,
>> which you want to assign to another port (PF)?
>
>No, a physical port is not a VF (nor a PF, FWIIW).
>
>The topic here is about two modes of behaviour.
>
>One, where VFs are associated with physical ports - conceptually one might
>think of this as some VFs and one phys port being plugged into one VEB,
>while other VFs and another phys port are plugged into another VEB.
>
>I believe this is the mode on most multi-port NICs.
>
>And another mode where all VFs are associated with one physical port,
>even if more than one is present. The NFP currently implements this model.
>
>This patch is about allowing NICs, in particular the NFP based NICs,
>to switch modes.

I don't understand the difference between the two modes, 
1) "where VFs are associated with physical ports"
2) "another mode where all VFs are associated with one physical port"

anyway here how it works for ConnectX devices, and i think the model should
be generalized to others as it simplifies the user life in my opinion.

Each physical port is represented by a PCI PF function.

devlink dev show
pci/0000:81:00.0 #port 1
pci/0000:81:00.1 #port 2

when you enable sriov, you enable it on a specific PF, eventually port,
meaning those vfs are only associated with that port.

# enable vfs on port 1
echo 4 > /sys/bus/pci/devices/0000:81:00.0/sriov_numvfs

# enable vfs on port 2
echo 4 > /sys/bus/pci/devices/0000:81:00.1/sriov_numvfs

$ devlink dev show
# port 1 PF
pci/0000:81:00.0

# port 2 PF
pci/0000:81:00.1

# port 1 VFs
pci/0000:81:00.2
pci/0000:81:00.3
pci/0000:81:00.4
pci/0000:81:00.5

# port 2 VFs
pci/0000:81:01.2
pci/0000:81:01.3
pci/0000:81:01.4
pci/0000:81:01.5

The pci address enumeration is device specific, but i don't think user
should care.




