Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8461625E496
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 02:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgIEATS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 20:19:18 -0400
Received: from mail-bn8nam12on2100.outbound.protection.outlook.com ([40.107.237.100]:30241
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726208AbgIEATP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 20:19:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLWSwm1hEPD55/WHNSdweWU2iVZbZcRbwnuSIGgmNtbluuf7WKyOzoO8KLTVrI4M6fOqb46Ur0FIyazrE/EtzyoC5WoGEoC3cafKw2COLqEaVBo7lBnzV6l4xValAIKeJO9a9KiQHLYU4qHg67QGXocRWv66gsp3v/K5xEb/1KQx9pOw8aQ6KcIw0YEvTIJBraT1RmT2CUXUiM9IXnZOS9PrDGFJ7Ngp61UO4NhTPyMfkW6hUZMDCq2/FtxySY0Wqd2j5fABAe3Yk6wp8EAH3xJ1duKwYWFZHZIhkzeSyxLlSoMU41H/UvBl4fZ0vtaP6qIiXv0GkvI2EMJJTrZXLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBTJH5pSyhYRIfuGAjuPvFA+TsbNFbpwSTXc8Fb7fuA=;
 b=KxxKoJPuDrPNjWs1Co/ecOOtdpe6FsBYmmRzn5lN+NS1OqE+HzjK3XkoFK9+4wxSUHa3ivjo66cysKE5LcXa06jgEeTQL/XHXm7BNZLvBy6pP5NNa2tx3XZSDCQ97nUwHXltFlO1IYAYJ6YZ1ABl3jf0pvfYSNd3GGWwOMmmIyW0v+glSIFGNOEp//iP1egXfz7Wc2J8f/1g0MKziY6s294jTV5b1QH37H+3sWKPc66gjJsSxqBnSrEFiF+80b5TTbLCrh4RY5vZDcj+d5stTiQTpWi7pj21eQUVmBXBehuEtjm7JUsiiWcVS60aoqdocLYRwlHChTxbUcKhjpIrpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBTJH5pSyhYRIfuGAjuPvFA+TsbNFbpwSTXc8Fb7fuA=;
 b=a289A3K8blyBWRxJlut2jrBRlTAnfYwkjsdnJQTvRPtw7+eulyeG3NcIUoEVA5CNypkBF8alv4+SMIqRdKjIdEi1LVqQnHMjLVO9C/UErBMfdDaEC/jYsJdh6zTG/3AgezvvxIuEpFBXSSq3d4r3Wj6yVZtFxE0HXHWr30O1O58=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0176.namprd21.prod.outlook.com (2603:10b6:300:78::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.0; Sat, 5 Sep
 2020 00:19:08 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%5]) with mapi id 15.20.3370.008; Sat, 5 Sep 2020
 00:19:08 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: RE: [RFC v2 03/11] Drivers: hv: vmbus: Introduce types of GPADL
Thread-Topic: [RFC v2 03/11] Drivers: hv: vmbus: Introduce types of GPADL
Thread-Index: AQHWgNVa4+3+6/SoS0KpUj1wmRcyxqlZLpYA
Date:   Sat, 5 Sep 2020 00:19:08 +0000
Message-ID: <MW2PR2101MB105294660A73A7C69273AB9ED72A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
 <20200902030107.33380-4-boqun.feng@gmail.com>
