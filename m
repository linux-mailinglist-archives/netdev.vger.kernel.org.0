Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC7D2D07BE
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 23:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgLFWs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 17:48:59 -0500
Received: from mail-dm6nam10on2121.outbound.protection.outlook.com ([40.107.93.121]:55169
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbgLFWs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 17:48:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrpCLh+A1xWmviN+k8KlkarXZEDPlZswvciDHhVztm+EDYQ/82iCPcDuaxV3i3HY78csLg3n3r9WYSHCd3HOewaYI6y9qMWtZibVz2D+y0TVpeUHuX1eI8BjNncTOgS+5THFk9BAzFF1cGW09ktyIElO+jhMzsedDCCsN/4FJdtZ8QtI3Ub3GoomkhFN0zpmOPhHtlv9KHZ6OBsOQqF/s2gLZ8g7S4joQU/fh4m/Q+CM35Gg2LP41SpF5TsHcwnE4QtARVltnZLU/MqzMivkhRgJgawxAoCFt2rX1ve6XZD6XB5AttARdpgSHTr89aoP5q+UTgszXvMkCJ/CJU13Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72BMP4SIlf5QxvcIulWooxTYhvs6thGUwBNnsq653N4=;
 b=lnWQY4/JDpNySBN73JLiawpohbx5o0EteXw6SyGRX/bR2be0ONXlqR2b4i5lNdoD1N+go2K7dTt7z0NCl1cVskZxKdkcIv/sOKZcLF5G8NCX2N2bQhCHQd3ZOZfAJk9i7hKNkxZfquPNNlLYW1yTsCjyor1DAaei3XENSvkwxfw4YBvPVPdIkeHgCqS3ISZ5I9w6z6di5hOWJ+W4l8lEhU8GHtbXiXYxHV7oq5gdv1Q5iNhdl3OWg1g1kHRs5LqEnj4l9wt7CErYH45UZuUMfUdFcbUxI+AdummxE8OpDCau6AdK2sw+ynlD3U0AiZvl7/5jdDRFcNZv05NQrZ+83w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72BMP4SIlf5QxvcIulWooxTYhvs6thGUwBNnsq653N4=;
 b=FBVmL2I2nE7b0Lvk3yp9wCWNCLjcqk2gRhsaWFoEy1NVeRBDNkSNiAMuENvCfKlFVaK7rqGDEsnYS7cCO7rVomjOB6lVODapGIrm+AqQkXwP2JUEfLgYiY3VPab4BTXRQgoT6kdfNFiRkXiifBylf0wWBJoSR2/dMB55TrUIPDk=
Received: from (2603:10b6:302:a::16) by
 MW4PR21MB1905.namprd21.prod.outlook.com (2603:10b6:303:7e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.3; Sun, 6 Dec 2020 22:48:10 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::b8f6:e748:cdf2:1922]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::b8f6:e748:cdf2:1922%8]) with mapi id 15.20.3654.005; Sun, 6 Dec 2020
 22:48:10 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Andres Beltran <lkmlabelt@gmail.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v2] Drivers: hv: vmbus: Copy packets sent by Hyper-V out
 of the ring buffer
Thread-Topic: [PATCH v2] Drivers: hv: vmbus: Copy packets sent by Hyper-V out
 of the ring buffer
