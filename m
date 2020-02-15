Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0E715FEF2
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 16:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgBOPUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 10:20:12 -0500
Received: from mail-eopbgr680133.outbound.protection.outlook.com ([40.107.68.133]:21316
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726131AbgBOPUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 10:20:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxmLgdfveWq7OcZ1OkhN37Q+XoT+pb42Sd7rccsSb278e+qRU2UhlDQAbbN65Dq0i4vJuSykpr5dUyP8n+FJ1aj6zCMAtYMpMSvfGcBLdn6AtpQTA7L3h/Y0CsAKbiZoUW+1Exk7VMj33co2MPOp6iFpp6wmg+tz9K8M6XdZWtr1IhjWolihUuYyKna113dLQU2GCnNZNmCo5q31JJWF96EO4H/rlAzoEi9MCTFYPhJ/uMHQn0Z7vvtGaZGqfEz+sAdlz+B4Rc3YzAxH6KT5dJBKMHu9XfflTjK2b4kqRW2um/UkVroePc0c+bawzvRaR3shtgMUn54xlBh1I2Olkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoSfqgB+Smdrkn931Vkg/pFlrj1SwYgqMquO397tQRo=;
 b=UeyRR1tWM6IrCx1gg8EeCKdisnvbxQFd/GIrH3NmMemBc7vgboTntZGtpTrw/Yjt5Ssiz90XxRm/5TZ5HYqd6ykrly4KjH4QuAprrwO9jt7mB9gzc74Z24MvD3+3mtcdgxcJyL4Dv957L0TyJCjYhCGJ0yXBy8Jtw4ayKjk9aDcsl74nGP2mZ1S4/fRgg4NdXiMCxXgDIa9sOZ0TRsSQuSn2N/RmfWkszNwUz8em9zhSpu0D8078kE66mzfpOirgGGqnF0dJ6A7sGH/6YrCFVBu0LdF2egJvcpoYqqVb0SpXPndGfVi9eCWuPRcqoimER6NPzj//dh5JHAsN3WDLQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoSfqgB+Smdrkn931Vkg/pFlrj1SwYgqMquO397tQRo=;
 b=TYY9UZnIsIgdYEHAUwDqYY9t1guKwEYeWGeDsztCCzGMY/nETN9//YCveofsEvruk8h9iy4v8uXUD6w9NDgGtIZzYFqIHfPmoXoNXWehlGjj73ELdcJLH/14z8hFxErNzTjKbK0DkOExDUhZB55aGRSp33af/lC08a5ppf9K+Qc=
Received: from MN2PR21MB1437.namprd21.prod.outlook.com (20.180.26.10) by
 MN2PR21MB1296.namprd21.prod.outlook.com (20.179.21.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.3; Sat, 15 Feb 2020 15:20:08 +0000
Received: from MN2PR21MB1437.namprd21.prod.outlook.com
 ([fe80::8d80:65c8:8df6:b6f6]) by MN2PR21MB1437.namprd21.prod.outlook.com
 ([fe80::8d80:65c8:8df6:b6f6%6]) with mapi id 15.20.2729.010; Sat, 15 Feb 2020
 15:20:08 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: Is it safe for a NIC driver to use all the 48 bytes of skb->cb?
Thread-Topic: Is it safe for a NIC driver to use all the 48 bytes of skb->cb?
Thread-Index: AdXjukH6tGicVKR8QjWZ+wsQCSffGwAV8b7g
Date:   Sat, 15 Feb 2020 15:20:08 +0000
Message-ID: <MN2PR21MB1437345219FA1CC3A75B9875CA140@MN2PR21MB1437.namprd21.prod.outlook.com>
References: <HK0P153MB0148311C48144413792A0FBEBF140@HK0P153MB0148.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <HK0P153MB0148311C48144413792A0FBEBF140@HK0P153MB0148.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-02-15T05:23:53.1818868Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0bdb99fb-ade9-4625-91de-e48aae6b21ec;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: afc6c0ee-5b35-4ace-985e-08d7b22a8acc
x-ms-traffictypediagnostic: MN2PR21MB1296:|MN2PR21MB1296:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB1296578F07F8988864CBB15CCA140@MN2PR21MB1296.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03142412E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(396003)(366004)(136003)(376002)(199004)(189003)(66946007)(66556008)(64756008)(66476007)(66446008)(76116006)(86362001)(110136005)(316002)(478600001)(9686003)(33656002)(4326008)(2906002)(8990500004)(26005)(186003)(81156014)(10290500003)(81166006)(6506007)(7696005)(53546011)(5660300002)(55016002)(71200400001)(8936002)(52536014)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1296;H:MN2PR21MB1437.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LY+xpsDiA265HLZB9iYhDGOTz9L4Ss3VkLVJW6Ml8fDhNBRfby93na2bnPfkgfvNnmm6q+88JgLSgHgXm1oAuqm1C8QRpy60naL9jjZkkaXXbN7NC/KCl0zUN1eYWiiPTZjedn8pDXTJqUuq5A+aADGKKta4z9GSUparg6TKOXprn3Lm4M1t7LkYl8i346SWxJoUm4Puxy2GqdlIPYrcHtEkXl+l+vZSQakXxyeWOPvGhsserlZBCFJpFe4L6ql8+p1ZBhcYrj0rZX6V+Xqft0f02IfLSmFOXkRsapXCFF6GIrLl3l7+N46AdoNpoIgTylMg0qRaGzyR6UP8YBC2um+M0apEOWG1qAMYuPdNr4GMgTOx0N9c1imtqlUNMkvYKa0UBbG8lKgwXrFRDOjnuXQaY1VAeKMMZ8hFrX+yQdzVVp8mWTSGUa6vaW1ZHsen
x-ms-exchange-antispam-messagedata: KBeovyE8m99YMsZlCeorMjrCKN2KM0uGsOkFYgyVAw5X98TCQdPL0ljcugNbBgsnNAQVAb7FBNExqwZ//E3GqCTeODgRS/45aK+178xuq44h++bsj8zH7ng4fSWNODgpmgf5pxJBaVJQFXXuXOy5tQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afc6c0ee-5b35-4ace-985e-08d7b22a8acc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2020 15:20:08.1865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rXxZuOEgbh5MGisrkermZxeYAv5tj/2dtO8gdusMKN0te/0uxFD9SPfa/oSM5h9+0bTarffj4HX7BWyomM6S9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Saturday, February 15, 2020 12:24 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; David S. Miller <davem@davemloft.net>;
> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; linux-
> kernel@vger.kernel.org
> Cc: linux-hyperv@vger.kernel.org
> Subject: Is it safe for a NIC driver to use all the 48 bytes of skb->cb?
>=20
> Hi,
> It looks all the layers of drivers among the network stack can use the 48=
-byte
> skb->cb array. Is there any rule how they should coordinate with each oth=
er?
>=20
> I noticed the last 16 bytes are used by struct skb_gso_cb:
>=20
> include/linux/skbuff.h:
> struct skb_gso_cb {
>         union {
>                 int     mac_offset;
>                 int     data_offset;
>         };
>         int     encap_level;
>         __wsum  csum;
>         __u16   csum_start;
> };
> #define SKB_SGO_CB_OFFSET       32
> #define SKB_GSO_CB(skb) ((struct skb_gso_cb *)((skb)->cb +
> SKB_SGO_CB_OFFSET))
>=20
> Does this mean a low level NIC driver (e.g. hv_netvsc) should only use th=
e first
> 32 bytes? What if the upper layer network stack starts to take up more sp=
ace in
> the future?

According to the comments in skbuff.h below, it is the responsibility of th=
e owning
layer to make a SKB clone, if it wants to keep the data across layers. So, =
every layer
can still use all of the 48 bytes.

        /*
         * This is the control buffer. It is free to use for every
         * layer. Please put your private variables there. If you
         * want to keep them across layers you have to do a skb_clone()
         * first. This is owned by whoever has the skb queued ATM.
         */
        char                    cb[48] __aligned(8);

> Now hv_netvsc assumes it can use all of the 48-bytes, though it uses only
> 20 bytes, but just in case the struct hv_netvsc_packet grows to >32 bytes=
 in the
> future, should we change the BUILD_BUG_ON() in netvsc_start_xmit() to
> BUILD_BUG_ON(sizeof(struct hv_netvsc_packet) > SKB_SGO_CB_OFFSET); ?

Based on the explanation above, the existing hv_netvsc code is correct.

Thanks,
- Haiyang
