Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7A428DC83
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgJNJP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 05:15:59 -0400
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:3555
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726323AbgJNJP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 05:15:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVSqW29kGDGboXuxpegr242UkFPRezNE7fZ17NT3aRAjzUpj8ukozA+TG01wwVWwSHS2DBArsXtGHaMxr1l3tfS8LBaODezyRBNAKKVacrUY425S2fMTept7LliFtGzxr8AFTndeFHyqBmKVf5Hoo/75nQuKz9LpjIl/fZ727Pv2tlklAHS28s0LTSdvhzR4Eaq93FWl/ELfqIk2XTeLWDMKQbF2o49kactgxr5MToGpaVuADeQQJosNDZdEKd869OJEXJiGSJDEIDj3AbY+9hdlMSr5JcYKFHz+gzwQfc4lSqwfSaTwnGPo/KgXy52VsTHjUsuqMPpt760Xtp/qdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzn7dI12wt7sA1mo2qxLLXv/C4H49n1+okpgDP5wFjk=;
 b=NaHVeaqOWz0zLCm6FG5tydEfeVUh/z0nJY9HSRGCjF2y5g4ldU225+p1EcXNwoKTvifOEHovKat1dTt7IqgaXz+FwnN4lA3/haecC3aLvqN06hCcnSVDExDWdgprVUadBCp8Td3/hIF23t08HNtZP+cjbzX0X+5z30pIYp3/fP6L+0wJXYaEgjVvhyIvGaAoAQ1FzMWUtbUIU7V4UR0jJWxjjZX+xlKLXogt+Ov4mW+duZ+OAdJ46wfw2uweynJvDK/8YaDJtbeA/98AFifGVauCzKJbeRHCmuvM5HtIzrSDltnqSPM5JscSQE+EHqMVFuxQuIAO4VNfJhPlSj13Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzn7dI12wt7sA1mo2qxLLXv/C4H49n1+okpgDP5wFjk=;
 b=pW0r4syFe9VjDpuYz7UcgOEsnpKz3iJ40BRRk5W4J2zr+V4fXRmx8ccEK76Gi6NNWJJi8vP8k9wE3b8sLUgezWNNniXvsWcREWzf0XXYF3sptjgQczaV6PZeJRniuf9kCNqoNP8p9F8FBiRelwYfA3afvNtef6fD/Q7ItgO4IeQ=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3200.eurprd04.prod.outlook.com (2603:10a6:802:d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Wed, 14 Oct
 2020 09:15:55 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Wed, 14 Oct 2020
 09:15:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxim Kochetkov <fido_max@inbox.ru>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] net: dsa: seville: fix buffer size of the queue
 system
Thread-Topic: [PATCH 1/1] net: dsa: seville: fix buffer size of the queue
 system
Thread-Index: AQHWoejF7ipkuyd6Sk2qKfXbUtPEoKmW0WoA
Date:   Wed, 14 Oct 2020 09:15:55 +0000
Message-ID: <20201014091554.abgvxjksepkp52ga@skbuf>
References: <20201014051404.13682-1-fido_max@inbox.ru>
In-Reply-To: <20201014051404.13682-1-fido_max@inbox.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: inbox.ru; dkim=none (message not signed)
 header.d=none;inbox.ru; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 36005998-b928-43ed-ad7e-08d87021c146
