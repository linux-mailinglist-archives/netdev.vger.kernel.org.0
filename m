Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121FD50797A
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353542AbiDSS4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347092AbiDSS4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:56:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB043ED1A;
        Tue, 19 Apr 2022 11:54:02 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JIbruL019412;
        Tue, 19 Apr 2022 18:53:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=cpyIdXl/EJXZiSOmoX25JdA1h/kiPt/eU3q8j73OcNQ=;
 b=s0lErlRdaMCZ4gl3s843RtXqpohvazgTXP+VUaLVLKvMLuuZXC0lcmQ4Ara4NOKL55DF
 pDVLKTg24QToR47JmOvIQ14+zBtHglcBQeap9INVe7FYKWd9gMoQ+xOQ6DH4MDZS0LyV
 DyqOvP4s4mpklV4pmJg4x50wG9cQ1USUC6T5PXQLz3CogrRM8U+PPTL/e8pRu6LfwEW3
 uWyUzfEAQiwXhPo4a5GHVDA1k9YuWyHiZXry0g33Ez/qdYLxzJv4rmQvKQfO8V5AsmJj
 Pjz+ZfDgo+NlTetu5sii95Gz6SH/ta0OzVbgtpOGfJo+exOnGPFEaiISUXVm3mc/BsVv Tg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffm7cpv0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 18:53:49 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23JIkc84036293;
        Tue, 19 Apr 2022 18:53:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm83akb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 18:53:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMW8o8srWmd6WJn7lCk8cIREYsb6Nb+BhnmK/Ck21If7wLI0d1QN7yuRFynzZ17xbGH6+gNGHXuPYJk2p0cX26deA4Mn+OzIjq0JojfEJGV4AtNL62sqIckqI2p19QIPPeOuRfUrZf5+NC5FkYY/4sOjDVGC4BIM1AECriFmY3hmufVcyoLpLv3GoYLBqhz9eXXJbhx3SMsn4ZpCaD8Hc1F/CwlxWF9vRJHvfiFYo8DCzaOUVMB8CJVao1dKxYi2DoxkdTtErVW8RZ45CNushjSZmIlULbzTrT20i5Z6W9nsPW8ndUr2cKdpRW0HuxHPiMB6qCsMPHJS0tX6D8Kslw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpyIdXl/EJXZiSOmoX25JdA1h/kiPt/eU3q8j73OcNQ=;
 b=FAJTvxI3VNG879kY8+EKr8uVcDShS46/4o5X0scYYsQ3HOcN1zAwHQ4TjMZ2BSROkfERuVh+etJohwqVy4VH1UlUFb6yiOlYbOxjij3E0r1nqxlNB0FO90UQAjUojC94GkJV9hmNWVMTDActBlKOEJ0vswNoEV8zLpZD9ENcrapgCz5FH7LFHNfkf0MOuo2oMcbZZFzZBK3BIPx70z7Owpx4ZuTMhaJfBaGxHtMRhhBRo6zKD1mHBbbizGi9KgvomcMpojmklxVWYgGgAJdpWZkwtkjvEQzAtyYhU8aqf97GJOJoiusUQjl4MEtlGXPxjh1rDpQxf4L8yG566hEmSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpyIdXl/EJXZiSOmoX25JdA1h/kiPt/eU3q8j73OcNQ=;
 b=IpUVJSWVVp3HhBbTSFcLzgmn1WrSpPAWOo5dhO66mrokU0Fkx3S9rKKKi0GUiA/obBPFbGKnSd6t5PeutN89ecKMC/PBuzjjsdNiSBrmyNg5DQ/3Hhlh3BXgU/6lNrkc8lAiGMIluNyPRRtj0MZiKjsBHL0YXw0n26dBpAtRGtM=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH2PR10MB4374.namprd10.prod.outlook.com (2603:10b6:610:af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 18:53:43 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::f427:92a0:da5d:7d49]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::f427:92a0:da5d:7d49%7]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 18:53:43 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
