Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFEA539316
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 16:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343829AbiEaOXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 10:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbiEaOXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 10:23:38 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BDD7C174;
        Tue, 31 May 2022 07:23:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJxuvKNN3sOMdpsLkGCw3fHnWXVA1WhESuf2Sutejk2YUa3rdFmaDC/r0r0kiBWUPU/ihCkhdqcPWvPAspJlXAindDbFOmy88vHeCddQ/wyEOQRrMJXMnPuGW8yBAy1eRoKYIUogF3PuDKT35GDhIgYpug3kD8UYMs0i0zsts9rtoPe8bGvxgHxtHpsY7GHcM/k/Q+slFTkk0Hiy7b04m3cmBSbuh4x/oYzPukI61af16IkvrwlhJ7zZn7z2VQaL+fDkytEYehU+4yBNiYMJ3SpTxvxC4VKfWPAutrooahb7eY2xhC0ogeAx8cr/ClHfSc5y+w53G3OBXYuMWZ094w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9gTRopLeEIwgJuGbroSNJ5D82pl7EhcG5yOOG7c2b0=;
 b=AbCNVLNX+HpNjt9HitvTSfaXFmwduZgkefYc1PjzgrYmsjW3J86iiJJJOjHxkGStH5YymLt+U7Fa45dKiVbhH5cwCyvLT17vbbwgblremrueeK9urcx2fjw7QXiFuokBAB/y65vAATnm63oNifj8EktOsGt0yz2Ab3pX8TapmAfrgn18d3Y/DgVEueLDm/4Nte8OxP82QCMHNK9xHooWjZpRjOYdicRBHWk9bPbjXjEZVlcsvfa4p3t+vDX8CW5E0fKZBJS5Tus1vFmvgXr4xMCJkib4ip/v2Qh+wsDnAbmoFzl7MacgetlqOoGBLiVkPxnMQRHpS9oim/dti+zrWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9gTRopLeEIwgJuGbroSNJ5D82pl7EhcG5yOOG7c2b0=;
 b=Tj3aU1fdb/SIlnMH5WNPTYYJI384Qnn5QKALrejU8AUsXkaEn0cdpyA0Yko5ia+WVpJjpm3CfxHawAxsf5NtBFrcrlboYchvJSYJtOqKRJLh3j1dMWtaKqkqXcLWXwoa0g3CsI6hFiJiTSsdr3YqL+skV84vk68WejLYIrKsbJr6yoMo6uE45qixj1VV3zG6q8Tj4pnbwwEYN7N9oE9MD7kirKutIc1jIDXETEQmhRVc2iiO+WhjyEwhgG+MygE+24QMl7k5gf3yMH7bROyTvnkWXX4eV5SANB8HLZYz6Szd9MPZIgVet87HSiHIVCHSavf317+ri+ooUE6z/4phnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN6PR12MB4735.namprd12.prod.outlook.com (2603:10b6:805:e5::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.17; Tue, 31 May
 2022 14:23:35 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099%2]) with mapi id 15.20.5314.012; Tue, 31 May 2022
 14:23:35 +0000
Date:   Tue, 31 May 2022 17:23:28 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Message-ID: <YpYk4EIeH6sdRl+1@shredder>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <Yo+LAj1vnjq0p36q@shredder>
 <86sfov2w8k.fsf@gmail.com>
 <YpCgxtJf9Qe7fTFd@shredder>
 <86sfoqgi5e.fsf@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86sfoqgi5e.fsf@gmail.com>
