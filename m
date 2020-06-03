Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8491B1ED807
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 23:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgFCV0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 17:26:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48214 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725961AbgFCV0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 17:26:49 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 053L3dJs147762;
        Wed, 3 Jun 2020 17:26:45 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31c541trsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Jun 2020 17:26:45 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 053L9vTm030153;
        Wed, 3 Jun 2020 21:26:45 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 31bf4akh99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Jun 2020 21:26:45 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 053LPili50004328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Jun 2020 21:25:44 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4985BAE05C;
        Wed,  3 Jun 2020 21:25:44 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12344AE067;
        Wed,  3 Jun 2020 21:25:43 +0000 (GMT)
Received: from oc8377887825.ibm.com (unknown [9.163.95.143])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  3 Jun 2020 21:25:42 +0000 (GMT)
From:   David Wilder <dwilder@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, wilder@us.ibm.com,
        mkubecek@suse.com
Subject: [(RFC) PATCH ] NULL pointer dereference on rmmod iptable_mangle.
Date:   Wed,  3 Jun 2020 14:25:16 -0700
Message-Id: <20200603212516.22414-1-dwilder@us.ibm.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-03_13:2020-06-02,2020-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 mlxlogscore=999 cotscore=-2147483648 mlxscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=1 malwarescore=0 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This crash happened on a ppc64le system running ltp network tests when ltp =
script ran "rmmod iptable_mangle".

