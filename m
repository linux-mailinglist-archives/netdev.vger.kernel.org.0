Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F199F486D2A
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 23:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245040AbiAFWZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 17:25:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49190 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244638AbiAFWZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 17:25:22 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 206KbmbC008728;
        Thu, 6 Jan 2022 22:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=HQCuZ4dUomIErA9nvcbt2gQysvho0T2Y1gYkmLHPLdU=;
 b=nEUbAZSO/p1B+zSpbnYLo1S6ikJYX32JOxalc7e/lxW7cMTNPVSd89At4Bv0ln7dG4QG
 1qkzoUbyI6ARq75fPJdwlVsB+gfeHYYxUaM6OF/2GXCejQ9nSIlb9fen8aMif+fBOILw
 0cRMsFgOa9oeZdI8sV0DGUwKOTm6pfIt1B1gSRMNd31qobl2S9n/IiFp42Peohl3vUgS
 e86rLXHgx10Kt8HrS75lwC2NwOPw23ZVBUZoYY+ctFYuldttH8M04isjC2gLfdlQp+mY
 C84MFpcdghVp4q75cC3JvdsTWPyc68jB4TKvqtnJP0WkG/U9mUQQ72hkLPfuK47g5FEg YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3de4y7m8y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 22:25:03 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 206M0mvG000731;
        Thu, 6 Jan 2022 22:25:02 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3de4y7m8xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 22:25:02 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 206MNskm028676;
        Thu, 6 Jan 2022 22:25:01 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 3de5k8v0am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 22:25:01 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 206MP1kw23789998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jan 2022 22:25:01 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8F226E05B;
        Thu,  6 Jan 2022 22:25:00 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5ED5E6E054;
        Thu,  6 Jan 2022 22:24:59 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.160.73.209])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with SMTP;
        Thu,  6 Jan 2022 22:24:59 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 33CFA2E128C; Thu,  6 Jan 2022 14:24:56 -0800 (PST)
Date:   Thu, 6 Jan 2022 14:24:56 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        alexandr.lobakin@intel.com, dumazet@google.com,
        brian King <brking@linux.vnet.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        netdev <netdev@vger.kernel.org>, Dany Madden <drt@linux.ibm.com>
Subject: Re: [5.16.0-rc5][ppc][net] kernel oops when hotplug remove of vNIC
 interface
Message-ID: <YddsOKc9DaRg5HTf@us.ibm.com>
References: <63380c22-a163-2664-62be-2cf401065e73@linux.vnet.ibm.com>
 <20220105102625.2738186e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87lezt3398.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87lezt3398.fsf@mpe.ellerman.id.au>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Cxz1C8dGMaytgdrdpEDv4lvbHGNoRt7q
