Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC0C585DB5
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 08:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbiGaGCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 02:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiGaGCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 02:02:44 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC3D13D17
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 23:02:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFhOAz9AVxZB1JOTafy6FvbimkhYtnRkfzNxI+R+UaEJCv3amltm/dNE0R6uWY+ufcfMzFXA0Nff0o26lH2M/l/3BnZULRmJwAZM5OyKzYpkrfGrljQgRvkc4pib+KRWroha2Tg5gd8Q6R39EjVNAniNOItpQ6uR9i7sOiFyP1YVG1NSkNoJ4L7zrERnndqsoR5kn/zThC8w/WPntJwuy7dcXrFmI8Ypkqzwwsg5FODefZ3GtK+2/vyBb5+aAi1/SG+qrE5xsj8XRzzncmc9RNWkUDKVxN1EbiXc+ssNYbK2I+cO56E07/uTksndgWrBKt1jgY3hnQkPebX3t4vD1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lVsKE+c6ffHcSMR4b9dLDlRFnUr+PYazUQuxVB7Pzdg=;
 b=F67bDEpT2E0D087DmCVpnj1PRGoZVWO49F92LwvUoiM515Zx7kpTDd0hSzV/CjoCQPINRi2iVhRr9xueBEL/ap7Je6bmlV/sq4hL/wZEfKNnZhpgDRTeP3uzbzN48Z+ZQUs7zYKU5CK6vtBRETtXeYxZLM9z7fiO5lSNcGZY6acH12t2tkCWP/gdwNYuDkxNKNH6aaoWByjaObXTToGnpVBSfx3Glp69W007JAkuXoY3pd+njsCUr27icDOfl5y9pfnStw9Ae2AA7ExGPszlptknRHGmjZmtFSTPv++45lXcRJ26VjZ9v3NoIgp2bJit4SyU/ZcJI/bKlUlxoJCU5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVsKE+c6ffHcSMR4b9dLDlRFnUr+PYazUQuxVB7Pzdg=;
 b=aOiHkAJ07ea+6urZQ0dkVGSbIhsSnh5OrC80Y39tA59ovOU+cDng1ilF30/YOY9B3osrwUlsnPeu3gNDMhDg/ifXWtUPD6XlYLX21YVWVrRchamAiFAaReArkbQn2fcvxm0wNZfLXiRvKmk8uo+f7GjtglX6im4CNSUUnJqN//6x8z5lkndbG6y9Nn4S4HH+ek8HSfD89liC6l35zOIA1aPp9OWsh1Gr4G5X0kfg7aEhrTQU4Z/8IVG5eCBsrco66yBe/mDVmjmL3ETvBAcXEsIzZ4+TcOWFfPcWAF0os6pBLwQQiCuS4VK7t6sppwRWS5Zhd7MJEf14ziK9jA9esg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN8PR12MB3137.namprd12.prod.outlook.com (2603:10b6:408:48::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Sun, 31 Jul
 2022 06:02:41 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62%4]) with mapi id 15.20.5482.011; Sun, 31 Jul 2022
 06:02:41 +0000
Date:   Sun, 31 Jul 2022 09:02:36 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, moshe@nvidia.com
Subject: Re: [patch net-next 0/4] net: devlink: allow parallel commands on
 multiple devlinks
