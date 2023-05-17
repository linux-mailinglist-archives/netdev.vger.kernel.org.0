Return-Path: <netdev+bounces-3139-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D64705B94
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 02:03:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F961281319
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 00:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C27917D1;
	Wed, 17 May 2023 00:03:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C66D17C8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 00:03:02 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2119.outbound.protection.outlook.com [40.107.243.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21802728;
	Tue, 16 May 2023 17:03:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImbS6N7B/vKshAfbjCUFfvKJBsgOQd/cTxgYn4V9QLenWsF44ntLS9sEnN4J3izjrTe17YNYLkrOYbkVe6D7joo4225ZxT9BWf2CzzYQejpWQTywiwti9LHzwOmZbmVbe26dqPCYXAL4WUb9QduviK/fAyAhCV3R7NKJhTPQmiTzRZHMVovcTprTtO8QvBF7ajsmKeMHfsjzDl4NEzJqkcmNBT1TxmOiK3yEWebqtBvvcprabXYrn5EKgsRpnk9HNU0m8f9KHpP8fLoLoT0EwQETqEoTpW+feg9XZndMUMv6zx3/FKyB+mdA11oCUq1IBUKVBVl8Ebk81rW4nO02JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kO7og7l5Io5mx8eD6ObA2UUW5gfwk+Alp4RxnxOqfQo=;
 b=ayhqv5j/8sZaQHly/8lUrLNEC4ZEmu2f7UKvXvMp+CvBM0B4moG+0GQhFIP9G1eW73eUIfxGhsMI2h7+YJXG9AnOe7/YWW55uFEk95tkKoXGa3MWYTwDGk6aD2b2lJ7WR42ILvLbTW24I5is4y4Py9DoUIVTkykrMUuYjrEsiD1S4ToRBpxzXhNeEhQbq/qvC9saQCIjCYNsKoaly/pz45IuM+bLh5MB8HMc9oZ3Q+2sL4jcOC56a+Z9qMRInQF5A/aupuQ1zfde4VpN/2mEvodhHHFGsGLo2p2EuCQ6E0LYz+qk+JkXpPIPYtyjhWT/49O/elbXxrqvvy2OcURs4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kO7og7l5Io5mx8eD6ObA2UUW5gfwk+Alp4RxnxOqfQo=;
 b=Q2MAjvck4wKYYvEb+0OaPJOgMC+zmWQqgTVOOQ8OwSOF7nW7q4pZX3h3hj7+WW3/N0VA04l9l6br04yN0E1zR86Ms2KDuSLcz3u4E3fLX2wTkoVQDvP9bHMHEX/B9prLMC0djHjC5v4dnAQQ8/MH9cjsvmJWH+qsAeVuEjuRbMk=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by MN0PR21MB3724.namprd21.prod.outlook.com (2603:10b6:208:3d2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.3; Wed, 17 May
 2023 00:02:58 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::c454:256a:ce51:e983]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::c454:256a:ce51:e983%4]) with mapi id 15.20.6433.001; Wed, 17 May 2023
 00:02:57 +0000
