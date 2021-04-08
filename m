Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70D2358A54
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhDHQ52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:57:28 -0400
Received: from mail-dm6nam11on2131.outbound.protection.outlook.com ([40.107.223.131]:13056
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230522AbhDHQ51 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:57:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8wj2PHP5Tv4W9CSyYWVwZYJ1ZdLoTmH3Ji9PFXP0B/WsTmIOz5lDy/1lD8LUNS5jVbP+WNL/d5g+ZFUg/VduxARWBmfF7/6hNYFZSqECoJPabX1zOZYY8giRRKvn/recTYGBo0zi/W5nAXZGYBeNHfNtCARqGnWiD4XftLusDquIM8NjzDuV79vHL7fe60xLWyHpXVjeiEqmnUNziSCh1Xzg7Ak9SkmzGt9B4jZHcth56kaUIAudkXjENsj/eK3D0zhcOZYDu5vYOAQYgA6g8A5xOjZFZNnXxtUhnE5ZhkO4YYl9lX7890rQeDYG3V8fNcAWh5ESIuRHq6VNxSm7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//SCtvb0vAL9BDphnP1TuHwDrxEq1nLfpZ7sNFJsD/U=;
 b=kPYE1GuVtmKfKxPCgj/dV5/LKRh/U2sThbqBP+VJdT6FVZO0uRTqmFJXxVqE2iBW0tgnOaoAXLub7CnJxJ0Devld/xkM5zytAN04rvyp2gPI9vdVBzpjgTw5okY0aF5HTD/+4yoqOWIpPfPMnAr7ffdJkSazR3Frd0r9aBZG92vW0YnlvyePh3dxdecDuPcVT8B4/El/ugL+KSgXiYNpYBLb0Ryh8Beg4vbCwGusg6nMEB2GshyCIZfFXdlVqwBD9NOGVuq2bWqYpzeuTLgdTRSe2D2EyjBW7EQzIiLgdcPggQQTbAsb5U2nX7Jcrirayl4w7Jsf/rfObYzASJ9peA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//SCtvb0vAL9BDphnP1TuHwDrxEq1nLfpZ7sNFJsD/U=;
 b=BxLpWKqxl7jKSoeCX2HSsoGQ4oQ95PEs6XVW+AG6CmdY8dNQxs5ozh/JQe/9PjeZAeHlBEIPDaLsTvChMNJNaLf+k5ZlMPxoQRui+vLDKI09B2+r9/xkrFq/Hmu72Qs9fAWpUELoxcUkwsFYqeI2fTZojSWMH/nudpLE7816VVY=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB1332.namprd21.prod.outlook.com
 (2603:10b6:208:92::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Thu, 8 Apr
 2021 16:57:14 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785%3]) with mapi id 15.20.4042.006; Thu, 8 Apr 2021
 16:57:14 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Randy Dunlap <rdunlap@infradead.org>
CC:     Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXLFfPL8irt8hn+U2/SmY55+fY0Kqqzi+AgAAIOACAAADr8A==
Date:   Thu, 8 Apr 2021 16:57:13 +0000
Message-ID: <BL0PR2101MB09308B4967ACF983289F9489CA749@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20210408091543.22369-1-decui@microsoft.com>
        <a44419b3-8ae9-ae42-f1fc-24e308499263@infradead.org>
 <20210408095222.058022d0@hermes.local>
