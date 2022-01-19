Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8576B493AE1
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 14:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354676AbiASNMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 08:12:45 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8508 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354629AbiASNMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 08:12:44 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JAC35L018362;
        Wed, 19 Jan 2022 13:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=sWPnl6D5wt4VtlA1pWPXdG2p+idYFuuMFe5mxf1Vj4k=;
 b=virr/yJ2GH26P0vY+0oMP0qMK+h4J8dasZAZzCSCQ1ENML7H887kptzIo6ylfP9a/SKQ
 kUdBolagj8ruPrb5GkzcfL8u+Bfvw6xQkCrlYSQHyziwcXmB/6Wm2JkGfdgp3JUBNHsb
 0yQS7I//JesAyiJcHEabZS/NPzD3P8NXHCdjjXX2S8lkR3ZJOW+GsqNuRA2maF3zI9r0
 CEnkV6nNbULSNXPxBkMgJ28R4FQScBK5EVhJd8uKo3ZSCZu3+QnnrKzM/AbT70a8BHSx
 fgBdpcDV0pe71ZaKcbQ6UxZCRMhFckfdxE8lg/r2ACJbn9ulJcO69KoWFjnimI5wxzJO Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc51cuuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 13:12:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20JD6Qxi097883;
        Wed, 19 Jan 2022 13:12:32 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3020.oracle.com with ESMTP id 3dkp35uu87-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 13:12:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ex6lp34RUEfFMrtOIDA8KTMveW9/KlwQy85/PsFs5GZTXqek7v/eNYN7diGbxeFFmkDEGHgApOJvGmM1cBerRhErCE2c+vBtbHTQ1DL0IQJyJRzPoUVow1DsTOTCQQxlsfBktypXr2dclZO2ae0tEh0RCuGIftzydQp2Vdg+Ya6wcjHySE7ZSrfjaUda5E0NWAAYnPhyJ0/yrRzBjQ/SiiarwK12tiWKlp6BC0s7IVGsIGLwpGEZ8pZNbobau+AbmyAdvLYaJrh5N/C3yjL3rRl5E++q5lYYs0bN6jUCXPPtHDYg3racEBQ2xJ6XY0ZvTiIoo8VO9btrLqdnW8XrUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWPnl6D5wt4VtlA1pWPXdG2p+idYFuuMFe5mxf1Vj4k=;
 b=HcBpLb1mQEuDUX4ewntUfyIPkhit8qax0LUCoGgy/Gq6JQlfJFEvq6Z74tqECnWsS8MxazRh8Obx3AXo9t0tDGhKcjxQdXfbtLx6+oXTqn9on5HE7sSWcXrsYyQDzLdxno7Swobrs6DbWNmx1ryudqCKwPzSXLYhevrPNy0ZT2FtiVY5TU0KjDYXN+HmnfBMXV/jPUVz/vub8XMOiWxx5U+2udjHR0VkWIUAmIyCh2vrwSM7uhSJS6EBkidGzv1iMS1w4+Hox66bIiWxKVMgqLtdp1H1rGZpXpoF2D5sYOff3Xt00YQBvLqb872F/u69vyp8rOrtY5RXFeV9nqk9LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWPnl6D5wt4VtlA1pWPXdG2p+idYFuuMFe5mxf1Vj4k=;
 b=z7izt45kz0EfsE0p+uMs8RIBXhDBsSeo2YyWje3qUkR7exxLx0s2xPjSz9nYnm+7s18KFwQVVwQhbnH+BHkxCuDoKq5DqwJMLYau8LNiBctNB9pS8sKCb+R8CU1EoOk457Iu8MMUehN0no3PhgcPo0K5xaNIvZpwqxE1Bl4fYhc=
