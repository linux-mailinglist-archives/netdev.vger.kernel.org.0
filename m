Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B4C12D582
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 02:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfLaBeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 20:34:50 -0500
Received: from mail-bn7nam10on2091.outbound.protection.outlook.com ([40.107.92.91]:41537
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725379AbfLaBeu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 20:34:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGdLqtieSptjIOHAqX2rU9QszKNiMPw+BLfOqb43d9tf3k+m9P+sizLT0v0bmDjDW7qSDHhUS1jSghCh+CEEcN4/k2Z4DL06q8VQyBHQ0WOfZrysBxIHMFET/TxSziGcr7PNglTwx8dw70B2ku8eYZXeZpUG/3W6N7+2ZXA7+wnlpSqG2Tmz+klOLpD+oc2u8B73vJ8LvTFEf56rSJjYFgceECF4yn65WkhiWbFC50D4JM+ZL5Wha7NXrmsS+XmGXVywpgX7OiqwvGPJTtm2N4GYbDtn0nCvNuYfKwSylCiQdsrIo7WmfETWFe2d/0ibUyYcdSCfiYfL0IIwNk9jSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpMA/iwRlge22YtL8WmAnRIgXuuddtw90g6x5Ri/1JY=;
 b=gPv4dj4GC3oGsh1CVCy6nEZt9N3NEnwzkk+NGhWVkUpWfFDoKdgGRpo4VwWoVQDLZwBRGxPSLWmmr++ppBaujNrI8SLuPBPCryAzGguar1R71GNoHaPdHIGeOzf45SBhOFTD2IgPzOfPqEftqGm7yHNJ+sjlC8g5O1MKGHbcMy02CGmFTKvMp6JBj+mF+L6XRP5UO539RKQwYzlN/9cgB0BoR8q53RB1XmW0IyJb0v6XRaiFYHcf7LCVJ5ZjYYDrep+jcN/C/3URcRleOy2HZ9TvwRRw8z8a31AlGn/fD50pbsDmyEyk0wMGtLs/pqiq+QWDQK7+2kVVha5HMrUlzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpMA/iwRlge22YtL8WmAnRIgXuuddtw90g6x5Ri/1JY=;
 b=a18wYyrgds5o/PphkZ+IsTlkgsy9pUG4MleJhXxardMHUKff4ZQ3QPk9ORj0gBx13hOgM5zDe0DiDPIXVw963ukHpEFWTi++m+LGvEa77yu1XyfNPdtDReAhMSguoDVAhf2gd8iuySidQipuiWEutLrnNPDyQNKT+XL6LtBAaV0=
Received: from CY4PR21MB0629.namprd21.prod.outlook.com (10.175.115.19) by
 CY4PR21MB0277.namprd21.prod.outlook.com (10.173.193.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.6; Tue, 31 Dec 2019 01:34:46 +0000
Received: from CY4PR21MB0629.namprd21.prod.outlook.com
 ([fe80::654d:8bdd:471:e0ac]) by CY4PR21MB0629.namprd21.prod.outlook.com
 ([fe80::654d:8bdd:471:e0ac%9]) with mapi id 15.20.2602.010; Tue, 31 Dec 2019
 01:34:46 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2,net-next, 1/3] Drivers: hv: vmbus: Add a dev_num
 variable based on channel offer sequence
Thread-Topic: [PATCH V2,net-next, 1/3] Drivers: hv: vmbus: Add a dev_num
 variable based on channel offer sequence
Thread-Index: AQHVv03D5az1FILedkG1hTPYOYSiuafTbghA
Date:   Tue, 31 Dec 2019 01:34:46 +0000
Message-ID: <CY4PR21MB06294EA44916F9BD16138F94D7260@CY4PR21MB0629.namprd21.prod.outlook.com>
References: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
 <1577736814-21112-2-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1577736814-21112-2-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-12-31T01:34:44.1639696Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=554a2b6a-063c-4cad-a423-10c76d7c12e4;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 27858ef7-846b-4dd4-0eba-08d78d919eb2
x-ms-traffictypediagnostic: CY4PR21MB0277:|CY4PR21MB0277:|CY4PR21MB0277:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CY4PR21MB0277C0FB33E68DE88EB18085D7260@CY4PR21MB0277.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0268246AE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(396003)(376002)(346002)(366004)(199004)(189003)(76116006)(10290500003)(8936002)(66476007)(66556008)(66446008)(64756008)(8676002)(4326008)(81166006)(81156014)(52536014)(7696005)(66946007)(26005)(8990500004)(71200400001)(316002)(186003)(86362001)(33656002)(5660300002)(54906003)(478600001)(9686003)(2906002)(6506007)(110136005)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR21MB0277;H:CY4PR21MB0629.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iLfDhrue9M0dXVsPfiD2cXrG545X/TI6CrluLCmdoMGMkt83sDTb9HNgKJywdeYQlxa0hcGhle/6cZ89Xxik8DnHkKglwCyIBTdklNx45zcHVkMIFjehJITlbyaKcP1c9JlvMHKhTzEJWI4/k3J8GXhqxAXR7hZb0GK+wB5UiaF9zs6HwE0f5dQ1c41FX30CJEWgAFG3VpYHUmvDUYstnaPvHeJhGUS1qYvfEfLaIPFzpA0dWX1NSPwyhzH96a9Id5mjLD71COkUcX22+bIXQTwoVBRM1uTdiDeOtxEbUOOrTsFmOmtVv509CPBJsGjC8+SkHwJC37YQ/P+g9MjPEcokA2xwrwZTh5xhQOpq7rspzjjT44oZ9AGtAyzn+pNaTjrfKorQd7WabDtCrDv9b8Gx0aXngk8nCMXbPPJ0iH9BhsOkM6c8z4zRf+YDkEwn
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27858ef7-846b-4dd4-0eba-08d78d919eb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Dec 2019 01:34:46.6978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0kNs63J/zQpV7em9b5Yw9i/IkO7RM0Oz7lc3u3p4XPJ/+VR0ika1W2udfvMqRjylGVTWIKfoZ+jNbvyaBodUAG2/LIY58+4IZetsJCKmy18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0277
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Monday, December 30, 201=
9 12:14 PM
>=20
> This number is set to the first available number, starting from zero,
> when a vmbus device's primary channel is offered.

Let's use "VMBus" as the capitalization in text.

> It will be used for stable naming when Async probing is used.
>=20
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
> Changes
> V2:
> 	Use nest loops in hv_set_devnum, instead of goto.
>=20
>  drivers/hv/channel_mgmt.c | 38 ++++++++++++++++++++++++++++++++++++--
>  include/linux/hyperv.h    |  6 ++++++
>  2 files changed, 42 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index 8eb1675..00fa2db 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -315,6 +315,8 @@ static struct vmbus_channel *alloc_channel(void)
>  	if (!channel)
>  		return NULL;
>=20
> +	channel->dev_num =3D HV_DEV_NUM_INVALID;
> +
>  	spin_lock_init(&channel->lock);
>  	init_completion(&channel->rescind_event);
>=20
> @@ -541,6 +543,36 @@ static void vmbus_add_channel_work(struct work_struc=
t *work)
>  }
>=20
>  /*
> + * Get the first available device number of its type, then
> + * record it in the channel structure.
> + */
> +static void hv_set_devnum(struct vmbus_channel *newchannel)
> +{
> +	struct vmbus_channel *channel;
> +	int i =3D -1;
> +	bool found;
> +
> +	BUG_ON(!mutex_is_locked(&vmbus_connection.channel_mutex));
> +
> +	do {
> +		i++;
> +		found =3D false;
> +
> +		list_for_each_entry(channel, &vmbus_connection.chn_list,
> +				    listentry) {
> +			if (i =3D=3D channel->dev_num &&
> +			    guid_equal(&channel->offermsg.offer.if_type,
> +				       &newchannel->offermsg.offer.if_type)) {
> +				found =3D true;
> +				break;
> +			}
> +		}
> +	} while (found);
> +
> +	newchannel->dev_num =3D i;
> +}
> +

