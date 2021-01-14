Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA78F2F5C8C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 09:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbhANIke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 03:40:34 -0500
Received: from esa5.fujitsucc.c3s2.iphmx.com ([68.232.159.76]:41072 "EHLO
        esa5.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727620AbhANIkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 03:40:33 -0500
IronPort-SDR: 6dbxcPsqvFFbrCoihICyPfjujn+s+oSBhGeZXowfo63H9/Cg8kN1NJgiHPlpo/kFfl0iOsLYMg
 rEmd1OvL7dB/w26iqn3O9AqmZ4e9iOAI1EKFJCYPCD5ROcwPYQM+ZtG560rfjvXPM0iUK3XWUC
 MIfuKW1RvE8vj9VRoN1lJEJRgRJUs1rjjU+G2/082aVWIXFXJ0x6ZiSb3CCZQbP7zsd4HxPchF
 sefbim3WEYBqRWA5q+5xPVUtsUqNbnT9hu7vfE5qKuuhxclRUjUsvagvjL7Lb4AJawLT6m++p9
 yoU=
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="24418234"
X-IronPort-AV: E=Sophos;i="5.79,346,1602514800"; 
   d="scan'208";a="24418234"
Received: from mail-os2jpn01lp2057.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.57])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 17:38:16 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVsYBHMdbPxh63xa5eYItzAR04rmcpXbM5b32HG8yz27HCUECMaLPW4RzEen54Iyvp2ui0otEQeW7mDqu4wtfQWK1rKn7NFRJ4CPzaEVPN38X1n1iKy457V+3haH51N/VeZsPsVMelubmtbVOysv4a9FkG0lxwDFqClJIxevIsmiXkozUxe8V9tbwRoyDzt8asYLGBaV6Hzfz6hFsr7SgS9dU/indyJGpXP++XkBP1kybArhgFi/pLOZfg45yiIVVkT1f8upTI8w7s4ljLEQFDiAfwUDS3zvD8djl1kaXvQ+0ZHXe4rJRTkAfdp9y0ftUSsGmR1L3JWhUogiepLtNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNlDA+9v39ffDp9LfDP8DPZA1QAOWN0P033EUJD+6iQ=;
 b=EvHsD1ZTN63UTCknoB16jnw59HLBC3evKLuot7x7LAdN9ChjYBcgsjZn48TLHAqyl12aw5KKZCtP0sS+dx/uRIhJz2zO9gndqaV6MpXBdfh3p3hvLmACywS5sGsVm7nTzPXaNMd/HlhB9jw8fJOlr9293rulgIDHJC3rp6SJV+olH8kxUQ8dSOoqHR88HCvwVRnnkUxS8FEGzBwLkWo07LpPRp5zuCSHf6RVTOEzgf0G2Juyeyz5BMf/Va9SM9w0r7ZNcy3FzCFjFhHmrNQCMGsCU8R09UiPXaGd050W08V6vG7J60nLyFUr+O7PLg5WJ/cW1M7mEpWT8xORn2dm0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNlDA+9v39ffDp9LfDP8DPZA1QAOWN0P033EUJD+6iQ=;
 b=lFKhHl0kNgvuI0OilPAw38E2GF0mtXj5Qfyg8HucJ7rJz2906r+QgBFwINmplt5bzESoZ9tIBS7Xva7Y7Vn95UX33U27EWXCh1w5vlFXO32AYR7qlhY7iN+AUb6tQJzGyj1SGdlfue8nktfclNKKtrt2aMU2Thep+bfm91B2r5A=
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com (2603:1096:604:5d::13)
 by OSBPR01MB5110.jpnprd01.prod.outlook.com (2603:1096:604:7b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Thu, 14 Jan
 2021 08:38:12 +0000
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::a555:499e:e445:e0dd]) by OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::a555:499e:e445:e0dd%3]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 08:38:12 +0000
From:   "ashiduka@fujitsu.com" <ashiduka@fujitsu.com>
To:     'Andrew Lunn' <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "torii.ken1@fujitsu.com" <torii.ken1@fujitsu.com>
Subject: RE: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Thread-Topic: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Thread-Index: AQHW5y31ARgi0NV/wE25+9nETrMkFKohCyYAgAXFg4A=
Date:   Thu, 14 Jan 2021 08:38:12 +0000
Message-ID: <OSAPR01MB38441EE1695CCAD1FE3476DEDFA80@OSAPR01MB3844.jpnprd01.prod.outlook.com>
References: <20210110085221.5881-1-ashiduka@fujitsu.com>
 <X/sptqSqUS7T5XWR@lunn.ch>
