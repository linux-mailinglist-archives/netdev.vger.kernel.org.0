Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7ADB41BB8C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 02:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhI2AGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 20:06:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38944 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230137AbhI2AGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 20:06:03 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SM2MUG002952;
        Tue, 28 Sep 2021 17:04:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=WJTO3TcK0v584jczsEBLNAuBWWgb1TzQuPpiAnCeogQ=;
 b=e7XSMPPyK6VKdo21XsRHUrTRRyz+epwfo0LTwvOefaSb2TNI3EoTg12hsMOTKzVT7Vv9
 DrGQz4p3fmJd4Lw8JO2IHN6D+zTsBApWjDDrIbMPFHfFgUf9d7CfqHOJjsFDfwC6+zXN
 ewa7NWcPmWBLgjYtIwxKXkethLRMKjXdb+8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bcbfhrp61-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Sep 2021 17:04:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 28 Sep 2021 17:04:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEKmPBJIlSqcC/V4oKpJgjaCXI5fXBZnAVPNZdzuJ1MXyOIkE6p4Kiejc4fnqg34yp3DQxFoAhpLsYrF3eNWe6Wk+IZZZQ4W4pD8K6K8tM+LZ8MtVe6ahViHX/7CqPDcyr/1mnW0bDOTCOOI/GAeeAIE23sAvk65TWETP9Tv+lxQK7xMEE0L76+sCtUJSPQ+Mp1jXDyu+BdGAy/5fFsoEfjwhiP1uNakGEueg6unPFDJqox07xstnLhtZPFQqjWq/Iy6s/UDn5RzhXDwGOK/bvm56vogMCnzfXwOrRtz81JQrTugoXSHVq4+DQdFOWKhWCTt2cWFHdiYsjrOUX2qIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WJTO3TcK0v584jczsEBLNAuBWWgb1TzQuPpiAnCeogQ=;
 b=EWeUsKML2DIOAI2XRqUYDt+4QVldYETgRQNeZW4l6MbVIvH7DlnJ5DnFYkik3Q7Lz9R8HESdASIwaHJwaoisiykse/QZ+o94wGaexa37zba5u1mxaSynANy9QAid0n9nDr2W99pIpbawk6qyM+OGZzbRXEvc9n8bsrcwf7v4fssTIHVKvHfsTkDXaNCyppvPWV3LJzUve1nONh10flyKy2lGTOUwqRqhaW1vdKsfHpUsNkbof/9R8sjIAT8yByhqvAMg5QXa/hp/HYk3KYaFdJWuEUwY5cWJtcUv9pnVy4pOY5poDIBfLKKuq0LqHWnp7J/OYpCXXnD0FeTitb1eSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 29 Sep
 2021 00:04:21 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 00:04:21 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>, bpf <bpf@vger.kernel.org>
