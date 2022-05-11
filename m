Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA1252412A
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349429AbiEKXnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349423AbiEKXnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:43:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1CF60B99
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:43:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmhzvigJEMJIMzShyeSPV+BR+ytdUhnx4cNcrfHHEGNg3sq/yO81th8ocf9rOjsdtV/WdnpEh1Tg2yRzQ9tsoI24GiERIcON0xTox56PPpvzBCFHcDjRKBF1HM6Axy1kOvnC/uQWcClAwJ60Cjk46V3B2jpBkvw7zg7ze1u/5kwuof5jQNWlEriX+xiZ14/lmQmZSOzyOzi0BZCrXSvtpjXTcYTNMZNtxoUwokbfSix9L6gms3BqUVKHj2iAQ9xuYGJwtUfsCo+ApPfRE4gCha474OqQ3X/VLHz3Bw+9ZYu4objjdOVuVrU3/7/+pENHHWUfatzkHfk9Efi1LcTj9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6e9IQaq7d9punn2W1UENgqg/61sr21zb5oOIZpop4jU=;
 b=TAX5SZkUbZIbwVs9cIs4UogwiNQNG+wUIe6Sf+ib/7mgjGnebe/DQV3p+QgdIlsPz1I3664jV2L5bhsdQF0/gbhSTHYiz+tSuRWTXA6r12gWRsxyE/u1+EydSH/38Ng5saYjm+62KMNQpTDsV1JgLc2e+OpRLI7oWcOo0HPUEguJwhpF2+upNuthapEQhDrtWV+xUyfsSUu4qi3RBP5kAPiGO9WP2uSSxoLqNest0h4Wl+lyyhbH8m5MYBSLTMmWMgTNdQ75lqGIY+jy5urcnugLjs/8n+8EjVZVEbhO5s/8l0nmtj7zdBVQDLL865RsYVknxxWa9qcpB1SpoauoLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6e9IQaq7d9punn2W1UENgqg/61sr21zb5oOIZpop4jU=;
 b=j0mn3sHMbr67g8VaInZge/Zy9yX6hDG7mlt8q3Ntp0U2hSH3eDzLP9By5oNVUDMmGUKbss1Uo2eGABIHej0BHR0A7//R9Rfoup3wYShgRZww82uw/DgvM7FnS6a6yuHim31KJ/67XchKjfbwZVgYP2vKSyS7kysAPzWOuHPjVi2KwDTO5SbR/rCXfoTEsm7XkvTCOGXgvL2zgAODM370vq6k56kFMVDaO/6gGNmnDu53j9xrPnYh8kyg4ne5Z6Cd6sKsj2sc9tRpEDV/DCB7kf3ZkU7rLXq/yN4x+9Eetwq8e609h/j0fWrga8Ta6oJ0KGi7Bgz0z5vesz+0WC1s4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1417.namprd12.prod.outlook.com (2603:10b6:3:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 23:43:30 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 23:43:30 +0000
Date:   Wed, 11 May 2022 20:43:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, johannes@sipsolutions.net, pablo@netfilter.org,
        laforge@gnumonks.org, Jason@zx2c4.com, leonro@nvidia.com
Subject: Re: [RFC net-next] net: add ndo_alloc_and_init and ndo_release to
 replace priv_destructor
