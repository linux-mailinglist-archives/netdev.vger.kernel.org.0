Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEAF556FAF
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 03:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377021AbiFWBCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 21:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiFWBCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 21:02:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8367041F9B;
        Wed, 22 Jun 2022 18:02:00 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25MNeV3S021387;
        Thu, 23 Jun 2022 01:01:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=LW+YKVgSxIN9ac5MO0QE4G2Eo0IHX1OAzDPl7/TKkN4=;
 b=Hh0mo/0XCTxrZag66a4v870WXFrTwuJjJNw8LGxjJWr+eTOdzGVlLOtcFu20qFtkpaeh
 xGzuxyjXmHTmZI0hirHGAYxEyv2Lu9MzBbfPgNRhUy7BOcQ9f8CJdUMLFeV3pBxgdMJT
 HVe1eH2FbZeypxgGosMthogv/kR4fFOgvfrzwHrka2QqKsYePu/pwZHhE+U3Pj9XHN5s
 nXoFY6N52BaeWd7BkdLbTzIQBnmPxcVdBSo4j6V+wFV2z369elNceB4PBASCt7whuiPc
 E2SyKd5t59rzpVkEUjZHQ6dB55aRW41ZNWtT23zuc9Uiy2G5Pg4ti4oc5E6iVTstRffa Ew== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs6at1vea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 01:01:54 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25N11kMC029263;
        Thu, 23 Jun 2022 01:01:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gtg3wxjga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 01:01:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AfD7O3EaiylJwSzqWeXL6wqU+JhTyl60FtpX0RIerl5/0QARG5HOZs3wV4B+jRRY1Dn3HRkw/SV5ZyspjiFCjRM/Uy257/pHhO/7Fuv5yMOYePGH2ZQAcORG9/rjwYmUDpwVDmGg+/NV9x5BMJRjGizkzLO0uHQ9lud6gsV6uMM4Bl7N4a7iTqkFPO4Melm0sWDk4WHGNTVNW3phSI5W1ECzP2UkfklR8QjR635yNFIIKDtSpjlytc7Usg4zdYAVhXAm7VFaIbjNUzcHnqDGvNYuCmVIfq1bjOgV9BozyVTvyWYPCvFBH/mRyVpxNitklGVlND3x9SKy9eaTL6qEyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LW+YKVgSxIN9ac5MO0QE4G2Eo0IHX1OAzDPl7/TKkN4=;
 b=VKpYCjyhShcPBmsy6fe/4DJAK0SZ91pUgeIkwxzu2itU+YBA3bJclQDATbqTBMXCTXv6oQQJC9A+MVbOxUbK+sgUSsxg86c6Ewu9I8Bog9sTeY6C8PJw+9swRWmLgP6jG2Od//Y4YGHfcz6e+xQ3SsZha9FIkrKklVQOESAyqMXWTeFASEIxIBaRPkq6Z7JRujbLf+ceIIyWAHXRoh2RkoBwnaoQsJfZVJa9CPqsrWVNTeiPC9bxVr0ufECd0BdY8NDQDR6YMccVaaKb4foTb/zLWTHsUAwh+Piga4XWe0Y/9f7O85HAs6KPg5WPZtQMAki8D+hknudEdJbZleZX5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LW+YKVgSxIN9ac5MO0QE4G2Eo0IHX1OAzDPl7/TKkN4=;
 b=IMvqDaY77YiHo7ir2/JrprbrN1b/1CFGrvadxMQExMC1Phk4azI7Zs+1OxyHa2p33stiU+Vem2klFRC2CkQvTzVDuKiF2lDS0HFSkS48Ws+2YVd2NUYXyVPXLh1tA9rXKM8tX/+Y3R5dDGaDhmbII6mXyK7+oJrluQ3909sUmFw=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM6PR10MB3146.namprd10.prod.outlook.com (2603:10b6:5:1a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19; Thu, 23 Jun
 2022 01:01:25 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::a022:c9:1cd6:8ef0]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::a022:c9:1cd6:8ef0%4]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 01:01:25 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     Wang Yugui <wangyugui@e16-tech.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tgraf@suug.ch" <tgraf@suug.ch>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 00/30] Overhaul NFSD filecache
