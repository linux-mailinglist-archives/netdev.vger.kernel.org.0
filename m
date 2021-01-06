Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9E32EC26A
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbhAFRhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:37:15 -0500
Received: from mail-bn7nam10on2131.outbound.protection.outlook.com ([40.107.92.131]:52992
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727106AbhAFRhO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 12:37:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjojMK29B6zqOn6WkgsYwdpAwzHCa+QtXf6CDshSEEmtsSLbrbuefHK51ffxIvIkNDf1OCtHydkP0GbhLWhmvMON12O4dze+DxIJzzV7uBck77YkD87sSie1RTxqwuo1MEDjBjrtneWnbZxJCUCwYVncS/yBb8TwWMGCni9uCXqZun/PX3mDLdNZLJ/qAr+hQV72nSrA6T38tl2NnafUci55oLy7Sakg1LlJqJkesbgRzN8F+lTBzCxNiklZfVpJXG193WcQGelvTIAkrpSAjECmJ6zAOgxgoF6KKDlKwbo481u/rdhGCF3WWfvGcZj6kOM/U5dlHRvkf40G1dqPaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ZDoMmkBqyUROzjFUjhCbFPJfdEv8DpbxcGDYw6cbpc=;
 b=VuRe5UtPvVV9HtepOWFFaH7NiuIxVufbXftPkLvnVz6AH0eH54IK0tGFjWrWy8HxCEA7gavqwJTAi1EFJn4MVRSH99cbpWoL9G7tE6ciIfWB2JLHeJMPNwhlEIQsM303wWwK7YmWxXON+kz7lih8zi4e1arWzQWF8rv29w4iXsuRUJWLKECFVA0Q9pWxITAwnXQiSgE+Hgp4xA50qaD8V6CwGvI3CTuvXk9P90iiHmVYiepbuPoV/j3mF43Sdzk8qDbCAV6jHUCtSVLPr7khYLg0Hz5w3I1gJtPz8KJn8SGd/TIKmTrVGkHSIRUxKTPWBtH+EvHSCegYj/vgM7VHXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ZDoMmkBqyUROzjFUjhCbFPJfdEv8DpbxcGDYw6cbpc=;
 b=MCPafpwVmucO1LLv8s7dUVRZpYtYbKhVJHNad9lQ30jd7eYjY491pOYNpAu6PBZocciS56Cg3opyoO0ONLIU8jSMJ6LLf7xCzEGGGMnssUQlo0H7fdPrxbQ5RWY1Am1z8OTU7iC4Gfj/59RbFe4C/YzyxBMbN1beE5FEJkBUNgc=
Received: from (2603:10b6:207:30::18) by
 BL0PR2101MB1332.namprd21.prod.outlook.com (2603:10b6:208:92::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.0; Wed, 6 Jan
 2021 17:36:30 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::246e:cb1c:4d14:d0eb]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::246e:cb1c:4d14:d0eb%7]) with mapi id 15.20.3763.002; Wed, 6 Jan 2021
 17:36:30 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Long Li <longli@linuxonhyperv.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Long Li <longli@microsoft.com>
Subject: RE: [PATCH 2/3] hv_netvsc: Wait for completion on request
 NVSP_MSG4_TYPE_SWITCH_DATA_PATH
Thread-Topic: [PATCH 2/3] hv_netvsc: Wait for completion on request
 NVSP_MSG4_TYPE_SWITCH_DATA_PATH
Thread-Index: AQHW48mSSnW4wihJ/kWHbl8K1k7Tw6oa3U9w
Date:   Wed, 6 Jan 2021 17:36:30 +0000
Message-ID: <BL0PR2101MB0930286A44DEE1B7ACA6DCD1CAD09@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <1609895753-30445-1-git-send-email-longli@linuxonhyperv.com>
 <1609895753-30445-2-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1609895753-30445-2-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f53b424b-ae52-4f3d-8ff4-630141c52575;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-01-06T17:36:19Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: linuxonhyperv.com; dkim=none (message not signed)
 header.d=none;linuxonhyperv.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d2f88e5f-105b-41df-d239-08d8b2699a7f
