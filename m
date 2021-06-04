Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7509539B34B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 08:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhFDGzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 02:55:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:52209 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229881AbhFDGzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 02:55:31 -0400
IronPort-SDR: MEZbheGEAhI0GV4GNNsYQb1LA6vyy1JPkGUi1FCWum6S+fISxGrH1nzKdSbe/5y3EEStGFnM0G
 8rGeyMJKr5gg==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="201216123"
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="201216123"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 23:53:45 -0700
IronPort-SDR: V+P0ql+gHJzXPiCjBWgWKilAULWEM/bBQCh3FYLRvSux6W0QduS12IbM4VFpRB7kBoCtEiGokq
 qtd33cL2dtnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="480535272"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 03 Jun 2021 23:53:44 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 23:53:44 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 3 Jun 2021 23:53:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 3 Jun 2021 23:53:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhjyAVq8CD3c9xvB4F01idBQwTavJ33Q6RxOp93vlaaf4meP4pDWjTC2c87QZ1zv9kC2URQSsTTGOWw4qDFee8fESvEyne8t5Dwoefwrk9oHLGy/SZBV6Nw8OWyyCpa/zHTdCVkSIgNU0q+mC0Bcri7DLd8rH584eIBODrYcYDnZdWf+SMPHvMmsNeuwooLl1SgooAST7oRXgSzzyXPSjZmJjSCQcVvkE+fyn5/PGDofXjB94IROHaBsXOuiTs6r0iG6jpAr2/6+xKXXiGF+A9xw5w7PcbSM1eccluD+aFitVEmJiGmvu4ifB0a2UntawLO3BDMd/BKKCNAPr69b3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lz+qObt79uDwG8IghMprLScwof9ogEEZbXa7+Iu3hQs=;
 b=A1niO6y98fLbFfq/jznUOKORCB/fovraeEgBN+GXHnLGhIvKK692pgEmIUdDaAxV/YJ3yXfqvOnq9RRgROotuQ8IgAA58EPG5oOAYMN2+pL6djtOp8cpaaipiG/4krQQyijpAY7Z2KtRtkE0HgxKyMcrP6KPmtnyH04kW5IyU8cCvDTI8scF/e7Mv85aGAmpBj7qOdrpKri8RsH273GoHak9sELtbrKpWxLPpdmRUGp8VPPEhJ4hpCYCV8B6SSlCGSI1STvAJNZbVHghjp9zfqVlxzQDkJoDpH4EDbKVMR/vLUv3jqWQhDvmCVBTNVBwc9X3Wb+eqf2Bfy/xraOeYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lz+qObt79uDwG8IghMprLScwof9ogEEZbXa7+Iu3hQs=;
 b=OqEx8GcK6oAQK6OzdmMjKH6zoSzk1jxSNTXqOR41GGjJdqIKk8gdF6YfsZyO6NYkxlPyL3woLz8XZ73gF9+xrAQ9Mes5Z7bQTkASsd0vvn6qZ5WQg1Se/KmUcjj0skGRDUnBXQIAy9RXav5rS1aUZBnm8KVVV5yEMEqBsodMPS8=
