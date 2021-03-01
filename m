Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4400D327649
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 04:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhCADDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 22:03:04 -0500
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:43521
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231867AbhCADC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 22:02:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frIXVpxsmUVsHkdhIKwC00ytDIeIiRIy1mKXTEFWa/b9DLgV55xP6QeMlr4lOxaVC4GOl0yar9oZOkN4XaCUig5MpglP0U2PgvxVR+4jGyEQ3nXRG3ZOAOX9rzvrqkM4hLsCuvMXt0uF8/Mrb+mgBUu6SFNa8KgBbY1NGyX4KqNwmf2BZcDzXorPXiwSshPslCngKTtpY1Rz16TBHeR97u9g9kj1C92YUVipDPB2sLrpzR3y+AfAZbyymPzxpVP0g6/SgvzWoU8ufNNzYfsFNK3+5FVY04OeT425rDv9LS450715kphMhmwBQ2YuFgK4x6x2aNUKTFoaxgdsfKj5zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9UrPx4Wh4OuJqMQDZMx4AxT8/SrDq781fGU6YE/XNk=;
 b=OhQhm9K4gMbXZFBcPNhmVOgiAiQdUnMA4xvIMv9o1q6EIXZT7QLCDq+CrqgbevK0UisdEozJ+SVxjUeE6Sd7Vj4nBpZh6fKIAsNpk8eULTiZ6/xk7hREViG9rwm6mciIiGIxF6WLCISgUIEk9FWPKlLVFpZe/+eP4LPTHKSprN4mlkTt8Osn9GLNqaEi0r1oAI4NPOqR/8U2aCedmdHxHq378j/+EKhAkPZxUeingEtweg/OTV4j52/xlMNPJrnwhB+ivhNHjzfVyC/IPX2v5+FiRQY+9+u7Wowfs9z4A0W3VlSA7U/uxYTFiKqxLFFCHrZNZwwTJ+ijKtU6SZniOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9UrPx4Wh4OuJqMQDZMx4AxT8/SrDq781fGU6YE/XNk=;
 b=AXGtntmIn7lGCkM1mcepNnG4K89OGca/iz/+pVfZQV1tF6p2dCsYL0GToJB9BRolCkRW5eWE49m4snnWOW5KNc3Ukwihtq0ut172zdS7j9pjluzbTYt0gMA7R8l54aGzWUxYMJtgbeg9cjjxns4x7FPfGgfI/0oaO/2JSZSflb8=
Authentication-Results: codewreck.org; dkim=none (message not signed)
 header.d=none;codewreck.org; dmarc=none action=none
 header.from=synaptics.com;
