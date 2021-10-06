Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932864245FE
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbhJFS00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:26:26 -0400
Received: from mail-co1nam11on2132.outbound.protection.outlook.com ([40.107.220.132]:59105
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238679AbhJFS0V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 14:26:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNSwmhNEarRnkJkek+HBVIQ7UDaCr8KwRxP3A/4BNsROS3q8es3k274WHpYJCk0Xm+hUEncqjLHnJ9EO3fUTrUMzAMQU+jwY9Hmd73EnYoaZGXrgKOpdBLXii4H9e5M58DvPylofJBTpf/F9oYgxS9kWaoUy4JTtfZVKpEOJByF7jiKywXlHaUW7RXaBwHrZcoBKDbKxZDpBUxMbrl2PWRls20nIaMN4mxPB71QSaEJryPEjD7ocmHl19d6fhIhXdE0mzW+n3EboJ57wF9RT8bheospr5QwIASKnnCx9pRM/3nWVl1wwhft/7/vLEv0rbgvY4pQKNQiL7xC7wtQUnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pqoTn1q5APa1haJLAItxAv60+0bCRhLnIqvwm49Ey1c=;
 b=SbaFnapM4SuTuqWkR5/n8T92h/nKkQwWFIdGsN1MXEjsquOEqtRGcFqXn8uW+dK16EJPs4CxOwSadqPo+0zoB6tDpoJ7xZyGI/0NhPtRDT/AidwKvtQjc82umXWrhyhjWwx9uUbTFHFbdwlagR9urQX+t2Uc5kHiTspgBn8X+p+VqlBt+E9a0WK2cO8rCfEP2Ey6RC3Ruu0nvfsYO66gk6hATCI6/WNA4fVqEZDP9Lt/NJ6jWIcDIgHM6f/edKwm59iS33cbtxF8v/6RkP6zMj4hOK7p7qaQt0NNRWoWv9Uoqk+MVw2QkTokdgclxye8YgHBs91ocVI7Rp7rSmiBGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqoTn1q5APa1haJLAItxAv60+0bCRhLnIqvwm49Ey1c=;
 b=RCSC6Zl2DnQcAsNB8tEu762zYIbkHd8bFJRe3SAF1207E9nBCq8y7x7eGit1WXn2Iyo3YyDNSLozODdMfTtkYrrwkia2/rTlIiSCmoJ/ftqN2IYMmnE0O2Q3XpK0+14g2aOos4REY8kMkUleME4QmRfqCtY4cz636bZip7ixAdk=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BYAPR21MB1285.namprd21.prod.outlook.com (2603:10b6:a03:10a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4; Wed, 6 Oct
 2021 18:24:26 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::78b5:7b19:a930:2aac]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::78b5:7b19:a930:2aac%9]) with mapi id 15.20.4608.004; Wed, 6 Oct 2021
 18:24:26 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH][next] net: mana: Use kcalloc() instead of kzalloc()
