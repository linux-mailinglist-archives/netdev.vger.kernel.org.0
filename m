Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8202755EB8A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiF1R5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbiF1R5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:57:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CB16449;
        Tue, 28 Jun 2022 10:57:37 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SHXurF032115;
        Tue, 28 Jun 2022 17:57:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rzb+HGm28ffNJU1vSdUpF9a9BapwpEW1aaL9P8Sy9M8=;
 b=RQ6LSdgKSQt5pZjCFz07rJn4GdXe6hswoRtMBTaVrDkqlHqJvtZctM4i/Xx1b6Yop/I5
 OYupYXxNT7hZQYQUfG/y7w/2sZjK93+SNhsG+cYFaOBOyzR6avu02a1CDbouZ6eYxHVg
 EPfl4CwwFCoTMBGfX/JfG50dKn2yjg+qfmHwEiwQx8tQtm7ASW+VBalWPeUehFQZh1JO
 Jx1hNFb/+XOn+NE2zyj90BRtd0CDugcFERxL724toVgbMvJokmqVOXZyNuizh9+YVVrH
 UZOUgnT5dOSkBvvX7jp8BZCQrVWq+Mf2UvKL3bs5QzENF/tKYWqqI0aE6XBdw4FnGI6h Lw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwsysetm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 17:57:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25SHoK10040041;
        Tue, 28 Jun 2022 17:57:32 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt2e47r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 17:57:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4LQMIjeaqpBhVKZpZ1IrFg4/VtlO/THOpdZBbc3S3a7q5+jdTY5efideOJb8GCmtq0ZXgVWh6VoADL/nH8PEBY8aea3kqqoDLd6Yf2PMBakYb7lVOk8194uzC4YyeBFX0TBpG5zu0N36wsiVyetp6WUMBKJpqCWY3IXwDNUp1d9fzjLb5/LssIIvq+6SX0JJ1D34V/9Sk0aeRZrPXF5mS1d7qcoVS9dFMMTMrSi6CV1wr+hdbebNENS56jZaU/PVRI3YY9SSEUknswhKBf6kPQljUX+YbQHNxPVli5+rF3WHThBurmXTIpQ7pQ4QKt/vMkYEr4itz7+IU0dUYXFJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rzb+HGm28ffNJU1vSdUpF9a9BapwpEW1aaL9P8Sy9M8=;
 b=jyBgE9t3c7PbFT/GCkmTwbMX+zrjSv7Xqh9TXF9GTZ0zn8L7GPxKs41JlzhB1R0d4Bee3iimRcNJiQqwNiOpiog0CrS7lLrNv2OsUUqXjhW4z0xuCl9cA0u0JZXAfz35ffAWskFGjBEKtPsuHRR+TxsdlRlsvzFF20q7AvuHPt3OrTqEtJ5XvcL8XlBBkOyz6XF4+z4lyDWfONXjivCUWWOoeREvoyc5IGTpb09UeZPWefeNzcygNJ6sqLXpCocfDSsMXU7c+k5Yik6rw8Jn89cMfleCrnmj/59mNpQpcHFEKSDHWXdZGxFRiqQl5NxiWsFj8KrKDunCfADil45XHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzb+HGm28ffNJU1vSdUpF9a9BapwpEW1aaL9P8Sy9M8=;
 b=u0RIZSVUxY64YvL/mS4/6sMhdsJRnmpqE0mLwckqx3vAW1KKi3BJx4Z4c7Dyptcuq/aQc/hDn9gGQt986izn1rw4nmQG+SKiFJJX23+RMm/Sm8wLgauJwgB7clAgq8qAL2b/8D0cWvHf46tya8ie3K3u6D1+l8L74h5q+wTgRAo=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH0PR10MB4971.namprd10.prod.outlook.com (2603:10b6:610:c3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 17:57:30 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703%5]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 17:57:30 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Frank van der Linden <fvdl@google.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 00/30] Overhaul NFSD filecache