Received: from BN3PR03MB2307.namprd03.prod.outlook.com
 (2a01:111:e400:7bb1::16) by BN6PR03MB3217.namprd03.prod.outlook.com
 (2603:10b6:405:3d::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Mon, 1 Mar
 2021 03:02:08 +0000
Received: from BN3PR03MB2307.namprd03.prod.outlook.com
 ([fe80::246d:2f3d:93bf:ee56]) by BN3PR03MB2307.namprd03.prod.outlook.com
 ([fe80::246d:2f3d:93bf:ee56%4]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 03:02:08 +0000
Date:   Mon, 1 Mar 2021 11:01:57 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: 9p: free what was emitted when read count is 0
Message-ID: <20210301110157.19d9ad4e@xhacker.debian>
In-Reply-To: <YDxWrB8AoxJOmScE@odin>
References: <20210301103336.2e29da13@xhacker.debian>
        <YDxWrB8AoxJOmScE@odin>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BYAPR07CA0033.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::46) To BN3PR03MB2307.namprd03.prod.outlook.com
 (2a01:111:e400:7bb1::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BYAPR07CA0033.namprd07.prod.outlook.com (2603:10b6:a02:bc::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28 via Frontend Transport; Mon, 1 Mar 2021 03:02:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 034d86b4-f245-4d9e-85a1-08d8dc5e669d
X-MS-TrafficTypeDiagnostic: BN6PR03MB3217:
X-Microsoft-Antispam-PRVS: <BN6PR03MB321710C982B56620903C080AED9A9@BN6PR03MB3217.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dun0J07LarLT13nTxf7Q+SEqEPhAID/qkvM4g8YKZLZpTShmJWPG7VN6nH831FhuiHvBk6ahNL8IKSW27HpiJ365wYe1lapFLMDR0Wlpa8RyYxIg0vZGfDynupgBmqiJ2x2AZfcaoQOGxrV+rtVwLP0zegWIG3+2ligZEzbH9/hrrpFfzLywL51RwLDPWwz7hdl9a5I+BAvms8fGve2yCGKBg/ZDgvZFOwjckgIblg9WIjUGasDZbf7nSOw/AgxfKXpUT7uRtcMqtB2B50p5XP4YiuGXKp2MNjw1hlajnNfBKcfffDsoWOptr1P43iGKZwqegJagPdQ4IUNrp/8qCFFnsMjfvMdM+9rhVlCnqoES62C91DFKF8k1cfG/J9aG1r3KVYso3U9ytMHGpQEPoe6iHZZtR1HzCzbhIimH8Vu3qQlyD96E58jWvnyzjSS1kQvGqS0qIwtuquA2xGgdaZx0WzVjDbPtnc+ojraECDEwUJh1mvjT8iqGg0XrXCN0r67jsjaiQxek793ij+SNlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN3PR03MB2307.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39850400004)(136003)(366004)(6666004)(8676002)(1076003)(54906003)(66946007)(7696005)(26005)(8936002)(55016002)(83380400001)(2906002)(4326008)(186003)(66556008)(6506007)(478600001)(86362001)(6916009)(5660300002)(52116002)(316002)(956004)(66476007)(9686003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WjdfG8lOXamJWCwb7g94o8XTWQRfxAhysO9lwThr7937OdCvbXzzc7g7BXPa?=
 =?us-ascii?Q?IX+BMzZLjtSfq+YpQPK0mrSXt1k3SKU2uwivUnlupwdQ6yRf3Cph64KsYzyv?=
 =?us-ascii?Q?NA3GtJiis+jqx/3nsN+5C1T0Pur9UYIVbii6yqGH/ziT9o5ad7HHArtUHQSN?=
 =?us-ascii?Q?89lRBg534B6iS20zQdffPq4J6IeqyDTvJ7GgDUGA7h1vJyyNsD25BBTJsjqz?=
 =?us-ascii?Q?rx45woJKrPVWsCKzqV6TL0+16m66f6sItq2scbEmAQRx77Z6eYq4Ci/Ql4Az?=
 =?us-ascii?Q?24FvGKX4GNf1eJO5BKOGU6A2+GME+99jOhdeboMhzuTgn3svocKoi8wPKtEu?=
 =?us-ascii?Q?XZ+gxsf10s9QTOKlogVa1c+4SF6b5xHiN4VTdZSrfCWwzk2TdYlVQjHO0q5J?=
 =?us-ascii?Q?ltWZyRyF7/HH1lzrvatBpZPg7dWoFZyXsanS7OxpGu5YE6TsEUF9XJojxNrj?=
 =?us-ascii?Q?8TGP2OsXpc828/F5V4N1LuJE4PrZEgsmR2/4TJAyskv7OxIg1LxUoVfSuxdU?=
 =?us-ascii?Q?81F/Jmq51wzqFcZ/73eQqRUXtRYn8selLPJqZTr05vk+cV1R4OY/3Xh6EciL?=
 =?us-ascii?Q?9JX6ZuDQ7oGqoJ8Z/6fV03QfiNZGeZYBMcENLMyaB03p3exKUWJeUXYhWtRZ?=
 =?us-ascii?Q?EAPOut61zDHZPSBAiLo1TTby/e30xxq82AknR7y/jrVi9fydm18bii3HVerY?=
 =?us-ascii?Q?rpS/xJGX6VSoQWKpVG4p3xHC0z5hnIoBrpu9K+CoHuFTgZb0eotjYv4drnP9?=
 =?us-ascii?Q?iEASZnFf788bqhf/wDnEl5mIClbq0OenGg0zUngXXwRRU4K/DqSWgIcE3L8w?=
 =?us-ascii?Q?wzUgYs3GJE1NGarDzb03TFLWdJyeEmve/KEnHeNPlU5NA1JpfiJKCJxPmK1S?=
 =?us-ascii?Q?vrgE6rn4gAepcEwOGYnEXj+RYfu/lDuPzIHPpebkXtIiGCTqyJRqUJURqWPW?=
 =?us-ascii?Q?pIS32crKfA9xMh+MDSLr6ysrTyxlACQBlKW4mpc2GN37Qyq2KVYqmGLwIgDj?=
 =?us-ascii?Q?7Gr8+ZQIhOMSfIa6Ta3kvDzQt3+S7PgzGOQ/xpIG4RbPmDo+WwCZD3KHhBUt?=
 =?us-ascii?Q?wyYl35p1FcNnChkGYKWklb8OKU25nWdhcw/VBJDmvmSdSD0KsT22fbH5CCFR?=
 =?us-ascii?Q?P/q9AxJJXfJ5d2UezYS8NknmWwMIhKQ1iBRAf1qoLi/1L/igtLd7i+b9uvaS?=
 =?us-ascii?Q?pVpUHTWLBhG4Hm/XYl8L2czAibyGc3rZGxk12K3APVQLETh8JGFgHEjh2Hgz?=
 =?us-ascii?Q?njH12vuEwn0drTOg1G6AKCgN2xLJxkYN/kWvg0tZyyw/SA7F8jtnGo2H0N/l?=
 =?us-ascii?Q?kyDAVhQ5xSNe/z33CzCancWr?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034d86b4-f245-4d9e-85a1-08d8dc5e669d
X-MS-Exchange-CrossTenant-AuthSource: BN3PR03MB2307.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2021 03:02:08.0700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 07a+QjQNoOuz8Gt7JFqRooLAYpLFqXt2oPJeCfaW5RwX2rXe+GujiX2AePz5G3UR3RCOHw1phDpXFH/7W+jgDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB3217
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Mar 2021 11:51:24 +0900 Dominique Martinet wrote:


> 
> 
> Jisheng Zhang wrote on Mon, Mar 01, 2021 at 10:33:36AM +0800:
> > I met below warning when cating a small size(about 80bytes) txt file
> > on 9pfs(msize=2097152 is passed to 9p mount option), the reason is we
> > miss iov_iter_advance() if the read count is 0, so we didn't truncate
> > the pipe, then iov_iter_pipe() thinks the pipe is full. Fix it by
> > calling iov_iter_advance() on the iov_iter "to" even if read count is 0  
> 
> Hm, there are plenty of other error cases that don't call
> iov_iter_advance() and shouldn't trigger this warning ; I'm not sure
> just adding one particular call to this is a good solution.

Per my understanding of iov_iter, we need to call iov_iter_advance()
even when the read out count is 0. I believe we can see this common style
in other fs.

> 
> 
> How reproducible is this? From the description it should happen

100%

> everytime you cat a small file? (I'm surprised cat uses sendfile, what

it happened every time when catting a small file.

> cat version? coreutils' doesn't seem to do that on their git)

busybox cat

> 
> What kernel version do you get this on? Bonus points if you can confirm

5.11 and the latest linus tree

> this didn't use to happen, and full points for a bisect.
> 
> 
> (cat on a small file is something I do all the time in my tests, I'd
> like to be able to reproduce to understand the issue better as I'm not
> familiar with that part of the code)

Per my check, it can be 100% reproduced with busybox cat + "msize=2097152"
mount option. NOTE: msize=2097152 isn't a magic number it can be other
numbers which can ensure zerocopy code path is executed: p9_client_read_once
->p9_client_zc_rpc()

Thanks
