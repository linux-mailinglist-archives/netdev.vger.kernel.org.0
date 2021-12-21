Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5967747C380
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 17:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbhLUQH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 11:07:58 -0500
Received: from mail-eopbgr150127.outbound.protection.outlook.com ([40.107.15.127]:54411
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229652AbhLUQH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 11:07:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3VPkyOZT5JNi8+LslfqB8HF6XcK+wA03lQc9YAW7v985p4C5nUj7Dq9+rrCkyz04U1+tcMpr1Vh2u2VbranQ/cf+HrJEV40ajL8z8S7zFcS5vOZdjSOGRDy/qbSMg0utcFaA9sWbTyPRJPhglBAOyj6y7FeouQbrvhHw/cHWRyyo6LYdgSeCKqZKoknu7rtLTCoYdM/9rjBGc8mAa23w9pk+Ydyolnd9vUApDhZycHX+6b2KksLuiIDfmkHJtUfThWnB31k2PiquooXkXJN6J++W9/TihdX5fCkCXLc1xAfI69gxUEsBqjtB8tO44oeKPDcFBuTfgSDlNOzGt3KGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQFnp3VI08RYEphbtRLDx7+/APxNN8UqtxOANBX3q3A=;
 b=WrPBo7bczOAc5o1h2Ow+mAYer3DHC51c9vGMhDURSfU3FzmpnvdWwt0ni26p6HYW2JUjfVWgGq3pYIM70nGxSJgJ/+ntTSbfQofIifHLhbiFx8/TbYPos7u4pHxY04qHcn03UPyPJiqjNS1edegqkUMlm9lWBZfIBV1malhD01zcVnI9GZd92/YEJfF7QOSoADy15ST1/VfuAtvQYnLZU+HqXbVDCiADUmUFr8V9qFR3ovMDEln9XMqX/WnEBZ3QWt6/uCg+LGh9c9AB30GTIofIry/drcKig9dvujbgvGLlm0NTZS+OyhePmSqhdQiScCD0iWpBZ4oK86ivFR8DSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQFnp3VI08RYEphbtRLDx7+/APxNN8UqtxOANBX3q3A=;
 b=hZvPEqsUiJP6MRfwskTaRgd04E7n06vX0K1UdugdKX0d3Kk44+JAV0vsxRjwkRpqFlTq9zaI5cYjHLpGW1vr6upXG8989U5qRE/dOmLkzP32NSJ0pmH9OEYpdghvlU/d7b+4SMwv/zydQU6Cu8787zAYiJGeI1RAU2mPN6gkMQM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PA4P190MB1136.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:10b::20)
 by PA4P190MB1392.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:10e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Tue, 21 Dec
 2021 16:07:54 +0000
Received: from PA4P190MB1136.EURP190.PROD.OUTLOOK.COM
 ([fe80::acf8:d636:15f3:81b2]) by PA4P190MB1136.EURP190.PROD.OUTLOOK.COM
 ([fe80::acf8:d636:15f3:81b2%2]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 16:07:54 +0000
Date:   Tue, 21 Dec 2021 18:07:51 +0200
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/6] net: marvell: prestera: Register inetaddr
 stub notifiers
Message-ID: <YcH718qGCAcjzaka@yorlov.ow.s>
References: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
 <20211217195440.29838-6-yevhen.orlov@plvision.eu>
 <20211217130203.537f6dc9@hermes.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217130203.537f6dc9@hermes.local>
