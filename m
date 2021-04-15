Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48801360A6B
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 15:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbhDONW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 09:22:59 -0400
Received: from mail-bn7nam10on2090.outbound.protection.outlook.com ([40.107.92.90]:58690
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230056AbhDONW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 09:22:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epAY+ppdoGEl8HjO+IiolrwQAjNPuv0AZFEQb79aN/5JE1RqPvhJ/YPPhs2CCdUO01/WJHlEhb3/IrK2XdRP8GCJfQRDRQrec2VHpIIvRk+WsJddMsuWptUW7o3I8gjQ2k96CAqzLdxB3h/jA5GfxxIF6vE4eef8q4tTPlnPsj+ZIPjDA0W4/OKw+Fs48qslkOvdmiC3uejZD+k57XAWw/h2L7ZOhHQShtKAvxgvDbuNCNllgZ+y8VK+AHN9i59dgqxYYI4xUetkhcZtQ4DAYKcLXdmAbGuq9PosoEqtBu8ebf8agMtZ34fB9sSGldOMwxhlBbU4uP+ai1lcox2nKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AnX1ahyoiPJEPcLxArs2jRR30w75nKbkXAL3uSmMZGU=;
 b=NNwN0faVgzjsHyEs1gpiOmDLscMajpnnhVDTEgJ4XBkgj16s31ByH0kbi5YeGZ6xnB7oaQm/KGUGILXlQV/WpscZ2M6cAzYZmhKDv9JiWWF9+hJNCibLPLFMQNpdCZBnHn7rm70/1OwCsli6TNyB7TbPmr8+oBvBfZa/L9F1EcOSN+AaBiKqvRSUI7aTW7eD0HLFMOHmbvnONCRblv6Ai5N9K6QXjEmYGOXMTbepT4H+Iy8NSiqKmSW8Cl1XdPyNw0fNvh7+vbcp6WfSEjdMW1L1srCZfNQVQyHMB48dKCaR3Z/ekuY7GEdqThApAuPmLAMfuLvpA5fXZ7wHMa/PrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AnX1ahyoiPJEPcLxArs2jRR30w75nKbkXAL3uSmMZGU=;
 b=XCnkPPfGnnKTU/dbvptJXwd6l5bW8sCAPEbMYH1F+C40iN/uBWs1Cnr4f1z0NVoBZoVyAwrL5Z5ZNaT7TxZy9SVOwAtQJ6/rYd8zqmCXpHh+0i2RIAeMp4+vyBLxnWsSX7R9h7mntlQ0+YCW+vx4MMEn5nuzf+mQUzEsj4JbUn0=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW4PR21MB1955.namprd21.prod.outlook.com (2603:10b6:303:71::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.2; Thu, 15 Apr
 2021 13:22:33 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c30:6e04:401d:c31f]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c30:6e04:401d:c31f%4]) with mapi id 15.20.4042.019; Thu, 15 Apr 2021
 13:22:33 +0000
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
Subject: RE: [PATCH hyperv-next] scsi: storvsc: Use blk_mq_unique_tag() to
 generate requestIDs
Thread-Topic: [PATCH hyperv-next] scsi: storvsc: Use blk_mq_unique_tag() to
 generate requestIDs
