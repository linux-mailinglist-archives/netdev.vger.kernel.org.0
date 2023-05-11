Return-Path: <netdev+bounces-1664-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 617746FEB4E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36A221C20ED7
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 05:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C587A1F19D;
	Thu, 11 May 2023 05:42:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2F563F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 05:42:36 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB2726A8
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 22:42:34 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34B5FGL2023552;
	Wed, 10 May 2023 22:42:23 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3qf77s94as-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 22:42:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qc7+RQWj/Ld6GKjsp3JY2juqSFT6PhytReF/TkjDMdGVoYQTMU0ewQQI2W+XO5qOi6fLpsmTByCyXGNJI/u7GsaRlog/tiKnpDnZBfm+cjH5Qr7e0Y2t/rH6CCPHppMJIPhxOw6vaz6ynx0IjuCKigehLu4+UWDzX4BbPCciEpIDD6Oc7i1qNHsvjRm3xIr/ksvLwDp39CYz5ZztaXbHAx6sS0t2dc+anU1KomZjC2wTdQUlKZYc5B/Mo13mSYUaSVuLzRTu7lrCBo5N88nQhV1c45TWfHfMvSZOGkFiIcm9zMlThX3iWmM3atoe9ru8Tal/9kG4gAEm5kmbpboQEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZ6kPPAMeOwfo+haJAaSIApsQ/ie4OIgxce80K1jOwU=;
 b=YSQhj0bgrN/Y3rtlGf6bUZ7WjSV/eQ1/kbYMLh/s9D+FNQjJTjUnCRPKqGWXV1rqXhZKC29hEtHRAfSH8M1XFUvCeh0RDGe6i8zE8UhacElxxEjzYF7AE76/szBYw4EjXIOi1mDeDanFo4TPs8Xov8n5mozgDqT0aAAhsvmpRbCIG/KnIquM87n/dnv/DOAJBglOCnvzrcowvDNKHnhWtztmqZYZV9BLdDmwy03ihAnW5/JvEg+3kFBPUFclqjGomiMez+ZZ8TqaEv245mHNR8Dtqo0lo/5yO/KckEzWmA5rvQKoHmT5RZqDisb+Cray5JDH+RzWJev7ypGD2qBeVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZ6kPPAMeOwfo+haJAaSIApsQ/ie4OIgxce80K1jOwU=;
 b=pV7K1BykdJ9WkENntz3z9Zco4ECAHOq+M9aHJHgjKjIWIzt/TaDjAKxA43RucoTQQKSgOKvsiHNkpUWEY8A+xwaSRleLrBWMlP5tVQLKFFyXji7fhnu5jivYfkKWYk/IMQaeAyKbAXZNgkIg029o8FPl109P9Vdh5cum+oxVmqk=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by MN2PR18MB3342.namprd18.prod.outlook.com (2603:10b6:208:159::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 05:42:13 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88%6]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 05:42:13 +0000
From: Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net"
	<davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Naveen Mamindlapalli
	<naveenm@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Linu Cherian
	<lcherian@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: RE: [EXT] Re: [net-next PATCH] octeontx2-pf: mcs: Offload extended
 packet number(XPN) feature
Thread-Topic: [EXT] Re: [net-next PATCH] octeontx2-pf: mcs: Offload extended
 packet number(XPN) feature
Thread-Index: AQHZg07pNsCQ4oa7B0W5e8HZdLgqzq9Tz3CAgADAAOA=
Date: Thu, 11 May 2023 05:42:13 +0000
Message-ID: 
 <CO1PR18MB4666A2656B7D6D66E03AFBBEA1749@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <1683730283-9353-1-git-send-email-sbhatta@marvell.com>
 <ZFveofGebqWWY4vm@corigine.com>
