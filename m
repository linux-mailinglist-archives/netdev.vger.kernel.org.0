Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B136D4A7673
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 18:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346102AbiBBRFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 12:05:25 -0500
Received: from mail-eus2azon11021016.outbound.protection.outlook.com ([52.101.57.16]:35765
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346096AbiBBRFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 12:05:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTSa+ic8cAQDqrIoR97pGpSDgaF3mmBD83BStcwKEzqZJ2nunDjExgf1cmvm5zsuO/TO6h1TeJlIipgb13zO21joJCPPxAtgVD4H4w2j19QTEvE3afawZHxa/799DqGd7gWqFIo9OMfhZlmxH+Vk9HOMiFTwO1/xn5yfXphiGWGbUDlet/5JuowDOY7JNk9AVwG/UwZu47Ee7z8t8BShmDNA0KuSIQYWQo5XKI+TY0w7GmhCKeUYkMZoLZ5/btKC8g4/mFZj4lFVJsuXFrXf0cQzsf+/NJDHV7WP9dvGr65Qh72QaFdF1inkxd2O0kv75wleiF55DJMWb0vsoRtzcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0t01kgk195gXAAvFOzHPsJ1NeMImznyODhKYvW8W2Y=;
 b=ddjlyyiRHjjX1e1S/ydbFPzi7Lkd/N4JIuZ+4CpmEEQrmWqc6AoQR/qGSTk0Pls4/aMtokkDwjirELpq0MSiWn/qGKCODddxvBaAJN2T4IU5xUfENPdBu5x6wjBvK19/Ss2V5UrrDYI4SMjgAJVPbIMEa4sWCqb/isSXxB7MnZZ/uh5SnrYdrXac0azQ3bqOVArQj36Un+YbNzfHQAq8clGZsntGuKcj9r1yHnldlfehxBqIYL5CYfzLEfNCEUKkNC22O2Ovna4At7cK7lf/Kt4/MJmF0b9s5HDLxz8rB44hAEjsAImKNYPOIWeeeSOt/WUlwofLSLQOGQbKJF+SOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0t01kgk195gXAAvFOzHPsJ1NeMImznyODhKYvW8W2Y=;
 b=czG56DmUKuZj2vrOE2R57Seifw9Sv5f34wxO0aSCEW/q2uxsMl2onVnIR+K7596E2ecOtZioMq8dHzrizpbqHW9fseB5/OsPJ2+0XRzczRKkEd1FQC881oHynWciYKbTzXtlpLlsx01zWwemm+87/5gUFMWXMhNSzR/oqcVHBnY=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by PH0PR21MB1896.namprd21.prod.outlook.com (2603:10b6:510:17::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.5; Wed, 2 Feb
 2022 17:05:20 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::61d3:a4c2:9674:9db6]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::61d3:a4c2:9674:9db6%9]) with mapi id 15.20.4951.007; Wed, 2 Feb 2022
 17:05:20 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
CC:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] Netvsc: Call hv_unmap_memory() in the
 netvsc_device_remove()
Thread-Topic: [PATCH] Netvsc: Call hv_unmap_memory() in the
 netvsc_device_remove()
