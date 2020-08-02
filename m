Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61615239CC7
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 00:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgHBW0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 18:26:16 -0400
Received: from mail-dm6nam10on2138.outbound.protection.outlook.com ([40.107.93.138]:23777
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726536AbgHBW0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 18:26:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+WqCwfZxj3ft/16Eha0W20KCSGDxy2BP5CAMbqqPSXBnpcQo/pnur9tcWf4dV/VhvA+aXh5URYjrVMqRs5/+9/DKH0JB9HmZ2Jh+Rk7OnqBkqsttOOpWhHrGwystEy1ml/iJwH7k3hTAB635uuE22Y3p19AtPPGVab1iImLEqFOcEMf5iL1mb6JAObewvXfVKwiJAf9UH9ixBGyEkHHPN7fLI3wFXKZs+SHGuKJjSQOgcpndnU0JyNAv3gDmKji091hbTfvK+ouu4gsD1hOqjuGq6eVfrbqC9lUzhrW7N9bjKK8UmGF+z2CltqjF6P3C7ZYO2tFzuN2y5ZIrAH4Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4bWKAiCYSFk3fh4MAQwciifNRmfR4mRJGksr/0farw=;
 b=URj2M0vznGFxLs3H1fbAL1W37AcWS8VBHy8oviePuZ4H9EI/VOkqtVAXjNBYMesd7KPFYN2jIiycqpkA0h2NxmYByQtLuf1FVdj7MEn4yh/h5XfaFNu/qq7v3UjYU3TwHj3SZb42aVXQXAYk5uCCsaCRvSwYeRknEUaezbl89HzUOyPQZMrshGqH7AX7AOV14HQgKRw6dtU4Ul1pXTdTizcdDCunlcK5sxhus1I4/fInDlONLTVimvK2S6A1lSoW/se5NM1h/ye8V8I49/wIOFjpO/NV4G9GadAnC5aOIQmZghDDWX/H3wBL1q0HY4Tgxzi70e63wKNhQzfsQkKqNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4bWKAiCYSFk3fh4MAQwciifNRmfR4mRJGksr/0farw=;
 b=Q4pWJ9D0VG246YHwIiaXTYzG7ytfFt1jADhyOs5BWyxuUDAXCS5YS2EGR3VhHS63kb27hNqw+ct6PGbXLVzT6e2ZHbtsmYxJ5AIvWbV0OYUl6oHDnHPAxoiKj5r6zBF1RTEdEdYkHYxzh2ACOaeOzVKqz5GuV/iQ8zLI4fUsEcY=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB1011.namprd21.prod.outlook.com
 (2603:10b6:207:37::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.0; Sun, 2 Aug
 2020 22:26:05 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33%4]) with mapi id 15.20.3283.001; Sun, 2 Aug 2020
 22:26:04 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Andres Beltran <lkmlabelt@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] hv_netvsc: Add validation for untrusted Hyper-V values
