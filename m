Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC59A1A857F
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 18:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437530AbgDNQow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 12:44:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:29554 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437378AbgDNQou (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 12:44:50 -0400
IronPort-SDR: cElgBHbZoUVDjzqHqCjF8x9eufpZtY3tzpGX0uK5TGfQ/3usRan2B9I+EcFlbZFIq0KP/hN8o2
 EMWuKYE2MqnQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2020 09:44:49 -0700
IronPort-SDR: vHPgi0iUoqhhkAhsOgx7mwv++pRCCbr3d1hxcXdJT/Bym4ITO0JUR5vnqm3Nq0kFgXJ3Tmdx+v
 3GMjwG6jvTog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,383,1580803200"; 
   d="scan'208";a="256570575"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga006.jf.intel.com with ESMTP; 14 Apr 2020 09:44:49 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Apr 2020 09:44:49 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Apr 2020 09:44:48 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 14 Apr 2020 09:44:48 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.59) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 14 Apr 2020 09:44:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPSNYxBkCoMFXUPo4Is+TO3qmr5DdcvXv6OTeuDOZLSyYDBIMqZgQ85Ud5oD9ATkQqLcd56HI2uOvmYWN5cvIoiUK+0lf6IKYm6yAJWcrJszcZc1O4oqOt7p9m6hOdwEZ6PNd3S9C8ILsg4LJ125VdA836kYTeeZeMIxiZa6THfcejDDlWsQM6UqPubNeRJXFbLj4c7q2QyQi7yqFbWPIoUwXAWnVPK84YcyFyjhYNG+7/S4IUZGOSo9wsNR5ayn7IekaLL9qFNIhk7ccaSLfVz9z88kQ9qlNzML8g/7oSb/+HejgpCSvdtArMMLdyPsLBjUZeZh24MdpLvhvpkkaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q/lhBrBJu8/RvJtrramEbrdHedUUhic/cp747EdAGs=;
 b=DCCdv8w/T5bZ5/QSAYOcpgc9fnw8P0GZuV6cdpUV5tOtBItNu8ZdzjM103PPxOE1k/xrERKKVjH9u9KSeEwyJkBfoldrihANu7WUYuaur2E5sqzhgSnfu2UJ+7hxjr6xP9nsx5oZp9G+wOswaxp6yJxp2OV1Qgh+9ZMq2MJMPFNR5k+n+gTXLBRtz7k/BIcs2Ouq+Bibx9mgRS0sUqEnP0op4Pl/uNBJs9C/F9qzjLbJejesx4RNeJ9e3GaBw1yp+0una9RKTDml+GwnVm2273dsibNcLUsqszb8sEnv0weLA3g3WHGQpLPQoUUigy2wXPk/+2+Z/LLqnu51S6mxew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q/lhBrBJu8/RvJtrramEbrdHedUUhic/cp747EdAGs=;
 b=eBt3Xy89HTZyyrc5sx/McWJ0dG1rFiQnW5j/3wo6K31vcuPR2qdsugZrBok7HHNynaSG/sXKVu1xJQb9BqHZtEn+X3ZSfESSmTDfBvofXHoAcpdFU7DbodcpYTLDkC9HYI7VMPWzHTN0TGMRLXPffhSz3CIHIPK16BdS60QuWzI=
Received: from SN6PR11MB3136.namprd11.prod.outlook.com (2603:10b6:805:da::30)
 by SN6PR11MB2558.namprd11.prod.outlook.com (2603:10b6:805:5d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Tue, 14 Apr
 2020 16:44:43 +0000
Received: from SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::4df5:24e2:ee20:6a01]) by SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::4df5:24e2:ee20:6a01%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 16:44:43 +0000
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
Subject: RE: [RFC,net-next,v2, 1/1] net: stmmac: Enable SERDES power up/down
 sequence
Thread-Topic: [RFC,net-next,v2, 1/1] net: stmmac: Enable SERDES power up/down
 sequence
