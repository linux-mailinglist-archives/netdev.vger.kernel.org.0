Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDC5359113
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 02:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhDIAzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 20:55:02 -0400
Received: from mail-bn7nam10on2121.outbound.protection.outlook.com ([40.107.92.121]:39165
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232426AbhDIAzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 20:55:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b19SeGfqJFWBVKctsA/uQQ9czRMy5Ea+ulogO1TPFK5B1rDPweMDSTOkUnHVwYLx2W3l+o+FAZpHCij+p0l4tMSGvYYIZImS4NpZAm/V0vWlO+pCVJvp+spowKBLAlM5D6iPrHaliTr/Bs4EP+5jDN02amsldAf7vCG+qcbPPkSjwVylorhovM46bdJGUtcfsocWtSmKbkq2X9ESfCbU2mGNKE+Bo61vQivcBSD/7Xiz8CRs77QxYza8AFy2ifqZSieBGeViWSMLysVhmS/n7ncNJA+PVuWPV2KuqQ7XcCkRWh7QwAuaJzQRKMO5/C4tfpAbApoSvMdkX8eYLJMI1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RivmEfd1Otp0JWXpcOlCXuNuxa4BfBmRmOrg01Eug0g=;
 b=HNaWIv2nrueBaxOrPmL91ej9CndttjDryyX4SBQxftqylXTz8wITVUB546nJHTzctchAUeL9XQd8VfsTIQ4l+bLrtAR3OE3snNhMDvDcEenHCndQP5YLOLmFnZqClXvQJA6mDoRNealQIlGF0hinXfHLeYrYJecAo/kma9M9DZTMrUFftNLN+SBSihSqLMlPNhAWhLRcIwtE43aGbSAU0FLSPiqJN/+MWFHM65rTZari0Gb2jNydxB+FrDUjzFLGoNKOMAUtccL6EbyeePxt8CtBUKQkP1J2USIDQvAa5hP7jHzYqibq2BzDA5uu76icxNSf+ftucDnUfrMlGcg00g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RivmEfd1Otp0JWXpcOlCXuNuxa4BfBmRmOrg01Eug0g=;
 b=O80nKVB9Lzs6hGLygEAVRODthC3Z9FzzJxtrWLrzAAGceLjeczCcA2J3jciv1+ejqF6nWXMGNBvaIrosAFl6BQjB2AnVf0vukLw/RgI1BLzbe0V6swDCvugva+VkxXCllibcPto+tw1jCVY/E/qgTGVOCv3G/irh+W28utYFuoE=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MW4PR21MB2002.namprd21.prod.outlook.com
 (2603:10b6:303:68::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.1; Fri, 9 Apr
 2021 00:54:47 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4042.006; Fri, 9 Apr 2021
 00:54:46 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v3 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v3 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXLNeAZWy01RJh1EWXtFcKc+4EuqqrW8LQ
Date:   Fri, 9 Apr 2021 00:54:46 +0000
Message-ID: <MW2PR2101MB08920609294E2F94F362EEABBF739@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210408225840.26304-1-decui@microsoft.com>
 <20210408164552.2d67f7b1@hermes.local> <YG+gFMnVuvtlHNQQ@lunn.ch>
In-Reply-To: <YG+gFMnVuvtlHNQQ@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=43b17a5c-e589-42fb-96c7-529aab6326ba;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-09T00:53:14Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:adc1:3ae7:8580:9c8a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40c2168e-4d01-438d-9330-08d8faf21258
x-ms-traffictypediagnostic: MW4PR21MB2002:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB2002E88ED437AC21CA0D637BBF739@MW4PR21MB2002.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qkdk3AkjlCkPhln9JrL4B/LixqR5wXdqG/mwm48HW7ocbrJRqjXL2bk7bNQbvOuEnN4skymX7S+zw//nfUanayB1UkHZqmaUdV5HVBemLVrCunGfAm63wbD8nSjuD7/5KOS+kPXaZiGW+CVBfZifxJZWZK3Uz3VWtFsFeCXusHb544bdn1myIdVtCjIHlebdEW7aMJylhSctd0kyV+HH0YNLXsyIsvYfh0SQXyyvFJzhuYFuM2iPuzlJuE0RbYORnqML72o4Rkssd6DS09w6ukYgwl3YZ4oY0uYT/8jPRJlmcdtyesacp8AxQa9COoMZYLHqAnORodjgiTDQpPeadnGww5i51Wd3V28U5ov3RnKEsSE2lGwcwbLwx0ne4mV367tA2Ss2BIBPvI8kFAA9AtNfxGHraaJx17HtpPkMPFa5ZnAmMUGqxwaES0HtvWh1bEsBumAY22sqD+IanMvJ2JeLyCyXeuJ1efy0rvJ7exzUApsxHUrggmz0fcGV3MZXROL34v45i4pFUx2sRbt8vNeeh+j7Pem1sOXjSyqEjjc1t63qum+jltGhemHlOnCwCASBnRa4G6491P9bVbYYEOt7O689JmLUS2C7LGg00XAYl+oM83VC4JJ8D3DS55t/axUq9TL8WIRKWHQp6HPDGk8KQEdvyd3uwosw0wTKCk8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(47530400004)(186003)(7416002)(8936002)(76116006)(5660300002)(33656002)(110136005)(71200400001)(2906002)(54906003)(82950400001)(9686003)(55016002)(53546011)(7696005)(66446008)(478600001)(82960400001)(10290500003)(316002)(8676002)(52536014)(66476007)(66946007)(4326008)(86362001)(66556008)(64756008)(4744005)(38100700001)(6506007)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hce9iC1a78lNuge7mOkveYPxBIjUNlNcRIQLWG2Pxreem4hZbJofvWcguWEP?=
 =?us-ascii?Q?dyrygRlBnkSlH2baJUntxjTn0fxrxM4TPbVZORrwNUL2d8CUiAIC844ffvMZ?=
 =?us-ascii?Q?57qIsLB8oKiQ9JQLmkqz69TodUvMz4O7P1dz5CfHZsIiAZbN0o+Wy77wkRt6?=
 =?us-ascii?Q?7toxFNSpfL+UcarJtGmGAzhzclS3hGIntMAQNR7bdIut0B6XmfO30795HF7A?=
 =?us-ascii?Q?oq6kGorijPAbo6aGtvybcYnF6tZrkDFzj7SToJC4Xsza3hsuefSHjl1Pzla5?=
 =?us-ascii?Q?qDxjMOUBSDugfkqB+/nwoU0AIr0eVR9Gh1+XdKEULDQ6rwQ/v2968g0HQuUg?=
 =?us-ascii?Q?OFWuE55ToDTuDfMzqQGpuBlGPijbVjLYi6jccVr6Ct5mnMzOk/yrVSceYsBZ?=
 =?us-ascii?Q?u4RN1LRik0dGvS8ek9jI8Ef30RhYaL0UDsuPt1s/RBEXIYAbxdnTKDuPn0/v?=
 =?us-ascii?Q?ju9PKn9zch+Y/GUpCj6tbX3QtkEO3kFwZrJ3e8Jhgdmr6F99Fmufb2aT/wdW?=
 =?us-ascii?Q?j3jzcUMY/+z710FFxaMmWHf8crKhbJvT475xqQy0H3912vakIsPApUxUZhgE?=
 =?us-ascii?Q?MbjL0H3JTHIxQR62FUPQGDlhj5HM31o5Ad0YuA5Ds+jHAUVEwPfjO0JftX5L?=
 =?us-ascii?Q?wSvvhb4RVtdcKIOmCd3Uzztuw8XxULtHXgVY+NXsa6eXI80AgG1bQbpyKNW2?=
 =?us-ascii?Q?jwubYedzxFTHTTyLLh3xVlKcftr1oz9os1zI89m/K9VQiPoOJl35Koif1GCy?=
 =?us-ascii?Q?rWuJdLBohZcPhTdhBa3Tms9dopkWEA9IefN3iIdJ0M3LkLezgrufM75+zrAj?=
 =?us-ascii?Q?0d8bQxG48psHq81UZ46yqP0BjAZdGSGC4F4L3rme1P7Ti52Z6wa7p/kZ2vmm?=
 =?us-ascii?Q?BFtvPA29hfrqSfW0Bo7nui2lgZxky7EfkuzuZdsXU6QiISLa+IRM/lGXmcsM?=
 =?us-ascii?Q?cZ2VPea87sBpAYNxK0SHX5jxIeSFTRU3SWJJg2VbcA8jDxQgC5xIHiNzgUi6?=
 =?us-ascii?Q?ALAOgHOuWeoRVKXGW7rEXjiLUS3DqwXmbilPbdZAD0vxahQBJ0NWZjBGy68T?=
 =?us-ascii?Q?UI5J1yipyn3bJGkDNO0fCXKJL0aDlh4JOtDGXN+WSu653JC0ajDaK2R+MGn7?=
 =?us-ascii?Q?019tr69PCsWjftjpfVqvpzS+ItARC7UbqHMPHviMBvy4YDzJ6PR5qOJmlGbT?=
 =?us-ascii?Q?ez4aVpq0NcgPDzKkUTwttDF8XLFuP5cDmdBRXJs9i+FfhyLSUZE7W4OBad2f?=
 =?us-ascii?Q?sanP1XfxXXj5Y0usI777fHF44e0YUzgYUDEO677BdJfCSGafY5m1FiAWf/qG?=
 =?us-ascii?Q?xLNUYb5/6nMy0h1kLX+mT6j9MtvdnrNJcrR+zqihEfLvEzWfp4E02I+W+Mwk?=
 =?us-ascii?Q?x0EutWS/RBzzMLIrDP2/LKJPX/HR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c2168e-4d01-438d-9330-08d8faf21258
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 00:54:46.8450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K6I/Uhh0YqxNw+gxGyRZByulMzzHc98q3M8Q9xBK2jRLHijjXF3XRjTzsUJiWih3jOJWoHDqaD1BO1HbiBwGSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB2002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, April 8, 2021 5:30 PM
> To: Stephen Hemminger <stephen@networkplumber.org>
> ...
> > Linux kernel doesn't do namespaces in the code, so every new driver nee=
ds
> > to worry about global symbols clashing
>=20
> This driver is called mana, yet the code uses ana. It would be good to
> resolve this inconsistency as well. Ideally, you want to prefix
> everything with ana_ or mana_, depending on what you choose, so we
> have a clean namespace.
>=20
> 	   Andrew

Thanks for the suggestion! Let me think about this and work out a solution.
