Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C123A50781E
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356888AbiDSSYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357763AbiDSSXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:23:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD95645506;
        Tue, 19 Apr 2022 11:16:58 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JHObu5019753;
        Tue, 19 Apr 2022 18:16:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8XRXDFWxOzDQjssWyWNyoZI2aOTm7YL0xdykwVcmTEc=;
 b=TwJjm62C8c9mROuR4YtnQJZ8XDPdEKarqVNvEs0Pw5J5kfVpc+rxCmhcKzS0lfnHxUMB
 pFm9Xr6C6dgqH6t94q2HKmP1sZM5KkdDmKT6Mpo+AwuYnPPjSQIhEaTFe2Qg1mLfUwJl
 x9itKmA95gSPhip11IE8+M02uIrMx8B9u5dxP+Cs5R1FnOFL9gKncl7r5NroR8TDdCFS
 boWlNM7+aPQzkJKYlsVU73u6yFVBd4k5l0hHyETylzHnp+sHctniIxCgQ/zEG42uCDul
 O0afoDxlSLmiNHUwiwMjtL52Hzxg1LAiJWMwinRD1IypQXOLn1glzSVYAmoIVtDFcyEX hQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmd16x2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 18:16:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23JI6dN2030391;
        Tue, 19 Apr 2022 18:16:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm837x84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 18:16:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJ+Y9WCoeT98mdXeC1KaNJWPSbQTEfOXfPQFT1dNDff8B/hMS0pAtkLNfmPyl70lz76BGBd3zWdgilAxVGkH8rS+zVOrz95MTFy1+iJtfbwURtheQe1qnouGyHFZkazNIjttUdfKXHzKiIxBHgWcF1umR8cibmA8ztJq4WU0jx9xS4EWCwcdLfWcOFngbcE08/15kIQP+bYtdjBd0HbdnwSh+4U/TiF91PWJIdkMMxgzyPsIdxkZuqNCTUOly+UKmq/mRplDHzpbswXZDWvirC4fXjCIBqFpF2qiQ2vdXNbQxLrrxItMLEyYWGkITJSn7le2i4foSY0/o15b8ni0RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XRXDFWxOzDQjssWyWNyoZI2aOTm7YL0xdykwVcmTEc=;
 b=Et/n2GP6p0Nd7rsAiZWpWOGgHB5jU0OovKzTt9x6jd87xplot6PMqiKBgfnWmauT/mUs73OeH33ypeIH+LunU9XByfZTZfmROMEiVEdhhrbDz3dZf6xM1KBbWwKBmfAeXA/SlhaOxNRyV34nmAK6Mk2ohwoB29UhZ+idTUHCHHnNb/kAxhlUacGwmx/sL8SbDmkPKUjJYrQpeXKx52OHtXeOD0zfHDHPMH0eqZOfo4ReLjsjBmuzg3U2KZIlsrAch9u/tyVosV+0KaSZHSjltbsaXwI8Ru6O1iNZ8jSL95PlyYmOeTtd+LHwYtE8izPI6vQ1NQoMlFB//2JcnER9Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XRXDFWxOzDQjssWyWNyoZI2aOTm7YL0xdykwVcmTEc=;
 b=axuUScQDwwzYIqkBDn0gR7crBdzDzMO4xd10dK/10CwS2FjIhnpq05UggMFmY/QdALtkxW42M42cPAVdOXSS5Xs7cWTAq/UmlMhwJ/CXJXkJsN5IW8nIbUGgPissUDKOU1K09EmWdZMp8rMu0e55OUlWU72P6j0zCRBNPL7Qc7U=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM6PR10MB2860.namprd10.prod.outlook.com (2603:10b6:5:66::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 18:16:42 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::f427:92a0:da5d:7d49]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::f427:92a0:da5d:7d49%7]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 18:16:42 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "borisp@nvidia.com" <borisp@nvidia.com>,
        "simo@redhat.com" <simo@redhat.com>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>
Subject: Re: [PATCH RFC 08/15] SUNRPC: Add RPC_TASK_CORK flag
Thread-Topic: [PATCH RFC 08/15] SUNRPC: Add RPC_TASK_CORK flag
Thread-Index: AQHYU0UH7NIJR860dUOYblj2e849Maz2i/EAgAEAwYA=
Date:   Tue, 19 Apr 2022 18:16:42 +0000
Message-ID: <AE1190F4-EDE4-4C2D-94C9-02A5EDAAFBC6@oracle.com>
References: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
 <165030072175.5246.14868635576137008067.stgit@oracle-102.nfsv4.dev>
 <a771c65353d0805fc5f028fa56691ee762d6843f.camel@hammerspace.com>