Thread-Index: AQHYF4lIsePd+/ezGUGXyC0jCaXhb6yAe9CA
Date:   Wed, 2 Feb 2022 17:05:20 +0000
Message-ID: <MWHPR21MB15935F58E55D05A171AE9ED4D7279@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20220201163211.467423-1-ltykernel@gmail.com>
In-Reply-To: <20220201163211.467423-1-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=74ad0ab3-3e7b-4bf2-bd30-21620f1dfd3a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-02-02T16:53:46Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db74cca7-9761-4d14-9e13-08d9e66e31c3
x-ms-traffictypediagnostic: PH0PR21MB1896:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <PH0PR21MB18967546D3537134814FCEDED7279@PH0PR21MB1896.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: isOdJ0m1TSg9JrmQewa2LAAAaB6zEA3qWaayv586cG1wwSM6bAUnBgNdkgJSVW284D94Saim+5aoJxnK2RT4cybybd6wGqJSxmcnhIYonnbTO8VPjRvMLH01FJzVwp49GSRjj/IstIFPzF6e88gayQgYkxA2GH61PpEe4onICZJtPfp0W5U0zSrfdZKXeD+UoX+jhqDehRyLMUG7Lev2GR5FXCXVzmIAi6tL8ib7OCMHGCeAX3Ar1bL6jK05gooDib5bkH9kg9LVUTFymQWXs5u6LoHP9NJ4hTtF9jB7y8S1LGYU3coCoPE7+keLIK84YzTqduH0yQbVumgAUO37xszP9sBHCuttZmKBC6L3KSiFLahvcT4raUZ01TkJPYoJkumSdpsQt/pE1aGkLYKWIJPLh6qCg+fULT3cU6hwg97EiesyYhXD0p8OmNvYR8FeJGwMc3XwH6piD/Tal+RS7cCNnqQcJWxe3kELKI1paCWlalNgivbDNziDH/c9A5Nea+b+BPFpqDFkgMQ1+FOSUuBJCWrUCCDjcBLRmyM6VQmWxJWZs40tXgy8O8w5rjP+nSl4yjlWQL5g7WIUiyY8/fQAAAO9I33DqD9Je0lqdd7mS+818dfdbpwcpQ20zQ8PsQWSxvfeWlFxVQGlUXAUV1RD3rdcsAlAPcJjXNCZykwhgHtajUaJLiTYO1f3D9n52gVy4sMxAohrjRcRR6BYIVg9RiNzklFTDj6UbKECi4H6IFImEeiDtow4ewKjTC8DokB9moQKgCyse8pBJXlGJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(316002)(122000001)(2906002)(921005)(38070700005)(86362001)(54906003)(110136005)(82960400001)(82950400001)(8990500004)(83380400001)(6506007)(7696005)(9686003)(186003)(26005)(52536014)(55016003)(5660300002)(71200400001)(7416002)(76116006)(508600001)(66476007)(33656002)(66556008)(10290500003)(8936002)(8676002)(4326008)(66946007)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9BQyF5c6rNS+B+32zw3WtQNprIBqB+i7o6BHR6yHik8kKwJPG+gARa8daMYM?=
 =?us-ascii?Q?mVTSylGbnIqqj934cwM/1+Bt/GyF/yQo7fW7L/8g5C6WhdmwE2lWSgFHWTjU?=
 =?us-ascii?Q?tbDb+ASXeFVuuvTpJ+pNtwcuw3U5OPDMZQnJPCgj3oFdDx9op/s00z3V9LGh?=
 =?us-ascii?Q?l5qb09NSH1lb4Z8UnXfzkoHWN1DilGv5bX6rLtEyItoigR+3ji2vT8D+1zoY?=
 =?us-ascii?Q?Mg9somwEoR3ETnxfozbLCSf9GfAUzDL4tFqiIVMd8Jk5ejSddUx1bUV9o1eJ?=
 =?us-ascii?Q?vqWLyGP6sC1L1XPeZpc+r5wU32/r8SFP+ZWDFpJ0m9hWx3q6O3KWuGySr2r4?=
 =?us-ascii?Q?Qv1lcLhxGWmlx/O8m5tMff8i98SogRFGUNHxI6mfU2E+LEO9EOo64KL1FrKk?=
 =?us-ascii?Q?bVOifut1AZam9GxaUtLnjW9RO6d6q5Xts5fXmY5a/jZWljYXjFVyYN/Q7jIV?=
 =?us-ascii?Q?h2CNbxgc9O635OXiiJTV1omgBz8I35hcUVN7/c7uY/rfisAfGY03pQ2lD4Rt?=
 =?us-ascii?Q?m2bSMz+I7msgxElBozTWy5lnQ9ulbjUxa6bK4ii2ArRiMLx1dPa4VjsmmSOY?=
 =?us-ascii?Q?lLCcIsFByecO6CuJBz9ExbNXnksuNNJI7LgIRhLWFwUTVIseJNsC3lZ4NPxh?=
 =?us-ascii?Q?st30XzMVJzfgSGqH4qXElecL7veHmV3fRUZkNsYMlm7/zVwvyPtEiofIq7/6?=
 =?us-ascii?Q?B+jAdTMsLqcqCYOEJ2AJybDtS9QhJhGaEwC0S7U8xtSBBCAK+Lom8IjcyP/R?=
 =?us-ascii?Q?s13ZPvkNkruOrMlDoZoV6Aml4RSrhsh0u/jEkb1Rq+o5VVDJvi9He3Ep1UoO?=
 =?us-ascii?Q?8MN6NBDoCJ16eUcMB1jqwNHMyE6RcsIeJV/WiU0Shb92GamQpwPTqqwaAmV7?=
 =?us-ascii?Q?XzSwaFtyCvDK4r1zklbUG0tbg5nW2W+PtjS59IkSISJ8DQnLGCCIr7GlDFf/?=
 =?us-ascii?Q?6lq/0wlleaeEg37OrVyn8U91SBzdKyR+Xa+Kh68LLfTmbcfE05zCg+HtT15f?=
 =?us-ascii?Q?+9G9g0YNAxbnTs1KxTbgwsL+GXwqfsDt8nCwx0HX6rt9ND1Ica5q8x3y9Tvc?=
 =?us-ascii?Q?Y4wQkipnNKnr9mzeWXH4699w3Yq0qSSI44OOSeBDat2P1EIqsUst/SUXmyTh?=
 =?us-ascii?Q?/hPLwrSNeAevUec+qXQsWDWxTni62a3ctxUp3cTYtjCZ9NhVI4s6sBlXAWzx?=
 =?us-ascii?Q?Vk+nGssF1lQrvUQyLXrBYeiWxs4TFyho1IoVmSHoJiwMOnI7iDaWdzXaizKw?=
 =?us-ascii?Q?N00Mr0sboxZuhxVdk2ECf0/9nq+yhUP21u1x4BAXSNzb/5Ei+2SmxIbQwh4h?=
 =?us-ascii?Q?N0fCGiU5btrK0VakJ+ptR15rTIZsfxUe8xVXyx9RHHgUMqdrhHPmw8J+8qH0?=
 =?us-ascii?Q?wc5uNBi/w6LWll+DvtoqVASk60P0+5EciKZv9h+V3Rugecczh7ZKcDvSGXpH?=
 =?us-ascii?Q?Aov/LlmbN9dJmuag6DGkQTuLCaYpC1J6uAOXFhNwZ2U+Qf3BSkhJfBaOlm1X?=
 =?us-ascii?Q?nLSSUxcf9ng1Fx+aZwNQVcAJEovgnSYmqDiGx+aXXZAVWoKNkhVjD+IUUNSw?=
 =?us-ascii?Q?xXAUKSDH8IyxxQPfdOrlWdXO6YOFU/xpREmCgscXW4KZopQ1GUY75CKblqFb?=
 =?us-ascii?Q?x1VjmvtR7633L7UAEHSQk0rSosxaxeuyBILf4O1YiaXuZz3LguS25pkOkdnh?=
 =?us-ascii?Q?YHWrxQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db74cca7-9761-4d14-9e13-08d9e66e31c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 17:05:20.4330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HI3ay60YGfo16iuV0BDXvrHxTpm8jvsvro1rl+RraKV9mWYb4jf0+u2BLw6k7tXcyYL+GxleMn7CYqFmq/I+9fTvbWiLjWSccaFcd8rUTU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1896
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Tuesday, February 1, 2022 8:32=
 AM
