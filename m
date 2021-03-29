Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF13C34D241
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 16:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhC2OQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 10:16:31 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:30401
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230258AbhC2OQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 10:16:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=heHfB6RgxaUbv4KuZZTuZE16qnGR8aDJNJBJfyiqV49rN0t0FBcgEgRzGEzvC6RQp2ikn950lIAuibF1+jwqmCZ7I9pj7HFEs6TjjALnLfJTtatBqyKMAsaJCwwFC1Mnus4kC9Nsyqpa+tIozpljEYf+vgHK8DfOvv84okSiNRRW9nG75weL+x8DC3v22I/y3cLcLa9QNSDKsKVw6lHg/u8K65gC87dvEIuhbUlZGHMnpPRbvBN/ajMK8MA9ZFLlO8OE5utsdZDY+5gIQAYkhRNZ0ptwx4gwoKvc9xQIykaAxnSaDU9oPEdedvhfbUBrovMkGYfDFEpC6au+QxlkAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsZ4qMQn6VvDjCnH0Rg+gHU+V6P5p+8JGa7c4+QAKpU=;
 b=i085pI5bXzEFij2Qiv7k6pQP6xM83xrjZP1nFaROWCWvJXWqtw9xvR2P7KPjzDzT2tu6fhLD55Ho9HTZK1h1rbr9leA1JO5Ud+INqDXb7jqjAUy0sREWhEEqPLYcfOubxsUy0m3+v5QRGXqkVkHvC4Smr+nW+YQG/tCtWWGHnh6On4VFwOKO6DAsroYUQItFjajk5qs3AjpMkdTwqbaSzHlv4H+ebU5h/4Q/Xqa1k07IsJh4QfrOXBKlNt0Qx8w6BdtxdnHhQ3UqY4NRVtWj11LrBZJUV8MMhTqXA6uBNO4HX6qBfmVKjRjIAK90yIAdYA3zHXrvXBgxAsbP6CaWVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsZ4qMQn6VvDjCnH0Rg+gHU+V6P5p+8JGa7c4+QAKpU=;
 b=F3lo6vMNXPfEfNqBVHiNWPZUQNdTAE5R1NDVZBkFBgJFt9a4TAf7ICqwdGsyv0YIsNtp/OvNskjj5r1BONuLZ3rjlAuyY3Oo8YRAlL4k4SPznJz/Ey9NLIrc2sLGanxzZsHzRlRnOFf1jB5T+vdfcx8hWjtGtj6mNSj5+JwbYSTPjDzKvGctfcZ+TXd5oowox8+aRyPkTaE0gZHzB4ZgoaJcE5tMBqQ86Ivk1Ye2XLKQfidfuw1HUsvjB4efVplq1UJsfTTCOegpJhvZOILM2SHzt0w+NoudzwsVWXUpGL5JL21YdEEUTqJ7MUKEOpIyJhzVTR/VEtioE2YM/N+AuA==
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4944.namprd12.prod.outlook.com (2603:10b6:5:1ba::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Mon, 29 Mar
 2021 14:16:27 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 14:16:27 +0000
Date:   Mon, 29 Mar 2021 11:16:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: Re: [PATCH rdma-next v1 5/5] net/bnxt: Use direct API instead of
 useless indirection
Message-ID: <20210329141625.GA2356281@nvidia.com>
References: <20210329085212.257771-1-leon@kernel.org>
 <20210329085212.257771-6-leon@kernel.org>
 <CACKFLinM5w4Go25et=W7ABi3F9CVuyv=A_eXkOOHVjfCGh7YAw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKFLinM5w4Go25et=W7ABi3F9CVuyv=A_eXkOOHVjfCGh7YAw@mail.gmail.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR01CA0056.prod.exchangelabs.com (2603:10b6:208:23f::25)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR01CA0056.prod.exchangelabs.com (2603:10b6:208:23f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Mon, 29 Mar 2021 14:16:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lQsgr-0054jI-HB; Mon, 29 Mar 2021 11:16:25 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d770285-c434-4c53-e22b-08d8f2bd3d79
X-MS-TrafficTypeDiagnostic: DM6PR12MB4944:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4944C4B58EBD7C75BC3EE1D7C27E9@DM6PR12MB4944.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FtWxWxGiJLT6tz80Rj1nMQvsG2ED/BPVTBfWffCqZok0jk/dTKtKlkP5WMGCknuTeq6utJ6nL5tp8nc2ADg0w402tiQ5f5SIcEb+BSg5cHGOvW8hhbGnatAvq16KduQdju3mgNpW1bc+2ZzzE1nMuqIAL+aLFbvnNlz9tYvtGvZivZliYpKjVq5sqbU4a6ydMBbIybT4iICTiZdW65iaSH09372oGxfdwdeRWrQxK3NIsFA8sD/2AgV9K1StRlTbEdFyq5CKacc9yLIohMxXZ1nq5JuBRfyXQgQWFCRuWa+wRqfKGrOXYRUdH0ks0vfw5xXJm1w0UwZ02RIt/MB8P8rmMnu+DR05JDKrw+C7srrrGix9AJ8mAIE1XDopoMANU3Ag8GBOUycSuAbijQs6Rg6+GZ/441lCcYCshdlemcMov7ZVSWah2HVqjO7tQMuUZwhvRM/x4k3gijM+rEJs2k0t+rEtWQPz6Rq11pA2eRTFLcF1qHB18MczkyDwmc8WRFpM4Oqs9rUPo1627iQrOaQTVja5FOvuepgeAy8gszMfJY1FzSBtMxpQB/SJ6pMdYiQith9s0Z7tUXMp2+ZcYbwXu6jpeUfPn6lJmXzz8gHyQOvf7MejIGk0LmR9jVd2dW/hsXGYhwye522Pqh7VBblaM+Vwo4/PcTpZN6SEXLw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(38100700001)(4326008)(86362001)(186003)(6916009)(7416002)(426003)(478600001)(2906002)(53546011)(4744005)(26005)(83380400001)(2616005)(66556008)(66476007)(33656002)(66946007)(8676002)(1076003)(54906003)(9746002)(8936002)(36756003)(9786002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vQXsdYGvIr2MS5eoXzPeVZEMmZTJhz7/Y67dI1q6SYvISdq2KEAs4gco+LSn?=
 =?us-ascii?Q?Rhpg/K5AYpMqLYNZoz+ZRTRrrwhffbwqWDI8wJObuWNgwIaYuA/+Vxu1cRVb?=
 =?us-ascii?Q?LtGYWMuEttXJVPQewreeYNYGzX07CMNr1ACxRGg1cXyvJ+ZAjWwJWV8sn++k?=
 =?us-ascii?Q?sIBLusLGN9wPyFfhNOXcUz7inXXt3RvCGiL33VQdO/OmUg6DK9sNYG4X05Mk?=
 =?us-ascii?Q?DE+Bt2owX26u01C870yLneQJbkr3xxEcZsmrnRDDW+K/4fGc+MjaeX4U6gnB?=
 =?us-ascii?Q?M2cZumooNIGooS4t0fWy8wi4PzBkwzQuHRSqXRqMpvcq35U9J/E/mA9iqtSt?=
 =?us-ascii?Q?Fq0crbscOPNhR1XMmGtLoU58DWfXiiUVsPxd3l39+zU314j2PyWrAfWcOy10?=
 =?us-ascii?Q?UiKZ/32kKz4mvVPL39QcsQbBAy6hMDcSTJl4gZoVdKqEr6Ow1M6PGS7xvPbM?=
 =?us-ascii?Q?znJ897Y/G0j2RNxp+ifGpzq64gFC9LXjhwh098Yi8in3OBXciqP3rgfzocni?=
 =?us-ascii?Q?4NXqyKJ8BA2DN7DBbFd4mYSh5udkLCFrvCKfgS3DXkNmAIcR93paWrT6pRW5?=
 =?us-ascii?Q?Hb6JuhPPpRsA74H/9dyL3MkE/sSRTSO/kieV+8JBC3PXkjRF13Z7k3VuZtQg?=
 =?us-ascii?Q?A9Lbj2BaPRUifUWugPolTV3QfbT7P051JLzj633IyQGgN8sNyylKgiDbGTQW?=
 =?us-ascii?Q?YKbeAOIsETZ9d2BbN2VxTql3AEMaWekIy/fUkD6Pa/0j9M53zwuJ39weAjJ3?=
 =?us-ascii?Q?SYddnnp/T2DlEMAadHZG1pfDWdbCyV4Jlt9qMqhvgghraBwqSVqseLwi4TG9?=
 =?us-ascii?Q?s68o3afE5nIq1y3aTKNUGcXMOQWHFyPM8ua6sMKT2xVEFIglt2brlEi7IGHt?=
 =?us-ascii?Q?/K6svZEZRyjxeMmQgDStAHzyFbpUIgVo+WM3YEkX10/yH8yTiXCn+5iR+0TT?=
 =?us-ascii?Q?6EO4GGjHso1+jm53HzYIspPaFwpcBM5LjqNDBb5JesqF+l5jmGN5GHhEEk4/?=
 =?us-ascii?Q?KdsUL94C7BodFYfJi1Sl7X5vsVIj8qw9UlSNx72j6xuO9VytZLH4kojnw4GG?=
 =?us-ascii?Q?RLIrAu9GG4QJrf4l3QWBL7ihYbqjC0ZV/9VaLnKBlJ/3NDpywNNKtyHGDxkQ?=
 =?us-ascii?Q?7ZVK0E/HELenxqRPO1Ga9YFqK9Y9EWt2xoEjy5AY8uDk+jfZNE8PizCdKlV1?=
 =?us-ascii?Q?dSk2VzPTa4VbuUK9eGjtMeUQQL7GJUpxQjijnyxHEvwQ7mjl8cC56scyBghq?=
 =?us-ascii?Q?mqj+MpKhfZJCRDq7nF6SJ0SGbXYkJhPDvpU+VMPwROk0Tc757gr4zTI7h3/5?=
 =?us-ascii?Q?mF80J/galooPz/nC9iILOsEAiI0tOhezOSf0VMGZvp0tDw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d770285-c434-4c53-e22b-08d8f2bd3d79
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 14:16:26.9742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pbAPK1wDjPrWXvMuijd+/mdok4xRKxofNRTDrmBofS42Vuo6Bhndvcdcll+4bllm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 07:01:44AM -0700, Michael Chan wrote:
> On Mon, Mar 29, 2021 at 1:52 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > There is no need in any indirection complexity for one ULP user,
> > remove all this complexity in favour of direct calls to the exported
> > symbols. This allows us to greatly simplify the code.
> 
> The goal is not to have a hard dependency between the RDMA driver and
> the ethernet driver.  One day, there may be a newer ethernet driver
> for newer devices.  The RDMA driver may be the same because it
> operates at a higher level.  The hard dependency will require the
> older ethernet driver to always be loaded even if it is not needed.

Then someday you will fix it. Today you do not have this, so it needs
to be deleted.

If you ever get to that point you will need to rework this driver to
use auxillary bus/etc, and it will look very different anyhow.

Jason
