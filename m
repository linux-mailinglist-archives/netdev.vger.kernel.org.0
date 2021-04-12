Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2A635CAD8
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241331AbhDLQMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:12:42 -0400
Received: from mail-mw2nam10on2071.outbound.protection.outlook.com ([40.107.94.71]:64385
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237798AbhDLQMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:12:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqQHUby1nekfRoq2214MqcxFfl+Yli1MvbAQDQeqpv/wk/Oksz6QKfy6VSZ3Cz93UkeFs0fQW9CIUN2sQcZ4Y3lluLwGm4z5Pt5nxcibJbn3gqq2LgI0Vh+WE5lmMWSvmG4AxL9xi83auyBCEeETcxSWu/u555z+HJlX4g7r/t/2tmjI1cD9+BioSCSI9H3ZTm2GCSAAvNA1bHfbhG/XLlWR4NSlVt5vxvwcBvg4qO95E4q2SSIvBazXZQFWTgabIYpkPYBeZaXwxsDM0rmvB/6TVZf1nrvWFayOePDEXQLedsjm0WwRa7LELY+kv4JS/4AfDvtYkulQOHRtEqAuFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+uasTNZtw9elqIRSBoLLyw89Hi6ooHYRyopiZpkC5c=;
 b=oRf69zSoJonuKgXqF6oTqew4/6BUjiZfo6SDNWaHo97Pga14HCEq2oUpUZk3sduh7zm9U6UVUpLWXwUnjvW2+hhCRx3vGaemAP6LSbN3xnVj+ufJ405utY0qUYKgLyF6MU9yfOsYNlSeq1rLByudRfJO0To9cVwMF16fbXI8nPwU70TyIzNDddckFOK6fHXMggdqmtq0iNeTp9yQDRm9Z0ZRTpFxErRyc4PZGaddU9XFLWMEI0TIJ4oxL5ZpDX1jCM+FID8HErCK/9hDWLcFObGbd97eDWEBVmQEaDMg53dAueGMWe69okp9wYkIa6MfsqPnk5hjCRnkDhWTq7CfjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+uasTNZtw9elqIRSBoLLyw89Hi6ooHYRyopiZpkC5c=;
 b=mPyG+XkeXrjv3dRyWhypTq6JgvDMeMDC+AmP8Y2dk/fRdG3BXGUIkx0ncUatB0xjMgD1U64KSS4tvD6+ZPbZNx9KGO6YN/+0SuIIk6LxcHYxS8n8M/hsuHgdjf9wQOpuGWYznjU6ZhDKMs8Kf3kNim25Q/pc6zc0y60wCXHC7h8fdhtocB/8r242eS7gjp6Q8W9iHi/wuyHgSUqxlExG4p2+I0Wwg0qOjgEqfEo9QMXaRxCn6Ay4NV+L+WL54T2jzmAV8/3Pb7Rajn5/8K8JkWr2tOO3B46kLj5Hh2YHiU38yoX86Oyj0+aRfoHw3MFKzKWv2zfXrlZSWqekXmpbkw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4618.namprd12.prod.outlook.com (2603:10b6:5:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Mon, 12 Apr
 2021 16:12:15 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 16:12:15 +0000
Date:   Mon, 12 Apr 2021 13:12:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "Lacombe, John S" <john.s.lacombe@intel.com>
Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
Message-ID: <20210412161214.GA1115060@nvidia.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-2-shiraz.saleem@intel.com>
 <20210407154430.GA502757@nvidia.com>
 <1e61169b83ac458aa9357298ecfab846@intel.com>
 <20210407224324.GH282464@nvidia.com>
 <2339b8bb35b74aabbb708fcd1a6ab40f@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2339b8bb35b74aabbb708fcd1a6ab40f@intel.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR06CA0018.namprd06.prod.outlook.com
 (2603:10b6:208:23d::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR06CA0018.namprd06.prod.outlook.com (2603:10b6:208:23d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 16:12:15 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lVzAc-004hAZ-0l; Mon, 12 Apr 2021 13:12:14 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d453756-7544-4c29-a703-08d8fdcdbcf0
X-MS-TrafficTypeDiagnostic: DM6PR12MB4618:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4618B55F2FFDCE9740994254C2709@DM6PR12MB4618.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vd8KvViw9KFXdnJKtpfqw+TgogPcXjacZFsReiVtgrSk/ZNXAnkjwdK0pPe4GJnsrpLmV6UbGzzvEdApV6p4J/Xtpgug3cktya6QKYgM4FeVliiYrIC9Rgx6qKaOMNXo8BjhySxNhSKFauAlikwf9PuoZ4/2+1CFkDSMDjGVBQ5trtdZ3Hc4Co9qm2p0ybqhPXh4gzIfXcYmrCG3lXExqjHzWyCv5fKz+jTx2m/Q9ir5kE74QF55y16THjc7v32AdilKtzgFwVqfH/y9HgWfZq6A6dp5K4RlM89WyFDfJxzA6nOIqeWiakrmaxouXiW1xqBrihMz/wY7mS+NuCrCqT7BPoqIbwmzYO5vPfYkG/OyuuawhLHxytfM9WbQlgzfzri3sEYQlzEekdTNMdjZ1HZ0rewqI8iqXUHY3r1Mr5iBmy6Va8by2QSicBstJEhqLkM5xwOGueggGoZDXurFcOC7no5CnO+n/y4NWh5ieN7VGlUDuboj9GUy2s9oD1CLvT8g8hoTkQY01024rOUEH3BN28XZLoeakgbzysSQ+OJhC7Qr5YzzlpOOkgj5egOyX4cP14yMakBUpEwmqXqbbmn1u8c4iEnpDUAJGAlT90w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(83380400001)(66556008)(26005)(186003)(86362001)(36756003)(478600001)(66946007)(7416002)(66476007)(2616005)(8936002)(316002)(426003)(9746002)(8676002)(9786002)(2906002)(1076003)(38100700002)(6916009)(5660300002)(4326008)(33656002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O3mAwv1Vx+bjZCFJV9T9kxThGKVFC77lXIGO6Pnh2Uw5OQD+jvf8yGaX0kaY?=
 =?us-ascii?Q?NYA7pFMWnjcBa/6pIuMmZ0FoZC5Zc/q8tvEqL+98PJQb9EAqSE40HZUtY4XE?=
 =?us-ascii?Q?UN0ZRGYLTjhCagO31/4Z2UsvK1OKs8ruoAP0Qr8ln8/zEzmmCHRe7B+N5YhY?=
 =?us-ascii?Q?Z4ce0Wke6NU3C57V1BNRfpFxdwBDbBU4MDGbDvlbI6/uvvf6KiaZ0Jh5NUtR?=
 =?us-ascii?Q?EUQwDTBNVLgP6cXWS0KxGVIrROmAdta5gOobxNbwWwEp+vip+VMGY2jK2ico?=
 =?us-ascii?Q?tUZMeXEx/nN4TJ9hhuRRhJqvxDg0ZkqVTnPRRzHklv4LM22gHLSOM2KNETwN?=
 =?us-ascii?Q?dT2T5JZ93tanqOc8NJ+lNZN2YFDi0bHHqMZ56Ftn0pWb7VmSeyswjdDzeREe?=
 =?us-ascii?Q?XElqJaKjZsLrp0PzZRrheuROXusJ4ES+lsGfRkxWCICCDPr4To5yZHg71Lyg?=
 =?us-ascii?Q?IatT9xt7OA/wd+irSLTz3TuI4r0y1hj90UAI+NvmeicI9GwhZjieUZXugJPT?=
 =?us-ascii?Q?U37aQ9QdOUiJI1+xbemZGbHLkPnodKmDMxetlx0CUoL5QoCVmIIcKlYaNwZp?=
 =?us-ascii?Q?U/PYmx4WBOzMqW/1pgnTT3h+7ef5oZnKmzCsmI2rluNK7Q8gnFvYHB+t9cEg?=
 =?us-ascii?Q?gRTJRvMjvz23YPz6SBe8XnZ+J3PxDIkXK3h1z06uj5cYtNLGdzsTIOWLPCci?=
 =?us-ascii?Q?YgmKMJ27q3C9rby/n7rA57EXIJ7u4j0vMvohqbQ2iXynozCWKfPxq8/7Z0Iy?=
 =?us-ascii?Q?6zShjB6IR9EIgawnzDwu3P4p3DXX0aonTT+ZJ1in8RUkeecnf1lzGMzneucA?=
 =?us-ascii?Q?5WILuyISXk3PIROovqMRvP4lCJFPum+CvxBER2QlT3Rt2dYLmdO4MJBSzk7V?=
 =?us-ascii?Q?Y9cjL+QPynaXpgDv1xjxfnPZm+HaapALI/cKA9JlTX08fg7qPTlJkyfxC4Qr?=
 =?us-ascii?Q?8JcESDEB4vLs2knzrDj7cUwaL1uUtsCERLI6NFXyFgt5YQh7TORLUUnuDIY/?=
 =?us-ascii?Q?4jfQNErr+898sgp0uyW7oV8x9C8ZKWj3v8qDuW9eEnfjlcAOsiKzrvZgoqy8?=
 =?us-ascii?Q?V3VDlc4SQYhZh8HX7YCWcNTnp6ICladiWRtbwHkgc6luJ6x0r+RhfhqYsHaG?=
 =?us-ascii?Q?6Y+Nw/J42OqLkKwQOV5hXMkogTMcft418lDiUICHWsw9gJOF3QVQW9muXOQH?=
 =?us-ascii?Q?0aVdYVpjxVPUyxp3c2wq1deKzJIvk9c2DvB40p+ni0mTxGreLeCklxPK4m+h?=
 =?us-ascii?Q?wIQ/zX2GiAWvUZZ7+Xl5b/Mcrj/+ca2UDSfyOc9HZ0yN21JT0QYQnaD9tAW6?=
 =?us-ascii?Q?7xCjl9SGEr6YR/wB2nqWPaAiQwUzULvnokW+Fynk3Jz0oQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d453756-7544-4c29-a703-08d8fdcdbcf0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 16:12:15.5124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xxNCWYBmZhj8OI4m7RJwJLTZJrHe75nABaXl4gwqUGFGPoN3N53IxnniZohBgs58
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4618
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 02:50:43PM +0000, Saleem, Shiraz wrote:

> Because it is an unnecessary thing to force a user to build/load drivers for
> which they don't have the HW for? 

Happens automatically in all distros, so I don't agree with this.

> The problem gets compounded if we have to do it for all future HW
> Intel PCI drivers, i.e. depends on ICE && ....

Then someday build a proper pluggable abstraction and put all your
ethernet drivers under it. 

Today you haven't done that and all we have a set of ops that only
work with one eth driver and a totally different set of functions that
only work with a different driver.

It is all just dead code until it gets finished and process is to not
merge dead code.

> There is a near-term Intel ethernet VF driver which will use IIDC to
> provide RDMA in the VF, and implement some of these .ops
> callbacks. There is also intent to move i40e to IIDC.

"near-term" We are now on year three of Intel talking about this
driver!

Get the bulk of the thing merged and deal with the rest in followup
patches.

> But in a unified irdma driver model connecting to multiple PCI gen
> drivers, I do think it serves a reason.

It is fine as a high level idea, but the implementation has to meet
kernel standards.

Jason
