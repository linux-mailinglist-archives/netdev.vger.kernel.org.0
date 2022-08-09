Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A51E58DA4E
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 16:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243821AbiHIO1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 10:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243764AbiHIO1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 10:27:18 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B0B11C06
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 07:27:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATxbGyDjrETdL5SheiuaZbXyBWpQ98jd+053eL4PPQoe9qrzBa4JSnGR/CkgspUM1hv6jZVMeHPsVV1hvqzEP6ewmyX9WQKoreTCTs3xpwea757P/K9IBRL26TQ3trlb6Ei9qNX3wXpLO/XtWhf+5ekzK+P1ipwo92jcZoOs2/6WoCTnY8CicecAovcDijvsVQOdmXaeKQEd3sgijrAEQBqdfXZTYjxIhSfFCc/tyYG45lLgyWnkjj3r7Edz0ByGYfCI5zQCnQsyn6Tfy7H/OyMjJois5pVkm8uEby4MdQfRCxpvUAhi4TlO4SfvZnw/8ZV41/7UfdUyUqUpqRIyzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sv+x0jlYqqLYOWyG/8mObtw7C1TIl2hheD9kE1DfA1Q=;
 b=ArBBW2RfNwYH9/HUIUM66BygQ9ZM2GLLg6fYKyYLwMZOhe7qMwzUlEYx5G0r479Mq1LoG9svG+5JdV+LzVKtmr5LmwjcF3oFT3o3KRVNPBPaBgnHqgq22nViodYo/akxeCV2Ri+NneNKSvrzBrVjbqeCkplPXkb5GN3VJLyKOmfkvuIfzFe0qSOqG1Y9yTBgO6spOlHwZj0QT6YvWlEeGCuXa+ugOL+mq7YsT2Fn/FKFRdS1rX+RCG37UFCqPeDVbsC7JtduHy1vmYOwT1QguopvEsMDQG22jTk2xcaFzoJvTqWmSOKxySxAm+zCCn6Xj+2+yaQmJLosGxC1YETfaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sv+x0jlYqqLYOWyG/8mObtw7C1TIl2hheD9kE1DfA1Q=;
 b=KBIyLeujFVLc4gT3YMPDds1mDcqEusu1V1kLQjyu+KuIoqTtwAAUYEbWOrQ8Vo6MnkOZ4ZYvvFFEUmfTyKJoSaeZLEK/esD5/d4OqUhHYxGeYrwF7ls/XrlZ1tkbSitnO1euxjilVL3B+Dl5N7huwjprWaoE/ho1deA5N5Uz65CgKAtZUMh0RfioBiuzAGi4Qyhw4TUMIFj3ll3H1P9AEfyd23chznLQwMtCW7F2qkpQA/L9e6YVXC70rH3jH8T49ocvnzMtxq3OvwgCxckCDJwtd5kCQ3+y050kVcfAPR0mX98p6JVtYmQPk0XiTszQBhukIb9Zy+k2CWdJFD3I0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by MN2PR12MB3870.namprd12.prod.outlook.com (2603:10b6:208:166::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Tue, 9 Aug
 2022 14:27:11 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5504.014; Tue, 9 Aug 2022
 14:27:11 +0000
Date:   Tue, 9 Aug 2022 17:27:05 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, amcohen@nvidia.com,
        dsahern@gmail.com, ivecera@redhat.com, mlxsw@nvidia.com
Subject: Re: [PATCH net] selftests: forwarding: Fix failing tests with old
 libnet
Message-ID: <YvJuuTnEaSng3y4Y@shredder>
References: <20220809113320.751413-1-idosch@nvidia.com>
 <YvJcql9M0CHJ6qGP@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvJcql9M0CHJ6qGP@nanopsycho>
X-ClientProxiedBy: VI1PR0901CA0105.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::31) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4140e375-a337-4c21-eac7-08da7a133f3b
X-MS-TrafficTypeDiagnostic: MN2PR12MB3870:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L03FPLU0gQxn61aJ9FJexjFa+KVrnGLsJMb7INXBzKQTKxDC/DfRriS2+B6iYh2CGPbSqlr5XBaC6I85wes9SpAHYY/V61WnTNPHtb+3mRmXUl3ACstJHPcGkVgwW3yL0pY8zIA99yP6OZt62Fio2wBV64Ta58jiqsB4uB3lCwNGMiVjQHcvdtlTCWEeHqaw4q0ESqXyvOhbtsPINgFSXQZfua+GS+W+9OtlQksUcY7tOxONZMigwz34wKiwGNVwzCz2fqnV3iDFYHy+8w68YmOgND0YQRwxg/eypFz5Y9TSCJQo5uQCUeX3k10IG16MFdHKNtKcHU8iRUyH+S1yh1/UTgZom7onLMcUesNlgFTtvliVeDAKvZ/R3SSZyEZPhmJHCVdo7v85oikoTvvoF+h3jwUP/8za4BbjiRQWpfX4MeX8hWEE2ViXQqX4U6ExK28MiL2MkihFucmh7rQYXvSFzTM0JcHt6zvBSsOQE8GCEQGc1lLuINSbHG6Fik/zghAOIh4CmFzNea5EcSXemBgDTZKvQN54viZ8C84/f5PFQFK5ugh0/yaVZht3aFu5Z5oTa0RM0+yMXlNGztVIhiFSYc8vvyNAb2IPL5p6O48QNWK9H7NOQ/8CjJ3Bq+SEQkMpjvFmOgwAEjcmhD9YNox5bvq7q7IoiufNO9tfVXPEjKbWP0lvKFsA6rF/bS7fAnQTJdYnBcC56R18FeVBe6gB0lG9EXSF6AXK4J6hba3XlOqUeSfzp8RgMXiqUG6s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(366004)(396003)(376002)(39860400002)(136003)(26005)(86362001)(6512007)(9686003)(6506007)(6666004)(66946007)(38100700002)(66556008)(186003)(107886003)(41300700001)(4326008)(8676002)(66476007)(4744005)(2906002)(5660300002)(8936002)(6862004)(33716001)(6636002)(6486002)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NzkXRBbpr3ldunhnHh+5/tYWeYWdhXUbmms/O5OUbtuAQ7BauY/4l2dVhnlD?=
 =?us-ascii?Q?Tq26Mb7a+vsd2510g7lvEAqIv3s0LT53KWSSF+JB2QfW6wTmposSSjKJbFl6?=
 =?us-ascii?Q?IYWFIw7djK+rPnAZlVWHCvs+R44z0KSXnv25hukIOwR/U3PgmSc0eygkBQEt?=
 =?us-ascii?Q?itQsM1dGppWTo9ufse1LgVnoUQu+qAsnVMAhh/a2pX99hsI1fJffLWa+DBfe?=
 =?us-ascii?Q?+w8cBII7DlL9I2LJ+pqNqhBqlBWYZM+xPQUIpegHZBhmdhn89R4E/hT188cL?=
 =?us-ascii?Q?cg7DVimoAxzSmyAKRlLvYAVpqHdChOHtBhGphA9N894OtElGWShnCkkun4tl?=
 =?us-ascii?Q?LniDHIPopJ0ZBnaIkRvjVqL5IUZoZVbxfV/2ub+GDSPg0FKxXkyf0eMLsuuo?=
 =?us-ascii?Q?cMZas4eb1e3WWHOhHGyioN1PZZJc7Nxz2JNAcvXpg2xgboZUQFc3p/MFBTg4?=
 =?us-ascii?Q?ewXX/Fhaa0pa7mtiIkMcZnnE/M9IsEO848YmkDulTRgH36VtPyP417wdjuc4?=
 =?us-ascii?Q?627laF0/l7tqppnaeXsrppNlBPVwnn36rPITpI7wksVUid47h1on4V542GCM?=
 =?us-ascii?Q?XrF77MmRV0MGVOkFwVp+iUxvsPbQV3PZUo1oXR8SfJvwjgGCoBZJYj1csEdz?=
 =?us-ascii?Q?bvtpqcLjTZqVqTg/Ef3YbRdMvcbSMcBEu2/4+57v2gKTZboVeHui1rq1gp6R?=
 =?us-ascii?Q?uP6+XSOcLYhHQBNhitBWbKG/kVm6MAFBM/6qFOwXgF2VHDYl1udHqlRZ2pDr?=
 =?us-ascii?Q?mvutztkQddh/bcGaRb4dB2SsTsWk6hfxjgJOGVed3eVXaVXXeN8onv2zJdjG?=
 =?us-ascii?Q?QSp46bi1QyTGAg99/eHbj2jMRBNJAn63Xn9mEkDzvIoGaLV3+rgwdKCote4Q?=
 =?us-ascii?Q?aHdUqKSX6os0NrkLdZvQ677arM7SlDEBBbO87LZI8P/JPGFCCNckVk+p5H8U?=
 =?us-ascii?Q?PU+i1qi9AN/yZmAnecWQTIdK2YlfVqW5sQ3ZXEku+eiLgOlbX2g6W9dhNl/p?=
 =?us-ascii?Q?UPrrWT8Z4HozlfOMmYUJ0rUsM93EbLFtB2uLbIjUHjWir1yNoEC+HU7Vhyz7?=
 =?us-ascii?Q?cYXpyBothHPQHavT2ufP0/lYdxKIajs573PI1xZiop3fwQyUgSe8U/3m86CF?=
 =?us-ascii?Q?0JJatB/AJRl9uPoHBkEM/JYGCeFreiSaFfMdmjksshbMYtkWXfQh0KbRI8oB?=
 =?us-ascii?Q?Z6K+BvWl5bWFyLUxpYxVTZwsB1iuY5LQtKOGzhoeaOSn1LHvuskIS/HdP0yV?=
 =?us-ascii?Q?M+xjzhuAG3A7ee6IPeNguDL6MZpxMVRwTZMYb25QW7rk7K0bZgbTbI8b93Dw?=
 =?us-ascii?Q?6HXo3vTUjNDFW257awOzlPXl9apk2HIeTtQzknG7Ivj73UWl8KCoptA51LVk?=
 =?us-ascii?Q?hjS4uk9i+ghnn7BSCsKZnscnK3V28jvUqN+t9WzLRIjwNrfaqshRMMwY8+X6?=
 =?us-ascii?Q?e3J/avj5WIOBXjTZewkCNABdkLsjKjqRfYM4P+JR+Xn/vXDb3SsfxPbAiO62?=
 =?us-ascii?Q?5sCSJeVbh+vp68mGWMjNGfzgicxsc1VyQFz54HmHy47ziUB+2OZdHkbVzIn4?=
 =?us-ascii?Q?uoyXuYdlbGqrpjgaZ3o85TlM1vWbvM2i59iU6UcK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4140e375-a337-4c21-eac7-08da7a133f3b
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 14:27:11.1298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AyzWddkBdyeuj9p9nuq0U152b4YRjWmI/3IaGo6Y7C9u9WsusIDvsG4cDTtxpQBdGqmup3CLAkoKES9nIYtGJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3870
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 09, 2022 at 03:10:02PM +0200, Jiri Pirko wrote:
> Not directly related to this, but I was wondering, if it would be
> possible to use $IP and allow user to replace the system-wide "ip" for
> testing purposes...

When testing iproute2 patches (mine or from the ML) I usually do:

export PATH=/home/idosch/code/iproute2/ip/:/home/idosch/code/iproute2/devlink/:/home/idosch/code/iproute2/bridge:$PATH

As part of regression we just compile and install iproute2 from git