In-Reply-To: <X/sptqSqUS7T5XWR@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v2.6.3
x-shieldmailcheckermailid: 8b5f1dc261c44c04b7957d19c95a29fa
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [210.162.30.50]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0163017b-fd4c-4965-58f4-08d8b867baa5
x-ms-traffictypediagnostic: OSBPR01MB5110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB51101A38E52809BB2671C8ABDFA80@OSBPR01MB5110.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 53rNryidUYQ2DrS1P1msp1ZUKaP0+fF3iMHS263a5tBKg9r6VFH5828JRHkKRY6sRNfD5sGeI7WL31y8dZOkjFOKbaBwr2HydEf6aDFN/GSUPP93ahSw/JBfHIPBJ3HSzKDG4AFWnkdzqQizXgdah5gGdh3pVDG+KFW/nJ8XSOnrg/JOLjFyKNmCzn4V90UfpavNyIdX18rBR78DR0aCaCGZfg4yXnxQoO4CsgrBmsUBAFYmLzkzeBn5yl7Uhj3LYIQ1MXuhannCr7K102ZAYDVnSy/SyiRuNn7awB0qmqT2BpexEIB0S/Ni3gLsAOz2cirGzAj5JI4I8cCKZufTRCmgn86lpMHTDDGyPwOluGYdlSbAzM/V8oeOmOUlfPqzbWNcsqshLz317h60D4P4rb00jAhhSxnVh7knMKcictDJs3fS6Dcpt91WXLH4j2O9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB3844.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(316002)(107886003)(478600001)(26005)(52536014)(9686003)(6916009)(66446008)(55016002)(7696005)(6506007)(33656002)(8676002)(4326008)(86362001)(2906002)(64756008)(54906003)(186003)(71200400001)(4744005)(85182001)(76116006)(66556008)(66476007)(5660300002)(83380400001)(8936002)(66946007)(777600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-2022-jp?B?YnZ2Sm9DZU1POXVSS0htK2RoK0hjTmNudmVpUVRnV2t1cGZGbVk2RzN1?=
 =?iso-2022-jp?B?dnhMc205UkxrZEVCUVdrRWRuZ0taUXRNMFdwRGRRK2tvSDRiZTRWUVly?=
 =?iso-2022-jp?B?RmVMM054SURHdGFKQWY0eXZycGhFZk9pZHo0UjdydnY2STM2aVJzVVpa?=
 =?iso-2022-jp?B?dDVHK0xWcThMaHQ2cjU5RWVSSVU3TkRFL1JXZmhBbUhvaEx5UGtlRmRx?=
 =?iso-2022-jp?B?RE9wakgzcjFGMjU2NzVCMUF1RW9yQWNDemN6M1BBOXlFODdoWWNSTm9R?=
 =?iso-2022-jp?B?ZkU5S0N0eldpZzF4S25lRExod3FocUYzK0EyRXhYbWhGa0RXdmFyZ3R1?=
 =?iso-2022-jp?B?ZzJIWVZDN29Td2UxZ1o2YzF0enVjaWFLTXdwbGcraGlycExjaTlOZE52?=
 =?iso-2022-jp?B?TmJoa1ZIMWhDS0ZOemZvSlZMVERRVTJ2eWtheDEzL1p3Q0IwOEd5UGR5?=
 =?iso-2022-jp?B?TEQ3dm1ZY0JLeTNsbzczbWVzeEtoTS9xY1U0MzNJVThvdDFlUWoydU14?=
 =?iso-2022-jp?B?SWM2Z1NrSGFKTldBZ1V6aTluN21EWU5hTk1Yb2ZBTThaclY1ak81eHRw?=
 =?iso-2022-jp?B?bUUvN2gxOHhORFVvM1R5ZHVEZk9oNEx1emJZQVQ3Ui91c3puVEZGdkNu?=
 =?iso-2022-jp?B?c1l0alV3RTBxL3BKcDBtbVlwelZWdThvLzdUZ3dLTzZmTmFRQmQ3dllO?=
 =?iso-2022-jp?B?RzVZbG9kNnN1R08wK3J3TGM0bENhN2NsTkVvbXU5ZWpPMEZVcHA5Ylpq?=
 =?iso-2022-jp?B?bXhEYmZIM3lLWWhnQVVsMTJ6cTMyK00yYktESUl3cDRrRWljblY5bGtT?=
 =?iso-2022-jp?B?SkRrUHIwRTdIQjgrQ3JVNzBaZjR4TjZOVnNyNENvRE0vSUwzazlDenFs?=
 =?iso-2022-jp?B?NXoyZmlSVVVJTkdpaEgwTS9ZRXM1OElhTEpURmtBanFPTzZ2YVJUSXBE?=
 =?iso-2022-jp?B?NUY1K2NHa2hqUWxoYmgxUGNDY2NEdUI4Vkg0a1p4SVQ3RlgzQlJQZXUv?=
 =?iso-2022-jp?B?Y1FkSWpDcmZ6bVZ0V0hIaW02c3B2Z25tWXR1dlpvWGlJUUFwaTdMVlpN?=
 =?iso-2022-jp?B?aTRKZTVNUWk0UE1pMkZaZFdwUHh1KzBMR3FUYmd1L0ZPZDY0L21xNTZ2?=
 =?iso-2022-jp?B?a1QvMVd2cklqN1BOSDFycEdpNjF0QXR0bWp3Z0JwVGZ6T2xZYmdFUWg4?=
 =?iso-2022-jp?B?aVo5YVcvcVdTMUFiSnFad0VCTGFLbGdMSEhhZHNSMi9ZMnZZNXB6NnVU?=
 =?iso-2022-jp?B?Q2hvN0JJQ25DWlJtTE8waWU2cVVkTGVCOHBFWDN4Y2NLaDZqWXQ3L1NL?=
 =?iso-2022-jp?B?YWlqZjI4ZFNWUFBPbzZhNGdCWDRKWTN0MWVRekF0bW0yMlNyd0NtMDNB?=
 =?iso-2022-jp?B?bVU4alJIbkZXbmpUVUQxMmxsTklKcXhyMldrTHduanYzU0gzMD0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB3844.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0163017b-fd4c-4965-58f4-08d8b867baa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 08:38:12.4176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xSmiqdMcFDRtZ4mjIA4atzn+MUYEtRI5S/KwkyHkWaNM99Je/VRcadadq3N7XmUvuGW2UskNzA6HZU2gRnNiBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB5110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew

> For T1, it seems like Master is pretty important. Do you have
> information to be able to return the current Master/slave
> configuration, or allow it to be configured? See the nxp-tja11xx.c for
> an example.

Do you know how to switch between master/slave?
The help of the ethtool command can show about the "master-slave"=20
option, but it doesn't seem to handle the arguments.
I checked ethtool.c and it seems that do_sset () doesn't implement the=20
process of parsing master-slave arguments...

Thanks & Best Regards,
Yuusuke Ashiduka