>=20
> netvsc_device_remove() calls vunmap() inside which should not be
> called in the interrupt context. Current code calls hv_unmap_memory()
> in the free_netvsc_device() which is rcu callback and maybe called
> in the interrupt context. This will trigger BUG_ON(in_interrupt())
> in the vunmap(). Fix it via moving hv_unmap_memory() to netvsc_device_
> remove().

I think this change can fail to call hv_unmap_memory() in an error case.

If netvsc_init_buf() fails after hv_map_memory() succeeds for the receive
buffer or for the send buffer, no corresponding hv_unmap_memory() will
be done.  The failure in netvsc_init_buf() will cause netvsc_connect_vsp()
to fail, so netvsc_add_device() will "goto close" where free_netvsc_device(=
)
will be called.  But free_netvsc_device() no longer calls hv_unmap_memory()=
,
so it won't ever happen.   netvsc_device_remove() is never called in this c=
ase
because netvsc_add_device() failed.

Michael

>=20
> Fixes: 846da38de0e8 ("net: netvsc: Add Isolation VM support for netvsc dr=
iver")
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  drivers/net/hyperv/netvsc.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index afa81a9480cc..f989f920d4ce 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -154,19 +154,15 @@ static void free_netvsc_device(struct rcu_head *hea=
d)
>=20
>  	kfree(nvdev->extension);
>=20
> -	if (nvdev->recv_original_buf) {
> -		hv_unmap_memory(nvdev->recv_buf);
> +	if (nvdev->recv_original_buf)
>  		vfree(nvdev->recv_original_buf);
> -	} else {
> +	else
>  		vfree(nvdev->recv_buf);
> -	}
>=20
> -	if (nvdev->send_original_buf) {
> -		hv_unmap_memory(nvdev->send_buf);
> +	if (nvdev->send_original_buf)
>  		vfree(nvdev->send_original_buf);
> -	} else {
> +	else
>  		vfree(nvdev->send_buf);
> -	}
>=20
>  	bitmap_free(nvdev->send_section_map);
>=20
> @@ -765,6 +761,12 @@ void netvsc_device_remove(struct hv_device *device)
>  		netvsc_teardown_send_gpadl(device, net_device, ndev);
>  	}
>=20
> +	if (net_device->recv_original_buf)
> +		hv_unmap_memory(net_device->recv_buf);
> +
> +	if (net_device->send_original_buf)
> +		hv_unmap_memory(net_device->send_buf);
> +
>  	/* Release all resources */
>  	free_netvsc_device_rcu(net_device);
>  }
> --
> 2.25.1

