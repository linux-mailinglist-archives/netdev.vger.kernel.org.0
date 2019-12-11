Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BA911BFBE
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfLKWX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:23:59 -0500
Received: from mail-eopbgr770113.outbound.protection.outlook.com ([40.107.77.113]:28576
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726141AbfLKWX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 17:23:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PuxpnYMftGIXZCTxcf+g3KfRBBCJQ8ltloLcOHERpNNmVr1otCg+N0GjoKHxwUH/hGcv+q88Of8tv2UQmPuRvSb/cDz8JiBLwE6AbWY8wnLG28/O7YwlJ2fEevyFY/A0LLXEpzaDdvrAo3g0j8MxV5c42AJKxgKxeL30NZhIxRKQfKAQb3yHUHgpaI/Tu7+i1Eg84byhJlMgzP8neYjQzoYoDNWWi2JU2GjrUmltfthAVUlML7agk+xJYYWqdA3oZkl6S1ahgjpb9hhWiwEh7hcH9zKWY8ngjVrLSWO2Xs6N/PeHbl0/WLeuJxaLt6G/1aVQnfd7fca2SP3rW/5m6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8N+ccXfJ5agdfyT14DlWIR7J5vil8M9tgq4X0zQjkY=;
 b=beTui4K6mASZXF1N35B41zkxKahLjZCxmoZd2mx3ESv0PA1abRbPTSACRm+P6/hLjBHvFr88j1PGjyoqUnA5P+VJRqt9MPA4q+zQ/hsuCEd5aTFUhV4Uhpoc153pt7IPbFjaGyIOtIDjTRZafPh0ubJkTWcZRP1iQYf+OseABS9akCa9lpp+bzw8BkOzRd+6NVtxSKv52c7wYww05W806iVHVOaoM/34sxvztp064sQQElOhdhlq3X7y6QVplGVjeKv9zLGBd9BOaKyrWCVg8qiC6J/SB86agbmIJaOtsXp7OXJhcjsm0T5jNau3CKJ11FeiWiwQdohjDVv6rtfrcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8N+ccXfJ5agdfyT14DlWIR7J5vil8M9tgq4X0zQjkY=;
 b=hfv4uc8f35W+rux1FCt36ur+6VMLaeethtA/KSA/Xo7/b2Ol6ZQ7HLETIf7DmfT2ZQS5J34Njt3CxmcgOJVzeone03nTNZrElSMZdiiAfgRFTyPs+4zjXhBmUnEx81NnqA2Pckg2EP5sL6hrXwEaVmMf3vfO9qxOf62bUn/IfUY=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1149.namprd21.prod.outlook.com (20.178.255.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.8; Wed, 11 Dec 2019 22:23:55 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::d15a:1864:efcd:6215]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::d15a:1864:efcd:6215%9]) with mapi id 15.20.2538.005; Wed, 11 Dec 2019
 22:23:55 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Fix tx_table init in rndis_set_subchannel()
Thread-Topic: [PATCH] Fix tx_table init in rndis_set_subchannel()
Thread-Index: AQHVsG5UVOIGNYBaZEilUlbB1bRSKae1ggCAgAAAY0A=
Date:   Wed, 11 Dec 2019 22:23:55 +0000
Message-ID: <MN2PR21MB1375EA1C437C0667689CA62ACA5A0@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1576101543-130334-1-git-send-email-haiyangz@microsoft.com>
 <20191211.142211.1624810442420026092.davem@davemloft.net>
In-Reply-To: <20191211.142211.1624810442420026092.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-12-11T22:23:53.8093260Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8aceaa83-04e6-404c-91c2-15049e25b534;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bdd9dfc0-ebc9-4328-a3d2-08d77e88cf6a
x-ms-traffictypediagnostic: MN2PR21MB1149:|MN2PR21MB1149:|MN2PR21MB1149:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB1149B0FFA13AA42373B2C7DCCA5A0@MN2PR21MB1149.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(39860400002)(376002)(396003)(366004)(13464003)(199004)(189003)(2906002)(66946007)(6506007)(66476007)(76116006)(26005)(186003)(54906003)(64756008)(66556008)(33656002)(66446008)(316002)(53546011)(9686003)(6916009)(86362001)(8936002)(7696005)(10290500003)(55016002)(478600001)(81166006)(52536014)(81156014)(71200400001)(8676002)(8990500004)(4326008)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1149;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OAFxUgQFmkSzAvIVhs41C+Go7XKPkPw4WT5L7cW0kZT49NP0qpq5VbQ7gaTwSyYk0IDNLTGBJphCaTJRp8yrQVG95D62OInnqvM1wm0g+VJUKvCzLlV8cj5Ft7+nayngzEAAn6YMU0cf/pDTqCA8u/de3DP/DzsU5CU4JEvm/CKJjaNughhJRluOYIgIZ8c0rDBHUhodAi5HHtHgwuzoHsEATktiPML57Z8TLNIqhI2YdNHLgs9liHnoaowKpkC/oZJiKzQXjiJ1o7/Qz1EB4UBj+mBAUVPbadnsvHJMmYYfCp55VpAKJnN9X4NRNHysdXSvlM1aWChJxwuA8mlQ8MiYuardhKaak2viF/r9POsPFBl3MbkpXnhdfhDAteGfjGkzeKl9j9jYx0Rgl9EK0w9wprw1JXUD5mg21x142N+GP4x3t46/L7KyOax3mxs13VlFX83y7d2hVKaXfQaSy5/V8MeSOABx8czLtHWX8YKeL9oVscLSd7ln6fCIT8Vn
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd9dfc0-ebc9-4328-a3d2-08d77e88cf6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 22:23:55.5509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dbyNozgxHoSGo/U1OvYcp6oUUrzfJURPTOCnRmMwNznJFAziyV6w0lUyx1SIcfepjVzYaRsgSkRSIQg5ViB5wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1149
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: linux-hyperv-owner@vger.kernel.org <linux-hyperv-
> owner@vger.kernel.org> On Behalf Of David Miller
> Sent: Wednesday, December 11, 2019 5:22 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.o=
rg;
> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Fix tx_table init in rndis_set_subchannel()
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Wed, 11 Dec 2019 13:59:03 -0800
>=20
> > Host can provide send indirection table messages anytime after RSS is
> > enabled by calling rndis_filter_set_rss_param(). So the host provided
> > table values may be overwritten by the initialization in
> > rndis_set_subchannel().
> >
> > To prevent this problem, move the tx_table initialization before
> > calling rndis_filter_set_rss_param().
> >
> > Fixes: a6fb6aa3cfa9 ("hv_netvsc: Set tx_table to equal weight after
> > subchannels open")
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
>=20
> Please format your subject lines properly.
>=20
> 	[PATCH $version $GIT_TREE] $subsystem_prefix: $description
>=20
> Even the Fixes: tag had the proper subsystem prefix in it.
>=20
> So your next posting must be of the form:
>=20
> 	[PATCH v2 net] hv_netvsc: Fix tx_table init in rndis_set_subchannel().

Will do. Thanks.
