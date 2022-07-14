Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B318574FF6
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 15:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240206AbiGNNwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 09:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240124AbiGNNvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 09:51:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0236662A43;
        Thu, 14 Jul 2022 06:50:47 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EDcshK026590;
        Thu, 14 Jul 2022 13:50:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=LNnrI8GvhsFqQnbZOzDulOGMlJYd8zFu0c+iz4dxq0c=;
 b=a/rNuj9J6ReUjPSgyfEpQEyugkYQCGthUBf3jAsbLXhk6j6p7+VyIqmHabaO1X5Nelf1
 9Xv7GiifvEGncfM+qAEdLEn4hsFDx3EmezPQKZRPOtkKqAmXCUg61ZsHB+6FK4g8tvev
 2Y1ifUuMam6tuc8RuBS7uZM8XZ452LgEh36UMcvazGGCyw+iFiOvEFTEq6qizAiaunSl
 axpsXBBvYXWkRGDdljCjTVQEjjoYSFYir6ZAz4WnElykToOzlLYxvKyyCmoHr/nYvwRi
 z1hBVDkCCa1HzZHtNxoRl0+/DmGy+haGiRr7lXqMW0WkLuFvPaJ6s4OkdpewIDc2SiKH rw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71sgvj2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 13:50:19 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26EDermm029321;
        Thu, 14 Jul 2022 13:50:17 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7045tbj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 13:50:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GmuEuerOuj3NAkG6C/M07r29HOtJJRewMoaT1zCDcUSBPeVKt6aA6c+HIucwxZ7zudmDIHeOTxHlWEHBDE3xX335jlySynXcC4OYpgqdJgdRw8zdiAg6warMK89yY5Z26tLCp0vLIWyPDoP4oiOEUq52ZkrePVf4nnQ1r1xK8+OHHsbPVd6B0mBriO+HlwW9hnqAbPp4l6kEh4GXBEWr92Si4eQEizSQIzC+a81WL6mGmmv41KZoEQ1ZmBgepunQDs8zeGouCjg542hdF5UU5z/sQ8FpZCxfGsCQkvokuqFrirf7BgDZv6/A0tOsnKXSSOJuR5fl70JtHPYFlaHWIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LNnrI8GvhsFqQnbZOzDulOGMlJYd8zFu0c+iz4dxq0c=;
 b=Yi4pep5K3Tcb8PyJLLfx0mTCjf1Ccddkx4L3PYO9TU0CujAxl6Cu+vIUW4Hfj0/a7SKZ/eAJSzrZs/PE1YSv+0fMpM4Axd1zCxwBxW7aKnpm7OzOgR0VGtTIOF6j8Z0YuVwumj0KI8Wo74yv2mffvmVjeC3+dvwILfjFwx+bKmcfKBsO6M2cB43JbgXKLgUTcGgYI4xfFWmXlV+hTvt66dc1a589/Sl5FcNhMsIHcEPNchJWdh6tn3GrOeIZKfN5xo6hh1TpIE68NGCCXHxK4JTleJ8g+Lk9YFBgKGPVx37mnhQ6+T0YC1vQw2VoBnLJEQwkx0CrIw4Jpto9AVKaZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNnrI8GvhsFqQnbZOzDulOGMlJYd8zFu0c+iz4dxq0c=;
 b=vMVbKEzcyYp3iwgeoc2f61Cflmr6BqVlrq5Vy+KbBIV7dcF+U1yRqPOX2FmsXcCh7LRjzWysAQFgJJlo16ybeNtiM07Wa74Vc9h1oDXbPHuV1ZKI08G1biECCCFCKcK7YeFjoTmpe2UfpQcyQSxIqY+AcF/b2MVdyXB0A8VFKhU=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BN7PR10MB2513.namprd10.prod.outlook.com (2603:10b6:406:c8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Thu, 14 Jul
 2022 13:50:15 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::8cc6:21c7:b3e7:5da6]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::8cc6:21c7:b3e7:5da6%7]) with mapi id 15.20.5438.015; Thu, 14 Jul 2022
 13:50:14 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jakub@cloudflare.com" <jakub@cloudflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] net: Add distinct sk_psock field
Thread-Topic: [PATCH v1] net: Add distinct sk_psock field
Thread-Index: AQHYlsSNzQGYXeKSYUuwAiRr7dGBLK19GvcAgADIx4A=
Date:   Thu, 14 Jul 2022 13:50:14 +0000
Message-ID: <B5485F5C-6E83-4186-9664-A8484848DE08@oracle.com>
References: <165772238175.1757.4978340330606055982.stgit@oracle-102.nfsv4.dev>
 <20220713185136.0e3c4fb2@kernel.org>
