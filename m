Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC8812F9D1
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 16:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgACPbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 10:31:17 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35338 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727539AbgACPbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 10:31:16 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 003FN85O004348;
        Fri, 3 Jan 2020 07:31:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=SWYUq1VYM99xnSbkDycUcS+KD+ESDY+p8Xg2UG5fH6k=;
 b=DbmobDMvPNVeGMLitCFe3KvhpxkZ8TeqenaNb4+0uK7XmiTlQvG6JafC4z5B7AlUC8N0
 S+ygns3w+YNXqLHZ14zwJVidoy3C0ekp2LdtqQmSofrs6LzpZvhxAG91xWQ1Rv/V86Tf
 ADacN4pWoGuWJtSOjscjU4uV0LF/s5KT1fc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2x88rbkp1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 03 Jan 2020 07:31:02 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 3 Jan 2020 07:31:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTogr+kZXTj2d1fEqKM2FW3S42UYplzbvfUFTO2AeRM+s+MrvnVro95VIaCEwJ6pTqip6BlMstEez2mEoWFtXF0WyBSKVAhTAAwjZd274RUfkkZ+PBL5uBJ6mPLDc64L7qUZwfzFt4W28cUoTVAIU7vWyAIRJR1Zu29r66588sHtTmGdvBmhaG8sg4NSkQzUGd+LKT545er8Wx7k3ivxjbk6PUNktbF1Z0o5hQ3xIH23snQyC40kwVF+YG1QlcQzIQX5pHstfK6Nd3BQiTziW+fwYnfp6SdlnTl2jPWI+KdmtLRO0MSaXsw9tGVDz0ZrE1InRsQ1DuXBllKblF/i3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWYUq1VYM99xnSbkDycUcS+KD+ESDY+p8Xg2UG5fH6k=;
 b=G2xXjLq+/mbqK17cAnnld41BOqR7od6BGlhGjD5uRqIcvjC3Y/ahrNdv5Xq31K367W7uKiv4bg8Oag4nsKEMOIYv3czOFM+R1vI89a3VAfemBHocCcUv0NzW5ylLtnp+CIP9vuYYPQymYSujgTvsn/n8KwL7LuicKPlT3M2lilGV1OAP4k8jRurpDe3XHKX/bKZfE2cG2j4pl0gcMN2tc8mcLvq7EBRKkTiv7CeiGvSOIp4QmDgmd1cxgVnzZwIimx4ok8+RlTONwT7wCQL4ueQjPIi4Lz4LnBh6gYCyLE4sWj9qi97cPbToO9gVELYWdhYxKyEf7E7UQO3bxaDh5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWYUq1VYM99xnSbkDycUcS+KD+ESDY+p8Xg2UG5fH6k=;
 b=SmoseodtgM4xa9280MTBL+90llOxFvt+3nIR/a9eV/XW0k6XzWCGwsD/GSHuefe6qvVwCpmo4dwb+h2B5DQmJKoH1NBWtJ0rZfI4EqFA9WnHoXFOmyWq6UHXRKOynmQ3/J5R2GrSoxbcfkMHHnOrZdWWCsab0Qq2efkzpauDNe4=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.155.147) by
 BYAPR15MB2392.namprd15.prod.outlook.com (52.135.198.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Fri, 3 Jan 2020 15:30:58 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60%3]) with mapi id 15.20.2581.013; Fri, 3 Jan 2020
 15:30:58 +0000
