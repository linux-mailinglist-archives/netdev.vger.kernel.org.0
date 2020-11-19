Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E462B8ACC
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 06:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgKSFUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 00:20:08 -0500
Received: from outbound-ip23a.ess.barracuda.com ([209.222.82.205]:55944 "EHLO
        outbound-ip23a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725648AbgKSFUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 00:20:06 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177]) by mx1.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 19 Nov 2020 05:19:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLSI9p1DJlHb0FMxwpEiP4uIFUMLOSTeAYl9c3RtHNP2g+4eqCPx+mgYlZ6qCSkytTnd0XG4aU18DZWzuJ+MrTJX778S716GTGpDBCEdL8M6AMCK3Fu0IPfJCwOKnAoDzuUUGuaZUjqGjJ8UQUCRD9HxrSyyqXNVrDRQUToRn+unbYkZNpwzQrJgKClfKgkxQLhEU7pTFYk9lmbT9lBvTlrC/hjAurU7cFFHEbk05CMIlIY5YX7KHel283VuH5dEL1xw09EwsNpzf6QGUV4j7cl8BzwXc6oVi0zcCKSqdfP/J2KZHfS9iLsulfuZ44Te8zuyREMljQwwr5KqOaioTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+9DwwL3p3+/ZSfQqSHvSulgTx1YhjFhb5x6PqF1Jyw=;
 b=WAqAotwRbsovN0flSMeYbpVFUq7mMfr8j/WV2dOjWz3VrMQIlf3jxl32nbkID/nTgNImucBWHKPyMN3TqBcYfFNfFAUX9p3V50SrKRUB52IXefJuR+klymssZSkYZMJVRiVGOol10we7kPY2dtSG1AMRVCcBntKSd7JFWIL4gA+cDNSkjZLDOMLXUr+1VgS2xOlXIypR0L7llANfxGmLOUsU7cYqpWNFEPGX3hN4cJz0f8h0r1poXk3AfFvf8ivjCExbtUbqYobzJrU+dk0ZbxjZqrc6I/Vq+NyJtXAYqj6J5YcY62nK5rsDA0ABTK9UhxEcBC3MXy9ShcEMbpahGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+9DwwL3p3+/ZSfQqSHvSulgTx1YhjFhb5x6PqF1Jyw=;
 b=Fi8HERTQLvuEs+rWDUiN86EjhPZFR4iLxhnGdDPEhy8J1wB5HRRsHsGag7g6+HZOJfVpiu9GS4kPqh63+rrEQ2ernZL/CGUTdjoX2zoTYNGVafIWebj7UuQAUhgERpEVTwitcmIc7e/qGYdu9F4JwtkAQuZSWUmiYZ6CL5Tkw+M=
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 (2603:10b6:910:44::24) by CY4PR10MB1943.namprd10.prod.outlook.com
 (2603:10b6:903:11a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Thu, 19 Nov
 2020 05:19:56 +0000
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197]) by CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197%6]) with mapi id 15.20.3564.033; Thu, 19 Nov 2020
 05:19:56 +0000
