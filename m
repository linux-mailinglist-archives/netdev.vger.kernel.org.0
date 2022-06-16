Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4397E54E54B
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 16:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbiFPOsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 10:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbiFPOsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 10:48:00 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B6122B16
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 07:47:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzH0D13UAVR9J7LbjkgCFQoB/Jj6CxSliqtfqUTcefOHfD0EoqAJM0Wa4pg96RchF9DfZwX4BH1n5Wil3Wyp5rsAUK/P9UH8aVml/GMeMj/EI0/odEAdr2WPE0k83pwldc17WBJ4PwCoWB6574u0B+BEcWh4nCZCJEl2mzfHbs203F6AQz5R869CxJMAAKVTF/Ad0I2UPATWBAv94y9PHEtqlCD7dDUNHt148OiewlR+sYtUcBY9OC6fxrKPhVWzNgTYg9JZwdb0+ETMBIItnTUPVmIKWuCWvHt6MErDLh8Brw6m6Q6d3E/X8MHjJHRaBrLKom7oM0PV/FVE7VbNqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLH6EJb4maOM0XjZ1zeeHKevymbb/NIqBiomzoAi/+I=;
 b=HJw6UQAeXEDYwnNS7yIxQbITaVYrlo+Y7s8Cuv3vDOPX+ak42MuPgFa/Po9kB+AHIeB34LELXAeNu8ejWEsjyto+cn/15dV0GFoBJ3hpip1DL7nvtNwVEjkOTj4fYzysh/w6Vkxo2DAOXvff+jwIAISXZT+YA6MZL3sB7BSzJw28/f6ETaqX9xX0nm+NsORzbpMG1FSB9pLcV/UkgwcvYH6QnDmAXzdrhPUtU7P7pBYluCG+KnC86XsAheiIVL+57lqryRvbIK8HppLrLrfryadNm3g4scis6zCyMapld0jgPnE7vgrj5/EtQw0JCQYSM7dNaJw1NvUqM0r9I1zhkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLH6EJb4maOM0XjZ1zeeHKevymbb/NIqBiomzoAi/+I=;
 b=SqSxUpgo5MygYBgFMoavNH8YM62dyLNXWSzOaM94kIJw9YMZRHsEnUevU1fX5r1v909mbV/PIz/QeUP1X40RUCEGe0YDkn2QtKBzE29CLLXbHnqK0HVjl1RCymG5bXzmDMUBZULbAW68LzHexRrQN7gjUw4U3WmC4vT9p/A9+rb2DQyQKAufUEgm49KOrLxdn+kzgw1QyVV6f2PqnCUIHv1p2LElvecAOekAJ4rZGELPwQySEV2w/LAntpZoexDqw+RbIoSzSpe3IsYiJe5VSjwG/vNeCXdecX7kTFI3YrRpn5VhfMBKNGwGlYHXlB3M0UDNwe3bXTr6Ng+YVtNUjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB3407.namprd12.prod.outlook.com (2603:10b6:208:c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 14:47:57 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 14:47:56 +0000
Date:   Thu, 16 Jun 2022 17:47:50 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 00/11] mlxsw: Implement dev info and dev flash
 for line cards
Message-ID: <YqtClpfUqQ0m+zVi@shredder>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <Yqmiv2+C1AXa6BY3@shredder>
 <YqoZkqwBPoX5lGrR@nanopsycho>
 <YqrV2LB244XukMAw@shredder>
 <YqssHTDDLsiE8UfH@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqssHTDDLsiE8UfH@nanopsycho>
