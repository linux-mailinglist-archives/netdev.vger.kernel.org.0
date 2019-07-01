Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD82B5B8DD
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 12:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbfGAKT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 06:19:59 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:52604 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726076AbfGAKT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 06:19:59 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A43A4C122C;
        Mon,  1 Jul 2019 10:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561976398; bh=1QlwBCmFpAUv2XW87rQ3tryYxk8Y4ZSRdZNZC1mJwt0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=b8Tx8s5LDSqvXz//zD+oMmpWbcgbeqmr4xN2r+VXYsyxAykHC4BaDwYp1FZFpPk2y
         wvEomTH1vaDhtoBdfSCK8hTlanS1+KfTcwpIq1hILukCa+/PaJgUBk2h5RWux2/Y7p
         Fcuo5UQW63BYcUd1P8rrK2rwiuKOxVPdLk3PExGjFx49+ctSsnEneZWoLePKySe1vP
         oSRQwcN7bWk4YeuzdJX3NpV8nv4PUZSoLNXzpS4zkJpLHeFsKxaMNTZA5Kn9TWUrdh
         sVa5Sl+3JM6u2iDaTtdVAnsAoLeZeadYZJIKw4C8mzLsqYHkA/kRmIVJ8t1RR3UVA5
         LPQl+2ASXUylA==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 5B9F9A0067;
        Mon,  1 Jul 2019 10:19:58 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 1 Jul 2019 03:19:57 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 1 Jul 2019 03:19:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QlwBCmFpAUv2XW87rQ3tryYxk8Y4ZSRdZNZC1mJwt0=;
 b=lxHJJNBA8NevcWGZLc/H7JqNL3MUShuajHmeJnAeoU8eZUsV6zPZhh7as8u8oHCHOECCw8yu8e65/IZtuXbOYx/TcteJDqqFLMY/I8GnIMEhw0nCMR5+1mHX6bThfb+vbgVu8F/D4gWAtMWqLckRim0xTkyi2EKK5rfPlgkXMWM=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3249.namprd12.prod.outlook.com (20.179.66.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Mon, 1 Jul 2019 10:19:56 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 10:19:55 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     David Miller <davem@davemloft.net>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>
Subject: RE: [PATCH net-next v2 00/10] net: stmmac: 10GbE using XGMAC
Thread-Topic: [PATCH net-next v2 00/10] net: stmmac: 10GbE using XGMAC
Thread-Index: AQHVLYNK1lmnq+s43E69mlApv5Y1IKaxQNSAgARQQxA=
Date:   Mon, 1 Jul 2019 10:19:55 +0000
Message-ID: <BN8PR12MB32662DA0B5733E93D88E7D7DD3F90@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
 <20190628.092415.219171929303857748.davem@davemloft.net>
In-Reply-To: <20190628.092415.219171929303857748.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6e37b29-0aa2-427d-99d7-08d6fe0da9ff
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3249;
x-ms-traffictypediagnostic: BN8PR12MB3249:
x-microsoft-antispam-prvs: <BN8PR12MB324971304A3A25C928BED911D3F90@BN8PR12MB3249.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(376002)(39860400002)(366004)(76094002)(199004)(189003)(4326008)(2501003)(6436002)(55016002)(66946007)(66476007)(66556008)(64756008)(66446008)(73956011)(5660300002)(2906002)(53936002)(6246003)(9686003)(52536014)(316002)(25786009)(86362001)(558084003)(446003)(76116006)(229853002)(54906003)(33656002)(6636002)(26005)(102836004)(186003)(486006)(11346002)(110136005)(476003)(8936002)(8676002)(81166006)(478600001)(81156014)(99286004)(7696005)(6506007)(76176011)(256004)(66066001)(14454004)(68736007)(71200400001)(74316002)(6116002)(3846002)(71190400001)(305945005)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3249;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9GIMFJ6bBUn2J3PwkOICONqvoh9eNisLum5KpkcuzFbn4cY+a6TGrgqYexehIvfBY0E7iFuMEOj4+PiPl1p7XLXixSQUq701KVRBKg9y118Y6YfLU0FS9QQ6f+0B20GdvQi3aeFIeTmIfSA8r1/7NPo/dAgyWR/y/ZcCu2fVYUi24UbO1r14tjZnZW+mfc0eOTGYPcOkJa4qHOpdzVLYy4QcF1Y3JFcMVzMkZZAVbOk18gLMksEIkQ3NhTiNdresAp469RdshppB3oaOeyXr8F63ACtshnJSMp5yE9wgHDuf/eVozrbZ+aNAjYdG2fp8r5/xMAa3SCsY2HKHTmoeFr+wLnizUPW0EpEjnVC95B8WmYbhr2gzTeehhDTGVtnbVws6tKjc9cD63oxLIds5cVgf8+fF+VMe+NWcbj98VCo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e37b29-0aa2-427d-99d7-08d6fe0da9ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 10:19:55.8455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3249
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>

> About the Kconfig change, maybe it just doesn't make sense to list all
> of the various speeds the chip supports... just a thought.

What about: "STMicroelectronics Multi-Gigabit Ethernet driver" ?

Or, just "STMicroelectronics Ethernet driver" ?
