Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC7A486FC3
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 02:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345219AbiAGBnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 20:43:04 -0500
Received: from mail-db8eur05on2138.outbound.protection.outlook.com ([40.107.20.138]:26561
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229538AbiAGBnD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 20:43:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oR3PyYB8UYxXWkVzSEAUikmrkKjxI4eiXDIyGYUYpXJh/PiSWINtf9OPjn6udQrAm9cYx2a+2MbE1uaQbvETlfp7e1Eb4T9sTdGv8zKG/3E14Ugz/j1oBs0EOpC6NZAqT5+0F2M3JnyzSapERM4qzj/klvywqUhVfH8LmG0nGpmwpVS77Vi91dOILsUi2MEqj9YqVFpiLQjax5l30qP8qeSN5wR3yzc/rEm1d2GnVE69IbpFjUGU7ataaiYUpHN5DOakI9TQdR292k+r8qqVmiC3mkcug9H2ZNTOomoIkoJ0bwyzsD8b8BKCgC7I+g7o5j+2KGaGWa6biFy1CYFn/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxRRxnlqEVIcZXgu2AqNKWIjt1MtOloLuT3cb2U+mkA=;
 b=Jx5Y7w1pbdjI98iiKBCWJK8z51Bxlw3zUcOor/W0ZnSeJYkpPfO+wvMp/mEHZqi7kXCw3IiT+1/pWBqYvpmBL/oTk9nLH9GS1AIwEnbT9Jk8v4CHk8CKtomRcFEJV0KVzakW3fXS1tSW3bwXySeDgDxzuX2k5qJX/90mXy0+4BxeY3DUssZsJdP+LFljW+DZF+2uEA2+s1Eo7h959Xy1057PgZa9OhIdfvTpYdGs8xIQA/rSQamV/ZZqK+TI2lPJdDGs+076iUKZvWb+WWTrpz0C6v5QyHSawCxVKyLZKJLAMx/MmqMT+UFzwDfsD0OtgqcyNWXY0rczZQMX00qxsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxRRxnlqEVIcZXgu2AqNKWIjt1MtOloLuT3cb2U+mkA=;
 b=bA72+jEj6eGV2r1ptPcwuw5hq7gvIGdfeRHyttkVqzelVQtzXAwhwFLGQOrnEPQ2hS++ht8Z82SknrxpduI3wZ26d4P8oU4sJzgiKrH8KkuVuV73Jg4KQPrLNTLbStFpXWBReLEZtdDIxBRoh1ReNkGuOaAnxewW/gp44ysFGw4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM4P190MB0018.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:63::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Fri, 7 Jan
 2022 01:43:00 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.010; Fri, 7 Jan 2022
 01:43:00 +0000
Date:   Fri, 7 Jan 2022 03:42:56 +0200
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/6] net: marvell: prestera: Register
 inetaddr stub notifiers
Message-ID: <YdeaoJpSuIzPB/EP@yorlov.ow.s>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
 <20211227215233.31220-6-yevhen.orlov@plvision.eu>
 <Yc3DgqvTqHANUQcp@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc3DgqvTqHANUQcp@shredder>
