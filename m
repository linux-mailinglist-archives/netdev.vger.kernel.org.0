Return-Path: <netdev+bounces-5723-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5328F7128CE
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96806280E5F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9F9724EB8;
	Fri, 26 May 2023 14:44:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDC2742C3;
	Fri, 26 May 2023 14:44:10 +0000 (UTC)
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021025.outbound.protection.outlook.com [52.101.57.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF412E56;
	Fri, 26 May 2023 07:43:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8aZrDXpQbq7+n9bFD1kIL95TLulhYil5MTBuTXt+BGyttM1P+mGQjUTYomat5yAnpkbOmSVWxtwXhjm+N5dzxMXDxyAArPRZ3N0FM77lOE1oakWfqV61CQtksi7nUkR37jnJYLD+ar2b4odVg7lXIiWuZtkxroKfv+yNzeyDz+gx0RQ4C5+a/p5DvuCiLBTveUa+O6ztpKCkS2GYGiN6bSdjN4g7+FcRC8uDQpcTj/mUf09AiYCz/0LYDwyiLXVXQr1tkRX0FAC/ycrUVYDbSAlUL8xXN9t+UfgtfVXwAz2otibdKzVDYNZneJkdkGEr0PTuuHg3kDPH4fiqej0JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45KekFoOlXD24B0v/r1zeNiCLsfAYgjuNpJ/3apYmc0=;
 b=Ts7SNDvkE13Jy2VKBCnWE/wNS86o2U+/XNFGvseoc58iJx+hr23n46fC6wyZnVDucJUe3N3O+YBHP929I2QnIVZAWBmK9mv4kIwKogSF91O28CaAWjgROG5D8kUMxDVTYtEb+WzAwCJqaYsDiV112hv28hMxXL3o09N0MbFTWnQBkJy/FDSZXtg/k2bcH+5VcJPwbEoPax2FRtNA86tq7hJUiT+bAXpUR+33knQgHil13dAynIwXMmXjhHUSz0Wtcn7mYEdoxMFv706bFZdoQ8qAOqXiFA6ihfSt5hOK9BoEdTpLBpC82vlEO1G9JLs3VCaKBi92DLUh7LsKtQF5Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45KekFoOlXD24B0v/r1zeNiCLsfAYgjuNpJ/3apYmc0=;
 b=GBoc9A7YLOrP2M+WBeWIp1u+S39yv5uwJXE8J2OAW9kRgT4Y+aLbWQlffl8xsVavof3+Gu4rH65KExMpCh9+SRjwo/aos5zgla5wtdLd0dDH1ij/NWIXIeNbryw/VHLM1nqGcU+00mYNN9VgV4J9dSv6K2Y9+l9Kcm6aoSibPgc=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by LV2PR21MB3254.namprd21.prod.outlook.com (2603:10b6:408:170::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.13; Fri, 26 May
 2023 14:42:07 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900%5]) with mapi id 15.20.6455.012; Fri, 26 May 2023
 14:42:07 +0000
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
Thread-Index: AQHZjxe4aWBF7RgXTEqOWnaG2HOEma9r5WKAgAC54BA=
Date: Fri, 26 May 2023 14:42:07 +0000
Message-ID:
 <PH7PR21MB311639268988CD72DA545774CA47A@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1685025990-14598-1-git-send-email-haiyangz@microsoft.com>
 <20230525202557.5a5f020b@kernel.org>
