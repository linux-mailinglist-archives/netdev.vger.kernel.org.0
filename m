Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723A442C05B
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 14:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbhJMMqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 08:46:20 -0400
Received: from mail-oln040093003013.outbound.protection.outlook.com ([40.93.3.13]:54991
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231330AbhJMMqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 08:46:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaQPr+mV1N8qHczOlAo2XCBsccgdZO6AvLgbJ3RqbIiX0mwbzp+Mfd46q9lzAyG27Fmgy4iqrFKnQOaxe1W/ePBt9Lya6/PmQYdWK7aVEwntah+VOFn48tbLIrdwkmo40Q6T0v24HaCHkwFR4XGKtdhfdebxwO8mW2Kf8E8zhiOo4bBylPeK4Di/ou9r3meK7Gyt4i18jZXsfqZucMAvxK8wH12oAso2h+c2vxR2g6luJzrNBS19iEFwZB0mL5IiMJAAJm3xuIHfTbav/kGRCnG4+f0lkBW3OwZWYCVvCPauOqP60EE73dAJxg8CRZXYKhaNaSIBMHkE04k0JeDPzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CSZlphN2Ou1yqM3oJB+jK4FtQv0kEt+ihgkxNDdv9dw=;
 b=mOEJmkhh5W3i6DoshTPIWWkQUiICZvDBd+D8apFtI4DcYf+apScH6v3oYjKOwIRNTIsPvP/Qt38vAT1zUPnWWGZ7K8iKPQfxmbazvvzs/fy0vspqPlQMomK9YcIYggMb/0FAmACuyWxtz4Mi0gwFdBdekmC6pZWbrracCltdExt0db8F1PPATeMfrY7MG4Bl4g4Mq7G9Fyv69LctRHpjnKlc+39Y3cqqCoK+7m6oXJjWJSmEBD154+42FE+mITrVCVFxbPhkiu3PL/OpiVS8wcs0srewfS/dV+t4Ss7qzUjvK9eTDcNCubZ/qkscQwflPqOZErQol8WOwCl5dtSqkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CSZlphN2Ou1yqM3oJB+jK4FtQv0kEt+ihgkxNDdv9dw=;
 b=Qms+slOU01t0bFYaIPZLvIY9CR4eN9Fr27WxRdf9uYaigyBqP8D54fBMU8Leb+EgNDWtlULgnY/T1JpRRAHb/bOfCehIrTs2tUsuS8LcJV0tdZOarsqXtq9hS4gI4v/9pawaLFNrPrzA3qd+RPMjOkbSOGd4N58ADHz8+7xTtpM=
Received: from MW2SPR01MB07.namprd21.prod.outlook.com (2603:10b6:302:a::17) by
 MN2PR21MB1232.namprd21.prod.outlook.com (2603:10b6:208:3b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.3; Wed, 13 Oct 2021 12:44:12 +0000
Received: from MW2SPR01MB07.namprd21.prod.outlook.com
 ([fe80::c8ac:aa63:8f5e:cf1c]) by MW2SPR01MB07.namprd21.prod.outlook.com
 ([fe80::c8ac:aa63:8f5e:cf1c%3]) with mapi id 15.20.4628.008; Wed, 13 Oct 2021
 12:44:11 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH] hv_netvsc: Fix potentionally overflow in
 netvsc_xdp_xmit()
Thread-Topic: [PATCH] hv_netvsc: Fix potentionally overflow in
 netvsc_xdp_xmit()
Thread-Index: AQHXv98bUqltCWSfmk+wm+1khQrFQqvQ3c7w
Date:   Wed, 13 Oct 2021 12:44:11 +0000
Message-ID: <MW2SPR01MB07B9C0C7ABCE2F81950BAACAB79@MW2SPR01MB07.namprd21.prod.outlook.com>
References: <1634094275-1773464-1-git-send-email-jiasheng@iscas.ac.cn>
In-Reply-To: <1634094275-1773464-1-git-send-email-jiasheng@iscas.ac.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d5802a60-9755-4f0f-b69f-5c2aa1d6c3a9;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-13T12:35:16Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 235b5505-9e76-4239-a15b-08d98e472845
x-ms-traffictypediagnostic: MN2PR21MB1232:
x-microsoft-antispam-prvs: <MN2PR21MB1232AA1161A8EEC868940CCDCAB79@MN2PR21MB1232.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7nK9U5kPhfbYyA6cIGt8lcPtbZICfNguE43k3PBPfgaUhNgSaYY7jjJcG2AGVECnu4OrwzTlODQuKfU6wSNb763LQ5p2Iq18nDpsaqdltDHCVIIZOH6LQEiemdMzwmVkpTznq2ctouE9tMOF6OI6jh8sRtEmSDnw4U3m79HLxjJto8Tpf0cqeWZKmiqWI0Yd1V9lViyZQrDblAJ/EcZnf3JxG9BY/8+xQsMugtOutYvKHayCpqMisHbryFEOo+1cO+WXeBjwC769GteCe1Yj5NfPE8BrR+a/ERsSdaya1r72gi9wFSkM5ZFAuRsLiTLJHE9z/qBna915Z11URwN08oj8qiDOYDyoLMWETofaSWwgNRsRrN7ilt5v7vb7xVnYMeaQLH7MiR4zjFXN96gjG5x+hf6jl4Vc6lp+NMN/caASNEHiFqL/nmMye9i6MugsgN9+tPnj7YGfT+wmP+RQMhwuqnxTkdClN9kgErEdHYPyLU1ilDd1fTAk5nS4BqEiCWJj/CrX2gh2tkZ2A6a6wwl/jhXfOXCemTX4BtTh98ufzp5l8leuEpSrQmgbBIhgTEkC5lswbeVWL4YyvVtEIwUzsfNUXQ54XdrInS+hE/dKRetwZAbchrv2NUlIQxw/S9DUKP357mHb19+tHGAWUBsQTySKt2t5YDVmrtmnOHQM9mLLf9uLSCMaKWSBsdedjCnx708HV5rdOk8zFoaw9MKeP5n+iWlClCXxkWHNMGcVgCmB1ziCXpzIFaF2DJucqQM4lFxOJoNOtUyeByyoxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2SPR01MB07.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(921005)(9686003)(38100700002)(82950400001)(2906002)(186003)(66556008)(7416002)(4326008)(83380400001)(52536014)(82960400001)(54906003)(110136005)(33656002)(55016002)(122000001)(6506007)(8676002)(66946007)(64756008)(53546011)(316002)(8990500004)(10290500003)(71200400001)(66446008)(966005)(26005)(38070700005)(8936002)(76116006)(86362001)(7696005)(5660300002)(66476007)(10090945008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Rmt8Gx4JFP0E4tl2K99oMkPl4peD7EY1FgRdzt9DHC2fkD+4iBGG4W4/3Zez?=
 =?us-ascii?Q?MxbM/ybXZCUzm8DTfz8Sh5GH8e13GiiSvLsyvvFI6iFq9pGmfzKRh3ivXzST?=
 =?us-ascii?Q?5Zt1ls2aOS3I+5jFNjvVzgj+8/K7VJbZgWkDOGptFPEEyx5i4CqvAYcbJ+KJ?=
 =?us-ascii?Q?KNJXl7Vq14mYUeVKV0dK8UaupYZnEuBOjs+a85drhUYlnzkuCu8hDfXfWtGT?=
 =?us-ascii?Q?/bZbv2vKXQWYZ3piS9jTglc/CgRcUfDiSXLnPYuf470i628fcnE28aDEui0T?=
 =?us-ascii?Q?hZmAejbr61Gg1SJ4mnA6rFhamN3r+R2d93GfembQVfKfcsjqEms3ZrlmV6KK?=
 =?us-ascii?Q?i5GsQ/U/E5DVU8uMbZawZJS25aNwZBhQ5vLlACM3nHdAOd0G/jnPBMbJFi9Y?=
 =?us-ascii?Q?OPZzdjD6RhYR80NfBP4u4cqIuceBBuNXxxh5I30FHlshyaZgz/r2S6Veh7Xr?=
 =?us-ascii?Q?GbjkxTRtXdjsxcZPAThz3c83W1U2cm78IQfn2wkgn9Ue/Nr9gIqsHG/jZp4h?=
 =?us-ascii?Q?R7X2m6YZqhxtyQ+BY4+t5jK/gOmjOUYbX8sW+lx986u5KgxuJ3POnyLHmPgF?=
 =?us-ascii?Q?RN5kbj8TrUNOu0H+8brixO9qKr8iPdWckPQt5lg6whtZbs8712uuSkPX+sfW?=
 =?us-ascii?Q?3pIIYf7kHq7kHlserdf3fSpWN6SVZ+BPOUPuM+puMzL1bZUpe1JJYPMN8e9g?=
 =?us-ascii?Q?OW+J0pBXPp4e247Tf71BzkVWDns6tlyRXSvfFj94C4WoaHnSaUd5PDfZFrjV?=
 =?us-ascii?Q?pxwAWeWk60povg2Y56/hE7/5UEzeYFx2QY3N00v7JNZ+Nfng0ba0YBt0k5j+?=
 =?us-ascii?Q?7fzu0h0eij+SwwuiLovxHlmSkty2dgcE1kcD/JXKinT8z2R1Xy1hm6WZytqT?=
 =?us-ascii?Q?Axp0FG01x+eyc/ZU0y16dKasb/UOapxdZMpu/0Y2m/00VkQtQ19TAY4sxKix?=
 =?us-ascii?Q?BswFC93NHoV7hR/TF7W4d1+rWPPQd5s7aPZiMvE5SQAjQo6osidiPyFQDLs9?=
 =?us-ascii?Q?rsSHtw+DYJwRFQsocUJVRqYjKjYAn3sJmx4mKyFkvHOivExjz0/kIOYyGFQ/?=
 =?us-ascii?Q?69R0GWjAvtgC+QZgWc/YPluugGOppw1941WLSgu2pvsjzg75WIJwuNDCMqM7?=
 =?us-ascii?Q?EjzlDwHIf9AKItmbctuTceXaBcJO1tZcqlQ3qbzaC8AJvgF3Fe6LGjq+hTgV?=
 =?us-ascii?Q?cV34V44eRWbJ6gRxyya9R/qRO+EQAMVwX3ND54+voskQmTrphtbD5NkZJb94?=
 =?us-ascii?Q?zjBPce5n07qtsgjBvbj9YuiF+tve5aUerSshQbrT5shPysB3MawncjbWOmqI?=
 =?us-ascii?Q?+lRjmYwG/YZuz8zbAPiEw/bIEntUiGKUp9yzq+WKQmUYSwVfIj7GkzyYayij?=
 =?us-ascii?Q?tmaDUYMLG8b0ul4iTIMFVOKWoOp6tQFHnnQJkjNCB+wbPQ9BIEYmUY7zQvwR?=
 =?us-ascii?Q?Jjt0FWCdIhSvHazcnaeOvMtnFR0UrGuGyUp7b7k2kPnmluC7/+V6pg+843K3?=
 =?us-ascii?Q?W5CgsY9M29/Y2G5hG7C4EF0eW4WCdmsmA4pBHZ/33ulj7HMLrbb4GDybrB8/?=
 =?us-ascii?Q?i14l3viKYv2iFgV+0BcEGQZ1wBaKCEwRErvhXTkiKeszo/GFk+69zi2vWatU?=
 =?us-ascii?Q?XA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2SPR01MB07.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 235b5505-9e76-4239-a15b-08d98e472845
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 12:44:11.6651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9S4TqOslIdNp5LsFO+a5cBbSKt1WaqG9Sz+N5WY4IdSM1YRnjDCdipho2F0Mmm0olDMEWbzvfc72IAGbeRcfCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1232
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Sent: Tuesday, October 12, 2021 11:05 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> wei.liu@kernel.org; Dexuan Cui <decui@microsoft.com>;
> davem@davemloft.net; kuba@kernel.org; ast@kernel.org;
> daniel@iogearbox.net; hawk@kernel.org; john.fastabend@gmail.com;
> andrii@kernel.org; kafai@fb.com; songliubraving@fb.com; yhs@fb.com;
> kpsingh@kernel.org
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; bpf@vger.kernel.org; Jiasheng Jiang
> <jiasheng@iscas.ac.cn>
> Subject: [PATCH] hv_netvsc: Fix potentionally overflow in
> netvsc_xdp_xmit()
>=20
> [Some people who received this message don't often get email from
> jiasheng@iscas.ac.cn. Learn why this is important at
> http://aka.ms/LearnAboutSenderIdentification.]
>=20
> Adding skb_rx_queue_recorded() to avoid the value of skb->queue_mapping
> to be 0. Otherwise the return value of skb_get_rx_queue() could be
> MAX_U16
> cause by overflow.
>=20
> Fixes: 351e158 ("hv_netvsc: Add XDP support")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/net/hyperv/netvsc_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/hyperv/netvsc_drv.c
> b/drivers/net/hyperv/netvsc_drv.c
> index f682a55..e51201e 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -807,7 +807,7 @@ static void netvsc_xdp_xmit(struct sk_buff *skb,
> struct net_device *ndev)
>  {
>         int rc;
>=20
> -       skb->queue_mapping =3D skb_get_rx_queue(skb);
> +       skb->queue_mapping =3D skb_rx_queue_recorded(skb) ?
> skb_get_rx_queue(skb) : 0;
>         __skb_push(skb, ETH_HLEN);
>=20

netvsc_xdp_xmit() is only called from netvsc_recv_callback()=20
and after skb_record_rx_queue(skb, q_idx) is called:

        skb_record_rx_queue(skb, q_idx);

	  ......

        if (act =3D=3D XDP_TX) {
                netvsc_xdp_xmit(skb, net);
                return NVSP_STAT_SUCCESS;
        }

So the existing code doesn't need this patch.

To avoid future misusing of netvsc_xdp_xmit() in other places, you
may just add a comment -- "This function should only be called=20
after skb_record_rx_queue()".

Thanks,

- Haiyang

