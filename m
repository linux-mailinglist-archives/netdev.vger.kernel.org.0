Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562B9514F1D
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378303AbiD2PXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 11:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378297AbiD2PXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 11:23:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1E1D4CBB;
        Fri, 29 Apr 2022 08:19:48 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TEfi5c015530;
        Fri, 29 Apr 2022 15:19:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+zZyiOyWysVJgwqSWfWz3KJ9flQ9BD+g6efTa6zKY90=;
 b=o41I9U+2CYElFpSI2WT7aQuKL6QrZhnzKYa1LPglqpO08JL6kDi/nYUHyOMZaLq4GsEa
 73JF8sZEBD/+TrngA0lJFhwMC+f12ZfaM855mEKt0yVT9Klg9waOV+l0QNV9bypqQuJT
 cxaX6gjz/YYfw7YkPgCYTFhVQFvnI7ardm+1FuLseRWWLk5agT/Pm4pSkKBBETOAHC/v
 d/8RME9uWel+BOblAzXgKPahB+JMqBDdBPeLFleyaRianhpRaFIDum0L514Z5O02oV5A
 Mf5e82W3eJNOhw0lEzGdSnkl0+RNy2lfxQSWHXifivae48i+BeyykhjOwReqRDvgglyZ 7g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9ay0gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 15:19:39 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TFBGL0008048;
        Fri, 29 Apr 2022 15:19:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w8656b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 15:19:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwu1nRRDOQue1EgISylckGPSzTNFgPfuWDEx4A2PpzFOumAMRzRr0MkU/sgK9PNso+ItreOC9BzajBji51g4URDFAHSICzedbj49wCw0Ri4xzgNs984XjVlk93baLmX5DRiYLBc4djk+ZhvpRFzclPymQNlq/2W0CkKo8ho6VnlcHqdI03BD0cba0JB9EwFlZw8LInjytquG0Yf5t2wSSVWoKjIxHzHySkfK5JN8mWhG8Hxer+rMhwAyd/SM7F0MJRQZeV5JIxUSGrTP8vKDLgvaz9vc4Yopcn1mDtGcdO88893O7Gza/IuZ6E4jl8VOTlrrOUJ9IlFJZkpnwzHRrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+zZyiOyWysVJgwqSWfWz3KJ9flQ9BD+g6efTa6zKY90=;
 b=hAzoNG12OB93kqbl7r5n1e/JYiHzwTgmcyWHsQ17Pb/UYihTjRG4w3z/nPZspWXXcMs0VUMjejfxmY+R6wYKOmmYy1b/zQJGPeokBy6OSQ3M1fXoTapNw5Mh+cUAujXPslLcf86NTyvtGxtu67mMbZcsmhZ2bOmFlVGaTV0ANqYpiRRz/CG7Mb9rJH6yQt099dhtchFFa5EiderY1wVDDfMD+5e2hbyoO3xdC+EKXxMmZ25XqY/1lNTUgH1KBE8GwXZrVCcYVbSAJFcoeqj8tZgErXOd26wBCfbkVEjnJ1ZIlWYXLCWVJw67LhuRzGmfeJxOe5QPnmncwU6ov/xCEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zZyiOyWysVJgwqSWfWz3KJ9flQ9BD+g6efTa6zKY90=;
 b=JmSRCVUzHnR8wcRgiZwQtSBSbyRDVu/5KwyJ7YcSx8MvRdPubqeXPV+30dHM4VlrtYV6Y1PqT0QdAXzbPnwMmWjR+z4OgmFLMwfxZJXNr7vyghnROVgCjmyvvIM70S43QSLF3wBZHo3VfS4vKLTxYR4KYg1TOmC7KAQ3Aiu7IlM=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by MWHPR1001MB2175.namprd10.prod.outlook.com (2603:10b6:301:2d::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 29 Apr
 2022 15:19:33 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%9]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 15:19:33 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Simo Sorce <simo@redhat.com>
CC:     Boris Pismenny <borispismenny@gmail.com>,
        Alexander Krizhanovsky <ak@tempesta-tech.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
