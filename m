Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F5C368F62
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 11:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241753AbhDWJat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 05:30:49 -0400
Received: from mga04.intel.com ([192.55.52.120]:18269 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhDWJar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 05:30:47 -0400
IronPort-SDR: wp2JxWHYdvm7r3Gs0TaLbAmN7MUgisK3F+b0U6iEdxEBAgOmIBGuKCena2gXNO0ivpGAtAjacC
 wGDlHdeWdDCQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="193925607"
X-IronPort-AV: E=Sophos;i="5.82,245,1613462400"; 
   d="scan'208";a="193925607"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 02:30:09 -0700
IronPort-SDR: IK0TxGxWGEFhBNEP4++Sgugv9p7pvzafR2d5LbInWGeSRF5zs6grFvTtQ1/GKI4t8uZFAFJlB1
 PINhL9bh4YsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,245,1613462400"; 
   d="scan'208";a="535494824"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga004.jf.intel.com with ESMTP; 23 Apr 2021 02:30:09 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 23 Apr 2021 02:30:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 23 Apr 2021 02:30:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 23 Apr 2021 02:30:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVnCePqYvgoCo1g6SaqhTIshgvrz+o0pN/WssNB+rT8m0+rCYYbZLwtoacuqQwkzp4/cGA5t+PVHCZUiJzhset0MgBhllYUrHXGf10YTOqWnhbPyV6bGKvfmdCh/UPlRWmXyDGF2T4XSgxTMtSM8yjZ5UuIz1/WbBBFa9gLJmjW6Lek0GGeg9GptJw8AwZF3G031/owBb9sYe5QmcLA/iF2WUkFMYpipkehbUkEOePzUpPp2vXEfmWjT1rGvM7L9Dj0FmmgnVoJMCvvsQTiJIK74kouiDtpbPo1QAy9tMBR4NWD6QLDLTDKbFn9ReBmKk/gG8CWKyuV17bIS6rV0jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+OE8FMSDxXAWrO+hxOv6fydGFlziwmziQkRPMBOJv8=;
 b=CHkPhk8uAKxymxtc7zUtsQ9060Obu6aj93+qGb08Gns/0zCrI16W0Qv9RUAPWe29Pfh63TZbj2HEZIsN64UnsMh918dJ+cV6yZefNUmisaTxn9B4G56wiXWKFWJYLcAIYJrf25F1cMGKZoWyHbKQbwAN5sPZ2yitJ5UOf15QPFSzSSc9XlobeqEC6XAMozX1FT/M/8swRlugdtlvZSWrhsafNvOISMU0BHEDZ6z8ZI6Sz+g2uvqUVL1A+DobU5AO2o+kWqcGBnM9xz8HAPlhP+QvdVF+nPM4We/I3GsqfvZgUfCjIBzbSiS5+3Ol+6TNvrdDA/Vi5J+ZEHi+2FxzIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+OE8FMSDxXAWrO+hxOv6fydGFlziwmziQkRPMBOJv8=;
 b=OKb40kpuNLrQe+I1ahmW9r75Zq4FntHQoyEqrJ81imKIhpKepMO1RdtswE4PwmyR3cwSZCAeU23GFpde1bHA9s6gLdDYY6Y1gbjZfglahjTEec4mThRuc08Dz4HTdPTCdnLeXNqPKhppxLpvaPqB9zI5YtmVUxiNkjUN5hSdYRQ=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MWHPR11MB1312.namprd11.prod.outlook.com (2603:10b6:300:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 23 Apr
 2021 09:30:07 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5c19:a154:82ac:30ad]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5c19:a154:82ac:30ad%5]) with mapi id 15.20.4065.024; Fri, 23 Apr 2021
 09:30:07 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 net-next] net: pcs: Enable pre-emption packet for
 10/100Mbps
Thread-Topic: [PATCH v2 net-next] net: pcs: Enable pre-emption packet for
 10/100Mbps
Thread-Index: AQHXN8w75Vo0bmfsFEyfZYnEbB76e6rBNbyAgAAK1lCAAAXiAIAAkBXg
Date:   Fri, 23 Apr 2021 09:30:07 +0000
Message-ID: <CO1PR11MB47716991AAEA525773FEAFC8D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20210422230645.23736-1-mohammad.athari.ismail@intel.com>
 <20210422235317.erltirtrxnva5o2d@skbuf>
 <CO1PR11MB4771A73442ECD81BEC2F1F04D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
 <20210423005308.wnhpxryw6emgohaa@skbuf>
