Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBD44651EB
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 16:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348015AbhLAPpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 10:45:54 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9068 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236266AbhLAPpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 10:45:51 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B1EZuqZ009641;
        Wed, 1 Dec 2021 15:42:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=RcMcKJTYJ6E6dXiHZ1ehuoiNJxu034M5v7xYqTzE0x8=;
 b=qJXWfQ5NeNePHRr//vJDrpQboSe5NyjDugQfSVcA3hwkB/s/RkLjKKPb9V+I0H4gqZCb
 OL+E9k51NiyvlHE9UBJi1GLnDT1Mm1MzdqLsSHv4UNnf58Purr/n0Tq5nzS7wAIFgRty
 /2JYqH9kfxTMii1+ivgSbJ6RCeUTuqiUbJrLSxcVT1YSK04rKPDAqoLwAwtCspNb7Tx7
 u/nPDFMjYzE8zbjowLOof2NDxCDgFbJ6M/kwYmdTk4gmSJ1kV6bycm00dOfZRbD1BCiE
 tcoh86ti3S/78K+ZuJEOC+JOQGEGorGC0UoaLHeO7TD3qJkQbTlLGTSZ73zuwttMaBNV 8A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cp9r50wdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 15:42:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B1FJXk6143250;
        Wed, 1 Dec 2021 15:42:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3030.oracle.com with ESMTP id 3ckaqgpm79-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 15:42:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3vMwjbfkI73pIytfKuPC2wxnD6Q0RFpEu0jtzfqu3wukrBor7w8HLV3XDqxmWKSGRJMtsEQP0qyUW+Ivr9kzlHOnnGnHegXDYJsY1b9IPTPexmOTOOxSJAWOUrkvmTHbpcDujBJtOaH/Ueaar0BP8bbI0N1Y3LrYjibthlux+fkrqILY4p6NIvumAGhRabnDjGE0A2hlmF46O+wIpRO6U35vUab7YGe6Bom/GJOrQzihrCxRa1w9treG0dYfbghsYSX3VQZFvAl9y/mSl1GT36QIqMCj2B1RhSpdLWFoHf1WlWh9mZye+vjgJYTS15OriScRkj0lRqPNwxUHjVfPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RcMcKJTYJ6E6dXiHZ1ehuoiNJxu034M5v7xYqTzE0x8=;
 b=AW/uKCY3LCrDiLGLZ9j6d9iJOXBPUKELxKnQW9QA5j/Z0v6xbdfR3thR3xpvhaTuR/JcZrufS1mYouSSJkuncTQKsk9gyEoVa+2pyhy32QskBYgGNuxlmE/NgdG7j2j5uYUyH8OoI9XKKs6IsVb/loV/LWHiy7jgNxQn9bPa35CUl0XtcC0imUGpdf0nrxxONGt9Jbk4QGryQlw4PRvfVkRx2+2Xgg7mmTyp+8nzBM6yd0rgS8pYlZD7lWKa/BTkwfR/p6wkDjSNLzlI+YWKCUnszZvUhkMU+MirC33Mzp+e37tUZEHf+EcufLLw1z1M9OeOywaKsPKc+qdWF137pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcMcKJTYJ6E6dXiHZ1ehuoiNJxu034M5v7xYqTzE0x8=;
 b=W+dEUxxMFvvWxzTVimgj5ukvbxNwvVSs75T0Ugr43w8ZM0WkUBUJ5fEP+tyHQOxDBKwNSRkkkoO2XM5enM2K1tF6JqJlU77XG1mxjdHiSY+AnYJaUr++PB+dog+mitz26im9KbBuJTEFIpZRug7OqiclrDLI8q/eE1DySHEOyQs=
Received: from BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25)
 by BYAPR10MB3335.namprd10.prod.outlook.com (2603:10b6:a03:15d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Wed, 1 Dec
 2021 15:42:19 +0000
Received: from BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::715c:4853:52ce:dd7e]) by BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::715c:4853:52ce:dd7e%5]) with mapi id 15.20.4734.027; Wed, 1 Dec 2021
 15:42:19 +0000
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     William Kucharski <william.kucharski@oracle.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH V2] net/rds: correct socket tunable error in
 rds_tcp_tune()
Thread-Topic: [PATCH V2] net/rds: correct socket tunable error in
 rds_tcp_tune()