In-Reply-To: <ZFveofGebqWWY4vm@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2JoYXR0YVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTkxZDYyNjU0LWVmYmUtMTFlZC05YzVjLWJjZjE3?=
 =?us-ascii?Q?MTIxOGI3YVxhbWUtdGVzdFw5MWQ2MjY1Ni1lZmJlLTExZWQtOWM1Yy1iY2Yx?=
 =?us-ascii?Q?NzEyMThiN2Fib2R5LnR4dCIgc3o9IjI4MTMiIHQ9IjEzMzI4MjU3MzI5ODEz?=
 =?us-ascii?Q?NDEyMiIgaD0ieWNXMnltUXFLYStBaWJ3VnVYeWxyWWVWbWhBPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBR1lOQUFC?=
 =?us-ascii?Q?cWJDOVV5NFBaQWQva1ZGZERKTTdYMytSVVYwTWt6dGNWQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBRDJEQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFFQkFBQUFxcU9DTEFDQUFRQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFEZ0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBYlFCaEFISUFkZ0JsQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4?=
 =?us-ascii?Q?QWJnQmhBRzBBWlFCekFGOEFjZ0JsQUhNQWRBQnlBR2tBWXdCMEFHVUFaQUJm?=
 =?us-ascii?Q?QUdFQWJBQnZBRzRBWlFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dC?=
 =?us-ascii?Q?MkFHVUFiQUJmQUhBQWNnQnZBR29BWlFCakFIUUFYd0J1QUdFQWJRQmxBSE1B?=
 =?us-ascii?Q?WHdCeUFHVUFjd0IwQUhJQWFRQmpBSFFBWlFCa0FGOEFhQUJsQUhnQVl3QnZB?=
 =?us-ascii?Q?R1FBWlFCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUcwQVlRQnlBSFlBWlFCc0FHd0FYd0Jo?=
 =?us-ascii?Q?QUhJQWJRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpB?=
 =?us-ascii?Q?SFFBWHdCakFHOEFaQUJsQUhNQUFBQUFBQUFB?=
x-dg-refthree: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJ?=
 =?us-ascii?Q?QUFBQUFBSjRBQUFCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBY0FCeUFHOEFhZ0Js?=
 =?us-ascii?Q?QUdNQWRBQmZBR01BYndCa0FHVUFjd0JmQUdRQWFRQmpBSFFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBRzBB?=
 =?us-ascii?Q?WVFCeUFIWUFaUUJzQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4QWJnQmhB?=
 =?us-ascii?Q?RzBBWlFCekFGOEFZd0J2QUc0QVpnQnBBR1FBWlFCdUFIUUFhUUJoQUd3QVh3?=
 =?us-ascii?Q?QnRBR0VBY2dCMkFHVUFiQUJzQUY4QVlRQnVBR1FBWHdCdEFHa0FjQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0Fi?=
 =?us-ascii?Q?QUJmQUhBQWNnQnZBR29BWlFCakFIUUFYd0J1QUdFQWJRQmxBSE1BWHdCeUFH?=
 =?us-ascii?Q?VUFjd0IwQUhJQWFRQmpBSFFBWlFCa0FGOEFiUUJoQUhJQWRnQmxBR3dBYkFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJ0QUdFQWNnQjJBR1VBYkFCc0FGOEFjQUJ5QUc4QWFn?=
 =?us-ascii?Q?QmxBR01BZEFCZkFHNEFZUUJ0QUdVQWN3QmZBSElBWlFCekFIUUFjZ0JwQUdN?=
 =?us-ascii?Q?QWRBQmxBR1FBWHdCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBYndCeUFGOEFZUUJ5?=
 =?us-ascii?Q?QUcwQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?MEFZUUJ5QUhZQVpRQnNBR3dBWHdCMEFHVUFjZ0J0QUdrQWJnQjFBSE1BQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reffour: 
 QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSGNBYndCeUFHUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQ0FBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR18MB4666:EE_|MN2PR18MB3342:EE_
