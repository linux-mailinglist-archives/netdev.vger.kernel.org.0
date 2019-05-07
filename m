Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F52157F8
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 05:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfEGDPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 23:15:51 -0400
Received: from alln-iport-5.cisco.com ([173.37.142.92]:51670 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfEGDPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 23:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=189; q=dns/txt; s=iport;
  t=1557198950; x=1558408550;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fPAYb48Hd7lHF4bhR2S9Sze28R1001viE0ObfRnKrNo=;
  b=KJE16D65a3ochwtyxr4dKCMzpghceS63CxxkYbsC2qMi0KhVl7J0oVVx
   VMCBHwCLCrL+J/C84QqEk5oJGN45i7Y5hbtoAWC0j8D1rNy0+/SMHX39W
   IiYyNdVWWSyz8o4a/tyT4THFe7tKfYPUl/ftBJecjlxPfhIxZFvQPUPbP
   4=;
IronPort-PHdr: =?us-ascii?q?9a23=3AHhalQhExKcJAlmaCN2AsxJ1GYnJ96bzpIg4Y7I?=
 =?us-ascii?q?YmgLtSc6Oluo7vJ1Hb+e4w0A3SRYuO7fVChqKWqK3mVWEaqbe5+HEZON0ETB?=
 =?us-ascii?q?oZkYMTlg0kDtSCDBj1LfTCZC0hF8MEX1hgrDm2?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AoAABX99Bc/5JdJa1kGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBVAIBAQEBCwGBPVADgT4gBAsoCodNA48CSoINlySCUgNUDgE?=
 =?us-ascii?q?BLYRAAoITIzcGDgEDAQEEAQECAQJtHAyFSwEBAwESLgEBNwEECwIBCEYyJQI?=
 =?us-ascii?q?EAQ0NGoRrAw4PAQKkJwKBNYhfgiCCeQEBBYUIGIIOCRSBHgGLTReBf4ERRoJ?=
 =?us-ascii?q?MPoREAoM6giaNLIVohxmNFAkCggmSZYF/AZNRjB+UdAIEAgQFAg4BAQWBZSK?=
 =?us-ascii?q?BVnAVgyeCDwwXFIM4ilNygSmPegGBIAEB?=
X-IronPort-AV: E=Sophos;i="5.60,440,1549929600"; 
   d="scan'208";a="269658509"
Received: from rcdn-core-10.cisco.com ([173.37.93.146])
  by alln-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 07 May 2019 03:15:49 +0000
Received: from XCH-ALN-020.cisco.com (xch-aln-020.cisco.com [173.36.7.30])
        by rcdn-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id x473Fnn8015624
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 7 May 2019 03:15:49 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-ALN-020.cisco.com
 (173.36.7.30) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 6 May
 2019 22:15:48 -0500
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 6 May
 2019 22:15:47 -0500
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 6 May 2019 22:15:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector1-cisco-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcLtg9Lq3H1u2ZPx1vFp08nNfUh5T6wqgusaofLNVdQ=;
 b=Js1KxxfkCHyyiOZO5kjUxdX4ArMB1CoTrTFJbBf8tZL7PdQqsSBl7V1mXIT6MHAr9eDHY3JOa//xhmRJAPeVMQGPU2M4S/vEtfdb3wIao96DRw+7VsMaN7rqQWF8c++5Ehcg7BMI0/veaxQRU3H9Lad3Rjy1M1fjbs3BTHQYpc0=
Received: from BYAPR11MB3383.namprd11.prod.outlook.com (20.177.186.96) by
 BYAPR11MB3269.namprd11.prod.outlook.com (20.177.185.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Tue, 7 May 2019 03:15:44 +0000
Received: from BYAPR11MB3383.namprd11.prod.outlook.com
 ([fe80::b0ec:ad30:c80b:e94]) by BYAPR11MB3383.namprd11.prod.outlook.com
 ([fe80::b0ec:ad30:c80b:e94%3]) with mapi id 15.20.1856.012; Tue, 7 May 2019
 03:15:44 +0000
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
Thread-Index: AQHVBG1FwjU1WTeEMUumoWKXpb9bbKZe8vkAgAAKMLo=
Date:   Tue, 7 May 2019 03:15:44 +0000
Message-ID: <BYAPR11MB3383B74F06254EDA7157D314AD310@BYAPR11MB3383.namprd11.prod.outlook.com>
References: <20190505220524.37266-2-ruslan@babayev.com>
 <20190507003557.40648-3-ruslan@babayev.com>,<20190507023812.GA12262@lunn.ch>
In-Reply-To: <20190507023812.GA12262@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=fib@cisco.com; 
x-originating-ip: [128.107.241.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3345170-67b5-4000-31d1-08d6d29a4b01
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR11MB3269;
x-ms-traffictypediagnostic: BYAPR11MB3269:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB326964AF9D90E52091BD25F9AD310@BYAPR11MB3269.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0030839EEE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(366004)(396003)(346002)(189003)(199004)(3846002)(6116002)(229853002)(7736002)(76116006)(7416002)(6436002)(6246003)(66476007)(66946007)(66556008)(64756008)(73956011)(66446008)(2906002)(316002)(66066001)(14454004)(54906003)(2501003)(110136005)(86362001)(478600001)(55016002)(99286004)(186003)(9686003)(7696005)(8936002)(76176011)(71200400001)(4326008)(71190400001)(68736007)(53936002)(25786009)(81166006)(81156014)(8676002)(107886003)(256004)(26005)(102836004)(305945005)(33656002)(74316002)(558084003)(446003)(11346002)(476003)(5660300002)(52536014)(6506007)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3269;H:BYAPR11MB3383.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xf9x/x5x7U9vmwYTaz+4d4OmwoCFBmSkTCjoyBGtrqGMd8XKGMgT3n36nxHnke62BWO7l8Mmd2sjrYSIn3AYVODsEwmD46nW+hayNcWyTFDTj5Am4B10EJv68J3kdSflDsWF4WU5QCTUoIikbScDEJo6Kgv2wLdTxxf/6bY7FIrTNPmbDnOhvnGKNsEMhYI1wAqLECcYKcgamH4q43FhDSVpvkq/3Fxn37zWa/DlJwAvfjfhdGb9t+YpmO3emoVOxrRA+3kLWPiy7Gpdt+ypwAuux3uSdwhgkvePwoPUP22FLckM/3ge7P3VAUIgCeXN6Q/bDFgfWtl1aCXeErGIHW3if5iDPd5VM+0d/wIFfzAD+EtxRYk7ZCPFFzJx1TNhn6QNznBtqF8djUNgNtPEZUfeep/JplvwjA6paUL9rg4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a3345170-67b5-4000-31d1-08d6d29a4b01
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2019 03:15:44.3749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3269
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.30, xch-aln-020.cisco.com
X-Outbound-Node: rcdn-core-10.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
> As i said before, i know ~0 about ACPI. Does devm_gpiod_get() just=0A=
> work for ACPI?=0A=
> Thanks=0A=
>        Andrew=0A=
=0A=
It does.=0A=
=0A=
Regards,=0A=
Ruslan=0A=
