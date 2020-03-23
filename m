Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07D0B18F0B8
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 09:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgCWISw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 04:18:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:12962 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727526AbgCWISv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 04:18:51 -0400
IronPort-SDR: IqgRZ9eInJ+Lg6PQgretw86mI8FCDaZHXWa2mhYrSQXlStrmKF/DOTSQWWeiFdsnKCoSRAsnZD
 e+QT2XwGOnkw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 01:18:51 -0700
IronPort-SDR: AI7mwcti47a8zY7rP3T1HAx+cm976cqmpmY2xAgIvuvrNZR3O5/Vwl2QZHRfC+y4J7PTcl4dfB
 luJrNVfdt3Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,295,1580803200"; 
   d="scan'208";a="249542467"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga006.jf.intel.com with ESMTP; 23 Mar 2020 01:18:50 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 23 Mar 2020 01:18:50 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 23 Mar 2020 01:18:50 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 23 Mar 2020 01:18:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 23 Mar 2020 01:17:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIvmfrCqmE18K9w+UDdGoNOVYD4V8VoMdUtgtKX3LKGDH84i8t8pwbt1h0P2MQ/jZ3ORuc4E1LQPWiQSylc1Ydc7CbgvWv1bBwnOQ8BIjVbmOS9aTPKpBqyoF7iIkC+laGTmkWCUsIwkzCMn6UzSlxJ4rUBNmdFqht901JWHZv86GJLZ5sh4NX/7KQnqE4VwnMQ3YlUu7xJhn03w8fVxXIzUaDxA397zdmmIG0VIcM8xcLE96pgWy3hTjYBYiIbwYRrWQNwbngzS8g4DlHDdp84bcKfXb1syhfDfvZiOs3/XWU2DxsPneopXxlK0G0pLUryIN8n8FjzKE+I/7FT2bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BaMhQe27Ew7yBq8joG5iOJKLRmveGIB+13R36VB14Sc=;
 b=JRA9OT+l+Xur3VfnRcu2sJTilQoOUKVN1wrgC4xN6G/IB1NLk76lzH26moZoXF+hXrxDYTDKpxBS5AI7Xuc0X6FrTzllHfzsvoztN+zqZbE66NeTDQvr7aeuQ/2VDWkuKUfItKuZ7BRQusC8qme6Ne9oKqDsJNq4xIKMGiaBLWuzij7T5JSjCVmolLZRgbdgBFlQOt7K5ZYV+M/H0KEaJIq2ME9g1n2oiysKF9sPj+yKIDoUkiU+TlZtiUxtaAUnqbf6XNpwVpEjrTBgm98B1MotLr6P/ZMtcjYKK6JdFlWfWuakRp2nLaRTVj6xao8T9V+4SJkpyk8khiFMSdrX0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BaMhQe27Ew7yBq8joG5iOJKLRmveGIB+13R36VB14Sc=;
 b=mxZcJ+qq1CG4f9oUQL4M9VJ8kszMBeyQZg4S1Xo6pSUcMXZ1N4QdkmnEbC7PT/6tbRDdV9t7NQuvHrOQC9WvTkykIS94NJl6XwGHCidqxVgAZhgssABVu0MxQgYMM2M6Z0gB1EkIi3YApYsrFo9pnNxYCr+Cgu2UCheUElQm64Y=
