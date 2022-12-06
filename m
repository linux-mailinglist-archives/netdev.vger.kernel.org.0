Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825046440F6
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiLFKIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbiLFKHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:07:53 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2087.outbound.protection.outlook.com [40.107.96.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C8F11A36
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:58:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpX/r4wtJDHv2eCYlHsicuS9ZGrdL4JLV+607XEXSKcqSnXzJyT75ntAKQf4p6TOwIrwcIcnYkDpX51AWEGmu0i0ZKRt8TZpnnxREqC/+BrQSENoC4kJNLpyQoyS0rWiIB5KKt/H8mXE0u3qgLAgN0ijNvj9hCCkPFZRzaJ8V5S80KMFRPWQejDq1HAAzTY8SlkXGY8k2XSWfm3ryuVp6VNlT/wyfTZFHOTk4lOWsP7rB5BdX2aiCsStLeMtkOiBofmhCu2YdEw1gHoyZyF7trkXdKuOxPI3G6nXjun2R0oyA8z0sNl6nul+3Sdzl8VQi8MWlzBEZOu8+1sKLMgb7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LikPI4qJ7Br1MN8Tnf7BmohotzDbh1kjQvCKDEv7DNY=;
 b=Iqj2ZhLBMEckCBJ8e8QRr/4GiTcceLDyiQCVRsxtYHF6H3Wcc30yQodQSMjtgo/y2mqTm8RhJmMHT1NJk5AUpcuwiUtLUXWmDDFNZUs3hA3ki3tBPBq3T455wBZ6U0RJ5Q6HjyIs2u+QYCGYtEOe641SnS07Dy2y7GztOSOlcTeoGRZAvtiie2r8lGaLoZO7yRTSnsIpzYXMFUT/LQOG630ywV2QB0dgD70b9W7TuuYNZhfkOtFhk23+WAvCRECvfyzmRxS+8wJt4wNElqf1edikWOlhazx6oxDbYkNsQnhnsS7lLfZpjFWziS5dJfh536e/aE10tAnljDAaa5yXOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LikPI4qJ7Br1MN8Tnf7BmohotzDbh1kjQvCKDEv7DNY=;
 b=tq9BPVBYfDO1DVTsbhh9U2LXUHmt6fD7gSALe9+kjdSDGjmdsTMfeRdwqRyO9Lji3l3KO4oJTe9nMz8+idi/s589CXU/giT4vmXJwXSoSdTpOLFy0y1Ic6K/iO8bYIe1/q6M4LygYi/eOwBR9Ct/Fn1Ev7r44mHLhATawHfowT1VMLR9VzgzE0Rj4iC8H/UjW5KY+/XMlcfZ/9Bguxe66fpFEd5wst+vVTG8JZ153h/GzOPSMK6nL0KoTZQgFDY7JYwqi9RrHica0NT4saV1FAvRyWNmjsL8+3ZsiXbSSZe/2yMO2IY0lLYRMi5CJBb9vBbMOivZmc1wiVhR67aStA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB7234.namprd12.prod.outlook.com (2603:10b6:510:205::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 09:58:17 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 09:58:17 +0000
Date:   Tue, 6 Dec 2022 11:58:09 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 0/8] bridge: mcast: Preparations for EVPN
 extensions
Message-ID: <Y48SMdAuQx5OK7Id@shredder>
References: <20221205074251.4049275-1-idosch@nvidia.com>
 <73405dec-e1ec-e581-ba8e-83bb8343d2b0@blackwall.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73405dec-e1ec-e581-ba8e-83bb8343d2b0@blackwall.org>
X-ClientProxiedBy: VI1P195CA0047.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::36) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB7234:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f53dd49-0bad-4c16-599a-08dad77065fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OwXRT/mQwQV88y1fM1Lm5tk4LvlXwO4XDGOuSYNkw68LwhXNiVJ5TZneg0qxfL/RiclmxCf1DUxqAYDMThhrdn0Z2Qy671ikaZ5aR6pHxOFNxEN7hhMsyHChHpR0s+M0ZovEWdGJWQDny/76I+efpeT7K9cnOvu2SOHmmafibk/gUpCKSPVLPQB+WU47ox6quxl748/0eCSYeFymJ4vc7DkzmmSCI5EC96LJ53PV0Q++b3bpi2oI+Lz5hbehUC5TJg0x19+vxyPMd9lGuWNQLnayCawjCvJ3f5sP+Jx8yVlbyfzn5ibeaE4cHOXECsRtQqTtnlABcvlPMiJiuaG83IYcS0vMyiRnSMV8uCP7n9KOm2y48GhCoA7uNTMV/UMcfrB0PgjajXDrc9jllrzhrevGMbZq5NudipYXLjBX1TZjS6ueJ3hWQVVIz+myzWpMi753uC4UJ0kPmHsr/yJFgiVISCi3vHe8Arx9ubhWNYjKWB/Cdv4d84MKzsd79rmhwwK5amBVrJ+ilS05iBdJ5a7/HI2WZI+LY8DZ3mS+02O/JnNbceyNx6SizkJLp/ZDeNsjMkQHeUQh3NaRj7GqaXsVc+5yXb6Ssm7hCfZz8kRry6K7+V+bvcvVybAKl8vOdCM/YjIjiHzjOTJLRFK36w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(451199015)(66899015)(5660300002)(86362001)(8936002)(2906002)(4326008)(41300700001)(4744005)(6486002)(83380400001)(66476007)(316002)(6916009)(66946007)(66556008)(38100700002)(33716001)(8676002)(6666004)(107886003)(6512007)(6506007)(186003)(26005)(9686003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6s7lKyFbZqMpQYezXWXXvYGAzPC+ZwmmHfYWTSYBVxGW8Si+nK1tXcbJ5d8u?=
 =?us-ascii?Q?GkmERMzM8kve9Zk5zllpa0zhDsnuhQPlxFStvGbluIkZ0j4/ff2UgQJmviGA?=
 =?us-ascii?Q?mDCvkq8F/dxHf1Q4+jCU8w91ECEIb/fz8/JjzX+zzcyw0KtMiDpdxGsgfNVp?=
 =?us-ascii?Q?q93U201kbr1HL2V/o+Rml2k0F9gP4zZRT8paQ8PhRvzjDTiBvh37B9VTjaBe?=
 =?us-ascii?Q?AJI14ZougWJ1befh22aY9nCTzpozxwI0NwL/0RDw+idVIViwKESy1OnORVBJ?=
 =?us-ascii?Q?w6HXuNps92sulmaYLrM0cFFACEeP9iHEt1XSBKfs2ga21lCQ1WtIfEvjYZvl?=
 =?us-ascii?Q?SX31Bnpupc+O8SPUDyEOiDllnx25Zh/wws0lKnDq6A63ButnDIByuwF/5zxk?=
 =?us-ascii?Q?XntW+z9hJFlzU2CQCQ+wsPW/2A1DzabwBTZCvLZXyMbjQYzmXNgwwtM/ZXCL?=
 =?us-ascii?Q?DLSp0I4fl6E3pXmqZw0aYC67kd2dnPsF9GYxzKDOb6fgbL0RxLx9vhBU3teE?=
 =?us-ascii?Q?OgJBmnVLYtfKUYXPhLeDO3Ch3Qfrhy5XIO/bXxacBjkJ8IbVnbl2xE/SWnai?=
 =?us-ascii?Q?lBLjeuwCuVRWGJmhRjKILUHpXZzRm9lcj9IWlEQ5mwyesLmv8xSOw/lrq6N9?=
 =?us-ascii?Q?u1/LoHgIwyWPV08cJNduS1+k/KZFd/C34LEYdhOyiCvc+U4l6ad0LgQuXePo?=
 =?us-ascii?Q?TjGySREqGD8qdOW6mBrIhDsZ3zrfKLy6Qg9bZMClyfBFda2V7Lfz0hFLOAf2?=
 =?us-ascii?Q?pXL6Sle38qh7Q5ZxBx0/hvccNdiG9Q8M5pviriz3h7rWpm+pOtuUFR8p7jne?=
 =?us-ascii?Q?+A5eaDX0fF6RiI37ah/DOfHCuz7x/EFqaAcNJtxcbRbs3klimDhEmrJznt2F?=
 =?us-ascii?Q?HBiyw3Rtr8D/SWBZlxtAiFWCcigUyGmz/q22y2VQe0p/3Lj04y7+4RqT7xJz?=
 =?us-ascii?Q?5bx6YXdBedlKb0xvLoKEYzsUSrrLa4XYd3fKZmJ6rMA6fW1PkkM6HCqY2FZG?=
 =?us-ascii?Q?lRKYJmTXwpLwmvbtQ6nU4fnum5bra3WnIesLvPDboinRWuvZmN1qNfpw+A73?=
 =?us-ascii?Q?CuVSu8k/emKFuSr+us66OuE+yHt/C8kQ6MvBle6W6y2Q1PxrgjPTRPjgzqnA?=
 =?us-ascii?Q?H++igeFVJIWoNO9coAXX/K2TLeF0MoS4VnsjsfEkaV8SNMDtOy8tmBVNEz8Z?=
 =?us-ascii?Q?cbQh2qhD9LZ5fLfcCs7sSvmQuEWHWHhK08HLwo0lWGFexIdeC9aPiN3fbNBl?=
 =?us-ascii?Q?In/s4LIuVBIqDwQkPSoSgutW4TjKp7zc6PdvBprSITs6VR8tJHoRW7bpLoBH?=
 =?us-ascii?Q?eNkxyVt7Sdpp2C6jA39v3ggS21hxvKKPCu2uQ7o1dhywr9EPBdtQoRs+7yqM?=
 =?us-ascii?Q?C73fV9Y2fwr1qDOYJJ3IEQby551wSsrwNTATm4ND/pPz4/lZEjcTcwDyBGyO?=
 =?us-ascii?Q?vABwAjbHJpU+B0iydomoUwAU868zDPmKrvlmwnA3r5tdCz98D0Qye1fJ/m8A?=
 =?us-ascii?Q?DnfkIPFcINHxX25nXuowlt5dOdPd6ZAn7gR7FRQ7/8ViuhGkWjV2o3Bmq0mf?=
 =?us-ascii?Q?CwbkxOlSUAPGlQ0AtG3VVeykcGRzRsJF3g5a3Wvm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f53dd49-0bad-4c16-599a-08dad77065fc
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 09:58:17.4629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4PVZANiD6FZEhzE7Y7Qel+02lXMBhnmT2RC74KcF+uTO96PAlhUoDe8jaudndAlTv2bbzlYlmVw/Rb5jPgwpHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7234
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 01:55:05PM +0200, Nikolay Aleksandrov wrote:
> One thought (not a big deal) but it would've been ideal if we could initialize the config
> struct once when parsing and then pass it around as a const argument. I know that its
> arguments are currently passed to functions that don't expect const, but I *think* it
> could be a small change.

OK, I've made the change. It was quite painful to rebase my next
patchset on top of it, but it's done now :)

As a result of this change, I've appended one small patch to v2 of this
patchset. It is constifying the 'group' argument of
br_multicast_new_port_group(). It is a dependency of the next patchset
which is already close to the limit in terms of size (most patches are
small).

Thanks!