X-Proofpoint-ORIG-GUID: sbIAicQaLACxR57qRAvw2tUc02ctvY0e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_10,2022-01-06_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=1011
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201060136
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael Ellerman [mpe@ellerman.id.au] wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Wed, 5 Jan 2022 13:56:53 +0530 Abdul Haleem wrote:
> >> Greeting's
> >>=20
> >> Mainline kernel 5.16.0-rc5 panics when DLPAR ADD of vNIC device on my=
=20
> >> Powerpc LPAR
> >>=20
> >> Perform below dlpar commands in a loop from linux OS
> >>=20
> >> drmgr -r -c slot -s U9080.HEX.134C488-V1-C3 -w 5 -d 1
> >> drmgr -a -c slot -s U9080.HEX.134C488-V1-C3 -w 5 -d 1
> >>=20
> >> after 7th iteration, the kernel panics with below messages
> >>=20
> >> console messages:
> >> [102056] ibmvnic 30000003 env3: Sending CRQ: 801e000864000000=20
> >> 0060000000000000
> >> <intr> ibmvnic 30000003 env3: Handling CRQ: 809e000800000000=20
> >> 0000000000000000
> >> [102056] ibmvnic 30000003 env3: Disabling tx_scrq[0] irq
> >> [102056] ibmvnic 30000003 env3: Disabling tx_scrq[1] irq
> >> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[0] irq
> >> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[1] irq
> >> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[2] irq
> >> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[3] irq
> >> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[4] irq
> >> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[5] irq
> >> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[6] irq
> >> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[7] irq
> >> [102056] ibmvnic 30000003 env3: Replenished 8 pools
> >> Kernel attempted to read user page (10) - exploit attempt? (uid: 0)
> >> BUG: Kernel NULL pointer dereference on read at 0x00000010
> >> Faulting instruction address: 0xc000000000a3c840
> >> Oops: Kernel access of bad area, sig: 11 [#1]
> >> LE PAGE_SIZE=3D64K MMU=3DRadix SMP NR_CPUS=3D2048 NUMA pSeries
> >> Modules linked in: bridge stp llc ib_core rpadlpar_io rpaphp nfnetlink=
=20
> >> tcp_diag udp_diag inet_diag unix_diag af_packet_diag netlink_diag=20
> >> bonding rfkill ibmvnic sunrpc pseries_rng xts vmx_crypto gf128mul=20
> >> sch_fq_codel binfmt_misc ip_tables ext4 mbcache jbd2 dm_service_time=
=20
> >> sd_mod t10_pi sg ibmvfc scsi_transport_fc ibmveth dm_multipath dm_mirr=
or=20
> >> dm_region_hash dm_log dm_mod fuse
> >> CPU: 9 PID: 102056 Comm: kworker/9:2 Kdump: loaded Not tainted=20
> >> 5.16.0-rc5-autotest-g6441998e2e37 #1
> >> Workqueue: events_long __ibmvnic_reset [ibmvnic]
> >> NIP:=A0 c000000000a3c840 LR: c0080000029b5378 CTR: c000000000a3c820
> >> REGS: c0000000548e37e0 TRAP: 0300=A0=A0 Not tainted=20
> >> (5.16.0-rc5-autotest-g6441998e2e37)
> >> MSR:=A0 8000000000009033 <SF,EE,ME,IR,DR,RI,LE>=A0 CR: 28248484=A0 XER=
: 00000004
> >> CFAR: c0080000029bdd24 DAR: 0000000000000010 DSISR: 40000000 IRQMASK: 0
> >> GPR00: c0080000029b55d0 c0000000548e3a80 c0000000028f0200 000000000000=
0000
> >> GPR04: c000000c7d1a7e00 fffffffffffffff6 0000000000000027 c000000c7d1a=
7e08
> >> GPR08: 0000000000000023 0000000000000000 0000000000000010 c0080000029b=
dd10
> >> GPR12: c000000000a3c820 c000000c7fca6680 0000000000000000 c00000013301=
6bf8
> >> GPR16: 00000000000003fe 0000000000001000 0000000000000002 000000000000=
0008
> >> GPR20: c000000133016eb0 0000000000000000 0000000000000000 000000000000=
0003
> >> GPR24: c000000133016000 c000000133017168 0000000020000000 c00000013301=
6a00
> >> GPR28: 0000000000000006 c000000133016a00 0000000000000001 c00000013301=
6000
> >> NIP [c000000000a3c840] napi_enable+0x20/0xc0
> >> LR [c0080000029b5378] __ibmvnic_open+0xf0/0x430 [ibmvnic]
> >> Call Trace:
> >> [c0000000548e3a80] [0000000000000006] 0x6 (unreliable)
> >> [c0000000548e3ab0] [c0080000029b55d0] __ibmvnic_open+0x348/0x430 [ibmv=
nic]
> >> [c0000000548e3b40] [c0080000029bcc28] __ibmvnic_reset+0x500/0xdf0 [ibm=
vnic]
> >> [c0000000548e3c60] [c000000000176228] process_one_work+0x288/0x570
> >> [c0000000548e3d00] [c000000000176588] worker_thread+0x78/0x660
> >> [c0000000548e3da0] [c0000000001822f0] kthread+0x1c0/0x1d0
> >> [c0000000548e3e10] [c00000000000cf64] ret_from_kernel_thread+0x5c/0x64
> >> Instruction dump:
> >> 7d2948f8 792307e0 4e800020 60000000 3c4c01eb 384239e0 f821ffd1 39430010
> >> 38a0fff6 e92d1100 f9210028 39200000 <e9030010> f9010020 60420000 e9210=
020
> >> ---[ end trace 5f8033b08fd27706 ]---
> >> radix-mmu: Page sizes from device-tree:
> >>=20
> >> the fault instruction points to
> >>=20
> >> [root@ltcden11-lp1 boot]# gdb -batch=20
> >> vmlinuz-5.16.0-rc5-autotest-g6441998e2e37 -ex 'list *(0xc000000000a3c8=
40)'
> >> 0xc000000000a3c840 is in napi_enable (net/core/dev.c:6966).
> >> 6961=A0=A0=A0 void napi_enable(struct napi_struct *n)
> >> 6962=A0=A0=A0 {
> >> 6963=A0=A0=A0 =A0=A0=A0 unsigned long val, new;
> >> 6964
> >> 6965=A0=A0=A0 =A0=A0=A0 do {
> >> 6966=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 val =3D READ_ONCE(n->state);
> >
> > If n is NULL here that's gotta be a driver problem.
>=20
> Definitely looks like it, the disassembly is:
>=20
>   not     r9,r9
>   clrldi  r3,r9,63
>   blr				# end of previous function
>   nop
>   addis   r2,r12,491		# function entry
>   addi    r2,r2,14816
>   stdu    r1,-48(r1)		# stack frame creation
>   li      r5,-10
>   ld      r9,4352(r13)
>   std     r9,40(r1)
>   li      r9,0
>   ld      r8,16(r3)		# load from r3 (n) + 16
>=20
>=20
> The register dump shows that r3 is NULL, and it comes directly from the
> caller. So we've been called with n =3D NULL.

Yeah, Good catch Abdul.

I suspect its due to the release_resources() in __ibmvnic_open(). The
problem is hard to reproduce but we are testing following patch with
error injection. Will formally submit after testing/review.

---
=46rom 8a78083e5ec6914be197352f391bfa17420a147c Mon Sep 17 00:00:00 2001
=46rom: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Date: Wed, 5 Jan 2022 16:22:58 -0500
Subject: [PATCH 1/1] ibmvnic: don't release napi in __ibmvnic_open()

If __ibmvnic_open() encounters an error such as when setting link state,
it calls release_resources() which frees the napi structures needlessly.
Instead, have __ibmvnic_open() only clean up the work it did so far (i.e.
disable napi and irqs) and leave the rest to the callers.

If caller of __ibmvnic_open() is ibmvnic_open(), it should release the
resources immediately. If the caller is do_reset() or do_hard_reset(),
they will release the resources on the next reset.

Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/=
ibmvnic.c
index 0bb3911dd014..34efba6c117b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -110,6 +110,7 @@ static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic=
_adapter *adapter,
 					 struct ibmvnic_sub_crq_queue *tx_scrq);
 static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 				struct ibmvnic_long_term_buff *ltb);
