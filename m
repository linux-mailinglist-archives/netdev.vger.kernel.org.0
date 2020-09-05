Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6333325E49E
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 02:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgIEAax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 20:30:53 -0400
Received: from mail-dm6nam11on2137.outbound.protection.outlook.com ([40.107.223.137]:53024
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726208AbgIEAaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 20:30:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1Xwn4aRZVgCeiV3/6BjSRAMnbXvBDehqD6ysYXEfR8kXJdBeOp6ne0MCNVro3q7N2Dt1J6/kIyQXpI44iBwORreU6dZHg+48dUQui01MZ4lQyrTc2JQ7H6Mp6G7eU7cFLK30BW70z4hesISt01QM+elmupCAK5GQbzP3DrmSLCthZr4fRppPiAuPnHH9f9Qfb1VrqU37SmUwm8fVsv/SKgRpuw5646JVFWGS1ZKhcNUcWJuQ6IsO2iIkyqU2kaMGFwSnmeIHWL5KDRa3ObwRN95L4xc8G42HHOO6b9dJplEXGeXzUY/1eBSanT9gQ/s10OneI3t+qttt5btGHUixA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuw9zJ4QKOwjjg1mdUnpEZBfvhm9dNP24eSKeB/l9cQ=;
 b=DzQoHVolVxkNS30CgjSAJYfMcR5xhORKLNEzWJo//kAVoPTSezOGbiRqtn1kOy1ZqOKtiiNx/sRgWqTv17j3sGWsWWKFVUrZfgbAmrZn63w7A170yPHitHlqO+XXjI4uEJpTBGmLLvb/4dvNiigsPf3BqM23vb0cuJpS+jwUBZ0QshQkCvbRIncAh0skRZCirQdetfSj2iq6ulVQEiUXZ4Q5ksBx1TyXVeF1Qb47FxmAwGkC656kZrSY6eP6O0+K+40BbCmmyB5lPsTqXfAxdhLxf+iyEVLWbs38jP4dOkMyur758sqT8SS3bl1pft/p7RdnrV0RXJvbqYCLmXjH7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuw9zJ4QKOwjjg1mdUnpEZBfvhm9dNP24eSKeB/l9cQ=;
 b=jxhVmPkFJtTOEBpj9c5NOUZA35SbnKyDD5IFGupMu2ia7Thqj/gKpSFg8RsWN8vn/F8lzZ41tRJS0D8KEEyG+BIOS34yvS/C4AVO85zSRGZzvwewC7GahWAn5+kdfNoHXPTgJlffwTYu6cERb9VyIYSlDng2MLmu788AiQaCP3c=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0749.namprd21.prod.outlook.com (2603:10b6:300:76::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.7; Sat, 5 Sep
 2020 00:30:48 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%5]) with mapi id 15.20.3370.008; Sat, 5 Sep 2020
 00:30:48 +0000
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
Subject: RE: [RFC v2 07/11] hv_netvsc: Use HV_HYP_PAGE_SIZE for Hyper-V
 communication
Thread-Topic: [RFC v2 07/11] hv_netvsc: Use HV_HYP_PAGE_SIZE for Hyper-V
 communication
Thread-Index: AQHWgNVetO8hT2p2aECskb2CDLuDyKlZNToA
Date:   Sat, 5 Sep 2020 00:30:48 +0000
Message-ID: <MW2PR2101MB10521041242835B2D6E3EA0AD72A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
 <20200902030107.33380-8-boqun.feng@gmail.com>
