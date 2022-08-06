Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484DA58B341
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 03:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241577AbiHFBoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 21:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237456AbiHFBoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 21:44:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D726011471;
        Fri,  5 Aug 2022 18:44:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7239761593;
        Sat,  6 Aug 2022 01:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482DFC433C1;
        Sat,  6 Aug 2022 01:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659750240;
        bh=EO4KPee/02ngsNQxKe+YCPGH0iJnUb6OQ3jJ/XW6sfY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RV1o3wX9SMUkkd1GFeWnhNfV2wFsw1bRxyoxZ1P0cXBLgm8Cmqk8vZ3gHqtuUxJ+n
         aY0Clc5/SeDmfmFz6k77MAd+Ibkbf5Z+m/IwpthYKDWpCAilsz2fnpY8Z9aqpAssW0
         gcNZTqMtbacFNZdn5/7IUnuOtALjEGbWCjBCQxxyx/90e10G5ip2P8rQG0xxzicNwu
         +FsC86frj94Bx6YeeuBAStrkLTyafovOeGtq+uzvEzc6xsgv2+IKzyGP0GUvzPFOzf
         GwBpTzt4SC4t2BlkaiAPS8Yvm5pFZCRqPXUbt30eM8qW4Y4oV/KyxThq+Qv4O4UrfT
         Qkd4FOeFN6V8g==
Date:   Fri, 5 Aug 2022 18:43:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <ecree@xilinx.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>, <corbet@lwn.net>,
        <linux-doc@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>,
        <linux-net-drivers@amd.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [RFC PATCH net-next] docs: net: add an explanation of VF (and
 other) Representors
Message-ID: <20220805184359.5c55ca0d@kernel.org>
In-Reply-To: <20220805165850.50160-1-ecree@xilinx.com>
References: <20220805165850.50160-1-ecree@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Aug 2022 17:58:50 +0100 ecree@xilinx.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
>=20
> There's no clear explanation of what VF Representors are for, their
>  semantics, etc., outside of vendor docs and random conference slides.
> Add a document explaining Representors and defining what drivers that
>  implement them are expected to do.
>=20
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
> This documents representors as I understand them, but I suspect others
>  (including other vendors) might disagree (particularly with the "what
>  functions should have a rep" section).  I'm hoping that through review
>  of this doc we can converge on a consensus.

Thanks for doing this, we need to CC people tho. Otherwise they won't
pay attention. (adding semi-non-exhaustively those I have in my address
book)

> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +Network Function Representors
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +
> +This document describes the semantics and usage of representor netdevice=
s, as
> +used to control internal switching on SmartNICs.  For the closely-relate=
d port
> +representors on physical (multi-port) switches, see
> +:ref:`Documentation/networking/switchdev.rst <switchdev>`.
> +
> +Motivation
> +----------
> +
> +Since the mid-2010s, network cards have started offering more complex
> +virtualisation capabilities than the legacy SR-IOV approach (with its si=
mple
> +MAC/VLAN-based switching model) can support.  This led to a desire to of=
fload
> +software-defined networks (such as OpenVSwitch) to these NICs to specify=
 the
> +network connectivity of each function.  The resulting designs are variou=
sly
> +called SmartNICs or DPUs.
> +
> +Network function representors provide the mechanism by which network fun=
ctions
> +on an internal switch are managed. They are used both to configure the
> +corresponding function ('representee') and to handle slow-path traffic t=
o and
> +from the representee for which no fast-path switching rule is matched.

I think we should just describe how those netdevs bring SR-IOV
forwarding into Linux networking stack. This section reads too much
like it's a hack rather than an obvious choice. Perhaps:

The representors bring the standard Linux networking stack to IOV
functions. Same as each port of a Linux-controlled switch has a
separate netdev, each virtual function has one. When system boots=20
and before any offload is configured all packets from the virtual
functions appear in the networking stack of the PF via the representors.
PF can thus always communicate freely with the virtual functions.=20
PF can configure standard Linux forwarding between representors,=20
the uplink or any other netdev (routing, bridging, TC classifiers).

> +That is, a representor is both a control plane object (representing the =
function
> +in administrative commands) and a data plane object (one end of a virtua=
l pipe).
> +As a virtual link endpoint, the representor can be configured like any o=
ther
> +netdevice; in some cases (e.g. link state) the representee will follow t=
he
> +representor's configuration, while in others there are separate APIs to
> +configure the representee.
> +
> +What does a representor do?
> +---------------------------
> +
> +A representor has three main r=C3=B4les.
> +
> +1. It is used to configure the representee's virtual MAC, e.g. link up/d=
own,
> +   MTU, etc.  For instance, bringing the representor administratively UP=
 should
> +   cause the representee to see a link up / carrier on event.

I presume you're trying to start a discussion here, rather than stating
the existing behavior. Or the "virtual MAC" means something else than I
think it means?

> +2. It provides the slow path for traffic which does not hit any offloaded
> +   fast-path rules in the virtual switch.  Packets transmitted on the
> +   representor netdevice should be delivered to the representee; packets
> +   transmitted to the representee which fail to match any switching rule=
 should
> +   be received on the representor netdevice.  (That is, there is a virtu=
al pipe
> +   connecting the representor to the representee, similar in concept to =
a veth
> +   pair.)
> +
> +   This allows software switch implementations (such as OpenVSwitch or a=
 Linux
> +   bridge) to forward packets between representees and the rest of the n=
etwork.
> +3. It acts as a handle by which switching rules (such as TC filters) can=
 refer
> +   to the representee, allowing these rules to be offloaded.
> +
> +The combination of 2) and 3) means that the behaviour (apart from perfor=
mance)
> +should be the same whether a TC filter is offloaded or not.  E.g. a TC r=
ule
> +on a VF representor applies in software to packets received on that repr=
esentor
> +netdevice, while in hardware offload it would apply to packets transmitt=
ed by
> +the representee VF.  Conversely, a mirred egress redirect to a VF repres=
entor
> +corresponds in hardware to delivery directly to the representee VF.
> +
> +What functions should have a representor?
> +-----------------------------------------
> +
> +Essentially, for each virtual port on the device's internal switch, there
> +should be a representor.
> +The only exceptions are the management PF (whose port is used for traffi=
c to
> +and from all other representors)=20

