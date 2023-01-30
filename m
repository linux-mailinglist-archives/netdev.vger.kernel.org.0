Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A279E6814C8
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238029AbjA3PVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238006AbjA3PVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:21:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590F23D091;
        Mon, 30 Jan 2023 07:21:30 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30UASuYx021351;
        Mon, 30 Jan 2023 15:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ao4gZyPPq0iqZI5h3uGtmEOAz2QATg/vs+Cez1+b4Es=;
 b=THu1DvrZfMBLMmbogEqRpbhHO3d8cFJjGGeoVXBUlFFhB9OsZ2hq0mY4u2Z/beIuc1vd
 ljgVeMOg1OXWsvhKIEMcwVMBLdEmsh5S2cSHnkdiHex5wXS+0fXKM/mOf8UspoZTfdJi
 FQrDyyUgPTxuITaTmLbVpHrm7Ob/GcFiERkg8K7CztX2E0QA44tm9A+sBjVryBPWFq3Z
 kvoZU1zHeC1w+UzJBKl57wKjPiA9W0U0zfnyuuBGdrrgbqQcnZE86I+MIAsshlStyIau
 QFkDErlwsSkF3t75LhhiBhZ4UnRa5lLuT07/byyO4YMwXn1ADELWo+t3ECnQKWsSEQP7 QQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvm135n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Jan 2023 15:21:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30UFIkfs024776;
        Mon, 30 Jan 2023 15:21:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct54g54d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Jan 2023 15:21:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LY6s5eNQTQMYnt7CEruEkMNFvxxWmTzSw9eedfiSCGToWeT23i4fpcPjHur9d4wYfO124pxssql93VnQELasJQKoHkR+Gig4m3Rzo/XFemh6UJ8aqjqnIzjEN5ndX6+JW0m+jizOQ9wRhF4D+ucvPK45DsrvaIOCLrSb7hnShUnRA3yT3ZvMyhZ/aC8TBFiq/sPqLN0lF3koZTo2w4YDVOYEr+mPUFCbYuNHo61/uXgkmxbA8jsdLdHKLH/YtaZZ9ssyFhGymEsx/enj0VXX6isPgsQf0cjhN+IKVy/cE+OorFqY2XbgL8q4RuOncYGfURYcaMGTP921WvPY4WzmqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ao4gZyPPq0iqZI5h3uGtmEOAz2QATg/vs+Cez1+b4Es=;
 b=Ru6eciRj8pjVY/cOuI0mgMOcxal2BlBK33I83SklndF/L16RYm40k8DAyArlu4HKU9D2+caKJp2qFyxI43fUl2RGvsW7oaX1PDaO7b0WTJWfrh9i+cnlGDqhZ3tQpM9O2t3wkiU6rJdydf4qqxvFdA6YxiF6OwJJtqbdYCXD1Pmz3dIcV9J/5J4A2W67zkAtP3MgMEJBCc2z+EVVxVcA+zC62qT0e/1oEPSIS2KCAPg1s8sGQ1HIAVXHrCEiASadM9WJ1Vbz/9uKsPT2AVyN2bVhzrfQOtNJErIiS2gZXi8yKh3ett74z6IwEq1ZLfmxUnvmK/oBlToanwm8HM/nOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ao4gZyPPq0iqZI5h3uGtmEOAz2QATg/vs+Cez1+b4Es=;
 b=IVM3mUT8HwpNaXR+Lw3oAeLcwG2ZxZoE0/Hdaj52UinD8k22nK2gF+Y3887LFIJwzUOUcN+dDzWuEtVLQfOPz2kC4312Hlft1HWMgnKs9nyp2zFD85bKvrjQdbVmOL6jkqKSNBraDAe0AwtE/XTjxCD/SUiG2y/nNpCNIQZvZQs=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH3PR10MB7118.namprd10.prod.outlook.com (2603:10b6:610:12b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Mon, 30 Jan
 2023 15:21:23 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed%6]) with mapi id 15.20.6064.021; Mon, 30 Jan 2023
 15:21:23 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Thomas Graf <tgraf@suug.ch>, netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH RFC] NFSD: Convert filecache to rhltable
