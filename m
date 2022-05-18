Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B3C52B307
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 09:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbiERHJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 03:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbiERHJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 03:09:08 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2063.outbound.protection.outlook.com [40.107.236.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A19BC6E7
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 00:09:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZiAmpbGlwwSSX8ak86DpqW6SDhNCKkxW0hEkHbswkdYUAqOi2qlHBrFWaE9xb1tLwd5bdzLmk7x1/jf1Bm78Kt+Uov9hpk2RkmJPjsP4ym6Gfkmmp2CxHblHFDC9pg0WCeEM4Iovd+Ig+lWDLrXP40rP2Y9j2P5RHt75wKE5rYnmJtL2cuesX2NE0QdbXECABxZR4TdWZ9YTnCkdmFdiSsEKKXNqWkatN157r3Dq6kjCh+MvHPiLa9SIl8TGqLsHkxYL6nrSXBI7D0uBeiCVzeqAsvU0ovF1OowBOSp1LeAKQSIrZfmUfdAQ0B5fA1xp7L+gt6CldtThe9xNw8GFTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KpSb/21qjkovoW1tb8tzZzoiExteozu+k8+mwyWw6wo=;
 b=Z4+0/LHKv32qutq26V7Xv1M18EMn7GH5fLjw2eXUJTGzZ/22j2r3XopFUBmA++6qmAgoW5CNMNoJH94hH2rjGOs6gsQc89RhXXcJbjBj072wGoNd8Fqg1eMc4anbbPCFvqpW1ueGbBMzaQP66Z1o+kdHX6Xy/OFv/6K8Es3tpc61PW09UYrOc6Ewxjbvl/0iajuUsWkomE0e4bsKqY2efnF/jyEpT7Zz6ga25X7Y7z4c+EaSWiKwcgbkYFwUY6a78S7bIMbIyFeqpW7utZyuuN3IPswr9oCxjD72a+q3eu4nWPo482UaJT+/wDHiY7UUS7s+yYgf8/CbGpL1/YbCwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KpSb/21qjkovoW1tb8tzZzoiExteozu+k8+mwyWw6wo=;
 b=X6MDut2yFWxVz8/yDmCBmmyn8ODTH9bRwBmqoIGTa5TK0mzDqlvf4ufRlJwggE0moNdmaHO63NsD8m5dvat98QMhrONfhcH9G34klokF441m0D5H+DzAbBCifhXlbb6duI0OY5JRB/wU4c6a5Ki88Ly1Du8oSvkaIVxECMY1N0cIBGbTLAhQaOPRU3y6WW7fbr1LgF8tvmwD6u9rkY5e4MChhZ0dVoDrg+1yMKsPsnDc8eJrwPD/Bmd0cE7oVHW3eYBgt+l+nLLXLrxq2KFNZv4jawfZbwdRTBjyOOJTeOJ+7BLYnXkkPLQ2Bxs5R7s8wAH98OPGREEY5iivLmVahw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5612.namprd12.prod.outlook.com (2603:10b6:a03:427::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 07:09:05 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099%2]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 07:09:05 +0000
Date:   Wed, 18 May 2022 10:08:59 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net] net: bridge: Clear offload_fwd_mark when passing
 frame up bridge interface.
