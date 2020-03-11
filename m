Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 636AA1824D5
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbgCKW1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:27:44 -0400
Received: from mail-am6eur05on2046.outbound.protection.outlook.com ([40.107.22.46]:32513
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729518AbgCKW1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:27:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=De4wOov9rFDieGYQ/GyG/t3sLHMy/a/TToLZba31vl9x/kmbpan1I2qgsz/0Lu+dN1z4by+e2lde5INnKZe9V/NLlUVhLlYFl/Uq2tIY3VsKdiXrr9ytXYNG7Hqq5P5a6iyBwIVZHbKvWLY89uss4eYLU8lAzFzGmdVaauAYySkswFAmyYgZVyjdE4KUj/zwAUdMb9x7mj2i8R2BFIcRBQaBFvl5RskHnfNmGKQvK5inTXqrm0FcXB2+umX9O/Ea7Bfw3t29xfJwTkoO7caY62GxRYEYkL1v7Rrqxd+QODAQofjfvMG2IvrNDLTK3jpylVdZmCmdzmEq0N4qJSqAFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DyxmYXtX7f852FlzUVD5z+Jv4WVsMr/zw6fNj5gXjQ=;
 b=jIxMT7YXugPMuHdRqHTvxrGU0k/GBs9unpkQ4jp86FkELtV7TF0Lnm5438ha2ewpozCWvMqEJSihoRSj1NeXzNvfDC46EladarwP9/bwkNvGCmIgU27cZc3nR7eoib9gUla6vFD0RB1TyIz+2rlotsVwznHNjUT8TFX5IsskhstlADh1QB67CIDbTxIzTa/FY55/202peXbgpsO9tVGLzjXALKHUC4K6OJz0hnJEN+eyK7F7N8GHWHZkk87hQsxLLnPZCtD+j2KkAtXMOeJoTmsgoFAGEpMruG+0i1gWrmFpZSw2etTmseKLRen+M8Iwa9rmf6plriCB+M3O7QZMYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DyxmYXtX7f852FlzUVD5z+Jv4WVsMr/zw6fNj5gXjQ=;
 b=YTI2JNr7dmK69FyjxfS2PoMIoeplL97Oh21rpV3UloIhLPfETA+6Gou1V4jtcCdfEPvN7vNDqsh6XIgOI0ruxsscfaiYdgO9eQvQhQ3Czk2CLcsd04prTh3QnI6DE9JAKDg6jiIG998HBKutNvO+ij3L36b8d6XXoY+uLBSVSvc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB4293.eurprd05.prod.outlook.com (52.135.162.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Wed, 11 Mar 2020 22:27:41 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2%7]) with mapi id 15.20.2814.007; Wed, 11 Mar 2020
 22:27:41 +0000
Subject: Re: [PATCH net-next ct-offload v3 00/15] Introduce connection
 tracking offload
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
 <20200311191353.GL2546@localhost.localdomain>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <511542c9-2028-a5a8-4e4a-367b916a7f1c@mellanox.com>
