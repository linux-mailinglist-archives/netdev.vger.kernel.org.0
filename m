Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC90D98D4
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394209AbfJPSBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 14:01:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49466 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390034AbfJPSBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 14:01:31 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9GI0cKs015140;
        Wed, 16 Oct 2019 11:01:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=sOmvQ9G1UHes6GJBhSRXmDOwRunflCmZPWfj3P6x91Y=;
 b=XV2xxZnIo0RuFdA+PCsCiAhZmXaQZQjZ6Lu6f1zBOHGg3KNHJimi9WT6/MsUNZKzcX1P
 zkZ8zQ1Agrx8lW25FrXnp5V8il6OR2Ax9R9WuAvPCCnbThIFbJxcv607yViR4zE1jhof
 LyJXUS2558RA/4OZ2S/YtharSMU7N/0oTgg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnkjd5b1a-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Oct 2019 11:01:17 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Oct 2019 11:01:15 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 16 Oct 2019 11:01:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnN4UNZVWsBTQGcL3d/b7TUsC8598IgymLyjnxmvoFeirpH4uc8vyxyZVNDXV3S0n+zvb0scsRZHsIsrkdZt+HMz5nKxyhvfmcmT50nyz12vnr+2LZ44uUGP8gNxn0XDILrbQTDdon3xCOVWkapidGNrbR6Mb1e8rT0L9Z6lFgIi75XMCY7jbrEuymQHaPtIpRHIAMYw09mGoaVEQCTpAFmgJtxzVwzSIZhaArz3YRkoOSGHtiaaVca6GYOwjHv+dPmulDwaqovbDV0acZ7NemNBzEeAxK+9MvwT8OOLtz8L39Z6e70fVH7p+nAKAlYDA+SHR8NsfnkCZKylIBhFiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOmvQ9G1UHes6GJBhSRXmDOwRunflCmZPWfj3P6x91Y=;
 b=AyxQPkBmAXVGDzQ7RX0yBBP+BDp4d0fmlsPxAI7o7D8yiN2kpGaRExFLqaBLzWH3b5jTMHT0+uaQwIT3kUOukBooqBAvKZJtLS0ULnJLCbJwOdp8W+uJHASYpdImYGVK4/IXZO/UVR3Zm4XKk4OYGCL3zHhFDl1/TI7P0nCuB7/Xl/hRlLcQUrJJlvqWClBF6KhAZflz8N5sM1ocTotTZd1uI6pwUaxnYr0HQxicZIrhuyLo5vfxay6Pu63gG/XZPtTiXEUXUyXaKh7gltoZtnZYDBRYF8HRqmLPecxTMKqe2g/0Q+9OmuTrnsSlSG3aJ8QNH5bu0pWgFUbEteW+kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOmvQ9G1UHes6GJBhSRXmDOwRunflCmZPWfj3P6x91Y=;
 b=e/N0/UhUt6W/gSQvaQq9PckH/7OgeQRG/nzpDtG3cBWKW1fGrlbEgz3iMPc5Wn8AKEWFBa/g/6HS9My7sZwk/bVuXlX6wnl9xOSk8Y7CPe6MrloHrzjpGMAt7hoYLxIdcBNEjrW+NxGwLmbm76DFguKD4KP+eNw0n1b/dhbRxxM=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2622.namprd15.prod.outlook.com (20.179.144.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Wed, 16 Oct 2019 18:01:11 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 18:01:11 +0000
From:   Martin Lau <kafai@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 00/11] bpf: revolutionize bpf tracing
Thread-Topic: [PATCH v3 bpf-next 00/11] bpf: revolutionize bpf tracing
Thread-Index: AQHVg9FQyiNAB0tYpkGpLhGyOIcXbKddj7uA
Date:   Wed, 16 Oct 2019 18:01:11 +0000
Message-ID: <20191016180107.od7sz3qp6irqjgxe@kafai-mbp.dhcp.thefacebook.com>
References: <20191016032505.2089704-1-ast@kernel.org>
In-Reply-To: <20191016032505.2089704-1-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR18CA0046.namprd18.prod.outlook.com
 (2603:10b6:104:2::14) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f9fb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92b9b069-feaa-4a37-f7f9-08d75262d413
x-ms-traffictypediagnostic: MN2PR15MB2622:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2622202210C5A101736DB37CD5920@MN2PR15MB2622.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(376002)(396003)(39860400002)(366004)(189003)(199004)(1076003)(99286004)(71190400001)(52116002)(5660300002)(8936002)(81166006)(81156014)(8676002)(76176011)(186003)(14454004)(102836004)(71200400001)(54906003)(386003)(86362001)(4744005)(6506007)(316002)(25786009)(478600001)(486006)(476003)(2906002)(256004)(6116002)(46003)(7736002)(6916009)(11346002)(305945005)(446003)(6436002)(4326008)(66446008)(64756008)(66556008)(66476007)(66946007)(6486002)(6246003)(9686003)(6512007)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2622;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 57Dtrdkz00yVJnBF2irMqNxi9k/GQKfgCRA/LVLFqlHNrsB0yPEx5SwAtiasgmEYH2DJ5V8YXIIpXmZ/F9+pylv61CV6W3HX0BHMTVhNxLU1CSpRnEKqPLChFJx0lH4+IbshHmIfx3RbPFTh8xQLg7IDZDhFAxWFs6cx+dTs/JLKpca24a6KO8qaDwsT4rXaXKiV3SsKbyFggmsEzQP6qlw2/dixnLuNjdmTR+5v/ILfA7RVMskqS1X4OQ5Yr1CT8Q9X0/ZZ+dHqOrIE9H1pT/qzTlplf/GC+NXF4WCCuL0fG7B2sG7I5MNo6stjkpdJnkaNqwkldlK9BeE9q9GzmKwtJwV+WVFtTEPBUlXeuxjT3oMJNoOyb7Tgn9sXyF2Tw9S+WmoGVf78AeR4atsNBxmmdofSwLWOz/jnGpweVz4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3BFABCF6DB4DD740A648EFFA7E5ECE35@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b9b069-feaa-4a37-f7f9-08d75262d413
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 18:01:11.6844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 89cWE3+lXxK6b3/jbhadZW5nIGCKdMYCZyLFBjIfdpaV2HEjRMVMDGBkqIT2u6CN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2622
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_07:2019-10-16,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=412 mlxscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910160150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 08:24:54PM -0700, Alexei Starovoitov wrote:
> The end result is safer and faster bpf tracing.
> Safer - because type safe direct load can be used most of the time
> instead of bpf_probe_read().
> Faster - because direct loads are used to walk kernel data structures
> instead of bpf_probe_read() calls.
> Note that such loads can page fault and are supported by
> hidden bpf_probe_read() in interpreter and via exception table
> if program is JITed.
Exciting stuff!

Acked-by: Martin KaFai Lau <kafai@fb.com>
