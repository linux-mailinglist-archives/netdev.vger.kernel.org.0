Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27979146EF3
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgAWRCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:02:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33698 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729999AbgAWRCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:02:06 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NGqafX014957;
        Thu, 23 Jan 2020 09:02:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=P2l9jjbb4T+aqFGdVq23TnSF8ftzxgdtJuvZhwvV74o=;
 b=b+TWfVfqaK/C5Kv21rT0eWDQy4Up2TSjFYt1WxOx66MHP5TvxBtlBruXFHq/oz8HqxFT
 gCZnKd8AN3C0HJSb/xYthnz2wE+aWtnH3G9mYRdl5idy2xI2s/Kd/0QySuNmK+IlRcLL
 +XbVYSKAKsqjZLbsTgAN9rSqOrDlCj5rTlI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xpj9tqc86-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Jan 2020 09:02:05 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 23 Jan 2020 09:02:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izFh9l+rKUpMtud3ZbWoejj8H8jL4TRvW+yrjTnL6hB+wc7WnfLwB50yjJ7Az1b+nKVOSA+76NDq5J0USB0DvDwTrhkSvOAQqK1DERwgeYugYacBWknIwCAkkYSnUB89G0rYX0R2O6DJHzOFoKwJfUPaV5zfqrX+l96Xb3e2aJbPJ9IheoAMQB2LN7xtQKHiG4oCzQofMBHivcodgrLrL7qbyBDOJZe1FW/NMD4+pm9+xSelshxYvFX2x8+PyLxPO7ZvU449o9j4uuUmvCMXNbGBvTcZkVX8/FAKOP/RF0k6TI0ljBjM9I0xnEkgXA2vervuyT9oznPg+L3H4+zGBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2l9jjbb4T+aqFGdVq23TnSF8ftzxgdtJuvZhwvV74o=;
 b=KRD+NnXK16AA0rQP2+HdPsNBkJJrtKqa9oBXK2e4EvRFQk9bjnQI5rcOiUBW57QV2pC335KavUQMHk6Qql45MAQCMDEfDoAJ35PORbCKZn5yrOoy8stu35wWhuY9l2l//wdUbtAM97/+dTJSUGBOYUfjaorTGF/NwV5a7+5rlDywJ1K5KeVQDEfldRNpAg8Mb3MrOs8Sed+XpqsrkuHqBEtMrteVQWko7yUqNrCPSl5hU4ngyB8YgZzeboPOA6q79ZZ+78x/XgmhfPX77OfOo/BYTa6NXQIT7sZ3YBXbYznNDqniTpMDvzd9q2sRisiK/MSENDzlGQstNLC2yjROMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2l9jjbb4T+aqFGdVq23TnSF8ftzxgdtJuvZhwvV74o=;
 b=Ipvk+Gy5B+qqaMOTk/Dw2WBkiMRmZgrYs1mmnXM9frpxWeb15u0Bzz2IPOM2iN8/8QdTEF0/UlFDayAOHatkeucd5oYJh1yHcvifeIS6sL71IT3ArbqjsY8mTqBJRhtrp9DolZ8ecGIft+Dv4NcxhWLOpZuz9LOBhV89VjSk+ks=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3133.namprd15.prod.outlook.com (20.178.252.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Thu, 23 Jan 2020 17:02:02 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 17:02:02 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::2:d66d) by CO2PR04CA0186.namprd04.prod.outlook.com (2603:10b6:104:5::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Thu, 23 Jan 2020 17:02:01 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v4 10/12] net: Generate reuseport group ID on
 group creation
Thread-Topic: [PATCH bpf-next v4 10/12] net: Generate reuseport group ID on
 group creation
Thread-Index: AQHV0gWXUwDh+wD38USp2poqMrxqKqf4eZkA
Date:   Thu, 23 Jan 2020 17:02:02 +0000
Message-ID: <20200123170158.a4c3awxgyr3n7huf@kafai-mbp.dhcp.thefacebook.com>
References: <20200123155534.114313-1-jakub@cloudflare.com>
 <20200123155534.114313-11-jakub@cloudflare.com>
In-Reply-To: <20200123155534.114313-11-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0186.namprd04.prod.outlook.com
 (2603:10b6:104:5::16) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:d66d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 818aa1dc-e8bc-461f-17ff-08d7a025f771
x-ms-traffictypediagnostic: MN2PR15MB3133:
x-microsoft-antispam-prvs: <MN2PR15MB31337D2E0385E2381A58487BD50F0@MN2PR15MB3133.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(366004)(376002)(396003)(189003)(199004)(1076003)(186003)(16526019)(6916009)(66446008)(64756008)(5660300002)(55016002)(71200400001)(66556008)(66476007)(478600001)(9686003)(66946007)(2906002)(4326008)(7696005)(52116002)(6506007)(316002)(54906003)(81166006)(8676002)(8936002)(81156014)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3133;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ibq+C7OqoL5mswPezFG7V2sZltDqZ0MWUK3bntGXOpyFROpI8nMsWVJtPMvT4UxSYrnTsXASxGuisw8b9Jng0aTdW3SScdJAUOe2/Q6632stH/HyamdwZzCG7RTqp/bsW42H3HiiNDHhZm9DLEtNrFo3YI2wvfVCfgFM10Nt7e2SzE/pzCVXA8EcpOJGUqJBPKGHg1ritsh82hMuKNlnR04ZswEtWUZHT+/CYAjWos/OmCUu9SiGPeDI0jsKpyDOKH3igzSiv+dFaUlz5C1UrvzAvWdLOri9XbwCSvRgeskEu6J88gb6Q8pEek7lFV5CMWoUK0zA1I0z21sTCVHgVg7pjAkNkvg5my0JX5GR+VlgM+FjcB+fq38gVG11BGQ/P4TVUwozjhZeufHwLVVWc2CG0p26sCas0/pEtuhnGfy9VO/dYAhiJJDrGrZun/h
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <424EF172DCBC0B488B7E9EA362D75C92@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 818aa1dc-e8bc-461f-17ff-08d7a025f771
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 17:02:02.4061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v2UFama2pOJGrDihLoCXmLemagRJJOkzfmbM6nzpiJcbFpaJ70/8TQoqvtveZUOJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3133
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_10:2020-01-23,2020-01-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=874 bulkscore=0 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001230132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 04:55:32PM +0100, Jakub Sitnicki wrote:
> Commit 736b46027eb4 ("net: Add ID (if needed) to sock_reuseport and expos=
e
> reuseport_lock") has introduced lazy generation of reuseport group IDs th=
at
> survive group resize.
>=20
> By comparing the identifier we check if BPF reuseport program is not tryi=
ng
> to select a socket from a BPF map that belongs to a different reuseport
> group than the one the packet is for.
>=20
> Because SOCKARRAY used to be the only BPF map type that can be used with
> reuseport BPF, it was possible to delay the generation of reuseport group
> ID until a socket from the group was inserted into BPF map for the first
> time.
>=20
> Now that SOCKMAP can be used with reuseport BPF we have two options, eith=
er
> generate the reuseport ID on map update, like SOCKARRAY does, or allocate
> an ID from the start when reuseport group gets created.
>=20
> This patch goes the latter approach to keep SOCKMAP free of calls into
> reuseport code. This streamlines the reuseport_id access as its lifetime
> now matches the longevity of reuseport object.
Acked-by: Martin KaFai Lau <kafai@fb.com>