Thread-Index: AQHWtoAsiafqnDwyfUGUOfgg02x7Nanq1NZQ
Date:   Sun, 6 Dec 2020 22:48:10 +0000
Message-ID: <MW2PR2101MB1052B7CBB14283AA066BF125D7CF1@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20201109100727.9207-1-parri.andrea@gmail.com>
In-Reply-To: <20201109100727.9207-1-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-12-06T22:48:08Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ac985768-ec28-4e48-9979-e5e314902878;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 704b5bb0-1b0a-4b6f-1397-08d89a3901b9
x-ms-traffictypediagnostic: MW4PR21MB1905:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB190544A6EBC7542A32F89CDCD7CF1@MW4PR21MB1905.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jkskURfgH6Zm9bNl4151JSyb/+5zy1LVGlML8tYyIREfAo5fthGV+DZnXQfrxdmtFPHbe+VmKYJyI1a8HKIFIBenIHZJucx6kreyUbrBGd6BscN20/zY2C4fr+BjVPRub99g5dHvMnID4iyLFLJs7fsc3wUrg11U64OxGapVoDKoo+ZGoeqhzoe4iizUVQYXwo8Xom/oZ58neSkrjKqtpKiWgQXqCCU27uROejXo7cebJ+FSP9uxrpnf6dLubLpZ4tv2yDL8vlPj1jdxvk7Q61cgRBX/1EuH0E5pe0pe1lpUZAlt1+1EE9cKA5R5wq+CnlabW5+e/wi4zDm3XfaMdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(8990500004)(6506007)(2906002)(83380400001)(66446008)(9686003)(66946007)(66556008)(76116006)(82960400001)(82950400001)(8676002)(5660300002)(64756008)(66476007)(110136005)(54906003)(52536014)(8936002)(86362001)(55016002)(33656002)(7696005)(26005)(71200400001)(316002)(478600001)(4326008)(186003)(10290500003)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lTvRizhm9A/BKTyL3uLR7sEkma3EgcObHsu3E+xjUIiUcaWlqw4LXpnct2Nq?=
 =?us-ascii?Q?lI/Zo4nwp2XuL+8dpFnfV7J8WT4hlKzUKqhoO3EXJ45WxTtv06/ANHYGPWJA?=
 =?us-ascii?Q?jY0YdWkHLZ+neNSwIXqnhuO7HgI2Gdq56yjFfQPonOjb1yxq4J1G97uRsJOV?=
 =?us-ascii?Q?eWuyY/371Ki+lapxvJkIYnkRcCEt3IlP+Id4nb5iQuV80Wlt7RG8SA9OKLwQ?=
 =?us-ascii?Q?Fl7nCRaUhlBYF3IWh7FyKe6nZ+c8zajbtProkqhYIC1aa2iXhd5pO0rJIzH8?=
 =?us-ascii?Q?GGvVJnRxkxDNXsPaoHUHghrHKCEOJc3o04rQj4JZ0l5n4GJKBt90MB63njhz?=
 =?us-ascii?Q?lJMvjZiGrV3xF+3lH05ZDj8mJ1d9jvzYIOT6LXu4fx7prl/8NFsr7GLTxQnO?=
 =?us-ascii?Q?5Q2O5YucEkgVCTtG/2JNchupdFu/eVW3o24TR9UdQT6hE4HzX9uHuHapn+HX?=
 =?us-ascii?Q?C0AylWkoTKGm5KpOoMbfdrJqZwaJNtLAox+kPNZPO7HFZ8IKY5Kz29tGGy/n?=
 =?us-ascii?Q?0nEaFcORdPhc9NtLWdIYJ7P5wIUB/P9PKHEUJvklTEZfW+vx1zkbXKXTjnhK?=
 =?us-ascii?Q?jtfU5tlk9cCJTT3yqqV7WViGjlwcNK6KnTZqUlrM6psyAtHdhwHKiiR0XVbF?=
 =?us-ascii?Q?cB2lMaUUOCAzjoVuiiVTCcdQTbU4C6oAdtMEpJrNQGc5YSUhzj2rMv7B/E7r?=
 =?us-ascii?Q?3q13XfpMaG2TMFTloYbXh7SRsTlNDycQe/ZdXPOykXpc1oirBmQOAOHz/qxg?=
 =?us-ascii?Q?SilouGPoBNmcSKfwsBzWiOneAVz80MWXyQQ17UVLQe8vulvwu7zCC0JkvOhj?=
 =?us-ascii?Q?LsVZ8hUsOrpfY1ZnSoIO0D+ChR9QFgtnJb00pRLuzJVnP40LyiHuhv3Yb/Rw?=
 =?us-ascii?Q?qop9PstkizN1a8ExSKCh5cyjQHEWb3MjFk39WW8v4NJ9vsjKybaHFOWyzWAE?=
 =?us-ascii?Q?PE+P6DOHDGjQOjb9ko4J4AjFOonCe6zWyL2AHmNfAf4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 704b5bb0-1b0a-4b6f-1397-08d89a3901b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2020 22:48:10.4065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iFIeQZLRwDH7l6DUenqCpPaZUH9rbVRHF/6UZCOFTB6wdS0z/3o55wTdbLpS4Oz166Pr5O0AueGwrUqwSfCWnfq2S30L4GTRhRYVE0YJajo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1905
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Monday, Novem=
ber 9, 2020 2:07 AM
>=20
> From: Andres Beltran <lkmlabelt@gmail.com>
>=20
> Pointers to ring-buffer packets sent by Hyper-V are used within the
> guest VM. Hyper-V can send packets with erroneous values or modify
> packet fields after they are processed by the guest. To defend
> against these scenarios, return a copy of the incoming VMBus packet
> after validating its length and offset fields in hv_pkt_iter_first().
> In this way, the packet can no longer be modified by the host.
>=20

