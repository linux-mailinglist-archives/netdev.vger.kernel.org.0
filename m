Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01DF39EA07
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 01:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhFGXUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 19:20:36 -0400
Received: from mail-bn1nam07on2042.outbound.protection.outlook.com ([40.107.212.42]:60286
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230183AbhFGXUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 19:20:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SxIwi4Xhcnkklb6lhyEtkOHNC+kNNzHXIoezBroFJweqL1X7rdEtS13l6MggGcPkb9tKpQsutosjc6FJoxfw4zUqs/4gfGvm9vTMjzsGB1BhFzN8b6Yw9VqlplFWyJfuSOWeB9e+Ce6NhC0yLAhDob7vu9xynLOKjRjGPRmcKwV+Kj2VEmbIX0sjZOkhww951HNn+A+8kI51nNU35344bFwk6Vpiof4f9ikc19cYBL0E1p9v1pSK8V5VNqTvOyDeuG+TlaKxNWM+DYqioevOdiIzDGjy0X7T2ppsHy1hHIZQneeDdWwqiGLIqCXCB7RQhNg/nc/mXsEMaigQCxvQyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcqCMQrGavgYjOt2lGIXN2oQn3dkrM4UhcUIjURHt0M=;
 b=dYyTx2EA95CQwtvWvJGbofqZaWcLG7jQk47A5wF7Ei/0VRwN9bLBv3iPIaYAe4LP+2VjQjMngj1dCFt/4+3VqCpiboCE1XP+U2aNhnNpUTNv3tiarMTigBsLpbGMSfrq7ylKgfbY1R1mTjoz+aWZPuxx+kd6+jcPLGdY84AGYS5+rLR3SZcopGzTfzoOrWLS2F424ushifWz7ScSJPHd2wMQ0Y2dv7ipaMNdiFl4gBdVitwJ2LTEowv1fo22PCNg14RbHwMrWMOMPsyMe430sGg0u6DueubS9F4JDuII4k54HLzqWbwSvlB/rCMyj4z+dlgP/Kvqem7ar3HXmRUTeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcqCMQrGavgYjOt2lGIXN2oQn3dkrM4UhcUIjURHt0M=;
 b=MkT3r8M0OYsEVLO7cCOXyS5OTiRNjN7sizRQjEARwUa01DPPfMX0K0Tp7aH6w9nddh9AwelmTtGK54XDmi+N25V6z6J6pSzfIaWWYktx8jXZw5I96HB8HSerCS8BMxYU5H2pflFpU2vFF1uNNYfghNMHYmTYuI4lEml9y3rIIKLGYjLO24ceI2ToyUAF7HMO13snbfm6deOP7ZtHhz43SNU81sCn7AXiYfoOl8qUBUTje+zHtFc3k+5mJKqCjxMQV9IuQDjFGU+QMtEPxzT/CWcNbXWcBw4yjn6zYH4syd83AOO//h5aa0FtaqA1zfhhja4VD6Pce0tdDtIXf6Puwg==
Authentication-Results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5318.namprd12.prod.outlook.com (2603:10b6:208:31d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21; Mon, 7 Jun
 2021 23:18:39 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 23:18:38 +0000
Date:   Mon, 7 Jun 2021 20:18:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joe Perches <joe@perches.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lima@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH] treewide: Add missing semicolons to __assign_str uses
Message-ID: <20210607231837.GA831267@nvidia.com>
References: <cover.1621024265.git.bristot@redhat.com>
 <2c59beee3b36b15592bfbb9f26dee7f8b55fd814.1621024265.git.bristot@redhat.com>
 <20210603172902.41648183@gandalf.local.home>
 <1e068d21106bb6db05b735b4916bb420e6c9842a.camel@perches.com>
 <20210604122128.0d348960@oasis.local.home>
 <144460ce4f34a51dabb76e422a718573db77cdc8.camel@perches.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <144460ce4f34a51dabb76e422a718573db77cdc8.camel@perches.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:208:256::12) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0007.namprd13.prod.outlook.com (2603:10b6:208:256::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.10 via Frontend Transport; Mon, 7 Jun 2021 23:18:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqOVx-003UGN-4z; Mon, 07 Jun 2021 20:18:37 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea855673-a817-4d6b-036a-08d92a0a94b6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5318:
X-Microsoft-Antispam-PRVS: <BL1PR12MB531868D60C97342FEC81E141C2389@BL1PR12MB5318.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1IQIx1Kt2aRGjU2JT97DmzuN4KpSkwPKVfdKyU0IUzq+uIc0ZdBJDlIXVKX0czRpEvtl1/rlvruGzP8W4QwKNAWQ4SQ696qtZKeZ/JHZPVEOGO5DT6ukNWcuVo3IPkBzGUHijB/mtXnRn4Jv7OIL05WjtfOnDdaqbAjXWe8xlDWcfCE60CVCxR4UT3KzjS6dN/rmebdAvKEhE9MK7CkVMPXEQB2DUMtWnakKFUxeyKoI8obrLm8bQWMNU7L/Vwr8vwWET5dNUP7zATZ67NKsFP9VUkEA0lPHFGFc17IQSxbrbU8Mh8rQg9D/zemTYCfTd5Sdi814M3bfLQNAyRYmJA6iqwhsMKdKibcU3dCJ40VRETy4n9pI71BnNtZlEKob/BCUW99/0szsyZ2YibVsyr8wvG6AchchcbIFhWHLcA88S4NwYhBC5VtlVPT9jMpsWhMNuEqiinlWwd1XFONHMUnCTwrPbrTnqcpd5rI8PDqNNTMTSHNqI0nyNu0/mKpboma0BGwM0p1Hh42EqWhjl4yDqItkAKqJBEgIhz5L7fCQsxKoNwePab9wLw4rXdjTJCP25j00FLxTYQfIubEoVXRLK675yZrIJr/krobFjLiTGneeMNY0PbBaXk+9gfi3OoZDsPnVcTGCYV2Wedid9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(7416002)(478600001)(83380400001)(36756003)(8936002)(2906002)(66556008)(186003)(66946007)(6916009)(2616005)(66476007)(38100700002)(86362001)(4326008)(8676002)(4744005)(316002)(26005)(426003)(5660300002)(9746002)(1076003)(9786002)(33656002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yfBM5qtu8tW6vwBJ0j080dK2cZ8vkOmiwZLJ63PMA+/80r8loKMql6hfUJtv?=
 =?us-ascii?Q?6/bo86HhiNe2f9aiBnzKG4hmtbrNTVQVN0yMwYTXE0+44JTFlyj5VUPCdlh3?=
 =?us-ascii?Q?zXT0us0CVFTOq6IpG+kPrQ9iyYbsfAGp+P9v/x2G/nPCHp+2J1B89B/NEXUd?=
 =?us-ascii?Q?43NyjGvlkhtynXZ9+gKXfRo319yGsWXE8Bm4qVP2x8J6GsNlZ6JpBB78zlon?=
 =?us-ascii?Q?JuFGZw1w7PzLN4uFvfW3RV7Rw4AROjhJSAufSqHjpnzDZ4cWQFICGXNXyB1Z?=
 =?us-ascii?Q?a8OS6DDubFGFVGi2ZtPdAZCAVFPQ+jzlZcfh+j7Z/F1j4l726Imb1BZzt7RL?=
 =?us-ascii?Q?YvjCyCdhaS4MxEL7XJ6Qr4zGq01QA5KQdfa0bAStdAoJZkBuHH42IxknlE8N?=
 =?us-ascii?Q?krqaxuS5f0Q3uW1V6XB2Tzs1zzlRzPe7EeQzkBGAZWALu1pKkcaE3z67CuGT?=
 =?us-ascii?Q?4aW3/iuFkKePhFQWWAD0BgN9n2ZyGkg/SQC5JwiZHOY5W3+MJovVTXcoo2i4?=
 =?us-ascii?Q?Xhi3LVT2VxW3+7Jbup3Ls3Z2A0502lvQpkoDUsiJF1Z2o7XLYKPRKowZiiC0?=
 =?us-ascii?Q?3yVhtkjYo2DTJSl8xTkjw+ArZYHYEnOSKszHzRqJdACQi5vhSQeMJwYsSPwa?=
 =?us-ascii?Q?eqhGRK9pSpM+8c7pkEJX3B+5TOMS4N2U057w5Y2LtauHW0AKePCeCRFP5tya?=
 =?us-ascii?Q?ZBmIa0dSvfgOSYjgdGPgGe2jVSDVT69E94/HM5Rh2CtjSmUBpGsS9dcwhlJK?=
 =?us-ascii?Q?qyCM1GN1HDU6ZNX/Jg9TbRM/vnZZZ1jTt8QHYhSgNKVlSXDX3fTMUwEATJA+?=
 =?us-ascii?Q?o3DfCY1T6MscrU9x9qc/aqzf+Z4efgpjIedZgDIIyZX56CJDC/2IqAN5GNDq?=
 =?us-ascii?Q?IhPFRAItHkfHEWtba6cZTZIRipHhFMmD4Bo/pDW+TCVHNHi+3FczVbX0Jj72?=
 =?us-ascii?Q?U4JL5OpQuYz/ZNg+9otDanDtkI3MWVP3xac56nWxoUA42yEA5wdZh6sad4UE?=
 =?us-ascii?Q?tXcfX6BXEv3VCwEbEFVrrNab76IGdhT9hG0EQL6PlWSKLvI7oLIBptOmo5E0?=
 =?us-ascii?Q?lS3Yb5MZ+SzW2wyXMWw0g7OkvII/rdaRuJFmRS+KG+c/XxCMjIDM6GZLt89c?=
 =?us-ascii?Q?hmi89HoDAvgn2SqtZhNMLE8lVXxDJ2/YfA8OPJpFkj/6fQR1u+f1nZm2yeSQ?=
 =?us-ascii?Q?5ms2a6uMnSEZLYTV53qY8dkjWED1YMeoDgmLuaKOnL5z+KeIZo+WBhKpXdhg?=
 =?us-ascii?Q?OTEWOgO3p+d8j5Qxms6gqTsPeJA3rKOHB8opXaX1K+0Kbkcbxv8c6gM9LSj/?=
 =?us-ascii?Q?nncr1s2JcbTuYBXrU4ZST25Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea855673-a817-4d6b-036a-08d92a0a94b6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 23:18:38.5967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: neQlgCFaKGpzHFVPgyILIvzKgtLEt7yz1tRHrJ5G3XSQq+P1Tt3kJpJYuZGkAwLn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5318
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 12:38:07PM -0700, Joe Perches wrote:
> The __assign_str macro has an unusual ending semicolon but the vast
> majority of uses of the macro already have semicolon termination.
> 
> $ git grep -P '\b__assign_str\b' | wc -l
> 551
> $ git grep -P '\b__assign_str\b.*;' | wc -l
> 480
> 
> Add semicolons to the __assign_str() uses without semicolon termination
> and all the other uses without semicolon termination via additional defines
> that are equivalent to __assign_str() with the eventual goal of removing
> the semicolon from the __assign_str() macro definition.

Acked-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
