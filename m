Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F03273DC7
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 10:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgIVIvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 04:51:11 -0400
Received: from mail-dm6nam10on2045.outbound.protection.outlook.com ([40.107.93.45]:41169
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726098AbgIVIvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 04:51:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pj1Z1AUvf644WGgTrueI8bhgzNyK2deebT8jE+4jwVX8rP/VlYkKOJF2vxz9i9Xxvc75oCcpsOapqo81HdNW/mDJulE5Ye2R/93yYM+zsmg9mBXKuphCKKkIKOOVkN3XozU7e74CGjXRPT6rw1wZmJff+BVmV0SGHtaXQZMFwq49koLP5KE8Ly9ZWXMQDtODhUouxR2wMulFn8ZxbD6LKnxtpO+Qlhpx4AIAtLIL2FJVUwInqRU+PYu9+sx+8mRwUk6vcdl9psH0l7cC9c7CtZpCMQtDPmoBuTepSZe9K9KJ4FJWm3AfE2OJAFM/0zEz3iV+sS3GX8n1PhDRg9VvUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UckRBRR05g19PH2qqSyvnCwZhGLCWayn09vV4fEmaqE=;
 b=k6vp4xSCg8DfPCOHcB8cpVSsKKFM3kwt+CAjkcaLePX070EQkwz2m7LxgEPpTjejXFOX+3HkN2aVdqGxyG4/7V6t3n+13tO52NJN7tMizKXoXQk7VqdAUEkHnDPH/X74631CFwH3A49+yrecv1vXvzye9cWhD0sMb7dMu6pTWx8WkImHyNbgrxtKGvzEyp03YNOVvLxJSe0txYPSJ9lvyO1X/ztZJyzG0yAppgc6oGUpyGFRLFTEdglcM5QyAfK1erGfjcKOPCZqOTfqY04ZNBkqe5bS038Wzf1mYd6mQbZmre9iQMebTqUBYY5j8I0j2snVoqWdjNZyM8iNJrpfPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UckRBRR05g19PH2qqSyvnCwZhGLCWayn09vV4fEmaqE=;
 b=f5qFvucBzhlzKOmPyP9SlxVk+rEvCHLOePLOr0Qt3ov8nYoxqQD6oxHOFwGTmvaeX3hmXLqNsVuEJDXmaGoIvJYMvdJVUdj7yF3dSCmpN19gk6FRXwjNlL59hM6ZfrFS0q7YhA0t+hSwTm81I1fuaQ6mHr4W09CrnVsSTVxpikQ=
Received: from BYAPR05MB4839.namprd05.prod.outlook.com (52.135.235.141) by
 SJ0PR05MB7392.namprd05.prod.outlook.com (20.181.200.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.8; Tue, 22 Sep 2020 08:51:06 +0000
Received: from BYAPR05MB4839.namprd05.prod.outlook.com
 ([fe80::4cec:47f6:a0be:8304]) by BYAPR05MB4839.namprd05.prod.outlook.com
 ([fe80::4cec:47f6:a0be:8304%6]) with mapi id 15.20.3391.025; Tue, 22 Sep 2020
 08:51:05 +0000
From:   Abdul Anshad Azeez <aazees@vmware.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Performance regressions in networking & storage benchmarks in Linux
 kernel 5.8
Thread-Topic: Performance regressions in networking & storage benchmarks in
 Linux kernel 5.8
Thread-Index: AQHWkLxv33yBR7j1VE2lVgq0lG/dkA==
Date:   Tue, 22 Sep 2020 08:51:05 +0000
Message-ID: <BYAPR05MB4839189DFC487A1529D6734CA63B0@BYAPR05MB4839.namprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [183.82.221.236]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6719534e-4b59-4741-e756-08d85ed4a48b
x-ms-traffictypediagnostic: SJ0PR05MB7392:
x-microsoft-antispam-prvs: <SJ0PR05MB7392A7F22390FC9640D130E7A63B0@SJ0PR05MB7392.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N/2zpkm77UcejifI3PVInlFNFUUwwxroOzK7n3FNMlwueNrmTliprkXm6vtDNYo24AsyeChuVVMSMWeUS/rwDntnacKqsn2+HI1/KVkeIefFZOTEss3PoB7WCPfj5uC3i1jJa0OOOjKMQIp78drVRfsxW3Nx2SVdix7EuqWeM/17oY8cMuRCnYNAyGy2Iac/voX4CDEQOS6qknuhTm8xL4+ucx5ggXsdPVE7uThYs2hSUNCyvRTwT499fYGRLOkB/TKIXjPYXzW6jFTQpeGFv/Pi+31qEntSqRDXLVN2tOCbTE/P6wtAI5ogsNqjbwQB7kvSb5YVuPOjND+7uQROpass2yfnNVcyceALqU4w5zfpMTpDiLMh7vtwp5/Wv0tu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4839.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(54906003)(76116006)(6506007)(2906002)(9686003)(66476007)(66946007)(8936002)(26005)(66556008)(64756008)(186003)(110136005)(55016002)(4326008)(86362001)(478600001)(5660300002)(71200400001)(33656002)(7696005)(52536014)(91956017)(66446008)(8676002)(83380400001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 5Sn448QOeVmXWAlaPdrN5e4+mPcfQCfncIQCfnBSXDOwL/OLSExdoIdah0ip03tjb30qmNmWDo5Ep4eLLr42aYcQzZiuhPC6q2mksyt5LuQUZSgh11yApL9Ae/mLXsjcR33/WuMs9jrD2mmzYJEphv9pSg+VXt35Ivq3hpeb/6Ve1bdz7zuYPqJa9VFMcMTDMUzgABOUPpjhk0DixMFoZOIh0MSU1eTOAwsfpMTI9diEr2OpMHNqHSRcaIgHkm7AJt0LLiuDdB/TNJk3IMcKf9pjV7jwHAKKYHXmLoZ/OdgXw6FYKOV+Ooz4hJThereMx8l7Lv4/9y+oS6gm7mtW1Qw1GUZGdhi2AWPEDapOkqg6r3mM3hkhtn5Z9frbhPGs+1S6UtYwGAinKfPyEFLJeqpnQ3ORIP3gn7mm6g/as3bKulyzWuEG0JTSgrc5TumTglchfc7ye9MbRWQRd+8S0wDxIAwXiwiSVou6IV/23QobioSs/ygJ50vgw6xmRjJ+UFwg1Pi419l62gQkhJdj0S4RvW0pOccasXsC6/A0BQPoU+1lezKwZRErBq6xsUMGtNpMfLu9PO56dNuLCWM+OTrkw3hNscrHx6gGQ09Glb87BGCLBFNa9HotVxufdvyf9XHXZH4OmVonDCG4U/nYTg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4839.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6719534e-4b59-4741-e756-08d85ed4a48b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2020 08:51:05.9065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qgr3s/8HXKh0W8hyFoCBtRKiLR8/fJC8xElxDdMMM3l9okt3Hpfzwe+e2t/ptWDl9prrwt4qi//LOA/SRH1LCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7392
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Part of VMware's performance regression testing for Linux Kernel upstream r=
ele=0A=
ases we compared Linux kernel 5.8 against 5.7. Our evaluation revealed perf=
orm=0A=
ance regressions mostly in networking latency/response-time benchmarks up t=
o 6=0A=
0%. Storage throughput & latency benchmarks were also up by 8%.=0A=
=0A=
After performing the bisect between kernel 5.8 and 5.7, we identified the r=
oot=0A=
 cause behaviour to be an interrupt related change from Thomas Gleixner's "=
633=0A=
260fa143bbed05e65dc557a492667dfdc45bb(x86/irq: Convey vector as argument an=
d n=0A=
ot in ptregs)" commit. To confirm this, we backed out the commit from 5.8 &=
 re=0A=
ran our tests and found that the performance was similar to 5.7 kernel.=0A=
=0A=
Impacted test cases:=0A=
=0A=
Networking:=0A=
    - Netperf TCP_RR & TCP_CRR - Response time=0A=
    - Ping - Response time=0A=
    - Memcache - Response time=0A=
    - Netperf TCP_STREAM small(8K socket & 256B message)(TCP_NODELAY set) p=
ack=0A=
ets - Throughput & CPU utilization(CPU/Gbits)=0A=
=0A=
Storage:=0A=
    - FIO:=0A=
        - 4K (rand|seq)_(read|write) local-NVMe MultiVM tests - Throughput =
& l=0A=
atency=0A=
=0A=
From our testing, overall results indicate that above-mentioned commit has =
int=0A=
roduced performance regressions in latency-sensitive workloads for networki=
ng.=0A=
 For storage, it affected both throughput & latency workloads.=0A=
=0A=
Also, since Linux 5.9-rc4 kernel was released recently, we repeated the sam=
e e=0A=
xperiments on 5.9-rc4. We observed all regressions were fixed and the perfo=
rma=0A=
nce numbers between 5.7 and 5.9-rc4 were similar.=0A=
=0A=
In order to find the fix commit, we bisected again between 5.8 and 5.9-rc4 =
and=0A=
 identified that regressions were fixed from a commit made by the same auth=
or =0A=
Thomas Gleixner, which unbreaks the interrupt affinity settings - "e027ffff=
f79=0A=
9cdd70400c5485b1a54f482255985(x86/irq: Unbreak interrupt affinity setting)"=
.=0A=
=0A=
We believe these findings would be useful to the Linux community and wanted=
 to=0A=
 document the same.=0A=
=0A=
Abdul Anshad Azeez=0A=
Performance Engineering=0A=
VMware, Inc.=