Thread-Topic: [PATCH RFC] NFSD: Convert filecache to rhltable
Thread-Index: AQHZNL6DmnuOVVmZY0WaktzKRiQ+7g==
Date:   Mon, 30 Jan 2023 15:21:23 +0000
Message-ID: <41E7AC96-4570-4379-A998-C4E71977E374@oracle.com>
References: <15afb0215ec76ffb54854eda8916efa4b5b3f6c3.camel@redhat.com>
 <7456FF95-0C16-45C7-8CD9-B4436BE80B71@oracle.com>
 <Y9dfB322nu5d3fB1@gondor.apana.org.au>
In-Reply-To: <Y9dfB322nu5d3fB1@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CH3PR10MB7118:EE_
x-ms-office365-filtering-correlation-id: a82ea028-34c0-4844-73e4-08db02d5a5e4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9w59fW/iwXIjrEawu0iWdEQNsaF/Z2INt750PbcTko45cc7BMEMZRCuBe3IzTRo8Z7Kwau0B9bPYQHGRxXJ+Qr+vsSQt3wI4qcoyb7E77j4Fw3GAAp2857nN2z005iH4LWCKRMGhUmGNc0qh+dgOZAhYC///hRzlI5PfHuRdG7ccuY0ZcHarVsz6uxZbkGgNaiSRQCN+kdDRfHmBBlDcbFdgrJJ7BLea6BGitbvLa7E3Vit5gC1az1WmO/mzTeQZpkMRGrE2I0u4xGQ+PEPKn57+lu53Qvbum6jzHyi9uxbaqBDVoo1PtgBRiQ9M7DcRUaLIUDu507DkfOjWBRt8/9mQOKEUTgtPTy12aT2Oh9ViyoPELPyQrhQu0S10QFnC8PL2mtZQ6FgFrryVwa9i38sg3UvcopivxMS8QwbPXOxYN6UiScgFqadIZyC4rCPBDIAN4IKlxUNoyIiT9KDer+T7vYSvPp1SiRL8S2ytnVkzrHii4d4Fn8X1JgH3tXr7xgA5rpfn5Fh60uJ40Kjvj6RO02qMZdVd4P8R2uBWMYOESsNrUowvWoG3n2/zEkxGW5A59Ql9zkbsnXQ/3hsrGXMWz2dMpvZt6N62Sxf7e3VZJvfsxvAuj+6k57/GQvgX1k9uNutUZ3IOnQPnb8SRjwOJCgIxnxqt+yYqqG2HvlhEfQTxbIR4pGvoV64NuWq3M3/sNtDYr5m3EYq1Cm64eaBjFXU1SPFsOJv7OD7Ctuw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199018)(6486002)(478600001)(71200400001)(83380400001)(38070700005)(122000001)(33656002)(86362001)(38100700002)(6512007)(26005)(2616005)(186003)(36756003)(53546011)(6506007)(4326008)(6916009)(8676002)(76116006)(66476007)(66556008)(66946007)(66446008)(64756008)(54906003)(8936002)(5660300002)(316002)(41300700001)(91956017)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4gG7wrGmZAwjKd/1ZbGWhYJfC76hXII0f0QSoh2D3tA7TRY2Bt+lbb3Q24JO?=
 =?us-ascii?Q?O64RPEIBEvDq9kg4/BhKci/qGMxApUAf7M3XeG6islJc8b2V7/f/6wFm1t03?=
 =?us-ascii?Q?GwYCSIQvVjb9V9V3yqZxm0MdriPSq9BHGCXmJXFNCx6f/5NwC69/BSJ1+VEO?=
 =?us-ascii?Q?gJG33lc/ekFaKXXAAmIqoMSyw2U/PlzKc1M5YIFTvB6Cw+5tkigDKE3GH3ev?=
 =?us-ascii?Q?mrx8osEOZeZUgfFTVlR8pmjVWwy3a/DXfaFrgOHsnOJqxoH+fDgX/kK5Wsti?=
 =?us-ascii?Q?JBFiXrKS4ftKdosJDhx9yxWF4LrroSNBK9kdtO9hwdn/VGED/JeFOuD7yNaD?=
 =?us-ascii?Q?CHV+0hUkK9RND++YzI/SkIi8tfq25qfXAexD1BgiukbNglertKjlL90O47U2?=
 =?us-ascii?Q?xU3Igr+tgqCLdNTp5Lb5t/x8uz6ulFJGtMpXeAVH7XfSbylNPFWIpZjhXndG?=
 =?us-ascii?Q?dloFI/q9ttliw7Yks79sA6Dfqi1PGxXYfZhfCTZ1yoasf/pkp+MFInzLVoYb?=
 =?us-ascii?Q?+J6xGCoZ9zo+CZ57cwt4RQ337UOCrdhim9y+Nx1NmuyZM6RYbLaXpo/pAZl4?=
 =?us-ascii?Q?ZMDwZBxJ/AVaKd1Ec9vnMHjBO6p0It9r2FqPdlmGJku0Jkv/FarMH9DmmIrq?=
 =?us-ascii?Q?vbzIsv/1xFRUtnkEk9gepyyVmbN50d6ou5NvvUR1AZxOzasZiYr0Xh5g9gBp?=
 =?us-ascii?Q?mxZelY+FOQIcC3S0WAjsWKoWbXoU3gPuA2fThT8qPjY9jS9A8lytGEyda3lY?=
 =?us-ascii?Q?NpKr60SH3f9fT/ue+h3Mjr5wgmNfc6xPXvhFzpBqVpxRs4l61jipwWQ1qDMJ?=
 =?us-ascii?Q?92U+K5+K0Sg1PfafpTRhTxcTDIoc8jk5ql2bkHESL8gXfzpf/qPPoNxti2mZ?=
 =?us-ascii?Q?5ycger0t4eVWkNGKMAH37WAor02kmabr7sIK9rOLQ1Gb7YW4JTB+BA97pfLF?=
 =?us-ascii?Q?vgeOE3pyu0FBFvF2DMWVBlr+yEVoj7H9XxU/8AXS0gbphCR73Wb25IPVIpjy?=
 =?us-ascii?Q?wnlYTeSCmVAEuZ7jYJYEmjoOJmMHcx544tQ4MDoJ/mC0T30g2DrJiElbyZhK?=
 =?us-ascii?Q?uLF2tOweRiIqPj2R3SEkN1QOIAJXD61EG+FQbQtHhhHEe9O/vcFL+FRqylsf?=
 =?us-ascii?Q?kqyACDT6EyDegkX3VqFEiEg2fPMMEZOOW0KDnFY7oCqNWX2KTyGfeiW26fAK?=
 =?us-ascii?Q?XT86BxwuxUiIcx0xTZ7f7EXZqCXI6fkGzUJU2RT+XRNaM9l1tQgkFwbVovje?=
 =?us-ascii?Q?F5CtYJhrzrg4yGZtz0vrPVmU5qoSYf/YIXmv1k+XgCEIVhV+LP+D/TSymdcQ?=
 =?us-ascii?Q?B2vztJ+eY+dTReTmIuYz6p2uOichYBETuBQrKXkTw3EOMM4SXxTXXGQxcnZi?=
 =?us-ascii?Q?tYmdu+0PJXQamBCCQyAuXr7N/dsB2LAxWVUah5AKzs6DTiOu1p6zuvmwzYlF?=
 =?us-ascii?Q?lEetwx4h+oBzmpPq96Z6cWbgP+n1s2CLDCh87KHr0pywTsHmGPhVD1SGYCkp?=
 =?us-ascii?Q?NqWbhSd6rDswyFR0oFBnYBsqrF1QOVrjtlWGSvScpq2WbhzRPrtsGfwZbPAu?=
 =?us-ascii?Q?FSJMo2dNJYIYdpUJeT8bF0dTTPggUi2lriBfeSZHCLaPFBPEn7TSm7M3NKfK?=
 =?us-ascii?Q?iQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3B4C8842F748814CB684612AF34DB948@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: S5k0yjWIxWgYxCtHwDmkzGOZLslevPZ8uBU0g2yboz+v36EIgzdNA1IXOC009E6wnfmmG3S7L5BGZNxlXUuPaEF6BGiUj4fTBiwiesPnJU7dPO6STlOzAdSyzRRXBNL6oVLYzgCnaSXseXpZqkOQ+vbMpp3qdYO6wXXRfHfkZ9tEtFMCFhZ3079jASYweGHryvbM2x3oyEFPuRPQx3vVRhoKqknGRDLly4y0MwYmhbKLX2aqnW48GB653OdIYOl/L4xtG/DevSiD2aIxaTctsnc3VBkcveYF/+fW/MFoatl8xVhBFHTEkjYIvHgOsf4P5epa7g6XLBnsfZlIHBQ+alpKEQ6X1UAv/HOdKWNYC9rAZAeSJ3zJ1PIuz+vDJRUdRMAzcNBgzbXKvahLaAtwK5uycOPb6ipN+HfTgxqk6294iG2fR/IF2AhOGIFQ7OCY6V4/JSIen0MCU41zTxDul6RiopBxyGp8f/J/OXwRT3RLzV1XpKWPHlPTFv2YImE90CF/aA1Kc08pIpkUkXarkZO54K91yUTidfbAOaHp/r/giUGmHSyCdsuZtBwtQgUo56KvUbZDAxxmvZdbMi1SaovcAVJRlnUEElGq/KG92t9RFuo6Tg97lUumAm0G3LmHTAw5RBEAOPTHJiqWqskEp5lhUBTT91MCDK0SFyDTol28lYaDD9xlAh4Wx2e+sbhXZAnX+TzGbycS7LySHD6zhBOB7JRgHkEYLCkzEv/CUNCk+3+kh2muBEn6PAdXog8DreBjB7KzBFpg/iPoCUhgBjFN1dJbL0E4OICm8in+Nv8nV25IAXpbFlTptPgFlpGfACjxrxJW0JcstzdJOyVMtA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a82ea028-34c0-4844-73e4-08db02d5a5e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 15:21:23.7246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2CMLnchV3KNFY0xmspba6Kn8Pm2mCwad4et11dJafXuzrpLgarllTLr79956kwJYLes1uk/Zq7Gbc63AOOn6dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7118
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-30_14,2023-01-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=868 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301300148
X-Proofpoint-GUID: Liud3iVFgxg5lURbolQAzEcoNcKa7xkW
X-Proofpoint-ORIG-GUID: Liud3iVFgxg5lURbolQAzEcoNcKa7xkW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 30, 2023, at 1:09 AM, Herbert Xu <herbert@gondor.apana.org.au> wro=
te:
>=20
> On Tue, Jan 24, 2023 at 02:57:35PM +0000, Chuck Lever III wrote:
>>=20
>>> I could be wrong, but it looks like you're safe to traverse the list
>>> even in the case of removals, assuming the objects themselves are
>>> rcu-freed. AFAICT, the object's ->next pointer is not changed when it's
>>> removed from the table. After all, we're not holding a "real" lock here
>>> so the object could be removed by another task at any time.
>>>=20
>>> It would be nice if this were documented though.
>=20
> Yes this is correct.  As long as rcu_read_lock is still held,
> the list will continue to be valid for walking even if you remove
> entries from it.
>=20
>> Is there a preferred approach for this with rhltable? Can we just
>> hold rcu_read_lock and call rhltable_remove repeatedly without getting
>> a fresh copy of the list these items reside on?
>=20
> Yes you can walk the whole returned list while removing the nodes
> one by one, assuming that you hold the RCU read lock throughout.
> The unhashed nodes are only freed after the RCU grace period so the
> list remains valid after removal.

Thanks for the feedback!


--
Chuck Lever



