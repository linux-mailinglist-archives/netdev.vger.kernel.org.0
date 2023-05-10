Return-Path: <netdev+bounces-1479-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7309D6FDE5F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FBF21C20D84
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA1C12B82;
	Wed, 10 May 2023 13:20:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45D520B4A
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:20:07 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4A26A45;
	Wed, 10 May 2023 06:20:04 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34A7HZAY029627;
	Wed, 10 May 2023 06:19:21 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qg6ges888-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 06:19:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0xk4gvg/NzFaRhGcMU/vqZvVuZRyOaGKKuo2i1iLYGDwUzALODG/VsWFZVL5T+sgdeWIIbSfclM7PkCvo5QNDVG3T68pmY4XL/GNFlfDb3BgxfXYyXmKPYOqSrwDjKMcftvj896sP7Wv6mD+LG934XQRy/87wqH4E4WsRqbNuzdClmeRS/H3FE1ti2pVuidU8HGdGaNzAQT3YrrPE0nMuEQkbKN4GIEr3N1IlodRdRIqxHq8qYjEaijGvIpgpIeDvez7UdDjkma1SUQIMmEfcCiZdfHb7qs+qb2afXXEPWt1K/fKmCaqs6+LBqIul8kEpNGJKjWaLgEJGosNaMCUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zxSPP93oU4VbAjQLUy7ZWXTMKxUuwFMURO1KHCmED9k=;
 b=eJWm3vWCutb2lDTl1YjxMCy8zFSoEq+qx1uniYBUtAoFnOr1wxGUatOimPstM3ox4aWLojIYr/YO8v/Mh84ycnZP9tr3qAKPZ5xPlCKv+iaW1FeCg9h+1wjDbcBDhXpnhlDaUSorrnO1sx079kmx1eGid0paWXygkD66TwVWbmX3jIBVAygDayK1R9Kv8d0VV+mVFZ1xCuiNaTU5uUP9SOuZAOKPb2A9zncWgXwUyIoSXnuu2RLsuyNHBCgm8Wdh/afock7j5NeQhQPvv3FMrGvUXxtJCNCg6xDrAUF5AopEKB6jrGj3+gGQLS0NgR+TtwumOkYLRzTVdJdonx1NZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zxSPP93oU4VbAjQLUy7ZWXTMKxUuwFMURO1KHCmED9k=;
 b=BiduCqMi5yMJkN1lNRvFAFXbGx29258L7O3/o+/DW4w7mJ4U5XhgwYqqqF8mv4wc8T0lHIh8AweXxk2Vg3l37BJMCuNRc4o89cvge6qVwJ0lnZ/69M9PoI5ajaephJOAyaZ6jgPPFeqzhr411QdYuQxfnK0quBpkhA9CWXITXyY=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by DM6PR18MB2780.namprd18.prod.outlook.com (2603:10b6:5:170::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 13:19:16 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88%6]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 13:19:16 +0000
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
Subject: RE: [EXT] [PATCH net-next V3 2/3] net: axienet: Preparatory changes
 for dmaengine support
Thread-Topic: [EXT] [PATCH net-next V3 2/3] net: axienet: Preparatory changes
 for dmaengine support
Thread-Index: AQHZgysB22htPOJtQECwJGr0qajW8q9Te9hA
Date: Wed, 10 May 2023 13:19:15 +0000
Message-ID: 
 <CO1PR18MB46661C2F9D7D2882C937DD01A1779@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
 <20230510085031.1116327-3-sarath.babu.naidu.gaddam@amd.com>
