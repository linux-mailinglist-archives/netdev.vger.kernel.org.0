Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F0F2A088
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404318AbfEXVlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:41:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48918 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404277AbfEXVlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 17:41:03 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4OLbehw010636;
        Fri, 24 May 2019 14:40:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=833M6gQ2Lc6X7v1EvYyqYf2ze/A0atFyhkbjTieKZoY=;
 b=AK5XWV5G4EOoxW13QnMyCxFvplkw89yIBF8aaWwGNHUkB/h/YN/r3hqiU5seg7efJCvJ
 eNNLoxohr6OGJDwjdpsziYsBkDKIwuKsGXEek9C14sq9b48iEUQjCTo+mpgbQHjVrFBO
 3tKMVGTPPlchFfdrifvYlY1iY/8vqqCZWs8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2spk3u9841-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 May 2019 14:40:43 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 24 May 2019 14:40:41 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 24 May 2019 14:40:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=833M6gQ2Lc6X7v1EvYyqYf2ze/A0atFyhkbjTieKZoY=;
 b=qSIuk9ZG7+33t1+eALaCAnwb3/BeLYrYju9ZRKg6Ep9PrY+XHSI3gYgPgWyK9xhWZ9qv399AUOiopPgPr7C56vlb2LFzOr5uzWvbREfEpOFvC0aFmygiHf5Jhuewcbz2b9wOW4sfJh4kTPYElFoQNN4j4igSAXM4hNEGF9PzS8U=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB2839.namprd15.prod.outlook.com (20.178.206.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Fri, 24 May 2019 21:40:39 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a%7]) with mapi id 15.20.1922.018; Fri, 24 May 2019
 21:40:39 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "Yonghong Song" <yhs@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 0/4] cgroup bpf auto-detachment
Thread-Topic: [PATCH v3 bpf-next 0/4] cgroup bpf auto-detachment
Thread-Index: AQHVEaBBRG5VueSSb0OqGPP4SAddC6Z6xP6AgAAKYwA=
Date:   Fri, 24 May 2019 21:40:39 +0000
Message-ID: <20190524214032.GA15067@castle>
References: <20190523194532.2376233-1-guro@fb.com>
 <20190524210321.tzpt7ilaasaagtou@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190524210321.tzpt7ilaasaagtou@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0026.namprd22.prod.outlook.com
 (2603:10b6:300:69::12) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::b702]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 550932dd-bd39-4835-1407-08d6e09076be
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2839;
x-ms-traffictypediagnostic: BYAPR15MB2839:
x-microsoft-antispam-prvs: <BYAPR15MB2839EB58CB8CCD4523441649BE020@BYAPR15MB2839.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(346002)(136003)(376002)(39860400002)(366004)(199004)(189003)(46003)(6916009)(11346002)(14454004)(5660300002)(76176011)(446003)(102836004)(33656002)(486006)(478600001)(386003)(68736007)(33716001)(25786009)(6506007)(66556008)(66476007)(66446008)(66946007)(64756008)(305945005)(9686003)(6512007)(1076003)(73956011)(6486002)(229853002)(256004)(14444005)(5024004)(186003)(71200400001)(316002)(71190400001)(8676002)(7736002)(53936002)(6246003)(476003)(2906002)(6436002)(4326008)(81156014)(81166006)(99286004)(8936002)(52116002)(86362001)(6116002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2839;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RGlk/k4wjY1EuEZijMOvBg4nfI9BvBJ2rhQO0ySL7lxqMRIwRKmJZudDQQ4HaQXSm5dUKYKQH2sDGnDdltyysb4Hs6fAC+PctQQlNhyvfdfqaSyfbIi/GngKRBQJnEqiIbBirVfvNEPsAMWoDlNu3dwiRsvAGCfZVOnAawyidP4pA/OSDYwbBmS/AQPcdFaPBa2uYNYWCSjorwLxLvte5FVD6XIVtPtmC13NKy+E0tU885ibgUpuMmD9VvApKn6m3VKT3oRf+X/Q9XNJ9P1LZ+MKOVUWOyaato+vL+qEN1yGZE+pPkyN1P4uX7Z/NqRg1cMQeuRUESOc20j8F8J+Qu2VpFgxwT9t9x3m5W5KjIl0k06ntUMLIeR+WTl6mo7USJn69dsOaXnFYi3QbHLVwPSkFGXQCm1A18Pn5EiDodU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4B9034D8D4595A4EAB3AEF55618767B8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 550932dd-bd39-4835-1407-08d6e09076be
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 21:40:39.4543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2839
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905240141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 02:03:23PM -0700, Alexei Starovoitov wrote:
> On Thu, May 23, 2019 at 12:45:28PM -0700, Roman Gushchin wrote:
> > This patchset implements a cgroup bpf auto-detachment functionality:
> > bpf programs are detached as soon as possible after removal of the
> > cgroup, without waiting for the release of all associated resources.
>=20
> The idea looks great, but doesn't quite work:
>=20
> $ ./test_cgroup_attach
> #override:PASS
> [   66.475219] BUG: sleeping function called from invalid context at ../i=
nclude/linux/percpu-rwsem.h:34
> [   66.476095] in_atomic(): 1, irqs_disabled(): 0, pid: 21, name: ksoftir=
qd/2
> [   66.476706] CPU: 2 PID: 21 Comm: ksoftirqd/2 Not tainted 5.2.0-rc1-002=
11-g1861420d0162 #1564
> [   66.477595] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.11.0-2.el7 04/01/2014
> [   66.478360] Call Trace:
> [   66.478591]  dump_stack+0x5b/0x8b
> [   66.478892]  ___might_sleep+0x22f/0x290
> [   66.479230]  cpus_read_lock+0x18/0x50
> [   66.479550]  static_key_slow_dec+0x41/0x70
> [   66.479914]  cgroup_bpf_release+0x1a6/0x400
> [   66.480285]  percpu_ref_switch_to_atomic_rcu+0x203/0x330
> [   66.480754]  rcu_core+0x475/0xcc0
> [   66.481047]  ? switch_mm_irqs_off+0x684/0xa40
> [   66.481422]  ? rcu_note_context_switch+0x260/0x260
> [   66.481842]  __do_softirq+0x1cf/0x5ff
> [   66.482174]  ? takeover_tasklets+0x5f0/0x5f0
> [   66.482542]  ? smpboot_thread_fn+0xab/0x780
> [   66.482911]  run_ksoftirqd+0x1a/0x40
> [   66.483225]  smpboot_thread_fn+0x3ad/0x780
> [   66.483583]  ? sort_range+0x20/0x20
> [   66.483894]  ? __kthread_parkme+0xb0/0x190
> [   66.484253]  ? sort_range+0x20/0x20
> [   66.484562]  ? sort_range+0x20/0x20
> [   66.484878]  kthread+0x2e2/0x3e0
> [   66.485166]  ? kthread_create_worker_on_cpu+0xb0/0xb0
> [   66.485620]  ret_from_fork+0x1f/0x30
>=20
> Same test runs fine before the patches.
>=20

Ouch, static_branch_dec() might block, so it's not possible to call it from
percpu ref counter release callback. It's not what I expected, tbh.

Good catch, thanks!
