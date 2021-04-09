Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8477935A242
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhDIPtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:49:17 -0400
Received: from mail-mw2nam12on2123.outbound.protection.outlook.com ([40.107.244.123]:20398
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229665AbhDIPtQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 11:49:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eT34UCT8cfv0kqT7/QJbomNI80ijZOLei2FVy/Tm+eFmbmRJQIEbnDmrWDbPw7OmzoJbxgSLIVlA6nCU7O4e1DJU/n0vIKGT2jO5y3etolZorDlao5IHcGDftYrE8+VaKFCY+e0e+ptK8RKuu8TkR4l1vkoFm1rHKeg8zRdP2iv9oyWq4MaBosjOBNhe5vTvI8SeZSckRVqTrgK2pP4NHtjDoFlIxBhR5a/UmFcCOYtMs1+kWeqBM1Q35B8u42HvQCveExQcTE5Wt8d72Mi+ua7ukQo5Eu9RidU3Afcmj+Yt+KL43j4CtVWHDV5mKQD13L7MYCvEIAwgi7DeXq/4WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LK3THLrnDmUzeQZ66B4wVRJdWkaMpAk/EY07oKBqEvs=;
 b=PgF1f9Oy4OIBSLU3NW8zekM045Jiv6LhnQZjRO8J6PBm5EqT/6AcGFdTzE2/ZyxarkqG6fkynX6+pJQdy0diuXL80zoBPiv6ihj0T6SLPjbZbCw3+M9POV/wyQrV3vWSo4r5x+uaOOBb+A+ptjeRCCT3S0RLcL3hoh5B9vwLC8tlkPbA+HFE6Xh3MNnkNWR9wB4QfJVPmUdDwYJt4OxLA9CfNC8Cd6k57YecrBTsu5xlMNwSpwA3dbvN/gDV9hkZ7TplGwR68P0Zr5ns2+NCPf7ZcMsaTCbHpuSZ+brgYRsCq/2sFGf/uIy1p96g/HzdRIWE4zLv3mktf083cHE3dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LK3THLrnDmUzeQZ66B4wVRJdWkaMpAk/EY07oKBqEvs=;
 b=OL5F/iGqxltsXbW3d3vu0z4zTt51sXAU5Ye7rP+O55fOuRR5CJKPjqkVLyWBLAN/rJBW0ckhQN9Vek89Mgm6/qizvP/WhYKLsdalUni9rUJlcJR1pqp2Ezk2NVVI1gYYa7cfI5zNSW+dXMI9iaP20Dpbaav5mH9cZ4dyY9d1Dc8=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW4PR21MB1922.namprd21.prod.outlook.com (2603:10b6:303:73::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Fri, 9 Apr
 2021 15:49:01 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3808:777c:8b25:c88d]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3808:777c:8b25:c88d%5]) with mapi id 15.20.4042.010; Fri, 9 Apr 2021
 15:49:00 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Andres Beltran <lkmlabelt@gmail.com>
Subject: RE: [PATCH hyperv-next] Drivers: hv: vmbus: Copy packets sent by
 Hyper-V out of the ring buffer
Thread-Topic: [PATCH hyperv-next] Drivers: hv: vmbus: Copy packets sent by
 Hyper-V out of the ring buffer
