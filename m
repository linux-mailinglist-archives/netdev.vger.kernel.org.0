Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A9C6BFB88
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 17:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjCRQ1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 12:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCRQ1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 12:27:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57C2A279
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 09:27:06 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32ICuGA6000686;
        Sat, 18 Mar 2023 16:26:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=+BaSz0QAFc+acwgGffT5oU8P2jAu47S8DKn8X1U/fkw=;
 b=fkE0bbCl5G894GCSIw2mAT+i1r5vxBKG02gTIsB5hRK2lFNvbHpGc7iyL89gQWj2ZRA9
 IPwdJ4OWU//8gb7Yxuv+tlvxdBU47xNGHSy91Q+HGz+QgrvPuV+OrU1fD109r/zro28K
 mSPAClJptcapw1OSUFOLjTNrCl2SyYCbsLqDmkhqk+N+lF3CikjWfxLkTxdow14AMjGk
 4wrcoeaDefZHrVlfygjstUrZXjra704fl52KcJtTbaoHhsZVjMRWo+ZhpH081OH68VMt
 5IzZeXpquwHbB7X3w0v0rhW02t7LGQ1VQTZpX71X+32WBwhL67GEdu4iKYXSYTpABDrX rw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd47tgub7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Mar 2023 16:26:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32ID0HlU005849;
        Sat, 18 Mar 2023 16:26:47 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2048.outbound.protection.outlook.com [104.47.51.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3r3ht3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Mar 2023 16:26:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrZDHmrctP9Ep4I0IL6uwHWH5vewyE/eHsrtrPOte9XE399em6pyvmdYbdp7hulXEmutCd+FcQIvHcoJxVTjSWZGPdiDtuFuGwIbRTNy3JQszfg7UmdrGs9qJRfNs/OVsDve5AuLB4EGLaiZqn/1/xDghR7S6mR6/fPru0N7mZ0zvO5oVjMvK+ev2SRfRSOTxLKHgqfX7Zo9cwl/2HDWZqKQ4TUT9gRbI1KoboPqv0/FNzyj9HX8t2vK6vM/mitjBEcedloxj5mH/XOLv76lfS4AHMVydt+f2Ju3w8zxDI1flc/s4Ch5xiE5WI6CB0O3dZcA8IUEjNlyZ6EY8ywXHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+BaSz0QAFc+acwgGffT5oU8P2jAu47S8DKn8X1U/fkw=;
 b=AGhY5Kux+8LYqJVBD/Gl0OMgi9VB2u3L7d/3zhESWZURB6bZVC/PFNUl4Atjq4mRmuBrLs6FC64oRaQHw34rAlV/pru8wFfnSdrchSLLj3UBd/Ewoo+tPNuGcegcJBpgIatWUtGgAXk5KP+0fMJdpRuu5E3cGVT14cpKMC36+yzAk/cy5McpVPxhtnQSTAeodWVhpA0/kE7ehLcEL4aq7W7nk3by6zE64ZHvoXqpOT7rVaDTObbnov6uV1f3tRxf8H9vUpMmfk+1jcbVk7KobXvEh2ErPNpbLVGYUH07+ypklW02IMVh4f5iKuH4q3I9OELkqdCN0O7aeqC4tzlBwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+BaSz0QAFc+acwgGffT5oU8P2jAu47S8DKn8X1U/fkw=;
 b=I9HYQqAIXU3xXbhQHstGmCR8UBNn+rVR/JN7LPsOT1FX5WauNIlpfcL4rc0Uv7QZ5t8cs7vmWt+wEeaDgWA0+0IhvS9GUDswIRH4gsim2eTXhI9hRZgYedVdQFSuA+xiOlLRsSghXNNKnXSTZPUhDgd1jGqJP3FSTxtHXxXEp64=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CY5PR10MB5963.namprd10.prod.outlook.com (2603:10b6:930:2c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Sat, 18 Mar
 2023 16:26:45 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6178.036; Sat, 18 Mar 2023
 16:26:45 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v7 0/2] Another crack at a handshake upcall mechanism
Thread-Topic: [PATCH v7 0/2] Another crack at a handshake upcall mechanism
Thread-Index: AQHZWbVC0xQOfSnFMUKmuVnD61fXcK8AuXAA
Date:   Sat, 18 Mar 2023 16:26:45 +0000
Message-ID: <70E1DAC8-AD24-426C-9A27-A0F6C0015BAF@oracle.com>
References: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
In-Reply-To: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CY5PR10MB5963:EE_
x-ms-office365-filtering-correlation-id: e3a36f62-95c6-468a-d06c-08db27cd90bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mIzwxh/dY9IU46Z8wfukHRf+oxy64lTqeM9RJR926Y7AnYP4AEacG4a3tLZ3UxX+cYcFXDj1TwiBJvGCj/fCPFOr+w0UJIft90fQH9S30Cee5GiwnkgnUluSbxo5oCU3ngV1NGSTVuxqyEJapBTv91ob9OBWALs3XyDye1ggc4AZae+GXRUlS8EXz3SXZS2McZJ4IQJqjpDxztLq8xFNB62jF3ePMM2J5ZbcGkmV6DtQyxWA4kWvsMafY1OuNLjcIst5qmIQascAYcOIlOYND+EkDjmf2efunASvC6HYlM0d1ljRPPGwp7Her72uCs+WPmj7RUuS9KOMktAX0UbZwQaJTnSXO1Eb9ZEVRN/j3PiFOmOa3VycrkpUPCsb+Ouoy22XOR++cnL1TBUV/98jIitaw7fYnPFA45c+jEHQgbQgxcidn8bEFHaQD/RkQ1tPfIVRp96jOvI7KOnk9vqLctcP0m/64qOeNqLPWOIgpw26kW76AIwNrnE4see6aKbf6lBSeutm5jvmcIg0Bb6A0E6as0UCkGyqkSieT9/bBDnNp+ljHVceJqOe5wfzXI3COnpyoQ2QTNxzo2goLiAINzwXcMcP7W0kiGK5gpZ7f8hxdXke7Q9NzeWWnvo9WkMYu+L8w7ChkY9iwn1MGMTC4U9ctIaDj5XogdF06+IuHFTRvGpEcWrj4Q83qiMS4RWarZJ8aq/bjKnbRD1aFLucBCBR3TTSEgnXjbxb+R92EC3x2mHh73/k4R7Upcn/mteslx+6P5p4Gzpa4L5an4velw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199018)(2616005)(107886003)(6506007)(26005)(6512007)(6486002)(966005)(186003)(316002)(91956017)(71200400001)(110136005)(53546011)(66476007)(8676002)(4326008)(66946007)(66556008)(66446008)(64756008)(76116006)(54906003)(478600001)(83380400001)(8936002)(122000001)(41300700001)(5660300002)(2906002)(38070700005)(38100700002)(86362001)(33656002)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FsbabVZmVyeNDcrJcoJZ4Q9ObYfDAwqxEz267ZVtkhq3Y9r0WofUiAShaF0N?=
 =?us-ascii?Q?gj4FgZYryRxaBMD7J+7w7YHgqlbCAcXkUm5g0gFtsuvItlCo3OV5phuIOyCJ?=
 =?us-ascii?Q?4tCLc6cZM3s1i+dQmdNWjbbhLG9bZAlnrM8rw/6L9h7UUhRPrd8d8kp7LW0P?=
 =?us-ascii?Q?PrZtGNX6jgivRiha4jtuWn2mcmZJQ3XpG1gE+NspRIqU8OVM3g2W1JXuDKXl?=
 =?us-ascii?Q?WojmVz4DXdrXpSgqr+OX8rsmVCaadpuQugMbgQKBpQGLawW78mdCBdEUTTN6?=
 =?us-ascii?Q?tOtsuWEhOv6jh9VN5YuSSljoXqc7VPG45Eu/rLfM5mDgac3u8a+R3JMCB9Me?=
 =?us-ascii?Q?C0e0zROQ2bY6KgIbnpWAzCt8xJWLH9+qYtbxCp7+CoPTg7ItlTwJxsF2iDsn?=
 =?us-ascii?Q?9ewlxABBIiZu4kqmyb0pkN1xrX9dL9zGP5bJCw/hAcB2pOpm7HV4pFho/E6D?=
 =?us-ascii?Q?qMFyWU9ymYoKZfgLqNpAQioeCKffv0ntBEC6/5P82T4OIS3xItnIw3O4KFNH?=
 =?us-ascii?Q?YYHBrpZ36bWnooUxgRsu1nSGKuFMH5oMg6tXIX+McZ084ebVdsGyR5Gvkpq3?=
 =?us-ascii?Q?ahWrTmDRsF0kOXv9YxLUJY5Ozgt6Q5xC/fFTpQhfj20G2J/bNfP0ApWOPpCp?=
 =?us-ascii?Q?IvR9qJDOR5zoTRFAmem/sj1WgTQ+Glfm9caeXJKfJtNvQ/j5kktVbQjBt0Io?=
 =?us-ascii?Q?H01Enz7nnpa6QmL5Z0fy9+Th1EPF8/FQo7ZwAxetoom/MFubATGWNpvOl8Z7?=
 =?us-ascii?Q?UUoaQCsR0n0M9YtjcWhMPIATSR5v+e8XxCNdm7RhS3/EIsW/fLyo65qQ20zH?=
 =?us-ascii?Q?RwhgdIalooy9nOWTdymjDaYrqFaF002wMMsWoAxzhnHvtsTrlyNnHkT8US5N?=
 =?us-ascii?Q?vT7dcKJt9Ra206I0g1Mf9Co5ofz2m5AJ07jVfrKs6d7QDG7coMZ/7/QxjXbV?=
 =?us-ascii?Q?XNS3rkzenV4f4Yn4KWKeQxr/o7gLJnL16D3mjOE0J51JLnRg/GAbA/MzHeFJ?=
 =?us-ascii?Q?vp1O3TI3/ML7r2bJrtMP/E4lqqAIGQvPUvdy49r5kg8qnuk1CMN03fPPd425?=
 =?us-ascii?Q?Jnoucmt6PSNZOXpkkJe6iFTQsmSte/yyHeAbabtWlv1ErGchjmT8YhqQuYhK?=
 =?us-ascii?Q?UIIduVabuz9Ml5iUv/E/T8vt96LKNQf6CYbvp+K6WxUIL38u+NwLOqhNt5kC?=
 =?us-ascii?Q?DOaF3U8EKivk/mNgBqoGMbc24Qo0h1e3dEPKfMhzfDCUE4LQalRb7z062lly?=
 =?us-ascii?Q?BadQWg1DQrHMH6bxuWWWu92/lNhByoKPacaXFmDbsd03ARtopcGUMpT+oe92?=
 =?us-ascii?Q?YDDhhMEyqThTuFyG88Z7f3eh8CHygVTMOWwN4TLS9XYXv/Fwagt37T3WyV7Y?=
 =?us-ascii?Q?Ecthabz1Q3UgtOJtKX1Tvo1JN7Sv7182j+rq5IAG2y3Tk2+F6afQaEuVFza+?=
 =?us-ascii?Q?zXtjDM3OefSjK6NwusLlJZHBFB6vJ8QKQ3TmMDO3HEdX0HZkOCRZaStrCxjt?=
 =?us-ascii?Q?2xWBr1O9eSQyc+41ASK47RJu+vJ853Cfu7weX7wn+4+QpIqRQXc8On+Guyij?=
 =?us-ascii?Q?xwDSly45XhKvKbjY5LJW1tjVdhznynpOYh5Aog+0ts6ZzRDlfoADztJ1cSZr?=
 =?us-ascii?Q?/Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8D4FDB3CABA3DB47A9052B56AE46746A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rn6DzdCKVf/m6UbvHjxMtxIUDhl5BVUubFkXLDRNUr4cbWJ3R7Yra0fNbr+r5FPg8eoR1UDi3A4eQ7z7VOx7v4n4fRG6nu54pd0s0DbL1ai4DTKniWyFGDw9nD1Kw44LSJKBodxi0CIs+MoRRXCkdqLiJDGaVoQIQAZjJQl8vgJey/srj5YD6TwvI4nsOZEHdPYn5Gopw24t6thFXt/B/3V95hd/s0OsPATfp53/E3z4/uCucg7GklEZh3fpbkR+IucF9Ltva+pkOb3yTXPY1FBWI3lzBg8BgWs6umDt/gp9+gxAbq+0/4mdqQAdCi25ZIOPAdaxOqyQW5CB4EIVOJS0gISMdMz070BpcLLBP/z5NRnNSXuUqSAnrY/NZUdV9ihNj5k9XIKAOdLiutcVBRvJwyfkdcvfDPVKzJozymmqMeXVNt336q/ZaKWc9q/2qK15fjcO0FGFWEp0+Zu7zJJDhLuuRLAv8Wqd8OBUKuvL+PXkitFkfdG2XTp4+ryRsxZW67+j4UZFS/H8L8njBELYl5TtcDxzdicO89GnKR+KTeRO1xUhfKyas1WKXhdXwWMPHIC9OZOw1ZlffzGS4gGVIM4t1+oj3nPgaXxO1EmOLnotyW6ZLQP+hooq5eCFfniAmbwYNHlo/muYQYLQ36Xs/LiNib8MZy0ZPZ82lCjI0+Xm51EoN9+StcEzggufVbF76DOry1Zp+N23qzocysOm7rk6qy8lwI23ubKHq6uhIqN8SLcP3osXj4x0M/LyDQpInlnbkVWpK/dXmAwFFgVyVtqsySB0j+mBS+cUjyeJ0RKuklrKbSDjKn78cvErp/R+QGQ60P0w8PVK7DfQ8/2nP3mpWynWG8KJZs879fBrue38mzq4h/f2ulD9YZJDlX0N/oceFqmQJWj3SaUOxQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3a36f62-95c6-468a-d06c-08db27cd90bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2023 16:26:45.2726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: amue6wZ3OmWg9sWdASSsLjGIJnOt1rQIqHNOHqvbvCsz0Em65CxNRrfa3X0gUORl9XIp8xzUdJrVQUxjfd0TbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-18_10,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303180143
