Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531063D017A
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 20:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhGTRit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 13:38:49 -0400
Received: from mail-dm6nam10on2055.outbound.protection.outlook.com ([40.107.93.55]:15393
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231381AbhGTRia (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 13:38:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZTqDy0mpYvUNoe9sgShI0L+mFdWs+1DfqQUSqtxIkBatRC6gC/jEOyYeMBJhoOBFUD/rgT1CfQqHxDMmOC9yWxCrdZ0YIBPh6ea3/YACkP2nFXuUNo/yOZjCRuwj5JSjqHaxVSl+zQeu+8sOB/q+jfrK4KadgvKzfAMGmwEksK43xExDmikREn3u5EGLqSa3YwCjkWvklLHXULmvkFKxU9aLvJfvAMh0kIbOysUezZarGnnDpRqMeWbh0C3f/U4ZUQIbsFLDOHawSaViNQLlXw0VJe/odRg3dRrieU1NdHrzTgqWFuu8nCF3j0zbD0d4eqpPUxnUGTupqtUxsHSDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ei/0YmdBusq4LA/gB+ZJApvpnZUR4vcGRFNP67mqv0I=;
 b=E/B/5gUA/SZcPpiG/tMRa2VFrOBdHtwzW5XFWfQGbOeO2C134Lt3kA2v6bx1+5KkwOifDr58PH9zv8A91BYO3dws28jyJAERlnNobI692rkBWBXh444l+PNi/AgjTdR6diXPvyzbqD9kGiGyU+R6/kFie8MURALli4V0i9ouVZqJRY/PZZJu5p9pX5WLBxqywRMQcsFCMBLbvnfkeN3pnZY3V1xpjiC/h5S9uYZb/8mUWeBjzK1/cxqT/8h01xpV+wYN13GZK4XN0C0Gzovz3a1MAF9oBBPMX7Lf6BQUx5m2JP07U9XX5Tv1fzlId65BwrhCpVnp1CboOwGE3fbqfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ei/0YmdBusq4LA/gB+ZJApvpnZUR4vcGRFNP67mqv0I=;
 b=e1LxZhizbJEtyGyyjy7YDMCjqKQvEsKALKKJpa9SKSa1lO+lxJLEr3G8B2gRAx3JOTTwKnqO1nzQWbo4zKUz1mEfMgjOcjn1dXQRdR4+9umitspJJy5lwCHpaXud0Th9JV5GLi6toKSPMTc1MbaX8iZQnjEsTQVMLj9p8EaZJDvfb1Eef1erdyKEoBaEGcdPy4iwPgpqNYKh/p0hMpKqQN1UCi1jgUeMJHQJfUmLN9pum+Wg+ByoEp5090PXLfOa3DgXxeS7G0pYtPW8u1qzioELWH1AZdyEqKp3uW7kJUjL2eFCg5gyqiYag6kJ0NVJeCLSDJjfCGfuMLxyR1euzA==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5239.namprd12.prod.outlook.com (2603:10b6:208:315::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Tue, 20 Jul
 2021 18:18:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 18:18:49 +0000
Date:   Tue, 20 Jul 2021 15:18:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-rdma@vger.kernel.org, Lior Nahmanson <liorna@nvidia.com>,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next v1 0/3] Add ConnectX DCS offload support
Message-ID: <20210720181848.GA1207526@nvidia.com>
References: <cover.1624258894.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1624258894.git.leonro@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0183.namprd13.prod.outlook.com
 (2603:10b6:208:2be::8) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0183.namprd13.prod.outlook.com (2603:10b6:208:2be::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.9 via Frontend Transport; Tue, 20 Jul 2021 18:18:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m5uKO-005491-0e; Tue, 20 Jul 2021 15:18:48 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2c50569-a699-4d3e-feaf-08d94baad1e4
X-MS-TrafficTypeDiagnostic: BL1PR12MB5239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5239D7BDDC8E480E7491E1A5C2E29@BL1PR12MB5239.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:669;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LlXcfCIxCO3qfil5QWBCrif2OeK6EabJqB9GqdzKO20Q8d7pn9rJeWYHk/2F8+qdOyunQK+K+Ez2kK5CTP4xDuH6nbftayQW2RWUp/D3jS4dEVCFakLDProcyG5PwRNZrnCjWViW8ZsAhX6o0wh/i0denIPK0j+2NFLoKZxNb6T0Y8Z2H4LWQ9MoiwR0UzQwAhyk0ZdCTgqhKJIDr2MyNrCojNgE3jR9b7qK44uGtA7k04fuVCmiRLEVljMeAJLmA5lQSe+mA8mmamqGIsO+imEmcPSaJnbbqMD0zixxpUSQFfsWwXKlx9LuHYIf0AXBnlCjjn658JslDmWOsmgQhd6rELmDOHmSjFJAilphxIngwbuCqD7X+z+H2/Dzh+AUlM7CKcK/rDpJQwLUa4N4wOw9vrq9s9HbZB1cBZTPhsrzmkpFGxyN7X0OmoYNl9QyHxXmLKO0h1aVxq+/XAZvl54ZpT6IT9vIQGMXa2i02JK1kRFY4c+Fy5wWWUj/+tCOxVqCcv50xUyxCLspdd3uXhHfRZu/67YNO7AYSKQ/oWQB6CGBNVnr2ASsbPjZvE1gIt8AqdW6yODpuctaez5K7PhzQLuGvHyCA7yUkEo9Zi4WOp3BtgswexmwexH9vCM3zdsubTsH9p27R27bcm0h1EW0HvZV+CYAEXOYr+oKgRPJea1mvb9yrPjfRXmO4C7Rc1Izi4h64fsMNwhZwNGf5Hw648pgzqE8JEqhhnbhMuY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(5660300002)(66476007)(8936002)(8676002)(4326008)(66556008)(107886003)(26005)(66946007)(38100700002)(33656002)(86362001)(2616005)(54906003)(9786002)(1076003)(9746002)(186003)(6916009)(4744005)(36756003)(478600001)(2906002)(83380400001)(426003)(316002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ejCPD+a1Mie+oBAMyyn4ViQ6AlCD0nDjXYfL7QhAGYKNNr3BQeRJvLPwGUoB?=
 =?us-ascii?Q?xVhQyFMX3awM9s2+uSVd19j0mTWk1cKFtT6+K8a+bPKbB9dzHDFtm1uKlSKe?=
 =?us-ascii?Q?ZHGKrxIJ5KccvHbGUI6mohu89YOSmSgSKYH/5+mQTKEz3nS7ZAPLPKaSVj+H?=
 =?us-ascii?Q?wsKz6SUlGqt1RGP36hskQe6UwDt6qWTfSqRXKfaXdqAgd+r3YPlyVIjht1RQ?=
 =?us-ascii?Q?P+SjEV3WYgOeiN/RS2ZmPufGRrcsxdwaCuS+0ZstbVZrC/IudscveCvh8f+m?=
 =?us-ascii?Q?tiAgCCWf36T2NbmSoEhcO5FEANlq22QaZm4Ofjj3rIGPI7LQvuJ5W5l/ICXg?=
 =?us-ascii?Q?KI8FhXdn0IYFuAdXZESI9V63hzYNVXENf+CDBIIxSYJsCCMXOvh23qboowpo?=
 =?us-ascii?Q?cTkD0QAndfk1AyJxE17H9IiDLcNxQoltseb8u7/zgw50XxA9Gywr94fN7ws9?=
 =?us-ascii?Q?fKt/WBXIDPXdZMR9vdCgG6y3FNI+3ysSkJUjkH9N07WK82lkzL51VYgtjYnn?=
 =?us-ascii?Q?aR47lrbvJB8UxayHB1Xwk5CNI17BnLUh4qUkTg2IjvHNHLzUx4hQPa3yU4nJ?=
 =?us-ascii?Q?pGxtK/F0RrGKtq3v2t33BOmuCmjPy366qVpjfO5H432gpIFf/7CsnqLxDfAp?=
 =?us-ascii?Q?EdNl25cl63ZCpyCyXg3NAOF1ugOcxeiHaucbG0dYTRZLxBKYPCVXUpDcdp1G?=
 =?us-ascii?Q?hHkHjJCw4OBC+rYhchSvfDPMgvjUfwHHFej+6TwHzvNvVC7owEPYz7+ZnFFW?=
 =?us-ascii?Q?NA+S5VA1CYj5NXJ/3X/hrbohi/gM/qygqNDJF4svYn49nBtNpKBszAvGIimO?=
 =?us-ascii?Q?YxNRPzFdsF+cdiNgMcpDH95LCDnG+wSkwhgkCx14ysgzj8GgDVXUfj/h9tSk?=
 =?us-ascii?Q?rMcVSewR7zaW6ukKFe2Ay524q0/pT42Apzplx5z6AajnzXwaxkdkpkLwadOl?=
 =?us-ascii?Q?nYJd7uGqrEvRGswFXGSbmSOU1pCyOZqQ744FNEPseNgBkuUzIpO5fBt048N/?=
 =?us-ascii?Q?+PWXpmgiJT1yQI5wSp4xigPj4xuyMlD37lmxKo5DyVVgauAvKZmjMARf8eLB?=
 =?us-ascii?Q?dO1EaHplS+wkwnLWoP9gQZ38hKZ/ek65ioPjRjooUr/A+4vEpbrkp67kZ5VH?=
 =?us-ascii?Q?4smoTwjKXTZOkXNdVSDkWmw5WicISjO5MBTsS9xgy4TxNkB8xvU6hE3vLA0v?=
 =?us-ascii?Q?fwO63kyepRJq1VVTbBhHbYlrxStDFKO+cONC6kChw9fAKw5m//xNhAOUJ5es?=
 =?us-ascii?Q?Hx0XznVLGdmWVKbdT1LT4YkOlgar/451/TfLx84rqfeIKQ2t9sggdk7Zw0gL?=
 =?us-ascii?Q?VWiBIjLUqAmRtQvqZKSmUWrH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2c50569-a699-4d3e-feaf-08d94baad1e4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 18:18:48.9168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +9thYkqzCbPr2tuDgU2OcxwxH/QejcS6wZFmvSo9cEIBUplI9JGXGE3V6cT1bJ8j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5239
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 10:06:13AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v1:
>  * Rephrase commit message of second patch
> v0: https://lore.kernel.org/linux-rdma/cover.1622723815.git.leonro@nvidia.com
> 
> ------------
> 
> This patchset from Lior adds support of DCI stream channel (DCS) support.
> 
> DCS is an offload to SW load balancing of DC initiator work requests.
> 
> A single DC QP initiator (DCI) can be connected to only one target at the time
> and can't start new connection until the previous work request is completed.
> 
> This limitation causes to delays when the initiator process needs to
> transfer data to multiple targets at the same time.
> 
> Thanks
> 
> Lior Nahmanson (3):
>   net/mlx5: Add DCS caps & fields support
>   RDMA/mlx5: Separate DCI QP creation logic
>   RDMA/mlx5: Add DCS offload support

Applied to for-next, thanks

Jason