x-ms-traffictypediagnostic: VI1PR04MB3200:
x-microsoft-antispam-prvs: <VI1PR04MB3200638F7470E3FBFE43C7BDE0050@VI1PR04MB3200.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FY3woVlNRKPcJhXN7Cxugf6c2sTvVz9VSoag54IfJkJbwQIWKqlBBVELXA0lo7orjW2e+samV2HhXlYIzH23AcqFCZT95GHvZBMmR4cmy58oBJ7Jshqtq/pbDwRfAkueyjULqksbdnnVGM01+7FRyLS1g7w6ReWLfHVefL/OOygOW2VHjDGrmtEbl+/MvTppS7oQoxyukQwCD7ivuASTP99Mpb5VhO6CCHOJfk9lnzBHXLrgWDYP/GIEMIARzCznrUqj2RFa5D6RQYkpmSS7/JrXblyAU41McV3oFYYlwGRtPESfyrwldyRXHwSmLnu0NOMcN06WbpFjO+lQYoKsysT/1VQu6xzqIY5qUVPVkCm82wUki/FBxpOP/J2FQBfJAuGhwMPmECFawCDN1+s0hg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(396003)(346002)(366004)(136003)(376002)(54906003)(966005)(8676002)(6486002)(316002)(478600001)(5660300002)(186003)(4326008)(2906002)(1076003)(71200400001)(83380400001)(33716001)(83080400001)(6506007)(86362001)(44832011)(26005)(66476007)(66556008)(8936002)(66446008)(9686003)(91956017)(66946007)(6916009)(64756008)(6512007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NISRkWmpBMorjPFST9sTVwWWrJ2lUKChp0CY+9IXUYeOpCQMvPzDpO/oUaS6Gi+/cWaQih3ak7ajTIlZ4zFSo35psViCo6K9bvIjnxi0pimiiHx/Puy8zh9XYFTivS+TnRjdpE/qj3epXX6zt9blJzXjHCjpQs6vrl3K90pB3WmjN0JGjtFdY9zvSA9X9I1aYvff8NAykXnldsDr3fbtlchUkccXsnXGfp9RNDe1p+77KHY51WnPwU19NG3teWTQ29kQqoxvkXYFO3qbOlRhjJKgf7x3qkSTA7o6NLBT0yveuJzA043W7Agcff/VKLFRV3cV48GxFnM6G5XaMpiN/Od+JL+9DmlIGzbLHz+gBTrYdb80Z35vGLGB2IXpmPPVh0EeCTtQho5eKZwwDp4cZGKQxYxRGIAKQ2qwXxOo376wj3a339LwNqMnYcrrkDmBShBukFTqf6tRLiBfa30Fsvz2duwYM4Xb9NsmRU9456lkvOxoHngSRktqx3MXiNGlI2WfU6W0BhY5I6mvBj1aXbbFieKmX9FDcuzdzYf4Oq5/NWWwbEyo9e39Sns4pxWTGme/LLlVyoXV2OUicfeOSucRamFGSw/NMJvtYwbJKYosddubcFqbCmNWcEVVn4JzaWljEo1Y8NX3yk2SbGlLPA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7C44F24E3380304BA2F901C79F57E6F8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36005998-b928-43ed-ad7e-08d87021c146
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 09:15:55.0332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DmW6YBk8pc1Br/OWZg5NnLMRanaj97RRPVzJC86dxwsWcR2g7VRSgEqL4F6fyhqir8N4ZWG54G6J1MukFpzCog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 08:14:04AM +0300, Maxim Kochetkov wrote:
> The VSC9953 Seville switch has 2 megabits of buffer split into 4360
> words of 60 bytes each. 2048 * 1024 is 2 megabytes instead of 2 megabytes=
.
                                                                  ~~~~~~~~~
                                                                  megabits
> 2 megabytes is (2048 / 8) * 1024 =3D 256 * 1024.
    ~~~~~~~~~                                  ^
    megabits                                   bytes
>=20
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Fixes: a63ed92d217f ("net: dsa: seville: fix buffer size of the queue sys=
tem")
> ---

Others:
Can you please use a different commit message? Like
"net: dsa: seville: the packet buffer is 2 megabits, not megabytes"
It simplifies the work of backporters to not have more than 1 commit
with the same title.

>  drivers/net/dsa/ocelot/seville_vsc9953.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/o=
celot/seville_vsc9953.c
> index 9e9fd19e1d00..e2cd49eec037 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -1010,7 +1010,7 @@ static const struct felix_info seville_info_vsc9953=
 =3D {
> 	.vcap_is2_keys		=3D vsc9953_vcap_is2_keys,
> 	.vcap_is2_actions	=3D vsc9953_vcap_is2_actions,
> 	.vcap			=3D vsc9953_vcap_props,
> -	.shared_queue_sz	=3D 2048 * 1024,
> +	.shared_queue_sz	=3D 256 * 1024,

I suppose I haven't caught this because I've been running with this
patch in my tree:
https://patchwork.ozlabs.org/project/netdev/patch/20201013134849.395986-2-v=
ladimir.oltean@nxp.com/

> 	.num_mact_rows		=3D 2048,
> 	.num_ports		=3D 10,
> 	.mdio_bus_alloc		=3D vsc9953_mdio_bus_alloc,
> --
> 2.27.0=