X-ClientProxiedBy: VI1P195CA0019.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4175dd8f-8fb2-4b30-ba0e-08da431125bd
X-MS-TrafficTypeDiagnostic: SN6PR12MB4735:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB47353876B33E2B81D44E2C7AB2DC9@SN6PR12MB4735.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SP8ZReIiZ/C5qygXRriQTGK2FeK2BEZmzsLjcgSj7r9ozKkAtjPY8jqj8VIub1A3hUzjnzVR4QELjoLhu4rc4nVOpCutP9Wv9rq1C8KWQBjTmCqvZhciQVISCo5aukQyRRvYi5/VVEqfxepRPin2Jkwom8IKEi5gCl/A6WopYU8w3S/g32bsOVXx8UZblhjhYhp13Nc0zW6iixjZ8uwvYgjKRIZw8FJ5gv+w6HDIYxcTg8znyi5eg73uLuU+CgGRtO9HUb0hQMd/RJnJV7kZlOUKHW2Ph3RfgtD45vZaiJTgJGCeuFRyrUw/eoezH1PtB1sO6wHIMP3Rp7zaKHFk4+BPQ9y2R/aY0xKelMK+YO36Vig5vd51ox9zRAsTAFBxno/p9JAZplaK5ZwmwHQdE4ndLJV4Yu82Y6kvcgHFbJWO89NkkhpCTUDZNGMxQ3MLtKWt+AYCsxReiLGYm6PTuvox2bA98nwAuLiXWg+k1OFuZet5qI5HOexSEG+qBeSTrvuQCNQSLvbWE7J7b17eOPViKa6wBrhNS2laZji8iyyCqsqMCqDW3rWifOSxCyPycn1vw0UiMd0xHe0KWn0JAYrO6v56Enp36Y+SnZx85ILmWJsl8r95tUyRp/CrvfNXv+4IOiNi3GV7bwsO16STdKvJ/z1V4bdUlzRsJpGXsoLntWgB86eAk66LQgs7SLTIu+2E0Ur9EzNpNeW4BxFdXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6666004)(6916009)(83380400001)(54906003)(38100700002)(508600001)(6506007)(8936002)(33716001)(5660300002)(66476007)(66556008)(86362001)(6486002)(26005)(7416002)(186003)(66946007)(8676002)(6512007)(9686003)(4326008)(2906002)(316002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8RtH7HT2/xkwWo5tAySTyizzOEfC5XbUG0MQOcH1bGqPqC1CPwrpOVg9DlUT?=
 =?us-ascii?Q?MMtZubLyrH9kGN1ttknW/kwp98EWVCg1N1ug6dJPEMRzvgn8UFSr8Vo/5HdJ?=
 =?us-ascii?Q?BQszI018T1epYNc5QrdBB0/n1iaVgq1M+wI3aCKZISDDyWvGLeWo1UrJObBS?=
 =?us-ascii?Q?wpM4G4AGlt6W1Sr6yNc9kWYWaKIVbcwMOqiUQ93jWwY8i4TuzkDeOgDHj9Ms?=
 =?us-ascii?Q?1KMICnEEGFdbEK3kdkzPhU6Fi4A2YS2EIe7l9xsycXqpkGRT32d3mmKBbJcb?=
 =?us-ascii?Q?YKVXdh8rfv4rMBuqAbZ1G0/FsPAoyOC64qZ5UHbn1NFVvCeMZA744bHQQI0C?=
 =?us-ascii?Q?O05TUzf3FsoEbSbC5oemCsPrUcwUC9mXjSis1xxQ+D+IHYbUl81sV+EOr7mG?=
 =?us-ascii?Q?jCXxbm+5/j0rD+WEKWJdpQIkW3ldAjo3EcH41iBGktSHxFQv/Eb/TzQ3IlR/?=
 =?us-ascii?Q?gPgr/e4ITmI0AsSfm1I2TcVErUslJ5uotecC9/T13eyv8/OKdrMvM+WodiHj?=
 =?us-ascii?Q?4yTACLyC8zz1qXoglrecoNJECUDOS5yQ7q2thTYjPzc+xqm0zbv5BFNf4SYO?=
 =?us-ascii?Q?xRcryZymujP1RgziKvlphC97TxckY1tYUr15jtLcpJjmbhwZKSKizEfFJmTP?=
 =?us-ascii?Q?mU82LR8Bq8q6sGtOj1hLmHhOwkRoXHRhLIsZrQYjkvCxT/WUzlRyjjXvBtEE?=
 =?us-ascii?Q?jjozMADYzkwyTyOliPMbmkaN3YrqZDOlRNomIhAVYCmEhcckOuVMIOkzq8rW?=
 =?us-ascii?Q?SwI7QWJY7eyhs2rnWz1Qgc6MGHv72XUiVGFGwbOmMQ2wypxuxqBaHeuIPg5b?=
 =?us-ascii?Q?jWYik3tqOIoNjpt8usT908rvl+H7nu3NFnnZKrDHura0hcX5o7Xopbcs5e8M?=
 =?us-ascii?Q?I0shgXa0ZuPLNAWyt4TuCMYU7JKa4FVGYYUXaGp0BblM1RtFeyYAmrP3Sdr0?=
 =?us-ascii?Q?X/+tQblNCUPvzY3AFPhHZUQ104DpI3gHvOpXSbk81+Ok/YUhDcu8giSJ0aP1?=
 =?us-ascii?Q?mJR3VPCTZJEXqGZ7VQWtZ4e1gBSZboPspzrSmIP1pAtPhraJAsZr7qoOt0uq?=
 =?us-ascii?Q?QqhEDjJGUJIhqBFMt99kqyh1ow1wLzxIXqPcx11MXb7ot7WUTmVvp1hsRDuw?=
 =?us-ascii?Q?q0Zvbv3lzNRGftHeZBzDliqw7yxZ6rrlsw5uEFtnHspdGB5XkKVTGCagtZHF?=
 =?us-ascii?Q?SN3XK3Emi4e2B3innDw3Lhjyo2o/l8hk+wW8bErbimPCgDRQBpqML7yZRlPa?=
 =?us-ascii?Q?1WakZpLQZ53sa9LRdGSFThe8SOYt0bwVVd1sERZf/kN51MyyqqfkGEhfOSJh?=
 =?us-ascii?Q?Os1bJjoIX/+7HvR5JXu/8KSL1S1ml0QEF9XSOnYym7H7Txw/oJvYqA762/HO?=
 =?us-ascii?Q?1+e/ptlTqpSAS0DdJvHMl2xduBQuUw9NTai7/nzKD86jPJ5kO6CTS/bckeB7?=
 =?us-ascii?Q?Dv7MCXAKzCjPSkTP4qFikF0a00XRjuAivhE8aaE3Sqn5W+fRRsIfLoZXWRFF?=
 =?us-ascii?Q?qGRWYsGaofk/BzITT4v4F8T5KG3ZXo5YPKcotJfll/asCdlSlVU2L35uNa4H?=
 =?us-ascii?Q?3rSuEK/8gZSN6xdSKWBlkAMTp204VB7UV2DCc1mZBi8mppZy0kxeF+jJhX4Y?=
 =?us-ascii?Q?t5RZGi5iJpbJ/56Ru325glE1XZrMj1OYHjnLnz1T5rbzulwdzDC2P/NI4pfZ?=
 =?us-ascii?Q?1QhQ/SY2pqNGu/QbEqpGtJGerjPYCSpIx28khMjJMYv842kOPQRtmI4+IZKv?=
 =?us-ascii?Q?MhEd3XhTDw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4175dd8f-8fb2-4b30-ba0e-08da431125bd
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 14:23:35.7729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CYXphHZx9mUGnkQt7dmKpHSZJ+EJIthXeyGXRMFSk9pyMo4pH2B3qdJxTC3Ma4QCrYvjTHxmVSbcKdZFu+sosA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4735
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 11:34:21AM +0200, Hans Schultz wrote:
> > Just to give you another data point about how this works in other
> > devices, I can say that at least in Spectrum this works a bit
> > differently. Packets that ingress via a locked port and incur an FDB
> > miss are trapped to the CPU where they should be injected into the Rx
> > path so that the bridge will create the 'locked' FDB entry and notify it
> > to user space. The packets are obviously rated limited as the CPU cannot
> > handle billions of packets per second, unlike the ASIC. The limit is not
> > per bridge port (or even per bridge), but instead global to the entire
> > device.
> 
> Btw, will the bridge not create a SWITCHDEV_FDB_ADD_TO_DEVICE event
> towards the switchcore in the scheme you mention and thus add an entry
> that opens up for the specified mac address?

It will, but the driver needs to ignore FDB entries that are notified
with locked flag. I see that you extended 'struct
switchdev_notifier_fdb_info' with the locked flag, but it's not
initialized in br_switchdev_fdb_populate(). Can you add it in the next
version?
