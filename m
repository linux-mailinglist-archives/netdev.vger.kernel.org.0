Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2191536454
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 16:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347318AbiE0Ovb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 10:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235087AbiE0Ova (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 10:51:30 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EB9D5B
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 07:51:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JV+e32GN++Nj2HIH2opC0yiFz+STZZBW14RZsIsqY3YwEOE2JnYE5fajkVxAOsM8Dvkd7G7iP9GOayaRe5uovMluo7LKl25dibcp0Onmr9wvgtWX8N7v3hv2NWY1jHvdEUXctdQyFf6Ub7IM01a9W+GkifMOdIkhnrBPQcR7JZdWXkLcUROJVYaBcT2oi0914cLzqwkiszyD55Ib3yP2J91YOF4f6vFNgUd7L6IolR1lGRVAjJYgLJBvaqCQd700eZf4CAaTOiztA+fHcGHqffLxtFNzqh1YwaTI3iHnWhTzV5YFSCjtbavvtjYKWkkN7kwUb4tP3C4iWjq4eylLXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aB43de/t6k4FSmZ8DtQW/s+WQTIJoTjU75and4V12aw=;
 b=c4xavgRr0fdpe6hcIa2qN8RFebBGEkM+oQfR/M1kGNMrOxmcF7LkMBFlG7tN0p7cUdeBUfhq0wgbnox5HWNl/sVlZz03pwtfXoR2mXxTGwkyTeqIbx5EOwXoXu99mn8Qt1tctOavK0u/+J3q9QFRJecqD0KlRdr10cYXxLdxb5lPMdng8wCO64gadacBJoT+glwbStVrrI6kGuJDWLEathd9D0ALRJbwLXWuFQKVLxECmKFxJrWfBhHqfiwzaodaxf/Yq60mxhq6seNjETkzDnphptUe0BiEeqTEP17AsdpQVsY8Rzu5MUO0gTryoP4P8vUUMNh1J1NkJ2rSpgFtlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aB43de/t6k4FSmZ8DtQW/s+WQTIJoTjU75and4V12aw=;
 b=GyYWHai4+0ljxAF897pgrmW0UKcu3LsWX+sOQWJEtsNXLD/T3UQg1f5Qh6YkLda5yMgGEEExwI3bTED6myVQAgCSfjj8Y21bFJAJl0Jqy61tC9fBtKzok2q06vRF3212UqvZ0VoOywk3cTfvD3/lKfrDUg44EVdYSLZk+RCEjoRhfI4qKumTHYBU5yozmXPENUemtkMUHUr0poZVRoo1L86xFUUxaGa51LlkO8eNKB7f+kdMgVW9rul8LDafquj75js4Iz9ZI1+PvxJz/jMyad2tPK1JvtgQQ/e+Ts9Vt3xOd3I6LMWmaZZ381gzlpu/OVm8yVNiyJDy9bNvtpmVwA==
Received: from DM6PR08CA0020.namprd08.prod.outlook.com (2603:10b6:5:80::33) by
 MN2PR12MB3648.namprd12.prod.outlook.com (2603:10b6:208:c1::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.16; Fri, 27 May 2022 14:51:25 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::4e) by DM6PR08CA0020.outlook.office365.com
 (2603:10b6:5:80::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Fri, 27 May 2022 14:51:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5293.13 via Frontend Transport; Fri, 27 May 2022 14:51:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 27 May
 2022 14:51:23 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 27 May
 2022 07:51:21 -0700
References: <cover.1652104101.git.petrm@nvidia.com>
 <5c0de4f4844bd23a3c7035826ec93d6bf71ae666.1652104101.git.petrm@nvidia.com>
 <20220526171313.592cbdb1@hermes.local>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH iproute2-next 09/10] ipstats: Expose bond stats in ipstats
Date:   Fri, 27 May 2022 16:50:12 +0200
In-Reply-To: <20220526171313.592cbdb1@hermes.local>
Message-ID: <87pmjzhvvd.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc8b6279-2fda-44ed-5aec-08da3ff05f2e
X-MS-TrafficTypeDiagnostic: MN2PR12MB3648:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB364814EB6451B0B3184EA971D6D89@MN2PR12MB3648.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Zp+GE6w0yYeikH4v8BfRGDANcrN/RQrpipA3AWsA+f5jMPHiy31aALh1UzsH9aBCCuAVaGLrmXjfDG7sLMP0u+ErEi4n3D5AG1qP8+C/ypfQ7cznZznIbdlrBWrFQ6ZK2gFO7SJTcLI6mXOsUSgchIdoxBsgfEwjrwVjyc8qzLCKKcJ8w8IK+rPkCrQXImRVf+vRLNl87klsKI1+yZuYp9LrgGy7bYh2v0snAYA9SL4FT4f+kXnbWl8cK4TxQhvM/w0GE5jUR/v7vOwSvYS+twtUx3tEpltSldEKb3wnUcEWDN7BBV6SqYXQFLh7hLCbhNOcrvZCX4f/tNf4Jo3wi8aXc9CFx3cy99mLb15eQXQ4kjm+4GxnZl3UFxv/ZhmQC5MHcOzE/NEihsIHg+q91Oz20k9NvAq2U91KOcDErU6A8XpKhpoQ1vFi9HZYrvYEt3CiShbyTe0+ydXlvJ8WQKhMd9zPFOay0QwOzo9Snj+v8iRSP9N+jJgB5gEGSbuAxBXPyrHQW6JuEL2NU/S60+NTJwLsmBS7f/fSq/Ik/6lSKibKMTMnVJqNXgZ+uivJwN8KbnUnqHPZ4/OMglYTG2kTF7E97tu78k//ZHwTxQbQSvsng94It9V5XGhO0bAhV24kwD4U61q+DG+JDzM4rzigqfhcusTMlpOV56cNcED7/LIbSN9M6KXUQ2Kc1GIGU9YdcOBwjHeGaIuw3zfxw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(70586007)(70206006)(316002)(86362001)(107886003)(2616005)(26005)(426003)(336012)(4326008)(8676002)(54906003)(16526019)(47076005)(186003)(81166007)(8936002)(4744005)(2906002)(40460700003)(83380400001)(5660300002)(36756003)(36860700001)(82310400005)(356005)(6666004)(6916009)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2022 14:51:24.6670
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc8b6279-2fda-44ed-5aec-08da3ff05f2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3648
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> This change won't build if clang is used to build iproute2.
> It has valid warning:
>
>     CC       iplink_bond.o
> iplink_bond.c:935:10: error: initializer element is not a compile-time constant
>         .desc = ipstats_stat_desc_bond_tmpl_lacp,
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> iplink_bond.c:957:10: error: initializer element is not a compile-time constant
>         .desc = ipstats_stat_desc_bond_tmpl_lacp,
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 2 errors generated.
>
> Since desc is a structure, you can't just assign an existing data structure
> to the new initializer.  It needs to be a pointer or macro.

Yeah, it has to be a macro. I'll send a patch probably next week.
