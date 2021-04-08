Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB97D358A17
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbhDHQtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:49:09 -0400
Received: from mail-dm6nam10on2106.outbound.protection.outlook.com ([40.107.93.106]:41384
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232394AbhDHQtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:49:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JO0T4k59MJwc4Y8f7Ef9+gqMYT8QAp837m29TZE94O4LRqhYX7yqzVO85UcR1bHPCCMmKmPZQKnk+z7aGOsmFYEIrp3Kp5q8IbBJYkjYkvGMkrZ6vtJ2b8u8C7XP9/PenrL/n9ZQXgPlKX1zbzAnaZByNCkUPT/3M+6rFhn/Bd5GMVwGOTt7hKkZ/cHhlU87MkLo+vleW7cIYXDbgHUgiKk5qwvfoJmW6tvSmqXE5fBvWp04IHAR7UIdzwC+VwJGDxc1pP5FO890rYoiSbjuPjMDAFE/G2UdjKsbe0tn/b/yErqKneeZ9AVn88vorL4SsBsHivcLEyzdFBvdUbLOZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nc7sDmyXlYv8mEjgpUeXobyZNtoAyEKl/VLBq0KnLNQ=;
 b=VFzQQb6+OcgTYHQ/YrOk0UDTZmk5HEoZ5n3pXOug6YNQBGMh3f5VWsD1/WLaGKrz13vUPpq5zXwqtIFMeFkWTR7bC1cXsP+lAvl+/O7qhsNFV2NcceHyMFZ9IzY4LWl6+ScM1VAY7tT4MaWF+i8bQh479m6VX/HGBdvR/moED7u9J3awABlyoUmL7e+s394gVNISgMkUjkyhr8UqixM0A7WEIwTGtCLSu15LbIXIxisp78BWYnZkn135PvN/VKbc4H775dJ3CmUUWQCYTJNXucb91DVqPeblnehFnAFz3eWZDnm+s6P0WHb/RYfGzmbWo5KCDnte+L+iOeIaNuXf1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nc7sDmyXlYv8mEjgpUeXobyZNtoAyEKl/VLBq0KnLNQ=;
 b=BaEa8LPC0Y80qUbOwDoKUUbkY6HQzpiM1nyuR1vVHChn7m+/WSmcbuCwGxWkKK0H7D+Lhw05VexKmRL18MKuOnOEeQTpIHJUYpVQHhI10q4ZFn2opWwB3VjPOAaMRL0ZfcWgVk//gDKE7C3NBK55+HvWHEDjaF39cR42Ds4dfsA=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB1332.namprd21.prod.outlook.com
 (2603:10b6:208:92::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Thu, 8 Apr
 2021 16:48:53 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785%3]) with mapi id 15.20.4042.006; Thu, 8 Apr 2021
 16:48:53 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Randy Dunlap <rdunlap@infradead.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXLFfPL8irt8hn+U2/SmY55+fY0Kqqzi+AgAAEEJCAAAIRAIAAAPEQ
Date:   Thu, 8 Apr 2021 16:48:53 +0000
Message-ID: <BL0PR2101MB0930B8B861D30E7F181A43B9CA749@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20210408091543.22369-1-decui@microsoft.com>
 <a44419b3-8ae9-ae42-f1fc-24e308499263@infradead.org>
 <BL0PR2101MB09301FF0A115F3C8D9BEBC7DCA749@BL0PR2101MB0930.namprd21.prod.outlook.com>
 <YG8zBgSuFW0tmrYr@lunn.ch>
