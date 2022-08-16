Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51B859580B
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbiHPKWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234412AbiHPKWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:22:16 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0627.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::627])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE6B32DAF
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 02:36:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWpsCmkPyCf1lbR8s2cSe9xsJm9nf9fwfwykBcJF1UAj2mm8KH4LlaJXFMo2Poa3yVxaYqoKVRTfUT602sQ8nDJ446hEVKvcWQAgmthop2vnicNeb2phdV1P+EjKAUiR++et5iDs65/XeJJjTllx1WH3IAQn0mBAJHfQpwXj6ZiAx2slsripgrpis3H/Be45uvABI/URzwJ8/WyBf3MHF1Wf3Au44eB4Ukh+CkDyUM0whCrDgPXFqqsYCgCXs/PJR2+eHQo6BXmYoHU7iCJVaHUdoHA2UCi5sDNXTsk1AP1/WgZq3979aujNoxZ2XCQFbERJPW5+OP589TIoIkHELw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVVMkryPA8Td6/UbiqvL3xa6UAPt12hiKxLTzWa+HgQ=;
 b=DC62PdBDex7esSKL6qH2+GVZGwfMwJtyD39akIjp6GUKEQ6Ok8Al6oHh08hpK4Oc8WAgWrGAjfa86fzIZPGpuy6CqT0Po5g6yOGM/WXmgmZnutL1Q5pBU12d1HT228AJLHbR9QWoBZDIFVvveGEbJHDHSydR6FxtqOv+VVQOqhNVQ4hBczXpB67HTTGvFm0kwxM3MBQWJb0rQpTOzb1WQSH2Q0IL3+eF97K4jhVhw52apkubHEYQOlWMFmAJb9/84x2GQIb7bM8cscbLtnwZYi31M/gWvFNCOC2UgoUrPJvTcAewAXTOBCfk1kpormOCKq8nCljWulYVV2faZ8bEmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVVMkryPA8Td6/UbiqvL3xa6UAPt12hiKxLTzWa+HgQ=;
 b=Goo71G8c50ddVt8wOcrr6h/1kQmMzv9DERc3Dbj7hAPCbnYy4R+vRKc5Gza+oTGwqBiJNldJK9+cdBiLUehDZP6BFW7pyDBctA1FvVjtjxE4btiyDdpNWr3QT3mvC8xWwbnCLUSZ1dUnCI6VMQMXyGa4Cw9Hj637A5k/VX09+XI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7484.eurprd04.prod.outlook.com (2603:10a6:102:8d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 09:33:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 09:33:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <ferenc.fejes@ericsson.com>
CC:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "marton12050@gmail.com" <marton12050@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
Thread-Topic: igc: missing HW timestamps at TX
Thread-Index: AQHYmepVJYOkQdQn8k+cRlOb7lKNfK2vsfIAgAHAowA=
Date:   Tue, 16 Aug 2022 09:33:14 +0000
Message-ID: <20220816093314.hqfnzangzamjdpkl@skbuf>
References: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <87tu7emqb9.fsf@intel.com>
 <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
 <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <20220812201654.qx7e37otu32pxnbk@skbuf>
 <1016fb1e514ff38ebfd22c52e2d848a7e8bc8d1a.camel@ericsson.com>
In-Reply-To: <1016fb1e514ff38ebfd22c52e2d848a7e8bc8d1a.camel@ericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47ab2ed7-7763-4eb6-ca67-08da7f6a5827
x-ms-traffictypediagnostic: PR3PR04MB7484:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xYY4eqDu/2DITAY0TlEQCKsKJwNrz692DRziZDONyKKaAZ1sALaT0Pj8tcB7NYwgy/z48zf7/BJTHOm35DEKUyFFsFdgEeYa1cqXqzUmCVYPPoKU5ymFLrbnQJCyO8xlvlGeQMwvKNlSDvITiYYif9gSGShwNT8YOCz6Y5EwrQEC8fvo0ICZuPb1K0raOX7TGHQW0OXZG07te7O0DX22JukzlBDRiShJRgY3RbXlqYzriuJHBkeGU1CgBpas3PEi6AmrFi4EOaEb/6UrUFjcNJTorjl4hWaqRKyWSmpzEN8bASO1tmbFFgWOks/cflh9nhJwi3KMKdRUgfu6W4Uln69meYfgCpBKs+HcMEKTiCFFZsiqP3gJMnfUUZ7F4W172nAKaY5MjHxlY/UvA8WOupibMIHHZln+naUynyaC7iRJ6DFi4NAOpSXeqYlLqWQSqrDfVaqz5ltGx8cLlSdKn33jL5GJx7wxJEX/iaI5fUmfgzK0oQXYVR+WLd9NFTR/Y3LZGjj6pJ0AoLg/ikXrN+7ttwL/0fukvjJ0Va4qNxgSjthBwrKnWGLml41aC9gJM7t+Zvgzp7a6VXA0OVu5JzBHFYmUlsaGG2f79S8T/XQ5QAL/3Kv5LG6+dFhk+lfeIyQsMFf076tnzlttx5Nig+OTudj8N1zqCp101sm0bwMFhz1vPS0T65svihcH1mkQSZ/5CfxFfFAI2AnusOSpx2g72VVU1QLhioLjTHOkCTY/ebiC69lzWIUX3vcfKELaKCgTFiJYI4HmYD4DoGUbvNwoRi/JRqqZyz1bSi7GikCO+/9WiMALJYFhJogXr3RK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(2906002)(86362001)(186003)(26005)(122000001)(83380400001)(6506007)(6512007)(38070700005)(1076003)(316002)(54906003)(3716004)(41300700001)(6916009)(9686003)(71200400001)(91956017)(478600001)(44832011)(8936002)(8676002)(5660300002)(66946007)(4326008)(66446008)(38100700002)(64756008)(33716001)(66476007)(66556008)(76116006)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zu31NGoYw1QKOXzXKQuo8egq5J60x0i3Loat7ceLhr59a+8o1CsCa2f6H/uN?=
 =?us-ascii?Q?zI4fr1wjIuO2TFfQ0u9F9ehgezyqZod2c52VNjaxvDjjWtd1OEyrIM75GkWB?=
 =?us-ascii?Q?ldwgRaD5hnQLBHHXYGW0ycMEJiSuIMpVlYwhgk06W50GNrMRk+N2Mojja1xL?=
 =?us-ascii?Q?yJX0KSZFjp0ozdh6c4/myzsY2DKd/8BRfWjCZKMYR4LFnJ2OIVzAOOrNBshD?=
 =?us-ascii?Q?zIMSbwtSkwSCz2mpzcRdFtK3OiAFP7MCEYsEMHVZzDdXXAxi4tuONw34IdBS?=
 =?us-ascii?Q?C4HBMwI7k1QWWvQXeyPZ1Rtnk9UKZjkfg7KlW1s7TjqZ8PDF/5J5qSq30VZf?=
 =?us-ascii?Q?7LWxFLhfC0zEmHFXFzfSYZVVDcAphNjMOUQxa+DRxJtdiA4PsDo/B7P+OfX+?=
 =?us-ascii?Q?wcNSSafPhVKqV/FEbYSp5fJK8Tyl5BeXrRnZy2ywO0kTY43IDdy+wyzegN3Z?=
 =?us-ascii?Q?+35Zo9vma2noiPm1sC9lq3Klrd8bB5xJ0Y3hRfImHmD5WLdw0LrBC4AAa34R?=
 =?us-ascii?Q?VGynURFFih1eCGv5EygOmxAHgbq+6/qZWrrynpaJFmAJZXkZNUpCrgy0g/WY?=
 =?us-ascii?Q?MsZVvF/Dv1wwSbqNNXk8il0Z5yQrifMWsh1yJ/y5TXZ2hpzlz42p9IAtUMk2?=
 =?us-ascii?Q?6zgrh+dcETXxq4128yVk7MOlKOTckdc3nFu6kOgRCu5+OUgg5n+MF37Wbfcp?=
 =?us-ascii?Q?RG90okheWYfjae5+FNfESoUHmzmL4MKEsjXMHJ58jv3oklN53eI0RXPwEbBi?=
 =?us-ascii?Q?qIcCyDI7+sHZ1fY/Q5LDpY9LBq3MPQkDhL+0VigUcq6sa4oxZh3Og25wL2eo?=
 =?us-ascii?Q?B9nBufkSYxZ7PNpBivWvzHlZH8m0KR2m/YxmQMhe26chZqYu0TMbSlfMtSlj?=
 =?us-ascii?Q?tTjMEz8tsTuRYkuQEJio78lIopTdKPopWCq5N6SEG4pw/qxDO5TdVB6e5Rkb?=
 =?us-ascii?Q?rRLMJF0kytG++ImGTUB5++SJW92e/ddxWRgGbCD/BFcEglgm825NUjOS0w8P?=
 =?us-ascii?Q?22m7n6VOAWm7TMQvsTAGlPSOPgGMiaGk3JaOKBO9uqHu+97bCW4OPhn6n2f5?=
 =?us-ascii?Q?mHZEZOdUq72ViIyVe4BhBt7n0usihfjB2TcwcpQYx8+9SHp2lE2s0Z9YJ3g0?=
 =?us-ascii?Q?Sz5TH8w4l1O9RJeqbVzFxv5rrEP2i2A//50+Ah2jXf2AjEjQLgWejL5a8RZx?=
 =?us-ascii?Q?8PHXd1QUHKxlwa9vKdScl/7mv0g2nkmw91iWAcotjfT+0/mJ5ujsx/36R/U4?=
 =?us-ascii?Q?2TVFW7eSV6p7AJd9Otk2/tovpsiDly6cOU3+1VzXF3BuRr6jj9n9tx7pmdv5?=
 =?us-ascii?Q?OBDjZBt9s/ZJNcU9tIuDe1O0y989IyThyA79/VBssRjknBXzaGs6WoONrZF4?=
 =?us-ascii?Q?P+yJQbRnyP2OcUVKy88s/7eJ8CbDuCoc3FLpbN+CFnnyGa9MaFQ83+1Mrn+b?=
 =?us-ascii?Q?8REUWhK4yfDEkpB/iOSP5UQYBg7Q89AxiiSNBq0db66LHhiTTvfGyNa6WTtZ?=
 =?us-ascii?Q?H4v+h7LOZw39MpfE+Kego3FasAvXMMIn5+oYjnaTj8rNUfsvllREtX35WjHc?=
 =?us-ascii?Q?QaPB4n3aljY4ZzdUMeWAwhOWdQ2tdSl/7viWY91H8PXRZtsIYwcTO1xzg7QW?=
 =?us-ascii?Q?qQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DCE301350865CD41AA5B31A1C565549A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ab2ed7-7763-4eb6-ca67-08da7f6a5827
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2022 09:33:14.8141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C/nuyrImb6VY91fRloX0oRgkbzIuayBlg+DqzW2cHhmXMAY+hvKeQuR5gDT3r6Iwgs/zoKR5FfJ9+QMJy9NWGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7484
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ferenc,

On Mon, Aug 15, 2022 at 06:47:31AM +0000, Ferenc Fejes wrote:
> I just played with those a little. Looks like the --cpu-mask the one it
> helps in my case. For example I checked the CPU core of the
> igc_ptp_tx_work:
>=20
> # bpftrace -e 'kprobe:igc_ptp_tx_work { printf("%d\n", cpu); exit(); }'
> Attaching 1 probe...
> 0

I think this print is slightly irrelevant in the grand scheme, or at
least not very stable. Because schedule_work() is implemented as
"queue_work(system_wq, work)", and queue_work() is implemented as
"queue_work_on(WORK_CPU_UNBOUND, wq, work)", it means that the work item
associated with igc_ptp_tx_work() is not bound to any requested CPU.
So unless the prints are taken from the actual test rather than just
done once before it, which percpu kthread worker executes it from within
the pool might vary.  In turn, __queue_work() selects the CPU based on
raw_smp_processor_id() on which the caller is located (in this case, the
IRQ handler). So it will depend upon the tsync interrupt affinity,
basically.

>=20
> Looks like its running on core 0, so I run the isochro:
> taskset -c 0 isochron ... --cpu-mask $((1 << 0)) - no lost timestamps
> taskset -c 1 isochron ... --cpu-mask $((1 << 0)) - no lost timestamps
> taskset -c 0 isochron ... --cpu-mask $((1 << 1)) - losing timestamps
> taskset -c 1 isochron ... --cpu-mask $((1 << 1)) - losing timestamps
(...)
> Maybe this is what helps in my case? With funccount tracer I checked
> that when the sender thread and igc_ptp_tx_work running on the same
> core, the worker called exactly as many times as many packets I sent.
>=20
> However if the worker running on different core, funccount show some
> random number (less than the packets sent) and in that case I also lost
> timestamps.

Thanks.

Note that if igc_ptp_tx_work runs well on the same CPU (0) as the
isochron sender thread, but *not* that well on the other CPU,
I think a simple explanation (for now) might have to do with dynamic
frequency scaling of the CPUs (CONFIG_CPU_FREQ). If the CPU is kept busy
by the sender thread, the governor will increase the CPU frequency and
the tsync interrupt will be processed quicker, and this will unclog the
"single skb in flight" limitation quicker. If the CPU is mostly idle and
woken up only from time to time by a tsync interrupt, then the "single
skb in flight" limitation will kick in more often, and the isochron
thread will have its TX timestamp requests silently dropped in that
meantime until the idle CPU ramps up to execute its scheduled work item.

To prove my point you can try to compile a kernel with CONFIG_CPU_FREQ=3Dn.
Makes sense?=
