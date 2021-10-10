Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC60428033
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 11:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhJJJ1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 05:27:15 -0400
Received: from mail-eopbgr1410111.outbound.protection.outlook.com ([40.107.141.111]:40233
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230370AbhJJJ1M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 05:27:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVIwO/meewXg9myqAcEiSPOizQgPWWPBwvRORiD80w3I1YwcNwlA08qt89or8t4wYrnDdfUElgQHihUEEvvZyzF1lpb/BkEtj+pzmY7oGvBIY4iakJeLOE/FgczVWA8n7Ny2uzo9yrc1EatXiJL5esPm172zqSpkbZkrC8dGBG1MNZ+EfsjdVF3W0+wilGXF4RQiEishWGV094Q/jQR0cIYkCWoCu8gFzUlrvbxMRRBMqPAikoB3i8iJufHZwKTIePwIRX0uvdl+AzAzrFfweJQ9EohRDEB5JXHiOg25hokM9EvYzNPHdB6z8zVhUHB2QxPWY3d3hhp71JxC7yOMrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=riialA0J9fKk34an3ZzfdWn2AUHfkIopOJ4U+1AXKfM=;
 b=RmLhwsbWUnc+vlDmuWnFEXT9PZMTPE7+INtOj2E23AOR1N8FWbjWeUyB5RObiVejkAbrA1Ex1WBj9gDv2OnjSDEOJKhhhVjMANfA5FxzP4aa31qNJD+VGkCElTU6WFQ542CxN77DZJK+8QEIMmdZ9q+WmSGELPa4lt9Okkz0D1PHPQCCp36alQXxyRZVVgxYAodjBv/VfxOGucG6Do8dy0n8Dd8yOhfGgIn9X25ikzjhs3G1wbpNR1xy9LYI2+XCTM4VKhq8Uiuwo6vGnUgbupUfFeelt0XNp2kXlLyJkrJVvLKKIfZYGwgVK7ngQ31looGAsh3P1XAsh7ZynBRhzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=riialA0J9fKk34an3ZzfdWn2AUHfkIopOJ4U+1AXKfM=;
 b=XPgj/t/+Od/KjR+tqdjEvQ9KZ4DhE8jrX05k473KICnmflTsX18mu55KnFD2c49GSxCNpRE/h3AKiZDrXoFEttlU3a5t4ufAAjw1zEbq3+gLJwoKj2IvDeovhZeBKw9IOXg5tuAp+DGBLnbTjEyUtN2E0XM1lhswZO8TRdTJJmc=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB1907.jpnprd01.prod.outlook.com (2603:1096:603:18::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Sun, 10 Oct
 2021 09:25:09 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.025; Sun, 10 Oct 2021
 09:25:09 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH 00/14] Add functional support for Gigabit Ethernet driver
Thread-Topic: [PATCH 00/14] Add functional support for Gigabit Ethernet driver
Thread-Index: AQHXvUEBHULAomfYXUWxvR6NssmBBqvLDP4AgADISoCAAB5vgIAAAUUAgAABfEA=
Date:   Sun, 10 Oct 2021 09:25:09 +0000
Message-ID: <OS0PR01MB5922FA0C0B34CF86286F518686B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
 <ccdd66e0-5d67-905d-a2ff-65ca95d2680a@omp.ru>
 <OS0PR01MB5922B0A86C654401D7B719E086B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <eefb62c7-d200-78d5-9268-d84b75c753c3@omp.ru>
 <6a57ab4e-3681-6a47-c47b-fd7ad022d239@omp.ru>
In-Reply-To: <6a57ab4e-3681-6a47-c47b-fd7ad022d239@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2dd0a92c-1379-4ca6-7d4d-08d98bcfdaef
x-ms-traffictypediagnostic: OSAPR01MB1907:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB1907EA6D63911993655B9FA586B49@OSAPR01MB1907.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PHSfX4I7/+B4YOm7agqphoyikU+Iza6KhxQAkCiy9iPBj7SBgUrZDEDvOyhBPuNPZdbZxr+hN0zhzUG6SH0+O4gG4CTsiUh1wGxrg7Ksi2TB9A/XrY+2PP//SK6ckskMYMTAT8iY/iHxzeo8k2gMIQB/Rw48XGeemq+ZvDBgu+TFbdwtiV67RFeHafBevKN9jaq4FJPq1rUGnutOuMqZafICpl2jnDCcIla0YAq/QAya1A0JOuovBtZb2rXBRCSgGFknxAfAt1KlNfpfcsjRw4YTYpjlbLJ6NgCjIGV/KyAUc5U3WM8CoxObrW4tQrJ+9UhExG5qk9OW99qzDYUrwrE83jJS2rorAa+Tpl6Mx6djoxZNfF7sg9spcEIKzTh5GX2uJGd/txt9C4obrFopNsCWn40p0IXU/r/57/NrxFdd35EmMbRBkPKXwbgZ0/+CoNPrBeva4f+wn67mj8H26bxK9KiO1fRqm8ij4lziGbMIqfEGaOb3IgKGeHwMZhWBSj4Y1p+KuFC2gpyA2D7cdoa10/Yd1l0+j0J1Of0PZtWypT7vZqdQceIeBEVeSxLsK4NiYkuM/bFI92AJw8v5xeA1A9MhWJan+a+hzxPRGOPTidMdSb7kLGYAd8Xj9dFLkROzyw3fRM/WbqZDP200DKPPlege78A0HpZ0L1SxKCD5frjqF66Qic4bUqrtUVtU2sjbM7P0V5tVaM3CmycObf2XWFxeHybD7f0ej2kyXj0krJupwLX8BvH0tQtFkYAbWqgZnWwqalHHOrL4H+r0vs7GPhgCnw/3PHO2YGOCZA0SAbaoJcwCgpT5bVTqi7/7OCewD6Z3ME0Fe0FudCfsDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(7696005)(83380400001)(6506007)(53546011)(8676002)(5660300002)(4326008)(38070700005)(966005)(55016002)(45080400002)(186003)(316002)(52536014)(38100700002)(107886003)(76116006)(26005)(86362001)(66556008)(33656002)(66446008)(66476007)(64756008)(508600001)(122000001)(54906003)(66946007)(71200400001)(2906002)(110136005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?omSaI7ii4WovcW01dNc/wgLUlcAdSYkdEzmW0TOCoXbfiud0MoWGr843Ls?=
 =?iso-8859-1?Q?nU74nuP641+4w4wbQ+ftjFkRZKPDJOFQkPYHQPWyN9ilfezdkcSA4fw2xl?=
 =?iso-8859-1?Q?o5pexENsnb1pKefw6AR78wmyIiIRClVKj+/ae3oLGJduQsXuySmpDRr+Hj?=
 =?iso-8859-1?Q?BaayxRar9HNizaS7N2wCZqeID3v4vdLE/GRpE6iD2hmPmdf2fw9cb3uOny?=
 =?iso-8859-1?Q?zTUbVu3CFNnqljfj81jdIjZVRXejKoMSgmjPBKo7M/v9aqlWwjVDl1sYG6?=
 =?iso-8859-1?Q?8llxmFS8sy/9XPtY7RPuFRHPdFNlQu7BIcQjS8UMvaXKGEqTKNgZZlYA/F?=
 =?iso-8859-1?Q?1t7D6GyoyAP9b5VrDClX4S1uue/8sE9WqqQ2cFqoirzWqihwckbleLUAyK?=
 =?iso-8859-1?Q?NPQxoCWhKMiTdvR06274B99cdwoOcasHbujwnhQFdcOZB6bvsN8W8HhgpT?=
 =?iso-8859-1?Q?3FYGABvVzSLVvcrja8eo3vk96W/OiOb0mRgLoezoW5LqHNUKwAA3gfuez6?=
 =?iso-8859-1?Q?xLtdh3qS1PuqkpiljMXdGg+VyT7dPmAItysaqnf4MWk8pEJ45VrUC1vUPT?=
 =?iso-8859-1?Q?7FXSXJSZlQmQT1oMDO98bTk4WkvpdZD9fPeiGiElL+MivAhy2yq6PvLJ3a?=
 =?iso-8859-1?Q?yJtlhFCsEGQnr1BpHVEOYxfM/psV6fBLaKneMJEoCJvFefJb1g4huH7UFo?=
 =?iso-8859-1?Q?lSN8P01QOJ9B7Vw5ndkfevCJfssYNTOPKehBCfB8V9f3xmXQDXhNzjTfvN?=
 =?iso-8859-1?Q?m4c1BPGhVM/+rHugXPYZHIVojz1OS7gDpvzJ3keevSDljERT/6Wlt9sCwy?=
 =?iso-8859-1?Q?MkGNQfIBnDzgX5Iyy9SQ1zgbPFUfohzV1gHlJmr1mXPPSJmVlQHYx+QHlW?=
 =?iso-8859-1?Q?CeJU/lBqkOoY3zh66WD9II6rG21dbWaRrSN6f3m/1yrqmHANjhNxttSu26?=
 =?iso-8859-1?Q?iQTVeyBLGTnjJWEcTavSaBD6UuReLT3Il3+HLUVVpAHKB+LrqZwM1AUvf4?=
 =?iso-8859-1?Q?F1VgTN38iww0mILeHYV0oT1yW89e2LOR9fk8dttlv/OSvx+8TreaRbS5Nt?=
 =?iso-8859-1?Q?nw6XAcAkP/IYrHW+YDnqi454wrYzID/e19OLAnD3G0PgqA3QevdtM/4S8y?=
 =?iso-8859-1?Q?tQxkhFhHz7b8zRP1++XHvPy3B1Wqq4Wn9AzQfPG3U6a+4jePmlGbZaescE?=
 =?iso-8859-1?Q?Dpf7chs/BZ3zcXBqV5WZp4GrY52Hb3+rWLwB+F0OpLWZ5svhNoYJJqc/kU?=
 =?iso-8859-1?Q?0MfHNIUXhjTweqn9BI0lxyJtq0uf+TYwGKOVTTeP+h8V1OcUqG4enfN+3i?=
 =?iso-8859-1?Q?iRifWutp6RuLvdIlOtmfDv2nIwbSDIZ3j883T0VDt4hceWs=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd0a92c-1379-4ca6-7d4d-08d98bcfdaef
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2021 09:25:09.2227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LlYMBqCObf5Zd+P9wkIXAO2gP3KiDurDd3Ofn8XQHBUVMzzAlqyKrQ/aCcsXiEqC2XSkCqKST4FuTOV1FWD2HCC1fxbrLEd3YDV+H3lyM1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1907
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

> Subject: Re: [PATCH 00/14] Add functional support for Gigabit Ethernet
> driver
>=20
> On 10.10.2021 12:13, Sergey Shtylyov wrote:
>=20
> [...]
> >>>> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC
> >>>> are similar to the R-Car Ethernet AVB IP.
> >>>>
> >>>> The Gigabit Ethernet IP consists of Ethernet controller (E-MAC),
> >>>> Internal TCP/IP Offload Engine (TOE)=A0 and Dedicated Direct memory
> >>>> access controller (DMAC).
> >>>>
> >>>> With a few changes in the driver we can support both IPs.
> >>>>
> >>>> This patch series is aims to add functional support for Gigabit
> >>>> Ethernet driver by filling all the stubs except set_features.
> >>>>
> >>>> set_feature patch will send as separate RFC patch along with
> >>>> rx_checksum patch, as it needs detailed discussion related to HW
> >>> checksum.
> >>>>
> >>>> Ref:-
> >>>>
> >>>> https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2F=
p
> >>>> atc
> >>>> hwork.kernel.org%2Fproject%2Flinux-renesas-soc%2Flist%2F%3Fseries%3
> >>>> D55
> >>>> 7655&amp;data=3D04%7C01%7Cbiju.das.jz%40bp.renesas.com%7C25bc7b9155d=
8
> >>>> 402
> >>>> a191808d98b5ae62f%7C53d82571da1947e49cb4625a166a4a2a%7C0%7C0%7C6376
> >>>> 940
> >>>> 44814904836%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2l
> >>>> uMz
> >>>> IiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DVktj5v0GvrNf%2BD=
N
> >>>> IFs
> >>>> e6xjCUm6OjtzwHvK3q8aG1E5Y%3D&amp;reserved=3D0
> >>>>
> >>>> RFC->V1:
> >>>> =A0 * Removed patch#3 will send it as RFC
> >>>> =A0 * Removed rx_csum functionality from patch#7, will send it as RF=
C
> >>>> =A0 * Renamed "nc_queue" -> "nc_queues"
> >>>> =A0 * Separated the comment patch into 2 separate patches.
> >>>> =A0 * Documented PFRI register bit
> >>>> =A0 * Added Sergy's Rb tag
> >>>
> >>> =A0=A0=A0 It's Sergey. :-)
> >>
> >> My Bad. Sorry will taken care this in future. I need to send V2, as
> >> accidentally I have added 2 macros in patch #6 As part of RFC
> >> discussion into v1. I will send V2 to remove this.
> >
> >  =A0=A0 I'm not seeing patches #2, #4, and #9 in my inboxes... :-/
>=20
>     Seeing them now in the linux-renesas-soc folder in the GMail account.
> But they should have landed on the OMP account too. :-/

Can you please confirm latest series[1] lands on your OMP account?
[1] https://patchwork.kernel.org/project/netdevbpf/list/?series=3D560617

Regards,
Biju
