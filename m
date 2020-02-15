Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2539215FF9A
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 19:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgBOSEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 13:04:23 -0500
Received: from mail-eopbgr1310112.outbound.protection.outlook.com ([40.107.131.112]:45632
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726299AbgBOSEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 13:04:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gODo6Eg2bOczH3ZnCUVnAocLODBLwtdP25rav1sL8ZB0CPoJ3XKPdUO8qfdiqiUcCQccQ/w7rv8LP6sRj8Y/iaFL6JL6ePbWeS6FooryjxexSTaSDgcOMsp4PyCpzM1rC1dfTv7IT/hn1mHScz+j0pLHDPGwWyebvej9ILHFAaljGOzS35jwfK5ae0/uH1qJb9rDbwnMrmFfRvrUcvPjtUudVxvnIK7eDqYQyHymKtSLPBtm9E1+V1Z5YXPpvB61qbjGe0BLO/gZCpJgkiIk4us3kIJOtFChOwrNNTS0lrirHQErAx4Ap/pwQk0+RDLld8w40sO9d3cFGq+bnLw0jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IQ09c0TtSv91JazQv6A1MqL2/rQKaRFLkeXrHvLjJY=;
 b=mf/2NMRtvdNvvhERzmaMfsg1yQiUlCoAsw2mc5vDGWMo/ehba91CHtY27phkVHG3G6I+SR5NBVCOL5L6CjZ0ioNyN6vxLmrY/4m3qq2NG5+jDNl+9zpiHlRTkCt6AtobfFCCAWHQ/1NBzStZ8zbLC9belbogyBYj/hH53omehxKOaSeGtgoUlsCIsxSCiWotCjtFYjPMc1/jCLGzD6V/6k3GMpiNyDIp5yuH8VKGOQyY7Was+x/p605Y9r+JRsF12MhYNnjhj/6Rv6MwXy8FATzq0X6BAE+p9xd9CHo6WZNjRMCH24aPaLTQG9DAJylJJ14IDQw4URfTayeT0wEslw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IQ09c0TtSv91JazQv6A1MqL2/rQKaRFLkeXrHvLjJY=;
 b=BE9oqbOYOzytTzmMOffYV9wLFy9bRFOH/Yi+VSeEhrv7dxJn96oIMVWU9ONrUOTt9CXt+Xl9lpORnZriCj7jZGkk0SMVI66Uss+ZADS+eEOLKO7uIqtdYTANTK08RAaYRg7IbdN+PdPW+4aq0ifFDk8pmYQpmklWfqQvSctxse8=
Received: from HK0P153MB0148.APCP153.PROD.OUTLOOK.COM (52.133.156.139) by
 HK0P153MB0242.APCP153.PROD.OUTLOOK.COM (10.255.253.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.4; Sat, 15 Feb 2020 18:04:14 +0000
Received: from HK0P153MB0148.APCP153.PROD.OUTLOOK.COM
 ([fe80::58ea:c6ae:4ea3:8432]) by HK0P153MB0148.APCP153.PROD.OUTLOOK.COM
 ([fe80::58ea:c6ae:4ea3:8432%5]) with mapi id 15.20.2750.014; Sat, 15 Feb 2020
 18:04:13 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: Is it safe for a NIC driver to use all the 48 bytes of skb->cb?
Thread-Topic: Is it safe for a NIC driver to use all the 48 bytes of skb->cb?
Thread-Index: AdXjukH6tGicVKR8QjWZ+wsQCSffGwAV8b7gAAVVXhA=
Date:   Sat, 15 Feb 2020 18:04:13 +0000
Message-ID: <HK0P153MB0148861FD9AAB88A98084206BF140@HK0P153MB0148.APCP153.PROD.OUTLOOK.COM>
References: <HK0P153MB0148311C48144413792A0FBEBF140@HK0P153MB0148.APCP153.PROD.OUTLOOK.COM>
 <MN2PR21MB1437345219FA1CC3A75B9875CA140@MN2PR21MB1437.namprd21.prod.outlook.com>
In-Reply-To: <MN2PR21MB1437345219FA1CC3A75B9875CA140@MN2PR21MB1437.namprd21.prod.outlook.com>
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
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:7f70:6019:e41b:6ca1:9563]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9080d85c-e669-4b44-c2ec-08d7b2417725
x-ms-traffictypediagnostic: HK0P153MB0242:|HK0P153MB0242:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HK0P153MB02427222D06ACA326601D36BBF140@HK0P153MB0242.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03142412E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(189003)(199004)(55016002)(8676002)(10290500003)(9686003)(76116006)(6506007)(5660300002)(66946007)(33656002)(52536014)(81156014)(81166006)(86362001)(66476007)(64756008)(66446008)(186003)(478600001)(71200400001)(66556008)(8990500004)(53546011)(110136005)(4326008)(8936002)(7696005)(316002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:HK0P153MB0242;H:HK0P153MB0148.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vjr26dNI5eg04PzDHRJ1YgCrNBhwF5rwSAu95QY47+NSNkQX+vE3JT5pSixCdh5Vft/ch+xn5G4M/a73GcALe58bsdgvozx+YHmEGqmPzRw4suZpuuq132AYK4IBGyrQ874Lf9xppL/77s1jeMFMMOsJD5BVsonIAF5gmk0b1VruxZs47Nj6LhLaNM/vTqdq5VQfDu4PPXUjxHgt6RSJzPak7CzyUnMDFaFwPwf1lG9Or900ss6R7aRjTBSIlAIUaNEdaY8LUfMixZ9ZPU1mIOxl0kHRpf6dIUD/vFKyVa//dEEeGeFXyniZgCQ3WvnksPXfWSWn3H1fbcwhWQxco4xVPCNPIHc+/IXcB5Y1eYMUyyRezOdoJGDrzxsOAR6e3FCUpb/tk93707Di/Zo3RU9uZ1vxxUn9alae/fCeYL3S8OgAFhlXXc4nX8ZHFyaQ
x-ms-exchange-antispam-messagedata: yaJCMWrNI79Pjx2nFrHAkvXDHapOWz6FJTnALxpZ1Q5BBkIGSGrZosJjj3dznQ4wkLTnPZcI7IAW4hlXWhe5uImZPKQFou2XP+anhAbligf1L8RlzmbGrS69ZNGcdOWAGoa2OsBaVZkRALTL1TcPSqaI8SH96so9GhDmfbUCIwCQQoZ0oCIdMdF5SqtCpNQi7FsueakOx9uBMUCMrNw7Bw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9080d85c-e669-4b44-c2ec-08d7b2417725
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2020 18:04:13.3618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D0CJdlMqCDpfVllu7M5GP0YeSkSRUmiKulsMQ0yxdIyJ9YKYFdJc24o1jI/hw4PtwsG52la7wDG7skUEBLzX2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0242
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Haiyang Zhang <haiyangz@microsoft.com>
> Sent: Saturday, February 15, 2020 7:20 AM
> To: Dexuan Cui <decui@microsoft.com>; Stephen Hemminger
>=20
> According to the comments in skbuff.h below, it is the responsibility of =
the
> owning layer to make a SKB clone, if it wants to keep the data across lay=
ers.=20
> So, every layer can still use all of the 48 bytes.
>=20
>         /*
>          * This is the control buffer. It is free to use for every
>          * layer. Please put your private variables there. If you
>          * want to keep them across layers you have to do a skb_clone()
>          * first. This is owned by whoever has the skb queued ATM.
>          */
>         char                    cb[48] __aligned(8);
>=20
> > Now hv_netvsc assumes it can use all of the 48-bytes, though it uses on=
ly
> > 20 bytes, but just in case the struct hv_netvsc_packet grows to >32 byt=
es in
> the
> > future, should we change the BUILD_BUG_ON() in netvsc_start_xmit() to
> > BUILD_BUG_ON(sizeof(struct hv_netvsc_packet) > SKB_SGO_CB_OFFSET); ?
>=20
> Based on the explanation above, the existing hv_netvsc code is correct.
>=20
> Thanks,
> - Haiyang

Got it. So if the upper layer saves something in the cb, it must do a skb_c=
lone()
and pass the new skb to hv_netvsc. hv_netvsc is the lowest layer in the net=
work=20
stack, so it can use all the 48 bytes without calling skb_clone().

BTW, now I happen to have a different question: in netvsc_probe() we have=20
net->needed_headroom =3D RNDIS_AND_PPI_SIZE;
I think this means when the network stack (ARP, IP, ICMP, TCP, UDP,etc) pas=
ses a=20
skb to hv_netvsc, the skb's headroom is increased by an extra size of=20
net->needed_headroom, right? Then in netvsc_xmit(), why do we still need to
call skb_cow_head(skb, RNDIS_AND_PPI_SIZE)? -- this looks unnecessary to me=
?

PS, what does the "cow" here mean? Copy On Write? It looks skb_cow_head()
just copies the data (if necessary) and it has nothing to do with the=20
write-protection in the MMU code.

Thanks,
Dexuan