X-Proofpoint-GUID: HwcoFpgquFfPKpTTM15d808jAK6N0iof
X-Proofpoint-ORIG-GUID: HwcoFpgquFfPKpTTM15d808jAK6N0iof
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 18, 2023, at 12:18 PM, Chuck Lever <cel@kernel.org> wrote:
>=20
> Hi-
>=20
> Here is v7 of a series to add generic support for transport layer
> security handshake on behalf of kernel socket consumers (user space
> consumers use a security library directly, of course). A summary of
> the purpose of these patches is archived here:
>=20
> https://lore.kernel.org/netdev/1DE06BB1-6BA9-4DB4-B2AA-07DE532963D6@oracl=
e.com/
>=20
> v7 again has considerable churn, for two reasons:
>=20
> - I incorporated more C code generated from the YAML spec, and
> - I moved net/tls/tls_handshake.c to net/handshake/
>=20
> Other significant changes are listed below.
>=20
> The full patch set to support SunRPC with TLSv1.3 is available in
> the topic-rpc-with-tls-upcall branch here, based on net-next/main:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git
>=20
> This patch set includes support for in-transit confidentiality and
> peer authentication for both the Linux NFS client and server.
>=20
> A user space handshake agent for TLSv1.3 to go along with the kernel
> patches is available in the "netlink-v7" branch here:
>=20
> https://github.com/oracle/ktls-utils
>=20
> ---
>=20
> Major changes since v6:
> - YAML spec and generated artifacts are now under dual license
> - Addressed Jakub's v6 review comments
> - Implemented a memory-sensitive limit on the number of pending
>  handshake requests
> - Implemented upcall support for multiple peer identities

