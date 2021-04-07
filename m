Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DAE356EC9
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353065AbhDGOeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:34:19 -0400
Received: from mail-bn7nam10on2103.outbound.protection.outlook.com ([40.107.92.103]:44833
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353027AbhDGOeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 10:34:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IlBwyUHUWaoN51aIu4y3jP/BAwaBoZc349g4MKx8JuAanVu532cYzdskJt0JDdnWWSL3YCRgNnOKP15skU0A0WUuOiU5aQ79JFX8IjF79EQgA1NodRmNjX9VQPg9L50zSfs91DuV6RvvsMfoii5OA9Ae0nLZhxAXHf7mI6TDg+VOMe0sZrvme0tK1RhX6qw+P7Mmy9gPel3mEpzJap9qYgJudDWq2gMjxBZjL2cR4xTz8rBPXn6jEh2UCjkJKE7wD7JcS4SzPNtkuoz7+bz4ighWkpRD1TBhJfv1MtkLb8Uh8SaqeHKZ+olKNfuIRWS7tGSn96tm/r8AGNPnHrtyuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMamaem/IDNfk3TwWhF54R/U0KUT9Q8Lc2PCygCGK6k=;
 b=dYbu0aLgVv/9zjXfCHZbSaVWgicAgnqrZoja6fZx/fXM1PBs+qJghFmCgka0IhbpuRTLOxEhf2GTsH68w3ihSB/MRG8Ittsr8X+7z76/zhnvYghOcp94Uwzc+pOEx4FWPtwx0ffOavu1eE5dGW07sFVQIgBVTXiroTfMq4287a0kTdMY6JQEZ8++uelRtpgJQ7IlY0vXC3dyweB6yfgtU666GsA/Os4+q+QxWIN57xZf+XawvERf/jdb+gG/8xYGCrXOvCerGYHJ1po4gNX1kK2RyOWbvs8cNEqNXRg4u7fmD/2jmlm2w5jhBAOBRD3IyN/jwoVq87IQzOu9/kMy3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMamaem/IDNfk3TwWhF54R/U0KUT9Q8Lc2PCygCGK6k=;
 b=QTSWNCEgEzeAn4NT4r1BJn6RiHq7RbZI8M1kpa6iumtYJ54dexRu1RXqWuJ8rG/h8JK5oxpMayTDBn7pRci5lzg7lCnPHpZCKu22qh+1BPC04cRAG7aIGzINweJgKX2FlC8rhy6A6dpFlb+SGCuhVuoa8qjUFDtyF9F4fqzc4Ww=
Received: from DM5PR2101MB0934.namprd21.prod.outlook.com (2603:10b6:4:a5::36)
 by DM6PR21MB1691.namprd21.prod.outlook.com (2603:10b6:5:bf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Wed, 7 Apr
 2021 14:34:01 +0000
Received: from DM5PR2101MB0934.namprd21.prod.outlook.com
 ([fe80::3180:1d96:7f57:333d]) by DM5PR2101MB0934.namprd21.prod.outlook.com
 ([fe80::3180:1d96:7f57:333d%9]) with mapi id 15.20.4042.004; Wed, 7 Apr 2021
 14:34:01 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXKzvmwFT+jLn9hE+ope3TVVs2GqqpCiOAgAAUhFA=
Date:   Wed, 7 Apr 2021 14:34:01 +0000
Message-ID: <DM5PR2101MB0934D037F5541B0FA449FA34CA759@DM5PR2101MB0934.namprd21.prod.outlook.com>
References: <20210406232321.12104-1-decui@microsoft.com>
 <20210407131705.4rwttnj3zneolnh3@liuwe-devbox-debian-v2>
In-Reply-To: <20210407131705.4rwttnj3zneolnh3@liuwe-devbox-debian-v2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=31817d09-7cc5-417e-a00a-b0d0d1664361;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-07T14:30:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40622f46-5a7d-4289-5493-08d8f9d23004
x-ms-traffictypediagnostic: DM6PR21MB1691:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB16912036B68FDF70C4BB1AE9CA759@DM6PR21MB1691.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IUkoaWdJCPw3cEZan4UZ27EqJrIfEYpZRQbfvGxcrWjA9jYnw0iU7FnxWijJpRa0DMmjayki2hPKmkfrxQknQHhl+8bvIp0vrhYQrbuQA1pVl3f+OaH9QTlvj22X/n+/KJReZnSkNCUlCgMN7d/qi9QFQkGek5zup+xmHoDIFDDuIwv1D5Uu4Y/RTBxtUKhUa3r8rI1t3/9rLY9omm5ar4bhdtLIJCs0uictwF693MVF0dr79dqqZGG0OFmB0tOeqtZS36ezX27FpSueJsO/9DzH90mSf/gOhJukcdayMa3/b4lVzV7xd6agBbDeGAB+OqcSmZ8D42c87V2VNHebBBTPcC72F1faxAnbyrD+bojKGe6yQLWk+ikzb5hWTm2W0RB0WM8IfkYBtW9ZW37vnQXMyRglqMPQu4WCwz+BXYm6IaF0vqfTgcbl/aHsib8UKMeI0NHEZ3649to7LOItw+aSOmh1rpzqtMWanESbeg6kfCsM6UvB197GWfMqfBkrZjO7sgOo/6C6EvsDEGbUm3hNrSjKQXsOhbgQVpkxRW7T5OvzJVE14L9VETaY1nA73Ol1naFZagp6sl5y9VaZGg8+1sV9cY4kz3ytP7p6qv6I3gwKOR5dI/JAJ46MfT+MwGNAjEhwtv9Ps0VT4COv9KUTcTmwrvQk5Q9eskdab1A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB0934.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(47530400004)(4744005)(33656002)(9686003)(55016002)(53546011)(5660300002)(2906002)(52536014)(6506007)(8990500004)(83380400001)(38100700001)(110136005)(4326008)(7696005)(478600001)(82960400001)(66476007)(71200400001)(66946007)(76116006)(316002)(86362001)(8676002)(6636002)(54906003)(186003)(8936002)(82950400001)(66556008)(66446008)(64756008)(10290500003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YLFc47/hLsYQOOat71A7+cr4w0ORkl7T3AjFcE0+jmFL/VW1Ij6qLokb9zyS?=
 =?us-ascii?Q?hqGuOf+HJesSCtf02CTu8k2QrWSaI5/8CT5OfxtjkdIYCrnqJSj7R1lLFqU9?=
 =?us-ascii?Q?IBDobeVASy53dknXKJTyt2MgbjdqnQVF9ter3mrPUPa8g3qCcoU/Vw8qYtDZ?=
 =?us-ascii?Q?/27eC9gvp+w8tvdbBoxSAyTUYSqBxuJSb0YyKGowV06QFlSM+o7vlRn/3UCc?=
 =?us-ascii?Q?yKC8NxSDFRaMYJzKvxkvTlgOkhUh3V5Gf3cvhsE+v1oT+x4uiUcHLjNuDj7Q?=
 =?us-ascii?Q?iySOJGOBphx52pYTlIhIUccISNDLKCUcQZ50R8KJTv+7vpX4eF5A/3ufqiir?=
 =?us-ascii?Q?KfEyiDPNjxRu35fGFHX0ibw7HhBsLWWXNL3yP//CyhCqB5OIRY/ZMTxMynxw?=
 =?us-ascii?Q?Zd0FJiwBEGzaDc4M+jrpCSpYxR8VZ6ePd5qciIKjnlzzlh/BdOXQ8P/AWulR?=
 =?us-ascii?Q?A2Pck/deWrN3AasVjfulCK1vtiZ6xeRdP4bDCIj6l56cOcrL37v0Q82+wu5X?=
 =?us-ascii?Q?xJZXGVetC9SWMa5qEzQi1vttYSA1KX5e/W8c2SoTTX9RkAJaoPzjztCZ6/C0?=
 =?us-ascii?Q?7/oRWuGzSBjoJAhHgapDNBw8+Ayt7XJ6Z06TyHHqx8KEpbRovs4T4DqTDAog?=
 =?us-ascii?Q?CGzSJUjarpqS6EGMZ1TmL8BSSaY3q9aPK6Lch8vF+OMFnvfY1tyhdy2xZmQ/?=
 =?us-ascii?Q?LHhb3W1e3IRfHqwYiqBAF1DGILPOWZkyxEpprhLreZYpe+QCRjCviM7h01Yn?=
 =?us-ascii?Q?osl3Ca5ST3RmkjoplSwxHCnP6FkYe28HK+JXCBh5kDDyz2YLEu4y83HGFhk6?=
 =?us-ascii?Q?31JmLG0y0XqiC7QGxHvIfWr4xK1QRcsEu9AgYqGNA9IljH+gytSVycuRoQi3?=
 =?us-ascii?Q?nYo0mu3kWd0bx0SvZbJRe5Xz4NtVgtBnQ2CH2THL4zW1w82cgS8G7mR3mgHi?=
 =?us-ascii?Q?1/dIxs9TynknkKt8u4KTTWtW1bBsvsjp551XbzIlB6hkkiw3lZzXZS/2lt9Y?=
 =?us-ascii?Q?SeexErJHWWK7G0SVvopr+pxpmmZDKDH7Is66OXXE69p+o9em78/467hCPviK?=
 =?us-ascii?Q?VCplJkGwiTsGwKSdnGlVyiEo/4cmEzB4e1cLzCcKwnPx790TYHoeLXLd9PuK?=
 =?us-ascii?Q?Cg+XvnvwabEMyMxGeiN4bPAdofCITUVLPYlBPob94Jww5V5RMTImQGI+gARH?=
 =?us-ascii?Q?BSp7ASMnFCosAzsLW3iDgYI2SkMAA/e0l7Zi2QUxywbDkk/MHq+sFIVixpc2?=
 =?us-ascii?Q?CEJgWsBSprr8uOKWTbvXh2nFe/j0aA7ExCI4lb29rQ8d1jq4uPujK2+hECbO?=
 =?us-ascii?Q?DAMlyuFCs52ORcGB+XVu5F8x?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR2101MB0934.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40622f46-5a7d-4289-5493-08d8f9d23004
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 14:34:01.5814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ozE/ynUXdnzriN/YloPbHA4sB4WhutCdy5vALgPaumHfx5zua8Tcm/V5D9ijH0RlqxSqu1I+ZlBCkIEWipRkOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1691
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Wei Liu <wei.liu@kernel.org>
> Sent: Wednesday, April 7, 2021 9:17 AM
> To: Dexuan Cui <decui@microsoft.com>
> Cc: davem@davemloft.net; kuba@kernel.org; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> <liuwe@microsoft.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-hyperv@vger.kernel.org
> Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
> Network Adapter (MANA)
>=20
> On Tue, Apr 06, 2021 at 04:23:21PM -0700, Dexuan Cui wrote:
> [...]
> > +config MICROSOFT_MANA
> > +	tristate "Microsoft Azure Network Adapter (MANA) support"
> > +	default m
> > +	depends on PCI_MSI
> > +	select PCI_HYPERV
>=20
> OOI which part of the code requires PCI_HYPERV?
>=20
> Asking because I can't immediately find code that looks to be Hyper-V
> specific (searching for vmbus etc). This device looks like any other PCI =
devices
> to me.

It depends on the VF nic's PCI config space which is presented by the pci_h=
yperv driver.

Thanks,
- Haiyang
