Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD56029EC20
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 13:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgJ2Mpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 08:45:50 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12523 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ2Mpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 08:45:50 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9ab9830001>; Thu, 29 Oct 2020 05:45:55 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 29 Oct
 2020 12:45:48 +0000
Date:   Thu, 29 Oct 2020 14:45:44 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     wenxu <wenxu@ucloud.cn>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: mlx5_vdpa problem
Message-ID: <20201029124544.GC139728@mtl-vdi-166.wap.labs.mlnx>
References: <401b2eb1-f77b-f7d5-8d6f-03ec30e81d6a@ucloud.cn>
 <258f86a8-d6ae-010a-11f8-c155b1df4723@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <258f86a8-d6ae-010a-11f8-c155b1df4723@ucloud.cn>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603975555; bh=pp6JAol90nQq1bWoKQrbAq99XeF2+anXM6LEA3wUdH8=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=Uex44V18dvDH2nAOE8mTaD1rjFqOFoiS+aU1OPivOVdoHmi+Oo8/6Zv09sj6wYfPf
         vwXly7NfWQPB7QJN23Jtm3hmWCvrrYlU9xsZECiiEwU0qp8eInUb5vAw1KVTohWuKs
         PhYHsLfvX00f8cev/Bt0b6bIS7EUYy1Lz3uB9UIpBjfQdIm4AYbqcIx4NGAmg0uy37
         31Mql3u1XQBdPvlQEVdqyi47FR5NAHLWmd5K1e59TUXhc367tsOGIv1MAHcCDllzIK
         DOTbTYvG7zV5VT2pylPI8j8IesKCfshTUWfKx23plG09Jp8cYq+7GCUUAU5j5ZgWqv
         qIJHkvs5S7EeA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 06:40:56PM +0800, wenxu wrote:

Please make sure your firmware is updated.

https://www.mellanox.com/support/firmware/connectx6dx

>=20
> Hi mellanox team,
>=20
>=20
> I test the mlx5 vdpa=A0 in linux-5.9 and meet several problem.
>=20
>=20
> # lspci | grep Ether | grep Dx
> b3:00.0 Ethernet controller: Mellanox Technologies MT2892 Family [Connect=
X-6 Dx]
> b3:00.1 Ethernet controller: Mellanox Technologies MT2892 Family [Connect=
X-6 Dx]
>=20
> # ethtool -i net2
> driver: mlx5e_rep
> version: 5.9.0
> firmware-version: 22.28.1002 (MT_0000000430)
> expansion-rom-version:
> bus-info: 0000:b3:00.0
> supports-statistics: yes
> supports-test: no
> supports-eeprom-access: no
> supports-register-dump: no
> supports-priv-flags: no
>=20
>=20
> init switchdev:
>=20
>=20
> # echo 1 > /sys/class/net/net2/device/sriov_numvfs
> # echo 0000:b3:00.2 > /sys/bus/pci/drivers/mlx5_core/unbind
> # devlink dev eswitch set pci/0000:b3:00.0=A0 mode switchdev encap enable
>=20
> # modprobe vdpa vhost-vdpa mlx5_vdpa
>=20
> # ip l set dev net2 vf 0 mac 52:90:01:00:02:13
> # echo 0000:b3:00.2 > /sys/bus/pci/drivers/mlx5_core/bind
>=20
>=20
> setup vm:
>=20
> # qemu-system-x86_64 -name test=A0 -enable-kvm -smp 16,sockets=3D2,cores=
=3D8,threads=3D1 -m 8192 -drive file=3D./centos7.qcow2,format=3Dqcow2,if=3D=
none,id=3Ddrive-virtio-disk0 -device virtio-blk-pci,scsi=3Doff,bus=3Dpci.0,=
addr=3D0x7,drive=3Ddrive-virtio-disk0,id=3Dvirtio-disk0,bootindex=3D1 -netd=
ev type=3Dvhost-vdpa,vhostdev=3D/dev/vhost-vdpa-0,id=3Dvhost-vdpa0 -device =
virtio-net-pci,netdev=3Dvhost-vdpa0,page-per-vq=3Don,iommu_platform=3Don,id=
=3Dnet0,bus=3Dpci.0,addr=3D0x3,disable-legacy=3Don -vnc 0.0.0.0:0
>=20
>=20
> In the vm:=A0 virtio net device=A0 eth0 with ip address 10.0.0.75/24
>=20
> On the host: VF0 rep device pf0vf0 with ip address 10.0.0.7/24
>=20
>=20
> problem 1:
>=20
> On the host:
>=20
> # ping 10.0.0.75
>=20
> Some times there will be loss packets.
>=20
> And in the VM:
>=20
> dmesg shows:
>=20
> eth0: bad tso: type 100, size: 0
>=20
> eth0: bad tso: type 10, size: 28
>=20
>=20
> So I think maybe the vnet header is not init with 0?=A0 And Then I clear =
the gso_type, gso_size and flags in the virtio_net driver.=A0 There is no p=
ackets dropped.
>=20
>=20
> problem 2:
>=20
> In the vm: iperf -s
>=20
> On the host: iperf -c 10.0.0.75 -t 100 -i 2.
>=20
>=20
> The tcp connection can't established for the syn+ack with partail cum but=
 not handle correct by hardware.
>=20
> After I set the csum off=A0 for eth0 in the vm, the problem is resolved. =
Although the mlx5_vnet support VIRTIO_NET_F_CSUM feature.
>=20
>=20
>=20
> problem 3:
>=20
>=20
> The iperf perofrmance not stable before I disable the pf0vf0 tso offload
>=20
> #ethtool -K pf0vf0 tso off
>=20
>=20
> I know the mlx5_vnet did not support feature VIRTIO_NET_F_GUEST_TSO4. But=
 the hardware can't=A0 cut the big tso packet to several small tcp packet a=
nd send to virtio=A0 net device?
>=20
>=20
>=20
>=20
> BR
>=20
> wenxu
>=20
>=20
>=20
