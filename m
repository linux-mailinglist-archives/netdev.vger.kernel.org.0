Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025FA3613E0
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbhDOVJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:09:26 -0400
Received: from mail-bn8nam11on2111.outbound.protection.outlook.com ([40.107.236.111]:21985
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234869AbhDOVJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 17:09:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GAhrfYrHGrLMY5792isFu/u0trUQShii7gHbLArDGLtIK14KohJHn/nW4h9xe6gdfWy+hgp2v6t3rkjC/4yrV9VT4eDpm3bds4Nc+WXP8QSzxPOrVrIR8qt2tyxnd3bHV/2BH7KuXWZPj23uLOXsMg5mhnO+xe59DNGByKlVbo8rsH/LUJlGEUhC5F7sC7zhhDgYkrUyxjlmQPTf8upDkgUjUkpwwd5a22Q6jS7O5zkPNQjOsb0bDv0a02Z/1FGeb75t0VChvkT9D/rDS/oKUMrICr3kb8NxfpvDuRizE/fwaFNAUDqLsskpGqZxmBsMdmBVBAAotA7F7C512vqgVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iJ63PfKQ4yBAnv39u6tsElhfkXTyxf2P7sTGCvG/kw=;
 b=TsDk+y1RQmNELhcIfemNOFU3TvdKFk7YasP9i8eOkSmZweZkfYRkTbvrNsxCTX9/D3HzOom77gb5Gcb/qHFnLG4KPTgMFCduMaqF8SOu+QEVEjK+K/TPFMOp1/Uo9ntat2LfXT/hl9GpBzdmmqGRUyS1FcC6F9mbdyFChO1N7tAugOC6tI52Qm54LMFND44xGCbkXdlqUFTjRS5KqjqVSqy9Ha6tu0uwjxFjYJGggIcCLiQcroG5oMPfyTh3GXBr8s8cyRUtxkj1IkqwVOEGaJYiNMMZ/xYpEdI0SekoepT9tAlBDwYMXHPvGTxxU4TeuvDJvf8A1n/2bcBSZvecAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iJ63PfKQ4yBAnv39u6tsElhfkXTyxf2P7sTGCvG/kw=;
 b=BUkHFCSaZzLMPkuNxO/t5SEUCzDT7QVEt+G6+avOMdisnytgvIXLPzm1NNFr7iZh9pcS2l5oPiCOd7zuio2ZcrjpV81KFp0kwP2sRrnuwMcwVEIUNCUxHaNH253Hjz9wRozEE2uxUq2EpowLpXQeSwAOozRaHJUChI7vL/rLiCE=
Received: from MN2PR21MB1295.namprd21.prod.outlook.com (2603:10b6:208:3e::25)
 by MN2PR21MB1421.namprd21.prod.outlook.com (2603:10b6:208:1f7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6; Thu, 15 Apr
 2021 21:08:59 +0000
Received: from MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::84fb:f29:d4a9:6c10]) by MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::84fb:f29:d4a9:6c10%2]) with mapi id 15.20.4065.006; Thu, 15 Apr 2021
 21:08:58 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Dexuan Cui <decui@microsoft.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
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
Thread-Index: AQHXMbqnL34ZzVD9CUy17E5OCguws6q2E0cAgAAAQAA=
Date:   Thu, 15 Apr 2021 21:08:58 +0000
Message-ID: <MN2PR21MB129535044483127ED5B413BFCA4D9@MN2PR21MB1295.namprd21.prod.outlook.com>
References: <20210415054519.12944-1-decui@microsoft.com>
 <20210415140740.7fac720e@hermes.local>