Thread-Topic: [PATCH] hv_netvsc: Add validation for untrusted Hyper-V values
Thread-Index: AQHWZTHoXLDSH9H/Tk2558IHcuZF7qklY/Ug
Date:   Sun, 2 Aug 2020 22:26:04 +0000
Message-ID: <BL0PR2101MB0930BC0130F6AE5775E62604CA4C0@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20200728225321.26570-1-lkmlabelt@gmail.com>
In-Reply-To: <20200728225321.26570-1-lkmlabelt@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-08-02T22:26:02Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=618dbe02-a9c5-4653-890a-fab6866485e8;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6c3aaf0a-e1cd-4114-297f-08d837330b65
x-ms-traffictypediagnostic: BL0PR2101MB1011:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB10110AAD4AE0B85760452561CA4C0@BL0PR2101MB1011.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3rU1OoC8smcv92+uZXYojNPflzutgQq+GVJ7h6/S46wkefijN2zfGA0wEElZbdbEINOr0OIv3jXYAmK5eY1glpjx8haftw7lHFGnTFE8yKl8pq+d31Es7v0+Xcmw9sQi3NLP+0SVAOoLvou3P2Qp1FtnlCEJN8vyFMhr+lO1cxGtfKH8u7avJFR3/1LARTQIE3EKXjDnir0IDTU4YqrRG1ICSKetmSvX+LimuiOZLd+TvD1mDhW5YpvmlbTqZgYK0Pn/heKAXXQtDhguqUNdO85+AcrzjrYOgOfoc86mA+meCnKlMH+pbwoWxWnZHs1E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(52536014)(76116006)(9686003)(26005)(64756008)(55016002)(66946007)(66476007)(66556008)(66446008)(33656002)(8676002)(10290500003)(8936002)(2906002)(186003)(4326008)(53546011)(82950400001)(82960400001)(54906003)(5660300002)(316002)(478600001)(86362001)(83380400001)(7696005)(8990500004)(6506007)(110136005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: iNAYJmtLeCAFrUBck1Jxe3RT9ECJfrAavAzZh/unRyCEXLHgUXQQcnNnOvmRAmUcUDKQ+21qgV9QWwCTsvEZB0hU6vZworn8qDZI1a1vfrmWR1yaxM33cF78sv4TQl/eiVpUVvbCs6ryjn0/gkh8UyVX1N4gWuKhWEX0XTyRIY3gAJvvAEkV2nftY2Psgb0KNQqTbFUN/gBwySPHMtbXDEqvZEpjt0XcB/MJWyRu5J3w58Ckqce9WXUI5pxP9Mf2mD4PaL3WXNxBgPY32OnBEcrMgtGDebKvV+xFQsO5S31v5LBMv9014av9CCzA3OKB790EbKl80cqdvfMqZfw/j+nY5T4Z3RcGBuFeDBdtaECv3d6azDXNSN2B38KTroesJv8FIk0zbti1Avse3u8YlONtzrj+bP3jv9lFOcnvGiUrAgZe2kq9vb9AmDC8eFA+BX9yeDiQuQBQMyf0JHsTM7bBcslnJxvz5YbHlQ7uvlNEnaBH7ibWpFs2Y7U+/xZDP6/nvOox4isY1xslQ+jslXTZpJu4YAbS0LVvshuCEcbFmNlkAPHvM3QNYwN6JwLbVukr4bFiYPdmez3JMSG4+AtPVzjC3N15XIKai0MX0wNJTCLCCBCTfai+LiZiO5tW41CTWd3qwRstk0RYEffbBw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c3aaf0a-e1cd-4114-297f-08d837330b65
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2020 22:26:04.2236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lDjQe3QGIM7JDi0Z2azr8hx0phNJ9l68seUe0jGn6+J+b1j2rsCqEXfZ4+56XqfcFqy5tTSqwAGNnMAeB6Tjvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1011
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andres Beltran <lkmlabelt@gmail.com>
> Sent: Tuesday, July 28, 2020 6:53 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> wei.liu@kernel.org
> Cc: linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org; Michael
> Kelley <mikelley@microsoft.com>; parri.andrea@gmail.com; Saruhan
> Karademir <skarade@microsoft.com>; Andres Beltran <lkmlabelt@gmail.com>;
> David S . Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> netdev@vger.kernel.org
> Subject: [PATCH] hv_netvsc: Add validation for untrusted Hyper-V values
>=20
> For additional robustness in the face of Hyper-V errors or malicious
> behavior, validate all values that originate from packets that Hyper-V
> has sent to the guest in the host-to-guest ring buffer. Ensure that
> invalid values cannot cause indexing off the end of an array, or
> subvert an existing validation via integer overflow. Ensure that
> outgoing packets do not have any leftover guest memory that has not
> been zeroed out.
>=20
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
> ---
>  drivers/net/hyperv/hyperv_net.h   |  4 ++
>  drivers/net/hyperv/netvsc.c       | 99 +++++++++++++++++++++++++++----
>  drivers/net/hyperv/netvsc_drv.c   |  7 +++
>  drivers/net/hyperv/rndis_filter.c | 73 ++++++++++++++++++++---
>  4 files changed, 163 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_=
net.h
> index f43b614f2345..7df5943fa46f 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -860,6 +860,10 @@ static inline u32 netvsc_rqstor_size(unsigned long
> ringbytes)
>  	       ringbytes / NETVSC_MIN_IN_MSG_SIZE;
>  }
>=20
> +#define NETVSC_XFER_HEADER_SIZE(rng_cnt) \
> +		(offsetof(struct vmtransfer_page_packet_header, ranges) + \
> +		(rng_cnt) * sizeof(struct vmtransfer_page_range))
> +
>  struct multi_send_data {
>  	struct sk_buff *skb; /* skb containing the pkt */
>  	struct hv_netvsc_packet *pkt; /* netvsc pkt pending */
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 79b907a29433..7aa5276a1f36 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -398,6 +398,15 @@ static int netvsc_init_buf(struct hv_device *device,
>  	net_device->recv_section_size =3D resp->sections[0].sub_alloc_size;
>  	net_device->recv_section_cnt =3D resp->sections[0].num_sub_allocs;
>=20
> +	/* Ensure buffer will not overflow */
> +	if (net_device->recv_section_size < NETVSC_MTU_MIN ||
> (u64)net_device->recv_section_size *
> +	    (u64)net_device->recv_section_cnt > (u64)buf_size) {
> +		netdev_err(ndev, "invalid recv_section_size %u\n",
> +			   net_device->recv_section_size);
> +		ret =3D -EINVAL;
> +		goto cleanup;
> +	}
> +
>  	/* Setup receive completion ring.
>  	 * Add 1 to the recv_section_cnt because at least one entry in a
>  	 * ring buffer has to be empty.
> @@ -479,6 +488,12 @@ static int netvsc_init_buf(struct hv_device *device,
>  	/* Parse the response */
>  	net_device->send_section_size =3D init_packet->msg.
>  				v1_msg.send_send_buf_complete.section_size;
> +	if (net_device->send_section_size < NETVSC_MTU_MIN) {
> +		netdev_err(ndev, "invalid send_section_size %u\n",
> +			   net_device->send_section_size);
> +		ret =3D -EINVAL;
> +		goto cleanup;
> +	}
>=20
>  	/* Section count is simply the size divided by the section size. */
>  	net_device->send_section_cnt =3D buf_size / net_device-
> >send_section_size;
> @@ -770,12 +785,24 @@ static void netvsc_send_completion(struct
> net_device *ndev,
>  				   int budget)
>  {
>  	const struct nvsp_message *nvsp_packet =3D hv_pkt_data(desc);
> +	u32 msglen =3D hv_pkt_datalen(desc);
> +
> +	/* Ensure packet is big enough to read header fields */
> +	if (msglen < sizeof(struct nvsp_message_header)) {
> +		netdev_err(ndev, "nvsp_message length too small: %u\n",
> msglen);
> +		return;
> +	}
>=20
>  	switch (nvsp_packet->hdr.msg_type) {
>  	case NVSP_MSG_TYPE_INIT_COMPLETE:
>  	case NVSP_MSG1_TYPE_SEND_RECV_BUF_COMPLETE:
>  	case NVSP_MSG1_TYPE_SEND_SEND_BUF_COMPLETE:
>  	case NVSP_MSG5_TYPE_SUBCHANNEL:
> +		if (msglen < sizeof(struct nvsp_message)) {
> +			netdev_err(ndev, "nvsp_msg5 length too small: %u\n",
> +				   msglen);
> +			return;
> +		}

struct nvsp_message includes all message types, so its length is the longes=
t type,
The messages from older host version are not necessarily reaching the=20
sizeof(struct nvsp_message).

Testing on both new and older hosts are recommended, in case I didn't find =
out all issues
like this one.

Thanks,
- Haiyang
