Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E430E3A1B26
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 18:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhFIQmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 12:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhFIQmc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 12:42:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA804613C0;
        Wed,  9 Jun 2021 16:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623256837;
        bh=mfgXdSVMRVCr8NhA1D03akzv4Aksz82oGg+tElKS19U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LW0DeYwvgzPZwjNiOxRHuHdhkW7TKYm3jXEbqgpod1pFap5rpdILcKCDUnrwM/lgm
         k030JGeJrtJnye06nSCJjxbPRuHkb2hRcS4v5ogTSK3U2xZI5EtyFYWJvP6vsdw8+w
         LArkjE65v6EP/ntf51TZTwzfhYZFOPhl8NSeeLo69AgKtWVGP+sBrg5wxQnczb+LLT
         1Epo61I0NmCl/vEj/PoQ0Ek4uutBvXTU8PczeQLqkCcM5x3t8Ly/bXnT7Va/fsT3qM
         FeJusSbObRQ8fGOu2ks9jS5ok0ztHK2t5PGTLAVzhqrQP/jcjmuxnCsZPdkdRH94Wn
         UkGcrtJqs9nRw==
Date:   Wed, 9 Jun 2021 09:40:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     moyufeng <moyufeng@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Parav Pandit <parav@mellanox.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        <shenjian15@huawei.com>, "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: Re: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Message-ID: <20210609094036.7557bd83@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <2acd8373-b3dc-4920-1cbe-2b5ae29acb5b@huawei.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
        <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
        <20210531223711.19359b9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <7c591bad-75ed-75bc-5dac-e26bdde6e615@huawei.com>
        <20210601143451.4b042a94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <cf961f69-c559-eaf0-e168-b014779a1519@huawei.com>
        <20210602093440.15dc5713@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <857e7a19-1559-b929-fd15-05e8f38e9d45@huawei.com>
        <20210603105311.27bb0c4d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <c9afecb5-3c0e-6421-ea58-b041d8173636@huawei.com>
        <20210604114109.3a7ada85@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <4e7a41ed-3f4d-d55d-8302-df3bc42dedd4@huawei.com>
        <20210607124643.1bb1c6a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <530ff54c-3cee-0eb6-30b0-b607826f68cf@huawei.com>
        <20210608102945.3edff79a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <2acd8373-b3dc-4920-1cbe-2b5ae29acb5b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Jun 2021 17:16:06 +0800 Yunsheng Lin wrote:
> On 2021/6/9 1:29, Jakub Kicinski wrote:
> > On Tue, 8 Jun 2021 20:10:37 +0800 Yunsheng Lin wrote: =20
> >> Afer discussion with Parav in other thread, I undersood it was the cur=
rent
> >> practice, but I am not sure I understand why it is current *best* prac=
tice.
> >>
> >> If we allow all PF of a ASCI to register to the same devlink instance,=
 does
> >> it not make sense that all VF under one PF also register to the same d=
evlink
> >> instance that it's PF is registering to when they are in the same host?
> >>
> >> For eswitch legacy mode, whether VF and PF are the same host or not, t=
he VF
> >> can also provide the serial number of a ASIC to register to the devlin=
k instance,
> >> if that devlink instance does not exist yet, just create that devlink =
instance
> >> according to the serial number, just like PF does.
> >>
> >> For eswitch DEVLINK_ESWITCH_MODE_SWITCHDEV mode, the flavour type for =
devlink
> >> port instance representing the netdev of VF function is FLAVOUR_VIRTUA=
L, the
> >> flavour type for devlink port instance representing the representor ne=
tdev of
> >> VF is FLAVOUR_PCI_VF, which are different type, so they can register t=
o the same
> >> devlink instance even when both of the devlink port instance is in the=
 same host?
> >>
> >> Is there any reason why VF use its own devlink instance? =20
> >=20
> > Primary use case for VFs is virtual environments where guest isn't
> > trusted, so tying the VF to the main devlink instance, over which guest
> > should have no control is counter productive. =20
>=20
> The security is mainly about VF using in container case, right?
> Because VF using in VM, it is different host, it means a different devlink
> instance for VF, so there is no security issue for VF using in VM case?
> But it might not be the case for VF using in container?

How do you differentiate from the device perspective VF being assigned
to the host vs VM? Presumably PFs and VFs have a similar API to talk to
the FW, if VF can "join" the devlink instance of the PF that'd suggest
to me it has access to privileged FW commands.

> Also I read about the devlink disscusion betwwen you and jiri in [1]:
> "I think we agree that all objects of an ASIC should be under one
> devlink instance, the question remains whether both ends of the pipe
> for PCI devices (subdevs or not) should appear under ports or does the
> "far end" (from ASICs perspective)/"host end" get its own category."
>=20
> I am not sure if there is already any conclusion about the latter part
> (I did not find the conclusion in that thread)?
>=20
> "far end" (from ASICs perspective)/"host end" means PF/VF, right?
> Which seems to correspond to port flavor of FLAVOUR_PHYSICAL and
> FLAVOUR_VIRTUAL if we try to represent PF/VF using devlink port
> instance?

No, no, PHYSICAL is a physical port on the adapter, like an SFP port.
There wasn't any conclusion to that discussion. Mellanox views devlink
ports as eswitch ports, I view them as device ports which is hard to
reconcile.

> It seems the conclusion is very important to our disscusion in this
> thread, as we are trying to represent PF/VF as devlink port instance
> in this thread(at least that is what I think, hns3 does not support
> eswitch SWITCHDEV mode yet).
>=20
> Also, there is a "switch_id" concept from jiri's example, which seems
> to be not implemented yet?
> pci/0000:05:00.0/10000: type eth netdev enp5s0npf0s0 flavour pci_pf pf 0 =
subport 0 switch_id 00154d130d2f
>=20
> 1. https://lore.kernel.org/netdev/20190304164007.7cef8af9@cakuba.netronom=
e.com/t/
>=20
> >> I am not sure I understand what does it mean by "devlink instances with
> >> multiple names"?
> >>
> >> Does that mean whenever a devlink port instance is registered to a dev=
link
> >> instance, that devlink instance get a new name according to the PCI de=
vice
> >> which the just registered devlink port instance corresponds to? =20
> >=20
> > Not devlink port, new PCI device. Multiple ports may reside on the same
> > PCI function, some ports don't have a function (e.g. Ethernet ports). =
=20
>=20
> Multiple ports on the same mainly PCI function means subfunction from mlx,
> right?

Not necessarily, there are older devices out there (older NFPs, mlx4)
which have one PF which is logically divided by the driver to service
multiple ports.

> =E2=80=9Csome ports don't have a function (e.g. Ethernet ports)=E2=80=9D =
does not seem
> exist yet? For now devlink port instance of FLAVOUR_PHYSICAL represents
> both PF and Ethernet ports?

It does. I think Mellanox cards are incapable of divorcing PFs from
Ethernet ports, but the NFP driver represents the Ethernet port/SFP=20
as one netdev and devlink port (PHYSICAL) and the host port by another
netdev and devlink port (PCI_PF). Which allows forwarding frames between
PFs and between Ethernet ports directly (again, something not supported
efficiently by simpler cards, but supported by NFPs).
