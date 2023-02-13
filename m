Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F188693E1E
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 07:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBMGRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 01:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjBMGRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 01:17:05 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A835BBAE;
        Sun, 12 Feb 2023 22:17:03 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D5kSI9025053;
        Sun, 12 Feb 2023 22:16:51 -0800
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3npbe1wyw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Feb 2023 22:16:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/pP0Oz129AKmFCw5G+jUpRkx1sUQznQOkIhKPxm8rWCXS5OY8iTZZQq+kp1SGW55Dt6Pjqjy2NSwvpxR2jC9Gnm+4c8+t2Bwd6LViYxmmsSxbt1sRQYj4PBGXLAJxTnsKf/2jtC4x7k3fza0qzYT2WxnghzthA13GWzPtMI7aX3HgiGHa1SX2PrlkHixFqgsN28zYpzsvdXhxmKMc7Mhzapuf4qaUu+FaKlUyRruieC+Npmj8IU75x2v3k8GbX9kr7tPbPgKGNNAytj8iWjJEq8j9hBBn4Xzr9dyx1Lj/zFo+SZmtYlN3QebxBZBVYdp6ZPGlwgvFOomtRoig8dOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yeHLD+2g/LX1WkkXFswlF/e+MQmSkvXWR67SJkX36Fo=;
 b=Fzpe5mtaMkZ+tsnkmxvYtcnrlWHzENavVINq215DMhht7aSImeVPE7M4cmPL1tkvyXbw+3Om8yA7gdUs5O8nZbEMfBDfrv+6MkSzWi6nDSqPIByYZo7KYIcy307GFHGPoQZ6CYzyDcFarETie2QuKizPHgydH3A7F7O0igLW89E6ufxYqYBhRLUhgBHepy3ihT2PmODTWvNaVQKvqeZ/1mzFvMbjtwQoU5bf4RF3AXZKMhhiX95yr0NaJ7qePvW0zhsdb6fEjoygE8HJ77XMMBnGeUenESbySaPPnLapkTGf5iZa7AC2IL/OyOz8e+180Ub3XGCKVWoNAwXfRCVKgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yeHLD+2g/LX1WkkXFswlF/e+MQmSkvXWR67SJkX36Fo=;
 b=dhGFfsD760Lv1eGC/YFjxEGEmjWUixGVvy2E06mX9wEZNRrCOqCojdcroUpWRpylst3nBxNzn3iFQEi4dRvz02+cv+JE+7XOpLOfYQY7OYT4Wi913yv8UqyPSUw3J1oDRY6kkPLCYkEICqi1YncEB2iilpWU69Q4maVEKk9OqiQ=
