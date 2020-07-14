Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824F321EF2B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 13:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgGNLVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 07:21:51 -0400
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:43265
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726332AbgGNLVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 07:21:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYl5NWLP/VgSeFdGO6leCjOBUhOKllFI8zESJodDya312xizmf2N7QN3ln2WLydJelCRxO7keXhhowDCdpXrr6wEA6mCLzNv3s6EHVrgMnf8Wz056WWppms7Nzd1eMMAKi6wccmjMCsf79I3PkIDaZLenARNjJU4D7I724UNbUQrGnqRuL5hQPPrloh9vQEYoZOewsUhZY0Bk6maOOIbtXTVIp8lonSr/OFhR4f2bm84zA3bu1UmmWTz1EcxGt6SEoeN/zrbxG8bP+i3rWT9fHFcEVE5SdSNnn9Sivg0a+B0gNL86sU8zLNXIBNJwN0sNTPhDCGbsKn2EGrmFqL3zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WU5Wa/2mAYsYvfK3IQXXyyxaPxL6hyhhNvlsp9HXz2s=;
 b=knmRbrbsRCCWmQdQ8HE4gC/rPb/x8q4a4/CrI+RW9ESW58a1rxUPeNJtbEO+4JYqXhEPy0foQOHsPdw4QAzgpyLjANR8JyfoP7ycQoGURyXU8YzHqvtvObNYiCwFCJ+VwkV7Gq9gy78zfKJ9xrmQiSIG5M6a+/LQqJwITXxZjD1tAlbEo4KCZapeswxRz2/cIra4OlexFsQQHosXjw7W9hJfgHxsmsgi7cMMtZ/oQcyNJCF2bUXueEUJ1vapIU+FuD1II8E3G2q7TSxPu+7l1Vbt2Oae8LPfDfscQHKFassuWHSVo18WKM2iCoGfz8bNgOas4EJl4qiyGJHB+QD9yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WU5Wa/2mAYsYvfK3IQXXyyxaPxL6hyhhNvlsp9HXz2s=;
 b=QA1Tzss0aEeoWnD6fRvuXwwYJIC5jt/Gm/o4DD/yFGmkpwSnobKkzvE3ZVNb4H0pi9jWCSciMfN3emPzlrbxuX1ZAwk0GSdC2KC3piJ/XQf2eqDSXaCLtxq7kIFW9Hg7F0ndSDhs2pKpDrIaAB9pO3Opa92CnlEtVffhVEXNJTk=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR0402MB3618.eurprd04.prod.outlook.com (2603:10a6:208:16::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Tue, 14 Jul
 2020 11:21:46 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::41d8:c1a9:7e34:9987]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::41d8:c1a9:7e34:9987%3]) with mapi id 15.20.3174.026; Tue, 14 Jul 2020
 11:21:46 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 6/6] enetc: Add adaptive interrupt coalescing
Thread-Topic: [PATCH net-next 6/6] enetc: Add adaptive interrupt coalescing
Thread-Index: AQHWWRUEtFwuN/BWrkeUwPH3KcNIEakGGDSAgADPmBA=
Date:   Tue, 14 Jul 2020 11:21:45 +0000
Message-ID: <AM0PR04MB675470086CB8131D715D402A96610@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <1594644970-13531-1-git-send-email-claudiu.manoil@nxp.com>
        <1594644970-13531-7-git-send-email-claudiu.manoil@nxp.com>
 <20200713153017.07caaf73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200713153017.07caaf73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.66.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cba61f40-1946-4b3b-6c5b-08d827e817f3
