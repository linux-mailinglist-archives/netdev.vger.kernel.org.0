Return-Path: <netdev+bounces-5739-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B51DB712999
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:34:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70DC32818FD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBD1271EB;
	Fri, 26 May 2023 15:34:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7015D742EE;
	Fri, 26 May 2023 15:34:46 +0000 (UTC)
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020022.outbound.protection.outlook.com [52.101.56.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C072E4C;
	Fri, 26 May 2023 08:34:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bvp0ugzbthmxUrq6+edrtef9b+hjpENwlDRF0vGnyjx/95Pm2H8pRCGGrTy14k8iEoRtCsNeRHVVcPpPDxd8XxxfT83/XyxHUtAGYHlL8FGOZCJWLw/eO8WDR5lB6+N2LypviBy6DoCrfGVIfTMuEM1xzrIq76CNX/bUcrEU6oAaV/nMACA2eEkQf+GQJSkvGGlV5EhBE307u6iGjN/CxdWM63Vuc/zfOCR9nNSHD6Wi05Ft7aQ7YQ7ZUMfq9pEqqxerXtvBi2owg78ldPAlzbQaGwdOPbec/d39v+TqFM9qIuoSE30Ol8M0UlEhldUaGWiRRNoATv/nkEpg0XGIWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0F90SGOgTbVGTooF+2XmOUazdEm36FtnHXGO0IBIyM4=;
 b=KVld+yloKS8/BMNrNJsJOiY1FwITKpqFLTwjvtKBwTs+pKgc6bDcB1O82HnWac3vUQEnoso6MtU7p7s0K+VDTH+2qdQN+xfW5yoo6GQ7+d/WLI6fxx3o3w5Qs8pRafURM74kHHoBkvWIl2oNFdQAZ9o5fmcqvAPdw2e6lDVyC3jIp0VmHdzEvUdaZ1t98o9pTiysWMyr+vmbYHGMlN/5RP/CZ1s+FDdMk8Ks1uQiIhTQriW1kKzHXzVoBxonxSCkOjxZyxUqjuqFI2ZO0w0Hj55DuxXCfbyPI20MY4EyOQRNbUW/Xdc1PdI41g159pFpx8xDB1eZJnr4mjYCwtfKAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0F90SGOgTbVGTooF+2XmOUazdEm36FtnHXGO0IBIyM4=;
 b=Gjy6XQKSRsGbioeozzyZLhHhtwd5VV/Zhrl9+wL0K6LoKG9E+SPlK6plv9WaIslDEuJLolAqM/8Cmexi93ejHAY3rSSZDzWYLrc2LKQy/58lV+dhZssNLQGzDxnjzMSs6JOswGAVuMe7jqnNMF/eActsKjVPiiO6fhX62f0WanU=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by PH0PR21MB1327.namprd21.prod.outlook.com (2603:10b6:510:104::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.12; Fri, 26 May
 2023 15:34:31 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900%5]) with mapi id 15.20.6455.012; Fri, 26 May 2023
 15:34:31 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Dexuan Cui
	<decui@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Paul Rosswurm
	<paulros@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	"edumazet@google.com" <edumazet@google.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "leon@kernel.org" <leon@kernel.org>, Long Li
	<longli@microsoft.com>, "ssengar@linux.microsoft.com"
	<ssengar@linux.microsoft.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>, Ajay Sharma
	<sharmaajay@microsoft.com>, "hawk@kernel.org" <hawk@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: RE: [PATCH V2,net] net: mana: Fix perf regression: remove rx_cqes,
 tx_cqes counters
Thread-Topic: [PATCH V2,net] net: mana: Fix perf regression: remove rx_cqes,
 tx_cqes counters
Thread-Index: AQHZjxe4aWBF7RgXTEqOWnaG2HOEma9r5WKAgAC54BCAAA/0gIAAAWog
Date: Fri, 26 May 2023 15:34:31 +0000
Message-ID:
 <PH7PR21MB31164EDC8AE1AB8E2E54EE50CA47A@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1685025990-14598-1-git-send-email-haiyangz@microsoft.com>
	<20230525202557.5a5f020b@kernel.org>
	<PH7PR21MB311639268988CD72DA545774CA47A@PH7PR21MB3116.namprd21.prod.outlook.com>
 <20230526082819.26ab0a9a@kernel.org>
