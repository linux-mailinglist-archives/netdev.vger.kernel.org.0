Return-Path: <netdev+bounces-3506-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 630217079A4
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4311F1C20EBC
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 05:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4C2137D;
	Thu, 18 May 2023 05:29:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03720137A
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 05:29:25 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FB53AB5;
	Wed, 17 May 2023 22:28:52 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HMFHVx012894;
	Wed, 17 May 2023 22:27:32 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qn7jb980x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 May 2023 22:27:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sci+OaKapJCuTBYfgltBAEyj1Z7BnrEfbqJvd/jFEfipN6V8vQ2P3CuzoQ1GlX1WHy2jZp0MbsmzmKkOuR5LOpz3y62ZVhkJMaWofGEguXkGstihElECDi4sWIJkaQf3GJWkxEq0/tBbhlMjYD2xq9l+a+fIKdXZNONdjEvjuR14nve42et1wmWglluOx7FciVG2RfQe/o4kvhmkt+9d6mNPmLIg0ro13bKAnO7rqS+4l3kez+3qn7uPkF38dFsZxvOJ219lfBqCAucmvZ2c2ezFUnxJMcQGjSbaa64WdJxGfGnwwCxObg/I+xHTHck48nI2j06yr5b468gkM6wB/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5WOofsUPfdFjC7TPTLRMcnPOwjPMOxUKOiCRAh77Ys=;
 b=GeDOD/ZlWV1NlY+XdhVZdzEpQ8DHTKel9wrW7BmIRFvtm4TiJ2z8MX4XPKL1nBu0ElYIAdpW4Rlag5gd2CppGQtvs1K6bL8RFInHKo7WcPdv4tUj9fmzI1+YSww71B9a4Mdrp4Y6um32qU+Tcqxyvl88B0RUXzs4ywwJi3eMibxHgyjrsuxwMpoIGZLbixIBf9dYVUbsE9KB4tlDhZtVQXcZNCE74NZSuTZPyNrKZq9VTbTwm3/4Vu3cwxgQrcLkjmDCK5usmvHXR0u2EyeLgClE11Qdg5KnTRip9XEQxAgscc8Av7+XYzSmiqgqX7aixsNSJF9gHIDUNGENeWiEDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5WOofsUPfdFjC7TPTLRMcnPOwjPMOxUKOiCRAh77Ys=;
 b=SJq3XhDFj+D8/MeHqtQwiv16D4vtxq2lVx9AbJ+ox7oC6DLKyky9b6UCcj7rltPaCdeIsZ5KUu6ooM5W+IC63mR0oeAHO5PfAD9gnWUv2YeFdMJlDxUUb9q8CLyTucNL0A5wOHpKsHI27qsegf7uNm8bmWZkE+cpu0yF94K0PqU=
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 (2603:10b6:301:68::33) by CH2PR18MB3272.namprd18.prod.outlook.com
 (2603:10b6:610:21::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Thu, 18 May
 2023 05:27:28 +0000
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::652:d887:6cce:6a3]) by MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::652:d887:6cce:6a3%6]) with mapi id 15.20.6387.028; Thu, 18 May 2023
 05:27:28 +0000
From: Ratheesh Kannoth <rkannoth@marvell.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri
 Goutham <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com"
	<pabeni@redhat.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Srujana Challa
	<schalla@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: RE: Re: [PATH net-next v1] octeontx2-pf: Add support for page pool
Thread-Topic: Re: [PATH net-next v1] octeontx2-pf: Add support for page pool
Thread-Index: AQHZiUlvwclaroU3Xk+4nrIRMuBdfA==
Date: Thu, 18 May 2023 05:27:27 +0000
Message-ID: 
 <MWHPR1801MB1918540ACD82ECEF1F7D92ACD37F9@MWHPR1801MB1918.namprd18.prod.outlook.com>
References: <20230517041511.2532997-1-rkannoth@marvell.com>
 <20230517204632.5f80a7bf@kernel.org>