x-ms-traffictypediagnostic: AM0PR0402MB3618:
x-microsoft-antispam-prvs: <AM0PR0402MB3618CCD1CBCD94D2AA9129F696610@AM0PR0402MB3618.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jCB8kZqAg2Ehcah5Aki5zDdoXCZUayIjq4SoASSsCoQE3TNlO6peM1TO++5NK9Y6aD73Te1Df6g6Ust1BwG1jv9arZ9LTxHokH9SlzozzqoZ7UDzCWJTagVVGVMoyjM9Yl7zjDx1ajjxtv/zb5N4hWQaX6kq6kpK59/7dRUFdB2Ea8evcwuVRzGQkiA00bgfGRZu3DVAr8bmgbhhvHIPJin1OfAUOq//HtaDE2IkNPZDBv/JZ4FHwgrbAjf71qLgJw+H9/nP+goxbBbBVoxRHZgNprDucIuZmLMxmBwrKqQ4kS0zYYiSmjNk35y0L0E4ig5OEHQKCzgDSHqXDp8Mwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(39860400002)(376002)(396003)(136003)(83380400001)(54906003)(316002)(71200400001)(478600001)(55016002)(4326008)(9686003)(6506007)(66556008)(66476007)(76116006)(186003)(6916009)(5660300002)(26005)(7696005)(33656002)(66946007)(52536014)(2906002)(66446008)(64756008)(8676002)(44832011)(8936002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZWl4iqjL6GSmhKdBmoV3KkuJik2x4TTemzaVjmokOK2d4eysnl487N6U4VuA/9Dhy4Iy5zVCAgMya7hdF2ihoHEAu+zCPBq/KVTncHyvrfPWZiURScHDo4VuwTwoCM7IAYvvxQHp2JAfUqQyCHBAWqdZJHe8ee0JG8lsDLBwfiO5ZUhHarVu/clY2Zdk2dAJLI0qtVbEPhkPlUlwNKgCblfgHdz8cinopx4oSh0ea0AlfItbWxvv374glsZ+87+M5e4xLiAwbjM0PpCcfCUiz2iOX6RwezI2ddtEHz94YC0yzZQksM61vdC4kvio46mQgBU9PvEMPZm6ihkVRrib0zRcgt6yXDBevEzuy9ygdl67t2FGdA6H8XQsbvybp3rC7pSJTcwkAzHgJvd/XVAxZQ0wyvjyEJL7dv1oUZVwZI9uSEQHljJnt+hfaKQIoxr/8dKq4jJGBLe8eJLiYm4NZUOJLfIWrOZMpQVnLKr5YaI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cba61f40-1946-4b3b-6c5b-08d827e817f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2020 11:21:45.9800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4mXjgSfEa7i5AarnRioPp/7kxSVZSyGrGpND1iVs3veprbxQKDG4Ndi4hq/S3YPCfXd/p0Hyp1A/d9NEh65Y4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3618
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
[...]
>Subject: Re: [PATCH net-next 6/6] enetc: Add adaptive interrupt coalescing
>
>On Mon, 13 Jul 2020 15:56:10 +0300 Claudiu Manoil wrote:
>> Use the generic dynamic interrupt moderation (dim)
>> framework to implement adaptive interrupt coalescing
>> in ENETC.  With the per-packet interrupt scheme, a high
>> interrupt rate has been noted for moderate traffic flows
>> leading to high CPU utilization.  The 'dim' scheme
>> implemented by the current patch addresses this issue
>> improving CPU utilization while using minimal coalescing
>> time thresholds in order to preserve a good latency.
>>
>> Below are some measurement results for before and after
>> this patch (and related dependencies) basically, for a
>> 2 ARM Cortex-A72 @1.3Ghz CPUs system (32 KB L1 data cache),
>> using netperf @ 1Gbit link (maximum throughput):
>>
>> 1) 1 Rx TCP flow, both Rx and Tx processed by the same NAPI
>> thread on the same CPU:
>> 	CPU utilization		int rate (ints/sec)
>> Before:	50%-60% (over 50%)		92k
>> After:  just under 50%			35k
>> Comment:  Small CPU utilization improvement for a single flow
>> 	  Rx TCP flow (i.e. netperf -t TCP_MAERTS) on a single
>> 	  CPU.
>>
>> 2) 1 Rx TCP flow, Rx processing on CPU0, Tx on CPU1:
>> 	Total CPU utilization	Total int rate (ints/sec)
>> Before:	60%-70%			85k CPU0 + 42k CPU1
>> After:  15%			3.5k CPU0 + 3.5k CPU1
>> Comment:  Huge improvement in total CPU utilization
>> 	  correlated w/a a huge decrease in interrupt rate.
>>
>> 3) 4 Rx TCP flows + 4 Tx TCP flows (+ pings to check the latency):
>> 	Total CPU utilization	Total int rate (ints/sec)
>> Before:	~80% (spikes to 90%)		~100k
>> After:   60% (more steady)		 ~10k
>> Comment:  Important improvement for this load test, while the
>> 	  ping test outcome was not impacted.
>>
>> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
>
>Does it really make sense to implement DIM for TX?
>
>For TX the only thing we care about is that no queue in the system
>underflows. So the calculation is simply timeout =3D queue len / speed.
>The only problem is which queue in the system is the smallest (TX
>ring, TSQ etc.) but IMHO there's little point in the extra work to
>calculate the thresholds dynamically. On real life workloads the
>scheduler overhead the async work structs introduce cause measurable
>regressions.
>
>That's just to share my experience, up to you to decide if you want
>to keep the TX-side DIM or not :)

Yeah, I'm not happy either with Tx DIM, it seems too much for this device,
too much overhead.
But it seemed there's no other option left, because leaving coalescing as
disabled for Tx is not an option as there are too many Tx interrupts, but
on the other hand coming up with a single Tx coalescing time threshold to
cover all the possible cases is not feasible either.  However your suggesti=
on
to compute the Tx coalescing values based on link speed, at least that's ho=
w
I read it, is worth investigating.  This device is supposed to handle link =
speeds
ranging from 10Mbit to 2.5G, so it would be great if TX DIM could be replac=
ed
replaced in this case by a set of precomputed values based on link speed.
I'm going to look into this.  If you have any other suggestion on this pls =
let me know.
Thanks.
Claudiu
