Return-Path: <netdev+bounces-1481-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C0AA6FDEFA
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:45:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6269028148D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:45:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1503E12B8F;
	Wed, 10 May 2023 13:45:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FA520B42
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:45:52 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7FFD2D3;
	Wed, 10 May 2023 06:45:10 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34A70E7E032743;
	Wed, 10 May 2023 06:44:12 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qg6gesbsu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 06:44:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INAYQ0KFzjJtS/u/swZ06xUo7Z2vpdkWiGDqxwO7fcG2jbF4g9DsJPrK5q5hlNHXOo83IknXcr5JS+F8HjDBK5vmKYWrTWhCUD835bugCFnYDqKPPSOjYCA7J3SKyecWr0sawdw2FK7HAEphYwlEKBIYsdorDDMfowi9HS0bhPWp8pnkvFCUNs4Ycs1CTGim3A+H8viQNCPC87IOxEJE64pSJwHk2ZeieHSZSsMxdlmq8cDp6nO+/jK5ZbLz4l1rOBXvkWKXVd2ONM1DubJ5/3lHKaK+29CVJsqjAhJFbcx3FtmnSAvwdxJTAVnDKGeA5EP91CivvHXSifl1aVcWxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJEAjApJVnx7IrccQwl/bi+tt5KkeW8XDxDRdqh097M=;
 b=aAofM6vhtcxcMV4SO2BBtpl1cgatWCG2igK8HU+72cKQsf5lQrwz+eTX8tIxI/y6ZP1nDfVzV4e+nzOn5xXYNAJNU8Aqw0LUfHz59jeghXHWf5s+MaRtGvXAg75QduGwlrcniMdUVPbZulDGucgQIR6LdEtLrN8DAjNm4CfcKRTtwVyYvhgbDS/cpWgLAPhMMM6XEXN0UmmMJ1nfZ8j9T2ImEnmVexeTJ2WqCfzoGddfMgOtJ1hF5TufN3J/DVPIX2OOMMDwqjeCJFDRM76EQ4zn9Oe532vNICJIt4eeT8R0ImpBXsBmWBOLeLLW+zXTEsuxcfUugFACkkIgmENiuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJEAjApJVnx7IrccQwl/bi+tt5KkeW8XDxDRdqh097M=;
 b=uJYf3qD1WYrE4u4UIGHnhWSbOI++d/X4ajd9+eHcs/JTes6C20MEALILEEU+2D/eI45Eq9R7vJKrSW2ysJFXGES2JuSCvVtZOgOkc5Fq4SCWKvsomgvWscTTuXEA8kWAnlgvRa9ORfRH54+xz97zPWqdsrKMr97yyJsXzqqqPjQ=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by SN7PR18MB4096.namprd18.prod.outlook.com (2603:10b6:806:103::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 13:44:09 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88%6]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 13:44:09 +0000
From: Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com"
	<edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org"
	<robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org"
	<krzysztof.kozlowski+dt@linaro.org>
CC: "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "michal.simek@amd.com"
	<michal.simek@amd.com>,
        "radhey.shyam.pandey@amd.com"
	<radhey.shyam.pandey@amd.com>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "anirudha.sarangi@amd.com"
	<anirudha.sarangi@amd.com>,
        "harini.katakam@amd.com"
	<harini.katakam@amd.com>,
        "git@amd.com" <git@amd.com>
Subject: RE: [EXT] [PATCH net-next V3 3/3] net: axienet: Introduce dmaengine
 support
Thread-Topic: [EXT] [PATCH net-next V3 3/3] net: axienet: Introduce dmaengine
 support
Thread-Index: AQHZgyqrpiKAw2cjIk+dFMphWLQeKK9TgeaQ
Date: Wed, 10 May 2023 13:44:09 +0000
Message-ID: 
 <CO1PR18MB46668BFF80E186AA255D03F5A1779@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
 <20230510085031.1116327-4-sarath.babu.naidu.gaddam@amd.com>
