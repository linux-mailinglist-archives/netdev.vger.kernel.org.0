Return-Path: <netdev+bounces-1411-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C16BD6FDB2F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9295A2813A1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D63B613D;
	Wed, 10 May 2023 09:57:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431B36139
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:57:57 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797E15583
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:57:53 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34A59Pr0006585;
	Wed, 10 May 2023 02:57:39 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3qf77s5w7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 02:57:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jb0dMbdFpXlpUmXsi9+ksfgddmj/HKDBeSPHMuJlGU1ke5iikEzIpjqRbXcr6+6wA8AdGWYDq1pRDRbzgUoykgZ5+yxW9Mm0XBUui3aph9xywI1JYXMxwEh7CDbJbfiEmbSSL4ZmlfNN7bJ/noa9aiE3MD/yABGA7/GbslICH9JUBf+jS94ucridqpGhQMQaNinmDRUUsTrpOxs4eGdAgzPyZqE5RZ69DD/dduRqVzZUNwFFgPcJXs057nc02STSdqJZB/6sePaoZPHYJLT5GKy5ZdKCQDZ3CAmzDn+FkmgeMc8EtRAv5xy8tFDR1sz5WBvcSWDgzNrIAzltvOW0Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f6qnClrr04Cd26YVnIk3hbt5OaQVuPPK+HG8FIgWTwA=;
 b=lw398/58pRTgyAk+4QWz/axRk9l1NVoa88aRrwGFVgWAfEJYqGsQiJPa/n1ow0fafapLEuTs1BW6MorT5LA0ZRUeoR4iB4WVYm1jjkipBsL4UKTiODHC3WBCUi4zFvv13XFb1xNfAm2p3z5Ug91uCmHlwVxAIZP6rzFypqIaMvtDJEv64DLci+Vwlgk/GAh+JG+X4BmHJFBasxtAYYeCawpzc8p2koXV/SQ1VVmXqh5R0DaVERAB6Ud4rf7a38vCQvcdXWPvp10VEg9Fr/YTw4BQLbUxS7pgEjsFUe2QSGMLKRXV39JPuk87+vaKbTR884vaMNznp+Xc5RqAZcrnOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6qnClrr04Cd26YVnIk3hbt5OaQVuPPK+HG8FIgWTwA=;
 b=qPbEdLuhp7WJ8Sh89CMdORrG1z0E8w494r0s3HHtg+UW8LasQ5G0QsyrFB0AoHuGH0oLiwva+l+D0f/ccRr1lOGDfp/1SnxC7e9BDFN1NZSE+m0ajJiEPs+fnu98uwFY43l6797pcF/TObc7xHT11OU8k8csCic9KTiJvasQOx8=
