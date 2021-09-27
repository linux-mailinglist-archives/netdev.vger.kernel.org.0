Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B5C419863
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 18:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbhI0QCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 12:02:07 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:56834
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235369AbhI0QBw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 12:01:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHhRP/ZQpUcMWm+Rk7+ZA+EIn4zH/5hT68RWNnQdxp5KosgtSPpjc7qecju1ov5SLR9HkA7sFnHbSpj9C1ODnCGrWezPSFSTIYVly71pBCDp6qPkMp9XD8YICG/Q7yvwx3j59U5ch3Ua8DvKalGv5Xjkk5YYLGkj00JnzlmHbDH3xszDbO0w09fjE/nk9ozs/9M5fRaojdsFEieBRMQSmGhJfGPiADp1KXA33c6KsdcZ7WNRBR0QJ9Io3T2IoJ6SKA//KYqVxWGMhbYRpfrUJeyOotKZoblQoHyMKB8f9sypTMAO/HATSADzLEWz95/7HeWxWrkmZxva5Q+4k3DL8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IEQgwmwpi6dblGLrS/b3z7qOnU8KeD3L45KacjFcO5w=;
 b=cBf911WXKxPB2B5l7XTc/9CEt1DOQJaECPSJ+6nRCTj/APRMHGhEi73G+ZrdjrLf1fRFl0uMn/+ocm9rg/OokIx0uXMKWuv0FLcf5Extf4/mbjeQb7YN8LA3klnzYYKU/GGLiIHonJcJ533mQB5XhLhML8qGJB6aesw3pGcrjbwSkCYwFtjV0rueM04GAeiY0SlTUb86gQtmfg1sOzpzcMKSe33dUqHwCx7Vpm/4l5aI6GcNvq4hHGKQ88bU4aMhDNZrqmtswpj9N1jd5/TbUQRuF/EzCM2V0F/2yJTvBwbaQcwNKRySlVi1vsqQnQuDaGQTNfcsZEUrb8vz1Kojsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEQgwmwpi6dblGLrS/b3z7qOnU8KeD3L45KacjFcO5w=;
 b=V1QsnXkQqO9wrajifRXp8HncL9fehERMkAEoQHkJF5X0W1ldg6ebSO2bVmesqdUSNYh2syaKGzFqDS/8C2cOnWfs3Q4NgBLxpaUwbMFgLxoYnh6upbVplncByxybqRwaIHmty1U29Ojwt1jBmFNfutpADz+QpVFg3J0tTLejkEI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10) by VI1PR04MB6159.eurprd04.prod.outlook.com
 (2603:10a6:803:101::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Mon, 27 Sep
 2021 16:00:10 +0000
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::2408:2b97:79ac:586b]) by VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::2408:2b97:79ac:586b%4]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 16:00:10 +0000
Message-ID: <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
From:   Sebastien Laveze <sebastien.laveze@oss.nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Date:   Mon, 27 Sep 2021 18:00:08 +0200
In-Reply-To: <20210927145916.GA9549@hoboy.vegasvil.org>
References: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
         <20210927145916.GA9549@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0202CA0006.eurprd02.prod.outlook.com
 (2603:10a6:200:89::16) To VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SOPLPUATS06 (84.102.252.120) by AM4PR0202CA0006.eurprd02.prod.outlook.com (2603:10a6:200:89::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 16:00:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35c910f3-6865-4dcb-8038-08d981cfe231
X-MS-TrafficTypeDiagnostic: VI1PR04MB6159:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB61596D949CA7BDACF70A8881CDA79@VI1PR04MB6159.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /nQN9eK+wcwYo+aMR6gDYvwwv5qxT1MaezhU8QwgO3SW6spna4GskF//eBq9dsd3qrI3g4ZHmClYu2jyfxeG1lYSdXKzkkWdRGuFfh6iYoiOziynYUCO8ywv83+ACcLrcaffhEA5n2HBAsuRngeza8Lvds749V8xJbrLrxHuWv+Yd0yWtFbMoqGTSygQMIM7s7fJPcO2IEpkY2Efh6zM9X/Ydu127Au8nwvC9U06ZKvYuJDpTciVYkMFaCF9ZyH6vWPrOx1G24acO7fZvTDiR/Cp4nZZf4DXSy6YXR76xh8nCfEupTowkCEBxm4KxONDjoOxCwliixUjlQA//1s75WJEKZJQY7GY4v/ln1Wws954aXAhrj6wZE0Q8iN8q0V8fecRKFyR/dr8wSkkwGVnWbY8p+LfnZMyf1+tg+E+HMv1li1rgLvo+enLMbGJdLZ+ifqRRs0pdoPRz1WqeVGGCjmVMD3L0/9rpcppeVw86r95o7hkzqP+U5dgYMh4PY0S9ejizQrRWhCd5MD6wfo+MhFM4+EriV8W/tQj4VPegWXWI+1IIeTBh1816CjbU5qG0qvxQwaQ6lWY9P/mpQfGs9HKV2jxWYvCKev5ck2A/o/y5LMYkVJQ/cIvY5K1wa6L7SYXeGkNmIeWmxoIeNwHI/br1xVD3ra827uTsHGm8q1d1aLurMMXCGPH9XK5/xVA5ohszmrNzMp3g4RbEGe2rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2671.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(38100700002)(83380400001)(316002)(2906002)(186003)(6496006)(52116002)(26005)(6486002)(38350700002)(6916009)(956004)(2616005)(5660300002)(86362001)(8936002)(44832011)(66476007)(66556008)(66946007)(508600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U05vWVNxdUUya3FNekdvU09RdllZQUw4YVNoaUYxUXFuVDFOMGlKOTF6T0NU?=
 =?utf-8?B?KzhudmVHUHpRTTFETFdONVlFMUtIZXRrL1AvV1liSWQrQ0xMNFZVZlFvd3hp?=
 =?utf-8?B?d2ZzZUZvTU02MkFSZU1JVy9sTW5aWTVBcHlEeXZuV1M0Smw2VnJ1Vy9SM3dB?=
 =?utf-8?B?NnR2eGUwYWFKTmc1MlpyMlBQMjBGbDRrSDlVTmw4bzYwSlIvejliOWxCTzFw?=
 =?utf-8?B?V2dpbkRLSWk0dG9LcStvUG85OUJkaE1WOUVSODFmb2dpb1M2bHRscGE5dGs5?=
 =?utf-8?B?WUFwRXpLVEF6UXVqTGNZSURxWHdUeGRLZGI4MWFGOG1qMDJISDJPYVNzQTVZ?=
 =?utf-8?B?T3RLVVg0YUIvL0lWZEpKMjY3bE5tUTVwZG5qb2Q5MThhaEZFMmlnWnArZHNV?=
 =?utf-8?B?cm04UG5nY0wxbUNEaElDdktYVXpWaWJMYVF3VUhmZyswcXJuUnZMUjNTZVhn?=
 =?utf-8?B?Y0pRZGlCU25LK1kwaXhSc1lrSUVuWktna2pWOVdCclZYT3hQdUtSQ3dHNUlW?=
 =?utf-8?B?TXVwNGxsbkZxa1dlMldYMEV2NW9wQUVMQ1FGZ1N2ZmxqN3hpTmEwT3REWmNl?=
 =?utf-8?B?eE03ZkZXeFlIUFJjbmhEcnZ2UU5sSWg0d0pBQWI4MmVxcG1WdkJtRWo0VUl4?=
 =?utf-8?B?VmtreExIaXZtRUl4Yi91cnlSMmlRNkFodXJ4c1hpbFZRNlBtQjVYQVJJTHZq?=
 =?utf-8?B?Q2xRdTBzK0Rjc1ZuRVZVd0ZJSWs2bGQ5UFFGTHgxS1Q2bWorRjFKUUcvMHdi?=
 =?utf-8?B?QUxGYjdZOFNuYUIzYVIxSnN5K2o1eWJxSENNUjdwd1p1UmRTM2dPVFFyQ1o2?=
 =?utf-8?B?blcvbFl4NVVRT2RpeG9ObU5adGZQU2lrUnNPZFliZkxMZSt0cm5aNnk0UVhQ?=
 =?utf-8?B?ZHlNM1ZEWW1NbFB0K3lkd1dPMDNuOE95UGxGNmRoVXRRT1BDa3JRU0hjRTYx?=
 =?utf-8?B?ZHFYMnZNZWorTUlKQVJQQ0g5dm0rcmx0WUtvL0xqR05EYVRoaU56RWpYbEZw?=
 =?utf-8?B?dnVZU2lJMG1jekxLK29LTkhwMGxoUW5BejlZR2JDNmx5cGVwT3F3RG1Da1VK?=
 =?utf-8?B?UVBLcHRyTEpHTFpsOEx6ODFZTXFJUWJ3MGVud1hRbkFrTlV6bnFyWnFSZFlF?=
 =?utf-8?B?VjczZGt6UGJqZFVGc0dZZGQ0T3N2Wlh4UTlFVjM0elpOUjVvVTA1NHhkTno2?=
 =?utf-8?B?cktxMkNxdU1CdkZXWkNVWVdWRHN0V2x5bktCTWZFUDc2em1XbnVYRFFScWNE?=
 =?utf-8?B?M1FYUUtoRUNFOFBmQUlVUTZoYzhHVHBFaDJSbkJzeSthdCtpZkV1S0hJcytn?=
 =?utf-8?B?aHJqd1MyMExiMjUvNG1qWHNBL1JOdk1VYmZMa01tMmVRcThuMTFDaU14cVMz?=
 =?utf-8?B?ZDVYNFVFUE5rSXFvVk5CRnhJZU5LT3R5Ty9YZTRleXpyUE8vdE9SUSs4Wndl?=
 =?utf-8?B?VVdvcEg1SksxM2tUMWdpUGtqeW00bTJ5N0MwYzZJM2ozdWRkU2UxNUsvZ0RS?=
 =?utf-8?B?SDY0V1hDdWE2a1FCMVFPcjB1YVV0NUNYZ3JneURYSk9zNG1ZdVBoWndmTXU5?=
 =?utf-8?B?bWZIbmtRS1ZsZkpGWERObFRQY1dzd3lnQTQ1RzJ6VlFWNzBXa2ZSZFNzUkxZ?=
 =?utf-8?B?Z1BUbU5XOFBGTW1IV2F3TTBsR3RhNysrbmtPWWc0aU4zZjBLTUdRK0JFNmlR?=
 =?utf-8?B?S25DdXdoTkdYK0Q4TWdsRjhEMjNRVFJZWlJUV2VOZmZzVXF1R0d0ZGpuUW5S?=
 =?utf-8?Q?RIC2Wy+kRRvzBKrz9fyoOXa54iy0Jh/n0HBjIbP?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c910f3-6865-4dcb-8038-08d981cfe231
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 16:00:10.6512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bg1/3lgelD8mdQ55YwqpThxU+YaugligylowYkyYilgVEKYvp0kC+/V1r3qLyjtQDkPedNsL8GAMdFkOdoEL723pEHrr+BDT8rg9LNteD3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6159
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-09-27 at 07:59 -0700, Richard Cochran wrote:
> I'm not wild about having yet another ioctl for functionality that
> already exists.

I was expecting some pushback :)

> > This binding works well if the application requires all timestamps in the
> > same domain but is not convenient when multiple domains need to be
> > supported using a single socket.
> 
> Opening multiple sockets is not rocket science.

I agree but you end-up handling or filtering the same traffic for each
socket. Not rocket science, but not "ideal".

> > Typically, IEEE 802.1AS-2020 can be implemented using a single socket,
> > the CMLDS layer using raw PHC timestamps and the domain specific
> > timestamps converted in the appropriate gPTP domain using this IOCTL.
> 
> You say "typically", but how many applications actually do this?  I
> can't think of any at all.

The "typically" was more a reference to this possible implementation of
AS-2020 using a common CMLDS layer and several domains using a single
socket.

So, without this IOCTL the design would be 1 socket for CMLDS layer
and 1 socket for each domain plus some specific filtering for each
socket to avoid processing the unwanted traffic.

With this IOCTL, the design would be 1 socket and 1 conversion for the
sync messages in the appropriate domain.

This also brings a finer granularity for per-domain timestamps which
may be useful for other applications.

> 
> Thanks,
> Richard

Thanks,
Seb