In-Reply-To: <20220713185136.0e3c4fb2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba86cf83-ef8f-48ae-79ca-08da659fc770
x-ms-traffictypediagnostic: BN7PR10MB2513:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G66qOTbKSVEJQXHbT0xyILGjOJZo6haN7prEp+JXb6L6inzghGjS4kvQ+uQIoiqtfW1UVnSNQLY/uWviAildsalIeJn2zdNOQvpHnmnRsny9aV7YyTKB56iMR4qrUm1gf22YbnFdfATxp7KbCXdp8PSpd5+bRJH69sad1alvFdVZQhTGGYLjZdSjCYGFFykvHFY0fqaB/rViiWhrRlccGBRqomuVzvnFO2HK2cSB8KsoqX5sdV0uL/aQ4DW0OaUn4zzjvsEKTcy3BN8zewricKKaDMCEeAU+J87Prr7kL1nt5f9LXMlIrSms/CZt4mgAx0i0BGL2liQ9rOR9UU4gOsgdqAFIJQVXC9BQCA+H1elj2IfMmGOC43n0jyL3pZnHoR+YjL/w5KomcryNRYm43P1b6/vkPgeaS+X2vXC+/jE+NOBnCbSZcuAKbQjMPlo0kBW8NAfoZm7e0GswqqHAnPTy9VI5lJhTEU9SKyqN0vwPPG82HpffeBIVrLDtErup+0VddYQm7nKtYG0HXHK8/ge+k8knIIvusKx/Vrbzmf3T29zod8vmungJFEWbVpkeuNvt+EHgT4MSRtYNma+v5xd9VEIV7u56avpc+3se+tavsVTqRRuUe398jURMtaFoDWm1QjTGieJbJ6Cx8BVgFGXf6NxArHT58WMYqJ1qBqbTn7BtAjllsp3+zQ32kDbdm+R+v2u0NTeA0Q/YbUoO7sihGD5DH+HgQImRSUnO90pJOyXaibzx+A90UpfifpC8YV6/W6XC+kSbz8D2DchvtTn1GUYSd5zLyw47zRe+uJeGfgz05nGyGC7qv3XPI4+r16P2ihNf9TThhoXUqGKMwGhNZ5iXLye++cI99IY8kfQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(376002)(396003)(366004)(136003)(316002)(6916009)(36756003)(38100700002)(186003)(54906003)(6512007)(26005)(2616005)(91956017)(8676002)(76116006)(5660300002)(4326008)(66556008)(86362001)(66946007)(122000001)(71200400001)(53546011)(66476007)(64756008)(66446008)(6506007)(7416002)(8936002)(33656002)(2906002)(38070700005)(6486002)(41300700001)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hqxELx4+AtXFFq02nZ582qLHA4+iav79rkAaNLwWnR3xXawvc9P/N0/bAPuB?=
 =?us-ascii?Q?SWl65otnLtN2iB2XAKkxIEhAdQn39alNI1KOC8OB37cOS7vM9e+Sjl2betSc?=
 =?us-ascii?Q?efUHWR28UWqSZkIk1HRACWmC8BO/NFf9CeWM0jE4raNn94NHIdjhVBotI5Zm?=
 =?us-ascii?Q?8dP9pPxXDDLDFXFur+q4aaRIdswgjGAoXWLRsezSAhm1ogdSaJx/yd7eSebq?=
 =?us-ascii?Q?smedoj+gjjv1qLWpf3ogmCPhsyg9i9QTmNOJ7Zzj+UbaLwC92wV6I0wxtHxw?=
 =?us-ascii?Q?tMBLovWLyqauahCjf4NMUe7uNq/2ORkQYcXd3V7nPVhhCmi084WSXTMzTP4J?=
 =?us-ascii?Q?VVkD0hpjo0AePRZ3i6lPDWCJSOP2+UMSlez66BS21+zyVKw8mv6VFJiu8mda?=
 =?us-ascii?Q?5/4apyHDZ4OgVeniQxANb9BkZN/LG4msUbnqorioQUQal2heK5J5SdxOlRYS?=
 =?us-ascii?Q?OOX/mNwBC7k6K8fMmF2ZQ2NUd66gcZOUfc03L7Yhh+yBDaN5NcSLnylw6K2m?=
 =?us-ascii?Q?P6sYul55Qg/INz/EQUSpE5HpzWt2VitrexUsY6wKYQqoCFemXwgQ9gg9rtxv?=
 =?us-ascii?Q?B1ZxIunNTiIUH6VpJPu119dC8w+5S+6DW18mzgsoxeZdJbnldQMQ7NYILOWW?=
 =?us-ascii?Q?HL7WZsKO0V1GKdaPLFNSy5yCbuRI7kX5ICPwvv20xEPEAmKFXBOESCVC785C?=
 =?us-ascii?Q?3xkJ+9vl8E4EFjF6OxhcmmkiAY/OJeG+rVkZPbEaxZrt/ytrbZDTfYw9THc9?=
 =?us-ascii?Q?u+c6OY90RKMrQjaf/Z1EoQC+lrE7uRoXdkmIFf/3nqRdn78Q6PEg8uRhFdAH?=
 =?us-ascii?Q?kzqdRStPvf7vdURTkPnV+bQNNFe5l/+/faqTcDPdPFjYS9X2Q0cQzbva5HNx?=
 =?us-ascii?Q?jmqT1dUJTI/Q0YTe93GsnFxie4VCQbQ1QyUxZTBECqArzNxQ9Qp1pH3BcdbZ?=
 =?us-ascii?Q?+r2NKcYK8JGmp++zzSj0Yb0ptgVozOfeKp0kv+aSSwM6PvSrxgGbQSmciF1l?=
 =?us-ascii?Q?TBwrZavdbtN8UTPM0SvOtzB6cNeuKgSEq9BtOaCi7TRgRsdjHenXbpc5aFeL?=
 =?us-ascii?Q?9SGm7NWsQMCPHyjJrSouZhavX3YHeJNSeSV8/DYRC6NzAnK4NxAg2+KDN9zY?=
 =?us-ascii?Q?eITL4JCAAF4H0Z3gUX2q4N7E/RoDTJykmyiQ+h5a5cH3mgq6Wp4c4J78OBkg?=
 =?us-ascii?Q?XPVeP0DdzQRMDQGbponwm9+DKF6hfcWl+jQ6lQNAhFhGP3NAvqnfkAfJeh9D?=
 =?us-ascii?Q?YK4oQJ+pYSc5JqGTZqvAr9+iDkJrJrmjnyTvSfeyDam5Ad4/7c2McDdhqBtZ?=
 =?us-ascii?Q?+ep2dRU1/0UqfFZQ51fmqChmOboKju0Zj9Pws4dQBMGV2JvQ7D8Mmf99GFMY?=
 =?us-ascii?Q?rTBBGNOnwRXhLYxvZRPcVFAEov0FIFRheGX9kSIwH02qzV/tfNioyR0TVEYH?=
 =?us-ascii?Q?ska1X52zQ88k2K5EAK5RTESVHflGkcls/sS3DPRamOxn+HETMQ4iM+gRObtN?=
 =?us-ascii?Q?YIoAYdRvMLllsv06PJccw7vckU3+0UlJi2fIlvYoYGsacABx23Vp09hAMoiG?=
 =?us-ascii?Q?//vZZkGK7Ty76HgBd83jv8xCfxccqdxSVD8gEy0T+jpycRpf4O2LRybLHERD?=
 =?us-ascii?Q?JA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5AC9529734A66C45AE07AB94E79A752C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba86cf83-ef8f-48ae-79ca-08da659fc770
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 13:50:14.4402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sI92Ch3+vID8/a9mUH7SlcTJiUV0mEQcC93qc/sB8GcEdui5OSSLZi71vTYRxY4pXhGrT2pLQy747clanxmR0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2513
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-14_10:2022-07-14,2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207140058
X-Proofpoint-GUID: OWjD6FKbYl_MEzaYUitI2HMJmSDmt-NJ
X-Proofpoint-ORIG-GUID: OWjD6FKbYl_MEzaYUitI2HMJmSDmt-NJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 13, 2022, at 9:51 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Wed, 13 Jul 2022 10:26:21 -0400 Chuck Lever wrote:
>> The sk_psock facility populates the sk_user_data field with the
>> address of an extra bit of metadata. User space sockets never
>> populate the sk_user_data field, so this has worked out fine.
>>=20
>> However, kernel socket consumers such as the RPC client and server
>> do populate the sk_user_data field. The sk_psock() function cannot
>> tell that the content of sk_user_data does not point to psock
>> metadata, so it will happily return a pointer to something else,
>> cast to a struct sk_psock.
>>=20
>> Thus kernel socket consumers and psock currently cannot co-exist.
>>=20
>> We could educate sk_psock() to return NULL if sk_user_data does
>> not point to a struct sk_psock. However, a more general solution
>> that enables full co-existence psock and other uses of sk_user_data
>> might be more interesting.
>>=20
>> Move the struct sk_psock address to its own pointer field so that
>> the contents of the sk_user_data field is preserved.
>>=20
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>=20
> Thanks for posting separately. We already have the (somewhat
> nondescript) SK_USER_DATA_BPF, can we use another bit for psock?
> Or add a u8 user_data type and have TCP ULP reject if the type is
> anything but psock. I'm not sure why psock is special to deserve=20
> its own pointer.

Hi Jakub, for an informed answer, you will need to ask the folks
who maintain psock. My guess is that kernel consumers might need
to populate both BPF/psock and sk_user_data concurrently for
separate purposes. If concurrent usage is never necessary, then
you can probably get away with a small enumerator that describes
the content of sk_user_data. But after some code auditing it didn't
look to me like that would be adequate.


--
Chuck Lever