In-Reply-To: <20200902030107.33380-4-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-05T00:19:06Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=de8e29d0-c4a4-40f5-9797-4d6730e46817;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 57644499-dabe-4b76-ea7a-08d851314ea5
x-ms-traffictypediagnostic: MWHPR21MB0176:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB01768CB8904BDF3520D658A9D72A0@MWHPR21MB0176.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O8yOuQ0U2m/xEuilqSb9w9ByZ5ViILnkycGC1Xll+GX/ByIjZEp80jJgWk+Kfx7mucdoSIQzYa9Hrb29Q/xr3OMEv/0M4EdRZnwd/o16vJtxU4SVZn1BoVu5JOJXP5OMchVfOF5OaSmPxirqCtDzMGSyI2LN6D2KnuPB2WX0zod9GBDtl8uNO59TYkDCzLxTfIZeRnVpf2U8WKSywLDjMnR1f9T3v+0rBkk8f1o1672sI0Eg+Gc9XTR/OitP23L8O86/RXI8lpiGfIxFotJKsIM8wuyjZYlxFfR7RDIBoaKUeklllMP9ODr/I46M+rXSbgq7uLn9KM0qcaavP/7jZPC9NSgMUW/l0c587mwRysXgK+AA7oJecotUNXEuxW/A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(52536014)(6506007)(2906002)(8676002)(7696005)(5660300002)(110136005)(10290500003)(4326008)(30864003)(316002)(82950400001)(66946007)(54906003)(55016002)(82960400001)(64756008)(66446008)(83380400001)(8936002)(33656002)(9686003)(86362001)(71200400001)(66556008)(8990500004)(76116006)(7416002)(66476007)(478600001)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: RgKd4HJ3T/bmpDv+KoaF83R5ErycrgDAr6U4Ieh3Kr7YxRztsLhx4NW6Xd2LZIuzcWyThxgepg8fiIhEwFRSAehoQtcGc2utP5IiZY5ckh5sIYw/v9SB0sfeaw4YhERaSUgA57FOv1juukr/o7vnPldQp82vkeoTikrpvpiEcKZzC3nBCFqdp+sC3Ib1wPhqEaMaXERdnKvQucriUBXktpOMkD/yA/zSgNngkWUcAIXueDu2eEtpCul8QO3Oj6od7zGnFFf+Esqh1oMbkGHLNiJ94Bf3Uqucetn+V/iRG1snUCPtPkXUGcZ7o5c+Q4d8xZkdKDHPUVw2zDQSryuxJjW4iIlzU3zqaNz3AcjWtDUYA8JvJ+70P6uYYlVAJUR/MAdVe2fsiIuWWat7sPT1UVF2taxK0+d1sziNpOKZB+gHrAfrwQpbnCWGgfshMJNr87tqKQdNB1aZp8Ppb4AHFtK1bkH0Mai9YuO+Mb0Sw//KHYoziQXp7yW19cAkCK36JUavu6lwFhU7oi8UXISy8BgMfPjEXd88YcRqy61kmrFcB5Vppch8kdiVkIX/r6H2+saqrLkDlFOJmjS/NrRZHbkssR5taEYT+KqehoqKz0x2MWkdGQxoaSdhObaUX+E2BenUGjJm9T4dFgwU+yaRUg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57644499-dabe-4b76-ea7a-08d851314ea5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2020 00:19:08.6079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 51EMBsP7aAbsPgEuibRTkSOgFoEyMr42D3bgWEEeBsF7HpSR7CkcgOmIkKr2BtIIkwtxZCzU3VwCLX7E2cDajH3yuuxvdibZs5TJL+lU3vA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Tuesday, September 1, 2020 8:=
01 PM
>=20
> This patch introduces two types of GPADL: HV_GPADL_{BUFFER, RING}. The
> types of GPADL are purely the concept in the guest, IOW the hypervisor
> treat them as the same.
>=20
> The reason of introducing the types of GPADL is to support guests whose

s/of/for/