CC:     Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: bpf_get_branch_snapshot on qemu-kvm
Thread-Topic: bpf_get_branch_snapshot on qemu-kvm
Thread-Index: AQHXtMWNnSWPSoCRC0Os2CrN3/HC/g==
Date:   Wed, 29 Sep 2021 00:04:21 +0000
Message-ID: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a47a90da-f5c3-46e3-4a96-08d982dcb060
x-ms-traffictypediagnostic: SA1PR15MB5109:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB5109B43F673537EDB4420EA6B3A99@SA1PR15MB5109.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XkDSr9amZNdGT1ziGCdbYhO8LS2y3BZsrXz6AKWjpKWyPxXxdyomwi2cDu6oTKlW3Dm6Spzs4dzU1I5TaiNIVnyt0vFkXd010OJjtQlnSnddrBQ9bU069SCOgltZ32EZg1EtXsGIYTkCs/tVbthlIgqdVnUHwdfcI7H3d+z03gpdIg8AuWjBdGP9u4hxaFxTTfkCrMmaBTEtBIvcvmnIImtH7z+ivlm3ATMFjtbY61IiZGonkTTldx3+5TM/TfpsPdD1ZgK6v0snTi+SsJOQk+k39nQbLgtv5MrzV5BIthjoXU1PjMhD+zuH3UC5rHbUXDDVRJkVAgjj3E1Ii5WOxvpROXWwYepeE888Q4XOjFZU508JM916yBccgWpt6LYwHGFScQULzYQFLSRQkeRHOTD2suBr72IN/jUj0kROZQ1EdDoF6LU1uLlRCuQ5ruHqx3b8lPDP6h/HSIYUrDsE8U3+llIw8CEem4WTGTLW9zGfiRdZswijEp87Q9gtSJT3JAAudLblgdH2rorr1howWaiLCzS6pGwEijrIElbxQSA1vTMy1ikIwX4cS3rhPlARhmQXwustUgPMji9ReUicqZZMeZHaxrdXoKMiY84t0cAHinhbKeGnYKwk4fOKIFuNgIJsjUD6RSGKEZ46zXu2uskmUGspzesBYyeMXtGl0TG+niaSfIp1Ej5lT50/uy1MQGrsyWsrELh8eqGM23OgdmN0R97A7nquDGSxsGUY6ehvl+OdTIgwNa0WKTb/l+tW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(71200400001)(508600001)(33656002)(2906002)(91956017)(66556008)(66446008)(64756008)(66946007)(36756003)(2616005)(38070700005)(4326008)(8936002)(83380400001)(76116006)(186003)(66476007)(122000001)(8676002)(38100700002)(6486002)(6512007)(5660300002)(316002)(54906003)(110136005)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sUUAg2P+rkoaKM1nk4Xi0kqnfalExWxBOVHwTh6kKsWcrSMdNxzS89ouoz9T?=
 =?us-ascii?Q?Xe8x6lVU0WTvNUgmvxdXUtjj//tW2TvqP1Mdkc72E4SIQwgCo70LVNoWf/PI?=
 =?us-ascii?Q?a00LjRdZzGopmccoZCaZm47/lQXXTci7YAvaoG5Y0biBquqmB5D71Xyr3e7W?=
 =?us-ascii?Q?IFUGGbGEd1PIywaGzAMbRh6q2mArYRD4D9lvWmJzuNVt5IGOtKsBRKTsLvqJ?=
 =?us-ascii?Q?KBEovWkvkgh/TfqUQyDn0zR9la3JXeB0MhiTZOkhxlg4NyHACKBzqEoRYSVE?=
 =?us-ascii?Q?rlFQjFexn2H3Tjjy1Puj8PRt3lcQtMMg500ye2WIWNOZD0Bti+cZ8X7CuFV6?=
 =?us-ascii?Q?X9oQGtYvjSHv4c8tEAKKYmfrzXIXSc/cTDuDvFd9iioYyZBp4x+MuBYTeb3W?=
 =?us-ascii?Q?V8iTCMu9WO8cqa7Wn4i9zJaARU6+7MCzew2Q8Bc2ILqR72AqqlkTx6E4jyMJ?=
 =?us-ascii?Q?FXWw9Df0DtTHJ0p5llD6+ldyDNQlPUudwCcOZcy4Rv6AbnlqMboBNZ+FmS5q?=
 =?us-ascii?Q?w1Bzk4otloIDydVzkY+KE5t+D3fCtKumSIc3saKk1GVXrITNmOuo4dm1xips?=
 =?us-ascii?Q?DvuG2QLgrdxBA8y1xt/GciJPBbVmGpenEgMh6ko+x53njIW339y6UXqcbOex?=
 =?us-ascii?Q?Co+V3tFbsZczpELe5/6E+wHm3xANf2F12VdKLY3XCHZXcolCN41K06y14bjU?=
 =?us-ascii?Q?Nif7R5F/VWjrdC90D4oytQS8Tcudjv0sZ6inv+vtUyfl4yOltoJWDcIv5AZM?=
 =?us-ascii?Q?gFf8MOuaEia+2oVpvEeiafFojcdwOxy1sUZn24R0IMQb7+XOiaPzmWbUURlq?=
 =?us-ascii?Q?Ual0z2aLUH0lejdEG4mo2RHq9lgWr2Rxnbo7lyHbTMdMzk5g8AEaPLb1LVDr?=
 =?us-ascii?Q?dcy6VKsKm1lwjOpAm34BX3NB59G++x1weGIqCPYczPz+jz+zS6xWO5Ms0LLC?=
 =?us-ascii?Q?wfxNLXJV8y9nUsxdX6TLovtUqoikCoUDeYewbMhx1juTx0WI+4Gf8TRs5063?=
 =?us-ascii?Q?/bisWI7tUWlcTr0BKKvECB6bBHAkdynbsdW+4rFPOkFLTwCrMosyRHFDDMYA?=
 =?us-ascii?Q?Y6jlTOEMPimJ5KPWtICVnGTC2MUWWGFSr9W5nTxr7pJW96dCChu6vXcquGQA?=
 =?us-ascii?Q?2HxSh4PhkHXne2et9xHKGZU5kR9ahWoXeb8YSNuJFItAhoiQk9cvVOVCDdxU?=
 =?us-ascii?Q?oX5kObLPQKUT8odYvuHkSJP+dwpyA1f9xJdM78G6Hxu4EVl52Of8LHp50EUn?=
 =?us-ascii?Q?J00IB1+SUBiI+HGfRpXYrdnjbFJz00GAd+CEOe3iPi3fKmtDc9TWhov9/VY7?=
 =?us-ascii?Q?igAORQZ8r5MQ0MBI3vPToIOxD1m7aqUFnvqqOoAlE6o595rzrDHXxXGldu5B?=
 =?us-ascii?Q?posKdLU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9AAECD8393BB7F4F84ED5C4CDBAFFC4C@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a47a90da-f5c3-46e3-4a96-08d982dcb060
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 00:04:21.1151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cJIH32VvO2rx/vzRoX0DYN99RKtRVlBeKed97zm36QqCb6QZjNYF2q1sKTaXAAi4ZcOhu/1b0WrozoUtQWG4eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5109
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: N99sh6d5jz58QJkulqJS2Kc2nsLwx5GF
X-Proofpoint-ORIG-GUID: N99sh6d5jz58QJkulqJS2Kc2nsLwx5GF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_11,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter, 