+static void ibmvnic_disable_irqs(struct ibmvnic_adapter *adapter);
=20
 struct ibmvnic_stat {
 	char name[ETH_GSTRING_LEN];
@@ -1418,7 +1419,7 @@ static int __ibmvnic_open(struct net_device *netdev)
 	rc =3D set_link_state(adapter, IBMVNIC_LOGICAL_LNK_UP);
 	if (rc) {
 		ibmvnic_napi_disable(adapter);
-		release_resources(adapter);
+		ibmvnic_disable_irqs(adapter);
 		return rc;
 	}
=20
@@ -1468,9 +1469,6 @@ static int ibmvnic_open(struct net_device *netdev)
 		rc =3D init_resources(adapter);
 		if (rc) {
 			netdev_err(netdev, "failed to initialize resources\n");
-			release_resources(adapter);
-			release_rx_pools(adapter);
-			release_tx_pools(adapter);
 			goto out;
 		}
 	}
@@ -1487,6 +1485,12 @@ static int ibmvnic_open(struct net_device *netdev)
 		adapter->state =3D VNIC_OPEN;
 		rc =3D 0;
 	}
+	if (rc) {
+		release_resources(adapter);
+		release_rx_pools(adapter);
+		release_tx_pools(adapter);
+	}
+
 	return rc;
 }
=20
--=20
2.27.0

>=20
> cheers
