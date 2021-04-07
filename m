Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC00B3565F9
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 10:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbhDGIC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 04:02:56 -0400
Received: from mail-co1nam11on2091.outbound.protection.outlook.com ([40.107.220.91]:63583
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241318AbhDGICc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 04:02:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fo89RW6So2RsmvdbD+9dpqOvawB4Ph2SGDmSWvIoMBcjQxsYbRRz+9w07ms9hjkD9lxoYgk6F4y/9nuLUzmxqS6FkbHvIxrvbwLIfef7b97oy2qQy7HvT7yT/LQF3h97U9I37GqWRkegWXctrOrrvq1xtVTZfgp6QfiCo9vQk/mEpXK03RJhRo6Pf60acjSKzd8387N71UaY8bH3N3OD38wuKDwZsPDp0ouURe8O8BZULgmx9xMYciHJG/sF8QgFboivnVVaiBU+OwobfWjAJyXKa6hq6RjyWMuz6B4vQBM6uLr9/PEBJvDu7ijzCORjbBXckXv7dAVYYguE1MSUfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HJPb+dniOvL11loC0LKEwl5aEEJhfMbiizNroAk/Uo=;
 b=Wcxbr9NiRoOpQUXCwthfIj5B5N/YGuXjwKQPDMDOVomfxA01Sr4petHKYE6IiFR1oeFApdsf127KSeFmzOe+ICDZkL73xxZsPH0z2yQ8rWtFhAC116JDGUQmLjdIpVqGKhuRwUN8MlBZwmnXRmw3++FAp21xWkgShFCFuUv1AdsUJFKu/64uatw/fhbqZQErWcxRkBAu8Cka0RL7uA/yo7tj3BC6ZcWbwyCuh9oE7QT67tGAPTOuDcjWoMphaDheDjOUnXv4U4dT1FTZ19Cupa27Vgcf3Y0v0BYKRZSgtf6UNLGSHcQVZMnSQAOoEf7EeGfkfwg9rpOvE1TyJKPv0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HJPb+dniOvL11loC0LKEwl5aEEJhfMbiizNroAk/Uo=;
 b=BpdutMSb8Ft3HFQOBMtMqpKwDFGIiSFaKuUT9rNRceQc1J0OhMyiNcjFS7+rrx/zvW3U2vV91M2JBixEbNyX3aVX7VTgTdouGFtGZcDcbfECOQrJfPS3BUyZIw41JrQPvAbfat9eaGw9QyluSoD8sKfIThuRyoVC5i5RXTg+jN4=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MWHPR2101MB0810.namprd21.prod.outlook.com
 (2603:10b6:301:78::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Wed, 7 Apr
 2021 08:02:19 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4042.006; Wed, 7 Apr 2021
 08:02:19 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
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
Thread-Index: AQHXK0pqK9CYzM87fki9gwnmLmNhk6qoPxRQ
Date:   Wed, 7 Apr 2021 08:02:17 +0000
Message-ID: <MW2PR2101MB089237C8CCFFF0C352CA658ABF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210406232321.12104-1-decui@microsoft.com>
 <YG0F4HkslqZHtBya@lunn.ch>
In-Reply-To: <YG0F4HkslqZHtBya@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d348d8b7-3c88-47d0-84ca-111028d8bcd0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-07T01:10:42Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:b462:5488:6830:14b3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36d7a0b4-f01f-4851-2892-08d8f99b7783
x-ms-traffictypediagnostic: MWHPR2101MB0810:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2101MB08108E5C53F19720FE7BDC9EBF759@MWHPR2101MB0810.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8V2TSGLjGDrtFMaKxfKOvk6CwHh8c5POhqibWVpeZ/BoaRhbbgVs4c8A8H+e7SEcXkgRsp58/CDnQR/O5zDXieDcQy+/YkzI1UPUe/q/eAQl145n5htOzohYn6cI/UOijVwHBMvhT3VPIh6TSlr3D1sXGIo07SN6H4RixoTOWKZAh+g8hFtS+5r/prRTGxbkg/kg0u+wk7CPyjU5koWMzjTAXWrJzT28rZjL6oPTXGfMMOfNVmAh9CAdhe2WeW3RyTpIIMXSBW4qOrUsCATWYW/sS7W+CsU/gK4Fogxk9l2o6o6+4xzZsGwbSqLZJo218k9K0HtQnJrtzyZvt3dMGfZh7jmhRDdhF33T50A6Yoh5EgnjY4DRXr1ZI5SV7gN1jxLLbdShzM5WIQxsbQH1DF5efJUApp6dYRAPeAo4yV/krD4x82ZeZFPxWR5C414P/RLRy/egpGJjQfkMVH3kUHxL75jhxar6drdO4iAnNN3osdlAPyuQ8Cozzj1yDh0wfoR//AY/BbqwZWBG1ozQ9RkHan0oW+WhA3Ov1B2lVCEO2Exv3YqtWmBRLUAsKImtymqoHa02TGOrv0ixh5cjBXRiqFr+E9yhjfhBOwcAW0QgBPqSNc1pV5DbDIisXFEUDaGnji2Xpdc8AQj+NWTphZrG+h8rRGj8gWFP+7JW8mg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(47530400004)(53546011)(4326008)(82960400001)(82950400001)(6916009)(186003)(76116006)(6506007)(54906003)(8936002)(33656002)(8676002)(66946007)(55016002)(10290500003)(38100700001)(5660300002)(66556008)(66476007)(64756008)(52536014)(316002)(66446008)(478600001)(71200400001)(7696005)(86362001)(8990500004)(83380400001)(9686003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ny2qKjvzMYkFa06v3dDTo+h201Mrh+fL+UWMgW42FlcBCXosUdxKmTms9pK4?=
 =?us-ascii?Q?0cCX1mrX4362oSy1SvGXMSkTCN7Dh8pI+YeanicdBGbeqOie6DZIGMEWMB6f?=
 =?us-ascii?Q?OQRBPBA9Pfxe/a75hXZ38etjI3HNeMqz6MeuzUOAhgvebpmpapIxta6MsV9t?=
 =?us-ascii?Q?wUY0UmyaJXksohh/BMiy5kBs1WAX3kz3RwPEmS69aO3iR0d/ptl+5xt2VbfK?=
 =?us-ascii?Q?qGFrTZGChL2bt+T1GxYfIXUDvz5srx5ZGp2dz7UxvRI4uqCfsYrNI5J8oVcK?=
 =?us-ascii?Q?O7E+B747S5SmDIfwKDJOp8LcY+dyRqHCVQLcCFXcxPjK1UWlsv7sx8yFNUGW?=
 =?us-ascii?Q?7JIb9CQ1xgZQLuj6oVT26OM91U/JAz6A62rQHk2g/jbR+0yKi67NEyTPQ6pg?=
 =?us-ascii?Q?HElSb+SYvr23pYCRIDdWzbtHLL3gvz1XqfGGvopOACfdpkZQwYoK6NQ3yGL8?=
 =?us-ascii?Q?j/uFCZRZteCZEpDxgdosgKxfgxmO/ttXHVkBUUBCH+QRB1N7/yhbL15e8Ki1?=
 =?us-ascii?Q?u4ad57rPbGEpiM6MgadwviMx49MG25akEA4Xir5Xg6Qf4rttYVt8wKHmgJaa?=
 =?us-ascii?Q?TqXM/ZHl+F+/caNK/Osvcij9Q4bGzHXKbZcWNhWqTXUyMPu0hniQmwdzEf4u?=
 =?us-ascii?Q?M8jBs1xfc7T4hHv4qPuXjQwsNqAf8SC/jGT8g8IyfK799XOmLP/zR0OzUr04?=
 =?us-ascii?Q?7OhbBW/tgN56LIAGMqdrJNV1GK2hcchgeNK/CI9Kxp1gUvHIxGSczNoV2Fua?=
 =?us-ascii?Q?u7N3H2BL/ezGr+mdTa0n1Wlsm+JfZmx+b3qrKnTnMEiMyAwpZYaEClvpaPOw?=
 =?us-ascii?Q?6rS4bW6udla64WpKyrWeVzNYDNqByvaryESLjPWksZfTocx/iDQFVz1lcCnA?=
 =?us-ascii?Q?BAw7BKFKd1x+XP/Ju3yYog87LYgMlDQMhmO2hgfyXGOfZ+XH8eUyEEGTPJh8?=
 =?us-ascii?Q?OOJFzatwmRRX39Un6F5QPChAyKae652NYCwEPXRhe7zH4yxSQ7zH82bdJ+mB?=
 =?us-ascii?Q?V6l2MePYmpADixCddBWpt1KX+RgdQ0/VWVqK32srGf7CHOuiJPp7K/05r3KL?=
 =?us-ascii?Q?KdPjgRpYEPJtdFwBGdFckxHv+f+FQA17TCVv4tqGTb2fk+6nOjj8fRMZLPi1?=
 =?us-ascii?Q?G5+27EWMZ0BdfxCVDoijhP6lKoWqI1KIyT9Nv2ne1EKUJIk+RAStzoSTB5Ql?=
 =?us-ascii?Q?wH4nAj6Qe9qRS45f7MpAkH2gT5HdSS55ugPMY5gYD130OoUUiXH8OhFzlDTM?=
 =?us-ascii?Q?pWe52B11EFG51r/YONCzHBkdVqcY/TAIk6VXmlVkDdMzDtvEhyVEk2INvu5v?=
 =?us-ascii?Q?zhpztltfthHi+HES/hTXUdpN+cEgEH4nZxYMC2XMtANSUqyYxpXOcXHRD/O2?=
 =?us-ascii?Q?aiWH4O/wYDMK+YXvMp/qycMlaom8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d7a0b4-f01f-4851-2892-08d8f99b7783
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 08:02:19.1557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bS3YLiw2cHWrqnjO/BmtL/CjnE2cS/vIhSE+3hvx0Ri/TrBuG3p1R4JTEavnXzqxC+/iH7TFL37RSpO8jitazw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2101MB0810
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, April 6, 2021 6:08 PM
> To: Dexuan Cui <decui@microsoft.com>
>=20
> > +static int gdma_query_max_resources(struct pci_dev *pdev)
> > +{
> > +	struct gdma_context *gc =3D pci_get_drvdata(pdev);
> > +	struct gdma_general_req req =3D { 0 };
> > +	struct gdma_query_max_resources_resp resp =3D { 0 };
> > +	int err;
>=20
> Network drivers need to use reverse christmas tree. I spotted a number
> of functions getting this wrong. Please review the whole driver.

Hi Andrew, thanks for the quick comments!

I think In general the patch follows the reverse christmas tree style.

For the function you pointed out, I didn't follow the reverse
christmas tree style because I wanted to keep the variable defines
more natural, i.e. first define 'req' and then 'resp'.

I can swap the 2 lines here, i.e. define 'resp' first, but this looks a lit=
tle
strange to me, because in some other functions the 'req' should be
defined first, e.g.=20

int gdma_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
{
        struct gdma_generate_test_event_req req =3D { 0 };
        struct gdma_general_resp resp =3D { 0 };


And, some variable defines can not follow the reverse christmas tree
style due to dependency, e.g.
static void hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
                                   struct gdma_event *event)=20
{
        struct hw_channel_context *hwc =3D ctx;
        struct gdma_dev *gd =3D hwc->gdma_dev;
        struct gdma_context *gc =3D gdma_dev_to_context(gd);

I failed to find the reverse christmas tree rule in the Documentation/=20
folder. I knew the rule and I thought it was documented there,
but it looks like it's not. So my understanding is that in general we
should follow the style, but there can be exceptions due to
dependencies or logical grouping.

> > +	gdma_init_req_hdr(&req.hdr, GDMA_QUERY_MAX_RESOURCES,
> > +			  sizeof(req), sizeof(resp));
> > +
> > +	err =3D gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp)=
;
> > +	if (err || resp.hdr.status) {
> > +		pr_err("%s, line %d: err=3D%d, err=3D0x%x\n", __func__, __LINE__,
> > +		       err, resp.hdr.status);
>=20
> I expect checkpatch complained about this. Don't use pr_err(), use
> dev_err(pdev->dev, ...  of netdev_err(ndev, ... You should always have
> access to dev or ndev, so please change all pr_ calls.

I did run scripts/checkpatch.pl and it reported no error/warning. :-)

But I think you're correct. I'll change the pr_* to dev_* or netdev_*.
=20
> > +static unsigned int num_queues =3D ANA_DEFAULT_NUM_QUEUE;
> > +module_param(num_queues, uint, 0444);
>=20
> No module parameters please.
>=20
>    Andrew

This parameter was mostly for debugging purpose. I can remove it.

BTW, I do remember some maintainers ask people to not add module
parameters unless that's absolutely necessary, but I don't remember if
the rule applies to only the net subsystem or to the whole drivers/
folder. It looks like the rule was also not documented in the
Documentation/ folder? Please let me know if such a rule is explicitly
defined somewhere.

Thanks,
-- Dexuan
