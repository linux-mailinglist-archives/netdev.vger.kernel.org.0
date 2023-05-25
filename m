Return-Path: <netdev+bounces-5378-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74E12710F8A
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA79B1C20E8F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D80E19517;
	Thu, 25 May 2023 15:27:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A05182C1
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:27:21 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BB5A3
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:27:19 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34PA2TjB020237;
	Thu, 25 May 2023 08:27:09 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qt5jnh9q1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 May 2023 08:27:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6Y/dXy1wgNzzbpoYEip3Pagz2TjsqEQEacNPTS1Hz1aBwVs//2j3E4nlBJNI6y738U+5EGjolm5uxCbr5sve3Y6MY+b0TF9m+ytDgkvUuu2Fi8xv3qMbwrdr0dTTlgxX/jia+uXfUV5DhGxHbEv9cxznhOo9ai24Cza3D21D6kfj5Kv4cHcfkyfYWSrtYmowo+ou4zTayWbQi2uo/ETb6Bhu0UINHUaD3hzVwbwF+cjBr+OJAhQPGtvoDYr+xVc6IKf3FdBji306p8EX9IELWjbSGut418TfJSGegHCpntJabCVMq5mkyyy4FfNmg2tejNCv8U76548mtsA2vqMww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=usDzLPH7kEyPYn1yc7zpo8TusnIBNqNSWwAKS1Oz9Vw=;
 b=QKuwNSY2LfGMIRwmG0jtDrhwKi3QK7RiOLlQzpNptRL4IrNi5xp+VFaWdVqQYuvGCDiwG/qZ1WMixTWctwShkNbvqFXRQmPDy+Ee9+2C35+qyemkF45Si01EVLHfLx68ScZAZZbaOziQoYT0McyuXPYjSYEqKKHVi7S4iWvk32ijr73ikZF6o8R9MCLzc25QccoPTtKNp96mdNoqBOOGn27TDl00WUQsz5lefPAcTuedt+W5TcDFYMUdWBnOuHT9VeyK0rqotq5iMMJy6GxIA5AQqNnIrig60frI3kzheV9W9UbDR8lEZSAtZAwKjtGGGRXZmhUHD0glddVKYnCWRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=usDzLPH7kEyPYn1yc7zpo8TusnIBNqNSWwAKS1Oz9Vw=;
 b=ZIdEAYeYjzhKu7BTpYtxz16JnAIXJXhIfBWphPXpAvxG0BgTg5MNaSzGb/Qkh9JS4agQCVzrrKL9R9A+ZVDJ1nLANS4jxOBZtbOAev1SYqYUUGUPtfBOC0KtG7iJrVFmLaYdXJDFyHf3liIZrEwbCkC1zOqP6T3si3C1/ygf2nk=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by BN9PR18MB4236.namprd18.prod.outlook.com (2603:10b6:408:11a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Thu, 25 May
 2023 15:27:05 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::edc4:5d0d:f48b:a60a]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::edc4:5d0d:f48b:a60a%6]) with mapi id 15.20.6433.016; Thu, 25 May 2023
 15:27:05 +0000
From: Manish Chopra <manishc@marvell.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>, Alok Prasad
	<palok@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        David
 Miller <davem@davemloft.net>
Subject: RE: [EXT] Re: [PATCH v5 net] qede: Fix scheduling while atomic
Thread-Topic: [EXT] Re: [PATCH v5 net] qede: Fix scheduling while atomic
Thread-Index: AQHZjjNFhFV41b3vDkaKSHPnX+wSgq9pW38A
Date: Thu, 25 May 2023 15:27:03 +0000
Message-ID: 
 <BY3PR18MB4612A5906D64C3DBACFAAECDAB469@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20230523144235.672290-1-manishc@marvell.com>
 <ZG31gX7aVN1jRpn6@nanopsycho>