In-Reply-To: <20210415140740.7fac720e@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=abeb63a1-902b-4af2-ad16-0769efafbbbf;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-15T21:08:33Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9856eaa-4ea2-4015-08b3-08d90052affd
x-ms-traffictypediagnostic: MN2PR21MB1421:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB14214B3A3BB478BF2B035F75CA4D9@MN2PR21MB1421.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AlIUVltR+DB5I7rz6JdSGak2VZDTacfk6NtXwWOY1OkdtbCWmOv/0xkd+zskbHzobgFnaOVXs94IIUJJ8qjq1YWhWmPcV0DIdlCR0m3OHqnmgIXvoK8usIV6zeqqDX3bmgZ9ZyfUZ5n8TS+HguaCbzj2LFEngcoHt9+Crdoi0Xuyydz8q4Moipm3T+Zal19YdkJ7T+gOO4em8mfIs0CuUdclFFuGRkEKzg4tQYXk7HTdssRRvmlvu2VaDGYFuYtX1czx2YZFpcVMK1gYTT5AYD1TPSBLRMsJ3y6ztYVHs9WstuOVU69SxStuk4J+zSk2E/Td04phRfvzCDCSpp1G6M4LLu5OVqx3Pi2PS0NFWgTUOHSDGWLiyshvzOxR6/5U3zR9TVVQCrYzcMz1i+WiHNrMy2HU+VtMqmP/ObCIIGgUU1G7kwVcP6/DnYgPF9NzdQQfpalOXagQ6whI9pFqZA/JIowjeI1XSZb2ekofR48jpFowQa5kc1tS9kiLg6Kr0N5EsNNBxj9tzj5yGhDM64qesyiCDWu5H7JHQlQqQb3xlvO96AUKkRc1V6CcEqA8uHvdLbgHnxsJcLZf3EGE3PlNDtgEFi9b326hvKoZ5jk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1295.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(47530400004)(8990500004)(66446008)(8936002)(66946007)(7696005)(86362001)(10290500003)(6636002)(66476007)(52536014)(7416002)(316002)(64756008)(54906003)(4326008)(76116006)(53546011)(66556008)(82960400001)(478600001)(186003)(71200400001)(83380400001)(38100700002)(8676002)(122000001)(82950400001)(5660300002)(9686003)(2906002)(55016002)(6506007)(26005)(110136005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?LP/ygnvT2lXNMbhIAdpef1dr6R4AiVz3kGrzjMHRaoQmETlHbZzMghtIpU33?=
 =?us-ascii?Q?973dBtJCYsEpSBhZHkdqhUuU78Q2aj3BPRDheWaPuIWg2bI+8ye+Mpb1XZyT?=
 =?us-ascii?Q?OyHS4CnLF/lv9JwNoBn3j7l0pn9Kh2qhUVG7wGo1PLR9eUOr0oOrsb4HQZnD?=
 =?us-ascii?Q?nAi81igd5Cn8eSV81FiNX2wE/A3HPQHNyw/2yf2PBQZaqtziCbc2WXsjzuoM?=
 =?us-ascii?Q?a4ssG5Go180BcfhSjbuiDo1BnkWhZ1+ZaBB8h0xSXWOgXd0twTWF7fWZRUnZ?=
 =?us-ascii?Q?+gVINCdeImRBJ5XxYgHSMO2x/Y6/+6zv6LhzNj8m/3bhX5OeG/vDF+ZwLcH7?=
 =?us-ascii?Q?vruMuSnPDu4fhZQCmV1Ccf2t9nDPyQ5AgbXuHnEfg3suwjoHg+gzbB+BkBiv?=
 =?us-ascii?Q?sd6rDkXAyVsebenLIDcsszks42C7QLSao+zd9eFJZk92HnPGZfvpCmKKgFFS?=
 =?us-ascii?Q?rXhpIlyFBVZWgkTRX5fRwWOZWTClbOkO7/VZlK/ZawGLoRXDAh+yj1S0PtTI?=
 =?us-ascii?Q?sr07R4jX84Cm/qcZDd6Oy0vfWhxbRjZ8XYgxyVsMy/aYdy7Yg2yGKfVEN+2i?=
 =?us-ascii?Q?Poiq1AycrszEfddQi4mBLbuqdDXqX9kJquudXe/NCsLh3OTiVFLjWUqd7nDQ?=
 =?us-ascii?Q?eCmgaulYT4HDB/wv3RNzoDqL6B2Lgy48V15TlMmQ2O89AdPqFjKtpYyOGHB8?=
 =?us-ascii?Q?gJ8B84J9bRwBjxdVgFM/y6F5IoHzDTIqQW+3EslfachM/ZThQL5Mcfu2/5Sk?=
 =?us-ascii?Q?FtmeB5PZtt09gxBgtm0pyERq//ol1eOE4P71K7+0bTrrhJBcrLPf9F0Dc9T6?=
 =?us-ascii?Q?oG+e+0J4kcgfCL4afzWFuDNLaidUWMAJwa7k2nNJHW+1CoxZlxxMR3wHa8JO?=
 =?us-ascii?Q?Ut1l3//ALEMY3qCCJ7CsFTtuQ+zBu7EoBdJ/Vn6CyzpdgXOXJeaAEJ/MaFo1?=
 =?us-ascii?Q?VbOrDLFSUs+ASfrDo2OF76ZwBSDy8AKlyO65wGa4BGXjtqzuvSK6mCc0XUoU?=
 =?us-ascii?Q?XyV+P7pa75CgGGPcLGAzoFoRLG+Ql7QQ1wq4/Yhp8WZTFUdju3a7VapqxakX?=
 =?us-ascii?Q?isRCh7mMZomQeBxQ0zysRyv7cjSPnl0MGkL0RvGiUumWUa9c9m7m2nXlkvlW?=
 =?us-ascii?Q?I4Jwmxc1RwzgWwwL6BVwXmz+4HZbZfyiDRYss6nBFM/mNl58cpk68b6KkQBP?=
 =?us-ascii?Q?FxfdH79zFyp5R51MMZD6qzJDkHBbSR3hQXYma9o9CpHsotm6jrgMkVK47MGW?=
 =?us-ascii?Q?mUcfiPz7K0c8M8dByXdGjIb4sESNbfSoOePUB4lKVwnyblbW5itG3xYE9NsS?=
 =?us-ascii?Q?lEmIw3ep4a7JpfiVfjkjHzkg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1295.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9856eaa-4ea2-4015-08b3-08d90052affd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 21:08:58.7830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9CEwrW1kwdSpm8kIIckooQKjFBapPApvdJH22MObMbjqA03bfYoC2vAV7RQHfv0b7wzJ/8B0jdhJOUxtYXxsEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1421
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Thursday, April 15, 2021 5:08 PM
> To: Dexuan Cui <decui@microsoft.com>
> Cc: davem@davemloft.net; kuba@kernel.org; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> <liuwe@microsoft.com>; netdev@vger.kernel.org; leon@kernel.org;
> andrew@lunn.ch; bernd@petrovitsch.priv.at; rdunlap@infradead.org;
> Shachar Raindel <shacharr@microsoft.com>; linux-kernel@vger.kernel.org;
> linux-hyperv@vger.kernel.org
> Subject: Re: [PATCH v6 net-next] net: mana: Add a driver for Microsoft Az=
ure
> Network Adapter (MANA)
>=20
> On Wed, 14 Apr 2021 22:45:19 -0700
> Dexuan Cui <decui@microsoft.com> wrote:
>=20
> > +static int mana_query_vport_cfg(struct mana_port_context *apc, u32
> vport_index,
> > +				u32 *max_sq, u32 *max_rq, u32
> *num_indir_entry) {
> > +	struct mana_query_vport_cfg_resp resp =3D {};
> > +	struct mana_query_vport_cfg_req req =3D {};
> > +	int err;
> > +
> > +	mana_gd_init_req_hdr(&req.hdr, MANA_QUERY_VPORT_CONFIG,
> > +			     sizeof(req), sizeof(resp));
> > +
> > +	req.vport_index =3D vport_index;
> > +
> > +	err =3D mana_send_request(apc->ac, &req, sizeof(req), &resp,
> > +				sizeof(resp));
> > +	if (err)
> > +		return err;
> > +
> > +	err =3D mana_verify_resp_hdr(&resp.hdr,
> MANA_QUERY_VPORT_CONFIG,
> > +				   sizeof(resp));
> > +	if (err)
> > +		return err;
> > +
> > +	if (resp.hdr.status)
> > +		return -EPROTO;
> > +
> > +	*max_sq =3D resp.max_num_sq;
> > +	*max_rq =3D resp.max_num_rq;
> > +	*num_indir_entry =3D resp.num_indirection_ent;
> > +
> > +	apc->port_handle =3D resp.vport;
> > +	memcpy(apc->mac_addr, resp.mac_addr, ETH_ALEN);
>=20
> You could use ether_addr_copy here.
>=20
>=20
> > +int mana_do_attach(struct net_device *ndev, enum mana_attach_caller
> > +caller) {
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
>=20
> And here use ether_addr_copy().

Thanks, I will update these.

- Haiyang
