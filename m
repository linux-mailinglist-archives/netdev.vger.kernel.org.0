Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF4646E681
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhLIKZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:25:53 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:9005 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbhLIKZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 05:25:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639045338; x=1670581338;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oSJ9CX+yaorFacgqMHsDss46nVZfOkNgl9RSPHR3DlE=;
  b=iJdY3maThD3BEcUWWf1QgIBDUOlZZeFb7OnfgLPCKwlrpLQWmqmw1on1
   a4WVGIyaJq8Pmr0XENNLMX/dSRu4XmoAQUPFWZEfRnqhEaDd65oe6AW/z
   4H8Xq+iCZV8j4Owtft8W+5RdCu6neokY5pb39PvR3tQUILrUnEJ0WRT51
   qLEnDDOJ9zsveRgqIpSciiOGRL1aZs/dZO6qg0JUP26RUTimT0RjbND5F
   jtz1kG6tnwxTW9vAtf7knmWFNXmO9CnUbjbhFBSPsthFTP6++FD8NiiRs
   T5sr3fOzx/oo/mf37B1EatW7GUDe3d3eIE66vesrZtVirySpvxV4lF7va
   Q==;
IronPort-SDR: QZfVlXSzAlQDq3VAuqul70tSci/dk6Rmj9NX/5LGCnXEW5n7iHMXs8mez8AKmwZZWlH7aRSGTi
 xM87fdv0WmBryhezfHJrInC5epPQUyIheDVUK9EmLZrHxZ4tQ66OttZ27CGLOHtTqj4OdtFb7L
 tL8Ouj9OH3T5XxFYrA9R6YW7nT8ZQBfpoHUM7NFLRyZh9WMT+TWE+4ZlmMwFi57nAlTnfYvNT4
 htLbzK0PeS4mFMxDfzuc1NFBTFVYeHRsznhY21gzqjD2hcRt7fw0B9UfyveJWW34llGTMTMzrJ
 J0pdoHlWhY2vBTp5wBcj7eBQ
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="146642872"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2021 03:22:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 9 Dec 2021 03:22:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Thu, 9 Dec 2021 03:22:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbmwJ9BJQAGGrcbHWzEYI0FkOtz1s5Cy+M1+0gXuzmJ96sZNTa7I0XUXQpgbFG9w+tPmEkYwud4ngXovQLJHqTtgk12Z7EVinIxyjOlSYghj+CCmnPWLYlImFgrPMO/uWAKxaoRtbss2XqVj/v/sxZsxBHfYVnY5BL6C7E3l0JHLSXWhqbKUzPDH4x58LGg0BnyvyL8qvyCv/UPCj5cMZb+m5IOaaDlwTrA01ecSMf4mvPibwK3cxjjNmarFVESD32E6nGqAObCuKCS3Nx941MVgFHDB+r6EEPZrPec3lt5V0/my9GXSA7ivClWfioHbEbaxxhPIjnaYNNsaAICWvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mOwJMVtdrTBTJwWfG1mV1DjN7+B0bZkLgYPk8Ry3WwQ=;
 b=GMvsEsOMF64tilvoMy2KoJyk5jmp8DpwVcYLxKdAixWObvSIrW09tBZ6TkFGkv6bnDdOebeJfAmqZCCncPu0AkV0sTLiaicehjQTfoMkdZ9jj9oChkx3hPDRk2Rw3Z+eBLdVO8duCRB7pJAfUMhJ7aEiye73Y6R+CF8k6vdHbkwDy1aBdkaYDjP8LJmiB35YEECK1Plc38C9IJOqyK9bZjq61bb8vYEuxE+RSEDLgi8EsP7fXmR5K82nVOyD37rPLnEdUJk/X0H9JNDU0zrALdY3NGFwcFJ/Z9+nJZA5l39G3jbug7bmiX54hdAV89cBuj7RmSxIdWXG2ffiZ716ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOwJMVtdrTBTJwWfG1mV1DjN7+B0bZkLgYPk8Ry3WwQ=;
 b=TinR1Yo5P6JEVY8rcy9N8iplCKOBTNhrV0hj1dA0wYwnUZX6CzCz+GVmUEeeOaDsR7euygdZaVFwQp7DfpSiP0OZohCNd3XmMu0BpHMEjI4N+5jeuCflxVftgPKS4pGkWLB7m3Bi4h2R/4ek2UmskZBQ3+YTC1XxTw4Wtgzv/m0=
