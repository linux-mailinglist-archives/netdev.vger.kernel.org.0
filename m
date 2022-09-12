Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE75E5B55D7
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 10:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiILIVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 04:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiILIVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 04:21:22 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960802A970;
        Mon, 12 Sep 2022 01:21:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8cOkrL+cviKDIlXcev4iX6QMB/s/+EmVnnzAoquseHTGY1M/Zri3zCAG36HeLemHE/V5gMWifbP1Nwb2fhmWDiz6tf4cpXO9+9AvzpiaaZsPwjhO5C4A7HXpE1i9ks1Fu2hgdGJQ3Yn27qSEGu+lV7V8tVIUMUZNaO1KUQw7JngoQtk3pCsASgSIr7SyeXTpgTie64TEBg3Ay8r1mvfeIFDTgzQoKIjF25GCVh6hJPMmdwsZP0AVQ0V5Kox0JS9mNV8fXbcumYZTFsvXG09WmH6sSOPF4a2wLabaQ+qpqZe57LHkg7eOB/Ds5wGGTA95qePfdsP+kDYfeQmsUqBZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YsEeRRwJRxP+nwGYkWMJWutMfHNgakAojyFTcKasUfg=;
 b=aDmbz5MjA2qIDPQByMFfJrKgWJdaJNd94hXTkB04vx3eciEVVKxr6dIAJ44Aoc/h5QAqKhXrr3kaOoPb/O3A6DZxMqH0R8WjX8cpRekBXxmfCTHkOkKzLsI6yLHSWgoUdqYxIEcdRs2jyuaECFxhCETWLrZxU4GQfN1syVRsfuanIZYGqk/mVdr+nkVAoJ0H7hu7m9Dj2R5clbmmYANeoCo46Ly8/pZJ8OTT3/qC8S89IcWpds8iMXd2PWXcN8b+8NxQRfoY7J8hnogPnjg1SimmQOpHDxQ1ao8gcs51mySl/SixsYgiMrojB82OeHBogtYL5kD8SV7iwmTosbMRcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YsEeRRwJRxP+nwGYkWMJWutMfHNgakAojyFTcKasUfg=;
 b=kMwpTdnYoeqNXH0admSyv8xpocvi4p82TIqB0/AwY1HtYPrrd1Kssi9DbCxKYFfJpOBqRRAry62g7uuammflIAjMit/MY7eNUtQfxrm8cVoEZcBSQcgalbA5iidSTkPadLqzeNSVtHU8X/RwMNBcICYM91Szdp/EVXjbKXY/W34OAw1dzJHlLSYF9d5N2GC+4LExWTQYMvx2L7RO77GIQAJYuHNvHXue2qSV6SWtbMKQDyIoHcWaENM0WclDvdNI+WzWQg77VpTSEo9dud/Qry22YoCX+yHoaQYkbPmzlD9ViZOlGytQGkMky81i9iSaqJ2zs41C/rqSwhcer8wouQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5820.namprd12.prod.outlook.com (2603:10b6:8:64::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Mon, 12 Sep 2022 08:21:19 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::18a5:7a35:3bb2:929b]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::18a5:7a35:3bb2:929b%3]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 08:21:19 +0000
Date:   Mon, 12 Sep 2022 11:21:14 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     cgel.zte@gmail.com
Cc:     petrm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Panda <xu.panda@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] mlxsw: core: remove the unneeded result
 variable
