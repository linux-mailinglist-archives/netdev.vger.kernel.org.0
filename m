Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67659678312
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 18:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbjAWR0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 12:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbjAWR0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 12:26:50 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324182E0C9;
        Mon, 23 Jan 2023 09:26:45 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NEHPYF030291;
        Mon, 23 Jan 2023 09:26:31 -0800
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3n8e9swpft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 09:26:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZUIMvP570AQCaEAVYcJs+XuENu/RYYCGqQ2Qbpfi1WtYd8yUaeMdshc+edB2wjvWy2Prs66drm1cx4+joV5f5+wJoSqpzfwks7CXLseQXYOHeBX76+MzPQ31VUnQrXGJyMaDT2yTEAtbnP2azxCv1rfQqrjqXCYzvfITqm8wqkwqdJs5qA4Jt4TIVh0zoNIRBcL2McEUauSy1dSWDRLp6sz8WXVhwdq3EpfUWOxk45saZgGCaaEu42lBpfdnwHqxFCOom7yJ+cPtGYiCneOPABLX0HkZVH3+NcAqyADp1qs+zR3OY1kCEkHycGazRdoIOwnb0s6VLw6zGkjIownxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTRIbxAf9zLjEaHSl5LgFu5j6YfD21IuU8Gb+tLtkG4=;
 b=GHLKmREckb38XeC1IkpQbaUnoBig5tJI5ek69e7+Dc5MmoZCdrHbNBptCxcTbIB92rjxrqfPJR5NQF18+ELVP2wNyZokvqK1iXB3MMUWJ7GY4mrtr2GjKSUjSmxVRyJxd4KgvWXzb2Qj7mgELZ98IEIPxL8z13PhIbFLqmKZ7LoZT2C+tO8HQn274UWlQk7SJvSh6LweySbfKbZknD8MApIF9RmLHcAntnX3CUkAjsvtXwWnGEr+J1ji71IXFgnvbrhoApLQFVwbH08xZQBFYe43C6kcb1nfkjRuP1icwHVtwoKGMSoxWZo3dqlGoFi9FrC0/hFkNnlohFFD01aLrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTRIbxAf9zLjEaHSl5LgFu5j6YfD21IuU8Gb+tLtkG4=;
 b=XwIPWLIm7tFeEAa6Iry8t3wROPLlm/5EOZEDXVZyHUumwYi4uSVE5whzT8BBuugxSUT3bpvUCCj+KKt9vNguHesos6ZqNT2M0BS7JSdwb7KxsGk9Bvv8V3jssE8pgBBrf293krwt5TKExrcLifhmNA2b+tsE1fGBe80GmvjsdFo=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by CO6PR18MB3810.namprd18.prod.outlook.com (2603:10b6:5:347::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 17:26:27 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e%2]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 17:26:27 +0000
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
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: Re: [net-next Patch v2 2/5] octeontx2-pf: qos send queues management
Thread-Topic: [net-next Patch v2 2/5] octeontx2-pf: qos send queues management
Thread-Index: AQHZL0/S7zsZxEsHj0aeZHreC7VI4Q==
Date:   Mon, 23 Jan 2023 17:26:27 +0000
Message-ID: <PH0PR18MB4474BE62B79C293DFA866967DEC89@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
 <20230118105107.9516-3-hkelam@marvell.com> <Y81oeTZiSTOCXsoK@corigine.com>
