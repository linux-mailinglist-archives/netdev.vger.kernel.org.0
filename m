Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEF119ADC0
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733014AbgDAOXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:23:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:10050 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732877AbgDAOXN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 10:23:13 -0400
IronPort-SDR: b7SlJNjhIudv47BzUnscxsnsgEcoxd4elLqeOn0i7xSXaEO7IVMMu3jHM0UKw4flAi1j/AeaDc
 3iwOAVMgQkbQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2020 07:23:12 -0700
IronPort-SDR: LmcL1CE6cW4D3pp6JEBGukpeTc+7I4iMCpK77ood2qgULsMxVrjJXCpPollYbT9cn6otDgzJne
 K9Xr2M2L4GIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,332,1580803200"; 
   d="scan'208";a="284423713"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by fmsmga002.fm.intel.com with ESMTP; 01 Apr 2020 07:23:12 -0700
Received: from orsmsx113.amr.corp.intel.com (10.22.240.9) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 07:23:11 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX113.amr.corp.intel.com (10.22.240.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 07:23:11 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.59) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 1 Apr 2020 07:23:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NudJle/IORgOk9jkWe1IWNi14DKZ3IXxU5rmUWmYwzdmbBFl23k8TI1R45wv9JDEFpS6+CiMSU5c/C3fe9pcPFSTRGMccoztVeX0P/J9uEEphYH/VhJOLVxYsBzJ5vxq17uA5E6Q08XYb6+H9n6gKgSAM2a2K0REUlY8OKMEQmeQF7wfWJDUXE0mvbR+RyqnLBCc/bgiMYAkdaKq2pdB3MIwQixT+s0mbHrHg7TKb2Pm1HfT6NpHiaW8xTmaBBQCGT2zL5F8T4hMqnNVZLH9aLmJLItJHNX6y2TZlyvA1xGH3LkbHAVEQ2dR6f192JdiBQJrAC8nyfYZELV3dlbFCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1EpgSNIDbbbDV8mBgHJSif/96xENPXEkgFSIGtGe4s0=;
 b=OnTrPkzppR/lBupHirBMRfIFFanZKL0gITBX4M8uXxsiwsbKy2gIhwHpWnq3wLmDeTkzav2w6fXiJOAxoifd2yhp+bv4K/T3eYdcx8pJbxdRQYnzdx/amoVdWnlXuzkVjuT8YnnEUq48GV7aSI/mdXJ97Eh8sXuhRVrgnyUmqiFOZwB5MpYlefvd6S3rha9dODUuKc1ssrxzILUiWRsWkNci6evun9uXCqWJ1fbtf5UCI+Sfjxmn1jUuUZB/7Fsm4qMcSfKLcJavmNQMQLo2ApT95eAVg9QTyTOTf6D5sMVezrXxdVkrLXY1H6WFF4JRU42rhxFX3Z92+Dvso8VQDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1EpgSNIDbbbDV8mBgHJSif/96xENPXEkgFSIGtGe4s0=;
 b=K/6oqP+NgfCJoXlJxpGU6OLVEEufOlnTHrf+1FJBJF2C2KnAbFrxbw+HQb8vLPSGhcRn43SvC+MeQOZDAnleeoYr0XolJKfNPFXtPJgYIhK5Er4B/dqk+hc4y704AFggW9wJTkEXf3d2wquSW4avKJcoyZGQJ2JPolzA0kybrLw=
