Return-Path: <netdev+bounces-10993-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55C4D730F2E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:19:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B6C72816A0
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70047ED0;
	Thu, 15 Jun 2023 06:19:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54451ECD
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:19:33 +0000 (UTC)
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBD4211C;
	Wed, 14 Jun 2023 23:19:31 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
	by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35F1GgG4030923;
	Wed, 14 Jun 2023 23:18:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=NsFgA66LYJD5kiF3fXC8M+T0APglxrdExdP9zyaA9eQ=;
 b=DrcblvIZSGfCP6qUWUwivaKMAWLkck4f8ihlqDr5VFaXIb1gBmocbUmVH+SXMOxG/HZN
 YsJdGa4XMQm5JYOBN+73C8Sy4t6J+ts5RENyGr0btq5LC58b94nTtI4Vu2HOTecaT1dS
 4gcSrm7cL2cyrCXr0x20QGlTCJTHIFG6vvf0qN+r9qRJLAt8ttbF1Sp0PZeF8Sz998KY
 TZV2bz7JmKy8y4jj5GWWr9xLj4QGXOOvy8+AJ4GG3Ty0cw6/PGUvNL9qdCz2+WJmUfW/
 6M+nfxK+lAcx/9TPn6MU1UBo1pGBDPMEigjXXUi96HUQ5Rphoqc5P3idlRVLxoZp65Lp Pg== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
	by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3r4r6m51qc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jun 2023 23:18:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
	t=1686809937; bh=NsFgA66LYJD5kiF3fXC8M+T0APglxrdExdP9zyaA9eQ=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:From;
	b=I1NahjAuLVs6ta2CQpn7WsFNVvViT+T5YNHPU7gtccE84juLLxFrhfRLuJmkuA4Zd
	 Z7XvH46ght41q7kaq07K4IePjzPwReIMFI44jetdKVWAqwcyv+4iuK2chx8fUJ+nD2
	 RFqVkAmEbNHh8uOhh6AXuHjDFQs/GmHGerBsktBgI2nXMyvzm+/n/yW6CvCB4TEAtI
	 spHhLYRdD3RNjbVwTmqMmKy+5aERq7iYXQHa8NC5bdzQqm8QljBYcXKXWtmu/HTk6h
	 IZf8fnuRCvsmDg5YAejsJ8QS7q5TeO6q3HYgnDLrV99D92H1Y0vL54mT5ExAkd2COp
	 o7UeUjbkflqcw==
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits)
	 client-signature RSA-PSS (2048 bits))
	(Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
	by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D274140362;
	Thu, 15 Jun 2023 06:18:55 +0000 (UTC)
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
	by mailhost.synopsys.com (Postfix) with ESMTPS id BAE76A0062;
	Thu, 15 Jun 2023 06:18:51 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
	dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.a=rsa-sha256 header.s=selector1 header.b=agJ+FElM;
	dkim-atps=neutral
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
	by o365relay-in.synopsys.com (Postfix) with ESMTPS id E7DE44059D;
	Thu, 15 Jun 2023 06:18:48 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaldLbf8Phs7+e1EtbAchaTkO0y4xvQ1lJLRqGMEi9wDB+ClDFWVzkecxEM+aVv7n9BLol8xkmgvxqavpzoyo2m6MKBipVq8wVgmRnCo2BNpD8rFY/INYbAVJv6dOKUf4lQkN/PNwnTG2Pp0YmkDF4IMI+L6BB1+JzDIizhsQwkDi4aZ3ir8QMW4SlZEnJa+KHJ7WTHBLVAPxIgMMrjXq6ZfyRpfUv6MJG1jtDmviAR64jHDv5IEyvPIDxxAQUQI0Sw/netOMmkOkVzIVgweS1L9eTztfLaUODuerDljBQaBqL1qHMWwzZSB+3EyPDJnmK9Nvv5uOjISA3/9OZIztA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NsFgA66LYJD5kiF3fXC8M+T0APglxrdExdP9zyaA9eQ=;
 b=GputTOFyHvz9m3bS3HQ/shGoQdn/rhUccExYicz9mmYOtBXKBNTL5u+Nl/OHqCDl6/IFxup95vtccpIp6VF+9IKePrHY9nvu7SQ+wMoP7bArQURHrE/ryaEn1tKcbPwQ2rbO7LJrW7QdjeOB5lhZa4TTaF6zYW7UPHubQuBXCTPhcbxOY+2llbHaNe2WAi6A0yaB6oCAZzj/rjgGcCrllwmTlUhHaHyRE+2FoCEHLO2Mkz3INzYjfP/VaKhowTvL9PZDmgmMzTfqiHmgghcrnY7SYn1Aab+5M4bM5y7b3ADfs3ez0uVz7zB8xHNPdbcqVVuhioqhbPnEDbxyj68OoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NsFgA66LYJD5kiF3fXC8M+T0APglxrdExdP9zyaA9eQ=;
 b=agJ+FElMcGU46uckkuGk+fHgpKSQYX7epervALQBrfRx/k1NC19H7BOHZfmdWJBa+GaWLOuWpDts9X+W3hirQAVBLGWpr89o8ZVkc7mn9h6Ezy97MTALVRkiBAxOiHcbaoig0QoHJGlSEM+2jCy2J9qwVE6W+vMK+2sJbgx0+UM=
Received: from DM4PR12MB5088.namprd12.prod.outlook.com (2603:10b6:5:38b::9) by
 IA1PR12MB7734.namprd12.prod.outlook.com (2603:10b6:208:422::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 06:18:46 +0000
Received: from DM4PR12MB5088.namprd12.prod.outlook.com
 ([fe80::2f21:4162:3ecb:68de]) by DM4PR12MB5088.namprd12.prod.outlook.com
 ([fe80::2f21:4162:3ecb:68de%7]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 06:18:46 +0000
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
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: RE: [net PATCH v2] net: ethernet: stmicro: stmmac: fix possible
 memory leak in __stmmac_open
Thread-Topic: [net PATCH v2] net: ethernet: stmicro: stmmac: fix possible
 memory leak in __stmmac_open
Thread-Index: AQHZnthZIpDsy937hU25DOLowXgjL6+LZJkA
Date: Thu, 15 Jun 2023 06:18:46 +0000
Message-ID: 
 <DM4PR12MB50880561EC92E25F6A721944D35BA@DM4PR12MB5088.namprd12.prod.outlook.com>
References: <20230614091714.15912-1-ansuelsmth@gmail.com>
In-Reply-To: <20230614091714.15912-1-ansuelsmth@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcam9hYnJldVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTdhYTlkYzM4LTBiNDQtMTFlZS04NjJhLTNjMjE5?=
 =?us-ascii?Q?Y2RkNzFiNFxhbWUtdGVzdFw3YWE5ZGMzYS0wYjQ0LTExZWUtODYyYS0zYzIx?=
 =?us-ascii?Q?OWNkZDcxYjRib2R5LnR4dCIgc3o9Ijg3MSIgdD0iMTMzMzEyODM1MjQ4ODM4?=
 =?us-ascii?Q?MDQwIiBoPSI3WkI1NGRTQ2xIL00ycDVLaDRJSXRjNXBWSTA9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUNZ?=
 =?us-ascii?Q?MVFFOVVaL1pBWm1Lc0xCeVRBOEhtWXF3c0hKTUR3Y05BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFBR0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQUZWYVdwQUFBQUFBQUFBQUFBQUFBQUo0QUFBQm1BR2tBYmdC?=
 =?us-ascii?Q?aEFHNEFZd0JsQUY4QWNBQnNBR0VBYmdCdUFHa0FiZ0JuQUY4QWR3QmhBSFFB?=
 =?us-ascii?Q?WlFCeUFHMEFZUUJ5QUdzQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdZQWJ3QjFBRzRBWkFCeUFIa0FYd0J3?=
 =?us-ascii?Q?QUdFQWNnQjBBRzRBWlFCeUFITUFYd0JuQUdZQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFaZ0J2QUhVQWJnQmtBSElBZVFCZkFIQUFZUUJ5QUhRQWJnQmxB?=
 =?us-ascii?Q?SElBY3dCZkFITUFZUUJ0QUhNQWRRQnVBR2NBWHdCakFHOEFiZ0JtQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCbUFHOEFk?=
 =?us-ascii?Q?UUJ1QUdRQWNnQjVBRjhBY0FCaEFISUFkQUJ1QUdVQWNnQnpBRjhBY3dCdEFH?=
 =?us-ascii?Q?a0FZd0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1lB?=
 =?us-ascii?Q?YndCMUFHNEFaQUJ5QUhrQVh3QndBR0VBY2dCMEFHNEFaUUJ5QUhNQVh3QnpB?=
 =?us-ascii?Q?SFFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVpnQnZBSFVBYmdCa0FISUFl?=
 =?us-ascii?Q?UUJmQUhBQVlRQnlBSFFBYmdCbEFISUFjd0JmQUhRQWN3QnRBR01BQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJtQUc4QWRRQnVBR1FBY2dCNUFGOEFjQUJoQUhJQWRB?=
 =?us-ascii?Q?QnVBR1VBY2dCekFGOEFkUUJ0QUdNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?Y0FkQUJ6QUY4QWNBQnlBRzhBWkFCMUFHTUFkQUJmQUhRQWNnQmhBR2tBYmdC?=
 =?us-ascii?Q?cEFHNEFad0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBY3dCaEFHd0FaUUJ6QUY4?=
 =?us-ascii?Q?QVlRQmpBR01BYndCMUFHNEFkQUJmQUhBQWJBQmhBRzRBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: 
 =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnpBR0VBYkFCbEFI?=
 =?us-ascii?Q?TUFYd0J4QUhVQWJ3QjBBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUhNQWJnQndBSE1BWHdCc0FHa0FZd0JsQUc0?=
 =?us-ascii?Q?QWN3QmxBRjhBZEFCbEFISUFiUUJmQURFQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFjd0J1QUhBQWN3QmZBR3dBYVFCakFHVUFiZ0J6QUdVQVh3QjBBR1VB?=
 =?us-ascii?Q?Y2dCdEFGOEFjd0IwQUhVQVpBQmxBRzRBZEFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCMkFHY0FYd0Jy?=
 =?us-ascii?Q?QUdVQWVRQjNBRzhBY2dCa0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB5088:EE_|IA1PR12MB7734:EE_
x-ms-office365-filtering-correlation-id: 78c83ebb-658b-4005-767b-08db6d68603f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 ABeB8Zz67fVK3qa/7U3vRYlFZITH6szPkx/Ppajhzl8ECGrLLv7Y0uzskO8EcTZA+hexsxX329atdEA4zhW8HLC4AmavZucxobpVLiM5BwXqqwF7a5PPCNh4SxfhfZNq4FABA8Vw7yTax2SDmxKJ2zSvCvf6SVt2pYY1Owh/Q8AqPC87FIcj5NKotJSkrEa1CaG80755klhiAJhko0G9XFP/ggVhQwHgLxAGxAmd9q/P5WDgIP/gW8qQCh+SC0f6lPi4ZIy849mXmlOOuID+XAukLezKl2ttolH7+RdaxBFJEsGETi3EhOvt6zWBMFMSe6R5MdWzJnBpTVx8nBjPfQ1X5v3bKrJQRyBwQx9MtgI/VYspUTV2khJMfi4M0oJlaraL4yk0cSdaho07nRFG2J8vm+cuZ7r+od356uIkcmtAWsWLIvUp793gNDF5O/2cgBPUQNvuLuk8Ke2iiWZwbFtVknAzM8joUSwwIl1yBUYw8S7koOxZRPWOe2XtqjKzn1O4m76ITjJSFXQnFbV+BaweQ91ckeVblHHRwg5mGHpuQFfHqa0nco90xkysCabXuhswlwQVwmn7bz8k+CPExZORqAh5s59GfhuCfwKkNJ4cZ7yYqi2ErGIe2PddYoUo
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5088.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199021)(921005)(122000001)(38100700002)(38070700005)(55016003)(71200400001)(478600001)(54906003)(110136005)(7696005)(7416002)(316002)(41300700001)(5660300002)(52536014)(8936002)(8676002)(64756008)(66476007)(66446008)(76116006)(66946007)(2906002)(66556008)(4326008)(4744005)(9686003)(186003)(107886003)(6506007)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?8vhHdNbZ1SwkX//uLmi7JnFISX/KxjxdfuOKyy1GmFcQ3A6UomBjlAFr1h2z?=
 =?us-ascii?Q?mPDMJyP9yDUaphaLd2O4JmtytU7yGMt25t8XAhHtxVYPxNr73ZRWqgnsQyMB?=
 =?us-ascii?Q?wvGKJQoJAX7C+4q+mXfZdjp2TarocZlKjHnTGIuT+j0VqqGNUZde1uduRjaN?=
 =?us-ascii?Q?JedzFalcpWcjF+yjPhsNkIoL7L6g8C+N/SXchpCKFDmcUYHhfd+yGmxyUt50?=
 =?us-ascii?Q?MzGzHwL5znWc1j3JHUZ7KgR8LFN5yy0o3e+UiedwNRVGmKFrxbuIrKZqfmpX?=
 =?us-ascii?Q?JiVYvsEtYsouANV0UwMbG93BMUZ6xvB/jrcusuCsWXL4PIjU4tg+l0caDoSY?=
 =?us-ascii?Q?OWeHMWTkvoUf+N6UNFvcsvfFKd26DbJKXfX86k5DOJbU0H8AV3OWCHRbhpqH?=
 =?us-ascii?Q?X8lsmu+m6kmmSjjDe6blqTMvpObPNbgO9MIBQXUTNbk7BovGsdzjtgNzus9y?=
 =?us-ascii?Q?kiFLNy89feuHmqEeHid8OwpIgBEyYPzBvgrXK1MRUpsiSK9YCbzidmQ+DXBX?=
 =?us-ascii?Q?bQ4KWHVurwo5uZIR3lei0IgU3de9/zwYXWEg/AMJFmB6j0SqQKPmznzX9apq?=
 =?us-ascii?Q?FxrwLgnJkdfKerXpEu4u8V9f0iV6Wb/Ji1eG6TNYAq4U2s1X5JrmxBNmN+qE?=
 =?us-ascii?Q?wvbK8smWnF+YoJ6x6mPf/o9Eodw1fEll6S7GW8jY3IcV6yCLI/pJe1tsdRUb?=
 =?us-ascii?Q?sd73yZEeKOP9XyjKywGZvJgePMzub2eqeymhosaM/dKG9pfUwp1ofInJNt+y?=
 =?us-ascii?Q?2NC29TWlL/FrplaczRLmOgkWnm3WqFHIFvbP5zifZ+aZBT6TEqxxLAXdZ/qM?=
 =?us-ascii?Q?ylfhOhWgM6GYNeXdEEzExyXsu8MBzRrURTWI0aN+5wreDGG051Rw9cLQcDlH?=
 =?us-ascii?Q?+uXUJpNrJMJrjawH29By/zjAF4jsi0nypUK6jvdJzrxdpprA206jC4W/IjZC?=
 =?us-ascii?Q?LwXOc4Vx5ceRkLDjdwwq/gDkTVwkl1UmHchDEHjQk1eKC0uf4VrcaAgZBlV6?=
 =?us-ascii?Q?rScQvGYQTJbHKw2dygsvOpCgUZbqhY/BE8yY216SWeMlvnr8RNvxUPVjDPYo?=
 =?us-ascii?Q?Km5Vz6WMePldWajWnNQ49Ma49bB8S4M7vnRoy8EX73gfLFVuIToAIVvf2tcN?=
 =?us-ascii?Q?Ylbn+HH559veTDeju95ockYxmwveUlk8Rhm6jHY9L+23OxZNjQBaVt7pEAkp?=
 =?us-ascii?Q?7nRQARMaXp+Yaq6rjg1lOw/uC2Mcz5Hy++KlIO3HB7VkoqYayAj5u9+qA/bn?=
 =?us-ascii?Q?/MKWt4TaIXK9AIShdscyWjdXo+I9pnl1r5w07kBhl3w9/WUw9927fIu3qsS9?=
 =?us-ascii?Q?j9Ch4oWYSGVLG90TFOSK/4dYhoFLo1dUEkHRAdsydyx3kzZydUpYGV3ACIT9?=
 =?us-ascii?Q?gmF5ih5xk712AA1knnXCqq9MVB6pw6qrOGIomct5btNQLu+f5BESMlQPbp1u?=
 =?us-ascii?Q?TgKJJ6Xj6gQauhdMMRnUYfFp2sEq6WruIVwPtMf4mw8kDoxzX69heTjPPjp5?=
 =?us-ascii?Q?beMi5HrWoClanbOpwoI9COBk/CvnIxF6rLHJcLu82aRgqOp7/hrt5abtdA?=
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
	=?us-ascii?Q?v45zOlt6Zh+U9lYHyBIw5hLYdu2vBjQTCZqOpetg+rw0xizo/sM+QmzvMKti?=
 =?us-ascii?Q?BEK26IOFUK3VcRLcBNodHNn/arUkXjALJ4ShRHOcfP6LOvTe1Sir5pCrYC9R?=
 =?us-ascii?Q?T5yBSperZ2J56ccrdJZBLblUqigotWDDjYtoUqThmAZssh9byG1pfmtdw0Yn?=
 =?us-ascii?Q?3MZo1I2xfz+QGRbmIdZOXKzIoyVXvS+hxtabw4UZxGEHrxoeKfgHfo+Ys/nv?=
 =?us-ascii?Q?v/fulML2hP+vrdX39c/eQ3T8RuqPRjq055/mkwTE9b1N2fmeyfLo2WG/L0Zc?=
 =?us-ascii?Q?yKVNgtH1w8FBUbTzmqg34pZPoTELBSEMkC5SXWoS8inzLjMOL/SEBt2OgwV/?=
 =?us-ascii?Q?akWbmdA7BLGWR3G262k5/bS4BGLobpd9f0e5KFeP4iw+umVW1KeU/hsWdfLR?=
 =?us-ascii?Q?W62MyMURDMwSGsAbaLGdcBIcGkIni4y3zegJMSksZSV2RkGcndNjie2ZZYL2?=
 =?us-ascii?Q?2q7zCR5C/dSfNWibiAm3LKNti1HpJJisqUX4+PWjq/9pIANci5MLso+q0hPL?=
 =?us-ascii?Q?q2hP+46N/A/gGK5Qq8hswKsGDlZRy9j8xajsARlhBc2YrIydVptXzcHQnVFL?=
 =?us-ascii?Q?nSKVx26gdSwb0aIMxzvGh6vvbhVL3oWrprweCfN5pFOpNaQy/3KEyzPvYI22?=
 =?us-ascii?Q?4YfRNn/z6HObWF9Z6gQKj7Rbq2OzaCoTDenGceymPzf5nZ1QgEiPYbalcvS7?=
 =?us-ascii?Q?D0vVQFeKkPqygAL2wy8tNkNF6OKmkDr/3x2qIuVSfoUjenTfABm2MTalZB/0?=
 =?us-ascii?Q?LHcN2SHbQeJE8JXpx6EujSLdqpZB6/n3bi29HISIWjBkV5p3Uzi52rCM/L2X?=
 =?us-ascii?Q?8Pi2vAzj1BEmbPLyu1IzkhaLp3VbwiYnOUMWENXB9A3dZzZMMGi76bN1zf4+?=
 =?us-ascii?Q?pPsheraKypwcoykcNpGEb1twJYgsVb9TzVc7jqmRLy2z1e38appKN2FNCwsh?=
 =?us-ascii?Q?vePHfzVU3JJu9GfQrLlYpIMBpggx0a+wcnZw8r7DR2SqkQ5BH5gjhmSjb7HC?=
 =?us-ascii?Q?D5RoVt4bikDI68k2K4zjpVKOGsiJsibH1q2lUmlTAjsTec71Tp/jgLLCng43?=
 =?us-ascii?Q?A0b+2l13TN435qBdQz/KRZbentgyIoENuafAti7nA+puWQ42EYgrhQVuFolS?=
 =?us-ascii?Q?V1UL8nOWy9JsjkI3oiMNuciFWx1TOFZNB6hrBLqXxRnZGBBVSYMlO2I=3D?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5088.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c83ebb-658b-4005-767b-08db6d68603f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 06:18:46.1697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MFEwKPsFI0mXa91SBW18LCUBQv9SzxHSDn+0s3dN5qxZeIQiw1oaEvPuyRUkzkoeV4/wlHE+8g32nPkGMp86Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7734
X-Proofpoint-GUID: jL7MwNQffBFLAnOM5BWIQPAIomqEn2hX
X-Proofpoint-ORIG-GUID: jL7MwNQffBFLAnOM5BWIQPAIomqEn2hX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-15_03,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 suspectscore=0 mlxscore=0 clxscore=1011
 adultscore=0 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150052
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Christian Marangi <ansuelsmth@gmail.com>
Date: Wed, Jun 14, 2023 at 10:17:14

> Fix a possible memory leak in __stmmac_open when stmmac_init_phy fails.
> It's also needed to free everything allocated by stmmac_setup_dma_desc
> and not just the dma_conf struct.
>=20
> Drop free_dma_desc_resources from __stmmac_open and correctly call
> free_dma_desc_resources on each user of __stmmac_open on error.
>=20
> Reported-by: Jose Abreu <Jose.Abreu@synopsys.com>
> Fixes: ba39b344e924 ("net: ethernet: stmicro: stmmac: generate stmmac dma=
 conf before open")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org

Thanks for the fix.

Reviewed-by: Jose Abreu <Jose.Abreu@synopsys.com>

Thanks,
Jose

