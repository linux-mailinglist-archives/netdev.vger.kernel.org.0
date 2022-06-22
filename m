Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83305553F5
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 21:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377645AbiFVTEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 15:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351124AbiFVTEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 15:04:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D3D3EF39;
        Wed, 22 Jun 2022 12:04:51 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25MIkBf8017786;
        Wed, 22 Jun 2022 19:04:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3zMB7GJ1UIHffrxy4SImY+kQYHhAR2kYElVlPAz8OlI=;
 b=YZVTiOmuMtyZBaDik1hRE7mLDzQHmXBYcxztAV5RYrwte4jvnmjkm3Zl2bSH/vNwWm5S
 nwXZFL/UVZJ0gS5bA8v83LO8ojeFpq2d00qtU3ggrnuau4orUizqCDy9IsL1hJC1cdha
 kY0dxCrwPAf+mM76mxmN+/ZVMnOwTbjq+xtLVKp/GdWnFknM93Es8vzUN8T2Dkilp01H
 8EuUsdPy/HWzIhX8cugzIprMU3sFLSyjjpkVcOe/NnICJOZOgvBVbdYijLZ79EqJ47y2
 WsfHCseggHp6GnhSPa2rtGCHRYL9jePO0cBr2+vj2tY4Vu1+Uao1UwzKhhZ571rfL+hq 2w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs5a0hbff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 19:04:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25MIo1ir039892;
        Wed, 22 Jun 2022 19:04:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtkfvxfrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 19:04:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmH8Oyazz4E2tws/EUL7AXCE3lDTApW5hKl5QHIm7KuTuvmwc/ePV4HLMOGf86B5AUL4cVpi8YZ06yFQfUmSQHCgaSqjEZn6guDnhujJnA9rRLgyE6bhIYc+wo6g3AjJt2FErc1tLuDAq54vC/juD2q3IKv3nLfFD8ggHEF5zTQoYKojUGAYejsWVvjBgHf7Z5+vwHExzyWoL/pdb0lxkL6upJrCRdFCtBVQCzYc8oROq2Jx03DZ46SqVdJ1IM0vZGIO9dFQXCYb0QKvvcrsTh8wkOFCHmXjO0y0yeQTc6oKy2llbIWYDQfHaXtrf+iX3Tdy9VFN8ppRh0+o7AdtTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zMB7GJ1UIHffrxy4SImY+kQYHhAR2kYElVlPAz8OlI=;
 b=i0kjgiT2uuZo4dXOrm8AtM5JhzknxbG+h/3caha2mxaoL3ra5sBRgvnJ1wQ5Z+/hwSAmHzGslEFgU2IiNz0zsBfAwuL9XRjP/SiU2ErL7gkzUHducKmF7YltmErJ7QNy2+ewTC2u5YmDvzpmIT22h9/eyPThe4Jq0ifgRV2rjk/+SPOSGJ9tpyCafjEJcb95Ml6zcPBLt748xEBW1R3sM+sn01hcPVfz4SsKZUn2FLhxTnGTDP0Hq7UnEbjq/aeZ7ATvGJpEHwpyPLGtTqhDlqy32pCENgjsT9btvM6lqDRj7Yzku4InPNcarSfxig4KdZPr5rRMKcl8jOLae0etjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zMB7GJ1UIHffrxy4SImY+kQYHhAR2kYElVlPAz8OlI=;
 b=wi+D+sKF0ubgwt3MlGekqFkN8e3IW+X3FAPSBYNK4W+tM410WCxR/OWKBz0Cb4NGa3g8zH1BvEWMYEHp/0oIEeat8aUf9jkANxz7QKuABHnG18LID3CqJco8DHf7u7JR0YEkpn1GhU4TAoh/GhE5uy4EW6ORCmnEbt83kqW+Cqc=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM5PR10MB1628.namprd10.prod.outlook.com (2603:10b6:4:11::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Wed, 22 Jun
 2022 19:04:39 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::a022:c9:1cd6:8ef0]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::a022:c9:1cd6:8ef0%4]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 19:04:39 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Wang Yugui <wangyugui@e16-tech.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 00/30] Overhaul NFSD filecache
