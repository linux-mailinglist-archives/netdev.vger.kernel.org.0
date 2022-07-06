Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0EC567DFF
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiGFFqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiGFFqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:46:13 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5F2220D0
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 22:46:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BvY9UCVwjAiXydAhidI5iHK8nKrkkaRy7Lg0h+AuRB5XavzYxGLk4h5Q2JOzOrIGknzshBlFv+/lC+5a6J7v0S9lDZ4FTxL0Pei+oh2dpsCYpNxC0e3UxgXNdXyby/zAjA8Et6rThcGN/zYdanVmaNwmVa1T3UjOBeJMvsr+DAn6unjNZUKxVT6spRHxq9zA5Hlq+W5WRDBHJWDRSxADo2TF92EwpjrlJH3fB6h5C03Fr+AtFFwutgx89//D+WTW9eo1ZVtp4TicsE46MZLNnENz5Y1QXaBsMKLCgiqQ+UaRWTPfScGHFqDpnfR4ky/EVnzPHwsw+kHj9hpcoLWmZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KpKQl24VvyILK0pgWBFudeqe13tNx2FHUs1rcys7K4I=;
 b=VbdVaEjcwEEkF18GH1yaHVG/M9mgHydEGjQV1VIl8Mpr5FACE+8/BJFONveoxhGzMjejrAo6pKR1eCLRfAeiDmgP/vflSOmpzefAqRvNDg+p+8kQouU8kkbHM4T83tSLEgRQFiMR6t2KEP6XbflJZ35qDZPosScFcEhFzNfhmROkEDq+Saw+vUKmQfnbDsE3SKam0cf5lkcj/tZXqNw8+WXdUPBL2EXgQYpQA6NZgR6Mgyo1gRj+QXgN30dVt7eC05iVjplg6Wgiz0EvQJQVKi9rda9lGDjTG3ZNOnvtziY3Bq1GgUmnk2j8fQDqQyx96yksZi565chnYWgPe6+l7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KpKQl24VvyILK0pgWBFudeqe13tNx2FHUs1rcys7K4I=;
 b=Ny4avV7a3VJHEji/SU1y/noLxTBIXyUb/b/jvmXkbGSogZriD87oZUDslVOPxJ1tRRICbc1UnUhoxFTpk7Lqc8CURqeuBIJkgAs/lFsUubSav/HtP+qU0+qhL4GHfvc1GBcqnxGix6+ajIYzzdSom8z3+PMequCbJCP/GV4BD7AW8bj0AsIZfGOxqvVHof6DPmgpxkotzO4fvhVFCjTZaAcS5mHWpNiB7coGtQubJrlEJSUfapgeDCW9HMmJexjB6I5SdfOhzgMTLUv7I6Abkzul9jZ+hXQMqa77y3UcB6hJp4naz/3URxWqDKRLD1fcgpeo+bTjWywXnBJHYr+r3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MWHPR12MB1263.namprd12.prod.outlook.com (2603:10b6:300:f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Wed, 6 Jul
 2022 05:46:11 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::3c4b:7012:620f:57f2]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::3c4b:7012:620f:57f2%5]) with mapi id 15.20.5417.016; Wed, 6 Jul 2022
 05:46:11 +0000
Date:   Tue, 5 Jul 2022 22:46:10 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vlad Buslov <vladbu@nvidia.com>, davem@davemloft.net,
        jianbol@nvidia.com, idosch@nvidia.com, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, netdev@vger.kernel.org,
        maord@nvidia.com
Subject: Re: [PATCH net 0/2] Fix police 'continue' action offload
Message-ID: <20220706054610.peqqedlbwgzpiys2@sx1>
References: <20220704204405.2563457-1-vladbu@nvidia.com>
 <20220705171113.690109ee@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220705171113.690109ee@kernel.org>