In-Reply-To: <20230510085031.1116327-4-sarath.babu.naidu.gaddam@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2JoYXR0YVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWJhYjc0MDYzLWVmMzgtMTFlZC05YzVjLWJjZjE3?=
 =?us-ascii?Q?MTIxOGI3YVxhbWUtdGVzdFxiYWI3NDA2NC1lZjM4LTExZWQtOWM1Yy1iY2Yx?=
 =?us-ascii?Q?NzEyMThiN2Fib2R5LnR4dCIgc3o9IjE2NTAxIiB0PSIxMzMyODE5OTg0NjQ3?=
 =?us-ascii?Q?MzQ4NTUiIGg9IllNNFc1YkZnZGNER05idDZUVkZFZHdRd0k2VT0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUdZTkFB?=
 =?us-ascii?Q?Q0gxbkY5UllQWkFlTEJhZU1VWkRVSTRzRnA0eFJrTlFnVkFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUQyREFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRRUJBQUFBYjNidXl3Q0FBUUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFa?=
 =?us-ascii?Q?QUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4QWNB?=
 =?us-ascii?Q?QmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VBYmdC?=
 =?us-ascii?Q?MUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJqQUhV?=
 =?us-ascii?Q?QWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFNQUF5?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?TUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhBY2dC?=
 =?us-ascii?Q?a0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcw?=
 =?us-ascii?Q?QVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFjZ0Jm?=
 =?us-ascii?Q?QUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFB?=
 =?us-ascii?Q?QUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhB?=
 =?us-ascii?Q?Y3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FB?=
 =?us-ascii?Q?QUdRQWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFHMEFa?=
 =?us-ascii?Q?UUJ6QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3QnpB?=
 =?us-ascii?Q?R3dBWVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdjQVpR?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0FjQUJm?=
 =?us-ascii?Q?QUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFHWUFh?=
 =?us-ascii?Q?UUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpBQmtB?=
 =?us-ascii?Q?SElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBRlFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
 =?us-ascii?Q?QUNlQUFBQWJRQmhBSElBZGdCbEFHd0FYd0J3QUhJQWJ3QnFBR1VBWXdCMEFG?=
 =?us-ascii?Q?OEFiZ0JoQUcwQVpRQnpBRjhBY2dCbEFITUFkQUJ5QUdrQVl3QjBBR1VBWkFC?=
 =?us-ascii?Q?ZkFHRUFiQUJ2QUc0QVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdFQWNn?=
 =?us-ascii?Q?QjJBR1VBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFBWHdCdUFHRUFiUUJsQUhN?=
 =?us-ascii?Q?QVh3QnlBR1VBY3dCMEFISUFhUUJqQUhRQVpRQmtBRjhBYUFCbEFIZ0FZd0J2?=
 =?us-ascii?Q?QUdRQVpRQnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHMEFZUUJ5QUhZQVpRQnNBR3dBWHdC?=
 =?us-ascii?Q?aEFISUFiUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSEFBY2dCdkFHb0FaUUJq?=
 =?us-ascii?Q?QUhRQVh3QmpBRzhBWkFCbEFITUFBQUFBQUFB?=
