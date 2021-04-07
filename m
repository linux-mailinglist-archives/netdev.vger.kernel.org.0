Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B994356FCB
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353316AbhDGPFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:05:39 -0400
Received: from mail-mw2nam12on2091.outbound.protection.outlook.com ([40.107.244.91]:46560
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243817AbhDGPFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:05:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Caull6oDNtxuk/V2QGxeggk1R+Fera10IIBI9+P6kQUnnxFjMwr7PZd6lLekVWGbAWhhSAv0C+EGGT//fBDOWvA6xrueAHQ+wqaQ3mNE6GYdJAuVPL8O1E5R4O8EAE5Iocg70hEwN5urPtt8wLjQvIBbWUo+AkYRwoHNCHLEJ6ycuRyZMvMmDtUwEG3TgSD7xfi4t9aINvs93IJ6+BGLOr8Lulo+9zVpo2WWzSy1b6K4bFS2XGl50kehnP4DTd9zKskSPTyrr1dKOJ9cib0ZhbGw/Zc7yfeEatq1mSKVOXg6BuGIg3szCGe7uXLoLnBNgeo8X2B9f/c4qUa76uhgHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bEMjs/Ld/siZgyoPei/svgOoprnHUvr7/8IPewmlro=;
 b=ls3BNRIp/ceyFIP1kgOxWRf8zsqKpYc7fRtu/nYLz6C2JpGEibhb6nX5u+3jjag4uxTWHUEPHRooRp01/OuUaffhvYQcRfz22Wf00IDEpfFln7TJJg5+X+Mc0A/ukchGESy7kblebvt7h7l9Dpr9E7To0dgQzaQUtoa+jt1swNCJ5djcSJ6uhifynxgOpIeMR2U1F5AMJI3/fnksc0plYa+9asZDwRO1GpE37ihEyRUT2sXSf0r5PGaXfQKuj3rwTpfqME+gh8AxmVOjVWFVgMyPft3yGvbdfk5CCYsflM1bea8RGlpx2X7MVksRvuhyRxpbJdlCgPKsYW49op3xXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bEMjs/Ld/siZgyoPei/svgOoprnHUvr7/8IPewmlro=;
 b=MIJ9kS6tmiAWxtNzSwDbxmB4HR1DnVSaH1MHOm9KhvXbu2+LdfVnlp4+DxVAIjifdrIHLmNZBBWt7G0WwZJRQuN9Dlz2duf2F6Pynzj7SID+nS8Dxvshuwpxi51qV5nk/TDgxG5NlKPdIE6t9LBvijvl4y/66M4nmaAJBEuDUuU=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB0979.namprd21.prod.outlook.com
 (2603:10b6:207:30::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Wed, 7 Apr
 2021 15:05:27 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785%3]) with mapi id 15.20.4042.006; Wed, 7 Apr 2021
 15:05:27 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXKzvmwFT+jLn9hE+ope3TVVs2GqqotGEAgAAIZ4CAAEYnAIAAHRmwgAAFeICAAAElMA==
Date:   Wed, 7 Apr 2021 15:05:26 +0000
Message-ID: <BL0PR2101MB0930CEB943EF4502932F053BCA759@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20210406232321.12104-1-decui@microsoft.com>
 <YG1o4LXVllXfkUYO@unreal>
 <MW2PR2101MB08923D4417E44C5750BFB964BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <YG2qxjPJ4ruas1dI@unreal>
 <DM5PR2101MB09342B74ECD56BE4781431EACA759@DM5PR2101MB0934.namprd21.prod.outlook.com>
 <YG3HxVaotTi/Xk5X@unreal>