In-Reply-To: <Y81oeTZiSTOCXsoK@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctMGQ3YzhlYWItOWI0My0xMWVkLWI2ZDMtZDQzYjA0?=
 =?us-ascii?Q?N2UyYjlkXGFtZS10ZXN0XDBkN2M4ZWFkLTliNDMtMTFlZC1iNmQzLWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmI5ZGJvZHkudHh0IiBzej0iMzUxMSIgdD0iMTMzMTg5NjgzODE5OTg5?=
 =?us-ascii?Q?OTc3IiBoPSIxRWc3NHJMS0FJaU9jdlRTM0NISlVaOGZrdUE9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFOZ0hBQURa?=
 =?us-ascii?Q?UzliUFR5L1pBWjdSWkh3UVRtalBudEZrZkJCT2FNOE1BQUFBQUFBQUFBQUFB?=
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
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFIUUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFCc0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJQVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVBY3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PC9tZXRhPg==
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|CO6PR18MB3810:EE_
x-ms-office365-filtering-correlation-id: 1c5eaaad-82ec-4a44-6482-08dafd66f571
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G4+UHtF3ZO3JXIw+eNCxVaTlVbIeoxrAELPyHNai0eiHkUsKXPnFAiW6NZ1QqQh7uECzEjQ/oAbvY6TKBH8tjR0Ys75AxTVzoN78/0Q4sbKZVgi63NknfLgVDBO17XcR+1hpPp43ymyiWiUK51ImMgI/EuxQA4J137JkVc6gQh0SUkNMiWXxllDZje5ZY0ljbnmO6X6dcG4N2sajeIDYV8wxYm2DlDjl1Z88vKkD4bikXPOftIHxO35ABhxFOOebvXc/5zOhXyMhULnd5iL2a/WUowF7ewhxGPcB9HFBPz+fozqerNz5GmLoenRhXOV4dr5R1t25yfYuMSK5g5SF5ZMnqeGoQlRSuGSD/Rg8XQ01DS72JhOxxCtjXjgB4wpv30XksQgjiLttFp2/B3bvqKV0INQPwtmg6yRLeehkSBw0X8PFAVga+iAQxOWg+lteH0JX/R76TCj7Ijzzh14ju3oLZhvQusXXJz8+45atPO1/oPO5seI1mesu5d8RxdOYT2EYgKysgi4QW89yJnO2AHtYxro5GQJ8LDZ5EyYvQRw2lm0MtvAcFfZ16SBkKTtj+qyfU4HFs30ibVNTu6U6OLvzPJiJyPpl5e0EGR3ZZLtB//VCODIhkK1E7pEtTyoorHq02snJPKSX/Xfxka4if28Clv3Do1IQsXDyHyhBWdOxjYylQ3Lba/Am6jFnUowFcgMIM/IYp0sOkNsmDtIBkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39850400004)(136003)(376002)(396003)(451199015)(66899015)(38070700005)(38100700002)(2906002)(7416002)(52536014)(8936002)(4326008)(5660300002)(41300700001)(122000001)(83380400001)(33656002)(86362001)(26005)(478600001)(71200400001)(7696005)(66476007)(8676002)(6916009)(6506007)(186003)(55016003)(66446008)(9686003)(66946007)(54906003)(76116006)(316002)(107886003)(66556008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uDzIKrFJGILim+c6uWa4BXH9BT/GgferFQ7wadp2NX0qRtONVhNaxqHz44R/?=
 =?us-ascii?Q?kNJKWYzTYR5wCVWAZTE/1kUXU38NAB4LNh6PKP/gRVoGZH4Gn+BiegnuBeC8?=
 =?us-ascii?Q?M5KgLQIe0ZM1+yaeJJQjh7goXJWrmtNBQ6bnAztmPI30U/6/d+Gy6UUZdu/Y?=
 =?us-ascii?Q?KX+/Iss4u4VkYkAuq0/rXYprlJFuzlGJBcvBBPsEDoSdgP4lXApYQYNnoZEe?=
 =?us-ascii?Q?ra8F54Sz5IDm3L5YWm/2wYH4mvYhoEJzQboVcGUgPGtmOxM00HxUcIA2kspt?=
 =?us-ascii?Q?XvhofUAFFTp/7TJ5OApdP2Xb/GxozM8bF+G1Re3/lc+CyMvUqwOa9B+xFoc7?=
 =?us-ascii?Q?kczBLtmmhztCbxpjrfbSVc1cYmFZ8fdtVgFGfFWO1qOqkbq1f4pEdeuX9ymR?=
 =?us-ascii?Q?g3rXmP0lcNU1Rt+wnrZkDTCd6bpNq8LxQ1WYsGh9ucwoyo+3FfF0Q/0EgLms?=
 =?us-ascii?Q?c82fXaXrPTrID8lxP64XTkoBYwPX/mfWeHmtZ8UHQm3XOPsSJHL9qVcL9AnW?=
 =?us-ascii?Q?v+UMNYNw8CGsm12L1D6ji9gdrRcv5udj5DpzlAvl1FtbjuLhMBRetHfVZjil?=
 =?us-ascii?Q?7R3LvuSWzIvgISt43ozRCBmmb4IYPUgg6Ecc7at9W+yYoD/r02IsFDCWvgkB?=
 =?us-ascii?Q?CSqelTAbgOex/EyiKJXZdOnheHyIJIXmeRQmfq1Knt2RTFcP7goeUzeOvJpS?=
 =?us-ascii?Q?2pdJfRryS+oYXwRfuZBxaIdzGggBCTX6HneTkKV5xeeupcHzjEmHNExSslbb?=
 =?us-ascii?Q?1WsiaRLo74Zz1ZRT1kECnbrF31elZ0xnmqInW3LYJ9S3kgxOu7F2Te4/lHxU?=
 =?us-ascii?Q?xqrbFoFtCrHzQ3S9XGEyViH6JDh2U7NPmsWSzR8YNN2slDOKqVRGGqfcKbND?=
 =?us-ascii?Q?cVxRMU7WQiyy4nlxxTxjCEKPC0i9tR5McXwK/UtrSmfzJHcBvj+qkluw6esM?=
 =?us-ascii?Q?XcoTcRXl/M+x+3KKFPrCeGgFoXiGSELur2S9IUpnVRUjU0gTU6j/ldr5wehT?=
 =?us-ascii?Q?ZopER30ZUieQY1fiivhdBoItKiyLC5j1WZrYOBCK5WD945a5tI1MQQTSb0bn?=
 =?us-ascii?Q?gfgtj5jRabrl+lds0wf4SSLj4byh7jr9nhODejDipxq/IZjLBOAA8tYjOwvk?=
 =?us-ascii?Q?LNeslt4C32p+2tFCspPXqcB4CYP8zzeJ8to8HnSEH09wuOq4wX6c94y7mf6B?=
 =?us-ascii?Q?OnuQomXHrUEnvTe49kbsvPOBX90q0ln5nht+nZh6p+IrwmK+chCcYBswdXRP?=
 =?us-ascii?Q?Kx/LDzUqhYVNvSYIXYVhWErs2jmMoUi4ku7ImsKHcnYqMsJBLWLgtpbA8Cvv?=
 =?us-ascii?Q?4hVAYCZuGyZUMJDY0i0jCQm9rOHY5cf3voHweUrj7Z7K3LZtvITna4YSaHWK?=
 =?us-ascii?Q?WW1PgdJMewhEG59L99G3nStqF1i9BQXVbK4EAXfVPZ2kmJsq+7uyUzeLplO2?=
 =?us-ascii?Q?sM3+eJcNkMJcQPLLYeYa34ZJbpQW0f94tYee81fJtHKm7Uk1mVf4Q6nkKTIY?=
 =?us-ascii?Q?R29uaSOyttWe2pF/UcaQzfoI21KPF/OGak8PkEtdFXKfpcZZVp861/QKRD6i?=
 =?us-ascii?Q?wGDV86r3hv5nWu+6tdQJXvfaQhujxB9vvbNfD5wR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5eaaad-82ec-4a44-6482-08dafd66f571
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 17:26:27.2374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0/IK6eSfyF0XYL5NsX95+7F5pLwASchGXbG6eNc2ZytGXIfWkxLObeK1V0rCDgzvVx1+M5/vAwJX6U74T8KAEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3810
X-Proofpoint-ORIG-GUID: FGy5x3uL78oshGqztjSwa3uXWV8Dqi--
X-Proofpoint-GUID: FGy5x3uL78oshGqztjSwa3uXWV8Dqi--
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the inputs, will address the review comments in the next version=
.

