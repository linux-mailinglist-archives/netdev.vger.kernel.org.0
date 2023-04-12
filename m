Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4490A6DFAB4
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 18:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjDLQAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 12:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjDLQAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 12:00:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF30172C;
        Wed, 12 Apr 2023 09:00:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZMtLdnLnyGLP81Baedji2kCurMD81fAlGMudhY0pCchCK4uR0p4aGxIruzXbxEB8k3gPy62VQSrwU3R0BVoWDfSCJnFOzb268/r6INxmIxeJpMguKVif1iI17bL/lH0zna/XGSQxqW6Z07mQ+D5Drl+Noc8k7AGvQGUXxdFU8rDMFTX7xV9lmsNTOEujb85u0NqOPVoXhRlap5T7vV4+y5D4J4K+FF4xJ0Y8u4XCXd4OevLlY5yxL6bqa5FkKvdCH5Pmb+v/iOxUdN1AJR0ZmQ7NR7kZzF1Cry/AEvFo8U/uCd16r3bva0RQ1sVKTdkQ54NeWmdAwyKLLXwaQhZ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIlbLkQ0bN/EkR4QcY14tF5YOM8MTvJ9RBCgar+lCt0=;
 b=kAhodVGgXa7dWp7aVeZVx5WLyRZjueqjzYqRuDnc6qx1r1RmhitFYvC0pG3L81mNkuClTsxJe4MYmreZELsv36ndf8bgTT5UpRA6jvYYFzYopSbaEe+kEPYezrYHpcv7n7kMKpMWj8sHViTYVn1ZwVFtNCH1DSm3miAvHdnX2Vq0jYHcREOxGONeGbdPVydu0Gd9FLyffAP+Ndl5hl0AYb48/ZQ7PFQ9lHrznF+VjEmG6eM2cFRdwp7M+HZk95gwKozHNQ0e/ui5Ykp0MZW3G7kNrV2nLnd6EcL4MmWiIdj6CzW5ynhWsPwXCK0SKMjMVO9s7/v+g2iGRJ0LdhH7ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIlbLkQ0bN/EkR4QcY14tF5YOM8MTvJ9RBCgar+lCt0=;
 b=kMCivOhJ/He4Qz7kfnUXRxMlmPf+ozpBJ3Ch7/KnNBQ1LWJsr8CcjozxXxmVRd/dhWQ9rewPWp2Y8Lc32888hJ7yx5PAJPc0/0rYiwz0QEdat4LR0Gq7wwbKUGNAy1MfzEfOmFsfs9IB+92WXCMuHEXRSGaPYii2+AHz0pr5dJJznVVVUNIm3h+gyz9/5dD0Hkfo6swEayKvEerSxCSzOM7mhdbvNZEOpuU0q04mJdW6XmLSWoXZQZ6kpNLsSJE9GVl9nvRy0lzEWHXpxBc/z/pgDfjWazt495Kn9O9Y/gYp4T+24Zq8uWwlu+el5yqUv8bc/4DRYX5OOQ8SZQzFEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH3PR12MB8852.namprd12.prod.outlook.com (2603:10b6:610:17d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 16:00:08 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 16:00:08 +0000
Date:   Wed, 12 Apr 2023 19:00:02 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Arkadi Sharshevsky <arkadis@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: bridge: switchdev: don't notify FDB entries
 with "master dynamic"
Message-ID: <ZDbVgqV9JT7Ru96j@shredder>
References: <20230410204951.1359485-1-vladimir.oltean@nxp.com>
 <ZDa856x2rhzNrrXa@shredder>
 <20230412142733.6jhxt7kjf3nwqzsy@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412142733.6jhxt7kjf3nwqzsy@skbuf>
X-ClientProxiedBy: MR1P264CA0012.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH3PR12MB8852:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bf7df63-0433-4ef6-3e74-08db3b6efd4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FP78mDa1UoIEpQvb6bg5oSmwSIfjy8qutK7RfKayOMc1n8mVodaGooY05UgYdEzb2cRQf/dP1BPSXd4P7o4nFYJYZQtNBUsiY09sgHzLBbsIRXQoDQ6e8qD1ifW08PDOvQRyAy3PVil05BWHjhS7lrJ4WZQCGrh858iN4NX8eGyO2aLF5sZGmchJkvgVrkl7ThCZD1ZEgzwrXwlJ3mrFxY3CLdImg+oO/i62IbZTmsyQqkILeZVDPmG4SPV7aJLaqcko+k0IKXssUk7SPXLql0+O3M08TiY0TO/olqHjnumvMQAmVhpEKguixsCzbfMX9LVmcfpk42f4lD4tsQ1yrwzULsNuAQatkkHDFVYLzwpKCjQZcBGpPlws1bg7rQvgEddP77yzjqosJbzhqQVnhCGSr58v30qPAePZajzZVeyfjl4Ik6fvDUj4loJ2tdH+iOjXVxWOVEl2gR4lYLZ0+NliPA4kZlL99/JEgPkolHJIS2I8Rbecm0MNCtxmF8D8rcmaQe32FAqUVGxnb12iZbnn8jEiSoWJ3OOD/5KkSZ3Y3PNWDfPF9VoIHbv638Ar
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199021)(478600001)(26005)(54906003)(6512007)(186003)(5660300002)(9686003)(66556008)(6486002)(6506007)(2906002)(33716001)(6666004)(4326008)(66946007)(7416002)(41300700001)(8676002)(8936002)(66476007)(6916009)(316002)(38100700002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RaE+ENsLkMrti5sMYwbHLqtYeI1infFNTA0JifzK5KChL8+Wgz7cowqUmslz?=
 =?us-ascii?Q?ElYd6Z4l7L2cP3O/1yqrbJfUTfGmLX2guspLbIPjcq9laKNJf0paAscHePvm?=
 =?us-ascii?Q?X1XYuOMFTNru+VohWWdaSSYcxf49BEr968JHorEOYmjngDpDOsv0D9CaMbvd?=
 =?us-ascii?Q?b1OdW6rMGC8bGiK8sxk/aDzTUOGDONBrBKzJmBoipVxYWO89iBZ9BwdbXE7y?=
 =?us-ascii?Q?4E3IVU4cr22jFdraNX562ujDfdIfkfshZJxpGfmxBNsbpnntfAWaanLqdrtD?=
 =?us-ascii?Q?XMVyytwT+CaztnaOqTKF/JTdB5qL2NAUuGS3YpspSiIxFcPxt9O2IDloSW3R?=
 =?us-ascii?Q?hGD9TUzND8m3PkhFeQ4XjawqATqlK/yIE60shUUpguFmJoL5qxunXce0XTjl?=
 =?us-ascii?Q?W3Pvzp2bLJBfOQ9IJJhvT9LkHSLoEo6Zdw2hBs+i87CdrRewYb5hNKjXpwcg?=
 =?us-ascii?Q?z67Bx50CNkfax7iUHV53eSHEu0cjAC628aqJgrlrd8sgIIcvEoRSiXO+p+wN?=
 =?us-ascii?Q?Q3rFG9AxF8FETWB830tfkqmU3fL7MHlWPyKMx+qE5O4dHvvucKmk+rwly1eb?=
 =?us-ascii?Q?+dv+ERSqJ9Besl9f4Cw3BM0VxgygfKLAl3rwcybGTAurTzxeAk0Day9wyrwJ?=
 =?us-ascii?Q?E/NulvudOMXiQ6XRgIamTGzv0AZZ4zZoFjF0QSQzOII//H9khSgXwFphknWd?=
 =?us-ascii?Q?weUq7xF7nHAmYdX9EWv/B1s/IpI2ES7fPf6XjMwHXZEBwPCxK8cjgE45XIMu?=
 =?us-ascii?Q?TzPBHWzA3fHq6YtyZYmZiGB0c7Cf/r6eafAVpY6rtcoMKJ/CJXVosbigpq/k?=
 =?us-ascii?Q?ahrnVsf60/Xd8lwK1nypS0PZYq//BBqbJBFSC+vJBDp84u+ItB0IongJlm/d?=
 =?us-ascii?Q?dLK/hJgBes4Mfnag4OjCbIJXyrb+6DVP9ztpsI5IURga0NRiSsuWR3fLiwDb?=
 =?us-ascii?Q?8eYGqGkKdZEc7U0xmqGHUZdDC9wtvrxlohBB+0QAqqQ7DTz86jdgxnvUDE7X?=
 =?us-ascii?Q?kUvbXeihviAB/NrPOy20N7a4du6f7QpXWxzm5ywl4P0RJjGgljQHIdM9Eudx?=
 =?us-ascii?Q?kX1DMmPLvqH2EXL0DGjFjitFpwyExxVUoAcG2DzM1nyUTLOKo6slTlBHKOeB?=
 =?us-ascii?Q?piC1/WmwEWZ9bVVuPwYfPGNzvCNj8PjtBvAYGyPbBnrlJl/HpEJd/5v3Ym8M?=
 =?us-ascii?Q?5RbfNTtVnerIdm8v1OTRbfQspAqRKiS1OsR6TIfNloNSPBLSuFRvuhgX5Olw?=
 =?us-ascii?Q?1VYY+nWnnk11ZyTJmPifmZT3lgiB2rQwgGlHakH/ho+ncSI+jGkTHJoIjjrq?=
 =?us-ascii?Q?+iX7Lz8kEUINcCu24zOyzFpSuFRpAeNxWsKN5qLi1TXEMyEMQ6Ww/c7Vs+wo?=
 =?us-ascii?Q?RgRAysCpRgiNojthNFxr2vL2cMAFpxKIUPS55oKVS94mN1uEgdA3lUxtpab6?=
 =?us-ascii?Q?Ou384kkJPa/Ti2NbctQd6+lPjSMhOjh/oZ5fF/iQrqsokieSJQIUR5noMojW?=
 =?us-ascii?Q?hsN0GG5BK6HIV5Nun/9H90e79NHf4HTsbWBeUjQN2AKXU7zNL1dJvN7xFxqs?=
 =?us-ascii?Q?ceqRB1E71tCd4kEHykWtgAP9KqLWUdPI4NLCWWgw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bf7df63-0433-4ef6-3e74-08db3b6efd4b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 16:00:08.6804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5gsocLHAZvFSx3uwLNre4D25Gz3mT55aiz1YU13zgB+ZvI4ElZoNgj9iukryXQbVKWTMWN6B52vRKvMGDgLowQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8852
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 05:27:33PM +0300, Vladimir Oltean wrote:
> How are extern_learn FDB entries processed by spectrum's
> SWITCHDEV_FDB_ADD_TO_DEVICE handler?

No different than "BR_FDB_STATIC", which is a bug I'm aware of and
intend to fix in net-next when I get the time (together with all the
other combinations enabled by the bridge). Entry has ageing disabled,
but can roam in which case it becomes age-able.

TBH, I think most devices don't handle "BR_FDB_STATIC" correctly. In the
Linux bridge, "BR_FDB_STATIC" only means ageing disabled. The entry can
still roam, but remains "static". I believe that in most devices out
there "static" means no roaming and no ageing which is equivalent to
"BR_FDB_STATIC | BR_FDB_STICKY". Mentioned in your commit message as
well: "As for the hardware FDB entry, that's static, it doesn't move
when the station roams."

As it stands, the situation is far from perfect, but the patch doesn't
solve a regression (always broken) and will introduce one. My suggestion
allows you to move forward and solve the "dynamic" case, so let's
proceed with that unless there's a better alternative.