AFAIK there's no "management PF" in the Linux model.

> and perhaps the physical network port (for
> +which the management PF may act as a kind of port representor.  Devices =
that
> +combine multiple physical ports and SR-IOV capability may need to have p=
ort
> +representors in addition to PF/VF representors).

That doesn't generalize well. If we just say that all uplinks and PFs
should have a repr we don't have to make exceptions for all the cases
where that's the case.

> +Thus, the following should all have representors:
> +
> + - VFs belonging to the management PF.

management PF -> /dev/null

> + - Other PFs on the PCIe controller, and any VFs belonging to them.

What is "the PCIe controller" here? I presume you've seen the
devlink-port doc.

> + - PFs and VFs on other PCIe controllers on the device (e.g. for any emb=
edded
> +   System-on-Chip within the SmartNIC).
> + - PFs and VFs with other personalities, including network block devices=
 (such
> +   as a vDPA virtio-blk PF backed by remote/distributed storage).

IDK how you can configure block forwarding (which is DMAs of command
+ data blocks, not packets AFAIU) with the networking concepts..
I've not used the storage functions tho, so I could be wrong.

> + - Subfunctions (SFs) belonging to any of the above PFs or VFs, if they =
have
> +   their own port on the switch (as opposed to using their parent PF's p=
ort).
> + - Any accelerators or plugins on the device whose interface to the netw=
ork is
> +   through a virtual switch port, even if they do not have a correspondi=
ng PCIe
> +   PF or VF.
> +
> +This allows the entire switching behaviour of the NIC to be controlled t=
hrough
> +representor TC rules.
> +
> +An example of a PCIe function that should *not* have a representor is, o=
n an
> +FPGA-based NIC, a PF which is only used to deploy a new bitstream to the=
 FPGA,