X-ClientProxiedBy: FR3P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::14) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7126c9c-3fc8-4d6e-538f-08d9d17f0941
X-MS-TrafficTypeDiagnostic: AM4P190MB0018:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB001872EA80C5E367B77A4F6B934D9@AM4P190MB0018.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xhkNK96AcUaQ6852tWF3+IXDYpSS/kTaK8IiW237lS4byweap85vciyjudQ4escfkt4SzsjOgYwBwaG35TvOKnwbQLYXM9MwcD5ZcwDmMTUkH6t8n8NV0hs/w2LhIy32vVKMpfWKvCPlRv4Zzcgkp8JmjcyOggRwRRYD2ug+zciXEgvDpLmTNSJljIzAXbMMGNGHMLI3nDoFGcBrpHi5CJbAnC16GsyHCPaOx78+ZmM+Tq4NfYr0o8vD/WEiryLMxEssx9R5RYdJRDjqpYs2xwvVIAi7bqHIa1impQAXRX4WJaF2XgTnpZpncUtw1i+6hfqrmVm4VUDC8TN5KS70fkG0j1x7IOlWQHO3WVcz+JfSnGJCoN1WrwFqAe/HRqBlUWlPaysqquTXDJvNCC+nEGv5xduonCYJ+cd6FylV4UglrrzbV2h6LYgiZLvvBzMJKc53BXQz30wwu/W8HD1klwNpngMYeLzXKlOn1OssTLdk9hwJbm3EbARhTM1IKgSmzxdqp/OCE23Ix84w97BtDl7DP8wh6bFuV2leOpVL8DDmhK7t0XhlQXOI4BF9ulg9JzpTYjPemUgFOQQReQK3cQ7Q9ohfn7sMYGXMG1CmHQCAaVnJl68tUISQBZgL8QssY9gWH49c6M5GMZsTiiIEj6WAs4m1H5A9xoG64pu/aENRVy28ZO2GSvb/MQZUyCAVtJL6Mevftg3aD95t02FPCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(376002)(346002)(366004)(136003)(396003)(8676002)(2906002)(5660300002)(54906003)(6486002)(66556008)(38350700002)(558084003)(186003)(66476007)(6666004)(66946007)(6506007)(6512007)(9686003)(26005)(4326008)(52116002)(44832011)(316002)(8936002)(6916009)(86362001)(508600001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SlxJK59yYNd0L86HlmvTRq2DtsTJiw01l4TQpjKmdjzqqWE5VkeUqDXGLMhS?=
 =?us-ascii?Q?N9RYbnnIuBu4zGvo6QvyuW3pnGaCZ8LDgi4xFo+MfwQrJNXNmYfC3TMU9CKU?=
 =?us-ascii?Q?OzAmgxkelJ5AXlvT2tSnnL+3T6aNstdh9ORZqmnTXbIWgCsmjFwcYX0HRG9f?=
 =?us-ascii?Q?JUpNkL7WL2LaWSFAKsNLN8Tn3xdVwFigeYkqjagqwKoc2x/A+bT+5jHr+S/9?=
 =?us-ascii?Q?SuZHGRbUTbIsgRySQkyjhO7xQjEMDPaf4BJnyXK7Sfypt+rTehw5YoJZSzsY?=
 =?us-ascii?Q?F0wzujebIsRyQqZQeJZu6Kp9cRzYZBzaisi6QDVSjT1ycKRrgzvztdNsAHLZ?=
 =?us-ascii?Q?QmZeZRbI27BMW5EsVvZMzJSn++8VFygm53UovZlQIhUohn8VJrUrCCss7NNE?=
 =?us-ascii?Q?u71Vaim0ObK6OZcJ2gtzFcmgFlBrsXvLu0WE59jw3LnSZDlSNp/WX89V47J5?=
 =?us-ascii?Q?yXxXCTLg6+SBPsxpuTUMaznJ5aYbRxKEcUsNfyDZoTqGq1Xvo0PlzdL9Nhi4?=
 =?us-ascii?Q?s+ra4fEn+KvFc70sbEQe1HgvJK69rfURJVUc15OLtcXWwmaJ5p+f9ieL2ChQ?=
 =?us-ascii?Q?Df4XZrfm3WnJ77ngKOJEi442kLipyA2qsh5TJQEzVqKVB0388qLcTsflmnKL?=
 =?us-ascii?Q?jf1w3zOy0JimXWuPBmDijzAN5iJYveLbr4jd4HA4Iu1e+aRT1OXWI8vm6YAL?=
 =?us-ascii?Q?/iEUXhf0v9VtbdCI5B5W+so1XpZtI7uU0C2LNBHqj5VDyLoP3rfSQF0ZCRYF?=
 =?us-ascii?Q?VIZnHO01H27R+Im7GNr1WUUmul4Co53U/zyLRB4yMiUN0xV0vqnDv36xzd46?=
 =?us-ascii?Q?MhJfqejgOKgn5NGOq+2DAE9C25H3oouLMF48QHq5n1sII2w/oPaZiedavtNH?=
 =?us-ascii?Q?A9YvGPrpaaNwXlOxMvhyk57PXjqau/AokQoTyYkJKLGhUJDV+pzSnrZgsrtS?=
 =?us-ascii?Q?qxVGODY1cgu6KEOR1tRfDydGKqNKrgBNS3F/Z1c3NyyJkmlrP+a96DMMNAHe?=
 =?us-ascii?Q?5VS5za1Sk+ZNKVzIz88tWzkpFZEEuhWFq8E6UGp6oItWC+EchjEv/jsE40r3?=
 =?us-ascii?Q?+93GqQ44q7BMprZM27664kCkdtvqyTnlpIqOmW4FPCwRUuHAX5GAZqfFy9IX?=
 =?us-ascii?Q?9+hDUWh3aQ3+3i38OBxr+6/5UIQUgMfBT/O1Dy1GKK9jjIvavklhHeEgq99B?=
 =?us-ascii?Q?BmJ6oI2Tf/fZd10yIixJ7DTHS8LD5FknEGeuqVSozAC15Eg3NkJxLCGBI9Ac?=
 =?us-ascii?Q?CGbLh3DlMX3B6XfekwzZ86ldnQXTozJmiNIeLb1JlhxoxIiR9QCgmoeBTOqY?=
 =?us-ascii?Q?WR0I+HPjLwZ++8yl7SB9t0pvWFUiPjyd3t8qs7g/8DmviB6qhma9IKcvRKTI?=
 =?us-ascii?Q?D2ATc12QiKz/hf73y3srpVtj7SjkJwuCy/p1oUl5Aws+iZNcQzlDSxTq8lWV?=
 =?us-ascii?Q?gvVksGqSEVD6sRpV0mHqsxfdmFJF/hDPOz9zBWGr9zWQl3FIgBW8uaoqcX/T?=
 =?us-ascii?Q?pZNzBgs0FJPq6d5V1yALfMgcGGZapj9f8DgvbR+pS7w2uxA80ofaZgoy0bwR?=
 =?us-ascii?Q?lLffEM/cmV5fDNARO/kRfVRe9ze7EsfR+JROr2/JnSuErWEhf6Qxh/Ho0JhU?=
 =?us-ascii?Q?Ns75NL4rMPqhQ638uIfpGimsqt6XdmpFD+giU3gZSLHQEPgCC+rUyUCnQfRa?=
 =?us-ascii?Q?JT6lYQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a7126c9c-3fc8-4d6e-538f-08d9d17f0941
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 01:42:59.8307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PpKk29Po4craE3QTiDEMTAXY8rvVS+eBOLd49LKF67IslXOIY4hwOmEkafwwbNQ/GepVtBVufW3Mp2ZncbKlntj+jzR4SqOpPxbi8OKjVTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0018
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 04:34:42PM +0200, Ido Schimmel wrote:
>
> What happens to that RIF when the port is linked to a bridge or unlinked
> from one?
>

We doesn't support any "RIF with bridge" scenario for now.
This restriction mentioned in cover latter.