CC:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simo@redhat.com" <simo@redhat.com>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "borisp@nvidia.com" <borisp@nvidia.com>
Subject: Re: [PATCH RFC 00/15] Prototype implementation of RPC-with-TLS
Thread-Topic: [PATCH RFC 00/15] Prototype implementation of RPC-with-TLS
Thread-Index: AQHYU0SpuI21otIlHEi6aMaWB1g+e6z2lWsAgADRRwCAAC7JgIAAAZCA
Date:   Tue, 19 Apr 2022 18:53:43 +0000
Message-ID: <E7B440A0-FD0A-4F67-8238-CAE9A6882F10@oracle.com>
References: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
 <962bbdf09f6f446f26ea9b418ddfec60a23aed8d.camel@hammerspace.com>
 <06AB6768-AA74-43AF-9B9A-D6580EA0AE86@oracle.com>
 <8597368113bcc38e605e9bbd11916a0ac8b7852d.camel@hammerspace.com>
In-Reply-To: <8597368113bcc38e605e9bbd11916a0ac8b7852d.camel@hammerspace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c328ff99-aa62-49cb-1f71-08da2235ed3c
x-ms-traffictypediagnostic: CH2PR10MB4374:EE_
x-microsoft-antispam-prvs: <CH2PR10MB43748C9B35DD39063B85CE4893F29@CH2PR10MB4374.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zwqlP+UwyBuo4OPMpAnnFFmmr+G6mMr8gZkXSSnwJFVCGYXYZnUjwH0w5d5tK5Yi+Wg7PFna4YsyH/9Y5G+Px/lCNak5NHDkMMRsccCXqoK8zQFmAjgwcUq5dgtnUz7+aF7ThtnSVWIIGicsq9QCmJ2ld/W9ePYZAof+YX2F5uaEn0QgaxyPACAUMDxn5wNIdm3SFF1zXoN7e3aaZfkZpyEuU0JRUd9rs12Aj0dqMqMiwAyhCKM4XO8mxP1stPG7EmFZ7t+yJWd30/pW9daqMC8//4YPJjjJY+IZ2dTCsv2nvM5hB9vR1H073a+NTzRcire3MPpWj3zEBA+1o/NeIUucykblJOLFu3MdmWv0YIvPYfddyiiMFGFxa6gU/ancC1VC5UpHJewfbXGwx3NVjD8cERLMU/7c0p520RwAP4SQfVz0DqId0pNWbgIuQwLjpORPrfyVA98ccqNlHA+z5QHRVR19NB12hE4ZDTcfvfq/GjiHb6sSkRkBdHGCA3vVafFztlGYuhc89JTpz9qksg5mmhKWteaH+eRyaUKCv+6c1G8B8nfbjb6nDuNt/2W2vyhOkJ26lZxgUXW5tM2VVNLwL4HGjBVHsO7wdwmWnF2qXWsnZ1pMvH01fEpe3wqu22TCMYFKr73mn7PA7ZshODSkd76uzoe2/qE2LBztLIC3RWLkLhT3sRDF6vDUZfn3Rcmi6sHB/2ieHuf09jk08rFPwT6COTDWG5bfxkrab2EZCbz7vYnZzYGHo7i+j41KVRNJVe+/GXEvLDUtfCdNlubSuJA7mO6N/7sTHNA5vQQbxbwpKkqbYWjbq2NoXCKZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(64756008)(66446008)(966005)(66556008)(91956017)(508600001)(4326008)(86362001)(76116006)(6512007)(53546011)(54906003)(6916009)(38100700002)(6486002)(71200400001)(6506007)(122000001)(8676002)(66946007)(33656002)(26005)(316002)(8936002)(83380400001)(36756003)(2616005)(2906002)(5660300002)(186003)(38070700005)(66476007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RFfS7K8E8cvc4XwEFLTXucq4CO3cvRcpVVBJY5G7f/6WcAjIWTbHiI4BpM32?=
 =?us-ascii?Q?acnLrBJC4owYKZAOJImahdSE1NtSwkQdq7IUR2kClWunphYdJhi3LnHdhn4+?=
 =?us-ascii?Q?D8ErMynjFI2k7kvXkTgivxrA5dAPYPcXBMoa2QCEgjE7smH3ZGxO1sSl1Xu8?=
 =?us-ascii?Q?Z3ra4MeJueUs8mRu6dg1bAlh3UY6YJUB6/f+Ig0V4a0Tw/NHfnmyc3mZlKvR?=
 =?us-ascii?Q?hcBZx4+wZVe5jYSGIuBN5UrKZIbPCfndWR/q9mNR0hP2UjIS/O/vERHXaZe+?=
 =?us-ascii?Q?RR6PPERTV7y6fKi41NmYgtFls+sV1Jby4HFvGiZCC8ahd9N9wH1aj925DJWa?=
 =?us-ascii?Q?sG/Xr2DO4nNkJNZTAx/u5el/NKuMK4E4YgZ2RfvnN0o3DjrvYXIKTM11uBtd?=
 =?us-ascii?Q?F95bRrQVEHXJJ52NC/z2Gi8wa/Wuf39evBMTRGyndgahkXpCSd8/QHefr6Yw?=
 =?us-ascii?Q?XWPBKiJvwn/lhyIYglRCPrcvpRufv3u2iruNZ8TMLbSM6I8f3AgaNE45dzxC?=
 =?us-ascii?Q?YqYPydcbdJ3ElaqTFcUdvjZLKUe50b5l3TCFXi12qJkpg7fP7etGswmHsTem?=
 =?us-ascii?Q?2hzVUBFSLi1PAghpAW0eeJ4s2YaLQhuqGrv+TT9fDCbIMPNHEjCgZXODGg0p?=
 =?us-ascii?Q?MmHiQMeiwJNctY79Wow+cUTYMxQwK3vXbXHoBbyXEvlq+DX/TjfDti1DxNul?=
 =?us-ascii?Q?YPq951d+LHyNErgEdGP4UW11VxZc4dMbXeFjqhi0/is/4GKJyCE5bZZLnEJb?=
 =?us-ascii?Q?fVU/rZlM42MAtB4E1vAx+DGcZa+3Ombze5zf9X4xJUYOZm144vUqbzhOgP13?=
 =?us-ascii?Q?Ffij8vl1px3nJLzK5IvrIiup0Hx1XfOZY3zaf1cIIGlUc9t6ydh4Tsc0nPe+?=
 =?us-ascii?Q?pIpHIpH50oKciqniNTmITRK62KAwqQuDXu8jggmRvadAQ4SGtSe13uxNeqDa?=
 =?us-ascii?Q?c2DBkwBB9zdXQtY1oQzBBUeHaTjsww9prnyKe9FcFYgrJzsN6vu/qLYuT1R6?=
 =?us-ascii?Q?fMTeeDTdouLUSAyFj4CXbDoBXT4Rxd3r8XO5CD8oYwKbggQSV46mm0rdP7BI?=
 =?us-ascii?Q?OTvhPCuv53PANt8g/8fySaIjJaT6nOPwvaQPFJ2Nj8j1zBikfU8m6SlZNoMl?=
 =?us-ascii?Q?nVfHWNMOVui2BwwL3SVgrgno3tdQsseV6FHz7hHVMVurnq/e9L+bdhy2wlHz?=
 =?us-ascii?Q?qISh97rgqnYc0eeDSduScBS+V6qutV9jLILqDsHYl/12sji8GGYuwEV0Niiy?=
 =?us-ascii?Q?sLCekhejLVW0aWO5BiD/BVARnZiIT13pGy5L8AHae0Xxpv4SG13HYbcX9e2c?=
 =?us-ascii?Q?g036sKp4E0BNO6WrzHoF6fAJQ4U012sT6Z7VOgciqIf7YFT0kd4itQ3/31Nw?=
 =?us-ascii?Q?HgDptKavUX7mbZuCu8LiY6Qnju20a2AJPzJKR36Ih3q8v4SrOs1jcbkqI8Gi?=
 =?us-ascii?Q?d210e8O7R2wqYAGqQPPMoQSeM+03I8nDSbgBYLUTH7E1qSr76M4DIgDyBIhM?=
 =?us-ascii?Q?boCm6kC35JA3h/z45+xdN4TXhXI9m3A9nv3L38xx5gDsNFhsc3sAawwXVvyy?=
 =?us-ascii?Q?zUUbJsbXpVjyU4HJvpDt1xmUf4f+mzE2hXrYvmXou1xXVIdxI/LOFgh7qjDX?=
 =?us-ascii?Q?fLNxoJ952FQteWqYRsxTXKKEJv5pzgC45zDOhxlpR4yycLEY93ajzOVtqeYv?=
 =?us-ascii?Q?VveZ+vq4i5rGFtFVC9pErjgPHdBfJ+XAsLxVcpnBA9pFG9Zy3ibaKkn/kLbK?=
 =?us-ascii?Q?wXarAYa4lQ9mVn67fbC3A7x+XX2t5U8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <085117D7ADA568458E01E26535F64A7C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c328ff99-aa62-49cb-1f71-08da2235ed3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 18:53:43.4160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9vJrBAKXMqLed+fIV8A12OWsVtHtRMUlYJBMT+IO42Rtz7qMnVUJ7SQKfjXgpSAA3+Y96jcbk4znjjr+0I2K0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4374
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_06:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190107
X-Proofpoint-GUID: YHWoQPy4dNxes-dH5An2QZM3DTc8kGFh
X-Proofpoint-ORIG-GUID: YHWoQPy4dNxes-dH5An2QZM3DTc8kGFh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 19, 2022, at 2:48 PM, Trond Myklebust <trondmy@hammerspace.com> wr=
ote:
>=20
> On Tue, 2022-04-19 at 16:00 +0000, Chuck Lever III wrote:
>> Hi Trond-
>>=20
>> Thanks for the early review!
>>=20
>>=20
>>> On Apr 18, 2022, at 11:31 PM, Trond Myklebust
>>> <trondmy@hammerspace.com> wrote:
>>>=20
>>> On Mon, 2022-04-18 at 12:51 -0400, Chuck Lever wrote:
>>>> This series implements RPC-with-TLS in the Linux kernel:
>>>>=20
>>>> https://datatracker.ietf.org/doc/draft-ietf-nfsv4-rpc-tls/
>>>>=20
>>>> This prototype is based on the previously posted mechanism for
>>>> providing a TLS handshake facility to in-kernel TLS consumers.
>>>>=20
>>>> For the purpose of demonstration, the Linux NFS client is
>>>> modified
>>>> to add a new mount option: xprtsec =3D [ none|auto|tls ] . Updates
>>>> to the nfs(5) man page are being developed separately.
>>>>=20
>>>=20
>>> I'm fine with having a userspace level 'auto' option if that's a
>>> requirement for someone, however I see no reason why we would need
>>> to
>>> implement that in the kernel.
>>>=20
>>> Let's just have a robust mechanism for immediately returning an
>>> error
>>> if the user supplies a 'tls' option on the client that the server
>>> doesn't support, and let the negotiation policy be worked out in
>>> userspace by the 'mount.nfs' utility. Otherwise we'll rathole into
>>> another twisty maze of policy decisions that generate kernel level
>>> CVEs
>>> instead of a set of more gentle fixes.
>>=20
>> Noted.
>>=20
>> However, one of Rick's preferences is that "auto" not use
>> transport-layer security unless the server requires it via
>> a SECINFO/MNT pseudoflavor, which only the kernel would be
>> privy to. I'll have to think about whether we want to make
>> that happen.
>=20
> That sounds like a terrible protocol hack. TLS is not an authentication
> flavour but a transport level protection.

Fair enough. We've been discussing this on nfsv4@ietf.org, and
it's certainly not written in stone yet.

I invite you to join the conversation and share your concerns
(and possibly any alternative solutions you might have).


> That said, I don't see how this invalidates my argument. When told to
> use TLS, the kernel client can still return a mount time error if the
> server fails to advertise support through this pseudoflavour and leave
> it up to userspace to decide how to deal with that.

Sure. I'm just saying I haven't thought it through yet. I don't
think it will be a problem to move more (or all) of the transport
security policy to mount.nfs.


--
Chuck Lever



