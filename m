Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37ADFAE18D
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 01:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbfIIXtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 19:49:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:35717 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730370AbfIIXtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 19:49:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 16:49:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,487,1559545200"; 
   d="scan'208";a="183979279"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga008.fm.intel.com with ESMTP; 09 Sep 2019 16:49:39 -0700
Received: from fmsmsx101.amr.corp.intel.com (10.18.124.199) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 9 Sep 2019 16:49:39 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx101.amr.corp.intel.com (10.18.124.199) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 9 Sep 2019 16:49:38 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.51) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 9 Sep 2019 16:49:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tnh76ADA5RgdZxOqPWiF418aAebRmiVurL6dcpNWZ0cHiPTt+iDfIGEE54LK6rRhNyyG4kljfre0s/pZuZbscqJx9jJoPZMWbiBHjvLjmE0f7YYeVdGKKz5mJg/gpIZozpj1QATvMdY9bJ2AaPuNCFvsweHm74t/ChNXRyT55Y4iMRxfiU6TYN9OzSTelX7ni+FBqZzjo/DKKcponr8np3ibutx+z8TONaKfdW6ckAjW9CG9239aVOqfPn2xdMsiboGKJ8aWJY1mFxJQRzpfV7Q4DxcoIrF71y9f5L64vzX3O2IrTJgyahDErK642y/S2NToLhkGQZMP2UzxrwZRZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqQiPORcT8U18EGmaIyZm+cG4MPpux9dcrDymWuynl4=;
 b=KHoYW59U6GafCIWHVFYOiKLn+mNXFC7JsHn3CfZNmRLUZAH750guhNHSAy7kvIiNbLD6YR8gZcCmYA6hvmX1IhFhmUeMW/8jabapxzB/4yBcqIyEGWN4Xc1tWRGGDIgMoU/eQCjxHX3iiPRTPTeGPspk0xbqzqT/OkcpzzyrJpK4fadVqFkAvYUbcWJmiOLOBfSZpAzxBALgohZrcE7butrj83suq7FPPJaAsagnyHyBDFmC5ZKawNSdIAaJ+QZYnPPkY8wBE/+xUnEm3W9ZPTXj6tF5CKg4rZLwuh0h1dRGS9m7Zu0JCTlb3uw4hnDxBVQzp9oW1IPGGTMw3/p4vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqQiPORcT8U18EGmaIyZm+cG4MPpux9dcrDymWuynl4=;
 b=nrIEkboXGhc8tRE7NG5mbcfddw7tHX1/on99vuOKitT48Dwz1Fce9ymycoY0O3XyAycpasPfCN40mRH/ifQBdTSpkzJwp8Qkf0gkUmRqdU3m0HeOc8RdN+4nfFLj6tx7XUum0b4zofYbiOyNXNZT7S8Ykb8e/QRp5R2o7VMhgBo=
Received: from BN6PR11MB0050.namprd11.prod.outlook.com (10.161.155.32) by
 BN6PR11MB4052.namprd11.prod.outlook.com (10.255.129.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Mon, 9 Sep 2019 23:49:37 +0000
Received: from BN6PR11MB0050.namprd11.prod.outlook.com
 ([fe80::a4e9:cc41:8ded:4c03]) by BN6PR11MB0050.namprd11.prod.outlook.com
 ([fe80::a4e9:cc41:8ded:4c03%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 23:49:37 +0000
From:   "Gomes, Vinicius" <vinicius.gomes@intel.com>
To:     David Miller <davem@davemloft.net>,
        "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "Patel, Vedang" <vedang.patel@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "kurt.kanzenbach@linutronix.de" <kurt.kanzenbach@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v1 net-next 00/15] tc-taprio offload for SJA1105 DSA
Thread-Topic: [PATCH v1 net-next 00/15] tc-taprio offload for SJA1105 DSA
Thread-Index: AQHVYasgWcMUawWtzkqtxe8Xm/RqoqcgRJKAgAPFHTA=
Date:   Mon, 9 Sep 2019 23:49:36 +0000
Message-ID: <BN6PR11MB00500FA0D6B5D39E794B44BB86B70@BN6PR11MB0050.namprd11.prod.outlook.com>
References: <20190902162544.24613-1-olteanv@gmail.com>
 <20190907.155549.1880685136488421385.davem@davemloft.net>
In-Reply-To: <20190907.155549.1880685136488421385.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjM0ZWM2M2MtNjViNS00ZGIzLWIwZTUtNWIzNzgxZTBmZDlkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWTJaN2pIUm1rN3dJb2VcL0F4elBSaWJ0VFhlRnlVeU01c1AwZU5EMDdqXC9mSlwvRk9EMWF4M0Y3ZW1TZms0UGxmQSJ9
x-ctpclassification: CTP_NT
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vinicius.gomes@intel.com; 
x-originating-ip: [134.134.136.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90882fa1-22c2-44d0-f1b3-08d735805f93
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB4052;
x-ms-traffictypediagnostic: BN6PR11MB4052:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB40526B97F4661721D890235886B70@BN6PR11MB4052.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(346002)(376002)(366004)(396003)(55674003)(189003)(199004)(66946007)(54906003)(2501003)(110136005)(76116006)(66556008)(66476007)(33656002)(14454004)(7696005)(3846002)(66446008)(6116002)(99286004)(64756008)(2906002)(7736002)(8676002)(7416002)(478600001)(316002)(74316002)(14444005)(86362001)(71200400001)(71190400001)(256004)(81166006)(66066001)(6436002)(11346002)(486006)(186003)(26005)(102836004)(476003)(446003)(4326008)(229853002)(305945005)(4744005)(55016002)(9686003)(8936002)(25786009)(76176011)(5660300002)(6246003)(53936002)(81156014)(6506007)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR11MB4052;H:BN6PR11MB0050.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gDaK901GPXT5fkRivH3r60+DdXO9TJTTO+cdeWzNRTSq8u9fX3dxGGfW8/VxnEM0sS0leerFyocrnaItLZKy1WDXfO4Qeo/Tzq/23Ql/FUEkxgVlOVKsxOp52gyw3S+JhP6xO0UsWsFrSd8UhG54MCUA64d0RmeWHdos6Ri517ASrOBliw+l6JdjzdSjScPOEyaCA0PGdyxCz5NhJDqiYbLd1iwUroD7OAhIu7jd8FfwCpnx6/v3C8sfrltCpN4f9M6UH7YaUe9/QsWKC8Hzt/tCnptRA9Flkt0WcZP4O5Ol3OWpL0Km7JCmUDJbdvVx9se+7saYnw6CKfn80SJ1+HVBZVLc+wItOd+QEj/vGFmtAdFvTws9tKXL+2gZacZ/B+V2RVheRyStXLdA/4gvVlkuxcN03i8BPv38+ljXK1w=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 90882fa1-22c2-44d0-f1b3-08d735805f93
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 23:49:36.6914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7IFP1U+5O8ar0ptA7STlxSAOSXgc+jwOyjpT0xhQBYdQBm6htcNgE3b5M1k1W2uyUe0DRwRF9JC6jg8NpVYsvzoxIZRHFfdLVQhfDbzSYaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4052
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> This is a warning that I will toss this patch series if it receives no se=
ries review in
> the next couple of days.

Sorry about the delay on reviewing this. On top on the usual business, some=
 changes to the
IT infrastructure here have hit my email workflow pretty hard.

I am taking a look at the datasheet in the meantime, it's been a long time =
since I looked at it,=20
the idea is to help review the scheduler from hell :-)

One thing that wasn't clear is what you did to test this series.

Cheers,
--
Vinicius