In-Reply-To: <YG3HxVaotTi/Xk5X@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e2b91099-4b78-4a8c-a4b9-821fb7e0de35;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-07T14:59:07Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c98e78a8-5354-48dc-6f89-08d8f9d69405
x-ms-traffictypediagnostic: BL0PR2101MB0979:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB097956EAABB4F068A1609D33CA759@BL0PR2101MB0979.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +mDXNfeJUOvrSh1V6J6lSWg56IYGS8nFuyOtbQ0QvZGwunpBFXtId2Nnni3VQJcmionHjHKCbvgErMlFxDWfWvdAP4+31Svp2R/ri9Vu3P7bIUHO+dZpDyJCUUzCjLDMsRK1Kr1DrXWK7vzLKXGCMcK7fzb1AKJGUGmRqlOpJx/vTbZiPIgfd9pUMi86Q0xbK0ggoiWYiEDc5ML8pM60AqjWoF/8blbLPbKLW+I4vWoASbL/pamCyv1ra2YOq76iQ2xggVO5i1jWcA1C59ulP7l2Aalf4m26ikOTJEUVJPZ2xL/r+C43Kkxe04XueoLxk4BV4BY9CtWnFaqvzeWWMaspnYttgf1rWV1781HV3jD3L8DNgCFMu+KZxt5TWwo23ONWinSToNK1EiXzm0zfDzPaJTfXYpx49JQSsvNspDeeKJork4IGFSikfvj+UksvI6ginuhMG8eSKhMx/nZkKCLBIQXcpyGy9R9u2RaeCXqItg1h1nx4ALy7cW29CbEaC3cgZ5fnJwjvldgNq24qM+oDHrSxG2Zx3dSYgPcOgHX5WVRRN1oGY4Q5/tRSyNRV/wZ/dyJgvOH6j9OrDwNz2QNvfXG+DZy4Vf2AjbvrV/1pwgenOL1ZFH/RpW3EHatvDz7tue2ENnqr9rp5usf7JB6IEb7dXkhmgtq1L4R74Xs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(47530400004)(64756008)(54906003)(316002)(478600001)(6506007)(82960400001)(82950400001)(8990500004)(55016002)(86362001)(26005)(2906002)(66556008)(9686003)(66446008)(66476007)(33656002)(71200400001)(10290500003)(6916009)(8676002)(52536014)(5660300002)(83380400001)(186003)(8936002)(38100700001)(7696005)(53546011)(4326008)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IId01lWgd4c1au6rUXMn1h2MXd3JOEeWsnuR8U7iR7GVIUG7LzbQlafvQMhx?=
 =?us-ascii?Q?/U0h3CZCGBHfDIeQVgxsI9gVvLnNsUlvr+f8m6/WY7QJqZDgJ9dl5BC3rMT1?=
 =?us-ascii?Q?VpjcSCS5vXmNyjpHel1YUdmFbFbc3gCnf2m2ko675bD6Je5CcZ5oVAQQqueC?=
 =?us-ascii?Q?phSXTZX1AwiSS9rku2kUeM+nc+EkMobpgRwRBg6p24X3BXE9EBoYboKpmkBC?=
 =?us-ascii?Q?KZgY3U8aaiS/rOGMG2C14Z2tDNHo3XLEj+MJX2YnF6osm9SnsbN6JQjtVmrJ?=
 =?us-ascii?Q?qejR2gXWWxB7KqP+Nh/wcaqG13DlSgAURK25iZ3/wh/JC9dgtILTJRzosW3L?=
 =?us-ascii?Q?BzSnEOeuZtWW4zTwZ+WtpCeDpi3oDmwWWw83kiDW8Fxnairl2F1OR/FK0sjm?=
 =?us-ascii?Q?0xQ2R2nBFkw2//cl6NFAY0I873qqzijq0reqomLXJcXrEmUlfKiukpG+IOCi?=
 =?us-ascii?Q?K3eWgfzPjwn5kkYJSKyZFczV4w2cRRmHOWMHyricx5zjAPCaKkeS4wSPt9V5?=
 =?us-ascii?Q?IFxuxUXo59uJ7S2jY/x2tgylSXLSKXDstbswCGEDIC1TbkffqFYXadDRLIY9?=
 =?us-ascii?Q?5UhxYWfICtJdDWyk/rxLAcDuWtpXg/Z/6dfQ5aEoGsNNTX+sb8hqV7XwdJs9?=
 =?us-ascii?Q?obbraCwzFaXRadS6dCRLRSYaXXTABSvuUJZ1KXUV4t1lwbu7nByrpgUj1gAi?=
 =?us-ascii?Q?UP1dcw0WOtTjrgve2J3s9jrci6bpBucFLoLSHPVmigcqyGetn6QlL/Y56fX1?=
 =?us-ascii?Q?kG8/EUfJya1ah2qCR8TlqbRsutLqMsrCE4EK8hAIh3sgIo173lNlrxGqNTQR?=
 =?us-ascii?Q?2InSoerdtS7gYvzB/jAXk8B651IhaiM6Xmcbp+C+LEkobClFfcz3sBP3KlKQ?=
 =?us-ascii?Q?4Pdb9yQtD1WCG95g4iGU4+n3Vz4PXObrTSgw3rWiEa8/ek7KkQuuvxqJeYHy?=
 =?us-ascii?Q?3ba1O/975lI9PbQHzzf/dc5LWP34dsF7oLeefgnLoELR78c7CSM3c8C7MSbG?=
 =?us-ascii?Q?aL24jyYVhzuGoqwt2m/AGjRPuvLyPhy5f+DhLGYcux4hBeeJTtxhzz22We1r?=
 =?us-ascii?Q?ygXMq+hqq3UDGv04owtvRW15y2/xSVBvXd/a5h+t9gM2H4LG2SutF6OVcUtx?=
 =?us-ascii?Q?B38jTVOJL6N9JFKmk9dy6R45ZJxE5+XNxlRSxJY5uu9zCrvqwzXHjimTA2mx?=
 =?us-ascii?Q?tt5aakKMe+AUhK40KIlYiBPOfmt1AE52vEDdG/5560fb+tx7nmy5LD0QZ/q5?=
 =?us-ascii?Q?AtqlwCGSi1ZjMPPQ1tyIJteGj88FGuTDwNBCTiYxdsUOQ8+EQdCQK7nf23xI?=
 =?us-ascii?Q?kxsV2dlpJ5qkuzyhyU/s6zp3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c98e78a8-5354-48dc-6f89-08d8f9d69405
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 15:05:27.0199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mAF8UkUv757OU1GsuhrryJnrtvK+AKhKPRtx/6H5h4NewctshS3w9AwQYOq0LTs/mMsWObstN+vPxrUyjkuj3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB0979
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, April 7, 2021 10:55 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Dexuan Cui <decui@microsoft.com>; davem@davemloft.net;
> kuba@kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> <liuwe@microsoft.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-hyperv@vger.kernel.org
> Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
> Network Adapter (MANA)
>=20
> On Wed, Apr 07, 2021 at 02:41:45PM +0000, Haiyang Zhang wrote:
> >
> >
> > > -----Original Message-----
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Wednesday, April 7, 2021 8:51 AM
> > > To: Dexuan Cui <decui@microsoft.com>
> > > Cc: davem@davemloft.net; kuba@kernel.org; KY Srinivasan
> > > <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> Stephen
> > > Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> > > <liuwe@microsoft.com>; netdev@vger.kernel.org; linux-
> > > kernel@vger.kernel.org; linux-hyperv@vger.kernel.org
> > > Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft
> > > Azure Network Adapter (MANA)
> > >
> > > On Wed, Apr 07, 2021 at 08:40:13AM +0000, Dexuan Cui wrote:
> > > > > From: Leon Romanovsky <leon@kernel.org>
> > > > > Sent: Wednesday, April 7, 2021 1:10 AM
> > > > >
> > > > > <...>
> > > > >
> > > > > > +int gdma_verify_vf_version(struct pci_dev *pdev) {
> > > > > > +	struct gdma_context *gc =3D pci_get_drvdata(pdev);
> > > > > > +	struct gdma_verify_ver_req req =3D { 0 };
> > > > > > +	struct gdma_verify_ver_resp resp =3D { 0 };
> > > > > > +	int err;
> > > > > > +
> > > > > > +	gdma_init_req_hdr(&req.hdr,
> GDMA_VERIFY_VF_DRIVER_VERSION,
> > > > > > +			  sizeof(req), sizeof(resp));
> > > > > > +
> > > > > > +	req.protocol_ver_min =3D GDMA_PROTOCOL_FIRST;
> > > > > > +	req.protocol_ver_max =3D GDMA_PROTOCOL_LAST;
> > > > > > +
> > > > > > +	err =3D gdma_send_request(gc, sizeof(req), &req, sizeof(resp)=
,
> &resp);
> > > > > > +	if (err || resp.hdr.status) {
> > > > > > +		pr_err("VfVerifyVersionOutput: %d, status=3D0x%x\n",
> err,
> > > > > > +		       resp.hdr.status);
> > > > > > +		return -EPROTO;
> > > > > > +	}
> > > > > > +
> > > > > > +	return 0;
> > > > > > +}
> > > > >
> > > > > <...>
> > > > > > +	err =3D gdma_verify_vf_version(pdev);
> > > > > > +	if (err)
> > > > > > +		goto remove_irq;
> > > > >
> > > > > Will this VF driver be used in the guest VM? What will prevent
> > > > > from users
> > > to
> > > > > change it?
> > > > > I think that such version negotiation scheme is not allowed.
> > > >
> > > > Yes, the VF driver is expected to run in a Linux VM that runs on Az=
ure.
> > > >
> > > > Currently gdma_verify_vf_version() just tells the PF driver that
> > > > the VF
> > > driver
> > > > is only able to support GDMA_PROTOCOL_V1, and want to use
> > > > GDMA_PROTOCOL_V1's message formats to talk to the PF driver later.
> > > >
> > > > enum {
> > > >         GDMA_PROTOCOL_UNDEFINED =3D 0,
> > > >         GDMA_PROTOCOL_V1 =3D 1,
> > > >         GDMA_PROTOCOL_FIRST =3D GDMA_PROTOCOL_V1,
> > > >         GDMA_PROTOCOL_LAST =3D GDMA_PROTOCOL_V1,
> > > >         GDMA_PROTOCOL_VALUE_MAX
> > > > };
> > > >
> > > > The PF driver is supposed to always support GDMA_PROTOCOL_V1, so I
> > > expect
> > > > here gdma_verify_vf_version() should succeed. If a user changes
> > > > the Linux
> > > VF
> > > > driver and try to use a protocol version not supported by the PF
> > > > driver,
> > > then
> > > > gdma_verify_vf_version() will fail; later, if the VF driver tries
> > > > to talk to the
> > > PF
> > > > driver using an unsupported message format, the PF driver will
> > > > return a
> > > failure.
> > >
> > > The worry is not for the current code, but for the future one when
> > > you will support v2, v3 e.t.c. First, your code will look like a
> > > spaghetti and second, users will try and mix vX with "unsupported"
> > > commands just for the fun.
> >
> > In the future, if the protocol version updated on the host side,
> > guests need to support different host versions because not all hosts
> > are updated (simultaneously). So this negotiation is necessary to know
> > the supported version, and decide the proper command version to use.
>=20
> And how do other paravirtual drivers solve this negotiation scheme?

I saw some other drivers used version negotiation too, for example:

/**
 *  ixgbevf_negotiate_api_version_vf - Negotiate supported API version
 *  @hw: pointer to the HW structure
 *  @api: integer containing requested API version
 **/
static int ixgbevf_negotiate_api_version_vf(struct ixgbe_hw *hw, int api)
{

Thanks,
- Haiyang
