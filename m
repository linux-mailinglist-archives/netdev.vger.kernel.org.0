Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5CB146F58
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgAWRQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:16:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64498 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728731AbgAWRQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:16:32 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NH8eQA000441;
        Thu, 23 Jan 2020 09:16:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=39vetacuAforZk3W+3gRyQFZuI0sX037sOEZQwB4roY=;
 b=TwaUUSakuw1ccW0MJ+ixLvwmoIUOlotBLnG5rP+ibxadZkAuWutV1pg1Q3J2oVdtgYkE
 Wq+QZNeQWBKbWETtvHZGdjYazO+LY2wYrn6XmHP/23DJQeislEtiHErxSFbptTvE3hip
 jc7QiQ2FnGjOrPbpIaby8WQKrWE5hDUqd2Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xpr4ke2d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Jan 2020 09:16:18 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 23 Jan 2020 09:16:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Td+6jsvrap4VdaOvca3Dtk+67FKPHlXMJv3CJDIofQb/sq1+tY4X2tE/lTGgHsqQ/26gAPjerPQpzgr8eQhMtUBFDPuygCwDkORLfjQjkpbsQthyzYMyom4RKejYgb/jSZ/WgCpm6kEE/DeHJgXSm6Bb/etek8koQqJQagWykX+ixD1jI/uL4X5cJ/8FMcQzfY/n85KUZidCxanmodMpRXGNf1rQXeY2sYqqEwMf0K3w7eLGsElGv8Y7RLdr8pBq4PtZoJDSNsBqzcwDwJ9tWUk8YPqM2gPVKjFEsHD9RlxQbicjFA4FoLbSSUQml7tCYg9kIvOLx3GdQsh0+BLXHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39vetacuAforZk3W+3gRyQFZuI0sX037sOEZQwB4roY=;
 b=FbYWIS3XWEeLCr/JSVJI32HmNAcomrPgKfPlYRZEsRD1h7u3JBoI/WQ4V2DAtThkyIl473chXEaFBeX3XJbppTw/deDLyI5OSjqE2G9ojul0kaGhr9sPImja0V/b8zQfY9EnyUnVvFMPhXNzC2qWOd/wjVeZR+CF018+fDsOkoPeUk0ibHxTQK/kWxdBsU6hEcclvMGGzBpwvQDmhAWbt+WIiLbLmc5f/cBEiwnD79NiOuhnocRvRbZ4pm+U6BH3KePNm6+iMrVmJ/4ZlgRYeOu4fXu6DW2yxTt3XS5N5x8AWI462TBqDRIG0waQgeK1758QkuWSbBH4w6uQahoyyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39vetacuAforZk3W+3gRyQFZuI0sX037sOEZQwB4roY=;
 b=NUy+7rALW9zj649FYkOTzkWfcstHUt1q0ldWio8AI5SmraEy8rX23W6VwEUhkmKUVMvhzozTRce/qKuW8nndVGaV8IxdNBC+GtlUhqonVsg96pCCd7ioXMFER2XMblm9DQUdjkDwEJIPODpiRP1+PziDe8WZvpXorjLxqPsdoLo=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3311.namprd15.prod.outlook.com (20.179.23.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Thu, 23 Jan 2020 17:16:16 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 17:16:16 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::2:d66d) by CO2PR04CA0058.namprd04.prod.outlook.com (2603:10b6:102:1::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Thu, 23 Jan 2020 17:16:14 +0000
From:   Martin Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf 2/4] selftests: bpf: ignore RST packets for reuseport
 tests
Thread-Topic: [PATCH bpf 2/4] selftests: bpf: ignore RST packets for reuseport
 tests
Thread-Index: AQHV0g6NwgtJo3iSuUOeG+lkP8Lweqf4fYEA
Date:   Thu, 23 Jan 2020 17:16:16 +0000
Message-ID: <20200123171612.stdwtlpqibkydz2s@kafai-mbp.dhcp.thefacebook.com>
References: <20200123165934.9584-1-lmb@cloudflare.com>
 <20200123165934.9584-3-lmb@cloudflare.com>
In-Reply-To: <20200123165934.9584-3-lmb@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0058.namprd04.prod.outlook.com
 (2603:10b6:102:1::26) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:d66d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe21180c-3d8b-4811-28d5-08d7a027f4bc
x-ms-traffictypediagnostic: MN2PR15MB3311:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB33119E72CED3C530C16F895ED50F0@MN2PR15MB3311.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(396003)(366004)(39860400002)(199004)(189003)(1076003)(4744005)(2906002)(86362001)(6916009)(54906003)(9686003)(7696005)(52116002)(55016002)(5660300002)(6506007)(478600001)(4326008)(8936002)(316002)(81156014)(81166006)(8676002)(66946007)(71200400001)(16526019)(64756008)(186003)(66446008)(66556008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3311;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h9sZqhlDdh03cRqb+VWUtIKerG4A04sFM6hhnhJz9Of8Hm04m7JrL7VlA+WD2ZFsqhuFPz75yGia10L3auufwJjzixBISbqz4PrJRBr34kRs9RZMjG29JGu4bphl9/aN14wAdNKMaA5FW+4SRIpQWTJ5XuSEFIku9i+u0TDe+W66SM6yI/CB7S3x82VeiogAuHLI3dnF0jSOjdlxVbpF0fBtEOv47I5I7lcfi/3pL9yP8zY6utdRNEKdpn7vvLVkfI0WCqxPqvEDB39tO3lTWV3Phlg609YpquMkrut74Fm4pWjTzx95dhJNScR7AmXWiktQQCWAPToRSiCNGBv5Mvi4bRhI4yGnk5Euue+lnzgI0HTR2Ns2t+VvSsUegkyiWG1w0a2Rotd6vrEWjyn132tF7ojwTrxGsXTrmv1ztJMl39zPpNq1OjcX+T3r3j3U
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6D75503A71A72A41AA7EF4EC3FF92E32@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fe21180c-3d8b-4811-28d5-08d7a027f4bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 17:16:16.7954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PJ1ST79cX6QlYsF9ucsTC/NuYXRh3YOSoDv3U50qZIVkllYKr84PWVUEdwU8WBPm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3311
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_10:2020-01-23,2020-01-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1011 impostorscore=0
 malwarescore=0 mlxlogscore=661 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001230134
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 04:59:31PM +0000, Lorenz Bauer wrote:
> The reuseport tests currently suffer from a race condition: RST
> packets count towards DROP_ERR_SKB_DATA, since they don't contain
> a valid struct cmd. Tests will spuriously fail depending on whether
> check_results is called before or after the RST is processed.
>=20
> Exit the BPF program early if FIN is set.
Make sense.
Is it a RST or FIN?  The earlier commit message said RST.
