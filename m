Return-Path: <netdev+bounces-8858-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 855177261B5
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D54701C20BCA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8176135B43;
	Wed,  7 Jun 2023 13:54:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7B2139F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:54:59 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8531BE5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:54:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UgDHpu1DeMOGEd8EaeIF922Fhbn3HPaf2k7a0Th6NQ5N+ixpTF6fW5m3JscAnAaQal+b81aLq7DH0pK3g2oJYEBPnEuQCKu/gFJvwnhWGmnh150Yo8D+limOvG5hRQmC9phl1OFT0UOTnfUSIM5C2b2bqCdItjHILtmajgBzuxnATzcNfgpVYpdfo5GyWozMxrcAhOS5jGPkrCiM5Hq2er+YxCJWVGRRbvGAo0yViZHtocRa8vN5e11WcCqcfXG32Q5JDo4f1odLp4yGZDotI85Enx3egF9dHV1HkB/JeP1tkm8DZsgJRX89H7Vm/TP7q7uBoB81OqSA6iUIESTZCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUEmooSEWg4wvdAnozSzLnXnT9XMETQLwmgNkIf43FY=;
 b=GbPnWzrir88j1kNCNgajYR48zP57tED0Q8nkjtKOZBjQD3w46l55uVH3cORpHkBLwAGJOnIKyH7qNYfqGoLlT0b34kb6UPKdH+K04W456Si1tFblg364L+IRZyTWJ1ypH6etzEPS90NdlYqLgt4n9+8rQCcSr9e8FaN45d19aVkCFfwojLkBOdLwR01RIMLftTvuEUfXP1VK4IwKogHqTWEC4CiwBvDcKepfZUBEfKWeQc/+j6KOhEO4BuORt6W+KJJaZ6UlZhe8715h49RuOsObkW5gl7YLphRTLcQsW3OvkBg3dPEoY8fO8rmS5jYKGr0GEdACUY65tmr0ILy8Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUEmooSEWg4wvdAnozSzLnXnT9XMETQLwmgNkIf43FY=;
 b=cAFEwAN7YbLe5vRl5s9yQT/5B/NEAuFtGGaq8YOcpcNn1VNaQXQRAhAzQnNObiFjOnBt1o9YI663xsmJ5zwI2GbjkNTVCnWBY+ovcCnGtvnhw0zyx3wqJZE+s9Dp5tj+1S/vdR5SlimME2f1WLifKuR+onNuWUQ2Qci1y8eyleWbIQRk2ALXCYPMUxgH+LSLzaJGEPeKlX4hx2EQuoGlOydS/BAc/tmZic1F3qvWiYw7jMC7xSaO17+nfhObU5kUgP5l6eufHHXdlhVOIOeSe88F+wskgaN+X/OvBNX9CQYqwj0z8BflPG0I+pHvTo84NsAPyfkTYfgJYi9D0Bwckw==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by PH7PR12MB8038.namprd12.prod.outlook.com (2603:10b6:510:27c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 13:54:53 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::fb8a:a6f5:8554:292e]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::fb8a:a6f5:8554:292e%6]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 13:54:53 +0000
From: Asmaa Mnebhi <asmaa@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"cai.huoqing@linux.dev" <cai.huoqing@linux.dev>, "brgl@bgdev.pl"
	<brgl@bgdev.pl>, "chenhao288@hisilicon.com" <chenhao288@hisilicon.com>,
	"huangguangbin2@huawei.com" <huangguangbin2@huawei.com>, David Thompson
	<davthompson@nvidia.com>
Subject: RE: [PATCH net-next v1 1/1] mlxbf_gige: Fix kernel panic at shutdown
Thread-Topic: [PATCH net-next v1 1/1] mlxbf_gige: Fix kernel panic at shutdown
Thread-Index: AQHZlX+JJDuaDuAbbk6lZFqBQ/F84K99nX2AgABwX4CAAVY64A==
Date: Wed, 7 Jun 2023 13:54:52 +0000
Message-ID:
 <CH2PR12MB3895172507E1D42BBD5D4AB9D753A@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20230602182443.25514-1-asmaa@nvidia.com>
	<9df69dcc0554a3818689e30b06601d33fe37457c.camel@redhat.com>
 <20230606102921.653a4fd2@kernel.org>
