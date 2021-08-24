Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7FF3F5F8A
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbhHXNw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:52:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21204 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237667AbhHXNwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 09:52:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O7c7kr001613;
        Tue, 24 Aug 2021 06:51:46 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by mx0b-0016f401.pphosted.com with ESMTP id 3amkrkaym1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 06:51:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTZ9mW4HHzCzXONiLA/akogyGeGNEP2e8RvITWE2o8ErUxtFNn8okYPKI8Qn4jdRTACV/soCiAZNUk81zjIgRDdLFiA6lF5l23j16HCQP9lOMOOJuCUhkobfTLVpUw+Lgvc0+fshvTQG6W2qdWHMvm/VVZTm2VMIt4vkvgnYjXR31cgmwomPC1umsdOhot007tqLRmhP7FTD3mFVgL4mnF3qIzElIDGtmB6Pwj7nO/uxMNhLTTMTJTcfWrH3cJAdIHHgdUV1bFe2CTxzWORA6JbxEX+kqYaN4xRISo3dVghewriaT0r/cAdamPZmxohenU5iafSZYV5V058simfsWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7Q/8UGudqLi8wcwPle43t+wM7F6ZcDGUqZV6Wh/DQM=;
 b=TB5y/reqXD+V6Bcw8hTQTrXsBByjtayUV7wywozhTQeEiqhqrmqeaq2yQ8+Yjs9ukNY4a3DWXI0u1Gx3zDHbqYy0VAL1CALIn7MF78EQ6xy2XYyI6hjJTs2UWQD5893+DbUlCNwfjYg+bPhxrxJXTAjNQK71aKultLE+7vxirBWNZF0ItQ5X2nBVml01el66BWTjjnu6hxPbqCNsFvFHRLOZbgARGnkodyr9WOwOy/80InNXfzAlZj3rYaA/4xrmIFOMA1rpaNKe6+XAXfquS6HpxX7t1vOo8O1+81rV8vjadNtL9iqBtIedUVBB5wWhPGUQP/WiZDf1Zr/QKBJozQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7Q/8UGudqLi8wcwPle43t+wM7F6ZcDGUqZV6Wh/DQM=;
 b=CHtBS7WCUilc9iwor4XjRsrnL3RjZXhIsCO5FHsvjHUrgOVGNpfAMwdrJW9+NS+qYZjDU45D+67hP9vm3EyQNu2m2yKs7fuDPB4eOrWnRbPp7EB1DsvX/x07wX1BKivUUwDwy47f4dduEnRToszoem+B/aLB2IzUebCAdjGw/14=