Thread-Topic: [PATCH RFC 00/30] Overhaul NFSD filecache
Thread-Index: AQHYhkIqDsKitGhdzEmSu19Gpo96sa1bwYeAgAAHywA=
Date:   Wed, 22 Jun 2022 19:04:39 +0000
Message-ID: <FE520DC8-3C8F-4974-9F3B-84DE822CB899@oracle.com>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <20220623023645.F914.409509F4@e16-tech.com>
In-Reply-To: <20220623023645.F914.409509F4@e16-tech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ddf6475-efdd-4675-83f1-08da54820eb0
x-ms-traffictypediagnostic: DM5PR10MB1628:EE_
x-microsoft-antispam-prvs: <DM5PR10MB16283316E7332F4C97E804C793B29@DM5PR10MB1628.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZhxHbrUEf8uYB5bEt6JnK6MoqAy9//75XNx8ZMnM7nbl91qKjP6p2XkI4EFUTZjJ0bXbZ25i0Eslw5FiFJiYIuAmMabezorC/sYkhWgk3mD614D6IzFuM64gG5qgKTwmXyh23ZzqV/kzw4pEJeBaIRuiVcEGgenIqJsW9kpC/q+JvWsMi//UnXkbXkYDULt2mcin9CqmzDoikumzEfvB0qlEcr8n9Mg5FS2I8oonOJwi9lFT3EvpjfiRx9aGbjH34Egyzuey4Lwq1k5Tkuh0wUqeN3sdi8YWaf0kG+NfZx2MbdCypguPs9JY+poBV6Z+DUooeFw9xWgTTJ3d4R09yOyhFHKgCzmW8tOqy4AIek4E8LXYRURDHdEVX8yCLVKxHqjq4DmZZ/hhnN2xO9CTrbq4wLs9M+BLvY0u+/36jQcdqEC14+OvGsANTTADxmJohrV9gRNzFJOv1uIFA4omNLQRkReZ0y1ImiJmdPfBBjjlI+bMW6TPMBHGehgky6FncFZtGSj2/LWdJ4a2osLS42jHhLj8ehQr25cyVkAPiNvuOAUlXPOrHBNyaoKJAhN8tLLVGNr6geJC2pSR0zp5gJ6GDggUkmFxNUB823IZvCMUuOkWSRCRdhIICtm1Y3lLUMAy+FG1N0TPDbkmGsSr9WSl8gnFt3vf455xnecPHxvOibu770no4ZyoOfLYekuPo9EzJqKMjCnM2c/GeYV0s9Kv6B7z5sZV9NQ+KGJxkc+q5Pd76DtJZGEfk5HtPg8dz058yGBBgXm2/j4lqz8s90ERhMlsDs++HUY2zuc97faNCL1zgAG1r1dfYeIJTiFKHXThfcLr8WnXb8JGKZjwvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(366004)(39860400002)(376002)(66476007)(122000001)(86362001)(4326008)(66446008)(64756008)(8676002)(33656002)(76116006)(66946007)(83380400001)(41300700001)(6916009)(38100700002)(6486002)(966005)(6512007)(66556008)(316002)(54906003)(6506007)(36756003)(478600001)(2616005)(2906002)(26005)(71200400001)(5660300002)(91956017)(53546011)(38070700005)(8936002)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hjAscq+Cl/KkzVeg8X/cqNNWlg85tGqGxrG1s2WvniWXLCz45nmZEHbdeFeJ?=
 =?us-ascii?Q?j86jkjmcMhIhqCh7NyfBfm0FNXSn/B8vU32rTRZd96DhjmV1IS42t4/9GjCd?=
 =?us-ascii?Q?L5mPr/eSJcA93tX8rHlKaso8KKIyDnOA3IX+w6U0IqcfF6hHperNRDkHVN6z?=
 =?us-ascii?Q?pwt1qL9Ez77oUuxjF7HPrNckOr4bWKQ+fFWzDOipc69ThC4NpUv5r7GmxMTH?=
 =?us-ascii?Q?0pHHf6fmGpFBBZQIN0WTABYHKlWKrjffqJbm96CtRESLp6BoMofPB17G7fWv?=
 =?us-ascii?Q?bDSGSFp1Yhq3vddtEUldvhfhDbn67pB91mvDlTfNXJJWp1PJogLZozy3Aovb?=
 =?us-ascii?Q?xZ85QjbjJpkhruaotK1uv4q1VI7h33NJwHwjEdhpJi+gh/XMo4u5USrvuqsk?=
 =?us-ascii?Q?Ps/M7LCxzLdwL5ABBU/mchELpbNkJHe1+ONtHE6g+5ZxI5WaZnYa+6mLDAy3?=
 =?us-ascii?Q?uRy07YJtFBgaFSv3X6Gl1tsZB4183u0ci0U888owNl3swFIL4YAlKXHjN9Gj?=
 =?us-ascii?Q?eWy6Fov0hKUWNKd+30JWexGNVLPeOrukOOgMSUO1k0nAsT1qw3LUs9T5APlU?=
 =?us-ascii?Q?Q4C5oNsax4MLV2754X1sxWAQ3cmCJ3C9Tn2MCtW7oYQejvlRoty/gcplQ+in?=
 =?us-ascii?Q?FBWAhC0V1rmPV5uiRdGYMwBjidM4xfk0OvwFkM7WXCPzAd6vjfMbJ4/By78V?=
 =?us-ascii?Q?78cfHCFylRc72mxNa+OpZYKojVdEs3ZGe9362dhCa52QLQ3Co6tuSwbVWuFq?=
 =?us-ascii?Q?q0HDBszSPk46fWioQwxiX0GorcU1mC2ERH3YIpUFCqLqfncwoNkSP9jqIPvw?=
 =?us-ascii?Q?FEVyEUz3+1fE7UXxVJREyOj8u4VTHdXfbN7FHyjmNNov03hxbiqL/qJSUN+F?=
 =?us-ascii?Q?Y8PYL1oc7yfEwoHL4wAB0XMJWxwjdAjuyQqlJNx4VzqxX0MutdyNJrWyXwTc?=
 =?us-ascii?Q?qTv/nXPQc248hxRbP03DL3u8Y6jz8W3XqZaiOA27+tuLlVjjkL3iOBQeTA5H?=
 =?us-ascii?Q?5jKeaE8r8jOxuGIYaIFs9GNAfXz8uO/LCAghd9k7DfpunZaXwaL/QjbaugVt?=
 =?us-ascii?Q?8Bcn7vtn8rm17BKUPJY7jRblNv5+qu60iDWeFuYCZxkAptynAWIA0RWgrWKj?=
 =?us-ascii?Q?sCBsx7Rh9Xy0OCV8HtH798DPYN2eM0GNGW2y20Iz276cqj1S1JEwT+S4m0A9?=
 =?us-ascii?Q?ebRpZS13loife6RkL3vpUOp0NBVKg1bZpxtloZvArZwMsv559E6LQmP1eKQy?=
 =?us-ascii?Q?aM2jUZOfJZVmWnv4M4VSzj40aqII+0H6XwTVdKS0023NzX91gOm5wjYWUxvb?=
 =?us-ascii?Q?OgKYuiZKURSIkuYi40IxOyUjv375SkWk71IXW6obb9J0obAphaSywfJKTh+A?=
 =?us-ascii?Q?to1i2UioLs3vFOT2ZxjhJKOgfY2KkERglESz9GDL3GQ1sDFOkc+cMTZD0Cm0?=
 =?us-ascii?Q?4Oi2yyb6bBtGHXP25xxbaNSVf+xPLGlw12CauLTq6GJLIua6RMR2sjBLCSQJ?=
 =?us-ascii?Q?gTqgc+6UaIyTkZW47Njp4dCpCbGJzU1gna8TLV/mfQV0Ca2WKcF4liUExFAi?=
 =?us-ascii?Q?vi97v3S5mNLlDmouXO1y5bh5CSbS4bSQm8a77BiV5qv/xoo15jK6jy5LTY0/?=
 =?us-ascii?Q?4AtSWo0BuTYHw02Rp9xuCVTbe88k8+cLP2s/r8iyq/QaexYOP/qPsOFGNaaP?=
 =?us-ascii?Q?FCldv5uxUnx4Jr+nNqG/xWuQjYS++VRUdlP7FJeWPe/J7/R6fx1hntZ8zVwt?=
 =?us-ascii?Q?sU2pPUZZwQF5xyEhYZhPOwfuMEPp1kI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6D36C32849E6324B9300C59CDF386CF9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ddf6475-efdd-4675-83f1-08da54820eb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 19:04:39.4652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /qJ9c9Y0WKGbjoyUAK79nj9dsc0yQ46CAwWLCgq9YFxI9iAQi7QSmOWfIFTnlBKNn1rXAoMFeYi6ZSpCvYsUMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1628
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-22_06:2022-06-22,2022-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=662 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206220089
X-Proofpoint-ORIG-GUID: BMuYVZw1kYQ9OH4_8kO4lU8WBY4PIKbj
X-Proofpoint-GUID: BMuYVZw1kYQ9OH4_8kO4lU8WBY4PIKbj
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 22, 2022, at 2:36 PM, Wang Yugui <wangyugui@e16-tech.com> wrote:
>=20
> Hi,
>=20
> fstests generic/531 triggered a panic on kernel 5.19.0-rc3 with this
> patchset.

