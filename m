Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B30D81479C6
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 09:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgAXIzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 03:55:47 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55162 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbgAXIzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 03:55:47 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00O8rWKj017146;
        Fri, 24 Jan 2020 00:55:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=W0Lz+P990IB5mneXsEPjMxdWYIQ1nE5025/IzU1sGJQ=;
 b=S6EE3ApKC7g0B/2k8b392tPzQEVrfswdMWXM/D25z/vWXC1xCHl3m0fucxxNgOJVcplX
 kaUnRNACfxCsj62ENPkHN6pihwJoPs6nx8kT8VqQwl6WioI5qMNM05GMF/8AHtRyJrPr
 rcc8j0EY7GU/yMaATYLr31Mqi+3KQCUo7/o= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xpu218jcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 Jan 2020 00:55:29 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 24 Jan 2020 00:55:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnDOb0Ag+81oXDHpsaM+/XWZ9eExvmi1Z9yjEd4ZabfwoBESOZLJ0vNilNvYjhpS17OxXNGo73zJTbXWA3YTf+0rfLgiNeKwkvaVfDAsvNK8cI91mz9Lck3ZA96RzPXwkC2lHfp58kKVkeUGkrebE307Ysld/Su26wX3Bcstr34awV6zCL2HnQ3UHv3CvLc/teWwz9U6VQQzr26sllqPMfEkig34kPXLL9/XGvyuGcS6jX1aPn5+0VWKmYSS8xlV2/XgSp/J95QczXTU3XUwZOYLO8rPzjZICojPCaJbSWVyx/B/8b9fjhEjvZ1sb8AdldNaqYweDLVJZ72S+JFOjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0Lz+P990IB5mneXsEPjMxdWYIQ1nE5025/IzU1sGJQ=;
 b=KBKwqfxAOXe5oRId9PM+DP8wMKSN9IUeHB5Pv1Rj49B6AbuBkYymWt/1bul9OwFS5C2BJByhzmSTU+xu7aHdzPtfSiQlYSOEeCDymBG4fMZXAAh9uJcRa3Oq0JjP2DNWBjPL5lj0Bo1woNHbOnioZaGT9Cb0ZMtFIs9vNRnzOgjSt6WYkSDwvVtaoZxYj5ajBuG55EUvxB2h3BWUTPxWARG53BEAfRvd5zEHv7M9nFnbYe+iFYy73UOWQMoufPpsgopOXVNu9/Ehg+oe+5Qu7aXD6heq/6FdD+kz+YPmPow/1Xufq5+HIwY0b9WI0T+FoitJar6cGzdQHuC5clTVWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0Lz+P990IB5mneXsEPjMxdWYIQ1nE5025/IzU1sGJQ=;
 b=dIrYap9vYErTnhTQ7tfQT+SOHMoO7S1wBgen+8qBHuhV6xL6yGl3DEhqe+7VaiDVcgocpmc/J6321gFNkDHQX63Va9av9RL3oJU9xlrBZbNI2dph/yDTKlz9QhAwNsZz1kBkNG9edHxB1M91LdgNSHKU5gRlSuGwPZMx5t8Eo3Y=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2576.namprd15.prod.outlook.com (20.179.146.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Fri, 24 Jan 2020 08:54:52 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 08:54:53 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::d6ea) by MWHPR11CA0036.namprd11.prod.outlook.com (2603:10b6:300:115::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Fri, 24 Jan 2020 08:54:51 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        John Sperbeck <jsperbeck@google.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: initialize duration variable
 before using
Thread-Topic: [PATCH bpf-next] selftests/bpf: initialize duration variable
 before using
Thread-Index: AQHV0kgVF64+g2FKGECZMqyOKE8lWaf5g0wA
Date:   Fri, 24 Jan 2020 08:54:52 +0000
Message-ID: <20200124085448.r6lqsfigpatxhhig@kafai-mbp.dhcp.thefacebook.com>
References: <20200123235144.93610-1-sdf@google.com>
In-Reply-To: <20200123235144.93610-1-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0036.namprd11.prod.outlook.com
 (2603:10b6:300:115::22) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::d6ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09f87838-be69-4069-c5bf-08d7a0ab13bd
x-ms-traffictypediagnostic: MN2PR15MB2576:
x-microsoft-antispam-prvs: <MN2PR15MB257646EDE0E6C58B8DB5C3F5D50E0@MN2PR15MB2576.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(136003)(39860400002)(396003)(346002)(199004)(189003)(66556008)(64756008)(66946007)(66446008)(4326008)(478600001)(66476007)(186003)(55016002)(7696005)(52116002)(316002)(9686003)(54906003)(1076003)(86362001)(2906002)(6506007)(5660300002)(8676002)(16526019)(8936002)(81156014)(81166006)(558084003)(71200400001)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2576;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wBrLlpDpl6NXRfdXDPaf7sw3rWQZCo9Jc6qBnZd0LAXJnXTcffM9sOWruWurpGs8X+iBocJ7pid06dViC+RcvqBtyx+XOsnbXJGxgWe3nQrSHMRXn7rZ3oMt6ukpZt4EFKnm/+0hZQDF7CJ9c9FQ59UUmW5w3RwZA0wgKWhPTwnOAObmQFu2yG5QkJELKA37wGIPdBjjlI5DSS2CWco5UQizxy/zJdzdq80v/6R/U1cg8cq+vINaEGZcZ1umcRAccK6nxeSd4gpP24IgAkh0UgJRy3i138vob+fa5NjyLPrvi9ANN8MhKodYHJWu7HAOq73s/ZgLvsheiezu824OdIZ378x1knEjxt6qDIy4XqzNDxlkUAvasISoRXPSovSMBUhN81sYH9hWBjvui2UBfUdPl2+E80ZnfOVRk+6lYuFSP2x9xewmh+5YBBAgmbXH
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3ED5135FC836DE40AD94FC975FB0DB35@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f87838-be69-4069-c5bf-08d7a0ab13bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 08:54:52.9519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LJ4Cpbs6itPSenxmaZkc6E/L1AYLPabMYBCIpKo2/4gi2lBmR3eyvHSzIKgoUnbM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2576
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_02:2020-01-24,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=0 adultscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=455 phishscore=0 malwarescore=0 clxscore=1011 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001240074
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 03:51:44PM -0800, Stanislav Fomichev wrote:
> From: John Sperbeck <jsperbeck@google.com>
>=20
> The 'duration' variable is referenced in the CHECK() macro, and there are
> some uses of the macro before 'duration' is set.  The clang compiler
Acked-by: Martin KaFai Lau <kafai@fb.com>