x-dg-refthree: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFB?=
 =?us-ascii?Q?SUFBQUFBQUo0QUFBQnRBR0VBY2dCMkFHVUFiQUJzQUY4QWNBQnlBRzhBYWdC?=
 =?us-ascii?Q?bEFHTUFkQUJmQUdNQWJ3QmtBR1VBY3dCZkFHUUFhUUJqQUhRQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUcw?=
 =?us-ascii?Q?QVlRQnlBSFlBWlFCc0FHd0FYd0J3QUhJQWJ3QnFBR1VBWXdCMEFGOEFiZ0Jo?=
 =?us-ascii?Q?QUcwQVpRQnpBRjhBWXdCdkFHNEFaZ0JwQUdRQVpRQnVBSFFBYVFCaEFHd0FY?=
 =?us-ascii?Q?d0J0QUdFQWNnQjJBR1VBYkFCc0FGOEFZUUJ1QUdRQVh3QnRBR2tBY0FBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dB?=
 =?us-ascii?Q?YkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFBWHdCdUFHRUFiUUJsQUhNQVh3QnlB?=
 =?us-ascii?Q?R1VBY3dCMEFISUFhUUJqQUhRQVpRQmtBRjhBYlFCaEFISUFkZ0JsQUd3QWJB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBY0FCeUFHOEFh?=
 =?us-ascii?Q?Z0JsQUdNQWRBQmZBRzRBWVFCdEFHVUFjd0JmQUhJQVpRQnpBSFFBY2dCcEFH?=
 =?us-ascii?Q?TUFkQUJsQUdRQVh3QnRBR0VBY2dCMkFHVUFiQUJzQUY4QWJ3QnlBRjhBWVFC?=
 =?us-ascii?Q?eUFHMEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?RzBBWVFCeUFIWUFaUUJzQUd3QVh3QjBBR1VBY2dCdEFHa0FiZ0IxQUhNQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reffour: 
 QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhjQWJ3QnlBR1FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFBPT0iLz48L21ldGE+
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR18MB4666:EE_|SN7PR18MB4096:EE_
x-ms-office365-filtering-correlation-id: ca43eb8c-daef-49a4-7ffb-08db515ca18d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 wpA9JAzeenVvatg174+Zw6BNYCw89fk/agj68F+10Qmdcyl3KMslihpk3UWqjHVZVlsUURQMKEWnh+zhysV8ZH51jvt40/zaWrBUUguHw5aFZz1Da9/g0cCpL3MHe2iIulDz3StCPfLrYZMzBvySodS7U0ayV1NQeqwpM/tEzShj5jrH0K5y+UXuJ0QIXeW+qI0iEdpjqqnP/flefKDNcoUPlik0mxC7XsVLjiF1gTHlQw7rmzqLlEiKnmYsI/9BzBPQ53LqLRXW+uo6GgSKIJgcPo2K6LaF5QCWuAAHdgseLSLJl2sDIP5s+sCGw//vt/ym5bl/TdKh2Z4pW4iAt+54ZTht1my7ZMZus6FGpv1uI2SewRBmckWgBnvmNgRQYufRJlFv9puhuu45gV67EorymxA9LGOnJZcIMyMq+AF0oqGgmb85AwO0fJhqXhS/MokQH01L+VttpJKJETMjUm68xLGfovp2Jye751gQK+uVLIs9/ZyobGuoz23DRI6P0uhyERRqSWqBlIiMKFGvfA4E3sd1kBsNCc5FseFtxXfc224+7mkaDr5dno1ef4QPKsWvFWiHCy4hgraOZMiq1l9A8cRz2PTIqfuR8y2zL/0=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199021)(66946007)(66556008)(66476007)(76116006)(66446008)(83380400001)(9686003)(33656002)(110136005)(86362001)(38070700005)(38100700002)(54906003)(6506007)(122000001)(7696005)(966005)(186003)(478600001)(71200400001)(55016003)(2906002)(52536014)(30864003)(7416002)(8936002)(8676002)(316002)(64756008)(4326008)(41300700001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?54I2f5DY2XLk3IrXjRnW1U1vT3ftmHN28wf4GYlePxyWckSLA/WtKbOuN65l?=
 =?us-ascii?Q?hWrNbStqm4Wu+XitkdvW5E62c/pnkaSesYSx8Wc4vFjjfDp7JHr+RCSDIXry?=
 =?us-ascii?Q?Ic0/siThXvvZiFyHeQaPniNUC9ZDAKswLCMraB4PT/TzwiNAFVzOfBZwJ9or?=
 =?us-ascii?Q?F91ki0laTBasp26XYawyr27iweT+BFkdlQhOwwvriRAmj42qkuTr23pMYkhw?=
 =?us-ascii?Q?g2HjwryjVwUeY7xgMsFUy6toWZzIc/P15oQ/vN3CuVdc+lxTAiyF3Ouz1r+g?=
 =?us-ascii?Q?27yXre+vjWsgot2344pUYPARNdiJeXuSnaCeSZ+33ffdKF9yK563BvSfvllL?=
 =?us-ascii?Q?1+SXq6WBQsUwywZB+DUbj+f3KxBKpJ/o6thm2pkdq9ypFi6+Vc5wS8FuNpUj?=
 =?us-ascii?Q?LcYGN8e6aoiblleVYWXtSooTKn6OTZRhMeYFBypoKa1IdnflF+WiyD1/eYpq?=
 =?us-ascii?Q?9kPmtQWGOGCTXUnAN647wRHzeQg3DehAvgW5mEl1OqG5P6GEuDWAQQ+qR64M?=
 =?us-ascii?Q?mtg7XyTrh9D5qfsSIGLqlt4YnXOx9OdTZWxr6wquCeQVauSEo1ID57k9V461?=
 =?us-ascii?Q?zAdZyF51Og91E7UPatcjQ0y3cyNND8FMG2Ax4L/MNl0gMcJGJSmiibNsWrFR?=
 =?us-ascii?Q?ec+faIVlaAjnq4PB/L00Ct3aqIfZaof0iAevik5XeH8YoPpj32Fbp20ojNQB?=
 =?us-ascii?Q?zr3i8luuAPzcZl5QPUNtVhqZKzlUZ6kNDlWsxMTfTp2irtoYUGR3ka+7J8dL?=
 =?us-ascii?Q?gX96uXdGK8UkWTvkFrWMEBiUaw8gr02taDMz7G8NMYyu2kh9nfZwrQIIajeA?=
 =?us-ascii?Q?nNJ8kiTD3vJvyvS89p63cp18w4OAecOgLwrwTkbl2jFBCV13XBUkb/F/Pgp/?=
 =?us-ascii?Q?tR0HU7GowCwZh6QuMA6QBSD8CMOyuvifRuG1PVXBXGLCo2uf+RTP/LG5C7Qj?=
 =?us-ascii?Q?k9JhQwUNcn+GwZwyiuYbKdy3sQuZdRC/oJydKWx7zjiSOeqTOiXAwCVLGgs/?=
 =?us-ascii?Q?NruqjD7MTz0dAtLYQbXSIJuOBpJUPBfQzzxNjj7AEsyTNoBxY7O89Koxy10X?=
 =?us-ascii?Q?PPejCSKEYr8ilzpVxb/RT5w5elWQxJnbDpOCy0xuYe3b0mssSEViTefyqJOL?=
 =?us-ascii?Q?T0suUFQIBNlOB7LQVgYVH4U9qiWhYn4fS+MTpKLWavzRomZIVrfXDJENeLrE?=
 =?us-ascii?Q?3oTVTRyOihVF2b6+e7uHjfToC0JVvPCKBvWd7V8tfZBS9kxw0ItnRZQ/uFnF?=
 =?us-ascii?Q?VsjlK2l6/b7LZxLoMk536FlMCFRjXsXGgetXaMocMaWWJf63ePLtTfP/4iTh?=
 =?us-ascii?Q?SJ3OSvrXnyxvykQzdA+s9qMo5dLp4Urb0IiYa4BHetGxiBnW6uU0TaGDjkTC?=
 =?us-ascii?Q?wzTGlGaxonjZ3hdN+Cdmpv7yoQ8yo2Iz9m8KHmZyUhvl6sM2UVkGIypO1fEF?=
 =?us-ascii?Q?FJzqUUgKW0xB+N2Tn3AOTgMtOvnaj7whIzc0f7fV4Sm9r5RzeGlxkBgm/e/L?=
 =?us-ascii?Q?bB10aqa8AxleFwTEPQhQ3My/eE6gB0+f1VEEGwfV/KSxqmZW6PFQ5BZv7A?=
 =?us-ascii?Q?=3D=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca43eb8c-daef-49a4-7ffb-08db515ca18d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 13:44:09.1763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WfNvoqgADeAWQuCFv/zRabSDcFEDPgDcC1hRxZIqgN3PJsltlW/XTCeW7ZYRZqWsP41HlEq9AJLAB3/OJELO/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR18MB4096
