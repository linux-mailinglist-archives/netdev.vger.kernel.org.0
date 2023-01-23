Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFAE6780B9
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 17:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbjAWQCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 11:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbjAWQCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 11:02:18 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B7CB76C;
        Mon, 23 Jan 2023 08:02:17 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NEEh3f026059;
        Mon, 23 Jan 2023 08:01:55 -0800
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3n8e9sw937-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 08:01:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crPZI+EJQmrGEK+E/OEZg+HQo2BkoL36P1c7tb0NqI/mjwq3fMy1ZbktK8Q05l6e+Tvtj8kxc0GWd89y/FjBd40ilj6H8t5x3NxnKeO+RCku6PnpzW2GQgl29cyAG5FdWURfha9UHg+tG9Mt+Z0js3EgKylSYMexBzHTza9UeH3z/mCE1vNlxO/lb27u4Dn1JGl36eidtSxAwokXoD1TUH/rXwgyvKWwHOZYbAtgyntCO0ikuepRdvQDDg1235Sar8eduD5ABOSuWWjzw14fx75j5TfA0JG4kTT4/BdZU07fIhhZttGSeLkYe5NtGynk8VCpcVTHO/p3qCH22BVg/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wtPLpdqBWO/uVu0ZweEZ2Ttpe5/fog5r/7GgSieaRdc=;
 b=MGCLG3QmChOP2MZemxJnGMYiYcmdCUZhVE16jBdQxaa4h/KNL+COQWvyP27HvKfSBA+siS+KxgygmmMk+ktsD4jDznk24bULaKuQdKd0COuFNfKSowNgm7e4p3TGog4nHBqOdBqZ/WKWtBZUQ0nO0MmSTCPrDqFx7XQzllmfh7BmH4af0P+pjBLWwsIXHrplmJfqGVRAPK5Pk02mtKzQEUG4JJEAPvYyyXUWQAPmMzDATA8tf2UazK3SPjHE+Yi0tO9qA6N5AIChjb7ZXlN6qkyjlEK4gSMrbO+TXt4i/naLpbqvivW3DH8D7cpbCxikd1/OO1zommJKk8hRV3ggrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtPLpdqBWO/uVu0ZweEZ2Ttpe5/fog5r/7GgSieaRdc=;
 b=qFDPrdN5f9eG+6m2LeEqr5/jgO8cOgHNw3Cdd+QR7bFXCQm64q+vQqq5PfzvV7q4WpDnwuf3HQkBBqnkMarqPTOQTTZka0kDxYtrWT4SbMBFba4USQUUAFTrBUFxTTdSoNEDKtxZLtH2gKtyFXdmIIhs65Lng8YPYMJpjqjBabY=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by DM6PR18MB3490.namprd18.prod.outlook.com (2603:10b6:5:2a1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 16:01:53 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e%2]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 16:01:53 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
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
        "maximmi@nvidia.com" <maximmi@nvidia.com>,
        "tariqt@nvidia.com" <tariqt@nvidia.com>,
        "moshet@nvidia.com" <moshet@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "maxtram95@gmail.com" <maxtram95@gmail.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: Re: [net-next Patch v2 1/5] sch_htb: Allow HTB priority parameter in
 offload mode
Thread-Topic: [net-next Patch v2 1/5] sch_htb: Allow HTB priority parameter in
 offload mode
Thread-Index: AQHZL0QCO87Fr8OC60ePabgspZQyHQ==
Date:   Mon, 23 Jan 2023 16:01:53 +0000
Message-ID: <PH0PR18MB4474A678CC3A6AAF0D69CDCBDEC89@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20230118100410.8834-1-hkelam@marvell.com>
 <20230118100410.8834-2-hkelam@marvell.com> <Y8zz/eDMsXEr5KMk@unreal>