In-Reply-To: <20230517204632.5f80a7bf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccmthbm5vdGhc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy1hYjQxNzRlNC1mNTNjLTExZWQtYjZmMC04MDM4?=
 =?us-ascii?Q?ZmJmMmM2MjJcYW1lLXRlc3RcYWI0MTc0ZTUtZjUzYy0xMWVkLWI2ZjAtODAz?=
 =?us-ascii?Q?OGZiZjJjNjIyYm9keS50eHQiIHN6PSIzODA5IiB0PSIxMzMyODg2MTI0NTE5?=
 =?us-ascii?Q?OTY1MzMiIGg9IklSamZmek1mZ0ZZWk5GS3QySFZPcVJkQ0hiQT0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQU1nTUFB?=
 =?us-ascii?Q?QjFVODV0U1luWkFZanhHSjQ0dWxsZGlQRVluamk2V1YwVUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUJZREFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRRUJBQUFBNCtVdERBQ0FBUUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFa?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBRFFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
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
 =?us-ascii?Q?QUcwQVpRQnpBRjhBY2dCbEFITUFkQUJ5QUdrQVl3QjBBR1VBWkFCZkFHMEFZ?=
 =?us-ascii?Q?UUJ5QUhZQVpRQnNBR3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dB?=
 =?us-ascii?Q?YkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFBWHdCdUFHRUFiUUJsQUhNQVh3QnlB?=
 =?us-ascii?Q?R1VBY3dCMEFISUFhUUJqQUhRQVpRQmtBRjhBYlFCaEFISUFkZ0JsQUd3QWJB?=
 =?us-ascii?Q?QmZBRzhBY2dCZkFHRUFjZ0J0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBZEFCbEFISUFi?=
 =?us-ascii?Q?UUJwQUc0QWRRQnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?RzBBWVFCeUFIWUFaUUJzQUd3QVh3QjNBRzhBY2dCa0FBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reffour: 
 QUFBQUFBQUFBQkFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUE9Ii8+PC9tZXRhPg==
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR1801MB1918:EE_|CH2PR18MB3272:EE_
x-ms-office365-filtering-correlation-id: ca0323d9-6da4-44bf-c28a-08db576091f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 EH0spGApi9t7kkxwJU5UsjY+MbTwDcleKjvUeivUiecnP8bFZtppLlLRhSeMF/OMEHJ+xKlBpIHQaysVDV2RMtDU9G0p/K+k60cZHKWCh8B/MaVekI42dYcCl7w1LR+MNILugjx2q7Z9r2xZeuK2zKjkuEHsyjZ1RfEz4KqT5bWKY/zF8n44IsDFa0Na2eUB0HDVLbG5qwQygIgc9nO7xFOr+mjLGWMtsWg7Ousroqj1ELR0kQGgZPGV4lSKT/lxsPryxqZYoXzhK3tblrwpxgya0736Igoab85wUcInfx+B2MupjitcmIENBAlgOEvrbNB1IPRJt08XN/Y6nL9DbPXUs5m4GhrNM2mYKKl46MG78GfuiL7Pu73xMJIIiVeOUIxPBeBMf2G35xaI/9Eg7PWvDNQsmQUc+Hz2fO1xa8bNagH+GSgeM96ARt8VJwDgSBVBHd0+P0I+LJjIGlxZne9+RItIXYdwcurP+6qxEPNUUao4vHbT5u5qguPvKe9JGV9xLlj9oPklLN7VFrvGJVI/ew7Ja7JyLILLpFzXkd0sCMwsrqaEWk/Kg3bLI3vs20ETat8x+tAcaG9J+58F/SE5eg8j4pafidHNK968kG8qL7DeBsnu8BdljrT3GSZB
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1801MB1918.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199021)(33656002)(86362001)(38070700005)(478600001)(54906003)(4326008)(64756008)(7696005)(6916009)(66556008)(66476007)(76116006)(316002)(66946007)(66446008)(71200400001)(52536014)(41300700001)(55016003)(5660300002)(2906002)(38100700002)(122000001)(8676002)(26005)(107886003)(186003)(53546011)(6506007)(9686003)(83380400001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?OIII756Q0qWM1Ubs43RUZYvK1FzXNV5fWdAX84H7b19O2TozimG/PhE9ye5w?=
 =?us-ascii?Q?QnylBYF6MnOr4bHF00qrgEUJMjc51CoseU4zwqZo/UnNmlmlGTICbyzmqlWj?=
 =?us-ascii?Q?L4HZdNYht+qK/dSrtGwyytPVRBZ1csthbDqZnjCnL/M8WEjomnZdVeQ1FX9I?=
 =?us-ascii?Q?hw9IEE3U2X9dNdfmkX7UKsI47d+yHnXV7VqGijbE4OCyPPu6bZsAJ5QtVVHv?=
 =?us-ascii?Q?xp5wHNid5sJWTD39c8Ovv0I2zKiYFjRsKJD7YbjE1jGD/IPqUciHv4K9jSYK?=
 =?us-ascii?Q?dnf9JJ49lXVBjVIXr9aH5NARs040mD1t4czFhzOIKZWrKEiw/3zbegDpVbVJ?=
 =?us-ascii?Q?eSgd+z3ou0z8uctl4z+XEoTvbBixqUN9So7mxcglZg89+CtmwDYrXVb8plGh?=
 =?us-ascii?Q?o25/ViJKPzcDkSla+unFDPGr/IbuEgLP1SUjEAMWKukuSOloebUQr0PU+5fO?=
 =?us-ascii?Q?L/LvzNRaM+T1U4It4owAsiIz2Rrx/R+81gOFxBk1Tu966AAt35AwBRQH00BW?=
 =?us-ascii?Q?xKwusFCDVC/KOAWB0FOn91UxBIohNNB8lkGzrMUxWReSuKOZcD0WFJbSFbx2?=
 =?us-ascii?Q?1KCdDClhmZOQJggiVkZSHUQ+FeCkhigL0FZEG25Nq26UmUyJkv0Cfji1GoMe?=
 =?us-ascii?Q?1lIIkUmUHDYbZcxVYmU5fdqU7mPCvYMJ5cwO7Ra3Spm3HsIZ0GtnkvvvJdra?=
 =?us-ascii?Q?F3gngbqJ/OXyFKeLs4Rt67261B7psmk+U1ENTsnkmFGQN9IX2PLj0BgYqSFM?=
 =?us-ascii?Q?VHu3OaFX5BYX7wASOk3lIbHfXNlduax0tD3r66Msx3feWPAIXjBOvYjZGfva?=
 =?us-ascii?Q?bez3ixWXhPNekQk43crnG7qzipnmVhbAjkr55hrC2GpnPrKjOmuQaP4Hk9TU?=
 =?us-ascii?Q?iKG3a1FOKi48nm339SyNJgIdWv5E/WVJhznOJY5L4oFDwEnPi3ypjigkUWNj?=
 =?us-ascii?Q?Hq9cE4Axgh4YcQ37quOs8ybf6Wdup8Uic6csKX98NQVhVB/LMgt2fJ9948SY?=
 =?us-ascii?Q?wQj5SQ0+s6PvBGkxSQCf7Y60cpUCYvzAkoRu3LSB1FSlPTORj+n0Rjd9GhZ5?=
 =?us-ascii?Q?KsAB7DS2Z0gW3CHeb8U2p7H9YsEPSqD5sMTC/gaqCV27XFtPfWO3cv4WCDja?=
 =?us-ascii?Q?2mMBWDCz9hCqsOnAmFu/dJd/hd3veaX7izD9W2V7x5RaqM6UJ3PSpRBq7DhQ?=
 =?us-ascii?Q?ln80yI4Ij8aY/q1R0F5XcM8Zczkn/TaaTubrrzGI0iSgZ0kFHqVQXO2i5U9l?=
 =?us-ascii?Q?zh4f7qDFUrTl1kw7VkfeuCuTpPZSVWh9QrF/6NKaivkMMSogS7pAguip89km?=
 =?us-ascii?Q?252rqjIvk59r8owv3GiPXdiNkQQVlrK9U+WFTxsCeXPqRp5W4M54+LOxm/Wg?=
 =?us-ascii?Q?axZFXqjIB7zoMRPOYHvjNcmju4YA8g2X3v3LThdS+Z/METW1ZBKh2a6kgaoG?=
 =?us-ascii?Q?L3ycEJy7RPeoidrTxclJ/Sjj83bsonT4uyz5dvHsBTG8S0G3e2KXOe9LJuSb?=
 =?us-ascii?Q?oAu9Lnz8UpZhuzOu5V8WrqlxBy8tqRvGpaHI15DJWcKrn7gYUMxXDgUX3exG?=
 =?us-ascii?Q?k6bMLszhBxBjPTzx6YVkp1tBjIHjC7SNMin9FBfS?=
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
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1801MB1918.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca0323d9-6da4-44bf-c28a-08db576091f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 05:27:27.9521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T+oDY6D9n/qD9SlRVT/0I7ARUY1/CaRJJ3Rv8uzCZyCc1FpP5ClTWFf6VFzYHHcUUwj/L3UbyinyBW+W3GIB7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3272
X-Proofpoint-GUID: HLgI4cLlmlQDVPc3ZFeKD-aXvy6c73WG
X-Proofpoint-ORIG-GUID: HLgI4cLlmlQDVPc3ZFeKD-aXvy6c73WG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_03,2023-05-17_02,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, May 18, 2023 9:17 AM
> To: Ratheesh Kannoth <rkannoth@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sunil Kovvuri
> Goutham <sgoutham@marvell.com>; davem@davemloft.net;
> edumazet@google.com; pabeni@redhat.com; Subbaraya Sundeep Bhatta
> <sbhatta@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>;
> Srujana Challa <schalla@marvell.com>; Hariprasad Kelam
> <hkelam@marvell.com>
> Subject: [EXT] Re: [PATH net-next v1] octeontx2-pf: Add support for page
> pool
> On Wed, 17 May 2023 09:45:11 +0530 Ratheesh Kannoth wrote:
> > Page pool for each rx queue enhance rx side performance by reclaiming
> > buffers back to each queue specific pool. DMA mapping is done only for
> > first allocation of buffers.
> > As subsequent buffers allocation avoid DMA mapping, it results in
> > performance improvement.
> >
> > Image        |  Performance with Linux kernel Packet Generator
> > ------------ | -----------------------------------------------
> > Vannila      |   3Mpps
> >              |
> > with this    |   42Mpps
> > change	     |
> > ----------------------------------------------------------------
> >
> > Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> >
>=20
> Put an extra --- here, to place the change log outside the normal commit
> message.
Okay.=20

>=20
> > ChangeLog
> > v0 -> v1: Removed CONFIG_PAGE_POOL #ifdefs in code
> > 	  Used compound page APIs
> > 	  Replaced page_pool_put_page API with page_pool_put_full_page
> API
>=20
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > index f9286648e45c..49df1876eca3 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > @@ -518,11 +518,36 @@ void otx2_config_irq_coalescing(struct otx2_nic
> *pfvf, int qidx)
> >  		     (pfvf->hw.cq_ecount_wait - 1));  }
> >
> > +static int otx2_alloc_pool_buf(struct otx2_nic *pfvf, struct otx2_pool
> *pool,
> > +			       dma_addr_t *dma)
> > +{
> > +	unsigned int offset =3D 0;
> > +	struct page *page;
> > +	size_t sz;
> > +
> > +	sz =3D SKB_DATA_ALIGN(pool->rbsize);
> > +	sz =3D ALIGN(sz, OTX2_ALIGN);
> > +
> > +	page =3D page_pool_alloc_frag(pool->page_pool, &offset, sz,
> > +				    (in_interrupt() ? GFP_ATOMIC :
> GFP_KERNEL) |
>=20
> in_interrupt() should not be used in drivers, AFAIR.
Okay.=20

> Pass the correct flags from the caller (or don't -- it seems like the onl=
y caller
> assumes softirq context already).
I agree. Will Remove GFP_KERNEL.

>=20
> > +				    GFP_DMA);
>=20
> GFP_DMA? Why?
No need. Will Remove.=20

>=20
> > +	if (unlikely(!page)) {
> > +		netdev_err(pfvf->netdev, "Allocation of page pool
> failed\n");
>=20
> No prints on allocation errors, please, it only adds stress to the system=
. You
> can add a statistic if you want.
>=20
> > +		return -ENOMEM;
> > +	}
> > +
> > +	*dma =3D page_pool_get_dma_addr(page) + offset;
> > +	return 0;
> > +}
>=20
> > +	pp_params.flags =3D PP_FLAG_PAGE_FRAG | PP_FLAG_DMA_MAP;
> > +	pp_params.pool_size =3D numptrs;
> > +	pp_params.nid =3D NUMA_NO_NODE;
> > +	pp_params.dev =3D pfvf->dev;
> > +	pp_params.dma_dir =3D DMA_FROM_DEVICE;
> > +	pool->page_pool =3D page_pool_create(&pp_params);
> > +	if (!pool->page_pool) {
> > +		netdev_err(pfvf->netdev, "Creation of page pool failed\n");
> > +		return -EFAULT;
>=20
> EFAULT =3D=3D "Bad address", doesn't sound right
Agree. Will fix to return correct err code.=20

>=20
> > +	}
> > +
> >  	return 0;
> >  }
> --
> pw-bot: cr