Thread-Topic: [PATCH RFC 00/30] Overhaul NFSD filecache
Thread-Index: AQHYhkIqDsKitGhdzEmSu19Gpo96sa1dcq8AgAex3YA=
Date:   Tue, 28 Jun 2022 17:57:30 +0000
Message-ID: <A98597CB-F422-4FE4-9A08-6EABAAE8C649@oracle.com>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <CAPTztWayDY7ejHaQNcCr6f3iRS8B1ytMqk0iYSUpHngp7OV-FQ@mail.gmail.com>
In-Reply-To: <CAPTztWayDY7ejHaQNcCr6f3iRS8B1ytMqk0iYSUpHngp7OV-FQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d24dcebc-6ca2-4a75-a06f-08da592fab8d
x-ms-traffictypediagnostic: CH0PR10MB4971:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HKg0t0ZKI6nt+tZzrNqknALQJr8jkER+CuFfiEr/q7KWFvunVTiOfrhXS3Xa0L4tSOnxoGkxXCZanPqhwKjbbcX1hR/MoGiv0n6sn8R0Jeuj5cML/zefz1Mgab7Q8C3xzEMU2ZLlpexahgTFcvVHyK2x8YNUY8Vrk5fUtzxEK6NlXHNptgVzCwuH6g0MXtZ/ukDxPCDh3gjBLEls5ij/uOdxS30PlP0PYMDgPcbQShqtou6yihNQVp9wFUZGqxygDFYxRXoWs9LnDTFU/MbbM221jT02Rc87uZghYzS9anu5sABUk7oDBGQHqVFbmeHzR1DQTrjy2Imsl3qXRuUPyCgF3dGYQV9ZmX388QzbD0WO6FgcTCqHcU1pykZnwk/Id041etK9BCQkRNW30l7+q3tkPwBWGmRobaEMHB/vLx0SDH+wZQ0OkhynQ2XC8jGOW3mdJVuvflxuoHfzZhsYI23G45h71mAwlvHkjlYmR8Nem6fDSE4CqWWYl6Q8jMB2S760/lTJk+UEO8pPrJKwIoL8I5+WNeuU90hLl4tDY0k7E6TJPCtTHI7aZHDcZNAjcdsus1ocEBqNO8SCwIZhX6C6Q7MWH3CEeG6eXHk4kEksPMxayoSrjYHO6NSJHoVnsZ4m2Z6NuvygewEqyv1rgp+6EPofKS7OcMBUEQDZIi3fzUy2xYtxob6VngFDnjONACsaodu9kf4V+evTExcmWwS6VjZ3riK6yHGQQ+cnP10hrfjK4qI4s5qd//YvEUPmuFm5kGB3mlzRDZHphLJoXkpFuA2ZwG1/cEK1vSGiNRdJyzBX2zQREyACRUu8gmOnjH+82ecWzQTSPB1i+Rn4GNgGSr0a9OBq+GXfL6dDPNo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(396003)(346002)(366004)(136003)(86362001)(83380400001)(26005)(91956017)(6506007)(66556008)(38070700005)(71200400001)(53546011)(76116006)(8676002)(6512007)(64756008)(4326008)(8936002)(6486002)(66946007)(122000001)(66446008)(33656002)(66476007)(478600001)(38100700002)(2616005)(966005)(36756003)(41300700001)(186003)(5660300002)(6916009)(54906003)(2906002)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N/HeN8EXBrMb8nd3bcOoid+pCvhyi/fkRGIKoFweatVmcdZm+TXTqVNjgL+R?=
 =?us-ascii?Q?FAtu6o6+xHeJYaQTre+5SgFt0R7EL6xngWcDuMTrxm4x9L0XBEqMH3IqtcSl?=
 =?us-ascii?Q?+Cs+O/ngDO10AAQPxvYYM44zBHQfAGBq/Pc7FMJzZgwWObFVIzy8J6iA71OC?=
 =?us-ascii?Q?GoI/10dfFry066uKkftG6lYPVheWouNce+WzPtL2uXH2mjPESEDiTUIEMjZh?=
 =?us-ascii?Q?KalGC1U26RKdRyMB6b6FpVT7OlRQTv3XEjMO+k+I8jjJiUb1JJ3HEkbayYtA?=
 =?us-ascii?Q?6b9oBkVMR54aAdQv1f+ij+dAqUvjbUW+lX2RttDFdLwvQbwmBxJicRwcZDYA?=
 =?us-ascii?Q?BHAMO1r1VfZCYbzA2elkbbVfKnFenXWo6+gC2bi722l6NXiIh/wnjUM6zb5D?=
 =?us-ascii?Q?gmLqu/z81cDBaYgPetIuGc7ug+3jK5tHA6Sb4KC+QqDb6eV3dkDiTDskzd5/?=
 =?us-ascii?Q?6UWgH0TO+NQnPZEXYQDJEYf7TqYTedpTxrLo4D7gZRd2OEF/TuREYaG3WnjA?=
 =?us-ascii?Q?Ab3Gcki2pct8fRA9J2UaHLz9w392i5ZBoryhLhAKiASFZw24SuKkTA+UnTV5?=
 =?us-ascii?Q?xJ6A5DYRG6O9Cz/6J+puLHhkZ9vM5UCX18cAFiBB2DC8zF3FcriWneS1tgWT?=
 =?us-ascii?Q?XlktuNaJFnFA5K7dX5mVtGZbf1Tczwj72ctSQRq4FNy5sPuO5uCALpx1syB0?=
 =?us-ascii?Q?dEv8XqRhFMgpr4PGGvwas3950jG9De0NUFIPB4xSApKsexyVZr8lovtbV6Bu?=
 =?us-ascii?Q?jy2l9njQy4oRa1evohiZBht5nOuhAXJsR1ZIkHzTxwbL/cgynuQo60ENXObp?=
 =?us-ascii?Q?JhOSn/EY/jGFs8WlIswwmdhfW2Rz41iGl6+cImoUXXlS6DCAtQnoRTvjcTS2?=
 =?us-ascii?Q?SZboL3Y9EoAMf4sixnczG38b91UxPl2Kxl5n+TDaMHdKoBtPHBLxSbT8OjxW?=
 =?us-ascii?Q?LPNxpS/pysd1K+EvtaHPtv9Tx6qSWJrR7ZJ9RdSR2FrnPBdixMCfnH5idpJ/?=
 =?us-ascii?Q?royun7egE62TGoIZE/cOHLgI35RmrtqTVolHErCowyEyHm+3YgkIqT7wwHkP?=
 =?us-ascii?Q?eUHfcBmmZJTV05oxRXJSXoYfVpqzMv+uDIRHhzv5VJYpMkPk8jf70pOoUY3F?=
 =?us-ascii?Q?l42rVeNX/VQhbjSGH77cJznWiOXJ6yGteU0RA7ZXKmNZM+GfDjqVcuNTAZuB?=
 =?us-ascii?Q?cM1FuqekPP79UnQ4ffsqvroIMjb8O5Vx8TIbSFK2+bJ0+dhPxRdbWLr0n36l?=
 =?us-ascii?Q?U1dTI9IowbWWRV2mqdbBdvvhf0Xus08lCioLGJvNsYSaLgxej4WBFKrioGvw?=
 =?us-ascii?Q?xOSOi8tOIEkqWQ6lSfgwa4jCwncKByueKvLDWT2/gH5IpeKD0HzaE+RDRqVI?=
 =?us-ascii?Q?W6gO/8vazo3QQyVb+eU/E6cH8jEy+7mNTg9aPsVVsDHHaVGbvBFBPghFWWU4?=
 =?us-ascii?Q?6C04TGi2bQOPif08U1EX7i/3OpR8FOY+mwTvruvkN1wi4YwI6gYTJevacLNj?=
 =?us-ascii?Q?/AjzxW7pNY3nTQE6bsaVGthxj2HgfPvZao6tabN5JkzkRFN/q+yjKkQZKSJ9?=
 =?us-ascii?Q?WhmaLHUQDcwd5wtlHCI2/sQGLcIlKVBvuwoX1oFlLNhB2/4za/vNyZ1XbDX0?=
 =?us-ascii?Q?Sg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <35B175EE833B57469E65C3A8CF112C17@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d24dcebc-6ca2-4a75-a06f-08da592fab8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 17:57:30.2398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3KWoI/eqU94RMkRpGTcr+JSW0PQCcf1Z1yWfp10gglKx+TYcvLL0QMS6OJV7HMfdMuz9qMj5goVfscUpvVNJOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4971
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-28_11:2022-06-28,2022-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 mlxlogscore=908 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280071
X-Proofpoint-ORIG-GUID: SsjRr_UIKhhUtcUnznL-peK9rYXzGeKV
X-Proofpoint-GUID: SsjRr_UIKhhUtcUnznL-peK9rYXzGeKV
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 23, 2022, at 4:27 PM, Frank van der Linden <fvdl@google.com> wrote=
:
>=20
> On Wed, Jun 22, 2022 at 7:12 AM Chuck Lever <chuck.lever@oracle.com> wrot=
e:
>>=20
>> This series overhauls the NFSD filecache, a cache of server-side
>> "struct file" objects recently used by NFS clients. The purposes of
>> this overhaul are an immediate improvement in cache scalability in
>> the number of open files, and preparation for further improvements.
>>=20
>> There are three categories of patches in this series:
>>=20
>> 1. Add observability of cache operation so we can see what we're
>> doing as changes are made to the code.
>>=20
>> 2. Improve the scalability of filecache garbage collection,
>> addressing several bugs along the way.
>>=20
>> 3. Improve the scalability of the filecache hash table by converting
>> it to use rhashtable.
>>=20
>> The series as it stands survives typical test workloads. Running
>> stress-tests like generic/531 is the next step.
>>=20
>> These patches are also available in the linux-nfs-bugzilla-386
>> branch of
>>=20
>>  https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git
>>=20
>> ---
>>=20
>> Chuck Lever (30):
>>      NFSD: Report filecache LRU size
>>      NFSD: Report count of calls to nfsd_file_acquire()
>>      NFSD: Report count of freed filecache items
>>      NFSD: Report average age of filecache items
>>      NFSD: Add nfsd_file_lru_dispose_list() helper
>>      NFSD: Refactor nfsd_file_gc()
>>      NFSD: Refactor nfsd_file_lru_scan()
>>      NFSD: Report the number of items evicted by the LRU walk
>>      NFSD: Record number of flush calls
>>      NFSD: Report filecache item construction failures
>>      NFSD: Zero counters when the filecache is re-initialized
>>      NFSD: Hook up the filecache stat file
>>      NFSD: WARN when freeing an item still linked via nf_lru
>>      NFSD: Trace filecache LRU activity
>>      NFSD: Leave open files out of the filecache LRU
>>      NFSD: Fix the filecache LRU shrinker
>>      NFSD: Never call nfsd_file_gc() in foreground paths
>>      NFSD: No longer record nf_hashval in the trace log
>>      NFSD: Remove lockdep assertion from unhash_and_release_locked()
>>      NFSD: nfsd_file_unhash can compute hashval from nf->nf_inode
>>      NFSD: Refactor __nfsd_file_close_inode()
>>      NFSD: nfsd_file_hash_remove can compute hashval
>>      NFSD: Remove nfsd_file::nf_hashval
>>      NFSD: Remove stale comment from nfsd_file_acquire()
>>      NFSD: Clean up "open file" case in nfsd_file_acquire()
>>      NFSD: Document nfsd_file_cache_purge() API contract
>>      NFSD: Replace the "init once" mechanism
>>      NFSD: Set up an rhashtable for the filecache
>>      NFSD: Convert the filecache to use rhashtable
>>      NFSD: Clean up unusued code after rhashtable conversion
>>=20
>>=20
>> fs/nfsd/filecache.c | 677 +++++++++++++++++++++++++++-----------------
>> fs/nfsd/filecache.h |   6 +-
>> fs/nfsd/nfsctl.c    |  10 +
>> fs/nfsd/trace.h     | 117 ++++++--
>> 4 files changed, 522 insertions(+), 288 deletions(-)
>>=20
>> --
>> Chuck Lever
>>=20
>=20
> Yep, looks good so far, thanks for doing this. Somewhat similar to my (bu=
ggy)
> attempt at fixing it that I sent at the time (don't put open files on
> the LRU, and
> use rhashtable), but cleaner and, presumably, less buggy :)
>=20
> Can't test it right now, but it seems like Wang already confirmed that it=
 works.

Frank, thanks to you and Wang for reporting this issue, and sorry for
taking so long to address it.


--
Chuck Lever