As I mention in the cover letter, I haven't tried running generic/531
yet -- no claim at all that this is finished work and that #386 has
been fixed at this point. I'm merely interested in comments on the
general approach.


> [  405.478056] BUG: kernel NULL pointer dereference, address: 00000000000=
00049

The "RIP: " tells the location of the crash. Notice that the call
trace here does not include that information. From your attachment:

[  405.518022] RIP: 0010:nfsd_do_file_acquire+0x4e1/0xb80 [nfsd]

To match that to a line of source code:

[cel@manet ~]$ cd src/linux/linux/
[cel@manet linux]$ scripts/faddr2line ../obj/manet/fs/nfsd/filecache.o nfsd=
_do_file_acquire+0x4e1
nfsd_do_file_acquire+0x4e1/0xfc0:
rht_bucket_insert at /home/cel/src/linux/linux/include/linux/rhashtable.h:3=
03
(inlined by) __rhashtable_insert_fast at /home/cel/src/linux/linux/include/=
linux/rhashtable.h:718
(inlined by) rhashtable_lookup_get_insert_key at /home/cel/src/linux/linux/=
include/linux/rhashtable.h:982
(inlined by) nfsd_file_insert at /home/cel/src/linux/linux/fs/nfsd/filecach=
e.c:1031
(inlined by) nfsd_do_file_acquire at /home/cel/src/linux/linux/fs/nfsd/file=
cache.c:1089
[cel@manet linux]$