In-Reply-To: <20200902030107.33380-8-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-05T00:30:45Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=68df6d7d-4f12-4d3e-abba-2eaecbbf05fb;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 47c18f46-028d-4d74-11c4-08d85132ef92
x-ms-traffictypediagnostic: MWHPR21MB0749:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB0749B1AC568118280AF730E1D72A0@MWHPR21MB0749.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kqMNyBas5Ao1IU9ORRjcuaZgJXKO6i/dYO7cwVIG+qqp/v+IUckzJT76RkSHiumHt+5J5e85qNE+K3jBxDT8Q59oqdsSOBzyY2bOuSXrhwQ5+cSs2LzmUwK8tordp9r634YZF2qPDlt43BRafKku+pXIKAbv8dnkRnuHLUKURo8G44lJjNDZnnhlU9ggzq8fbTceuqB9/Fqz2eb7a5WjGvda/LBpQxRwMCLlHbY1WA/IQbpjDpcW1iZb5sev66e7wdqqdnCx2aFqnEo7vIAdHRTXhPL6i5ZY5twFfP51Zb//zPBmhnpux2/qU8hz3tcKHRa9BnmmIDy3BjI5pOihHihgxz8xtKpbcsQqwCTikE9RC0xGuLdRCacYclv/pKv4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(66946007)(5660300002)(82950400001)(71200400001)(82960400001)(478600001)(33656002)(55016002)(8676002)(52536014)(8936002)(86362001)(110136005)(66446008)(54906003)(8990500004)(186003)(83380400001)(2906002)(66476007)(10290500003)(76116006)(316002)(64756008)(9686003)(26005)(4326008)(6506007)(66556008)(7416002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 4JNvSFcURU2B9wguw31zsSXfwvv0xfm0fq4Ih8DWC/nyibVy8miIr8XPkTMjdlvArUntyXKE/rJfeqyS+2XkOfBfxIBtPSaYOFGf7qWsRlyWcrpMQeqljpsKQmrXqWfn4DEW6QweO4g8YtDPCWqKByPeLX7kxyAYob2dmjeYThxTKqWkeJsMiXaq2mUxae3W/m0wGUaq48EGNPfGbkO0kpBOo5LEkhOnokskbXbU5Bu0AAe9B1M7ybizpmPU/bpKP8H8lyp5bRW2RuH0s1bfSt5K1ZaHuRfmrPgn8zQ0n7Cie5C3Jw2rt566IWH9YANwQ/hzQQwTIY+t7Wml8ge+ApSK0okExinwnYBcedcryMm3ixMy008k02PNNJklqDh/mgZ9NylAJk9H6XZYAzfpWKNMQd9EqppGak+X+Dsd704n3xoeTgBo3Pr7rMPAI2QKtDRsnONgClxYXrbkoEgu2GOk3cgFFJ1otemKTi5OOFu5k+Wv2u72/oFNA39OF90m5158HLe2CDkXLyO7UjI35Gd/hWnGfVJvACta89ycPVm4OU+zP0Sv3eX43CLzSVLci4/fFf7veJnG6NxAUzbDstuF3JE8DpAiauE95lcxQ15orKedjEDrWiJ5LWSPAtIJrRftFLSGm7ROTG0i8GFw/w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47c18f46-028d-4d74-11c4-08d85132ef92
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2020 00:30:48.1287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hrHaf7JoJhrP7hSrycKEVXNoFFeMYtEDSH6F5fPa6WeF10/lmrju7ichiALngxz+BpwJflO4FLyTXSbJtVHs6kJaPqgQqHgvpfnTlg+oh/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0749
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Tuesday, September 1, 2020 8:=
01 PM
>=20
> When communicating with Hyper-V, HV_HYP_PAGE_SIZE should be used since
> that's the page size used by Hyper-V and Hyper-V expects all
> page-related data using the unit of HY_HYP_PAGE_SIZE, for example, the
> "pfn" in hv_page_buffer is actually the HV_HYP_PAGE (i.e. the Hyper-V
> page) number.
>=20
> In order to support guest whose page size is not 4k, we need to make
> hv_netvsc always use HV_HYP_PAGE_SIZE for Hyper-V communication.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  drivers/net/hyperv/netvsc.c       |  2 +-
>  drivers/net/hyperv/netvsc_drv.c   | 46 +++++++++++++++----------------
>  drivers/net/hyperv/rndis_filter.c | 12 ++++----
>  3 files changed, 30 insertions(+), 30 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 41f5cf0bb997..1d6f2256da6b 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -794,7 +794,7 @@ static void netvsc_copy_to_send_buf(struct netvsc_dev=
ice
> *net_device,
>  	}
>=20
>  	for (i =3D 0; i < page_count; i++) {
> -		char *src =3D phys_to_virt(pb[i].pfn << PAGE_SHIFT);
> +		char *src =3D phys_to_virt(pb[i].pfn << HV_HYP_PAGE_SHIFT);
>  		u32 offset =3D pb[i].offset;
>  		u32 len =3D pb[i].len;
>=20
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_=
drv.c
> index 64b0a74c1523..61ea568e1ddf 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -373,32 +373,29 @@ static u16 netvsc_select_queue(struct net_device *n=
dev, struct
> sk_buff *skb,
>  	return txq;
>  }
>=20
> -static u32 fill_pg_buf(struct page *page, u32 offset, u32 len,
> +static u32 fill_pg_buf(unsigned long hvpfn, u32 offset, u32 len,
>  		       struct hv_page_buffer *pb)
>  {
>  	int j =3D 0;
>=20
> -	/* Deal with compound pages by ignoring unused part
> -	 * of the page.
> -	 */
> -	page +=3D (offset >> PAGE_SHIFT);
> -	offset &=3D ~PAGE_MASK;
> +	hvpfn +=3D offset >> HV_HYP_PAGE_SHIFT;
> +	offset =3D offset & ~HV_HYP_PAGE_MASK;
>=20
>  	while (len > 0) {
>  		unsigned long bytes;
>=20
> -		bytes =3D PAGE_SIZE - offset;
> +		bytes =3D HV_HYP_PAGE_SIZE - offset;
>  		if (bytes > len)
>  			bytes =3D len;
> -		pb[j].pfn =3D page_to_pfn(page);
> +		pb[j].pfn =3D hvpfn;
>  		pb[j].offset =3D offset;
>  		pb[j].len =3D bytes;
>=20
>  		offset +=3D bytes;
>  		len -=3D bytes;
>=20
> -		if (offset =3D=3D PAGE_SIZE && len) {
> -			page++;
> +		if (offset =3D=3D HV_HYP_PAGE_SIZE && len) {
> +			hvpfn++;
>  			offset =3D 0;
>  			j++;
>  		}
> @@ -421,23 +418,26 @@ static u32 init_page_array(void *hdr, u32 len, stru=
ct sk_buff *skb,
>  	 * 2. skb linear data
>  	 * 3. skb fragment data
>  	 */
> -	slots_used +=3D fill_pg_buf(virt_to_page(hdr),
> -				  offset_in_page(hdr),
> -				  len, &pb[slots_used]);
> +	slots_used +=3D fill_pg_buf(virt_to_hvpfn(hdr),
> +				  offset_in_hvpage(hdr),
> +				  len,
> +				  &pb[slots_used]);
>=20
>  	packet->rmsg_size =3D len;
>  	packet->rmsg_pgcnt =3D slots_used;
>=20
> -	slots_used +=3D fill_pg_buf(virt_to_page(data),
> -				offset_in_page(data),
> -				skb_headlen(skb), &pb[slots_used]);
> +	slots_used +=3D fill_pg_buf(virt_to_hvpfn(data),
> +				  offset_in_hvpage(data),
> +				  skb_headlen(skb),
> +				  &pb[slots_used]);
>=20
>  	for (i =3D 0; i < frags; i++) {
>  		skb_frag_t *frag =3D skb_shinfo(skb)->frags + i;
>=20
> -		slots_used +=3D fill_pg_buf(skb_frag_page(frag),
> -					skb_frag_off(frag),
> -					skb_frag_size(frag), &pb[slots_used]);
> +		slots_used +=3D fill_pg_buf(page_to_hvpfn(skb_frag_page(frag)),
> +					  skb_frag_off(frag),
> +					  skb_frag_size(frag),
> +					  &pb[slots_used]);
>  	}
>  	return slots_used;
>  }
> @@ -453,8 +453,8 @@ static int count_skb_frag_slots(struct sk_buff *skb)
>  		unsigned long offset =3D skb_frag_off(frag);
>=20
>  		/* Skip unused frames from start of page */
> -		offset &=3D ~PAGE_MASK;
> -		pages +=3D PFN_UP(offset + size);
> +		offset &=3D ~HV_HYP_PAGE_MASK;
> +		pages +=3D HVPFN_UP(offset + size);
>  	}
>  	return pages;
>  }
> @@ -462,12 +462,12 @@ static int count_skb_frag_slots(struct sk_buff *skb=
)
>  static int netvsc_get_slots(struct sk_buff *skb)
>  {
>  	char *data =3D skb->data;
> -	unsigned int offset =3D offset_in_page(data);
> +	unsigned int offset =3D offset_in_hvpage(data);
>  	unsigned int len =3D skb_headlen(skb);
>  	int slots;
>  	int frag_slots;
>=20
> -	slots =3D DIV_ROUND_UP(offset + len, PAGE_SIZE);
> +	slots =3D DIV_ROUND_UP(offset + len, HV_HYP_PAGE_SIZE);
>  	frag_slots =3D count_skb_frag_slots(skb);
>  	return slots + frag_slots;
>  }
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis=
_filter.c
> index b81ceba38218..acc8d957bbfc 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -25,7 +25,7 @@
>=20
>  static void rndis_set_multicast(struct work_struct *w);
>=20
> -#define RNDIS_EXT_LEN PAGE_SIZE
> +#define RNDIS_EXT_LEN HV_HYP_PAGE_SIZE
>  struct rndis_request {
>  	struct list_head list_ent;
>  	struct completion  wait_event;
> @@ -215,18 +215,18 @@ static int rndis_filter_send_request(struct rndis_d=
evice *dev,
>  	packet->page_buf_cnt =3D 1;
>=20
>  	pb[0].pfn =3D virt_to_phys(&req->request_msg) >>
> -					PAGE_SHIFT;
> +					HV_HYP_PAGE_SHIFT;
>  	pb[0].len =3D req->request_msg.msg_len;
>  	pb[0].offset =3D
> -		(unsigned long)&req->request_msg & (PAGE_SIZE - 1);
> +		(unsigned long)&req->request_msg & (HV_HYP_PAGE_SIZE - 1);

Use offset_in_hvpage() as defined in patch 6 of the series?

>=20
>  	/* Add one page_buf when request_msg crossing page boundary */
> -	if (pb[0].offset + pb[0].len > PAGE_SIZE) {
> +	if (pb[0].offset + pb[0].len > HV_HYP_PAGE_SIZE) {
>  		packet->page_buf_cnt++;
> -		pb[0].len =3D PAGE_SIZE -
> +		pb[0].len =3D HV_HYP_PAGE_SIZE -
>  			pb[0].offset;
>  		pb[1].pfn =3D virt_to_phys((void *)&req->request_msg
> -			+ pb[0].len) >> PAGE_SHIFT;
> +			+ pb[0].len) >> HV_HYP_PAGE_SHIFT;
>  		pb[1].offset =3D 0;
>  		pb[1].len =3D req->request_msg.msg_len -
>  			pb[0].len;
> --
> 2.28.0