X-ClientProxiedBy: VI1PR0101CA0066.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::34) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d564699a-5958-4238-145c-08da4fa73370
X-MS-TrafficTypeDiagnostic: MN2PR12MB3407:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB340721C3489DF6E3B1550E64B2AC9@MN2PR12MB3407.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0cLN73VD4xL47VC89hmRUKnwuUShj+Y8P59aChyTolWMiRpu+DkH0KMZdVrcwzM49JkTOVO4AIlWpCQs2wF1f4sHcBMKB5fAok7IOoU2bnFdkZn10/LWaaoDyURJlHIEXva2pfwKtq4dCMiMrlZckxFQEDqONwiXc2p+vxTi5dSCH7FFDHnJIctmshpUD7zi0rAdR6olrL19vaqlgnmuCQ7QmsiUNS5p8KWGL2OaJlOJ8YmCYYchk+i+IUTq3oUT4eg0eUeMQjGUPACx8gKoDSkfG3CRA6qwV7ErZ/swj8WWy39YD6VlEOS89KkqS7t1YWwmgxkwNR+ivIGX4U8KzEdQ8Zwz45bFhIRAXEhRT+DtQd0LDXH3Wuo1X5xNTtrgn/VkmEZYsDx/AF1GK4SwF2t09UphDC5CROfXhuLFhFa3qbTMxzVF5J3es7WSTGzl77qNpBXX6k/DVqn0dW690OCTqFsI1s0I4CAuxRHdq2Jk+uZCwsTQFixP++XzdHl0wuRNxTi258w1XlI0/1ULIiYt7PDGitEG/5uc0Xh5kHDGpsePeeaaZH9zJBijYEtLf5KZKm5Mu91lejthO1EuKjxuCOfQdOP/COhE7bOOqJb2GwVLTBCejJxseUJul1/zVY/PcMtPwkCzzzARq5dmiIOqthc6IPrTKGkIRmI9OBfLRkEoWe/noy+/e1/FviB/noAo7b1K8H5uaa4K5zIc5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(5660300002)(8936002)(33716001)(2906002)(4326008)(83380400001)(6666004)(66556008)(86362001)(38100700002)(508600001)(6486002)(8676002)(66476007)(6916009)(107886003)(186003)(66946007)(19627235002)(316002)(6506007)(6512007)(9686003)(26005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sxmYIUgslezRN5ylzin4oxbPsg92N+9LO4W+WEnsCCCZagNtbBxgFKzizHqD?=
 =?us-ascii?Q?HuMEvs97WqGUH8OJrf3JfWnYLP385B18LBLs+Q7Y3nz9WuTTOnU8goOiODjN?=
 =?us-ascii?Q?nmm/87CS+th/S6Kuwi5tcgX89uDPRvKOA8xgsEopOG3RtAu7zStJLzXARBQc?=
 =?us-ascii?Q?O0Q28P+KoYHxLnH7413leom7IZRFVPhGckoC7EniZjNQzyA9VyAKhCroe+Ra?=
 =?us-ascii?Q?WDTuWCzcpwCTO9Up42wFQuwmpUbr+Qp1apCCLq9RteGanuQ75IqWTKId6K1U?=
 =?us-ascii?Q?3a84j8BwlaUutThcckqIJctqctNDli3/wZ0oJh0vFkrsxz0K820MKmCrpxS9?=
 =?us-ascii?Q?dp33VwJrojPUSp+hlgnTuwYs5ri2Ub3ArCfqO3i0tqm6DCvuNeyDsy/OfSqf?=
 =?us-ascii?Q?yZgIlOOBlcNM6xscLfsEgg8ehY4K4RjWOSqe5b2n7eOgLjHZS7IanvY+9xbE?=
 =?us-ascii?Q?amR9wakptbTsyxKxQz2tO3bzZ5KbEwKy5n1ian9oVFeN931INnWPFn7AL6xW?=
 =?us-ascii?Q?m7raxQrh/MUvpWwyO0jdcaAc4Mqgb2/XTcIWIb+gvegTq0bI6VUdVBcZVVAW?=
 =?us-ascii?Q?9RlQdHwV58lVDT7RIbBYIpQeA/4iAPJ+H0Ie5ABrz61QTvwJqD58XTjg4tDR?=
 =?us-ascii?Q?JGBymt7ufJqjSeEPdEeAeb9D8Qy4sEA/7zoUuTK7ICuNuaNrZ0hbzwMhBCUR?=
 =?us-ascii?Q?cTpG1wrwcRH0EeWBfYi0n3E5oZjl/Te+XnIQIvJCA0CVQk5BFsy8uAV3pPhL?=
 =?us-ascii?Q?unNPTh7lS7MTYK4d4A0SnxbI0Ip/do1zGbvKPftnZiaRoLpkkN3Xq8pnrzaY?=
 =?us-ascii?Q?HN/ER2QtujNBqUuwhZarQcLbU6kL9PdeCx7In4Il0kB2EiuFNVFvZdE3o4q8?=
 =?us-ascii?Q?9kOwUN/Jj8NBG3rW4yi5cyiW4CGaGSYMQAc1rVAnARv3ynl6PDcPQPBe96rl?=
 =?us-ascii?Q?HGrolOYUtFRHynLUG+fnxVLVgSs82HwQbV3vouIkZNk7FoI09tx86RtnJKll?=
 =?us-ascii?Q?Bq3HMlzKQhh2qdJ09NKWv9Bx7L4UXjghHE1qVEd5cWYc8Vl7gnS4U3pZJ/yg?=
 =?us-ascii?Q?ZMhvhoZQrkKMlqxVhBKWXSjDUOr3VSNK/qIleFvtAZyfSfFjmA+d+mx31dHn?=
 =?us-ascii?Q?8OSDz+dWGSRn2n0x5v9h6qwWYZDHjyOkffEF596tgQ9ypLxeO2xet3vFUjcT?=
 =?us-ascii?Q?tcXFlGWl0Ao2rDykvrUh2cY07d0rHbhiDUAkfGIbzNwnI1pBnVfTTFb2mMrn?=
 =?us-ascii?Q?8X5AaR54UKyHWpBcR9WgaqLOPDP0mdRmeyXA1T5M/mzxjoaAVIWhx3HVFM8w?=
 =?us-ascii?Q?NuFqNJAzdWbko+RmvIq+Nq/QaEoIxGd2zyLT1mwBHpO829w81Uo7SmHODtAr?=
 =?us-ascii?Q?E/ctJ2moRdMlYN+Jn6mT21/cJsBDBG+MjQ45r6JyJCx9hqiVCbfqQWB8Xb2y?=
 =?us-ascii?Q?oZU/JxYAWy79HAOV/9UAI2/yDNFbLqj3T7+fVC8vQIcalB4CV807y5IFjk2z?=
 =?us-ascii?Q?KqLRkJcYdRDm+GHX0R8ZNODUJjlbZbyrWVOxKB3WnD+TWNyBOJxB7ZA6dODP?=
 =?us-ascii?Q?QW9AdPCEd3RYcxZzD+/WQw3Rm8wMCxUHZIXd9fB9v6zDI2bkVKulMa33Mk+3?=
 =?us-ascii?Q?Gj6COAG7UiCCEXk5mdUu8QvfElA0PQYmfK8Lid5sI7IiAsvq46TlZccO7yfP?=
 =?us-ascii?Q?ONyoOeRWQjH8O7WHueaSihlZ/So+SQMa/IS1N+06qvrpnuK21Nu9HMdGxagj?=
 =?us-ascii?Q?I+K0kHYiCw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d564699a-5958-4238-145c-08da4fa73370
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 14:47:56.8868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6qpVwNGL6p09i3FpxEDVeHNp37FtDMwHMyBQqZbGv9o6XhF2V+A+zpGoCvZTOvD4Uz/fRSG64HoA9nYPADbwXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3407
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 03:11:57PM +0200, Jiri Pirko wrote:
> Thu, Jun 16, 2022 at 09:03:52AM CEST, idosch@nvidia.com wrote:
> >On Wed, Jun 15, 2022 at 07:40:34PM +0200, Jiri Pirko wrote:
> >> Wed, Jun 15, 2022 at 11:13:35AM CEST, idosch@nvidia.com wrote:
> >> >On Tue, Jun 14, 2022 at 02:33:15PM +0200, Jiri Pirko wrote:
> >> >> $ devlink dev flash auxiliary/mlxsw_core.lc.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
> >> >
> >> >How is this firmware activated? It is usually done after reload, but I
> >> >don't see reload implementation for the line card devlink instance.
> >> 
> >> Currently, only devlink dev reload of the whole mlxsw instance or
> >> unprovision/provision of a line card.
> >
> >OK, please at least mention it in the commit message that adds flashing
> >support.
> >
> >What about implementing reload support as unprovision/provision?
> 
> Yes, that can be done eventually. I was thinking about that as well.

This patch should come before the one that adds flashing. Then both the
primary and nested devlink instances maintain the same semantics with
regards to firmware flashing / activation.
