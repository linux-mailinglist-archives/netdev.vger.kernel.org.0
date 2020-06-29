Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2028220D2ED
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbgF2Sxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:53:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:41675 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728222AbgF2Sxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:53:45 -0400
IronPort-SDR: 2KOpL0BP19OvHj+jvodaQHKrEQw6Sq88DJZd1UJQS5rcB+Lm3PzACsChw1VazIfRENZdQv7rBI
 uN7vD0GfHn/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="134346410"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="134346410"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 11:53:38 -0700
IronPort-SDR: zNBu5gQW8gCIJC0H6ExRKjXBQKD0G9Qo17dAXh89YW6rZQoz0dF0vE/WFqXygWkwvXqBG9IUnv
 8M41LxwVUqPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="386470972"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jun 2020 11:53:37 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 11:53:37 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jun 2020 11:53:36 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jun 2020 11:53:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 11:53:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWenjaPjsGqMN3vSAYcSgG2cSmqCOKjrotGgrhDSFImUuTNruY6n5pGPfOckAtTd/AQsupKeDaJjDcHTkpKjpMYK9GNsbQsyimAknmpwjoTn2siQ7Iei5TN4yV3VaJOVwxcE7hQ+HwGYOBeqt5/96FjwRvWs2iCYOvQAm6oehRQ3MGEM4ZXwNTXBnOP92gtSjsvGR/+LubfDVLDwudnHl0nVjJlc6RrkPnE1Fe5JNvzCVcoBi1BbCY7d5HeE/h5cz/vTLg6Ob5fRV1KVR40TjfjUl8yYn9mJDY4J3oIMW7KGzLcYQi3mg0mxAEF6u8WGI0H/G4M+1nD9+AQMn7TaPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEfPCu2rcSDqpGIhzHuxfKZvx0TY+q4FHYS9KP3P8E4=;
 b=CyrbN8ijpSv8aoqRvGB3eZsG5FEReV4JAlvUbWLSBJXQ9LNGUPiLXUftyFhGVDUvV53UslpBw43t+JgSUWqePpNjLTw0RvH1h/Kn/Zk0LSD4ps1B/Eg13WNM6+z07karHUZpuBOboXXkNItfWUsRJSHci0mdHLVjiw1wIO+7YjXwBPu7gV7qQ52qtnu6h7rPLxFTequNzEkFMQOGqurAhRxc22NBsDeRpcQ3QfaWyYKIqxkjFMDcgo1P83rk6kDqQRX5G0iS+wtwh/wQo04l1JFjL5LvZUWMqVjg1lJdBp502IBsNrETW0ZttWV0Xu7cWtOEWzgBk+HYO5we3rBjOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEfPCu2rcSDqpGIhzHuxfKZvx0TY+q4FHYS9KP3P8E4=;
 b=rAhI1uNoTIiyQiKjGJ/+o20uP7oTR4WwFOaz7SEqSCeSZxlC32slQROtoBDtk8wFTIDvdfQhLawE3YffvryC7eRMJ6KB/D4SjmXFVfYI2ZpyReQV8mkZPYiQ7mcGo77W072mD4uz8ULdFVPhuumNfUR/TesbZc5r5e7+BFo4dLc=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 18:53:34 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 18:53:34 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v3 13/15] iecm: Add ethtool
Thread-Topic: [net-next v3 13/15] iecm: Add ethtool
Thread-Index: AQHWS16ZZzIbMh9UG0WTZD4rdYDCP6jrRVcAgASwbrA=
Date:   Mon, 29 Jun 2020 18:53:34 +0000
Message-ID: <MW3PR11MB4522C544BF3EC8CDBBB9F12D8F6E0@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
 <20200626121440.179db33c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626121440.179db33c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f2a7bda-d797-427e-1169-08d81c5db993
