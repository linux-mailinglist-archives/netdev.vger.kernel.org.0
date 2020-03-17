Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086021891CA
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 00:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgCQXJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 19:09:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61138 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727054AbgCQXJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 19:09:08 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02HN5MD1016731;
        Tue, 17 Mar 2020 16:08:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QrBA2gmuB7tpx4fh3Zk2K8avH1bdJWX0/MVlsG9dOKo=;
 b=FRscoQ2ARGT7EFru5vFXs+mgNzAj+3g/0lSGp9KwJ/SKdAIXlH63UEkIc5s1Lt1fOsQ3
 nm6yPFvsOqktwsDHRnwXDnadSI+9Gt2hbMVrC8wN9+fEF7KC42/DOYywlLEsOmCRv9oH
 ymV8vh2cGeudYFAFnOFLdSOs7x7LRFrhOQM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu7qa8263-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Mar 2020 16:08:50 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 17 Mar 2020 16:08:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YeRhdH7l8hVJ5o9J5/AAfmscGI5zYruDPSwXnD9rwW28CP412W6TSdN3efz2daZJ8WG+NAfhq1pQAlWsT+1S26DCTxDHDvwYgdI3M4mXmlld1epyHTvDp/2wtZH1wCq9VdJF4q4iulW8c/L7o6HP5t4gg0qlGk4VF46qSscCSCW5BjvD8NqFbVH/3n2MEq/uVmNopRdSDIpX5c8QxtcjsGD4VEnihMbGSWyWwqmgM9CQd99H0a/sKWYSM8dhmYHbi1/41qaw1FrDPVsBuWKT06yahTBzE9B4xWTM2RIcrVKVoZpblvvmjDHnpa+Ed2DMFP3hvuqG6/2G3PesvfNrvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QrBA2gmuB7tpx4fh3Zk2K8avH1bdJWX0/MVlsG9dOKo=;
 b=g8Yqj8OBuf/jD/0nuHDbD4anU7W1iPqQLRJnPDIB94k8Tl4ZYvEwxBJXGKQRYRk2DOhpYBBFZdYWBuiqb5NmfGpSqRfOqLCD+gowJSHRuTgHnw1ELP+n8fiZJAwnIgRRR3HW56Q9SMlT41JeBPdORSH4Y+0P0dbCOEg4HwRtRItxBmYLx5c20NpX3RLar5rDJB4fwKXfaN4RC/BBTEJMZoebDzO7ZCETJkJ0QIM+ZApph8E1NpZVuJ+TBQ/cUL10XdGtlkr+UPBmwjRvMUz9nu998o8oCIyOjjcnI0SATj4U1Ly7cPX6ovhOc3/rUKHSrRvDDxy+Jv5qLbfG4R4/jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QrBA2gmuB7tpx4fh3Zk2K8avH1bdJWX0/MVlsG9dOKo=;
 b=gKTk3voK3sgxxTKFN5IVRYitw+DISJsHwhKHSXdz7tMrPOrxeCYNEkiIv2eNX4glG1q9GchdKWRn4pn/p4b+iYuK7aOnVckQx+OdfpndeaHcKOB2D9gK1/tWOMd/twqAKvQEGIltrs6NhnZ/T5CcW1lpbuNrjw1+Xo4F7maleaE=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3756.namprd15.prod.outlook.com (2603:10b6:303:47::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21; Tue, 17 Mar
 2020 23:08:01 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 23:08:01 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "yzaikin@google.com" <yzaikin@google.com>
Subject: Re: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with
 /dev/bpf_stats
Thread-Topic: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with
 /dev/bpf_stats
Thread-Index: AQHV+9Iy3gdyr8P9PUGp5sv3FGMYHqhNLWaAgAAGw4CAAAJXAIAAAvkAgAAaDwCAABahAA==
Date:   Tue, 17 Mar 2020 23:08:01 +0000
Message-ID: <C624907B-22DB-4505-9C9E-1F8A96013AC7@fb.com>
References: <20200316203329.2747779-1-songliubraving@fb.com>
 <eb31bed3-3be4-501e-4340-bd558b31ead2@iogearbox.net>
 <920839AF-AC7A-4CD3-975F-111C3C6F75B9@fb.com>
 <a69245f8-c70f-857c-b109-556d1bc267f7@iogearbox.net>
 <C126A009-516F-451A-9A83-31BC8F67AA11@fb.com>
 <53f8973f-4b3e-08fe-2363-2300027c8f9d@iogearbox.net>
In-Reply-To: <53f8973f-4b3e-08fe-2363-2300027c8f9d@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:424]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc765b81-d335-4e17-9bdc-08d7cac80abe
x-ms-traffictypediagnostic: MW3PR15MB3756:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB3756F6386DE1CAAB2B4F0988B3F60@MW3PR15MB3756.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(396003)(376002)(39860400002)(199004)(966005)(186003)(2616005)(66446008)(6512007)(64756008)(478600001)(6506007)(53546011)(86362001)(2906002)(8676002)(36756003)(81166006)(81156014)(6916009)(6486002)(54906003)(71200400001)(8936002)(4326008)(33656002)(66946007)(66476007)(316002)(76116006)(5660300002)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3756;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RYpHoZy8INZueEqj5OpzbobClxqxYM5iTS6kxDilv/Lx6eIx+v7Tgu3OjporF0aNS5T/+bjE1HG4qVWCPB7cA/iiuVIyaBDwCG4JcHx3XkBm/nKx+Yeu6K8/e2t+RPzJnjeFYuQHSDLUMkMniOibEAMo/Yx/GzERTV5UG4SeNayzoW1EN/ALiBPSnamWMfeXkUAIMPp05spLxTMSMhw0rsYy5DAa5HkgcI2xXY2hKc4UTlk100yvMjUx7fDKTteeCnzE7LZ0G/zFh2mA1twdqf7WbovipDP/gf90UyUm8dym92mFIiT7Ia062HRF/l2YSm3nETdlw6G4ABOF4bVhRhDnDTIT2gArYnzgZshcBBepaucQ04aYZNIgilomEebKtTZiVCqljo16oimMtq9yl9967TLQokLktgxHU2TQf+WYav0Kx1CpoN7SPYmRRJIHP3FUEK94+0XhywQAQrXp+n2vCNgQTE8l8PqaWdhIPZ8Ct5V6OK3bI9Al0E1xIFxeGpktgu190NVfyJemTw64bA==
x-ms-exchange-antispam-messagedata: Qk4OnzWAFAiCQ85U957mdidrqfLOR7/VgQaYEtijLaGM+RWziTcFT8+QKxzdlO4Vb1jPTKhyyDMCRf7Lf/T2zJGIXvL8LB0NTwsf8i12FdtV8GaA60u16x5sqTmAThVSx/TZggA29D9hjodnY796nSIfz2F0hOVvaIvSR5QLLc+x7yaphEOZnOKjvl8dE1yn
Content-Type: text/plain; charset="us-ascii"
Content-ID: <184AA02C680A5045B61AF2625ABC0E7F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dc765b81-d335-4e17-9bdc-08d7cac80abe
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2020 23:08:01.6289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X1S+RTGr/0JntvDi5BIRRKvEB3+jkKTw+D0q7tRYxF/MKnI09x1Urtjnrw7sn5yVQUOLZz4Tc7aVgg5d/jY6yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3756
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_09:2020-03-17,2020-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003170091
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 17, 2020, at 2:47 PM, Daniel Borkmann <daniel@iogearbox.net> wrote=
:
>>>=20
>>> Hm, true as well. Wouldn't long-term extending "bpftool prog profile" f=
entry/fexit
>>> programs supersede this old bpf_stats infrastructure? Iow, can't we imp=
lement the
>>> same (or even more elaborate stats aggregation) in BPF via fentry/fexit=
 and then
