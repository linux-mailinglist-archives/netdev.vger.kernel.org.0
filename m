Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1AA5128D2
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 03:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240054AbiD1Bch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 21:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiD1Bcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 21:32:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA45D2251A;
        Wed, 27 Apr 2022 18:29:23 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RKI0Su015475;
        Thu, 28 Apr 2022 01:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=4ZixdfxHRW9gxhYX73w4Es/G/t9x5ds38z/WVpjECCY=;
 b=mzek5rvqBC8tX0bfxEX9ZZCqmpj6fe2HBCB4VuTPL23KcBMfbf7d0Y3t/uv0qM5eOfvA
 juXT9vJKHH75XC13LJ+fYe+T41Oj6TexL/fFLlT7+NTW5EwVGtsn3VcwnAdeADtGDo3a
 7u3NrlGuwS1iA0E5hU9ORRsWh6uAYs2067ijNFQkxhUzTfIcU7rTIQjJ6i+C+Qb27s96
 8kLGYvvun3cMlR84WJi/wChrDUev4DxNcsAltJG1IeV6KctteJuFySwaQIzJUY0nSsvB
 7ZlDnhoZoW/WmXMADKSfqkCGWDUShptZV8tU22hIMwErKGPhgFhDCA6M4cbpDux9+v9b tg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9atkfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 01:29:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23S1BCSa012850;
        Thu, 28 Apr 2022 01:29:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w5sern-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 01:29:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jL7jAoR7PmUbmJkbD/iJwdQFrCZpIPbKYlOV5b87eTKvFEnHyzDiAlIvxcgv5UrMur+nBj68CBmXXGnR7+mUxQqwGnxq5KPMhH79TgdPxtzFjjwJhvWMRWyFzMQ5udzvP5t5v7YtOfa1BLZpFmE+2jBgvYC+yYSRO8y85ddtFEZ9wkrhD/ortZOqi8FNiIaq5lP/J5gOVdyB9FKgWzs01/8lUb6er1OCDznZnGiBaXOAvXZ6rBUPuJk0JtMhEht4G/xGeP8gC7LOkVHNE5MarmlKpo82HTbWXnnE/jSWAmC36Bh5RlfFdkgn6ggM9JbpydZUSLiSiP/gdZ0RyWR3oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZixdfxHRW9gxhYX73w4Es/G/t9x5ds38z/WVpjECCY=;
 b=AnwnMmhBMzCQp3wqJoCKMtf+EsvkustVBfVfk9ND5QfU2wtYz8XTl1xFIoqX9wZb0AsNl49YwcPvgVn90g3rua0Gl0TLNJHUtvXkxjKSngmkTpzXY3WH4+wu7wtMCoDRqVUG2dHLUL6UIoUsa9JL8IJID3z+RB56jhJp/uuxMpFuy61FTEeoGUbWAvRN6d/nKsGkG1vu1SoAcNkmbXKrEIUjndbYtFWBKuyNXgvxVHbpQfHBs/ZL2/BEYb+8t5GXKfzl39bPtqBNmhRKjlpK70i288R2f3PGVUtWLYYqpTN3CNW/pwW+wccYvVI8oZMAKU7Z57hqVA2QwNswn1c0hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZixdfxHRW9gxhYX73w4Es/G/t9x5ds38z/WVpjECCY=;
 b=i3aqd7fYDOsQs0Y4uWviJXjXAT6qgBtW6WFSL0PlGwPXViVnsHPA2f/zn7bMBOgSVCGfU4FtIAyrb96H9feLTN4O3/Xjg/UvTqXNJOEuWy88bCIuvjX2lDK8zGKvTZZzEy17qASpbhAxEwMtgA7jXpJyFDO84cqUu8pA3RuZs94=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CY4PR1001MB2389.namprd10.prod.outlook.com (2603:10b6:910:45::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 28 Apr
 2022 01:29:10 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%9]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 01:29:10 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>,
        "borisp@nvidia.com" <borisp@nvidia.com>,
        "simo@redhat.com" <simo@redhat.com>
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
Thread-Topic: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Thread-Index: AQHYU0RqwCfhD8h+BkiXOp6ayeNVBq0A6XOAgAFYlQCAABKoAIAAEbcAgACC9gCAAPo/AIAAmfUAgAAanYA=
Date:   Thu, 28 Apr 2022 01:29:10 +0000
Message-ID: <F64C2771-663D-4BE7-9EB9-A8859818C7F8@oracle.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <20220425101459.15484d17@kernel.org>
 <E8809EC2-D49A-4171-8C88-D5E24FFA4079@oracle.com>
 <20220426075504.18be4ee2@kernel.org>
 <BA6BB8F6-3A2A-427B-A5D7-30B5F778B7E0@oracle.com>
 <20220426164712.068e365c@kernel.org>
 <7B871201-AC3C-46E2-98B0-52B44530E7BD@oracle.com>
 <20220427165354.2eed6c5b@kernel.org>
