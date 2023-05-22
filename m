Return-Path: <netdev+bounces-4299-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0441F70BF43
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C82651C20A3A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94D0413AC4;
	Mon, 22 May 2023 13:10:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACCBBA53
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:10:09 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3554CD
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 06:10:07 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MBOIsS015838;
	Mon, 22 May 2023 06:09:59 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qpujnekk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 May 2023 06:09:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUiu4LGZKyvqf9GjP24eqvg1WVieTWxscbonsFgpGuX820m784oK4y2OevlDaRTRSziVMiK2zyInJFiJOJERzzfrNE1QXrIP7O72iKGqzCKmErd2NPjcejXi5y9HJ7Dm6k8jJmolr3R8bqUNAiiBSCFj7xoIjLMqQa0mKm+kiH04p4L3h9omLMDVLYv3xElJnxjkoT9XH0ouQp+tbdUGIivrBArk9hQ7wHjtpIqQtnGw1OQUTEB7J7K7/BJ8v3bLF4+jBm6kPJMHO5pDFqsRatSfqNREvqayuFE/hNH5+HjBUgzVo92PFsmVuv9cpuYvxUPyh+eHbO57n6IswvAhnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FiAw78erS2LJ9Cx5/iby9HaaE9hQDiq1ninA08YGvY=;
 b=oWyIGmFAPgwtvnRewKv3k8Vh59vdprVvaH215M8PmYbG03FZTyUc1zfTZGawk0s+bb16tZ32xZgR8egMCgNgrBPgZeN+m+BMD/hCyu8WmPPeVHACBLn/85nKKzzRZfPqscQ2j0gaiGxQ4tnoZsXKakmQ/99msM8hbhw2+MPUsBZf8QEAqAx0zPV6rZH93sL34T+B3MKtZHCWmWqn6F2HcVaE25Y9Kg7FlGO285U/Pi6REj328mGhvpRKfCWBf5uCGciZa5dVa2uzuTjm3lMJSQXM+PKmN4zqV8yLSnHmceWYntzPhDKO7bMXhKadu88vj+I8fjfC62GT8B5Z1lIzOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FiAw78erS2LJ9Cx5/iby9HaaE9hQDiq1ninA08YGvY=;
 b=M5v7B/BJY/yyuNRJDaSu0y7zbEskpS2v8dO4wsuceAaqXcntbi1LhrXnA4m2Q8hfJuPPu9dzfxAtsW70oXW/sgBadCTSXP0zjwNsm25OP6V+ChNVfba0IcLlMqZytgzIqlsXkhOG6s6imaPyHcksmG2Evpbr3GrNGhIfdL4ljV0=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by CO3PR18MB4941.namprd18.prod.outlook.com (2603:10b6:303:164::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 13:09:56 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::edc4:5d0d:f48b:a60a]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::edc4:5d0d:f48b:a60a%6]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 13:09:56 +0000
From: Manish Chopra <manishc@marvell.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior
	<aelior@marvell.com>, Alok Prasad <palok@marvell.com>,
        Sudarsana Reddy
 Kalluru <skalluru@marvell.com>,
        David Miller <davem@davemloft.net>
Subject: RE: [EXT] Re: [PATCH v4 net] qede: Fix scheduling while atomic
Thread-Topic: [EXT] Re: [PATCH v4 net] qede: Fix scheduling while atomic
Thread-Index: AQHZitPZXe63Uchez0muhA5ufK3F7q9mP3pA
Date: Mon, 22 May 2023 13:09:56 +0000
Message-ID: 
 <BY3PR18MB46126D0DCC780CC494F45220AB439@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20230518145214.570101-1-manishc@marvell.com>
 <20230519213040.0ff30813@kernel.org>