In-Reply-To: <20210408095222.058022d0@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=50f45405-e3bc-4081-83dd-33a0809a9053;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-08T16:55:39Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 579e0a66-895b-4238-1e73-08d8faaf5bea
x-ms-traffictypediagnostic: BL0PR2101MB1332:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB1332877BB3D698DBFE3BFE6ECA749@BL0PR2101MB1332.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NawMRPaTd2By88B6LD7zsHd0WgnzQwWQPFXHhXpjRysq4ly9NGQ6mzz3Kph2d7eNVbDZp85YMSTnAACt9OmaZp3cwYu39mtpWd7Jt3MfwYe9ceOgdNyRrTKQ+FO1E8XWE94sWuDFrgLZzuLM7S5Ku5FZrMDUgf8JnMyGsQP6RGL0xnnL5NiPiJf6uJFzs2K5VWE0AG8pRaK/pu/lv8566axqhOVVdPAotjoWsSFy6hYJQ4n6qcO5pzXiQjMMbmBxf46GScCTGDJ+ocVX5JU4bMMn7PONC3XV8BcBq6EN4BuqFnXXtBbMeRp/oWmTjzri20EllbUsFJ8GomHdGMPZ4pCLhsv7Wp7gZYM23+JNl0lJlG/t93AmcpFlTf1Or1p0RvtWH5K0+NtHiAbpaJuizDpJXceL5Gm8n77IooM8t/C2K3NTopz7vzVGldKq6qjyZzOy1IzbbEj0/YF0hEM1cnrNZLgvN0P1bIpF3or+O4GjHSSsgMTJELvE0mwl24wK3aWA9s7oZoV3/msPMlm/Q2iCFe0m4wleEDQigorh3SMyGwEYaB6xy2XcrJg6Qmai/ecB8pot+iD2oMilIxj3vG9JQi+VWD0CEBTfmyHfug2XWtVXhdlSXBGQdoeJ/PRUX1CvVU4H4Cb7IUdgZCegNzxTg3NLpSoo0z14yuL6e0I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(47530400004)(186003)(7416002)(83380400001)(66946007)(64756008)(66556008)(66476007)(52536014)(5660300002)(316002)(7696005)(110136005)(6506007)(53546011)(478600001)(54906003)(8990500004)(66446008)(86362001)(10290500003)(4326008)(38100700001)(2906002)(71200400001)(76116006)(55016002)(9686003)(33656002)(8676002)(26005)(82950400001)(82960400001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?jlBpq+bKihLyR7+9bzq3pKY1hfsnH0pjbckDBseoe9d5CycKkUvOEPrEUp3T?=
 =?us-ascii?Q?wTvKoWRKd+T1Y4CYA/37EqfjVJUHFoo8afSBsf2Se9XhQS251cW74TTyqV4D?=
 =?us-ascii?Q?bLIT/EXhDwe6iRld0s4oPbHAk4+RzZRYSLFwyDDl+cS+7+d/6nzc2dbFapgO?=
 =?us-ascii?Q?Svfc3pvoKXBzxvVKvWhTX0K8fGDDGSEUQyXqwwQFvplhqa2bI2QxHrT+/HrQ?=
 =?us-ascii?Q?qQb8mrf937mYhNVdps9vRC7FSQQgKFEykGpHQqMW2bI2SKsbPLp9MSu38iuV?=
 =?us-ascii?Q?gVxgqs1jr4HfdmJgkrUcB8yX1wZxb4k03wZv45gbZElGeN0ds301Y+WAf2CP?=
 =?us-ascii?Q?LClmWMhGr27jPj01/ZP/EBdqsq3j6VmUHyf0GHcDpxZlE8eJBoi1HgKsBxyT?=
 =?us-ascii?Q?ds4sl8iTwvuLLyOGP8F8azdrHMXlxG5Ac3vWE/xtNyVsYp3Aey0DFkRC7p9S?=
 =?us-ascii?Q?HkDbPVQTMWVCOp6XaWJZnmHY4U8egvM4QsqlQJi+V+DPbWwXEHoSLmLix+hE?=
 =?us-ascii?Q?EVz8Rhy9LuMQz9l4tFkr1F7mVh08a7ibiISnK4sUlPWRDUhjd/eZTOEDelkx?=
 =?us-ascii?Q?YdM6GR0tKoRvhW96HVimQm+LnObj2FK2dx+hGYzxBjfniLOIj7R6cvcYhoq0?=
 =?us-ascii?Q?3+yXpQnlFkuBgHfm+re1o+yWSodXwQf48Ce6AKjFEb0c3/Se/HF1+x/XX0BY?=
 =?us-ascii?Q?U0gfFDFKihddkoSgZHkqGbEvhuR1dUu87j1VYdQvk1mGbblDtAe9dIePyCFM?=
 =?us-ascii?Q?RlbufvvtMHfCoG079dWVv6stFK66TEtipUZQbJE6RrhFqGFDMmS+O5pR1/lz?=
 =?us-ascii?Q?AJ2/JPQnTm6xBscOxJzsWbAEuGC1QMfcg+mU8erTzgILISrafEvSgv9lR4pQ?=
 =?us-ascii?Q?M0PsIIFTSO+GaWwmYR1fvp8oxdVJrOv+UmliGP4dhIPjJZ9CpSSNa14UT37X?=
 =?us-ascii?Q?pH+JtUlayGZUAgXwXDGfvwTxBzxN8C8Cx0/7K/YS8gigGC/OJEZIaAg2bLzu?=
 =?us-ascii?Q?mj73r6xQEJbhOMDV/MaMMMYrtjjC6BSIf8AAkxFDvKOVGWJnS7XI/D0pSZtT?=
 =?us-ascii?Q?5jCRmqUtKUIlWx97Tj10QEVEejhPVw476CzqzDZdRyzAmR7H+uB9XsPive1I?=
 =?us-ascii?Q?OrKIskP767pN3XgmnhJ7K3fndo5QhMbD0W0MeHm3vLlNoTAqkWx8yZcOm9d0?=
 =?us-ascii?Q?VkWHXwLUFU4P2GblsPLGXSCf4sh0ulkT4Hyh+FW7xUZKGwQ4J/hzzxLx4lqd?=
 =?us-ascii?Q?9Y4/Q7TXmeXVOntfCfe1ZPvivV7LTPAQba41vkJmd2EYx138ZcdD4goCYQve?=
 =?us-ascii?Q?PdB6AZUYMWyXS0ibiIdTD0BA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 579e0a66-895b-4238-1e73-08d8faaf5bea
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 16:57:13.8897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s0Sp7x1gBRZDGd+haNVMagINDahc4klBpkV31JpS2Wgj+9sAvAirLuGDryRTgHLyQ/FrjN/KkKH18DIOKPZatg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1332
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Thursday, April 8, 2021 12:52 PM
> To: Randy Dunlap <rdunlap@infradead.org>
> Cc: Dexuan Cui <decui@microsoft.com>; davem@davemloft.net;
> kuba@kernel.org; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> <liuwe@microsoft.com>; netdev@vger.kernel.org; leon@kernel.org;
> andrew@lunn.ch; bernd@petrovitsch.priv.at; linux-kernel@vger.kernel.org;
> linux-hyperv@vger.kernel.org
> Subject: Re: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Az=
ure
> Network Adapter (MANA)
>=20
> On Thu, 8 Apr 2021 09:22:57 -0700
> Randy Dunlap <rdunlap@infradead.org> wrote:
>=20
> > On 4/8/21 2:15 AM, Dexuan Cui wrote:
> > > diff --git a/drivers/net/ethernet/microsoft/Kconfig
> > > b/drivers/net/ethernet/microsoft/Kconfig
> > > new file mode 100644
> > > index 000000000000..12ef6b581566
> > > --- /dev/null
> > > +++ b/drivers/net/ethernet/microsoft/Kconfig
> > > @@ -0,0 +1,30 @@
> > > +#
> > > +# Microsoft Azure network device configuration #
> > > +
> > > +config NET_VENDOR_MICROSOFT
> > > +	bool "Microsoft Azure Network Device"
> >
> > Seems to me that should be generalized, more like:
> >
> > 	bool "Microsoft Network Devices"
>=20
> Yes, that is what it should be at this level.
>=20
> >
> >
> > > +	default y
>=20
> This follows the existing policy for network vendor level
>=20
> > > +	help
> > > +	  If you have a network (Ethernet) device belonging to this class, =
say Y.
> > > +
> > > +	  Note that the answer to this question doesn't directly affect the
> > > +	  kernel: saying N will just cause the configurator to skip the
> > > +	  question about Microsoft Azure network device. If you say Y, you
> >
> > 	           about Microsoft networking devices.
> >
> > > +	  will be asked for your specific device in the following question.
> > > +
> > > +if NET_VENDOR_MICROSOFT
> > > +
> > > +config MICROSOFT_MANA
> > > +	tristate "Microsoft Azure Network Adapter (MANA) support"
> > > +	default m
> >
> > Please drop the default m. We don't randomly add drivers to be built.
>=20
> Yes, it should be no (or no default which is the default for default)
>=20
> > Or leave this as is and change NET_VENDOR_MICROSOFT to be default n.
> >
> >
> > > +	depends on PCI_MSI && X86_64
> > > +	select PCI_HYPERV
> > > +	help
> > > +	  This driver supports Microsoft Azure Network Adapter (MANA).
> > > +	  So far, the driver is only validated on X86_64.
> >
> > validated how?
>=20
> Maybe change validated to supported?

Sounds better. We will change it to "supported".
Also other suggested changes.

Thanks,
- Haiyang