X-ClientProxiedBy: BYAPR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::23) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d44d0dc8-22ce-4b44-0ea9-08da5f12d4fc
X-MS-TrafficTypeDiagnostic: MWHPR12MB1263:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: geVfEXdtme/IHqhES24BUZgML3FkmjsR3y55+hD6qJ3NEy1EdD2gO9kzee6+ysjdcvLsLRDKfNQ5Y2hfHuZvgZ+agHpOXb/IZHLcWn5TFyy6gxsM6TKXQ8iZgs9O9KZ1Z+B549jkCffgzdTf9Ghdw4EX1fQmTq08ucpEc3OhayI4Yp+30cbIk3H/LyuIRdsZF7G4GsTd85jFFul8/OBWgWTOGhOkdGMJpNSTjn7N1/hXd5t67elZZSYCxJSJZ6z33rG8WHa9HD3zVbx/O/dV2YzUJHjF/JPKnI8pW/N5MPdxnUDnuKCOCwW4l2EF9DhyCIXdku4pOYsogLV9hLhwAIRWZx6vohOc+Crp0fyRBvtYW5Ru8KRiBjOzhsraMBcwWEy7npCYM/HEA+pETZLIEUqQoCT06EGZXjg2nSiTMY5S0qRpyxa4nHHnXTQlKsrQS94MloxA5SkmhoQbzWc9TeCEGbpLIFdEznq7+qHHoTItU1EDRvWvEDVOnqRvXvYRuykQnRDDpDYIERR6puiIg70K5p1UrcxoHZtxDqXgIcnAvPVaoX+u6MuZWylfzsbsCTCJdK401iA9/BjHaLq7l+94UgrvQmi0UmHPHCTDrOoyntprSFtn7evNPMTHWBU1x7s+CSUwkC1RNqS2Ff7FpQBHUkt6jVcU42TnwEQWfSy5bugcUdIBJfEXs9edcX0wc/G5uULUXwzc87eskeQX58kASa3I1Y3Xv9E1BYy4bDzhQgX3LYtM0MUkwA/iAH7r86QXGQH2rHFVfn54XJ8yPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(39860400002)(346002)(376002)(366004)(136003)(8936002)(41300700001)(4744005)(478600001)(86362001)(6486002)(5660300002)(2906002)(38100700002)(316002)(33716001)(1076003)(107886003)(66476007)(66556008)(66946007)(186003)(4326008)(8676002)(83380400001)(6506007)(26005)(6512007)(9686003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K6KcuaJRJoVXZV6iJqUywJm2cPXkqucwweYAs+FuYkYgaEl63JW7tCoqG56f?=
 =?us-ascii?Q?pZyKk+euXkqjzImsxP9zsB9oChZuDGqs7+RIIqPU3s+xZeTucSqBUjeh9nT4?=
 =?us-ascii?Q?B5PGXerkYMGjO8ZIBjf+AuRie+vk1SzDlF7w+o76NKSfw0jUv1KL6yE5esCR?=
 =?us-ascii?Q?Rpdd19O+objPNG19W/8Ne2wTttAGZIjPD+s4J0jh3ZdiiAyLDkLwjCF7dnlz?=
 =?us-ascii?Q?8l5oX/kfg6TmUwNaraXsxS8A7d8UKcz9HPDKDXjc9iw+ayw+pTfH7LOaMpSq?=
 =?us-ascii?Q?sphaR2erA2ld4NgWwFFEoLazyS5jQl1iXO5ak6P8Ap9TFvHat/Xios/MU3pm?=
 =?us-ascii?Q?RiSajCUe/zA0By6YG20NVjxgT8plkmV4WSHsGPjElu+kxiyHqgDbntAhqyqF?=
 =?us-ascii?Q?hR4yv0iHgZu6W22fS3MMdDo4bK62ulyHgjkq7pI1IrLvro9bpW08nlQZlRIs?=
 =?us-ascii?Q?7giTmssegG2bF0u2dCDqLasaH3oFx/SeRVYy9oKf8W/pbHiTLMAD8vYwEUNY?=
 =?us-ascii?Q?lcbhPaNTuxUoYEwZFehLSYMMjSX1l53Z+N8w6P2Zf1IuyxyQrd0vXlTbHhlt?=
 =?us-ascii?Q?eTRxwxnbBCOEJLq8QYfsCst30mEw9moZMX71WO5clqnw5rUxwg+63WY9+7ap?=
 =?us-ascii?Q?o1Ale7pGLDPJ8yOabDp2FqKrQcGlAufQBpaw0muHR8yU6PbqWWeC/88311tz?=
 =?us-ascii?Q?vNJ577tKT59kd4/ivf/99mVSnBm2+GQdM54ltuqItQs3+iGprFHLy28pV7/u?=
 =?us-ascii?Q?ULi471UkmxlFGHRvLw4bsAcEmsUpHmWQxSYksgTtKpkMWLkcXUC4CcTpj8g3?=
 =?us-ascii?Q?AQfncDsFnJM9Nj+kCnSCAvmdPAdqq/BseLN8MZAO1YS1CmGg/YNPDrjL5pm2?=
 =?us-ascii?Q?hSwmkxZzQWJUo1HMUfPwjdwD5VXa/TTnn4WgGoc8se+WhfzOW+y8m9MKG9m2?=
 =?us-ascii?Q?22SAoOfnXMBfmUxi5Pi4fjjweBb/wHkbQtkVipCfIoASyxqbU/tVC9IxkCE1?=
 =?us-ascii?Q?Bmm+PGz1khDxE0lXmA8hbcdezjWT4Gn1VnAP17oan4cIyrz4iTYCilmbcioX?=
 =?us-ascii?Q?ktH9vCkna+Hd89qFGpkd36/Tb2QGVGgQoVeNd2J2OwfLaXzxfVDC6sLuSnOA?=
 =?us-ascii?Q?OsC1HUPqsfA0N5K+PnUcYdKSc6l4PTvQ11H6ZXEKMkaBL5G8W4kLddho5QEm?=
 =?us-ascii?Q?G13WJ1mw+3hyFwzEOAEEC1WbYrKqNu3ExRBkjvpNjQbHJQgHqtxVVK/ACWSq?=
 =?us-ascii?Q?vGdB2U0pf8LwOCyBrVygoOvWS0YKEIvp+0kb+PAQCscGFJR6dDnzCs1TIcAe?=
 =?us-ascii?Q?txM/riyN3ldWbZ0WjSrNvVDCqzM/G7wg7016/BQy+Y8vOoHu+0xxXNWjZsKw?=
 =?us-ascii?Q?3X0Lcb9eTMSPNv63luXNj7VGTPJ4kbiy6f3NKNpZdUZFVgS51CEpqNHYGWVn?=
 =?us-ascii?Q?LZGYOA0TSulJ2n63APGV77pdCOFa19Yni0xyfYmBojBY3oxITr5JL80dPeHW?=
 =?us-ascii?Q?5sP903i5+kz0ujLzdcgYLfygDqqmMb9LvQZOwsZXeZ8pFkP1l6EG92bl9l5a?=
 =?us-ascii?Q?spBF5laVDtPHw+FTOZcT/FQZAQe7dIZSmZXJamaZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d44d0dc8-22ce-4b44-0ea9-08da5f12d4fc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 05:46:11.5091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4udRMYgeZF0+RDVm4tEjRId7MD+p9mUKHUAaxVEwsEf8LlGtetuXYfHuW5ZYnYNFg60zmh+4B9IYU58CvOoZdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1263
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05 Jul 17:11, Jakub Kicinski wrote:
>On Mon, 4 Jul 2022 22:44:03 +0200 Vlad Buslov wrote:
>> TC act_police with 'continue' action had been supported by mlx5 matchall
>> classifier offload implementation for some time. However, 'continue' was
>> assumed implicitly and recently got broken in multiple places. Fix it in
>> both TC hardware offload validation code and mlx5 driver.
>
>Saeed, ack or should they go via your tree?
>
>The signals are a little mixed since the tree in the subject is "net"
>which makes sense but there's no ack / sob from Saeed.

Acked, vlad was under pressure to submit this I told him to go ahead and I
will ack on the list.