X-Proofpoint-GUID: 7C-2mqpRlOGHZouINq_DjDPVmafjbX-9
X-Proofpoint-ORIG-GUID: 7C-2mqpRlOGHZouINq_DjDPVmafjbX-9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

>-----Original Message-----
>From: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
>Sent: Wednesday, May 10, 2023 2:21 PM
>To: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
>pabeni@redhat.com; robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org
>Cc: linux@armlinux.org.uk; michal.simek@amd.com;
>radhey.shyam.pandey@amd.com; netdev@vger.kernel.org;
>devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
>kernel@vger.kernel.org; anirudha.sarangi@amd.com;
>harini.katakam@amd.com; sarath.babu.naidu.gaddam@amd.com;
>git@amd.com
>Subject: [PATCH net-next V3 3/3] net: axienet: Introduce dmaengine
>support
>
>Add dmaengine framework to communicate with the xilinx DMAengine
>driver(AXIDMA).
>
>Axi ethernet driver uses separate channels for transmit and receive.
>Add support for these channels to handle TX and RX with skb and
>appropriate callbacks. Also add axi ethernet core interrupt for
>dmaengine framework support.
>
>The dmaengine framework was extended for metadata API support during the
>axidma RFC[1] discussion. However it still needs further enhancements to
>make it well suited for ethernet usecases. The ethernet features i.e
>ethtool set/get of DMA IP properties, ndo_poll_controller, trigger
>reset of DMA IP from ethernet are not supported (mentioned in TODO)
>and it requires follow-up discussion and dma framework enhancement.
>
>[1]: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
>3A__lore.kernel.org_lkml_1522665546-2D10035-2D1-2Dgit-2Dsend-2Demail-
>2D&d=3DDwIDAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DwYboOaw70DU5hRM5HDwOR
>Jx_MfD-hXXKii2eobNikgU&m=3DqvFFGXjULUP3IPFOil5aKySdkumrp8V0TYK4kQ-
>yzsWPmRolFaQvfKMhaR11_dZv&s=3DbrEWb1Til18VCodb-H4tST0HOBXKIJtL-
>2ztGmMZz_8&e=3D
>radheys@xilinx.com
>
>Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>Signed-off-by: Sarath Babu Naidu Gaddam
><sarath.babu.naidu.gaddam@amd.com>
>---
>Performance numbers(Mbps):
>
>              | TCP | UDP |
>         -----------------
>         | Tx | 920 | 800 |
>         -----------------
>         | Rx | 620 | 910 |
>
>Changes in V3:
>1) New patch for dmaengine framework support.
>---
> drivers/net/ethernet/xilinx/xilinx_axienet.h  |   6 +
> .../net/ethernet/xilinx/xilinx_axienet_main.c | 331 +++++++++++++++++-
> 2 files changed, 335 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h
>b/drivers/net/ethernet/xilinx/xilinx_axienet.h
>index 10917d997d27..fbe00c5390d5 100644
>--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
>+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
>@@ -436,6 +436,9 @@ struct axidma_bd {
>  * @coalesce_count_tx:	Store the irq coalesce on TX side.
>  * @coalesce_usec_tx:	IRQ coalesce delay for TX
>  * @has_dmas:	flag to check dmaengine framework usage.
>+ * @tx_chan:	TX DMA channel.
>+ * @rx_chan:	RX DMA channel.
>+ * @skb_cache:	Custom skb slab allocator
>  */
> struct axienet_local {
> 	struct net_device *ndev;
>@@ -501,6 +504,9 @@ struct axienet_local {
> 	u32 coalesce_count_tx;
> 	u32 coalesce_usec_tx;
> 	u8  has_dmas;
>+	struct dma_chan *tx_chan;
>+	struct dma_chan *rx_chan;
>+	struct kmem_cache *skb_cache;
> };
>
> /**
>diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
>b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
>index 8678fc09245a..662c77ff0e99 100644
>--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
>+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
>@@ -37,6 +37,9 @@
> #include <linux/phy.h>
> #include <linux/mii.h>
> #include <linux/ethtool.h>
>+#include <linux/dmaengine.h>
>+#include <linux/dma-mapping.h>
>+#include <linux/dma/xilinx_dma.h>
>
> #include "xilinx_axienet.h"
>
>@@ -46,6 +49,9 @@
> #define TX_BD_NUM_MIN			(MAX_SKB_FRAGS + 1)
> #define TX_BD_NUM_MAX			4096
> #define RX_BD_NUM_MAX			4096
>+#define DMA_NUM_APP_WORDS		5
>+#define LEN_APP				4
>+#define RX_BUF_NUM_DEFAULT		128
>
> /* Must be shorter than length of ethtool_drvinfo.driver field to fit */
> #define DRIVER_NAME		"xaxienet"
>@@ -56,6 +62,16 @@
>
> #define AXIENET_USE_DMA(lp) ((lp)->has_dmas)
>
>+struct axi_skbuff {
>+	struct scatterlist sgl[MAX_SKB_FRAGS + 1];
>+	struct dma_async_tx_descriptor *desc;
>+	dma_addr_t dma_address;
>+	struct sk_buff *skb;
>+	int sg_len;
>+} __packed;
>+
>+static int axienet_rx_submit_desc(struct net_device *ndev);
>+
> /* Match table for of_platform binding */
> static const struct of_device_id axienet_of_match[] =3D {
> 	{ .compatible =3D "xlnx,axi-ethernet-1.00.a", },
>@@ -728,6 +744,108 @@ static inline int axienet_check_tx_bd_space(struct
>axienet_local *lp,
> 	return 0;
> }
>
>+/**
>+ * axienet_dma_tx_cb - DMA engine callback for TX channel.
>+ * @data:       Pointer to the axi_skbuff structure
>+ * @result:     error reporting through dmaengine_result.
>+ * This function is called by dmaengine driver for TX channel to notify
>+ * that the transmit is done.
>+ */
>+static void axienet_dma_tx_cb(void *data, const struct dmaengine_result
>*result)
>+{
>+	struct axi_skbuff *axi_skb =3D data;
>+
>+	struct net_device *netdev =3D axi_skb->skb->dev;
>+	struct axienet_local *lp =3D netdev_priv(netdev);
>+
>+	u64_stats_update_begin(&lp->tx_stat_sync);
>+	u64_stats_add(&lp->tx_bytes, axi_skb->skb->len);
>+	u64_stats_add(&lp->tx_packets, 1);
>+	u64_stats_update_end(&lp->tx_stat_sync);
>+
>+	dma_unmap_sg(lp->dev, axi_skb->sgl, axi_skb->sg_len,
>DMA_MEM_TO_DEV);
>+	dev_kfree_skb_any(axi_skb->skb);
>+	kmem_cache_free(lp->skb_cache, axi_skb);
>+}
>+
>+/**
>+ * axienet_start_xmit_dmaengine - Starts the transmission.
>+ * @skb:        sk_buff pointer that contains data to be Txed.
>+ * @ndev:       Pointer to net_device structure.
>+ *
>+ * Return: NETDEV_TX_OK, on success
>+ *          NETDEV_TX_BUSY, if any memory failure or SG error.
>+ *
>+ * This function is invoked from xmit to initiate transmission. The
>+ * function sets the skbs , call back API, SG etc.
>+ * Additionally if checksum offloading is supported,
>+ * it populates AXI Stream Control fields with appropriate values.
>+ */
>+static netdev_tx_t
>+axienet_start_xmit_dmaengine(struct sk_buff *skb, struct net_device *ndev=
)
>+{
>+	struct dma_async_tx_descriptor *dma_tx_desc =3D NULL;
>+	struct axienet_local *lp =3D netdev_priv(ndev);
>+	u32 app[DMA_NUM_APP_WORDS] =3D {0};
>+	struct axi_skbuff *axi_skb;
>+	u32 csum_start_off;
>+	u32 csum_index_off;
>+	int sg_len;
>+	int ret;
>+
>+	sg_len =3D skb_shinfo(skb)->nr_frags + 1;
>+	axi_skb =3D kmem_cache_zalloc(lp->skb_cache, GFP_KERNEL);
>+	if (!axi_skb)
>+		return NETDEV_TX_BUSY;
>+
>+	sg_init_table(axi_skb->sgl, sg_len);
>+	ret =3D skb_to_sgvec(skb, axi_skb->sgl, 0, skb->len);
>+	if (unlikely(ret < 0))
>+		goto xmit_error_skb_sgvec;
>+
>+	ret =3D dma_map_sg(lp->dev, axi_skb->sgl, sg_len, DMA_TO_DEVICE);
>+	if (ret =3D=3D 0)
>+		goto xmit_error_skb_sgvec;
>+
>+	/*Fill up app fields for checksum */
>+	if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL) {
>+		if (lp->features & XAE_FEATURE_FULL_TX_CSUM) {
>+			/* Tx Full Checksum Offload Enabled */
>+			app[0] |=3D 2;
>+		} else if (lp->features & XAE_FEATURE_PARTIAL_RX_CSUM) {
>+			csum_start_off =3D skb_transport_offset(skb);
>+			csum_index_off =3D csum_start_off + skb->csum_offset;
>+			/* Tx Partial Checksum Offload Enabled */
>+			app[0] |=3D 1;
>+			app[1] =3D (csum_start_off << 16) | csum_index_off;
>+		}
>+	} else if (skb->ip_summed =3D=3D CHECKSUM_UNNECESSARY) {
>+		app[0] |=3D 2; /* Tx Full Checksum Offload Enabled */
>+	}
>+
>+	dma_tx_desc =3D lp->tx_chan->device->device_prep_slave_sg(lp->tx_chan,
>axi_skb->sgl,
>+			sg_len, DMA_MEM_TO_DEV,
>+			DMA_PREP_INTERRUPT, (void *)app);
>+
>+	if (!dma_tx_desc)
>+		goto xmit_error_prep;
>+
>+	axi_skb->skb =3D skb;
>+	axi_skb->sg_len =3D sg_len;
>+	dma_tx_desc->callback_param =3D  axi_skb;
>+	dma_tx_desc->callback_result =3D axienet_dma_tx_cb;
>+	dmaengine_submit(dma_tx_desc);
>+	dma_async_issue_pending(lp->tx_chan);
>+
>+	return NETDEV_TX_OK;
>+
>+xmit_error_prep:
>+	dma_unmap_sg(lp->dev, axi_skb->sgl, sg_len, DMA_TO_DEVICE);
>+xmit_error_skb_sgvec:
>+	kmem_cache_free(lp->skb_cache, axi_skb);
>+	return NETDEV_TX_BUSY;
>+}
>+
> /**
>  * axienet_tx_poll - Invoked once a transmit is completed by the
>  * Axi DMA Tx channel.
>@@ -912,7 +1030,42 @@ axienet_start_xmit(struct sk_buff *skb, struct
>net_device *ndev)
> 	if (!AXIENET_USE_DMA(lp))
> 		return axienet_start_xmit_legacy(skb, ndev);
> 	else
>-		return NETDEV_TX_BUSY;
>+		return axienet_start_xmit_dmaengine(skb, ndev);

You can avoid this if else by
 if (AXIENET_USE_DMA(lp))
         return axienet_start_xmit_dmaengine(skb, ndev);

and no need of defining axienet_start_xmit_legacy function in patch 2/3.
_legacy may not be correct since you support both in-built dma or with dma =
engine just by
turning on/off dt properties. Also does this driver roll back to using in-b=
uilt dma if DMA_ENGINE
is not compiled in?=20

>+}
>+
>+/**
>+ * axienet_dma_rx_cb - DMA engine callback for RX channel.
>+ * @data:       Pointer to the axi_skbuff structure
>+ * @result:     error reporting through dmaengine_result.
>+ * This function is called by dmaengine driver for RX channel to notify
>+ * that the packet is received.
>+ */
>+static void axienet_dma_rx_cb(void *data, const struct dmaengine_result
>*result)
>+{
>+	struct axi_skbuff *axi_skb =3D data;
>+	struct sk_buff *skb =3D axi_skb->skb;
>+	struct net_device *netdev =3D skb->dev;
>+	struct axienet_local *lp =3D netdev_priv(netdev);
>+	size_t meta_len, meta_max_len, rx_len;
>+	u32 *app;
>+
>+	app  =3D dmaengine_desc_get_metadata_ptr(axi_skb->desc, &meta_len,
>&meta_max_len);
>+	dma_unmap_single(lp->dev, axi_skb->dma_address, lp->max_frm_size,
>+			 DMA_FROM_DEVICE);
>+	/* TODO: Derive app word index programmatically */
>+	rx_len =3D (app[LEN_APP] & 0xFFFF);
>+	skb_put(skb, rx_len);
>+	skb->protocol =3D eth_type_trans(skb, netdev);
>+	skb->ip_summed =3D CHECKSUM_NONE;
>+
>+	netif_rx(skb);
>+	kmem_cache_free(lp->skb_cache, axi_skb);
>+	u64_stats_update_begin(&lp->rx_stat_sync);
>+	u64_stats_add(&lp->rx_packets, 1);
>+	u64_stats_add(&lp->rx_bytes, rx_len);
>+	u64_stats_update_end(&lp->rx_stat_sync);
>+	axienet_rx_submit_desc(netdev);
>+	dma_async_issue_pending(lp->rx_chan);
> }
>
> /**
>@@ -1148,6 +1301,134 @@ static irqreturn_t axienet_eth_irq(int irq, void
>*_ndev)
>
> static void axienet_dma_err_handler(struct work_struct *work);
>
>+/**
>+ * axienet_rx_submit_desc - Submit the descriptors with required data
>+ * like call backup API, skb buffer.. etc to dmaengine.
>+ *
>+ * @ndev:	net_device pointer
>+ *
>+ *Return: 0, on success.
>+ *          non-zero error value on failure
>+ */
>+static int axienet_rx_submit_desc(struct net_device *ndev)
>+{
>+	struct dma_async_tx_descriptor *dma_rx_desc =3D NULL;
>+	struct axienet_local *lp =3D netdev_priv(ndev);
>+	struct axi_skbuff *axi_skb;
>+	struct sk_buff *skb;
>+	dma_addr_t addr;
>+	int ret;
>+
>+	axi_skb =3D kmem_cache_alloc(lp->skb_cache, GFP_KERNEL);
>+
>+	if (!axi_skb)
>+		return -ENOMEM;
>+	skb =3D netdev_alloc_skb(ndev, lp->max_frm_size);
>+	if (!skb) {
>+		ret =3D -ENOMEM;
>+		goto rx_bd_init_skb;
>+	}
>+
>+	sg_init_table(axi_skb->sgl, 1);
>+	addr =3D dma_map_single(lp->dev, skb->data, lp->max_frm_size,
>DMA_FROM_DEVICE);
>+	sg_dma_address(axi_skb->sgl) =3D addr;
>+	sg_dma_len(axi_skb->sgl) =3D lp->max_frm_size;
>+	dma_rx_desc =3D dmaengine_prep_slave_sg(lp->rx_chan, axi_skb->sgl,
>+					      1, DMA_DEV_TO_MEM,
>+					      DMA_PREP_INTERRUPT);
>+	if (!dma_rx_desc) {
>+		ret =3D -EINVAL;
>+		goto rx_bd_init_prep_sg;
>+	}
>+
>+	axi_skb->skb =3D skb;
>+	axi_skb->dma_address =3D sg_dma_address(axi_skb->sgl);
>+	axi_skb->desc =3D dma_rx_desc;
>+	dma_rx_desc->callback_param =3D  axi_skb;
>+	dma_rx_desc->callback_result =3D axienet_dma_rx_cb;
>+	dmaengine_submit(dma_rx_desc);
>+
>+	return 0;
>+
>+rx_bd_init_prep_sg:
>+	dma_unmap_single(lp->dev, addr, lp->max_frm_size,
>DMA_FROM_DEVICE);
>+	dev_kfree_skb(skb);
>+rx_bd_init_skb:
>+	kmem_cache_free(lp->skb_cache, axi_skb);
>+	return ret;
>+}
>+
>+/**
>+ * axienet_setup_dma_chan - request the dma channels.
>+ * @ndev:       Pointer to net_device structure
>+ *
>+ * Return: 0, on success.
>+ *          non-zero error value on failure
>+ *
>+ * This function requests the TX and RX channels. It also submits the
>+ * allocated skb buffers and call back APIs to dmaengine.
>+ *
>+ */
>+static int axienet_setup_dma_chan(struct net_device *ndev)
>+{
>+	struct axienet_local *lp =3D netdev_priv(ndev);
>+	int i, ret;
>+
>+	lp->tx_chan =3D dma_request_chan(lp->dev, "tx_chan0");
>+	if (IS_ERR(lp->tx_chan)) {
>+		ret =3D PTR_ERR(lp->tx_chan);
>+		if (ret !=3D -EPROBE_DEFER)
>+			netdev_err(ndev, "No Ethernet DMA (TX) channel
>found\n");
>+		return ret;
>+	}
>+
>+	lp->rx_chan =3D dma_request_chan(lp->dev, "rx_chan0");
>+	if (IS_ERR(lp->rx_chan)) {
>+		ret =3D PTR_ERR(lp->rx_chan);
>+		if (ret !=3D -EPROBE_DEFER)
>+			netdev_err(ndev, "No Ethernet DMA (RX) channel
>found\n");
>+		goto err_dma_request_rx;
>+	}
>+	lp->skb_cache =3D kmem_cache_create("ethernet", sizeof(struct
>axi_skbuff),
>+					  0, 0, NULL);

I do not see kmem_cache_destroy?

Thanks,
Sundeep

>+	if (!lp->skb_cache) {
>+		ret =3D  -ENOMEM;
>+		goto err_kmem;
>+	}
>+	/* TODO: Instead of BD_NUM_DEFAULT use runtime support*/
>+	for (i =3D 0; i < RX_BUF_NUM_DEFAULT; i++)
>+		axienet_rx_submit_desc(ndev);
>+	dma_async_issue_pending(lp->rx_chan);
>+
>+	return 0;
>+err_kmem:
>+	dma_release_channel(lp->rx_chan);
>+err_dma_request_rx:
>+	dma_release_channel(lp->tx_chan);
>+	return ret;
>+}
>+
>+/**
>+ * axienet_init_dmaengine - init the dmaengine code.
>+ * @ndev:       Pointer to net_device structure
>+ *
>+ * Return: 0, on success.
>+ *          non-zero error value on failure
>+ *
>+ * This is the dmaengine initialization code.
>+ */
>+static inline int axienet_init_dmaengine(struct net_device *ndev)
>+{
>+	int ret;
>+
>+	ret =3D axienet_setup_dma_chan(ndev);
>+
>+	if (ret < 0)
>+		return ret;
>+
>+	return 0;
>+}
>+
> /**
>  * axienet_init_legacy_dma - init the dma legacy code.
>  * @ndev:       Pointer to net_device structure
>@@ -1239,7 +1520,20 @@ static int axienet_open(struct net_device *ndev)
>
> 	phylink_start(lp->phylink);
>
>-	if (!AXIENET_USE_DMA(lp)) {
>+	if (AXIENET_USE_DMA(lp)) {
>+		ret =3D axienet_init_dmaengine(ndev);
>+		if (ret < 0)
>+			goto error_code;
>+
>+		/* Enable interrupts for Axi Ethernet core (if defined) */
>+		if (lp->eth_irq > 0) {
>+			ret =3D request_irq(lp->eth_irq, axienet_eth_irq,
>IRQF_SHARED,
>+					  ndev->name, ndev);
>+			if (ret)
>+				goto error_code;
>+		}
>+
>+	} else {
> 		ret =3D axienet_init_legacy_dma(ndev);
> 		if (ret)
> 			goto error_code;
>@@ -1287,6 +1581,12 @@ static int axienet_stop(struct net_device *ndev)
> 		free_irq(lp->tx_irq, ndev);
> 		free_irq(lp->rx_irq, ndev);
> 		axienet_dma_bd_release(ndev);
>+	} else {
>+		dmaengine_terminate_all(lp->tx_chan);
>+		dmaengine_terminate_all(lp->rx_chan);
>+
>+		dma_release_channel(lp->rx_chan);
>+		dma_release_channel(lp->tx_chan);
> 	}
>
> 	axienet_iow(lp, XAE_IE_OFFSET, 0);
>@@ -2136,6 +2436,33 @@ static int axienet_probe(struct platform_device
>*pdev)
> 		}
> 		netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll);
> 		netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll);
>+	} else {
>+		struct xilinx_vdma_config cfg;
>+		struct dma_chan *tx_chan;
>+
>+		lp->eth_irq =3D platform_get_irq_optional(pdev, 0);
>+		tx_chan =3D dma_request_chan(lp->dev, "tx_chan0");
>+
>+		if (IS_ERR(tx_chan)) {
>+			ret =3D PTR_ERR(tx_chan);
>+			if (ret !=3D -EPROBE_DEFER)
>+				dev_err(&pdev->dev, "No Ethernet DMA (TX)
>channel found\n");
>+			goto cleanup_clk;
>+		}
>+
>+		cfg.reset =3D 1;
>+		/* As name says VDMA but it has support for DMA channel
>reset*/
>+		ret =3D xilinx_vdma_channel_set_config(tx_chan, &cfg);
>+
>+		if (ret < 0) {
>+			dev_err(&pdev->dev, "Reset channel failed\n");
>+			dma_release_channel(tx_chan);
>+			goto cleanup_clk;
>+		} else {
>+			lp->has_dmas =3D 1;
>+		}
>+
>+		dma_release_channel(tx_chan);
> 	}
>
> 	/* Check for Ethernet core IRQ (optional) */
>--
>2.25.1
>


