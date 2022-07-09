Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21ED656CB6C
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 22:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiGIUpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 16:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIUpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 16:45:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9445663BC;
        Sat,  9 Jul 2022 13:45:13 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 269D4UFa013914;
        Sat, 9 Jul 2022 20:45:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=TzMyXpcCM++JwEyfOGxab/95Jo5sjIfqpzScHR6PjAw=;
 b=Ar4Y+teb/JvKJEkqoSE1t6z29dT9Yx44L6QerlpGK+3+rT/JHlVRHQELt9UYn5qEfcLe
 ON+omvkEc/YSsoHgKaYvp2IXZHFs9xudXuXxHvhXWs4qnecd4QVXappy6FTYKmtZ6TSh
 AkvZLr8WfJpVicpGRKgYFDM48k2h/WemFgXhLYOl9wx12Gd721vkYnQu21BeYr9FLclw
 oEqCk0tY/E90kfukKCNvaqyVO2eW6QtruPdDU+3qYACUplDsS6eQNvYsNNTKSwJfJG7/
 kTzZP1R0vE6GnH0GLAHiBeySTqzFM3fARhPiqgGcXZ8cie3Ssx92JxxLsjTfIACuHTUN jQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71sggrar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jul 2022 20:45:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 269Ka1Ql028114;
        Sat, 9 Jul 2022 20:45:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h7040y9my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jul 2022 20:45:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L518+v/JnJQOOlnbqEPo7XU7tkHFwbquCXiBFZSNc5xRBAakXTYhuaE6eINqPVAeFNHfnY9/VA5lxX1be8qG2JuqLNQlUi3qb8ahtv373fDZq9yEWbjdz4izliy0wXXPFazAnb2uX/FJ/ReLkoUYl1SDIsIHlkV+kaI5ASvdKxUuQKlOdTWkvPxbmcDqvwmSIhZagS3zzDz9uMvGj7cQQ1RZvQ/f6JkFDemUDGFyJcRurHXq99ORSX/xnGGHpYLChUN44ebmDOfzCqmulvBU/xxfbF4Ow8vfvmgJ96UAlwbn2KN5v/oYOf0WSfyJOtE+cJglX9m+JsxnONgmzUa7JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzMyXpcCM++JwEyfOGxab/95Jo5sjIfqpzScHR6PjAw=;
 b=EaiWmd6zrBSrQ7EwVVY4qEvNonjBmAnIf627qpGxT4/ssU6gd7IqPdn4KHUmz7tW9tIm99uiWvhWaWxj1cSxeHXwbir8jlNpXhtNg1pXLer12PQZbAY5claS4FWlHMx3yh4WellPGWQyOB+FJPTQ5inJhdAL+/pqb8Yhm50RpUZhljEhCGKcXc8L3nQQBGhl4TCxOGC4dxFnsJfS4DzcNLI5VMnWydTbZe2hcOTTUJVLto2Nr7IVwNsbtLM8BXx4o2Fba5zOVFLxzYbDTVWNaeJpKF19mgyCaM35XOoTEiVEb4Q89KSEIVTDbhyGo9H6s7n6syR+2nrSFpqsQwoCNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzMyXpcCM++JwEyfOGxab/95Jo5sjIfqpzScHR6PjAw=;
 b=OBgIMWLSauzjAKyiYMAQjgLCutf7yEGqge90VEj7G1vNdw9pOBQOdUC0419OOCxc6fF5ra+sRcsVsYzNXgne1YF6pFibn/MV+SKlr2ZAZeJ8uJeAodY4XM4AcgMVz5O/L5k+LNi/d2bBvrAa7WP5VtJW90nzx08FK2OFbzMg1zE=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CY4PR10MB1557.namprd10.prod.outlook.com (2603:10b6:903:23::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Sat, 9 Jul
 2022 20:45:05 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703%7]) with mapi id 15.20.5417.020; Sat, 9 Jul 2022
 20:45:05 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jeff Layton <jlayton@redhat.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>
