Return-Path: <netdev+bounces-5344-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8571710E66
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:34:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98ACE1C20F2D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E7DFC1A;
	Thu, 25 May 2023 14:34:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7DCBE62;
	Thu, 25 May 2023 14:34:09 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020020.outbound.protection.outlook.com [52.101.61.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC70CC;
	Thu, 25 May 2023 07:34:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZB/iswJLjSX16mOEKwgOTv8yl2DMn7KmZ6JxFS8fn0f9kuCxUo+Fa/Lbdy2RRuzJlhuWbVsIlmeWHhRz/bO1Md7Q/PMY7h6MR9MoC5vYhtTRGjlMKVNd6oQnqcdWS4nb1j00fqyZzbfiMepl1dd8hABrquBH6Mg7DzWFmPWsQUjkCvNj9jZ2RLtG5CcyabNp1ao52DWlC3yGxp6kPHNNZdGQLiEA6kMYMKCfO3WF7NJYnJX2KQNoi9DdMZ9BBM57F1FcMvHltvbYll6XYKENQcp+Ag4zKIrZdAm5rBpa8E+wphSYO7sHitL9QTbs/Rv8DU9KE2m8suzeEjG2SKzL9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rn7aXzNk1537IH1OBP2NR6a9GMEDxVr+yJabDSZR/ZI=;
 b=mW+yTfWxHXPu7WIfyt/NVP/I0ltWcIAq11LyRaNdu52/UAlYrdTBjwJKgoLsDtK8ALRrIasl91m7UHZ5NSHFO7C0KE8ZhhRBiCHieo5LFKDsRTnIEpwQR2f9XQeazRMz1GNVHAX+allXAItOYAt4SsjjZxrvrjKur59ZZr89SToj74immYhaH+0L7wHQ/uVHF/ROxAh1G3NsYuPVxqcqYD3072Ke024dU5e4YVbnh+2t+3mKYQSBDHSQvg/CZRh6TpWrwv81FWbcDxXvOJuOv5jcyonmNxcULAp6QuDZ0OcLFmd4d98MYuU7tcTnTKNxLgKQHBW1q7nRsAVR7r6dsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rn7aXzNk1537IH1OBP2NR6a9GMEDxVr+yJabDSZR/ZI=;
 b=VuBVVIeQUW6MfPlraHl4gt5EjQe9tTJrWylb57P71KKGzohCLU3768SOkohEhT9fIQ+y/rb2byJvGoGA3d875GCZ83btUg2BiSZECDECBJV55LsxVPzWg6Sc2TT99wxytgt2zHyAox2AoS7P1yEExGmksJ7A+vJ4LPL9V28yi4w=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by PH0PR21MB1975.namprd21.prod.outlook.com (2603:10b6:510:1c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.7; Thu, 25 May
 2023 14:34:04 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900%5]) with mapi id 15.20.6433.013; Thu, 25 May 2023
 14:34:04 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
CC: "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Dexuan Cui
	<decui@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Paul Rosswurm
	<paulros@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>, "leon@kernel.org"
	<leon@kernel.org>, Long Li <longli@microsoft.com>,
	"ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "john.fastabend@gmail.com"
	<john.fastabend@gmail.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"ast@kernel.org" <ast@kernel.org>, Ajay Sharma <sharmaajay@microsoft.com>,
	"hawk@kernel.org" <hawk@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: RE: [PATCH net] net: mana: Fix perf regression: remove rx_cqes,
 tx_cqes counters
Thread-Topic: [PATCH net] net: mana: Fix perf regression: remove rx_cqes,
 tx_cqes counters
Thread-Index: AQHZjoX1WTJfOkpxnkOGdXtSJcYZ8a9qjN+AgACAu1A=
Date: Thu, 25 May 2023 14:34:04 +0000
Message-ID:
 <PH7PR21MB31161F3291FF951877355DA9CA46A@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1684963320-25282-1-git-send-email-haiyangz@microsoft.com>
 <20230525064849.ca5p6npej7p2luw2@soft-dev3-1>