In-Reply-To: <20210423005308.wnhpxryw6emgohaa@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [42.189.200.23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cad1625b-d7ec-4c1f-5def-08d9063a61fa
x-ms-traffictypediagnostic: MWHPR11MB1312:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1312A6B84733CCD9C42591F9D5459@MWHPR11MB1312.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U2tBwrQVaFGb993bB9BR6bF3EFV6pwxgisec5rhrmnkuD9cWoFAFm+xhhoBlZGsYKoiULzLXoawVCwhuU4TZe3JBLQs5T8iP1Q8i2T4Eb/0LoGtr9nxU9txY2nSioFhE3n3rm9JhtNH90P42vFLarHYjHwQ/iCLHRyEC3AoDUeFtk+zfzZpyudiCFMlMBfDH9chi5fRwRiMGKeK+GiFDtAnJS3/OCafQxH6H9fCUs57az0v3qDP6EMt6WbIOaFH47u6KNggMkiC24yQfplLSlp4wQzMks8T+Ue0/SUp+n+40pJjq27rIc1TOIRZnDRw0wE78WRd7lXTy2gikg9K1y6GZASrV9AK5B5ITld2s1yYAiGIECgDMZMKo+eGTnezhT5Rt9ftXWVKENYEQj3MsjjQIQK16lopmtgz3h3OkLnQjYi/OwxH71Xafu9lFPTLV+Amauxtt5duBJ5vSMBrelCbyF23hbD6ABag+rnavxkIGrn5AgtnxAi07cJ0wfIV8Jma8C+fi7vLQYP+hi84f4vS0Z9hi2mE1HJNp3I4YsiaC0DwR44y+sZ01eUyI2/Vij/EHbgjM6woPS25+cQIfaPKok4hl+E4bl2wgodPW17E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(136003)(396003)(366004)(26005)(7416002)(38100700002)(6916009)(66946007)(8936002)(8676002)(66556008)(122000001)(54906003)(55016002)(316002)(66446008)(66476007)(6506007)(186003)(4326008)(478600001)(76116006)(52536014)(71200400001)(2906002)(9686003)(83380400001)(64756008)(5660300002)(33656002)(86362001)(53546011)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?wzYtCk9h87F9YfdFtuZsmd6yj/t4LyBZgvNfUya8pLthgi7wrqFlqujPkmpF?=
 =?us-ascii?Q?Gpi2CkRpUrBeY6M76wuKBRbuS1ArhVkMDqGcb9L++Qau6iETnVSfTQgqjah3?=
 =?us-ascii?Q?R8VvfHjjBZ8JCep1/A6RwyyU2eAEMJGBv9VkEVdxBiCVGXbTfNCQCNyl9w4g?=
 =?us-ascii?Q?WsV5qAtGOd10mREm9RovH4eLOEPFxeOa4vb2ph3qQZLzWhYMXP4LUhVDIlYF?=
 =?us-ascii?Q?yk/nDBe0IQ36WmZtVRrlbHssRbUDyk6Ollio6t/j/x6MqUzCcq5rbjI2rdDR?=
 =?us-ascii?Q?ymG2JpWZWsMtFn1KKQO2fZdd2Kv8WAOPpqQydvRSBJB8MvHXY06NH/jquQT8?=
 =?us-ascii?Q?8hFvJphNMHxm2rcoVGmfNd0ADLR1rCuWFsDF+jxYhhY/60audLP5020jGhKS?=
 =?us-ascii?Q?xCBkv8Uw1X+QFGuCINzFFEOBwYMMA4skjOnp6Ox4JUOS9lH5C7j7P9ztYvUt?=
 =?us-ascii?Q?Ri8XjYavA0dN0mE5Fai/yRN4jWsX4VDImJH7/YK06ErcjT5ZwizJU+vcv/k7?=
 =?us-ascii?Q?+BHZQRtrj2LVG/bipdtHini0Mw9jsKa79Si6efF6s1I0G4UiWZZkkAtHB3pv?=
 =?us-ascii?Q?0Zlb2hjrBC3HsgiIFiPsp7XIsd9YKTmZSSg1Mn4qtZmcuHl/9QU8uQMV/SmR?=
 =?us-ascii?Q?69KPZrO1mmCUe4Rc3pAcHXfZW9e4dtDGLCh8FwaKkea9AEk/9LdJX1unckWW?=
 =?us-ascii?Q?oXx2b8rAZI2FHaXExA6haXXXbm3K4olHV30cRT2lVJll4T9v7tSV7kISi+BS?=
 =?us-ascii?Q?JltzAc/8wpoLmpG+VQsY5Kumf2CrNPs2PKgcY7FaxvQQig6dDakIKUPg7QDo?=
 =?us-ascii?Q?ePbgj1yKKO1r3cDExaGaSMthz4bQdZfWqHX8jIRt567n8TQdo+sRLPFvcn+C?=
 =?us-ascii?Q?gUhPGMlQ1y66z4+G2ez6SXTlFOclnAJNdkYkk9bOxb+DKVBadZJnkjfZ7Dnr?=
 =?us-ascii?Q?urleyhyGLZ79qWurU2VAvvinX0Yko3Hr2i7qVN9F7EGND5GbjdqV6f3DM4u1?=
 =?us-ascii?Q?hAluH6Sfex9fOeEdwTpetfb1MnDwWyXCBWJGQxPLB7+pQ5aDUYB/ayvN9X6e?=
 =?us-ascii?Q?Q1kTWd33jTWF7dJ/CX2k/BPAY4skz0EJytlp+Do04L2Yj8neQFVaWbgg/jpo?=
 =?us-ascii?Q?AMk+1vCjII52a1XwiRpLfh7SUI/dNqRqlWNz81QbtoBHfdevZKOJXDyo51GP?=
 =?us-ascii?Q?q2jDuECWEeuLgX6qiYSXM7jAUsFmdcGCWSqW19rmanGo1yITzhCKacnmGARz?=
 =?us-ascii?Q?Qi4kaQgB4f9R3jGzvd4cuXy0EZMSxlgFEWVr+oA3JiKncSJBCcqwghXPhtTP?=
 =?us-ascii?Q?Ze9zxgwlbhNUlNj1Z/tUSlXu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cad1625b-d7ec-4c1f-5def-08d9063a61fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2021 09:30:07.0278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qqMfnnuPh/kY4KDANVVknvsUPVd5saNSFPV05P4amemC6xlm94JQNF7JmIszqqhxT6qv92yCtUFJ/HhwmisdGa7XWuh6CJGdV8yf20dEW2d9dApmlzT8t/raMCzKu0fr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1312
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Friday, April 23, 2021 8:53 AM
> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>; Jose Abreu
> <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit
> <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>; Ong, Boon
> Leong <boon.leong.ong@intel.com>; Voon, Weifeng
> <weifeng.voon@intel.com>; Wong, Vee Khee <vee.khee.wong@intel.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2 net-next] net: pcs: Enable pre-emption packet for
> 10/100Mbps
>=20
> On Fri, Apr 23, 2021 at 12:45:25AM +0000, Ismail, Mohammad Athari wrote:
> > Hi Vladimir,
> >
> > > -----Original Message-----
> > > From: Vladimir Oltean <olteanv@gmail.com>
> > > Sent: Friday, April 23, 2021 7:53 AM
> > > To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> > > Cc: Alexandre Torgue <alexandre.torgue@st.com>; Jose Abreu
> > > <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>;
> > > Jakub Kicinski <kuba@kernel.org>; Andrew Lunn <andrew@lunn.ch>;
> > > Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> > > <linux@armlinux.org.uk>; Ong, Boon Leong <boon.leong.ong@intel.com>;
> > > Voon, Weifeng <weifeng.voon@intel.com>; Wong, Vee Khee
> > > <vee.khee.wong@intel.com>; netdev@vger.kernel.org;
> > > linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH v2 net-next] net: pcs: Enable pre-emption packet
> > > for 10/100Mbps
> > >
> > > Hi Mohammad,
> > >
> > > On Fri, Apr 23, 2021 at 07:06:45AM +0800,
> > > mohammad.athari.ismail@intel.com
> > > wrote:
> > > > From: Mohammad Athari Bin Ismail
> > > > <mohammad.athari.ismail@intel.com>
> > > >
> > > > Set VR_MII_DIG_CTRL1 bit-6(PRE_EMP) to enable pre-emption packet
> > > > for 10/100Mbps by default. This setting doesn`t impact pre-emption
> > > > capability for other speeds.
> > > >
> > > > Signed-off-by: Mohammad Athari Bin Ismail
> > > > <mohammad.athari.ismail@intel.com>
> > > > ---
> > >
> > > What is a "pre-emption packet"?
> >
> > In IEEE 802.1 Qbu (Frame Preemption), pre-emption packet is used to
> > differentiate between MAC Frame packet, Express Packet, Non-fragmented
> > Normal Frame Packet, First Fragment of Preemptable Packet,
> > Intermediate Fragment of Preemptable Packet and Last Fragment of
> > Preemptable Packet.
>=20
> Citation needed, which clause are you referring to?

Cited from IEEE802.3-2018 Clause 99.3.

>=20
> >
> > This bit "VR_MII_DIG_CTRL1 bit-6(PRE_EMP)" defined in DesignWare Cores
> > Ethernet PCS Databook is to allow the IP to properly receive/transmit
> > pre-emption packets in SGMII 10M/100M Modes.
>=20
> Shouldn't everything be handled at the MAC merge sublayer? What business
> does the PCS have in frame preemption?

There is no further detail explained in the databook w.r.t to VR_MII_DIG_CT=
RL1 bit-6(PRE_EMP). The only statement it mentions is "This bit should be s=
et to 1 to allow the DWC_xpcs to properly receive/transmit pre-emption pack=
ets in SGMII 10M/100M Modes".

>=20
> Also, I know it's easy to forget, but Vinicius' patch series for supporti=
ng frame
> preemption via ethtool wasn't accepted yet. How are you testing this?

For stmmac Kernel driver, frame pre-emption capability is already supported=
. For iproute2 (tc command), we are using custom patch based on Vinicius pa=
tch.