Thread-Topic: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Thread-Index: AQHYU0RqwCfhD8h+BkiXOp6ayeNVBq0FEy8AgABJdgCAAbXggA==
Date:   Fri, 29 Apr 2022 15:19:33 +0000
Message-ID: <7FA8327D-8D88-4BD3-B482-91FE673BC118@oracle.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <068945db-f29e-8586-0487-bb5be68c7ba8@gmail.com>
 <089628513e1cadc0d711874d9ed2e70bb689e3f1.camel@redhat.com>
In-Reply-To: <089628513e1cadc0d711874d9ed2e70bb689e3f1.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d860797a-b8ea-4fac-0711-08da29f3aa34
x-ms-traffictypediagnostic: MWHPR1001MB2175:EE_
x-microsoft-antispam-prvs: <MWHPR1001MB2175F91AB90239BEB3F25EFE93FC9@MWHPR1001MB2175.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8IDdhyGey7uQxO1mWOxZgz3wqoqFwk+E2+3adXswnLL96NPRT/bDKaemhLt7wKBF+6euHVULiDDFMbpkDVAphfH4vMAVtjxtiWSZrcambaGKL8JJUZhrMhksAGXJjaR7GvfJQLcIzCTVCbS34xOeGt9sZ24XyAp6++WkqRMwTSQCW8pGPJR0+qN5thOagXNz1qFuqLTWHuuPgUPTFWTgC5FYB5Hq/8U2sOSylqtDYTWzZFfeyySdOojXkQcW7dasi59b6+N7Fcub70uHmdEi9jzhu/iOHWltaeClVmlztiSOm69MhvlRyltVWKzP9xqJfP+jt5hBgXaXpB/Ew4J/laoTXGUI0/GsyRTORzpoD+V4iqaCq8a+rAWCHgVk49VZ3vDCMIcm8KoVjFmWSpQkievErw42fhf8Zb1AlWmd0/J2sd2QzdgtfFzwn4ur1DoMcTC5APeh0LhQ7740ExDwqm0xBEe/Z44R+tdIw/zOFJtp2NjgRJhSqaIEJ16D+FIzO7lUkLlmFtf/lvTvpY4Lm4Qru4Zp0H1WvkhbfjyP022nFYA+uyJwaroJMagEThuH6guaSqwVfRrW/HA7bkTATxzSMm9HYQ+0jXB1beH0Lgf0/B6v7WCdwwjmxUfBskzgxZHodUnGsFjNu9Dx4prRKXgu3wxSiRYLhKgeTO7WJ0DZcW7SiURNI9FBW0kLBRxWXbMEdWNX8k9ysBY4eyogHEj3GMKtJboqPLY0xtLpMVyl0fVLGAI/JEZnMJ18TiAf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(64756008)(76116006)(2906002)(33656002)(2616005)(91956017)(66946007)(36756003)(71200400001)(122000001)(38070700005)(5660300002)(186003)(4326008)(54906003)(38100700002)(8936002)(8676002)(66556008)(86362001)(66476007)(508600001)(66446008)(6512007)(6916009)(83380400001)(6486002)(316002)(6506007)(53546011)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NbAK34l0T4oxf12B2v2dCY5uCu9rW1Rf80ZiE+krzP91WKk2YJYssr4YP9o8?=
 =?us-ascii?Q?ZZ2FHme7Bhvz4uoh3PyIODJRrXk19HKhOLKkE04nU3M8KsQBBJhXvnZXvKHK?=
 =?us-ascii?Q?G41WW/94IC9kC1JWLwH34k4s9qrPlpDeGBnBgZys+FRN49CAtVMQK16kaJES?=
 =?us-ascii?Q?j/s91ktsOVlklTotYroiXSK/+KvaMoF3soFa4DaNL6LTk3D0bht7LYtA+jg7?=
 =?us-ascii?Q?EwS8tMjyNAJSeabEwahXLT+qLe6SdZnaWTR+Zw8h/uRuAgq1+3uTb6Tx/8TJ?=
 =?us-ascii?Q?oq054RdV4nOp2XqS8ofX3d+QMjXj/n+b4DYjlaxD0LAP77NMmwsrfxFtqmTa?=
 =?us-ascii?Q?NaQrgBoMFaFMftNhTFmLnv6eUiCaDioptoYGJYgxsaHKYh+xWpMDnIhXU3dA?=
 =?us-ascii?Q?b6TpokZ22GW1De2BdyeVbbWqcztpTGQCg9dOIEhNJShkyc+0PQDuY+nR6NaI?=
 =?us-ascii?Q?iOw0V/CURzsWnO3qAFMUXuR+EOd8uEIQJltOe62DtZWcU9yxAjOoguQzm5N/?=
 =?us-ascii?Q?gijF0D40x0cVOncdjqoqIISv5ME02k1gQORUjWw1YbeBF41+YnsCCCct0GzV?=
 =?us-ascii?Q?dW33ukvC7T1MWkNwG8V9RBIivk33CB+P7TOAkmANfeXekJzR1rKj2Dlbz4A9?=
 =?us-ascii?Q?QbeItMUWzbBBOMyKGfiLslsoJTr3BCKX2AFFBe3XThRu8x3RVAxdkBT/BJoB?=
 =?us-ascii?Q?7C2fVe3iQ2n6AL/jp0rNpi6mAeNL8h6sAdyZtBLZH765VjbsE5Hc1JtVXxxe?=
 =?us-ascii?Q?YB29IcdDF7DHhe318kX+cg3St197Dz2UkxloGbSAChtjDvc1UCTsJUnjnFd2?=
 =?us-ascii?Q?H9Q3erxbXXLBJaeuGSadQAJN525hpOM8bWhi4baaiFv43iR3vv3IAu2qh6iE?=
 =?us-ascii?Q?RcqBDVnVvbEmokYFsW8GHPdTSq6ATYQDUC/7+D36HVzv+lCJtNXc/DkVddSE?=
 =?us-ascii?Q?+qxMehp/M990Zdtlbv/lCIpA65jp2kXWTfyWITOoTDOP2U3hokOZTCg/kT9R?=
 =?us-ascii?Q?nqA2z+hPGvt3/Nz50pAwc9wKWofF0tzNCtEP5KajHe/Cw5AXcUs3jLPd2Kxf?=
 =?us-ascii?Q?mBRPbQKA0LaMBtq2WHw/5eR/gyrryg+70zMvTqUh2Bg87ipaQWF9D3WDFJC9?=
 =?us-ascii?Q?mI1UEPcH+J7IJfGplr0k5sivCCIAwO65yQXEKZFYKSp8SEBlPqFtXda4j423?=
 =?us-ascii?Q?RQzZeJKJS0SdZqKuT9HBKWWQAQB46/llefBQowFlryvdipQQnEploI37JQ/c?=
 =?us-ascii?Q?thc5kvABzmeeGdrxZJQ19K2Tp2na3+ZH/HYThDPISORJxhv8NxcQNY5Av7q5?=
 =?us-ascii?Q?NtEbpXyeU0JVImAc6O+xUJo90yIpeqfsuN0c2pBOPZg26NbqZh5lu2ZeRVZu?=
 =?us-ascii?Q?ClyMqUd6Ng70XsyzwECy+CFL+q1E80QRkXTTmRkRHp1R4aPwzQ9KuvcxESeK?=
 =?us-ascii?Q?lGy7NHt8hcaAuhcIAajdxnlndPT0vMrdQZINtPA77Wif6t91LD21FrLxbmkL?=
 =?us-ascii?Q?ab8BxRaazW8ghNYX5hKp2uok6xtOLPLTohEKpEgL+l98dWUEDW10ixyfIPUl?=
 =?us-ascii?Q?iOEgQYM5mLIq6H6OBjFPUEDw37DWT3HM+S0pU2IvXHhbGJ5E4LW4WCjmGYr0?=
 =?us-ascii?Q?V/WYAbmKDpqteKDNbjFjEMx2qSkckhdb972Hp5Ypf0IjuLxkaSIPTCUxOsMj?=
 =?us-ascii?Q?xY5I2xyQ7iNtGZCSQvIgZ1Z9pfRKpw7AXv/erOymBVoGSXdJp4SXst7Mm5OU?=
 =?us-ascii?Q?E+TcW8NLfYUGH+ZUCf5ZI7WLaTBPGWE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AC22864E3EF46A439C5FAF6ACFC562CA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d860797a-b8ea-4fac-0711-08da29f3aa34
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 15:19:33.5049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pd2lfrlKLPzCKy5juwZrzEmQxj+LMxIEvpW+jQzf4HuTdm3wB0fRsATtQpiBAMegKhgfeKcSw0PXR+oy/IsvTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2175
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_05:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290083
X-Proofpoint-ORIG-GUID: npo7NMfuoCG_hTPCAv2kbdEliXY2qeFw
X-Proofpoint-GUID: npo7NMfuoCG_hTPCAv2kbdEliXY2qeFw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 28, 2022, at 9:12 AM, Simo Sorce <simo@redhat.com> wrote:
>=20
> On Thu, 2022-04-28 at 11:49 +0300, Boris Pismenny wrote:
>> On 18/04/2022 19:49, Chuck Lever wrote:
>>> In-kernel TLS consumers need a way to perform a TLS handshake. In
>>> the absence of a handshake implementation in the kernel itself, a
>>> mechanism to perform the handshake in user space, using an existing
>>> TLS handshake library, is necessary.
>>>=20
>>> I've designed a way to pass a connected kernel socket endpoint to
>>> user space using the traditional listen/accept mechanism. accept(2)
>>> gives us a well-understood way to materialize a socket endpoint as a
>>> normal file descriptor in a specific user space process. Like any
>>> open socket descriptor, the accepted FD can then be passed to a
>>> library such as openSSL to perform a TLS handshake.
>>>=20
>>> This prototype currently handles only initiating client-side TLS
>>> handshakes. Server-side handshakes and key renegotiation are left
>>> to do.
>>>=20
>>> Security Considerations
>>> ~~~~~~~~ ~~~~~~~~~~~~~~
>>>=20
>>> This prototype is net-namespace aware.
>>>=20
>>> The kernel has no mechanism to attest that the listening user space
>>> agent is trustworthy.
>>>=20
>>> Currently the prototype does not handle multiple listeners that
>>> overlap -- multiple listeners in the same net namespace that have
>>> overlapping bind addresses.
>>>=20
>>=20
>> Thanks for posting this. As we discussed offline, I think this approach
>> is more manageable compared to a full in-kernel TLS handshake. A while
>> ago, I've hacked around TLS to implement the data-path for NVMe-TLS and
>> the data-path is indeed very simple provided an infrastructure such as
>> this one.
>>=20
>> Making this more generic is desirable, and this obviously requires
>> supporting multiple listeners for multiple protocols (TLS, DTLS, QUIC,
>> PSP, etc.), which suggests that it will reside somewhere outside of net/=
tls.
>> Moreover, there is a need to support (TLS) control messages here too.
>> These will occasionally require going back to the userspace daemon
>> during kernel packet processing. A few examples are handling: TLS rekey,
>> TLS close_notify, and TLS keepalives. I'm not saying that we need to
>> support everything from day-1, but there needs to be a way to support th=
ese.
>>=20
>> A related kernel interface is the XFRM netlink where the kernel asks a
>> userspace daemon to perform an IKE handshake for establishing IPsec SAs.
>> This works well when the handshake runs on a different socket, perhaps
>> that interface can be extended to do handshakes on a given socket that
>> lives in the kernel without actually passing the fd to userespace. If we
>> avoid instantiating a full socket fd in userspace, then the need for an
>> accept(2) interface is reduced, right?
>=20
> JFYI:
> For in kernel NFSD hadnshakes we also use the gssproxy unix socket in
> the kernel, which allows GSSAPI handshakes to be relayed from the
> kernel to a user space listening daemon.
>=20
> The infrastructure is technically already available and could be
> reasonably simply extended to do TLS negotiations as well.

To fill in a little about our design thinking:

We chose not to use either gssproxy or gssd for the TLS handshake
prototype so that we don't add a dependency on RPC infrastructure
for other TLS consumers such as NVMe. Non-RPC consumers view that
kind of dependency as quite undesirable.

Also, neither of those existing mechanisms helped us address the
issue of passing a connected socket endpoint.
listen/poll/accept/close addresses that issue quite directly.


--
Chuck Lever



