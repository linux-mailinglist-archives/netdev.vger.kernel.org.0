Return-Path: <netdev+bounces-9700-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8314572A43A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:17:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9358D1C211A5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC3722D43;
	Fri,  9 Jun 2023 20:17:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EC9408CF
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:17:34 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DCD1B9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686341853; x=1717877853;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HmWwI5k7KSQY5dDqEOBWAGuoUoxJQBPTsHn3RwD2IU0=;
  b=SBxHRVOwm2vfoixwQp60z114zed0Yhc1knlyUVkWPxMzFDWixa7szwRP
   CcX3bZs22KAvyjCSR33uOyGo21IEw44ElQiDgwKcPDtD2VDGssgzZP/V3
   /M5JTOEvCo9qSfrxnATohvCDgwznKCL/r61vhCDx/YDe1UCak5mffCT34
   VTiEWORDd1jOr/wKPOMo7tr/wo7Hnbh9P3koNmRWuPy4/G3LXF6DUKoJA
   PeHo1CzlAzpUU7ima8lWONeh2QA+p5FhbmuB9YWY2LSuEGDyVKU3UAP8A
   zOn530e2VSZIINOn67KmUQe2MoAqmAaJgKUoBrWvi70hm5fn+HJ65j+J8
   A==;
X-IronPort-AV: E=Sophos;i="6.00,230,1681196400"; 
   d="scan'208";a="215415269"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jun 2023 13:17:32 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 9 Jun 2023 13:17:07 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 9 Jun 2023 13:17:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGs7czWrvRspjJY4ftF8UxvHARikR2eFE9lkCaRptKGrKo/usxqBueE/ArSVSqSZOyyZXWpJczl29PjbEfdMbBDWZQkEZh162CKDyKH4rj/qsX6h8uXnh2CtFYx/N8IlCALG7zATxvFkBMKXVykMI9xycPZYBvZnRxa1RdGj7m5s+7qfGlgySQcKNqQ7XtC9F+VIRgyJ2gxOXW73H9kVC3XPQb+lH1TIn8gTWD0591DTrA9z+s3cL4+lG0j9F/J+bQJRZnN/bumvNOrqV9LrlfVfK/A/3ZLM2kA6csfcI3Fa/rZzy+fEKyW9elnrTo9baFNZ85jyhVFnVTldCwogMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5crYi/ehPDAsxEX5t37DYkVVMt3SWaZW1jjD7SrW8m0=;
 b=OPZYyHu4t1FSaLRshuxKlzoj8xBkeAIpHd5hyKkRsJ6bLu6Q+u+hJt01Dw+qsI6Y0Jv5olt6wtQz68/oDY+zzRu6gk+att7CL0wdYC3EarHM8zpRw0oiScmkHMcfQ7wzh5H7SKleVASkw1EUaTEqQDovPV99/wObMk/KvF2H61ga8Hatr+nSO92C+vKJ6OfjrzVohpeQK+FlgLICv/pNXOH462Xe7V14auGjfNU2XwDW3G+3BrGoM5KN4B4UduKQZgQu9XO4TeufDcJqsc46Ew90zjkbfUN21V9ueW6sI1eStCco7dIO/vcbYbzhJWteK+/lsgGygBvN1z6PUFE86A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5crYi/ehPDAsxEX5t37DYkVVMt3SWaZW1jjD7SrW8m0=;
 b=m2iqEUQM+C8T2oiGsn4CZs4OKQudvvqRHe7M5JHiarzCnbN/6bXz7muQ+2t7TcFdtp5qDsZvtn/J+VJpceVdUp/ra0owVxLLcAQRF/dcnC09aU/rh2QQxnCDzy1gt+kMFBFVuHvhZZZRhMtt+CinPYbykZxFoz+Id4dk9GBBqiw=
Received: from BYAPR11MB3558.namprd11.prod.outlook.com (2603:10b6:a03:b3::11)
 by LV3PR11MB8481.namprd11.prod.outlook.com (2603:10b6:408:1b7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Fri, 9 Jun
 2023 20:17:07 +0000
Received: from BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::9617:4881:ecb2:7ce]) by BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::9617:4881:ecb2:7ce%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 20:17:07 +0000
From: <Tristram.Ha@microchip.com>
To: <simon.horman@corigine.com>
CC: <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
	<netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH v1 net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs
Thread-Topic: [PATCH v1 net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs
Thread-Index: AQHZmnIXLg09bmq/9ESQkTrC8RG4oq+CZFSAgACEYuA=
Date: Fri, 9 Jun 2023 20:17:07 +0000
Message-ID: <BYAPR11MB3558494D2D38F58083233D80EC51A@BYAPR11MB3558.namprd11.prod.outlook.com>
References: <1686274280-2994-1-git-send-email-Tristram.Ha@microchip.com>
 <ZIMYxaANiLvd0blQ@corigine.com>
In-Reply-To: <ZIMYxaANiLvd0blQ@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3558:EE_|LV3PR11MB8481:EE_
x-ms-office365-filtering-correlation-id: dbf5ee61-ce73-4056-9c85-08db69267f9d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CZZT4r66Itg+idOLb+enUQreNXn/jxi3XzoyLrU4WjbjAIaFQF8y1XIVkAfJrc+Eu2BZZB7Cb1ocD3B0kWLY+Bc907HcvpG59AVSvSAquiRNrMvBryM5fDbaAH9Ze5C+Sho8sjXxnoJCzDk9Q+R661Q97GzscGxlymznQZzLLWe2V4xzpmHX/TXGD3a8kYeV4CWtiKF3AxuONeB0J3YxGwMgaMM2G0iRVCRH1neSTQy8Wqis1YkWYZOQ4BKMJYeiJOTsvjBS0OSxTXg7aC2rE7NLnWusI8HL02Z9fzk1hFMSMjzQi1SgFpJsWV0M9HlwY7htuBLXF7URbWGVICfxUEbn5ZUboR+18UfqcRII14O/2Me38+AnT7Imkb5MA4oqjFnfVNUhYnyoRPk5dKA541O85NWfO5k2V2g/U74M0pfihrCUvFP0XJtwxz4GM3MvoRAKVwfllSfMbOGur+5h50EMw0+Ev8NuBH+vJgZKq5P5hTt0RSbHXxqt1YWXzgjiK2H1rjE8d64LXiWsi46mWr/PnSXEEoURGXJORge8ksqKJRP3v60Xu0PtaUPAPPkPO/rMkbKlvqsMCCCJCSlQ4rb20dAUPN04S3UKCe0Z8XWkT/SI/tJK2ubamFWHCTC7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3558.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199021)(4744005)(2906002)(38070700005)(33656002)(52536014)(86362001)(5660300002)(55016003)(71200400001)(7696005)(186003)(6506007)(9686003)(107886003)(26005)(122000001)(478600001)(54906003)(6916009)(66476007)(76116006)(4326008)(38100700002)(8676002)(66946007)(66446008)(64756008)(41300700001)(316002)(66556008)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S473jD1fxQd78a9n+5aGVM86c2NTMs1Io3dS2+hWvQTrIydPJ/ZlfSCMacqG?=
 =?us-ascii?Q?AcA37oYMx6y62u/lJjUg7BbKc7vZCPPT6OMKqHfK5nmsjSFPyL5LUbe30+nm?=
 =?us-ascii?Q?ipqVOl8BNNBwLjGb1uDsQvmqeGtpCat+b9dV391Tr1PbgHo/rTQRQh0cStD0?=
 =?us-ascii?Q?jxgZwFlBFlTaltwTyc7Yz2rLytES886GtDZeNhe7mDjHmL8e6fW34UWToWlC?=
 =?us-ascii?Q?kSz603AzJ1CCbvj1Nou5BFqWq4z7ZCbXIRJzy1uzyscpXy/HNfMY/hJARSi9?=
 =?us-ascii?Q?/MBLbdaLX/JJYB/qyUwxfH//J+HZVO/Cr/FbHBq7+w5NE7C+qSJ2pmgqAaA5?=
 =?us-ascii?Q?Jh+fB6jKs2hf9oglR2K433n0ZvX4G9w8Jd6BXYG4noOQB/dAr/NK37EQ3EFq?=
 =?us-ascii?Q?jxJgB7LLcxr0bLq/altnWjJjw7f3d+DQ+YTlOaNsLLdXBO6UxSfsr6AQ4Diu?=
 =?us-ascii?Q?KYqNpBe4wwzopjWJUD4jQ7bkeg1ZbMf/0x1OuGY+8XBQRlLnzfdbYc1nsGxC?=
 =?us-ascii?Q?+s1Qwh/pxkp1Gn6G855T59uZkZk9CWeaSXlWT7Qj6dSBxh+UXDKtejTvQuij?=
 =?us-ascii?Q?NbNAGME9wgZuxpL4L+1VhF7QuacN/wxoLSzYX5g4e8CzOU/Z+IF7Fsaq0rrv?=
 =?us-ascii?Q?ubKYddPHjbZu4HkLXFztJrRaN7PipK7NC/0sN/XKfTCDRUrdYEc8mESBZH2l?=
 =?us-ascii?Q?OGxxVFuF2hC+kHili2PxC8Q2MIC3peK3oi3saEUFoEbsVcPg/+qATRH11ebo?=
 =?us-ascii?Q?YiRRTRvAGoVuEKRIMU2jG17fOe91FwYcABLKdYqm1Vx/unzk28QvnnyWi5dk?=
 =?us-ascii?Q?NeRB981tp+kxfnvjkygaxuOv6OE8lWBMxQzfDPqmVtXuMfw+Vl+6xhOJqjwG?=
 =?us-ascii?Q?jxGx2xK8sTdhwo3G0qG47QxPwalh5eEXKG8wRYleHrylOVGSh/EEYGZyVvSU?=
 =?us-ascii?Q?pOZuwNbchIdRIbl84YNCfKsif/n2rNPtddOLuB0F9DO2U4DpAp46W8C8fAaZ?=
 =?us-ascii?Q?Zvchyqsd8E8bsQHhbOR/RzUwFUkTl1qlUveRXU8Fd/wQu0By5XA3FoSq5aa1?=
 =?us-ascii?Q?CQoRB3v131VOQONgzs3SMqHCgNmwAI71x7mTQ1/ll1sWl+JJR2sH7CoM+YxL?=
 =?us-ascii?Q?HKIAYgHEPBk3OrA28yYGAVtDzQaTf7jOg/nFso4FMVbkz126O15ZsZmAFDwt?=
 =?us-ascii?Q?vDaeE+rD5d3RWK97JxdFh0C9G0r9XUTaI2dyepYQTqQ8o4FaAosKeGj6sSON?=
 =?us-ascii?Q?890MLoZ6VjT0VB88mUfGmAfFnFcQ0rFY55r2vXfl3biT6XfZ4GZ2rbn4Wwdt?=
 =?us-ascii?Q?sERNVY1tC2VEWYIx1OQ4tyqVu3kqb6ki/CbDNcUVyyfE3JCoo8eEB5BaZgdo?=
 =?us-ascii?Q?G1mbDD2Ykm3BSc6vQkYfOJ/Qtk3l17F+UEyyqNmOy36QXUSwvhJaIUbGZ2fy?=
 =?us-ascii?Q?Vnqaksoiu8c2Xm3KOfACvMoiXFcJ1aFQD38Y0OlNmbEWzVGV8MN/7gbtdYwH?=
 =?us-ascii?Q?oPjJTh3RKAdQEWdb3U3V5PkXUoKwVaP1uDd0G+iqLpLvjZGRe42/f9gqAyRZ?=
 =?us-ascii?Q?lvxL/ptTk5Cku0zZw2Pzha4XqneM15uscHHnAz58?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3558.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf5ee61-ce73-4056-9c85-08db69267f9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2023 20:17:07.3675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jJrSCZ9MGnmCpT5OiIIGcoEjCiIFEsM6tDHo7V/HS9buet8XgyJgbLM9vKcfU7B+m8E9fd3XmexypAPo6y+m72V0mhmk5ToCdwv/tJvJ5Xk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8481
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > +#define MII_LAN874X_PHY_PME1_SET             (2 << 13)
> > +#define MII_LAN874X_PHY_PME2_SET             (2 << 11)
>=20
> Hi Tristram,
>=20
> you could consider using GENMASK for the above.
>

The equivalent for (2 << 13) is BIT(14).
It is defined this way to reflect actual hardware register definition.
The value can be 0, 1, 2, 3 shifted to 13 and 11.