Thanks,
Hariprasad k

On Wed, Jan 18, 2023 at 04:21:04PM +0530, Hariprasad Kelam wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
>=20
> Current implementation is such that the number of Send queues (SQs)=20
> are decided on the device probe which is equal to the number of online=20
> cpus. These SQs are allocated and deallocated in interface open and c=20
> lose calls respectively.
>=20
> This patch defines new APIs for initializing and deinitializing Send=20
> queues dynamically and allocates more number of transmit queues for=20
> QOS feature.
>=20
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c=20
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 88f8772a61cd..0868ae825736 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -758,11 +758,16 @@ int otx2_txschq_stop(struct otx2_nic *pfvf) =20
> void otx2_sqb_flush(struct otx2_nic *pfvf)  {
>  	int qidx, sqe_tail, sqe_head;
> +	struct otx2_snd_queue *sq;
>  	u64 incr, *ptr, val;
>  	int timeout =3D 1000;
> =20
>  	ptr =3D (u64 *)otx2_get_regaddr(pfvf, NIX_LF_SQ_OP_STATUS);
> -	for (qidx =3D 0; qidx < pfvf->hw.tot_tx_queues; qidx++) {
> +	for (qidx =3D 0; qidx < pfvf->hw.tot_tx_queues +=20
> +pfvf->hw.tc_tx_queues;

nit:

It seems awkward that essentially this is saying that the total tx queues i=
s 'tot_tx_queues' + 'tc_tx_queues'.
As I read 'tot' as being short for 'total'.

Also, the pfvf->hw.tot_tx_queues + pfvf->hw.tc_tx_queues pattern is rather =
verbose and repeated often. Perhaps a helper would... help.

Will add these changes in   next version.

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c=20
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> index c1ea60bc2630..3acda6d289d3 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c

...

> @@ -1688,11 +1693,13 @@ int otx2_open(struct net_device *netdev)
> =20
>  	netif_carrier_off(netdev);
> =20
> -	pf->qset.cq_cnt =3D pf->hw.rx_queues + pf->hw.tot_tx_queues;
>  	/* RQ and SQs are mapped to different CQs,
>  	 * so find out max CQ IRQs (i.e CINTs) needed.
>  	 */
>  	pf->hw.cint_cnt =3D max(pf->hw.rx_queues, pf->hw.tx_queues);
> +	pf->hw.cint_cnt =3D max_t(u8, pf->hw.cint_cnt, pf->hw.tc_tx_queues);

nit: maybe this is nicer? *completely untested!*

	pf->hw.cint_cnt =3D max3(pf->hw.rx_queues, pf->hw.tx_queues),
			       pf->hw.tc_tx_queues);

Will add these changes in   next version.

...

> @@ -735,7 +741,10 @@ static void otx2_sqe_add_hdr(struct otx2_nic *pfvf, =
struct otx2_snd_queue *sq,
>  		sqe_hdr->aura =3D sq->aura_id;
>  		/* Post a CQE Tx after pkt transmission */
>  		sqe_hdr->pnc =3D 1;
> -		sqe_hdr->sq =3D qidx;
> +		if (pfvf->hw.tx_queues =3D=3D qidx)
> +			sqe_hdr->sq =3D qidx + pfvf->hw.xdp_queues;
> +		else
> +			sqe_hdr->sq =3D qidx;

nit: maybe this is nicer? *completely untested!*

		sqe_hdr =3D pfvf->hw.tx_queues !=3D qidx ?
			  qidx + pfvf->hw.xdp_queues : qidx;
Will add these changes in   next version.
...