In-Reply-To: <a771c65353d0805fc5f028fa56691ee762d6843f.camel@hammerspace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6b3dcb1-f293-4da3-9132-08da2230c187
x-ms-traffictypediagnostic: DM6PR10MB2860:EE_
x-microsoft-antispam-prvs: <DM6PR10MB286058B6A70B4B63647D7D1993F29@DM6PR10MB2860.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ngLF6YoLQorMvBgui2JOCfeXFGm1NIpG/G26OU8XQex5o1taGqrk/yZuX4Q6Mxl3zp6HynikNN4zRAwLyh2id7/p1vYgFBmMec3Ua9KjFpJtzEntU4uUnp4e17EINT4Z8F8GWT7DtW79EUYLPpTYffZVH8r5ugFaHoyw+VxCIkMM1pYJpMA/d+wjVwFUxN3r5JjXL1YeolnL4zagzbXB8qGdqgs7UgLB5olIgvZv1RnKRGWNl59Am2dO5FsuyqpvYNmJBy4uqKYWXveRPlS7n2sENXYFs0Fmgzv2fgQc9zVwYV2xFtNQJk1gTJ7pm6vepIWcg1tgw+F68PiAl2O6/1MVozHxiz3ofBPRIiaODOtgUKWSWB9KoVpwkYI1GWx/yFuxIUqLHyaE5z6YCvTQWs6gSDZAT0tItnSpfet1EbLnAtcxUNouZ0rY2ug5J6ATlq7i76Ex89MwqaiiKhewlz87wjb3WS3CRG9dglPhCkB4UYjnzxi09jsfDWESBtScH34MaYANJpoLm/E9cWOgxp5TYhGTawMa2SyD2YouDKSCuGHHtPbuWFPQ+cJqaFxm/t1UL1VfMpDreVAeUh8Como8qgI9XAXrsf/nQNGtt3mDI0yF5G+4YIJdPLPm0Ra1HcHk7YTofWrx6e9yB8XGFmdgnlRJhtGGIC6EyX4aZAVCfr/huVx7AqAQIS88GVlnUJ8xavN366YiQhwp82tMGvjqO5MvN4g3tz9tN4mqk2OZt8Y0TKLPyf/34a38XL+c
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(508600001)(5660300002)(2616005)(38100700002)(83380400001)(8936002)(64756008)(4326008)(8676002)(33656002)(66446008)(71200400001)(66556008)(66946007)(66476007)(91956017)(76116006)(6486002)(38070700005)(54906003)(36756003)(6916009)(122000001)(6512007)(2906002)(53546011)(186003)(26005)(6506007)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9CLazAEWbRTYsOnoZtE9/Lovs3m1KsxfXGH8fuPw3l1ZYGhm/BBEhiuZCXjT?=
 =?us-ascii?Q?M52y3GVYFVabtqFkWqYP1Y/pCiUalnMO57bHi40Y+CTsXyqhXAsKTRVy0Z7q?=
 =?us-ascii?Q?RlDl5MNDMCqQ+HkYQ7ydInQOV8jt2tyu8Cktb3jafDSn50QTfJr/+9F0aJ9X?=
 =?us-ascii?Q?q/1LtaMgx5il0tshQT9mg84VsTZhlI2kKWlXPBaoWWVqbp34u1npfVpJBp6E?=
 =?us-ascii?Q?UHiD4kCOdgM+2H5RNVBl5ESXP4PRbXYPGqsms9O+QrWHbGTF3jzE+qiomfKR?=
 =?us-ascii?Q?8ydy9Lw34NwpeYouHAcfu1c3AgzycUEnuVS7Qpy005HUxzSO8UdgENfMZ3ec?=
 =?us-ascii?Q?gfjT0wlWlwCDSfkOze+mB9skyrggKIQba70QXUqI65Kq0sdq3cl5UZ2kummI?=
 =?us-ascii?Q?xDXBvqiwZ4OUZiew0R+wSktiSYIuTH5dg9C8AaP0xMon4bJNdkz+ht76MqxB?=
 =?us-ascii?Q?8S+mSU/kLRVlzQtr5sxWpxvA5Z6FIojNEOX/Q4MS77LxI3Y5K45/kKo0w8p5?=
 =?us-ascii?Q?NZLkDUeQAtrQdv515Nr6EbtY92nHMqbrGEJhtgxfVnkuxaAoiopLXegeNEA8?=
 =?us-ascii?Q?oBhy2fguaZtkKjvNCo46hoaF0SoO8L+X74sfTMkdBvyrg5944HOGVPyrsx3u?=
 =?us-ascii?Q?OX8ZkhhwvMcU8DzUZqvteIHv5jbI5FGbGkeTazN9q34psZs3wOv7HvCILq/2?=
 =?us-ascii?Q?a+IALZsvkrjunAQtc1/fNzKplml7SLEOE5NcdiI+3vSCKYJCIJA8S2lhUvnD?=
 =?us-ascii?Q?VBQY6v7OuTa4XCn6E+K94AXedpVnfkGLQCVyUbeHwf0QjiH1Rj7f3tl9+MWd?=
 =?us-ascii?Q?48aF2oRTIt2LOKhVIsjwei889ApZBWLyqOAlhKpSNRSRS7s5v16JG9udYG0Y?=
 =?us-ascii?Q?31VtkqIUHwxhATlyckJD5eoWdtGmCBbTdThH/OjEty+22KzcctBpDPO0Muxt?=
 =?us-ascii?Q?8TZ4VnixeNfYlYkNdcl9HyC3UrwGTtWzJMoX63scPmH2rl4R2GEZTE/0NcVM?=
 =?us-ascii?Q?GGpTZECsOKtUYs9jOiIMPnC5GsXbLurMniDwmR6Z3oJu6ZkAa68Kcj2pLsUk?=
 =?us-ascii?Q?mjGk3Uy2RDXK4tciFzuUjgWqfC0QpHforWpwPRuyIvQFZKWuqs6bPYejPoRH?=
 =?us-ascii?Q?hxPAO1heoEXsl3XgIlgZFPw4M72P9rIIjwnh7J3b4K4u44pSkxkHjqOg+sJO?=
 =?us-ascii?Q?2V7yRwsFG/M+6GReMH32PAd6aqM9MI0h+jMLpdgrRVBVtyA/bcYcak9HEkme?=
 =?us-ascii?Q?hWACfAWLQsjElnzDKH9GPEgE3xM+E9z/BZkCLx/cPDmDhb6xZ1Fr2Qlua7J1?=
 =?us-ascii?Q?oZPyki9kiSr4EPz+/rpSuGEHtreUhtwl1HNnENNhb2kQO/S8DbzRnuQVInqo?=
 =?us-ascii?Q?H1tJVveDdZUPSA6zjPohPC/rXGdV8d9GdAkPTRBMEEDxoX12eBEBwNqlFIuE?=
 =?us-ascii?Q?OBq/f7rrpZzZKmtXTrj/+hA17aa5k9nfO7J8oxEvolUQFULptq0JRF2DRNBi?=
 =?us-ascii?Q?dHrFWtpZDh8SjYMBbNwRtM8XetSJ5a1aSKkMV5kPmquhBU0MqGWckK3PhyYg?=
 =?us-ascii?Q?wWhG12GOMWE53V8RQ/JJdYE6Syhl7IklJCAefDOh1o01ZjFcBWjEx6f4Ywph?=
 =?us-ascii?Q?Wb1JCQxu08iog1An9PSLuz2HJzYQOSX2Mgq1Dx8lRrB7SwN2D/Be0bbNX8aB?=
 =?us-ascii?Q?7C7tIiJaryYvgm2OxUq59SgKXx/9KXnqWwEF/av58BqrFPFvwcTWFrIjn9sC?=
 =?us-ascii?Q?91tRDZBYR6oG5vWu1Fnm1M5G+t2/DDI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AE46CDEB9A0DA04BB43F0317F513ED5D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b3dcb1-f293-4da3-9132-08da2230c187
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 18:16:42.6070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GpbdInB6l2iHbv2BSZ2KyjzX30h9vZRljYw4kulHN3wfN6BViGRumdfoweK0dyYMY+yOAFXXHhcX/HbJUdMeAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2860
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_06:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190104
X-Proofpoint-ORIG-GUID: Q3TkknMt_QYkzTFv6OOhSLNDWymRfRNn
X-Proofpoint-GUID: Q3TkknMt_QYkzTFv6OOhSLNDWymRfRNn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 18, 2022, at 10:57 PM, Trond Myklebust <trondmy@hammerspace.com> w=
rote:
>=20
> On Mon, 2022-04-18 at 12:52 -0400, Chuck Lever wrote:
>> Introduce a mechanism to cause xprt_transmit() to break out of its
>> sending loop at a specific rpc_rqst, rather than draining the whole
>> transmit queue.
>>=20
>> This enables the client to send just an RPC TLS probe and then wait
>> for the response before proceeding with the rest of the queue.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> ---
>>  include/linux/sunrpc/sched.h  |    2 ++
>>  include/trace/events/sunrpc.h |    1 +
>>  net/sunrpc/xprt.c             |    2 ++
>>  3 files changed, 5 insertions(+)
>>=20
>> diff --git a/include/linux/sunrpc/sched.h
>> b/include/linux/sunrpc/sched.h
>> index 599133fb3c63..f8c09638fa69 100644
>> --- a/include/linux/sunrpc/sched.h
>> +++ b/include/linux/sunrpc/sched.h
>> @@ -125,6 +125,7 @@ struct rpc_task_setup {
>>  #define RPC_TASK_TLSCRED               0x00000008      /* Use
>> AUTH_TLS credential */
>>  #define RPC_TASK_NULLCREDS             0x00000010      /* Use
>> AUTH_NULL credential */
>>  #define RPC_CALL_MAJORSEEN             0x00000020      /* major
>> timeout seen */
>> +#define RPC_TASK_CORK                  0x00000040      /* cork the
>> xmit queue */
>>  #define RPC_TASK_DYNAMIC               0x00000080      /* task was
>> kmalloc'ed */
>>  #define        RPC_TASK_NO_ROUND_ROBIN         0x00000100      /*
>> send requests on "main" xprt */
>>  #define RPC_TASK_SOFT                  0x00000200      /* Use soft
>> timeouts */
>> @@ -137,6 +138,7 @@ struct rpc_task_setup {
>> =20
>>  #define RPC_IS_ASYNC(t)                ((t)->tk_flags &
>> RPC_TASK_ASYNC)
>>  #define RPC_IS_SWAPPER(t)      ((t)->tk_flags & RPC_TASK_SWAPPER)
>> +#define RPC_IS_CORK(t)         ((t)->tk_flags & RPC_TASK_CORK)
>>  #define RPC_IS_SOFT(t)         ((t)->tk_flags &
>> (RPC_TASK_SOFT|RPC_TASK_TIMEOUT))
>>  #define RPC_IS_SOFTCONN(t)     ((t)->tk_flags & RPC_TASK_SOFTCONN)
>>  #define RPC_WAS_SENT(t)                ((t)->tk_flags &
>> RPC_TASK_SENT)
>> diff --git a/include/trace/events/sunrpc.h
>> b/include/trace/events/sunrpc.h
>> index 811187c47ebb..e8d6adff1a50 100644
>> --- a/include/trace/events/sunrpc.h
>> +++ b/include/trace/events/sunrpc.h
>> @@ -312,6 +312,7 @@ TRACE_EVENT(rpc_request,
>>                 { RPC_TASK_TLSCRED, "TLSCRED"
>> },                        \
>>                 { RPC_TASK_NULLCREDS, "NULLCREDS"
>> },                    \
>>                 { RPC_CALL_MAJORSEEN, "MAJORSEEN"
>> },                    \
>> +               { RPC_TASK_CORK, "CORK"
>> },                              \
>>                 { RPC_TASK_DYNAMIC, "DYNAMIC"
>> },                        \
>>                 { RPC_TASK_NO_ROUND_ROBIN, "NO_ROUND_ROBIN"
>> },          \
>>                 { RPC_TASK_SOFT, "SOFT"
>> },                              \
>> diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
>> index 86d62cffba0d..4b303b945b51 100644
>> --- a/net/sunrpc/xprt.c
>> +++ b/net/sunrpc/xprt.c
>> @@ -1622,6 +1622,8 @@ xprt_transmit(struct rpc_task *task)
>>                 if (xprt_request_data_received(task) &&
>>                     !test_bit(RPC_TASK_NEED_XMIT, &task-
>>> tk_runstate))
>>                         break;
>> +               if (RPC_IS_CORK(task))
>> +                       break;
>>                 cond_resched_lock(&xprt->queue_lock);
>>         }
>>         spin_unlock(&xprt->queue_lock);
>>=20
>>=20
>=20
> This is entirely the wrong place for this kind of control mechanism.