>>> potentially deprecate bpf_stats counters?
>> I think run_time_ns has its own value as a simple monitoring framework. =
We can
>> use it in tools like top (and variations). It will be easier for these t=
ools to
>> adopt run_time_ns than using fentry/fexit.
>=20
> Agree that this is easier; I presume there is no such official integratio=
n today
> in tools like top, right, or is there anything planned?

Yes, we do want more supports in different tools to increase the visibility=
.=20
Here is the effort for atop: https://github.com/Atoptool/atop/pull/88 .

I wasn't pushing push hard on this one mostly because the sysctl interface =
requires=20
a user space "owner".=20

>=20
>> On the other hand, in long term, we may include a few fentry/fexit based=
 programs
>> in the kernel binary (or the rpm), so that these tools can use them easi=
ly. At
>> that time, we can fully deprecate run_time_ns. Maybe this is not too far=
 away?
>=20
> Did you check how feasible it is to have something like `bpftool prog pro=
file top`
> which then enables fentry/fexit for /all/ existing BPF programs in the sy=
stem? It
> could then sort the sample interval by run_cnt, cycles, cache misses, agg=
regated
> runtime, etc in a top-like output. Wdyt?

I wonder whether we can achieve this with one bpf prog (or a trampoline) th=
at covers
all BPF programs, like a trampoline inside __BPF_PROG_RUN()?=20

For long term direction, I think we could compare two different approaches:=
 add new=20
tools (like bpftool prog profile top) vs. add BPF support to existing tools=
. The=20
first approach is easier. The latter approach would show BPF information to=
 users
who are not expecting BPF programs in the systems. For many sysadmins, seei=
ng BPF
programs in top/ps, and controlling them via kill is more natural than lear=
ning
bpftool. What's your thought on this?=20

Thanks,
Song