In-Reply-To: <Y8zz/eDMsXEr5KMk@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctM2RkZDBmNjktOWIzNy0xMWVkLWI2ZDMtZDQzYjA0?=
 =?us-ascii?Q?N2UyYjlkXGFtZS10ZXN0XDNkZGQwZjZiLTliMzctMTFlZC1iNmQzLWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmI5ZGJvZHkudHh0IiBzej0iMTg4NSIgdD0iMTMzMTg5NjMzMDkyMDM4?=
 =?us-ascii?Q?ODAxIiBoPSJYQUdQa1RXMGtmL2pUQXY2UkQ3WEJIcW9oRzA9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFOZ0hBQUNS?=
 =?us-ascii?Q?TURjQVJDL1pBU3Z0cEJJcUdrVGNLKzJrRWlvYVJOd01BQUFBQUFBQUFBQUFB?=
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
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFIUUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFCc0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJQVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJnQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVBY3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PC9tZXRhPg==
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|DM6PR18MB3490:EE_
x-ms-office365-filtering-correlation-id: 6cad35cc-cd82-44fa-f955-08dafd5b2512
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p0P2mpVbGYxhYt4nL+phYT2iHLbn3CD08H9zOwFlsKu1fAH9d+qHpmpU1QFTazaDipQsgTKoCfaJsRAy74FYoRtUt0IBJejTEY76/tm6NDjiE5+yhqHFT3SJIa5nWxbrSXsPPAOWX48F8pDGaCiNtqHLtEu0WVaz1LTOnQfYccEjt5ijXYywUymSj68fyOmZ/hbiIBTKB2UqeAiV4KEnUfeO8lOH/F87r9SFu5cWRsOoNvKwdcYlGL5dBYaRPI6rUgzYB9S0rtQrhKAbDAaBN9ch2pe62FYxSOOIWGynmAqp0XxAWo4diY2VwYvMrQeTiChrC5DBwlRblqDU0etCtMFjjbmxC3irEPEJG+5SQ6+OBjX51VDYOWzcLIpJKLakHqljNR9WVsw6zwYZ3IYBNvpjiTwZ8nped+BuHDgAsvxkJKHdg00zhVpAFU8B0+Bo4xVZlKCDDliAv1yj9MJRY/YZb37Nswdk64Hr6m5ym8NrFCwmFlVqFa5XUFTQXuAp6UYu+n2At2ZskdwBCn1MFG7v3VQIEkccIApQuM2i6Fq1qPocbExOhxZCYiB+6j+3inoBjgi683PE83GVGwYUigIV39x/MkHxxZbki/PH6a8dCWvJkoE4e/wtx/99Gw2yhO7Av+TjDAOA4a91JHJ+YCKC0jYkwWmN/RSXc14/aqOHMjGZkCk5qCsjOkcLBrg6e7Wc6ANBZOApG74T4NWYHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(451199015)(41300700001)(86362001)(38070700005)(7416002)(5660300002)(8936002)(52536014)(4326008)(2906002)(122000001)(38100700002)(33656002)(478600001)(71200400001)(7696005)(6916009)(26005)(8676002)(186003)(6506007)(9686003)(55016003)(316002)(76116006)(64756008)(66446008)(66946007)(54906003)(107886003)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/228mO6sdFQ9i/9ZXs6i7+tpl4TFZsoWyKOn4HQyvThNmBwqcWMzfaHCxuFh?=
 =?us-ascii?Q?OLTkh8n9o2C2N1PrsctioDLCg0gADVDhp7ydUao1OJJpie9mSobhHCvk94BB?=
 =?us-ascii?Q?1V8CoE52RCMv/Hd0xRZTDOGy2a7SVaeArhVUMouRhgIOTlBAOsdAcemhrg/d?=
 =?us-ascii?Q?w5gJ9Ctaeiw/NMrqPdoksW3XscK1Qtk+1GqQhs8xtyO0rVzoYExyyUX2/nWG?=
 =?us-ascii?Q?MjM9ykHaUuNtPVx74aK0PAXe4GHgal7QltI47GCb7CF1JnXId6Rr4uPWshXy?=
 =?us-ascii?Q?tAdllYQjfEjmA72CzOcZFh09a1jhG4tydvh4hCQus6k4uY0j/o5pO/AqfDGs?=
 =?us-ascii?Q?s4+ZYJYpYuiiaomeA3Ev2Uv/t310zBsYpqCqxxSFs8v1QIt2YUIalOptC0TG?=
 =?us-ascii?Q?rEDjYz4ykI0zFbWOaiRIbIcm5w+QDMpG+1BX07Sn9CLc6qqIMvNbmCDm0xJo?=
 =?us-ascii?Q?NruoGGeBm6xiZVDoMqqmQqeH175Pz/ZvJt3hFb/YXNRU4ImCR5hPRpTacJ9i?=
 =?us-ascii?Q?O4o6Sd0kUeTjrOjtaAdRWZlxkrRzEeKLJ1ui21/a1+V3UIWSKB+DdC0KEnwe?=
 =?us-ascii?Q?+y1BR3G/ChD252UB20TawhdHl8r+haICCy1UjoS+eNBMHAx80UFDnJZO/w0k?=
 =?us-ascii?Q?8+TDgmNIHQDOfQtOd2+NbuF4IS/QqcxDktHKI6Da9/7pIh7e4z9vqTF5sDvT?=
 =?us-ascii?Q?Ab0PeDkOLzZjEl+OWqFOfAkUzdD7hgXk+eGIazgaLWdYa9rJQrXNfPZOGaoE?=
 =?us-ascii?Q?MAr2M+ssNArZO3+DYcSnidJkdFyRxg9H+mtHppPsHbkG16eRYOwrHN7LMpHU?=
 =?us-ascii?Q?iR6aWFfjePsbj3j+OEDafzzQFtW9Wjr7902N3E5NlDCbrtoiozVijV8aiT+f?=
 =?us-ascii?Q?Fv6/bPEreg/tSXR8F0zvM3IOzF7O56fZYHl1ujDXuE4+UNRejns3FmlI9axR?=
 =?us-ascii?Q?uFGuOBn0RRCQerBqPLDAwnYIcg6aZWTxujYcQFWLWGSZESHBC6V/gwzLrQbO?=
 =?us-ascii?Q?UHcfwh77awOzYiVvd3PPKx6qqAvzBFKCBfiDJoDhSoMO9sXqAgfI8b6r/FxT?=
 =?us-ascii?Q?safGM5NBbd3DTgJN0lSFIcZuCrw0YkVdL+gx01MJ0Wf6bhK5q7fjoTCnL1Vt?=
 =?us-ascii?Q?F8mWEELhoQ3fNf2Uk/zVa6fX4kPyWzBg6asHe2idiA3iXDjpVNQaWrirJeQS?=
 =?us-ascii?Q?FSBpXPP+fIJoLMa1UrryM124pVi3akng4INCNs0//87MVaXnX1hVYhfMJACI?=
 =?us-ascii?Q?0wFTrdytxxkcJ5csoQCit184z3b7aYLlqK2SwvF3YhMLQaQpzVzZ38Yomgd4?=
 =?us-ascii?Q?fFDarB+LKcf4Av+xBGZOZjgpzrwoSiQJHibr4vnUhL+FIxbXwTzt2pUz/guP?=
 =?us-ascii?Q?W64DuOfydOYFLFemx9nlteJJQFwkERKaxyzHYJcpWFaVHlCJzf/NroNH+MbG?=
 =?us-ascii?Q?vxX0JRSjmUB5JPWBxrnQGTMBh2eSODiIjMvGyf6Mll7JUO4wCIafVNTqsoeY?=
 =?us-ascii?Q?bSSflJXP2nQUbq2h3LzG8TPBKxfZkUySTS36YZXZnkm2rMnZP2UMb+0ZaQMj?=
 =?us-ascii?Q?telZqtPP36rbVZZacS+BARh+K60oXzPY/frab61G?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cad35cc-cd82-44fa-f955-08dafd5b2512
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 16:01:53.2041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wNb/QAyDlGMrfKrH2jezheLkTZLBY7R9O4lK7gfzWLUD+wDkyJ08dDA2KGTsDwkGCZ6S9+p/ntOUtZKmMrF4Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3490
X-Proofpoint-ORIG-GUID: Si240MXH1UUVMwohBj0_hkZgQUeoVtnH
X-Proofpoint-GUID: Si240MXH1UUVMwohBj0_hkZgQUeoVtnH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_11,2023-01-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, Jan 18, 2023 at 03:34:06PM +0530, Hariprasad Kelam wrote:
> From: Naveen Mamindlapalli <naveenm@marvell.com>
>=20
> The current implementation of HTB offload returns the EINVAL error for=20
> unsupported parameters like prio and quantum. This patch removes the=20
> error returning checks for 'prio' parameter and populates its value to=20
> tc_htb_qopt_offload structure such that driver can use the same.
>=20
> Add prio parameter check in mlx5 driver, as mlx5 devices are not=20
> capable of supporting the prio parameter when htb offload is used.=20
> Report error if prio parameter is set to a non-default value.
>=20
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Co-developed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
> v2*  ensure other drivers won't effect by allowing 'prio'
>      parameter in htb offload mode

<...>

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c=20
> b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
> index 2842195ee548..e16b3d6ea471 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
> @@ -379,6 +379,12 @@ int mlx5e_htb_setup_tc(struct mlx5e_priv *priv, stru=
ct tc_htb_qopt_offload *htb_
>  	if (!htb && htb_qopt->command !=3D TC_HTB_CREATE)
>  		return -EINVAL;
>=20
> +	if (htb_qopt->prio) {
> +		NL_SET_ERR_MSG(htb_qopt->extack,
> +			       "prio parameter is not supported by device with HTB offload=20
> +enabled.");

NL_SET_ERR_MSG_MOD()

>> will add this change in next version.

Thanks,
Hariprasad k

Thanks