Subject: Re: [PATCH v3 15/32] NFSD: Leave open files out of the filecache LRU
Thread-Topic: [PATCH v3 15/32] NFSD: Leave open files out of the filecache LRU
Thread-Index: AQHYkvg8JrllNf6d90GqMYl2WyBNLq103EOAgAGnVAA=
Date:   Sat, 9 Jul 2022 20:45:05 +0000
Message-ID: <BC4E1A0C-1404-4C50-ADD0-3999DEE01066@oracle.com>
References: <165730437087.28142.6731645688073512500.stgit@klimt.1015granger.net>
 <165730471781.28142.13547044100953437563.stgit@klimt.1015granger.net>
 <2af895fcbdaeab04773cbce275ca7a6d59b879cf.camel@redhat.com>
In-Reply-To: <2af895fcbdaeab04773cbce275ca7a6d59b879cf.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6bdfe97-0c18-438a-23a0-08da61ebe77a
x-ms-traffictypediagnostic: CY4PR10MB1557:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ce8Xbx9CtqaGS3XWWW7trHzZs9LLYMqNVcq1Dg5JHPjINNpPNVQekN2sSH+c1O5pVJqtnP7QDaJOsCJlpv/WNwOvcmngvJj0owkv8K1h2X1qdJWeD04Kei09i9LOAZL3rD+evkaJF8em/s4uuPf65edfX+bsCKz531Hk917dy7FZd8NBN/gDKjkPnYUfaxMjTnfrZ77gs8e+RoQI++LlehRTqG0zhrSOQ+f+TmVz9Qb9/fHjshQahqLaPHYHfLRS0hAdvkP7T3YY7wDdzLxSkSTXEUTyXhzl77SBWoM5dK4nD18CS1NMkYIvN8W+xToKcvSePsj3ZGasmIwMVjKK4o07zyfxW20aJmhbQ36AvpuCTqGhn/c1zNnF4aZFRnribi5Hx9xRd3LNQR2X+mUaDXPqpkg/53C/sfVmrDJXnXgucY+H+Txzu2/E9G3MTS96yTMB9e6DvqnRqSgHNKL0rjXA6lUpkhwGV/qs7Nmr1VJSiOFvBxFnQNrfkAIrMbYo8iXaAI7ais7OV+BDDn48Go6bzc9Y9VQnQLhdyiTTqsVSOKRusUAYQlOvhdYTsGvGPXUlq4WncW5y/zvkdw0MW5BmZ9dszExvBl0+lvAhzlhftrNGYyQ6LrbIIhTVS8LeLvy2BS1UllzzuJx/Pm8Q7W7SPVHFSmm9/SeMarsEZbVXdpQl0CdOxKJ9Im+ZXVChe99o85QyhN9t+B57kkFcUxc5SWW9ihRzSNSf/7X0qvImEwY9ej+r8SpLqEh3rGFP+Hq2/xgzQT0bF6XE0m/Dm7QT08Ed7H0yqlcyXPWJ1zoGCAMz2u9WjfNWO4g8GjdUT18zD2PwqLF2ofSb8PZ3ax2XYHlyB6kUNtq+biREjVkYCBvgVTRhor0Fe7niJGGL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(396003)(346002)(376002)(136003)(4326008)(8936002)(41300700001)(2906002)(66446008)(53546011)(26005)(36756003)(33656002)(71200400001)(122000001)(478600001)(66946007)(6486002)(6506007)(66476007)(5660300002)(66556008)(966005)(91956017)(38100700002)(64756008)(76116006)(8676002)(38070700005)(2616005)(6512007)(54906003)(83380400001)(6916009)(86362001)(316002)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P86hYti0N3w2ZJ7CIjDLJ+a86uHRrOmJamEL1jsGGKC64tJi3hkoW5ca1uey?=
 =?us-ascii?Q?uzNs2/xtqXsEEBEl1Y268HgPeWwP23guds5VQk1s9crfN+ix7DMCmTfLzxwB?=
 =?us-ascii?Q?Qe5AQymbriZ1m0AkLqxHG4NYq5J3M45bVBV5Yw8DG2+OvJgBSz5Bxnem1B5A?=
 =?us-ascii?Q?wuaVzKNrKvl6LKAMWK/+uYR95jiwRtSw6b7TepwkgZ8WTGe0L91l377TevpC?=
 =?us-ascii?Q?8m6VTw+oF1V7NCRhdWLqk9/9BXw+IjMcr9/x33csxR0AE72GPSSG7fMvrpB+?=
 =?us-ascii?Q?VQCDAB/QLFzaWE4CQ6BUytNKkh7CI5VwxXy8TUeOt9HgEvcLAAXICMrnY2ny?=
 =?us-ascii?Q?kGtrkepEaNkzLGsx9CEx2sJTwJVE7iedTUgmWufQwetySWyn5X7f07KkxWrN?=
 =?us-ascii?Q?akL4iZJn2yRoONNmX7AANruZyPUIbnhr5veyqAMSZL44mhXH6Sqje1aPKYvc?=
 =?us-ascii?Q?UVe458ENGoV5eRTeYvqiz3snPfoMVnw8tKOhF3QzVKCyo9ruKhHpbOGchsi3?=
 =?us-ascii?Q?2uiMQRNBpyUolrueNGCkEhLvSoq+g6zhHWo+pT3F02z86xrzgru80ULPcoWQ?=
 =?us-ascii?Q?soVv/Tg04g76oTHdCZzndiureCpZPk44QM/9anlQ9avD4QpJ/6MSkE/M/v5U?=
 =?us-ascii?Q?vE4CiLzwrF3rBB3GiwquujguV4/0/l1fIRl9jjM+toQvd0ctYoQIqn410DxH?=
 =?us-ascii?Q?s8kYIz6lyghkhpWqcZ2ySoS5O6d+39HKbtA7qOe8RlEtlKuBHKVCCo39soru?=
 =?us-ascii?Q?JU8usrOHfOKvPL4qbEEchVNnFwcOG48PPnu5vdm291aV13Ik6lT6c0jgAQSe?=
 =?us-ascii?Q?2C9NgAn5xL1au8s0UunnnMp636fRwVOVPGNC2hZR/ByRomGxzbJFicmhxUJW?=
 =?us-ascii?Q?mxCzp1NR8lIKgfHhtZpk8nGTetN6bQcpb/T6U0Zq3p3gh8/rl0MheXqfHUft?=
 =?us-ascii?Q?fvtLzSJMerKQWBZM3zFo9uvGsq62/0lCInXR5f98B8iLZSJjQ0+Sqd5zy3jN?=
 =?us-ascii?Q?mwOsNd8iLj8CgkoeSo/de+ruX6JxkqJlUqegZJfMyxtZYe0TTCi1fDASAUWH?=
 =?us-ascii?Q?8suhAln4R/w2wr13mpmhdrdPlcuFEd4oR7Wkkp5R4UaMWKmCGXbnkxVuyKQZ?=
 =?us-ascii?Q?2z6ikdz4RreutQaQxh7VndMhFGco/GMgrzaXJUx/SBMFbegNyWiOFzpODMaR?=
 =?us-ascii?Q?UMAIcLJdAOlGtZihnd5Tb1ZVB4hkFA/N84JV0qKsUubM+6IBDby3VLhLvsez?=
 =?us-ascii?Q?NkJ2gXAD8PjsnteKyKvmyy6rJto7ELz01dMmyY3biASqziFlpFWJuEmYbaTD?=
 =?us-ascii?Q?M2qRVrWTKmt7kVZR53i080kxGfi+ry/nCWGE44Xrm9VdVWxpDQsB3WAd7s2D?=
 =?us-ascii?Q?DcTpDn8oZDw1z4d6shVFFjjMUcagN+08EK1YqmLWN1xMx+G9sOad9ji7W5SO?=
 =?us-ascii?Q?w3GqMBDMyc5eXAFDn+rEFH4uWxhBkpen2wlZUqGrr7vWzBL8lDpTrxRUiYwt?=
 =?us-ascii?Q?R+dgp3QPmH0mSrFBzIaSqywt2PXL2ebNEIbThFpolvV0qbF/8OjQCNPY0C6B?=
 =?us-ascii?Q?GZjfCu+Ci+K4E/7uNVicjFPKHCvzgJrusnGGb4q0WQ8yskmC5mN+bWd2ZSUJ?=
 =?us-ascii?Q?Tw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6009F5B473C4E04E93C31B94E1B2B18A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6bdfe97-0c18-438a-23a0-08da61ebe77a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 20:45:05.4471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mxkCBBLXprLGor/rkWLkxLNUYd/mSKVU3EHJBg81nNs7vhummo+qAwRPBxQYodMSf4y0GNlWS0C7CxV0B8+8Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1557
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-09_19:2022-07-08,2022-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207090092
X-Proofpoint-GUID: TeS94cA5r_tkMmPEiER-hx5nGv7sfzi6
X-Proofpoint-ORIG-GUID: TeS94cA5r_tkMmPEiER-hx5nGv7sfzi6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 8, 2022, at 3:29 PM, Jeff Layton <jlayton@redhat.com> wrote:
>=20
> On Fri, 2022-07-08 at 14:25 -0400, Chuck Lever wrote:
>> There have been reports of problems when running fstests generic/531
>> against Linux NFS servers with NFSv4. The NFS server that hosts the
>> test's SCRATCH_DEV suffers from CPU soft lock-ups during the test.
>> Analysis shows that:
>>=20
>> fs/nfsd/filecache.c
>> 482 ret =3D list_lru_walk(&nfsd_file_lru,
>> 483 nfsd_file_lru_cb,
>> 484 &head, LONG_MAX);
>>=20
>> causes nfsd_file_gc() to walk the entire length of the filecache LRU
>> list every time it is called (which is quite frequently). The walk
>> holds a spinlock the entire time that prevents other nfsd threads
>> from accessing the filecache.
>>=20
>> What's more, for NFSv4 workloads, none of the items that are visited
>> during this walk may be evicted, since they are all files that are
>> held OPEN by NFS clients.
>>=20
>> Address this by ensuring that open files are not kept on the LRU
>> list.
>>=20
>> Reported-by: Frank van der Linden <fllinden@amazon.com>
>> Reported-by: Wang Yugui <wangyugui@e16-tech.com>
>> Link: https://bugzilla.linux-nfs.org/show_bug.cgi?id=3D386
>> Suggested-by: Trond Myklebust <trond.myklebust@hammerspace.com>
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> ---
>> fs/nfsd/filecache.c | 24 +++++++++++++++++++-----
>> fs/nfsd/trace.h | 2 ++
>> 2 files changed, 21 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
>> index 37373b012276..6e9e186334ab 100644
>> --- a/fs/nfsd/filecache.c
>> +++ b/fs/nfsd/filecache.c
>> @@ -269,6 +269,7 @@ nfsd_file_flush(struct nfsd_file *nf)
>>=20
>> static void nfsd_file_lru_add(struct nfsd_file *nf)
>> {
>> +	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
>> 	if (list_lru_add(&nfsd_file_lru, &nf->nf_lru))
>> 		trace_nfsd_file_lru_add(nf);
>> }
>> @@ -298,7 +299,6 @@ nfsd_file_unhash(struct nfsd_file *nf)
>> {
>> 	if (test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
>> 		nfsd_file_do_unhash(nf);
>> -		nfsd_file_lru_remove(nf);
>> 		return true;
>> 	}
>> 	return false;
>> @@ -319,6 +319,7 @@ nfsd_file_unhash_and_release_locked(struct nfsd_file=
 *nf, struct list_head *disp
>> 	if (refcount_dec_not_one(&nf->nf_ref))
>> 		return true;
>>=20
>> +	nfsd_file_lru_remove(nf);
>> 	list_add(&nf->nf_lru, dispose);
>> 	return true;
>> }
>> @@ -330,6 +331,7 @@ nfsd_file_put_noref(struct nfsd_file *nf)
>>=20
>> 	if (refcount_dec_and_test(&nf->nf_ref)) {
>> 		WARN_ON(test_bit(NFSD_FILE_HASHED, &nf->nf_flags));
>> +		nfsd_file_lru_remove(nf);
>> 		nfsd_file_free(nf);
>> 	}
>> }
>> @@ -339,7 +341,7 @@ nfsd_file_put(struct nfsd_file *nf)
>> {
>> 	might_sleep();
>>=20
>> -	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
>> +	nfsd_file_lru_add(nf);
>=20
> Do you really want to add this on every put? I would have thought you'd
> only want to do this on a 2->1 nf_ref transition.

My measurements indicate that 2->1 is the common case, so checking
that this is /not/ a 2->1 transition doesn't confer much if any
benefit.

Under load, I don't see any contention on the LRU locks, which is
where I'd expect to see a problem if this design were not efficient.


>> 	if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) =3D=3D 0) {
>> 		nfsd_file_flush(nf);
>> 		nfsd_file_put_noref(nf);
>> @@ -439,8 +441,18 @@ nfsd_file_dispose_list_delayed(struct list_head *di=
spose)
>> 	}
>> }
>>=20
>> -/*
>> +/**
>> + * nfsd_file_lru_cb - Examine an entry on the LRU list
>> + * @item: LRU entry to examine
>> + * @lru: controlling LRU
>> + * @lock: LRU list lock (unused)
>> + * @arg: dispose list
>> + *
>> * Note this can deadlock with nfsd_file_cache_purge.
>> + *
>> + * Return values:
>> + * %LRU_REMOVED: @item was removed from the LRU
>> + * %LRU_SKIP: @item cannot be evicted
>> */
>> static enum lru_status
>> nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
>> @@ -462,8 +474,9 @@ nfsd_file_lru_cb(struct list_head *item, struct list=
_lru_one *lru,
>> 	 * That order is deliberate to ensure that we can do this locklessly.
>> 	 */
>> 	if (refcount_read(&nf->nf_ref) > 1) {
>> +		list_lru_isolate(lru, &nf->nf_lru);
>> 		trace_nfsd_file_gc_in_use(nf);
>> -		return LRU_SKIP;
>> +		return LRU_REMOVED;
>=20
> Interesting. So you wait until the LRU scanner runs to remove these
> entries? I expected to see you do this in nfsd_file_get, but this does
> seem likely to be more efficient.
>=20
>> 	}
>>=20
>> 	/*
>> @@ -1020,6 +1033,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struc=
t svc_fh *fhp,
>> 		goto retry;
>> 	}
>>=20
>> +	nfsd_file_lru_remove(nf);
>> 	this_cpu_inc(nfsd_file_cache_hits);
>>=20
>> 	if (!(may_flags & NFSD_MAY_NOT_BREAK_LEASE)) {
>> @@ -1055,7 +1069,6 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struc=
t svc_fh *fhp,
>> 	refcount_inc(&nf->nf_ref);
>> 	__set_bit(NFSD_FILE_HASHED, &nf->nf_flags);
>> 	__set_bit(NFSD_FILE_PENDING, &nf->nf_flags);
>> -	nfsd_file_lru_add(nf);
>> 	hlist_add_head_rcu(&nf->nf_node, &nfsd_file_hashtbl[hashval].nfb_head);
>> 	++nfsd_file_hashtbl[hashval].nfb_count;
>> 	nfsd_file_hashtbl[hashval].nfb_maxcount =3D max(nfsd_file_hashtbl[hashv=
al].nfb_maxcount,
>> @@ -1080,6 +1093,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struc=
t svc_fh *fhp,
>> 	 */
>> 	if (status !=3D nfs_ok || inode->i_nlink =3D=3D 0) {
>> 		bool do_free;
>> +		nfsd_file_lru_remove(nf);
>> 		spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
>> 		do_free =3D nfsd_file_unhash(nf);
>> 		spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
>> diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
>> index 1cc1133371eb..54082b868b72 100644
>> --- a/fs/nfsd/trace.h
>> +++ b/fs/nfsd/trace.h
>> @@ -929,7 +929,9 @@ DEFINE_EVENT(nfsd_file_gc_class, name,					\
>> 	TP_ARGS(nf))
>>=20
>> DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_add);
>> +DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_add_disposed);
>> DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_del);
>> +DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_del_disposed);
>> DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_in_use);
>> DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_writeback);
>> DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_referenced);
>>=20
>>=20
>=20
> --=20
> Jeff Layton <jlayton@redhat.com>

--
Chuck Lever



