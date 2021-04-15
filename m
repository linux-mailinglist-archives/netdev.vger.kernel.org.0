Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722D9361419
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbhDOV1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:27:36 -0400
Received: from mail-mw2nam12on2124.outbound.protection.outlook.com ([40.107.244.124]:24928
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235046AbhDOV1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 17:27:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8qbNTmiSKD1V5lsvcuLQLSvA+YnGPy1b0FtNDbtTHpOYi72dq/LWT3cP3pvFk91clWO6w2r1Npi9c7Z4/z89uJtUwQygThpnhtnpMygXyjLwUGFVmNVhpEiVDfz6j1u/QQlre/mE4jQ7yLbiVGRMU5hj0a0QpUNFZRZOfkGBbGAEC/HykbzlDNzHKPEPS36mNmOV9VeV/Amw7pWxDnENbXGSa441ns5YijHsEKqfcsVRGSpAq8HWWDcU1pPk+LwtM9Xbg9htfvaWtXcbo7HBndKzyCUcB9/Odi9Td/qzTru/MmEkxEg/YSWX9iYUEG8Dkff7EnlfrtUjiD1KiFfzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=votrX3xhiz4JRL7KOZ9+EO1z2qOUonD7vYrmCdfeYWU=;
 b=k9JS/SMa5IMklFoYTMOrwsFg93zFbIXqfbxRSv74S41wfK7M4pSogfupx03nYDNLkuC4i6FXrO6A0rP0QxSNP/U7ffqMBu6ISxa04iMmj2BmiXLGgC0MO0MoQUDFzjyTtR5APgvqW23mlJWjsnLfYMMurBjEwETohTrL8HYaY62M1F0DV139kRjTXaGF7KTgOYzQiLyn+WXWtilcLhs2d+dPrci9z0Pf6zlbsX/NpKozR+BlJFnOjMdsIAE7+oC7o3LrujR/WnpUAsS6dwGyEsdoAtOmge1aujJcG/4nEBEJNu8rhsFxcW0buIaQhjHj6xtHZTYaoPXz5KBkILCFvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=votrX3xhiz4JRL7KOZ9+EO1z2qOUonD7vYrmCdfeYWU=;
 b=bGj9hb6hkWOfcwpCSJIOOVjX7gZheE5b+bezwFgTv3+LtopHdJEcCgWN0ytqyydEucrQm+SpBao7kvHncg7+Om8szCzNUk9r9LtqXXN1m7AlffDQ4hRQi0/UgFfmFvIXrgdUCieZcl0k3gMjwcIE1w83EXw8uj9cvjR4FLmlTH8=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MW4PR21MB1889.namprd21.prod.outlook.com
 (2603:10b6:303:77::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.2; Thu, 15 Apr
 2021 21:27:09 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4065.008; Thu, 15 Apr 2021
 21:27:09 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v6 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v6 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXMjxzqz+n6heTS0m4o7oyoLHpzqq2F4qw
Date:   Thu, 15 Apr 2021 21:27:09 +0000
Message-ID: <MW2PR2101MB08926821645915D96881CFD8BF4D9@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210415054519.12944-1-decui@microsoft.com>
 <20210415141525.69c12844@hermes.local>
In-Reply-To: <20210415141525.69c12844@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6de89b35-af8f-4c11-8fb0-031f34e5bf42;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-15T21:26:32Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:d56c:64b4:268d:aceb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f51ba2b-e2ed-493e-bdfc-08d900553a34
x-ms-traffictypediagnostic: MW4PR21MB1889:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB18892D32703C94A02AB7654EBF4D9@MW4PR21MB1889.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5RbtenDb+1PCioShRglLZLBB1jIQdDhkwX0IZpwvMIHVeCtagjPZJRe3Dza6SOUMny1z0+0DrYG/32RofFPEAktyUPlXq4rvdozFqRnZzh/pcoemDkQMMBIUJz72YUXbPJ8fWgu6YbY0y+MHjDsMv+/6FPs3zW8irIyPxynPS6lu2EqZg1te57z2CpUg/t9W9NwWQgDmJ/irluEp1cK1RiT8dFOy96rkvBVNvVaFkEh92EqqGAt5cxgMcj3yhzdVu18GFU3KlfdQMxFSqTaTO0c6kQeJz11jawuEbV232wXhYBgzHIuOuLNBOlH1QReoDzWnnCirqjYoVw5hQhV5DgiJMcADfPscphHpaW+dx3OBCZb7/nB3ZJjI0phhUCiEakEU/lA+53VPqJTzYKy8xx7yczCEYGaoKnLQ0Dzhb9VevsEPJlejEw4DEvdIc5KK2TKilk3qjDmgmeEWwaehF9PtU9iwi4umH3O+MGXW6DgTN23OgbrmFvWveTfz3EK8VFjloYWh7jSKiaISBdsPQUBCJ6rdXsZtp/hrywk+5YwzEBPxwwJBcdRIBxTNiLA0h0GJwhGZZyfLsPEgPCjAgRKiJ8ijjeuBGxWSTrAeyXk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(47530400004)(76116006)(66946007)(33656002)(7696005)(82960400001)(8676002)(82950400001)(8936002)(54906003)(122000001)(7416002)(66556008)(316002)(66446008)(38100700002)(86362001)(66476007)(64756008)(478600001)(8990500004)(10290500003)(9686003)(4326008)(558084003)(52536014)(2906002)(186003)(6506007)(5660300002)(71200400001)(6916009)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9KNp3XyBgjCLDUYAo1cdpTaw8myJ7tWZ/ylQdADy7IiPwz9lPF5kWRPgE6OU?=
 =?us-ascii?Q?fKRJ1BlpGkoBsVV4wArWmK44oFkVySfBIulZBC7GfymTqnRuN3jaUKdRPuNM?=
 =?us-ascii?Q?eWbf2qe7XGmZDob/eKtRuL6/7blTMjp1vPB86M1+xdS80/nWP4T9CzMxlQqP?=
 =?us-ascii?Q?Jpv0sGpeEsvorxWFQyx1nKJsEmTtIHpf963U4RDfHlCqaHgkPvcaYVtyk/fi?=
 =?us-ascii?Q?ESEczB0nPE81Ua4qpUQs9qUQrHoxaIuCCU41ZbHdi9RoFIf00vA6Z6guluZ8?=
 =?us-ascii?Q?4MIS8XyvMrCItNpSkVbqRwcKav5JHxo7xtWCloWSbw/UFIL7PbEZwg3ieaY/?=
 =?us-ascii?Q?VZleMRJwoKvEaw1WrCC3Z1yJNZN/VORrt28zoLBnS7Fh6MD1GliyfcoMlUdj?=
 =?us-ascii?Q?lP3k1P8Cg8WMr/FD+4PmJWKgwuz4WGq8fR6/4u8YpKS/k7OJtZZYJJ10EHtb?=
 =?us-ascii?Q?/jlfK3DDPTsrzLLL1AkdUZpKdK0pp2eW6EWunMMRC1Kpsorc/F/zk0AR7qiP?=
 =?us-ascii?Q?kVe8dwFX3Z/D0DNHzTaYm2cgnQVjCdYJI6RuOx962rOOsVPPAp/+dMpYdxaa?=
 =?us-ascii?Q?sIPb6+sWq9SyDPkSv6XXYVadQmO/FdFKxpXWpc5k7R8JSDVv59E8on8KQpET?=
 =?us-ascii?Q?tU4EWCWYEy8UIs/0MundiVKsBml2DQKTFLTDNMZ3isR000bKcQgHLaiy/yL1?=
 =?us-ascii?Q?R1VCZObsnxIA/JqdKyXkLclbLD/30LlXMm+x2AWgjbP6zTiONZdCZIT4F0F8?=
 =?us-ascii?Q?2ROmhjL9R0jaPxqQJ9ZaNgXdxliPmONzXpn6tQft1e5RenNeb4/BZwYid/SA?=
 =?us-ascii?Q?Jk9FsxqFluSKHDG8zDYvE+Fu+mEG8A5EffsAnvU+1kZgTQDz4b1F3NXRjHB5?=
 =?us-ascii?Q?5zIAK1PNoYsA9Q1BHbGLfa+TBu9qBfYKAM1oqR1WBxL6am0+Ipx2Mh3zXSh1?=
 =?us-ascii?Q?vp4F8MlaOqxNBFbE1ghuUb7mxzeB4lNlcTniGWrwVcn2LuOvBLN9UHWD4trP?=
 =?us-ascii?Q?8PqebLEzgvFLR1S4HGpGHPZRbvAtko1ghnP0UXnpSVCmYEWWPp/yv0oLsA+q?=
 =?us-ascii?Q?tUGDfWmO6N81ljQaW+O3ZAWT5s8AXkD68/kK1DaKYlpq6ZI/XjMmZ8MwItYM?=
 =?us-ascii?Q?TN0wWoWmM0FyIs/OHtHLg4o2ZvlEaqenUaFgnWKYT28rbBLs2l6e3OfNOdHI?=
 =?us-ascii?Q?Wi/5HLRAhx6pLZS8yZbI3851cEtG+EFo8036zuBHM6RCVCknXPUrOc6NwPDQ?=
 =?us-ascii?Q?F6RWRP+Qh61af1rmu5eR4rhcyw1wsRMNE/qxqPHVWnp//g2wlqsqPhvQkFvq?=
 =?us-ascii?Q?Vcpjo2ZEn60aUwxyqTy1Tw8+RUeM5tBpZaHT/lRY2yXvY63X2Q9TVt3VQSq1?=
 =?us-ascii?Q?W/AOS0+xEikuDf4umpzhSMFt4zwh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f51ba2b-e2ed-493e-bdfc-08d900553a34
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 21:27:09.4133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ILp7isnAtfC8sALuFsI78HBDWcip0GnMpaTmD1kEphMYeGl7mIvxS1g0t8B3OYbR7CFcMMPFraUckQ4ykjcIGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1889
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Thursday, April 15, 2021 2:15 PM
> > ...
> > +	netif_carrier_off(ndev);
> > +
> > +	get_random_bytes(apc->hashkey, MANA_HASH_KEY_SIZE);
>=20
> Current practice for network drivers is to use netdev_rss_key_fill() for =
this.

Will change to netdev_rss_key_fill(). Thanks!
