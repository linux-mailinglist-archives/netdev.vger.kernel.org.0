Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52FA35A21F
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhDIPib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:38:31 -0400
Received: from mail-dm6nam12on2138.outbound.protection.outlook.com ([40.107.243.138]:56001
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229665AbhDIPia (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 11:38:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUGYJbv6leIqtJ2o8DeP+V+fp+Cm3D3J8ispPYYVtSOYNwEh/isC9HEytrSNtsGp6QEzH46hSB3K6lN7YlwfDBAmevbHR1uav0mhRYPXxwAxnEfnFVNg0Lw6aLhCVG/u7as41iz7QidYcqb5kqVmoF9An9f+AiSpexOWP8sgO84C0nGJjEs04hNxj0HhuRvdq78xOzKO/W3DslaKw3wLsA4MfwJYmLEpO+fEQAA+KTJtFzCdoAm7C5w0p3hBA1TZau16iT+RHpvBTJuARQRq+Xw/EuIF4t25G195Gp9c2xDlZmf9rnaiPvlhGvP8dEQHrkR26n2ZcLr/BR1shQx8hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQYsCKS6J/995lYm6yfCkevYDtpiyl92GL8gya9xnvg=;
 b=nQCncQoPabgWIjFUIyitXjzS7G6O4+8u1RN6muD8+US34hkIvhZToybmFsQJwJZQEFMC0qG6m5jqy1oIt4QPqkpYLQaJOJwZ8OyGgEn+EGkFqj2FGROAp2WtEcYZqQ7L8ah/LlsHHMMP1bfnrrFEZKYEZWGGX9SyfgPbl9ZcNHyfKVq3IidXVPHb+2AFzhjmn4awn9F6c6JHb/jPK1kufOfot9F9OwA/9ah5OYmTF9Kmim85PxytMHqhXXwKXe52oMvP9gOpASv0wSlAr/ObtG39RNHLXbRwxnXf5LJfra5LZvTJXHeanNh9yn7CG6jSrJueielFad4JAVBs9yOPMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQYsCKS6J/995lYm6yfCkevYDtpiyl92GL8gya9xnvg=;
 b=CSvFO+jMfU8Sr3QAVEbeOlAXlwHIbw1WvRwOJrzjU46LOyHhpjd8zk8gRvwZC2ZdI+cmVcZJHFQ3aXXL6wAE1G96VzgKFgRWMSQRmoFr1wYVdsKN9o118jEv5gAjfqr+lZqLxBd2VFycqjxuE5s2Qop1CDNDQ1CTQbLTVgFXWn0=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0288.namprd21.prod.outlook.com (2603:10b6:300:7a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Fri, 9 Apr
 2021 15:38:14 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3808:777c:8b25:c88d]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3808:777c:8b25:c88d%5]) with mapi id 15.20.4042.010; Fri, 9 Apr 2021
 15:38:14 +0000
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
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [RFC PATCH hyperv-next] scsi: storvsc: Use blk_mq_unique_tag() to
 generate requestIDs
Thread-Topic: [RFC PATCH hyperv-next] scsi: storvsc: Use blk_mq_unique_tag()
 to generate requestIDs