Thread-Index: AQHXLJJagDKycFtcJkGpES1elshg6KqsVdzw
Date:   Fri, 9 Apr 2021 15:49:00 +0000
Message-ID: <MWHPR21MB1593B81DEB6428DC3FD6085ED7739@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210408161439.341988-1-parri.andrea@gmail.com>
In-Reply-To: <20210408161439.341988-1-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ce78c4d2-fdcc-4016-9b58-b1a99f6ff729;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-09T15:46:27Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26f586da-dbe4-4f29-66c9-08d8fb6efe9e
x-ms-traffictypediagnostic: MW4PR21MB1922:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB19220585B73E0F5411B677DFD7739@MW4PR21MB1922.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G94GwkIlxSxKfjjhw7bPNYkBAo9FeluQl8aKfoO71sSwZDWMJ7uLFxqmFfeW8QizR9a2outewvQbMCN86pdOBU19ft0SmejyAJPTTewylV9BQCRySqlALBgkziyQL+G6C+daqZ6fzL/IDvY8gHiJqc6pefGlLBe1U/eZ2eJm0WahGCstp/ay1JswhLgCC3if1ToRG5aQ/NZ+DClZt4bJ34TmW/CNbD4qPL5lF36Nn93C9VxEU6OdhBujk+nCEpjapP8SFZ3UqEqmCaNzhY0mXViaQryv7OC9gwAWyJq1cDFw1e6J+L9nRI347OdP/E3CGJkDfAvGPBmUaehPuwBpVDGkFvWimvH+uixOO4qs0UVpZtynRyOH/K+bHUxn9lydrLSiSstPy6zS9DFzbPhI5k6NcA3L/fugyT+U+tiC/j7tSwfmXBSu4AsMUuzEPRatUccUTmjLhL9RFVoajP+ffNCn17pnDlEmHpl8GDqPU9ndgV6PbAtpMKsicLyXdmiz8fTM0xNjtdBmEiCCqICdhW12Pvy9X6kh15/ezBbavgKyuzPofIU17Cqj+YO4Nl+Me4Fzt7qeAtmj4cGIzcZSzE8FQL7OOSV//Eu/isx6uYMSiP/M4v1SLffl055G1JgK6r+E1sGB0wRktHtrsASwDWT2JP3SD6V6Y04adrCGoyw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(66446008)(66946007)(64756008)(76116006)(66556008)(55016002)(66476007)(71200400001)(9686003)(5660300002)(8936002)(8676002)(316002)(4326008)(38100700001)(110136005)(54906003)(7696005)(478600001)(52536014)(7416002)(6506007)(10290500003)(2906002)(26005)(86362001)(186003)(8990500004)(30864003)(33656002)(82960400001)(83380400001)(82950400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?PcNZRcNmLe1Q8UoFCrfHuzGNJmS6eVjlXZmDAUDzrI++VJJp2OVhrDn1e3Kb?=
 =?us-ascii?Q?EyO9omem6aGX+JWVKBtt+sGTNxCcRqCcgGF7KaohjglxqLhTjIZXnpgrtBKE?=
 =?us-ascii?Q?IAeps/6W3LTHsGtnrFYd5XQi5XxKcgp45nUQIJxbFnLgzRNJwkQfRP67LN+2?=
 =?us-ascii?Q?40mrwrc5ItHWespOdvqSrtmCO04rB1AzmSyBRvVGeFZty83mD1oB+WX4g88e?=
 =?us-ascii?Q?Vgo7GbzDnhSZjCNvuzztBkdAYb9GS+grTTPDYeeR+Ww8srqG5QRTq+N77Fhu?=
 =?us-ascii?Q?BQuoq8tU1JT/mynwxrQ5xZCen1y/ZaLR/EeiBOWotLiRjEl4ZEbLEhbYtqKU?=
 =?us-ascii?Q?5DnSSjK2UEehztrpG2LOoi2NAjVuoND0G/1/itJh4yjDH6ZDos6S3Sj+DEy6?=
 =?us-ascii?Q?ih6fJk27c2vkdGSewshMrbVQ6udP6TGELdnJwef7xse7gOJXCOMQTGbGNplk?=
 =?us-ascii?Q?U7dPsYNuyZ8yL9eJWHnSOhu/xxkgpAF/0GTyNr39VVjSCCMo20+8SCJSO9XR?=
 =?us-ascii?Q?erKqoGFen8BYPMcRfNzejeC18hjOWKUjLIBEE/DPD6eSS+Sh5xkEQGXCacxI?=
 =?us-ascii?Q?z5gK80cf8JEhVe1G+nCCt8cGkYjmEmX2HVJFI14CB6W90/uNFfaRRUNgXLIt?=
 =?us-ascii?Q?fUIEs+2cXAONyp4v/jxiPg8SBPfSORALjQiA/QcrkIV2Lmy+JO+nnbFSBVJP?=
 =?us-ascii?Q?oqnblwpUyc5aqu6lAzctQO7xOUFH8sxh+eJ4k3lxFUHSZ0PpiKLpT5klpK5Y?=
 =?us-ascii?Q?qAuXLPX205jXMj77uzsZBlpMeIxQ0W2C6F3WbnCHWFf5YLN107lAr6j4rUu5?=
 =?us-ascii?Q?VYsQrDU9rDDKLDw1rsm0JRZJB44Rz29YKv10xYm4ZkEZ/uECydvUbV9saTUY?=
 =?us-ascii?Q?Pb6WLqdYmsYOoD9Fvsb2Imbmq64NLefGYnxu85ujp8exxzs5VSL/YzdP/KP2?=
 =?us-ascii?Q?30fbtL4Z/lPJC6ktK3xe47znSbjcpP5/cgkpuBUaY2qRntt6iuq62zezjVEL?=
 =?us-ascii?Q?JcrjW6gMZ8eF1bBLxmH4e6ndCLvWaEAt/KEhtXF/DqPR0Et1sxt1M2fpWQbU?=
 =?us-ascii?Q?WeyB5tOSi35K3G3DPKTGxJ53EnIHKIiAHhp4syhrqK+RPP8VgyRnqLcnZBRK?=
 =?us-ascii?Q?BzFRBypQg7J0Yo2h3hS6ISMrZd4vv/Q2V/GQasGgih+Rrei8ZYCm0pYtq68w?=
 =?us-ascii?Q?8gghVhXrmyigvMSD017KJAarKahxvyTZCRRCY8L1BpNykknrPwu4bKmQblru?=
 =?us-ascii?Q?rqFvzEMdEzXvn/dKgcUVW6R9qqYctAtDRI718iMFWmQcjyD+jMTJDJmTIziC?=
 =?us-ascii?Q?dGZJS6Bdvy91e+Z//e5OZR74?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26f586da-dbe4-4f29-66c9-08d8fb6efe9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 15:49:00.8044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZYQLxH2fGru/ZnOJH2kl2dLDU/Ntei39KgkHA50+mksznZbHhVd3L79e+hYKhyFBnAtLzZHvM5kfL6Av4wigwxhoyuFKGJMjoVHRUsuwHZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1922
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Thursday, Apr=
il 8, 2021 9:15 AM
>=20
> Pointers to ring-buffer packets sent by Hyper-V are used within the
> guest VM. Hyper-V can send packets with erroneous values or modify
> packet fields after they are processed by the guest. To defend
> against these scenarios, return a copy of the incoming VMBus packet
> after validating its length and offset fields in hv_pkt_iter_first().
> In this way, the packet can no longer be modified by the host.