Message-ID: <20220511234328.GO49344@nvidia.com>
References: <20220511191218.1402380-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511191218.1402380-1-kuba@kernel.org>
X-ClientProxiedBy: MN2PR11CA0015.namprd11.prod.outlook.com
 (2603:10b6:208:23b::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1142037d-8652-4613-da8e-08da33a80da5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1417:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1417DDD355F5B1CDE5C41B1BC2C89@DM5PR12MB1417.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l5/FJ63RBi+glHM9pxQfxW0a6yBQHl4p09Z/i4iGJQnvvLLLc6i8NO3bytso/O7Ng7hLlnfVF+DbSdIzezkyYGMvuTISwiil5vz/IYU7tnYJg+S2o+oyfVImL/TgSl2vtQpPMFdXC0NtcHVA3LIegh3N8vu/v3LiV73IayUdGiWEjMzYjzSqpJ2KaBmNDUnoQiuWfuDxKlYFoorS3mD/18gzIlCw1uWdcGeBwOZC4JSr2XklZ+OHlBdG7UDnnX2mjvpDl8Zalb4Ya3i3kS0h/S1S4aEosu74lvGkdU1WMLj1SzJITrmJUPwrjzv3NFp6E0seyt0yPB+cfvMjBcJ8KBPv98Ak3Kk2KHH4GmINHQus/W9MvCZd+51wxoa1SAcXS0XgDrGYPy+tlREPmQz2ktfEDH4UvGIVWWzo3c7JgSRJuBPUGxNA/m6PhJGogsaGzi0r3ivdb6gFjKgbqWAYYs0Zspf6vWS0DrBZc2QHMwOcNpM3mvYyJHWWN4iNngXOvV+xG0ZzV3RTE865fV2EPzfCAI3P/C+bvDYs2tyQ0UXFLz5edP192+BDV+OCoTDOrMe4OyXlFYGM2onNAACxq4JXxvWwbPhPjCW3l1dvNJfhzhm0jA2uBxvz1gVWDb4doSF7qiAl5TAbieRNbEIWRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(86362001)(107886003)(38100700002)(6506007)(6486002)(1076003)(8936002)(2616005)(6512007)(26005)(186003)(5660300002)(33656002)(36756003)(6916009)(316002)(2906002)(66476007)(66556008)(66946007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cq/FdVfjG6Y/KXr5o5ruYjaztGFSxdojLQczkvSnNCEE4gW3YNbcaaoWW5iy?=
 =?us-ascii?Q?KYm0/bem0WH+PZIXE5+jCIzZG/BuQOP4T2+VzlGO4G91hVHZEuR8jDdQfImw?=
 =?us-ascii?Q?yVaBLrC4bvL672QRTQOsEVmUg2JFVW/2W34zQ6ZtAxvo39jPxKH5n8eDB8FO?=
 =?us-ascii?Q?g6s1YQLwri+iDrnU0HFNC+hW7FpFniGMH944AfzkvQo/Mr0WcmuzgnrmKFNX?=
 =?us-ascii?Q?ng1W23X5Uvn0v6Zz9hDavbKf/+oWgj+DWnp0Oay4JLwsk1Rxa+sjihnEiTmn?=
 =?us-ascii?Q?oDsnvxRGeUNXbLEfqwsAyDiADYeWxB7OptNE1cU9s7ib6mC6ZCn5i9nzrT8I?=
 =?us-ascii?Q?vlfSKuJat4BzRlXOJ5yZzJF+pGswsSj2ZXA/Mmgzyod++5hery9Lg/s1zvwM?=
 =?us-ascii?Q?EfULZEzatSywGrfH5HoUdGt4eIbUN8aprByCycg+o848+ZD+GZ+KVshnIYqV?=
 =?us-ascii?Q?FqK/ceuoHJKb+GdDLLLzgFGMRNIZ6DzZ8hsMe/4Dg/MiKpx/ORSwE7ODitkJ?=
 =?us-ascii?Q?rgGSpOV4m7RxVwkcuWKkNBmwsFKaufIrFl85p/q5tNI12Y4SfsIx4SoZhlxf?=
 =?us-ascii?Q?+lvvca+lBLaFOYVOiApluTfIs6K72uZDU09/yAdGdDabf5gY/jvDLtpO/HHS?=
 =?us-ascii?Q?VQLOTn75Q/TCdRvYcOJxk3wj5SADvef7Bl5cgVoO9F6bSmUnnsCaWI1gaUw2?=
 =?us-ascii?Q?u0M1MPCMPsDUizk3j51cLL6jWH9u1qtkiWBpfwbv5ZWvsZNTF770olgXvUHO?=
 =?us-ascii?Q?n/5ipXExhIOEvJgIapkX5jmOnN/Md+FqyCs5q+7DbRXDM/NP7y6INnLZW0gS?=
 =?us-ascii?Q?Io0Tr/IC9L8/Rt/z/U1Ns3OQWnyJAov7Z4zWSw+B9coGXxb2uDNpOOh8+796?=
 =?us-ascii?Q?uRz7INXbVIY9qEvabG7zWqJcDXV9qIrLMmn2ljpeFhbAFG/DZvumDj11HLJS?=
 =?us-ascii?Q?gg85kvIi1Ey/8AnLeN9BOclYRYJcAKJQObj74epl1cmy2EIZeyzeAeiB+ZlV?=
 =?us-ascii?Q?F+LvgFkQwWaL+SUoi+DPHDIJ/512gnmcJ7XxfKoFlUUw2aUnO+Of3BMf1ZpB?=
 =?us-ascii?Q?wC+eLkhwRsD5ptoaJTlDn2tU7p7Ue3iAk2oD+gb/biV0jkZafMb29HzOxCUU?=
 =?us-ascii?Q?Jk1eGW1IH363TnFES+s4nOuyqyGi3R4Ub4uTlvgWrl7lFOKLzRupNvYgL/X8?=
 =?us-ascii?Q?g62CRtslyCvsYwybTeRgmndZP1lCqGxTWgeHJu+Z1DRPGZe5K2ylX89bqUJ9?=
 =?us-ascii?Q?DLjvt5ILylf4uPWRN+LeQAGqFAijLV5qfbo5N4uFxNBJt0yZNYqETW/3u7cJ?=
 =?us-ascii?Q?A720Q4tWv4Oaupcnctwk4jJmn/CvXR69XXSm64GIVPOYZ8hnqUkvXEo5NMt9?=
 =?us-ascii?Q?F3bvCyhCsd1NSzf8uobn7cAWdlcxwNpqovgTqD4dAK0y9pQfIEWuUtG8YsNQ?=
 =?us-ascii?Q?+wbTN7EX21d1qHFvj5BwdwlnLjaE7C+IfCjGFRU2Ro8v48MUyrce4Cdlg2wk?=
 =?us-ascii?Q?hQRXHxnlqvzHrq3hQ86AntI3m6hGyxDRzQHm+9RlSW9TlKgx3XaxX+gi/VpF?=
 =?us-ascii?Q?GjbQaAGWSgnpuryciQq+AQOe24yr/C6/2QaYGbzXSWESw3IxCe/dFQCVGfsk?=
 =?us-ascii?Q?32Qr+Ga+8sBlE3llfPzGIOTsToi9uj9W7Ob8ABY/qsi/njzE3s1M0WwwPaAl?=
 =?us-ascii?Q?VIevIVLIiwq0gmi4lbIj3YelVyU2BQEKipHy09m8wHmWSPsth8woE/JHfrWI?=
 =?us-ascii?Q?jsXm2RMf0g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1142037d-8652-4613-da8e-08da33a80da5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 23:43:30.4403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1AqFMieQN/l2+Eo/fPMhX1gXu57BciwOcpg1CmMuhh9crGzlSDV3gSx0/YbTk0Yy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1417
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 12:12:18PM -0700, Jakub Kicinski wrote:
> Old API
> -------
> Our current API includes .ndo_init, .ndo_uninit and .priv_destructor.
> First two are part of netdev_ops the last one is a member of netdevice
> and can be overwritten at will by the drivers.

ipoib runs into this trouble, it would be nice to see it improved, but
I'm not seeing how this helps..

> BTW as far as I can tell there is no strong reason for .ndo_init
> to exist. It gets called early during registration after
> netdev's name gets filled in, and none of the users I checked
> care about the name. They could have as well run the code
> they have in .ndo_init before calling register_netdevice().

Well, exactly. This is sort of where ipoib ends up - and it is
complicated enough that moving everything into ndo_init isn't
something obviously doable - there are several ndo_inits and several
different driver flows involved here.

So, the proposal here seems to be to rename ndo_init but otherwise
keep the lifecycle model the same - and with a now const ops it is
basically hopeless to do anything that needs to be undone before
register_netdev()?

I would be happier if netdev was more like everything else and allowed
a clean alloc/free vs register/unregister pairing. The usual lifecycle
model cast to netdev terms would have the release function set around
alloc_netdev and always called once at free_netdev.

The caller should set the ops and release function after it has
completed initializing whatever its release will undo, similare to how
device_initialize()/put_device works.

IIRC priv_destructor is really only needed when needs_free_netdev is
used, and the real point is to reliably inject code before
free_netdev.

> A common workaround is to set .priv_destructor after
> register_netdevice() succeeds. This works fine in practice but
> is not always correct. Theoretically something may nack the

ipoib does this, but I don't think it has a problem because it does
the priv_destructor action manually on the error path after
register_netdev fails and then leaves priv_destructor NULL'd so that
the later queued unregister doesn't double call it.

> We want an intuitive API, which I think should mean symmetric
> ndo callbacks only. There is no point in having two steps at
> init time so this patch renames .ndo_init as .ndo_alloc_and_init.

What does it alloc? It doesn't alloc the priv, that was done
earlier. It seems like a more confusing name than ndo_init to me.

Jason
