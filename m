Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2FA679CBD
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbjAXO5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbjAXO5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:57:45 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7342D70;
        Tue, 24 Jan 2023 06:57:43 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OEmg7h027740;
        Tue, 24 Jan 2023 14:57:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=cPbhMtLO09aDva9Kpd+DuOJNNt9+LJzSojM7+V8CFSg=;
 b=1SPhOZdw4dJ0RKKRMTdL+KYwKbRMuFXynS51supteAeeWmqaAeZyTutgNboEA4eNP0h1
 U67iaA/mpPcgskay1Lh3jDZ2UxReUgeBeGD9inWtEwv4iiimel7LylOs0BzxB7fKBDiX
 QM2sbhMpWT1rHh+jkjzX9vNDTdAGnDjYzUTmQwpCBdpuwMe5zsakfl9ZUR8W2nbIMsXm
 6auuCIx6Nqwd2KDisy3gta4h9JuUc6DiIKUFqqMwa9sjrSKKs8SaItICUYRLKEr8MGZr
 bhqM2o5ZmW3j1t9ihCL9TSA7KEXhtgdGYP9KiQqjATIYwf5YX1JjQImpAPJ/L6jK3X1/ dQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86u2wjpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 14:57:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OE74xx005932;
        Tue, 24 Jan 2023 14:57:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g50jau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 14:57:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9YlcpsIraSLYfDP0NIn2nwQonqGmPLcUmzpQV3ynQ8nXU8AWLGZxdbuDLh4eA7KK//lHYFgoZV/mly2ixMrpQoq+0nZn50kWzzeLX2Eht/jcfByKFOf3ajidxMAdcWfGl/gDzAhr8x58gvKMfG2vfzypJ/dOO6PN9xT0bEXcIQfr6nSrV0CPrl3mc5m1sKh16GK4T/kDuziOBIGGTXYLbrN+0PL+2nqbsGMFNsn02jVsySuNrS4gQ3jUdHVjtGQrt+AfBkhdAy+x3CqGUiPzpg0sPLGjJc3cgv+B9vEx4OsnTTPeUlS5rUS/MxODvopo9BT+TTEB8NtJqk5N0pyeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cPbhMtLO09aDva9Kpd+DuOJNNt9+LJzSojM7+V8CFSg=;
 b=b8iN6WQdI2ieR5yzQ46pU83XrqDHrauSIqrzdtOVBGoHCmg8+6I7K3qlyyc45rPk5BzhFCaRCDSTfC/a+9z+Vy3ruszmpQdaCNkv58tLI9+OU/mfXEiHFDD5CwSWKsjCy1JRpwDI9Au8iYeO07a6M09uIl71Qg4wyCTxMhXBvrNlJZCgNyCystP9d6IjBHY3xtG21e7cuhPFWR0aWBnBEKrMzf+UZ52XDWOTz/BWmznPQko5YaOtLjDrU8DIb4FYBwiZfS+KTvOjM0BQ8qX6XNfD/sq7ysYV7xYBnAqPq/SiXF2nv6Gjua5tTIV8BL76+W771Gbe2WnoSOaYg6T7fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPbhMtLO09aDva9Kpd+DuOJNNt9+LJzSojM7+V8CFSg=;
 b=kpGAStj78Qdfr8UqJgF5YN2YzPYM/kjjH3QuTJkpzzlMpLc0WI25KY2ZdxfgZTZ5g7rD3Kiy2I4f/v9xc0LLoEc1K6CoMtW1Ht6HYSqAp752dHD6G67+8mPTKY8e4cvp0BDPUY8y0dtRqjzR1RS9OOdfjQ4+F1kovQ1zB17yMiI=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 14:57:35 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed%4]) with mapi id 15.20.6043.017; Tue, 24 Jan 2023
 14:57:35 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Fwd: [PATCH RFC] NFSD: Convert filecache to rhltable