> +and which cannot create RX and TX queues.

What's the thinking here? We're letting everyone add their own
exceptions to the doc?

>  Since such a PF does not have network
> +access through the internal switch, not even indirectly via a distributed
> +storage endpoint, there is no switch virtual port for the representor to
> +configure or to be the other end of the virtual pipe.

Does it have a netdev?

> +How are representors created?
> +-----------------------------
> +
> +The driver instance attached to the management PF should enumerate the v=
irtual
> +ports on the switch, and for each representee, create a pure-software ne=
tdevice
> +which has some form of in-kernel reference to the PF's own netdevice or =
driver
> +private data (``netdev_priv()``).
> +If switch ports can dynamically appear/disappear, the PF driver should c=
reate
> +and destroy representors appropriately.
> +The operations of the representor netdevice will generally involve acting
> +through the management PF.  For example, ``ndo_start_xmit()`` might send=
 the
> +packet, specially marked for delivery to the representee, through a TX q=
ueue
> +attached to the management PF.

IDK how common that is, RDMA NICs will likely do the "dedicated queue
per repr" thing since they pretend to have infinite queues.

> +How are representors identified?
> +--------------------------------
> +
> +The representor netdevice should *not* directly refer to a PCIe device (=
e.g.
> +through ``net_dev->dev.parent`` / ``SET_NETDEV_DEV()``), either of the
> +representee or of the management PF.

Do we know how many existing ones do?=20

> +Instead, it should implement the ``ndo_get_port_parent_id()`` and
> +``ndo_get_phys_port_name()`` netdevice ops (corresponding to the
> +``phys_switch_id`` and ``phys_port_name`` sysfs nodes).
> +``ndo_get_port_parent_id()`` should return a string identical to that re=
turned
> +by the management PF's ``ndo_get_phys_port_id()`` (typically the MAC add=
ress of
> +the physical port), while ``ndo_get_phys_port_name()`` should return a s=
tring
> +describing the representee's relation to the management PF.
> +
> +For instance, if the management PF has a ``phys_port_name`` of ``p0`` (p=
hysical
> +port 0), then the representor for the third VF on the second PF should t=
ypically
> +be ``p0pf1vf2`` (i.e. "port 0, PF 1, VF 2").  More generally, the
> +``phys_port_name`` for a PCIe function should be the concatenation of on=
e or
> +more of:
> +
> + - ``p<N>``, physical port number *N*.
> + - ``if<N>``, PCIe controller number *N*.  The semantics of these number=
s are
> +   vendor-defined, and controller 0 need not correspond to the controlle=
r on
> +   which the management PF resides.

/me checks in horror if this is already upstream

> + - ``pf<N>``, PCIe physical function index *N*.
> + - ``vf<N>``, PCIe virtual function index *N*.
> + - ``sf<N>``, Subfunction index *N*.

Yeah, nah... implement devlink port, please. This is done by the core,
you shouldn't have to document this.

