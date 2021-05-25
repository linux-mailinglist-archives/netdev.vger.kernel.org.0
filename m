Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DA439015B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 14:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhEYMxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 08:53:17 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18598 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232720AbhEYMxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 08:53:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PCpH9I020588;
        Tue, 25 May 2021 05:51:40 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by mx0a-0016f401.pphosted.com with ESMTP id 38s0fer7uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 05:51:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tgl2ejydeHqJtGvUKgcgOVQveEiLErJGCjvHZw4Wl+/YP5tdVdU6asXAX6KqATBJWUdGmsF1jS96QRInD0yRugJg3/8le/hzf12/yayzEnGi+PK2B1FBwic3kiveT4sQBSpQmacC0M/elJ3RZ5iteAU2PtQhl2S1POsS6N8d/QsYGW5G04U2537F6svVFfpa8hObSC5jZmF9YwL07Xnj6Ar0b3Z03oDn9M7dv/xp+n522+w6HiRkQrX7RGlEBaMuZzlj0PKM1xzav7EDzGoFIooRjva4K2ADMr5a4Uj3FcEKDD3NzzyZeffi+GP3fNayYhWDHS/srwgYA/434BOfKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryxpUVIQf1GG9aoVNsVSklBQHES+pHVy1+ciADL5GsM=;
 b=oe3lE/rki3a/bCm0dt805Hgd/droKG+hjji+lgMf9sKEVWNAJxpQh41rSjSkZ9JypfbSnguKup6JGAF/Yv/fwPwzJMEOVE7XiWSW+99hLfKUmGuaVfhM+jmNuKbQe3YcuwlM0DWqHXXhNO3shJ9FlR0uzKawi9y4BDsf8kffdfgeOJ3359KPedoKpvLhe4b/JaiFAxfS+mNT9yubsnG9wHIbwayA/KGFDIGpglQz0AMTKn/B0B3XoGD+UWhdKfZH0DUOoXrKXndi588CxBv8EKBPxinE2OUv63swGwXIyJU6ndX+GnVK1koo24WNKpRJLIA6HFDeIIxwmxr89uAtEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryxpUVIQf1GG9aoVNsVSklBQHES+pHVy1+ciADL5GsM=;
 b=lpC11ncruUljHjSc2U++D2iyM8nYvjg7+38nRcG5+42RPtTahGBm8fnEGWG2TcL25WQbX/06rIavApajI1Z0oQMzVCy0ZBLE64NjowpNNfQ7mViMJLx2XMni2+eLWbsD6/fAGJmghPXbLmJoHqBGB7cWmFoFcXEmMFQ3gJp4/gw=
