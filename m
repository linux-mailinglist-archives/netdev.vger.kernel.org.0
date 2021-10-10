Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22645427FB4
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 09:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhJJH3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 03:29:16 -0400
Received: from mail-eopbgr1410105.outbound.protection.outlook.com ([40.107.141.105]:35649
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229697AbhJJH3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 03:29:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H27ABTlIABlMQlkUC+7EgU8Y9XnXMBailOJaPwbOI6kFwLXN+3w3O0ZPY/1cocS4HESm9IZoEuiH2BOzeCPJVWyJ9tVmaSNpiEIw+zTESps440gQEpcVSsWf5liGBqnWRxyTJn5KWMgUDmWUL4sNDsmVTkwCyj2y0mCMpmc1NrDd6UxpBbQe7wclXjvc+lqvZzBC9m+rNsPob3OIL7aAeW38VGW7FIRTnKqcLcZ3jJkCoSkaC/crvcXZir/HiFsIFp45ukXU2Mxx360rxUKHSt2WD12ortpRQZH7u3oxXCZLLm7Ws1RAqH496z8tqpysWPNrnziRYS39EcAooND8+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJPF5zAGfEMXMo67tvxM0IKo8+ZUFP3MIJYfxO1gyC4=;
 b=mGY7jSXKZfOaGwMUYwopPSQBquTsxh9FKdI0YAifZAoMEr8ezBOHgNL1x9BUTN1/dm0wMcKOC3giVS26ACSAlbMrUxMq3kZRZlVQObMrEYcmGD6uj/O9sRu4o+DyLrrHDJU/ULlIIDIbNNxe9iBWmnUWgE3eqbIh+XzXPQ/4cAb5Xp+fHEUCS/3Bas/5jGQAVR9X47hME8WZ1xAPZ7tGmwaTh3HSIliIoR7735/OWSdJWh4quz8sYaI+3GAQiUHqaLAaIFhNQBI85Mla9abbmCg4qpFLHymjLqUX+L491OExKDU3RvhBinGcdEhMsf2AwFVWm+icItm7ZSO6kOA/Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJPF5zAGfEMXMo67tvxM0IKo8+ZUFP3MIJYfxO1gyC4=;
 b=C90MBvxsenzotkRKVlkdxscOehVjgmlYzaPBux80Fsg+kNPeo233FY49ZA/lLCBWRKprQTIyySzLnrHjtNiwU2HRx5tCNWQKb40JmOQj8BBKPTOStAx++AdAKfzFtW2SQwRPB2sqJtghUPpL3TWhNG0oYvjnhGjZPGFQlYP80uA=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB1944.jpnprd01.prod.outlook.com (2603:1096:603:22::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Sun, 10 Oct
 2021 07:27:11 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.025; Sun, 10 Oct 2021
 07:27:08 +0000
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
Thread-Index: AQHXvUEBHULAomfYXUWxvR6NssmBBqvLDP4AgADISoA=
Date:   Sun, 10 Oct 2021 07:27:08 +0000
Message-ID: <OS0PR01MB5922B0A86C654401D7B719E086B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
 <ccdd66e0-5d67-905d-a2ff-65ca95d2680a@omp.ru>
In-Reply-To: <ccdd66e0-5d67-905d-a2ff-65ca95d2680a@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f37353f2-3149-4334-4094-08d98bbf5e58
x-ms-traffictypediagnostic: OSBPR01MB1944:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB19449681A925B9762B89B93986B49@OSBPR01MB1944.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jX0/oHLlXetFfn9b9j4PS7wDBOp+PwEZcJIBrGH5h2oEVMbjaS/ALhhYVVbqUeH9PC9yfXjTUENB+T5aYy14wX+QOlYMAcEeTzVfhl8+u1HE2GMfAXHCDx9REDROothZewour9cHSiE6O2htwUjuhv1chSu1v18w3VNlYMNN/HWfzbqo8OCH/g5SjtzPlOMYlHT+yze6LsHcazZeZlpSq5IC6SAIeYzZ3uVYgw+/4VX+R89iXEF5VkRuqCP3Xtc0eczSekV47rxlR7X3AsGVgHyF4ls7bMkmbM4wF48VUngKQIYuNn73ZIMD5rjcCTM3UWRCyevM4LXGnmf/KvUBolD/8JsGKZkqLmjpUmb4EtFI7xRC7B0/3c8/3ziAYZpG89mAYpj3zEV3pyBQW460AKzzirjzzXo7u9F1YpCdmKjRivKmkJZdkghfhL8tjtrvs0akPqtr8gsvG1iJ/XYYUep4x5oujHLuEcnQ6N2wSDgSgOT8YTMxGwBRjWN7vHLv2JUx0GmS4TcqghK5q2u4TyeJM0sgu8G3+ElbUuEQ3ANWP8I9DR4ZWaE2DgZgtFlC3DBtkD3i06rkZFnViRYjV6jxuNz/0/1a4bQF1wP/QZ3qkf9K9f1F8pc4spV3uCKiq11XWOkIBWRyeU+QTBbNII8gEWY5nncQZ0jK2ZPRw3bAQS5vKVw2Sh23WvU+IWKWo393LfIRrUvqza8Xr8jI88GybMUbaCIOclLNk8Eqr3x1lZYobHgMl/IBZvml4kcbn2Kb2uQnSx/heyjV7BMNebkDWHUztunrjL/mWtdmO5Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(4326008)(7696005)(8936002)(186003)(55016002)(5660300002)(26005)(71200400001)(8676002)(6506007)(54906003)(316002)(53546011)(52536014)(110136005)(45080400002)(66476007)(38100700002)(508600001)(86362001)(122000001)(66946007)(33656002)(966005)(66556008)(64756008)(66446008)(38070700005)(83380400001)(76116006)(107886003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3cqSSuKsyMeQsgc+ixDgm+fbBoO32Gql8VyV324XvmSiS9xEUQNZLSOGbNdx?=
 =?us-ascii?Q?H6t2ZPcC+Sl59u6W14fewmeEtCRpTOGZs1TD7uF08QXm9ULG0TXIu8SGxzEq?=
 =?us-ascii?Q?V60njdpaIOCNJd52d2101fK/3kEEPKu2qcNMShXC0fMA6ag9oI9CtHxRFhBt?=
 =?us-ascii?Q?gnbOhUpa5TisVXXZ/p/v9DDFRo5Mh0ZxJ6iW7MQYhcf32p8qNgKkV368eKjw?=
 =?us-ascii?Q?amYMO5IysIIknAWuRWC6DQMPPSrnuvVQALPJQZ2n0Oxx6+TPdzAmgA8v1C3E?=
 =?us-ascii?Q?PxMidGPetLyacjjk/cQFhwtDzJIpA6dIHFhGQYdHg/A7ZJ0FULXU1iMEO8KZ?=
 =?us-ascii?Q?5iem2L1rp8Rk9DLaz6Zrr9n8a0tZ9bLSofAeyFuLj7vN6cAS6LO2swmMJm+6?=
 =?us-ascii?Q?4rb3nTwZQi7qSJ/7VXdE7eC63e/YilNVt/UCGXqX4oRb1l1lZaOpez8uwcjg?=
 =?us-ascii?Q?tRuKPlYdOd8LIGMrk3ahzvOGHMluKMtZEetSb9ahE56vwJrJZtyeGyTrn4jt?=
 =?us-ascii?Q?YeVI1mkrsucb3xBgU03Uf9Omi0G7lp3O2TQE/gm6liowW6701fbeHw5PUQ/s?=
 =?us-ascii?Q?HBtlK7Yhw0rQtnOdnyQHKa0oNLhFlIvRjnZtvJ0ZZ6Pa+kbIJ7AdcGN88ZwA?=
 =?us-ascii?Q?ifui6pLkU+CGqLkqkBsAZUabNIDO5A4l3MPfjGMRiOUURoRVb2N4LTSIN8Wa?=
 =?us-ascii?Q?EBscOU7hFtFlp1dFvCluzdDX4tfelpT/X6he3i/+wJEC8UdgNIqJgGCncehK?=
 =?us-ascii?Q?nbNSfBbg34sFdkOFC7RMl3NDki298eqUmx7Wu7dXDXCxXy3NPYrNWreKa+BR?=
 =?us-ascii?Q?xtMRspQN7TmErmFGbq5Pwz+iaAYdgkvXb83xwK7MTk0o7aLoT0PomcXopdhA?=
 =?us-ascii?Q?81nFfMf5DJ7stgFZZOiMcAhvU7v8Vv9YSiVKx6j1/nmBsnsNfyYZD3fFNXSE?=
 =?us-ascii?Q?aA3VXJ9/hRi9n68j3dRPMsfa1OP+OvvpOkNUutSenCzzkpDzrtuRYco7rNAN?=
 =?us-ascii?Q?IQ+yvWIrOFdPg6E2ib+ANIOkV9GAewzh9pW4RkCSld/oIdjp8tw99NVmz27s?=
 =?us-ascii?Q?0C0RlA9xF+3L12RDR6ToD3PcPKBsnh/tXajaut8itmRzlCkiGrHXSEaVXZx0?=
 =?us-ascii?Q?+PymN/ejQGPJIxWgCVllZ2tqkbMBPX7I9XkZTrR3Kla7JU2+fkoDaLuR4TYm?=
 =?us-ascii?Q?jLqUl2BmiRVnLgOf1hilAQToqv5oZEv7fwTrcSFbYmlMe2X3kIuHR0pEWWS4?=
 =?us-ascii?Q?EyZXSSZYG7IDmD0uAFb438/1pom0M+7hbZQPI8VXmxGukaD/V8OpPkgGXywk?=
 =?us-ascii?Q?Ekc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f37353f2-3149-4334-4094-08d98bbf5e58
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2021 07:27:08.1837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dNOda6kvBzR5oOViGGj2zGLaWVOfcFjqED8X0yb9nnysMCTvQLS4VXph1W4qN6Y/zmkEUR9b+P1FAoyHhBo0y3PIytXUaBapcheCW4/1quQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

> Subject: Re: [PATCH 00/14] Add functional support for Gigabit Ethernet
> driver
>=20
> On 10/9/21 10:07 PM, Biju Das wrote:
>=20
> > The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC
> > are similar to the R-Car Ethernet AVB IP.
> >
> > The Gigabit Ethernet IP consists of Ethernet controller (E-MAC),
> > Internal TCP/IP Offload Engine (TOE)  and Dedicated Direct memory
> > access controller (DMAC).
> >
> > With a few changes in the driver we can support both IPs.
> >
> > This patch series is aims to add functional support for Gigabit
> > Ethernet driver by filling all the stubs except set_features.
> >
> > set_feature patch will send as separate RFC patch along with
> > rx_checksum patch, as it needs detailed discussion related to HW
> checksum.
> >
> > Ref:-
> >
> > https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpat=
c
> > hwork.kernel.org%2Fproject%2Flinux-renesas-soc%2Flist%2F%3Fseries%3D55
> > 7655&amp;data=3D04%7C01%7Cbiju.das.jz%40bp.renesas.com%7C25bc7b9155d840=
2
> > a191808d98b5ae62f%7C53d82571da1947e49cb4625a166a4a2a%7C0%7C0%7C6376940
> > 44814904836%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMz
> > IiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DVktj5v0GvrNf%2BDNIF=
s
> > e6xjCUm6OjtzwHvK3q8aG1E5Y%3D&amp;reserved=3D0
> >
> > RFC->V1:
> >  * Removed patch#3 will send it as RFC
> >  * Removed rx_csum functionality from patch#7, will send it as RFC
> >  * Renamed "nc_queue" -> "nc_queues"
> >  * Separated the comment patch into 2 separate patches.
> >  * Documented PFRI register bit
> >  * Added Sergy's Rb tag
>=20
>    It's Sergey. :-)

My Bad. Sorry will taken care this in future. I need to send V2, as acciden=
tally I have added 2 macros in patch #6
As part of RFC discussion into v1. I will send V2 to remove this.

Regards,
Biju

>=20
> > RFC changes:
> >  * used ALIGN macro for calculating the value for max_rx_len.
> >  * used rx_max_buf_size instead of rx_2k_buffers feature bit.
> >  * moved struct ravb_rx_desc *gbeth_rx_ring near to
> ravb_private::rx_ring
> >    and allocating it for 1 RX queue.
> >  * Started using gbeth_rx_ring instead of gbeth_rx_ring[q].
> >  * renamed ravb_alloc_rx_desc to ravb_alloc_rx_desc_rcar
> >  * renamed ravb_rx_ring_free to ravb_rx_ring_free_rcar
> >  * renamed ravb_rx_ring_format to ravb_rx_ring_format_rcar
> >  * renamed ravb_rcar_rx to ravb_rx_rcar
> >  * renamed "tsrq" variable
> >  * Updated the comments
> >
> > Biju Das (14):
> >   ravb: Use ALIGN macro for max_rx_len
> >   ravb: Add rx_max_buf_size to struct ravb_hw_info
> >   ravb: Fillup ravb_alloc_rx_desc_gbeth() stub
> >   ravb: Fillup ravb_rx_ring_free_gbeth() stub
> >   ravb: Fillup ravb_rx_ring_format_gbeth() stub
> >   ravb: Fillup ravb_rx_gbeth() stub
> >   ravb: Add carrier_counters to struct ravb_hw_info
> >   ravb: Add support to retrieve stats for GbEthernet
> >   ravb: Rename "tsrq" variable
> >   ravb: Optimize ravb_emac_init_gbeth function
> >   ravb: Rename "nc_queue" feature bit
> >   ravb: Document PFRI register bit
> >   ravb: Update EMAC configuration mode comment
> >   ravb: Fix typo AVB->DMAC
> >
> >  drivers/net/ethernet/renesas/ravb.h      |  17 +-
> >  drivers/net/ethernet/renesas/ravb_main.c | 325
> > +++++++++++++++++++----
> >  2 files changed, 291 insertions(+), 51 deletions(-)
>=20
>    DaveM, I'm going to review this patch series (starting on Monday). Is
> that acceptable forewarning? :-)
>=20
> MBR, Sergey