Thread-Index: AQHWDoZeGoUeZLGEa0qZ7cIYQH4yK6h3ItoAgAG3dtA=
Date:   Tue, 14 Apr 2020 16:44:43 +0000
Message-ID: <SN6PR11MB31369FDE9E86EB85448E1AC688DA0@SN6PR11MB3136.namprd11.prod.outlook.com>
References: <20200409154823.26480-1-weifeng.voon@intel.com>
 <20200409154823.26480-2-weifeng.voon@intel.com>
 <BN8PR12MB3266DAEBA9F314B0D1515B4DD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266DAEBA9F314B0D1515B4DD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=weifeng.voon@intel.com; 
x-originating-ip: [192.198.147.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f62c045-a715-4d81-ba44-08d7e0932261
x-ms-traffictypediagnostic: SN6PR11MB2558:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2558780EB351906EA8BF682A88DA0@SN6PR11MB2558.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3136.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39860400002)(376002)(136003)(396003)(366004)(346002)(186003)(5660300002)(9686003)(4326008)(81156014)(8936002)(107886003)(55016002)(8676002)(52536014)(66946007)(2906002)(4744005)(26005)(66476007)(66556008)(64756008)(66446008)(7696005)(71200400001)(6506007)(110136005)(316002)(478600001)(76116006)(86362001)(33656002)(54906003)(142933001);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2x9+GE7s91j/rJEjL0fGzzUY6d4R3lZ4sta+E8x8hABG/xYhIkpiwbKOJn4rbSAUDKyOUa3/VhCsUfgL/W5NNL7XFx2bj10FMETXN/NF091chjJGAbOYn+DHQH/4KnxJwYo7Ek0K4RllhJ3jARJertIFEcnUWqxhaIVbPzjICX+Q3vVehnTGcNqK9y3RIg4oUN8JfMbSgcfH1Vn+4pAsiMMosvlK6+GD41yyz2Lu6KdEFlV7JTeSDjrUg3XPVhpcdIcKU3rGRBb7x0vQJtxEMvhvYf9ws30zs5FwDmA9w8NhiMfPEnSceFpVYwbxgAlj49fDobilmlo4WY16UQNUThUYm+yvxQIHOyCklT8LvVRQGJK9hCLyQj9xAd7QIxNk3mBp5s8fkB6APJbDgj7vddIutITybOchjWXYj5ZOUdzvStfd37DN9f8a910zQ9lg6PshoT/I+waZFUnibdngHPOACwgXA+KS6IsSvuuRuYuhoFApmUebYo7lEQl4QYdS
x-ms-exchange-antispam-messagedata: qN6MBdEco89xtmNAmyPEFxTJSShUSdGj3wkYdEN/9vvlJ0aiGNhwhBnpscOCKHI7bVQqA3yoecNNmN/VYiUf7tqmPQRBToVtVll09lScvC9k0cYlBFaqIVMsaCUe/eRR0MHYdPGutGSWnyJxHTO8EQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f62c045-a715-4d81-ba44-08d7e0932261
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 16:44:43.7089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uaAnf/wi8+7AGTmB+PwvnhUUoRMPk3AC1B+BUQTHpJg4D9hf6Bf8sWRZBRKg6DL7dpWBCAKCQlDZTSlyQ0k0MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2558
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Voon Weifeng <weifeng.voon@intel.com>
> Date: Apr/09/2020, 16:48:23 (UTC+00:00)
>=20
> > diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h index
> > fbafb353e9be..89c8729bbe5b 100644
> > --- a/include/linux/stmmac.h
> > +++ b/include/linux/stmmac.h
> > @@ -147,6 +147,7 @@ struct plat_stmmacenet_data {
> >  	int bus_id;
> >  	int phy_addr;
> >  	int interface;
> > +	int intel_adhoc_addr;
>=20
> No, this is not right to add. Just use the bsp_priv field.
>=20

Noted and thanks. I will change this and submit for v5.7.
Weifeng

> ---
> Thanks,
> Jose Miguel Abreu