Andrea -- has anything changed in this version of this patch, except
the value of NETVSC_MAX_XFER_PAGE_RANGES?  It used to be a
fixed 375, but now is NVSP_RSC_MAX, which is 562.

If that's the only change, then

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

>=20
> Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
> Co-developed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> ---
>  drivers/hv/channel.c              |  9 ++--
>  drivers/hv/hv_fcopy.c             |  1 +
>  drivers/hv/hv_kvp.c               |  1 +
>  drivers/hv/hyperv_vmbus.h         |  2 +-
>  drivers/hv/ring_buffer.c          | 82 ++++++++++++++++++++++++++-----
>  drivers/net/hyperv/hyperv_net.h   |  7 +++
>  drivers/net/hyperv/netvsc.c       |  2 +
>  drivers/net/hyperv/rndis_filter.c |  2 +
>  drivers/scsi/storvsc_drv.c        | 10 ++++
>  include/linux/hyperv.h            | 48 +++++++++++++++---
>  net/vmw_vsock/hyperv_transport.c  |  4 +-
>  11 files changed, 143 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index db30be8f9ccea..b665db21e120d 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -597,12 +597,15 @@ static int __vmbus_open(struct vmbus_channel *newch=
annel,
>  	newchannel->onchannel_callback =3D onchannelcallback;
>  	newchannel->channel_callback_context =3D context;
>=20
> -	err =3D hv_ringbuffer_init(&newchannel->outbound, page, send_pages);
> +	if (!newchannel->max_pkt_size)
> +		newchannel->max_pkt_size =3D VMBUS_DEFAULT_MAX_PKT_SIZE;
> +
> +	err =3D hv_ringbuffer_init(&newchannel->outbound, page, send_pages, 0);
>  	if (err)
>  		goto error_clean_ring;
>=20
> -	err =3D hv_ringbuffer_init(&newchannel->inbound,
> -				 &page[send_pages], recv_pages);
> +	err =3D hv_ringbuffer_init(&newchannel->inbound, &page[send_pages],
> +				 recv_pages, newchannel->max_pkt_size);
>  	if (err)
>  		goto error_clean_ring;
>=20
> diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
> index 59ce85e00a028..660036da74495 100644
> --- a/drivers/hv/hv_fcopy.c
> +++ b/drivers/hv/hv_fcopy.c
> @@ -349,6 +349,7 @@ int hv_fcopy_init(struct hv_util_service *srv)
>  {
>  	recv_buffer =3D srv->recv_buffer;
>  	fcopy_transaction.recv_channel =3D srv->channel;
> +	fcopy_transaction.recv_channel->max_pkt_size =3D HV_HYP_PAGE_SIZE * 2;
>=20
>  	/*
>  	 * When this driver loads, the user level daemon that
> diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
> index b49962d312cef..c698592b83e42 100644
> --- a/drivers/hv/hv_kvp.c
> +++ b/drivers/hv/hv_kvp.c
> @@ -757,6 +757,7 @@ hv_kvp_init(struct hv_util_service *srv)
>  {
>  	recv_buffer =3D srv->recv_buffer;
>  	kvp_transaction.recv_channel =3D srv->channel;
> +	kvp_transaction.recv_channel->max_pkt_size =3D HV_HYP_PAGE_SIZE * 4;
>=20
>  	/*
>  	 * When this driver loads, the user level daemon that
> diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> index 9416e09ebd58c..42f3d9d123a12 100644
> --- a/drivers/hv/hyperv_vmbus.h
> +++ b/drivers/hv/hyperv_vmbus.h
> @@ -174,7 +174,7 @@ extern int hv_synic_cleanup(unsigned int cpu);
>  void hv_ringbuffer_pre_init(struct vmbus_channel *channel);
>=20
>  int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
> -		       struct page *pages, u32 pagecnt);
> +		       struct page *pages, u32 pagecnt, u32 max_pkt_size);
>=20
>  void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
>=20
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index ecd82ebfd5bc4..848f3bba83f8b 100644
> --- a/drivers/hv/ring_buffer.c
> +++ b/drivers/hv/ring_buffer.c
> @@ -190,7 +190,7 @@ void hv_ringbuffer_pre_init(struct vmbus_channel *cha=
nnel)
>=20
>  /* Initialize the ring buffer. */
>  int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
> -		       struct page *pages, u32 page_cnt)
> +		       struct page *pages, u32 page_cnt, u32 max_pkt_size)
>  {
>  	int i;
>  	struct page **pages_wraparound;
> @@ -232,6 +232,14 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *r=
ing_info,
>  		sizeof(struct hv_ring_buffer);
>  	ring_info->priv_read_index =3D 0;
>=20
> +	/* Initialize buffer that holds copies of incoming packets */
> +	if (max_pkt_size) {
> +		ring_info->pkt_buffer =3D kzalloc(max_pkt_size, GFP_KERNEL);
> +		if (!ring_info->pkt_buffer)
> +			return -ENOMEM;
> +		ring_info->pkt_buffer_size =3D max_pkt_size;
> +	}
> +
>  	spin_lock_init(&ring_info->ring_lock);
>=20
>  	return 0;
> @@ -244,6 +252,9 @@ void hv_ringbuffer_cleanup(struct hv_ring_buffer_info=
 *ring_info)
>  	vunmap(ring_info->ring_buffer);
>  	ring_info->ring_buffer =3D NULL;
>  	mutex_unlock(&ring_info->ring_buffer_mutex);
> +
> +	kfree(ring_info->pkt_buffer);
> +	ring_info->pkt_buffer_size =3D 0;
>  }
>=20
>  /* Write to the ring buffer. */
> @@ -384,7 +395,7 @@ int hv_ringbuffer_read(struct vmbus_channel *channel,
>  	memcpy(buffer, (const char *)desc + offset, packetlen);
>=20
>  	/* Advance ring index to next packet descriptor */
> -	__hv_pkt_iter_next(channel, desc);
> +	__hv_pkt_iter_next(channel, desc, true);
>=20
>  	/* Notify host of update */
>  	hv_pkt_iter_close(channel);
> @@ -410,6 +421,22 @@ static u32 hv_pkt_iter_avail(const struct hv_ring_bu=
ffer_info *rbi)
>  		return (rbi->ring_datasize - priv_read_loc) + write_loc;
>  }
>=20
> +/*
> + * Get first vmbus packet without copying it out of the ring buffer
> + */
> +struct vmpacket_descriptor *hv_pkt_iter_first_raw(struct vmbus_channel *=
channel)
> +{
> +	struct hv_ring_buffer_info *rbi =3D &channel->inbound;
> +
> +	hv_debug_delay_test(channel, MESSAGE_DELAY);
> +
> +	if (hv_pkt_iter_avail(rbi) < sizeof(struct vmpacket_descriptor))
> +		return NULL;
> +
> +	return (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi-
> >priv_read_index);
> +}
> +EXPORT_SYMBOL_GPL(hv_pkt_iter_first_raw);
> +
>  /*
>   * Get first vmbus packet from ring buffer after read_index
>   *
> @@ -418,17 +445,49 @@ static u32 hv_pkt_iter_avail(const struct hv_ring_b=
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
> +	bytes_avail =3D min(rbi->pkt_buffer_size, hv_pkt_iter_avail(rbi));
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
> @@ -440,7 +499,8 @@ EXPORT_SYMBOL_GPL(hv_pkt_iter_first);
>   */
>  struct vmpacket_descriptor *
>  __hv_pkt_iter_next(struct vmbus_channel *channel,
> -		   const struct vmpacket_descriptor *desc)
> +		   const struct vmpacket_descriptor *desc,
> +		   bool copy)
>  {
>  	struct hv_ring_buffer_info *rbi =3D &channel->inbound;
>  	u32 packetlen =3D desc->len8 << 3;
> @@ -453,7 +513,7 @@ __hv_pkt_iter_next(struct vmbus_channel *channel,
>  		rbi->priv_read_index -=3D dsize;
>=20
>  	/* more data? */
> -	return hv_pkt_iter_first(channel);
> +	return copy ? hv_pkt_iter_first(channel) : hv_pkt_iter_first_raw(channe=
l);
>  }
>  EXPORT_SYMBOL_GPL(__hv_pkt_iter_next);
>=20
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_=
net.h
> index e1a497d3c9ba4..154539b2f75ba 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -895,9 +895,16 @@ static inline u32 netvsc_rqstor_size(unsigned long r=
ingbytes)
>  		ringbytes / NETVSC_MIN_IN_MSG_SIZE;
>  }
>=20
> +/* XFER PAGE packets can specify a maximum of 375 ranges for NDIS >=3D 6=
.0
> + * and a maximum of 64 ranges for NDIS < 6.0 with no RSC; with RSC, this
> + * limit is raised to 562 (=3D NVSP_RSC_MAX).
> + */
> +#define NETVSC_MAX_XFER_PAGE_RANGES NVSP_RSC_MAX
>  #define NETVSC_XFER_HEADER_SIZE(rng_cnt) \
>  		(offsetof(struct vmtransfer_page_packet_header, ranges) + \
>  		(rng_cnt) * sizeof(struct vmtransfer_page_range))
> +#define NETVSC_MAX_PKT_SIZE
> (NETVSC_XFER_HEADER_SIZE(NETVSC_MAX_XFER_PAGE_RANGES) + \
> +		sizeof(struct nvsp_message) + (sizeof(u32) * VRSS_SEND_TAB_SIZE))
>=20
>  struct multi_send_data {
>  	struct sk_buff *skb; /* skb containing the pkt */
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index c64cc7639c39c..d17ff04986f52 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -1603,6 +1603,8 @@ struct netvsc_device *netvsc_device_add(struct hv_d=
evice
> *device,
>=20
>  	/* Open the channel */
>  	device->channel->rqstor_size =3D netvsc_rqstor_size(netvsc_ring_bytes);
> +	device->channel->max_pkt_size =3D NETVSC_MAX_PKT_SIZE;
> +
>  	ret =3D vmbus_open(device->channel, netvsc_ring_bytes,
>  			 netvsc_ring_bytes,  NULL, 0,
>  			 netvsc_channel_cb, net_device->chan_table);
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis=
_filter.c
> index 123cc9d25f5ed..6508c4724c224 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -1260,6 +1260,8 @@ static void netvsc_sc_open(struct vmbus_channel *ne=
w_sc)
>  	nvchan->channel =3D new_sc;
>=20
>  	new_sc->rqstor_size =3D netvsc_rqstor_size(netvsc_ring_bytes);
> +	new_sc->max_pkt_size =3D NETVSC_MAX_PKT_SIZE;
> +
>  	ret =3D vmbus_open(new_sc, netvsc_ring_bytes,
>  			 netvsc_ring_bytes, NULL, 0,
>  			 netvsc_channel_cb, nvchan);
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 6bc5453cea8a7..bfbaebded8025 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -402,6 +402,14 @@ static void storvsc_on_channel_callback(void *contex=
t);
>  #define STORVSC_IDE_MAX_TARGETS				1
>  #define STORVSC_IDE_MAX_CHANNELS			1
>=20
> +/*
> + * Upper bound on the size of a storvsc packet. vmscsi_size_delta is not
> + * included in the calculation because it is set after STORVSC_MAX_PKT_S=
IZE
> + * is used in storvsc_connect_to_vsp
> + */
> +#define STORVSC_MAX_PKT_SIZE (sizeof(struct vmpacket_descriptor) +\
> +			      sizeof(struct vstor_packet))
> +
>  struct storvsc_cmd_request {
>  	struct scsi_cmnd *cmd;
>=20
> @@ -697,6 +705,7 @@ static void handle_sc_creation(struct vmbus_channel *=
new_sc)
>  		return;
>=20
>  	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
> +	new_sc->max_pkt_size =3D STORVSC_MAX_PKT_SIZE;
>=20
>  	/*
>  	 * The size of vmbus_requestor is an upper bound on the number of reque=
sts
> @@ -1290,6 +1299,7 @@ static int storvsc_connect_to_vsp(struct hv_device =
*device, u32
> ring_size,
>=20
>  	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
>=20
> +	device->channel->max_pkt_size =3D STORVSC_MAX_PKT_SIZE;
>  	/*
>  	 * The size of vmbus_requestor is an upper bound on the number of reque=
sts
>  	 * that can be in-progress at any one time across all channels.
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 2c18c8e768efe..7387bb41f6a37 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -181,6 +181,10 @@ struct hv_ring_buffer_info {
>  	 * being freed while the ring buffer is being accessed.
>  	 */
>  	struct mutex ring_buffer_mutex;
> +
> +	/* Buffer that holds a copy of an incoming host packet */
> +	void *pkt_buffer;
> +	u32 pkt_buffer_size;
>  };
>=20
>=20
> @@ -788,6 +792,8 @@ struct vmbus_device {
>  	bool allowed_in_isolated;
>  };
>=20
> +#define VMBUS_DEFAULT_MAX_PKT_SIZE 4096
> +
>  struct vmbus_channel {
>  	struct list_head listentry;
>=20
> @@ -1010,6 +1016,9 @@ struct vmbus_channel {
>  	/* request/transaction ids for VMBus */
>  	struct vmbus_requestor requestor;
>  	u32 rqstor_size;
> +
> +	/* The max size of a packet on this channel */
> +	u32 max_pkt_size;
>  };
>=20
>  u64 vmbus_next_request_id(struct vmbus_requestor *rqstor, u64 rqst_addr)=
;
> @@ -1651,32 +1660,55 @@ static inline u32 hv_pkt_datalen(const struct
> vmpacket_descriptor *desc)
>  }
>=20
>=20
> +struct vmpacket_descriptor *
> +hv_pkt_iter_first_raw(struct vmbus_channel *channel);
> +
>  struct vmpacket_descriptor *
>  hv_pkt_iter_first(struct vmbus_channel *channel);
>=20
>  struct vmpacket_descriptor *
>  __hv_pkt_iter_next(struct vmbus_channel *channel,
> -		   const struct vmpacket_descriptor *pkt);
> +		   const struct vmpacket_descriptor *pkt,
> +		   bool copy);
>=20
>  void hv_pkt_iter_close(struct vmbus_channel *channel);
>=20
> -/*
> - * Get next packet descriptor from iterator
> - * If at end of list, return NULL and update host.
> - */
>  static inline struct vmpacket_descriptor *
> -hv_pkt_iter_next(struct vmbus_channel *channel,
> -		 const struct vmpacket_descriptor *pkt)
> +hv_pkt_iter_next_pkt(struct vmbus_channel *channel,
> +		     const struct vmpacket_descriptor *pkt,
> +		     bool copy)
>  {
>  	struct vmpacket_descriptor *nxt;
>=20
> -	nxt =3D __hv_pkt_iter_next(channel, pkt);
> +	nxt =3D __hv_pkt_iter_next(channel, pkt, copy);
>  	if (!nxt)
>  		hv_pkt_iter_close(channel);
>=20
>  	return nxt;
>  }
>=20
> +/*
> + * Get next packet descriptor without copying it out of the ring buffer
> + * If at end of list, return NULL and update host.
> + */
> +static inline struct vmpacket_descriptor *
> +hv_pkt_iter_next_raw(struct vmbus_channel *channel,
> +		     const struct vmpacket_descriptor *pkt)
> +{
> +	return hv_pkt_iter_next_pkt(channel, pkt, false);
> +}
> +
> +/*
> + * Get next packet descriptor from iterator
> + * If at end of list, return NULL and update host.
> + */
> +static inline struct vmpacket_descriptor *
> +hv_pkt_iter_next(struct vmbus_channel *channel,
> +		 const struct vmpacket_descriptor *pkt)
> +{
> +	return hv_pkt_iter_next_pkt(channel, pkt, true);
> +}
> +
>  #define foreach_vmbus_pkt(pkt, channel) \
>  	for (pkt =3D hv_pkt_iter_first(channel); pkt; \
>  	    pkt =3D hv_pkt_iter_next(channel, pkt))
> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_tran=
sport.c
> index cc3bae2659e79..19189cf30a72f 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -596,7 +596,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *=
vsk, struct
> msghdr *msg,
>  		return -EOPNOTSUPP;
>=20
>  	if (need_refill) {
> -		hvs->recv_desc =3D hv_pkt_iter_first(hvs->chan);
> +		hvs->recv_desc =3D hv_pkt_iter_first_raw(hvs->chan);
>  		ret =3D hvs_update_recv_data(hvs);
>  		if (ret)
>  			return ret;
> @@ -610,7 +610,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *=
vsk, struct
> msghdr *msg,
>=20
>  	hvs->recv_data_len -=3D to_read;
>  	if (hvs->recv_data_len =3D=3D 0) {
> -		hvs->recv_desc =3D hv_pkt_iter_next(hvs->chan, hvs->recv_desc);
> +		hvs->recv_desc =3D hv_pkt_iter_next_raw(hvs->chan, hvs->recv_desc);
>  		if (hvs->recv_desc) {
>  			ret =3D hvs_update_recv_data(hvs);
>  			if (ret)
> --
> 2.25.1

