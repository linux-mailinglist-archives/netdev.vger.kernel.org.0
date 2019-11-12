Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D870F9705
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfKLRX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:23:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38178 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726952AbfKLRX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 12:23:27 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xACHJxXQ007300;
        Tue, 12 Nov 2019 09:23:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=98rPujDdGk2Zyw9mHGKDZ1aDaIdmFle6LXh4uV7DRFE=;
 b=MUawOUfFvOfaY8i32UvbIs8WtbqMhLZMvSdmWNpzFCBElXUhRp+K7UbklwHwV0GfcTed
 bl/Twn2clLR0yIsJ+7jfYm47gYzsvlIrJjyjGZUuXqfNcahbrFJGQdr60XWDB2g5rLtx
 GcabNF2VsYZ2ENPJEK3vqVVtbq3qVvZjKMM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2w7pr9u4pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Nov 2019 09:23:17 -0800
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 09:23:16 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 12 Nov 2019 09:23:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtzWLN6EQPK+hjAdTMr1z46+4ryfV+6EKnbo3J3Bp/mjAWSKhVXysv0Y+ciUIbayqxlSwxu0pH3Zu/n242g/F3tuOfw++TSvhYYpD6wxc7d55+upUlMx22TFHJk5CccNNRYM40MDpCUHJ3IB1I2zXsOqRAuv4L1haD7uoXtxhu5QWnJZGnptkcP6xOjZr1V8qeq2lzXopOmgMspwqn+Yy/wby2OWPdQq4XD1uJ9h8IV9cfN+FOfTZ0Y0NrUqIfHGwiYGLAm+01Sfv1K980D19EBRorpWkZsxTHw7XILo3pGzbx41z/cpYsB3PP8IzeOqi8DqgWFs3xZZipfj4xJsdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98rPujDdGk2Zyw9mHGKDZ1aDaIdmFle6LXh4uV7DRFE=;
 b=ABK9vydR7zIOmSFRLV7U1KF3ea2szBTnd49q8/EjLd5AKXpyuKCQHBYClECR22B9WIs3B9QQLkihtpSLQrzvg65dZtGuxiffRpnJsphssZH/COEfAINf3U6DxoWR2Mmec7BkMcdIdB+StPNOD1k8SmOI0ov0Aef0CYgZA3rlGYzKqZrTJpctvcvMrRdNyECRUQLH335u/gYxRZ2MTLrBY6JO1//EzLB2WKoLk8R9OjFMDWmD5Zi5FbM2Av+raUND/NfMODr3fr0KAkH/gYSq0KpiFmThQtjBOI/G4vj8y/rRO5KZ8TCcj32DrWE8NW4x6j2lrVSyN6CsSA3m/KW3jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98rPujDdGk2Zyw9mHGKDZ1aDaIdmFle6LXh4uV7DRFE=;
 b=Q70tRbEpa/I4z/zLxXXTNejlU3Z9e9utKwtf/SEXiFgPp+ocD1LuPBdYJZsv98k9xp3hCEBHB8C4flOxFCCveeAR0AAw073VfjZohmXG/XcfhCFkQim0z5wMHdZ+XvAEUKnbjrEY+hEVf87h2De2Nqd/hJL1RDjZ/x7inL7w0/s=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2486.namprd15.prod.outlook.com (52.135.194.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 12 Nov 2019 17:23:13 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 17:23:13 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>
Subject: Re: [net-next PATCH] page_pool: do not release pool until inflight ==
 0.
Thread-Topic: [net-next PATCH] page_pool: do not release pool until inflight
 == 0.
Thread-Index: AQHVmRqNKHbrdA+p1kSynDGQUj+KsaeHcZgAgABKKQCAAAQGAIAACbkA
Date:   Tue, 12 Nov 2019 17:23:13 +0000
Message-ID: <e4aa8923-7c81-a215-345c-a2127862048f@fb.com>
References: <20191112053210.2555169-1-jonathan.lemon@gmail.com>
 <20191112130832.6b3d69d5@carbon>
 <12C67CAA-4C7A-465D-84DD-8C3F94115CAA@gmail.com>
 <20191112174822.4b635e56@carbon>
In-Reply-To: <20191112174822.4b635e56@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0030.namprd20.prod.outlook.com
 (2603:10b6:300:ed::16) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:e001]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f214f307-4822-4e35-e9ff-08d76794ff30
x-ms-traffictypediagnostic: BYAPR15MB2486:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2486756F77F315D486A93E24D7770@BYAPR15MB2486.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(376002)(136003)(39860400002)(366004)(189003)(199004)(86362001)(31696002)(4326008)(6246003)(229853002)(6512007)(6486002)(6436002)(99286004)(81166006)(8936002)(81156014)(8676002)(2906002)(110136005)(6116002)(54906003)(7736002)(305945005)(66556008)(4744005)(66476007)(14454004)(486006)(186003)(2616005)(66946007)(316002)(64756008)(66446008)(14444005)(256004)(102836004)(46003)(5660300002)(478600001)(476003)(11346002)(446003)(76176011)(52116002)(71190400001)(31686004)(36756003)(25786009)(71200400001)(386003)(53546011)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2486;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sYKiNlsPShI1z4aCrenrG1ejwaWRtLfv2lLqlNDWUa4ORSJitM46hVKEDyUrW79um3B8mzkL7+3PMWE/L/CUBGaJZWF8wo8JyrDiJ1qrJIeUCwOcCp6/AaBdyTs7HaDML2dHufmIhdf/6MT7htkQWj/as2USDzfebIb6s7r2U9YRSFukLtGLz3DEZJtPtb7RgTfjp7fL70my4QLsXi9O47SyHAzT0LBq8PS4FxxmKSh6LUKW1s1kk4xLFyUMftK2mS4o2w4/7o5idlfKI/KFh/f2LyGjPg2anFH5s6YpXSnR/R+bNayHhOQF2cXSCY+QUrKbsX/aNqI/R/jy+jA51/p9ohjyOwYQSpIvu9x5uL3+cnHeSh/OecnX7qDz6F5VMg0PD+Xl+mH6dSCUueUgkRb7ILsSl8tL2eR9uIu2CjLGFpJU0KPZc3vkG6kOh9+f
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <86B1BA1928C8FD42ABEF959FF616E3A2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f214f307-4822-4e35-e9ff-08d76794ff30
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 17:23:13.4768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7sbxu5+/ZVKUhcIW4dqSFFpu/BovESK1M9wvPSFi4D9/CGtGOFcCCiOnxq6sJS+D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2486
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-12_06:2019-11-11,2019-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1011 phishscore=0 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 mlxlogscore=790 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911120148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/19 8:48 AM, Jesper Dangaard Brouer wrote:
>> The trace_page_pool_state_release() does not dereference pool, it just
>> reports the pointer value, so there shouldn't be any use-after-free.
> In the tracepoint we can still dereference the pool object pointer.
> This is made easier via using bpftrace for example see[1] (and with BTF
> this will become more common to do so).

bpf tracing progs cannot assume that the pointer is valid.
The program can remember a kernel pointer in a map and then
access it days later.
Like kretprobe on kfree_skb(). The skb is freed. 100% use-after-free.
Such bpf program is broken and won't be reading meaningful values,
but it won't crash the kernel.

On the other side we should not be passing pointers to freed objects
into tracepoints. That just wrong.
May be simply move that questionable tracepoint?