Thread-Topic: [PATCH RFC 00/30] Overhaul NFSD filecache
Thread-Index: AQHYhkIqDsKitGhdzEmSu19Gpo96sa1bwYeAgAAHywCAAFiKAIAACyQA
Date:   Thu, 23 Jun 2022 01:01:25 +0000
Message-ID: <C2E70B75-0CB2-4F4C-AB8E-613F90264D33@oracle.com>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <20220623023645.F914.409509F4@e16-tech.com>
 <FE520DC8-3C8F-4974-9F3B-84DE822CB899@oracle.com>
 <20220623002132.GE1098723@dread.disaster.area>
In-Reply-To: <20220623002132.GE1098723@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0aff7e75-c374-4ffb-f530-08da54b3e592
x-ms-traffictypediagnostic: DM6PR10MB3146:EE_
x-microsoft-antispam-prvs: <DM6PR10MB314617E4257CBCE2AD606ED793B59@DM6PR10MB3146.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4rv6xLsjwXaGXFKcGdrWg728NEdji7OknDPKLmTaUuq7uaWtDD9Kqbrq8l3MBqJmCVg+2pCXqaMOAWmMNhw6yDSyeOVcb+WVtsVN17+xg2u/bjtAEPvpCOc9te5L0rXyGoW5cfhwOwZzm8HfCBzdgSJvAJrm68Iy78rhpk3ve5V7s1aHaPOZfx/CJwlXlb8m531sBcZ4Zfsx/CtRchtd8kgtwhSMFQ4/wsIs6hW2jUzQvxprxtLg7HuYJ1JSt42jxHgqUwCDxAENzmBx5X/ziJRt0D1jMgZTDTEn5EzX8T3cO1/Pg/v9NV/2R56Fag3bTbo0dRbFXJMX95T2i5J2BMWJJYT4OugZdmUE1dl4/K7YJWQP2CykhNLz21jF1iZgqEtp9iuu0M61I0A6y71VKOLRNqhQL4mExdHHSbuv4K954E6quL4qbisoTy/rU2VA5b/MW3H9WGGLOulAk1pB6AedfAFjxqDFJzHtWOvtx52DvXpKOm+TgY3j2G2bhi0liBN0GwiWL2kPEdXSANQlDZbqZanykXR9EXys0gDyt+FjdjOn1fud7Br48Fb8gdciKI9mg+OKC7gnDIpcFkSb9xZf91UyWHIy4tr6+nMeT0scV+6vYX/7qM/xxGpn1681+HawK5yPPmfX3s9MsNpVV+koTP5WDDXfqcZSpLbtzG9trSRmuo3e1b3iMJ/H9ozRispsc2SurC+sk+aV55LF0eZrQFx59e5vGw+0sEOY+vI4M1Y8apye6t0vSNYjJPskOlZlLTdt09sYJgiI4CreOdtbBaJZOtnkJVbG8lh9AO0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(346002)(136003)(396003)(376002)(38100700002)(83380400001)(316002)(64756008)(478600001)(5660300002)(8936002)(33656002)(86362001)(38070700005)(2906002)(6486002)(91956017)(71200400001)(4326008)(8676002)(76116006)(66476007)(6506007)(122000001)(66946007)(2616005)(53546011)(186003)(6916009)(66446008)(26005)(41300700001)(6512007)(36756003)(66556008)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XFwfF3pdh1Bh9HvrItivMbZaypkOrPfyZTOxiY1rWV0MxcjN/WVZbVkwOIxO?=
 =?us-ascii?Q?uVqSVSTJo9wseUfRbOnFpFtrNvh3hr/5oH2728Z8L2r9pPva6+xcPpTxYc5h?=
 =?us-ascii?Q?5zr+Uj5sXOI1im4f08RUpGwMz9do2nYJJ1AUbpuRcAs2in9NRlTArYHU6oQv?=
 =?us-ascii?Q?fa0z7axW5p/278d0uq7k3Crz3tiyQEikJoFcvB9iH/gAus3tL/xxAPyhII3P?=
 =?us-ascii?Q?Xi+I+8U6nKipwSd6sPl4DdhfrehS2e6wlu+tbmkpYhhyDJ/m5GJn+m+yr8v2?=
 =?us-ascii?Q?pKM4P4jsIujJjakrh87pDPmDhIJ8m6iwVqrNx/AwvbT3effyF4bQKp82XQ3+?=
 =?us-ascii?Q?tIeDSp54VYnp6jl0smS/ImpDFy3EGUHfp6CpteJbNZ3Q1pwQhVE5NsbzROnY?=
 =?us-ascii?Q?QuxcEqsj9jpyyM92uUumV65gTGCxnRdC9XcOOlw51aoRwqBqPeOcbZseBOzd?=
 =?us-ascii?Q?J9OJ2SY3QBDZjkUKuXJ0XhsRVTbKaaRPpIV1EAfYSMDBxkFUkQSfd2TtxJIB?=
 =?us-ascii?Q?mm5Syof4+TNTXCBHnBXAzFOeFSWQeD6PmZB0bDoajabi7G9iqla1Hk4611Vb?=
 =?us-ascii?Q?h3wc1TBkmE5eQnJFL9ODUGDHPy7phOxsx2p1klgFOWjeDJA+TozSAGcRTsmz?=
 =?us-ascii?Q?9bjdqmZk4pPe838UJCky3PwPUkcNgy7EGmNVZEsnael7JS2MTcrNvbvnjJ+H?=
 =?us-ascii?Q?h/d6L4NubvVOaqy2JWpp3xHfmTM7LJ6pm3CV9zXrhCNH3ToS/AfwG3V/0TBP?=
 =?us-ascii?Q?6tQjGYRm30nCNRQ3qtCJAHWXBWkp/AYlgziFPxMWsvCwq6b7s7rwyuVFxeNY?=
 =?us-ascii?Q?+vdXutNHLjCmFX0z1dWwPDZeR8epAUFe44zXWpRY7EhNtr021Mxwe8czmejr?=
 =?us-ascii?Q?RtMEvyx+Zduy1bnML32YJt+wgOwTdIdzm3ddmcYIbpinxKT2y8jAmlBArJYX?=
 =?us-ascii?Q?XLAf81K1MvXUZDDm+AOsOlcslr6IJ4vBqZJlFSwhtQ1+qjqf+/aLbS4DPPnD?=
 =?us-ascii?Q?5jJRsh2w4QWVs6hiOZFUGPJYivW3p20seC9//BBSPe8Irg+F7jO/Sv7LKSz8?=
 =?us-ascii?Q?YYsEoI2X37g4HQbmS1v3BsVm3qCLBdPClTe/SrufaIFB27T8JZ+D0bHgCtqv?=
 =?us-ascii?Q?TmNo1K/Brnq7OAcRPoqH17uFrqOWfUj05pDwe5eoemqDS6LtJO9yChcYKSYv?=
 =?us-ascii?Q?vorK7MHvt9lqB7pOjfmMu+PVY/l0YQhVaoVntfnWBKEjJUsITafleKnzmbMp?=
 =?us-ascii?Q?6Mhi9N1uBK+Y+ho3SqmMBr5dtxCIUIfrdVOu49KxkqiOzwRKs5qUrGLdempZ?=
 =?us-ascii?Q?OHXDrNpajbqXED5yw/pg185aSpNNN2Z1TV0F2SZu2N1xWZSfYPdd9hQec9OW?=
 =?us-ascii?Q?1gUiTwIUeKsJ2OR+0LpnkopjF1G7zHscqnxfONDnYJ/zIOyfWyx8bi7Ez1lx?=
 =?us-ascii?Q?4nT08fJH6Ap9o6iRdbtvw1zF2TDxsSnCmuacU1gCQ6trdsSoRIDgexcq7XvS?=
 =?us-ascii?Q?tY1uz2N879asgtlPUnCGb6fuBISUv8HbeDAR8DFN4i8P9sra9jMuBR7rJ0ub?=
 =?us-ascii?Q?r7P583G/AXaFvi2lvpCeouWITuKTAnOGHtfr51Mdr9Cc9pUUatCzJgXOkbk+?=
 =?us-ascii?Q?Ct7iVjo9PwKP1DbrO3A3Y0LZILBYSihhfYSouAy1OVJnWaMNb+B/pQPIUrad?=
 =?us-ascii?Q?LJXur7qsSXMplIg+E+rBWyUq+nL2yhcGbcpzFNg3Xq7cFCOCBJFmGX6xIkad?=
 =?us-ascii?Q?us8LddIovoFIFkVtzM0wtqo1S8ZjuR8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6BAB9E4C998BC045B4611A0132A0D177@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aff7e75-c374-4ffb-f530-08da54b3e592
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 01:01:25.3370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hEAX+7bN8dK9aOOKULinEUXv6jTaiVektk+Q0Gq7JQcwKk8avtN81WuyZHOb6rumNtUhavlbTmz6ByYjDOMpLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3146
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-22_10:2022-06-22,2022-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230002
X-Proofpoint-ORIG-GUID: FAozwXH1hyKDpkvYsNSreO6QcHnDVQ6t
X-Proofpoint-GUID: FAozwXH1hyKDpkvYsNSreO6QcHnDVQ6t
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 22, 2022, at 8:21 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Wed, Jun 22, 2022 at 07:04:39PM +0000, Chuck Lever III wrote:
>>> more detail in attachment file(531.dmesg)
>>>=20
>>> local.config of fstests:
>>> 	export NFS_MOUNT_OPTIONS=3D"-o rw,relatime,vers=3D4.2,nconnect=3D8"
>>> changes of generic/531
>>> 	max_allowable_files=3D$(( 1 * 1024 * 1024 / $nr_cpus / 2 ))
>>=20
>> Changed from:
>>=20
>> 	max_allowable_files=3D$(( $(cat /proc/sys/fs/file-max) / $nr_cpus / 2 )=
)
>>=20
>> For my own information, what's $nr_cpus in your test?
>>=20
>> Aside from the max_allowable_files setting, can you tell how the
>> test determines when it should stop creating files? Is it looking
>> for a particular error code from open(2), for instance?
>>=20
>> On my client:
>>=20
>> [cel@morisot generic]$ cat /proc/sys/fs/file-max
>> 9223372036854775807
>> [cel@morisot generic]$
>=20
> $ echo $((2**63 - 1))
> 9223372036854775807
>=20
> i.e. LLONG_MAX, or "no limit is set".
>=20
>> I wonder if it's realistic to expect an NFSv4 server to support
>> that many open files. Is 9 quintillion files really something
>> I'm going to have to engineer for, or is this just a crazy
>> test?
>=20
> The test does not use the value directly - it's a max value for
> clamping:
>=20
> max_files=3D$((50000 * LOAD_FACTOR))
> max_allowable_files=3D$(( $(cat /proc/sys/fs/file-max) / $nr_cpus / 2 ))
> test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_fil=
es && \
>        max_files=3D$max_allowable_files
> ulimit -n $max_files
>=20
> i.e. the result should be
>=20
> max_files =3D max(50000, max_allowable_files)
>=20
> So the test should only be allowing 50,000 open unlinked files to be
> created before unmounting.

Looking at my testing, it's ~50,000 per worker thread, and there are
2 workers per physical core on the client. But thankfully, this is
much smaller than 9 quintillion.


> Which means there's lots of silly
> renaming going on at the client and so the server is probably seeing
> 100,000 unique file handles across the test....
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

--
Chuck Lever



