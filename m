Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE95C18F8F8
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 16:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgCWPwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 11:52:40 -0400
Received: from mga04.intel.com ([192.55.52.120]:33100 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbgCWPwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 11:52:40 -0400
IronPort-SDR: Bxk3l/nacJ/MImTZcSDX38v7uiprxwhT3vakDEs8hUYUAVizZ5Gi96pIoaNYMAoj2i6Uwr09m7
 JgjQRN0XMGxA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 08:52:39 -0700
IronPort-SDR: qdgVt2/8/RiYVSkmoIPLI02uvi7BFx1td0EGptt4/GDQ6Pn5ouFZ4JQ/vgHSWY2HKNYvXPEard
 nn8Pofm1rp3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,296,1580803200"; 
   d="scan'208";a="325610672"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga001.jf.intel.com with ESMTP; 23 Mar 2020 08:52:38 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 23 Mar 2020 08:52:34 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 23 Mar 2020 08:52:33 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 23 Mar 2020 08:52:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 23 Mar 2020 08:52:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZuXiPUNBLNeLCWHdxUMszbEOYf8aI9C0RZXWrPfhqgHhQ8qaWvtFrTiPRWbPYkcXY6OF/nexTPLnnks+Li9ZPXQipES/AtoHiTx4sBmiSCHZ7kIqs/2l03N+ROhdhScXkFEGSu9iW9D8mRmbHBRIZV/zv85nhHG9izSs7ld0/jaakiZ9cn+WVlZlII24jmRYa/LE93Tbq0D5K0GMh2rBZev2qmJPDGJIiiUIxiICb8QCQga/yY6zN4hwtwz2rj90WRjlDI/dAdQi/0NZJTrSyC96eZ+68eWInNXnme0v6U6h7Ks1T685EP6ZuFUKCUvk4kJFNTHrFJ6It9ckGenXHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NbG25fPmN6j9cr+i/Z3VOKaKxitNL0V+BRRKst/0fU=;
 b=aB7BaxLbk0Zk+6a/bx2UcHQLMHsSkBbX0KMqV+igdBLI2P/4R61thDurmnjput0rlj48JWHe8BEY3OOHy7w39S8A88lBZds6d86AulZMseC1Eri2nwCB8PkG9ibhyrZ1RdiWJQlm/Q7LwcT8pjSHTw5+2HTpTys025iZQ8MTNgiGlVDzf0Oq1CzcKAkBiCLbvjuZDQWAgxQvC1NANFakLYUyWm4SaQaaYB/S4QtDcZGZWSHL0OpzYH5T5y8jUdG+zlFlqPB2SE/sD46Ib4XOiqWkxpfo1Bey2HskZfXnyN7RMS5wVe0y/OFubQhuwUyaL/jShTX2wE5PIeDrg55CbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NbG25fPmN6j9cr+i/Z3VOKaKxitNL0V+BRRKst/0fU=;
 b=s/jaXPvnKA6bAEcmWB/X4ly9OyT3oHWmrDWTG6LAJCtxmxfTRjYKqyaWgfKlhOcN+FdqDY9YtL+80HOwC+Pi9xNAFneWfTJxK56ZbFr6fwBhdnX7AqTyBfLsTL6QyzyomCF5s1IHjtRk2BJlQjmZ9F7Uca1j4iq+qzOEsJU/pJ0=
Received: from BYAPR11MB2757.namprd11.prod.outlook.com (2603:10b6:a02:cb::16)
 by BYAPR11MB2615.namprd11.prod.outlook.com (2603:10b6:a02:c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19; Mon, 23 Mar
 2020 15:52:13 +0000
Received: from BYAPR11MB2757.namprd11.prod.outlook.com
 ([fe80::f8aa:496b:6423:f5fc]) by BYAPR11MB2757.namprd11.prod.outlook.com
 ([fe80::f8aa:496b:6423:f5fc%4]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 15:52:13 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [RFC,net-next,v1, 1/1] net: stmmac: Enable SERDES power up/down
 sequence
Thread-Topic: [RFC,net-next,v1, 1/1] net: stmmac: Enable SERDES power up/down
 sequence
Thread-Index: AQHWAE0vpBWvWDPaGkGozDEPMDm2A6hVzcSAgAAFr0CAAAz8AIAAbqEw
Date:   Mon, 23 Mar 2020 15:52:13 +0000
Message-ID: <BYAPR11MB2757B80101035B9A599E357B88F00@BYAPR11MB2757.namprd11.prod.outlook.com>
References: <20200322132342.2687-1-weifeng.voon@intel.com>
 <20200322132342.2687-2-weifeng.voon@intel.com>
 <BN8PR12MB3266ACFFA4808A133BB72F9DD3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BYAPR11MB27575EF05D65A8AA9AF4128488F00@BYAPR11MB2757.namprd11.prod.outlook.com>
 <BN8PR12MB326606DE1FEB055B7361A939D3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB326606DE1FEB055B7361A939D3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=weifeng.voon@intel.com; 
x-originating-ip: [134.134.136.203]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14b99ac5-7879-4d67-58f6-08d7cf42279d
x-ms-traffictypediagnostic: BYAPR11MB2615:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB261530E4C76A52E9635539D588F00@BYAPR11MB2615.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0351D213B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(366004)(396003)(376002)(136003)(199004)(186003)(478600001)(26005)(33656002)(4326008)(316002)(9686003)(55016002)(54906003)(110136005)(6506007)(107886003)(7696005)(71200400001)(86362001)(81166006)(66446008)(66946007)(66476007)(64756008)(52536014)(8936002)(76116006)(66556008)(2906002)(8676002)(81156014)(5660300002)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB2615;H:BYAPR11MB2757.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VwnRttc10a6RPfsduwVIRJkHwJvNRWhzOPeLkzlRo6qEP1ewKc4PCmjXHjj5XkaZlSRAoqHGwsODYC/a8nX1bOqqPEhfvOx52AB+XmV33BqnIlcmql31LAy3rLvXSHugQ5Xfblbq88aK1f2R7tkqZ3jsPk7Fi1CsuSKQnEv8XNE3c3q9V1kWVCXABLTXMZMKJc2qmfaENEEO/jNn1X8kEdlAeCJ8PnUpItyJGFWd2tPM8Tskwv0cIFv2a+in9ZIBZPClUriAOMg4gatzUjuO9PS0/rgY1eeg9mdvuGeNAp31geDVrhjV5KGLidgDnisfS39C5qweubkKbIs24zNUIGua1iDmcNZhKT3eNI2q7cCBkBBhtIHVAHafVZ3XCh8rs8ezxXw4/NDY9DSoYWtpjVU86n2/eEnyS9zGu2nSl1QaegjLWp3NC5ias3H559R5ypFAHI1FZvFCpDES3D7QpdvgwyX0PPBYynp1phFMhCgQjzMDgQkO5/2O4lGYDe1Y
x-ms-exchange-antispam-messagedata: TDKnBxT8DoLhNweoIPdlFrEKxJMp41KA9C/SaZYN2HbizVB8pBV9WU+1FS3bcxJ4CTGJqaB4/5WXcJDcXY0ngnqVSr+ESf0C4gntV1ceXu8bPHbmbM6Kaait6rMRUr5lHLqHJBhcXPug6bIEqmSgAQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b99ac5-7879-4d67-58f6-08d7cf42279d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2020 15:52:13.4629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IiSNaK8ZMhHubLowDkL2YQpDDvHyqx5tTQPq+LKwY3yNOBlwkWaUe5+Hc2btGR1orI1DYemnhBUiriupPdne2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2615
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > This patch is to enable Intel SERDES power up/down sequence. The
> > > > SERDES converts 8/10 bits data to SGMII signal. Below is an
> > > > example of HW configuration for SGMII mode. The SERDES is located
> > > > in the PHY IF in the diagram below.
> > > >
> > > > <-----------------GBE Controller---------->|<--External PHY
> > > > chip-->
> > > > +----------+         +----+            +---+           +----------
> +
> > > > |   EQoS   | <-GMII->| DW | < ------ > |PHY| <-SGMII-> | External
> |
> > > > |   MAC    |         |xPCS|            |IF |           | PHY
> |
> > > > +----------+         +----+            +---+           +----------
> +
> > > >        ^               ^                 ^                ^
> > > >        |               |                 |                |
> > > >        +---------------------MDIO-------------------------+
> > > >
> > > > PHY IF configuration and status registers are accessible through
> > > > mdio address 0x15 which is defined as intel_adhoc_addr. During D0,
> > > > The driver will need to power up PHY IF by changing the power
> state to P0.
> > > > Likewise, for D3, the driver sets PHY IF power state to P3.
> > >
> > > I don't think this is the right approach.
> > >
> > > You could just add a new "mdio-intel-serdes" to phy/ folder just
> > > like I did with XPCS because this is mostly related with PHY
> > > settings rather than EQoS.
> > I am taking this approach to put it in stmmac folder rather than phy
> > folder as a generic mdio-intel-serdes as this is a specific Intel
> > serdes architecture which would only pair with DW EQos and DW xPCS HW.
> > Since this serdes will not able to pair other MAC or other non-Intel
> > platform, I would like you to reconsider this approach. I am open for
> discussion.
> > Thanks Jose for the fast response.
>=20
> OK, then I think we should use the BSP init/exit functions that are
> already available for platform setups (.init and .exit callback of
> plat_stmmacenet_data struct). We just need to extend this to PCI based
> setups.
>=20
> You can take a look at stmmac_platform.c and check what's done.
> Basically:
> 	- Call priv->plat->init() at probe() and resume()
> 	- Call priv->plat->exit() at remove() and suspend()
>=20
I have 2 concern if using the suggested BSP init/exit function.
1. Serdes is configured through MDIO bus. But the mdio bus register only ha=
ppens
in stmmac_dvr_probe() in stmmac_main.c.=20

2. All tx/rx packets requires serdes to be in the correct power state. If t=
he driver=20
power-down before stopping all the dma, it will cause tx queue timeout as p=
ackets=20
are not able to be transmitted out. Hence, the serdes cannot be power-down =
before calling
the stmmac_dvr_remove(). The stmmac_dvr_remove() will unregister the mdio b=
us. So, the=20
driver cannot powerdown the serdes after the stmmac_dvr_remove() too.   =20

Regards,
Weifeng

> ---
> Thanks,
> Jose Miguel Abreu