In-Reply-To: <20230510085031.1116327-3-sarath.babu.naidu.gaddam@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2JoYXR0YVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTQwOGE0YmM5LWVmMzUtMTFlZC05YzVjLWJjZjE3?=
 =?us-ascii?Q?MTIxOGI3YVxhbWUtdGVzdFw0MDhhNGJjYS1lZjM1LTExZWQtOWM1Yy1iY2Yx?=
 =?us-ascii?Q?NzEyMThiN2Fib2R5LnR4dCIgc3o9IjE4NTExIiB0PSIxMzMyODE5ODM1MzAz?=
 =?us-ascii?Q?ODY4MjkiIGg9IlNNZEFZa1VndDFZelhsVTcyczNWN2o0TGtnTT0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUdZTkFB?=
 =?us-ascii?Q?Q054VWtEUW9QWkFma2xsblBrUDFnQitTV1djK1EvV0FFVkFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBRXdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
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
x-ms-traffictypediagnostic: CO1PR18MB4666:EE_|DM6PR18MB2780:EE_
x-ms-office365-filtering-correlation-id: ee8bf4ea-8523-4e8d-6158-08db51592781
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 S4uWbQlDYfGIA4CC62YS1fogvmv8kA4qa+62O4kI1E6yRXdan3ONcEaz5jFbLz/wLQ4Mq+E7gO0o/e4P8GPpPZeepVSjLcHCxrRB04fv6Pt5gSPVGeo6lIvasKxG6BAjHP2UK/ZP3jaBF9FuvlfQv6dJwxheZRyiFgVcrgZimVNlsdoI/xbJY3GG2Q4df3JeH0YLU2ob/0SmfO8lK0HyC03kbW66fKE1qzGBYg4No5FIlWr4HoQLf8kFAVNRBmlM8dtn+urZ4vIPAqXRLgGf1+hqT8ISRP+oKWdAWPBUe/bw5/knAk9yyFmYAgbHAWhgXo9rT8+tMShTmi5QhzDj4nZjzLbtnvj2fDLTYJ1OEtbrymDZpE1rAuoXoA2iBborFuX+gxs0ZKFooXWNIAX4vwKFdnl3iboh+onqzii43BOWUlkTDZasVPnsii4JLEdA2vCACwIhF1+IbFnEzZmA0hMt7/doIhg75E1ImsroMwksCzooPBduiOcxxIlLdJmsbgVu1Os/Xkih0R84XCOc7sy3NsDe1hJ0rpFVoTi2PWqYPccyksjCHee1weLUvVCe5OMwMRgsAzGsQhomy5FX9u7hYqK9HB+p8MmKuk7RTaHAWxFFmmOJylq99VvJy1C8
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199021)(86362001)(66446008)(33656002)(64756008)(316002)(54906003)(76116006)(66556008)(7696005)(478600001)(66476007)(66946007)(4326008)(110136005)(55016003)(5660300002)(8676002)(52536014)(7416002)(8936002)(41300700001)(2906002)(30864003)(71200400001)(186003)(38070700005)(122000001)(38100700002)(9686003)(6506007)(83380400001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?WrKj3LEZk6omR+KoAcBU42aRm51PBx1yBD9xd3zapJKpFcJMtFBi5Jsith9s?=
 =?us-ascii?Q?ef4rD17bUq+mABXM3zLkrr4nK/uKB16kA+6r0qCZbdCrtRaLRCQIFUdDMMA1?=
 =?us-ascii?Q?dlJbjuKCN+zpI+03LA6gtAAF6uMjXnCSSKmWZ034fqNY5AUhCn2NHxTuNAct?=
 =?us-ascii?Q?Eyc3mWJrN4FskW00SS/POz4rKF5x3DEJeWeKNZEms0WApN/rYEHKyQuzyYZo?=
 =?us-ascii?Q?O/P2ePuiSB2MxpiMOkpPT/MmRCHj1p0Smkri1Q//N1+NoLZ/ut8jsftKRUAW?=
 =?us-ascii?Q?WCHo9CmO+T2Ae7WCEcFghky1j/O3qoSK2gV901IYdt1bFvfnkSmBVmq/xMzX?=
 =?us-ascii?Q?ybLzAE7/WxG2RjL0Pt1MVskY/p8y3SEU72sDbGkPo8Jx0HyO63o/I3bLoaEK?=
 =?us-ascii?Q?xzzcm7krXo5BOb0gQwqdcGNZIRiryxuDPXPUpKkvPXJ29LCg4LhmCydf7MqH?=
 =?us-ascii?Q?iTnjGtvh7yyjbQKE0LhKe7+GR2CIQpATMXwandPMowqmnciLKwWbzxLiDJDT?=
 =?us-ascii?Q?Z9JaOx5n5q/3i22a2AaYdpWMsm2Gi2oNxWPAwwDmL3bTPDv9PUCCiGro/jyx?=
 =?us-ascii?Q?L0zRV3zmojgFjlff4c37k24EoYLPUL3qAcmNVpn22EMTP+ZrziBDGIES8ads?=
 =?us-ascii?Q?0kW1plSX8rEUCYy+Nwinj4yQyRasqOE5iGLhmLrD7VAuC3Gp3s64ztLBvn0j?=
 =?us-ascii?Q?FBujEhR+pBAwY9t4Zv2FWlB6fJ0+jmPgZu44r8MoOUS2HFCVgJceKRLlaBuZ?=
 =?us-ascii?Q?B1riWXWb4K6eqMgifsd23oORFXG3EhANIg7ymzUXyZkL6esjM2t4DXlTorcA?=
 =?us-ascii?Q?vLKopX1HXgD5K15dUnvgQFR4mz9j9jPwewRq13Ul/f8rN+LTtVwHMjNDjSsf?=
 =?us-ascii?Q?BQJxHg0Ydw8dMYOlpWouQ5rfkw9mkjtWvSkKp777QZx9gI16qy3Mo7u5HvfU?=
 =?us-ascii?Q?Db4+SdKF9jT8Rzl4WH6WQgEwjhmyZuVW18aELcXslUa9IuJH19+cZHpLiEho?=
 =?us-ascii?Q?CD4rrSgqb0tZq8ySSPF82HTD7ZeU5gGC+3214bzYI26mTdYVdfjxWMehLrz/?=
 =?us-ascii?Q?LV1aX7s73EorrQuqop51ze5ZJ68TNCDK/Db4u720FVwCcy/wcyhIWLJYFsQV?=
 =?us-ascii?Q?0KgohnOFEpCSDu5DZyrVTKc2Ga3RgiJ24HIMUjbLCd95jlNbFUDAiPUCmugQ?=
 =?us-ascii?Q?ZOEm0f+BRLpoGeIoHIIHN+VVJneEQDe1QavFRVcR7ajzzGYkDVvZKd5YRdIT?=
 =?us-ascii?Q?PpSxZCmsmCzZ7v3OpKqjWO8tdSQ1z4NM01O/EyC4HfI0LnVsCng91BGfIfk7?=
 =?us-ascii?Q?HUPGOpp6moh0YmT60GzRwyJeCqzoRAoyWSu9FeSt1suR10pTLxiE2k1XSjxi?=
 =?us-ascii?Q?ckQ4YUvL6r59HuBqVESN2wtgqFd7u+bPFr+y6N0vv+vWf2xj4Ougdsci3tGp?=
 =?us-ascii?Q?ACUYhSPKEuKqFepZL6JfCTj5TptCtONlK23wtj0iegiLzAayleJkYqwfumwa?=
 =?us-ascii?Q?4V4EmtX8aOGY/lpiubWRYaAGq5OslKpbY0q+BAaRbKmeUiZ+yO9nljLAxg?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8bf4ea-8523-4e8d-6158-08db51592781
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 13:19:15.9535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gRBcO5dU5TV3bRewhUTwKZh4kos6MmOOcwc854Vn07RYIhctFABMornU3X0Zpi2MApIE3HKlNBYdTn2SkZN1UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2780
X-Proofpoint-GUID: djHzTRs20-xYVTF1boHaIndXLt4btx38
X-Proofpoint-ORIG-GUID: djHzTRs20-xYVTF1boHaIndXLt4btx38
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
>Subject: [PATCH net-next V3 2/3] net: axienet: Preparatory changes for
>dmaengine support
>
>The axiethernet driver has in-built dma programming. The aim is to remove
>axiethernet axidma programming  after some time and instead use the
>dmaengine framework to communicate with existing xilinx DMAengine
>controller(xilinx_dma) driver.
>
>Keep the axidma programming code under AXIENET_USE_DMA check so that
>dmaengine changes can be added later.
>
>Perform minor code reordering to minimize conditional AXIENET_USE_DMA
>checks and there is no functional change.
>
>It uses "dmas" property to identify whether it should use a dmaengine fram=
ework
>or axiethernet axidma programming.
>
>Signed-off-by: Sarath Babu Naidu Gaddam
><sarath.babu.naidu.gaddam@amd.com>
>---
>Changes in V3:
>1) New Patch.
>---
> drivers/net/ethernet/xilinx/xilinx_axienet.h  |   2 +
> .../net/ethernet/xilinx/xilinx_axienet_main.c | 317 +++++++++++-------
> 2 files changed, 192 insertions(+), 127 deletions(-)
>
>diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h
>b/drivers/net/ethernet/xilinx/xilinx_axienet.h
>index 575ff9de8985..10917d997d27 100644
>--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
>+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
>@@ -435,6 +435,7 @@ struct axidma_bd {
>  * @coalesce_usec_rx:	IRQ coalesce delay for RX
>  * @coalesce_count_tx:	Store the irq coalesce on TX side.
>  * @coalesce_usec_tx:	IRQ coalesce delay for TX
>+ * @has_dmas:	flag to check dmaengine framework usage.
>  */
> struct axienet_local {
> 	struct net_device *ndev;
>@@ -499,6 +500,7 @@ struct axienet_local {
> 	u32 coalesce_usec_rx;
> 	u32 coalesce_count_tx;
> 	u32 coalesce_usec_tx;
>+	u8  has_dmas;

Hardware always has dma. You are just switching to dmaengine software frame=
work.
use_dmaengine might be the correct name.

> };
>
> /**
>diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
>b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
>index 3e310b55bce2..8678fc09245a 100644
>--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
>+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
>@@ -54,6 +54,8 @@
>
> #define AXIENET_REGS_N		40
>
>+#define AXIENET_USE_DMA(lp) ((lp)->has_dmas)
>+
IMO lp->has_dmas is already simple enough and no need of a macro.
Up to you to remove or keep it.

Thanks,
Sundeep

> /* Match table for of_platform binding */  static const struct of_device_=
id
>axienet_of_match[] =3D {
> 	{ .compatible =3D "xlnx,axi-ethernet-1.00.a", }, @@ -588,10 +590,6 @@
>static int axienet_device_reset(struct net_device *ndev)
> 	struct axienet_local *lp =3D netdev_priv(ndev);
> 	int ret;
>
>-	ret =3D __axienet_device_reset(lp);
>-	if (ret)
>-		return ret;
>-
> 	lp->max_frm_size =3D XAE_MAX_VLAN_FRAME_SIZE;
> 	lp->options |=3D XAE_OPTION_VLAN;
> 	lp->options &=3D (~XAE_OPTION_JUMBO);
>@@ -605,11 +603,17 @@ static int axienet_device_reset(struct net_device
>*ndev)
> 			lp->options |=3D XAE_OPTION_JUMBO;
> 	}
>
>-	ret =3D axienet_dma_bd_init(ndev);
>-	if (ret) {
>-		netdev_err(ndev, "%s: descriptor allocation failed\n",
>-			   __func__);
>-		return ret;
>+	if (!AXIENET_USE_DMA(lp)) {
>+		ret =3D __axienet_device_reset(lp);
>+		if (ret)
>+			return ret;
>+
>+		ret =3D axienet_dma_bd_init(ndev);
>+		if (ret) {
>+			netdev_err(ndev, "%s: descriptor allocation failed\n",
>+				   __func__);
>+			return ret;
>+		}
> 	}
>
> 	axienet_status =3D axienet_ior(lp, XAE_RCW1_OFFSET); @@ -775,7 +779,7
>@@ static int axienet_tx_poll(struct napi_struct *napi, int budget)  }
>
> /**
>- * axienet_start_xmit - Starts the transmission.
>+ * axienet_start_xmit_legacy - Starts the transmission.
>  * @skb:	sk_buff pointer that contains data to be Txed.
>  * @ndev:	Pointer to net_device structure.
>  *
>@@ -788,7 +792,7 @@ static int axienet_tx_poll(struct napi_struct *napi, i=
nt
>budget)
>  * it populates AXI Stream Control fields with appropriate values.
>  */
> static netdev_tx_t
>-axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>+axienet_start_xmit_legacy(struct sk_buff *skb, struct net_device *ndev)
> {
> 	u32 ii;
> 	u32 num_frag;
>@@ -890,6 +894,27 @@ axienet_start_xmit(struct sk_buff *skb, struct
>net_device *ndev)
> 	return NETDEV_TX_OK;
> }
>
>+/**
>+ * axienet_start_xmit - Starts the transmission.
>+ * @skb:        sk_buff pointer that contains data to be Txed.
>+ * @ndev:       Pointer to net_device structure.
>+ *
>+ * Return: NETDEV_TX_OK, on success
>+ *          NETDEV_TX_BUSY, if any of the descriptors are not free
>+ *
>+ * This function is invoked from upper layers to initiate transmission
>+*/ static netdev_tx_t axienet_start_xmit(struct sk_buff *skb, struct
>+net_device *ndev) {
>+	struct axienet_local *lp =3D netdev_priv(ndev);
>+
>+	if (!AXIENET_USE_DMA(lp))
>+		return axienet_start_xmit_legacy(skb, ndev);
>+	else
>+		return NETDEV_TX_BUSY;
>+}
>+
> /**
>  * axienet_rx_poll - Triggered by RX ISR to complete the BD processing.
>  * @napi:	Pointer to NAPI structure.
>@@ -1124,41 +1149,22 @@ static irqreturn_t axienet_eth_irq(int irq, void
>*_ndev)  static void axienet_dma_err_handler(struct work_struct *work);
>
> /**
>- * axienet_open - Driver open routine.
>- * @ndev:	Pointer to net_device structure
>+ * axienet_init_legacy_dma - init the dma legacy code.
>+ * @ndev:       Pointer to net_device structure
>  *
>  * Return: 0, on success.
>- *	    non-zero error value on failure
>+ *          non-zero error value on failure
>+ *
>+ * This is the dma  initialization code. It also allocates interrupt
>+ * service routines, enables the interrupt lines and ISR handling.
>  *
>- * This is the driver open routine. It calls phylink_start to start the
>- * PHY device.
>- * It also allocates interrupt service routines, enables the interrupt li=
nes
>- * and ISR handling. Axi Ethernet core is reset through Axi DMA core. Buf=
fer
>- * descriptors are initialized.
>  */
>-static int axienet_open(struct net_device *ndev)
>+
>+static inline int axienet_init_legacy_dma(struct net_device *ndev)
> {
> 	int ret;
> 	struct axienet_local *lp =3D netdev_priv(ndev);
>
>-	dev_dbg(&ndev->dev, "axienet_open()\n");
>-
>-	/* When we do an Axi Ethernet reset, it resets the complete core
>-	 * including the MDIO. MDIO must be disabled before resetting.
>-	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
>-	 */
>-	axienet_lock_mii(lp);
>-	ret =3D axienet_device_reset(ndev);
>-	axienet_unlock_mii(lp);
>-
>-	ret =3D phylink_of_phy_connect(lp->phylink, lp->dev->of_node, 0);
>-	if (ret) {
>-		dev_err(lp->dev, "phylink_of_phy_connect() failed: %d\n", ret);
>-		return ret;
>-	}
>-
>-	phylink_start(lp->phylink);
>-
> 	/* Enable worker thread for Axi DMA error handling */
> 	INIT_WORK(&lp->dma_err_task, axienet_dma_err_handler);
>
>@@ -1192,13 +1198,62 @@ static int axienet_open(struct net_device *ndev)
> err_tx_irq:
> 	napi_disable(&lp->napi_tx);
> 	napi_disable(&lp->napi_rx);
>-	phylink_stop(lp->phylink);
>-	phylink_disconnect_phy(lp->phylink);
> 	cancel_work_sync(&lp->dma_err_task);
> 	dev_err(lp->dev, "request_irq() failed\n");
> 	return ret;
> }
>
>+/**
>+ * axienet_open - Driver open routine.
>+ * @ndev:	Pointer to net_device structure
>+ *
>+ * Return: 0, on success.
>+ *	    non-zero error value on failure
>+ *
>+ * This is the driver open routine. It calls phylink_start to start the
>+ * PHY device.
>+ * It also allocates interrupt service routines, enables the interrupt
>+lines
>+ * and ISR handling. Axi Ethernet core is reset through Axi DMA core.
>+Buffer
>+ * descriptors are initialized.
>+ */
>+static int axienet_open(struct net_device *ndev) {
>+	int ret;
>+	struct axienet_local *lp =3D netdev_priv(ndev);
>+
>+	dev_dbg(&ndev->dev, "%s\n", __func__);
>+
>+	/* When we do an Axi Ethernet reset, it resets the complete core
>+	 * including the MDIO. MDIO must be disabled before resetting.
>+	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
>+	 */
>+	axienet_lock_mii(lp);
>+	ret =3D axienet_device_reset(ndev);
>+	axienet_unlock_mii(lp);
>+
>+	ret =3D phylink_of_phy_connect(lp->phylink, lp->dev->of_node, 0);
>+	if (ret) {
>+		dev_err(lp->dev, "phylink_of_phy_connect() failed: %d\n", ret);
>+		return ret;
>+	}
>+
>+	phylink_start(lp->phylink);
>+
>+	if (!AXIENET_USE_DMA(lp)) {
>+		ret =3D axienet_init_legacy_dma(ndev);
>+		if (ret)
>+			goto error_code;
>+	}
>+
>+	return 0;
>+
>+error_code:
>+	phylink_stop(lp->phylink);
>+	phylink_disconnect_phy(lp->phylink);
>+
>+	return ret;
>+}
>+
> /**
>  * axienet_stop - Driver stop routine.
>  * @ndev:	Pointer to net_device structure
>@@ -1215,8 +1270,10 @@ static int axienet_stop(struct net_device *ndev)
>
> 	dev_dbg(&ndev->dev, "axienet_close()\n");
>
>-	napi_disable(&lp->napi_tx);
>-	napi_disable(&lp->napi_rx);
>+	if (!AXIENET_USE_DMA(lp)) {
>+		napi_disable(&lp->napi_tx);
>+		napi_disable(&lp->napi_rx);
>+	}
>
> 	phylink_stop(lp->phylink);
> 	phylink_disconnect_phy(lp->phylink);
>@@ -1224,18 +1281,18 @@ static int axienet_stop(struct net_device *ndev)
> 	axienet_setoptions(ndev, lp->options &
> 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
>
>-	axienet_dma_stop(lp);
>+	if (!AXIENET_USE_DMA(lp)) {
>+		axienet_dma_stop(lp);
>+		cancel_work_sync(&lp->dma_err_task);
>+		free_irq(lp->tx_irq, ndev);
>+		free_irq(lp->rx_irq, ndev);
>+		axienet_dma_bd_release(ndev);
>+	}
>
> 	axienet_iow(lp, XAE_IE_OFFSET, 0);
>
>-	cancel_work_sync(&lp->dma_err_task);
>-
> 	if (lp->eth_irq > 0)
> 		free_irq(lp->eth_irq, ndev);
>-	free_irq(lp->tx_irq, ndev);
>-	free_irq(lp->rx_irq, ndev);
>-
>-	axienet_dma_bd_release(ndev);
> 	return 0;
> }
>
>@@ -1411,14 +1468,16 @@ static void axienet_ethtools_get_regs(struct
>net_device *ndev,
> 	data[29] =3D axienet_ior(lp, XAE_FMI_OFFSET);
> 	data[30] =3D axienet_ior(lp, XAE_AF0_OFFSET);
> 	data[31] =3D axienet_ior(lp, XAE_AF1_OFFSET);
>-	data[32] =3D axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
>-	data[33] =3D axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
>-	data[34] =3D axienet_dma_in32(lp, XAXIDMA_TX_CDESC_OFFSET);
>-	data[35] =3D axienet_dma_in32(lp, XAXIDMA_TX_TDESC_OFFSET);
>-	data[36] =3D axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
>-	data[37] =3D axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
>-	data[38] =3D axienet_dma_in32(lp, XAXIDMA_RX_CDESC_OFFSET);
>-	data[39] =3D axienet_dma_in32(lp, XAXIDMA_RX_TDESC_OFFSET);
>+	if (!AXIENET_USE_DMA(lp)) {
>+		data[32] =3D axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
>+		data[33] =3D axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
>+		data[34] =3D axienet_dma_in32(lp, XAXIDMA_TX_CDESC_OFFSET);
>+		data[35] =3D axienet_dma_in32(lp, XAXIDMA_TX_TDESC_OFFSET);
>+		data[36] =3D axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
>+		data[37] =3D axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
>+		data[38] =3D axienet_dma_in32(lp, XAXIDMA_RX_CDESC_OFFSET);
>+		data[39] =3D axienet_dma_in32(lp, XAXIDMA_RX_TDESC_OFFSET);
>+	}
> }
>
> static void
>@@ -1878,9 +1937,6 @@ static int axienet_probe(struct platform_device *pde=
v)
> 	u64_stats_init(&lp->rx_stat_sync);
> 	u64_stats_init(&lp->tx_stat_sync);
>
>-	netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll);
>-	netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll);
>-
> 	lp->axi_clk =3D devm_clk_get_optional(&pdev->dev, "s_axi_lite_clk");
> 	if (!lp->axi_clk) {
> 		/* For backward compatibility, if named AXI clock is not present,
>@@ -2006,75 +2062,80 @@ static int axienet_probe(struct platform_device
>*pdev)
> 		goto cleanup_clk;
> 	}
>
>-	/* Find the DMA node, map the DMA registers, and decode the DMA IRQs
>*/
>-	np =3D of_parse_phandle(pdev->dev.of_node, "axistream-connected", 0);
>-	if (np) {
>-		struct resource dmares;
>+	if (!of_find_property(pdev->dev.of_node, "dmas", NULL)) {
>+		/* Find the DMA node, map the DMA registers, and decode the
>DMA IRQs */
>+		np =3D of_parse_phandle(pdev->dev.of_node, "axistream-
>connected", 0);
>
>-		ret =3D of_address_to_resource(np, 0, &dmares);
>-		if (ret) {
>-			dev_err(&pdev->dev,
>-				"unable to get DMA resource\n");
>+		if (np) {
>+			struct resource dmares;
>+
>+			ret =3D of_address_to_resource(np, 0, &dmares);
>+			if (ret) {
>+				dev_err(&pdev->dev,
>+					"unable to get DMA resource\n");
>+				of_node_put(np);
>+				goto cleanup_clk;
>+			}
>+			lp->dma_regs =3D devm_ioremap_resource(&pdev->dev,
>+							     &dmares);
>+			lp->rx_irq =3D irq_of_parse_and_map(np, 1);
>+			lp->tx_irq =3D irq_of_parse_and_map(np, 0);
> 			of_node_put(np);
>+			lp->eth_irq =3D platform_get_irq_optional(pdev, 0);
>+		} else {
>+			/* Check for these resources directly on the Ethernet
>node. */
>+			lp->dma_regs =3D
>devm_platform_get_and_ioremap_resource(pdev, 1, NULL);
>+			lp->rx_irq =3D platform_get_irq(pdev, 1);
>+			lp->tx_irq =3D platform_get_irq(pdev, 0);
>+			lp->eth_irq =3D platform_get_irq_optional(pdev, 2);
>+		}
>+		if (IS_ERR(lp->dma_regs)) {
>+			dev_err(&pdev->dev, "could not map DMA regs\n");
>+			ret =3D PTR_ERR(lp->dma_regs);
>+			goto cleanup_clk;
>+		}
>+		if (lp->rx_irq <=3D 0 || lp->tx_irq <=3D 0) {
>+			dev_err(&pdev->dev, "could not determine irqs\n");
>+			ret =3D -ENOMEM;
> 			goto cleanup_clk;
> 		}
>-		lp->dma_regs =3D devm_ioremap_resource(&pdev->dev,
>-						     &dmares);
>-		lp->rx_irq =3D irq_of_parse_and_map(np, 1);
>-		lp->tx_irq =3D irq_of_parse_and_map(np, 0);
>-		of_node_put(np);
>-		lp->eth_irq =3D platform_get_irq_optional(pdev, 0);
>-	} else {
>-		/* Check for these resources directly on the Ethernet node. */
>-		lp->dma_regs =3D
>devm_platform_get_and_ioremap_resource(pdev, 1, NULL);
>-		lp->rx_irq =3D platform_get_irq(pdev, 1);
>-		lp->tx_irq =3D platform_get_irq(pdev, 0);
>-		lp->eth_irq =3D platform_get_irq_optional(pdev, 2);
>-	}
>-	if (IS_ERR(lp->dma_regs)) {
>-		dev_err(&pdev->dev, "could not map DMA regs\n");
>-		ret =3D PTR_ERR(lp->dma_regs);
>-		goto cleanup_clk;
>-	}
>-	if ((lp->rx_irq <=3D 0) || (lp->tx_irq <=3D 0)) {
>-		dev_err(&pdev->dev, "could not determine irqs\n");
>-		ret =3D -ENOMEM;
>-		goto cleanup_clk;
>-	}
>
>-	/* Autodetect the need for 64-bit DMA pointers.
>-	 * When the IP is configured for a bus width bigger than 32 bits,
>-	 * writing the MSB registers is mandatory, even if they are all 0.
>-	 * We can detect this case by writing all 1's to one such register
>-	 * and see if that sticks: when the IP is configured for 32 bits
>-	 * only, those registers are RES0.
>-	 * Those MSB registers were introduced in IP v7.1, which we check first.
>-	 */
>-	if ((axienet_ior(lp, XAE_ID_OFFSET) >> 24) >=3D 0x9) {
>-		void __iomem *desc =3D lp->dma_regs +
>XAXIDMA_TX_CDESC_OFFSET + 4;
>-
>-		iowrite32(0x0, desc);
>-		if (ioread32(desc) =3D=3D 0) {	/* sanity check */
>-			iowrite32(0xffffffff, desc);
>-			if (ioread32(desc) > 0) {
>-				lp->features |=3D XAE_FEATURE_DMA_64BIT;
>-				addr_width =3D 64;
>-				dev_info(&pdev->dev,
>-					 "autodetected 64-bit DMA range\n");
>-			}
>+		/* Autodetect the need for 64-bit DMA pointers.
>+		 * When the IP is configured for a bus width bigger than 32 bits,
>+		 * writing the MSB registers is mandatory, even if they are all 0.
>+		 * We can detect this case by writing all 1's to one such register
>+		 * and see if that sticks: when the IP is configured for 32 bits
>+		 * only, those registers are RES0.
>+		 * Those MSB registers were introduced in IP v7.1, which we
>check first.
>+		 */
>+		if ((axienet_ior(lp, XAE_ID_OFFSET) >> 24) >=3D 0x9) {
>+			void __iomem *desc =3D lp->dma_regs +
>XAXIDMA_TX_CDESC_OFFSET + 4;
>+
> 			iowrite32(0x0, desc);
>+			if (ioread32(desc) =3D=3D 0) {	/* sanity check */
>+				iowrite32(0xffffffff, desc);
>+				if (ioread32(desc) > 0) {
>+					lp->features |=3D
>XAE_FEATURE_DMA_64BIT;
>+					addr_width =3D 64;
>+					dev_info(&pdev->dev,
>+						 "autodetected 64-bit DMA
>range\n");
>+				}
>+				iowrite32(0x0, desc);
>+			}
>+		}
>+		if (!IS_ENABLED(CONFIG_64BIT) && lp->features &
>XAE_FEATURE_DMA_64BIT) {
>+			dev_err(&pdev->dev, "64-bit addressable DMA is not
>compatible with 32-bit archecture\n");
>+			ret =3D -EINVAL;
>+			goto cleanup_clk;
> 		}
>-	}
>-	if (!IS_ENABLED(CONFIG_64BIT) && lp->features &
>XAE_FEATURE_DMA_64BIT) {
>-		dev_err(&pdev->dev, "64-bit addressable DMA is not compatible
>with 32-bit archecture\n");
>-		ret =3D -EINVAL;
>-		goto cleanup_clk;
>-	}
>
>-	ret =3D dma_set_mask_and_coherent(&pdev->dev,
>DMA_BIT_MASK(addr_width));
>-	if (ret) {
>-		dev_err(&pdev->dev, "No suitable DMA available\n");
>-		goto cleanup_clk;
>+		ret =3D dma_set_mask_and_coherent(&pdev->dev,
>DMA_BIT_MASK(addr_width));
>+		if (ret) {
>+			dev_err(&pdev->dev, "No suitable DMA available\n");
>+			goto cleanup_clk;
>+		}
>+		netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll);
>+		netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll);
> 	}
>
> 	/* Check for Ethernet core IRQ (optional) */ @@ -2092,14 +2153,16 @@
>static int axienet_probe(struct platform_device *pdev)
> 	}
>
> 	lp->coalesce_count_rx =3D XAXIDMA_DFT_RX_THRESHOLD;
>-	lp->coalesce_usec_rx =3D XAXIDMA_DFT_RX_USEC;
> 	lp->coalesce_count_tx =3D XAXIDMA_DFT_TX_THRESHOLD;
>-	lp->coalesce_usec_tx =3D XAXIDMA_DFT_TX_USEC;
>
>-	/* Reset core now that clocks are enabled, prior to accessing MDIO */
>-	ret =3D __axienet_device_reset(lp);
>-	if (ret)
>-		goto cleanup_clk;
>+	if (!AXIENET_USE_DMA(lp)) {
>+		lp->coalesce_usec_rx =3D XAXIDMA_DFT_RX_USEC;
>+		lp->coalesce_usec_tx =3D XAXIDMA_DFT_TX_USEC;
>+		/* Reset core now that clocks are enabled, prior to accessing
>MDIO */
>+		ret =3D __axienet_device_reset(lp);
>+		if (ret)
>+			goto cleanup_clk;
>+	}
>
> 	ret =3D axienet_mdio_setup(lp);
> 	if (ret)
>--
>2.25.1
>