In-Reply-To: <20230526082819.26ab0a9a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=613f761f-d26c-44d2-9ee2-40bab7b47b41;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-26T15:33:22Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|PH0PR21MB1327:EE_
x-ms-office365-filtering-correlation-id: a3970de4-4181-401a-6da1-08db5dfeb336
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 eHkewELhPdDF5mfnxEDzMFmWAtR9WFxsjG2Zacmwx3bmztQ4PSvUVeITRPElJVa/Y6BzqDU1PrR36Jx9Zd+dVG8Mas8qBikgDOb6RX7nMiZrzHNfBqWSXXkkoPOu1Ys5oq1R04w9Z62zvCynW71Ndnft2EP5LP59RlBo+f905V8eZjxI2FYUzWQVrhOd65nBvMvGTTvN5uJYLKIAUtAahk859NRUYDwYKh63hLOjPtOMfHBmkufLvWvduS4kZI8nxZ1V88ZlYUV0VhU0r+74RCN2VuI3PPTuB9FPmIFolm3/IchQHqDif8gud99bncGsRbPN6VSIIH0s/P1KMfXWVxaJLaeyUlp3AvnAuoL+eg2+f9lnAlNGpss71EqX8B2OvJMYyCs7mPh1rn+BVNCAnu+MvvW0RWSzCfdV0boIKLxLLWkXUJXMUX2YjnYRD+5Ch6+MpidV84ynuoWalZuypGeR3Le1PS1vMTF9Zad4VAj0P/y0lTWZNo8XvVwbO3wJFWyh+ZZT99eHd5EOk4pPOHucMBYK8sNBIauAzbj1CLlJvnOPyfA/1LvaJzLpzY4/42pBQjpsZlzzRUSZhWI+zGcABq6ZfOiK31tB2iwJUGJMcZo8w4uk1YnDij+4HM2X
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199021)(26005)(71200400001)(786003)(316002)(122000001)(82960400001)(82950400001)(55016003)(7696005)(41300700001)(478600001)(38100700002)(6506007)(10290500003)(9686003)(8990500004)(7416002)(53546011)(2906002)(186003)(54906003)(33656002)(86362001)(8936002)(8676002)(4326008)(6916009)(83380400001)(5660300002)(52536014)(66946007)(64756008)(66446008)(66476007)(66556008)(76116006)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ei0fyuDCSkgXjWpFKO81x8vy0IHMqliab9B7hRSmd5DaxbpHLOiCouSIVp/L?=
 =?us-ascii?Q?66Bav9+OWw6Qj4HVVwzrIuEfiGxfgqdZHbeEEa1ldHtFsNS7h1NIjRakusUe?=
 =?us-ascii?Q?DuSY/CuW+XWISbj4KOENBR1Or+wAnC/ltW3kabg8PTKv330aTl5YQRfdsAbh?=
 =?us-ascii?Q?n85WhRN29TrFr4G0JMfwb7cqe3y34aiIxH/ue4IlGUtyD3ES6FF/rC48ZEkS?=
 =?us-ascii?Q?cnxIrqJi3sf5pnPsTH9lYRqghk75LvsOqiEFnSAWc7PQSAq4Dxzt8keSQh+1?=
 =?us-ascii?Q?HwVZYZCQXe0R2MIfzVLA+Trh3uZkIVtJO4hxabGB7Cu1L9RJfDcp2MxR0FAP?=
 =?us-ascii?Q?+yoh9Wk6c4H5LGn9rP90Cv7ew0uCXBcWNHwTYSb59Foy18jcXxFTNmwVTx86?=
 =?us-ascii?Q?4ULyYEEWcGcvMIlXUA1BGZxenYCmaEWZAdoFl4O9daeLsEbzTxueDcqu+ywa?=
 =?us-ascii?Q?8tTScG8TO52mntV20tTJa9khoKfTi4Pi/h6CbEfOvR07S3bM2MkRBRkBD7f7?=
 =?us-ascii?Q?DQT8Uddt+NT3Mjyl2U9XaEbuOnAqRsY9H3Qu+HirbsXTyiL/zizlqPbCChiI?=
 =?us-ascii?Q?31E6fSIH4dpUcvzJqP73TiNqNUMQ5SkH5/FrunlH257XWJp1B31NBT7wJgPw?=
 =?us-ascii?Q?vKXB5gPG/7W/BSH4/jJBE59nAEQr1d9W5MjBG8LYsVt4C/hjer/X3ebvwMvD?=
 =?us-ascii?Q?+PuHkuVLxe5g02x2jE5AW21ZQI/Fgb8xrxuCDrpnXOBvs063Q4P9u3OuTcXC?=
 =?us-ascii?Q?EINo4ivqgFxdl8YlyIfItDI4l3pBsAj5iCgtiGW/DkJme4BUt3YgVGxUm02R?=
 =?us-ascii?Q?PPkJAfj5Hna02o/lSPvTmh7ZtL4MAF70YIftC/Rp5IHyOcgSXwISmsO97NmN?=
 =?us-ascii?Q?mySdW6ciSWE921JrA3YzjScLx+1iIjFhODiwu76jucMCz4iP/EJBbn4nKxqZ?=
 =?us-ascii?Q?oHF0ceLuae4ZvUZdjHML4twdpcrfKIhgplgDpkTPNbNJ6v0X6FkNJwbi99oT?=
 =?us-ascii?Q?jPGsIsWBRC7HBEDr2hAo58t9Dz66fXOP02n4/BctUJomd72QLKvKtekwhcOX?=
 =?us-ascii?Q?tbzffsfxJ0BGDwb0SkNg+LoHGDAsZhNTuhaFHYX46Yj5f/VHj2qfs5qEFyOu?=
 =?us-ascii?Q?sFs+9i38AtmahCHmkGiaUCmQXsP5nnlvzawTAqj9LUh5yxocVoAuA9k28ZQB?=
 =?us-ascii?Q?CdFa+bFp37rL5TtOMmeRHVm0+zjYIrNhW1uklQjD9TOgRYKrk4cuZy+NH452?=
 =?us-ascii?Q?nIQ7kplQV0WSbWVh5s38kZpvLuf33dgJ1SO26HmC5MBrBXhtlnH85HbXAFAU?=
 =?us-ascii?Q?fithpjEE4BSOd4VpPriJJPaRLCrb9NhQT8LTYzoq85RWkEbSzMydYLiF3nh0?=
 =?us-ascii?Q?MftXHFAoJutMVeBDdm1sX4W+1135R7q/uHkn1S8mttvj1tMu/xiyWUoq3i15?=
 =?us-ascii?Q?gzWYRuIwRwtH0bHsA/18PS9opLib09on/0XNYTMQYAZeiUJGkajGeWIRcrcf?=
 =?us-ascii?Q?3HL1jn8IvfxP876EsBKDjCFT7bqypqwMI+7pLiEtEf9/V9QWCKIB9X7bJCJ+?=
 =?us-ascii?Q?+3Bvo61q10PdKQUOo2biyy6rjwoZLj3hLBCqXGq3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3970de4-4181-401a-6da1-08db5dfeb336
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 15:34:31.2481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5sy1Cv1iukX5LlGhDRoJuN99AnUhNYZYgSjeRg1Nc14++B11C4kuFjt8s63WiduMBxppMvtzuI0lLZGvJN0Osw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1327
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, May 26, 2023 11:28 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> pabeni@redhat.com; leon@kernel.org; Long Li <longli@microsoft.com>;
> ssengar@linux.microsoft.com; linux-rdma@vger.kernel.org;
> daniel@iogearbox.net; john.fastabend@gmail.com; bpf@vger.kernel.org;
> ast@kernel.org; Ajay Sharma <sharmaajay@microsoft.com>;
> hawk@kernel.org; tglx@linutronix.de; shradhagupta@linux.microsoft.com;
> linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH V2,net] net: mana: Fix perf regression: remove rx_cqe=
s,
> tx_cqes counters
>=20
> On Fri, 26 May 2023 14:42:07 +0000 Haiyang Zhang wrote:
> > > Horatiu's ask for more details was perfectly reasonable.
> > > Provide more details to give the distros and users an
> > > idea of the order of magnitude of the problem. Example
> > > workload and relative perf hit, anything.
> >
> > For example, a workload is iperf with 128 threads, and with RPS enabled=
.
> > We saw perf regression of 25% with the previous patch adding the counte=
rs.
> > And this patch eliminates the regression.
>=20
> Exactly what I was looking for, thanks. Please put that in the commit
> message and post v3 (feel free to add the review tags which came in for
> v1 in the meantime).

Will do.

Thanks!