Message-ID: <YoSbi3EXYUwaBs1a@shredder>
References: <20220518005840.771575-1-andrew@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518005840.771575-1-andrew@lunn.ch>
X-ClientProxiedBy: VI1PR06CA0215.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::36) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f629d232-f462-4ba7-24db-08da389d4b31
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5612:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB56127A2B987F894A84EB859EB2D19@SJ0PR12MB5612.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nwGNyVanvhO3v0PbxxYvoV91AM485L4+rW7Oc2VOKpWGvd+icMSLdMnD9iyMbadhf5UkB43jRbOgTqK6bl5V9F18S5/bcBVwdGLgcTand82YUvWxJzt6V84PnsR4oMVaOmWC8f58CSrXdJqiiUajnIYMeQRG0yjcL5FDdyoZeO5KFIm1z2JKHBue829E/k5qZqJ1/8P0ARA+KiQMKIoYoU/H0NCCUH+JALFIStN66ac7n5pSa/j2Csasj5IqcY34kzmGIcx+KXKyQFp1ik6Bgs7NQ04lYy8zSZVSAzDK/iuKsWBee3c048oaGNyX9sa+3DC32cza/jSEFxAUWy0dbATeOAxAET4RvIiHRvdbnz1ZOHcWIFuit6WSpmiIq4iL7gaU7etQKsNyHmSjYEwSfPYP/Fs+dX0KyuQDlLxOnSm51Bpv/6rQIA/JeWX5ywHSVf4Xbz3wmEsLl3lnXXSenVQgO9XoSqOozUSDLqp95/SV3IWe50hmZn/WK81ybR3UIpYYhDbYjB+q9FJkzcu2McCCNWnWsN5H0n1eqJBZZmUWHcMYG+glqrXlTc2csGOLRcUaOfwI6RxAVwWUzaAMajzraM7DOuFbevA1ktN9T8r8OyDq9C3/hmnuoBncFvnz2nIE/2o32+XtTTq4PHvgbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(38100700002)(316002)(8936002)(6486002)(9686003)(26005)(6512007)(2906002)(6506007)(6666004)(54906003)(5660300002)(86362001)(66556008)(66476007)(508600001)(186003)(66946007)(6916009)(8676002)(33716001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7kWxMqSQXRd7+FL0w39DS9DbM4WIvLo4eFZq9tDSAyDfjTp6xiXg5OpHrDHK?=
 =?us-ascii?Q?eNCGiwRv9Ws/ol1Vgy+ewIisCzKs7v43lixnz9DypRY+Sk/mUtD71BUFzK/U?=
 =?us-ascii?Q?ml8S5g9dnju2MUjTvts+u5rJU3SbZcIH/D6m/4ISgqIyOyqP+yyRTpxCa9Lq?=
 =?us-ascii?Q?tjt6sbbB3F/Qggn+DyT+WZE/BQjaPFyCksQDwAsbAseSHjY8ANScyTOu6zoQ?=
 =?us-ascii?Q?gDiZi0EAJKYWqTlO7+irz9ssDjHCZeOsZaCbsrJ5Pj8RQartGTbcM9vcyWzq?=
 =?us-ascii?Q?wE0wZyvKDqasuiQZV+rJj/SIitVjNbwBAFJB6LVH5LMYBGy6pf2lW/xytjpg?=
 =?us-ascii?Q?O0rY2WxdVVq87zPU2Kc/4rp4vMum5EGNQdp6Yf+CPvjhiTS7cLtEZY04wo+m?=
 =?us-ascii?Q?ngp0qY47JXNsdwl0+DLTx5JADH5+ePRbXw//lyV0RSTayjUcn24gj147mIhf?=
 =?us-ascii?Q?+aKRIklppDx/6CDG+9Jkx30J0iPn5rGc0epgjddD1z7TJ3J4g/QamKL09Mrh?=
 =?us-ascii?Q?ppwygEoAj6mBA70W6yk/GA/7xJ5J6ryh7RLMHYR0zE7Jogmi+593HwSJO2RX?=
 =?us-ascii?Q?UjQUskOjpxZaM7akIzCiZkGVMEvXT2q/Y365/86NZt/if51d9sZ94Yr+4aeU?=
 =?us-ascii?Q?z5Bt9FySCxQkwzMyd2puLUEgRo5TSQrFfEgHXN/j1ER3btNYkP5wh9yin4Cz?=
 =?us-ascii?Q?0dyFaFUSp0duIPzxiJdMxWJjrBIQazPhUX0YawqpY20FGVB5YPQFalGnYgOq?=
 =?us-ascii?Q?EWBE3XujODEY+angnoi4EFPb5N4UsDWwom71gun16I9hkSomiC4FdbpkXS61?=
 =?us-ascii?Q?uWYu6Vuyq54zb6++o8WGDSMZX+xzC/haeKa2IVoch4y9IrrFjbU2k4PXz7RM?=
 =?us-ascii?Q?fNMGN/Xfd/oI5antMQOzl0PxZaJIburisCBTdkhb0zaSTf9IvnSsq0D0/0vf?=
 =?us-ascii?Q?NYbm7dIch50PEort2jkYk8xio1uiT6csSMRsvY33rKA5oU1zwcMZPq7/qG17?=
 =?us-ascii?Q?XrQlUZwuwqU8041vTdQ6IbPzSSSUxJ9MTNc8wmaje50SOWLewGlNaY4DOPOS?=
 =?us-ascii?Q?BFSq91ecttL2gBGiP6s2XjB2FgpLQWUsnzoLjZbBGQByjJbXlscovjEj4hXk?=
 =?us-ascii?Q?ZLRku9ZK5jR72HFkOG37yxeoGGz8RZcvOo+r1l+uTfQogMnfE51Q+RpiHU8d?=
 =?us-ascii?Q?ZM5e39zJ8vA7LoSbVGhg5pWJnvCWPG8cOrhMZKfgkIyxvcgjIBPxz/nkiKxM?=
 =?us-ascii?Q?pDKB7Qm+Z+EYFi9a8FSgvbuYUqAZweyx5UERcMgo0c+oMQnND2oLrrJ7Hf+u?=
 =?us-ascii?Q?RHCQJqT1F4wBEawh3RqMwXtRz+LsUCa0MgKjmyhql/D82G0P6wBnyBNY8cmx?=
 =?us-ascii?Q?MYVSe5KUP9GdPEoy+ABKcYbdbjBBQlvvUno60m/Toh9SuE49M/TZ3jllVY5a?=
 =?us-ascii?Q?5u5iWJh1dzxFaYNL2MABBm6DIUh9JFXYIw9xf5A9ZkacTvxBPaPm0F0iTgLQ?=
 =?us-ascii?Q?QS7I6HpcE7xeiBqxi5O8bhLDH0NnsEvCuJp6bN3bqZ77sJ5EG3hDBPk8y6gL?=
 =?us-ascii?Q?bYDbzuyTh1LY5+69xBDFeeqpv18gJYZNcRjgQZYDMexjiBokioiXAugHDuo9?=
 =?us-ascii?Q?XByyTRRyJBKJCUMlEuY3G+/SCsEqu0g7lqFWOGvJs8B+e3OQ3femysE7w1O8?=
 =?us-ascii?Q?QdAKoVQQT+F2otH83zNueIxlCzVJlpLEmFdLvjOBkWiXRcuNg0OT4ZyCz9Uc?=
 =?us-ascii?Q?rIZBVj/A2g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f629d232-f462-4ba7-24db-08da389d4b31
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 07:09:05.0129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iVj2PwYPGAmMZNp0f4fTyJqxg4VOX86Eqfsr+0Seiq1+bUx4UWJnKGx4kOVatIrz2DAlrqCkmmCZLcXVfrvgBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5612
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 02:58:40AM +0200, Andrew Lunn wrote:
> It is possible to stack bridges on top of each other. Consider the
> following which makes use of an Ethernet switch:
> 
>        br1
>      /    \
>     /      \
>    /        \
>  br0.11    wlan0
>    |
>    br0
>  /  |  \
> p1  p2  p3
> 
> br0 is offloaded to the switch. Above br0 is a vlan interface, for
> vlan 11. This vlan interface is then a slave of br1. br1 also has a
> wireless interface as a slave. This setup trunks wireless lan traffic
> over the copper network inside a VLAN.
> 
> A frame received on p1 which is passed up to the bridge has the
> skb->offload_fwd_mark flag set to true, indicating that the switch has
> dealt with forwarding the frame out ports p2 and p3 as needed. This
> flag instructs the software bridge it does not need to pass the frame
> back down again. However, the flag is not getting reset when the frame
> is passed upwards. As a result br1 sees the flag, wrongly interprets
> it, and fails to forward the frame to wlan0.
> 
> When passing a frame upwards, clear the flag. This is the Rx
> equivalent of br_switchdev_frame_unmark() in br_dev_xmit().
> 
> Fixes: f1c2eddf4cb6 ("bridge: switchdev: Use an helper to clear forward mark")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
