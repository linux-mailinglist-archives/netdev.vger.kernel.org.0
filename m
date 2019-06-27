Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF3C57D82
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 09:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfF0HyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 03:54:22 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:58774 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725787AbfF0HyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 03:54:22 -0400
Received: from mailhost.synopsys.com (dc2-mailhost1.synopsys.com [10.12.135.161])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 68E25C00B1;
        Thu, 27 Jun 2019 07:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561622061; bh=e6e2VhfxTqjfagQbFWP/4/+TtGDJvZ5Z6cJYZFfpW8g=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=EVCXij4l+Kw8xQZQJzzMcp0aVNIFtcEvIA1kq/uEf9uaJde0zlzxtICOKDhODxM24
         kH8xr1T1nUXGfZDHxVvtUg/N+XV6Dl9G8xKUOsZtAtr7YZtnBP6uhmlP1iQAZ0vUdn
         4j7/iMwS8dhf4rWA1hKVScVZEExJkdurrUvYc2KuCeOWvrypVTT8qLjkZcTEajPy1F
         C6bzuZ5QMB8BIaMHQhwdmy0YUDFCFSGSZihKrTVZOoNmMh9c5icIOgR+Jp9Y1LCH1f
         o5NDCmjcXl4NjhB/TwJ5pPWnRuMfXUvjXBv4qZ0sHh0rwzvsIwi/3DeQQFmrlcM55/
         PzyjR+3xCUcPw==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C3751A0098;
        Thu, 27 Jun 2019 07:54:17 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.235) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 27 Jun 2019 00:54:16 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 27 Jun 2019 00:54:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6e2VhfxTqjfagQbFWP/4/+TtGDJvZ5Z6cJYZFfpW8g=;
 b=ctMtitg+sIuo0F9vgJANGK74W7iXmzZXeMCXswaIRD+H3xTEaRcrnXMKW7UjJUPmLGKJ76Gb/yO0hbXyB6veVT9sT6Df29YpbpQs1a5oEfkKjFbkQpK0h5aqtJGs3TopxS0owYNig10rTY2fwGRlmDxwk/znGVyCDv4ymthabEw=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3154.namprd12.prod.outlook.com (20.178.223.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 07:54:14 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c922:4285:22a6:6e]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c922:4285:22a6:6e%5]) with mapi id 15.20.2008.017; Thu, 27 Jun 2019
 07:54:14 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: RE: [PATCH net-next 10/10] net: stmmac: Try to get C45 PHY if
 everything else fails
Thread-Topic: [PATCH net-next 10/10] net: stmmac: Try to get C45 PHY if
 everything else fails
Thread-Index: AQHVLCXCrx1niaeCs0CBNlrs4Af9k6auOg4AgADniCA=
Date:   Thu, 27 Jun 2019 07:54:14 +0000
Message-ID: <BN8PR12MB3266A8396ACA97484A5E0CE7D3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
 <c7d1dbac1940853c22db8215ed60181b2abe3050.1561556556.git.joabreu@synopsys.com>
 <20190626200128.GH27733@lunn.ch>
In-Reply-To: <20190626200128.GH27733@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c87a89e-03ee-4a77-d368-08d6fad4a647
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR12MB3154;
x-ms-traffictypediagnostic: BN8PR12MB3154:
x-microsoft-antispam-prvs: <BN8PR12MB315449D5F2AE02B6C4818A26D3FD0@BN8PR12MB3154.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39850400004)(396003)(346002)(366004)(136003)(199004)(189003)(6636002)(81156014)(5660300002)(52536014)(6116002)(478600001)(66556008)(64756008)(66066001)(66446008)(3846002)(486006)(256004)(71190400001)(71200400001)(6246003)(25786009)(9686003)(8676002)(55016002)(81166006)(8936002)(11346002)(446003)(476003)(6506007)(74316002)(2906002)(99286004)(14454004)(102836004)(26005)(76176011)(4326008)(76116006)(66946007)(73956011)(66476007)(186003)(86362001)(4744005)(53936002)(7736002)(7696005)(229853002)(305945005)(316002)(54906003)(33656002)(6436002)(68736007)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3154;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wGRSFiiR0wxpKjB5C/t1gDp0Xp/XovthilGPsjmEumIWfc8lts4ZbiOp84h3gNBM3axDaL2y+ld6ddv/CihlB3BGlxWh6mgNjgV/Xd52XO40h9n1a17fptLMogJtem/ZswB7mZTOwYWFlEL9MskMku9c4wkH9m6TjyVKOTmAY2hCSt/Rc4VmO86oi9NULyHT5p+lLl+sWbv8bn4c+eqVR+NPr8ARuFkrWUtYcy45nrCYF9lGrlU5ZufWQXQS5xEBTlDA5tA6FvYku86DIjBVnTovvU8pcTj6Myn43T929lBOUvfEVpVh0Q5Nme8oY771X4PtQxNd7+V3aqHlpcLQ3xjJ7FOwri9mSVr5yoNteQeUM43q1LpcXDqvPSJqPIwfBAgyt44YndhnXIKi8Iqme2BezizVwyfgHtB6JF1nb/E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c87a89e-03ee-4a77-d368-08d6fad4a647
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 07:54:14.8400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3154
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

> On Wed, Jun 26, 2019 at 03:47:44PM +0200, Jose Abreu wrote:
> > On PCI based setups that are connected to C45 PHY we won't have DT
> > bindings specifying what's the correct PHY type.
>=20
> You can associate a DT node to a PCI device. The driver does not have
> to do anything special, the PCI core code does all the work.
>=20
> As an example look at imx6q-zii-rdu2.dts, node &pcie, which has an
> intel i210 on the pcie bus, and we need a handle to it.

That's for ARM but I'm using X86_64 which only has ACPI :/