Received: from BYAPR11MB3125.namprd11.prod.outlook.com (2603:10b6:a03:8e::32)
 by BYAPR11MB3111.namprd11.prod.outlook.com (2603:10b6:a03:90::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 14:23:09 +0000
Received: from BYAPR11MB3125.namprd11.prod.outlook.com
 ([fe80::c27:87cf:ca4:d86e]) by BYAPR11MB3125.namprd11.prod.outlook.com
 ([fe80::c27:87cf:ca4:d86e%4]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 14:23:09 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [RFC,net-next,v1, 1/1] net: stmmac: Enable SERDES power up/down
 sequence
Thread-Topic: [RFC,net-next,v1, 1/1] net: stmmac: Enable SERDES power up/down
 sequence
Thread-Index: AQHWAE0vpBWvWDPaGkGozDEPMDm2A6hVzcSAgAAFr0CAAAz8AIAAbqEwgA4QMGA=
Date:   Wed, 1 Apr 2020 14:23:09 +0000
Message-ID: <BYAPR11MB3125359A86ECE3A845595E3888C90@BYAPR11MB3125.namprd11.prod.outlook.com>
References: <20200322132342.2687-1-weifeng.voon@intel.com>
 <20200322132342.2687-2-weifeng.voon@intel.com>
 <BN8PR12MB3266ACFFA4808A133BB72F9DD3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BYAPR11MB27575EF05D65A8AA9AF4128488F00@BYAPR11MB2757.namprd11.prod.outlook.com>
 <BN8PR12MB326606DE1FEB055B7361A939D3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BYAPR11MB2757B80101035B9A599E357B88F00@BYAPR11MB2757.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB2757B80101035B9A599E357B88F00@BYAPR11MB2757.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=weifeng.voon@intel.com; 
x-originating-ip: [192.198.147.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd9a9c2f-4101-40f1-a3fb-08d7d648344b
x-ms-traffictypediagnostic: BYAPR11MB3111:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3111F41AA0D0597CE5E4F57E88C90@BYAPR11MB3111.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(396003)(366004)(39860400002)(376002)(136003)(346002)(55016002)(81156014)(478600001)(107886003)(6506007)(86362001)(316002)(71200400001)(9686003)(8676002)(81166006)(33656002)(2906002)(52536014)(5660300002)(7696005)(54906003)(66446008)(66556008)(66476007)(66946007)(4326008)(64756008)(186003)(110136005)(8936002)(26005)(76116006)(142933001);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FmuO8oB/LU5uDlXrgNtK4Vur8EXknHZkVocI8+j664jtP22O3E7m4CmM2r0cNC2PqHLHCT+kaR79ZfojjN7t/wE/FWfQtKgaY0RsXCjfM/uyoCu057DvKCQBZn7l4jUTcjwBAZRaWW5la9O686oWcBK6YoSUXy7C7H6+WDW87JGdwRMuquEil+LNjtrAzglfXUWrgjdO1MbBbPhLtUtHDpYqBQU0/yixy1Nl3HFtqhxudg1B1sdOv81+nZ4KBgnfE03lLeJLPUS5JU5jzed642j1BZtBIb2Mc8j6Jd5+lkQSzgc6TW9Hxos7avMUUdxaZohn5B5J1JTlBzutkWoa1xB8ISdsB+e+AuZy5ViqCPo1Kgh56w4Ibd0CUF0DSvu+UR8R7FmC8T/v2sSkHwD9g+IwOIGfWzomcsahZHkqtmgGqGdaCQfgJ2JSbFfk+bMlObMzMIGUrIyXE2P8YX3nAlylV1gUzcFfqmzq00HbT6KN6zS8Ou1w29CBqh90S4K1
x-ms-exchange-antispam-messagedata: 1YbjYCTmblqYxSXIjitcwiBUhBnrewW9aV1TXRdEhpSpJspFd0fFkQz0LJzcKOuGuZXNXKGUWJLuBt39O1+lOebITLy1r7fTJo/4b/GPnpJKW6yaLJcLLYCQxEhzs/SuuRBZu9csH0yP+fXjQ7ElMg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9a9c2f-4101-40f1-a3fb-08d7d648344b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2020 14:23:09.8207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5JTBYQlnP1lwo6bGM5lbBGXynEe1/E1fAhC3JUCgPGtFe4MG1wjJgNHPMj8Y8T9PIC1wVzmmUPrimhH1JHMqpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3111
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > > This patch is to enable Intel SERDES power up/down sequence. The
> > > > > SERDES converts 8/10 bits data to SGMII signal. Below is an
> > > > > example of HW configuration for SGMII mode. The SERDES is
> > > > > located in the PHY IF in the diagram below.
> > > > >
> > > > > <-----------------GBE Controller---------->|<--External PHY
> > > > > chip-->
> > > > > +----------+         +----+            +---+           +--------
> --
> > +
> > > > > |   EQoS   | <-GMII->| DW | < ------ > |PHY| <-SGMII-> |
> External
> > |
> > > > > |   MAC    |         |xPCS|            |IF |           | PHY
> > |
> > > > > +----------+         +----+            +---+           +--------
> --
> > +
> > > > >        ^               ^                 ^                ^
> > > > >        |               |                 |                |
> > > > >        +---------------------MDIO-------------------------+
> > > > >
> > > > > PHY IF configuration and status registers are accessible through
> > > > > mdio address 0x15 which is defined as intel_adhoc_addr. During
> > > > > D0, The driver will need to power up PHY IF by changing the
> > > > > power
> > state to P0.
> > > > > Likewise, for D3, the driver sets PHY IF power state to P3.
> > > >
> > > > I don't think this is the right approach.
> > > >
> > > > You could just add a new "mdio-intel-serdes" to phy/ folder just
> > > > like I did with XPCS because this is mostly related with PHY
> > > > settings rather than EQoS.
> > > I am taking this approach to put it in stmmac folder rather than phy
> > > folder as a generic mdio-intel-serdes as this is a specific Intel
> > > serdes architecture which would only pair with DW EQos and DW xPCS
> HW.
> > > Since this serdes will not able to pair other MAC or other non-Intel
> > > platform, I would like you to reconsider this approach. I am open
> > > for
> > discussion.
> > > Thanks Jose for the fast response.
> >
> > OK, then I think we should use the BSP init/exit functions that are
> > already available for platform setups (.init and .exit callback of
> > plat_stmmacenet_data struct). We just need to extend this to PCI based
> > setups.
> >
> > You can take a look at stmmac_platform.c and check what's done.
> > Basically:
> > 	- Call priv->plat->init() at probe() and resume()
> > 	- Call priv->plat->exit() at remove() and suspend()
> >
> I have 2 concern if using the suggested BSP init/exit function.
> 1. Serdes is configured through MDIO bus. But the mdio bus register only
> happens in stmmac_dvr_probe() in stmmac_main.c.
>=20
> 2. All tx/rx packets requires serdes to be in the correct power state.
> If the driver power-down before stopping all the dma, it will cause tx
> queue timeout as packets are not able to be transmitted out. Hence, the
> serdes cannot be power-down before calling the stmmac_dvr_remove(). The
> stmmac_dvr_remove() will unregister the mdio bus. So, the
> driver cannot powerdown the serdes after the stmmac_dvr_remove() too.

I went through the code again, I understand that your intention is to keep =
the
platform specific setup in its own file and keep the main dwmac logic clean=
.
But, I did not see any way to separate this SERDES configuration from the=20
stmmac_main logic cleanly.=20
Hope to get more ideas and discussion. Thanks.

Weifeng

>=20
> Regards,
> Weifeng
>=20
> > ---
> > Thanks,
> > Jose Miguel Abreu