In-Reply-To: <20230525202557.5a5f020b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=eb1de31e-f469-481a-b60f-84a8b0201767;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-26T14:31:13Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|LV2PR21MB3254:EE_
x-ms-office365-filtering-correlation-id: 5f69e765-ddd6-4f3d-d034-08db5df7614c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 NqsHNnfFYiJDuBf4gqJIhGcXQ9pyp0eYgMiGy/uvXnY4/ktd5NTLBwZOFucIhbH3XTjqvNei/NkoycecQHlBF9vREomwPPTtZgpfXrsWb0eqRtPedbN3S/G9OkEWhI9Q5Uuhi/LToS4w/9k/L1SyjeW+SsFdXsgMJNuf+D0mp7s/nBWV3a3FFioTkNRhdrnoHpzLzcl7TaijV3KXpx1B8FhkuQTCDhyLkJcNipE7/TpeVieVrgsw+DCKCcbOdl+ehkvWI1vP0T3mdT0ruJo6cxhcvMCL3fx8Ee8m6OuZCsU+P3nrPQ8qc5EHA5amWZgjKXXT3s+ieEcAEYLqbZO0xivQUUEAjEzgQHciHzSx0DvLC771FQoMQ6Z8QVr4p8B29lv7BKNL4YbnxjBHHi2SYSEr3o0t6FQTY2WUmS6J6giW9DvnUGNJNhSf/mxZwvduN4Feg5boeqWCkbTZR6Ts2aMAXGpBi/IW8A0KGIaUyafwSe363CAb3IFcPjUZwaOXhgTGHSVzDZ5LcL/nS9VUBVaYVYenZXFZoxOZxxvB7bG0SyEqeT+zS8rmUc2yyyHsNIHPWzhD7uWaLk5aWZ2vKqyZNr8P/WvzVfy4eZQ/ygDioNt//qrMcouSHriYiuBkrgS5T05IjwOBmxzkOsSF8/fWqS8rcpKdjSc3oJ3Jzuo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(451199021)(71200400001)(83380400001)(7696005)(86362001)(10290500003)(2906002)(53546011)(478600001)(122000001)(54906003)(38070700005)(26005)(9686003)(6506007)(186003)(8990500004)(66556008)(66946007)(8676002)(55016003)(52536014)(66446008)(8936002)(76116006)(33656002)(786003)(316002)(38100700002)(7416002)(82960400001)(82950400001)(41300700001)(64756008)(66476007)(6916009)(4326008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?D7davT2xMzSpz8pPu5GdtKz0oVMwMAg/sF7ppT5OktOUjY/2ERSuPkmynqVV?=
 =?us-ascii?Q?ddVLALrlW9nxUZ/hUESIQWBk+OkZYNwoiTcE2/ic7Sg3wNbXfMgA+YODscfl?=
 =?us-ascii?Q?NQiN+ZqgT05T4SYOI1l96SPcR3d0+7ewV6+HN9c9vpzPtKepTnxGBRm+p65a?=
 =?us-ascii?Q?8e8kDOn7zBBTL1BhS57VitHPMLvWxleTxNaIq/IGnj7+T3vJ4ww1zh917PcX?=
 =?us-ascii?Q?tb9vUcx3m6wgbsIWIQ9gBZQObM6tTjKqoOaZRfVxGxo2R5vChhEHE67iFQCI?=
 =?us-ascii?Q?XyLDubxTkQP9UuqXhiUfHYPYyV6faqEtGti8qyfwV/J/yvsxlvus2YtIg/T2?=
 =?us-ascii?Q?l6qAcoTD4nJbVdohyMZl2FD1IvXcvBILkbaboeK7BEhh8/cCsnxyjQ88cNl3?=
 =?us-ascii?Q?oHRNcbMfxtTwqBJwQHO3tk1pY65TfIHRcbltFJ7PU9LoYYzpv74mxluBKVeP?=
 =?us-ascii?Q?0zppJPYSMeqzU01qsTtKTRtvA9mLCq8Y/4oGosDoKmZA3RBvHhdvbBW6HKPV?=
 =?us-ascii?Q?3hFGhK+Y5uBTWGJhOUJDduRoiimsXhbhiCLT5d1S8w4kQaquBb9gm1BlMcbp?=
 =?us-ascii?Q?Rh09JP6riqZqQKIgLIJ5n4nBbm3pYSBHP/yAHWi3OGGDbo2gUPRPtp3KoUEv?=
 =?us-ascii?Q?MBP60o1fsfNbNKI5I7hdzUeAt43G6N4YtndfAo4UB5uHVGqpfyLHDOFPxeC0?=
 =?us-ascii?Q?+4GX5qwAp4TYukpuQDAIKF5IQZZKwdI0JeiHIGHNxG2thLWMvtuHOEEKvsiU?=
 =?us-ascii?Q?EDqNuTk0dmRN3QIlByc6hsQb8Lzsc36RLVLAAuWbwMwyooWuTqJPKrr12Wvp?=
 =?us-ascii?Q?zqw7vbbPpCjfHdQ9gqUmU54MRhfN5JQiWaagQUQ5qmMCi+nf3OsKgshBvxiP?=
 =?us-ascii?Q?UhVuKasY/JzN4RlNMushqOtP8QQ1E4S0hM6S/dA1nwJoXdpjqjfzZqpA9YNI?=
 =?us-ascii?Q?TZ37zojqZmsicYj5pW2ZsyRNYXCrT/ac1yA/ZhsTycTZzvD+bMALowynwLQm?=
 =?us-ascii?Q?yFtZbMgBaW852/gj8hrKLt2XRi6D44RYxfAUHOrBk/MajepBJOb9RZcot5x/?=
 =?us-ascii?Q?sxwCo9bhQR11zdROQNmp49MOjsagFrlFOcN3lRHqN9RbU/yKDED61th/k6qK?=
 =?us-ascii?Q?XucsYhoMl8RGIyg4Wc3p4xbDUjnRS4UuTD+8YgDzCdLoR9OX7rCKS1saozNK?=
 =?us-ascii?Q?03E0v1BZvXzhLm0rsUFbgosiktE3QchFjSkbYqHvsxH9/fiw1Edv9/3T6UsS?=
 =?us-ascii?Q?zC5joub00B1UHAiHMieoTGHjvHO7JvH6W8cqs0a2y/PaZa+27vjUOsF9zZhM?=
 =?us-ascii?Q?2nuXe3fExutA41G7z7HcwPNAxPGlAVOcCaMu2obE4A4pPJW2FI734+SA0iDb?=
 =?us-ascii?Q?8eyfaZ2uZm/RRHeLz0nj2YOtAYQqPZkh7JCNaZQogN1uiA1stULAlXc1DJ9F?=
 =?us-ascii?Q?V8i+wwk0pDsPCguvAXnjWwkmlCZ1UseBeAoCfOaGLdJpQCgU3mTHKr6tgUvY?=
 =?us-ascii?Q?/K2G8oYIbdfpSgyZ3UXjqNID1zBwCvpKCrUGAPEuG0JWUhMni5VTEMSHOrbv?=
 =?us-ascii?Q?Bk1UX7U1Slv9u6XTL7y6xFOaYxm5zD0gL+tlDITE?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f69e765-ddd6-4f3d-d034-08db5df7614c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 14:42:07.3239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I/JN0yH4s34Blz8ITx/FigluFrwbNOFW54G6FJUSqGzurnom+Hj90ap2YidmA+/lc8b0IHX1KL3lSlCM38z+KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3254
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, May 25, 2023 11:26 PM
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
> On Thu, 25 May 2023 07:46:30 -0700 Haiyang Zhang wrote:
> > lot caching and memory overhead, hence perf regression.
>=20
> Horatiu's ask for more details was perfectly reasonable.
> Provide more details to give the distros and users an
> idea of the order of magnitude of the problem. Example
> workload and relative perf hit, anything.

For example, a workload is iperf with 128 threads, and with RPS enabled.
We saw perf regression of 25% with the previous patch adding the counters.
And this patch eliminates the regression.=20

Thanks,
- Haiyang