> page size is not 4k (the page size of Hyper-V hypervisor). In these
> guests, both the headers and the data parts of the ringbuffers need to
> be aligned to the PAGE_SIZE, because 1) some of the ringbuffers will be
> mapped into userspace and 2) we use "double mapping" mechanism to
> support fast wrap-around, and "double mapping" relies on ringbuffers
> being page-aligned. However, the Hyper-V hypervisor only uses 4k
> (HV_HYP_PAGE_SIZE) headers. Our solution to this is that we always make
> the headers of ringbuffers take one guest page and when GPADL is
> established between the guest and hypervisor, the only first 4k of
> header is used. To handle this special case, we need the types of GPADL
> to differ different guest memory usage for GPADL.
>=20
> Type enum is introduced along with several general interfaces to
> describe the differences between normal buffer GPADL and ringbuffer
> GPADL.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  drivers/hv/channel.c   | 159 +++++++++++++++++++++++++++++++++++------
>  include/linux/hyperv.h |  44 +++++++++++-
>  2 files changed, 182 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index 1cbe8fc931fc..7c443fd567e4 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -35,6 +35,98 @@ static unsigned long virt_to_hvpfn(void *addr)
>  	return  paddr >> HV_HYP_PAGE_SHIFT;
>  }
>=20
> +/*
> + * hv_gpadl_size - Return the real size of a gpadl, the size that Hyper-=
V uses
> + *
> + * For BUFFER gpadl, Hyper-V uses the exact same size as the guest does.
> + *
> + * For RING gpadl, in each ring, the guest uses one PAGE_SIZE as the hea=
der
> + * (because of the alignment requirement), however, the hypervisor only
> + * uses the first HV_HYP_PAGE_SIZE as the header, therefore leaving a
> + * (PAGE_SIZE - HV_HYP_PAGE_SIZE) gap. And since there are two rings in =
a
> + * ringbuffer, So the total size for a RING gpadl that Hyper-V uses is t=
he

Unneeded word "So"

> + * total size that the guest uses minus twice of the gap size.
> + */
> +static inline u32 hv_gpadl_size(enum hv_gpadl_type type, u32 size)
> +{
> +	switch (type) {
> +	case HV_GPADL_BUFFER:
> +		return size;
> +	case HV_GPADL_RING:
> +		/* The size of a ringbuffer must be page-aligned */
> +		BUG_ON(size % PAGE_SIZE);
> +		/*
> +		 * Two things to notice here:
> +		 * 1) We're processing two ring buffers as a unit
> +		 * 2) We're skipping any space larger than HV_HYP_PAGE_SIZE in
> +		 * the first guest-size page of each of the two ring buffers.
> +		 * So we effectively subtract out two guest-size pages, and add
> +		 * back two Hyper-V size pages.
> +		 */
> +		return size - 2 * (PAGE_SIZE - HV_HYP_PAGE_SIZE);
> +	}
> +	BUG();
> +	return 0;
> +}
> +
> +/*
> + * hv_ring_gpadl_send_offset - Calculate the send offset in a ring gpadl=
 based
> + *                             on the offset in the guest
> + *
> + * @send_offset: the offset (in bytes) where the send ringbuffer starts =
in the
> + *               virtual address space of the guest
> + */
> +static inline u32 hv_ring_gpadl_send_offset(u32 send_offset)
> +{
> +
> +	/*
> +	 * For RING gpadl, in each ring, the guest uses one PAGE_SIZE as the
> +	 * header (because of the alignment requirement), however, the
> +	 * hypervisor only uses the first HV_HYP_PAGE_SIZE as the header,
> +	 * therefore leaving a (PAGE_SIZE - HV_HYP_PAGE_SIZE) gap.
> +	 *
> +	 * And to calculate the effective send offset in gpadl, we need to
> +	 * substract this gap.
> +	 */
> +	return send_offset - (PAGE_SIZE - HV_HYP_PAGE_SIZE);
> +}
> +
> +/*
> + * hv_gpadl_hvpfn - Return the Hyper-V page PFN of the @i th Hyper-V pag=
e in
> + *                  the gpadl
> + *
> + * @type: the type of the gpadl
> + * @kbuffer: the pointer to the gpadl in the guest
> + * @size: the total size (in bytes) of the gpadl
> + * @send_offset: the offset (in bytes) where the send ringbuffer starts =
in the
> + *               virtual address space of the guest
> + * @i: the index
> + */
> +static inline u64 hv_gpadl_hvpfn(enum hv_gpadl_type type, void *kbuffer,
> +				 u32 size, u32 send_offset, int i)
> +{
> +	int send_idx =3D hv_ring_gpadl_send_offset(send_offset) >> HV_HYP_PAGE_=
SHIFT;
> +	unsigned long delta =3D 0UL;
> +
> +	switch (type) {
> +	case HV_GPADL_BUFFER:
> +		break;
> +	case HV_GPADL_RING:
> +		if (i =3D=3D 0)
> +			delta =3D 0;
> +		else if (i <=3D send_idx)
> +			delta =3D PAGE_SIZE - HV_HYP_PAGE_SIZE;
> +		else
> +			delta =3D 2 * (PAGE_SIZE - HV_HYP_PAGE_SIZE);
> +		break;
> +	default:
> +		BUG();
> +		break;
> +	}
> +
> +	return virt_to_hvpfn(kbuffer + delta + (HV_HYP_PAGE_SIZE * i));
> +}
> +
>  /*
>   * vmbus_setevent- Trigger an event notification on the specified
>   * channel.
> @@ -160,7 +252,8 @@ EXPORT_SYMBOL_GPL(vmbus_send_modifychannel);
>  /*
>   * create_gpadl_header - Creates a gpadl for the specified buffer
>   */
> -static int create_gpadl_header(void *kbuffer, u32 size,
> +static int create_gpadl_header(enum hv_gpadl_type type, void *kbuffer,
> +			       u32 size, u32 send_offset,
>  			       struct vmbus_channel_msginfo **msginfo)
>  {
>  	int i;
> @@ -173,7 +266,7 @@ static int create_gpadl_header(void *kbuffer, u32 siz=
e,
>=20
>  	int pfnsum, pfncount, pfnleft, pfncurr, pfnsize;
>=20
> -	pagecount =3D size >> HV_HYP_PAGE_SHIFT;
> +	pagecount =3D hv_gpadl_size(type, size) >> HV_HYP_PAGE_SHIFT;
>=20
>  	/* do we need a gpadl body msg */
>  	pfnsize =3D MAX_SIZE_CHANNEL_MESSAGE -
> @@ -200,10 +293,10 @@ static int create_gpadl_header(void *kbuffer, u32 s=
ize,
>  		gpadl_header->range_buflen =3D sizeof(struct gpa_range) +
>  					 pagecount * sizeof(u64);
>  		gpadl_header->range[0].byte_offset =3D 0;
> -		gpadl_header->range[0].byte_count =3D size;
> +		gpadl_header->range[0].byte_count =3D hv_gpadl_size(type, size);
>  		for (i =3D 0; i < pfncount; i++)
> -			gpadl_header->range[0].pfn_array[i] =3D virt_to_hvpfn(
> -				kbuffer + HV_HYP_PAGE_SIZE * i);
> +			gpadl_header->range[0].pfn_array[i] =3D hv_gpadl_hvpfn(
> +				type, kbuffer, size, send_offset, i);
>  		*msginfo =3D msgheader;
>=20
>  		pfnsum =3D pfncount;
> @@ -254,8 +347,8 @@ static int create_gpadl_header(void *kbuffer, u32 siz=
e,
>  			 * so the hypervisor guarantees that this is ok.
>  			 */
>  			for (i =3D 0; i < pfncurr; i++)
> -				gpadl_body->pfn[i] =3D virt_to_hvpfn(
> -					kbuffer + HV_HYP_PAGE_SIZE * (pfnsum + i));
> +				gpadl_body->pfn[i] =3D hv_gpadl_hvpfn(type,
> +					kbuffer, size, send_offset, pfnsum + i);
>=20
>  			/* add to msg header */
>  			list_add_tail(&msgbody->msglistentry,
> @@ -281,10 +374,10 @@ static int create_gpadl_header(void *kbuffer, u32 s=
ize,
>  		gpadl_header->range_buflen =3D sizeof(struct gpa_range) +
>  					 pagecount * sizeof(u64);
>  		gpadl_header->range[0].byte_offset =3D 0;
> -		gpadl_header->range[0].byte_count =3D size;
> +		gpadl_header->range[0].byte_count =3D hv_gpadl_size(type, size);
>  		for (i =3D 0; i < pagecount; i++)
> -			gpadl_header->range[0].pfn_array[i] =3D virt_to_hvpfn(
> -				kbuffer + HV_HYP_PAGE_SIZE * i);
> +			gpadl_header->range[0].pfn_array[i] =3D hv_gpadl_hvpfn(
> +				type, kbuffer, size, send_offset, i);
>=20
>  		*msginfo =3D msgheader;
>  	}
> @@ -297,15 +390,20 @@ static int create_gpadl_header(void *kbuffer, u32 s=
ize,
>  }
>=20
>  /*
> - * vmbus_establish_gpadl - Establish a GPADL for the specified buffer
> + * __vmbus_establish_gpadl - Establish a GPADL for a buffer or ringbuffe=
r
>   *
>   * @channel: a channel
> + * @type: the type of the corresponding GPADL, only meaningful for the g=
uest.
>   * @kbuffer: from kmalloc or vmalloc
>   * @size: page-size multiple
> + * @send_offset: the offset (in bytes) where the send ring buffer starts=
,
> + * 		 should be 0 for BUFFER type gpadl
>   * @gpadl_handle: some funky thing
>   */
> -int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
> -			       u32 size, u32 *gpadl_handle)
> +static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
> +				   enum hv_gpadl_type type, void *kbuffer,
> +				   u32 size, u32 send_offset,
> +				   u32 *gpadl_handle)
>  {
>  	struct vmbus_channel_gpadl_header *gpadlmsg;
>  	struct vmbus_channel_gpadl_body *gpadl_body;
> @@ -319,7 +417,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *chann=
el, void
> *kbuffer,
>  	next_gpadl_handle =3D
>  		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
>=20
> -	ret =3D create_gpadl_header(kbuffer, size, &msginfo);
> +	ret =3D create_gpadl_header(type, kbuffer, size, send_offset, &msginfo)=
;
>  	if (ret)
>  		return ret;
>=20
> @@ -400,6 +498,21 @@ int vmbus_establish_gpadl(struct vmbus_channel *chan=
nel, void
> *kbuffer,
>  	kfree(msginfo);
>  	return ret;
>  }
> +
> +/*
> + * vmbus_establish_gpadl - Establish a GPADL for the specified buffer
> + *
> + * @channel: a channel
> + * @kbuffer: from kmalloc or vmalloc
> + * @size: page-size multiple
> + * @gpadl_handle: some funky thing
> + */
> +int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
> +			  u32 size, u32 *gpadl_handle)
> +{
> +	return __vmbus_establish_gpadl(channel, HV_GPADL_BUFFER, kbuffer, size,
> +				       0U, gpadl_handle);
> +}
>  EXPORT_SYMBOL_GPL(vmbus_establish_gpadl);
>=20
>  static int __vmbus_open(struct vmbus_channel *newchannel,
> @@ -438,10 +551,11 @@ static int __vmbus_open(struct vmbus_channel *newch=
annel,
>  	/* Establish the gpadl for the ring buffer */
>  	newchannel->ringbuffer_gpadlhandle =3D 0;
>=20
> -	err =3D vmbus_establish_gpadl(newchannel,
> -				    page_address(newchannel->ringbuffer_page),
> -				    (send_pages + recv_pages) << PAGE_SHIFT,
> -				    &newchannel->ringbuffer_gpadlhandle);
> +	err =3D __vmbus_establish_gpadl(newchannel, HV_GPADL_RING,
> +				      page_address(newchannel->ringbuffer_page),
> +				      (send_pages + recv_pages) << PAGE_SHIFT,
> +				      newchannel->ringbuffer_send_offset << PAGE_SHIFT,
> +				      &newchannel->ringbuffer_gpadlhandle);
>  	if (err)
>  		goto error_clean_ring;
>=20
> @@ -462,7 +576,13 @@ static int __vmbus_open(struct vmbus_channel *newcha=
nnel,
>  	open_msg->openid =3D newchannel->offermsg.child_relid;
>  	open_msg->child_relid =3D newchannel->offermsg.child_relid;
>  	open_msg->ringbuffer_gpadlhandle =3D newchannel->ringbuffer_gpadlhandle=
;
> -	open_msg->downstream_ringbuffer_pageoffset =3D newchannel-
> >ringbuffer_send_offset;
> +	/*
> +	 * The unit of ->downstream_ringbuffer_pageoffset is HV_HYP_PAGE and
> +	 * the unit of ->ringbuffer_send_offset is PAGE, so here we first
> +	 * calculate it into bytes and then convert into HV_HYP_PAGE.
> +	 */
> +	open_msg->downstream_ringbuffer_pageoffset =3D
> +		hv_ring_gpadl_send_offset(newchannel->ringbuffer_send_offset << PAGE_S=
HIFT) >> HV_HYP_PAGE_SHIFT;

Line length?

>  	open_msg->target_vp =3D hv_cpu_number_to_vp_number(newchannel->target_c=
pu);
>=20
>  	if (userdatalen)
> @@ -556,7 +676,6 @@ int vmbus_open(struct vmbus_channel *newchannel,
>  }
>  EXPORT_SYMBOL_GPL(vmbus_open);
>=20
> -
>  /*
>   * vmbus_teardown_gpadl -Teardown the specified GPADL handle
>   */
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 38100e80360a..7d16dd28aa48 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -29,6 +29,48 @@
>=20
>  #pragma pack(push, 1)
>=20
> +/*
> + * Types for GPADL, decides is how GPADL header is created.
> + *
> + * It doesn't make much difference between BUFFER and RING if PAGE_SIZE =
is the
> + * same as HV_HYP_PAGE_SIZE.
> + *
> + * If PAGE_SIZE is bigger than HV_HYP_PAGE_SIZE, the headers of ring buf=
fers
> + * will be of PAGE_SIZE, however, only the first HV_HYP_PAGE will be put
> + * into gpadl, therefore the number for HV_HYP_PAGE and the indexes of e=
ach
> + * HV_HYP_PAGE will be different between different types of GPADL, for e=
xample
> + * if PAGE_SIZE is 64K:
> + *
> + * BUFFER:
> + *
> + * gva:    |--       64k      --|--       64k      --| ... |
> + * gpa:    | 4k | 4k | ... | 4k | 4k | 4k | ... | 4k |
> + * index:  0    1    2     15   16   17   18 .. 31   32 ...
> + *         |    |    ...   |    |    |   ...    |   ...
> + *         v    V          V    V    V          V
> + * gpadl:  | 4k | 4k | ... | 4k | 4k | 4k | ... | 4k | ... |
> + * index:  0    1    2 ... 15   16   17   18 .. 31   32 ...
> + *
> + * RING:
> + *
> + *         | header  |           data           | header  |     data    =
  |
> + * gva:    |-- 64k --|--       64k      --| ... |-- 64k --|-- 64k --| ..=
. |
> + * gpa:    | 4k | .. | 4k | 4k | ... | 4k | ... | 4k | .. | 4k | .. | ..=
. |
> + * index:  0    1    16   17   18    31   ...   n   n+1  n+16 ...       =
  2n
> + *         |         /    /          /          |         /             =
  /
> + *         |        /    /          /           |        /              =
 /
> + *         |       /    /   ...    /    ...     |       /      ...      =
/
> + *         |      /    /          /             |      /               /
> + *         |     /    /          /              |     /               /
> + *         V    V    V          V               V    V               v
> + * gpadl:  | 4k | 4k |   ...    |    ...        | 4k | 4k |  ...     |
> + * index:  0    1    2   ...    16   ...       n-15 n-14 n-13  ...  2n-3=
0
> + */
> +enum hv_gpadl_type {
> +	HV_GPADL_BUFFER,
> +	HV_GPADL_RING
> +};
> +
>  /* Single-page buffer */
>  struct hv_page_buffer {
>  	u32 len;
> @@ -111,7 +153,7 @@ struct hv_ring_buffer {
>  	} feature_bits;
>=20
>  	/* Pad it to PAGE_SIZE so that data starts on page boundary */
> -	u8	reserved2[4028];
> +	u8	reserved2[PAGE_SIZE - 68];
>=20
>  	/*
>  	 * Ring data starts here + RingDataStartOffset
> --
> 2.28.0

