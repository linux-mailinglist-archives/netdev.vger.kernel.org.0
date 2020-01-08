Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED4E134B5D
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 20:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbgAHTP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 14:15:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14752 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726989AbgAHTP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 14:15:56 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008JFbD5004697;
        Wed, 8 Jan 2020 11:15:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rJRSj1hneR1mDnfT8TX5K4MKWiqbJinVU5GKuyf4Bds=;
 b=VAbUH0z75+NrxilIreFYJEazo1bIr8/EnAzw5ht71Xjx2V28xSfHA2La+z6mKyzbfacb
 NPb6/AsX1ve6S3wUWIlRX2myTqghWh+XmbG1rn67cLAFmDILabhuJ10xUe2zrSh+8MQH
 sDXZtVLQXD76K5JrAj48qFRaQ0UZ7eNiQ0E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xcqharx69-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Jan 2020 11:15:43 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 8 Jan 2020 11:15:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XH/e9nzveQQ4wNBh74nLKo2lqD35fVADOIpzxmCD39NmEv/DyVNIrRkeboOq+un9jLTI3Lc9/S/Yw1FzGAmTZE53V1oefql0lBi13RBRQlSHI/WmKKnrDE8t0tgQLpXQ3KEwYKc4YJ+hMl4YroopMEtqD6Mr4Z9sbm0Y78JyICvOkelKZQXz3rTOhDdRBkZ6Gdkt7oKwfzYMAz12bmH+29NMrwLobsIdb7IjnHku+BeW+5xYxsNEN4AOFsxPuqEIEDstxpu1izz1qwRVva/Qmj8E5ygaIEclreI0neZ1EkNq7JJ6mPZ0lZO6sqg+8/A8o92FeQjqdrfofKBmgFXjqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJRSj1hneR1mDnfT8TX5K4MKWiqbJinVU5GKuyf4Bds=;
 b=dqvw2cQ3ii7ySDAL0DXvO2CPyhrE/NIE7fePKcjUdY4e1PoHSlOtHywH+Dpd8+MS56ZLZJBAv/4ASAW/qsvG/o5nm4fS1ByCKPKRtK+WyawvFYC2RjJ/w48EOEim9tWslANqXTmcLBKcC0ONJYskV4CedfoOiTNwK6ZaHyt2ly3JraYzF92/VyB2hEaKRz65rbTItShiBrJv/gOA7EPSJ7L0pQLcuJRrP9dVIlQ4dHYcmlFK1notayR0d6jNyKVMcAYYXJehiczs+zGZWGgXPuX81p7IQ7S2uD143mKEwdyKa6OY/NgIp17E5beYAyFITUNZisUVQzPYxWt4kPabJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJRSj1hneR1mDnfT8TX5K4MKWiqbJinVU5GKuyf4Bds=;
 b=gcORSBLWVRDihX3Uu0F9kmlD+5JfsILi1cMHyGicKl2LDYBpQXeYDONqumd6tfRsVKq1eOElyR9U02IHUaE+YYB7qv10ziXY1QMdu4gqnrTqhphKdQgl7kvWjWiwkZWSYzLLdwKbN7rQeDjY+p46OXtT6OT3cEmw+y7iRKvQ9qk=
Received: from BYAPR15MB3029.namprd15.prod.outlook.com (20.178.238.208) by
 BYAPR15MB3333.namprd15.prod.outlook.com (20.179.58.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Wed, 8 Jan 2020 19:15:31 +0000
Received: from BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d]) by BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d%3]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 19:15:31 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 4/6] selftests/bpf: Add fexit-to-skb test for
 global funcs
Thread-Topic: [PATCH bpf-next 4/6] selftests/bpf: Add fexit-to-skb test for
 global funcs
Thread-Index: AQHVxfTm870ki/neS02Fav0iGk+2UqfhJBEA
Date:   Wed, 8 Jan 2020 19:15:30 +0000
Message-ID: <D7C6AE60-C90F-470B-95A8-3C522998A3D6@fb.com>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-5-ast@kernel.org>
In-Reply-To: <20200108072538.3359838-5-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.40.2.2.4)
x-originating-ip: [2620:10d:c090:180::c159]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0baca945-a5c0-4ced-e292-08d7946f20fe
x-ms-traffictypediagnostic: BYAPR15MB3333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3333FCFF3A86DF854EAFA047B33E0@BYAPR15MB3333.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:565;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(346002)(39860400002)(136003)(189003)(199004)(6506007)(53546011)(8936002)(8676002)(81156014)(81166006)(4326008)(5660300002)(478600001)(91956017)(64756008)(66476007)(66556008)(66446008)(316002)(558084003)(54906003)(6916009)(2616005)(71200400001)(2906002)(36756003)(186003)(86362001)(66946007)(76116006)(33656002)(6512007)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3333;H:BYAPR15MB3029.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wUMen8FNn5Z5rLZhea1hU0o2Q1W9xgsRiO0+/YoWXPgci1j328OcWmaY1P4VTs2193ZX9iLkEWcMgzBVrJuQA1UVXpF3TDLZvDZ5idkZxjISn8lt0lfUZkxcZakAuXJaFPZub9DpZnOBH9KLX+ZgcozYTI2xWuZhgQut77DC2UVNdBNE4yZPFHaTqVpMVMAWpE66FGCvSeekt4wHK/GNfjf1tC3YsiDIoNmOiZE+2qV3nQ4p9KlySq8yxiit375pti+6DBzCHVgRejEo2sspdoVrmgFjzo/hbrblLS1lOOapb5z3yTdiiTt5upqiQOsI1xNfVsuRtsGid2CejV3rvPTEyiqAUPg2kXX+xKk90955ix+M0qIx0my0JyBGgGxYNRdKDEwQnordyGT3TukWOsH2sUtPi+0+C984cyp4FrITkV9g0K7oYfZCuU4MnHDZ
Content-Type: text/plain; charset="us-ascii"
Content-ID: <84331FB9321BE74692B8131E5DE2B0B3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0baca945-a5c0-4ced-e292-08d7946f20fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 19:15:30.8392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rUMFavvOLREIgbWFdDmaJgyBd3SisGrzDPbSaqqEvHqjdDx2PaJuNx53DCFKGldXfKW0JaB4z9K11OQovAHa9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3333
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_05:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 mlxscore=0
 mlxlogscore=769 adultscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001080152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 7, 2020, at 11:25 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Add simple fexit prog type to skb prog type test when subprogram is a glo=
bal
> function.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