In-Reply-To: <YG8zBgSuFW0tmrYr@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=215056ea-6a14-4882-a3fa-a9c4af8ecf04;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-08T16:48:15Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c372a775-82ae-4fb6-97ea-08d8faae31cb
x-ms-traffictypediagnostic: BL0PR2101MB1332:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB1332DEBD9C4F4E3FDB3D6B93CA749@BL0PR2101MB1332.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v+hHcqdA0AgOrBRUN30lep6UmjK34MqT7K5SF+2Hl6YW43/zR0eIpQVMEw0ck+Jj/iRxuxvYcdGXq7uED07ZA+BVT8ZXJzdU6VISH0fRK1A0mvnTXZ5MPLb7gpq1UEF3p7r5wM6uFzX+B5G7/6/WWyCxJ4z0UnlBoUGyV3D81iZcp0LeTOdY5qUWMtgSkKl1/a7LOINWA+zo85oMDz5dW01KmyCex42nfy/qCxxfzGrLgzLC3DxOdO/sIkQGJJm3amsgBR0zbepnmwmzxyfDcwUlzv+Z1fgp7lGB501oaUMFqijkEE0bYzfTZlqovmybX3eioVLtmvcj/eTMwBcgxBvBzQ+ul4j3XCqt0/45baRwNIa0N3UbrrqUNPt1VuztPrBMZSxYUN29P8z9sBWvz9qYJDHqQlOUQA6TJMNNXkPtcEC6LvJODTzWksNpF9DjpBWbI11hkxBWHOe+8cZd76RVDgfOv0IGU/KxAkDNwcUI9LNq3QB8sKgoIt89HYvtWGUrAUpXAwR7CjiZ7DUvMlAa55OaqUyDzjw4qZ0Mn8XFENgXLJdKGna7CUnR+H3r0x05ZNPTyxos9Z+1SiOEInOfAqGUUWpWsZjYjHELOdONAS3gPwOuB09jTTb2URUoDO1i+PWNKnaw+L8lhiybwkfJdcytabXXCHR/EogGDH0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(47530400004)(186003)(7416002)(83380400001)(66946007)(64756008)(66556008)(66476007)(52536014)(5660300002)(316002)(7696005)(6506007)(53546011)(478600001)(54906003)(8990500004)(66446008)(86362001)(6916009)(10290500003)(4326008)(38100700001)(2906002)(71200400001)(76116006)(55016002)(9686003)(33656002)(8676002)(26005)(82950400001)(82960400001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IR16OEfHgkvu4wunQjLePm4ose4JHfddOgaivZ03Y7WNBSXCAF6Gn43rR9PU?=
 =?us-ascii?Q?Se8x4MuygligSJV2V2gu76NSs7NN2ZOIJm9+sBpwNLH7F6och2Y7yP3gStxG?=
 =?us-ascii?Q?S1HZggeWBolLB/dXGePrJdPIUf/xSfAb4PG/DklJSkRYsbgu0c5LwiwKHZjv?=
 =?us-ascii?Q?dnCK1RpBd0vM0UAGyIEiStJ2BGxP1sGF/koJGPhc4wTMZNtZPLPjNkE/BGsa?=
 =?us-ascii?Q?yWu3w02nFs0KfVTQeUIZZGXkoxZhQgMTKqZ2bL9qhpfBpbQ3En1TUUIpZbzB?=
 =?us-ascii?Q?0f4gdliLUa216nMSOZggJOE3v1gbWiw0XjYOsrhXY952uPmWQZwTeDBu8UYg?=
 =?us-ascii?Q?dRxPveBs5nZfZhilcupE3RPB7lmhawFtupnVfPg/lxrNRohtvthxlxiHmRAY?=
 =?us-ascii?Q?kvyz4qCMHQHLtSbWeKJxTLh8xEWeHHphPKc0zN3aS+IE5QdjJILJ+mkiIz77?=
 =?us-ascii?Q?Xi0DsGoPBbkqLzk8Z0fi/a0wIZBj8uFCQ+7R9cAzyTlWxFWrlogctBffFypp?=
 =?us-ascii?Q?Kay0EnGlG6wUnt+FcoFWV+wgoCNll+bBUqWjaCbVEkB4/uNCbz3LTe0gPUH5?=
 =?us-ascii?Q?75xinPOPBOUrBv2r+CmgG+jp+xis0cfMjcp8cU8cvrg1+96nwzcINVviYBgb?=
 =?us-ascii?Q?VQegVfD1N/dvdsmlmge44W4unU85Gy7RIl3DFXoYSY78FSruTYoEi+luO1ZX?=
 =?us-ascii?Q?lN5GIxFHyIyEOJ2HWe0aosFflvIv9j32bP9stvGQT6z2KM2sBOOFQmLMKGYd?=
 =?us-ascii?Q?WKsTTydTvLzVPnwdbLcZUXq5NrZO58MJS2tLKc9BszLenTVVzpPqLr+Nc+R2?=
 =?us-ascii?Q?lLuufpuLbdGT/J5NTGKZzOwYz46IfIQxTd5L99NHjqHIaXeCZ4s6UCAckOc1?=
 =?us-ascii?Q?VNRn9rSrZWn/SCgMKuXIZhu3BCh8x80DccmFKBG9oP2TScyDLjFOmKfElduA?=
 =?us-ascii?Q?qcz/duQcyZvTyg1/1XP4Le1p8FbA2VB21PMaN6Z/zlEE5go8YlpYwgUqGqDV?=
 =?us-ascii?Q?YSuylxOGIOezxHIlW0v54lo20o3uJ9fNa9Qg+uTGOfQks/wNIjR6DNKXxcZk?=
 =?us-ascii?Q?5A4zddnofozT+mn13bEEpHoxShL1/ZkbSdBbcX+T+gE1O8Qb3fFNOWk4pfY4?=
 =?us-ascii?Q?VlSNrulE1ncyBPMhrRqShSwKY7gsEf1UcfvsMp7rLesSBBm5iPhuRp+69vIy?=
 =?us-ascii?Q?71CV1Igca5RYhqwqJIJCPWlN7GcrkymhBJvJ1v/5xuE2rPLEc+hhTx8QKiYA?=
 =?us-ascii?Q?s3o6YI8LtDfZ4HF2tQV3tP0lOCw1Kys7WC0ijm0ECjaGN+h4NMX3zDzWP0lj?=
 =?us-ascii?Q?Xh3q5wT661dQrU0ntowhFWTt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c372a775-82ae-4fb6-97ea-08d8faae31cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 16:48:53.6886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dai3J52Ak8OIQX2M3HsrH3gG+/f84IfJ4nW7aLJCn5HPlT+bKlZa8/EKoG9O38kBjElRDe7uZJJYiNQk/rlCxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1332
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, April 8, 2021 12:45 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>; Dexuan Cui
> <decui@microsoft.com>; davem@davemloft.net; kuba@kernel.org; KY
> Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> <liuwe@microsoft.com>; netdev@vger.kernel.org; leon@kernel.org;
> bernd@petrovitsch.priv.at; linux-kernel@vger.kernel.org; linux-
> hyperv@vger.kernel.org
> Subject: Re: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Az=
ure
> Network Adapter (MANA)
>=20
> > > > diff --git a/drivers/net/ethernet/microsoft/Kconfig
> > > b/drivers/net/ethernet/microsoft/Kconfig
> > > > new file mode 100644
> > > > index 000000000000..12ef6b581566
> > > > --- /dev/null
> > > > +++ b/drivers/net/ethernet/microsoft/Kconfig
> > > > @@ -0,0 +1,30 @@
> > > > +#
> > > > +# Microsoft Azure network device configuration
> > > > +#
> > > > +
> > > > +config NET_VENDOR_MICROSOFT
> > > > +	bool "Microsoft Azure Network Device"
> > >
> > > Seems to me that should be generalized, more like:
> > >
> > > 	bool "Microsoft Network Devices"
> > This device is planned for Azure cloud at this time.
> > We will update the wording if things change.
>=20
> This section is about the Vendor. Broadcom, Marvell, natsemi, toshiba,
> etc. Microsoft is the Vendor here and all Microsoft Ethernet drivers
> belong here. It does not matter what platform they are for.

Thanks. We will update the wording.

- Haiyang