In-Reply-To: <20230606102921.653a4fd2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR12MB3895:EE_|PH7PR12MB8038:EE_
x-ms-office365-filtering-correlation-id: 318e2ea6-14ae-4284-46df-08db675ec4cf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 WqeWjmnc/iNmJTLCjKQyaqyaNbjfOBRuNHnLoz9MDkke5RFkQr4hLMcJiY13SWLmQHzg3i4TL+cjWQMJNp5EaE9LpLs1qC9tVsYz7Np7lmH7yw2mpZ4PRFP1BrVbt+jlPXL9LYiaGHJP+rXy4KqtwWbkdSx+VhIhg5hzJXvY88wRbIm3LNbCf6eXbcjlaal0iVbAHb6PJaEi7lhAeQQReOAA3EpFHZVxmhrVQPZ+7+ly3lQmKm6VZj8GytboUV7hfreIMlNkQWoshRlnVodqitJI3fUSEyhAnVsC0yTTPA0YZTK+HzLiWAGapfJyvUamaZS8wcligr+jGCC+fi1voVRIVsrFGL+dLTMOdmBVesfJyE9Ddckr4r1SmeikcxXU7oBxTmbg9lwenknQbLwmEIT6OgE7ywUi8ssuoiSycgcvGp1MV68rCy/AOF74RC0GryjcrZanZ+OPG2k9TPwii9yG1+YSglsWuDSVodBd1OH7UoSiBWgCPI5azICN6DhY14YZ3+SyuOMCleYD3e4Oo7AIh9fN5ht6v73hzPYFycwNp7+1tO0wtV+m3VVAul+9XK8fI0XJHgTDxiH/tU9QakHRc+dKEsHsZqLIG6iURod31sXmrfb7zH09VKcd+jxs
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(451199021)(110136005)(54906003)(33656002)(55016003)(478600001)(8676002)(8936002)(41300700001)(38070700005)(316002)(66946007)(76116006)(64756008)(66446008)(52536014)(66476007)(66556008)(122000001)(5660300002)(38100700002)(4326008)(86362001)(7696005)(71200400001)(2906002)(4744005)(107886003)(186003)(26005)(6506007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?kKkwweLeRbiuV/eBYnFmWAP4AVSviyWmViQ0a5e4T+sjHSzJN3XUd1+FLQqE?=
 =?us-ascii?Q?9sim+eQhk6F/ih9q+/YK9RMlAV8BNpsxzmcL7ys58VJP8dS3vVmwRB01aBY2?=
 =?us-ascii?Q?BlOS0nE+Aa5jv5xSZWvPm8jzC4AkKBh5s4pxRhM1eoWFtGXYd47/fM13QqBV?=
 =?us-ascii?Q?tYxNmUAuiF7RK8NRqQvmqHuRSCC9wBvQ2O9ui+nVWfRjeAGf7RuiY1ab2T3n?=
 =?us-ascii?Q?1oiom4jhJ0gmOSQjbFktrMDnO5G2eF24Of1xat18nVMeceoEHO2Bg81A2LAc?=
 =?us-ascii?Q?Yi0FceAVCfvziRAu4xvLhIzxUBvf/LiHnKUlU6PQKs1x7NM5MaKzZ3PeDLtq?=
 =?us-ascii?Q?cu1U3DBNWQLalPS4ncPCfJEtY0Mw/82Ck1WLuacVqicy1onIpbJ052v0hMwG?=
 =?us-ascii?Q?0PF5OkYhI5GMvxbC6DpSmrvEi3KZN2QyppmCNf1zrQYO26ds+hFdTVL+NjIc?=
 =?us-ascii?Q?QkMZ8LgtVm1W+VNpVGcUXvzBQOQUcaoGpV6HuAIq7fR/aXLlpB+PPWY9/uuE?=
 =?us-ascii?Q?8v0NZx+iGMCmrluvC2MMJuIQYyeCwnDpuAMxxU7E4m+IApZ07+lKbAZHbzjf?=
 =?us-ascii?Q?P3kpV+L7f8FdiDjfvw700/MFEmaHt7upsDarMaRbydYWr82DHynJD1G+PWYX?=
 =?us-ascii?Q?vUN/o0beF4pPdAGy9IRyKS3bP3zU6TcSugCHV03APWjbmAQNUIyMLOETPLKt?=
 =?us-ascii?Q?pazYTSdTEAHYtCRA25HiWLUQSVCAjPJS364CS2TX/1/oA7coKalLPd91N7p1?=
 =?us-ascii?Q?Oc8AGE6ziksS09KdQEOnTEc8l1JX7PnnU90nj1aJl+UkrcmxKE5vc1vVEz+u?=
 =?us-ascii?Q?15q+2m01RKWY4DBBHf1rKZ6vLlfjWoUNzJYqDJXSVQgJTi/f6XluM9i+gsAJ?=
 =?us-ascii?Q?PRoNg8hVwdL7uEsbpJda6XqnwQdYlIorrZotSqQHvnH+Z2THYdpiGtItcsut?=
 =?us-ascii?Q?2FotWvN48IJAlke/jW6LF3/BBKh2G4058RjYU5KFI26TmRGJICZi1ykA2TCm?=
 =?us-ascii?Q?rNTTHF3YC+/66t3njjjF5seXIYgAyJvgIfMu+K9VF3tz/bwlHTNlxsgUJRZQ?=
 =?us-ascii?Q?VYR7KaEMSkuEz7yfxQoK4CmgaNbCwn/DFTZnZoeKnV2qoYnatRWbPx58Cmdm?=
 =?us-ascii?Q?RzoUlyMfkwHM7kunwc3/gCPA/YgySLGc2pLK1Dipc5PANt8IlV5ikjADEtBl?=
 =?us-ascii?Q?azX1qDd1CeWbSa3wTQZTlkuntm5J4jGgpeqBjg4/bM5sHgGKXKfyiOBarnnP?=
 =?us-ascii?Q?baCGKTiI+AiOH7SEwxmNhwIJ7+ZO7tsaO6qQjzyUuE6+FzWqr5XT3TBtdz9l?=
 =?us-ascii?Q?qTeRR/yf1LUXB+fXV0LAbQf0DiYkxetMfwRBmN64Z5cpPUL8miZPH+O9Cbwd?=
 =?us-ascii?Q?kSwZiz56+ZTytdPp4kddqz0iojHBQd97Xp5cRs6HBiY/jWrYbUHzxD2COXzm?=
 =?us-ascii?Q?4QwbvKvQt8iGgbu+yiuIm0wKq5h1pwGg297fymijMuTDJ7hWSaQG1WnZfxGp?=
 =?us-ascii?Q?yk0DHnDj5qJHiBTKPHZombjvtQY4hwfNz95qhPVgMUFMRVfLpPrqbemgTrse?=
 =?us-ascii?Q?haE+TqHbyIPn7Cjc09c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 318e2ea6-14ae-4284-46df-08db675ec4cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 13:54:52.8998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gGSDJplCKs29wK3atFywSm8KUVkKPYdGRnJ+9A6yquf4wyFjn6dEsgR0EGdb2x+2FXp4X57BhGbV7WO8HxJ4yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8038
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > >  static void mlxbf_gige_shutdown(struct platform_device *pdev)  {
> > > -	struct mlxbf_gige *priv =3D platform_get_drvdata(pdev);
> > > -
> > > -	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
> > > -	mlxbf_gige_clean_port(priv);
> > > +	mlxbf_gige_remove(pdev);
> > >  }
> > >
> > >  static const struct acpi_device_id __maybe_unused
> > > mlxbf_gige_acpi_match[] =3D {
> >
> > if the device goes through both shutdown() and remove(), the netdevice
> > will go through unregister_netdevice() 2 times, which is wrong. Am I
> > missing something relevant?
>=20
> Good point, mlxbf_gige_remove() needs to check that the priv pointer is n=
ot
> NULL.

Thank you all for your feedback. I will fix it shortly along with net-next =
-> net.