Date:   Thu, 12 Mar 2020 00:27:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200311191353.GL2546@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: PR0P264CA0177.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::21) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.105] (5.29.240.93) by PR0P264CA0177.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13 via Frontend Transport; Wed, 11 Mar 2020 22:27:40 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6e25e4ef-2636-445b-c8cc-08d7c60b698c
X-MS-TrafficTypeDiagnostic: AM6PR05MB4293:|AM6PR05MB4293:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB4293FB80D665285ECE93F7F3CFFC0@AM6PR05MB4293.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(199004)(52116002)(6916009)(6666004)(66476007)(66946007)(66556008)(316002)(966005)(4326008)(478600001)(5660300002)(16576012)(31696002)(8936002)(36756003)(86362001)(53546011)(31686004)(54906003)(2906002)(6486002)(956004)(81166006)(2616005)(186003)(16526019)(8676002)(81156014)(107886003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4293;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MQfVTjQj2hFQbPOG4GJHgNEJe42CDzbyz7XunjDrsX+4LGGNviHCa4ufjx8zf7Ydw8EzlkM2n1SLCZHqvvptJqk/zpgEbxfLVIWuQ2Zkb2eToPU8cJ3XD/gdYIHymnKROlhhAy9POn+d4eqeXStvFVhNTn5vBKrYI9Z2f5kta0vRhsatmm+Io8n90dQT2gynGaRAo6P80BEg0rRJjyM2LAO55jbJfq6EdzZB6Mrhd0KkSHqdaroaor+LKK9wZFar1TrEWiAGbPM21HotXu8q4b22HdAit2T9q9ktltBcDzx1LRAXvXGnx18uIH3gJ5urBjFPmnbg5K4f8l1cI81d8HavjQMKq33BAHZLxFrHu/xqXVhxi/fMrD9Ad8xII5CM8qJagwnMfO/az+B2PdvqkaQWn+BadXd75wB1+FYlJQQBd3b2K61f82Dsqd/sIAfMt89nVOwRyyDrHzNAd3OdZmQXb2HGAkgCzsXYjpiFohzZjRG5za7R6PFUlx3qHJ3WF0FKSEgMDxyefdg5rKruLQ==
X-MS-Exchange-AntiSpam-MessageData: fiVgFpTp0ggJmqdkNvt0mjIRIIKSAI1zXkMMVyvjqYBFCkVUHLro9wBVyBqWeDOwa8HsCYGdNK/uJ2J/u0h9sDWvcavFonBAdBwLuVYMmoRFJwBByj/LEuM0UTarM7KQlETve4Wq43oENGGbrmB9kg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e25e4ef-2636-445b-c8cc-08d7c60b698c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 22:27:41.5890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlwLQjFAfC3/70jmlu8Ybo+wzYdE4FivNsXY7XL8fzn+uPae1cXoXUElLCxH7gRcl89Sto2YEfG626/bdJYLDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4293
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/03/2020 21:13, Marcelo Ricardo Leitner wrote:
> On Wed, Mar 11, 2020 at 04:33:43PM +0200, Paul Blakey wrote:
>> Applying this patchset
>> --------------------------
>>
>> On top of current net-next ("r8169: simplify getting stats by using netdev_stats_to_stats64"),
>> pull Saeed's ct-offload branch, from git git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git
>> and fix the following non trivial conflict in fs_core.c as follows:
>> #define OFFLOADS_MAX_FT 2
>> #define OFFLOADS_NUM_PRIOS 2
>> #define OFFLOADS_MIN_LEVEL (ANCHOR_MIN_LEVEL + OFFLOADS_NUM_PRIOS)
>>
>> Then apply this patchset.
> I did this and I couldn't get tc offloading (not ct) to work anymore.
> Then I moved to current net-next (the commit you mentioned above), and
> got the same thing.
>
> What I can tell so far is that 
> perf script | head
>        handler11  4415 [009]  1263.438424: probe:mlx5e_configure_flower__return: (ffffffffc094fa80 <- ffffffff93dc510a) arg1=0xffffffffffffffa1
>
> and that's EOPNOTSUPP. Not sure yet where that is coming from.

I guess you fail at what this patch "flow_offload: fix allowed types check" is suppose to fix

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=a393daa8993fd7d6c9c33110d5dac08bc0dc2696

That was the last bug that caused what you decribe - all tc rules failed.

It should be before the patch I detailed as seen in git log here:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/log/


Can you check you have it? im not sure if compiling just the driver is enough.

if it is this, it should have fixed it.

if not try skipping flow_action_hw_stats_types_check() calls in mlx5 driver.

there is a netlink error msg most of the cases, try skip_sw or verbose to see.


>
> Btw, it's prooving to be a nice exercise to find out why it is failing
> to offload. Perhaps some netdev_err_once() is welcomed.
>
>   Marcelo