Thread-Topic: [PATCH RFC] NFSD: Convert filecache to rhltable
Thread-Index: AQHZIRZdLVddJev/70WpowDSuI8Nng==
Date:   Tue, 24 Jan 2023 14:57:35 +0000
Message-ID: <7456FF95-0C16-45C7-8CD9-B4436BE80B71@oracle.com>
References: <15afb0215ec76ffb54854eda8916efa4b5b3f6c3.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SA1PR10MB6365:EE_
x-ms-office365-filtering-correlation-id: c1af514d-6e18-477e-b5ab-08dafe1b5404
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oXrsniZ75cMpqHU7wWF1ayvMpsNRklDCwplg6o43qdkl7Bhnrm/AwLgwYsPOPhgCFv8kjX+pUWVX+pTS7NXSmZ4veb1SLJTg7FjtvsRXCWx8KoZyyPNyurg22xJFOxL9okyBvhHM93AALQ8SZ5+aLhJv6q4HzPJE7/leUBN9vQku6uXHsawOoCpqhCOZtMpDLn4wVSJo+plnKLHXHdT6GC+9O7k4t+JJdvwyDKyAQzxI6h+NA7Le1SG8ghq++vVQm2lB9aJEAoTOlRqJFDmFXMFwIMvJ808eRO1ia+gvzvkBPtVmKj30y3oDWJW6MXP1QwrmMrem/7xnLPQXbaLWkVk9VHzNcyaRiJ/OhIuF1xhaVE4vdJwOgJ8vOkKekZ1cXzt9+w402Q3C8nvLv59mn1Ynh6DVIGqQg8eLZTBG/S6qzpMSWnh+Fedjq9yvVZFbiPUYdepP/4GSffQivL+rmO8lZwt0Z24BqpxX3tTi+VahI2J05+xT+ah3bEGmYiC6j5U5I9NA4ZQupfSxZfezwP8LBOMfHCKe9aXEcKnLGcI+QILIS3FEUvsBlHKgYB7aivSPN5VpPLwfu0PUUgqh80hcGMxW4QfNYo49pAcdXc7HRUqQdKTuJdyRokJlW9vgUKDEpWFZtPcHZ7pjiG06lskGHy9G+dWkKZLc9u6C9AwQJYVmW9dDP0pgM0apxeAkeVvTAtLiT4cvkznadu3kSwmuGISrrBGZ1R6MukVrNfc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199015)(86362001)(6486002)(38070700005)(6512007)(186003)(26005)(36756003)(6506007)(53546011)(478600001)(33656002)(4326008)(91956017)(76116006)(66556008)(66446008)(64756008)(66946007)(66476007)(5660300002)(8676002)(8936002)(30864003)(41300700001)(83380400001)(110136005)(54906003)(2616005)(316002)(38100700002)(122000001)(71200400001)(2906002)(45980500001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6QQwELnlulFObuFeyF+A6ZlP+LppWEhYGujk3b5cW5Y/aFXJdqaWoLr0Xw8A?=
 =?us-ascii?Q?fh6xfgHh33PGH4YgKbQXxCC4x2HXbtDbeTkIPGa1A7Twne8PMPprRsyt8j1j?=
 =?us-ascii?Q?F+0FloF1TBahmS68frPKuCDrdarw7rAmr/2SRJGqSHL2PQQCjt8Fzv6Pptvz?=
 =?us-ascii?Q?wnmwujqagoAoytZECJfA7DNJR7GnzeeLoz766e88VLIcukZAI/oL0rD39ctt?=
 =?us-ascii?Q?ZtQXzv8i4UqQpjDMunp1R+1+lYFsPY8bcVBoh3g1NjzgfxUHGRocv4xqh3BS?=
 =?us-ascii?Q?WrAz7WrRkxzMF515jYVjhDg/xs2IZ2NiSts0PiVIAO8+E6Qcl85fGnNh+gY/?=
 =?us-ascii?Q?oub/uSYVgqtsWgWacgPWlsiAGe7OuZMSTUDaNeZXraSww/ib/5p2SHeGoxWf?=
 =?us-ascii?Q?rPQmZ7mQ317Yz+46yZvA8MhvsEj6esN5zTFbRu5/dtcD0P9Oa9ABb3yH8/92?=
 =?us-ascii?Q?+mVE8ESXY06TFhaEvQxtGyZtYHAulDFJ5nsi7m2KTvJiFg+DQEBqy1ERvrxG?=
 =?us-ascii?Q?8d68k7uR0bq3p8f/urQgXM8aq7MBi84IBfkSm/SUok+Z9jcn01bbGwGTPC/p?=
 =?us-ascii?Q?rfH/OOxpbejuGQx5Ef3iTtuf+HjhowfMKRELP9HMN9mGx1E6uuNs6cgn89dC?=
 =?us-ascii?Q?0JyW4Pn6ml84VAtnfIkfffXYxoSU2uKhT4hs4WUZ7/knReLqbWCQxcqn3n94?=
 =?us-ascii?Q?YLt8JCONwZYevHBUWhOAAV1Xu/l8v4UcHzceCbletzVo6X81ppzHk+C+vWN5?=
 =?us-ascii?Q?6fuK0xheTIo2BapzIgRUFhMwVTjHDEdtfi0R+4Asnepa0BZwRIIDOTOYZQqb?=
 =?us-ascii?Q?ZrzylOMGYyrn6CDAWEPmhK+d+z6fxeViiJlhxDHusqdh7PjRxhEyIlnLwe5U?=
 =?us-ascii?Q?tqdKaBvnLAEOGwN6zeS3G14RWAps6vrNR0ZUTbfCj7+5bKheFy32XR3Kf5OP?=
 =?us-ascii?Q?XM7D07CKwQ74V+1Ny6Q6lw/wFdrGgLrH/mgJHhh6skoN+Y1q18uzdnsup/H4?=
 =?us-ascii?Q?X9yzkCOr9xBmKxPkOSqmoYTW4/vO1AOZaWBWqvrCdBk8NLyrMsJJZf00A5E9?=
 =?us-ascii?Q?51hUikUchvtynK/VJQsejH078BtCbIlQmGawMIqmefTYTkCaDNHbWQWZ/eYY?=
 =?us-ascii?Q?r+nSYV7wOu8BArAu8g2gHmcEH4uQrS+FhTtrmjrykatjrBlnS3XGLHzsxGiz?=
 =?us-ascii?Q?3bMFLqYIFH0Su31p+Tx9MuXO568frq+yUwTQ+uc+xj3B7xemHGA61jeQ8zcb?=
 =?us-ascii?Q?ILO07HuYI/rIteQPw+CxP6Ny3KkneClPBaQ2QcU3d3ueaz2mK2KbQNnFeeiF?=
 =?us-ascii?Q?w9DytW1pRuLjxt76m0TVUlmFWNRqQlJV1Glmt8UbZf52OEAW4KSMNB8c2mGb?=
 =?us-ascii?Q?SasZ/XlcYm7mtD6Rtu1O8PtdoBwnffWv8GBSRp1KIQlKTMzm11ISkLnzOUHE?=
 =?us-ascii?Q?ojyjCXXMtCx56t2qn8l0mWBnjD9DfEobC73awpkWT22OLrkmNXZGgurVjIBY?=
 =?us-ascii?Q?Jxyk8OogHDtfjsPBJAoSIP3fz3ZhZhkzWuxC6KLQxwF1i/O6bHFlMgsqOcrN?=
 =?us-ascii?Q?hCILDwNNntowlfzNBlFFPrsjbnTefmXkxVUbSEmcrRPwnUrS1cs/fc8kkl02?=
 =?us-ascii?Q?Tg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3CFE40D1D4D6664591FC83F2F04603FB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YvZC77cSN70uc9ullhJmYxkpfU274rfj2/5Hj3aABSbgwvjDj2i+agY5diReraYzL0LqNhAcGInhhmjftbkV8CF7oTgcw3btYAU2bcwG4PEWsYPmfCCOC6C5BjDKmK8OZjmCZDrL7zGhmmA1Gu2NnGUf0UpBgEv/3LWcf7dG0q6iary37AoC8F02berkxyZlawbvOLClAUgPsNFXowcH8FlIzlJgqwXadWNFmnzS9QuSbxohrilDZkxXoLNmuBAgdtcJAatR7Hn8ybaag3r0+7lhgV3RODN/+Y2Opr1SNz8gc8yH2asDdQc6kp9MkLkf7vwsODjT2P/XgjlnhzNJgxbmRC0WKIp9BRB1rBbHpzfXb5cYgD7nm4DQr2UIJSfbBl/9reA1dFlYfSBJ9XBEmDL6u4S3MDbgub9I4yMgtrf+6r2d+kGCuQKXb37qpjjDoSCctZOXt3EqZ75eOvMRXxOeywjgMNxgZLwAYhQBof3c/1wcup/o/t5khVvc4fLGgZZvPkUnZoi/vMeSn5pg0JxxpfN1PjA4eRHXJ6lo14DkPquQOEY0Med7KrSfmor9HplKofRNfrooUzPUs6BfOpmDrzCCBskOEsLowGAzc1QF3g/PzBlEWxfI/bwdvMyMASf8l5qGOcAoScOT6VlsiaQnyl2DpwZ0Pvm+roWwx9w8RiBTif4cYvxHBRAqkI819uiGXUlXGZBGWjsEsso/dsk1lZvV8+MqX5lCxsBkbW7gIHOu2KGKB4zDlGZzrv0FqXKMffpGmXsuRstnAV9GnZmHcn+42xBIOsDEE5d1uXdPpyJ4NDC9d/N8MUj7fnm/IhBYvV87wXGfSWzk6uPtIA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1af514d-6e18-477e-b5ab-08dafe1b5404
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2023 14:57:35.3200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kqf4rSrUOKhq0hXVOyexwUeDQoLBK5JWm40Hwy5fva9jnN3tW2oh35jDzcLd9V4YJdpnmJhwAocq0cV2ha1mFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6365
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240135
X-Proofpoint-GUID: r4bzgufZ_PdOZaYmDuXR5je8FxmWfrfi
X-Proofpoint-ORIG-GUID: r4bzgufZ_PdOZaYmDuXR5je8FxmWfrfi
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> Begin forwarded message:
>=20
> From: Jeff Layton <jlayton@redhat.com>
> Subject: Re: [PATCH RFC] NFSD: Convert filecache to rhltable
> Date: January 23, 2023 at 4:38:50 PM EST
> To: Chuck Lever III <chuck.lever@oracle.com>
> Cc: Chuck Lever <cel@kernel.org>, Neil Brown <neilb@suse.de>, Linux NFS M=
ailing List <linux-nfs@vger.kernel.org>
>=20
> On Mon, 2023-01-23 at 20:34 +0000, Chuck Lever III wrote:
>>=20
>>> On Jan 23, 2023, at 3:15 PM, Jeff Layton <jlayton@redhat.com> wrote:
>>>=20
>>> On Thu, 2023-01-05 at 09:58 -0500, Chuck Lever wrote:
>>>> From: Chuck Lever <chuck.lever@oracle.com>
>>>>=20
>>>> While we were converting the nfs4_file hashtable to use the kernel's
>>>> resizable hashtable data structure, Neil Brown observed that the
>>>> list variant (rhltable) would be better for managing nfsd_file items
>>>> as well. The nfsd_file hash table will contain multiple entries for
>>>> the same inode -- these should be kept together on a list. And, it
>>>> could be possible for exotic or malicious client behavior to cause
>>>> the hash table to resize itself on every insertion.
>>>>=20
>>>> A nice simplification is that rhltable_lookup() can return a list
>>>> that contains only nfsd_file items that match a given inode, which
>>>> enables us to eliminate specialized hash table helper functions and
>>>> use the default functions provided by the rhashtable implementation).
>>>>=20
>>>> Since we are now storing nfsd_file items for the same inode on a
>>>> single list, that effectively reduces the number of hash entries
>>>> that have to be tracked in the hash table. The mininum bucket count
>>>> is therefore lowered.
>>>>=20
>>>> Suggested-by: Neil Brown <neilb@suse.de>
>>>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>>>> ---
>>>> fs/nfsd/filecache.c |  289 +++++++++++++++++++------------------------=
--------
>>>> fs/nfsd/filecache.h |    9 +-
>>>> 2 files changed, 115 insertions(+), 183 deletions(-)
>>>>=20
>>>> Just to note that this work is still in the wings. It would need to
>>>> be rebased on Jeff's recent fixes and clean-ups. I'm reluctant to
>>>> apply this until there is more evidence that the instability in v6.0
>>>> has been duly addressed.
>>>>=20
>>>>=20
>>>> diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
>>>> index 45b2c9e3f636..f04e722bb6bc 100644
>>>> --- a/fs/nfsd/filecache.c
>>>> +++ b/fs/nfsd/filecache.c
>>>> @@ -74,70 +74,9 @@ static struct list_lru			nfsd_file_lru;
>>>> static unsigned long			nfsd_file_flags;
>>>> static struct fsnotify_group		*nfsd_file_fsnotify_group;
>>>> static struct delayed_work		nfsd_filecache_laundrette;
>>>> -static struct rhashtable		nfsd_file_rhash_tbl
>>>> +static struct rhltable			nfsd_file_rhltable
>>>> 						____cacheline_aligned_in_smp;
>>>>=20
>>>> -enum nfsd_file_lookup_type {
>>>> -	NFSD_FILE_KEY_INODE,
>>>> -	NFSD_FILE_KEY_FULL,
>>>> -};
>>>> -
>>>> -struct nfsd_file_lookup_key {
>>>> -	struct inode			*inode;
>>>> -	struct net			*net;
>>>> -	const struct cred		*cred;
>>>> -	unsigned char			need;
>>>> -	bool				gc;
>>>> -	enum nfsd_file_lookup_type	type;
>>>> -};
>>>> -
>>>> -/*
>>>> - * The returned hash value is based solely on the address of an in-co=
de
>>>> - * inode, a pointer to a slab-allocated object. The entropy in such a
>>>> - * pointer is concentrated in its middle bits.
>>>> - */
>>>> -static u32 nfsd_file_inode_hash(const struct inode *inode, u32 seed)
>>>> -{
>>>> -	unsigned long ptr =3D (unsigned long)inode;
>>>> -	u32 k;
>>>> -
>>>> -	k =3D ptr >> L1_CACHE_SHIFT;
>>>> -	k &=3D 0x00ffffff;
>>>> -	return jhash2(&k, 1, seed);
>>>> -}
>>>> -
>>>> -/**
>>>> - * nfsd_file_key_hashfn - Compute the hash value of a lookup key
>>>> - * @data: key on which to compute the hash value
>>>> - * @len: rhash table's key_len parameter (unused)
>>>> - * @seed: rhash table's random seed of the day
>>>> - *
>>>> - * Return value:
>>>> - *   Computed 32-bit hash value
>>>> - */
>>>> -static u32 nfsd_file_key_hashfn(const void *data, u32 len, u32 seed)
>>>> -{
>>>> -	const struct nfsd_file_lookup_key *key =3D data;
>>>> -
>>>> -	return nfsd_file_inode_hash(key->inode, seed);
>>>> -}
>>>> -
>>>> -/**
>>>> - * nfsd_file_obj_hashfn - Compute the hash value of an nfsd_file
>>>> - * @data: object on which to compute the hash value
>>>> - * @len: rhash table's key_len parameter (unused)
>>>> - * @seed: rhash table's random seed of the day
>>>> - *
>>>> - * Return value:
>>>> - *   Computed 32-bit hash value
>>>> - */
>>>> -static u32 nfsd_file_obj_hashfn(const void *data, u32 len, u32 seed)
>>>> -{
>>>> -	const struct nfsd_file *nf =3D data;
>>>> -
>>>> -	return nfsd_file_inode_hash(nf->nf_inode, seed);
>>>> -}
>>>> -
>>>> static bool
>>>> nfsd_match_cred(const struct cred *c1, const struct cred *c2)
>>>> {
>>>> @@ -158,53 +97,16 @@ nfsd_match_cred(const struct cred *c1, const stru=
ct cred *c2)
>>>> 	return true;
>>>> }
>>>>=20
>>>> -/**
>>>> - * nfsd_file_obj_cmpfn - Match a cache item against search criteria
>>>> - * @arg: search criteria
>>>> - * @ptr: cache item to check
>>>> - *
>>>> - * Return values:
>>>> - *   %0 - Item matches search criteria
>>>> - *   %1 - Item does not match search criteria
>>>> - */
>>>> -static int nfsd_file_obj_cmpfn(struct rhashtable_compare_arg *arg,
>>>> -			       const void *ptr)
>>>> -{
>>>> -	const struct nfsd_file_lookup_key *key =3D arg->key;
>>>> -	const struct nfsd_file *nf =3D ptr;
>>>> -
>>>> -	switch (key->type) {
>>>> -	case NFSD_FILE_KEY_INODE:
>>>> -		if (nf->nf_inode !=3D key->inode)
>>>> -			return 1;
>>>> -		break;
>>>> -	case NFSD_FILE_KEY_FULL:
>>>> -		if (nf->nf_inode !=3D key->inode)
>>>> -			return 1;
>>>> -		if (nf->nf_may !=3D key->need)
>>>> -			return 1;
>>>> -		if (nf->nf_net !=3D key->net)
>>>> -			return 1;
>>>> -		if (!nfsd_match_cred(nf->nf_cred, key->cred))
>>>> -			return 1;
>>>> -		if (!!test_bit(NFSD_FILE_GC, &nf->nf_flags) !=3D key->gc)
>>>> -			return 1;
>>>> -		if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) =3D=3D 0)
>>>> -			return 1;
>>>> -		break;
>>>> -	}
>>>> -	return 0;
>>>> -}
>>>> -
>>>> static const struct rhashtable_params nfsd_file_rhash_params =3D {
>>>> 	.key_len		=3D sizeof_field(struct nfsd_file, nf_inode),
>>>> 	.key_offset		=3D offsetof(struct nfsd_file, nf_inode),
>>>> -	.head_offset		=3D offsetof(struct nfsd_file, nf_rhash),
>>>> -	.hashfn			=3D nfsd_file_key_hashfn,
>>>> -	.obj_hashfn		=3D nfsd_file_obj_hashfn,
>>>> -	.obj_cmpfn		=3D nfsd_file_obj_cmpfn,
>>>> -	/* Reduce resizing churn on light workloads */
>>>> -	.min_size		=3D 512,		/* buckets */
>>>> +	.head_offset		=3D offsetof(struct nfsd_file, nf_rlist),
>>>> +
>>>> +	/*
>>>> +	 * Start with a single page hash table to reduce resizing churn
>>>> +	 * on light workloads.
>>>> +	 */
>>>> +	.min_size		=3D 256,
>>>> 	.automatic_shrinking	=3D true,
>>>> };
>>>>=20
>>>> @@ -307,27 +209,27 @@ nfsd_file_mark_find_or_create(struct nfsd_file *=
nf, struct inode *inode)
>>>> }
>>>>=20
>>>> static struct nfsd_file *
>>>> -nfsd_file_alloc(struct nfsd_file_lookup_key *key, unsigned int may)
>>>> +nfsd_file_alloc(struct net *net, struct inode *inode, unsigned char n=
eed,
>>>> +		bool want_gc)
>>>> {
>>>> 	struct nfsd_file *nf;
>>>>=20
>>>> 	nf =3D kmem_cache_alloc(nfsd_file_slab, GFP_KERNEL);
>>>> -	if (nf) {
>>>> -		INIT_LIST_HEAD(&nf->nf_lru);
>>>> -		nf->nf_birthtime =3D ktime_get();
>>>> -		nf->nf_file =3D NULL;
>>>> -		nf->nf_cred =3D get_current_cred();
>>>> -		nf->nf_net =3D key->net;
>>>> -		nf->nf_flags =3D 0;
>>>> -		__set_bit(NFSD_FILE_HASHED, &nf->nf_flags);
>>>> -		__set_bit(NFSD_FILE_PENDING, &nf->nf_flags);
>>>> -		if (key->gc)
>>>> -			__set_bit(NFSD_FILE_GC, &nf->nf_flags);
>>>> -		nf->nf_inode =3D key->inode;
>>>> -		refcount_set(&nf->nf_ref, 1);
>>>> -		nf->nf_may =3D key->need;
>>>> -		nf->nf_mark =3D NULL;
>>>> -	}
>>>> +	if (unlikely(!nf))
>>>> +		return NULL;
>>>> +
>>>> +	INIT_LIST_HEAD(&nf->nf_lru);
>>>> +	nf->nf_birthtime =3D ktime_get();
>>>> +	nf->nf_file =3D NULL;
>>>> +	nf->nf_cred =3D get_current_cred();
>>>> +	nf->nf_net =3D net;
>>>> +	nf->nf_flags =3D want_gc ?
>>>> +		BIT(NFSD_FILE_HASHED) | BIT(NFSD_FILE_PENDING) | BIT(NFSD_FILE_GC) =
:
>>>> +		BIT(NFSD_FILE_HASHED) | BIT(NFSD_FILE_PENDING);
>>>> +	nf->nf_inode =3D inode;
>>>> +	refcount_set(&nf->nf_ref, 1);
>>>> +	nf->nf_may =3D need;
>>>> +	nf->nf_mark =3D NULL;
>>>> 	return nf;
>>>> }
>>>>=20
>>>> @@ -362,8 +264,8 @@ nfsd_file_hash_remove(struct nfsd_file *nf)
>>>>=20
>>>> 	if (nfsd_file_check_write_error(nf))
>>>> 		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
>>>> -	rhashtable_remove_fast(&nfsd_file_rhash_tbl, &nf->nf_rhash,
>>>> -			       nfsd_file_rhash_params);
>>>> +	rhltable_remove(&nfsd_file_rhltable, &nf->nf_rlist,
>>>> +			nfsd_file_rhash_params);
>>>> }
>>>>=20
>>>> static bool
>>>> @@ -680,21 +582,19 @@ static struct shrinker	nfsd_file_shrinker =3D {
>>>> static void
>>>> nfsd_file_queue_for_close(struct inode *inode, struct list_head *dispo=
se)
>>>> {
>>>> -	struct nfsd_file_lookup_key key =3D {
>>>> -		.type	=3D NFSD_FILE_KEY_INODE,
>>>> -		.inode	=3D inode,
>>>> -	};
>>>> -	struct nfsd_file *nf;
>>>> -
>>>> 	rcu_read_lock();
>>>> 	do {
>>>> +		struct rhlist_head *list;
>>>> +		struct nfsd_file *nf;
>>>> 		int decrement =3D 1;
>>>>=20
>>>> -		nf =3D rhashtable_lookup(&nfsd_file_rhash_tbl, &key,
>>>> +		list =3D rhltable_lookup(&nfsd_file_rhltable, &inode,
>>>> 				       nfsd_file_rhash_params);
>>>> -		if (!nf)
>>>> +		if (!list)
>>>> 			break;
>>>>=20
>>>=20
>>> Rather than redriving the lookup multiple times in the loop, would it b=
e
>>> better to just search once and then walk the resulting list with
>>> rhl_for_each_entry_rcu, all while holding the rcu_read_lock?
>>=20
>> That would be nice, but as you and I have discussed before:
>>=20
>> On every iteration, we're possibly calling nfsd_file_unhash(), which
>> changes the list. So we have to invoke rhltable_lookup() again to get
>> the updated version of that list.
>>=20
>> As far as I can see there's no "_safe" version of rhl_for_each_entry.
>>=20
>> I think the best we can do is not redrive the lookup if we didn't
>> unhash anything. I'm not sure that will fit easily with the
>> nfsd_file_cond_queue thingie you just added in nfsd-fixes.
>>=20
>> Perhaps it should also drop the RCU read lock on each iteration in
>> case it finds a lot of inodes that match the lookup criteria.
>>=20
>=20
> I could be wrong, but it looks like you're safe to traverse the list
> even in the case of removals, assuming the objects themselves are
> rcu-freed. AFAICT, the object's ->next pointer is not changed when it's
> removed from the table. After all, we're not holding a "real" lock here
> so the object could be removed by another task at any time.
>=20
> It would be nice if this were documented though.

Hi Thomas, Herbert -

We'd like to convert fs/nfsd/filecache.c from rhashtable to rhltable.
There's one function that wants to remove all the items on one of the
lists: nfsd_file_queue_for_close().

Is there a preferred approach for this with rhltable? Can we just
hold rcu_read_lock and call rhltable_remove repeatedly without getting
a fresh copy of the list these items reside on?


>>>> +		nf =3D container_of(list, struct nfsd_file, nf_rlist);
>>>> +
>>>> 		/* If we raced with someone else unhashing, ignore it */
>>>> 		if (!nfsd_file_unhash(nf))
>>>> 			continue;
>>>> @@ -836,7 +736,7 @@ nfsd_file_cache_init(void)
>>>> 	if (test_and_set_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) =3D=3D 1)
>>>> 		return 0;
>>>>=20
>>>> -	ret =3D rhashtable_init(&nfsd_file_rhash_tbl, &nfsd_file_rhash_param=
s);
>>>> +	ret =3D rhltable_init(&nfsd_file_rhltable, &nfsd_file_rhash_params);
>>>> 	if (ret)
>>>> 		return ret;
>>>>=20
>>>> @@ -904,7 +804,7 @@ nfsd_file_cache_init(void)
>>>> 	nfsd_file_mark_slab =3D NULL;
>>>> 	destroy_workqueue(nfsd_filecache_wq);
>>>> 	nfsd_filecache_wq =3D NULL;
>>>> -	rhashtable_destroy(&nfsd_file_rhash_tbl);
>>>> +	rhltable_destroy(&nfsd_file_rhltable);
>>>> 	goto out;
>>>> }
>>>>=20
>>>> @@ -922,7 +822,7 @@ __nfsd_file_cache_purge(struct net *net)
>>>> 	struct nfsd_file *nf;
>>>> 	LIST_HEAD(dispose);
>>>>=20
>>>> -	rhashtable_walk_enter(&nfsd_file_rhash_tbl, &iter);
>>>> +	rhltable_walk_enter(&nfsd_file_rhltable, &iter);
>>>> 	do {
>>>> 		rhashtable_walk_start(&iter);
>>>>=20
>>>> @@ -1031,7 +931,7 @@ nfsd_file_cache_shutdown(void)
>>>> 	nfsd_file_mark_slab =3D NULL;
>>>> 	destroy_workqueue(nfsd_filecache_wq);
>>>> 	nfsd_filecache_wq =3D NULL;
>>>> -	rhashtable_destroy(&nfsd_file_rhash_tbl);
>>>> +	rhltable_destroy(&nfsd_file_rhltable);
>>>>=20
>>>> 	for_each_possible_cpu(i) {
>>>> 		per_cpu(nfsd_file_cache_hits, i) =3D 0;
>>>> @@ -1042,6 +942,36 @@ nfsd_file_cache_shutdown(void)
>>>> 	}
>>>> }
>>>>=20
>>>> +static struct nfsd_file *
>>>> +nfsd_file_lookup_locked(const struct net *net, const struct cred *cre=
d,
>>>> +			struct inode *inode, unsigned char need,
>>>> +			bool want_gc)
>>>> +{
>>>> +	struct rhlist_head *tmp, *list;
>>>> +	struct nfsd_file *nf;
>>>> +
>>>> +	list =3D rhltable_lookup(&nfsd_file_rhltable, &inode,
>>>> +			       nfsd_file_rhash_params);
>>>> +	rhl_for_each_entry_rcu(nf, tmp, list, nf_rlist) {
>>>> +		if (nf->nf_may !=3D need)
>>>> +			continue;
>>>> +		if (nf->nf_net !=3D net)
>>>> +			continue;
>>>> +		if (!nfsd_match_cred(nf->nf_cred, cred))
>>>> +			continue;
>>>> +		if (!!test_bit(NFSD_FILE_GC, &nf->nf_flags) !=3D want_gc)
>>>> +			continue;
>>>> +		if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) =3D=3D 0)
>>>> +			continue;
>>>> +
>>>> +		/* If it was on the LRU, reuse that reference. */
>>>> +		if (nfsd_file_lru_remove(nf))
>>>> +			WARN_ON_ONCE(refcount_dec_and_test(&nf->nf_ref));
>>>> +		return nf;
>>>> +	}
>>>> +	return NULL;
>>>> +}
>>>> +
>>>> /**
>>>> * nfsd_file_is_cached - are there any cached open files for this inode=
?
>>>> * @inode: inode to check
>>>> @@ -1056,15 +986,12 @@ nfsd_file_cache_shutdown(void)
>>>> bool
>>>> nfsd_file_is_cached(struct inode *inode)
>>>> {
>>>> -	struct nfsd_file_lookup_key key =3D {
>>>> -		.type	=3D NFSD_FILE_KEY_INODE,
>>>> -		.inode	=3D inode,
>>>> -	};
>>>> -	bool ret =3D false;
>>>> -
>>>> -	if (rhashtable_lookup_fast(&nfsd_file_rhash_tbl, &key,
>>>> -				   nfsd_file_rhash_params) !=3D NULL)
>>>> -		ret =3D true;
>>>> +	bool ret;
>>>> +
>>>> +	rcu_read_lock();
>>>> +	ret =3D (rhltable_lookup(&nfsd_file_rhltable, &inode,
>>>> +			       nfsd_file_rhash_params) !=3D NULL);
>>>> +	rcu_read_unlock();
>>>> 	trace_nfsd_file_is_cached(inode, (int)ret);
>>>> 	return ret;
>>>> }
>>>> @@ -1074,14 +1001,12 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, s=
truct svc_fh *fhp,
>>>> 		     unsigned int may_flags, struct nfsd_file **pnf,
>>>> 		     bool open, bool want_gc)
>>>> {
>>>> -	struct nfsd_file_lookup_key key =3D {
>>>> -		.type	=3D NFSD_FILE_KEY_FULL,
>>>> -		.need	=3D may_flags & NFSD_FILE_MAY_MASK,
>>>> -		.net	=3D SVC_NET(rqstp),
>>>> -		.gc	=3D want_gc,
>>>> -	};
>>>> +	unsigned char need =3D may_flags & NFSD_FILE_MAY_MASK;
>>>> +	struct net *net =3D SVC_NET(rqstp);
>>>> +	struct nfsd_file *new, *nf;
>>>> +	const struct cred *cred;
>>>> 	bool open_retry =3D true;
>>>> -	struct nfsd_file *nf;
>>>> +	struct inode *inode;
>>>> 	__be32 status;
>>>> 	int ret;
>>>>=20
>>>> @@ -1089,32 +1014,38 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, s=
truct svc_fh *fhp,
>>>> 				may_flags|NFSD_MAY_OWNER_OVERRIDE);
>>>> 	if (status !=3D nfs_ok)
>>>> 		return status;
>>>> -	key.inode =3D d_inode(fhp->fh_dentry);
>>>> -	key.cred =3D get_current_cred();
>>>> +	inode =3D d_inode(fhp->fh_dentry);
>>>> +	cred =3D get_current_cred();
>>>>=20
>>>> retry:
>>>> -	rcu_read_lock();
>>>> -	nf =3D rhashtable_lookup(&nfsd_file_rhash_tbl, &key,
>>>> -			       nfsd_file_rhash_params);
>>>> -	if (nf)
>>>> -		nf =3D nfsd_file_get(nf);
>>>> -	rcu_read_unlock();
>>>> -
>>>> -	if (nf) {
>>>> -		if (nfsd_file_lru_remove(nf))
>>>> -			WARN_ON_ONCE(refcount_dec_and_test(&nf->nf_ref));
>>>> -		goto wait_for_construction;
>>>> +	if (open) {
>>>> +		rcu_read_lock();
>>>> +		nf =3D nfsd_file_lookup_locked(net, cred, inode, need, want_gc);
>>>> +		rcu_read_unlock();
>>>> +		if (nf)
>>>> +			goto wait_for_construction;
>>>> 	}
>>>>=20
>>>> -	nf =3D nfsd_file_alloc(&key, may_flags);
>>>> -	if (!nf) {
>>>> +	new =3D nfsd_file_alloc(net, inode, need, want_gc);
>>>> +	if (!new) {
>>>> 		status =3D nfserr_jukebox;
>>>> 		goto out_status;
>>>> 	}
>>>> +	rcu_read_lock();
>>>> +	spin_lock(&inode->i_lock);
>>>> +	nf =3D nfsd_file_lookup_locked(net, cred, inode, need, want_gc);
>>>> +	if (unlikely(nf)) {
>>>> +		spin_unlock(&inode->i_lock);
>>>> +		rcu_read_unlock();
>>>> +		nfsd_file_slab_free(&new->nf_rcu);
>>>> +		goto wait_for_construction;
>>>> +	}
>>>> +	nf =3D new;
>>>> +	ret =3D rhltable_insert(&nfsd_file_rhltable, &nf->nf_rlist,
>>>> +			      nfsd_file_rhash_params);
>>>> +	spin_unlock(&inode->i_lock);
>>>> +	rcu_read_unlock();
>>>>=20
>>>> -	ret =3D rhashtable_lookup_insert_key(&nfsd_file_rhash_tbl,
>>>> -					   &key, &nf->nf_rhash,
>>>> -					   nfsd_file_rhash_params);
>>>> 	if (likely(ret =3D=3D 0))
>>>> 		goto open_file;
>>>>=20
>>>> @@ -1122,7 +1053,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, str=
uct svc_fh *fhp,
>>>> 	nf =3D NULL;
>>>> 	if (ret =3D=3D -EEXIST)
>>>> 		goto retry;
>>>> -	trace_nfsd_file_insert_err(rqstp, key.inode, may_flags, ret);
>>>> +	trace_nfsd_file_insert_err(rqstp, inode, may_flags, ret);
>>>> 	status =3D nfserr_jukebox;
>>>> 	goto out_status;
>>>>=20
>>>> @@ -1131,7 +1062,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, str=
uct svc_fh *fhp,
>>>>=20
>>>> 	/* Did construction of this file fail? */
>>>> 	if (!test_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
>>>> -		trace_nfsd_file_cons_err(rqstp, key.inode, may_flags, nf);
>>>> +		trace_nfsd_file_cons_err(rqstp, inode, may_flags, nf);
>>>> 		if (!open_retry) {
>>>> 			status =3D nfserr_jukebox;
>>>> 			goto out;
>>>> @@ -1157,14 +1088,14 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, s=
truct svc_fh *fhp,
>>>> 	}
>>>>=20
>>>> out_status:
>>>> -	put_cred(key.cred);
>>>> +	put_cred(cred);
>>>> 	if (open)
>>>> -		trace_nfsd_file_acquire(rqstp, key.inode, may_flags, nf, status);
>>>> +		trace_nfsd_file_acquire(rqstp, inode, may_flags, nf, status);
>>>> 	return status;
>>>>=20
>>>> open_file:
>>>> 	trace_nfsd_file_alloc(nf);
>>>> -	nf->nf_mark =3D nfsd_file_mark_find_or_create(nf, key.inode);
>>>> +	nf->nf_mark =3D nfsd_file_mark_find_or_create(nf, inode);
>>>> 	if (nf->nf_mark) {
>>>> 		if (open) {
>>>> 			status =3D nfsd_open_verified(rqstp, fhp, may_flags,
>>>> @@ -1178,7 +1109,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, str=
uct svc_fh *fhp,
>>>> 	 * If construction failed, or we raced with a call to unlink()
>>>> 	 * then unhash.
>>>> 	 */
>>>> -	if (status =3D=3D nfs_ok && key.inode->i_nlink =3D=3D 0)
>>>> +	if (status !=3D nfs_ok || inode->i_nlink =3D=3D 0)
>>>> 		status =3D nfserr_jukebox;
>>>> 	if (status !=3D nfs_ok)
>>>> 		nfsd_file_unhash(nf);
>>>> @@ -1273,7 +1204,7 @@ int nfsd_file_cache_stats_show(struct seq_file *=
m, void *v)
>>>> 		lru =3D list_lru_count(&nfsd_file_lru);
>>>>=20
>>>> 		rcu_read_lock();
>>>> -		ht =3D &nfsd_file_rhash_tbl;
>>>> +		ht =3D &nfsd_file_rhltable.ht;
>>>> 		count =3D atomic_read(&ht->nelems);
>>>> 		tbl =3D rht_dereference_rcu(ht->tbl, ht);
>>>> 		buckets =3D tbl->size;
>>>> @@ -1289,7 +1220,7 @@ int nfsd_file_cache_stats_show(struct seq_file *=
m, void *v)
>>>> 		evictions +=3D per_cpu(nfsd_file_evictions, i);
>>>> 	}
>>>>=20
>>>> -	seq_printf(m, "total entries: %u\n", count);
>>>> +	seq_printf(m, "total inodes: %u\n", count);
>>>> 	seq_printf(m, "hash buckets:  %u\n", buckets);
>>>> 	seq_printf(m, "lru entries:   %lu\n", lru);
>>>> 	seq_printf(m, "cache hits:    %lu\n", hits);
>>>> diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
>>>> index b7efb2c3ddb1..7d3b35771565 100644
>>>> --- a/fs/nfsd/filecache.h
>>>> +++ b/fs/nfsd/filecache.h
>>>> @@ -29,9 +29,8 @@ struct nfsd_file_mark {
>>>> * never be dereferenced, only used for comparison.
>>>> */
>>>> struct nfsd_file {
>>>> -	struct rhash_head	nf_rhash;
>>>> -	struct list_head	nf_lru;
>>>> -	struct rcu_head		nf_rcu;
>>>> +	struct rhlist_head	nf_rlist;
>>>> +	void			*nf_inode;
>>>> 	struct file		*nf_file;
>>>> 	const struct cred	*nf_cred;
>>>> 	struct net		*nf_net;
>>>> @@ -40,10 +39,12 @@ struct nfsd_file {
>>>> #define NFSD_FILE_REFERENCED	(2)
>>>> #define NFSD_FILE_GC		(3)
>>>> 	unsigned long		nf_flags;
>>>> -	struct inode		*nf_inode;	/* don't deref */
>>>> 	refcount_t		nf_ref;
>>>> 	unsigned char		nf_may;
>>>> +
>>>> 	struct nfsd_file_mark	*nf_mark;
>>>> +	struct list_head	nf_lru;
>>>> +	struct rcu_head		nf_rcu;
>>>> 	ktime_t			nf_birthtime;
>>>> };
>>>>=20
>>>>=20
>>>>=20
>>>=20
>>> --=20
>>> Jeff Layton <jlayton@redhat.com>
>>=20
>> --
>> Chuck Lever
>>=20
>>=20
>>=20
>=20
> --=20
> Jeff Layton <jlayton@redhat.com>

--
Chuck Lever



