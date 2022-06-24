Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584E1558C2B
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 02:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiFXAPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 20:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiFXAPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 20:15:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEA756749;
        Thu, 23 Jun 2022 17:15:00 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NK2l1t009474;
        Fri, 24 Jun 2022 00:14:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=bGYIEKUc8hMq2tf6u9yAjgmoGR7cK1D49RLfg4Oz8Co=;
 b=praxQp5+y1xHpGTHOlNlwTs7yAsxj7WvpsxE/4q+OZBV2wuz1Kt4h49jVPUTx85n/jL+
 YVce9tjBqD+AkMt9xrtq4MbyMyi6Qph2Cu6e5HT2fxCpO/YqgazIKX1BkgG/yyBV5pmB
 P4kjrw/oZ+w4Y3C8h8w/v0C/m4D+G5GxYaNd8FI5Ahj3JAod3Wyh8DwDlllJR3hqeCIh
 8w0SJ5/XGx/JqWkTv+7EkxAsG1XKQa4um40EMi/JWosXuJRAiE0SGUmosCycQQOI+omw
 fQKcFQv26OhW0ttR/Gdw1qQa2Q5MPLLNcoPq/UT4qF7QCtYteBumHjnm4WSbxWzAuoIq nw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs5g24nbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 00:14:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25O0AdQa034448;
        Fri, 24 Jun 2022 00:14:56 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9wsdcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 00:14:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y33BSfRPluBtQx+g4u4eQ7+8torLIV+kE45l1qZcq7s9U2SRVREsg40nyOkxSkJcMVWbAM2Rnb1ejt2wh+kKZy6vmQNgJoozdBQa48WBZUMiibE6K0nwOd5YXrgHEdwXlWyFLFCwEY8kH9/y8nikVc/SjAeXFTit2ZsiTyTVn9WynEMWySeWln3HWNydt9FpfchSmgkQO6L4ndZuP0Yphff/xRICiENqbqjU7+FLtCgqs/Y63Hy5piE/WEG6I3nP7XndNW+yYDngmuRV9aE06P9QVBEeVw+CQjmnoQA2niAjUTVA1m+KDkIjO3maQxoHT5Ux1K+eGSTWp1N37Z6Xeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGYIEKUc8hMq2tf6u9yAjgmoGR7cK1D49RLfg4Oz8Co=;
 b=fRhEBIAWt0V5TAKfVlUVBOyNfxh/JjHFnkxN7wqmft2EU5fjRcmWkth5IA2s7plpN50abZhSPgk4gXCj7evwGO3FE3wCMMnp0/tzJyLNbIwaXAiydJVw0B9hQcYPYwinL+jPD5Qc709VO4a4yh71qaQKDmFVO7AD00qvb0E72jGs23i1Y6vMKszzg9DxYNoesyE3mjSEwnQpHaFDCBxwuvST7Tgwfn+qRhGCSHeRN1riUGDtYW61OhxUKPH33/zsbb1zxPd8UacBN2K3UXZKqaDYVqm0JTYey0d4aNRw6KfZu+xmqZyQ5TUyQ28QEQQNJujbo39cL5NY4XgyoGhoOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGYIEKUc8hMq2tf6u9yAjgmoGR7cK1D49RLfg4Oz8Co=;
 b=nZ89HhSlm1hNOGmsVAujFmItvsD+hVUz55qm4v9b2A/oC9qY4hhMxfY9SoP9kUacnVupmHT86SwOlThdRZKDJCa4x3Get9/g1E+85tsq4/ukCqojnX+Loi7l4a+lkbzHrqzvaDTiLaW2DtEqxH0K7FMUQPb0yGX09vKiRlJ0sGw=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CY4PR10MB1862.namprd10.prod.outlook.com (2603:10b6:903:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Fri, 24 Jun
 2022 00:14:54 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703%5]) with mapi id 15.20.5373.017; Fri, 24 Jun 2022
 00:14:53 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 28/30] NFSD: Set up an rhashtable for the filecache
Thread-Topic: [PATCH RFC 28/30] NFSD: Set up an rhashtable for the filecache
Thread-Index: AQHYhkLIv6uRbtoPJEu5Zs/9WvV7ta1dnH2AgAAPTACAAAaKAA==
Date:   Fri, 24 Jun 2022 00:14:53 +0000
Message-ID: <4417FB68-83C9-43DC-BB57-122D405302E7@oracle.com>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <165590735022.75778.7652622979487182880.stgit@manet.1015granger.net>
 <YrTvq2ED+Xugqpyi@ZenIV> <1E65ABAA-C9D9-41F3-A93C-086381A78F10@oracle.com>