Addenda:

- I volunteered as maintainer of net/handshake/
- Addressed "undefined references" with certain build configurations


> Major changes since v5:
> - Added a "timeout" attribute to the handshake netlink protocol
> - Removed the GnuTLS-specific "priorities" attribute
> - Added support for keyrings to restrict access to keys
> - Simplified the kernel consumer TLS handshake API
> - The handshake netlink protocol can handle multiple peer IDs or
>  certificates in the ACCEPT and DONE operations, though the
>  implementation does not yet support it.
>=20
> Major changes since v4:
> - Rebased onto net-next/main
> - Replaced req reference counting with ->sk_destruct
> - CMD_ACCEPT now does the equivalent of a dup(2) rather than an
>  accept(2)
> - CMD_DONE no longer closes the user space socket endpoint
> - handshake_req_cancel is now tested and working
> - Added a YAML specification for the netlink upcall protocol, and
>  simplified the protocol to fit the YAML schema
> - Added an initial set of tracepoints
>=20
> Changes since v3:
> - Converted all netlink code to use Generic Netlink
> - Reworked handshake request lifetime logic throughout
> - Global pending list is now per-net
> - On completion, return the remote's identity to the consumer
>=20
> Changes since v2:
> - PF_HANDSHAKE replaced with NETLINK_HANDSHAKE
> - Replaced listen(2) / poll(2) with a multicast notification service
> - Replaced accept(2) with a netlink operation that can return an
>  open fd and handshake parameters
> - Replaced close(2) with a netlink operation that can take arguments
>=20
> Changes since RFC:
> - Generic upcall support split away from kTLS
> - Added support for TLS ServerHello
> - Documentation has been temporarily removed while API churns
>=20
> ---
>=20
> Chuck Lever (2):
>      net/handshake: Create a NETLINK service for handling handshake reque=
sts
>      net/tls: Add kernel APIs for requesting a TLSv1.3 handshake
>=20
>=20
> Documentation/netlink/specs/handshake.yaml | 124 ++++++
> Documentation/networking/index.rst         |   1 +
> Documentation/networking/tls-handshake.rst | 217 +++++++++++
> MAINTAINERS                                |  10 +
> include/net/handshake.h                    |  43 +++
> include/trace/events/handshake.h           | 159 ++++++++
> include/uapi/linux/handshake.h             |  72 ++++
> net/Kconfig                                |   5 +
> net/Makefile                               |   1 +
> net/handshake/Makefile                     |  11 +
> net/handshake/genl.c                       |  58 +++
> net/handshake/genl.h                       |  24 ++
> net/handshake/handshake.h                  |  82 ++++
> net/handshake/netlink.c                    | 316 ++++++++++++++++
> net/handshake/request.c                    | 307 +++++++++++++++
> net/handshake/tlshd.c                      | 417 +++++++++++++++++++++
> net/handshake/trace.c                      |  20 +
> 17 files changed, 1867 insertions(+)
> create mode 100644 Documentation/netlink/specs/handshake.yaml
> create mode 100644 Documentation/networking/tls-handshake.rst
> create mode 100644 include/net/handshake.h
> create mode 100644 include/trace/events/handshake.h
> create mode 100644 include/uapi/linux/handshake.h
> create mode 100644 net/handshake/Makefile
> create mode 100644 net/handshake/genl.c
> create mode 100644 net/handshake/genl.h
> create mode 100644 net/handshake/handshake.h
> create mode 100644 net/handshake/netlink.c
> create mode 100644 net/handshake/request.c
> create mode 100644 net/handshake/tlshd.c
> create mode 100644 net/handshake/trace.c
>=20
> --
> Chuck Lever
>=20
>=20

--
Chuck Lever


