Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 178CE58393
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfF0NeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:34:08 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:47368 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726431AbfF0NeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:34:08 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 234ADC0AF9;
        Thu, 27 Jun 2019 13:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561642447; bh=CvUvd+BwvFXn36qikg39gOxbIOlHyYMYLATw7osbcGc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=epltGH4RnYMkL+UJTtumeugXlHPkB+h6JhBH242A2u280bCtMRWlcGlgcOaX3R8Dn
         jNruu+CNe+6z+m1p4+LexNyrc/+QQGOfa9+z+3/csOdBUHGfHqTt2P96QIu+spiAZP
         Ch0dC/yH8CNTZphK67UgKM9P80+FPupgj2h5FMcfmjH0kEKZX2C0YRuuFRAePn3G0Y
         ZJWAt+Pv0//GdMii/87l/6TEitr+PADUDxsK5OKPN9v4w1dT45btZyKSMwmMLcXamO
         rxUtFPIRzDWoVEIryobfCJtOzO5XBXll9CyniE4nCoJfNokXKv5m3HTSQZ5+RsKEP7
         uivdM17WLUaUg==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 69E5FA0093;
        Thu, 27 Jun 2019 13:34:03 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 27 Jun 2019 06:34:03 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 27 Jun 2019 06:34:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvUvd+BwvFXn36qikg39gOxbIOlHyYMYLATw7osbcGc=;
 b=q5Bp8r6Cr+a96mkhmYRxa59S9/SHQl+QFJNI5heZ6WEnznkSPkzpOedKbXJirNi4MRsOXy6s0QkSukb1gk2M27H/6juraTYBMUUqZHwNoKASDqyQM+8WlZIYizizbrjaIhg5LMZJBYvLaQkGbdj2rbIA5ky/jGMiBPewVze6Bt0=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3107.namprd12.prod.outlook.com (20.178.210.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 13:34:01 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c922:4285:22a6:6e]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c922:4285:22a6:6e%5]) with mapi id 15.20.2008.018; Thu, 27 Jun 2019
 13:34:01 +0000
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
Thread-Index: AQHVLCXCrx1niaeCs0CBNlrs4Af9k6auOg4AgADniCCAAF0vAIAAAOYg
Date:   Thu, 27 Jun 2019 13:33:59 +0000
Message-ID: <BN8PR12MB32666DADBD1DD315026E9A2BD3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
 <c7d1dbac1940853c22db8215ed60181b2abe3050.1561556556.git.joabreu@synopsys.com>
 <20190626200128.GH27733@lunn.ch>
 <BN8PR12MB3266A8396ACA97484A5E0CE7D3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190627132340.GC31189@lunn.ch>
In-Reply-To: <20190627132340.GC31189@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30677112-0130-4eee-6d09-08d6fb041db2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3107;
x-ms-traffictypediagnostic: BN8PR12MB3107:
x-microsoft-antispam-prvs: <BN8PR12MB310759607AE8A4933E3222ACD3FD0@BN8PR12MB3107.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(396003)(346002)(366004)(189003)(199004)(102836004)(6506007)(446003)(26005)(52536014)(68736007)(256004)(99286004)(476003)(14454004)(11346002)(186003)(486006)(76176011)(7696005)(305945005)(71200400001)(8936002)(71190400001)(8676002)(81156014)(81166006)(6636002)(7736002)(5660300002)(55016002)(86362001)(74316002)(6116002)(6246003)(4744005)(2906002)(53936002)(3846002)(9686003)(229853002)(4326008)(110136005)(54906003)(66066001)(316002)(66476007)(66556008)(76116006)(73956011)(66946007)(6436002)(66446008)(25786009)(64756008)(33656002)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3107;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Rn8mO7ZmyjEXQawMsLWySETkQOwhSg5Nyz/DhtTjRPGW+0M679lQrNG9l09eGfAIMcRPRSj9+fTFbcWqQoKaPf/nsrfwXiNPi8WyV8G+t+LNo7zxOO1vItf5k1NqGHHgtEwZviyEHBtxQ7VtXQpDZ/z15j4SWTlgM+cnn87igtb8i9fvwHCeYlQw8eRKV49kx6drsom7zm+CO3vrQH9Arkr3d/tzgjKR9Ifhx9VNSGaigBIwZJ4SQoDAs6XuIoBfVTwdJ7bh4L2sZxKmgR1a2AsLbzxOpaGcZV/egPxaxGbLpdkxae8C/9xGXHR8AD4zGXCJUD96anNirABs5hB7dNjZUGxvYRJzcbgZzO+uaQqOGoDpsV905Ts4TAWg75nm8yjeoFmgGjywerePQ7X/oZyc4phlSqTrizDUSebbpQk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 30677112-0130-4eee-6d09-08d6fb041db2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 13:34:00.5593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3107
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

> There have been some drivers gaining patches for ACPI. That is
> probably the better long term solution, ask ACPI where is the PHY and
> what MDIO protocol to use to talk to it.

Hmmm, I'm not sure this is going to work that way ...

My setup is a PCI EP which is hot-pluggable and as far as I know ACPI=20
has only static content (????)