Thread-Index: AQHXMeZ5+UsCvMGzVUiOCHBsvAGtu6q1kH6g
Date:   Thu, 15 Apr 2021 13:22:32 +0000
Message-ID: <MWHPR21MB15936B2FBD1C1FE91C654F3DD74D9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210415105926.3688-1-parri.andrea@gmail.com>
In-Reply-To: <20210415105926.3688-1-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=600f892f-0115-4979-b64e-862b4d5708e3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-15T13:20:47Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2deb3f0b-0c78-43f8-39d5-08d900118718
x-ms-traffictypediagnostic: MW4PR21MB1955:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB1955594F0FD58281034F9FA8D74D9@MW4PR21MB1955.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: szwdCBihlYhpVTUhqwAWPeUBw/z25cwDZNHoMh8pWUbxPr6QLD5VY/2FLRcXJWMi8nZNYFYWDfsLgRZ4owj32bHTR8Drb00yblf/5cxeQw1tCCgoHbIXs/SV+jEVCvYgQCg9iFiIeDi2kLDdmaZboZVxG1a9VM4ryeE7AQfr4ucl+IhRhplk4dbJatPK1iL2P4dmnrPHEfBGJB2wKWNrhU4I+tbrZR+lTECh/+soiOsXDmcTkyyxgjqVnunDW5R5p01ZkXZ8PLr1qn/KF/FjSudUqWczSLleNsrYpf4JY5Ban1M6m9H8ewUPe3qfv5YvqRUOPdGRkOXbqRLt3GqBb6lZBTcJL1axZu4XQ0ksLfOdjeCHCefUP1P5diV2Tx4cjUNu7NKJ3j+8hlEty/XIp7N6KkvjPKIWBT86N0aIFNx4XB3UfHmsKH0ReXt/pzaf8ojBcNUeKDwK8h9ePF4HRxHIAVyxTRYPToA8d8rzhqtMRXG1O1nesLy0s/dkbjQetorqy6utYwyjALGDfuYoBSBcs8C13ZWbOefoHIKLW02OkkUB9QvYWsxP1rPsA869sI3ONrVVOzRMTY4wzARyqlkdCjjDWO/Jf12A98u5UM6tD+9FgR+97xmrpr3iIJMXabFLPRrT5YUidkf6OczkqAyRGQnVU18DXJTB7XLIwPvgPrCbDMHK2VskX3LlrJfY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(30864003)(6506007)(33656002)(66446008)(186003)(7416002)(8990500004)(26005)(10290500003)(52536014)(55016002)(66476007)(83380400001)(122000001)(316002)(478600001)(7696005)(64756008)(82950400001)(54906003)(9686003)(2906002)(110136005)(71200400001)(4326008)(66556008)(76116006)(66946007)(82960400001)(8676002)(5660300002)(38100700002)(86362001)(8936002)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rP6/m2clStSVhBDAPcfRDh8Qc1MH/vNm3DB3lLfJKcsrSOHNJ7OkbQkI5LDy?=
 =?us-ascii?Q?WfG0u/kjoEO9D545+08zeJKrdwjr4Cs+lrKHk2+8OO9u+PUoxiIJ3LzObi8U?=
 =?us-ascii?Q?wu8BC0dIuXebGDCna59MVwFenR0lB7R7D34S3m7pxicpo6Y4skB91ntrp2CV?=
 =?us-ascii?Q?NhrYaDqz+Ds+0FgamqPaHtmjscE1X8FRHIA+uaZECf1emVAB+ONxicTRhJ3r?=
 =?us-ascii?Q?EimuEQ+zDXEGL0GXV2Bg9PeOlH8oc4IzX2KZwHRftYYawbZP30g7cBVXomXP?=
 =?us-ascii?Q?StIoa+U37lbpJTw3lh06zXOa8zQiQ6Ut2xHgXfedbX7lyPiHwpFH2YrX5jCh?=
 =?us-ascii?Q?gtwPcoWeuI9ZmYACmvv7Ymp7yD/G6VrAyyr+Qlz6XI21EHbC1g55xat035yP?=
 =?us-ascii?Q?Kz/ZiJUBnqaAZnJhcxlaZgK3txtqWYjHnIXb3K1NEnN8fsaLm2GRneUChZoI?=
 =?us-ascii?Q?F9+LE86lxLwcInfwn75gukQh0UU97HM9xJMIODui0qQfyRhsv9h3Edeo6WlK?=
 =?us-ascii?Q?n6DwUYTlfN6jT0U04Z+IgRU36F39l9r84Hw/dtmnhsY3aUQLEDbIOF2Z2EiW?=
 =?us-ascii?Q?0ifnR25uvhQ/g0F3TQN6G0jC28zARwIyQ4TkDfkvqtLg1wyEBf23w/nCE+tB?=
 =?us-ascii?Q?MvR9mo85ss1C+4FDCQ6YWzEZumx5MzKD9n/rCozZQo3K0iJLoTLpqXyAf0Ti?=
 =?us-ascii?Q?JeflGrqyLZx7V4907AN2vK/Oc1rdJkMTrgxV/0JkOu/cSzvtqIXsjk/b7kDP?=
 =?us-ascii?Q?am3+ECqCIr1qxW0pKIcVM+H0XsTZ2zQeWMNmUItOjyWjmYErlcQqgaFnQIxI?=
 =?us-ascii?Q?qAJ8/2NjNfEEU98AW4iGQorjUvUukdp7V+spWWuSNwvtttrS+UlwXWuL/62p?=
 =?us-ascii?Q?mZFOWN1uPF51jF5X9ZN/CJZb2HemPfszv0CGQ54kwIcr4Cw5f0pmQK8LjI7r?=
 =?us-ascii?Q?NMGH330CtkYhy84aMaMElgZO6CpQVWkreyaSfnqy4D25VXDW5VNz97qoTALa?=
 =?us-ascii?Q?acckTLDYqnseiv7JhWl6b76SwDNiNr1gqLfqM5edpYMtL/m9pOX5HI6lXRQw?=
 =?us-ascii?Q?XbbmDv71mJd3otR1+BgYe+PALOKKIHmiMSs+9cuZkzz9TwyzdubINvu+RaIJ?=
 =?us-ascii?Q?jwp1SQgx8BFbpLzo8p9bWyJNy7QcpyrY4tQCvQGcC6c1vOhmTLvqJTp93cOG?=
 =?us-ascii?Q?aN8jRq4YJUleLNZq+Ba1YDIN1S1uU6RIZIH9XfcaqKO7AdTnih9mrZw3ClaN?=
 =?us-ascii?Q?F3U61j7KRwn4NWr0SB9ONhj5omWUZDylioqJAfWcbS3iJwS9Qcf/F/lPWWcH?=
 =?us-ascii?Q?ROpiiUyQgKxXdBuF2DQLmsla?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2deb3f0b-0c78-43f8-39d5-08d900118718
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 13:22:32.9742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pU1mZ1MslbyhY0u2BWkZkhRND0D3D4SoyL7/X0oNqOURqLXMZJYXPqvUr4s+NJSRzV+5mef9Td7m+SWWDJkA/Cv3oHtvIiRTUCbutU6hYFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1955
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Thursday, Apr=
il 15, 2021 3:59 AM
>=20
> Use blk_mq_unique_tag() to generate requestIDs for StorVSC, avoiding
> all issues with allocating enough entries in the VMbus requestor.
>=20
> Suggested-by: Michael Kelley <mikelley@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> ---
> Changes since RFC:
>   - pass sentinel values for {init,reset}_request in vmbus_sendpacket()
>   - remove/inline the storvsc_request_addr() callback
>   - make storvsc_next_request_id() 'static'
>   - add code to handle the case of an unsolicited message from Hyper-V
>   - other minor/style changes
>=20
> [1] https://lore.kernel.org/linux-hyperv/20210408161315.341888-1-parri.an=
drea@gmail.com/
>=20
>  drivers/hv/channel.c              | 14 ++---
>  drivers/hv/ring_buffer.c          | 13 +++--
>  drivers/net/hyperv/netvsc.c       |  8 ++-
>  drivers/net/hyperv/rndis_filter.c |  2 +
>  drivers/scsi/storvsc_drv.c        | 94 +++++++++++++++++++++----------
>  include/linux/hyperv.h            | 13 ++++-
>  6 files changed, 95 insertions(+), 49 deletions(-)