In-Reply-To: <20230525064849.ca5p6npej7p2luw2@soft-dev3-1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e63b229e-0b77-4b7c-9d17-baa93e325182;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-25T14:29:33Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|PH0PR21MB1975:EE_
x-ms-office365-filtering-correlation-id: b94e7dc3-33bd-4a0e-3dbb-08db5d2d173d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 SADQW2WteTWVXC1UI/s+PZEcnJ9p18OfkKltnBfdCRHKZBLd+2ALvCfQCu4cnHqiGhHpR+vbgkyq7TT0e+v1pcF01ML5k3Xe7xxfJrVlW94Cz1LcvXa+Nzw05ovrhJms3RhPOpr+itcHu/uJSMYPHvsCR4AntA0zhLVcFHPtSGLCSSfju3yr82Y5jNfqfcfmoy+rdTZiHOzk3w+rNl+fgtRi+R9CSLL1dXfqlps9FYoX3qt9n20pOAtvq69/+4+yY2ksWxjKGtVCA/sJkzif7wUDnKpvPLRDl1pIv3nawOx4Sl8xaEPV5jYhrAo25xB8dICQpUjTIumx8Ufbg5S4iTA11xWKAClpyeaKqEQCIK4eFhk1Saidgkjm524Xh0joE+NnZbhcZR34Kl+rKkYnllIH5ffZiPGC1Wm7tvXAZ32nW571a70k7jnPKqF7gWGMKNgJU6tfyLWUJdDezXo185+9tNcfaLHRllayPik5Io3ifrtVIJqtZ3N9XXMKln1Dw8lmcuXxIuxP7ykfKr3QOpWIEBi+HOOmpBJoHpw2cMsfeR0dO5z+0dXef6GyBr3oHEWIS2z8QZhpLDIvkmYfGKQ6zMU2oWG3wVVbORO6XUhU9ZiFhZDwLGHD23VRhrdEpjjN7RhsZxJHzjOj9+weqQzBL8+bSHHwWt3Otssv6FM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(451199021)(33656002)(82960400001)(38100700002)(82950400001)(122000001)(86362001)(38070700005)(55016003)(8676002)(8936002)(5660300002)(52536014)(10290500003)(7416002)(966005)(9686003)(6506007)(26005)(2906002)(186003)(83380400001)(66556008)(76116006)(71200400001)(786003)(7696005)(66946007)(41300700001)(316002)(4326008)(478600001)(54906003)(6916009)(8990500004)(66446008)(64756008)(66476007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Ei0052iCAa2LWnj4DdknuKikjA2boVslNCDnsd+2YVxT1yvMPaerYyY//G5X?=
 =?us-ascii?Q?9Qzj9ZqIaOZvq5GuIjuUdsH2rnFFNBGktWn9rjM7Sd2N6yoAPLKxiNS92T0H?=
 =?us-ascii?Q?U//oFhuy7vdy+Te3VIGdcfW2m3mSjAJNyRon9dr/AQ77rU/3cvGZffv0V+D4?=
 =?us-ascii?Q?RqKT57TMw2Gf47576JPCiaBzp0c09VjjtDi7rJxZzJ4tvG++RA/nreIE+WZq?=
 =?us-ascii?Q?AaNGvy3jSTgPNlh6osmp7WuYLa9n/M4zi+bZtMv0kJNU5jpqP0jdBXVEFQRA?=
 =?us-ascii?Q?dZyLi52tfW773Skxvx0pdTDLjr2Onp96u44jIHT42LEBsjFyAV6x8RiJ001x?=
 =?us-ascii?Q?XRP83BtNGYcg2uofFhwAnQV1YQ/S3DB3kQqrGebze/rR0vCjgzkU1KzaY7IS?=
 =?us-ascii?Q?DNEbA+g7OtCfourUdPI2ph3JY1R25UYB6B0FRzXacJwaE3KOSLX2LTCtYKvr?=
 =?us-ascii?Q?0XsR2BzLMilrbgpSrGbMqgYsWcqrPjYM7pTDjz3o4BxBAuHaQ1KILbFpOWTs?=
 =?us-ascii?Q?4b0PZ+sUO28dESsmIWPn6AbDjc1vE3b2noK1pxFITJh74tAdCB5iOcJ8mCZo?=
 =?us-ascii?Q?TftkXIX/5TpSXDjT/ao4co1UEZ9uKUDw5J/43/zk96o5xIVOC8pYr7CBMdIl?=
 =?us-ascii?Q?essEdWpXSczyURMzDVEtUXWYQL3RA++3pWBeSYxii97Jkh7oUEs1WLt041md?=
 =?us-ascii?Q?AyOkZlweUfLhzpsomADc0PB/VkRWTys5zc8ziT7h6cmUvF6+Nu8fLuKKZRem?=
 =?us-ascii?Q?ak5Yp3LDd52HILfi7dJuBLCIwriPxdhIoodc2y3rz/ZbCRDnx6eK/g67ZR3O?=
 =?us-ascii?Q?YdGiF8ZP9QogFZBkEhSWABuabNuEBCOFOKo/9dUgotbk0XwTwAoANMFzhpcT?=
 =?us-ascii?Q?ZAhZLwOg0kigbyCux2N8+94WwCL1T3j8J8eTQUSuqpZQr4J6u3Tho4VfOqkK?=
 =?us-ascii?Q?shJyo/iJJChSXLit9GmDLt9HNTXf27ZpfjhEp8QHSNffufBC5vTjlShb2fwL?=
 =?us-ascii?Q?l4Eqw2y4uTqyN9VrFljalUINvG2bZ13b2i84nQZcgUUUdlJLx3QwXd6LG2sm?=
 =?us-ascii?Q?74RmD6tJ2a6uHBQi0lV7e8CtkTHF57u2p7HE0cMmOPRjE7tUFVlmwXJT1ntt?=
 =?us-ascii?Q?LjmsXgJ0lmqwMMYIITlZIbHnayW/KXIhowUtLkAaYFVhTxf9yCWLEe8vUI+f?=
 =?us-ascii?Q?h4a9ngdkIs1XBpay8uPw7fjqbn6Q4B3/UAoCnOkJjmsPO2neZoYS31jLJU7I?=
 =?us-ascii?Q?zzbop0BkHUXGDt8YbrUm7HFLWh6urRt1PPPqy5ju6fgS+Ngk8DtnZ3nHdLKZ?=
 =?us-ascii?Q?6ZAvLZv9pTameX2IkE7oD8n2U9RWtjKEQqKNpOOK0chjTeoTklEzKs9DerWU?=
 =?us-ascii?Q?o5MltTJ03XU7fztyvIoORJfNDTyAl5ulc+C98KjkjxlGZmBkdqDstCZLC2oE?=
 =?us-ascii?Q?fpjCdAWk3/ays3azAE7sTlioIjjxJ4mLjxGslwL4tmbmJSOAFTM1cj85yAzu?=
 =?us-ascii?Q?U687k0howEv9QnqtlioEubdCwfAEdf5KVLvm6IqfNHjKvla4MgraeSWM4mto?=
 =?us-ascii?Q?s6ogLujvyEvja3bZRFboBd0gU+CQAncZNG2RQLLz?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b94e7dc3-33bd-4a0e-3dbb-08db5d2d173d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2023 14:34:04.7580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6cow0s78QPjCze0+Amm9Ur8Yc7D9Vr3tjtfD+7XJ0lH5nC0OsNuVT3w1vF/bXnTtSyHueuzYyd9N5bIK754Skg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1975
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Sent: Thursday, May 25, 2023 2:49 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; leon@kernel.org; Long Li
> <longli@microsoft.com>; ssengar@linux.microsoft.com; linux-
> rdma@vger.kernel.org; daniel@iogearbox.net; john.fastabend@gmail.com;
> bpf@vger.kernel.org; ast@kernel.org; Ajay Sharma
> <sharmaajay@microsoft.com>; hawk@kernel.org; linux-
> kernel@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH net] net: mana: Fix perf regression: remove rx_cqes,
> tx_cqes counters
>=20
> [Some people who received this message don't often get email from
> horatiu.vultur@microchip.com. Learn why this is important at
> https://aka.ms/LearnAboutSenderIdentification ]
>=20
> The 05/24/2023 14:22, Haiyang Zhang wrote:
>=20
> Hi Haiyang,
>=20
> >
> > The apc->eth_stats.rx_cqes is one per NIC (vport), and it's on the
> > frequent and parallel code path of all queues. So, r/w into this
> > single shared variable by many threads on different CPUs creates a
> > lot caching and memory overhead, hence perf regression. And, it's
> > not accurate due to the high volume concurrent r/w.
>=20
> Do you have any numbers to show the improvement of this change?

The numbers are not published. The perf regression of the previous=20
patch is very significant, and this patch eliminates the regression.

>=20
> >
> > Since the error path of mana_poll_rx_cq() already has warnings, so
> > keeping the counter and convert it to a per-queue variable is not
> > necessary. So, just remove this counter from this high frequency
> > code path.
> >
> > Also, remove the tx_cqes counter for the same reason. We have
> > warnings & other counters for errors on that path, and don't need
> > to count every normal cqe processing.
>=20
> Will you not have problems with the counter 'apc->eth_stats.tx_cqe_err'?
> It is not in the hot path but you will have concurrent access to it.

Yes, but that error happens rarely, so a shared variable is good enough. So=
, I=20
don't change it in this patch.

Thanks,
- Haiyang