I'm not sure I entirely understand your concern, so bear with
me while I try to clarify.


> TLS vs not-TLS needs to be decided up front when we initialise the
> transport (i.e. at mount time or whenever the pNFS channels are set
> up). Otherwise, we're vulnerable to downgrade attacks.

Downgrade attacks are prevented by using "xprtsec=3Dtls" because
in that case, transport creation fails if either the AUTH_TLS
fails or the handshake fails.

The TCP connection has to be established first, though. Then the
client can send the RPC_AUTH_TLS probe, which is the same as the
NULL ping that it already sends. That mechanism is independent
of the lower layer transport (TCP in this case).

Therefore, RPC traffic must be stoppered while the client:

1. waits for the AUTH_TLS probe's reply, and

2. waits for the handshake to complete

Because an RPC message is involved in this interaction, I didn't
see a way to implement it completely within xprtsock's TCP
connection logic. IMO, driving the handshake has to be done by
the generic RPC client.

So, do you mean that I need to replace RPC_TASK_CORK with a
special return code from xs_tcp_send_request() ?


> Once we've decided that TLS is the right thing to do, then we shouldn't
> declare to the RPC layer that the TLS-enabled transport is connected
> until the underlying transport connection is established, and the TLS
> handshake is done.

That logic is handled in patch 10/15.

Reconnecting and re-establishing a TLS session is handled in
patches 11/15 and 12/15. Again, if the transport's policy setting
is "must use TLS" then the client ensures that a TLS session is in
use before allowing more RPC traffic on the new connection.


--
Chuck Lever