Received: from BYAPR11MB2757.namprd11.prod.outlook.com (2603:10b6:a02:cb::16)
 by BYAPR11MB3192.namprd11.prod.outlook.com (2603:10b6:a03:7a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.22; Mon, 23 Mar
 2020 08:16:29 +0000
Received: from BYAPR11MB2757.namprd11.prod.outlook.com
 ([fe80::f8aa:496b:6423:f5fc]) by BYAPR11MB2757.namprd11.prod.outlook.com
 ([fe80::f8aa:496b:6423:f5fc%4]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 08:16:29 +0000
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
Thread-Index: AQHWAE0vpBWvWDPaGkGozDEPMDm2A6hVzcSAgAAFr0A=
Date:   Mon, 23 Mar 2020 08:16:29 +0000
Message-ID: <BYAPR11MB27575EF05D65A8AA9AF4128488F00@BYAPR11MB2757.namprd11.prod.outlook.com>
References: <20200322132342.2687-1-weifeng.voon@intel.com>
 <20200322132342.2687-2-weifeng.voon@intel.com>
 <BN8PR12MB3266ACFFA4808A133BB72F9DD3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266ACFFA4808A133BB72F9DD3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: ef479fb2-e056-4be2-e55b-08d7cf027d81
x-ms-traffictypediagnostic: BYAPR11MB3192:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB31924A7467CAAE6974AB64DD88F00@BYAPR11MB3192.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0351D213B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(55016002)(316002)(6506007)(54906003)(9686003)(110136005)(33656002)(66946007)(76116006)(64756008)(66476007)(71200400001)(66446008)(66556008)(86362001)(8676002)(8936002)(52536014)(107886003)(81166006)(2906002)(81156014)(4326008)(5660300002)(186003)(7696005)(26005)(478600001)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB3192;H:BYAPR11MB2757.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HGRcyiJXp7aZET68eQ1MNX3RJRIn96+F0PFU+htuL/T7YFz4veEkggbrtmApvRfp+WCKYB/PmLOfKLaZ9CGzGUj8DiYVMvngUhxZ7mm58pztbTr4rMlKahCNHy9CFkvbsTtLTABtqCTYlDCLaL6vBwKMlshHQovfmIMtqq+PdbrmJZWBauT3PRjYzw0rC93xpiLcLmKadF99wv53M8VTrrgPRLeS0/r8rL+qbdGt7o801gMQ2zqJ4Ec7HkSZnctsP+yzSJ0nuYeduo5hZu3QEK+kpm5xrm9PWBykld0vMUN5nenvl/2suqrC9VOm7nCPIzxFxZpcVnfqpRRGQXQ9EbcpZbC6s2pNfaeMu6bqwsallNlI7D7mTCs36MfpReRWf6HSyvFsUU6EMf9bHCrSmyR3ipC0Uw/aIKK5CWk3RFNgwyEu6rbi9t0S+OTy61lL4Tz2f/LQxG1prlTlSwbGIwEcd/Alm7RkHETBIXv8bw0epF5010K8nDXzETTUn1Jj
x-ms-exchange-antispam-messagedata: vHIKY5WKC3OQViemPR/H2t7W3xhP105VLTzveFwVd9rCKLSJ/CkQeFwY8dMZp2b0WDgBRA1iUOTjgu4Y5jULudwQxYIA64T38S+wt/eO2G6jNwQU6Xw/ut1JZxnf7YWFN/EdxsLWPr+syUFXnOTvAw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ef479fb2-e056-4be2-e55b-08d7cf027d81
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2020 08:16:29.7564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dFLWThUk5g6k87yGS4Hkra9rORQWJqljmILEucZ5oEMjTqQ2WdbD5TrimQaXEHJ9bEpo10bHWcrw7D8kEfiYjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3192
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > This patch is to enable Intel SERDES power up/down sequence. The
> > SERDES converts 8/10 bits data to SGMII signal. Below is an example of
> > HW configuration for SGMII mode. The SERDES is located in the PHY IF
> > in the diagram below.
> >
> > <-----------------GBE Controller---------->|<--External PHY chip-->
> > +----------+         +----+            +---+           +----------+
> > |   EQoS   | <-GMII->| DW | < ------ > |PHY| <-SGMII-> | External |
> > |   MAC    |         |xPCS|            |IF |           | PHY      |
> > +----------+         +----+            +---+           +----------+
> >        ^               ^                 ^                ^
> >        |               |                 |                |
> >        +---------------------MDIO-------------------------+
> >
> > PHY IF configuration and status registers are accessible through mdio
> > address 0x15 which is defined as intel_adhoc_addr. During D0, The
> > driver will need to power up PHY IF by changing the power state to P0.
> > Likewise, for D3, the driver sets PHY IF power state to P3.
>=20
> I don't think this is the right approach.
>=20
> You could just add a new "mdio-intel-serdes" to phy/ folder just like I
> did with XPCS because this is mostly related with PHY settings rather
> than EQoS.
I am taking this approach to put it in stmmac folder rather than phy folder
as a generic mdio-intel-serdes as this is a specific Intel serdes architect=
ure which
would only pair with DW EQos and DW xPCS HW. Since this serdes will not abl=
e to
pair other MAC or other non-Intel platform, I would like you to reconsider =
this
approach. I am open for discussion.=20
Thanks Jose for the fast response.

Regards,
Weifeng =20

>=20
> Perhaps Andrew has better insight on this.
>=20
> BTW, are you using the standard XPCS helpers in phy/ folder ? Is it
> working fine for you ?
>=20
> ---
> Thanks,
> Jose Miguel Abreu