Thread-Topic: [PATCH][next] net: mana: Use kcalloc() instead of kzalloc()
Thread-Index: AQHXutzzU+say7NzcEyLOhPQd75BgavGSEGw
Date:   Wed, 6 Oct 2021 18:24:25 +0000
Message-ID: <BYAPR21MB12704E2037BB1BD622356629BFB09@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20211006180927.GA913456@embeddedor>
In-Reply-To: <20211006180927.GA913456@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ce0df582-8cf0-4783-accb-fe6fcc7a7dd1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-06T18:21:33Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e712c49-c1f0-488a-3e9f-08d988f68722
x-ms-traffictypediagnostic: BYAPR21MB1285:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR21MB1285317E25C2DFEEFBE62C18BFB09@BYAPR21MB1285.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:469;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WEBjsw0k/anAOPTWrH+3kxTu5HZPkY8RJF43Vsoonqy1a0l7U4QWAWCsMLPDu3XE5q0MxAolNsJNxFs5cQAjefu13lPSpRWUz9qU0eybBxYYggxr8Oq7pu4gok6RcFj0JH/wAGfWQ4iAYKkyi9ERtSlrMo/wlbDsY2ypyPpm5p4XlM3ZozOzecN7cft1UZ1207NNPhzZOf8vI9TMVznGPhIQwvBuhpvOdbuB/MGyO+BvNwr2k74r4eE1u4Uly/bSqGbdsS8egiZwwtAyfFV4KoB5Cv7+Bmj3r16Tf/9bL3RKmFRv18JB8J2NSDqRzEbuoasBNHUMXaRM47prQ704jl5+zXVwlcEwV0Aq/Tm0zbJtrc6gnnPhVMSclk6y8tqv9wgWf5O/XmCV4aOVJ5lP8CBZkKPuPDgWEvtzGJ5E8JFjmEuU+sAOSSJrsbQgmEenTrDnT1PUKhfOIX3dYw8htUdSRQfVIeyXPgCG1yWIDUOGfbjBxnsW/ZT+5Cgr3YxXTChS2dcQwnKFl1JTmE2LDeLanJ4IC2e+szUPf2ZIMZLzEktS5S+fO+sTZWXsG5dj4tRodh5p0XIIjwt14JsibIoi7Pl7fW3u0OB2EvsmBFFKyTFLri+ZQnwTdLfok//IfJmtymM3IsA8COGloQOWXSBx5QMq+hA/QPPajXqqHy6MUaqhKx8mLtV5urp4kMS9Kxk2UtcjTNo7y/NpBlJJHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(316002)(8676002)(8936002)(4326008)(54906003)(33656002)(110136005)(52536014)(66476007)(86362001)(55016002)(53546011)(6506007)(7696005)(66556008)(66446008)(64756008)(66946007)(2906002)(10290500003)(71200400001)(9686003)(508600001)(5660300002)(38070700005)(76116006)(82960400001)(558084003)(8990500004)(186003)(122000001)(82950400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h2FB3jOI02ct2EK728Z8I5SYl5qqpuYYAOn3rpUWn3BLKeEz/jwsTU9gYE9d?=
 =?us-ascii?Q?Oq2hUq5e4STA1ELsJ5C0diWmAi97Ylo8A4r5HI7r4AU1W3apZYzTMbLDPcgB?=
 =?us-ascii?Q?2tJC1OGK8mfjLgQi1fYM2jD0UqL5hx8ODE5mJl8IHkBuc+bIdH046qDnQ1L2?=
 =?us-ascii?Q?H9ocpxkh/tM94qty13jXtnyTJbl9Vf12cPCxZMg6k/Nxouqdcdvsw5Nee1uL?=
 =?us-ascii?Q?aM8nHruVfcxMJ57Ro8vQJAEg9KR8Lh4p64MV/r28QH8RYwg3TQBtdmXqzqtK?=
 =?us-ascii?Q?40BS9uvRkvHoJb/VLp2j59wilA6Y46DkVi40iuqSJTUs5Oz2RyVRUNRUiuaQ?=
 =?us-ascii?Q?VDNZaeZDeeIEjJoO7piR2JHlEyDmEwUpwIVmgHWQPfnTEK+TkJmksBBZthda?=
 =?us-ascii?Q?Hep8UakQlek6+1VP9W5cuNbVOM/5P6kYDVj38uF1UKUYcuMAQm+rJuEuXn0h?=
 =?us-ascii?Q?f3BlKZZB+IwTjDcLy8A7LyD14wXw2Aoi1mRwUtI5uh0W1ZVWp/RxRRD5Qp/v?=
 =?us-ascii?Q?dKKaHFFa5NyGJalkJ7qf4pcE4uYey7dDDSwhHTkPearTDVNQZEfwCHoBcSXQ?=
 =?us-ascii?Q?JO9JRHGQyR7VBE3VdB5wpisI2PqSTNe89rrMs8N97nEwPc7xLnlvQ75MszKg?=
 =?us-ascii?Q?txBeEDyABtM+mLM8/AWR0Kwrc4wnCU3CEebpgYgqCzb6bI9Ca8tDnwH9rEuH?=
 =?us-ascii?Q?UGTRU3yzrbqcMZAjLAFetlbe1+sfhQBb6IQPLH+byhaa8yStWcDvlCTcxMBa?=
 =?us-ascii?Q?TMPc/tAnFZzz1D7fP4V+2Hf7oaI+eulT1r6WS7ULwoJN+6SzXOLMr0EDeAFW?=
 =?us-ascii?Q?sspYqXPfxHJ5Q4stmZkMPnFeLfKgMogrPyLtasosFDe+aQaWT2JXdifE2W3E?=
 =?us-ascii?Q?2NwyFKDVihpj2n7IomibID15vRWYRbbyHGn9IeyWPVa/sh/qveK4iWo24VJo?=
 =?us-ascii?Q?r86s7g/NpjrRUi7cUndiyBkK9Xhf+czEKEA3NPFAWs5sOH3JvpWfuz4HRxbM?=
 =?us-ascii?Q?5sV3UCbXRkEQ37IhVJ70M5InCqYHiid6/jISoMumkYS2Dhu/Uwrw8zhakbRW?=
 =?us-ascii?Q?B+RibbXQuSsMCWrZN0DFWnT4PvcUWHDOHvVGFK3feSzUEf59z63SXmWnfvri?=
 =?us-ascii?Q?2E+uBTPU0gTUk2F78qzJGSGTOCzxx1fy088rAiLNecoSHYt+BMAHs0jxStoq?=
 =?us-ascii?Q?YMaGxwLOElUodOIDmo05suBmrT8da9kKbOr5O4vT9Wv7c3snB5JV9Wwkjc4A?=
 =?us-ascii?Q?VkBxq1yp2Ks9/k9Qo83dT5LijPfI21PZyyUZCSX6xSFw5KwPyc15q+nq0B6f?=
 =?us-ascii?Q?SrjUewE/OkCPEmD4e1ewfcxC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e712c49-c1f0-488a-3e9f-08d988f68722
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 18:24:25.9287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qDS6/ad/OXUZ4SVKYZiC12jDT6uhDVe1KBRVPua5ZusYMcPwOz+uYvjRq+VPgnpYF1YZlZYZSTtJsN4w7vcRFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1285
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Gustavo A. R. Silva <gustavoars@kernel.org>
> Sent: Wednesday, October 6, 2021 11:09 AM
> ...
> Subject: [PATCH][next] net: mana: Use kcalloc() instead of kzalloc()

The [next] should be [net-next], butI guess David can fix this for you :-)

Reviewed-by: Dexuan Cui <decui@microsoft.com>