> +It is expected that userland will use this information (e.g. through ude=
v rules)
> +to construct an appropriately informative name or alias for the netdevic=
e.  For
> +instance if the management PF is ``eth4`` then our representor with a
> +``phys_port_name`` of ``p0pf1vf2`` might be renamed ``eth4pf1vf2rep``.
> +
> +There are as yet no established conventions for naming representors whic=
h do not
> +correspond to PCIe functions (e.g. accelerators and plugins).
> +
> +How do representors interact with TC rules?
> +-------------------------------------------
> +
> +Any TC rule on a representor applies (in software TC) to packets receive=
d by
> +that representor netdevice.  Thus, if the delivery part of the rule corr=
esponds
> +to another port on the virtual switch, the driver may choose to offload =
it to
> +hardware, applying it to packets transmitted by the representee.
> +
> +Similarly, since a TC mirred egress action targeting the representor wou=
ld (in
> +software) send the packet through the representor (and thus indirectly d=
eliver
> +it to the representee), hardware offload should interpret this as delive=
ry to
> +the representee.
> +
> +As a simple example, if ``eth0`` is the management PF's netdevice and ``=
eth1``
> +is a VF representor, the following rules::
> +
> +    tc filter add dev eth1 parent ffff: protocol ipv4 flower \
> +        action mirred egress redirect dev eth0
> +    tc filter add dev eth0 parent ffff: protocol ipv4 flower \
> +        action mirred egress mirror dev eth1
> +
> +would mean that all IPv4 packets from the VF are sent out the physical p=
ort, and
> +all IPv4 packets received on the physical port are delivered to the VF in
> +addition to the management PF.
> +
> +Of course the rules can (if supported by the NIC) include packet-modifyi=
ng
> +actions (e.g. VLAN push/pop), which should be performed by the virtual s=
witch.
> +
> +Tunnel encapsulation and decapsulation are rather more complicated, as t=
hey
> +involve a third netdevice (a tunnel netdev operating in metadata mode, s=
uch as
> +a VxLAN device created with ``ip link add vxlan0 type vxlan external``) =
and
> +require an IP address to be bound to the underlay device (e.g. managemen=
t PF or
> +port representor).  TC rules such as::
> +
> +    tc filter add dev eth1 parent ffff: flower \
> +        action tunnel_key set id $VNI src_ip $LOCAL_IP dst_ip $REMOTE_IP=
 \
> +                              dst_port 4789 \
> +        action mirred egress redirect dev vxlan0
> +    tc filter add dev vxlan0 parent ffff: flower enc_src_ip $REMOTE_IP \
> +        enc_dst_ip $LOCAL_IP enc_key_id $VNI enc_dst_port 4789 \
> +        action tunnel_key unset action mirred egress redirect dev eth1
> +
> +where ``LOCAL_IP`` is an IP address bound to ``eth0``, and ``REMOTE_IP``=
 is
> +another IP address on the same subnet, mean that packets sent by the VF =
should
> +be VxLAN encapsulated and sent out the physical port (the driver has to =
deduce
> +this by a route lookup of ``LOCAL_IP`` leading to ``eth0``, and also per=
form an
> +ARP/neighbour table lookup to find the MAC addresses to use in the outer
> +Ethernet frame), while UDP packets received on the physical port with UD=
P port
> +4789 should be parsed as VxLAN and, if their VSID matches ``$VNI``, deca=
psulated
> +and forwarded to the VF.
> +
> +If this all seems complicated, just remember the 'golden rule' of TC off=
load:
> +the hardware should ensure the same final results as if the packets were
> +processed through the slow path, traversed software TC and were transmit=
ted or
> +received through the representor netdevices.
> +
> +Configuring the representee's MAC
> +---------------------------------
> +
> +The representee's link state is controlled through the representor.  Set=
ting the
> +representor administratively UP or DOWN should cause carrier ON or OFF a=
t the
> +representee.
> +
> +Setting an MTU on the representor should cause that same MTU to be repor=
ted to
> +the representee.
> +(On hardware that allows configuring separate and distinct MTU and MRU v=
alues,
> +the representor MTU should correspond to the representee's MRU and vice-=
versa.)

Why worry about that?

> +Currently there is no way to use the representor to set the station perm=
anent
> +MAC address of the representee; other methods available to do this inclu=
de:
> +
> + - legacy SR-IOV (``ip link set DEVICE vf NUM mac LLADDR``)
> + - devlink port function (see **devlink-port(8)** and
> +   :ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port=
>`)
> diff --git a/Documentation/networking/switchdev.rst b/Documentation/netwo=
rking/switchdev.rst
> index f1f4e6a85a29..21e80c8e661b 100644
> --- a/Documentation/networking/switchdev.rst
> +++ b/Documentation/networking/switchdev.rst
> @@ -1,5 +1,6 @@
>  .. SPDX-License-Identifier: GPL-2.0
>  .. include:: <isonum.txt>
> +.. _switchdev:
> =20
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  Ethernet switch device driver model (switchdev)