It took me a little while to figure out what the above algorithm is doing.
Perhaps it would help to rename the "found" variable to "in_use", and add
this comment before the start of the "do" loop:

Iterate through each possible device number starting at zero.  If the devic=
e
number is already in use for a device of this type, try the next device num=
ber
until finding one that is not in use.   This approach selects the smallest
device number that is not in use, and so reuses any numbers that are freed
by devices that have been removed.

> +/*
>   * vmbus_process_offer - Process the offer by creating a channel/device
>   * associated with this offer
>   */
> @@ -573,10 +605,12 @@ static void vmbus_process_offer(struct vmbus_channe=
l
> *newchannel)
>  		}
>  	}
>=20
> -	if (fnew)
> +	if (fnew) {
> +		hv_set_devnum(newchannel);
> +
>  		list_add_tail(&newchannel->listentry,
>  			      &vmbus_connection.chn_list);
> -	else {
> +	} else {
>  		/*
>  		 * Check to see if this is a valid sub-channel.
>  		 */
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 26f3aee..4f110c5 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -718,6 +718,8 @@ struct vmbus_device {
>  	bool perf_device;
>  };
>=20
> +#define HV_DEV_NUM_INVALID (-1)
> +
>  struct vmbus_channel {
>  	struct list_head listentry;
>=20
> @@ -849,6 +851,10 @@ struct vmbus_channel {
>  	 */
>  	struct vmbus_channel *primary_channel;
>  	/*
> +	 * Used for device naming based on channel offer sequence.
> +	 */
> +	int dev_num;
> +	/*
>  	 * Support per-channel state for use by vmbus drivers.
>  	 */
>  	void *per_channel_state;
> --
> 1.8.3.1

