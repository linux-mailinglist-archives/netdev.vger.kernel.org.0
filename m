Return-Path: <netdev+bounces-10613-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1786372F5C1
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:15:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA478281340
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0423B10F7;
	Wed, 14 Jun 2023 07:15:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D937F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:15:52 +0000 (UTC)
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EBC1BC5;
	Wed, 14 Jun 2023 00:15:50 -0700 (PDT)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
	by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E3Ckqd006587;
	Wed, 14 Jun 2023 00:15:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=qUtjVK6VnloIwGMvx+L1C9YzFozIGjVfz/7Irym02uE=;
 b=rtxKhVFs23go3dLOcj6JYXTbdiXZBvpfHhkwNfoPlE2yx/dapj1UQ36IJvNFZT28uD9q
 BEtP8ZyFYkTQP8Ng4+Kkg1WZgw0ey2vVZAhQm3PzKdmIlRilBCglbSzERvU57BKslpSv
 AptYJ0NwWB92OjX28WD3MDvnbsOuZ8MldCs6ZSIAvaVst5Osh73tYSqUyjjkusg+g9vd
 rYSMbyV2VCBskEiIHjIWY/Xj+Ef3PNP/wR4TI4FVudR63JPZpITvjPoPnGk2lAKz6owa
 hWqA2bdffibfXsDm34FvmoJT6NKejJp6r91oJodVcCEy8V2/7jtVesLqZDYPncH9zMTb Fw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
	by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3r4r3u0xan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jun 2023 00:15:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
	t=1686726915; bh=0YB5f3SsO6vtcPwtFPGtEk1oMvSHsZegc52ER08ZGmY=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:From;
	b=En1FbfXNV3XJxa2rBET82t3MHfLX6jnk7yqPEc7JCgorhMWx8Pkcu5Afigal8N5Hp
	 2dtG0iMu5PXD3dR0O3+am2y/R1bL1DfyC7IzXS/wgFHIvJRkWf3oa7seOfIZxWq0Yl
	 bYrWDJ8SCLKzuoawZQK1cE67PswxVES5Jk5S+0HzznnNuW5ogLKqDGULpXOj3C4hZO
	 BoWRq0rZ7PQaH7GlR97hvl3q/E9S0fX4i7a9RgwsJEETHhXfyoLP6buHbBsJEnbFXQ
	 hZ2jC9Q19DSiT8+79CGtNzcmFNiuin43kQjch4+DZdvto+sXRkPtq1PMBBpD4iFK9E
	 2WhkAYVg09MBg==
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits)
	 client-signature RSA-PSS (2048 bits))
	(Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
	by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4EECF401CA;
	Wed, 14 Jun 2023 07:15:12 +0000 (UTC)
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
	by mailhost.synopsys.com (Postfix) with ESMTPS id 1F593A0096;
	Wed, 14 Jun 2023 07:15:09 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
	dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.a=rsa-sha256 header.s=selector1 header.b=irAL6+jg;
	dkim-atps=neutral
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
	by o365relay-in.synopsys.com (Postfix) with ESMTPS id 3C70340141;
	Wed, 14 Jun 2023 07:15:07 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YodCV95N7CeMXU/E/7CsOSg/qXwpAvUrhJzXdvitYA4bCGAejVJ1qbHhiA20/CUTydWm4zElP6j/IpZXf0MELI6bdk+RwxfMMKoI6EXMJ3r43B1HhKpgOXcy4scm+afYu95ZOFG2IP5gNlepqtT7uYlTmf4A2rIu6CtVp67budr2ZMpFiqrwAQUJFjXj6E5DHysqV8jqVbpToNbzBHfCe9HWbIuHpg21P+K2VtbryKeJwfORmOSAKDIOenFpo0voo4KyONooEvfgp/V1yolbP82n1DTt+L8jK+Zrrgv/tQS1Aqzlo90OWA/z3qHO7KgGDmvY2EIeJ+Y2LR5wxkiscg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qUtjVK6VnloIwGMvx+L1C9YzFozIGjVfz/7Irym02uE=;
 b=AypwUG61SZKvmlMr21Di7HO++5l+fBY6leFRLA7A1/mj3ix/MDj5CidL+6a2phyFLEbiN4NtoHW6juLcs8J8IwqN7cCvEDiH5HecqMghQDuMIpR0kPO+9bz24KyKo4Kwj5Ju/vI1rtAMS2pxvWIlAMRTpQVgpBxaxyfeAMfLFDgfIPt6Yd8icrzuBqT2XtFNrigxO0HiU+IZaYpEGUJz1mHjEENZr6wg+Yuh4OMoH1A4Tw1qT63pmv2awpkrdEjkWlhTP0LJeL7YjXczsANEP3ow2TSyIG4knBY4u2w7lf3x9CP0U0IJOz6VZ5SkTKAFD33XHKh1hq+Ffbyu+EZNrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUtjVK6VnloIwGMvx+L1C9YzFozIGjVfz/7Irym02uE=;
 b=irAL6+jg+Fz1lL3D9moRfQGRnBECxwVGMy5HTnk8XGrc9mabq+ws+1aq1AaxnHEARpU0EBx6Z1aV3pLUmPutpb/+sQdqP10aHKUg7k82qnMEjvJfITpZkU8eXfsnY/1K6z5BW9zhaoO7zGien6GdkGC750DMLwfI4KpldsURpZE=
Received: from DM4PR12MB5088.namprd12.prod.outlook.com (2603:10b6:5:38b::9) by
 DS0PR12MB7509.namprd12.prod.outlook.com (2603:10b6:8:137::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.46; Wed, 14 Jun 2023 07:15:03 +0000
Received: from DM4PR12MB5088.namprd12.prod.outlook.com
 ([fe80::2f21:4162:3ecb:68de]) by DM4PR12MB5088.namprd12.prod.outlook.com
 ([fe80::2f21:4162:3ecb:68de%7]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 07:15:03 +0000
X-SNPS-Relay: synopsys.com
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
        Giuseppe Cavallaro
	<peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime
 Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com"
	<linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: Jose Abreu <Jose.Abreu@synopsys.com>
Subject: RE: [net-next PATCH v5 4/5] net: ethernet: stmicro: stmmac: generate
 stmmac dma conf before open
Thread-Topic: [net-next PATCH v5 4/5] net: ethernet: stmicro: stmmac: generate
 stmmac dma conf before open
Thread-Index: AQHYnqCzb/lINFBB6kaBEWXyCUbVca+L4V/w
Date: Wed, 14 Jun 2023 07:15:03 +0000
Message-ID: 
 <DM4PR12MB508882D5BE351BD756A7A9A4D35AA@DM4PR12MB5088.namprd12.prod.outlook.com>
References: <20220723142933.16030-1-ansuelsmth@gmail.com>
 <20220723142933.16030-5-ansuelsmth@gmail.com>
In-Reply-To: <20220723142933.16030-5-ansuelsmth@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcam9hYnJldVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTJjZGU0ZjYzLTBhODMtMTFlZS04NjJhLTNjMjE5?=
 =?us-ascii?Q?Y2RkNzFiNFxhbWUtdGVzdFwyY2RlNGY2NS0wYTgzLTExZWUtODYyYS0zYzIx?=
 =?us-ascii?Q?OWNkZDcxYjRib2R5LnR4dCIgc3o9IjIyMjAiIHQ9IjEzMzMxMjAwNTAxNDkz?=
 =?us-ascii?Q?NDQ2MCIgaD0ieHl0UEJHTERzYUhiKzFDNkZTYWg1K1VYUFFJPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFD?=
 =?us-ascii?Q?ODB6WHZqNTdaQWRwNktlQ0FNMVg4Mm5vcDRJQXpWZndOQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQUdDQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUFGVmFXcEFBQUFBQUFBQUFBQUFBQUFKNEFBQUJtQUdrQWJn?=
 =?us-ascii?Q?QmhBRzRBWXdCbEFGOEFjQUJzQUdFQWJnQnVBR2tBYmdCbkFGOEFkd0JoQUhR?=
 =?us-ascii?Q?QVpRQnlBRzBBWVFCeUFHc0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHWUFid0IxQUc0QVpBQnlBSGtBWHdC?=
 =?us-ascii?Q?d0FHRUFjZ0IwQUc0QVpRQnlBSE1BWHdCbkFHWUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWmdCdkFIVUFiZ0JrQUhJQWVRQmZBSEFBWVFCeUFIUUFiZ0Js?=
 =?us-ascii?Q?QUhJQWN3QmZBSE1BWVFCdEFITUFkUUJ1QUdjQVh3QmpBRzhBYmdCbUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQm1BRzhB?=
 =?us-ascii?Q?ZFFCdUFHUUFjZ0I1QUY4QWNBQmhBSElBZEFCdUFHVUFjZ0J6QUY4QWN3QnRB?=
 =?us-ascii?Q?R2tBWXdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdZ?=
 =?us-ascii?Q?QWJ3QjFBRzRBWkFCeUFIa0FYd0J3QUdFQWNnQjBBRzRBWlFCeUFITUFYd0J6?=
 =?us-ascii?Q?QUhRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaZ0J2QUhVQWJnQmtBSElB?=
 =?us-ascii?Q?ZVFCZkFIQUFZUUJ5QUhRQWJnQmxBSElBY3dCZkFIUUFjd0J0QUdNQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCbUFHOEFkUUJ1QUdRQWNnQjVBRjhBY0FCaEFISUFk?=
 =?us-ascii?Q?QUJ1QUdVQWNnQnpBRjhBZFFCdEFHTUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?R2NBZEFCekFGOEFjQUJ5QUc4QVpBQjFBR01BZEFCZkFIUUFjZ0JoQUdrQWJn?=
 =?us-ascii?Q?QnBBRzRBWndBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWN3QmhBR3dBWlFCekFG?=
 =?us-ascii?Q?OEFZUUJqQUdNQWJ3QjFBRzRBZEFCZkFIQUFiQUJoQUc0QUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ6QUdFQWJBQmxB?=
 =?us-ascii?Q?SE1BWHdCeEFIVUFid0IwQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFB?=
 =?us-ascii?Q?QUFBQUFBQUFnQUFBQUFBbmdBQUFITUFiZ0J3QUhNQVh3QnNBR2tBWXdCbEFH?=
 =?us-ascii?Q?NEFjd0JsQUY4QWRBQmxBSElBYlFCZkFERUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBY3dCdUFIQUFjd0JmQUd3QWFRQmpBR1VBYmdCekFHVUFYd0IwQUdV?=
 =?us-ascii?Q?QWNnQnRBRjhBY3dCMEFIVUFaQUJsQUc0QWRBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQjJBR2NBWHdC?=
 =?us-ascii?Q?ckFHVUFlUUIzQUc4QWNnQmtBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUEiLz48L21ldGE+?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB5088:EE_|DS0PR12MB7509:EE_
x-ms-office365-filtering-correlation-id: a5d167d5-3980-4913-20da-08db6ca712b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 w/1IoLyBJmMRxn/LdBvvjzhjI03j9pNOx1gAvtAc8b4mHMLsKY8mWX94bywFO04SxPrMR8Wo1dS2gAFQHrydcWQFQfJbc+80pyggmPAEhPIN6kAFMiMKv3VrovG7CdPCL8tdsy7Jyp09AY8oL5acc1jM30wxkm5gxo+KXeHK7HL1ae5DPG1gZxFHoTDnP/bu7DMJdADPQTlZQW39ad5ASnuHwnHHcFtdlmBvAqGOKFnnjqWSM/KwWMhOv4E8bkSAFw1sClsOpqxoD05corDAtJEuPQagsNfzCYnvU/H7hxgGZhE0kgHDx2Wez+1LLuTePU2k25S7DP2YVzJECotieuH1bkJMSO5nIjiNkc3n+oYdNQS8Ra+DTKaB3Zqkq3uEZNPAEEVvdDXgTOaiF1Qa4iz643qYlvUKjvJNeOcD4u95bGnfbKlqrwgiJf5LEsLJ2fq8hXEoc9JiJaFrJkuydKQewgebykitHG2QhieRGXqDoMucOWLQdpNQ2mlQatkgIrZtkL4fTGaw05h1l5utoLBD/GZokdCKWu6NGdvDAhxuctf6S8l00SNBce9eFRBrVxPp1DeFYDlvltsXtg2pIjK4OFxiAdnvwi1rcHdkhb2JG3wYz5DwU9r3rO2vrUi389DMzmUnKa5p9buYcRHVdg==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5088.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199021)(55016003)(110136005)(122000001)(921005)(71200400001)(8936002)(478600001)(8676002)(5660300002)(41300700001)(316002)(4326008)(76116006)(66946007)(66556008)(66446008)(66476007)(64756008)(38100700002)(186003)(7696005)(107886003)(9686003)(6506007)(86362001)(52536014)(33656002)(38070700005)(2906002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?LS4jvlfmTKPsNSAhH1zSQ5pT10yZLyo5MYfK6NY9JqJjdXxpGjRiN4ZfzIZz?=
 =?us-ascii?Q?EKr5E9wpRTYXoKRYkjuVPGgmhvQYgKvHWBVBoYb0MuSxY8PSaOvGbYOrw0bF?=
 =?us-ascii?Q?hUn+yYm58dM3RKWVLlIdz8RxfjX2F2ntKYq681GEJJO4QTtZyIxtzAiT/xsa?=
 =?us-ascii?Q?au3Po4Q0JDz5Mhho5qqd2k2RlNfd4ChKZVcstjKgwH114VKXNMJFRiMmWoFR?=
 =?us-ascii?Q?u8VlAMG1xoj1PyGOJauhRuth86i2Rh97FvdFVjjBGTwax5pUEitFfYfjZzW2?=
 =?us-ascii?Q?jKZWy0qPe2LeXC2RyMFimgVbZbALugevtmu2wekYE9AlXPIVkdeTFt/Y8tHU?=
 =?us-ascii?Q?bJwnjZpYe1K8HzLpALrz/c14cpf+K0DFgBp6GGcorjysHgaw8ABMmUJKjbz5?=
 =?us-ascii?Q?UoW0I7zvLHRTCY/MGXJgmtXEEdcI/COR9RSqDB1sXshtJEml89NNjX8sWtyM?=
 =?us-ascii?Q?YsJ82V5c7OzMvu8HnrgOdBAdHi094UvW/7quTYeA6yyNGPh62IYkgy204Wvu?=
 =?us-ascii?Q?t4RJtjzr21gOnyVX1WMOqe/W+TfYOmJTSdz2+jRu/sistX7s+OjdhqDdetTw?=
 =?us-ascii?Q?qh1Ey/a/IYQqqOYOBAqdAFDLnPYtKC7v91R2HGAUsgjGcRGiJUa1XfAHCEIK?=
 =?us-ascii?Q?pJ+nnfV0mvCeBAdnYfESdIHlZ/A08qDozpyXdn7KEO8F1+cFZ1wvaV2R/bq3?=
 =?us-ascii?Q?zLYsfi9fJ0eUlDJ6Z3Ney4UT4l04pyH89qP7Jy/WPI8UNP+H2deY8L+iYcN2?=
 =?us-ascii?Q?a+GHaFLp/lgJeoJ9/xanqXN5v0zwLTQW5JoYIptwZICLg0fro7NhITOmpLxe?=
 =?us-ascii?Q?Y7F3khlo3wIFbPXRaOhr2gwU34ZArNv9tXRCd+GMHg/vfgTHw/1MW3bmhprp?=
 =?us-ascii?Q?3zisPxnOLZtEOpr17Nliuzpe9pcSEBzk6pVrAPgNvrsZ1BW+zjtcPHwjvkRT?=
 =?us-ascii?Q?qtCinjPi8a3/ehpxwLcIaqBD5q+2fbqHnqv8i+NjewE9PjGBvxnJv7guGr3J?=
 =?us-ascii?Q?Z+au3BWPtxbPgOPAlMF7KojKM4A/zxm6wkkTzEQkMjN3tKsB90r5PAndMP5j?=
 =?us-ascii?Q?xfdrG+ZcIqsfFtG+6otRhTVdVWyb+0EQ7ElMAUvmVY1mURyYw65kHLOXNmHi?=
 =?us-ascii?Q?/oKnVtvugAsyCoxsASALkeVP+RBKKjLdod4KUi6a7CQ07xjcS1sU5X+lDerg?=
 =?us-ascii?Q?LZtFUzLDALrV4bTDdIoEZdh4BoCParWIUuOHsnLwkK8opwPyEDu/RCsY1phg?=
 =?us-ascii?Q?E4rJNQ7+aGGXeI1TjdFu4TEpKUsXnCCi4VL80kETAuK3eIpAnO3Llf/X2p0c?=
 =?us-ascii?Q?fmqhhWP3COS6n9uvDUI60DUEe5ZRzEWE6wf+EgJMbyImasOtDwZ5D2f1aWFZ?=
 =?us-ascii?Q?LzAlLf5vsUJRRCdzJVhvYZbYyBIMPRtqUllXdi3Wc8voFUi9o6mUQFD8rNtI?=
 =?us-ascii?Q?1npjv2ApIbz53c4nOwSshZTzuziObNwTF0QGIh3zYx8MBbP9+eSt6hACwRDs?=
 =?us-ascii?Q?iSldgJpfoVNkhclWqd7CXsU/kthOloysFTJEht/RuFNB+yBqFndASZvtsw?=
 =?us-ascii?Q?=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?yuPy00iWwu4kwC4xPixaE62nGbs+1IphSIYuenH3Oak9fjTK9dA2ZbUXfPVo?=
 =?us-ascii?Q?FTnUMndEBeMCvumZxqcwFl3hFw2mcG3BVMbWRZuFoe0Fldg4duV7lTHHZp5x?=
 =?us-ascii?Q?9VDlHxY7Lx6yNW/8E31OQplvFPNM4bQesGIpeb6ooQRaSWTUXSeAyaEFaSvL?=
 =?us-ascii?Q?YTmwktoX0/3ELGNflLzhjNDElZhF8cTl5JkjMNdXx7yLJk53xRuzZPmfbDy6?=
 =?us-ascii?Q?JMQK9ge5qw8g5vpKzkcZlJ0v8naViYlc1q5fvRXzncKDIf2tICntVsBjNofl?=
 =?us-ascii?Q?BMzE4fLxMoLVKg965KKEt9BkCsUdW6mKLQPJg0X5xgqKlRWENX+1i664iWWw?=
 =?us-ascii?Q?SrSevXWVJKCO4SmfeD+Wd6eX/3e9pUGwgHsLc547qqCEQR6i3DjxURF10Iim?=
 =?us-ascii?Q?wrdLV5wArCawLHWzs19KycmJN8DUgCfkiQBhv97Q4kuplrRLKCDueBE+6VYn?=
 =?us-ascii?Q?3dRDn5Jm+B+ahjTdKqT9XcqUpqRmLXFrcsZsCnKnTLXpSIgy70Fo76V62b5p?=
 =?us-ascii?Q?G8Kjyh5mL4l56SbKMkMnfMqJpeUjIe2DvDIiEWTjnN8uuSs588mxQECqyvdh?=
 =?us-ascii?Q?bOePJM3oq6FBLskhQ9xZ4EAM/wt0CRvVsEpiPKKbZ8ZG1AnlWpA5bMhM41c/?=
 =?us-ascii?Q?sXIgVwAlseKN9RIIyFLa/Yqor1cfx1y9bWkjOXHFssZLERtzH354Pdf3V27p?=
 =?us-ascii?Q?wboDB/quY4BSsxqsaqKnT6x4HYqTvCRYIpl9REsFyhQI2/uNlU/HKaQ6fHVy?=
 =?us-ascii?Q?3p53s40cMRQxjsvAwHkqtFICrJcvL9I0DQQbQJ6bvr1RKxKdxyxhifN1/nYY?=
 =?us-ascii?Q?WaGBhx4Y7JgKNSU9Y6++a2GDmP1EtEjw3aFkNS2prAe94o64umvR+4KPAUIO?=
 =?us-ascii?Q?nWREruvsICv+K2Cs8l1W0qvlIW9/3IvIG/TxHZZChhHNij1at9dZNlRRSBtm?=
 =?us-ascii?Q?LPTBJQ/kQQp783bneoXQ6Vph+uO06hFC5MvW9faypsluzPHIkzkOTlDKTApT?=
 =?us-ascii?Q?NZ8V3Erd82YKe8zwNrLgEJGASmfPuPDCgkjMFci3l3tVHq31NhhB2byLBtpQ?=
 =?us-ascii?Q?TIVYMz22XIaXjvnWeSZq42XflUxshz+6L+U0BIAeqPi4Bj67x0xeMBM5uf6t?=
 =?us-ascii?Q?RAN+Hw+Qlb5nQDNrgndBZ1lxmoz0f0WOmGrxJjLVss7Z8qRNgqiA56Y=3D?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5088.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d167d5-3980-4913-20da-08db6ca712b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 07:15:03.1677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yTVzepmXDKrOY6G4oeoeFPnEaO+MMFFhywfyEpIpXuLKGJ+Anaqeu4ToT7RiHS3vqsz/NBjLtvONZAUUF5ksYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7509
X-Proofpoint-GUID: yeh0lwdA9LfBIpV5xHn-7ojm1OPn4nM9
X-Proofpoint-ORIG-GUID: yeh0lwdA9LfBIpV5xHn-7ojm1OPn4nM9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_03,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 phishscore=0
 spamscore=0 impostorscore=0 malwarescore=0 mlxscore=0 adultscore=0
 clxscore=1011 bulkscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Christian,

From: Christian Marangi <ansuelsmth@gmail.com>
Date: Sat, Jul 23, 2022 at 15:29:32

> +static int __stmmac_open(struct net_device *dev,
> +			 struct stmmac_dma_conf *dma_conf)
>  {
>  	struct stmmac_priv *priv =3D netdev_priv(dev);
>  	int mode =3D priv->plat->phy_interface;
> -	int bfsize =3D 0;
>  	u32 chan;
>  	int ret;
> =20
> @@ -3657,45 +3794,10 @@ static int stmmac_open(struct net_device *dev)
>  	memset(&priv->xstats, 0, sizeof(struct stmmac_extra_stats));
>  	priv->xstats.threshold =3D tc;
> =20
> -	bfsize =3D stmmac_set_16kib_bfsize(priv, dev->mtu);
> -	if (bfsize < 0)
> -		bfsize =3D 0;
> -
> -	if (bfsize < BUF_SIZE_16KiB)
> -		bfsize =3D stmmac_set_bfsize(dev->mtu, priv->dma_conf.dma_buf_sz);
> -
> -	priv->dma_conf.dma_buf_sz =3D bfsize;
> -	buf_sz =3D bfsize;
> -
>  	priv->rx_copybreak =3D STMMAC_RX_COPYBREAK;
> =20
> -	if (!priv->dma_conf.dma_tx_size)
> -		priv->dma_conf.dma_tx_size =3D DMA_DEFAULT_TX_SIZE;
> -	if (!priv->dma_conf.dma_rx_size)
> -		priv->dma_conf.dma_rx_size =3D DMA_DEFAULT_RX_SIZE;
> -
> -	/* Earlier check for TBS */
> -	for (chan =3D 0; chan < priv->plat->tx_queues_to_use; chan++) {
> -		struct stmmac_tx_queue *tx_q =3D &priv->dma_conf.tx_queue[chan];
> -		int tbs_en =3D priv->plat->tx_queues_cfg[chan].tbs_en;
> -
> -		/* Setup per-TXQ tbs flag before TX descriptor alloc */
> -		tx_q->tbs |=3D tbs_en ? STMMAC_TBS_AVAIL : 0;
> -	}
> -
> -	ret =3D alloc_dma_desc_resources(priv);
> -	if (ret < 0) {
> -		netdev_err(priv->dev, "%s: DMA descriptors allocation failed\n",
> -			   __func__);
> -		goto dma_desc_error;
> -	}
> -
> -	ret =3D init_dma_desc_rings(dev, GFP_KERNEL);
> -	if (ret < 0) {
> -		netdev_err(priv->dev, "%s: DMA descriptors initialization failed\n",
> -			   __func__);
> -		goto init_error;
> -	}
> +	buf_sz =3D dma_conf->dma_buf_sz;
> +	memcpy(&priv->dma_conf, dma_conf, sizeof(*dma_conf));

This memcpy() needs to be the first thing to be done on __stmmac_open(), ot=
herwise
you'll leak the dma_conf when stmmac_init_phy() fails.

Can you please send follow-up patch?

Thanks,
Jose