Received: from DM4PR11MB5390.namprd11.prod.outlook.com (2603:10b6:5:395::13)
 by DM6PR11MB4154.namprd11.prod.outlook.com (2603:10b6:5:191::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 10:22:16 +0000
Received: from DM4PR11MB5390.namprd11.prod.outlook.com
 ([fe80::61fc:3bdd:45de:82d0]) by DM4PR11MB5390.namprd11.prod.outlook.com
 ([fe80::61fc:3bdd:45de:82d0%6]) with mapi id 15.20.4690.030; Thu, 9 Dec 2021
 10:22:16 +0000
From:   <Thomas.Kopp@microchip.com>
To:     <pavel.modilaynen@volvocars.com>, <mkl@pengutronix.de>
CC:     <drew@beagleboard.org>, <linux-can@vger.kernel.org>,
        <menschel.p@posteo.de>, <netdev@vger.kernel.org>,
        <will@macchina.cc>
Subject: RE: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Topic: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Index: AQHX63m5RC9thyxmT0S34SqWhDegYawp9Ydg
Date:   Thu, 9 Dec 2021 10:22:16 +0000
Message-ID: <DM4PR11MB5390BA1C370A5AF90E666F1EFB709@DM4PR11MB5390.namprd11.prod.outlook.com>
References: <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
In-Reply-To: <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Enabled=True;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_SiteId=81fa766e-a349-4867-8bf4-ab35e250a08f;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_SetDate=2021-12-07T16:53:12.130Z;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Name=Proprietary;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_ContentBits=0;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26a4bbf7-a6d7-4680-cc57-08d9bafdc625
x-ms-traffictypediagnostic: DM6PR11MB4154:EE_
x-microsoft-antispam-prvs: <DM6PR11MB41548EE93A0C76E30B836001FB709@DM6PR11MB4154.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KNBpBjaIkDuf3JYSfltqPhGn7n8k+QId/qKcx+gTno7BOy0k7FpR6MUCe5ty57ZnfVEHToAuP0CI+eIxAPwB2yrDWTopqOSIXy8AhLli9dLIfxOJhLmNI+uKJwL7MSrHa/dqIg7xOOeimpviWT0v7w9ZDtEWsrwbN0QjUsp4emAvVwl2MAyI+FU07XEuy6T1QBm3BMXnwUInyzRlp/uFb5oFooopYyh/6NP3VHXWuAbqVl+Q2fGOz224UVVY/MSBc0hSHz85Ce0N3KAsVbQKtN0Qd6uCw+6R6SOegbXD2zdp7EnRlLWi+D0fmrIaxu1TB40rvRvEwvyKCinZK2BePGdRuEYHC+4UZmQ9YS6apD8qwJUP1NfZb6ZnOMWuSEUGiPL1E6rgJAIwTtL86y4E7+zqqGOUaOwMrNk4lPIydN+guHBxv5CBgVqwO6Ri+jHbSjgCQ2vy916Dvz2Dw//40RkE/E6zKurUdOZfkKunCZAsZ0kPAZgqEyt6aNsDL5Q3Qjo7oCoyhmczkmeStuBXLpiLUDOit9VmvMQ4AJcY7oq6aD8u3obCM4ndF2nVhhzLjwfrSRuPrm6d+WCS2g58kto03hhaizfL7wYjCgLpl+6dLbLq6CiOvvvrMVgyo70yAc1wXunxVxNwvcIGOflafbXBRDk8aOUOjJ8871RIuuaxPJGJZVKdxcNDO3Py/qC154AHmUmUPF/i5mvMsdnbwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5390.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(8936002)(508600001)(83380400001)(4326008)(33656002)(8676002)(66446008)(316002)(66476007)(55016003)(5660300002)(7696005)(38070700005)(9686003)(52536014)(76116006)(86362001)(26005)(54906003)(110136005)(66946007)(2906002)(122000001)(38100700002)(71200400001)(66556008)(64756008)(6506007)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9F4Xjxg8ectk3K1Ihc1Rg2+Vlo2d0mvZZGWevSVgZE8gztyRqfKXvLllq7pB?=
 =?us-ascii?Q?yAJOTY7dV7y/k84HsssY39d+t44EJD+gxq+9LUtIr6di/u0EYUzl7IsNKBVC?=
 =?us-ascii?Q?ByBVktRvTTWWyr7jPGZLnrT5TpSahHdhj9NcFBRKVuNwoQOigzJzq3rR/eb6?=
 =?us-ascii?Q?hzUpe/pUnAn+sSqJFmcKs7BD8pg13SM8Rq1Ju2vyU1FgGQKsHpgCgTRbeGs3?=
 =?us-ascii?Q?oqEp/23pXb/HDLFO2QzeyJNdbWjGajaFcWDsG6OrHgSM0HoGQvRz0FUSeKg1?=
 =?us-ascii?Q?zQj5FCm1VFd7qh8yxw0o533I4Gh4pXmMvYyrUjFV/HJ46lMgAkuAVO9WAst0?=
 =?us-ascii?Q?bGh9EogQaUD/sM0KxD2wf6dQL7PX0S84C6lKYetVoHUCGp+7l/h0ofTqoIfj?=
 =?us-ascii?Q?WSGBA/0byFjdlk4u0lnqVGVWXi9yL7GRLBpD996zyej8Y7wGZkr6GaauACOw?=
 =?us-ascii?Q?oouHxgE32wdFf1w5a/+AE87Pw8/Hy4EAh1pT6Q7+6T+Bu7/JVAbhTVo7bWdm?=
 =?us-ascii?Q?ltg2aOG1SQ/L4dSExpUGdClXhrIMgyjVuvMOnx0N7Brr/0ToC/7y1tHb25I3?=
 =?us-ascii?Q?TkKGKavKHlfk4imCyQMrrcGDtd9unDB2xuBMPI59G7OAsryvdEeMBUfTViYg?=
 =?us-ascii?Q?ic590URgC7QLkiigTXPD9jVv/YxqD59pE9HsxGV25kry5SzKVQTJW4/kcT3B?=
 =?us-ascii?Q?hkkTHkuZ8IxLsWYvof/qY4rJGCcZUYjQPtzLJOwd0+l7LcmZF0p7F9EiQdzo?=
 =?us-ascii?Q?mzCJnnU4KjJeJZsElE4f4KCneX2ZR7Gf/sgZbQHZw1KFqAkIYBaLXVLlOdXz?=
 =?us-ascii?Q?qUn1FaWA0xpgmfTQyyN/R0Suis5TqHOIoj+itWbNC/LJ5uDr6ISYuB/3hGFu?=
 =?us-ascii?Q?nCHdBSgkQMpL9cZrfv1Fpn6TY1flKnHST50C/42jVqvoCJEt1ek8p8+mS4iX?=
 =?us-ascii?Q?0PjuzQW2udByc+vLktKFJF7BoGdQbA7a2VGuvfYGfMDWMWBECEUV3YdCmmNV?=
 =?us-ascii?Q?9pTz8+4dDlrklr+zfolPurEtsSeQZ5e6WLOSjq7I2av0Frbz7f/5VpJehYBC?=
 =?us-ascii?Q?ebXShfISuQZNYfg2pRPIneqnz0JACBF3qlp9umJa8E6Y1aJTzQzhmQ+D4J2o?=
 =?us-ascii?Q?r5e7BYg7smFQXmRumfGIhOBcEvvaPZMPL0Ys0QLQd1toSXyVk2q7C3QGRGwG?=
 =?us-ascii?Q?mtGPz63gbDMNZmplPm1n+lMqYXI2+hMT6qVkVr7d2iLUPsVXLaOniknkN2Lw?=
 =?us-ascii?Q?Lyboi0R1dAWudkrifQM5ttMLISTYEMQWzmY2NaDKfQJLRzInVefu3Z4mmiI0?=
 =?us-ascii?Q?zoiyf1Bn+h6vOvniC1PN9MqHFo1dzk45WnD2Irw8hdIK3YTriLS5u8X2PAGt?=
 =?us-ascii?Q?yXR/DX1aqlSENV5s/PRa2YXYd8wkSewVCGJX9Z3+D3GIBehflSTiCiDiYgnF?=
 =?us-ascii?Q?/sItkiFY/fIojEKvlu/iBm1LDzkO7FOaEqitlTt3nIF75Wd0UCLuJ3ZtaU5y?=
 =?us-ascii?Q?zBFvqhuE3rp5k5pNYa0CnWz9WAmjHLBuDnZx09ERBxT4k0XtFDuOTfq0lX01?=
 =?us-ascii?Q?YlEaXN+MmNX36dB5Rwo5810aS/HINrIb7hf9M6fQEXXZBQTrgwiOzDhJCaC4?=
 =?us-ascii?Q?nidq0xHKBYqlyqjid+WwZ/jjllEw7PGk+Yxeivj535kZBXy2Q3B97afohLuq?=
 =?us-ascii?Q?hgKMJg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5390.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26a4bbf7-a6d7-4680-cc57-08d9bafdc625
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 10:22:16.2727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d8f1Sq0hRxbOVBktJQ7L8vvtXFVMH9JTOWR8Gh1Ou9UGg0pGX7c3bK9au9hoHNotLX7IGu1vGaJ7eszaUUfymUt0x882Xb4Qmob4v+hgWoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4154
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,
=20
> We have the similar CRC read errors but
> the lowest byte is not 0x00 and 0x80, it's actually 0x0x or 0x8x, e.g.
>=20
> mcp251xfd spi0.0 can0: CRC read error at address 0x0010 (length=3D4,
> data=3D82 d1 fa 6c, CRC=3D0xd9c2) retrying.
>=20
> 0xb0 0x10 0x04 0x82 0xd1 0xfa 0x6c =3D> 0x59FD (not matching)
>=20
> but if I flip the first received bit  (highest bit in the lowest byte):
> 0xb0 0x10 0x04 0x02 0xd1 0xfa 0x6c =3D> 0xD9C2 (matching!)

What settings do you have on your setup? Can you please print the dmesg out=
put from the init? I'm especially interested in Sysclk and SPI speed.

Thanks,
Thomas