x-ms-traffictypediagnostic: BL0PR2101MB1332:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB13323C18CA690E80BE8E7BD8CAD09@BL0PR2101MB1332.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KlUQbA3LfASb2FY5BPHhspRCjgdv/YvUgDFEKkjjKr7vB3+E8v4h4EuR0pPt6DFV8eorQnqfJoOycZ1nhMxGtYkVWdPLgCZKupGLRbgGVTz/qYPXElPGeEmBG1dqvu/CarOG2QdXTQ0eKsPHP2k8OkM1vSzc+RfRHpsNox2T5m+YylGYt8jRUXNHEPWahCSw4VyDJvPw82ukOBeiIIgO0f4glJFL4SrpSTvHko0gbW1uqcGn2CocItxt/pX0nqy8zvTLPimsYkFiRBzoXds7zh1ghWi4QQNViLXWbNmByW7JJ2ykyLoF7tuP77d6ZfNdYgEokw0cBDSPDr3riFXCZEKwackSawGojukRwpwaGDzp2VmS9y/2sC/TDUDu+s3q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(53546011)(66476007)(66446008)(64756008)(33656002)(6506007)(76116006)(66556008)(83380400001)(8936002)(8676002)(26005)(82960400001)(186003)(4744005)(71200400001)(66946007)(82950400001)(110136005)(316002)(4326008)(10290500003)(478600001)(52536014)(7696005)(2906002)(107886003)(9686003)(8990500004)(5660300002)(55016002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0eEUYh4tw7OmSjqJ9mgkiFC/2/Mcjv+k1e+ys2mB8STBbh9poZm9ct0D1jKX?=
 =?us-ascii?Q?DU/J2C5VU0NgnTUL4BuaG9TqXOfIqIW1PtfFiANQ4OEarwSZ4mw1FJe0Ex7a?=
 =?us-ascii?Q?39daA/B5xFCGgljFhx1uSuaLabMdTKffSIdi/000gqXjZjfirEp/o9UDBtCO?=
 =?us-ascii?Q?6fB/SXQp5pDwc6wS0kp95gAqESZWS9u3IPYlSKdGVnnqDQCuK9gaRNqgZoZV?=
 =?us-ascii?Q?iEVXOCbIRFwKET+0LfQhAO52Si3iHqVzwpqbwahWUgkKOd84VfuLRdV0gjdK?=
 =?us-ascii?Q?bYKnkePtoqFZoRY4nh94zwxBzTj/A4bPJLAP+U9IcGlASYjWggMR3Kt7P+c3?=
 =?us-ascii?Q?mlxA3W1wsJZvnqu57hcTuaQcirBtlDDOhs+bqH+f0+QIsCRIRNjsDd5Eo92W?=
 =?us-ascii?Q?Pt9GnUE3OZI243UIvSERK4llpfFTu5wtLN9CkpsSOmc6PyttL2R2fkea4M0a?=
 =?us-ascii?Q?V00a/ud/rw1PNs1fZUEiRAojDGbG5ACEgXco3Na9ewVEk79mxoXVtViVc03W?=
 =?us-ascii?Q?kYrWDISoLkJt1Xls0v7mRQ0qGqExX7aSfKy8AEUqPNG0BXd6R0yWE9YXuZOQ?=
 =?us-ascii?Q?fSJYoOzukDdDC58IWmait/v2dcB8l6H2A9Ow77Fbedj7oZkUO6LPXg3X634A?=
 =?us-ascii?Q?fEUr+Tc+m1hAHnKQaTaEWQKsr7+fjn0gyxyo4i2pO1vUOWjEs5KRH+tR3UCF?=
 =?us-ascii?Q?aS5FULkdLu6RGc/OoqErtcmpnuTdBgm69zAnh/+4VmPbzdFxdxGgJQ8O8eO3?=
 =?us-ascii?Q?RbDyOjWqxu2G3DDGX8cfPZMICnXNdr26xneUss2POa3aIr/tcBIep67AMpZI?=
 =?us-ascii?Q?6ZvaNuxdqJAX4xcQZFjVknt4H9y6ljLxByh2jSsz38jpjXdoXpcmFrZHcgcn?=
 =?us-ascii?Q?gElJsXK2C4FL9otlPjGYuKq6UCZrzztPZTP6LwjEFDU9ZhY/uaY+1DiQD35L?=
 =?us-ascii?Q?sTeKOnLMc5L3tsnh1iPNu57Y69vsujFyD6NO+S5UcYA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2f88e5f-105b-41df-d239-08d8b2699a7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2021 17:36:30.5673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FUz99difUxuI7dk/IFuIoD3SgcvJwOZhZ6BOXgFJftofFr9N6/mtIVRpFcdlbIBMgrTLZQnSDcQblcAbX5g8bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1332
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Long Li <longli@linuxonhyperv.com>
> Sent: Tuesday, January 5, 2021 8:16 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Long Li <longli@microsoft.com>
> Subject: [PATCH 2/3] hv_netvsc: Wait for completion on request
> NVSP_MSG4_TYPE_SWITCH_DATA_PATH
>=20
> From: Long Li <longli@microsoft.com>
>=20
> The completion indicates if NVSP_MSG4_TYPE_SWITCH_DATA_PATH has
> been
> processed by the VSP. The traffic is steered to VF or synthetic after we
> receive this completion.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