[213425.602369] BUG: Kernel NULL pointer dereference at 0x00000010
[213425.602388] Faulting instruction address: 0xc008000000550bdc
[213425.602399] Oops: Kernel access of bad area, sig: 11 [#1]
[213425.602409] LE PAGE_SIZE=3D64K MMU=3DHash SMP NR_CPUS=3D2048 NUMA pSeri=
es
[213425.602418] Modules linked in: nf_log_ipv4 nf_log_common iptable_mangle=
(-) iptable_nat nf_nat nf_conntrack iptable_filter ip_tables xt_limit xt_mu=
ltiport xt_LOG xt_tcpudp nf_defrag_ipv6 nf_defrag_ipv4 x_tables sch_netem t=
cp_bbr rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver rds dummy sctp crypto=
_user veth uhid kvm_pr kvm vfio_iommu_spapr_tce vfio_spapr_eeh vfio hci_vhc=
i bluetooth ecdh_generic ecc vhost_net tap vhost_vsock vmw_vsock_virtio_tra=
nsport_common vhost vsock uinput n_gsm pps_ldisc ppp_synctty ppp_async ppp_=
generic slip slhc serport brd tun fuse vfat fat xfs ext4 crc16 mbcache jbd2=
 mlx5_ib ib_uverbs ib_core mlx5_core mlxfw tls loop be2net ibmveth(XX) st s=
r_mod cdrom lp parport_pc parport nvram xfrm_user joydev binfmt_misc rpadlp=
ar_io(XX) rpaphp(XX) xsk_diag tcp_diag udp_diag raw_diag inet_diag unix_dia=
g af_packet_diag netlink_diag nfsv3 nfs_acl nfs lockd grace sunrpc fscache =
af_packet rfkill vmx_crypto gf128mul ibmvnic uio_pdrv_genirq crct10dif_vpms=
um uio rtc_generic btrfs
[213425.602577]  libcrc32c xor raid6_pq dm_service_time sd_mod ibmvfc(XX) s=
csi_transport_fc crc32c_vpmsum dm_mirror dm_region_hash dm_log sg dm_multip=
ath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod [last unloaded: i=
pt_REJECT]
[213425.602659] Supported: No, Unreleased kernel
[213425.602671] CPU: 0 PID: 10 Comm: ksoftirqd/0 Tainted: G               X=
   5.3.18-14-default #1 SLE15-SP2 (unreleased)
[213425.602682] NIP:  c008000000550bdc LR: c008000001de00c8 CTR: c008000000=
550b48
[213425.602692] REGS: c000000002973250 TRAP: 0380   Tainted: G             =
  X    (5.3.18-14-default)
[213425.602701] MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  C=
R: 88082822  XER: 00000001
[213425.602726] CFAR: c008000000551050 IRQMASK: 0
                GPR00: c008000001de00c8 c0000000029734e0 c00800000055d800 c=
00000087b7c3600
                GPR04: c000000002973768 0000000000000000 0000000000000000 c=
0000007ab050800
                GPR08: 000000000000000e c0000007ab050814 c000000001558380 c=
008000001de04e0
                GPR12: c008000000550b48 c0000000021e0000 c00000000016b358 0=
000000000000100
                GPR16: 000000000000008e 00000000000000a0 0000000000000000 0=
000000000000005
                GPR20: 0000000000000000 c000000001168fa8 0000000000000000 c=
0000007ac4b46d4
                GPR24: c000000002973768 c008000000555f80 0000000000000001 c=
0000000011ee000
                GPR28: c0000000011ee000 c00000087b7c3600 c0000007ab05080e c=
000000002973768
[213425.602816] NIP [c008000000550bdc] ipt_do_table+0x94/0x980 [ip_tables]
[213425.602827] LR [c008000001de00c8] iptable_mangle_hook+0x50/0x180 [iptab=
le_mangle]
[213425.602835] Call Trace:
[213425.602843] [c0000000029734e0] [c000000002973570] 0xc000000002973570 (u=
nreliable)
[213425.602856] [c000000002973690] [c008000001de00c8] iptable_mangle_hook+0=
x50/0x180 [iptable_mangle]
[213425.602871] [c0000000029736f0] [c000000000a82b60] nf_hook_slow+0x70/0x1=
40
[213425.602882] [c000000002973740] [c000000000a90cdc] ip_rcv+0xac/0x120
[213425.602894] [c0000000029737c0] [c0000000009d978c] __netif_receive_skb_c=
ore+0x42c/0x1160
[213425.602906] [c0000000029738a0] [c0000000009dab80] __netif_receive_skb_l=
ist_core+0x130/0x330
[213425.602919] [c000000002973940] [c0000000009dafa4] netif_receive_skb_lis=
t_internal+0x224/0x350
[213425.602932] [c0000000029739c0] [c0000000009db2b4] gro_normal_list.part.=
109+0x34/0x60
[213425.602943] [c0000000029739f0] [c0000000009dc0c8] napi_gro_receive+0x1b=
8/0x200
[213425.602957] [c000000002973a30] [c008000000e32368] ibmvnic_poll+0x2d0/0x=
410 [ibmvnic]
[213425.602969] [c000000002973b10] [c0000000009dcebc] net_rx_action+0x1ec/0=
x540
[213425.602982] [c000000002973c30] [c000000000c1ff68] __do_softirq+0x178/0x=
424
[213425.602994] [c000000002973d20] [c00000000013c924] run_ksoftirqd+0x64/0x=
90
[213425.603006] [c000000002973d40] [c0000000001717c0] smpboot_thread_fn+0x2=
70/0x2c0
[213425.603018] [c000000002973db0] [c00000000016b4fc] kthread+0x1ac/0x1c0
[213425.603029] [c000000002973e20] [c00000000000b660] ret_from_kernel_threa=
d+0x5c/0x7c
[213425.603038] Instruction dump:
[213425.603046] e8e300c0 82c40000 e92d1178 f9210118 39200000 2fbc0000 7fc74=
214 419e046c
[213425.603067] eb380010 2fb90000 419e0474 393e0006 <80850010> 38c00000 7d4=
04e2c 39200001
[213425.603089] ---[ end trace f2babb2170f723cc ]---
[213425.690517]

In the crash we find in iptable_mangle_hook() that state->net->ipv4.iptable=
_mangle=3DNULL causing a NULL pointer dereference. net->ipv4.iptable_mangle=
 is set to NULL in iptable_mangle_net_exit() and called when ip_mangle modu=
les is unloaded. A rmmod task was found in the crash dump.  A 2nd crash sho=
wed the same problem when running "rmmod iptable_filter" (net->ipv4.iptable=
_filter=3DNULL).

Once a hook is registered packets will picked up a pointer from: net->ipv4.=
iptable_$table. The patch adds a call to synchronize_net() in ipt_unregiste=
r_table() to insure no packets are in flight that have picked up the pointe=
r before completing the un-register.

This change has has prevented the problem in our testing.  However, we have=
 concerns with this change as it would mean that on netns cleanup, we would=
 need one synchronize_net() call for every table in use. Also, on module un=
load, there would be one synchronize_net() for every existing netns.

Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 net/ipv4/netfilter/ip_tables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c2670ea..97c4121 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1800,8 +1800,10 @@ int ipt_register_table(struct net *net, const struct=
 xt_table *table,
 void ipt_unregister_table(struct net *net, struct xt_table *table,
 			  const struct nf_hook_ops *ops)
 {
-	if (ops)
+	if (ops) {
 		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+		synchronize_net();
+	}
 	__ipt_unregister_table(net, table);
 }
=20
--=20
1.8.3.1