LGTM

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

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
> index ecd82ebfd5bc4..2bf57677272b5 100644
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
> @@ -341,7 +343,8 @@ int hv_ringbuffer_write(struct vmbus_channel *channel=
,
>  	if (channel->rescind) {
>  		if (rqst_id !=3D VMBUS_NO_RQSTOR) {
>  			/* Reclaim request ID to avoid leak of IDs */
> -			vmbus_request_addr(&channel->requestor, rqst_id);
> +			if (channel->request_addr_callback !=3D NULL)
> +				channel->request_addr_callback(channel, rqst_id);
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
> index 6bc5453cea8a7..b219a266cca80 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -684,6 +684,23 @@ static void storvsc_change_target_cpu(struct vmbus_c=
hannel
> *channel, u32 old,
>  	spin_unlock_irqrestore(&stor_device->lock, flags);
>  }
>=20
> +static u64 storvsc_next_request_id(struct vmbus_channel *channel, u64 rq=
st_addr)
> +{
> +	struct storvsc_cmd_request *request =3D
> +		(struct storvsc_cmd_request *)(unsigned long)rqst_addr;
> +
> +	if (rqst_addr =3D=3D VMBUS_RQST_INIT)
> +		return VMBUS_RQST_INIT;
> +	if (rqst_addr =3D=3D VMBUS_RQST_RESET)
> +		return VMBUS_RQST_RESET;
> +
> +	/*
> +	 * Cannot return an ID of 0, which is reserved for an unsolicited
> +	 * message from Hyper-V.
> +	 */
> +	return (u64)blk_mq_unique_tag(request->cmd->request) + 1;
> +}
> +
>  static void handle_sc_creation(struct vmbus_channel *new_sc)
>  {
>  	struct hv_device *device =3D new_sc->primary_channel->device_obj;
> @@ -698,11 +715,7 @@ static void handle_sc_creation(struct vmbus_channel =
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
>=20
>  	ret =3D vmbus_open(new_sc,
>  			 storvsc_ringbuffer_size,
> @@ -769,7 +782,7 @@ static void  handle_multichannel_storage(struct hv_de=
vice *device,
> int max_chns)
>  	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
>  			       (sizeof(struct vstor_packet) -
>  			       stor_device->vmscsi_size_delta),
> -			       (unsigned long)request,
> +			       VMBUS_RQST_INIT,
>  			       VM_PKT_DATA_INBAND,
>  			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>=20
> @@ -838,7 +851,7 @@ static int storvsc_execute_vstor_op(struct hv_device =
*device,
>  	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
>  			       (sizeof(struct vstor_packet) -
>  			       stor_device->vmscsi_size_delta),
> -			       (unsigned long)request,
> +			       VMBUS_RQST_INIT,
>  			       VM_PKT_DATA_INBAND,
>  			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>  	if (ret !=3D 0)
> @@ -1240,6 +1253,7 @@ static void storvsc_on_channel_callback(void *conte=
xt)
>  	const struct vmpacket_descriptor *desc;
>  	struct hv_device *device;
>  	struct storvsc_device *stor_device;
> +	struct Scsi_Host *shost;
>=20
>  	if (channel->primary_channel !=3D NULL)
>  		device =3D channel->primary_channel->device_obj;
> @@ -1250,20 +1264,12 @@ static void storvsc_on_channel_callback(void *con=
text)
>  	if (!stor_device)
>  		return;
>=20
> -	foreach_vmbus_pkt(desc, channel) {
> -		void *packet =3D hv_pkt_data(desc);
> -		struct storvsc_cmd_request *request;
> -		u64 cmd_rqst;
> -
> -		cmd_rqst =3D vmbus_request_addr(&channel->requestor,
> -					      desc->trans_id);
> -		if (cmd_rqst =3D=3D VMBUS_RQST_ERROR) {
> -			dev_err(&device->device,
> -				"Incorrect transaction id\n");
> -			continue;
> -		}
> +	shost =3D stor_device->host;
>=20
> -		request =3D (struct storvsc_cmd_request *)(unsigned long)cmd_rqst;
> +	foreach_vmbus_pkt(desc, channel) {
> +		struct vstor_packet *packet =3D hv_pkt_data(desc);
> +		struct storvsc_cmd_request *request =3D NULL;
> +		u64 rqst_id =3D desc->trans_id;
>=20
>  		if (hv_pkt_datalen(desc) < sizeof(struct vstor_packet) -
>  				stor_device->vmscsi_size_delta) {
> @@ -1271,14 +1277,44 @@ static void storvsc_on_channel_callback(void *con=
text)
>  			continue;
>  		}
>=20
> -		if (request =3D=3D &stor_device->init_request ||
> -		    request =3D=3D &stor_device->reset_request) {
> -			memcpy(&request->vstor_packet, packet,
> -			       (sizeof(struct vstor_packet) - stor_device->vmscsi_size_delta)=
);
> -			complete(&request->wait_event);
> +		if (rqst_id =3D=3D VMBUS_RQST_INIT) {
> +			request =3D &stor_device->init_request;
> +		} else if (rqst_id =3D=3D VMBUS_RQST_RESET) {
> +			request =3D &stor_device->reset_request;
>  		} else {
> +			/* Hyper-V can send an unsolicited message with ID of 0 */
> +			if (rqst_id =3D=3D 0) {
> +				/*
> +				 * storvsc_on_receive() looks at the vstor_packet in the
> message
> +				 * from the ring buffer.  If the operation in the vstor_packet
> is
> +				 * COMPLETE_IO, then we call storvsc_on_io_completion(),
> and
> +				 * dereference the guest memory address.  Make sure we
> don't call
> +				 * storvsc_on_io_completion() with a guest memory
> address that is
> +				 * zero if Hyper-V were to construct and send such a bogus
> packet.
> +				 */
> +				if (packet->operation =3D=3D
> VSTOR_OPERATION_COMPLETE_IO) {
> +					dev_err(&device->device, "Invalid packet with ID of
> 0\n");
> +					continue;
> +				}
> +			} else {
> +				struct scsi_cmnd *scmnd;
> +
> +				/* Transaction 'rqst_id' corresponds to tag 'rqst_id - 1' */
> +				scmnd =3D scsi_host_find_tag(shost, rqst_id - 1);
> +				if (scmnd =3D=3D NULL) {
> +					dev_err(&device->device, "Incorrect transaction
> ID\n");
> +					continue;
> +				}
> +				request =3D (struct storvsc_cmd_request
> *)scsi_cmd_priv(scmnd);
> +			}
> +
>  			storvsc_on_receive(stor_device, packet, request);
> +			continue;
>  		}
> +
> +		memcpy(&request->vstor_packet, packet,
> +		       (sizeof(struct vstor_packet) - stor_device->vmscsi_size_delta))=
;
> +		complete(&request->wait_event);
>  	}
>  }
>=20
> @@ -1290,11 +1326,7 @@ static int storvsc_connect_to_vsp(struct hv_device=
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
>=20
>  	ret =3D vmbus_open(device->channel,
>  			 ring_size,
> @@ -1620,7 +1652,7 @@ static int storvsc_host_reset_handler(struct scsi_c=
mnd *scmnd)
>  	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
>  			       (sizeof(struct vstor_packet) -
>  				stor_device->vmscsi_size_delta),
> -			       (unsigned long)&stor_device->reset_request,
> +			       VMBUS_RQST_RESET,
>  			       VM_PKT_DATA_INBAND,
>  			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>  	if (ret !=3D 0)
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 2c18c8e768efe..5692ffa60e022 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -779,7 +779,11 @@ struct vmbus_requestor {
>=20
>  #define VMBUS_NO_RQSTOR U64_MAX
>  #define VMBUS_RQST_ERROR (U64_MAX - 1)
> +/* NetVSC-specific */
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