Thread-Index: AQHXLJInjsu44/p3MUKBv7H3jmwHRaqsSuaw
Date:   Fri, 9 Apr 2021 15:38:14 +0000
Message-ID: <MWHPR21MB15934EAD302E27983E891CF2D7739@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210408161315.341888-1-parri.andrea@gmail.com>
In-Reply-To: <20210408161315.341888-1-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=fa8955af-3697-46d3-87c3-28e210b2e0b7;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-09T15:07:13Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 945c1992-bcba-40f8-131b-08d8fb6d7d48
x-ms-traffictypediagnostic: MWHPR21MB0288:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB0288B0C572C843E0991563DFD7739@MWHPR21MB0288.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fd0XjDN6ZW5+cxBQn9b72tAaNEHxzQtYi+CrOm9yYNDWmG52pAt/nfw1/AUceX17kuADnFlXcnVYInovS/KuFW7IWQxw+qYPRcgKEqVFMrv0MtD8DV1qmnya/LZ8CXzBl9TWm+vx90p6fCUOqe8XkvHM/lY6qlGV+/kgUl5nkD7tM74PUX1DxTAR1iBvWDOmy8Orr4TaElJe04y2nReR5znT0bQkKiUnNV92ZbtMltT+bSYDq/2Yne7itL+TcvXnEAsVOqkRwVxuQOFC/XaP6tc/4YyXnhgeTGrnU85zs1jriLQU1chrf1eliMYRQgrWE3C9kVBtR7hBMVtbbVAsR2wzuFGYavkGsxtEInPt5rCBofZb9nNMurnNGz4lv45bnbc48+i24kaw+XvaMllLeSrE5b67NNn0thOrD7EeF3ICB7ABJpimRW7SPBpyM7i+flgLUPEKYDz2BvpGRGVHk8SG3EAmQVm/OzJdiZ0yIl8JsEcOVKFCKXgFWdL1ILljgKlveI4ZO6U9wYZJ2UbtGiR8alU5ROaTyagt9lqdlKptGuMPX5vF39z7Zq7YTz7BqA8yinLKrb2Pb7w2GZGDoqEbZRdZExyGgygD/fDhtPFEksTDoYeUYh8oenODsh7DEJWEFoDWn5UzP2jB+/9MrZnN1qMtm/fi18hjs83A3eg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(55016002)(38100700001)(9686003)(64756008)(71200400001)(7416002)(30864003)(86362001)(6506007)(83380400001)(10290500003)(4326008)(82960400001)(33656002)(316002)(5660300002)(7696005)(8990500004)(186003)(26005)(8936002)(76116006)(52536014)(54906003)(66556008)(2906002)(478600001)(66446008)(66946007)(8676002)(110136005)(66476007)(82950400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?r0CPxXP8sqK1yzPmrF8c/5FIim8Xr4d/OtKaiE08KnHeg2xlpw2NO4nhOUpm?=
 =?us-ascii?Q?2e/XulhU+9YkIXIPPL3HK2lN+xOeXGjCh8+KqcLT5xWSUrcDIWjp92kvq28V?=
 =?us-ascii?Q?uv6x9BPvnnLjaYiFuA+E4XcekhiuFdtzR4BdVPx918xaO4MfK9H1xAhjxPhg?=
 =?us-ascii?Q?BC5oTEi5r97txiUXJmVaw7KtfBOL0wl5AXdrOI1J31d/jYhLG3s0HBTVoo5P?=
 =?us-ascii?Q?wfTFcx9R+WczhuvJa97Gj6AjVhyGwLZLrOfi2k7RcBV6rLKhhakh52+Kxo+y?=
 =?us-ascii?Q?aikJG53TGhsNmy35jFNm4H12hY4WdRSz/hrujjtQdz0jYrrz65Tbp8eyYE68?=
 =?us-ascii?Q?TLEFT63z++W7kixb6oVsxYdRtEkOIendwcw1bshIJHE7zh91MlAmxpAZ4E8k?=
 =?us-ascii?Q?jAOqYC71PNq+oJvSj+eRy1KNO9xuHU0/hOtbjC1oOZns11+zhk/drsykp1VZ?=
 =?us-ascii?Q?1DhStA9cDJSWZooreLpwhEUspbP8fnG7g1IfK9gjdbAczs+Z30UISicCAPIE?=
 =?us-ascii?Q?UX6mWyynZb/EAJ1jqj3Vb4pKiwS9yIMuo1TLyG2WsFWN6IIYfYBjARR9IyX4?=
 =?us-ascii?Q?W4TrNS18vL1R3fYI9YwmXXvhN5HOi/No1pZ0A0OPEIVNZOdt8TLyBPq7BcoJ?=
 =?us-ascii?Q?WliNWAkGen/KNm7Kr6lveRpy0gJXnjREzHjVBAoEEoMJqYQYLbaUCQC7RV4J?=
 =?us-ascii?Q?b0CSOp9ldgagMWxGQ+YPaw7lKSl6aLTtgtICO80wLGaHxt/vbtQbimgpN4mK?=
 =?us-ascii?Q?918vmMzNwBUfyawsbVhyDysm1+YoxAqa/Cvw8e3VD93NqPdyz8a1/zRV48Kl?=
 =?us-ascii?Q?8+oSb5mVwM/e7wWsYUspV5X1E0rCCSb3ViVrsUOsf8vcoOn54gEo8VwtdE/m?=
 =?us-ascii?Q?yGZG1ScgCuXrf4jovfLIscoGzEnvMssBg6WjZCUm/+1XmhbPrZWaCb3e0L0X?=
 =?us-ascii?Q?Wxfj1TrSuY8gCUStF5LbLpRBYOOk8yXzDJjXR1JkwE9VprIjkg2huT5balq2?=
 =?us-ascii?Q?J/L8uurAgs5I90BqHwU70lVS6ljO/ghxuGF187hAwWaJvRWDF9PWLtJ+4knm?=
 =?us-ascii?Q?ohoF7Vzb/5fSfNIyWzCB5KHQTIFWks6GSKQzBNuQiGMUwqcF/oJYMQnc4Jtf?=
 =?us-ascii?Q?5rrxbBlXHgtfGWm8dKkTF/ni/O+5lYgpKqTLE+pqsVD+prgyozTuS3Z8Mu2q?=
 =?us-ascii?Q?NYIrbxvIsCnEJgo54VIY5RCMcdgSEX+Cs3zN5Wb7TOYo9dzoO8FqyfPIsan4?=
 =?us-ascii?Q?xwj/9W6G53Ru6mzFMzxcnWctv80zfXCv3EfcNmfDy4Xq+p/AbY8V/p4ycqeu?=
 =?us-ascii?Q?b/bjOzVfPzGWG/aJxP0WTY4O?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 945c1992-bcba-40f8-131b-08d8fb6d7d48
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 15:38:14.3468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tdpj46rtErtBy4AQjvLhhvCejsAIceAeTufk0ujof6cYsSIrqDyOdof/0+5+IjOdGb15AV+a62ivebWF+CUZN0u3cvM5IxT8190rbGjn6Wg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0288
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Thursday, Apr=
il 8, 2021 9:13 AM
>=20
> Use blk_mq_unique_tag() to generate requestIDs for StorVSC, avoiding
> all issues with allocating enough entries in the VMbus requestor.

This looks good to me!  I'm glad to see that the idea worked without
too much complexity.

See a few comments inline below.

>=20
> Suggested-by: Michael Kelley <mikelley@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> ---
>  drivers/hv/channel.c              | 14 +++---
>  drivers/hv/ring_buffer.c          | 12 ++---
>  drivers/net/hyperv/netvsc.c       |  8 ++--
>  drivers/net/hyperv/rndis_filter.c |  2 +
>  drivers/scsi/storvsc_drv.c        | 73 ++++++++++++++++++++++++++-----
>  include/linux/hyperv.h            | 13 +++++-
>  6 files changed, 92 insertions(+), 30 deletions(-)
>=20
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index db30be8f9ccea..f78e02ace51e8 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -1121,15 +1121,14 @@ EXPORT_SYMBOL_GPL(vmbus_recvpacket_raw);
>   * vmbus_next_request_id - Returns a new request id. It is also
>   * the index at which the guest memory address is stored.
>   * Uses a spin lock to avoid race conditions.
> - * @rqstor: Pointer to the requestor struct
> + * @channel: Pointer to the VMbus channel struct
>   * @rqst_add: Guest memory address to be stored in the array
>   */
> -u64 vmbus_next_request_id(struct vmbus_requestor *rqstor, u64 rqst_addr)
> +u64 vmbus_next_request_id(struct vmbus_channel *channel, u64 rqst_addr)
>  {
> +	struct vmbus_requestor *rqstor =3D &channel->requestor;
>  	unsigned long flags;
>  	u64 current_id;
> -	const struct vmbus_channel *channel =3D
> -		container_of(rqstor, const struct vmbus_channel, requestor);
>=20
>  	/* Check rqstor has been initialized */
>  	if (!channel->rqstor_size)
> @@ -1163,16 +1162,15 @@ EXPORT_SYMBOL_GPL(vmbus_next_request_id);
>  /*
>   * vmbus_request_addr - Returns the memory address stored at @trans_id
>   * in @rqstor. Uses a spin lock to avoid race conditions.
> - * @rqstor: Pointer to the requestor struct
> + * @channel: Pointer to the VMbus channel struct
>   * @trans_id: Request id sent back from Hyper-V. Becomes the requestor's
>   * next request id.
>   */
> -u64 vmbus_request_addr(struct vmbus_requestor *rqstor, u64 trans_id)
> +u64 vmbus_request_addr(struct vmbus_channel *channel, u64 trans_id)
>  {
> +	struct vmbus_requestor *rqstor =3D &channel->requestor;
>  	unsigned long flags;
>  	u64 req_addr;
> -	const struct vmbus_channel *channel =3D
> -		container_of(rqstor, const struct vmbus_channel, requestor);
>=20
>  	/* Check rqstor has been initialized */
>  	if (!channel->rqstor_size)
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index ecd82ebfd5bc4..46d8e038e4ee1 100644
> --- a/drivers/hv/ring_buffer.c
> +++ b/drivers/hv/ring_buffer.c
> @@ -310,10 +310,12 @@ int hv_ringbuffer_write(struct vmbus_channel *chann=
el,
>  	 */
>=20
>  	if (desc->flags =3D=3D VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED) {
> -		rqst_id =3D vmbus_next_request_id(&channel->requestor, requestid);
> -		if (rqst_id =3D=3D VMBUS_RQST_ERROR) {
> -			spin_unlock_irqrestore(&outring_info->ring_lock, flags);
> -			return -EAGAIN;
> +		if (channel->next_request_id_callback !=3D NULL) {
> +			rqst_id =3D channel->next_request_id_callback(channel, requestid);
> +			if (rqst_id =3D=3D VMBUS_RQST_ERROR) {
> +				spin_unlock_irqrestore(&outring_info->ring_lock, flags);
> +				return -EAGAIN;
> +			}
>  		}
>  	}
>  	desc =3D hv_get_ring_buffer(outring_info) + old_write;
> @@ -341,7 +343,7 @@ int hv_ringbuffer_write(struct vmbus_channel *channel=
,
>  	if (channel->rescind) {
>  		if (rqst_id !=3D VMBUS_NO_RQSTOR) {
>  			/* Reclaim request ID to avoid leak of IDs */
> -			vmbus_request_addr(&channel->requestor, rqst_id);
> +			channel->request_addr_callback(channel, rqst_id);
>  		}
>  		return -ENODEV;
>  	}
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index c64cc7639c39c..1a221ce2d6fdc 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -730,7 +730,7 @@ static void netvsc_send_tx_complete(struct net_device=
 *ndev,
>  	int queue_sends;
>  	u64 cmd_rqst;
>=20
> -	cmd_rqst =3D vmbus_request_addr(&channel->requestor, (u64)desc->trans_i=
d);
> +	cmd_rqst =3D channel->request_addr_callback(channel, (u64)desc->trans_i=
d);
>  	if (cmd_rqst =3D=3D VMBUS_RQST_ERROR) {
>  		netdev_err(ndev, "Incorrect transaction id\n");
>  		return;
> @@ -790,8 +790,8 @@ static void netvsc_send_completion(struct net_device =
*ndev,
>=20
>  	/* First check if this is a VMBUS completion without data payload */
>  	if (!msglen) {
> -		cmd_rqst =3D vmbus_request_addr(&incoming_channel->requestor,
> -					      (u64)desc->trans_id);
> +		cmd_rqst =3D incoming_channel->request_addr_callback(incoming_channel,
> +								   (u64)desc->trans_id);
>  		if (cmd_rqst =3D=3D VMBUS_RQST_ERROR) {
>  			netdev_err(ndev, "Invalid transaction id\n");
>  			return;
> @@ -1602,6 +1602,8 @@ struct netvsc_device *netvsc_device_add(struct hv_d=
evice
> *device,
>  		       netvsc_poll, NAPI_POLL_WEIGHT);
>=20
>  	/* Open the channel */
> +	device->channel->next_request_id_callback =3D vmbus_next_request_id;
> +	device->channel->request_addr_callback =3D vmbus_request_addr;
>  	device->channel->rqstor_size =3D netvsc_rqstor_size(netvsc_ring_bytes);
>  	ret =3D vmbus_open(device->channel, netvsc_ring_bytes,
>  			 netvsc_ring_bytes,  NULL, 0,
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis=
_filter.c
> index 123cc9d25f5ed..ebf34bf3f9075 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -1259,6 +1259,8 @@ static void netvsc_sc_open(struct vmbus_channel *ne=
w_sc)
>  	/* Set the channel before opening.*/
>  	nvchan->channel =3D new_sc;
>=20
> +	new_sc->next_request_id_callback =3D vmbus_next_request_id;
> +	new_sc->request_addr_callback =3D vmbus_request_addr;
>  	new_sc->rqstor_size =3D netvsc_rqstor_size(netvsc_ring_bytes);
>  	ret =3D vmbus_open(new_sc, netvsc_ring_bytes,
>  			 netvsc_ring_bytes, NULL, 0,
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 6bc5453cea8a7..1c05fabc06b04 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -684,6 +684,62 @@ static void storvsc_change_target_cpu(struct vmbus_c=
hannel
> *channel, u32 old,
>  	spin_unlock_irqrestore(&stor_device->lock, flags);
>  }
>=20
> +u64 storvsc_next_request_id(struct vmbus_channel *channel, u64 rqst_addr=
)
> +{
> +	struct storvsc_cmd_request *request =3D
> +		(struct storvsc_cmd_request *)(unsigned long)rqst_addr;
> +	struct storvsc_device *stor_device;
> +	struct hv_device *device;
> +
> +	device =3D (channel->primary_channel !=3D NULL) ?
> +		channel->primary_channel->device_obj : channel->device_obj;
> +	if (device =3D=3D NULL)
> +		return VMBUS_RQST_ERROR;
> +
> +	stor_device =3D get_out_stor_device(device);
> +	if (stor_device =3D=3D NULL)
> +		return VMBUS_RQST_ERROR;
> +
> +	if (request =3D=3D &stor_device->init_request)
> +		return VMBUS_RQST_INIT;
> +	if (request =3D=3D &stor_device->reset_request)
> +		return VMBUS_RQST_RESET;

Having to get the device and then the stor_device in order to detect the
init_request and reset_request special cases is unfortunate.  So here's
an idea:  The init_request and reset_request are used in a limited number
of specific places in the storvsc driver, and there are unique invocations
of vmbus_sendpacket() in those places.  So rather than pass the address
of the request as the requestID parameter to vmbus_sendpacket(), pass
the sentinel value VMBUS_RQST_INIT or VMBUS_RQST_RESET.  Then this
code can just detect those sentinel values as the rqst_addr input
parameter, and return them.

> +
> +	return blk_mq_unique_tag(request->cmd->request);
> +}
> +
> +u64 storvsc_request_addr(struct vmbus_channel *channel, u64 rqst_id)
> +{
> +	struct storvsc_cmd_request *request;
> +	struct storvsc_device *stor_device;
> +	struct hv_device *device;
> +	struct Scsi_Host *shost;
> +	struct scsi_cmnd *scmnd;
> +
> +	device =3D (channel->primary_channel !=3D NULL) ?
> +		channel->primary_channel->device_obj : channel->device_obj;
> +	if (device =3D=3D NULL)
> +		return VMBUS_RQST_ERROR;
> +
> +	stor_device =3D get_out_stor_device(device);
> +	if (stor_device =3D=3D NULL)
> +		return VMBUS_RQST_ERROR;
> +
> +	if (rqst_id =3D=3D VMBUS_RQST_INIT)
> +		return (unsigned long)&stor_device->init_request;
> +	if (rqst_id =3D=3D VMBUS_RQST_RESET)
> +		return (unsigned long)&stor_device->reset_request;

Unfortunately, the same simplification doesn't work here.  And you need
stor_device anyway to get the scsi_host.

> +
> +	shost =3D stor_device->host;
> +
> +	scmnd =3D scsi_host_find_tag(shost, rqst_id);
> +	if (scmnd =3D=3D NULL)
> +		return VMBUS_RQST_ERROR;
> +
> +	request =3D (struct storvsc_cmd_request *)(unsigned long)scsi_cmd_priv(=
scmnd);
> +	return (unsigned long)request;

The casts in the above two lines seem unnecessarily complex.  'request' is =
never
used as a pointer.  So couldn't the last two lines just be:

	return (unsigned long)scsi_cmd_priv(scmnd);

> +}
> +
>  static void handle_sc_creation(struct vmbus_channel *new_sc)
>  {
>  	struct hv_device *device =3D new_sc->primary_channel->device_obj;
> @@ -698,11 +754,8 @@ static void handle_sc_creation(struct vmbus_channel =
*new_sc)
>=20
>  	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
>=20
> -	/*
> -	 * The size of vmbus_requestor is an upper bound on the number of reque=
sts
> -	 * that can be in-progress at any one time across all channels.
> -	 */
> -	new_sc->rqstor_size =3D scsi_driver.can_queue;
> +	new_sc->next_request_id_callback =3D storvsc_next_request_id;
> +	new_sc->request_addr_callback =3D storvsc_request_addr;
>=20
>  	ret =3D vmbus_open(new_sc,
>  			 storvsc_ringbuffer_size,
> @@ -1255,8 +1308,7 @@ static void storvsc_on_channel_callback(void *conte=
xt)
>  		struct storvsc_cmd_request *request;
>  		u64 cmd_rqst;
>=20
> -		cmd_rqst =3D vmbus_request_addr(&channel->requestor,
> -					      desc->trans_id);
> +		cmd_rqst =3D channel->request_addr_callback(channel, desc->trans_id);

Here's another thought:  You don't really need to set the channel request_a=
ddr_callback
function and then indirect through it here.  You know the specific function=
 that storvsc
is using, so could call it directly.  The other reason to set request_addr_=
callback is so
that at the end of hv_ringbuffer_write() you can reclaim an allocated reque=
stID if the
rescind flag is set.  But there's nothing allocated that needs to be reclai=
med in the storvsc
case, so leaving request_addr_callback as NULL is OK (but hv_ringbuffer_wri=
te would
have to check for the NULL).

Then if you do that, the logic in storvsc_request_addr() can effectively go=
 inline in
here.  And that logic can take advantage of the fact that stor_device is al=
ready determined
outside the foreach_vmbus_pkt() loop.  The scsi_host could be calculated ou=
tside the loop
as well, leaving the detection of init_request and reset_request, and the c=
all to
scsi_host_find_tag() as the only things to do.

This approach is a bit asymmetrical, but it would save some processing in t=
his interrupt
handling code.   So something to consider.

>  		if (cmd_rqst =3D=3D VMBUS_RQST_ERROR) {
>  			dev_err(&device->device,
>  				"Incorrect transaction id\n");
> @@ -1290,11 +1342,8 @@ static int storvsc_connect_to_vsp(struct hv_device=
 *device, u32
> ring_size,
>=20
>  	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
>=20
> -	/*
> -	 * The size of vmbus_requestor is an upper bound on the number of reque=
sts
> -	 * that can be in-progress at any one time across all channels.
> -	 */
> -	device->channel->rqstor_size =3D scsi_driver.can_queue;
> +	device->channel->next_request_id_callback =3D storvsc_next_request_id;
> +	device->channel->request_addr_callback =3D storvsc_request_addr;
>=20
>  	ret =3D vmbus_open(device->channel,
>  			 ring_size,
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 2c18c8e768efe..5692ffa60e022 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -779,7 +779,11 @@ struct vmbus_requestor {
>=20
>  #define VMBUS_NO_RQSTOR U64_MAX
>  #define VMBUS_RQST_ERROR (U64_MAX - 1)
> +/* NetVSC-specific */

It is netvsc specific at the moment.  But if we harden other
drivers, they are likely to use the same generic requestID
allocator, and hence need the same sentinel value.

>  #define VMBUS_RQST_ID_NO_RESPONSE (U64_MAX - 2)
> +/* StorVSC-specific */
> +#define VMBUS_RQST_INIT (U64_MAX - 2)
> +#define VMBUS_RQST_RESET (U64_MAX - 3)
>=20
>  struct vmbus_device {
>  	u16  dev_type;
> @@ -1007,13 +1011,18 @@ struct vmbus_channel {
>  	u32 fuzz_testing_interrupt_delay;
>  	u32 fuzz_testing_message_delay;
>=20
> +	/* callback to generate a request ID from a request address */
> +	u64 (*next_request_id_callback)(struct vmbus_channel *channel, u64 rqst=
_addr);
> +	/* callback to retrieve a request address from a request ID */
> +	u64 (*request_addr_callback)(struct vmbus_channel *channel, u64 rqst_id=
);
> +
>  	/* request/transaction ids for VMBus */
>  	struct vmbus_requestor requestor;
>  	u32 rqstor_size;
>  };
>=20
> -u64 vmbus_next_request_id(struct vmbus_requestor *rqstor, u64 rqst_addr)=
;
> -u64 vmbus_request_addr(struct vmbus_requestor *rqstor, u64 trans_id);
> +u64 vmbus_next_request_id(struct vmbus_channel *channel, u64 rqst_addr);
> +u64 vmbus_request_addr(struct vmbus_channel *channel, u64 trans_id);
>=20
>  static inline bool is_hvsock_channel(const struct vmbus_channel *c)
>  {
> --
> 2.25.1