Received: from PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7)
 by BYAPR10MB2775.namprd10.prod.outlook.com (2603:10b6:a03:86::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Wed, 19 Jan
 2022 13:12:30 +0000
Received: from PH0PR10MB5515.namprd10.prod.outlook.com
 ([fe80::edcf:c580:da6f:4a5]) by PH0PR10MB5515.namprd10.prod.outlook.com
 ([fe80::edcf:c580:da6f:4a5%6]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 13:12:30 +0000
From:   Praveen Kannoju <praveen.kannoju@oracle.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Leon Romanovsky <leon@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>
Subject: RE: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Thread-Topic: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Thread-Index: AQHYDHpMX8JHvK1k8kSJh1x30qsksqxo/YyAgAAprgCAAAb9AIAAvOYAgABQL4CAABYHAIAAAX/g
Date:   Wed, 19 Jan 2022 13:12:29 +0000
Message-ID: <PH0PR10MB551565CBAD2FF5CC0D3C69C48C599@PH0PR10MB5515.namprd10.prod.outlook.com>
References: <1642517238-9912-1-git-send-email-praveen.kannoju@oracle.com>
 <53D98F26-FC52-4F3E-9700-ED0312756785@oracle.com>
 <20220118191754.GG8034@ziepe.ca>
 <CEFD48B4-3360-4040-B41A-49B8046D28E8@oracle.com> <Yee2tMJBd4kC8axv@unreal>
 <PH0PR10MB5515E99CA5DF423BDEBB038E8C599@PH0PR10MB5515.namprd10.prod.outlook.com>
 <20220119130450.GJ8034@ziepe.ca>
In-Reply-To: <20220119130450.GJ8034@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 313b27a8-33a0-424e-8351-08d9db4d58e7
x-ms-traffictypediagnostic: BYAPR10MB2775:EE_
x-microsoft-antispam-prvs: <BYAPR10MB2775232EDA96C6A5B3681ED98C599@BYAPR10MB2775.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nAICxsBbLJCVRCPkzfWGZFMYfBZH6KvzyJXWxLeJNLcQXhxKurLDt8XxlaTw1X3Id/TPdZsC4JKO3YoC2DeU4HA+yf1HlzHX6DNrmkznM/323TrAd1x0PR9UAwNAgBvcNvFFJo/GNtvNysySIhiQe94RnmkDokaIuck7pcUGweaD78ZppGmmFoHwUbEk/RC2joELjoJC2pdYjNa3cl4NCKwN54w78v+woce9072omL7tkuHcf/oSdo3rRY1+MJxo4c8iKLjwqeyEtReskS6JYaUCdNvxXtOI+vaeiWGitCEkD8hlBjVkYNvvMU4fNrvy/65G0oRZ2L1gO9b+5pBxgqink37iuLNo8rcMan+ruO3CGS5rQyK4ycyRerlmjnaOwvEnyNF56SUSMHa150Orvjp2lNrTMJKcn0w0reE/qc7Z5doxJubEC04cJUH0oAeo8u+mIa9Dq9HXQcmD3NmGPIJaNuDODlLrlI0fSJV079v9yltDPiWt7vQv+5ARw6oJCFgu3vB0HltLA5/zk4nhNgBBV2vvOJVcqjwn+VV1Ab9GTbX4YzgsCr/GMD6LNVXtIiFpLhPBwRYirQbnRy6WPk38R1S8NXI4n9c+bWjgIrHQ1vcodCRtThLeaeWA7YYVtomUEqonqAuVRZ5q4/0Iccogd9dAKQzu0U540XEyxuk2MFyJ8YSjmKDAElDfDyhCjZ1js0ll3OaX5jezm4CGuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5515.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(5660300002)(66446008)(86362001)(83380400001)(316002)(54906003)(6916009)(53546011)(66946007)(122000001)(38070700005)(38100700002)(66556008)(8936002)(2906002)(71200400001)(9686003)(64756008)(52536014)(4326008)(44832011)(6506007)(66476007)(508600001)(76116006)(186003)(107886003)(7696005)(55016003)(33656002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AoDG3mbs9Z4TEXO/uxMJRAaTUS3cMBzoEJYJ/wkAHi1jmQpPyUREyN3zG+5p?=
 =?us-ascii?Q?dvVsOcI1sl40N8/1uxyLoPUJPkPsW6QdnuJ8LG3CCT9TQDz8VYTJ2f6jQlJ4?=
 =?us-ascii?Q?qJMkqqN3/4bmTDhYaWM2qwPepOYm8Lv33RAxU1/tuF0s87Ar90roELadCdp7?=
 =?us-ascii?Q?/uHjLyIGq0F22NGiRNaxkNxsDJaxY2MHMwlAnol2yqTC1IM10hgxxHBDlHDv?=
 =?us-ascii?Q?3pRKhKX8r03FHIRjGbP5+S8NIx57P8zsiDjkb97ZhAI4RIeUwWQ7WjvL1F9k?=
 =?us-ascii?Q?+An5Klz7hd1AOErAEd0g4KB9AVhcWSh6cf4CZrH714BciycpgHIUSeFm16oK?=
 =?us-ascii?Q?hIooLu2D1G60v63y7HikqKc2Do7Rb+E3ld9WADU+RUBA42BosKHpEH7kZUEk?=
 =?us-ascii?Q?4jtjC3nedpUWpwtjTPb1YvUXrKidTJfUyv83Toyk2ge6qHcAlM173dvDzbFn?=
 =?us-ascii?Q?BwVCJRf6pgr27nScXk168ITLAW9kD89mbmqH3ot4OsulmlE5tfY53eUYjBj/?=
 =?us-ascii?Q?h5lJkgSOuPTP/3ja8C6bbNx1CKD0TsaYpReHFoaKEwj9Ph7XzPL8FoI1Uvhb?=
 =?us-ascii?Q?dnBr/TivUHSNBB6TGCwMxiLn6Y5sEhJnD0RREBkr3H+fo+yVdXredo6NZNXz?=
 =?us-ascii?Q?4ciBPiasj1CdWffJbdIhU9uedwAGv7oStZZujiZICqE/KCNLnnG74JofqvJK?=
 =?us-ascii?Q?L5gzBYzUJyvJJttgetKZRAyia5MY+92fBR/muEsdlRe1uN4QdpNCyl7Yj4iW?=
 =?us-ascii?Q?OxzJTAtV+YMVylcuA0kfeUqL4OUmGyCLPVuk78+PMO3mACqIOtQZzqJsFP5o?=
 =?us-ascii?Q?gdeU3nxFFl0ermEUMW7m7zq/2IucGCGGwDMxH/1TWwAmhKjQQbbLHG4+DQb3?=
 =?us-ascii?Q?UuvspE2jgwLVoR6OGMP4jc0nBD/w4sYaQgJLPl99hgfvidBbdWQt3v4VDpLJ?=
 =?us-ascii?Q?KNeDo8frN2rrJjMJiEG/wXWbGfbFGPlLHUYK+60kVS2RoTI50zZy08r/5mGs?=
 =?us-ascii?Q?rMfhO19BHJB/F/jEnVHud73dEvlrsQuEZZvZuvQgrDReH8AAtWbKK7juNnuP?=
 =?us-ascii?Q?YgKsOyG4279V3Sq6Dm7s2GKtgxzYra8YXFUt3LF/5abrpqP8alTpXeSAPi3C?=
 =?us-ascii?Q?OpP6s6HJwutxv4P60SgmGTt3WvO1HaA9YYpMWm69QIUq3W6lXC6fYyk7pLO6?=
 =?us-ascii?Q?2gr+49ViWyyHgQPUuPK9576OiXMjWvTeUYHFpR3PicnQ+uqTStgCXZC6uofR?=
 =?us-ascii?Q?5fGYgeRFl7cc0hL7DzfO2N/Y8UszZQtPXoTDlMbz81JUEDzWHlxBTev9xo+S?=
 =?us-ascii?Q?E3zEdc/d6bMzzsQVdo6u8r+PkXIjtt3/efg57pAddgcaqiyTRFyaA6p+FZXZ?=
 =?us-ascii?Q?zv1MAjbQv+wY8Pwhljsd4BHWa+9TiOtT2yoAQWte92AQqP7iB45+j50/qTCy?=
 =?us-ascii?Q?PMfyTi62NkAoxA7ttjYCgjNfR0LFnQRWAT/5qWKF8Nj/BII0UuskIn3Tqzdi?=
 =?us-ascii?Q?xwUGSLRZ+LFj1rES221PIbv9gltwmSWYb2hSpMmKp5pqJRmaMOKdOlXZO6zc?=
 =?us-ascii?Q?ENNTBXnlR/j23eemWC3dmNb2C58PXG8K43boPPfPxqVbjcpchv+iWHgzuJ/D?=
 =?us-ascii?Q?9m3vK0il0A5iVytKMjosCWXmDKDy6sv0caWhkkNqJJuA/5ngboBo+lK3nUL1?=
 =?us-ascii?Q?OmlzXA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5515.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 313b27a8-33a0-424e-8351-08d9db4d58e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 13:12:29.9230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aFKrt00wGBVhiHulGm1OcaRTElCA8aVnOhY79sFtCXIW5Jm4hSmRV9OA0gYt1tPpkTaEpJ/KIx/Vl6fuCAyMJaR3/V41xI4ro2khyS8NOhI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2775
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190076
X-Proofpoint-GUID: XOh0Gxm_PvqUG19x87V1uI1iHhNGiFOj
X-Proofpoint-ORIG-GUID: XOh0Gxm_PvqUG19x87V1uI1iHhNGiFOj
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



-----Original Message-----
From: Jason Gunthorpe [mailto:jgg@ziepe.ca]=20
Sent: 19 January 2022 06:35 PM
To: Praveen Kannoju <praveen.kannoju@oracle.com>
Cc: Leon Romanovsky <leon@kernel.org>; Santosh Shilimkar <santosh.shilimkar=
@oracle.com>; David S . Miller <davem@davemloft.net>; kuba@kernel.org; netd=
ev@vger.kernel.org; linux-rdma@vger.kernel.org; rds-devel@oss.oracle.com; l=
inux-kernel@vger.kernel.org; Rama Nichanamatlu <rama.nichanamatlu@oracle.co=
m>; Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [PATCH RFC] rds: ib: Reduce the contention caused by the async=
hronous workers to flush the mr pool

On Wed, Jan 19, 2022 at 11:46:16AM +0000, Praveen Kannoju wrote:
=20
> 6. Jason, the only function "rds_ib_free_mr" which accesses the=20
> introduced bool variable "flush_ongoing" to spawn a flush worker does=20
> not crucially impact the availability of MR's, because the flush=20
> happens from allocation path as well when necessary.  Hence the=20
> Load-store ordering is not essentially needed here, because of which=20
> we chose smp_rmb() and smp_wmb() over smp_load_acquire() and=20
> smp_store_release().

That seems like a confusing statement, you added barriers which do the same=
 things as acquire/release then say you didn't need acquire release?

I think this is using barriers wrong.

Jason

Jason,=20

Yes, we are using the barriers. I was justifying the usage of smp_rmb() and=
 smp_wmb() over smp_load_acquire() and smp_store_release() in the patch.=20

