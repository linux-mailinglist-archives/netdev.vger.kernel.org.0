Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E256B8FB
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 11:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfGQJMF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jul 2019 05:12:05 -0400
Received: from m9a0003g.houston.softwaregrp.com ([15.124.64.68]:42927 "EHLO
        m9a0003g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725873AbfGQJMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 05:12:05 -0400
X-Greylist: delayed 936 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2019 05:12:04 EDT
Received: FROM m9a0003g.houston.softwaregrp.com (15.121.0.190) BY m9a0003g.houston.softwaregrp.com WITH ESMTP
 FOR netdev@vger.kernel.org;
 Wed, 17 Jul 2019 09:12:03 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 17 Jul 2019 08:56:05 +0000
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (15.124.72.14) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 17 Jul 2019 08:56:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/azBZpOMhvggf67LnYGV5mH4OwYEgDdKWP69l7TbYNOXPBw8q0uJrYboUeSp77WnShiFXTQldIAXpY42DRC+9m7Q4YjVyoAuNky21BL6b1E9KiXt+gbS2XmJjrVnafm0s0put38tJCC4fuNF5xPFTrqLnaMEjKUbyFki1n2fhM2uqwV9pVEjPQh9AmURNyu1olam+q1eEq9DevOvsiE0JwDcmQG4SEk556THtUN8UDKdlov08ze5YkZ3ChwlfpYpNZMf5eopiV6ZtHuKHt4oJyQ2fL8c+ZY6TYefKbW4mqLyq35a+gBLHGN992fmosKT+0Sfi5NL4QbEC3AUXOwBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxG/sHwf8Iaorw92l0kWemUEbW7m/zuFf6H4OltSUP4=;
 b=W9ZC/mK/Bg7QAG3KCnrJgpiFpVpLqwXbuXlbEc6r0iynZDnkOZWCk8Ieki5816pD8midf2c4RszDCI5I/rIgzKt2zTaSBP6gCNvRTV1kNgABrFl4yp95mcx3k+ZCO5dw8FU+/hr4BfdRvoFa88XRxBKLBfxCQzh0cy21i5ZhNcPRI3VQtzqBSui/J6r5MYcKse2uu5xo87C6cWrKBttfKLe4ZBPEQyAq5KdlJG0WMl6r2fVOfyUCF8GH4yQpxWNZQwUxbEeis0ed9icVnZ5oiKUHRI5dv7234q21w5E6i5cWY0lO9j1BLnp9VIvkny2fBsX6GJEgjqN0YZEDHj2pLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=suse.com;dmarc=pass action=none header.from=suse.com;dkim=pass
 header.d=suse.com;arc=none
Received: from CH2PR18MB3189.namprd18.prod.outlook.com (52.132.244.203) by
 CH2PR18MB3112.namprd18.prod.outlook.com (52.132.231.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Wed, 17 Jul 2019 08:56:04 +0000
Received: from CH2PR18MB3189.namprd18.prod.outlook.com
 ([fe80::2053:cdc8:d81c:a5d6]) by CH2PR18MB3189.namprd18.prod.outlook.com
 ([fe80::2053:cdc8:d81c:a5d6%7]) with mapi id 15.20.2073.012; Wed, 17 Jul 2019
 08:56:04 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     Benjamin Poirier <BPoirier@suse.com>
CC:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] be2net: Signal that the device cannot transmit during
 reconfiguration
Thread-Topic: [PATCH net] be2net: Signal that the device cannot transmit
 during reconfiguration
Thread-Index: AQHVO67z2A6t0cO8nkSyQhUeM2Az8KbOMBQEgABKiSaAAAY7iA==
Date:   Wed, 17 Jul 2019 08:56:03 +0000
Message-ID: <CH2PR18MB3189AD09E590F16443D8D5BA88C90@CH2PR18MB3189.namprd18.prod.outlook.com>
References: <20190716081655.7676-1-bpoirier@suse.com>
 <CH2PR18MB31898E033896F9760D36BFF288C90@CH2PR18MB3189.namprd18.prod.outlook.com>,<20190717082340.GA6015@f1>
In-Reply-To: <20190717082340.GA6015@f1>
Accept-Language: en-US, en-GB, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=firo.yang@suse.com; 
x-originating-ip: [45.122.156.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19b15cfb-0435-4191-32e9-08d70a949953
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR18MB3112;
x-ms-traffictypediagnostic: CH2PR18MB3112:
x-microsoft-antispam-prvs: <CH2PR18MB31125C53ED49630C4F18BCC388C90@CH2PR18MB3112.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(189003)(199004)(5660300002)(229853002)(6636002)(6506007)(6436002)(54906003)(8936002)(76116006)(478600001)(52536014)(76176011)(74316002)(7736002)(486006)(256004)(316002)(476003)(11346002)(446003)(7696005)(14454004)(53936002)(66066001)(71190400001)(55016002)(25786009)(558084003)(305945005)(71200400001)(68736007)(44832011)(4326008)(66946007)(2906002)(99286004)(6246003)(26005)(33656002)(9686003)(81156014)(3846002)(8676002)(81166006)(6116002)(186003)(6862004)(66556008)(86362001)(66446008)(102836004)(66476007)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3112;H:CH2PR18MB3189.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /XJcncG1DFdVN/r5Do+SS5N1+26CfxfUd+HfeY+asej5LtGfV+FT+nJ15uR+yYXvwXLga5EcLJklCbBC1+WjBCZ5SWfUGWDnp5xIvt1DuBXb8Xv80HCE3t4Qz6g6SDu0VKspAlXFCd29ixGlwoTjnsD8I11F5Dy3IejjLbXX02/bVENZyArZp0HJsErvcFr1sV9Qv8PvSKkrRLxoOT88xPKtv7byVs0coTKggkPacKnX+CAuv81qQ6WGpsIE5gK2FOS+Uf45QNrKaD5qpdPd5u0/qHZRSISsHflIFDgOz3bLeoCndVfHskJr6atmIUGb1Sm3bfIVzTBs1SIG3VopdoA9TAQ5XNjr/n/q4inf4mB9cCa+J3a63kExT9eCmZCEWrZ8GR7BTP3Fp5Kv/fOyBL/tjqOdfNLxZxeCUKs9pWE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b15cfb-0435-4191-32e9-08d70a949953
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2019 08:56:03.8619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: firo.yang@suse.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3112
X-OriginatorOrg: suse.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I don't think this change could fix this problem because if SMP, dev_watchdog() could run on a different CPU.

Thanks,
Firo