x-ms-traffictypediagnostic: MW3PR11MB4522:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB45222E9718C18B006C5CE4748F6E0@MW3PR11MB4522.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vf/62riqa9OnSMCmVD2uVyTEuv1hUAUgMviVl9dEyjGeXaiGlLQJA8yMG0vB+kZLvhwumsYPb6MPIn3qH1ocmMC7Tnjp8Sd8BCXbWwTb5qlodKRsBojN5HrwIELaZZLEhG6C2nl7+uDebgfuFx0/0yKDLwuppzFZwuhpGaVH1gdLGeBpPQkb8Fi/YGozTClh51NH46rhoL8/4h99zJ8qnyRGy2cDro+I7AcEvx3ah4ncxQF7w3QihbV5FmBY22itNe1ixaHFJzT49HF66nsICRD4D4se1TNkW+U+TlX9WMccqoPt/54MxlgH1A0imRtw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(2906002)(55016002)(8676002)(9686003)(33656002)(478600001)(52536014)(86362001)(107886003)(26005)(54906003)(71200400001)(5660300002)(6506007)(316002)(8936002)(76116006)(66946007)(66446008)(66476007)(7696005)(66556008)(64756008)(4326008)(186003)(6636002)(110136005)(83380400001)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +y7+blNc8oBxlAO0Zij7bxODgbvq+aMwDnj6GHzjaGRP3YqNyWv3jpW4B1K3OL+3mZM0BKr2c1EZ7ovGWTelzbgb85hyKKoLpfxaUCuggFPZmHgoKUW/VYCKegOgxcpfgaCy14yYmZ+QmV9VzthEPNZDJU2AlmwVov/biiYrXbEja/lRAsIywGgf9C/vC0ekNCBlguTrQdC6YE1a5cspLsVHgLSf/iWfcik6x1jAvZwu9gJrnjYY18a4gCFNrLfdJqshFsUAWaFaDj3GRqtUlsCwrZBW9vtbUdpj+HBsMCVo5Wl/cp1GXordEglkly75tNmzgeBLONzSsY+erI6J261jCYu2Qgr5S+xtXi8ayrHL+Brkr2Rn811LYXqyb5AnfmfS7sLHhGfL1v504L0FBlPfbLm3m+zH0YfU96wwVAv5i8NQypZnfG21VzYIhgH5nnGP+kDVLzYz6yYHKbOBBajl0rIJ5g/9gJnpmfFwiLXi23JHEJ7RbycjygnHq7qu
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f2a7bda-d797-427e-1169-08d81c5db993
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 18:53:34.3187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q/aLR2tOX9RW+6/tfL4fTfOe/dMKYluRNhedjXfPZydBk2yzqDgZHPRfRH+D0yOmC/6X43+U24Ov5O4Kcsz6mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4522
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, June 26, 2020 12:15 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Michael, Alice <alice.michael@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Brady, Alan <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.c=
om>;
> Hay, Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v3 13/15] iecm: Add ethtool
>=20
> On Thu, 25 Jun 2020 19:07:35 -0700 Jeff Kirsher wrote:
> > diff --git a/drivers/net/ethernet/intel/iecm/iecm_lib.c
> > b/drivers/net/ethernet/intel/iecm/iecm_lib.c
> > index d34834422049..a55151495e18 100644
> > --- a/drivers/net/ethernet/intel/iecm/iecm_lib.c
> > +++ b/drivers/net/ethernet/intel/iecm/iecm_lib.c
> > @@ -765,7 +765,37 @@ static void iecm_deinit_task(struct iecm_adapter
> > *adapter)  static enum iecm_status  iecm_init_hard_reset(struct
> > iecm_adapter *adapter)  {
> > -	/* stub */
> > +	enum iecm_status err;
> > +
> > +	/* Prepare for reset */
> > +	if (test_bit(__IECM_HR_FUNC_RESET, adapter->flags)) {
> > +		iecm_deinit_task(adapter);
> > +		adapter->dev_ops.reg_ops.trigger_reset(adapter,
> > +
> __IECM_HR_FUNC_RESET);
> > +		set_bit(__IECM_UP_REQUESTED, adapter->flags);
> > +		clear_bit(__IECM_HR_FUNC_RESET, adapter->flags);
> > +	} else if (test_bit(__IECM_HR_CORE_RESET, adapter->flags)) {
> > +		if (adapter->state =3D=3D __IECM_UP)
> > +			set_bit(__IECM_UP_REQUESTED, adapter->flags);
> > +		iecm_deinit_task(adapter);
> > +		clear_bit(__IECM_HR_CORE_RESET, adapter->flags);
> > +	} else if (test_and_clear_bit(__IECM_HR_DRV_LOAD, adapter->flags)) {
> > +	/* Trigger reset */
> > +	} else {
> > +		dev_err(&adapter->pdev->dev, "Unhandled hard reset
> cause\n");
> > +		err =3D IECM_ERR_PARAM;
> > +		goto handle_err;
> > +	}
> > +
> > +	/* Reset is complete and so start building the driver resources again=
 */
> > +	err =3D iecm_init_dflt_mbx(adapter);
> > +	if (err) {
> > +		dev_err(&adapter->pdev->dev, "Failed to initialize default
> mailbox: %d\n",
> > +			err);
> > +	}
> > +handle_err:
> > +	mutex_unlock(&adapter->reset_lock);
> > +	return err;
> >  }
>=20
> Please limit the use of iecm_status to the absolute necessary minimum.
>=20
> If FW reports those back, they should be converted to normal Linux errors=
 in the
> handler of FW communication and not leak all over the driver like that.
>=20
> Having had to modify i40e recently - I find it very frustrating to not be=
 able to
> propagate normal errors throughout the driver. The driver- -specific code=
s are a
> real PITA for people doing re-factoring work.

We understand how those can makes things difficult.  We will do our best to=
 rework and limit the use of the iecm_status enum.  I think we do need a ch=
unk of them in conrolq related things, but we can definitely do better to l=
imit pollution.

Alan