In-Reply-To: <ZG31gX7aVN1jRpn6@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbWFuaXNoY1xh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTk1ZWY5OTQ1LWZiMTAtMTFlZC1iNmQ5LWQ4Zjg4?=
 =?us-ascii?Q?MzVmNjc2YVxhbWUtdGVzdFw5NWVmOTk0Ni1mYjEwLTExZWQtYjZkOS1kOGY4?=
 =?us-ascii?Q?ODM1ZjY3NmFib2R5LnR4dCIgc3o9IjEzMTk0IiB0PSIxMzMyOTUwMjAxODUy?=
 =?us-ascii?Q?MDI4NTkiIGg9IjFDbW8vVDM1bEdsakZKZU52N3plSHUzUVNiZz0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQU40UEFB?=
 =?us-ascii?Q?Q3JzSGRZSFkvWkFhb3FQUmtETEQxeHFpbzlHUU1zUFhFWkFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUJ1RHdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRRUJBQUFBSTdxVHBBQ0FBUUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFa?=
 =?us-ascii?Q?QUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4QWNB?=
 =?us-ascii?Q?QmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQWdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBREFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
 =?us-ascii?Q?QUNlQUFBQWJRQmhBSElBZGdCbEFHd0FYd0J3QUhJQWJ3QnFBR1VBWXdCMEFG?=
 =?us-ascii?Q?OEFiZ0JoQUcwQVpRQnpBRjhBWXdCdkFHNEFaZ0JwQUdRQVpRQnVBSFFBYVFC?=
 =?us-ascii?Q?aEFHd0FYd0JoQUd3QWJ3QnVBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdFQWNn?=
 =?us-ascii?Q?QjJBR1VBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFBWHdCdUFHRUFiUUJsQUhN?=
 =?us-ascii?Q?QVh3QnlBR1VBY3dCMEFISUFhUUJqQUhRQVpRQmtBRjhBWVFCc0FHOEFiZ0Js?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHMEFZUUJ5QUhZQVpRQnNBRjhBY0FC?=
 =?us-ascii?Q?eUFHOEFhZ0JsQUdNQWRBQmZBRzRBWVFCdEFHVUFjd0JmQUhJQVpRQnpBSFFB?=
 =?us-ascii?Q?Y2dCcEFHTUFkQUJsQUdRQVh3Qm9BR1VBZUFCakFHOEFaQUJsQUhNQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBR0VBY2dCdEFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refthree: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFB?=
 =?us-ascii?Q?SUFBQUFBQUo0QUFBQnRBR0VBY2dCMkFHVUFiQUJzQUY4QVp3QnZBRzhBWndC?=
 =?us-ascii?Q?c0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUcw?=
 =?us-ascii?Q?QVlRQnlBSFlBWlFCc0FHd0FYd0J3QUhJQWJ3QnFBR1VBWXdCMEFGOEFZd0J2?=
 =?us-ascii?Q?QUdRQVpRQnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dB?=
 =?us-ascii?Q?YkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFBWHdCakFHOEFaQUJsQUhNQVh3QmtB?=
 =?us-ascii?Q?R2tBWXdCMEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBY0FCeUFHOEFh?=
 =?us-ascii?Q?Z0JsQUdNQWRBQmZBRzRBWVFCdEFHVUFjd0JmQUdNQWJ3QnVBR1lBYVFCa0FH?=
 =?us-ascii?Q?VUFiZ0IwQUdrQVlRQnNBRjhBYlFCaEFISUFkZ0JsQUd3QWJBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBSUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?RzBBWVFCeUFIWUFaUUJzQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4QWJn?=
 =?us-ascii?Q?QmhBRzBBWlFCekFGOEFZd0J2QUc0QVpnQnBBR1FBWlFCdUFIUUFhUUJoQUd3?=
 =?us-ascii?Q?QVh3QnRBR0VBY2dCMkFHVUFiQUJzQUY4QWJ3QnlBRjhBWVFCeUFHMEFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reffour: 
 =?us-ascii?Q?QUFBQUFBQUFBQVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNl?=
 =?us-ascii?Q?QUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFCakFIUUFY?=
 =?us-ascii?Q?d0J1QUdFQWJRQmxBSE1BWHdCakFHOEFiZ0JtQUdrQVpBQmxBRzRBZEFCcEFH?=
 =?us-ascii?Q?RUFiQUJmQUcwQVlRQnlBSFlBWlFCc0FHd0FYd0J2QUhJQVh3Qm5BRzhBYndC?=
 =?us-ascii?Q?bkFHd0FaUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdFQWNnQjJB?=
 =?us-ascii?Q?R1VBYkFCc0FGOEFjQUJ5QUc4QWFnQmxBR01BZEFCZkFHNEFZUUJ0QUdVQWN3?=
 =?us-ascii?Q?QmZBSElBWlFCekFIUUFjZ0JwQUdNQWRBQmxBR1FBWHdCdEFHRUFjZ0IyQUdV?=
 =?us-ascii?Q?QWJBQnNBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFB?=
 =?us-ascii?Q?QUFBQUFBQUFnQUFBQUFBbmdBQUFHMEFZUUJ5QUhZQVpRQnNBR3dBWHdCd0FI?=
 =?us-ascii?Q?SUFid0JxQUdVQVl3QjBBRjhBYmdCaEFHMEFaUUJ6QUY4QWNnQmxBSE1BZEFC?=
 =?us-ascii?Q?eUFHa0FZd0IwQUdVQVpBQmZBRzBBWVFCeUFIWUFaUUJzQUd3QVh3QnZBSElB?=
 =?us-ascii?Q?WHdCaEFISUFiUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSFFBWlFCeUFHMEFhUUJ1QUhV?=
 =?us-ascii?Q?QWN3QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dC?=
 =?us-ascii?Q?MkFHVUFiQUJzQUY4QWR3QnZBSElBWkFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUEiLz48L21ldGE+?=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4612:EE_|BN9PR18MB4236:EE_
