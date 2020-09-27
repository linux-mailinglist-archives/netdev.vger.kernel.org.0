Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96285279D13
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 02:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgI0AKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 20:10:53 -0400
Received: from mail-eopbgr750128.outbound.protection.outlook.com ([40.107.75.128]:18042
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbgI0AKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 20:10:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHoyLuMcS8LdR9PllZ1+tHV6GH9Ka6nPF67+wFBD83DWEGLb9YImjJ5CaG6qT2a2kGWJXIduuTn7jnI/5ms81b/8WFwrpURGGAdzXuHQfHxlAefwOvwePYNNZmG9WrCG+dWQTdqq2tkLH3HGN4kqbc2xLNSH/ua+cfS3wuWCEqTtMjuzBJrZUammCAoIU/hjQGD4Np/b5EHnk/e+MMJkLamZSBwiUZhneTMhJegFrMevPqrZyOGZhbnV59ZJhU6hMIBbydPhPka4zrDFWLHv/RcvpAJwgie4uQ36dx6NRaQRnK8bYsQYR8ME2pYyhY8ifTbobibC9Qqj054xOU9LfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2n2ro/ZnahhmqvTCp+7mpMyunYhXxDlNAWQDQCnCJY=;
 b=VosL7DkVcpPBL8Di2YxSG2dETuAixeaMqrFk7FU9CRwr5sl1jcKhz/ncNrTwftK0bIrGxlI5zATcZ+WMXoJOBAjxG+CI3msUx7wfgAiplI8Gz88fALI2NiDHWSVEWjHR0xlOXvIxxTFBTGEsmNYmhwo2njMjFYaFemjKgG3uJkxliiZiXqePFj1bppeCZv4zE/NFaFUnMyvhQdsZZYNafji9gO827Z4fq+MqlBBhhZRdbZsM5VMSpMeYMWx70WNd8n6j0g8R6ReTbzACAJzyVYa/XtbTLYgeDvvXN8dFIJrWxsr1GC9w1Mx56Ihs++F6bzTi9TyjX2x7Q5hcqYgNKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2n2ro/ZnahhmqvTCp+7mpMyunYhXxDlNAWQDQCnCJY=;
 b=hQ8fEQqmvwfeHl9f+EiaKQ52oGmlWv7isM7E7F0l1WcgEH1sZFm1WdSUEK5MFRjhRKZGJUf9PzhhFzlnIzAl1FOmVe0YtmiNmCqMqERcaauNHa3ML1c5uObC/IsqwMCy57Y/zYotDuQXraZITqK3xb7EEqHUXX2u2Utt3jlHURw=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB0892.namprd21.prod.outlook.com (2603:10b6:302:10::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.7; Sun, 27 Sep
 2020 00:10:47 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.028; Sun, 27 Sep 2020
 00:10:47 +0000
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
Subject: RE: [PATCH v4 08/11] Input: hyperv-keyboard: Use VMBUS_RING_SIZE()
 for ringbuffer sizes
Thread-Topic: [PATCH v4 08/11] Input: hyperv-keyboard: Use VMBUS_RING_SIZE()
 for ringbuffer sizes
Thread-Index: AQHWi9xgXwrIsiJPAUmuyIEnmBPQ+ql7rSJg
Date:   Sun, 27 Sep 2020 00:10:47 +0000
Message-ID: <MW2PR2101MB105277B76109C6C25654E077D7340@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
 <20200916034817.30282-9-boqun.feng@gmail.com>
In-Reply-To: <20200916034817.30282-9-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-27T00:10:45Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d8474ca5-0737-456b-b901-55bd3b42cb3b;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5c6c1ee6-5e39-4f0e-849e-08d86279c921
x-ms-traffictypediagnostic: MW2PR2101MB0892:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB0892918A4EF9CEA614A8DF5DD7340@MW2PR2101MB0892.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z1vz5cAqtcwM5bWUoDx7ydeYqWfECasw4lz0F6BHoYGfiABohezEl1N/Eomogn16GHKAPXRthKdtbZC4KZ8oA8V1RRxMJKy++APlvcSEVQWx7dC70cZtmbq+BmL60/4VqfRUWNTNRXumjhVfeHCTEFSfK0kIhW5tnPy/xAT5na6aHlTlisukN5NWdFIoSYdEr0rhyIBaEeQW72dchoovPeP+/jqAvDdqgvhjNzaQpx0HRE6A1R8OqbDow4VM2UYy8I8YSAvyZEj5KE0OFXtjml9MboH51As/gnSVn8c+8aB52B9NZkrup/R9r+4rqwiaGFtnJPgd8K8+nkmkH/MLY4BKILZLlPcscM/RmBeeE32gJYPe4+WjaHUJnsBQHwRppC++CeE3o9xeXDWduzgfrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(7696005)(110136005)(82950400001)(186003)(7416002)(6506007)(8936002)(478600001)(26005)(8676002)(966005)(54906003)(10290500003)(9686003)(8990500004)(55016002)(2906002)(4326008)(66446008)(316002)(52536014)(86362001)(33656002)(5660300002)(76116006)(71200400001)(66946007)(83380400001)(66556008)(82960400001)(64756008)(83080400001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +Wm0Jsb4BBsOws+osESQIuhmug808eJQ3W3Qa3jxydWZXxrH/ZTDhh7Q1g3ehXoNpAX7creyCCwtQNBYMRQX6Ts772QQllKd0LRVdUoEOo5ARGIoEt0wgyXZFCGIkF14xrCsP12kvuFbhOaddsa6GQmMxGWvjCfcW7gmoeESL26b8o87kX+0ApTuAHrGbYJdFLGBvq0x/JUFNti3Rd5FhLeClVt9b9BSJ0bSUEix3JGQwmV0YOFBmIRDULL1HrhF98Dx5gsMNPH6Cz+RQOb8fmWY5XsZcR2eg5nb86ujXH6CjXWvpu7Tl9+n04YbeZDovfN4FniHQSX32BWEW35VVO5zEJWSkW2FLoExKx7/E2zcVwjtzDV6VuowHO2vwA7S444JMNMuFPq9sQF0qBWaE3/AWb3gJ7oFQMf9lgc4GkR0/YJmARh5uUb0G+oXsf0CSl7x1iyv12Ud5EWuq50ekJ8b1ng6milFUMvJMNLYuwVVAceYCZqG5CRYacQWfDb6AMlk0dGOgRGW9Sp2SQqBOrL8rJcrS7ujCacqTgqR4QydOdv3nD3vXNr/R25DB23STRqqrFgzccENiimL9SXNGqubleQWA12OGoN0Onti1+6GhyU/VEPahaBnMJxRC9vxbDIyl1juIVdeahPOfo8e3Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c6c1ee6-5e39-4f0e-849e-08d86279c921
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2020 00:10:47.7017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EjagVTP458dWQk2I5/crZvHAUrsPE7WLKz9ZxJAH3uLvSF4FttBskyqAkBg3udxOMjq2ohVHn9ZKg743vappswrTdnVUZHJw5ZJ/70mGFCw=
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
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> Michael and Dmitry,
>=20
> I change the code because of a problem I found:
>=20
> 	https://lore.kernel.org/lkml/20200914084600.GA45838@debian-boqun.qqnc3lr=
jykvubdpftowmye0fmh.lx.internal.cloudapp.net/
>=20
> , so I drop your Reviewed-by or Acked-by tag. If the update version
> looks good to you, may I add your tag again? Thanks in advance, and
> apologies for the inconvenience.
>=20
> Regards,
> Boqun
>=20
>  drivers/input/serio/hyperv-keyboard.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/=
hyperv-keyboard.c
> index df4e9f6f4529..1a7b72a9016d 100644
> --- a/drivers/input/serio/hyperv-keyboard.c
> +++ b/drivers/input/serio/hyperv-keyboard.c
> @@ -75,8 +75,8 @@ struct synth_kbd_keystroke {
>=20
>  #define HK_MAXIMUM_MESSAGE_SIZE 256
>=20
> -#define KBD_VSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
> -#define KBD_VSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
> +#define KBD_VSC_SEND_RING_BUFFER_SIZE	VMBUS_RING_SIZE(36 * 1024)
> +#define KBD_VSC_RECV_RING_BUFFER_SIZE	VMBUS_RING_SIZE(36 * 1024)
>=20
>  #define XTKBD_EMUL0     0xe0
>  #define XTKBD_EMUL1     0xe1
> --
> 2.28.0

Reviewed-by:  Michael Kelley <mikelley@microsoft.com>