Received: from CH0PR11MB5380.namprd11.prod.outlook.com (2603:10b6:610:bb::5)
 by CH0PR11MB5251.namprd11.prod.outlook.com (2603:10b6:610:e2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 06:53:42 +0000
Received: from CH0PR11MB5380.namprd11.prod.outlook.com
 ([fe80::d26:b91e:773:5e22]) by CH0PR11MB5380.namprd11.prod.outlook.com
 ([fe80::d26:b91e:773:5e22%6]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 06:53:42 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
CC:     "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RESEND PATCH net-next v4 1/3] net: stmmac: split xPCS setup from
 mdio register
Thread-Topic: [RESEND PATCH net-next v4 1/3] net: stmmac: split xPCS setup
 from mdio register
Thread-Index: AQHXWG9VZDAInycEtECS03SHnnEzzKsCRbMAgAAH7wCAACh0gIAAybNw
Date:   Fri, 4 Jun 2021 06:53:42 +0000
Message-ID: <CH0PR11MB53805074303D0F06738FCD40883B9@CH0PR11MB5380.namprd11.prod.outlook.com>
References: <20210603115032.2470-1-michael.wei.hong.sit@intel.com>
 <20210603115032.2470-2-michael.wei.hong.sit@intel.com>
 <20210603132056.zklgtbsslbkgqtsn@skbuf>
 <SA2PR11MB50513D751429D3D456A5A9409D3C9@SA2PR11MB5051.namprd11.prod.outlook.com>
 <20210603161407.457olvjmia3zoj6w@skbuf>
In-Reply-To: <20210603161407.457olvjmia3zoj6w@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [161.142.242.146]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cd682fb-0f0d-4d4d-caaf-08d927257dae
x-ms-traffictypediagnostic: CH0PR11MB5251:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH0PR11MB5251B9A7E9204523082620E3883B9@CH0PR11MB5251.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lDv0p0AMpUVCRIaMg1ikqiZ7M5TNS+vfVJvZgN0MeDven5D0YUTe9/G0qdY20E6SkDCgYbaol5mvds7JUhCjiGW/DAyw/+uu3l/mFaf9CvizoiFH4AcnKLl9xNRWZIBNfvbZ+K2z0lcfl4wxoJZerB0U7/eTnxijPNtuXCWmjRDaVi93ePIY7iIJY0K1MCzlGz6vGKucudzWk6BUN9FS8hDOaNc7+feLFR06K+Qhsp2SmLNbbiIHDi1QOzgolPKGnqPJ9NdUC7fMATl5xum9fCMITIxh54N+0kl07xEmsohSQTsZs5pfEURXWx+mfxtQPVJv9mbUsnRh/mRMKxngOc0Aoa2zt5/O4AInDPwtv6Pzda3xgSYkq+tCEYsF3p9b+QLPbvfY905MmAcjOB+AC6TbSSGxsp9ARIGfOjc7n26U/X7WQzyJgH+ojAxlfwJfPfn8tPc+xihOTv5wSr/298w0JQOkr3nWIpF/GrQ/krvIMLZy8i0PvROuAUhbQ1brRLYqQL9Guw74p7mmJgNG2B/CcPjLD20tAYwVc1kmxbqJeo+3iu7J0FfsnIqxAE2orCaETboyyRwZk1ewdYNCSJmFFNUqNqcybatD9odpmAg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5380.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(39860400002)(376002)(366004)(186003)(66946007)(66446008)(66476007)(64756008)(6636002)(66556008)(8936002)(52536014)(54906003)(4326008)(76116006)(110136005)(6506007)(7416002)(2906002)(316002)(33656002)(55016002)(38100700002)(86362001)(122000001)(9686003)(478600001)(8676002)(5660300002)(71200400001)(26005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?sht6MuE2o+zPj6U+fvyOTD2hIAcn/QIqTZ/GfVosGd1w+llIOqxar5xjq/09?=
 =?us-ascii?Q?qCM7aFadlaQjNLJpohJeS8VdN2U0nhV3njr0F/9QEBxUUWq+kEIAY6MuSBqi?=
 =?us-ascii?Q?FkdagtweT2sjchnTVGPM4epYsrEhN/TOfYdoPwqGBpvcvGc2+UIEeGJm7+jx?=
 =?us-ascii?Q?B1karzaJMqpp1S6Hl8+oH+ytcnPlxVvmjUrxIw5AkIzpLlKP2NsQBzFS+o3y?=
 =?us-ascii?Q?ne/Chd5FkzV91LdpXwz4yMFInVtQHScOpaBGEWDuhkW3isQnHF1LzEet9jK0?=
 =?us-ascii?Q?fMJMf/jJ+NlG0tJXaHNQYS6Q9ju8Ptu8krL33SOWd6kLY70bd1ILiYBXU/m3?=
 =?us-ascii?Q?hGubO/c5LjYel0eoWlfYQW2nd4dMwqXjSvRXYbudo0fA6K4sVPsnCgdl2d9s?=
 =?us-ascii?Q?ZCzi98YoGXcBaO9V6TYuj4W6IZyiJuiJrjTsUFZZbxsqeWPeLDHEgeUicyv6?=
 =?us-ascii?Q?fZOjmsJJEVQA/5B+QJWbtpg1TXk2yEh+a4ZjSatloW6Vr7wJVlctzsyvwTtP?=
 =?us-ascii?Q?Gp3UesaViWGbKD3smlvIhqgtJpz6IQLam/6UOUD63wBOnUvZpjD3FjPobGAx?=
 =?us-ascii?Q?QdRqENxpxKarIi+Ylc1FRrrheCoRk4OWCFfuLsDoBuFAPGliP8q6xX5Gu/Rw?=
 =?us-ascii?Q?tmoxa9PAa+uidFziO3ErWhzHpZYGarjZch6icDwZJx6rVHQgJpUOzNU1Pi/2?=
 =?us-ascii?Q?N2er/WavM2NrEdEv9XzcOx3yfQz+rWcxq3uXKQmAKCuPx2aclvXeqkrfTriy?=
 =?us-ascii?Q?1fwgIe572C2PSAdcF3Ew06H4XXfEW40oYUKv66BIrNIU4spZyEzASj4H5YGK?=
 =?us-ascii?Q?K7k0QqbjrWi708mznmHfvEOgAemPzWPJ4NIU2T8XGJSOuXgl86ALO5dQrZGq?=
 =?us-ascii?Q?ZcHI9QOZvohdyVxmymNi+IFlBg2qGpBeTsUwgV+C/3LF4HSTR3F2IF9iBGD9?=
 =?us-ascii?Q?VzaEceZ6BtknMYkZVOf9QFbcFKddN9AvcnI9OeklVukNsWVYssd5I+ucu6fo?=
 =?us-ascii?Q?0wvwMEJ6PJLcN8wmOTr6JKPMX3GM0G1hG7A6pD1BRKP8lixQVJMaiC4pgQDW?=
 =?us-ascii?Q?fplZ21UoTyY2/ouni08YjUqKQk6hJ0Aeul9DuGIj/4cPeBRANz1bguyOlo9L?=
 =?us-ascii?Q?PBRZkPygpHcFMKACUoI2iuYSHd+3ExNq7VJtzDn7xUBAF9wd/I+pSITE3Hl1?=
 =?us-ascii?Q?QCHAW77EscfOSUoGh0XX7WTmqHpH9zgMD3oYMn1ftsEhX6q73Q0u672YBBpP?=
 =?us-ascii?Q?6gfdDi5R6otBqgIWZHljViYwDgSv5h0DkXmh+DF/EDkcIwqQpHIpriULRsUn?=
 =?us-ascii?Q?Zvl6pnEX4HTg8ovt7y7z5FNp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5380.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd682fb-0f0d-4d4d-caaf-08d927257dae
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 06:53:42.4122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d8ZhraB3QlWBhu3C7Ue0S3F1mgYcpFVAL5UEaOnt68H5XLw0U4dyxKOhXP8eB3MIdlHZIFZLVSRFYvLyd76pFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5251
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -7002,6 +7006,9 @@ int stmmac_dvr_probe(struct device *device,
>  		}
>  	}
>=20
> +	if (priv->plat->speed_mode_2500)
> +		pri*v->plat->speed_mode_2500(ndev, priv->plat->bsp_priv);
> +
>  	if (priv->plat->mdio_bus_data->has_xpcs) {
>  		ret =3D stmmac_xpcs_setup(priv->mii);
>  		if (ret)
>=20
> With the current placement, there seems to be indeed no way for the
> platform-level code to set plat->phy_interface after the MDIO bus has
> probed but before the XPCS has probed.
>=20
> I wonder whether it might be possible to probe the XPCS completely
> outside of stmmac_dvr_probe(); once that function ends you should have
> all knowledge necessary to set plat->phy_interface all within the
> Intel platform code. An additional benefit if you do this is that you
> no longer need the has_xpcs variable - Intel is the only one setting
> it right now, as far as I can see. What do you think?

Hi Vladimir, I still think that stmmac_dvr_probe() the suitable place to
probe the XPCS together with MDIO and PHY setup. In addition, XPCS also
need to be probed before stmmac_open()as there is an checking of XPCS AN
mode at the very beginning of the function.=20

The has_xpcs variable is introduced in the very first commits in the XPCS d=
esign.
Although currently Intel is the only one using it, it is beneficial for any
future system that pair stmmac with xpcs. =20

Weifeng