Message-ID: <Yx7r+ob2PTlbQQc9@shredder>
References: <20220912072933.16994-1-xu.panda@zte.com.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912072933.16994-1-xu.panda@zte.com.cn>
X-ClientProxiedBy: LO2P265CA0369.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: 590f8737-cb7b-4db1-b616-08da9497c503
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A6E5MSAAa8CbXNclxc7y7BuMmONzD+ndR/Dr87MYYoAG52I8yU+lTg7Qd6pmYLbzzwj6vO3RMee1otX6l0oH993an6KhTtQOPYzHe+x3cxpEe8gooLdAGQqVN8bRvsfc4uuNEyumNd59+JbAn7KmgZcs4ur+HvxmJkcxhkH+PqhOX9A2mmmrgy7qvGDcOgd5MLABhem1IH1rKYaoAvFu8vkDrhv6HQwA4FSKzQrnBKcTKi4x4PZr41BUzTABi80teBeLOPsxvu1CRjSdF0IWU6OC+ukvVK/HYc/4fp/2FY/Cxtsur+KDIWdpo0SeZ2Q44STP1Sptk6ZrHBSek6SwyGb40XauCfJXaSNa3+9ywc3Eyp29nmxOiudXrQZWtv+5N1YzdHRXZevZRbYaB8z3H2Sj2Dfc7qPPKOfXxbBpSm9o7hCTvmVeqHunEEGJmLVgAGEOgBbWywMfGH4chqOixfOfVdjSCbVASLrbuzJR3Y1nwMJWU37/Ru4zW2W5h1IxkEL9DLuinTW6y9f/gGhsknaqAN/BChqi+EF8lyZSQB8vvj3WYngnxCEpADaCj4JpnU8yb5YNZFgzb3jNyveipcz6kPO57yNgWGF9ScwtWWnwvcKE397hsQ3/tJApN2tef+h8qN7MmFLx1JnhNVQWDbIlfl6kr8cbvzfMZM3rtcVb4vg0lMrBtsqKdXNNlWyOcSgKQCUqe0/iQmK7NMzZlBujYd25h32S+QwGJ8BEKlLPEHGMM3R/tBWh3wpwgmTujil/hei1teZeQRm7F0HjGy/vnB4VZzntiQm2qXgJ9nuVK2odQK8orQS71BpxjyPBGTJz6gSsVTVnI4WlaQTG6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(26005)(6506007)(9686003)(6512007)(478600001)(966005)(6486002)(41300700001)(6666004)(186003)(38100700002)(66946007)(66556008)(66476007)(316002)(8676002)(6916009)(54906003)(4744005)(4326008)(33716001)(2906002)(5660300002)(86362001)(8936002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S/E0zF3b+01KpLmXUGpe8dM6eLEJ8RMvjqID/HZpRdIEkS8SnVMMwG6iGfsf?=
 =?us-ascii?Q?VUM4amZk3/b4bxMRcm7GasjU7qqQjr4FBBV4ZeDfW9WlhRH42xWJ0rhAMQYO?=
 =?us-ascii?Q?0ztonGt4fJpp5kf22NTTaRlZPW7NsacfCi8373YC2ASQK0NP1XLYsH27z08Z?=
 =?us-ascii?Q?o2lKlmLmS/VvXLMXUUbKsW7uRiKJ4PBsDsHh3VStFgPJVvJWVZY0M1BwWwu2?=
 =?us-ascii?Q?3+AVigXS/EWIJJAQtBn9HMiGO+f4bBiK3/IhniU6V3QfoYm9yQaYVIZC2M0y?=
 =?us-ascii?Q?mtIPMO1WCU878MRG9+5nIHgYaTNEZ8neJDqXFvrcG40pzHSHcIBnLjmsGGIL?=
 =?us-ascii?Q?OpItJ9o1jEHGWU2VJHhe+lhRsutszV1ROc8Xayw1sqXRBztgFTHf8wVfTvQm?=
 =?us-ascii?Q?VlmTkQb5S1rzMxJOvV8z4CSJWfWtWSq0y9JT0CFO1uWjeFg4pfa+OoidPgZO?=
 =?us-ascii?Q?hF5p7s9C2ZLjtMqXMcPY/5bEa54f+rWroZSCKliWGEPThKyYOeN1UA3Ic1pn?=
 =?us-ascii?Q?Ikqd0I6X5h77Abm1pnmM4CeeIpO7JFUNdYa6zbz6CgSHwErsVscqEY3vPT01?=
 =?us-ascii?Q?yxYeXtDDkqlUU/TqoNDBeqUG2U3HmLb7VCryQ9yEh9k5uc+A8oyxqPkqcX7Y?=
 =?us-ascii?Q?Y/HAaYMw1zXFVTzAsc21xx2A9YQQcl/wus9uztO2E4+QCD6qB1/l5BiHamer?=
 =?us-ascii?Q?hc410J5RX/DBttKBF58GR4PznCZqQ9vPB6Dmp1w5DB8RRDL4KD56EcYiHw16?=
 =?us-ascii?Q?bIHQq6qBPF188S/AT4eQ3TczTqUfZPtURcijnY0e5RHJTaQlNUdMflHRf20E?=
 =?us-ascii?Q?f2BOBEPImt0mU5/q4GW71Wz/Ou8W8+iggfTIT210XQhjFEDkL9CStetE944X?=
 =?us-ascii?Q?XY5ge31Aj+7XTAmzdIcKwWXetTjxEa8JSb+pTM6FNX5XyNTpUtfdZGFscV9k?=
 =?us-ascii?Q?Wo6JjV2itobLYZKchzyl7kyWfsdSgblvlOuJ1Wr0eJDpwpALF9jcFA0noE05?=
 =?us-ascii?Q?iY7rWpsN7VlDESb32f5tRdc9x1JKOyGDShZf6zEibeRNyuBTeny44zghevSC?=
 =?us-ascii?Q?4EpW7p7edb7rz/e/MT3zKaUpoVZE1jodal5PSKHjd8QcXp4RJbyoFb/II+Am?=
 =?us-ascii?Q?dIVKp06HgJBkajvSuxdoUeHmgsu5oj8yZ3vEiwbqUqFYkcYhanC616sNdw7M?=
 =?us-ascii?Q?V2CGCMyQd8sQUkDkmrN7rEMRXhydKxRxuQSU3x5c7Lq+pMaEsBLYX4Ws9iqe?=
 =?us-ascii?Q?Jouq882PRySAwlC08EHOuWsXzUW0MEDcr8IDoZNEZV5QnA4Z4xi/1f4PtUwx?=
 =?us-ascii?Q?x9oJC8qkQM/uUAKpJ3fBPbziS7Y032XpodJHd1b9egS7H6x0V9NoNXLBHGog?=
 =?us-ascii?Q?Xa/0zvFyLxjS1rnqE2BLgurBg5jaEGAqD00bDFQLQeH4NJBHoIvYSQTkyrhF?=
 =?us-ascii?Q?HpUX0CIe0Q79KsdFLV3yI1GjhOxqy6HA76GspePJBfnkzMf77bXnFPjBUyWE?=
 =?us-ascii?Q?5N88UIOsI+hGJidTqb6xrHqTo/D+yklKhpg3+L+y4qc0k9Pm8YVuSs+4tRcg?=
 =?us-ascii?Q?hVXvOqylT/CL90sY94fiF7lUv9nkRErZjf/Qz2Ui?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 590f8737-cb7b-4db1-b616-08da9497c503
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 08:21:19.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: km1J41Q2kvHJ3b5JYHhoZbsaqpbbh38MeqIIDEYqpX75dNQghUpWKZHLY6dw+OGeL0vgcY3Y1rEqiFlGuI4/3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5820
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 07:29:34AM +0000, cgel.zte@gmail.com wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> Return the value mlxsw_core_bus_device_register() directly instead of
> storing it in another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>

For net-next:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Please use "PATCH net-next" prefix for such patches:
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#how-do-i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in