In-Reply-To: <20230519213040.0ff30813@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbWFuaXNoY1xh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWYwNjM2NjRlLWY4YTEtMTFlZC1iNmQ5LWQ4Zjg4?=
 =?us-ascii?Q?MzVmNjc2YVxhbWUtdGVzdFxmMDYzNjY0Zi1mOGExLTExZWQtYjZkOS1kOGY4?=
 =?us-ascii?Q?ODM1ZjY3NmFib2R5LnR4dCIgc3o9IjM0NzYiIHQ9IjEzMzI5MjM0NTkzNjA0?=
 =?us-ascii?Q?MTY0NyIgaD0icTAydUdJcUNJRXBHS2xpdmltSTV6ai9LcncwPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSHdRQUFD?=
 =?us-ascii?Q?djFzdXlyb3paQWJMRm1qc21vSFdVc3NXYU95YWdkWlFhQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQU1FQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFFQkFBQUE4QU1OOHdDQUFRQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcwQVh3QndBR2dBYndCdUFHVUFiZ0Ix?=
 =?us-ascii?Q?QUcwQVlnQmxBSElBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVB?=
 =?us-ascii?Q?Y3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhBWkFCaEFITUFhQUJmQUhZQU1BQXlB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdN?=
 =?us-ascii?Q?QWRRQnpBSFFBYndCdEFGOEFjd0J6QUc0QVh3QnJBR1VBZVFCM0FHOEFjZ0Jr?=
 =?us-ascii?Q?QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBB?=
 =?us-ascii?Q?WHdCekFITUFiZ0JmQUc0QWJ3QmtBR1VBYkFCcEFHMEFhUUIwQUdVQWNnQmZB?=
 =?us-ascii?Q?SFlBTUFBeUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCakFIVUFjd0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFj?=
 =?us-ascii?Q?d0J3QUdFQVl3QmxBRjhBZGdBd0FESUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?R1FBYkFCd0FGOEFjd0JyQUhrQWNBQmxBRjhBWXdCb0FHRUFkQUJmQUcwQVpR?=
 =?us-ascii?Q?QnpBSE1BWVFCbkFHVUFYd0IyQURBQU1nQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVpBQnNBSEFBWHdCekFH?=
 =?us-ascii?Q?d0FZUUJqQUdzQVh3QmpBR2dBWVFCMEFGOEFiUUJsQUhNQWN3QmhBR2NBWlFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZB?=
 =?us-ascii?Q?SFFBWlFCaEFHMEFjd0JmQUc4QWJnQmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFR?=
 =?us-ascii?Q?QnNBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFB?=
 =?us-ascii?Q?QUFBQUFBQUFnQUFBQUFBbmdBQUFHVUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FI?=
 =?us-ascii?Q?SUFaUUJ6QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFCd0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBYlFCaEFISUFkZ0JsQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4?=
 =?us-ascii?Q?QWJnQmhBRzBBWlFCekFGOEFZd0J2QUc0QVpnQnBBR1FBWlFCdUFIUUFhUUJo?=
 =?us-ascii?Q?QUd3QVh3QmhBR3dBYndCdUFHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dC?=
 =?us-ascii?Q?MkFHVUFiQUJmQUhBQWNnQnZBR29BWlFCakFIUUFYd0J1QUdFQWJRQmxBSE1B?=
 =?us-ascii?Q?WHdCeUFHVUFjd0IwQUhJQWFRQmpBSFFBWlFCa0FGOEFZUUJzQUc4QWJnQmxB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUcwQVlRQnlBSFlBWlFCc0FGOEFjQUJ5?=
 =?us-ascii?Q?QUc4QWFnQmxBR01BZEFCZkFHNEFZUUJ0QUdVQWN3QmZBSElBWlFCekFIUUFj?=
 =?us-ascii?Q?Z0JwQUdNQWRBQmxBR1FBWHdCb0FHVUFlQUJqQUc4QVpBQmxBSE1BQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFHRUFjZ0J0QUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refthree: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJ?=
 =?us-ascii?Q?QUFBQUFBSjRBQUFCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBWndCdkFHOEFad0Jz?=
 =?us-ascii?Q?QUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBRzBB?=
 =?us-ascii?Q?WVFCeUFIWUFaUUJzQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4QVl3QnZB?=
 =?us-ascii?Q?R1FBWlFCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0Fi?=
 =?us-ascii?Q?QUJmQUhBQWNnQnZBR29BWlFCakFIUUFYd0JqQUc4QVpBQmxBSE1BWHdCa0FH?=
 =?us-ascii?Q?a0FZd0IwQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJ0QUdFQWNnQjJBR1VBYkFCc0FGOEFjQUJ5QUc4QWFn?=
 =?us-ascii?Q?QmxBR01BZEFCZkFHNEFZUUJ0QUdVQWN3QmZBR01BYndCdUFHWUFhUUJrQUdV?=
 =?us-ascii?Q?QWJnQjBBR2tBWVFCc0FGOEFiUUJoQUhJQWRnQmxBR3dBYkFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?MEFZUUJ5QUhZQVpRQnNBR3dBWHdCd0FISUFid0JxQUdVQVl3QjBBRjhBYmdC?=
 =?us-ascii?Q?aEFHMEFaUUJ6QUY4QVl3QnZBRzRBWmdCcEFHUUFaUUJ1QUhRQWFRQmhBR3dB?=
 =?us-ascii?Q?WHdCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBWVFCdUFHUUFYd0J0QUdrQWNBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reffour: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VB?=
 =?us-ascii?Q?QUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSEFBY2dCdkFHb0FaUUJqQUhRQVh3?=
 =?us-ascii?Q?QnVBR0VBYlFCbEFITUFYd0JqQUc4QWJnQm1BR2tBWkFCbEFHNEFkQUJwQUdF?=
 =?us-ascii?Q?QWJBQmZBRzBBWVFCeUFIWUFaUUJzQUd3QVh3QnZBSElBWHdCaEFISUFiUUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dCMkFH?=
 =?us-ascii?Q?VUFiQUJzQUY4QWNBQnlBRzhBYWdCbEFHTUFkQUJmQUc0QVlRQnRBR1VBY3dC?=
 =?us-ascii?Q?ZkFHTUFid0J1QUdZQWFRQmtBR1VBYmdCMEFHa0FZUUJzQUY4QWJRQmhBSElB?=
 =?us-ascii?Q?ZGdCbEFHd0FiQUJmQUc4QWNnQmZBR2NBYndCdkFHY0FiQUJsQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUcwQVlRQnlBSFlBWlFCc0FHd0FYd0J3QUhJ?=
 =?us-ascii?Q?QWJ3QnFBR1VBWXdCMEFGOEFiZ0JoQUcwQVpRQnpBRjhBY2dCbEFITUFkQUJ5?=
 =?us-ascii?Q?QUdrQVl3QjBBR1VBWkFCZkFHMEFZUUJ5QUhZQVpRQnNBR3dBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFB?=
 =?us-ascii?Q?WHdCdUFHRUFiUUJsQUhNQVh3QnlBR1VBY3dCMEFISUFhUUJqQUhRQVpRQmtB?=
 =?us-ascii?Q?RjhBYlFCaEFISUFkZ0JsQUd3QWJBQmZBRzhBY2dCZkFHRUFjZ0J0QUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBRjhBZEFCbEFISUFiUUJwQUc0QWRRQnpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQW5nQUFBRzBBWVFCeUFIWUFaUUJzQUd3QVh3QjNB?=
 =?us-ascii?Q?RzhBY2dCa0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-reffive: 
 QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUE9Ii8+PC9tZXRhPg==
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4612:EE_|CO3PR18MB4941:EE_
x-ms-office365-filtering-correlation-id: 0ea96f1d-b943-4fe7-d453-08db5ac5d70a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 R0S02b5XZfd8quw/Qge3HpaKoP2Fkznkq5QEJ+u69W33++TWVs0TUIyH8/z2bHPLSOlvrQhSdmst7NW5QFS32A1uZrukrN31ddMv9aeAO3BqqAn/CyjddGPV/fSxMuyPTaA/WUW2YAQXxQMEAWWnO2QFHrNB2jxq72WzkSiQDfftSDXGmfehwpkt2uyNRbhceEvtl6lbzksoROTaEd8R7GFZhffCecvK01gxUmkwYwOWuJZH3m+0zQmT8NfvFvdvfTp/wXgHK00N9E1xrS6DvOgx8iWlhvXTBwKkpomD+VYmRU1tOXB9bXYrEf4A6d7deleJbjoOGe5/LqDpZCG46iajljfSnRnChafc1Nvp/TO2EQ+Yd0gCq1edlu3ExPzrg4RcM2wO91As7FrEupjhze4wBkrnDIC9rnEGmGQdZr7v/Nvy5qMrY3yoXm9wmMlmuJEW4ExHSleBH6M57r50gvGn6bAXN5yKzntxHceTCfFPMV7SbCsc4RZTKJxhHaaPEVXr50C3ptW6yPCiAtI6L26qkgZFCTkwEZrD4M8xJjUO2vqfllgHGRIhkQrg+0QMrYb+wX2gV84yI1BdQd2W44/FthlpnYDmJw5gb4EkKOZi/CpYFb1B//dsgstPhIpI
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(451199021)(478600001)(6506007)(53546011)(9686003)(316002)(54906003)(71200400001)(41300700001)(66946007)(76116006)(66556008)(66476007)(66446008)(64756008)(6916009)(4326008)(7696005)(8936002)(8676002)(52536014)(5660300002)(86362001)(55016003)(2906002)(83380400001)(33656002)(122000001)(38100700002)(38070700005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?zno91ZkzvXAjIOFbRA2EWQUfI4LZHNhbSjV48Snx50u68QIisQKCC7NBuSQz?=
 =?us-ascii?Q?Gqi4IQDTsGpvGIx45gGFt4DGESwGhB/NhjeTUiLly6nNpK6Z6j+Rd0Khkl8P?=
 =?us-ascii?Q?alBsVxvleIiliSnaJsqfMv4PhP2k9AefMhEpKE45OgCtntTSmqMNe+TaUx8Y?=
 =?us-ascii?Q?x+kxaCi5QB6LM3bZpRJynP1nDRbys1SK2HiEbRN6c/HFGe3BzPjN0GLVo2Cv?=
 =?us-ascii?Q?Z+P/oD5nTyGyA8qVfnwAH4MPgSyxWOibMFxDeJPuZyozdWa/fktdLvuoIiz9?=
 =?us-ascii?Q?zVidDE9KSH8DoK4X27/sxWuuB8XY4NMnVK8Gdg6c9fmoxEawUZf1V/Kf1IYG?=
 =?us-ascii?Q?qmBoOr1dEBdqa96byKA1Ab7M+N3SMIj3qUiXNNhZ/DAGzwbOGVfUqU3WPOTT?=
 =?us-ascii?Q?snuyMgIyV0OCuiB98utv8qrdvvvABLhCS+Aqulou5o7g5EoL1BUuM/05KRHn?=
 =?us-ascii?Q?CdOkZrKNTC/lirL7vMAZPLYMmV+cjPxKVqppVKHDGXK6MFVQDrvGC6huUWYj?=
 =?us-ascii?Q?yIA6nUqDhwv5RLwUDXCcRepFL6VFOdM7ZQh6GHSMEDxVYzeOFDO/nwAEIr5z?=
 =?us-ascii?Q?aJl8eYRAtiNE5zyo0eWwyian4cTvblyae3pktebq3cQi3EIN7eSEDGnv94KE?=
 =?us-ascii?Q?K6lO/hCjHyLXn8DOPRxDP8bWJNaatJjFpNAcAyK/aP2wf7O2dILozhwJeI4J?=
 =?us-ascii?Q?UAaNR7Kd3ec2UYgATrSwFC7DUlgKyx99jw4e57OkTxuPdBISG/U7Xn0Uk2Td?=
 =?us-ascii?Q?8/CNxVJHUf2epxPdwIaOKSZrwMgknb24A3hlpXGW4dG7ZDU01XZJ2u8uK5Sx?=
 =?us-ascii?Q?omh+ZfXOaTnd1nWHuuq8TbcrfcmJyubg86TQPhepC3XMlcgmhvMKA4iAvd21?=
 =?us-ascii?Q?zSLLNAK+OQwSctOJsTSffLEJUcj7U5PxtUE9T07drT8d4zR8K+PeZr4LZlJQ?=
 =?us-ascii?Q?opdesg6YoMBZyb1pPFoQxhp6L7BYi0sZFeImw5bhrfMQeUSo+sNHTfUc/po5?=
 =?us-ascii?Q?24JaYcdtZ5bGimjYqXqwj//+2j/wbtXHslj8v/uQqYSGgsyvbDnTsAzK0ALv?=
 =?us-ascii?Q?zA0f/cxtWabAmMrsF6zdAhoMZat5Zh1iyW/QkVi+CP0PJMTkUWn8k0hHyGoq?=
 =?us-ascii?Q?AsCdC/rKTrV2dg2N5Zqdk59fGW99LdVcTbZc3Sr7UAKbjcxk5BJiC4JJ3bYM?=
 =?us-ascii?Q?Z5INQgj0WP6WtdLlGTulMXsaMPnZ4H7bgfYDYXwxryeVoGkla+ZT2wVg99T6?=
 =?us-ascii?Q?Ywd1//MJAyKj6e+224Iqvx/6DOMo+J8M/TGj/pZWrvYmp9ddQxtl69Ua+TtD?=
 =?us-ascii?Q?B1V46dz0/Pv84tKDAc+9znSWcIXxU45D+Z236FwTA2vCYDpVIaNfuY7bOmvu?=
 =?us-ascii?Q?bfGN5DqKbAKUcIX9JD6PZ+iw+IuKWf1kgoyoR+10w4lOjKPiwS0OrGhS0dI+?=
 =?us-ascii?Q?GtI7sZJeh758ivLgKd+l6N5dEwn94B90jHY62/qXE+KH1KZNW7wUHPKGtf6h?=
 =?us-ascii?Q?pqq/llKQBoyD9BuAJyVfpbyyXhGdKbM1DVIFSrzvJ52QGcujN9PgShgsLM+f?=
 =?us-ascii?Q?PuPBBW0ZAG6Em9rTZSupkTuWWby/LMYlnT7Et24bI2wkfHfYqR9Jx8lVx3pB?=
 =?us-ascii?Q?kFLhgT0qaKeXGCVnIODGf4/86Hrp4CplR07/En13sgOU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ea96f1d-b943-4fe7-d453-08db5ac5d70a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 13:09:56.5777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KZcjfK+WLeOvuanUR6I+pCjZLET8cjD8zZ6D+Y/TEiZ3LJ1erOfdgGzXCvv/HJuJlASpbo9QSzPMBrfnJoxTbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR18MB4941
X-Proofpoint-ORIG-GUID: eftOK-GTCzz7QhP2-mg2kRXr81AUFv3V
X-Proofpoint-GUID: eftOK-GTCzz7QhP2-mg2kRXr81AUFv3V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-22_08,2023-05-22_03,2023-05-22_02
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, May 20, 2023 10:01 AM
> To: Manish Chopra <manishc@marvell.com>
> Cc: netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>; Alok Prasad
> <palok@marvell.com>; Sudarsana Reddy Kalluru <skalluru@marvell.com>;
> David Miller <davem@davemloft.net>
> Subject: [EXT] Re: [PATCH v4 net] qede: Fix scheduling while atomic
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Thu, 18 May 2023 20:22:14 +0530 Manish Chopra wrote:
> > Bonding module collects the statistics while holding the spinlock,
> > beneath that qede->qed driver statistics flow gets scheduled out due
> > to usleep_range() used in PTT acquire logic which results into below
> > bug and traces -
>=20
> >  	struct qede_dump_info		dump_info;
> > +	struct delayed_work		periodic_task;
> > +	unsigned long			stats_coal_interval;
> > +	u32				stats_coal_ticks;
>=20
> It's a bit odd to make _interval ulong and ticks u32 when _ticks will obv=
iously
> be much larger..
>=20
> Also - s/ticks/usecs/ ? I'd have guessed interval =3D=3D usecs, ticks =3D=
=3D jiffies
> without reading the code, and the inverse is true.

I will rename to avoid the confusion (ticks to usecs and interval to ticks)=
.

>=20
> > +	spinlock_t			stats_lock; /* lock for vport stats
> access */
> >  };
>=20
> > +	if (edev->stats_coal_ticks !=3D coal->stats_block_coalesce_usecs) {
> > +		u32 stats_coal_ticks, prev_stats_coal_ticks;
> > +
> > +		stats_coal_ticks =3D coal->stats_block_coalesce_usecs;
> > +		prev_stats_coal_ticks =3D edev->stats_coal_ticks;
> > +
> > +		/* zero coal ticks to disable periodic stats */
> > +		if (stats_coal_ticks)
> > +			stats_coal_ticks =3D clamp_t(u32, stats_coal_ticks,
> > +
> QEDE_MIN_STATS_COAL_TICKS,
> > +
> QEDE_MAX_STATS_COAL_TICKS);
> > +
> > +		stats_coal_ticks =3D rounddown(stats_coal_ticks,
> QEDE_MIN_STATS_COAL_TICKS);
> > +		edev->stats_coal_ticks =3D stats_coal_ticks;
>=20
> Why round down the usecs?  Don't you want to return to the user on get
> exactly what set specified?  Otherwise I wouldn't bother saving the usecs=
 at
> all, just convert back from jiffies.

Maybe I should not put this and allow user to configure any usecs value (by=
 not limiting to any min/max)
as long as it results into different/unique ticks/jiffies. But I should sti=
ll save usecs rather than ticks/jiffies
(or preferably both in order to avoid runtime conversion at the time of sch=
eduling the work every time)
because on get jiffies_to_usecs() could be misleading, for example if user =
configured 10 usecs which will
result into single jiffy and on getting it back it will report 1000 usecs w=
hen converting back using jiffies_to_usecs()
which is still not the same as what user configured.

>=20
> > +		if (edev->stats_coal_ticks) {
> > +			edev->stats_coal_interval =3D (unsigned long)edev-
> >stats_coal_ticks *
> > +							HZ / 1000000;
>=20
> usecs_to_jiffies()
>=20
> > +			if (prev_stats_coal_ticks =3D=3D 0)
> > +				schedule_delayed_work(&edev-
> >periodic_task, 0);
> > +		}
> > +
> > +		DP_VERBOSE(edev, QED_MSG_DEBUG, "stats coal
> interval=3D%lu jiffies\n",
> > +			   edev->stats_coal_interval);
> > +	}
> > +
> >  	if (!netif_running(dev)) {
> >  		DP_INFO(edev, "Interface is down\n");
> >  		return -EINVAL;
> --
> pw-bot: cr