In-Reply-To: <1E65ABAA-C9D9-41F3-A93C-086381A78F10@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8dfeb9c3-5e9e-4959-6c15-08da55768ffa
x-ms-traffictypediagnostic: CY4PR10MB1862:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W15ouiGkRTeeAqsqKznYJ7mUkrUJiPMONGHfsySY1rAS60QI05mIYUjgODHteNhgKwSh0d/5WJe1itTcUIL5mLIZQOaieNPVXVtfpxEHILYRAA4V85MqSv5sJ+0g3YgUY97MI+E1onCuIbvgLm/SNJvqpYzINl5EZPu78ChkHBH2tK6Ts7/b0ksPnmVnfHTj0gNrxlF1BuzwfoPJTIejnFCzCuHja7nFHsFMFqe25BHomUQiioNnTFNlP79NtiLnW93OHdE4/DGYH8yumFe8L+7/39pnW1JR0sqVhwwQeRhex8LOW/HrYOocnTeq5Z9ULGIPmVNmKpU+Q1TcKnGPcXg0dCXu+7BHI2fAo0e0tUD4ReWeMWpKDJaz5QgHYFDC5AU3ISqcmiqx1nSobS5jd9noqmMtEEih6l+niAh5SKpqAt2Bh0ACOipZ6hi/1Bebqo0ZkLtTMJ16bUahXpyExYwvrHY269jjYR43mJvZVjb9lXuzkBpgF5bFsdw+YCo7N6ba/ofduNmt04AdHZQjdrcLK+ZflNhkWhlr+Cah65z34b8KnY3O3itPpYAx92JhVcmtb5a4ONSX9QDtCA72ZTUB646mdXCoVd8NQbFCJna0SeOvQPxtAMlAU8b7BMP2sBcJMSz5dTP/LfcJgzY42H8UrDgByXaAVuP2Oeu94utBI40pIX2dbQnEhg6ZgCJXbCXOomcA/W3xZa5yFUw0CZjs4fAGG6u/wYwwxDbZG35b/MMjIm5JXukD7clETCHSINsDNWVSYWS3ADlic2qeI/Q7FgXEHJhfsn0HoRCjwBlItYGcpqsJHlVnTA+rNwi5JyFUhOakrWARkNJAy75/RQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(366004)(346002)(376002)(396003)(71200400001)(54906003)(4326008)(66556008)(316002)(26005)(6486002)(478600001)(8936002)(53546011)(6506007)(8676002)(41300700001)(66946007)(76116006)(66476007)(66446008)(6916009)(91956017)(64756008)(38070700005)(2906002)(6512007)(5660300002)(186003)(38100700002)(122000001)(86362001)(36756003)(33656002)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FEAd6IgGu8bBvUFBn4asFR2qdoUoOvGMjS1HuoQnTx1BPewKzoX+vQlhZ+tz?=
 =?us-ascii?Q?mearlS/ktoSn0nut5iVQUVVO8NFVvtkp9c454z8QPstBzXEQHpSZPQCzkXkx?=
 =?us-ascii?Q?QTUnlcHpTvZqaoViXs0xxPF1ev2uSw+gx81n8hFvFBHlqcHIwaDOlJsSWmsu?=
 =?us-ascii?Q?+mhV8EGd3LkVGwYrz8+RBY/oC+X6ufidE79rvRT9+6hPkkqa6iCewF2Bmf4D?=
 =?us-ascii?Q?X4jlYdQGbcPPHZHig19WyGZDfRQwZ2i22N92QTi0X1FnFxfv/1wf+ECojE0T?=
 =?us-ascii?Q?i1yvdOGnZRCwkYkPzVyAcaPae5gYbcTACFbaYBBPzoRHC8jQ9p/ZsD6GaGo8?=
 =?us-ascii?Q?NQq6n+8fKDaYobWO+7GzU04MU0DnQ8RWBXo9gO8T3w0MBz8nAk2btuxi6zhI?=
 =?us-ascii?Q?Cy98g+/aAisYvTlEi8N74YVhA3kge9Gxwf7MyoB2toji0rJEVU9c0ZJ17gRN?=
 =?us-ascii?Q?7l2x50bW3t+d6A0cyqcVa61fX/QlxSomuC2FahG7HXYYGkcE0UsqoccSqXKJ?=
 =?us-ascii?Q?+IqCn+HVgHPCSfX9i9KFMlYPM3YgGI8nIm7Kwfv2jsyC4X/4pyo7vGwbD5Yv?=
 =?us-ascii?Q?Phx3rQdjkH+RCrOu5ZsFuMccSCQSOMhfLUDOptinYr37YUO+D+EH6fvUuPL0?=
 =?us-ascii?Q?uTvD0IpDjoQXio9dpYVq/5e8grq9PpjpqSfvEhu17NvVXWwx1P/FonbYP5Kq?=
 =?us-ascii?Q?tZ6GjJktxrLj9gF0ZrGt+Qw2LwX76RPj69AloyYtL1Ckc7rBktvRJV3CGM9v?=
 =?us-ascii?Q?yHyRt4sISgCgmEhIrHZrqIwbMzK5zyxwfjh1WHD+oqZ7xOSKIs9xi0a1EP4T?=
 =?us-ascii?Q?vbO71wGAttLrYzYTuajnbnoB63rISTVHuxMJNMlE7RhjoSZrhY9U2w2VwUVh?=
 =?us-ascii?Q?OeJh+NTQiHgfFe9gGT5WlXZXX4WsZwRUAPxFUIEPyPFilGwljbP0gWLD0hLP?=
 =?us-ascii?Q?sVALxT2YWu+0eXO0+Wo/Y/W9NPqZetVTcXLTzPjy4OzzGR0+BC27Jy/Mr1QF?=
 =?us-ascii?Q?+tNDeJPLdSVSGvCdr21lYyriv39/Xle6Slfs87NDvQwoRGO/rEVQBTZLpY8d?=
 =?us-ascii?Q?U4o3SIYPsCgcOC5iIzodyN6VOmYTLQ7oUDJ/G8a2pPFwTYRfPXlnHFrtcIfv?=
 =?us-ascii?Q?6YzYAvDARQVnYWWAG1bp/+JboSEvd12ycbCoqZCELyHdjCPHfryUyIxoUnq/?=
 =?us-ascii?Q?DXKINE5ojnrulaj9gjfNy+XG1ykqq+AWAQp/oOZfd5zb9YoZlnwR0jxibNWK?=
 =?us-ascii?Q?kGNOTjje84woMR0QdNHTwCTGGDeicILx2RSxvVt+fEEGSgQP9Ol4fkGaoy30?=
 =?us-ascii?Q?kXUDTIPQVbiTxrtWf8PTI9QBkD17txy8tAyQvOkiN8cGCD9J0Lvv0Z7URj7L?=
 =?us-ascii?Q?sA/ik//jnG8iacGiGydV4jvToojvgzs4CB4DZqFOzPz2OP2nV/BRWrftVhk7?=
 =?us-ascii?Q?Ao0S8pSM0RlnziACKhjxZklBvlEOHKjdaLgZdDLljv+ucQmLld51PR2X1SDY?=
 =?us-ascii?Q?3THfpSgq9Fa39sSHC/2MCYIYNSxHly9gOYl4/hyyRoDCs4PAdvmfKsMXyCjj?=
 =?us-ascii?Q?Qlz4wGi9MXhjFeOU8ZkOTj7P+v63waqgZZto93qWjta6jNW6dPaCNeS7qKMH?=
 =?us-ascii?Q?6Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19DB34A27A128D4CB36513E1F8D78FFE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dfeb9c3-5e9e-4959-6c15-08da55768ffa
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2022 00:14:53.5933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IclFPTbxHiXxExq0WMvv9gJyXJr/EP9t16CpbC4p9kLZ93cIo203KwDPmqclzeKEYOBpFrUj5mYl/os9UBflyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1862
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-23_11:2022-06-23,2022-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=844 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230094
X-Proofpoint-GUID: Ft758hIK8cqUTpqEx1IVQ5W2sQO2G2zE
X-Proofpoint-ORIG-GUID: Ft758hIK8cqUTpqEx1IVQ5W2sQO2G2zE
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Jun 23, 2022, at 7:51 PM, Chuck Lever III <chuck.lever@oracle.com> wro=
te:
>=20
>> On Jun 23, 2022, at 6:56 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>=20
>> On Wed, Jun 22, 2022 at 10:15:50AM -0400, Chuck Lever wrote:
>>=20
>>> +static u32 nfsd_file_obj_hashfn(const void *data, u32 len, u32 seed)
>>> +{
>>> +	const struct nfsd_file *nf =3D data;
>>> +
>>> +	return jhash2((const u32 *)&nf->nf_inode,
>>> +		      sizeof_field(struct nfsd_file, nf_inode) / sizeof(u32),
>>> +		      seed);
>>=20
>> Out of curiosity - what are you using to allocate those?  Because if
>> it's a slab, then middle bits of address (i.e. lower bits of
>> (unsigned long)data / L1_CACHE_BYTES) would better be random enough...
>=20
> 261 static struct nfsd_file *
> 262 nfsd_file_alloc(struct nfsd_file_lookup_key *key, unsigned int may)
> 263 {
> 264         static atomic_t nfsd_file_id;
> 265         struct nfsd_file *nf;
> 266=20
> 267         nf =3D kmem_cache_alloc(nfsd_file_slab, GFP_KERNEL);
>=20
> Was wondering about that. pahole says struct nfsd_file is 112
> bytes on my system.

Oops. nfsd_file_obj_hashfn() is supposed to be generating the
hash value based on the address stored in the nf_inode field.
So it's an inode pointer, alloced via kmem_cache_alloc by default.


--
Chuck Lever