x-ms-office365-filtering-correlation-id: 02c6d927-0a9f-4fe9-b6cf-08db51e278d2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 BXFXU6meCxS4N87oJPStXB2exFe9Rr4SXeOEir47ej7snFldkzRw4Li6PmTEnYVxwiR3SrQNmw7JiTGf0sxg09yCnql7ljIHlVVWPtOvCQaw+0NMcNWNO23lOJ7yBYTma5pwGrMsiO4/i7X7IhsCBNw8cLiVut5OgTrT4ogFIyC57utXFKshqd8WulsA46FQ88Hr/f5zkPGIRuipd6p2V5RDRiPfpde9O0QUGyLC4Ouuqd9Wya9xEKcjOHdFcvHATcrBOC/kjkbIsU9IgRTsIcVQWuRLLzf2es93m7+FCxlYU666e4lrsBUEguMf+6teXAlRg8rc95RVtgoeYoRh/Hq5xgR9730y1wKVe29WhHuaKtw3FeGc6Nx1CGx7zzOQ58DXBTGv3iza8U7HahY9zLjBm57lCon1poo92cHKrLkypCnb/yic/+wV/raY9r87N1M4lBCmbkXBeTKJUaZW0d7N1cS4yvdfuWeyHfKDXGH5g0JeCUE0CZT4cJRRCQ9ZMg+TSKEgGGox6/Br3fyR0kThUByJDuxYfYA8/fs7jilkiHDs8WySM4ZU+gLk0IoHTAKrstJyPRm/o1HKXirglthoNTRFmyixyL+LJ2fcjDFKxjp8TvV4MDGNEt5Ipuq/
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199021)(83380400001)(41300700001)(4326008)(38070700005)(122000001)(6916009)(33656002)(316002)(8936002)(8676002)(38100700002)(6506007)(9686003)(26005)(107886003)(7696005)(478600001)(76116006)(64756008)(66946007)(66556008)(66446008)(66476007)(5660300002)(52536014)(2906002)(86362001)(186003)(55016003)(54906003)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?BVc91aUMlr8KzFeTFZAtG3ycBItlrtKrCgdWbk+l3P8yIvPUUURlTopH87Xy?=
 =?us-ascii?Q?NfmvWb3+zc8RfsnYBRz0cwi8nkPZmACi4vB1Sjb1PjXs0epQq39VoAEmLNCL?=
 =?us-ascii?Q?/iBMYMc+RHeOXH6xKYemnumGIDH3lfi9ky26ot+g+6kQt5P3OTouBmlm05RQ?=
 =?us-ascii?Q?7uqNK8Xs7Y1Gjydj5Wvhz55CxRpMdT2xhX/aAoClxwWZEXe0CZDqU7pbgq10?=
 =?us-ascii?Q?JojbECFM8xL1kzPhaeIkKfZuUFRoOzDZfHH/XzpeX7lKM4WES4pCVP8fQ+pu?=
 =?us-ascii?Q?EHX1onx1BJEl2EmPd+0keG+CAG+tJKgfBDsC5D/LoeVATIXlNVSxKyDwMc+N?=
 =?us-ascii?Q?7dOnXEInWyyyO6PwtlBbhBarN2tb4DY06CKJljgLfKTchfbxViz3CRSaPqzw?=
 =?us-ascii?Q?dA6pulvpyJTaus3SIbeZ62DCHFrmfFIJq3eysX4Csy9owDKQm+c0f6FZx0xM?=
 =?us-ascii?Q?rocr6NC8H/zWPXXv7ma5a19IM60SHsT4DnneaU/b8kPDJh6Yrc0k3ydHl7SD?=
 =?us-ascii?Q?SFP0h4ST/loPuZjwW4OyW9WRSE6yxp8Mx4OAi/R59Zm80eYzwdilQ/DHFzBX?=
 =?us-ascii?Q?0ii0v6rWidMm5qekP63OqIG7Tvt65P51Dv1adntjmDGw+ObbZasfT3t2eBUN?=
 =?us-ascii?Q?GA2iMS0jmmEbb+BMpXlC4UV2MkFqlcRzt324X0U5rmj/954oL1femZsZt0P/?=
 =?us-ascii?Q?N843orXZRFIGnnEuvRdV0xgpCojt0Nu1+lFsyOj3Xf2CkFn1abv5egjzGcy2?=
 =?us-ascii?Q?YRRDXRRd3+LEwZfVjfAL3FTQss3KrzJQDbNN30r/4N0Qg4F7W/TtRibGSPwS?=
 =?us-ascii?Q?1I0GWYjI6ET+OxBhYJKkIg03v2elRSEE4hDtHsF8sPvonTR2YJguDFCBXqAF?=
 =?us-ascii?Q?Iob4RfXD6eZUEtep82NmN2Osbaeuexr6o4n4/vFQfxp5i/SyYOsyBiQSaK7R?=
 =?us-ascii?Q?8DcaESnZCMfNbJ2uahZXYzH/8bMbIFr16EmpKFjum24CjdwVGflZeQoezuLp?=
 =?us-ascii?Q?Uwd9BNNLtbzuvEa6w9JFnWlWsOGjFgIMdZACpKnqDVN5ukrTaMWJrvHe4VP6?=
 =?us-ascii?Q?khNtI2jEY/6dBtb935EZ76FN/DW9RL1IgkimRfOV3tAVAoyC8v21wma/MU0V?=
 =?us-ascii?Q?i6dPNXviIzQbJvVYtX+x3xFprUwt+7lRyaeYknj2HTQhjzLEoJJyqTb/T0CR?=
 =?us-ascii?Q?A//0dEtwdpK6Znv3CP9JwqnY6kfargEOLLmWnGooTbGIyrQTPPIND5JPMSAk?=
 =?us-ascii?Q?mO9Soq4wgfkxZqY0GIyp/9ksT5DEY86lCQhUdpw8c8Obb1WLfDOKyWapyTQQ?=
 =?us-ascii?Q?PEz3yOunNrnNlBUTyYjhwRTX1LWvvNZzDMhdNco56xz8hjXQdDGMgDJS/622?=
 =?us-ascii?Q?l6Bkr8wrGxtf6pJeFC0d7OQ19kkgf0VICMo4Vu4mmS7Xr0ybmSLFpMchZCbG?=
 =?us-ascii?Q?MCsienezjMA3ZaowgGkfUbt4iBLyTsC0R4XbEcAqExhQ8Nz0F4td8IFzOF3z?=
 =?us-ascii?Q?CcPITOuHhHxTSfuGnwIwJjpRNXqyjDQL6gWM+5uWvdg0a5e/0d42Ad+CWsyr?=
 =?us-ascii?Q?6XaI7/Qxv0FtXBw3XJCzWSJof3N8kbVzWh85QvcK?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c6d927-0a9f-4fe9-b6cf-08db51e278d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 05:42:13.4309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p/tS9aaDn8m/RnE60sdyRHpvtB5MRDQaVBkhssOuGfeKnxdyxdbOc6yCcpQdbwXdEuT6mSgFZTgp57mu5+lnkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3342