X-ClientProxiedBy: FR0P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::12) To PA4P190MB1136.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:10b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 126fbcc9-2646-44fd-9522-08d9c49c0ba6
X-MS-TrafficTypeDiagnostic: PA4P190MB1392:EE_
X-Microsoft-Antispam-PRVS: <PA4P190MB13927CB19F8D278F1B82AC59937C9@PA4P190MB1392.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ncQIRg6PdyKohIXnk8aTPkycHevANs2W2DDEMVouUilbLwxifyHyRPUzNzOUrXC0Dg4zE+pFaVWGdYjEw2Wxkp2yQdv0BsSj6JgPrzAaxiJ073Rymug5NxgF1fUzV6UsEqnYeFS5HPorYbEioQcIRJh5ZpCe32PjGgipVyTMmMgt/750XN/6TBkMn+q7qL95+Chm/gejKg7+TR6mzdRREnR4a5PvfZy3hbiQa1Y794oYQEL3i/do8LORtNzSzpa/vevk+K3xFeJjstXwdEJriifTlhRKrRZeEQayJeOMK9ELju5fQRbYgNaMZOsoNS1yq5U/UZNsVd71BsNV6TooN8dZoDU2OSCjPrYwntRSJzaV+DF1BHicbhVpki6S91A1B9gpUFRyxYtCjvwR1/ABL9Sp091n8fpF9npdIdAGeCoTte4NRKDksHmLnRBkf6wvNahC4S+cjf9Ix9dRCA8aMeN7c8RqqMuvHXWbgM54wlFXWNkuzPO2SfvgvbvKXySVfeIxYDGmrcb0EydEq2/paMEP5SYPEVmvRG0AE96tP6BRhPwnFaH7Kb/gVJwrOhgtRvGnh9umCdpPKYKDhubn92I/lSq6sw05YBWcT7ZDnMNt+yeWc2MGastsSWQstssMeMqIrSWDivV4oEAb/IaaI1zjwtEDhp5h9460w/butpCFKh2bKM7DjBigvfrpRhsd5DlTl2Zj7zgyXrRiokirAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4P190MB1136.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(39830400003)(346002)(136003)(8936002)(6506007)(54906003)(38350700002)(6512007)(38100700002)(26005)(66574015)(83380400001)(66556008)(316002)(8676002)(52116002)(186003)(44832011)(6486002)(66946007)(66476007)(9686003)(4326008)(86362001)(508600001)(6666004)(4744005)(2906002)(5660300002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GrrLI3a/0gKJgnIuAx+Y/JvhQq82G7r0EGTJir7YR9mQKuOReww5a7Qxl50n?=
 =?us-ascii?Q?VugDmoMdDdISCWpbiagn/lq9VplzTlHEIr7txPFaFOqhyEiY5wUXFuFvQUVH?=
 =?us-ascii?Q?zcKN56HcivxuGChvkrVYmt6pc/HuImpPtsIxE37UhVzL/bAzGZCzSE8edUwz?=
 =?us-ascii?Q?FCUzsRAA2lY/jJ5mHFKCeQ4Qs7Ff1Ble6y7vzz59weTJuDyjrWLVzn6FSrnV?=
 =?us-ascii?Q?pAQM3QBgbBP+OGjaFGGdM+qzlmI1ohIhbn/zczSYUVtQcyNVJzwgUKbsYtZn?=
 =?us-ascii?Q?l0FaHohG0Oov23KQ6Z8GrVsApN8AsJt1JTdEfuuMLObMzFuQRtH6DZQY8yjl?=
 =?us-ascii?Q?Lw8mPEWDdQidle8pFgx2eJxZFd7MBJC6T62zhr5DAHfUruslzL5sExFP+I2b?=
 =?us-ascii?Q?ggW0uUe9HYjXMKJoFlR3qmKiCmOXKj5WNcB4lmwrESbXQFjqjEeeUnYH9Jh2?=
 =?us-ascii?Q?4QqqXY+n5vhbI44qGOF04fW3G2OpqeL4h2ivjoQkK/hNmgiiQlnjBPH0CkLq?=
 =?us-ascii?Q?ZybD9St5WnBk6sULsrk7YOrTIACXAO/JHMgIa9zrh7pnsVBXac8QqDo7Ajyu?=
 =?us-ascii?Q?/jIi+I5xkoGeHBR8Q+WSg7wyD77COuIcHzzhTyEX8JdmYG4MWYMF/FbNU/Oa?=
 =?us-ascii?Q?pTX4WJ7wqFVxkJoHnen/zL/M0HMqHMu9Sno6SYkzFEfewrPT016muQbJqDZb?=
 =?us-ascii?Q?WaYA9/40h1HRI8eyqpcP7DzvAVJOYF39EZXn22KIJw1Po6oWgX4WQMtpFIQq?=
 =?us-ascii?Q?0HqQJjplGy3zCUAg6+DecrEEWY2h3S15iThj/JFToQsqPfU4F9W32boldR/O?=
 =?us-ascii?Q?vkh0Kjrp3Ca8/MAWYoQgPVYo68jwE1noXUsc7xXjDGTk1B6jW3dQbKb8oER5?=
 =?us-ascii?Q?4EHvzU6SC2cLur9OxdV1SAMySlJ4VM/89w51v7VHzbxPYYA9+DsZOsNt1VqC?=
 =?us-ascii?Q?MTrYqUhMD/lE49+uEeVLCczzerBEF+h5zSLYr+VyxSaLba1tdYuFlTYjAgCY?=
 =?us-ascii?Q?E8glQC2xAz8f1H7I/go6nUE6orhNqSCCIycD61634LyiUX3wWKRSpr2p6F1j?=
 =?us-ascii?Q?b/OYwFGFSPVvWE6pfgV4Ygm9TwohZWdp/Vm17MvaREWB7tVbZDjj75ygoQg+?=
 =?us-ascii?Q?WVn8NCV+bH1Hpx71iwS+ZRjwOWejGls7X76XFXt3WatJOz/zak5P6mAehaHy?=
 =?us-ascii?Q?mopt+s4uVNv6F6vxXBZINghCRmVCpQCkHYm5DIWgE4BRtVJuU0cqjYUOGuJ1?=
 =?us-ascii?Q?hOVJOvRVDP24hCptfA3PdTv1lbJlJT3dg1hCLhL9B5xyGEkdA25qdtrPNYtA?=
 =?us-ascii?Q?opcYQRVAuGul/w4M7GRwEpAGZjYm/wF0iZkiae6JJQbSJuA4MQExztRDKzJT?=
 =?us-ascii?Q?o9lX5DCcjICxZ75qCk7LwPtgOYYmegdHUkGbdMNxfuafJ2tD9tWQaZiRcbOe?=
 =?us-ascii?Q?3d4+BVv8xHaXAj+fFK7Vb3sAL+I6Q1M1C6D5NsaSJVCNeBzMabuS76L5BO4V?=
 =?us-ascii?Q?NGq3y64DC6d1NZb1IrjSIOPrKjzCVr7WaZO0eb0PEJqo4seFDARsUuabYMod?=
 =?us-ascii?Q?2fOOFyX0ad5m5FFxQ1nVdaCrCTVCF3tEDV+8I3H/MRjLEycgdwokeJsYj1s/?=
 =?us-ascii?Q?IvGHfXXwPuCgES6YpMHVhHl98mDNAo4ZlAgZFMV7H7yHjePdFbDh5C00/zbr?=
 =?us-ascii?Q?JB0xqmzUJPBwi9ly58j8kcTXYsk=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 126fbcc9-2646-44fd-9522-08d9c49c0ba6
X-MS-Exchange-CrossTenant-AuthSource: PA4P190MB1136.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 16:07:54.1832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GtcUhk9mjqvPxFr54yn726zHt5O5C/K9odc5jh7UZJ3kLMUx+GEqQBJN6RPRgs/d8NvHyWTQ0TOQbJFlkafHjkoZqXeFaOOKZMh/VoDA1IY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4P190MB1392
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 01:02:03PM -0800, Stephen Hemminger wrote:
> Your router is quite limited if it only can handle a single unicast address.

We support several addresses on interface. We just have nothing to do for
second address, because rif is already enabled on this interface, after
first one.

So, answer is: we support one, two or more unicast addresses on
interface.