We have see the warning below while testing the new bpf_get_branch_snapshot 
helper, on a QEMU vm (/usr/bin/qemu-system-x86_64 -enable-kvm -cpu host ...). 
This issue doesn't happen on bare metal systems (no QEMU). 

We didn't cover this case, as LBR didn't really work in QEMU. But it seems to
work after I upgrade the host kernel to 5.12. 

At the moment, we don't have much idea on how to debug and fix the issue. Could 
you please share your thoughts on this? 

Thanks in advance!

Song




============================== 8< ============================

[  139.494159] unchecked MSR access error: WRMSR to 0x3f1 (tried to write 0x0000000000000000) at rIP: 0xffffffff81011a8b (intel_pmu_snapshot_branch_stack+0x3b/0xd0)
[  139.495587] Call Trace:
[  139.495845]  bpf_get_branch_snapshot+0x17/0x40
[  139.496285]  bpf_prog_35810402cd1d294c_test1+0x33/0xe6c
[  139.496791]  bpf_trampoline_10737534536_0+0x4c/0x1000
[  139.497274]  bpf_testmod_loop_test+0x5/0x20 [bpf_testmod]
[  139.497799]  bpf_testmod_test_read+0x71/0x1f0 [bpf_testmod]
[  139.498332]  ? bpf_testmod_loop_test+0x20/0x20 [bpf_testmod]
[  139.498878]  ? sysfs_kf_bin_read+0xbe/0x110
[  139.499284]  ? bpf_testmod_loop_test+0x20/0x20 [bpf_testmod]
[  139.499829]  kernfs_fop_read_iter+0x1ac/0x2c0
[  139.500245]  ? kernfs_create_link+0x110/0x110
[  139.500667]  new_sync_read+0x24b/0x360
[  139.501037]  ? __x64_sys_llseek+0x1e0/0x1e0
[  139.501444]  ? rcu_read_lock_held_common+0x1a/0x50
[  139.501942]  ? rcu_read_lock_held_common+0x1a/0x50
[  139.502404]  ? rcu_read_lock_sched_held+0x5f/0xd0
[  139.502865]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  139.503294]  ? security_file_permission+0xe7/0x2c0
[  139.503758]  vfs_read+0x1a4/0x2a0
[  139.504091]  ksys_read+0xc0/0x160
[  139.504413]  ? vfs_write+0x510/0x510
[  139.504756]  ? ktime_get_coarse_real_ts64+0xe4/0xf0
[  139.505234]  do_syscall_64+0x3a/0x80
[  139.505581]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  139.506066] RIP: 0033:0x7fb8a05728b2
[  139.506413] Code: 97 20 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b6 0f 1f 80 00 00 00 00 f3 0f 1e fa 8b 05 96 db 20 00 85 c0 75 12 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 41 54 49 89 d4 55 48 89
[  139.508164] RSP: 002b:00007ffe66315a28 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  139.508870] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb8a05728b2
[  139.509545] RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000010
[  139.510225] RBP: 00007ffe66315a60 R08: 0000000000000000 R09: 00007ffe66315907
[  139.510897] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000040c8b0
[  139.511570] R13: 00007ffe66315cc0 R14: 0000000000000000 R15: 0000000000000000 