Received: from PH0PR18MB4039.namprd18.prod.outlook.com (2603:10b6:510:2d::6)
 by PH0PR18MB3991.namprd18.prod.outlook.com (2603:10b6:510:1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Tue, 25 May
 2021 12:51:37 +0000
Received: from PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::10ad:7f4c:f888:b700]) by PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::10ad:7f4c:f888:b700%4]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 12:51:37 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Ariel Elior <aelior@marvell.com>
CC:     GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "davem@davemloft.ne" <davem@davemloft.ne>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] bnx2x: Fix missing error code in bnx2x_iov_init_one()
Thread-Topic: [PATCH] bnx2x: Fix missing error code in bnx2x_iov_init_one()
Thread-Index: AQHXUVUrqUjBSZ9P4kK5zYgbsd0vf6r0JZTw
Date:   Tue, 25 May 2021 12:51:37 +0000
Message-ID: <PH0PR18MB4039B944D4D822A168428DB6D3259@PH0PR18MB4039.namprd18.prod.outlook.com>
References: <1621940412-73333-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1621940412-73333-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [49.37.150.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 637070c8-8e35-4b5a-0e7b-08d91f7bd597
x-ms-traffictypediagnostic: PH0PR18MB3991:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR18MB3991D9CDCE316C69A6DE371FD3259@PH0PR18MB3991.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Oa+63hK7+7c11eneLaBQz7593pqgMpMTlQhJ7z7wqos2UyHryqjg440j+KpHdVsjTWclJg86kSvnf2SgLQMZaf5wIrPqMmHaj2f7ITHGL2uOsMEP1KvaHnM59MPgz6cG6bxYLXRZMSmQ2MNBzC3snLajt3TCgOkbL9wuuFOZAPbpZmaewDzFcX9qHSEm8+ho2aDSmp4hi+jjXJ9HOZhJrwzN9gRSuyR8F6i94OlvqZbpwjyQD0lyQRClIa9dA1zkhaWb9MKJkqoNb0ZbEHnIK3OxmIWJ9mk91R6N7l9lZIf9Zp5wbRDTi0KczM1H76XO3Y3jRCKwbIkAYXQB+iOczuO8X9Z1JpdRQO+8RZDno7NC7PQx59xx3WM80WoexVhijC4z3TUSm0pVdQVSLSxeK9kkvp9lfmWGPchkJm/yQNH0wsbHy7ieVgJK19mevwRHOfZhkIbHdMJyypGrni68IXjG2v2iwCH9NHSPYfx0CA0+prorVFCG3eL46e2G2kXfnVxHgiaIKgv3lIALdDnuai2nAuN8U02tKqQ1CsJwUuhJlB13vHdCgUkr+T782Eg1qcK77q8y6limQ/zscION80UxBu38w/LKb9wKUyq9ET0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4039.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(136003)(346002)(366004)(396003)(186003)(5660300002)(6636002)(7696005)(54906003)(53546011)(55016002)(86362001)(110136005)(2906002)(316002)(38100700002)(83380400001)(6506007)(4326008)(122000001)(64756008)(33656002)(52536014)(76116006)(66556008)(71200400001)(66446008)(8676002)(66476007)(26005)(66946007)(478600001)(9686003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?OZ0MjhGNvNgh7NZKXfbVyDtsRfhSeW3yW+/wIX+H8nQzzBuz6geUA+7/91Mc?=
 =?us-ascii?Q?T5IyIZyaSyCMjVggQPUffkiDpNRf2d2R5rrNc8Bm8uv/yjM2CsDpGn6K68Yr?=
 =?us-ascii?Q?fPgSs7O2mK7YbrMGPZbe091hzerWqV9Ft+rRy7w3vCQocBqFN8En/s8WfDzF?=
 =?us-ascii?Q?RLj1H24mMo6xuqKP2UZ1voFKB0vJfvTzpItowdgsFqHylCYOTjDtNM2krIXE?=
 =?us-ascii?Q?P4MKS11tKLjV35aCZzHyiiGwlzYC+MnPAjFX4kbodcfGXWmMj9rXJo3h1f2P?=
 =?us-ascii?Q?ygRAAV3k+/HHGWjMINjFW3/rALXeCB3WUbgzrJBlrs0wmGTWPV75g1aj7MGC?=
 =?us-ascii?Q?lSQdItDiq7UBGrvrXF/5ufx1HMfYmxC/D90t/JLq6XCeP5xEIQOFLv2Xb1YQ?=
 =?us-ascii?Q?bgj7Imq1UMI+V5eGLLyy3bZIzG43zKCKEvY4pdJzN2tKJUDHVF20JoZxPx35?=
 =?us-ascii?Q?JgLt5XBtMvhCjwB48gUlV5Oj2Mlcoid9hw//9pPqVcSJn64PYhsANDHYRVwC?=
 =?us-ascii?Q?LVuasEObdlaCpBdLMqTIzG+ku3/plIT2JufvsVydAXUNfTe1gN6dJPglUX+W?=
 =?us-ascii?Q?/5XpYOpFHVzOSncB2S7KOewsX7uHL4nTW6WahoKMS/bvBOYF760nJZL5WYl6?=
 =?us-ascii?Q?ZBNd1LoXVUklNsT3PsctQ2FazqHJnJWubmY070AxgKIYynI5jwuV6Qix5MCK?=
 =?us-ascii?Q?TuwmuXSOtoNPM2kse4quvsvF7I4BYmlxP9ws8hC5gxpzCMV2mnsMpQN2YFNB?=
 =?us-ascii?Q?JShrSpOeiOohHl2OBijDCY1dkwm6LQg1q1b1UxtcKAtQkCKg1cNRGc0FPNJu?=
 =?us-ascii?Q?s3BALA0/5TZFJccPxcpjG+KqdBIgDYtLbnO2IjUASDV3Yi4q+ow3ZU7+Ck1X?=
 =?us-ascii?Q?SLD6vvVvUL0Kt7nBh8OKK0CLohEXQGsQkSsNMz2qA+5KXvdhBt8BMsPHa3d4?=
 =?us-ascii?Q?ekXThCzKIbtuC1gsJ6dm7AaS1e7oarbL6YUzzJwGd8BfTQXZTk8RYGMbjX4B?=
 =?us-ascii?Q?jLoN18vY1AKwUMgEMIA8PkgddoArjIuSrKdHcV2T1FTEEvj3w+LKRmglRPiu?=
 =?us-ascii?Q?onViyHg3aD06Q/rRKzPTv1R1jezKgoaGmekAtwAmNIwQ5/lnXBzhbjZObPVY?=
 =?us-ascii?Q?xyglfzxDT4CxmDMAYn1FLoVJ2riYAQDG1ToGA2/YHHvCHr3xbkHRhVhgpCVu?=
 =?us-ascii?Q?iUfEkq/80XHRML8qOOSIFjozs9ANW8apjTaupV0A88wPD7/aA3J+17CdICDg?=
 =?us-ascii?Q?sdfDWiT8stblBqpuDnTTkPPK7xoHLQ/EdnwZHEPiVte1pCDMm1Ya9gGnHYDB?=
 =?us-ascii?Q?G7zsCJYmPetQxRI/3h152ukO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4039.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 637070c8-8e35-4b5a-0e7b-08d91f7bd597
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 12:51:37.2997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SRSSkIAEMfQBbgjCwvItMxD9MEYY8oCpt9szH1ufErfnIkzQhOTcOf29ppJ/fOSUXLojjUcMQ+cUk5Rf0hYbGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB3991
X-Proofpoint-ORIG-GUID: Yl7C8FemtXzfDAwQ9QuxIRF7akEKCw3A
X-Proofpoint-GUID: Yl7C8FemtXzfDAwQ9QuxIRF7akEKCw3A
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_06:2021-05-25,2021-05-25 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Sent: Tuesday, May 25, 2021 4:30 PM
> To: Ariel Elior <aelior@marvell.com>
> Cc: Sudarsana Reddy Kalluru <skalluru@marvell.com>; GR-everest-linux-l2
> <GR-everest-linux-l2@marvell.com>; davem@davemloft.ne;
> kuba@kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Subject: [PATCH] bnx2x: Fix missing error code in bnx2x_iov_init_one()
>=20
> Eliminate the follow smatch warning:
>=20
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:1227
> bnx2x_iov_init_one() warn: missing error code 'err'.

Not sure if it's false positive, variable 'err' is initialized at line 1195=
.
1194
1195         err =3D -EIO;
1196         /* verify ari is enabled */

[Changes look ok though]

>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> index d21f085..27943b0 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> @@ -1223,8 +1223,10 @@ int bnx2x_iov_init_one(struct bnx2x *bp, int
> int_mode_param,
>  		goto failed;
>=20
>  	/* SR-IOV capability was enabled but there are no VFs*/
> -	if (iov->total =3D=3D 0)
> +	if (iov->total =3D=3D 0) {
> +		err =3D -EINVAL;
>  		goto failed;
> +	}
>=20
>  	iov->nr_virtfn =3D min_t(u16, iov->total, num_vfs_param);
>=20
> --
> 1.8.3.1

