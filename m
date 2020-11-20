Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9420A2BAFE3
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 17:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgKTQRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 11:17:06 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12019 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728834AbgKTQRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 11:17:04 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb7ec0b0002>; Fri, 20 Nov 2020 08:17:15 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 16:17:03 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 20 Nov 2020 16:17:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DihsY/FgQuES4FUV64Rm+9CaYTrBeytQ+S7yd5gbJf0TzO1KRyI5KZUjXgml4U5fygNBU/j0rjeYqXLcy0Xn4Ure02EKhxCPAYjmTqPX2Jmbu7/gh5AEuRYeHPME/5UHNdlvN6wvz2pUyO3A9In1xBMeo5YfKU/3RMQU1bMpkusSzsZKOWcdGykw7ikZKaBf+X59xxnyD1wiLLPDMRUHPFAA6j31H2xCNtEPESizsSivv4YFPhkcO0MDR1wE14YqO+ozTsmL12Jq+NP7UEG64Ya4BlwG4Gq0bxEzvqAW7u768mHIj5stODuPQ/dvLXRB6Hmcpmm5n/h4BGVUV9hyEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puRQKXKkgnaa4qwBfeifpMQxVg5wLhoIDrcgqSAgO2o=;
 b=YEfbe52ehKnFhXNiq6l9jWkll56JHUfM94JLsJndL9RRCq3NkVCpBG6/40QPVPLnrDBvB4znAv8IURy+PxzASl8r062WHsicQs97XxEmYaQFE0TdmW1IL0MlIlPORopp7yLNBO3HvDbQHTN5o0we7BpKuqiRQtymIVRCGyql5YIobcfwIta+o8drzAvB2JvCWlEhZuPZyExrQancdYuuEupGNXgROr7Psd1RIaIRrONsB+BJ+JlhPBrqic+WvwBVNHTw6CLUOWwfjJiqCa6ypXmAIkg+qa/0jwecFIR9Ok8f6WL4vqP0voYDqmPBJC2gH5jMehsGCAyMAQY03bowTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0108.namprd12.prod.outlook.com (2603:10b6:4:58::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.24; Fri, 20 Nov
 2020 16:17:02 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3589.022; Fri, 20 Nov 2020
 16:17:02 +0000
Date:   Fri, 20 Nov 2020 12:16:59 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>, Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
Message-ID: <20201120161659.GE917484@nvidia.com>
References: <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
 <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <BY5PR12MB4322F01A4505AF21F696DCA2DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201118182319.7bad1ca6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <28239ff66a27c0ddf8be4f1461e27b0ac0b02871.camel@kernel.org>
 <20201119140017.GN244516@ziepe.ca>
 <20201119193526.014b968b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201119193526.014b968b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-ClientProxiedBy: BL0PR02CA0123.namprd02.prod.outlook.com
 (2603:10b6:208:35::28) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR02CA0123.namprd02.prod.outlook.com (2603:10b6:208:35::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21 via Frontend Transport; Fri, 20 Nov 2020 16:17:01 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kg95n-008rfm-Re; Fri, 20 Nov 2020 12:16:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605889035; bh=puRQKXKkgnaa4qwBfeifpMQxVg5wLhoIDrcgqSAgO2o=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=JMuAvEyjBaa+IX3Vk2PL7l8t40VEfe01UJJyhQyZckauowcz77YJG0w2lPUQhNaw0
         iilxjMeeM6nXeI9uZtmtuq8hy/+XyTtoRiCbu0ZZlw523U0SFO83Jm8FRcK8wOqrt2
         n9haPztNOzLaeTmzK/alsqn8quo8coRKa4VogbQC9OKBbkn2ur12OvWw+gJ6+WUTl+
         E6MyU3aHUJRwnL08EE0PHrOoQL15ejLOwCNolgzX9N60TRCnSoxj3odZz5V2PeOZfW
         8FJ2lzj1S3BwxpDNPhGE+++KzLPUwSaAMMyHLQO2HQhGApsGGl+6w3ZLHSKTuxOjog
         NTA11yS8FPBAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 07:35:26PM -0800, Jakub Kicinski wrote:
> On Thu, 19 Nov 2020 10:00:17 -0400 Jason Gunthorpe wrote:
> > Finally, in the mlx5 model VDPA is just an "application". It asks the
> > device to create a 'RDMA' raw ethernet packet QP that is uses rings
> > formed in the virtio-net specification. We can create it in the kernel
> > using mlx5_vdpa, and we can create it in userspace through the RDMA
> > subsystem. Like any "RDMA" application it is contained by the security
> > boundary of the PF/VF/SF the mlx5_core is running on.
> 
> Thanks for the write up!

No problem!

> The part that's blurry to me is VDPA.

Okay, I think I see where the gap is, I'm going to elaborate below so
we are clear.

> I was under the impression that for VDPA the device is supposed to
> support native virtio 2.0 (or whatever the "HW friendly" spec was).

I think VDPA covers a wide range of things.

The basic idea is starting with the all SW virtio-net implementation
we can move parts to HW. Each implementation will probably be a little
different here. The kernel vdpa subsystem is a toolbox to mix the
required emulation and HW capability to build a virtio-net PCI
interface.

The most key question to ask of any VDPA design is "what does the VDPA
FW do with the packet once the HW accelerator has parsed the
virtio-net descriptor?".

The VDPA world has refused to agree on this due to vendor squabbling,
but mlx5 has a clear answer:

 VDPA Tx generates an ethernet packet and sends it out the SF/VF port
 through a tunnel to the representor and then on to the switchdev.

Other VDPA designs have a different answer!!

This concept is so innate to how Mellanox views the world it is not
surprising me that the cover letters and patch descriptions don't
belabor this point much :)

I'm going to deep dive through this answer below. I think you'll see
this is the most sane and coherent architecture with the tools
available in netdev.. Mellanox thinks the VDPA world should
standardize on this design so we can have a standard control plane.

> You're saying it's a client application like any other - do I understand
> it right that the hypervisor driver will be translating descriptors
> between virtio and device-native then?

No, the hypervisor creates a QP and tells the HW that this QP's
descriptor format follows virtio-net. The QP processes those
descriptors in HW and generates ethernet packets.

A "client application like any other" means that the ethernet packets
VDPA forms are identical to the ones netdev or RDMA forms. They are
all delivered into the tunnel on the SF/VF to the representor and on
to the switch. See below

> The vdpa parent is in the hypervisor correct?
> 
> Can a VDPA device have multiple children of the same type?

I'm not sure parent/child are good words here.

The VDPA emulation runs in the hypervisor, and the virtio-net netdev
driver runs in the guest. The VDPA is attached to a switchdev port and
representor tunnel by virtue of its QPs being created under a SF/VF.

If we imagine a virtio-rdma, then you might have a SF/VF hosting both
VDPA and VDPA-RDMA which emulate two PCI devices assigned to a
VM. Both of these peer virtio's would generate ethernet packets for TX
on the SF/VF port into the tunnel through the represntor and to the
switch.

> Why do we have a representor for a SF, if the interface is actually VDPA?
> Block and net traffic can't reasonably be treated the same by the
> switch.

I think you are focusing on queues, the architecture at PF/SF/VF is
not queue based, it is packet based.

At the physical mlx5 the netdev has a switchdev. On that switch I can
create a *switch port*.

The switch port is composed of a representor and a SF/VF. They form a
tunnel for packets.

The representor is the hypervisor side of the tunnel and contains all
packets coming out of and into the SF/VF.

The SF/VF is the guest side of the tunnel and has a full NIC.

The SF/VF can be:
 - Used in the same OS as the switch
 - Assigned to a guest VM as a PCI device
 - Assigned to another processor in the SmartNIC case.

In all cases if I use a queue on a SF/VF to generate an ethernet
packet then that packet *always* goes into the tunnel to the
representor and goes into a switch. It is always contained by any
rules on the switch side. If the switch is set so the representor is
VLAN tagged then a queue on a SF/VF *cannot* escape the VLAN tag.

Similarly SF/VF cannot Rx any packets that are not sent into the
tunnel, meaning the switch controls what packets go into the
representor, through the tunnel and to the SF.

Yes, block and net traffic are all reduced to ethernet packets, sent
through the tunnel to the representor and treated by the switch. It is
no different than a physical switch. If there is to be some net/block
difference it has to be represented in the ethernet packets, eg with
vlan or something.

This is the fundamental security boundary of the architecture. The
SF/VF is a security domain and the only exchange of information from
that security domain to the hypervisor security domain is the tunnel
to the representor. The exchange across the boundary is only *packets*
not queues.

Essentially it exactly models the physical world. If I phyically plug
in a NIC to a switch then the "representor" is the switch port in the
physical switch OS and the "SF/VF" is the NIC in the server.

The switch OS does not know or care what the NIC is doing. It does not
know or care if the NIC is doing VDPA, or if the packets are "block"
or "net" - they are all just packets by the time it gets to switching.

> Also I'm confused how block device can bind to mlx5_core - in that case
> I'm assuming the QP is bound 1:1 with a QP on the SmartNIC side, and
> that QP is plugged into an appropriate backend?

Every mlx5_core is a full multi-queue instance. It can have a huge
number of queues with no problems. Do not focus on the
queues. *queues* are irrelevant here.

Queues always have two ends. In this model one end is at the CPU and
the other is just ethernet packets. The purpose of the queue is to
convert CPU stuff into ethernet packets and vice versa. A mlx5 device
has a wide range of accelerators that can do all sorts of
transformations between CPU and packets built into the queues.

A queue can only be attached to a single mlx5_core, meaning all the
ethernet packets the queue sources/sinks must come from the PF/SF/VF
port. For SF/VF this port is connected to a tunnel to a representor to
the switch. Thus every queue has its packet side connected to the
switch.

However, the *queue* is an opaque detail of how the ethernet packets
are created from CPU data.

It doesn't matter if the queue is running VDPA, RDMA, netdev, or block
traffic - all of these things inherently result in ethernet packets,
and the hypervisor can't tell how the packet was created.

The architecture is *not* like virtio. virtio queues are individual
tunnels between hypervisor and guest.

This is the key detail: A VDPA queue is *not a tunnel*. It is a engine
to covert CPU data in virtio-net format to ethernet packets and
deliver those packet to the SF/VF end of the tunnel to the representor
and then to the switch. The tunnel is the SF/VF and representor
pairing, NOT the VDPA queue.

Looking at the logical life of a Tx packet from a VM doing VDPA:
 - VM's netdev builds the skb and writes a vitio-net formed descriptor
   to a send qeuue
 - VM triggers a doorbell via write to a BAR. In mlx5 this write goes
   to the device - qemu mmaps part of the device BAR to the guest
 - The HW begins processing a queue. The queue is in virtio-net format
   so it fetches the descriptor and now has the skb data
 - The HW forms the skb into an ethernet packet and delivers it to the
   representor through the tunnel, which immediately sends it to the
   HW switch. The VDPA QP in the SF/VF is now done.

 - In the switch the HW determines the packet is an exception. It
   applies RSS rules/etc and dynamically identifies on a per-packet
   basis what hypervisor queue the packet should be delivered to.
   This queue is in the hypervisor, and is in mlx5 native format.
 - The choosen hypervisor queue recives this packet and begins
   processing. It gets a receive buffer and writes the packet,
   triggers an interrupts. This queue is now done.

 - hypervisor netdev now has the packet. It does the exception path
   in netdev and puts the SKB back on another queue for TX to the
   physical port. This queue is in mlx5 native format, the packet goes
   to the physical port.

It traversed three queues. The HW dynamically selected the hypervisor
queue the VDPA packet is delivered to based *entirely* on switch
rules. The originating queue only informs the switch of what SF/VF
(and thus switch port) generated the packet.

At no point does the hypervisor know the packet originated from a VDPA
QP.

The RX side the similar, each PF/SF/VF port has a selector that
chooses which queue each packet goes to. That chooses how the packet
is converted to CPU. Each PF/SF/VF can have a huge number of
selectors, and SF/VF source their packets from the logical tunnel
attached to a representor which receives packets from the switch.

The selector is how the cross subsystem sharing of the ethernet port
works, regardless of PF/SF/VF.

Again the hypervisor side has *no idea* what queue the packet will be
selected to when it delivers the packet to the representor side of the
tunnel.

Jason
