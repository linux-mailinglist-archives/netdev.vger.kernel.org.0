Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E13A26BB2
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732786AbfEVT3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:29:16 -0400
Received: from alln-iport-2.cisco.com ([173.37.142.89]:60596 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729466AbfEVT3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:29:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=872; q=dns/txt; s=iport;
  t=1558553353; x=1559762953;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7SE77wYHwG03Jg767C9KD7YEVTpFF93beEhebDVXgsk=;
  b=Pgc5nO/B5QduzV2bx2BYXK2YBG+Fca+iIqw9Ix47FzBg32YIIbTc63OG
   pL05PgoJEr+3EeSFc1dJNYQMSVfp8xT6PMmkxgF9UG8sHjAMZlTrdNEqx
   YHIoWxTt2QuRo6S3+tuLZFitWFSJyBgqtP0RTyISUewLkuRBVMQDBDepQ
   Q=;
IronPort-PHdr: =?us-ascii?q?9a23=3A91kOnh1nNqOGU1H3smDT+zVfbzU7u7jyIg8e44?=
 =?us-ascii?q?YmjLQLaKm44pD+JxGDt+51ggrPWoPWo7JfhuzavrqoeFRI4I3J8TgZdYBUER?=
 =?us-ascii?q?oMiMEYhQslVcCEA2XwLeXhaGoxG8ERHFI=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AGAACyoeVc/5FdJa1lGQEBAQEBAQE?=
 =?us-ascii?q?BAQEBAQcBAQEBAQGBUQQBAQEBAQsBgT1QA4E+IAQLKAqHUAOEUooigleJQI1?=
 =?us-ascii?q?pgS6BJANUCQEBAQwBAS0CAQGEQAKCMSM0CQ4BAwEBBAEBAgEEbRwMhUoBAQE?=
 =?us-ascii?q?DARIoBgEBNwEECwIBCBEEAQEfECERHQgCBAENBQgahGsDDg8BAp0dAoE1iF+?=
 =?us-ascii?q?CIIJ5AQEFhQUNC4IPCRSBIAGLUBeBf4ERRoJMPoIagioCgzqCJo1SjSqNADk?=
 =?us-ascii?q?JAoINjyWDfJYyjF2IS40KAgQCBAUCDgEBBYFPOIFXcBU7gmwTgXwMFxSDOIp?=
 =?us-ascii?q?TcoEpjCYBgSABAQ?=
X-IronPort-AV: E=Sophos;i="5.60,500,1549929600"; 
   d="scan'208";a="277582125"
Received: from rcdn-core-9.cisco.com ([173.37.93.145])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 22 May 2019 19:29:10 +0000
Received: from XCH-ALN-015.cisco.com (xch-aln-015.cisco.com [173.36.7.25])
        by rcdn-core-9.cisco.com (8.15.2/8.15.2) with ESMTPS id x4MJTAuj015185
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 22 May 2019 19:29:10 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-ALN-015.cisco.com
 (173.36.7.25) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 22 May
 2019 14:29:10 -0500
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 22 May
 2019 14:29:09 -0500
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 22 May 2019 15:29:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjOytL2SZyled10Jhx6GRQspP79SXFzPuQxJZJLshvw=;
 b=LKU3TDroV/PO4t2iA73ti+T1gDw9tl/ZKS4mlvVFKCR8Vd18y0/nMLunLE3ZfVPlcuuDfg0yG5zipXNOw4XwiQucLz/dTc+Ga6qQBBtARe9hgV6wuSpuocxiEwuWPu+QpA//5yR4/Kb6vZzmYTnO7m0PEBfdS/qJSZrdow7bEQ0=
Received: from BYAPR11MB3383.namprd11.prod.outlook.com (20.177.186.96) by
 BYAPR11MB2999.namprd11.prod.outlook.com (20.177.224.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Wed, 22 May 2019 19:29:06 +0000
Received: from BYAPR11MB3383.namprd11.prod.outlook.com
 ([fe80::a116:fc59:1ebf:5843]) by BYAPR11MB3383.namprd11.prod.outlook.com
 ([fe80::a116:fc59:1ebf:5843%5]) with mapi id 15.20.1922.017; Wed, 22 May 2019
 19:29:06 +0000
From:   "Ruslan Babayev (fib)" <fib@cisco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "20190505220524.37266-2-ruslan@babayev.com" 
        <20190505220524.37266-2-ruslan@babayev.com>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>
Subject: Re: [PATCH RFC v2 net-next 2/2] net: phy: sfp: enable i2c-bus
 detection on ACPI based systems
Thread-Topic: [PATCH RFC v2 net-next 2/2] net: phy: sfp: enable i2c-bus
 detection on ACPI based systems
Thread-Index: AQHVBG1FwjU1WTeEMUumoWKXpb9bbKZe8vkAgAAKMLqAGKLmaw==
Date:   Wed, 22 May 2019 19:29:06 +0000
Message-ID: <BYAPR11MB33837495646A3A0BB23AD1B4AD000@BYAPR11MB3383.namprd11.prod.outlook.com>
References: <20190505220524.37266-2-ruslan@babayev.com>
 <20190507003557.40648-3-ruslan@babayev.com>,<20190507023812.GA12262@lunn.ch>,<BYAPR11MB3383B74F06254EDA7157D314AD310@BYAPR11MB3383.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB3383B74F06254EDA7157D314AD310@BYAPR11MB3383.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=fib@cisco.com; 
x-originating-ip: [128.107.241.180]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96dadade-eb8c-4153-f8fe-08d6deebc1b4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR11MB2999;
x-ms-traffictypediagnostic: BYAPR11MB2999:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB2999AE4E49B1EBD6A2A69F14AD000@BYAPR11MB2999.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(396003)(39860400002)(366004)(199004)(189003)(2906002)(6116002)(3846002)(86362001)(2501003)(4326008)(25786009)(256004)(53936002)(107886003)(4744005)(71200400001)(71190400001)(478600001)(6246003)(476003)(446003)(11346002)(14454004)(486006)(99286004)(66066001)(76176011)(102836004)(26005)(54906003)(53546011)(186003)(7696005)(6506007)(33656002)(316002)(229853002)(68736007)(8676002)(5660300002)(81156014)(81166006)(76116006)(110136005)(66476007)(55016002)(66446008)(7736002)(8936002)(74316002)(66556008)(64756008)(9686003)(305945005)(7416002)(6436002)(66946007)(52536014)(73956011);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2999;H:BYAPR11MB3383.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VhDXBxD8aPmjkSX3Du5aBnPtuYS5e5SsqABmO44W4ouq1+9mLk7Kc8gWNeEs5Wd9Wm8UN1d7cKxZECrld+/bPyh8jB1je+niLDkqXbJZsLuRV0Lvqv9LPkryxFvcZjueEIuZhY55LaWFrnqNzOtHBQ5+oc5JHkpS6a8w4nMZn2qLgngBqoVKmxwi/ubb74TlqoDK6hb1Ttqg7v+JtbXYqNLZ5hx4NG70rzV4r9s50Msz/Y56XYKQtpwAtE6WwcS210npMxdfGaZ0aUWXlRGriEpbGieh98hTd1aTs6o0q5uScw5GgZP9VaE8Igp3ORhmaV7wjQtvjpjTti4TAXKPTTDi49LSeDOnEhwPUy04GojvYWF+uOVaBxH998+dtbhpkHjAdST5nsp/dat1eeihSXaJZ+3HsEm5uZrxj2iqm4A=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 96dadade-eb8c-4153-f8fe-08d6deebc1b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 19:29:06.6628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fib@cisco.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2999
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.25, xch-aln-015.cisco.com
X-Outbound-Node: rcdn-core-9.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Just wanted to follow up on the patch. Does it look good? Do you have any o=
ther feedback, concerns with this patch?

Thanks,
Ruslan

________________________________________
From: Ruslan Babayev (fib)
Sent: Monday, May 6, 2019 8:15 PM
To: Andrew Lunn; 20190505220524.37266-2-ruslan@babayev.com
Cc: linux@armlinux.org.uk; f.fainelli@gmail.com; hkallweit1@gmail.com; mika=
.westerberg@linux.intel.com; wsa@the-dreams.de; davem@davemloft.net; netdev=
@vger.kernel.org; linux-kernel@vger.kernel.org; linux-i2c@vger.kernel.org; =
linux-acpi@vger.kernel.org; xe-linux-external(mailer list)
Subject: Re: [PATCH RFC v2 net-next 2/2] net: phy: sfp: enable i2c-bus dete=
ction on ACPI based systems


> As i said before, i know ~0 about ACPI. Does devm_gpiod_get() just
> work for ACPI?
> Thanks
>        Andrew

It does.

Regards,
Ruslan