Received: from DM5PR18MB2229.namprd18.prod.outlook.com (2603:10b6:4:b9::24) by
 DM4PR18MB4173.namprd18.prod.outlook.com (2603:10b6:5:390::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.21; Tue, 24 Aug 2021 13:51:45 +0000
Received: from DM5PR18MB2229.namprd18.prod.outlook.com
 ([fe80::a9c9:dccf:5e59:fdec]) by DM5PR18MB2229.namprd18.prod.outlook.com
 ([fe80::a9c9:dccf:5e59:fdec%2]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 13:51:44 +0000
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Shai Malin <smalin@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH v2 17/63] bnx2x: Use struct_group() for memcpy() region
Thread-Topic: [PATCH v2 17/63] bnx2x: Use struct_group() for memcpy() region
Thread-Index: AdeY7yGdR9cZvhLdSru1pL8aUI2KKQ==
Date:   Tue, 24 Aug 2021 13:51:44 +0000
Message-ID: <DM5PR18MB2229B0413C372CC6E49D59A3B2C59@DM5PR18MB2229.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cff11d0b-a9d6-4ef8-79a0-08d967064f71
x-ms-traffictypediagnostic: DM4PR18MB4173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM4PR18MB4173859078969B3FB6DD878CB2C59@DM4PR18MB4173.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A48KM2JlMSMYgGArSHWjjJVD6xTijC+sMFJ/pdep2lhNAEFu8S31wBryajCFXqph1dRnIb99zR/ENyy8ItUiE0CFHDOe959R0Rz3AYK2RO0nD9QRVEjed97DVP6Em8VexOUJ4gp4n3srtbnjkZza4sTa1gVn9rtKWI+UzbZcnLIRubvaM7u8Uehs0owExl52VjGqitNFeGD6eHxfvxpGfuz3NESmJUoDntwzWPZ8NJqeSgGOxc09aPp4o80qA1HbHnpo+tgGh+YoCLlj2m/s2qsOwtT5UmCdrm4woUOmmWXU1vArd1mz7o4CGRypHhaGUXeZfB9nT3vvda//LMjg1Cc/cKLV0AaJvTDSUFdopdbazasd+Z1UDk6sK3U7AwHZm2hVb04LwnAFyz/5voGihLiW30RVWFr4n2MHdLZU/I6NQJCMZCW/XrTEQWh8/R1NWWYbrnqV2lYvMnu9G5vNm98DmH3IaBYmLuK4YT4xvB9UoAEGLe9zstngepVwURFphINW425nh2ScKQJqC+pL7PinCB7OZso3V3kq8+wpfyMgYL8iS62bXyuVn41s3n1sX06Vi5UVNm5maXbj+zFocVTY7AZlpHxb0AypIqD6+8WF5Q8dOCo8NBL4yCUJdz7d5M2wF769p7RyEsrXwKoPsD4jdtaGOacajg4oDMEXePRAstuX4LdF4vCEAx0CX7Fo0eYeX6jT8+cmc40mFJHTEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR18MB2229.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(6506007)(83380400001)(26005)(76116006)(66946007)(53546011)(122000001)(9686003)(64756008)(55016002)(86362001)(66446008)(38100700002)(66556008)(66476007)(54906003)(33656002)(4326008)(71200400001)(316002)(186003)(8676002)(8936002)(7416002)(478600001)(38070700005)(5660300002)(7696005)(52536014)(2906002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EMDIb0DJI8NV0xiWg7/D5hHaDWHCeDakcGy/278+cHfPg4FEvj1RULd+LY1V?=
 =?us-ascii?Q?mvT/JOTAOIJvK6HqD/vlPwz+dhLIzBFNiWXADKZlC/INcG+INVr7/vM1Wsiw?=
 =?us-ascii?Q?O23P9w2+qJxzteL3TrWDr95dnVkZBnSkBQLym6qkwt1JY+0lWtnAFq2wTa0N?=
 =?us-ascii?Q?xFfZH0vtOex/q0v/noaqvI4vL0A1jlqYpimb2pM1qqH4anPQDVTZkIXDDpGU?=
 =?us-ascii?Q?56gQF0Pjo8Lq6+DP4lSVaBnAPmVxwVE02YgkINn3bxTa98Vf5tXQHEZdi8H7?=
 =?us-ascii?Q?KWbmHRRRalXBU4cDvvMZyi6gXGO4a+eD+j8ZKMG59FQBW3n0cBdIHfPUlMRh?=
 =?us-ascii?Q?TsTltdQogzI7BvGQzUX0BzWdkb49YwF2QST7+Ol/0Rv4UeveJr4H3NzvzjuP?=
 =?us-ascii?Q?1UxL05n3SrnHK7RnGcDJbJOGGt4awXNsnPbUvIyjh7ni09Zv61zeyYiHq5g+?=
 =?us-ascii?Q?8/x3wOrpleWlXp66e9gy+/2/c9gxNfLbSMOI6XwCpaCKaVnJN+hQmjCQ8AIq?=
 =?us-ascii?Q?8MoRFl4j+jt1n8ca0MkPO3rJMELlxlR4kgm8dWRCkiDT0QArszs6hsaDdZY1?=
 =?us-ascii?Q?z7NX9aFdbS5WnOXtEkZdueyNj2Ovho3QfAzofKT2Zrl5fzAgOXWKiRxYkq6u?=
 =?us-ascii?Q?PDevoZ2dRFa5jgfhLVLmbO+/eJEuVkUJQFtXOm3abUrTr/w4oTIIHySIM04v?=
 =?us-ascii?Q?JCMUDkiEB4M0JTh9XIxMDubek566tSQIcg6SLNHJTZ1XXywNOC8zy9zeI04h?=
 =?us-ascii?Q?bgz6LpJmmNUlxR1SdFT4anRbfI1P2gXbZVUkdTMgbO3kS/m/6eOSr/jdVtHU?=
 =?us-ascii?Q?7eo7cIFVLCy5PwzpaGKPhfv/0qUBvIG9b1aZ9LRDKOzP57pHIKc/WZra0VGM?=
 =?us-ascii?Q?fbaAw6nQcRfnvmepUxBGFVSpMtJLT+vsFkxvPPYM8qTfQvb4MjM3UWcpYVUh?=
 =?us-ascii?Q?oaYJuFhu7QLpeRhMkiZGFdKArTEMbKOSBPe8jQLHnP9NNrwx/6Sq1ZpOH3de?=
 =?us-ascii?Q?kKnuukJ21vXn9ZkhGxDfLXYELdemQEcsuZITqvgAh9GKf1uXwEoqO5NRrjBN?=
 =?us-ascii?Q?QESh8lLi/IbI4rQln+J+S5sPzRJtd2FPe5u5ylMs+UledCu6GIGg6nonOzrs?=
 =?us-ascii?Q?CNZsrucVDyhaH+ST31Gn1cS7U/83K8usv3bBSmEVznXXUkEV6rpwXIi5j+2Q?=
 =?us-ascii?Q?vw/DNoIaqzsSRXNe3TpdweF4AUaSFOmq0YFaUheWZRWTeGQ4XS3+3WOwPfOV?=
 =?us-ascii?Q?PaZC9Jb4CpTONNpbwkASp2EVSAA5PqVwP6RTa7iy9311VQ6zpcw9HPEszm8h?=
 =?us-ascii?Q?wB0aQqxTrFzOGhs1b8PziTyd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR18MB2229.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cff11d0b-a9d6-4ef8-79a0-08d967064f71
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2021 13:51:44.7798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S07K5TsDOEM1fYOyl4L5sHc6IFKNL8HtJzGfPubKFD6+2Z+PKq+bOkDAl63rre8IrpHApOzgGQ5mrJm/p90OxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR18MB4173
X-Proofpoint-GUID: lLSeim5oVrTVDfdXvJxQPHeUBF8phhVS
X-Proofpoint-ORIG-GUID: lLSeim5oVrTVDfdXvJxQPHeUBF8phhVS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-24_04,2021-08-24_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Kees Cook <keescook@chromium.org>
> Sent: Wednesday, August 18, 2021 11:35 AM
> To: linux-kernel@vger.kernel.org
> Cc: Kees Cook <keescook@chromium.org>; Ariel Elior <aelior@marvell.com>;
> Sudarsana Reddy Kalluru <skalluru@marvell.com>; GR-everest-linux-l2 <GR-
> everest-linux-l2@marvell.com>; David S. Miller <davem@davemloft.net>; Jak=
ub
> Kicinski <kuba@kernel.org>; netdev@vger.kernel.org; Gustavo A. R. Silva
> <gustavoars@kernel.org>; Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> Andrew Morton <akpm@linux-foundation.org>; linux-wireless@vger.kernel.org=
;
> dri-devel@lists.freedesktop.org; linux-staging@lists.linux.dev; linux-
> block@vger.kernel.org; linux-kbuild@vger.kernel.org; clang-built-
> linux@googlegroups.com; Rasmus Villemoes <linux@rasmusvillemoes.dk>;
> linux-hardening@vger.kernel.org
> Subject: [PATCH v2 17/63] bnx2x: Use struct_group() for memcpy() region
>=20
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
>=20
> Use struct_group() in struct nig_stats around members egress_mac_pkt0_lo,
> egress_mac_pkt0_hi, egress_mac_pkt1_lo, and egress_mac_pkt1_hi (and the
> respective members in struct bnx2x_eth_stats), so they can be referenced
> together. This will allow memcpy() and sizeof() to more easily reason
> about sizes, improve readability, and avoid future warnings about writing
> beyond the end of struct bnx2x_eth_stats's rx_stat_ifhcinbadoctets_hi.
>=20
> "pahole" shows no size nor member offset changes to either struct.
> "objdump -d" shows no meaningful object code changes (i.e. only source
> line number induced differences and optimizations).
>=20
> Additionally adds BUILD_BUG_ON() to compare the separate struct group
> sizes.
>=20
> Cc: Ariel Elior <aelior@marvell.com>
> Cc: Sudarsana Kalluru <skalluru@marvell.com>
> Cc: GR-everest-linux-l2@marvell.com
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Reviewed-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