[snip]

> @@ -419,17 +446,52 @@ static u32 hv_pkt_iter_avail(const struct hv_ring_b=
uffer_info *rbi)
>  struct vmpacket_descriptor *hv_pkt_iter_first(struct vmbus_channel *chan=
nel)
>  {
>  	struct hv_ring_buffer_info *rbi =3D &channel->inbound;
> -	struct vmpacket_descriptor *desc;
> +	struct vmpacket_descriptor *desc, *desc_copy;
> +	u32 bytes_avail, pkt_len, pkt_offset;
>=20
> -	hv_debug_delay_test(channel, MESSAGE_DELAY);
> -	if (hv_pkt_iter_avail(rbi) < sizeof(struct vmpacket_descriptor))
> +	desc =3D hv_pkt_iter_first_raw(channel);
> +	if (!desc)
>  		return NULL;
>=20
> -	desc =3D hv_get_ring_buffer(rbi) + rbi->priv_read_index;
> -	if (desc)
> -		prefetch((char *)desc + (desc->len8 << 3));
> +	bytes_avail =3D hv_pkt_iter_avail(rbi);
> +
> +	/*
> +	 * Ensure the compiler does not use references to incoming Hyper-V valu=
es (which
> +	 * could change at any moment) when reading local variables later in th=
e code
> +	 */
> +	pkt_len =3D READ_ONCE(desc->len8) << 3;
> +	pkt_offset =3D READ_ONCE(desc->offset8) << 3;
> +
> +	/*
> +	 * If pkt_len is invalid, set it to the smaller of hv_pkt_iter_avail() =
and
> +	 * rbi->pkt_buffer_size
> +	 */
> +	if (rbi->pkt_buffer_size < bytes_avail)
> +		bytes_avail =3D rbi->pkt_buffer_size;

I think the above could be combined with the earlier call to hv_pkt_iter_av=
ail(),
and more logically expressed as:

	bytes_avail =3D min(rbi->pkt_buffer_size, hv_pkt_iter_avail(rbi));


This is a minor nit.  Everything else in this patch looks good to me.

Michael

> +
> +	if (pkt_len < sizeof(struct vmpacket_descriptor) || pkt_len > bytes_ava=
il)
> +		pkt_len =3D bytes_avail;
> +
> +	/*
> +	 * If pkt_offset is invalid, arbitrarily set it to
> +	 * the size of vmpacket_descriptor
> +	 */
> +	if (pkt_offset < sizeof(struct vmpacket_descriptor) || pkt_offset > pkt=
_len)
> +		pkt_offset =3D sizeof(struct vmpacket_descriptor);
> +
> +	/* Copy the Hyper-V packet out of the ring buffer */
> +	desc_copy =3D (struct vmpacket_descriptor *)rbi->pkt_buffer;
> +	memcpy(desc_copy, desc, pkt_len);
> +
> +	/*
> +	 * Hyper-V could still change len8 and offset8 after the earlier read.
> +	 * Ensure that desc_copy has legal values for len8 and offset8 that
> +	 * are consistent with the copy we just made
> +	 */
> +	desc_copy->len8 =3D pkt_len >> 3;
> +	desc_copy->offset8 =3D pkt_offset >> 3;
>=20
> -	return desc;
> +	return desc_copy;
>  }
>  EXPORT_SYMBOL_GPL(hv_pkt_iter_first);
>=20
