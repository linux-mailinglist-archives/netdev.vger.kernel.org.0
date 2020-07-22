Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1DB22A30B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 01:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733042AbgGVXZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 19:25:23 -0400
Received: from mail-mw2nam12on2106.outbound.protection.outlook.com ([40.107.244.106]:3680
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726525AbgGVXZX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 19:25:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxmEEsDfdlKflJXSSWv7x69ZkyZAmvQ2tKR774gfTjyBEp/RJA9Smz/V8Nq5YzIU4ACR3BgPmaNnePtPhB+CTWH1cwXbTWBWSGgeJoZ4TpTLYrUkpd5osu75P9hGyRORqaDBCGscxjV97ZsfJ2pneHTSuFiIimeNINY6VuwI9NnHqLR/W7XXgeI0ZBWl7J6hJJfQl44KmxR48tcymQ+PGyGJl2JWb1uDWX4M7VMaG5MW8P7ybGaUOiqId9LWPldkVxFds/IKCIJ9Ugzd6glaO4QfHvakGKI95aVMgpJJABE2eQrn5K+KxMMlRBELMk+Ll/3xdSBqCx0ClE810S0u8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEXhSgKoDqBsBh/OydI2XHzmflLk63tVyRIy7uXcWFc=;
 b=c72ojLJ9anM2TWlrLiiz1jNrGriGX4HTGGDjFTY0h32cRTup+phH/WWo5QKKDAgNhkhE1PqZdvTPJfLWmoZM3fqarv+OLA5daBD4gEAhZyeiYk4zrosi412DXmGOXZ7hX2P9rXpPA1UW9jA6CROthe0KQ34LLeXdsUiD5Dl/tNWTZuyYFiAbGRAebecjWIRcXbKvkcN1W4DSwqfOciqbNRJNY0+ND+IeC+BZ3zLl/3FgF1fGfNpEBkZ8967hineV4cPiIjj3N4UF6q7jLPOiT+//eFYStucaxi5Rfwycmdr8ATMeoAyHV7TrC6mcrkPNkKwDi4ZYiSArXhVe4YDgxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEXhSgKoDqBsBh/OydI2XHzmflLk63tVyRIy7uXcWFc=;
 b=dFELN40drrU49DeT92kA4mm1ZL1eHWb02ijq+I0rjBjQGkR+8zpbVc5jkObqqeQLiFBV7xooI4aer40nF3f9rBCkyqaE30weNxxZ/yYqlwx/sNf/h6IMIHj8nsfTdjMXeaYA5FEVfPLNurbtlDckQOwYXnzvG6OL7RGgu/ecnpM=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB1113.namprd21.prod.outlook.com (2603:10b6:302:a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.3; Wed, 22 Jul
 2020 23:25:18 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407%8]) with mapi id 15.20.3239.005; Wed, 22 Jul 2020
 23:25:18 +0000
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
Subject: RE: [RFC 03/11] Drivers: hv: vmbus: Introduce types of GPADL
Thread-Topic: [RFC 03/11] Drivers: hv: vmbus: Introduce types of GPADL
Thread-Index: AQHWXwAfq8py9R1cgk6EBitVHLoMRqkUP0Ww
Date:   Wed, 22 Jul 2020 23:25:18 +0000
Message-ID: <MW2PR2101MB1052E3D15D411A5DC62A60F2D7790@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
 <20200721014135.84140-4-boqun.feng@gmail.com>