From:   "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [EXT] [PATCH] aquantia: Reserve space when allocating an SKB
Thread-Topic: [EXT] [PATCH] aquantia: Reserve space when allocating an SKB
Thread-Index: AQHWvUcksksVLDpkhU+MIoNHoOO3dKnN7HCAgACGx0GAAC/ADQ==
Date:   Thu, 19 Nov 2020 05:19:56 +0000
Message-ID: <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>,<2b392026-c077-2871-3492-eb5ddd582422@marvell.com>,<CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
In-Reply-To: <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=digi.com;
x-originating-ip: [158.140.192.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f337d49-4d9e-4021-7434-08d88c4ac0ba
x-ms-traffictypediagnostic: CY4PR10MB1943:
x-microsoft-antispam-prvs: <CY4PR10MB194327D3ABF365A724E9980AE8E00@CY4PR10MB1943.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MW8lApfkn2CRFlbNCEZPbtic1b3CACgDgS4ZDQ2ARCDpv2WhnX5lLeM8uTz4NnU+DAYWl7zxAMGeKgI3HO1wdKkwbrgg83xqzbU0Jlwk7jr7FZ2Nm78zUpgnhbXHf8p3MLLnzG4uUhiywpLfNG1s0IEv775J/PG0NPc8W1iOJqsywxwHfw7l0mXueqIrq38d/VhId2JQu2gS9VraVJKWk6sukOryCQ8c5AwRa2MUP2EckcwcEW923irovvKUqFbeuF5ckDPe2l9hsTok8a/88nOedc/LL8+hWzPgonzJU+jn8chR+Wwn6q++B6AuasXwaYDHNHfC4n5CtyY7cnocYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2311.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(396003)(136003)(346002)(7696005)(6506007)(26005)(55016002)(9686003)(66556008)(316002)(186003)(71200400001)(110136005)(8936002)(8676002)(86362001)(2906002)(5660300002)(478600001)(66446008)(33656002)(83380400001)(66946007)(76116006)(66476007)(52536014)(91956017)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: oUyODxEfTUmTIynD/u8k5KpUw7EpI7d287mo9okYdG/qq5BiGASJUIZgXS6YT7+o3ssbAKsy5dEVeEQUvsLQvZuEb+tEO2kr+fwMBzH5YTppiSbqf2dBYZnqZH5kDG8uaPb+cxeqUh5tyLBjLk19Ized+J0iaTK1aK7IP+bXdVL8ZcFvbREybAiFmqtOg+vpvEesjdqrV7xLAza/5pfkDfk0DUf6uMs785Zwoxz8I/UTLQEKK+BCzjTVYSM3W27F8Lw4Yb17f0sJSuwysnOI+ImW/75XtRK4DRFIjRLLxdhDNGvB3LmAKdENRuKt5AoEFnUfeeBXMdMhdYDWibQxC1WtmCK3b3QIzrb79/FWPz7j+Dl4QEQfCcGuSDHPdeFlZp8nO8MD84f08DrO+gYa7R+9ViUwLL/DH5S0DBGQxL93n1XnRYg/HmJiWCbDa4tc4aVWqKGKqRnNGF0CrNa71nD00AXK6FsaHuhGYofj2hd1wVT+A7IuuXD+H/SSAYMnz1wqpaibWS9TAMpWB8H838/Zslwj8hYSsc5Sbre6aLa46VZ8KYcLzFlwCmt6/WK+s/vlbNXTlbqstUecd4ucEZJU1mE25COYARuBubMfrGWC4UzQEKxPNKZHVCpSkiKoNLG0wWsgKFDQ3+dy7aVXoS8X21WuaHA8VSvtzbOQroJZz/ClM3n5hoNbAOD0eAdzs+VKd3Loa0X0UkybAEZAGF6R+HL3UhTtYt/gfiDfP5mpRaMWG1TPLIUkGVCvJSYm6RGcAs8LCROe30e1XBW62HH8Edi+/odF98UZi3HR/C9igdffkEoRyQswgPlqmhcKJ2QiQLq2cWRDLtHd6bULjsoDpoKd+Axf+2hSZ3ErLSpQQjHHyBZF/jz2K3KtS3kGSHJmeXpTABqePkxy0tgkLA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2311.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f337d49-4d9e-4021-7434-08d88c4ac0ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 05:19:56.0279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8xoij5H/1a3cFqTI0h7YBLyX8InDf5uPKIbVcQx1G1/Ob70Xs7DKeHOxAID3XxtzSAIs+sEsfGIJt1XYgFGv9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1943
X-BESS-ID: 1605763197-893000-4258-46405-1
X-BESS-VER: 2019.3_20201118.2036
X-BESS-Apparent-Source-IP: 104.47.56.177
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228289 [from 
        cloudscan9-177.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Igor,=0A=
=0A=
> > With your solution, packets of size (AQ_CFG_RX_FRAME_MAX - AQ_SKB_PAD) =
up to=0A=
> > size of AQ_CFG_RX_FRAME_MAX will overwrite the area of page they design=
ated=0A=
> > to. Ultimately, HW will do a memory corruption of next page.=0A=
> =0A=
> The code in aq_get_rxpages seems to suggest that multiple frames can fit =
in a rxpage, so=0A=
> maybe the logic there prevents overwriting? (at the expense of not fittin=
g as many=0A=
> frames into the page before it has to get a new one?)=0A=
=0A=
I am not terribly experienced with such low-level code, but it looks to me =
looks like a page is allocated (4k) and then DMA mapped to the device. Fram=
es are 2k, so only 2 can fit into a single mapped page. If the mapping was =
done with an offset of AQ_SKB_PAD, that'd leave space for the SKB headroom =
but it would mean only a single frame could fit into that mapped page. Sinc=
e this is the "I only have 1 fragment less than 2k" code path, maybe that's=
 ok? I'm not sure if the hardware side can know that it's only allowed to w=
rite 1 frame into the buffer...=0A=
=0A=
I noticed on my device that aq_ring_rx_clean always hits the "fast" codepat=
h. I guess that just means I am not pushing it hard enough?=0A=
=0A=
> > I think the only acceptable solution here would be removing that optimi=
zed=0A=
> > path of build_skb, and keep only napi_alloc_skb. Or, we can think of ke=
eping=0A=
> > it under some configuration condition (which is also not good).=0A=
> =0A=
> I'll attempt to confirm that this works too, at least for our tests :)=0A=
=0A=
FWIW: This does work. I notice that this has to copy data into an allocated=
 skb rather than building the skb around the data. I guess avoiding that co=
py is why the fast path existed in the first place?=0A=
=0A=
Would you like me to post this patch (removing the fast path)?=0A=
=0A=
Lincoln=