Received: from CO6PR18MB4467.namprd18.prod.outlook.com (2603:10b6:5:355::12)
 by PH0PR18MB4492.namprd18.prod.outlook.com (2603:10b6:510:ed::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 06:16:49 +0000
Received: from CO6PR18MB4467.namprd18.prod.outlook.com
 ([fe80::8c60:52c6:59eb:3696]) by CO6PR18MB4467.namprd18.prod.outlook.com
 ([fe80::8c60:52c6:59eb:3696%4]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 06:16:47 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "tariqt@nvidia.com" <tariqt@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "maxtram95@gmail.com" <maxtram95@gmail.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>
Subject: Re: [net-next Patch V4 4/4] octeontx2-pf: Add support for HTB offload
Thread-Topic: [net-next Patch V4 4/4] octeontx2-pf: Add support for HTB
 offload
Thread-Index: AQHZP3LAZoSbPG7ASEmGS5aOMKxvmg==
Date:   Mon, 13 Feb 2023 06:16:47 +0000
Message-ID: <CO6PR18MB4467174DDC4FCA538CF69E48DEDD9@CO6PR18MB4467.namprd18.prod.outlook.com>
References: <20230210111051.13654-1-hkelam@marvell.com>
 <20230210111051.13654-5-hkelam@marvell.com> <Y+ZdLphI/TolrgcA@corigine.com>
In-Reply-To: <Y+ZdLphI/TolrgcA@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctZmJlODYyZWYtYWI2NS0xMWVkLWI2ZDQtZDQzYjA0?=
 =?us-ascii?Q?N2UyYmEwXGFtZS10ZXN0XGZiZTg2MmYwLWFiNjUtMTFlZC1iNmQ0LWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmJhMGJvZHkudHh0IiBzej0iMTAwMTMiIHQ9IjEzMzIwNzQyNjAzNzQy?=
 =?us-ascii?Q?NjAyOCIgaD0iM1drb1lVTFRXbFBMK0RqTHpqZld4RXVMLytzPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFC?=
 =?us-ascii?Q?c3AyZStjai9aQVR0R2gxSnN6MTMzTzBhSFVtelBYZmNOQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQUdDQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUExRkgzYUFBQUFBQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcwQVh3QndBR2dBYndCdUFHVUFiZ0Ix?=
 =?us-ascii?Q?QUcwQVlnQmxBSElBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVB?=
 =?us-ascii?Q?Y3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhBWkFCaEFITUFhQUJmQUhZQU1BQXlB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
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
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZB?=
 =?us-ascii?Q?SFFBWlFCaEFHMEFjd0JmQUc4QWJnQmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFR?=
 =?us-ascii?Q?QnNBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFB?=
 =?us-ascii?Q?QUFBQUFBQUFnQUFBQUFBbmdBQUFHVUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FI?=
 =?us-ascii?Q?SUFaUUJ6QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSEFBY2dCdkFHb0FaUUJqQUhR?=
 =?us-ascii?Q?QVh3QmpBRzhBWkFCbEFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dC?=
 =?us-ascii?Q?MkFHVUFiQUJzQUY4QWRBQmxBSElBYlFCcEFHNEFkUUJ6QUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUEiLz48L21ldGE+?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4467:EE_|PH0PR18MB4492:EE_
x-ms-office365-filtering-correlation-id: 8d675ab1-36e8-4fd5-0fa3-08db0d89e349
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PQffL8ZxseCr4JjjTsad1MANFL6ON/FzggjETjRD89abPGvppq1ZqrlQ2jx8fs0FZHOeQrH44xyKOGJ7dmSZZP8CefO1FuKiCMGhk5dn3E1T3tXloSVgxot6bsPSa+kRbFTuP9ddy2/ppiqOoxg5Hwc2T1zAexvjSZRGO0zXPQunG+Dw1S03HoSILv2GCDhcXmzi6AXgpm5ZmSgc/zvYeIHPjWV/wY8NDJo9BaSSMySIj2iHJBx+PGKhvZqzYM+RfD9qbHHZXyZQkcE4zmdYKzfC5ASnZPbAsmBStdhT6odechKcOHksK1AidXNWB4IpEVgqyyf8lrwQLhbzFKXhdCqqZ3gITdTRfxcgosT2DHA0RrV/7gCziQ9b+U7wCzmtsbw8JJbduq0p2axkere84Oau+EyiyUT/5fqwaM6xK7TIH3g5D4A5k/SZIH+1PaHEeMq2+oWFiCDwIOWx/CKsRTz57E6cuzZNeJli9oEsWsojImIqkVXxfowB64e+CYHuaVnBVTBaGdGOn2uyE7jSSMS77fStav4KHPSc44lj8IV9Lq9a45Iij3PXuH2xFzo2FInj3PnT1ElXO/r7hkl9QSaR1iIaM6Sc5Ebb8/yzhxEyKg3BPCJUvDAtCRnlK4rlgQ3EB1tTdOQssYoU7eMh5wFsQqfSgs0DAK0xBbRlKBGu9GD9I6V9eNDMqJ+7CayEPGfIq3Pw+3+A59tWRCW0CYOz0Wm20oyTN2s7FAitLuY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4467.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(136003)(39850400004)(396003)(451199018)(33656002)(86362001)(122000001)(54906003)(316002)(4326008)(8676002)(76116006)(66946007)(71200400001)(7696005)(478600001)(2906002)(41300700001)(7416002)(6916009)(66476007)(5660300002)(8936002)(66446008)(52536014)(64756008)(66556008)(38100700002)(38070700005)(55016003)(26005)(6506007)(9686003)(83380400001)(186003)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jZ1/5Q8vCDJRmd3s4+0oUJkFSzK5QWiMQbkHl0seFV6VXXNWvylhQ9m/hvsK?=
 =?us-ascii?Q?FC6cfB1/8XdZORiqoP9zdMTb5OUHpvFs6rqSrWV5tALfZYW3COR/aBtAyNeu?=
 =?us-ascii?Q?EDVTgSPdwh15poDWL6pHdF1QRj3ikwEb5VjP3GmSKd9de9EkLFTIUpwu9tqW?=
 =?us-ascii?Q?1n11HlhPE+j4JVmmV3zbc5vfDZljWVEvxoS0pF/b0MpGNElP6CwGrDS6b1K6?=
 =?us-ascii?Q?gF0yK46MItma8Qxlai6SxcL64R4U/qNy5SNl0tuizTQICfggl5QqQF7s+IQV?=
 =?us-ascii?Q?dwXY6eRPCCAMGjFLJWKxSOUXFJYhMUjfa49yDNGQrdnAfnAM7Em21Q2lX2Wy?=
 =?us-ascii?Q?+I7XTl/e3Gn1itOLFJsopYIqYrF7U/dePt2C4RTkwY6g8qWZNz63/RUkL52R?=
 =?us-ascii?Q?hwToIOFSg4MwsVzaeQvsX07UoQPb9jiWXESf9vPz6BopMSGrAASBE9z3JJuw?=
 =?us-ascii?Q?Pj8Jsl93RBBQlMwPZPLfaGtUc65Xu86xxUoLC7zyiP6cUgK4ON/C/M6JXw0i?=
 =?us-ascii?Q?wXttPOH6rw/16PRn/qwuee3N10bzUFgiqGIjQM0nBttCZzCjL1NWaoEMbRTV?=
 =?us-ascii?Q?n28fbK4PAyv0JhXBYKbZp2ZLHoTddPigbTqLGHfw2GkfVbnEvHzqqHc/AO4d?=
 =?us-ascii?Q?dBzX9y2oeFGkJfubJyVS4vtSVPKW4aprjXaqY3tWvCToicmsE5QTzKd2vmoI?=
 =?us-ascii?Q?5WYq4cxANYbdCPk6b3YKBp2zc7vROOJHLmmp/NOH2clP38DyAtC+xQeA7tdV?=
 =?us-ascii?Q?WpfiD/mE+6shUQYFciTeu9AYYIkSYrlltxDv6C93gS01W1lX98LR+0DgA7pC?=
 =?us-ascii?Q?JtGS67dzz7IP1SAA0OTnq3TLoVhVeja3otcFLlsVvNFg/72eIDtEn1uh5z+p?=
 =?us-ascii?Q?xp1YrNqaNJat07ubhWwUd2gj9X+6tcphuXsRFeI9R3agkZAv3RWIQtMxuzez?=
 =?us-ascii?Q?7G9VdOn50QzGoecZI9qzTPEBAIOEEk/mwm8C2WTvZkAfhdrMkjby6UjgIQwG?=
 =?us-ascii?Q?gN1z13UHZrPBiAYJ0MLtT6JUsdTJIDQK3Doia9rlloIpUs5tIfbPVf3wpEou?=
 =?us-ascii?Q?P0qJjezqDN7+O0Id18x3ss+IJlV+eDJmacDDWsuU0DkupiCs1+aHqnlPFy1a?=
 =?us-ascii?Q?Q1GksGRLFqIUHgrAiMZZFtB7gS0MKkPp+9UICF1+w+SX/7mIqSVmuYcSHc6r?=
 =?us-ascii?Q?Yxz1uotV6Lga0HoocQrh551D05y8G532TwcAHJPUhdX9dmLGdzfDIu7fHqEb?=
 =?us-ascii?Q?MBoqrsverlBShHN1XBjEMdYSMW3iP4HABYpXHV1tciR/gyqMD56UwDxKP0bO?=
 =?us-ascii?Q?I5yMrjdgcU2syS/V9hoD8OnhDKihBXh8T2moya6N3r+80q/iJh2/zOzh5pWL?=
 =?us-ascii?Q?Bpa4txAPqbVqUxh7z4Y67/4KxKuuMPX98DlSwbzwoXpcy63VjvIwKuydy4QO?=
 =?us-ascii?Q?b6WtNyKN2TH5OhDRge7TbvJ34vU49ZKT2KeTIld0S0XXzAjcyqiKOE64iUD+?=
 =?us-ascii?Q?5UBtGxtH+BSDdUR4CrCD8KfFtfCd8pPQeTZQag0andpcQCvyQj/cnCd+NhP+?=
 =?us-ascii?Q?7vvCNAqSq3iA0l63MTp/ahzV+wqIVL3RZO3XvLlD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4467.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d675ab1-36e8-4fd5-0fa3-08db0d89e349
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 06:16:47.7797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RuBQGWPF8m/Cjg0ebdMKElow/BCK2IqzATorY3Sg85Vz+TLQSLXKdRpmabFUjT2NriJFW7jlhfigZjFvnAOYmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4492
X-Proofpoint-GUID: yFkVFqwY8_ZgtchZIUAyew1hcm4R-oXR
X-Proofpoint-ORIG-GUID: yFkVFqwY8_ZgtchZIUAyew1hcm4R-oXR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_02,2023-02-09_03,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see inline,

> On Fri, Feb 10, 2023 at 04:40:51PM +0530, Hariprasad Kelam wrote:
> > From: Naveen Mamindlapalli <naveenm@marvell.com>
> >
> > This patch registers callbacks to support HTB offload.
> >
> > Below are features supported,
> >
> > - supports traffic shaping on the given class by honoring rate and
> > ceil configuration.
> >
> > - supports traffic scheduling,  which prioritizes different types of
> > traffic based on strict priority values.
> >
> > - supports the creation of leaf to inner classes such that parent node
> > rate limits apply to all child nodes.
> >
> > Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > ---
> >  .../ethernet/marvell/octeontx2/af/common.h    |    2 +-
> >  .../ethernet/marvell/octeontx2/nic/Makefile   |    2 +-
> >  .../marvell/octeontx2/nic/otx2_common.c       |   37 +-
> >  .../marvell/octeontx2/nic/otx2_common.h       |    7 +
> >  .../marvell/octeontx2/nic/otx2_ethtool.c      |   31 +-
> >  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   47 +-
> >  .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   13 +
> >  .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |    7 +-
> >  .../net/ethernet/marvell/octeontx2/nic/qos.c  | 1541 +++++++++++++++++
> >  .../net/ethernet/marvell/octeontx2/nic/qos.h  |   56 +-
> >  .../ethernet/marvell/octeontx2/nic/qos_sq.c   |   20 +-
> >  include/net/sch_generic.h                     |    2 +
> >  net/sched/sch_generic.c                       |    5 +-
> >  13 files changed, 1741 insertions(+), 29 deletions(-)  create mode
> > 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.c
>=20
> nit: this patch is rather long
>=20
Ok,  Will try to break the whole patch into two.
> ...
>=20
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > index 4cb3fab8baae..5653b06d9dd8 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
>=20
> ...
>=20
> > +int otx2_txschq_stop(struct otx2_nic *pfvf) {
> > +	int lvl, schq;
> > +
> > +	/* free non QOS TLx nodes */
> > +	for (lvl =3D 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
> > +		otx2_txschq_free_one(pfvf, lvl,
> > +				     pfvf->hw.txschq_list[lvl][0]);
> >
> >  	/* Clear the txschq list */
> >  	for (lvl =3D 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
> >  		for (schq =3D 0; schq < MAX_TXSCHQ_PER_FUNC; schq++)
> >  			pfvf->hw.txschq_list[lvl][schq] =3D 0;
> >  	}
> > -	return err;
> > +
> > +	return 0;
>=20
> nit: This function always returns 0. Perhaps it's return value could be n=
ull
>      and the error handling code at the call sites removed.

ACK, the caller is checking for the error, will modify the return value.
>=20
> ...
>=20
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
> > new file mode 100644
> > index 000000000000..2d8189ece31d
> > --- /dev/null
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
>=20
> ...
>=20
> > +int otx2_clean_qos_queues(struct otx2_nic *pfvf) {
> > +	struct otx2_qos_node *root;
> > +
> > +	root =3D otx2_sw_node_find(pfvf, OTX2_QOS_ROOT_CLASSID);
> > +	if (!root)
> > +		return 0;
> > +
> > +	return otx2_qos_update_smq(pfvf, root, QOS_SMQ_FLUSH); }
>=20
> nit: It seems that the return code of this function is always ignored by
>      callers. Perhaps either the call sites should detect errors, or the
>      return type of this function should be changed to void.
>=20
ACK, will modify the return value.
> > +
> > +void otx2_qos_config_txschq(struct otx2_nic *pfvf) {
> > +	struct otx2_qos_node *root;
> > +	int err;
> > +
> > +	root =3D otx2_sw_node_find(pfvf, OTX2_QOS_ROOT_CLASSID);
> > +	if (!root)
> > +		return;
> > +
> > +	err =3D otx2_qos_txschq_config(pfvf, root);
> > +	if (err) {
> > +		netdev_err(pfvf->netdev, "Error update txschq
> configuration\n");
> > +		goto root_destroy;
> > +	}
> > +
> > +	err =3D otx2_qos_txschq_push_cfg_tl(pfvf, root, NULL);
> > +	if (err) {
> > +		netdev_err(pfvf->netdev, "Error update txschq
> configuration\n");
> > +		goto root_destroy;
> > +	}
> > +
> > +	err =3D otx2_qos_update_smq(pfvf, root, QOS_CFG_SQ);
> > +	if (err) {
> > +		netdev_err(pfvf->netdev, "Error update smq
> configuration\n");
> > +		goto root_destroy;
> > +	}
> > +
> > +	return;
> > +
> > +root_destroy:
> > +	otx2_qos_root_destroy(pfvf);
> > +}
>=20
> I am curious as to why the root is destroyed here.
> But such cleanup doesn't apply to other places where
> otx2_qos_txschq_config() is called.
>=20

There are two use cases,

1. otx2_qos_txschq_config is called while creating a new class, on this fun=
ction fails we are simply returning an error.
2.  if QOS commands are installed in the interface down state, " otx2_qos_c=
onfig_txschq" this function is called during interface UP,=20
     To configure the hardware CSRs for all classes.
    We are deleting the root if the driver failed to configure the HW.  We =
missed adding message, will add in next version.
 =20
>=20
> ...
>=20
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
> > b/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
> > index ef8c99a6b2d0..d8e32a6e541d 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
>=20
> ...
>=20
> >  struct otx2_qos {
> > +	DECLARE_HASHTABLE(qos_hlist,
> order_base_2(OTX2_QOS_MAX_LEAF_NODES));
> > +	DECLARE_BITMAP(qos_sq_bmap, OTX2_QOS_MAX_LEAF_NODES);
> >  	u16 qid_to_sqmap[OTX2_QOS_MAX_LEAF_NODES];
> > +	u16 maj_id;
> > +	u16 defcls;
>=20
> On x86_64 there is a 4 byte hole here...
>=20
> > +	struct list_head qos_tree;
> > +	struct mutex qos_lock; /* child list lock */
> > +	u8  link_cfg_lvl; /* LINKX_CFG CSRs mapped to TL3 or TL2's index ?
> > +*/
>=20
> And link_cfg_lvl is on a cacheline all by itself.
>=20
> I'm not sure if it makes any difference, but pehraps it makes more sense =
to
> place link_cfg_lvl in the hole above.

ACK,  will address the suggested below changes in next version.

Thanks,
Hariprasad k
> $ pahole drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.o
> ...
> struct otx2_qos {
>         struct hlist_head          qos_hlist[16];        /*     0   128 *=
/
>         /* --- cacheline 2 boundary (128 bytes) --- */
>         long unsigned int          qos_sq_bmap[1];       /*   128     8 *=
/
>         u16                        qid_to_sqmap[16];     /*   136    32 *=
/
>         u16                        maj_id;               /*   168     2 *=
/
>         u16                        defcls;               /*   170     2 *=
/
>=20
>         /* XXX 4 bytes hole, try to pack */
>=20
>         struct list_head           qos_tree;             /*   176    16 *=
/
>         /* --- cacheline 3 boundary (192 bytes) --- */
>         struct mutex               qos_lock;             /*   192   160 *=
/
>         /* --- cacheline 5 boundary (320 bytes) was 32 bytes ago --- */
>         u8                         link_cfg_lvl;         /*   352     1 *=
/
>=20
>         /* size: 360, cachelines: 6, members: 8 */
>         /* sum members: 349, holes: 1, sum holes: 4 */
>         /* padding: 7 */
>         /* last cacheline: 40 bytes */
> };
> ...
>=20
> > +};
> > +
> > +struct otx2_qos_node {
> > +	/* htb params */
> > +	u32 classid;
>=20
> On x86_64 there is a 4 byte hole here,
>=20
> > +	u64 rate;
> > +	u64 ceil;
> > +	u32 prio;
> > +	/* hw txschq */
> > +	u8 level;
>=20
> a one byte hole here,
>=20
> > +	u16 schq;
> > +	u16 qid;
> > +	u16 prio_anchor;
>=20
> another four byte hole here,
>=20
> > +	DECLARE_BITMAP(prio_bmap, OTX2_QOS_MAX_PRIO + 1);
> > +	/* list management */
> > +	struct hlist_node hlist;
>=20
> the first cacheline ends here,
>=20
> > +	struct otx2_qos_node *parent;	/* parent qos node */
>=20
> And this is an 8 byte entity.
>=20
> I'm not sure if it is advantagous,
> but I think parent could be moved to the first cacheline.
>=20
> > +	struct list_head list;
> > +	struct list_head child_list;
> > +	struct list_head child_schq_list;
> >  };
>=20
> $ pahole drivers/net/ethernet/marvell/octeontx2/nic/qos.o
> ...
> struct otx2_qos_node {
>         u32                        classid;              /*     0     4 *=
/
>=20
>         /* XXX 4 bytes hole, try to pack */
>=20
>         u64                        rate;                 /*     8     8 *=
/
>         u64                        ceil;                 /*    16     8 *=
/
>         u32                        prio;                 /*    24     4 *=
/
>         u8                         level;                /*    28     1 *=
/
>=20
>         /* XXX 1 byte hole, try to pack */
>=20
>         u16                        schq;                 /*    30     2 *=
/
>         u16                        qid;                  /*    32     2 *=
/
>         u16                        prio_anchor;          /*    34     2 *=
/
>=20
>         /* XXX 4 bytes hole, try to pack */
>=20
>         long unsigned int          prio_bmap[1];         /*    40     8 *=
/
>         struct hlist_node          hlist;                /*    48    16 *=
/
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         struct otx2_qos_node *     parent;               /*    64     8 *=
/
>         struct list_head           list;                 /*    72    16 *=
/
>         struct list_head           child_list;           /*    88    16 *=
/
>         struct list_head           child_schq_list;      /*   104    16 *=
/
>=20
>         /* size: 120, cachelines: 2, members: 14 */
>         /* sum members: 111, holes: 3, sum holes: 9 */
>         /* last cacheline: 56 bytes */
> };
> ...