Received: from BN9PR18MB4251.namprd18.prod.outlook.com (2603:10b6:408:11c::10)
 by CH2PR18MB3398.namprd18.prod.outlook.com (2603:10b6:610:2c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Wed, 10 May
 2023 09:57:36 +0000
Received: from BN9PR18MB4251.namprd18.prod.outlook.com
 ([fe80::ad33:f4a1:f323:2a0d]) by BN9PR18MB4251.namprd18.prod.outlook.com
 ([fe80::ad33:f4a1:f323:2a0d%3]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 09:57:36 +0000
From: Elad Nachman <enachman@marvell.com>
To: Ido Schimmel <idosch@nvidia.com>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org"
	<bridge@lists.linux-foundation.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org"
	<kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "razor@blackwall.org"
	<razor@blackwall.org>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com"
	<xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "taspelund@nvidia.com"
	<taspelund@nvidia.com>
Subject: RE: [EXT] [RFC PATCH net-next 3/5] flow_offload: Reject matching on
 layer 2 miss
Thread-Topic: [EXT] [RFC PATCH net-next 3/5] flow_offload: Reject matching on
 layer 2 miss
Thread-Index: AQHZgkT3dMzzK3y9JE6DR4sgrX7HGa9TRq2w
Date: Wed, 10 May 2023 09:57:36 +0000
Message-ID: 
 <BN9PR18MB42515532FEB4A498D39AB073DB779@BN9PR18MB4251.namprd18.prod.outlook.com>
References: <20230509070446.246088-1-idosch@nvidia.com>
 <20230509070446.246088-4-idosch@nvidia.com>
In-Reply-To: <20230509070446.246088-4-idosch@nvidia.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcZW5hY2htYW5c?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy0xNjA4MGZlOC1lZjE5LTExZWQtYjczYi0xOGNj?=
 =?us-ascii?Q?MTg3OGFiYThcYW1lLXRlc3RcMTYwODBmZWEtZWYxOS0xMWVkLWI3M2ItMThj?=
 =?us-ascii?Q?YzE4NzhhYmE4Ym9keS50eHQiIHN6PSI0NzQ5IiB0PSIxMzMyODE4NjI1NTEz?=
 =?us-ascii?Q?MTAwMzAiIGg9InU3UkY1VmF4VmRPOTAzUTI1b1RwdEZFUG5Laz0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUdZTkFB?=
 =?us-ascii?Q?RE9qbC9ZSllQWkFhU1FwQmRaWTRiSXBKQ2tGMWxqaHNnVkFBQUFBQUFBQUFB?=
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
x-dg-rorf: true
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBRVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
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
 QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhjQWJ3QnlBR1FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUZBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFBPT0iLz48L21ldGE+
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR18MB4251:EE_|CH2PR18MB3398:EE_
x-ms-office365-filtering-correlation-id: 37f16b30-d486-4edf-cb5b-08db513cfbb2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 7dg1DPLc3l1pKSL8YxWCYZbhCljIzg34QPBYeJt1xoU7BIEP0Q1iQjQdYlZnu6JBHsvPMK/SknB1sUH0g9Bx07f9sL4DGvFO4bPoDLhrl9Udv1ddMRW8VJWZSHlVpdwW7W1ZWudVWYgqwkz3CBInD3UhnoQ8PLqXgTb/Z6lDquImheNpw+PYE8ZNYF8m5SBu7QcjITe6L+CgwRhK2evsw8NZL8c5tcj3omC0kKDsxTKPgXzOEGQZpQw8PsMQb7Aw02G5YUhEo8NMou3ZL8TlQX+jt1LhNK8HicypO5HcZ2vhW7F8BJOsasuoX9V03ncgUVKjEOeInOXX/2f2z2rZvBn9cbRA/HoD0KMcEb2lGK6Ru4Vu5hNvrjdeqy9gPCkMEWvUUvE0PGWED+limwRKFmB3kYt77QYMjm2k59NbgdxqCoL81bxzmAJR9nurumVEzOpmiXwKQKS52E7GRjWi2ywWJ3Uqbio1qMt8vjuIGIejpGrdZwYnRuuCDDTgeR3xoCzK2P+DHn+dY/4OkOrFxeQLHObQ4r1I/fSbFg6qeNpiCXQZQllprcfNQ+1EHqrwZ6ISVKl5vH/Yc+Yh6q6i7ae5ksGTubBoS/7JvkgAAAzR2+EEHrBK6yy4izSjhiXQ
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR18MB4251.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(451199021)(52536014)(5660300002)(316002)(478600001)(7416002)(54906003)(41300700001)(122000001)(83380400001)(110136005)(66556008)(66476007)(66446008)(66946007)(76116006)(64756008)(4326008)(38100700002)(8936002)(8676002)(38070700005)(6506007)(9686003)(26005)(53546011)(33656002)(86362001)(186003)(55016003)(2906002)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?l9HkrEV9E9BVhLnM2gFNUxLqvtpp8darnxrjgzssE9hmKvfRIxitNypRWIox?=
 =?us-ascii?Q?BTUq4Wd/IANuavox1Nwntem2o8i5G3Y6UVlZAeuEiVl1EPzV1nSu1H2oSUs9?=
 =?us-ascii?Q?4RaMhlvisynb5fA4gNrohvPewwlxAPNvVcHxsZ8QndZy0xjV9cllNJ+nO6iO?=
 =?us-ascii?Q?S975WdJ++e2ED63uHbvZEwwBnWaqq7NG7Lp2U2CGo1hGeIGrvCK5+twaKON2?=
 =?us-ascii?Q?SUEwWwwK0IsW+oolS+fHbc4mW/18aN+OYgGp4rh7MTfYmy2TCOfIs6+BJwko?=
 =?us-ascii?Q?g6PGB675kRdWKPgv04Fxqon7IdkO3nHKMcNqCZujOvwGPhBAHlnQN5fHBcOq?=
 =?us-ascii?Q?k9cAM5G5IlwNRlet2uEHb9zT+9r+NIOcRS4ELGW6yVRP2+2a0HbvrM5aPgir?=
 =?us-ascii?Q?MCmaTklIjO/7GiB9CpjXwSotnq/iiP6fjk23Uo1CQIv3ZU1wk/OHvx8I4tWI?=
 =?us-ascii?Q?UaNuQi80pMH+lQZu1nEwYuHwQbLfIKxqYGN62628O7tpjfKswJKEbMth66EP?=
 =?us-ascii?Q?SOOi/SNEtqYbvAH73XqtZUU/nRvxQ583sNz34tXsQgM4zdtTtuGISN0nHR2e?=
 =?us-ascii?Q?/ImfMdSE2z1q9Rwb1HNcFRCfMNTPeT1Fk5dCA2Vn898mhSAQD2TqcPayyE/9?=
 =?us-ascii?Q?5PjblXN6Ri3MUWerM/Fb7pGqq6SaFYs1CHyy0gduK+RQ/B4JI8sh7r6g4gg+?=
 =?us-ascii?Q?Kk1MIVdPmH6QM+wbV1AwNkK82OXXTNpuQV+wX5w5kD4sivQ/lxKnav2V5YCJ?=
 =?us-ascii?Q?r2DiD4eXkdLYKAt6EKmvkSSots8tBbIcvRa94pPLMNASRIl1k5pu/u+Q+vL7?=
 =?us-ascii?Q?2aEONpUd9zRqKCLv25OPWWCSH5fKu9JH9gpWEfg34rNz+y9U3grw28+DnS9L?=
 =?us-ascii?Q?xWk3lKROS1jY89VV46VCGaW6iEDmnhBtiOdXB9Mooj3S+MgbfSq5I4TgnBcp?=
 =?us-ascii?Q?O48gXhyC97VeNCmkQhhbCI7HQypnE6oUL33qjyEyfS2Jv9L4R8nw3eOFzi5d?=
 =?us-ascii?Q?CvkFtjWCxIhRPjz1Z7ATdxeJczBtMaFFR+ziID/33AF4318eHYGcSc3wldA/?=
 =?us-ascii?Q?PqudFz2Pr7XU+pSVPYOHAwN3NmJST4Y2HjVmRwsGCQ2PfhJDq1DZGIHWPuPy?=
 =?us-ascii?Q?Lhx3PuM8DXElRpMVaTdT9PFLpHw4n4h6b9eXRbpE1psFCrj6X2f3NTMjHoFH?=
 =?us-ascii?Q?Lz/7lm8N1FaJ9bHlKNeo0cPS4x1QXyB7JYokUO5oA7k4/aW+6ZancOhD1NfB?=
 =?us-ascii?Q?3jKb1l2IJtcKqv0SycLkWbRfsD4YeHydY0Fg+HM72WEzgMYPbZor1yAMR0ii?=
 =?us-ascii?Q?iZl8QO44Gzo8HBG5k+acVgUCkrJ9LoBIXfNGAxwlMiHj72gbGqc0Gs1HJY7v?=
 =?us-ascii?Q?BThHapeMaGzgqRIwUPduXogTJvKNEJBtB+kEpPxYR7k19oXgpqXSYyf3FHFP?=
 =?us-ascii?Q?A3vZbmFqFyYKxCc/94rM0SKln+pwUw7qAuAbbo59isbEi/xpESkadIIUDVtE?=
 =?us-ascii?Q?ll7aBSvo75aYArB1O/F7sebP72pSXSGPqSGq8smS17QV2pmCAtD1+nF+viOL?=
 =?us-ascii?Q?wLGkrLRFZFVoStu6i+XdED9GKYE3oN0ZsZeS6J4L?=
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
X-MS-Exchange-CrossTenant-AuthSource: BN9PR18MB4251.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37f16b30-d486-4edf-cb5b-08db513cfbb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 09:57:36.5666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z4c8R5UIc2XjMIyErj7hiDMVDNcEiGT6YNxCSyRFGTPnGBLY7UtAynRLV8cvsTHvQS15LqQWP/xuartsii51yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3398
X-Proofpoint-ORIG-GUID: XREHvIesnU_4JlpEhv3DEtFFoNcSvzW7
X-Proofpoint-GUID: XREHvIesnU_4JlpEhv3DEtFFoNcSvzW7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Ido Schimmel <idosch@nvidia.com>
> Sent: Tuesday, May 9, 2023 10:05 AM
> To: netdev@vger.kernel.org; bridge@lists.linux-foundation.org
> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> edumazet@google.com; razor@blackwall.org; roopa@nvidia.com;
> jhs@mojatatu.com; xiyou.wangcong@gmail.com; jiri@resnulli.us;
> petrm@nvidia.com; taspelund@nvidia.com; Ido Schimmel
> <idosch@nvidia.com>
> Subject: [EXT] [RFC PATCH net-next 3/5] flow_offload: Reject matching on
> layer 2 miss
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Adjust drivers that support the 'FLOW_DISSECTOR_KEY_META' key to reject
> filters that try to match on the newly added layer 2 miss option. Add an
> extack message to clearly communicate the failure reason to user space.
>=20
> Example:
>=20
>  # tc filter add dev swp1 egress pref 1 proto all flower skip_sw l2_miss =
true
> action drop
>  Error: mlxsw_spectrum: Can't match on "l2_miss".
>  We have an error talking to the kernel
>=20
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  .../net/ethernet/marvell/prestera/prestera_flower.c    |  6 ++++++
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c        |  6 ++++++
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c  |  6 ++++++
>  drivers/net/ethernet/mscc/ocelot_flower.c              | 10 ++++++++++
>  4 files changed, 28 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> index 91a478b75cbf..3e20e71b0f81 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> @@ -148,6 +148,12 @@ static int prestera_flower_parse_meta(struct
> prestera_acl_rule *rule,
>  	__be16 key, mask;
>=20
>  	flow_rule_match_meta(f_rule, &match);
> +
> +	if (match.mask->l2_miss) {
> +		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't match on
> \"l2_miss\"");
> +		return -EOPNOTSUPP;
> +	}
> +
>  	if (match.mask->ingress_ifindex !=3D 0xFFFFFFFF) {
>  		NL_SET_ERR_MSG_MOD(f->common.extack,
>  				   "Unsupported ingress ifindex mask"); diff --
> git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 728b82ce4031..516653568330 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -2586,6 +2586,12 @@ static int mlx5e_flower_parse_meta(struct
> net_device *filter_dev,
>  		return 0;
>=20
>  	flow_rule_match_meta(rule, &match);
> +
> +	if (match.mask->l2_miss) {
> +		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't match on
> \"l2_miss\"");
> +		return -EOPNOTSUPP;
> +	}
> +
>  	if (!match.mask->ingress_ifindex)
>  		return 0;
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> index 594cdcb90b3d..6fec9223250b 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> @@ -294,6 +294,12 @@ static int mlxsw_sp_flower_parse_meta(struct
> mlxsw_sp_acl_rule_info *rulei,
>  		return 0;
>=20
>  	flow_rule_match_meta(rule, &match);
> +
> +	if (match.mask->l2_miss) {
> +		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't match on
> \"l2_miss\"");
> +		return -EOPNOTSUPP;
> +	}
> +
>  	if (match.mask->ingress_ifindex !=3D 0xFFFFFFFF) {
>  		NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported
> ingress ifindex mask");
>  		return -EINVAL;
> diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c
> b/drivers/net/ethernet/mscc/ocelot_flower.c
> index ee052404eb55..e0916afcddfb 100644
> --- a/drivers/net/ethernet/mscc/ocelot_flower.c
> +++ b/drivers/net/ethernet/mscc/ocelot_flower.c
> @@ -592,6 +592,16 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int
> port, bool ingress,
>  		return -EOPNOTSUPP;
>  	}
>=20
> +	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META)) {
> +		struct flow_match_meta match;
> +
> +		flow_rule_match_meta(rule, &match);
> +		if (match.mask->l2_miss) {
> +			NL_SET_ERR_MSG_MOD(extack, "Can't match on
> \"l2_miss\"");
> +			return -EOPNOTSUPP;
> +		}
> +	}
> +
>  	/* For VCAP ES0 (egress rewriter) we can match on the ingress port
> */
>  	if (!ingress) {
>  		ret =3D ocelot_flower_parse_indev(ocelot, port, f, filter);
> --
> 2.40.1
>=20

I have reviewed the prestera part. Looks straightforward enough.

Acked-by: Elad Nachman <enachman@marvell.com>