In-Reply-To: <20220427165354.2eed6c5b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d29a8280-d55e-446a-0ec4-08da28b67ec1
x-ms-traffictypediagnostic: CY4PR1001MB2389:EE_
x-microsoft-antispam-prvs: <CY4PR1001MB23897088F1FA11918F43333193FD9@CY4PR1001MB2389.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f0vSdlArSteArUAIADF/Uy8dYRQ4oVJsYEPgODz7iOE6BBM4N5TrD2cB4vmWSMoUT4hiR9q8ukJeynvPmxy1gPS7RiB6uqppLzwVmCDgeUtTBE6jL82TmCpoJiMQ8gehnRgfGKHSnXvMDhpCSlU9OPGPSUhQE9ouwHyCEjWVJPQrsSJpkJADdGkK3sJGzXZg5bEwRh6Q14exSEp/pS/JaFAcQnGb21M1oNuXdaZmQJHA0Id+5RogTpoqhYgZvasLDef6GGvoMAIKf0oAMH7L4CE08zsHKlqsF0D50j6AupyDAng4HV09/1WGJWQo3PheRZAUkQ1wWUqFd2n0YF0AP2XASW+RWeQ08ekJlQd2uGnbmHjbEpip39Wid+GtTEcoEocp7C5brBWLFXajbFJuaYWp0mjxs7Jujn5NGgM2OsoEnvWRfwVO4pokAsBy3a+AP+qmU+9tXqLCipF4+OgBbnd4RxIIN0GeZ5UvDubC1NNBfPzdd7phAQsdwr8M9253oaBiePp067xwOx1pvxdvGXz1rV1299KjAFn0TtYdmZ8+tFLRlCeT3QepzBGqnUZDT9PgNnhQFlx/0o1/DfITj5QGG0aL2sUMCkHEseA8TDv0xTuQhzVk/XXrbQPJUe6mVVy3BRr2HG6c3a0jl3Pt9uTJA6US/XnslwBx2yag514xlhE3ztQ5xFOaWOqfcNq8e7adMMy6mfIoe89LDYtQkH7yL9e55RJJEbSYMnpRrftzgRBJwZJFV9TER9tVUutb9RCUlYn31SyI/qWgVp79NFq/8gBML8+YTgd+kgqs8KQkLC3xyy03NGccZjxRm1HWXG7CvrWv+/T75ccJ0M60H3H3eLEL7EkZ48ui/uYs52M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(83380400001)(91956017)(26005)(76116006)(66946007)(4326008)(66556008)(66476007)(66446008)(64756008)(6506007)(8676002)(53546011)(122000001)(5660300002)(6916009)(54906003)(86362001)(2906002)(316002)(38100700002)(38070700005)(36756003)(8936002)(186003)(2616005)(33656002)(508600001)(6486002)(71200400001)(966005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P1JyvsKHx87F9fykayYxkLJq1y92s4tG7FxR1HthyYM3B/XYnQruG1Q+p1FH?=
 =?us-ascii?Q?aOmHOKSYniIsZ/MgKVpQ95j5YhlEaKSsDNfVWEf2pqf99IcDbaRF8BW8qh5E?=
 =?us-ascii?Q?AzzJqhc78I1SiScO5OZLLnb2JOU4aaYPXe452idNsA9E91cNAcksLYroEPoO?=
 =?us-ascii?Q?aA89meDrELqqPurWTehnBeElKvb/UpzhXDxt6yvjpLVoNKWb7EDNcWl0CM3V?=
 =?us-ascii?Q?3DlUQjOUoQyHaClcUlY7zLI8IKCHzsQgMMxDUuQg2Ha2KjHPKsizm/GXZIXq?=
 =?us-ascii?Q?Tyik2a/vSyjaorb+XNFEwM1B3m/lSoHv4KrRH7dkprVHd/7xMaPdIA60YaQH?=
 =?us-ascii?Q?SQBnIDg07bI17YPPtiJFPZtT8+7FkqXqwOwJFCoFaBHiJbD9Y9zf5ur9iNtW?=
 =?us-ascii?Q?+Eu7shhGKdn8VzWzReh+FRfZu1tCT4BlXMDnFTd0oVRVa1HUlbzWmw5/p0b/?=
 =?us-ascii?Q?B/yGk/pEa7RFLi/whB21AgcXxx/c7knXBAXS1zOwyT0r5FVgoLEUgxlTka0x?=
 =?us-ascii?Q?WtR26ftTMUVshStEMbGWeUK8xy1n/wagFD0o5/AVb9eJ9TmQGwttri9yJk8D?=
 =?us-ascii?Q?tIZhZzOyeQh47UIImB8wsRGWp5pNIL5Z+6jS90/QQG0cJOQePAen0uWWvHUs?=
 =?us-ascii?Q?thr1aDqH6Y/E+Nt63/Z2IvON90HxciUgggkv+9+jZy/SpMmaTDQoLe9uC7WK?=
 =?us-ascii?Q?PVIl/txrq8gFFBqf5alXK6dlf8xBlgdtTywadcNqDS65NhVHw6JmHOaTZYBE?=
 =?us-ascii?Q?+ixUthZTLagsNpLP+X44IjLZgc9FHB3sz32jUpF/52TMQ+k88c26c5ca9vhK?=
 =?us-ascii?Q?8Je0II+HQPdl2KC8/j/I1KiiTe0d5+cxUjYrB3vlCCQ++CF+QE7scCBIek1o?=
 =?us-ascii?Q?9GLvzlppTMhJWb03mWIvH6QyJZ1kANLgh68p8QuDA7rQivyOGUOSxE2Set+Q?=
 =?us-ascii?Q?oJBGMKLybvG5csI56OYdth6W2LSS7HE0G4jD+CxStVKGPUfsW0VVqTEM3ACm?=
 =?us-ascii?Q?6Gx/MLwr1INnWWdd9W+dtVuxwJnlq1Wzr2crhE2VNdFgWw8+dLeFnfa+FUPq?=
 =?us-ascii?Q?7Zdg1EGDNGTzB3TZihdFbEMG/sKMI+blJHbTjwAiDGR4iTDzcSEObvN5h1EY?=
 =?us-ascii?Q?+RVa8c/ubmaJqXzo1eXg9iDGZJ/nbJ8kg9PuMNUcv/PIS+33LD7SZCMlRF+B?=
 =?us-ascii?Q?mK1z91iBw1SXznwrP0ov5mgQNlrJ+nvmvW3bZflYtABkTHWxlZHXr7GrStAm?=
 =?us-ascii?Q?bXvAQNnvpVO9qoayKyPVbR89xPeEphiGXjF3J7cxa1corFeRg20oVZvD1es2?=
 =?us-ascii?Q?NYyKpo0H/5UTFtC7ZTGCv45EC6wiIjE/zCc7/Zp2TAy473n0b2Xf3uYy8Yyk?=
 =?us-ascii?Q?KrvM1/mZpBe/5FJXpX87gs0XrVUde5ghEqQIwIAPOWYxjqeCBusPNYuAeb8I?=
 =?us-ascii?Q?Hup1epTyDusT/b70RkszqDijUY/kzPq5JyKcoBZAOUF1fwvjmSsUEZu9Reqs?=
 =?us-ascii?Q?FpbftZWy9aZvjyRjkKPE5Qg6+zUwPAdMRKgoainWHxgG7tnP02w1o/kt8oat?=
 =?us-ascii?Q?DpGo4DOgCAbhbJURPFidTiFA7pUiVMQmQpMJ6MqfwyACdNr2nltqy3pHBZmC?=
 =?us-ascii?Q?cM7c4yvTxJQCXWXWGV7Adl3wBoPqE/K8XO469oBNFv9hBteQO5BYXSk4VBkY?=
 =?us-ascii?Q?pYDHJEyKqTiVTxTtiZR+5CdQBNwZlVcJgCetStzSCzUL990Pn0fmf6hiib44?=
 =?us-ascii?Q?TPLyECrlRWAV7KnDV98le8scgudxXvA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31A56027C594F94BAD476D481F58F522@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d29a8280-d55e-446a-0ec4-08da28b67ec1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 01:29:10.1774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ubL5LCArJwmri+AbL9Ex2VR284b0aG32GH3GquClk0MzCWljtVCWeOH7KazYERzsl+gJNoUBlyalaweGYfxLyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2389
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-27_04:2022-04-27,2022-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280005
X-Proofpoint-ORIG-GUID: ey5BRPZCOrZJrokSg23AxgaYuzXDGbAD
X-Proofpoint-GUID: ey5BRPZCOrZJrokSg23AxgaYuzXDGbAD
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 27, 2022, at 7:53 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Wed, 27 Apr 2022 14:42:53 +0000 Chuck Lever III wrote:
>>> On Apr 26, 2022, at 7:47 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>>>> RPC-with-TLS requires one RPC as a "starttls" token. That could be
>>>> done in user space as part of the handshake, but it is currently
>>>> done in the kernel to enable the user agent to be shared with other
>>>> kernel consumers of TLS. Keep in mind that we already have two
>>>> real consumers: NVMe and RPC-with-TLS; and possibly QUIC.
>>>>=20
>>>> You asserted earlier that creating sockets in user space "scales
>>>> better" but did not provide any data. Can we see some? How well
>>>> does it need to scale for storage protocols that use long-lived
>>>> connections? =20
>>>=20
>>> I meant scale with the number of possible crypto protocols,=20
>>> I mentioned three there. =20
>>=20
>> I'm looking at previous emails. The "three crypto protocols"
>> don't stand out to me. Which ones?
>=20
> TLS, QUIC and PSP maybe that was in a different email that what you
> quoted, sorry:
> https://lore.kernel.org/all/20220426080247.19bbb64e@kernel.org/
>=20
> PSP:
> https://raw.githubusercontent.com/google/psp/main/doc/PSP_Arch_Spec.pdf

During the design process, we discussed both TLS and QUIC handshake
requirements, which are nearly the same. QUIC will want a TLSv1.3
handshake on a UDP socket, effectively. We can support DTLS in a
similar fashion.

We hope that the proposed design can be used for all of those, and
barring anything unforeseen in the description of PSP you provided,
PSP can be supported as well.

The handshake agent is really only a shim around a TLS library.
There isn't much to it.


> Is it possible to instead create a fd-passing-like structured message
> which could carry the fd and all the relevant context (what goes=20
> via the getsockopt() now)?
>=20
> The user space agent can open such upcall socket, then bind to
> whatever entity it wants to talk to on the kernel side and read
> the notifications via recv()?

We considered this kind of design. A reasonable place to start there
would be to fabricate new NETLINK messages to do this. I don't see
much benefit over what is done now, it's just a different isomer of
syntactic sugar, but it could be considered.

The issue is how the connected socket is materialized in user space.
accept(2) is the historical way to instantiate an already connected
socket in a process's file table, and seems like a natural fit. When
the handshake agent is done with the handshake, it closes the socket.
This invokes the tlsh_release() function which can check whether the
IV implantation was successful.

So instead of an AF_TLSH listener we could use a named pipe or a
netlink socket and a blocking recv(), as long as there is a reasonable
solution to how a connected socket fd is attached to the handshake
agent process.

I'm flexible about the mechanism for passing handshake parameters.
Attaching them to the connected socket seems convenient, but perhaps
not aesthetic.


--
Chuck Lever



