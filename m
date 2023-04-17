Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748AD6E4013
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 08:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjDQGsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 02:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjDQGsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 02:48:07 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2040.outbound.protection.outlook.com [40.107.21.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804A21FDA;
        Sun, 16 Apr 2023 23:48:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7UXB2YKZmiVbo8EkqO5uPbjulZBsa/H/104JP09Orx7z3YN4huPpZcZLGp5oPNLs2B8+Nbd4x6mDjTebSAQ6o0U+H5UYyetCdrKU2QTs7P0ZRhXvTu2ghv+nUcOlrGH/HWmgNq5M7yFdZlnVPEe1tw+Rh1cUL2i3oaxAQC5A3oz2BpJvTb9y6D7ZwlIFsrm32kAl73oF3eR0FznP9k88XbYroOvcDgVv6LrzG9x8ztdUz7wpyNsGDmbAvf2n1kFEW0GdCr6n3VvAZJT4LED4wk3qDVa5laTydfzT+yrjU/KWJ8MdqwT5C9UalLZqZWNYptO6BPN6sp2sGi6n6bxdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZxg2z15RIg2trq8gg4QhXrnIfeUrMMIY1mdfZfs9Xk=;
 b=bW6L/LyuvIF9ENujP7IYbEZKlRXVKAE6MB/K/Pw7Aw7TPkLL6ygsaNpO3n2FWXfi7be9uLH+Tp8rHa8PTvjO0CyzBfJrD735zHLNtYbKr+RQnxkUvGAneDhkUWh+T7jFBpTI5NtmN6O/tkFHUhG/jb1jyumniRFssVtJqCdYn2z9ONOt/96jdy6HFQ3HKE0R+ZOqNbdC56q10fjhFcc4J5J34Cj1u7Tv3AS+GEwjiZtBqfAibS40pc9VKzbjSeDUSdnJjoRwNFwarybIQ/lwCd8WHKf8ctFxxOZh6865w1V34om7lgMNQrHGEHRtrxSgcgqPG2K+Ms/Ky1q+tSQHPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZxg2z15RIg2trq8gg4QhXrnIfeUrMMIY1mdfZfs9Xk=;
 b=JChg8NnGLgibFsFdB8tKKNnu8ZSF4Q80UK0yeqZLlU9hglSEB5m21P8/xYO3yUruM2Sr/Z93ou3StNQ63P+dTWVobIj0bAupGpdWtgdWLQuTz1fMRgUNFWf6thod9UisXLUNYnk1+Ogw1QznsYF/3dXg2lp4AtKd4Higd27qStE=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by DU0PR04MB9468.eurprd04.prod.outlook.com (2603:10a6:10:35c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Mon, 17 Apr
 2023 06:47:59 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977%5]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 06:47:59 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Thread-Topic: [PATCH net] virtio-net: reject small vring sizes
Thread-Index: AQHZcDeGnH5xR2OGlkuo4s6jvhNMC68uvmIAgABRFeY=
Date:   Mon, 17 Apr 2023 06:47:58 +0000
Message-ID: <AM0PR04MB47235781555A587B72107038D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
 <1681696410.7972026-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1681696410.7972026-1-xuanzhuo@linux.alibaba.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|DU0PR04MB9468:EE_
x-ms-office365-filtering-correlation-id: ab7720d9-9a61-495a-82d8-08db3f0fae9b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DhbCC9cokk4cgZckyFW/HYXFOdzfmn6Hysz+1scoYLShuPOD5W6QeyFtAsgC2vBCWxMkOzmYbb2CipvdOu67K455pvG7ad5BMqWz3pIjr8iooXyJJBUb06lYpQrrtKSxBvWCm4B+jH/l+/Khe+g8Hcpj40AuzHwJhayVrrqwMSA7FTwrqg7/TKkS9a7TWDvVvghrFttZ5MjXWgMui9mMXvwC2OQPHmbwenDB8n6KHIi0/FQaMKurYkSe8Cw/t3CShUFDsqvwMlasdcbkBAavmnNozNipPix5MgpFXcpgUWbL41xrWxH5ab68fd3hzYNQDnelm1NcdERA9nxmCJ+Se4Ttp5tgJzb1qz9zCnO9LKXJmr9AgKJpDmBxuvvUei9HQpWS+2f65fZ+qfcLZCXSGsaEc3ZTlBC5jMW1MaOnR762lCifKMG5Cu4D7gJJItRP4CfcfTOP9HlgXJSQ+nmqaRe4kfmA/qLzV33p9YAZZjOJe0k28G1C7hGgMxhVVWLcEPzGdgboX7HSuiq3e0SfhVg2B6T87ysdUeUJL0UuXXoul1s9C5Qz8tnul9blOmmMj3LRptHNyzdgi96J00fdQlXI2USXgP06xrD+MQvRNwxZTz+KoQJLAv8njOPzVah4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(396003)(39840400004)(346002)(451199021)(8676002)(66446008)(26005)(76116006)(91956017)(71200400001)(33656002)(478600001)(7696005)(186003)(54906003)(6506007)(9686003)(2906002)(44832011)(38100700002)(52536014)(122000001)(4744005)(7416002)(86362001)(64756008)(6916009)(4326008)(38070700005)(66476007)(41300700001)(66556008)(66946007)(8936002)(316002)(55016003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?iFQJBDKiK8BONWSjziljntI3Efp9RBocY1KfsIHBwL3i8pDmpFQVKIp7As?=
 =?iso-8859-1?Q?MV6HONTdldjzucYmGg+gcg9boeh606neXt0xpbTKkNFNt7VCugVrT2bQsD?=
 =?iso-8859-1?Q?ILVI3e+kd+j+q1MtZXXJFyCu6YDQHnnrKcVbTCmvISf/LpAsfhZSMweCt2?=
 =?iso-8859-1?Q?7c4ijpwf4XNQzz0DWSzepGWYrJyV5f728mK1CycuZv17I0mGzs3N0HKKmC?=
 =?iso-8859-1?Q?xmcgIa48Tb9bscVo4MHPUAdaN5+6ZwfrQ9NwT1REifTN/rZmdAMXHURkKy?=
 =?iso-8859-1?Q?sbF5amT7l8gLnORtvYepYu7o2FW7fx8DqHPDdWrtm2WP9ZcL10HJJ7VK/G?=
 =?iso-8859-1?Q?W5tWM5AsET0smXLEWd75KDtFN4nINkqMhYNJc/X+xqIqiVKTFez8lgpN1d?=
 =?iso-8859-1?Q?XgfXLFXvNYMBCLfI4kB7jXxLr4EVsLV9dVibhc5DXB8seEgQtq27feCFW+?=
 =?iso-8859-1?Q?GbryWo+93fjJGT5Mz24oip9VwBAmMm42zeAjcgIYGjyPaCjR6CCRxlKIOi?=
 =?iso-8859-1?Q?pG59sa6HnvZqYdsQIoqaLv6cYQ+fgVK/e21b8U5KsDpJqN0s/AmwY56Kyt?=
 =?iso-8859-1?Q?ylic+y97mXMfsYibX5Hid40f7Qdh8lgTA2qKCWhCARirc00ap21l0pwWwF?=
 =?iso-8859-1?Q?WKZ8VaI1ymMK9pYCtRfoIHJauXHJWfaGtbiJmYdw9wodKkJbljzJ+ItRfr?=
 =?iso-8859-1?Q?wx7X8rRtmJWQU7ioBzR4NsHLG/OzXkEaRQyf7NStVP8elLdJHuU5LK2cwV?=
 =?iso-8859-1?Q?N2dCu2bvp/Y3DafgYpU3OKxyeyscKkJQFVImZJcHTtJ8rQ9AuWPN0MpROe?=
 =?iso-8859-1?Q?EZ7LI4h09AbxC2S075nBEBSsk41uB2W/bEDiNvgKMLsOyuNhgWPDoPpYQS?=
 =?iso-8859-1?Q?5tt5/iOm8uOqbL2vXy2PW+wit+hn9fDuo+guI7Wy2e8aetPwKu5IGV7XKG?=
 =?iso-8859-1?Q?tvPg9ZFwe97/IFRhoY0TIbYAj8FQgQc1o1a+epI/uRWp4yCxNdRSOn93Pq?=
 =?iso-8859-1?Q?wLu33Aifq9txRPv+cl2b1/Owz+SA4KxV5vw0mgD24n+LRh898Tdw5g2Shy?=
 =?iso-8859-1?Q?fXuVihE5r6hLrXKUDUcu4ioC1LZBRjc1ukOJGaDONL3DikbL1sZGQIs4nj?=
 =?iso-8859-1?Q?4U2zG/tGqoMEKXL7cGCrzBMTdDMLM6JQsNR+WqoWlYh8iG+hAadapsjp6/?=
 =?iso-8859-1?Q?Kom1gT+AOy4Rxu29nluZh3uuZiHqsvVbguEeEsiy+J0/SGLrw/cSccKxmx?=
 =?iso-8859-1?Q?nd0l3dfEhGXq9Kyg7KkqNWrbXmg85V/sHaWSPQ0erpl7XCG5uePg673aAG?=
 =?iso-8859-1?Q?lSPKL7h7KWdpuNHh8jXU4hPlNU4ftJz8jG6GWXnz1vd5DHoPuDrqkjQSFu?=
 =?iso-8859-1?Q?h407H4ouhLMQoNJFC8cyzmMDT+rjF2+xonpRMwas2k4RUYMraM5PCMOTMO?=
 =?iso-8859-1?Q?6pdH15JLMOW/LRAc3hmoxGz+QjEVrMlq/T/+n/SCLSUGX5pQd4O7ZlCw9G?=
 =?iso-8859-1?Q?jcFoEQhbAQYn4Be6Iv1BfiZ4vWmY20lwV0fx82Ht4Vr7FOJj56/W+r+ZQI?=
 =?iso-8859-1?Q?lca5DO7RsMThNmkVMHBsqgx2fPN31rsi2tU/X4qRFtO1kogELQjPBO9ap/?=
 =?iso-8859-1?Q?Ac5Nfp1JJrDG9L4dO37vxkVCL1Lsdgr/+K?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab7720d9-9a61-495a-82d8-08db3f0fae9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2023 06:47:58.9516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XQhqBfsnWowJ4ZYFeW0SfflJWo43x2yugvb2jDIBolmeT+hPYQWX6Rg/iqXaQwzhCQiP7Rg03QaNXH5pN0c6KIh3HisqUuBINg0ESbdU2Xw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9468
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Check vring size and fail probe if a transmit/receive vring size is=0A=
> > smaller than MAX_SKB_FRAGS + 2.=0A=
> >=0A=
> > At the moment, any vring size is accepted. This is problematic because=
=0A=
> > it may result in attempting to transmit a packet with more fragments=0A=
> > than there are descriptors in the ring.=0A=
> =0A=
> So, why we check the rx ring?=0A=
> =0A=
=0A=
You're right, the rx check should be a little more complicated.=0A=
It depends on the negotiated features, like VIRTIO_NET_F_MTU, any guest GSO=
, VIRTIO_NET_F_MRG_RXBUF.=0A=
But MAX_SKB_FRAGS + 2 covers all the rx scenarios.=0A=
We may be able to accept smaller rx rings if for example none of the above =
features are negotiated.=0A=
=0A=
If you think that this is necessary, we can do a more complex rx check.=
