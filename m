Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB1A3611CF
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 20:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbhDOSOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 14:14:43 -0400
Received: from mail-bn7nam10on2119.outbound.protection.outlook.com ([40.107.92.119]:54113
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234208AbhDOSOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 14:14:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfg79Hq/awHnHeBcWNi1C6PWkVF/XVCRfYqbPZe+UaOUt8A2bsB+XxySHcjTT2iKKnua+7/qb3jRR/z8/dCQW6rAGtrc84XQ12v6RWbqWEXOh66A8m/HX0vqdZ0PZfN1HUVBRaLiqc1bLjF/rW6wJ8vM88J9rj5mQwPrHgFB4lNv9FkYQE8SS+8qK6Bdpn/wEyP5JZgkMTbam0LjxoiKMxzA2iApXlHorHsju5zJ244JQm5qQ6ppz/DQmABA9DMKS23KWaFqkukSz8a+vUuNXVrZ9nLiEM0LExevWSoBrSkYrYoadzpswfkd7875R8If7+OF5IaVm3zvJ+qfJ4kdSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7uWJ0hKdGysFzQrVKkeUtKc6fROhl+kUkFCUIueZp4=;
 b=c4kM4tTMauEFl+s6MIWK82Qw6Zi0czd6xzK0NNDGQPtHl8qGocaCycuBYcrVJTmIvFips4uEYY199hjdPH7QGa5IykVnDS+1fBTtjfPShvVNluNffu4odbOaR/WX6sDhcaiOCXeEeg0DA8nqbI8fTVdL5VenonhFX/Tmep4QXzerZPbUyEJeorhlz9WeLhhZ85x+3ybYFJZTvSukCcizkULMOhPPfhyw68q2muVIuvyGAOX8SgSgul0SJRjQgIKGMsU7bpEUVNN7euqIhW3Kn7QSczQExcVRi2OYfoAJnuDINCrRqPcQBTS6vxHZlYTfd2cGqkk4cOv2wemTUyBTLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7uWJ0hKdGysFzQrVKkeUtKc6fROhl+kUkFCUIueZp4=;
 b=GEBn08DGHM8I5ndwOybvPZT/H8oDFob2n7czGERYxyDlxqRpdquGqBGvtv9A1EH54oyWd2yNPvJ0YvrD+NUObCMl/itocLjZBajodhd2MBmB8uNDG+lAzpj8490DL4+c6yzfmz3DVDJ7b5u6uj/l3LozgAj8hner9Rjany2q7K4=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MWHPR21MB0845.namprd21.prod.outlook.com
 (2603:10b6:300:77::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.2; Thu, 15 Apr
 2021 18:14:09 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4065.008; Thu, 15 Apr 2021
 18:14:09 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v6 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v6 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXMh74qz+n6heTS0m4o7oyoLHpzqq13bxw
Date:   Thu, 15 Apr 2021 18:14:09 +0000
Message-ID: <MW2PR2101MB0892BA3116E2C3C82BEA3D25BF4D9@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210415054519.12944-1-decui@microsoft.com>
 <20210415104417.6269cd9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210415104417.6269cd9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a84e3b9c-d716-432f-93c3-d4d9fd2c027e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-15T17:58:49Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:d56c:64b4:268d:aceb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f301c475-d941-480a-820f-08d9003a43d7
x-ms-traffictypediagnostic: MWHPR21MB0845:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB0845C1A964EBFFA6642F7C66BF4D9@MWHPR21MB0845.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jJPS/0pNFOq5xxT4n7sZEA9E7ZUwagPQS6J8gpeHkOE/zNs6wkr1buMNTVq57T+R6nCtM3Cl9n+TaDDJlKummFR5cvbBGEW4ilZYTFS2+U8ZAl/jbCG8ixy2eP+reWBpqySlf+2L+C5owKP60CoBEeH7K1ef1GmCJ+twc9J3OrEr3KNsSO1foD3IVWVswEfQVehD5G2uGYoLydQH68aLoYLk8nJENZJmZcFoJxkmhwfhPlgUbn7QZ9gEmglDkPILvk8jOkS+s0R19x3hK3nMgA71E+0PR2wTUjPvbOKf0ExYdvX7WNS9rUyu5LHQoBW6tEXz3RUcxiAuabyOGHTwkW4bPh8kPg0mxe6ppPfrzk38VZ28Fd8vUN0Mm8L8xXsqOdRZwea1hKNqyEgpUUDa1Dwor36KvglhrXJmk8lzsJfLx1bGfGrOKfQrcHzEy6w1VJCr/PIIcSiFvceqKNiwza4arJmBxcwEHI0NsBAsemHezHJSq44JKTsoHmEa9LZgjZXbUV3TaoS4aeQgnf3nWY3eAxUD6K1+0z2xAXMG+dLeZEzZVYm23COo1QVefksRykwJyyLYdr/WWS2XQcR31eUrR9CIWtJYjDjUOeVLMiM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(47530400004)(4326008)(33656002)(5660300002)(55016002)(7416002)(54906003)(38100700002)(52536014)(76116006)(186003)(71200400001)(122000001)(2906002)(316002)(7696005)(9686003)(66946007)(66446008)(66556008)(6916009)(64756008)(478600001)(82960400001)(10290500003)(82950400001)(8676002)(8990500004)(6506007)(8936002)(66476007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?tR06L2hpThiTfXXOOZMVp7vOKL9ZVnYKSQ+tphmiMm6wqBewbUlTmA+N044m?=
 =?us-ascii?Q?JMqWtLMcQyY5JDNJMJI1hHedHr8fwZpDsl8iJ64JoOXfvxxJ2EoLJjIQtouJ?=
 =?us-ascii?Q?s2cl5IxgNAQYHvPFDtAbMwMpBmCEsbXpWKblNjwNC0LxZvddQ9DAtln/1bwu?=
 =?us-ascii?Q?1oMZpeEcOnh3Fe4fUHLgY4wnltRZ9DZPEm1T0tJt2ZziQOygbAsqHJvMp+13?=
 =?us-ascii?Q?+V5gnLQLU02JGm0p0NdkBeCOBeecULhMm6F4O7Lejaf6GdK+QhXXX5CRYXfA?=
 =?us-ascii?Q?ICR+GPk3Hl86ntJPC929MORhEIfI/3eJQEs4DtVFSFdsg1JwKKutUgRWH/bc?=
 =?us-ascii?Q?/tstSGwGX3N6jIIywnhToC1RQM7CwoQ5l5rM4QVMLVB0SLPWG9rEYcFDZBV1?=
 =?us-ascii?Q?pW8X/1eKe9mav6mdATeFXKdaGYfHKtoDRahEVdDyEiyFp0JympeSUFZhQ7SV?=
 =?us-ascii?Q?C1fy1hbuDetkmfwnRuuIMwQApoHBGGpBckFbnlHFnTrQb8oGf29N3TC0+Ctg?=
 =?us-ascii?Q?0qMGHlAnG5dRquJOPrrqkUtMCUDTtAjD22GXkzmGvoR5ftwXBqUXQ+uhSZf0?=
 =?us-ascii?Q?C5Lgqv078kiog9aM7D81blipmdrWID/BI+gL1fg5CHA3m9h3Ii0ysEQhejuz?=
 =?us-ascii?Q?agFPsr3Niw+/Su+ZcdivE2JlZpBB66KaeNrJBbr6rC3Vi41pT+rmyoMEtW32?=
 =?us-ascii?Q?8bAuaXkmbfkZ+UWcBj9CTYwAhCRiISnJURTEF8Gpho+D1sv80bCdNo7TdM7D?=
 =?us-ascii?Q?kd7Zf8SkElSgfP2Y9080MVBbkwwLm0nc3zPOYvU7vH7Nsw04AOYHSfmKZor7?=
 =?us-ascii?Q?6kIoiPOlsL9lpS8sDL87X4W/aEMKa0Xia+89ML6eOq0jKrqyJFxSm/RTpr/j?=
 =?us-ascii?Q?zNAIrKhTFKGmYNC+dpWUwglQwOH5MXGt0dzkA5T9vEJVX+vMSSlC0O8Ns168?=
 =?us-ascii?Q?c10vNQwdb+vLyMwlfdHsoAf9Ip+B+e17ECNCK8D8sIpyo9pPXBQHN9xAsZGF?=
 =?us-ascii?Q?nF3XKECx4vi3xzWxEzx9vngDSHDR0AAt1LjYMZRzBPlv+w6NBcd0gCXA3WcN?=
 =?us-ascii?Q?4AlGCX3tNNXnemefgxhcJTikhIouTf2WGd4awBj4Clo+Om2sVzi/9CaBnjH2?=
 =?us-ascii?Q?CC7v11rNKF0B1+KBZsvn3NmBgpkmu+iGg3ZfPZaJk6Vr5hQOmGyldacev7xe?=
 =?us-ascii?Q?Mc49weNs2HLqxHdvTyR5KLwGafYz13HMVRg0CE+A5XFE+3IPeQqaEHCe1zlJ?=
 =?us-ascii?Q?MJerxMsioMXwF4pCuQ1ooNw4TV0vLnyF9oSsjRnJAAxxOEom3jugccS1Nzpm?=
 =?us-ascii?Q?F3ra+hSlRfKzR9JP1Q2UvMZpsXkaSgfuBJ09UPlI21Y1VQD01NbUsYvFCttc?=
 =?us-ascii?Q?uy21PxITB1kVWPbdLIQtYJiguZBT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f301c475-d941-480a-820f-08d9003a43d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 18:14:09.4666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1X3kySp73XoueUmRIOvU+YSvUTP8xPa/OFB7eOFTi6NqaTOOvOmQYpIXADqkeTJWDa0C7ZpIrxnioUrfo2R3Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0845
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, April 15, 2021 10:44 AM
>  ...
> On Wed, 14 Apr 2021 22:45:19 -0700 Dexuan Cui wrote:
> > +	buf =3D dma_alloc_coherent(gmi->dev, length, &dma_handle,
> > +				 GFP_KERNEL | __GFP_ZERO);
>=20
> No need for GFP_ZERO, dma_alloc_coherent() zeroes the memory these days.

Yes, indeed. Will remove __GFP_ZERO.

>=20
> > +static int mana_gd_register_irq(struct gdma_queue *queue,
> > +				const struct gdma_queue_spec *spec)
> > ...
> > +	struct gdma_irq_context *gic;
> > +
> > +	struct gdma_context *gc;
>=20
> Why the empty line?

No good reason. Will remove this line. I'll check the whole patch
for similar issues.

>=20
> > +	queue =3D kzalloc(sizeof(*queue), GFP_KERNEL);
> > +	if (!queue)
> > +		return -ENOMEM;
> > +
> > +	gmi =3D &queue->mem_info;
> > +	err =3D mana_gd_alloc_memory(gc, spec->queue_size, gmi);
> > +	if (err)
> > +		return err;
>=20
> Leaks the memory from 'queue'?

Sorry. This should be a bug I introduced when moving arouond some code.

> Same code in mana_gd_create_mana_eq(), ...wq_cq(), etc.

Will fix all of them, and check for the code similar issues.

> > +int mana_do_attach(struct net_device *ndev, enum mana_attach_caller
> caller)
> > +{
> > +	struct mana_port_context *apc =3D netdev_priv(ndev);
> > +	struct gdma_dev *gd =3D apc->ac->gdma_dev;
> > +	u32 max_txq, max_rxq, max_queues;
> > +	int port_idx =3D apc->port_idx;
> > +	u32 num_indirect_entries;
> > +	int err;
> > +
> > +	if (caller =3D=3D MANA_OPEN)
> > +		goto start_open;
> > +
> > +	err =3D mana_init_port_context(apc);
> > +	if (err)
> > +		return err;
> > +
> > +	err =3D mana_query_vport_cfg(apc, port_idx, &max_txq, &max_rxq,
> > +				   &num_indirect_entries);
> > +	if (err) {
> > +		netdev_err(ndev, "Failed to query info for vPort 0\n");
> > +		goto reset_apc;
> > +	}
> > +
> > +	max_queues =3D min_t(u32, max_txq, max_rxq);
> > +	if (apc->max_queues > max_queues)
> > +		apc->max_queues =3D max_queues;
> > +
> > +	if (apc->num_queues > apc->max_queues)
> > +		apc->num_queues =3D apc->max_queues;
> > +
> > +	memcpy(ndev->dev_addr, apc->mac_addr, ETH_ALEN);
> > +
> > +	if (caller =3D=3D MANA_PROBE)
> > +		return 0;
> > +
> > +start_open:
>=20
> Why keep this as a single function, there is no overlap between what's
> done for OPEN and PROBE, it seems.
>=20
> Similarly detach should probably be split into clearly distinct parts.

Will improve the code. Thanks for the suggestion!

Thanks,
Dexuan
