Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BB8279D1C
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 02:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbgI0AMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 20:12:25 -0400
Received: from mail-eopbgr750124.outbound.protection.outlook.com ([40.107.75.124]:30389
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbgI0AMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 20:12:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iuo66aruBha1msLCDAF684WCXT7luZXUxB03fBxO19HE9JesRwDz+7h8IVdyll6ubrh7na6o6aq1mdApjrfDf3jHrbFL3WpBJuNGGpdR3T2eRF+u4uLyjLK/89VZpBzmODhyBLQpJLa1UZhfm/FDr7jUCdhzltXJF0Mox9ibzUKwnEr6IJhD6GUm1eyu6LAYtKcmZe4gdT4i9+OjWSvCQUK8oT+qOH8N05MKqMjBdGIwthGIuVg521s9Y8el+z/YXCKaXokHFGSA6i6J7e2R8m+LllFOGdKOkn0SQzvl6ZgpATXh5riCy5I2sOoTdNzJgmEnQSg32NZH+s11B+FvJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e05lc9B2A3dgCiVkkc2qaYZ0PtxigCWjYD19XM4LA4s=;
 b=ie4nyXgMqFBb+JEnFKTkWbYDOwRfsDaP0g/rCEqollyyLBdt826TDoTW5HifIanr22CzbGisDcOvUxggdu0a+QVJsWuRCr16jxQuVdwcDvWesMYXqLQscyXfXo82GsfC6+AtM3PW5JW4daEO0L+o+xYEasaRqa+iJjenoavvwxUQvT7u/YhaWbWjwcsJqz9cgm+g1xj7ux7CluxJlXMknymcfubtLb0lwCEZCMI6DffKaFgFDMZ2HOOuoDesha0/SyucQic35Gc4taCMgSmxKe8Ho59I2/K+ILmWpLVaNI2Xo7cTqlE/PhhGxMTXQRczlqs4oYYyu4q58xVShOvEkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e05lc9B2A3dgCiVkkc2qaYZ0PtxigCWjYD19XM4LA4s=;
 b=EquGInRT2w2Rid+q6EoeWYJAO/CAwtHppIfhmhrpmwGJ3Fp0pE3lUvjB4wOc94Kuw8EuY6pLuLsLumS7XpCEGBVBABESvkibk1C/m2NAzcxvJFTXiRVcJyMZEeOGn4itOz2PuldDBiyg+d7EPDbdLrbdq0HHtYhNP4849MMSfsw=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB0892.namprd21.prod.outlook.com (2603:10b6:302:10::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.7; Sun, 27 Sep
 2020 00:12:20 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.028; Sun, 27 Sep 2020
 00:12:20 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "will@kernel.org" <will@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Mark.Rutland@arm.com" <Mark.Rutland@arm.com>,
        "maz@kernel.org" <maz@kernel.org>
Subject: RE: [PATCH v4 10/11] Driver: hv: util: Use VMBUS_RING_SIZE() for
 ringbuffer sizes
Thread-Topic: [PATCH v4 10/11] Driver: hv: util: Use VMBUS_RING_SIZE() for
 ringbuffer sizes
Thread-Index: AQHWi9xHczzmm0pDnU+OThnPDZZK4ql7rdeA
Date:   Sun, 27 Sep 2020 00:12:20 +0000
Message-ID: <MW2PR2101MB1052E8E344B482AB0A0DD193D7340@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
 <20200916034817.30282-11-boqun.feng@gmail.com>
In-Reply-To: <20200916034817.30282-11-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-27T00:12:18Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b28a0bef-45ee-4824-bd9f-b8c1aac2b206;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c528a9aa-08b4-4d7b-ff21-08d8627a003a
x-ms-traffictypediagnostic: MW2PR2101MB0892:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB08920E01292829912D07F7A8D7340@MW2PR2101MB0892.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DuD/mTOL7pdhLsQKdbrjmMkxezNKslNWl2WH89hrVlP+OiLAi5uz8kCWczHKwcLVrMIZbC7yXIh4Cw+CoJpQX/9DHUemi7Dje+mRLUcd5VUuxi7TwzMPkaVF9U5/LRd2XCrbi7k3C/NxeegEKqsGfQ5GARGLAv6tfaTAH+zZ/ZcfOspy9bZ8Wj3n39wmP9b32eP1oQr9DHp9c96zOvI5REJaPUjDJZMslkh5g9fdkpW5FWrlYjXL06XCV38zsDWwnYNAk0Jct0Rkm5pfVLwZ4Y1E/0OOMPM8UaucTe5ZdVWBxSkXnT35W97/T6GuM1y5LOK14RzNqd2LR+oebwfFfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(5660300002)(316002)(4326008)(66446008)(52536014)(86362001)(64756008)(66476007)(66946007)(71200400001)(76116006)(82960400001)(83380400001)(66556008)(33656002)(8676002)(54906003)(82950400001)(186003)(7416002)(110136005)(7696005)(6506007)(8936002)(478600001)(26005)(10290500003)(2906002)(55016002)(9686003)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Am8aTWHSdCRzLTeAbh+sS14fcgC5HuPfMqOULZGeBHEHED4mCMVjkbWw82nMosSQX7zlbE8sUYKk4Uy3CM1i5yJueGXxiYBVZwbRTpj1/WY8SB2Ix9rmzqqkBMvW9gwLGJ58gmLv2ZBd2GKaGATxvpOe5Y/mnza5kiClK4JOKrSdD0TdLorxlZRJLudO11B72uUgmaAHLmcrM/MTlK9QHKH2XA1ly1emwtSl1k/OqLu35JiX/yXQnTi6PFvAVC6ZH36+4PO0LfwAtFG19N/N/VGzZzFGgIgDlfzhvtyoW0+X0rnQZLnL7CIU8gmRDkIDOsbqnWJU/yEQNbFndajwPSYNmYzcxuproDpNmCriQDFJ3IX2cGvU1OAJYAl6HAIZo95sRj1VaAkZ9YO8V/Du860hPSxx+ar2WNpV4BKoqDtQWvjwjj1GOIMn6BduQSeawUmCzlC9QuLu51v6LERKVbR/IoCRmI5sSLHqvg4VCZ9CUWtyw2IaJVOhdtjZ80Rvs1TsSKSHMfk/qOR1uF4mFQ+3402XKNkhrzzlDqRyMcvb1O1LCaedZ+8FrgXW+Qe1Iwx5LaG/snFJ4I6YXvNSnl8HHm1G/Nx0gIIbEK8edmgeaQi12mFrE4GGfLYK0JIykt8nlxFnfR5r6XZSDohM7w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c528a9aa-08b4-4d7b-ff21-08d8627a003a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2020 00:12:20.1874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6pwSwY5+Ryv/MCdAc27waJds5Ws6dtH44oNsVOj+n0xIrDRaSbf43/AJCYOiDtmitJS7CN5FXd8s0qN/kHtnvbwGmLzYZj63bRO1KlUPnuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0892
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Tuesday, September 15, 2020 8=
:48 PM
>=20
> For a Hyper-V vmbus, the size of the ringbuffer has two requirements:
>=20
> 1)	it has to take one PAGE_SIZE for the header
>=20
> 2)	it has to be PAGE_SIZE aligned so that double-mapping can work
>=20
> VMBUS_RING_SIZE() could calculate a correct ringbuffer size which
> fulfills both requirements, therefore use it to make sure vmbus work
> when PAGE_SIZE !=3D HV_HYP_PAGE_SIZE (4K).
>=20
> Note that since the argument for VMBUS_RING_SIZE() is the size of
> payload (data part), so it will be minus 4k (the size of header when
> PAGE_SIZE =3D 4k) than the original value to keep the ringbuffer total
> size unchanged when PAGE_SIZE =3D 4k.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Cc: Michael Kelley <mikelley@microsoft.com>
>=20
> ---
> Michael,
>=20
> I drop your Reviewed-by tag because of the page align issue. Could you
> review this updated version? Thanks!
>=20
> Regards,
> Boqun
>=20
>=20
>  drivers/hv/hv_util.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> index a4e8d96513c2..05566ecdbe4b 100644
> --- a/drivers/hv/hv_util.c
> +++ b/drivers/hv/hv_util.c
> @@ -500,6 +500,9 @@ static void heartbeat_onchannelcallback(void *context=
)
>  	}
>  }
>=20
> +#define HV_UTIL_RING_SEND_SIZE VMBUS_RING_SIZE(3 * HV_HYP_PAGE_SIZE)
> +#define HV_UTIL_RING_RECV_SIZE VMBUS_RING_SIZE(3 * HV_HYP_PAGE_SIZE)
> +
>  static int util_probe(struct hv_device *dev,
>  			const struct hv_vmbus_device_id *dev_id)
>  {
> @@ -530,8 +533,8 @@ static int util_probe(struct hv_device *dev,
>=20
>  	hv_set_drvdata(dev, srv);
>=20
> -	ret =3D vmbus_open(dev->channel, 4 * HV_HYP_PAGE_SIZE,
> -			 4 * HV_HYP_PAGE_SIZE, NULL, 0, srv->util_cb,
> +	ret =3D vmbus_open(dev->channel, HV_UTIL_RING_SEND_SIZE,
> +			 HV_UTIL_RING_RECV_SIZE, NULL, 0, srv->util_cb,
>  			 dev->channel);
>  	if (ret)
>  		goto error;
> @@ -590,8 +593,8 @@ static int util_resume(struct hv_device *dev)
>  			return ret;
>  	}
>=20
> -	ret =3D vmbus_open(dev->channel, 4 * HV_HYP_PAGE_SIZE,
> -			 4 * HV_HYP_PAGE_SIZE, NULL, 0, srv->util_cb,
> +	ret =3D vmbus_open(dev->channel, HV_UTIL_RING_SEND_SIZE,
> +			 HV_UTIL_RING_RECV_SIZE, NULL, 0, srv->util_cb,
>  			 dev->channel);
>  	return ret;
>  }
> --
> 2.28.0

Reviewed-by:  Michael Kelley <mikelley@microsoft.com>