Received: from localhost.localdomain (2620:10d:c090:180::260a) by MWHPR1601CA0009.namprd16.prod.outlook.com (2603:10b6:300:da::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend Transport; Fri, 3 Jan 2020 15:30:57 +0000
From:   Roman Gushchin <guro@fb.com>
To:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf: cgroup: prevent out-of-order release of cgroup
 bpf
Thread-Topic: [PATCH bpf] bpf: cgroup: prevent out-of-order release of cgroup
 bpf
Thread-Index: AQHVvP+26yjH3drshkGEPJ14gI885qfZG5MA
Date:   Fri, 3 Jan 2020 15:30:58 +0000
Message-ID: <20200103153054.GA3049@localhost.localdomain>
References: <20191227215034.3169624-1-guro@fb.com>
In-Reply-To: <20191227215034.3169624-1-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1601CA0009.namprd16.prod.outlook.com
 (2603:10b6:300:da::19) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:150::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::260a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 861b08d4-e160-45b8-e512-08d79061ee3c
x-ms-traffictypediagnostic: BYAPR15MB2392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB23922B9281AA759219F94BA2BE230@BYAPR15MB2392.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0271483E06
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(396003)(346002)(366004)(39860400002)(189003)(199004)(4326008)(186003)(7696005)(316002)(52116002)(69590400006)(2906002)(6506007)(86362001)(16526019)(9686003)(55016002)(71200400001)(478600001)(33656002)(54906003)(1076003)(8936002)(8676002)(64756008)(66946007)(66476007)(5660300002)(66446008)(66556008)(81156014)(6916009)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2392;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JJhDm/f/KAyN5S3z/U3DcnMwKCH8ndzazgOjriYatmgpPyz30MdBGMiZd+HJNcnQupvBm+aitCfX2SAMzSafZvxdQV1Um7P2zLFk9lwsixB4wPS7l9mB72Lm3DPzm+ki1YnlJEg4zka2TIg3lQa9KbMJ3EEvjW6LgDptlsgEkT4t9HpR5fq24XCearbps/KnAX081tVp+Y7h5Z4ormEijv5S1dYG8KeYNW8RY7tn+l8d5MqAiz5kPSUiqzbaaHej8LHG8Jf8AGvYOTtkDuYaOSJN0qZxJOJoJL1UGYnLa+5OajkylPunzRdQcJugcxd5aBotQquaG3NkcQb3/MKV47DF7EmY9or6QM8oVmGcXLbx4nxjZdCnkRf3w09ryy2bq9xZzPqK5UfFLp0Wf1i+t+SBW5UHQtSLO6DRecwgVZlap4ES0EfCGeasod2SDZd55/WfH4N3W+ts299S0eEC7PVs+ceB6L95Ie6mlqCGpO9AyGY23pu5iPGt+z+/Rpqy
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FDDC3017931758438FCC55598206C4FB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 861b08d4-e160-45b8-e512-08d79061ee3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2020 15:30:58.1768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JLXuc/76hjuVU3nVjros1KJIhhv3NA9qbVuv23X9RMMpOcsJlA49dJ8HLna7yi1+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2392
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-03_04:2020-01-02,2020-01-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 mlxlogscore=474 clxscore=1015 mlxscore=0
 impostorscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001030143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 01:50:34PM -0800, Roman Gushchin wrote:
> Before commit 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf
> from cgroup itself") cgroup bpf structures were released with
> corresponding cgroup structures. It guaranteed the hierarchical order
> of destruction: children were always first. It preserved attached
> programs from being released before their propagated copies.
>=20
> But with cgroup auto-detachment there are no such guarantees anymore:
> cgroup bpf is released as soon as the cgroup is offline and there are
> no live associated sockets. It means that an attached program can be
> detached and released, while its propagated copy is still living
> in the cgroup subtree. This will obviously lead to an use-after-free
> bug.
>=20
> To reproduce the issue the following script can be used:
>=20
>   #!/bin/bash
>=20
>   CGROOT=3D/sys/fs/cgroup
>=20
>   mkdir -p ${CGROOT}/A ${CGROOT}/B ${CGROOT}/A/C
>   sleep 1
>=20
>   ./test_cgrp2_attach ${CGROOT}/A egress &
>   A_PID=3D$!
>   ./test_cgrp2_attach ${CGROOT}/B egress &
>   B_PID=3D$!
>=20
>   echo $$ > ${CGROOT}/A/C/cgroup.procs
>   iperf -s &
>   S_PID=3D$!
>   iperf -c localhost -t 100 &
>   C_PID=3D$!
>=20
>   sleep 1
>=20
>   echo $$ > ${CGROOT}/B/cgroup.procs
>   echo ${S_PID} > ${CGROOT}/B/cgroup.procs
>   echo ${C_PID} > ${CGROOT}/B/cgroup.procs
>=20
>   sleep 1
>=20
>   rmdir ${CGROOT}/A/C
>   rmdir ${CGROOT}/A
>=20
>   sleep 1
>=20
>   kill -9 ${S_PID} ${C_PID} ${A_PID} ${B_PID}
>=20
> test_cgrp2_attach is an example from samples/bpf with the following
> patch applied (required to close cgroup and bpf program file
> descriptors after attachment):
>=20
> diff --git a/samples/bpf/test_cgrp2_attach.c b/samples/bpf/test_cgrp2_att=
ach.c
> index 20fbd1241db3..7c7d0e91204d 100644
> --- a/samples/bpf/test_cgrp2_attach.c
> +++ b/samples/bpf/test_cgrp2_attach.c
> @@ -111,6 +111,8 @@ static int attach_filter(int cg_fd, int type, int ver=
dict)
>                        strerror(errno));
>                 return EXIT_FAILURE;
>         }
> +       close(cg_fd);
> +       close(prog_fd);
>         while (1) {
>                 key =3D MAP_KEY_PACKETS;
>                 assert(bpf_map_lookup_elem(map_fd, &key, &pkt_cnt) =3D=3D=
 0);
>=20
> On the unpatched kernel the following stacktrace can be obtained:
>=20
> [   33.619799] BUG: unable to handle page fault for address: ffffbdb4801a=
b002
> [   33.620677] #PF: supervisor read access in kernel mode
> [   33.621293] #PF: error_code(0x0000) - not-present page
> [   33.621918] PGD 236d59067 P4D 236d59067 PUD 236d5c067 PMD 236d5d067 PT=
E 0
> [   33.622754] Oops: 0000 [#1] SMP NOPTI
> [   33.623202] CPU: 0 PID: 601 Comm: iperf Not tainted 5.5.0-rc2+ #23
> [   33.623943] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S ?-20190727_073836-buildvm-ppc64le-16.ppc.f4
> [   33.625545] RIP: 0010:__cgroup_bpf_run_filter_skb+0x29f/0x3d0
> [   33.626231] Code: f6 0f 84 3a 01 00 00 49 8d 47 30 31 db 48 89 44 24 3=
0 48 8b 45 08 65 48 89 05 4d 9d e0 64 48 8b d
> [   33.628431] RSP: 0018:ffffbdb4802ffa90 EFLAGS: 00010246
> [   33.629051] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000=
0000034
> [   33.629906] RDX: 0000000000000000 RSI: ffff9ddf9d7a0000 RDI: ffff9ddf9=
b97f1c0
> [   33.630761] RBP: ffff9ddf9d4899d0 R08: ffff9ddfb67ddd80 R09: 000000000=
0010000
> [   33.631616] R10: 0000000000000070 R11: ffffbdb4802ffde8 R12: ffff9ddf9=
ba858e0
> [   33.632463] R13: 0000000000000001 R14: ffffbdb4801ab000 R15: ffff9ddf9=
ba858e0
> [   33.633306] FS:  00007f9d15ed9700(0000) GS:ffff9ddfb7c00000(0000) knlG=
S:0000000000000000
> [   33.634262] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   33.634945] CR2: ffffbdb4801ab002 CR3: 000000021b94e000 CR4: 000000000=
03406f0
> [   33.635809] Call Trace:
> [   33.636118]  ? __cgroup_bpf_run_filter_skb+0x2bf/0x3d0
> [   33.636728]  ? __switch_to_asm+0x40/0x70
> [   33.637196]  ip_finish_output+0x68/0xa0
> [   33.637654]  ip_output+0x76/0xf0
> [   33.638046]  ? __ip_finish_output+0x1c0/0x1c0
> [   33.638576]  __ip_queue_xmit+0x157/0x410
> [   33.639049]  __tcp_transmit_skb+0x535/0xaf0
> [   33.639557]  tcp_write_xmit+0x378/0x1190
> [   33.640049]  ? _copy_from_iter_full+0x8d/0x260
> [   33.640592]  tcp_sendmsg_locked+0x2a2/0xdc0
> [   33.641098]  ? sock_has_perm+0x10/0xa0
> [   33.641574]  tcp_sendmsg+0x28/0x40
> [   33.641985]  sock_sendmsg+0x57/0x60
> [   33.642411]  sock_write_iter+0x97/0x100
> [   33.642876]  new_sync_write+0x1b6/0x1d0
> [   33.643339]  vfs_write+0xb6/0x1a0
> [   33.643752]  ksys_write+0xa7/0xe0
> [   33.644156]  do_syscall_64+0x5b/0x1b0
> [   33.644605]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> Fix this by grabbing a reference to the bpf structure of each ancestor
> on the initialization of the cgroup bpf structure, and dropping the
> reference at the end of releasing the cgroup bpf structure.
>=20
> This will restore the hierarchical order of cgroup bpf releasing,
> without adding any operations on hot paths.
>=20
> Thanks to Josef Bacik for the debugging and the initial analysis of
> the problem.
>=20
> Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgrou=
p itself")
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: stable@vger.kernel.org

A friendly ping!

Thanks!
