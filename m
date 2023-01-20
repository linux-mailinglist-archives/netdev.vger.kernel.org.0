Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5A1675AB5
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjATRDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjATRDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:03:36 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9DEAA7E1;
        Fri, 20 Jan 2023 09:03:35 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30KDMgXG003562;
        Fri, 20 Jan 2023 09:03:23 -0800
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n71cf0j5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 09:03:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMGQYr6idUcg2Jaf2mlc5NbEfY7HsipJep7rA1LrGWUTDRFr7aUcQl0tbUTjzlYrF9Xhg1FxIBskV+06jIWlLDO98BA6TtsI1zs8WYBRjAAQY2WisN1ePVGkJwC8rBxj4dwd8pAMBGCzEDvDt8i5aXapX7X/nI6X3O9J3hysT+xkghLMfXFt55XT5GK7C89VpT3c0ZKhy7h7EPVxpBcYcSoIB52AkvzbOWCZ1FBd69hUH3x4LvdmxPJwnlWBVwhBsgpyMbRE/1b1rEx0UCH0Dtu5Aw6s7p9ufawWWUGS3cWiRsf4epLi+czGaakAYUxVzEJ/9P1XHY9mangTAc7VGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehqKDalQu6fF4l+u0a7gZMEo0FUZhkRu0RgydcsgW6s=;
 b=P1ZKJeQ2y31ImrhBO9HNeMEAGV726zmb3UWsFeCId+XqRFMlJfPb075MwxlZPOFwCA+kix/mmoJ1mnIfrSoxntdvoaY751C1bmte984WZO1X4Nyadud+hMgmEldmBem/3Og1jpjOfX2IGiD0C2hnHEqpZroL8OfubWLxTyZeHtUhcNJPsBds9xTHkhdI0Lag8fx3Si3WKiBm8Ce53G8BBwhvqO+22zebq91hw7YIo9LjPXb/+9C2ZwS9XXkVEGJ38ItdnV9S4yXZpU5hAX8EsxcL4/t1qUR8zuWqbF2HV9oWPbPcP0oozsshPEWuoJ1x/CfWw0sy7TdsgnBX/HOeFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehqKDalQu6fF4l+u0a7gZMEo0FUZhkRu0RgydcsgW6s=;
 b=EAs111VtUvyHSrsFoBLnvenmGO+CP3I/wCABL8UbiZKeguZQFNgaoctFxDGxo7cKaZh+ehDTZ3BVlQ0HsQGE3r3A9Ysqhg3mRA3HN5dwe2TsWXbbDLOi7yuXrBYbPX407nVpB1qpbb9FhivMsjB/8pK/Hz4bfDVLHaRRu72Pekw=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by SA1PR18MB4630.namprd18.prod.outlook.com (2603:10b6:806:1d1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 17:03:20 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e%2]) with mapi id 15.20.6002.027; Fri, 20 Jan 2023
 17:03:20 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
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
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>
Subject: Re: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Thread-Topic: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Thread-Index: AQHZLPEZRqmv6MllqUaKMRPDHkfLgw==
Date:   Fri, 20 Jan 2023 17:03:20 +0000
Message-ID: <PH0PR18MB4474DBEF155EFA4DA6BA5B10DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
 <20230118105107.9516-5-hkelam@marvell.com> <Y8hYlYk/7FfGdfy8@mail.gmail.com>
 <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y8qZNhUgsdOMavC4@mail.gmail.com>