X-Proofpoint-ORIG-GUID: nkAE0K4zf1PG7gMoXrup8HhDDoz2rc2T
X-Proofpoint-GUID: nkAE0K4zf1PG7gMoXrup8HhDDoz2rc2T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon,

>-----Original Message-----
>From: Simon Horman <simon.horman@corigine.com>
>Sent: Wednesday, May 10, 2023 11:43 PM
>To: Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
>Cc: netdev@vger.kernel.org; davem@davemloft.net; edumazet@google.com;
>kuba@kernel.org; pabeni@redhat.com; Geethasowjanya Akula
><gakula@marvell.com>; Naveen Mamindlapalli <naveenm@marvell.com>;
>Hariprasad Kelam <hkelam@marvell.com>; Linu Cherian
><lcherian@marvell.com>; Sunil Kovvuri Goutham <sgoutham@marvell.com>
>Subject: Re: [net-next PATCH] octeontx2-pf: mcs: Offload extended packet
>number(XPN) feature
>
>On Wed, May 10, 2023 at 08:21:23PM +0530, Subbaraya Sundeep wrote:
>> The macsec hardware block supports XPN cipher suites also.
>> Hence added changes to offload XPN feature. Changes include
>> configuring SecY policy to XPN cipher suite, Salt and SSCI values.
>> 64 bit packet number is passed instead of 32 bit packet number.
>>
>> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
>> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
>
>...
>
>> @@ -349,6 +366,15 @@ static int cn10k_mcs_write_rx_sa_plcy(struct otx2_n=
ic
>*pfvf,
>>  		reg++;
>>  	}
>>
>> +	if (secy->xpn) {
>> +		memcpy((u8 *)&salt_63_0, salt_p, 8);
>> +		memcpy((u8 *)&ssci_salt_95_64, salt_p + 8, 4);
>> +		ssci_salt_95_64 |=3D (u64)rxsc->ssci[assoc_num] << 32;
>
>Hi Subbaraya,
>
>Sparse says:
>
>drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c:372:37: warning:
>cast from restricted ssci_t
>drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c:611:37: warning:
>cast from restricted ssci_t
>
>I think if you really need a u64 here then you need (__force u64).
>But of course at that point any help types and annotations give you have b=
een
>thrown out the window.
>
Yeah __force is required. I overlooked the warnings from sparse. I will sub=
mit v2.

Thanks,
Sundeep

>> +
>> +		plcy_req->plcy[0][6] =3D salt_63_0;
>> +		plcy_req->plcy[0][7] =3D ssci_salt_95_64;
>> +	}
>> +
>>  	plcy_req->sa_index[0] =3D rxsc->hw_sa_id[assoc_num];
>>  	plcy_req->sa_cnt =3D 1;
>>  	plcy_req->dir =3D MCS_RX;
>
>...
>
>> @@ -561,6 +605,15 @@ static int cn10k_mcs_write_tx_sa_plcy(struct otx2_n=
ic
>*pfvf,
>>  		reg++;
>>  	}
>>
>> +	if (secy->xpn) {
>> +		memcpy((u8 *)&salt_63_0, salt_p, 8);
>> +		memcpy((u8 *)&ssci_salt_95_64, salt_p + 8, 4);
>> +		ssci_salt_95_64 |=3D (u64)txsc->ssci[assoc_num] << 32;
>> +
>> +		plcy_req->plcy[0][6] =3D salt_63_0;
>> +		plcy_req->plcy[0][7] =3D ssci_salt_95_64;
>> +	}
>> +
>>  	plcy_req->plcy[0][8] =3D assoc_num;
>>  	plcy_req->sa_index[0] =3D txsc->hw_sa_id[assoc_num];
>>  	plcy_req->sa_cnt =3D 1;
>
>...