This is an example, I'm sure my compiled objects don't match yours.

And, now that I've added observability, you should be able to do:

  # watch cat /proc/fs/nfsd/filecache

to see how many items are in the hash and LRU list while the test
is running.


> [  405.608016] Call Trace:
> [  405.608016]  <TASK>
> [  405.613020]  nfs4_get_vfs_file+0x325/0x410 [nfsd]
> [  405.618018]  nfsd4_process_open2+0x4ba/0x16d0 [nfsd]
> [  405.623016]  ? inode_get_bytes+0x38/0x40
> [  405.623016]  ? nfsd_permission+0x97/0xf0 [nfsd]
> [  405.628022]  ? fh_verify+0x1cc/0x6f0 [nfsd]
> [  405.633025]  nfsd4_open+0x640/0xb30 [nfsd]
> [  405.638025]  nfsd4_proc_compound+0x3bd/0x710 [nfsd]
> [  405.643017]  nfsd_dispatch+0x143/0x270 [nfsd]
> [  405.648019]  svc_process_common+0x3bf/0x5b0 [sunrpc]
>=20
> more detail in attachment file(531.dmesg)
>=20
> local.config of fstests:
> 	export NFS_MOUNT_OPTIONS=3D"-o rw,relatime,vers=3D4.2,nconnect=3D8"
> changes of generic/531
> 	max_allowable_files=3D$(( 1 * 1024 * 1024 / $nr_cpus / 2 ))

Changed from:

	max_allowable_files=3D$(( $(cat /proc/sys/fs/file-max) / $nr_cpus / 2 ))

For my own information, what's $nr_cpus in your test?

Aside from the max_allowable_files setting, can you tell how the
test determines when it should stop creating files? Is it looking
for a particular error code from open(2), for instance?

On my client:

[cel@morisot generic]$ cat /proc/sys/fs/file-max
9223372036854775807
[cel@morisot generic]$

I wonder if it's realistic to expect an NFSv4 server to support
that many open files. Is 9 quintillion files really something
I'm going to have to engineer for, or is this just a crazy
test?


> Best Regards
> Wang Yugui (wangyugui@e16-tech.com)
> 2022/06/23
>=20
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
>>  https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git=20
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
>=20
> <531.dmesg>

--
Chuck Lever



