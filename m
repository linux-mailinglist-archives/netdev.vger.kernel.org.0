Return-Path: <netdev+bounces-10738-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46EF6730088
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 227A81C20C2A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B83BC2C7;
	Wed, 14 Jun 2023 13:49:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AAEC8F2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:49:24 +0000 (UTC)
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C779C106;
	Wed, 14 Jun 2023 06:49:22 -0700 (PDT)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
	by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E9Y0bj006550;
	Wed, 14 Jun 2023 06:48:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=o2QQxML/YyEky7GKWsEsKlPi5Yc+wP9M172k2LFUxyY=;
 b=HiH6G71uoLCBt06vlOVOTKZczP1J7WKlP8fJqsVMLZ9T7+/nk6jSGYCi52pEc9x0hfq2
 oMDE18nBoKbnptzFmDKv4OEPdQHvQodZHFg8piTSwLDKOiwcJ70NFVgcGXZNWvcM39pr
 0eIy/l2fNYnVNF9UIQt8ZAfp/vNskWYRIRz7365M+SF/DgJnIOfNUVxl8aVfpurmUGO3
 314JAA4Qo0M/hUnWO0tR9RGDIeisEeB9XXKBljAEycD9DPjFSMNCzZ6dXHymHmWia67t
 OhliE6+plM3ZoDM5d3xlRiYayN9n8QWVXUicIRQQ3i/naDzW6LAC8N1tnNmUAvSY8NE3 hA== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
	by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3r4r3u2q5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jun 2023 06:48:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
	t=1686750529; bh=o2QQxML/YyEky7GKWsEsKlPi5Yc+wP9M172k2LFUxyY=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:From;
	b=VtkANdCHokKKntcTjCibVfMZUsD26bZy/hmdviyb0Mg11ZzjRIF9LjNnIhhFDyWJX
	 rrd7EXfA3HDB7EeCY4dph7eYisfbGcIHkEYaqqlDyQvBUnTit4axThozlNyuvMEZPu
	 oGPvMFJpALsrEgkwKgPDUcZHm28UbvYMMwE13tHuzo2lsJE/eVaYwyxxws9vQLKMYl
	 04/99SOiLxS6H8KsizYxHinUtYcXnP5d3OJVHf1B4mSmPCFP6O3wGmapXm31EDwQRi
	 mcw0XSAOtGWaOMj3uq37v+47mqOVQxzaNp8DdyTwZTp5OKuL1pn4ey0oxJPJMeqz6E
	 BBSKR/frIZAjg==
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits)
	 client-signature RSA-PSS (2048 bits))
	(Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
	by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 77C0740136;
	Wed, 14 Jun 2023 13:48:48 +0000 (UTC)
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
	by mailhost.synopsys.com (Postfix) with ESMTPS id C30E5A0062;
	Wed, 14 Jun 2023 13:48:45 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
	dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.a=rsa-sha256 header.s=selector1 header.b=nydqKQoR;
	dkim-atps=neutral
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
	by o365relay-in.synopsys.com (Postfix) with ESMTPS id 157C14012E;
	Wed, 14 Jun 2023 13:48:44 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmNVlns+Sp7OJU3Y7xfzlGlpdNWIsbBlayjBi1mghb3AfsmzodatD20oqt5k5U12TS4l3UHddJKtelkPFX9nAM6pgBBc6TWkHNFnxKycS3XMDuOuM7uKP3dkQgNB4DB13LHLmQPLRHgPtB+8t0jkJcMZK7mlUDa9NvtewkcunYT4elvQiqUJU4xYCcD0BPRm4j/aU9yIMod2EztqAPLDadSbbtesDQU1cOMOWkmbgpC1kVVILdKLxyHO9ucHTJLCVGm6QnO+u2ZbLhVMk4CZ5SIy4lFZWQR/PHOELR8kX2ElqFkZvY9V1IGhtWWMOGDWDkx06jMjI/gLxdz8o4ctdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o2QQxML/YyEky7GKWsEsKlPi5Yc+wP9M172k2LFUxyY=;
 b=n5YlDcXl51RIRVJWoHx9+8SLLZmh47Gvh90HLmRbCPN2L7qOBYo3vgzP6iuFcpPPCQ5Ro+mog9j3gXRf74ud45JYdhcttDWhrn1DL/Tlghx2ZSBmsTEjuTpTscnD/esc+WYmMgxsxzGcO3D7A6LoY/d0QR8501MaeqJDrnkYBMf6NVfH8AejecXWccAMF7ePOA1MXYsm6aNiEr/6Oma4R4kLoTzj32YgO2/DbmKIwiCslj41OqAsOmQXQwnbANDouWLvVQRWx4oyX2AB/vyKTVxZhuSEoOXHNRlK6kNwGLG8r1/yyLR2lltEcC3PckPv5tmZHp9WEgeT15BvtuQ+pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o2QQxML/YyEky7GKWsEsKlPi5Yc+wP9M172k2LFUxyY=;
 b=nydqKQoRXdJutxWUz7BcvVVGmONeKI9VRfjZ2LfV33TcB+1cIss5kNYY+yi9xQSHeGzXnNDmv6y6NWQ135digHAThOaanjqhXyctYa1iP5kTrPNG6FZd+6Q1iJjH8OalBvuVwE+m+jp+91/hHpSY2e6LWxgHz9ylPdmtSHP0250=
Received: from DM4PR12MB5088.namprd12.prod.outlook.com (2603:10b6:5:38b::9) by
 PH7PR12MB7020.namprd12.prod.outlook.com (2603:10b6:510:1ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.42; Wed, 14 Jun
 2023 13:48:40 +0000
Received: from DM4PR12MB5088.namprd12.prod.outlook.com
 ([fe80::2f21:4162:3ecb:68de]) by DM4PR12MB5088.namprd12.prod.outlook.com
 ([fe80::2f21:4162:3ecb:68de%7]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 13:48:40 +0000
X-SNPS-Relay: synopsys.com
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: Christian Marangi <ansuelsmth@gmail.com>
CC: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: RE: [net-next PATCH v5 4/5] net: ethernet: stmicro: stmmac: generate
 stmmac dma conf before open
Thread-Topic: [net-next PATCH v5 4/5] net: ethernet: stmicro: stmmac: generate
 stmmac dma conf before open
Thread-Index: AQHYnqCzb/lINFBB6kaBEWXyCUbVca+L4V/w//+tuwCAAMDMQA==
Date: Wed, 14 Jun 2023 13:48:40 +0000
Message-ID: 
 <DM4PR12MB508899B25BA18E2E53939BE7D35AA@DM4PR12MB5088.namprd12.prod.outlook.com>
References: <20220723142933.16030-1-ansuelsmth@gmail.com>
 <20220723142933.16030-5-ansuelsmth@gmail.com>
 <DM4PR12MB508882D5BE351BD756A7A9A4D35AA@DM4PR12MB5088.namprd12.prod.outlook.com>
 <64898745.5d0a0220.546a.a6f1@mx.google.com>
In-Reply-To: <64898745.5d0a0220.546a.a6f1@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcam9hYnJldVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTJhM2FlZDgxLTBhYmEtMTFlZS04NjJhLTNjMjE5?=
 =?us-ascii?Q?Y2RkNzFiNFxhbWUtdGVzdFwyYTNhZWQ4My0wYWJhLTExZWUtODYyYS0zYzIx?=
 =?us-ascii?Q?OWNkZDcxYjRib2R5LnR4dCIgc3o9Ijc0MiIgdD0iMTMzMzEyMjQxMTkzODg0?=
 =?us-ascii?Q?NDIyIiBoPSJzQU04SWh0RmwvZDF4R1lCNnZvYThIZTRpMWc9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUFH?=
 =?us-ascii?Q?bTVMc3hwN1pBYzdzdCtRN0RLVnN6dXkzNURzTXBXd05BQUFBQUFBQUFBQUFB?=
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
x-ms-traffictypediagnostic: DM4PR12MB5088:EE_|PH7PR12MB7020:EE_
x-ms-office365-filtering-correlation-id: cad894da-c921-48de-c9c9-08db6cde0fd6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 keolzJWiK94ZPj5jHE5p1yBLHZxunFBpuqeUoqfRrof96zRCega0C3m3ukk2UspUA1ZSVu4DF9C91mhA+UJy5aXLjTe+7ahDF44vOK7X8ba7xk0GD9UiqEHLK15ESEmmoDQlzOWvR02jRLRjjWFrOqglx7dG9QcJmu5MiVUZo/AP4z4PD1ZTHvkHRyiN6Lg3XO57H3z1prHUBQEfhDEJBRRdodmdI480KVFesJmsPwiSfpy3SJoDIgmof9PMdgHRDYi9KbmrlfLg323w6pR9GJ6nolKVhdUvkqwI/StSstBhNDSQe9pPg7zuJB3zR1f13xuYDF0bxJyZIa/MEJxspeBtejPToPleOmvbBChjRpj3JPZbaObzlbec3lUc1pG3jYEx6GWNeQLmll0FaEji6l8tpDHstNCGTFlmwBCkpLolqKi+ckihfnHHd0CMviFfr7Z2fbQlLWzC8FmPGMor/jlKtJlH+OEgEEeWkRgOIVBOZCo8b8VNPLH/MChKnHrxbyW+di8MoqiFHeP5PEFK7I3F46jQqLxgfDkvZb2zgVPRz6pJ9vcssV0qIvaQ7UAPfeWvZHN9Uc/2uuvtWJfch4CWIwn1Qi8r3IRR6Me5/O/4vFy2UFvSDtelAxT4jWjf
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5088.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199021)(4744005)(6916009)(33656002)(64756008)(71200400001)(478600001)(54906003)(7696005)(107886003)(6506007)(9686003)(186003)(2906002)(5660300002)(52536014)(7416002)(66556008)(122000001)(55016003)(66446008)(38070700005)(8676002)(66946007)(4326008)(76116006)(316002)(66476007)(86362001)(41300700001)(38100700002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?kDFsLWYr4pGiaA1UI4p414eD8TJtXbyyiOs+ah6SHGRwgU9OPJ6YU0YQGNEG?=
 =?us-ascii?Q?/NexwBZ4WUD3DTz+TO32s9eszOJsJqNANhB6YFMHnhdx9KJjVFKggK4Y0XYn?=
 =?us-ascii?Q?JFveliJx2enTXqk4dWGnYiJ5RgJFU7lVHRMNbU+iA1Lz8J4ZglytsUu5V42j?=
 =?us-ascii?Q?pzO8I2Q6k/olAJjm8AR/07SnbSc+JsOo5oGV9X6q3nT6SM3jMyiXpDV6lAB+?=
 =?us-ascii?Q?v3cbPp76Trhn8eHlkb9w9DeWSIzVZr6jJvpCOxh5vUwcBm/1eJ3zocbJBsAU?=
 =?us-ascii?Q?d0Xn9K7KQp1F3RiEslgNN0ck2LoWhHUhrFDOsbjThs4IW/T2N0axQFLJKkIF?=
 =?us-ascii?Q?Mb08T7SpSNtlLog2fadad/4e9pd7CReVWu71dix7Bm7AfWeuuM1wd0GpTiJw?=
 =?us-ascii?Q?rlOBrufeASnBcGsjOHKdKkORviBhbGcPiWP9t7gB4uBKswe3hTFy8573Iebe?=
 =?us-ascii?Q?tHSqt+k9/QdNudL3HKZqck/2wmUUG/25oF836mvFvPWdWSY7UDUHZMlug/IQ?=
 =?us-ascii?Q?DplvGCDH9ETg91i54OwjjGuYPX77e8aWiX8C6A1/w/R9HjXOTbg1ax/Td1Rs?=
 =?us-ascii?Q?NpcmqjUHZ6N4FOmS0AdX50yAk1KextkvJcKAqGjkgb1NvxzR9QplIySURx7p?=
 =?us-ascii?Q?nptQ5+zRKjWVGXsnf0+UW/VxvKDuT5Vf8LQMUbLkfoLSV/ltM3dxY3pFb1Ef?=
 =?us-ascii?Q?7Dp0N/kG3ZGEI4kJh1I3ogngY7ETIKSbgZcd/0jTDJx1Ls0Y46AVgFNDbg3a?=
 =?us-ascii?Q?PM3pxO12fwm9gydtE/1ePG7uRTSyZO/f+6XI64Lm3onIGQny+WRfETIgp+QM?=
 =?us-ascii?Q?0oVxyQR/H7uGgd3BjtE9alxKlBYU3cNpUtTWV3SY+C3gEqp56BCc+omUrur/?=
 =?us-ascii?Q?5Ikm34DMnWqgsDLFzMp3X5eP9HMj9XcVbzE/BY/tWBd3jMDorpMqCTZcZH9Y?=
 =?us-ascii?Q?ZLWJ3Vl9jaSIgR9mORM/vBT7ZY38RZxMm5Bg95AJaNnkUrWHMTh6qLcAx6d3?=
 =?us-ascii?Q?fpyZLOPRkhdNnUkn+Sv8M6f/UXGl94egZPlXa8DFGQ5KYb+YlgcISFIzYBdq?=
 =?us-ascii?Q?UZhvfrBvbageYTwVQuqQTBgJdHT7c3e7HJsyCp/E5oG+Z3qjwSRzwxXf0DXn?=
 =?us-ascii?Q?pfGXhTzeZe3zHvvnGLGWWmEF4nQ7KtRuRm6yl5+vaCbukwdsLNC69ROK//rY?=
 =?us-ascii?Q?6mukObQ/H+abcxT+NkALcEr5FT8yp3g3hJ5nChCHvEEMUbxr46yfh6fFmuX1?=
 =?us-ascii?Q?zXACd2/JRyyDUZ/U5ALt8mwlYMxsux875Ow50pASzwpn1u3vsEiY29dWHdWp?=
 =?us-ascii?Q?8BJtNe2UpsidwUgg8f80s0JiawRRd379pOAr6WJGZWCsT8Q2kGlw8s3SzRZ2?=
 =?us-ascii?Q?HjvJeTYbPo0c1BriBGw7nvgW9FYbW4fz+WG4MSJ9LL3zAFhso/clpgMsF14p?=
 =?us-ascii?Q?7tswIQDQZTJ+v+uGIB0WQAKz9xM1RXcDXd7xrVbmBgK0Z71XBsxJgNl+dmxX?=
 =?us-ascii?Q?uT5LWYTRRTnrc+T/b9K9DpiEVDIhmYh9Hhb8BqeAZzZsj1cNU6Lpb+N7GA?=
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
	=?us-ascii?Q?H36S6J/qT/2BiJbUuB2msRAx+Bd3JtkjVxmeS72dKjCPC6dIZvUT4D0fa5op?=
 =?us-ascii?Q?lg9NrhtI/x9tfIuUVpIGv+fNKgBCSKu1EkBlf9LhkFgDd5d8reXmgOYbLZsv?=
 =?us-ascii?Q?4KZvIaDtNn9GoZKP+xjPuoGN6RgvGgxoqnqFYzhc4ugKFK/kAbD75SRggKur?=
 =?us-ascii?Q?OhWB+Mw/5baYFZu6C8ZS7SbGG+418WHf7DaSCs3vt55Dz4wnJ+V2J7a4P6DN?=
 =?us-ascii?Q?vYUC6i7c9PxSRabFnepE0Ei4DvFOSC4cboV4BRIyshGrjjhOJFZiFdVLD9DL?=
 =?us-ascii?Q?RuXTZwMfhU6frs5rDysR9I1+JtuInrqlfNS93dCnm16lc9UHs1PbYnWkty7a?=
 =?us-ascii?Q?SBPRPNdFntYrY+rUHjlKxybvHueLOpF7NLuVjMYKPgM8qzwyeZ2rrPQc2xk3?=
 =?us-ascii?Q?Xvt1HKXzwBaYOlNk4t9s1V9dyPPa1oaoFi8ZGqIdrNwVBOeJlu6oQzXqq9hG?=
 =?us-ascii?Q?UD0/pg1i6/1f40aMbXHzkDm4DSb8ooIj/3xj9bGLBCAnauLahr4zSLDgmvDv?=
 =?us-ascii?Q?sIgjsUl6/VM6DxQNAaU4nkfLzG2ETpVCTINTy/Ldkm+fyjL1FfFlIdeTEqR5?=
 =?us-ascii?Q?ivyIKp0qyQ4s2TR5y8YsfLU5axJPCOEbevznNw0Ke0b3FQD3/6fFOD8NO4Id?=
 =?us-ascii?Q?5I5vI3klOrKRbCgXQmQO5PypKnS4SUpCE7oNl1o3W1PPfGUtGinuTNmYXEVH?=
 =?us-ascii?Q?n2U7RFIYtQogbIwA/1fLD+Pe29t/M7gp7uNRosnZFSu2jNCt0jzEq45943W1?=
 =?us-ascii?Q?VimtVcTw2Lnz5YvWmS/eo+8UgeBHieR7MOMMMIHRv+foLZ6hfWe09LCeCquM?=
 =?us-ascii?Q?seOZZ21WiU13w3JgAPuC2OZcEOQ9v2k8QH0uhl+5bbuYF5Tw03cZqLqZ9Kq1?=
 =?us-ascii?Q?wei2Pg2x6mTpZSM9w5LKVYSXqX6T/rDtSrCO2GpITbqkyrjMiwhU5sHI1FCB?=
 =?us-ascii?Q?FgfdGNuwUSRLJshHoShPlbBRRBOrXw13/+XZfJrJczzOjIs2AkE9CouvBx9a?=
 =?us-ascii?Q?ECJ1rWZilUUlBFUBPH5ZFDb6PGdo0VSOpKx2Hh2QqP7SQS33C4Mz7fXqedGd?=
 =?us-ascii?Q?3dicMfsxSdHQcXy70UVmXkBsr79NZPFTRSRfUeLvZdmj/pfscX19rt6Rp9kv?=
 =?us-ascii?Q?SY9xWoYSHMd/R5xnZxsIaGIb/HgrW4dYaGbrFrgnW+i4EkNkn3JIrpQ=3D?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5088.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cad894da-c921-48de-c9c9-08db6cde0fd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 13:48:40.7054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1LRSiOLBH6VJBHIQ6dtkwzXaV0Ph/wrHsbZK3WB+WZ74zJLW+tmEY6yM617+rLl0pKxUgnAPSohFaDQlt5UrQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7020
X-Proofpoint-GUID: gKj2upY5utBiXmzFXtDpTYFOUq1tz8BM
X-Proofpoint-ORIG-GUID: gKj2upY5utBiXmzFXtDpTYFOUq1tz8BM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_08,2023-06-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 phishscore=0
 spamscore=0 impostorscore=0 malwarescore=0 mlxscore=0 adultscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140118
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Christian Marangi <ansuelsmth@gmail.com>
Date: Wed, Jun 14, 2023 at 03:16:08

> I'm not following the meaning of leak here. If it's intended as a memory
> leak then dma_conf is correctly freed in the 2 user of __stmmac_open.
>=20
> stmmac_init_phy also doesn't seems to use dma_conf. Am I missing
> something here?
>=20

Sorry, I should have been clearer: It's not leaking the dma_conf per-se but
the contents of it: The DMA descriptors. Since the memcpy() is only done af=
ter
init_phy(); if init_phy() fails, then stmmac will never free up the DMA des=
criptors.

Does it make sense?

Thanks,
Jose