In-Reply-To: <20200721014135.84140-4-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-22T23:25:16Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0f5df9ef-827a-48e4-82f9-bb6f0efc59ec;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 38ce56b6-aaf9-4f5b-b879-08d82e967f2c
x-ms-traffictypediagnostic: MW2PR2101MB1113:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR2101MB1113AC7C22FAA977806F6CC5D7790@MW2PR2101MB1113.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cj+QpFuKMD6LTTc0BtjPGIPDCrDkRJxItDpv+TeVHlY1EEfEJt4YSJfv3xOW4T/WX0ecBxFHthX/Pe+UFo1W3FCAYtnK0vbC46LSS2BwTOvswNPjkB6ZAcoGwVV4jzKImMaziiuop121qb7DHHrGiKPi0MjvE09TljKHsFPw301MeT6aUZktg9CV5LQw7QPcrlrLyro/SOjlhfllYXJLLaRi8tEbjeYQJ8qwuTrmRKMcz/AODh8Gc76uDg987Jv7iQXvci3iojLZoVjRUxxkZZ6V9Mc258cFxQSU9D38a1LEPCoXIqQ1opyvblJlZtQoDQWfzMt01w0vKeMMGoPpog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(71200400001)(9686003)(33656002)(82950400001)(82960400001)(83380400001)(5660300002)(8936002)(8990500004)(2906002)(7696005)(86362001)(8676002)(6506007)(4326008)(66946007)(76116006)(52536014)(66556008)(64756008)(66446008)(66476007)(7416002)(478600001)(54906003)(26005)(110136005)(316002)(186003)(55016002)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +zWEneyD4EFatqEBcrLbeo82AGs4bxdNMAJHg7FEBH9HHkjj4g+wzKI1C6OHD04tkuq4ocIqjGcnEJ80Uvsz7xF9ARiDkX2UEuDP4nNY0iM09WEAyipg+zdgHfyKJnLulIkfBxkWghJoAMUdNpx1hcaHgXzs6UPrIiH0jliqMnyYlknY2bsku3buckf+mu51RbwlgsVhvi/nKSir9zX8P7Kpne1JjcxrBQdzy+EJAkzixYOrEHQ1ZbF4CZue7gsRc48jXQfhSx3OIonBUD/W++jOjTF1lsKW3+JOEPT3fidQmYBu125xhHSeCVpzNeMy8+fGthUrkWYVQJhjXI4ygJ+I0QZIT0+Uvg/cX60oRBCOQvsBcFUPhtTeL49wwywJYMkCgNxQgpXUlq1ZG1aSIpXOZuKdO/c3WnkcxVdJr+5930KAKvDCgR9/Pjf+zjX61Zc/wwb9ImfeEhzUKVgFW0OwTVo+7GdlHfpwfLc5lEu1orn34z9E4Xruy8q3SWM8KmJgcCIK7Rc9leci0wGsjPV2kZ6q3ousi6PpD6sTGOc6VjDCXBPYL+8zlc1wBvqZkCUTHAizhEC1pucv9rpU26EepEu4+wqt0JVMr+qj+lZ3D3GHvbA8icVAKJffIDK+CgDzRntjvkDUwPhGL/Qvdw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38ce56b6-aaf9-4f5b-b879-08d82e967f2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 23:25:18.4825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uUtfvWmXYCe9lNc0W1Q75tWO2kwsc5NKAs/3bgT0a1aeuaCc+4FvKH354wWP6XK6B8kjrYbS94w3D0HdJEZpEdYCyaJh6jsrzlOCu3osOdY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Monday, July 20, 2020 6:41 PM
>=20
> This patch introduces two types of GPADL: HV_GPADL_{BUFFER, RING}. The
> types of GPADL are purely the concept in the guest, IOW the hypervisor
> treat them as the same.
>=20
> The reason of introducing the types of GPADL is to support guests whose
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
>  drivers/hv/channel.c   | 140 +++++++++++++++++++++++++++++++++++------
>  include/linux/hyperv.h |  44 ++++++++++++-
>  2 files changed, 164 insertions(+), 20 deletions(-)

[snip]

>=20
>=20
> @@ -437,7 +528,17 @@ static int __vmbus_open(struct vmbus_channel *newcha=
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
> +	 * calculate it into bytes and then convert into HV_HYP_PAGE. Also
> +	 * ->ringbuffer_send_offset is the offset in guest, while
> +	 * ->downstream_ringbuffer_pageoffset is the offset in gpadl (i.e. in
> +	 * hypervisor), so a (PAGE_SIZE - HV_HYP_PAGE_SIZE) gap need to be
> +	 * skipped.
> +	 */
> +	open_msg->downstream_ringbuffer_pageoffset =3D
> +		((newchannel->ringbuffer_send_offset << PAGE_SHIFT) - (PAGE_SIZE -
> HV_HYP_PAGE_SIZE)) >> HV_HYP_PAGE_SHIFT;

I couldn't find that the "downstream_ringbuffer_pageoffset" field
is used anywhere.  Can it just be deleted entirely instead of having
this really messy calculation?

>  	open_msg->target_vp =3D newchannel->target_vp;
>=20
>  	if (userdatalen)
> @@ -497,6 +598,7 @@ static int __vmbus_open(struct vmbus_channel *newchan=
nel,
>  	return err;
>  }
>=20
> +

Spurious add of a blank line?

>  /*
>   * vmbus_connect_ring - Open the channel but reuse ring buffer
>   */
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 692c89ccf5df..663f0a016237 100644
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
> 2.27.0