x-ms-office365-filtering-correlation-id: 6c348288-07ca-4f2b-a4a9-08db5d347ecf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 2uB1CCckcL0DSsletE5QTfmlLFGKOfaODsnSbWHL9dqWolXjdNm8DDfBXnI9URoQ/9DWQRU5dvxtX5b8S1YQTVIYABC7zblc01TmWG8QGr/YaK7Wu9F9pskI31U/lya3QMzkaoM5xCfYg6wzP8EUfoNEabeKa+4ddkLQIpRX4g3AGZMsASriFwRbbyTF+2D77F9L35skwDGGSkIMLORx0OOz8R3Rq2aQGX+FE4RqXG5ikm3xUh9/vrgrR44GKe3Oe1609960Secn+4NlYniwG/MA35eoQu1DXRM5yMzY8o0ek1MCvQl3wPCpRK1tTPUqY8V82besmOmgK+vEf40/VMi9CnwpqPiErJBBqd1R9/xoc2MZ5F985247dHYKQfjtVkzFpmVA/3aLN4dsm9JHlwiVDnpN6GlEnGTA9CpoEfOqgkbRogF1s+XFbwLd8cif2eNiq9yN5lXDSYitN4LjZnJtEx4yVHn3E9Pqo25us1/EaT9ufWRWl6Eec5/ZO5HYhS5kqbeVIeybNWSbkFqcd3A0hAPEjeN7D0REJ7ucYGu1/PkV9mK7O0sotWWYyW7BSa1SlbpVwdwL3DnPOhiH9ZRc6H9JlkBmt1V3Q8EFCjEjXmTnVYe0YhUmQq3SSbwS
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(376002)(136003)(396003)(346002)(366004)(451199021)(64756008)(66446008)(76116006)(66946007)(6916009)(4326008)(66476007)(66556008)(316002)(54906003)(478600001)(7696005)(41300700001)(71200400001)(55016003)(186003)(33656002)(86362001)(122000001)(9686003)(6506007)(26005)(8936002)(8676002)(83380400001)(2906002)(30864003)(38070700005)(52536014)(53546011)(38100700002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?HxujhAIgKv+wS0AV5bw9amZ3uVyrLGnq9QvQR6CUE9rfKqyj3GlVL3ayRBz7?=
 =?us-ascii?Q?lKCzq2TL3jhmaW5FDg+sGNv5pau5O5BuTHMiDLJlBPrq2mVyu8grrNX5jve0?=
 =?us-ascii?Q?hxV8N64WR7W69+FcSf9x3hhzuOs0sxq8nA5AyMEFMjZdrxyPcPa5UMIzFZlu?=
 =?us-ascii?Q?kyCa7BTMccY3UL+asXoVqaVhNxwACfUOshOh1shvbk8kcrpJ4YigZnjBc/ZC?=
 =?us-ascii?Q?kPzS1OhE+Mf3P4e7na8/E6uUmYmplF99D2Fw5Qj14vMC/8aoGrZwMeS+8ABo?=
 =?us-ascii?Q?pmO6Y9bwitxLRipyzTxzqxi7XmI6wM0H34OKmyXpPokd0xVafqZs7g5CUPLe?=
 =?us-ascii?Q?7tnXglpH7e/1WOgOrUPfyj8ELDVNAwRIgAaHpo9wGZTVFNgM7G1WNuAuGRDe?=
 =?us-ascii?Q?+ImPI2EC/sDyVnKJJ4JvdHDr7ohcS3vYzxRmIPY6K72KWD8WkMltssPqkvKr?=
 =?us-ascii?Q?k9WDDM1XwDgKO8LD87lfJ/6EQa8iqQSpaJFd4wauTuI5P3ga8xB+XLPuPJKW?=
 =?us-ascii?Q?xhyFJ9vwuPiBxPQQ1qhlRMYDhOKLxj00H0jAsRsA2C8qvq3Uk1MgHyCIz2Go?=
 =?us-ascii?Q?oQIcLdJAbcoKuiXe9CF+o9YNcSju+nt6WXFuXQ+lIVhJBsRUk37lp5TYU3dh?=
 =?us-ascii?Q?oBz1dcx0c5Y4/GPYF75VP4JuP7ZMjHYbY7Y68YILSFQ13ps/OvpQirx+L00I?=
 =?us-ascii?Q?d2/NgYK4zG52ITxx45nk/vv7Kl0KktjRbGjtyD/AxdUAazwtBl6prAeER1WF?=
 =?us-ascii?Q?+39G52jP38m5m5JbPP8ACiadSnfSbfz22aNUe/roDZFLgyFIi3ZxE3M/wKG3?=
 =?us-ascii?Q?3bRipMBcbwaNwcfYYZS0wJif1nbdhKyvbSBBn7xKx3i+jO2dTqVSpS8sz0Y3?=
 =?us-ascii?Q?alkEJE7y7+ofJ83nC8y9LEC+g6fYIUYp88ypERKFtV1fKDVQUyvmZLB60P3S?=
 =?us-ascii?Q?Bo1jY5PsYJSpO5M+CpFvvJ7/2iNR1vWJDE2oMzHKHLbTNy5QQkgAM+nMUVuY?=
 =?us-ascii?Q?21eWqwqzdF/KBG56w7Xmgr9CBDiM+mw2T6R4+IkMrJDJGhXm7Z0fF4CgGxBf?=
 =?us-ascii?Q?K4DxQSU2uX1DC3DiQDvGEfeKZlFvfvU7XjOlqfXiRP53Fl/rjnl0D9l/hTOM?=
 =?us-ascii?Q?+0bCq6iF8o1AzKNmEuqNrCR85KJmfXusxtsz3eJuKvfJsGGwgzEtZ/TBvDZ3?=
 =?us-ascii?Q?Qg5lqBUcA27uhsQnQqEdoXDQGYY/YLpz37OIF3zqKGUy+UA+z3O/MW8syQPy?=
 =?us-ascii?Q?O/Z2s4S5flc0qrx06ICQFJrCO/PTIZ1TEp+pYLKA6WLTr2/GVbcVq6rx1g6S?=
 =?us-ascii?Q?yQABDFSVuxTMRjilSDBMzIXeSPQr2zBz+/liDbULpcEbqLsJ/ILN5NdTyumu?=
 =?us-ascii?Q?JyitdCj/kopdNLYebEb4bosBcsbJTpz1dXVazoxcZEVEw4hqRW1DmC9nEE1j?=
 =?us-ascii?Q?RjBMx5XzHMrI5SgTaUv1B1IrieSVhTIwLWa7o0q71HfEpyYZsBsTNFYeJoql?=
 =?us-ascii?Q?pUNzVDl6ohZAkLOCdO5mLHpmf7iQ7IBuqJuFmYyIwa9WkniGUNxBWQOSUEK3?=
 =?us-ascii?Q?yqaFI/odhu4JqFNYTVU=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c348288-07ca-4f2b-a4a9-08db5d347ecf
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2023 15:27:05.0166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JF7F+ng8g66Kg1JJDs4jCgha/eRKOI750LXBBtZdwEhjqd6H3q4rBXMH+lyWCuYnAoU2rU4hCUvDKjKZdg4Z7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR18MB4236
X-Proofpoint-ORIG-GUID: xN5kLO5U-kNWiLCGr7fgCKfpNJqKG2IA
X-Proofpoint-GUID: xN5kLO5U-kNWiLCGr7fgCKfpNJqKG2IA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-25_08,2023-05-25_03,2023-05-22_02
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jiri,

> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Wednesday, May 24, 2023 5:01 PM
> To: Manish Chopra <manishc@marvell.com>
> Cc: kuba@kernel.org; netdev@vger.kernel.org; Ariel Elior
> <aelior@marvell.com>; Alok Prasad <palok@marvell.com>; Sudarsana Reddy
> Kalluru <skalluru@marvell.com>; David Miller <davem@davemloft.net>
> Subject: [EXT] Re: [PATCH v5 net] qede: Fix scheduling while atomic
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Tue, May 23, 2023 at 04:42:35PM CEST, manishc@marvell.com wrote:
> >Bonding module collects the statistics while holding the spinlock,
> >beneath that qede->qed driver statistics flow gets scheduled out due to
> >usleep_range() used in PTT acquire logic which results into below bug
> >and traces -
> >
> >[ 3673.988874] Hardware name: HPE ProLiant DL365 Gen10 Plus/ProLiant
> >DL365 Gen10 Plus, BIOS A42 10/29/2021 [ 3673.988878] Call Trace:
> >[ 3673.988891]  dump_stack_lvl+0x34/0x44 [ 3673.988908]
> >__schedule_bug.cold+0x47/0x53 [ 3673.988918]  __schedule+0x3fb/0x560 [
> >3673.988929]  schedule+0x43/0xb0 [ 3673.988932]
> >schedule_hrtimeout_range_clock+0xbf/0x1b0
> >[ 3673.988937]  ? __hrtimer_init+0xc0/0xc0 [ 3673.988950]
> >usleep_range+0x5e/0x80 [ 3673.988955]  qed_ptt_acquire+0x2b/0xd0 [qed]
> >[ 3673.988981]  _qed_get_vport_stats+0x141/0x240 [qed] [ 3673.989001]
> >qed_get_vport_stats+0x18/0x80 [qed] [ 3673.989016]
> >qede_fill_by_demand_stats+0x37/0x400 [qede] [ 3673.989028]
> >qede_get_stats64+0x19/0xe0 [qede] [ 3673.989034]
> >dev_get_stats+0x5c/0xc0 [ 3673.989045]
> >netstat_show.constprop.0+0x52/0xb0
> >[ 3673.989055]  dev_attr_show+0x19/0x40 [ 3673.989065]
> >sysfs_kf_seq_show+0x9b/0xf0 [ 3673.989076]  seq_read_iter+0x120/0x4b0 [
> >3673.989087]  new_sync_read+0x118/0x1a0 [ 3673.989095]
> >vfs_read+0xf3/0x180 [ 3673.989099]  ksys_read+0x5f/0xe0 [ 3673.989102]
> >do_syscall_64+0x3b/0x90 [ 3673.989109]
> >entry_SYSCALL_64_after_hwframe+0x44/0xae
>=20
> You mention "bonding module" at the beginning of this description. Where
> exactly is that shown in the trace?
>=20
> I guess that the "spinlock" you talk about is "dev_base_lock", isn't it?

Bonding function somehow were not part of traces, but this is the flow from=
 bonding module
which calls dev_get_stats() under spin_lock_nested(&bond->stats_lock, nest_=
level) which results to this issue.

>=20
>=20
> >[ 3673.989115] RIP: 0033:0x7f8467d0b082 [ 3673.989119] Code: c0 e9 b2
> >fe ff ff 50 48 8d 3d ca 05 08 00 e8 35 e7 01 00 0f 1f 44 00 00 f3 0f 1e
> >fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56
> >c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24 [ 3673.989121] RSP:
> >002b:00007ffffb21fd08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000 [
> >3673.989127] RAX: ffffffffffffffda RBX: 000000000100eca0 RCX:
> >00007f8467d0b082 [ 3673.989128] RDX: 00000000000003ff RSI:
> >00007ffffb21fdc0 RDI: 0000000000000003 [ 3673.989130] RBP:
> 00007f8467b96028 R08: 0000000000000010 R09: 00007ffffb21ec00 [
> 3673.989132] R10: 00007ffffb27b170 R11: 0000000000000246 R12:
> 00000000000000f0 [ 3673.989134] R13: 0000000000000003 R14:
> 00007f8467b92000 R15: 0000000000045a05
> >[ 3673.989139] CPU: 30 PID: 285188 Comm: read_all Kdump: loaded
> Tainted: G        W  OE
> >
> >Fix this by collecting the statistics asynchronously from a periodic
> >delayed work scheduled at default stats coalescing interval and return
> >the recent copy of statisitcs from .ndo_get_stats64(), also add ability
> >to configure/retrieve stats coalescing interval using below commands -
> >
> >ethtool -C ethx stats-block-usecs <val> ethtool -c ethx
> >
> >Fixes: 133fac0eedc3 ("qede: Add basic ethtool support")
> >Cc: Sudarsana Kalluru <skalluru@marvell.com>
> >Cc: David Miller <davem@davemloft.net>
> >Signed-off-by: Manish Chopra <manishc@marvell.com>
> >---
> >v1->v2:
> > - Fixed checkpatch and kdoc warnings.
> >v2->v3:
> > - Moving the changelog after tags.
> >v3->v4:
> > - Changes to collect stats periodically using delayed work
> >   and add ability to configure/retrieve stats coalescing
> >   interval using ethtool
> > - Modified commit description to reflect the changes
> >v4->v5:
> > - Renamed the variables (s/ticks/usecs and s/interval/ticks)
> > - Relaxed the stats usecs coalescing configuration to allow
> >   user to set any range of values and also while getting return
> >   the exact value configured
> > - Usage of usecs_to_jiffies() wherever applicable
> > - Cosmetic change for logs/comments
> >---
> > drivers/net/ethernet/qlogic/qede/qede.h       |  4 +++
> > .../net/ethernet/qlogic/qede/qede_ethtool.c   | 26 ++++++++++++--
> > drivers/net/ethernet/qlogic/qede/qede_main.c  | 35 ++++++++++++++++++-
> > 3 files changed, 62 insertions(+), 3 deletions(-)
> >
> >diff --git a/drivers/net/ethernet/qlogic/qede/qede.h
> >b/drivers/net/ethernet/qlogic/qede/qede.h
> >index f90dcfe9ee68..8a63f99d499c 100644
> >--- a/drivers/net/ethernet/qlogic/qede/qede.h
> >+++ b/drivers/net/ethernet/qlogic/qede/qede.h
> >@@ -271,6 +271,10 @@ struct qede_dev {
> > #define QEDE_ERR_WARN			3
> >
> > 	struct qede_dump_info		dump_info;
> >+	struct delayed_work		periodic_task;
> >+	unsigned long			stats_coal_ticks;
> >+	u32				stats_coal_usecs;
> >+	spinlock_t			stats_lock; /* lock for vport stats
> access */
> > };
> >
> > enum QEDE_STATE {
> >diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> >b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> >index 8284c4c1528f..a6498eb7cbd7 100644
> >--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> >+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> >@@ -426,6 +426,8 @@ static void qede_get_ethtool_stats(struct net_device
> *dev,
> > 		}
> > 	}
> >
> >+	spin_lock(&edev->stats_lock);
> >+
> > 	for (i =3D 0; i < QEDE_NUM_STATS; i++) {
> > 		if (qede_is_irrelevant_stat(edev, i))
> > 			continue;
> >@@ -435,6 +437,8 @@ static void qede_get_ethtool_stats(struct net_device
> *dev,
> > 		buf++;
> > 	}
> >
> >+	spin_unlock(&edev->stats_lock);
> >+
> > 	__qede_unlock(edev);
> > }
> >
> >@@ -817,6 +821,7 @@ static int qede_get_coalesce(struct net_device
> >*dev,
> >
> > 	coal->rx_coalesce_usecs =3D rx_coal;
> > 	coal->tx_coalesce_usecs =3D tx_coal;
> >+	coal->stats_block_coalesce_usecs =3D edev->stats_coal_usecs;
> >
> > 	return rc;
> > }
> >@@ -830,6 +835,21 @@ int qede_set_coalesce(struct net_device *dev,
> struct ethtool_coalesce *coal,
> > 	int i, rc =3D 0;
> > 	u16 rxc, txc;
> >
> >+	if (edev->stats_coal_usecs !=3D coal->stats_block_coalesce_usecs) {
> >+		bool stats_coal_enabled;
> >+
> >+		stats_coal_enabled =3D edev->stats_coal_usecs ? true : false;
> >+
> >+		edev->stats_coal_usecs =3D coal->stats_block_coalesce_usecs;
> >+		edev->stats_coal_ticks =3D
> >+usecs_to_jiffies(coal->stats_block_coalesce_usecs);
> >+
> >+		if (!stats_coal_enabled)
> >+			schedule_delayed_work(&edev->periodic_task, 0);
>=20
> What is the point of schedule here? Don't you want to rather schedule if
> (stats_coal_enabled =3D=3D true) ??

This was for scheduling of periodic task ONLY if previously it was disabled=
.
But actually it does not harm to schedule once always whenever user sets a =
non-zero usecs.

>=20
>=20
> >+
> >+		DP_INFO(edev, "Configured stats coal ticks=3D%lu jiffies\n",
> >+			edev->stats_coal_ticks);
> >+	}
> >+
> > 	if (!netif_running(dev)) {
> > 		DP_INFO(edev, "Interface is down\n");
> > 		return -EINVAL;
> >@@ -2236,7 +2256,8 @@ static int qede_get_per_coalesce(struct
> >net_device *dev,  }
> >
> > static const struct ethtool_ops qede_ethtool_ops =3D {
> >-	.supported_coalesce_params	=3D ETHTOOL_COALESCE_USECS,
> >+	.supported_coalesce_params	=3D ETHTOOL_COALESCE_USECS |
> >+
> ETHTOOL_COALESCE_STATS_BLOCK_USECS,
> > 	.get_link_ksettings		=3D qede_get_link_ksettings,
> > 	.set_link_ksettings		=3D qede_set_link_ksettings,
> > 	.get_drvinfo			=3D qede_get_drvinfo,
> >@@ -2287,7 +2308,8 @@ static const struct ethtool_ops qede_ethtool_ops
> >=3D {  };
> >
> > static const struct ethtool_ops qede_vf_ethtool_ops =3D {
> >-	.supported_coalesce_params	=3D ETHTOOL_COALESCE_USECS,
> >+	.supported_coalesce_params	=3D ETHTOOL_COALESCE_USECS |
> >+
> ETHTOOL_COALESCE_STATS_BLOCK_USECS,
> > 	.get_link_ksettings		=3D qede_get_link_ksettings,
> > 	.get_drvinfo			=3D qede_get_drvinfo,
> > 	.get_msglevel			=3D qede_get_msglevel,
> >diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c
> >b/drivers/net/ethernet/qlogic/qede/qede_main.c
> >index 06c6a5813606..61cc10968988 100644
> >--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> >+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> >@@ -308,6 +308,8 @@ void qede_fill_by_demand_stats(struct qede_dev
> >*edev)
> >
> > 	edev->ops->get_vport_stats(edev->cdev, &stats);
> >
> >+	spin_lock(&edev->stats_lock);
> >+
> > 	p_common->no_buff_discards =3D stats.common.no_buff_discards;
> > 	p_common->packet_too_big_discard =3D
> stats.common.packet_too_big_discard;
> > 	p_common->ttl0_discard =3D stats.common.ttl0_discard; @@ -405,6
> +407,8
> >@@ void qede_fill_by_demand_stats(struct qede_dev *edev)
> > 		p_ah->tx_1519_to_max_byte_packets =3D
> > 		    stats.ah.tx_1519_to_max_byte_packets;
> > 	}
> >+
> >+	spin_unlock(&edev->stats_lock);
> > }
> >
> > static void qede_get_stats64(struct net_device *dev, @@ -413,9 +417,10
> >@@ static void qede_get_stats64(struct net_device *dev,
> > 	struct qede_dev *edev =3D netdev_priv(dev);
> > 	struct qede_stats_common *p_common;
> >
> >-	qede_fill_by_demand_stats(edev);
> > 	p_common =3D &edev->stats.common;
> >
> >+	spin_lock(&edev->stats_lock);
> >+
> > 	stats->rx_packets =3D p_common->rx_ucast_pkts + p_common-
> >rx_mcast_pkts +
> > 			    p_common->rx_bcast_pkts;
> > 	stats->tx_packets =3D p_common->tx_ucast_pkts + p_common-
> >tx_mcast_pkts
> >+ @@ -435,6 +440,8 @@ static void qede_get_stats64(struct net_device
> *dev,
> > 		stats->collisions =3D edev->stats.bb.tx_total_collisions;
> > 	stats->rx_crc_errors =3D p_common->rx_crc_errors;
> > 	stats->rx_frame_errors =3D p_common->rx_align_errors;
> >+
> >+	spin_unlock(&edev->stats_lock);
> > }
> >
> > #ifdef CONFIG_QED_SRIOV
> >@@ -1000,6 +1007,21 @@ static void qede_unlock(struct qede_dev *edev)
> > 	rtnl_unlock();
> > }
> >
> >+static void qede_periodic_task(struct work_struct *work) {
> >+	struct qede_dev *edev =3D container_of(work, struct qede_dev,
> >+					     periodic_task.work);
> >+
> >+	if (test_bit(QEDE_SP_DISABLE, &edev->sp_flags))
> >+		return;
> >+
> >+	if (edev->stats_coal_usecs) {
>=20
> Why don't you cancel the work when you don't want this to happen?

Ok.
 =20
>=20
>=20
> >+		qede_fill_by_demand_stats(edev);
> >+		schedule_delayed_work(&edev->periodic_task,
> >+				      edev->stats_coal_ticks);
> >+	}
> >+}
> >+
> > static void qede_sp_task(struct work_struct *work)  {
> > 	struct qede_dev *edev =3D container_of(work, struct qede_dev, @@
> >-1208,7 +1230,9 @@ static int __qede_probe(struct pci_dev *pdev, u32
> dp_module, u8 dp_level,
> > 		 * from there, although it's unlikely].
> > 		 */
> > 		INIT_DELAYED_WORK(&edev->sp_task, qede_sp_task);
> >+		INIT_DELAYED_WORK(&edev->periodic_task,
> qede_periodic_task);
> > 		mutex_init(&edev->qede_lock);
> >+		spin_lock_init(&edev->stats_lock);
> >
> > 		rc =3D register_netdev(edev->ndev);
> > 		if (rc) {
> >@@ -1233,6 +1257,11 @@ static int __qede_probe(struct pci_dev *pdev,
> u32 dp_module, u8 dp_level,
> > 	edev->rx_copybreak =3D QEDE_RX_HDR_SIZE;
> >
> > 	qede_log_probe(edev);
> >+
> >+	edev->stats_coal_usecs =3D USEC_PER_SEC;
> >+	edev->stats_coal_ticks =3D usecs_to_jiffies(USEC_PER_SEC);
> >+	schedule_delayed_work(&edev->periodic_task, 0);
> >+
> > 	return 0;
> >
> > err4:
> >@@ -1301,6 +1330,7 @@ static void __qede_remove(struct pci_dev *pdev,
> enum qede_remove_mode mode)
> > 		unregister_netdev(ndev);
> >
> > 		cancel_delayed_work_sync(&edev->sp_task);
> >+		cancel_delayed_work_sync(&edev->periodic_task);
> >
> > 		edev->ops->common->set_power_state(cdev, PCI_D0);
> >
> >@@ -2571,6 +2601,9 @@ static void qede_recovery_handler(struct
> qede_dev
> >*edev)
> >
> > 	DP_NOTICE(edev, "Starting a recovery process\n");
> >
> >+	/* disable periodic stats */
> >+	edev->stats_coal_usecs =3D 0;
>=20
> You disable but never enable again. Why?
>=20

It's getting enabled back when recovery flow completes in below part of cha=
nges in the patch.

+	edev->stats_coal_usecs =3D USEC_PER_SEC;
+	edev->stats_coal_ticks =3D usecs_to_jiffies(USEC_PER_SEC);
+	schedule_delayed_work(&edev->periodic_task, 0);

Although on reset I am resetting values to default load values but maybe I =
will cleanup here to retain ethtool set values.

> Also, why don't you do:
> cancel_delayed_work_sync(&edev->periodic_task)
> here instead?
>=20

Sure.

>=20
> >+
> > 	/* No need to acquire first the qede_lock since is done by
> qede_sp_task
> > 	 * before calling this function.
> > 	 */
> >--
> >2.27.0
> >
> >

