Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF022019E2
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbgFSSAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:00:35 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:61312
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbgFSSAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 14:00:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGYTpasZxFF2VZhOAhSDyHp5VeLFWX5iAWPTH0AGpnwov0tvYmIOUE8z/UgtBE1MTADR5fbghjGCxQTHe7c0x4oV5jhMPk7T7yl8b73rNqIjJRbcdRBSTooxcNPCLNJG4UmvoRBLJRejMTO416Ow8vtGIJXnI2jqQYo85M4uxaIfM/BtnFPJdKDNq2DGNJZZ+N9Km1AJOvmj+jAZkjzFgGhPz2QL4/yvGueZlGJNBISLHx4V1xV5CJkuLjAzGaPBC0JQ9Lfyjnp/97i7ERJSdQwARJQnZIP4BHb+bmsb3sc1GJMttOoDuCQB4hLwW9iX1sCneuJ5vIHWyrQvCIim9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vraE492OIDdU3mdqVBnYlBBV/tETIouHdnuiDm/JxCQ=;
 b=Qfs34AgHfB2HEij8Qdx1G8HzhTgVGYn0I4avXm4fLMFZ58tt0koeH8GujW15bw4VoDIC0gZj0+yvXDmxDJuSiTiA0/Y9ykYhYl3yfjQVVi6pKusVz8+AKasV5E1BJMb+csVezYMcH3FCr/i7IWOe9eI1tZ4Nw333gzXZ0exu3zMMgDhXwTpyIxR64VcegmrDZ4uPH3cglk5JmOXjrD648fMfsfkssvyDgRRMqY/lE10vXUX56kL6VmtqzbwAzT4DCQyXFQgy1K5a0EwDXnJjMrV/808GGQ6/8XPXGhJ1FqdfEG2//shFN40rCSbj7HFebquauEhkC+sCNYsU/7UHnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vraE492OIDdU3mdqVBnYlBBV/tETIouHdnuiDm/JxCQ=;
 b=F1zw2HhggHE+v6lUAtM7+LlqLUix3A/Y9X4ybbqAcHSpfexrm+5VXXIJuRRwSVTj5cOwA0eJwZvG6oUT7ATZxvVD1cOd97FK4oPMZXOo4WB4pLae9EyYz2fMmOKBZW729xBecZjfXI5E/zTOVlZW48UFlDj9ki9LuqLkdehbT4g=
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB7091.eurprd05.prod.outlook.com (2603:10a6:20b:1a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Fri, 19 Jun
 2020 18:00:29 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::d067:e4b3:5d58:e3ab]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::d067:e4b3:5d58:e3ab%6]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 18:00:29 +0000
References: <20200324034745.30979-1-Po.Liu@nxp.com> <20200619060107.6325-1-po.liu@nxp.com>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Po Liu <po.liu@nxp.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jiri@resnulli.us, vinicius.gomes@intel.com,
        vlad@buslov.dev, claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org
Subject: Re: [v2,net-next] net: qos offload add flow status with dropped count
In-reply-to: <20200619060107.6325-1-po.liu@nxp.com>
Date:   Fri, 19 Jun 2020 21:00:23 +0300
Message-ID: <vbfh7v7kkaw.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0025.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::13)
 To AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by MR2P264CA0025.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Fri, 19 Jun 2020 18:00:26 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 62229fd4-a105-4aa0-df13-08d8147aa6ca
X-MS-TrafficTypeDiagnostic: AM7PR05MB7091:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB70915A418AA0D78528CA5488AD980@AM7PR05MB7091.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BuFMA9YTWmEzcXZbZtH4imlwf2v2LngBuweqhnz5nZ4nHHJM3aO4nBZQLXlgI5soiWpF9Q+/Ju9wVqqpcWTdIpKmh2Es8hul8UF/01AiTp3jm8QQb5VQDX2hhZgrhME5inA/rb1YbxnGIjJ843T9kHe7XaIYqE6ijqq43I2WM27V2BBpcKYf3m8EVVRTRvF7WBshZ/3zam/zFh3EPdut8NuOQscK6IOA/W5XgAl0p4YeKd+ue05h+eqbuGngDEPLguIjFHyBnQkj33+zHrWgTl/Cw7bjfh2cCXmbX7iN/xI4fpaVxntkPemWjPOt09wO5v1KdsrcGZbU/eC/G/r1WQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(52116002)(7696005)(2616005)(956004)(8936002)(36756003)(5660300002)(26005)(16526019)(6666004)(86362001)(8676002)(186003)(4744005)(83380400001)(2906002)(66556008)(6486002)(4326008)(316002)(66946007)(6916009)(7416002)(478600001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RQCwl6yTYLYZlxsvXs9ukJ+RGRnGhK3bVyautYjlRKtGIX610BfkJbCfsqFdzLkegpl/z0OiDhJF0arS/x8VrPlvT8UwbUek+KppzQJG+7Rq2zcZb2GDtMH5P8wXYDel1LDqKD6i/nayXIxQL+wnBj58gzgSYVjqhIAGIudcezaUUHBE0wHv5RMUfONUkF4WZ1jKdGUeva2piIBSEZs7pogLvunOr29+VFuu2Jp9nKRtG2UTssNpMU1U+YHpbQQpnhPk3RxQzmF2OA/KLTnb3elwbR+FYMWFNaobeTpzgKVdChsv1w5Rmfa/NYJxR88pvUXWZ/NjkJ2GgLXjpqUGzw38Y9njYdW/NHfpZYpKAG6P2ymmEF5KoTDs9jfgUsuhlm/EtYCwVcG4iknDTPKkE62n9y73SocO/xAj55f+KBuK4+012a+QT0BuPs1bxJ+ApIwZbBIWLtU0d9pv8xV9rMfw+HVp0Q9QGU6/2XffICM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62229fd4-a105-4aa0-df13-08d8147aa6ca
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 18:00:29.2392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3F8WoFtxtny3/7be6QJdQhB6cgyzLx2teZt8ce6bjgxEf7gJL+5mqgdv553pAJaY4oxgym76gnSGJUQMWZGlhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB7091
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 19 Jun 2020 at 09:01, Po Liu <po.liu@nxp.com> wrote:
> From: Po Liu <Po.Liu@nxp.com>
>
> This patch adds a drop frames counter to tc flower offloading.
> Reporting h/w dropped frames is necessary for some actions.
> Some actions like police action and the coming introduced stream gate
> action would produce dropped frames which is necessary for user. Status
> update shows how many filtered packets increasing and how many dropped
> in those packets.
>
> v2: Changes
>  - Update commit comments suggest by Jiri Pirko.
>
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> ---

Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