Message-ID: <YuYa/GMiQ/i2M9dU@shredder>
References: <20220729071038.983101-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729071038.983101-1-jiri@resnulli.us>
X-ClientProxiedBy: LO2P265CA0515.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::22) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cc409b6-7730-49cc-1002-08da72ba475b
X-MS-TrafficTypeDiagnostic: BN8PR12MB3137:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jGsgQS8KZQ3Gxd04668elOOtiXgLhmq/pBh0P46KypoOYOS+aYqy9G98x5vtWiMuw0aky/3B7qNiNyxr6Zql/UOSRAv2vW/7cpXd1TJIr7RMvCwkT9rhIV4XDKt4ukjKst0dyHSsAPN4FMq3yTNQn9dAflTZ2TPXclRq6GZif0ZMul8rxWAZeETl0ZB8mGbb7UdG4TBYxXdLNWkndWIzv3+hNP1V3RNkui9dyrXE4sonhBV2YkoJ68008MSXqmNG61tNNiWwF59wxu4H17a2lOSFU71bdo7bpkP43aqLAsfmiuS2u3VpOyjHfwrbIh7IgZYSZkOX7FD0OktoZrDmTHmlnuI5N3sO0zl3dEday5Co+rGLIGxKE7BM0SPr63Ia3BZ36dakQNbdfLEBmYJm+HsB2cGsvtRK4/gj+2fFRmExWChoOxGdcnp22TR8q/OOYkhK991/18F4aq4vdQVfGQYOfS09120q3QOxvUS6kWWQX9nNGDGaRzsxiEcxtaQL7yFkeaMqt6INzQChX0d6//bY+qEVNckzAVy9SFykwyTBL9SNY+ozoTSjgwiJOVTX0++Gc7SY2XLRp/Aijqt7iPXVygJpkZnK9yagHWxUmXoZ4WGImBERw9Fufsu4YTdFQNVYpM9E5Dd7Z9DJCct5ELcM1uZ+HQUW4zEbGSqhnBCTNnjFGR5MAJseTgwaMyREMLLCvxse0cKnnfzjZ1t36n321X7a6U8IzpkbQeAaz6s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(376002)(346002)(366004)(136003)(39860400002)(186003)(107886003)(86362001)(38100700002)(316002)(8936002)(5660300002)(66946007)(8676002)(6916009)(4326008)(66556008)(66476007)(6506007)(6666004)(41300700001)(2906002)(478600001)(6486002)(33716001)(558084003)(26005)(9686003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LrVfbQU91NZBf72NierlmNOrC9hM2lFtsYubMiGz91ZLeTmGsA3d6LhdV/3/?=
 =?us-ascii?Q?avgTDxoT9JdheaPRwzdipS77Tq7tusmuZzgxHSibzFYSYd9HWXrJ9VOZsHJw?=
 =?us-ascii?Q?i1xEetkSgmskv9hDUEwW2eHtvmT6I13VFtEtbOytPg59FME775zFdHh6vpZz?=
 =?us-ascii?Q?Q+Sh9TnNVzncLFArhWYAByfT0a21BjQcSWJKctMfqdQuIdUn3PCjscjWwile?=
 =?us-ascii?Q?emdCFhESS6ObaVc6q7BCK7vvHiqiqr4nHxJpkLAsGj3dzjFeHRqgpGDTMZKP?=
 =?us-ascii?Q?ptdRLDqCmepEvijcE8uVoKJBOP2K6cjDshZiq0LiO7g9drOesbgnDfA3EwQp?=
 =?us-ascii?Q?D3rPZ+0cfOiz/WYz+QeuCEJo89gxFo9k9FSWTDP8gGWpLc12xJyucAJ7Ny6y?=
 =?us-ascii?Q?+cVGVLIF9iD5nTurZTyscgejUBNCpOlvZKiMIKKU6pzTSRhOcxHxfAW/WwM6?=
 =?us-ascii?Q?tqNlXxaPnnbmIGaCzilYQzH9/KmJX9o5HCE1VhEWBOAUOPQXe7Xv15XjHpfe?=
 =?us-ascii?Q?UjTTeRPTTXIKuR7LfwnMjKB9Jx5XOQ2kuVFmqAnmFZKj4d8VyxY9lcwFgyf7?=
 =?us-ascii?Q?tEwQKSeEyud2HH+zmtE4Jq1kOVHVy+DphCV7Fc4Uqon/QKzAqMtDPbPr9Ua7?=
 =?us-ascii?Q?GNSNg+aIcv7gfjYAPAIKH5kcAN25CDipR7Yjt0aQFC+0VB5wXSmFUSF45Pzq?=
 =?us-ascii?Q?zpP5uCfTnJMIK/jbgYdERYgBh5+VIJnZMPMiEP8AbryT/La6kSsJAA40z8Q5?=
 =?us-ascii?Q?pHpTnh/Mv8f2ZVOaHtnjeTRX8KVxffql/TMecCua5rUTq36dZICohXZ1eB1d?=
 =?us-ascii?Q?1r6Q60NQ7LKokLpDyhmMWCJALwUCpDXYCUWpMgWch3HVRvrKYkv3xO7u0zXj?=
 =?us-ascii?Q?6+HjiYLJPjouVgXGufmbNMQi8FYyk5zfnfzt0AReo+P80P5L8PNWbQagYVtJ?=
 =?us-ascii?Q?qAPObC1ASsmAXIDzdAJ6U3Lz6/fgUerBRFDxv/U5hDybgmEtVy6FH9fEW5b8?=
 =?us-ascii?Q?xuC2H3WdjbbM9+5g4Ux5ug0WgZzLMEOUb3ItRX7ucn8MqrdgyOTCjSpVx1x1?=
 =?us-ascii?Q?D6f8l39sAle62bcfpu7U9PH3VtIMnyGH4hKY0PYrlE+WirTv+6OCZgZFjWmT?=
 =?us-ascii?Q?UFx1GlAd35RAFQgRQEu8RE8APmlXVD2UMXiN876FWaQG4tgQENw9eT50RHdE?=
 =?us-ascii?Q?+bq9bPRDOW1H3gD+bey/AMUZoWAV6C8ZUZ7VkM0pHvhTRm5ON95XHmaa4FNJ?=
 =?us-ascii?Q?scEgbOioafVdC0v2/PVmM5ligu8ZyehCeXhfdr4cd1VJ0jllmmpPukufr0G5?=
 =?us-ascii?Q?Sz26Yk7ZU8NDxYpa++A542zO61Aj0qgyJ81+C1IL3H2kx2wwGBvN/rkTNzba?=
 =?us-ascii?Q?qsl6bdpIatL2gB27SBqZhWr1gLzcq7jQfouzj7itRL1A3TgBFQ2LaI8V2G6w?=
 =?us-ascii?Q?K4Z1rRrjqaXPt29+Wloh3epDhY0qtpTDUbHR356fpoc0cFUOITFpOSXB7v7W?=
 =?us-ascii?Q?e0+G3ZEdk/6d9XLOM4ZdCI7CAirUzMznJPuJ4EA2vV/TD8b/mUx5vWsnhwJ0?=
 =?us-ascii?Q?IVNs9HCS3mH7ifPQfA492L84kFdSDXZZdyAQ073F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cc409b6-7730-49cc-1002-08da72ba475b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 06:02:41.5166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QOA2MwEdKCE6E4PecOyZ23mMZtXnLU/DZK33wu+m04/xQ8B4YyUlEDQVKCzxGt9QQbCDLMeq9foKzyGdLKlBZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3137
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 09:10:34AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Aim of this patchset is to remove devlink_mutex and eventually to enable
> parallel ops on devlink netlink interface.

Tested-by: Ido Schimmel <idosch@nvidia.com>