In-Reply-To: <Y8qZNhUgsdOMavC4@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctNTU2NjA2ZTktOThlNC0xMWVkLWI2ZDItZDQzYjA0?=
 =?us-ascii?Q?N2UyYjlkXGFtZS10ZXN0XDU1NjYwNmViLTk4ZTQtMTFlZC1iNmQyLWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmI5ZGJvZHkudHh0IiBzej0iMzg0NCIgdD0iMTMzMTg3MDc3OTgxMjg4?=
 =?us-ascii?Q?NzUzIiBoPSIwN0l3SVhncHE0bU9yRDR4N0FxTWZyT2w0Umc9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFOZ0hBQUF4?=
 =?us-ascii?Q?T2I4WDhTelpBVk9XUUpYNnR1YUZVNVpBbGZxMjVvVU1BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFCb0J3QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQTNUekZBQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFaQUJoQUhNQWFBQmZBSFlBTUFBeUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01B?=
 =?us-ascii?Q?ZFFCekFIUUFid0J0QUY4QWN3QnpBRzRBWHdCckFHVUFlUUIzQUc4QWNnQmtB?=
 =?us-ascii?Q?SE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFY?=
 =?us-ascii?Q?d0J6QUhNQWJnQmZBRzRBYndCa0FHVUFiQUJwQUcwQWFRQjBBR1VBY2dCZkFI?=
 =?us-ascii?Q?WUFNQUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QWN3?=
 =?us-ascii?Q?QndBR0VBWXdCbEFGOEFkZ0F3QURJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?UUFiQUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZBRzBBWlFC?=
 =?us-ascii?Q?ekFITUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFYd0J6QUd3?=
 =?us-ascii?Q?QVlRQmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFHY0FaUUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFIUUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFCc0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJQVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVBY3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PC9tZXRhPg==
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|SA1PR18MB4630:EE_
x-ms-office365-filtering-correlation-id: 727161af-69cd-4dad-68a9-08dafb083bbd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ygi8RmZ5rzwP7yzQgfTsGbJfSF050i4W32vOXXw9fN7YxMGFAX7DIIKUNwd4UCF59Kx/MOih37/CXCsBKR9W7VDKXwbR5mhxJRJiT6EtdUKg7bcLN0hzfT4GAO87o9JxBEvvUSMzKFp/t/T9mllhNuy1m+8We1DTZtK7/rNL9fJEePPETO7aj9YhKFhKMlFmwy6LoXo4XZxQKNHe+20DjMdGc+KcoLGzfhvsStr/bNgJw7QStEtYeG+jTFj5EQf9eYlKMPb05zsUy1Xz4rKyFovtxw4qX99d2olEMEurt6IxWVSboQ6pry7gm035mJNgvCrEFQ/5j8nIhgIWlGuRkRJPwC23LHbHaEBAW+3/MFGY2dIO+MXmQwPeGL9eopNHNqD5bh+08YOnaCS1SLYyGnxyoVeCKtBs3lY8Pc62xxJv+DbxBBsXklUw7nKdyy/MKrdSm6ktaocU/UCHHCfi6gmz3Gsh7r5/7nZjNaFJ8OVxiKZEdHZHw5NVkHbVjNX1p32Fyi83RMIHVda0g4YqXorsfE55WsNn+hMGIiPGElEjZcJ0XdWcVQQk2Am2YLLoZVsG7Jfpv/T2dP7nPznX0EYqJjZ0pRYnPi9yVbCpyGfp/3qGs49z5WyHh+YmeaaFcuzbKQBDzUdJt89htUgdCo5qWPrBss8OCiym4HrS99/g5sKNWDQm77BxRl+6kDHTKLfgGE9/s1BtTNX67yhtLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199015)(38070700005)(38100700002)(66476007)(41300700001)(66946007)(55016003)(122000001)(76116006)(6506007)(71200400001)(64756008)(8676002)(9686003)(6916009)(186003)(33656002)(4326008)(26005)(66446008)(66556008)(7416002)(2906002)(83380400001)(8936002)(52536014)(54906003)(478600001)(86362001)(7696005)(316002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HMy4hMq2PpQVz03V3RUm3q6tzysPb/9RBJtkId2U7xkWjJqOADh+R/O0hssX?=
 =?us-ascii?Q?pS/3RxK87FY0+U7MSrkI/rDICQyxvmLKKpO5LpKFQlLHy/EKLX4WZS5xaFK5?=
 =?us-ascii?Q?kPQ/fbcc5ETXukmjXYeHAeKheIESbAgJllv7ixwRLj2S7Jv594CSqjQ2tVxO?=
 =?us-ascii?Q?EIoveaeGwnEN8V1ht0go1CjRAghzBG9nb7LwXUX7Kxi/OlII9x/jPRdhxnB4?=
 =?us-ascii?Q?v+2JMT7B8ffx2fD48z4iX1TLMmiMT4+kLyGNo20CRhugR37AwRVBzBcRb0yw?=
 =?us-ascii?Q?WYgipUJpIDEtq8YtRTXughy0JRQwIZx3niYWMPldH7Y8OVzN+v9oxtT5IJ3X?=
 =?us-ascii?Q?ofGp4OQZI/ymoygwoYo80G+z8rgwKPUIEWrvadTTVY/atEUQzNNaNe/SnYYH?=
 =?us-ascii?Q?rR/66MM8npqDUerM9ArCa+Ym1S9BJrro+LBzTC8qUMDS06Ja2AvOEWWHrwLb?=
 =?us-ascii?Q?mh0XfG/KK3LdI/zD0ZzV18qornsvrnFvMlrRWXGTE/3k5kTB7H9JCx+5BUHH?=
 =?us-ascii?Q?usFNrkI8yyZYFrdJ0ma2ZzBQEtq89EHBhsDkkpJG+d04EVxUctuZXxDFAqAg?=
 =?us-ascii?Q?8s5IvJjuoqKAe3p1ons06lKA6V1M41LIWtPs9aL6cBOoTxTgA3c9gpmpx0WB?=
 =?us-ascii?Q?zr47ka4gYxhCszl0oCup/NQc6+3+76zKAa/pRaZlHRZiID4RiU/xQVloO2sJ?=
 =?us-ascii?Q?286IeGnyb26yCHLYNEpotRnqXrYWEwHRZcsJYpZXkjKJXOtXns2WY3tUXDmh?=
 =?us-ascii?Q?kliAjund6WYCpdSf6j6TZaf4LBxexCHB4I1SRtR0Y5Gu33G6kv9REaninmdA?=
 =?us-ascii?Q?SxE8a0upnJCs3+9ilgNeQ7KPpD3rGlkqivUieWz667RqmeYRM+1O4L3QzFQ1?=
 =?us-ascii?Q?vZNbluFSAb6RIGnuA8eLfxTXOsMnErRx5KEDggJjqBhvrzzeHSbbImP0zM5x?=
 =?us-ascii?Q?vkPwvPyRyoHEn0McMdSzZcB3i8moy9ynFB3rW1XZQ2Az/RYDxFhJw9MA4y1U?=
 =?us-ascii?Q?kvebxsjZfgWhsRmduTKmPg8ZEazKeFEdBELT4czf018nhcPB9ipIaY8FXfHZ?=
 =?us-ascii?Q?ZEYpoNl+P2C0ntWWHH4aYHvjI60BM6p5hNa2cDLxATsIkEvKXxq0f+AnA0QS?=
 =?us-ascii?Q?VnyL1NGQ6Xpml5FPwi/WrbRoxrlHHZmr/kB3S9QwBP32Jel9RlY3ntWX502X?=
 =?us-ascii?Q?0iwhRzLe7gHrHps8QmukYyo63yPmPi7iYAnHvDnxRwaKlWeVoaVs3anxsXdd?=
 =?us-ascii?Q?QKq5rlh2YNVltNtFQVFNi109IlAS3yp4vm/WRApSHnwe2LzEOi4kUuJLndG/?=
 =?us-ascii?Q?1qfLGnVjN7/V0RFdVaPkoh0kUz1Q0J0N28mIpB1WXv3lKDF8xd4ativpXJ6B?=
 =?us-ascii?Q?9oSVTDjYRME5SUUWXgYoRDMgfGtC6ky0OTStH99QSGe56kQ4xrweyuMhU4hf?=
 =?us-ascii?Q?suSKYJBf4a+ug7MhSQnHaWnJ0uBwl8eeeOjLqN9F1AQxOmNnw+nUoiJZQpM/?=
 =?us-ascii?Q?kNsc6gwIWMHz5jGFdqtMZHYbGwPHCGCJME2jlSLWgd2vqoUNqesIhFJt/c35?=
 =?us-ascii?Q?Oz8G/1NBRKYMviPHiYqwMYh5lMlHMLIPIdvIl/6P?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 727161af-69cd-4dad-68a9-08dafb083bbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 17:03:20.6769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PGHQt9i/g6j+6bdZlhDT24Wh+CNzPpgnRImCpLl8pK1xWRB1CedAxNAYC1VGuCk+BZPwOJcKml2yk+EezOJ8Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR18MB4630
X-Proofpoint-GUID: mlulinFln0092EA8HiuWks5p5uxJZNlK
X-Proofpoint-ORIG-GUID: mlulinFln0092EA8HiuWks5p5uxJZNlK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_09,2023-01-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Fri, Jan 20, 2023 at 08:50:16AM +0000, Hariprasad Kelam wrote:
>=20
> On Wed, Jan 18, 2023 at 04:21:06PM +0530, Hariprasad Kelam wrote:
> > All VFs and PF netdev shares same TL1 schedular, each interface PF=20
> > or VF will have different TL2 schedulars having same parent TL1. The=20
> > TL1 RR_PRIO value is static and PF/VFs use the same value to=20
> > configure its
> > TL2 node priority in case of DWRR children.
> >=20
> > This patch adds support to configure TL1 RR_PRIO value using devlink.
> > The TL1 RR_PRIO can be configured for each PF. The VFs are not=20
> > allowed to configure TL1 RR_PRIO value. The VFs can get the RR_PRIO=20
> > value from the mailbox NIX_TXSCH_ALLOC response parameter aggr_lvl_rr_p=
rio.
>=20
> I asked this question under v1, but didn't get an answer, could you shed =
some light?
>=20
> "Could you please elaborate how these priorities of Transmit Levels are r=
elated to HTB priorities? I don't seem to understand why something has to b=
e configured with devlink in addition to HTB.
>=20
> SMQ (send meta-descriptor queue) and MDQ (meta-descriptor queue) are the =
first transmit levels.
> Each send queue is mapped with SMQ.
> =20
> As mentioned in cover letter, each egress packet needs to traverse all tr=
ansmit levels starting from TL5 to TL1.

Yeah, I saw that, just some details about your hardware which might be obvi=
ous to you aren't so clear to me...

Do these transmit levels map to "layers" of HTB hierarchy? Does it look lik=
e this, or is my understanding completely wrong?

TL1                 [HTB root node]
                   /               \
TL2          [HTB node]         [HTB node]
            /          \             |
TL3    [HTB node]  [HTB node]   [HTB node]
...                       ...

Transmit levels to HTB mapping is correct.



> This applies to non-QOS Send queues as well.
> =20
>                        SMQ/MDQ --> TL4 -->TL3 -->TL2 -->TL1
>=20
> By default non QOS queues use a default hierarchy  with round robin prior=
ity.=20
> To avoid conflict with QOS tree priorities, with devlink user can choose =
round-robin priority before Qos tree formation.

So, this priority that you set with devlink is basically a weight of unclas=
sified (default) traffic for round robin between unclassified and classifie=
d traffic, right? I.e. you have two hierarchies (one for HTB, another for n=
on-QoS queue), and you do DWRR between them, according to this priority?


 Not exactly, In the given scenario where  multiple vfs are attached to PF =
netdev.
 each VF unclassified traffic forms a hierarchy and PF also forms a hierarc=
hy for unclassified traffic.
=20
Now traffic from these all tress(multiple vfs and PFs) are aggregated at TL=
1. HW performs DWRR among them since these TL2 queues (belonging to each pf=
 and vf netdevs) will be configured with the same priority by the driver.

Currently, this priority is hard coded. Now we are providing this as a conf=
igurable value to the user.

Now if a user adds a HTB node, this will have strict priority at TL2 level =
since DWRR priority is different this traffic won't be affected by DWRR unc=
lassified traffic.

Thanks,
Hariprasad k







> BTW, why did you remove the paragraphs with an example and a limitation?
> I think they are pretty useful.
>=20
> Ok , removed them accidentally will correct in the next version.
>=20
> Another question unanswered under v1 was:
>=20
> "Is there any technical difficulty or hardware limitation preventing=20
> from implementing modifications?" (TC_HTB_NODE_MODIFY)
>=20
> There is no hardware limitation, we are currently implementing it.  once =
it's implemented we will submit for review.

Great, that's nice to hear, looking forward to it.