Thread-Index: AQHX5sIWg/vUV/7OrE2phwIhfSuXFKwdxoeA
Date:   Wed, 1 Dec 2021 15:42:19 +0000
Message-ID: <D6C3AAC8-9204-4D0E-9F6F-B7EF9F86D8E2@oracle.com>
References: <20211201144522.557669-1-william.kucharski@oracle.com>
In-Reply-To: <20211201144522.557669-1-william.kucharski@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d874498b-88db-4b83-076e-08d9b4e12907
x-ms-traffictypediagnostic: BYAPR10MB3335:
x-microsoft-antispam-prvs: <BYAPR10MB3335D21374A5D264259EE80193689@BYAPR10MB3335.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DVCJrdyE2c/jcUiqSTiOa6pjEr+cDe3YHA6UA1GK8gL1XPsrNCHlWCha/aE5tFW3wsRV3j5TzO8qU5Ct+D12esdYR6rt5nMzQjuW+ezcLWAjz5rbEhCCvVimxQM+I7FWaz6QUlU4j7uVujooy2sfywjNybG8kS0qmlha/Pk1TmUzPfBPRUVsM6FWRS5CI+Rh0W18A8tbjSMxWxk99nMBTrdOkY1rkwG/e1tYMhqsqZ/2X6VSoy6uy0kFqdaLn4EJQEjcvySfEqlkLIPTVZyJde8zkgDYeTaKWas+59w3jlrIZFWAqhmNuRGq11OkccwFjUotfFtQ44eJjfuyvuN2rcNuezGCpVem8SdZgKe3zrMNcMoJqQ55M2oRldS+A9+5hRM8N8FMmK6nqywjwyisSuhWamMDJ3LSVkxyB2Fs2HP9JsBOxJn3A0Tbw+SCBbQ5W+7TW3zdZtOHcDu3/0zyfDlLEiEaenwZm96qxNt7EVtj/a0AKsCwVuuxted/VDWp/0/91oB5SzavEQYx+5B0AKJZ1BNp0skpGFLlJ0GtZOQhkoxyeQqkDcu4/GgJose4QhVrj2VgFW8Sc9JDNsvu4Y1q//bOrkN4DAQx/hWz4BCnGsIROILjJccqEOq9kfactD6JN54eczLX8pVbDCTfj0Lu89NJW+DXghzwb3itHniRG7/kbgXlnYf5qyEoXDpt9nYlmnwoaRL1PgSbdfZZfjaiyVEr1tAAiX3qdl9FWf/AKyslTLQ6M6rVWpzvGC3e
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(33656002)(4326008)(316002)(8936002)(86362001)(6512007)(6636002)(36756003)(8676002)(2906002)(38100700002)(508600001)(38070700005)(71200400001)(26005)(76116006)(186003)(54906003)(91956017)(4744005)(66476007)(66556008)(37006003)(66946007)(64756008)(66446008)(6506007)(6862004)(6486002)(2616005)(5660300002)(53546011)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GHKH5Ou1xbuLC4+i/v4EvsB9JUMIB61nhTCkZdcUQTFFwcvAfBFvok9lTiPU?=
 =?us-ascii?Q?46DkOgrKnhtygwMF74hoyoKDj7leg2eECaas7S+sVy87Rm3cdDKearh+3vdN?=
 =?us-ascii?Q?EywX+DWjb2ILqnmrGQKpDNyd+L69qoWdK1v8yctkRSsTC72B9O4K8NFBHCgG?=
 =?us-ascii?Q?8mWh+h1zU2JZAFC7xmJQih31tbiQ4aiq8l56d/x60o0zEGyVmcFL+8E4ueOm?=
 =?us-ascii?Q?6/qN5cpBTgge9hgGJTFwaIgSDMhLSIL9Wmr5pCBkf6+v0U9mLhrGce5whuzv?=
 =?us-ascii?Q?ZGb4y1/3zKXSciliS+w/am8rraOLQQvv8dnAtd8wAZwRlbROKPG9Z/6Kpy5t?=
 =?us-ascii?Q?QK7WluRj4PpG5pC+1/bCIkdlZt/78IkvwhmTr0Y6nA8rlnulB9WOk+zoPKqE?=
 =?us-ascii?Q?gmA2OD7zkeDz0+bj/v8TyA9seKse78JFV4xjjj7ZzdCMu8lbEuZM84NVjczs?=
 =?us-ascii?Q?985qr+9AhOgtCjnN+I20xUh9sBc3PRl5AMgAqQuoqRlrqX/J+n6RtDknfFYO?=
 =?us-ascii?Q?JCAtuXdHc2R5hs+EsDpFDYphMxrAXtzFEj5HgdxSKDpifbwpec+G+fBcQKKz?=
 =?us-ascii?Q?qH0K9gE5l6ce2jnEcuvwu+ckUfEqgCWU6zhLXc/QxbALwuTMHQ1zENEkR6l5?=
 =?us-ascii?Q?Y4OnwGB2C2WIBra3u8DAtoRLlKpxaiDaIB2k7Dpqfcg+UlbEAuzRt0KrfFTt?=
 =?us-ascii?Q?9NHUGw9eHF5SUy+hdFCedZX4ETcqonYV8LSws3X81WMaenQt5IrDjpvAYGb0?=
 =?us-ascii?Q?j4Rl3ZWX6wXXhssFQwQBurJsFPjLF5AhlaPSgUL4uNq+uqdZo+BhgVGDv5EF?=
 =?us-ascii?Q?vTf2Gg7mrkNwRD+3PN9SKCKb7v8C9acLv6UZOPVL/asenrIyB9U7PZHTyGWy?=
 =?us-ascii?Q?LjKTssAdeJZdZl23oP9Luffvh3rJhNqJYnQwesvy6ldm2tzdkUKf1MoEXuLq?=
 =?us-ascii?Q?ssZu0WV1KnWKwFo1nXlZsd77pXjc4LGuHYVsZruCHdHGHHdXV0HRZFdrOZnl?=
 =?us-ascii?Q?C+i9aZNmMi+fgolKVwJOyMFd82CPfunByAXeFxkEMwxetLHHGhYLfPIK+330?=
 =?us-ascii?Q?RCxmuhQMbYvM7jNQpCHz2DvpZIK+nFEn4kKO4F+Oa3qlP5bRUpsoNIhXj39o?=
 =?us-ascii?Q?juvgUMvN74lsG86rYIMWqGLKZnfNEo2HkC+lJRO5IsSfricMCUlcCED+DLZZ?=
 =?us-ascii?Q?zLKg4lVJ4NLkBHLNt6dt9wIIuAj8G5VkPRB4vjBWS61uCd5U65+Kxh31A4co?=
 =?us-ascii?Q?pF//d0A3+TCKLt8MZUdFSVuLqmTWwIr/lDK3z7+Z00AGpwMmMPo0Lm9PDBhO?=
 =?us-ascii?Q?/AiKV2uC3/55BhHY0QOSJ8JkqwFWGMal5P3DMFXOR9I38Ib9A8GOkHuVJbVh?=
 =?us-ascii?Q?koGRFRlFetJUh0oPbJf7xWE6gEYy1WUUalnUB85yv+JX3JbpuaQgoYtp+wr+?=
 =?us-ascii?Q?u5ZAF0w7Ysfn8WtW+qOhbGpV40h4Gz5XdjV3uv3nFreoJMvUVzJSCZHERYZz?=
 =?us-ascii?Q?oTdIOUFzHt/WWDUKx316N7/W96Ew/6/6yaw90hGc5oDTx4xNfkx0eExV6/wK?=
 =?us-ascii?Q?2BFPHhVYfHjtJjrkfbLb2ITNtfHqstWSmirl6mWyZbfZdd6BTimQhyoM2IR0?=
 =?us-ascii?Q?g27FfQJxp1qe7CGG67Ol5TWO+VUUovnZnCocCggTcARjVqcBaZ/nq6tz25a5?=
 =?us-ascii?Q?MlYrWfTOjLQY1r4ns3h9BMWkXAM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F361A08E459D1A49951D9E07655C85DF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d874498b-88db-4b83-076e-08d9b4e12907
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2021 15:42:19.7254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iQnZXPw3DPvIIcz+vM5dl/MVJ39uriHofn21nLIYsC3bScGyq1TThR+A9aOV+vnojvYunul3Ufi5S1aNJxM937FRzGH1tvOtsraESMZlccg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3335
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10185 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112010087
X-Proofpoint-ORIG-GUID: DRXdpo4fFYvA-zXNjC7BiXGruH8ngv7W
X-Proofpoint-GUID: DRXdpo4fFYvA-zXNjC7BiXGruH8ngv7W
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Dec 1, 2021, at 6:45 AM, William Kucharski <william.kucharski@oracle.c=
om> wrote:
>=20
> Correct an error where setting /proc/sys/net/rds/tcp/rds_tcp_rcvbuf would
> instead modify the socket's sk_sndbuf and would leave sk_rcvbuf untouched=
.
>=20
> Fixes: c6a58ffed536 ("RDS: TCP: Add sysctl tunables for sndbuf/rcvbuf on =
rds-tcp socket")
> Signed-off-by: William Kucharski <william.kucharski@oracle.com>
> ---
> V2: Add Fixes tag to refer to original commit that introduced the issue

Good catch.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>=