From: Dexuan Cui <decui@microsoft.com>
To: 'Lorenzo Pieralisi' <lpieralisi@kernel.org>
CC: "'bhelgaas@google.com'" <bhelgaas@google.com>, "'davem@davemloft.net'"
	<davem@davemloft.net>, "'edumazet@google.com'" <edumazet@google.com>, Haiyang
 Zhang <haiyangz@microsoft.com>, Jake Oshins <jakeo@microsoft.com>,
	"'kuba@kernel.org'" <kuba@kernel.org>, "'kw@linux.com'" <kw@linux.com>, KY
 Srinivasan <kys@microsoft.com>, "'leon@kernel.org'" <leon@kernel.org>,
	"'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>, "Michael Kelley
 (LINUX)" <mikelley@microsoft.com>, "'pabeni@redhat.com'" <pabeni@redhat.com>,
	"'robh@kernel.org'" <robh@kernel.org>, "'saeedm@nvidia.com'"
	<saeedm@nvidia.com>, "'wei.liu@kernel.org'" <wei.liu@kernel.org>, Long Li
	<longli@microsoft.com>, "'boqun.feng@gmail.com'" <boqun.feng@gmail.com>,
	Saurabh Singh Sengar <ssengar@microsoft.com>, "'helgaas@kernel.org'"
	<helgaas@kernel.org>, "'linux-hyperv@vger.kernel.org'"
	<linux-hyperv@vger.kernel.org>, "'linux-kernel@vger.kernel.org'"
	<linux-kernel@vger.kernel.org>, "'linux-rdma@vger.kernel.org'"
	<linux-rdma@vger.kernel.org>, "'netdev@vger.kernel.org'"
	<netdev@vger.kernel.org>, Jose Teuttli Carranco <josete@microsoft.com>,
	"'stable@vger.kernel.org'" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Topic: [PATCH v3 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Index: AQHZgxiydynY9JdEwE2LUDobn6ASSK9TueZQgAnkUiA=
Date: Wed, 17 May 2023 00:02:57 +0000
Message-ID:
 <SA1PR21MB133549FB41041ED218E2C73BBF7E9@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-7-decui@microsoft.com> <ZFtUgCVaneGVKBsW@lpieralisi>
 <SA1PR21MB13355D8F2A7AC6CA91FE1D1BBF779@SA1PR21MB1335.namprd21.prod.outlook.com>
In-Reply-To:
 <SA1PR21MB13355D8F2A7AC6CA91FE1D1BBF779@SA1PR21MB1335.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9404ba2f-9e11-476c-bee1-b05b22020f31;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-10T16:54:12Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|MN0PR21MB3724:EE_
x-ms-office365-filtering-correlation-id: ff757fb2-e045-4d42-f9c4-08db566a125f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 VascPjmolAdNaKgF52ReMSN4HSinJyp5NBnX4NB6D91FyQ5xwYCy6ugy1T0U3/TetcEyvFJ7VeHuCKayHHSAKVfWiwgYwlzzCi0aNEzQU/emdLfyfczpJPVHawbEX1ZDp/P43rK6r1dzC3ru+jFGhj0P6jXkuttcafH9/NWXJycHBEldP8UOCMjGLf/x2j/c2Df3Gredz4MNWO7kpNtTLmSI0Pk0X5LTQll/uKMwY/ThAFpJM9touXvrY9+gD7aQELDAXZRqYk9b+4V/atsRcd//wSmIFdnO+MwHrEQ+Xj8PrxwQcmWV5o4dUKCZOWMpuAF3NFoG77cj4WbuHHb4zPypBb+AvFHWgywTh5bVMiYrZCzHf5V4wb6rDw95zd4hjv3Ee34JRyzDradyzCmV3iSMzXMRV8amDs/A1vWPI2/jLP96torPzDxP+3jjB5c25PqaLYaas+Jd3rFezCnDUzL/oNb+s+Vni87OAWYyqHMUYARpkqCpJhBlRgLW0IbPayUjhR5ArofuItXzXzAM65ytqhBZmtdia9SONjpOUYHSnNmz27XHSjgG7MIk5TV8DGaVfQ6wfpc8BRgnwvakXWi+p4qOzDrKvyenelPR6kYGdD9BFNa3ZqOqNQZ2Vb32OChg1HuxPKJw3u6FFK0qoQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(122000001)(38070700005)(38100700002)(86362001)(82960400001)(82950400001)(33656002)(786003)(55016003)(5660300002)(4326008)(316002)(71200400001)(8676002)(9686003)(52536014)(53546011)(6506007)(7416002)(186003)(8936002)(6916009)(8990500004)(41300700001)(66476007)(2906002)(54906003)(66446008)(64756008)(7696005)(66946007)(478600001)(10290500003)(966005)(4744005)(66556008)(76116006)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?CmWMeiVdpCxf7kSg+7gmOHBlGZVlPhoacVn84WF05ORPG4Xx9V11Z/kI29sN?=
 =?us-ascii?Q?SNBbXq2bP7vGDmV0JZumU+Wzerf0im5ne8JIO77SkbXLuvK3bb7hwyYNKhUA?=
 =?us-ascii?Q?ZSe0M8lQNYdprKheh28R9aW9p4uX4axdoXa//y//T2lkINEHnY5INYWRnC+7?=
 =?us-ascii?Q?rW0OBTrX9/adyDHCM4XoZQhPfPL1TOjVsVMMs0FAG4eFMuiRoRj3H1LFl/bG?=
 =?us-ascii?Q?EhuFRyLA6PxNqTdbRAbXeHVYqhz2U4hoJqvXJrskq7zhQ9BHx6UJruEBZiW+?=
 =?us-ascii?Q?Dj6xxMLvOWAvYZAHFOySObE09vPbd9H+lw0ljYe+56Bvx+DC7kcI7BEwbfkn?=
 =?us-ascii?Q?JcHfXFukfz72QHtKcd2m2jAZH+K1VnbJVdmfzfj3/nIb0/r50+mX3etllXw3?=
 =?us-ascii?Q?C+LHvSaTc8/vSiJlgTzFa7uoGO8QXta5ja49s7ViWAoYBeFz+UcEP9nPhx6t?=
 =?us-ascii?Q?kmDzibUhywd1sI5B9hECInvDewBwgjJkujxewM20Pwf/ITF88tYF7YbK7aGM?=
 =?us-ascii?Q?0CNx380g/WUzIrjb0Dh9pBF1V7HvUxZvmnuFlLnp4EtSS9RiCQ/gPTFDJRd0?=
 =?us-ascii?Q?Z17iAjEd4zkCPMV9D3U56uphPNP1SBgSM66vSL44AvR1cOFaFFiBshXSaVA2?=
 =?us-ascii?Q?tHf4D/vdBfCF/tXZef9i756BEM4fN2EqluYe5E7ejWm2/jch8HXd7m8d+87I?=
 =?us-ascii?Q?zbVSHfH0pcUXKMZe9l0LfR19badTwEJv8TZg5GJEAFuygo0gX45PRGxKyZWD?=
 =?us-ascii?Q?dr2u0CTcYZAcC9q3RvdcV1nCSb0WkUQXyS3H8poD3pVGv2fHlsVC8XX3HCLQ?=
 =?us-ascii?Q?KReZqCaSc9huOfle7cDwT/A/lzlrcg1XmSXrf3CJ9qXdNdPH4q99Wv43QLPk?=
 =?us-ascii?Q?oqtfsSDVTRtJzPEk/WrAAKpTrcVKyy7iSyTCYIUtgqFj6bP4718a6qLxE3RD?=
 =?us-ascii?Q?4MT7pRZlM0k19Zu/SJZz669YbWhQA9tuIxpLVX8NEh6BKAGfWz2EFXkMttVz?=
 =?us-ascii?Q?8qW1QNKR1VbiNVGXy/+jUIABLFNIbZbvc+mHmicaTTvOqCLZ3K/8egnhfUW7?=
 =?us-ascii?Q?utgN7RTGtLiI5sqfvOyhjdmyS1zjTepNwtygJny6WfzAMYHc1FRgT1IXeWvS?=
 =?us-ascii?Q?0s67BQyeKX9o82nuBTCfUlSkkKds9aaMdxk8Pw8ckDg1Ji9L77u5oXw6ur12?=
 =?us-ascii?Q?sfI4+rreaVjZYMuHmnbIp/HrE+skUBcbC1kCAc+F45B75RDqKBFl5+L/GiNe?=
 =?us-ascii?Q?RfLshW4PqK+h4d9Od8sy2Ae3352W1ZTbaobn7ojMOpZbjFiIPwgfQzZjXjgZ?=
 =?us-ascii?Q?Waf1lD5rtNbtTrGgM0xb+sSXOsXvfqwVOA0ALO/5EzhKpgKyNIgJ/DYoOey9?=
 =?us-ascii?Q?FZpe1HQm2oXWmMOGJC+XRlnMTLWAbvRaF1kIEznizpM6+BW87bzdNuseKe2d?=
 =?us-ascii?Q?spmRtGprObzcZFCfKMrOg8s0Z4tPbbtHhcnTrp9z8wlMkjM9a4bqzmoK8rlo?=
 =?us-ascii?Q?uzHBt6vJ73IlHVuUx6QUEEV9t6fcGV/H3zlu5N+4WBVHWb1irm05Y9BZzLZU?=
 =?us-ascii?Q?nBra61X1wtDpSfiomkm7tTFjaDghiYAycyq1vvIFykrkOQ46U+rSRF3LcmfO?=
 =?us-ascii?Q?p1jsIdICacvkNYr0sVXVZnIMXZl/FK1sfsQPCvAPdbgU?=
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
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff757fb2-e045-4d42-f9c4-08db566a125f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 00:02:57.7606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WZtrxCU7Xl2PCvp7aBGgnm3GixonjaYK+I8Mwqxp5bQfoxPeRLCOwCGWMTnYm3C8/9Z8+vBJH0dER4vTL43NVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3724
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Dexuan Cui
> Sent: Wednesday, May 10, 2023 10:12 AM
> To: Lorenzo Pieralisi <lpieralisi@kernel.org>
> > ...
> > This patch should be split, first thing is to fix and document what
> > you are changing for pci_{lock,unlock}_rescan_remove() then add
> > asynchronous probing.
> >
> > Lorenzo
> Ok, I'll split this patch into two.
>=20
> Thanks for reviewing the patch.
> Can you please give an "Acked-by" or "Reviewed-by" to patch 1~5
> if they look good to you? The first 5 patches have been there for a
> while, and they already got Michael's Reviewed-by.

Hi Lorenzo, Bjorn and all,
Ping -- it would be great to have your Acked-by or Reviewed-by for
patch 1 to 5.
=20
> I hope the first 5 patches can go through the hyperv-fixes branch in
> the hyperv tree
> https://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git/log/?h=
=3Dhyp
> erv-fixes
> since they are specific to Hyper-V.
>=20
> After the first 5 patches are in, I can refer to the commit IDs, and I
> will split this patch (patch 6).
>=20
> Thanks,
> Dexuan


