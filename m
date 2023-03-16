Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB466BD9BC
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCPUB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCPUB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:01:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83C9BAD24
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 13:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678996886; x=1710532886;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5d7wIu9e58p6xhOmoKwkfNRTBW4xty/xNLaZQxcDvtg=;
  b=h6xw6WQAPJl1H9766ghYbokFuAAmKGqcknazs3lPjuipxS/2fOA0i3K3
   v2VKIa2tTRCY4IpYrAZj17syoHrxDE24h7yGisXc0iJsBoSnizX2DFMBZ
   BhUC++3OTybqfaXlUmQ/GUF0iypdDH8sEOKdzSlMHtkgOvpZ+ZytpTHZh
   j+1EjyetBdeR16FARxo6YPCIuEKQrg1JMCG1SL8Ltd9DXVY5qGCsMTIvx
   MZ4oVNUF3EBCYo3iGUIlDC7OjEwLOyy3fJO6bb7JinsjrG7QVh/d/MGmA
   i/PK9ClCv4DXXhsgqww7ahr8GWfNDI+iKIt2ZqwhxaE12vY5qygzFO8/e
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="317754081"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="317754081"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 12:59:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="680021634"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="680021634"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 12:59:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 12:59:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 12:59:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 12:59:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 12:59:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XN4iI4aOMa35xj4rPENBnBMHymUU2lgcDDDmR/5RTRe49FOfzIDQNbjtwevqclOMS1GQfxLQqm0X8rIuG/rBZXpW/UO5Tb1b/1FC1plcG4QUoVrn8l1Wv2pLbgeXtiXhfZb/MMKVHPz20jQ7vdYTO1yQZO5K5hxmqrsv1HeEZKPM8NaKpsGDZzmGa3jYAUO9dPI2Wrz+zp1NN+KvRklvl7mhDJvbquG7jgrKkOlAF9YIZQcr7rWMYtX/6+qMZ6FZhaKXpD57/kj7Zu3pMvnPpQh3CNOKR5xiDqXC3WG0fdDLFRzoSbHfrCSTF491/GH8twHBaZl0BYDIAMo8dsugBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CggFx3lXoWDhPjrijK15GvXlRaGNrZEjiTe1luQC3jc=;
 b=gjxSSvT59d9ROWNhSY4/7pGor3Y9zaGr7s+H9wrxijX2ZR4IbJmbeFzAgvxs/pqxYLFUf9tk13DnAhRK4CCh7nvTGq7AgBIS5ryTVXgFTvkhTNUw3XIcKb+LWezVomelLDVL56A/vGCKl05phi4ovNy31aJpJDepR0hJHrbpyueenqj6XwDGyk5xwbcNxZY+r8JxEqk7RDmdsNoY88UPUA/dwJC7rH5Tw99hnz684NCRQ9TPgVRH4XLt0YQX81gx13jq+dzuVoRxtBn7lpp0rRYIr4Z4IsJ9T1mrAYZ7u1VM8V3xbogCX91Qh3E/1bs6cHiQR6sRdCXacZLDgvQsew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 DS0PR11MB7560.namprd11.prod.outlook.com (2603:10b6:8:14b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Thu, 16 Mar 2023 19:59:34 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 19:59:34 +0000
Date:   Thu, 16 Mar 2023 20:59:25 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Shay Agroskin <shayagr@amazon.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH v5 net-next 0/6] Add tx push buf len param to ethtool
Message-ID: <ZBN1HeMxbaXvpH+Z@localhost.localdomain>
References: <20230316142706.4046263-1-shayagr@amazon.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230316142706.4046263-1-shayagr@amazon.com>
X-ClientProxiedBy: FR3P281CA0103.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::19) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|DS0PR11MB7560:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fa2a667-1cbc-4c96-dbf6-08db2658f653
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hrohrDGLrW32r8MkZOO0PwKYWdagFBBE+J+7XnXwuFp0Y7p4KcVJGEf2MlsrTlcxROlTO3M6xwLgPREw0ownyrWe218DAcGpnDJXQ3fKen9canndlsSdRiNvuBdhcJU+uyHxt1KgNhn1kC/iZUdwxYC5jKe42ej73m/uTzD+QbyDn03Twu7FD1Qxh7dan3KFjXg7GiEKBbplmGTHNfsRfFfVQ8BqVdrIQTMjBBL9D8iP8FtqRL6OBTX42PO1Wlu6cm1PjeweOIt4iIDP0w8usZVhSlXclpfSBL4vVQU3uSKldvc+xbF8sY7ryRpG7kT/iWdXZ+fAJov+EzH0b3xBzxwjvDhJLJv8XBVPocNjHQMH1iW1SjNHaQIoW/gO+KoWt+0oJjMGABMJzMuks2JTfenw6MsCPay6p83vnu4UF3ZkBOcmzlFw2bK0GpWM3vXsiCT19Pachvgo9y4MuA42S9sFApF78KSpduvX+B6NbypRniuHEj7iTo2efg7UTqwNImkg5MrZrMl8hwvndRdCUWApYP5lZYBQNXMI/f26P2J5fETpHkAA3PmZtg91CeRfkFL4zIoOvwYDQGShuOD1gmUNvVVC0zKuqMcGmFFzZ5elqt/6/4zIOPPJavWP5uHav4GJOpjyU6aKOcd+sHQ75vmRX6tmewRZxf0CyaDWL1jtbPpO2uGuBcX4TBHynG0w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199018)(2906002)(41300700001)(82960400001)(5660300002)(7416002)(44832011)(66946007)(86362001)(66556008)(6916009)(54906003)(4326008)(316002)(8936002)(9686003)(83380400001)(38100700002)(478600001)(186003)(66476007)(26005)(8676002)(6506007)(6486002)(6666004)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vFST07XId4b0WNFV9OqHdUsG4lmRoK4cbWINRQRK+Zrc0xiT0PtxUKPu5sP5?=
 =?us-ascii?Q?R4AGVO8F2utC/TG6hRNoOwu2bZIT2lTPmHEPz5QncsByrTha41EGaczOuEgn?=
 =?us-ascii?Q?KfPNjDm5kznKy8pT8LaO/+6PekFs+mibLniSbBq9+M96MLWT7AgDnhM56+LC?=
 =?us-ascii?Q?5uy5/vdY5ktu29te4yCphxSHY8MrBr5hPqWKgBGM7squ/CusJh4371e5AnOn?=
 =?us-ascii?Q?Ip44EznY5UhlbUNjCEmfz20nD2FlGL33R6uKTGzGqEx/7Yb9qGi572YZufS+?=
 =?us-ascii?Q?VKsecIwv1G8QYrouBsr3lzvrd61JhMxKbhc3SqXtEIWNY3fjDpxvu76QQAdM?=
 =?us-ascii?Q?Z3JVtqRneJuaUhRnZr/fbQuEnKqpluJpgUfpUhv1uuQZsLohcV+prtVtTbEu?=
 =?us-ascii?Q?NZ+8XwSlfOgg6dvUJI4hZDaU77PI97B9ojSqcnfuwAwwd6Auv4i3MF/w+x6t?=
 =?us-ascii?Q?wZHvOrH1gYsylOMq0bQ0mQHpKXStwlXZi3MsMwzk1zxblFqdPgwgjMVykbYA?=
 =?us-ascii?Q?Figcyu97kcLOFgifzHp61T3XVkpiqc+cwHXiDyt0kdpvGdyGVRCMQs++Nbuc?=
 =?us-ascii?Q?tyFqavliadJMhWxtz7oCwFWavF/B4zOsyVt1kjNXuhy5SRTqrgR5U8osXvol?=
 =?us-ascii?Q?uUhLphih5EliFsFMxibCOp6mceUhFny7xFEbONDEKlbkRyYIbHqxuPktKrAi?=
 =?us-ascii?Q?G/5B/YVwWosJNjnghh2tkNPoeBvxUYZvYkNterE5pVlk0TpD9uNPzdb+jDkQ?=
 =?us-ascii?Q?FOu82jIzbZFitGnORfJ9JLISWDI91D8GHHh0wS5kJf0RrTCydb9/HsEGMSl1?=
 =?us-ascii?Q?eqZCXeO+wQOx+nILw3uwcx83ZmQJMiob/NP2WTpWUF5qotsOQXegb8IZUFFl?=
 =?us-ascii?Q?Wt4tuBEYvNI6HmMWJupiZihq+qrF51VvkpdrxPQ1LkD8r7ksQpAb7plSJfnB?=
 =?us-ascii?Q?VJW192Qr1beruHYdeeof3yXY+54tXZr2sdkPFyAT1nNl0vJ2XSHmFo9aLCsB?=
 =?us-ascii?Q?CqIWyenepZ5zLQGoj4XxRJG6lvdHN4nwv9jqpQnkKri4ux2mMMq32EVZdjar?=
 =?us-ascii?Q?SDdh5hscRLpnD/RVRRi2Drfq0VgiG5gvV6wKuBSw0DAy+5oRu9EnUMisb2yc?=
 =?us-ascii?Q?VbOeHlaZKbMnwHmenMyD2M1jmwt029X2ikPk/yjeEm0sRdOcun+Z08T5qGm8?=
 =?us-ascii?Q?fDbuO4x2U5mx92WWUUCXpDs3zAb3xt+VLmB8oQRYt5dLR3F6eKJjpfi9z/6K?=
 =?us-ascii?Q?9q3r1ZgCiZ8JpvQKREhI0hwUBpDtPo4KQ39iesh7Lur/JYeX9UTKuBQEIXVm?=
 =?us-ascii?Q?vKNbxvxKZ0x/+2ozSrWALobX8yXex0FhExszMKK9MEw28qRez8DfkASRfvzH?=
 =?us-ascii?Q?B9mBU0ZgtU1YaK7SPdP1lkI9EtsyHDxQ+tRCLa8FqozGfJviF3uYws8MJ0Xu?=
 =?us-ascii?Q?tPEAITU7TcDjyOWY1jTMiSF/f/g2J3TcK+z7DsrzCoivtu9Iasn24+JoJQAk?=
 =?us-ascii?Q?SLnqHVy/CkGK6Bq6gU/TYPPvzVzVaW/SzKHf7FcY8H7gVDZVeW2l0Y4fF4Q9?=
 =?us-ascii?Q?N9mFGKDxyOZ7/sqhnI0vkWkVH3vl61uC0aBmWy3J+Il08dxMhJtUa/Z5MkCE?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fa2a667-1cbc-4c96-dbf6-08db2658f653
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 19:59:33.7537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rn+xsm6S2tttY3qgmgrU78wDqKssjK+CUMb+Cw2anKMLddCiuXZEJNWiun1jQ7dg7HsH64O9/UQp8kp1eLG9Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7560
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 04:27:00PM +0200, Shay Agroskin wrote:
> Changed since v4:
> - Added advertisement for tx-push-mode in ENA driver
> - Modified the documentation to make the distinction from
>   tx-copybreak clearer
> 
> Changes since v3:
> - Removed RFC tag and added a Jakub's signoff on one of the first patch
> 
> Changes since v2:
> - Added a check that the driver advertises support for TX push buffer
>   instead of defaulting the response to 0.
> - Moved cosmetic changes to their own commits
> - Removed usage of gotos which goes against Linux coding style
> - Make ENA driver reject an attempt to configure TX push buffer when
>   it's not supported (no LLQ is used)
> 
> Changes since v1:
> - Added the new ethtool param to generic netlink specs
> - Dropped dynamic advertisement of tx push buff support in ENA.
>   The driver will advertise it for all platforms
> 
> This patchset adds a new sub-configuration to ethtool get/set queue
> params (ethtool -g) called 'tx-push-buf-len'.
> 
> This configuration specifies the maximum number of bytes of a
> transmitted packet a driver can push directly to the underlying
> device ('push' mode). The motivation for pushing some of the bytes to
> the device has the advantages of
> 
> - Allowing a smart device to take fast actions based on the packet's
>   header
> - Reducing latency for small packets that can be copied completely into
>   the device
> 
> This new param is practically similar to tx-copybreak value that can be
> set using ethtool's tunable but conceptually serves a different purpose.
> While tx-copybreak is used to reduce the overhead of DMA mapping and
> makes no sense to use if less than the whole segment gets copied,
> tx-push-buf-len allows to improve performance by analyzing the packet's
> data (usually headers) before performing the DMA operation.
> 
> The configuration can be queried and set using the commands:
> 
>     $ ethtool -g [interface]
> 
>     # ethtool -G [interface] tx-push-buf-len [number of bytes]
> 
> This patchset also adds support for the new configuration in ENA driver
> for which this parameter ensures efficient resources management on the
> device side.
> 
> David Arinzon (1):
>   net: ena: Add an option to configure large LLQ headers
> 
> Shay Agroskin (5):
>   ethtool: Add support for configuring tx_push_buf_len
>   net: ena: Make few cosmetic preparations to support large LLQ
>   net: ena: Recalculate TX state variables every device reset
>   net: ena: Add support to changing tx_push_buf_len
>   net: ena: Advertise TX push support
> 
>  Documentation/netlink/specs/ethtool.yaml      |   8 +
>  Documentation/networking/ethtool-netlink.rst  |  47 ++--
>  drivers/net/ethernet/amazon/ena/ena_eth_com.h |   4 +
>  drivers/net/ethernet/amazon/ena/ena_ethtool.c |  66 ++++-
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  | 259 +++++++++++-------
>  drivers/net/ethernet/amazon/ena/ena_netdev.h  |  15 +-
>  include/linux/ethtool.h                       |  14 +-
>  include/uapi/linux/ethtool_netlink.h          |   2 +
>  net/ethtool/netlink.h                         |   2 +-
>  net/ethtool/rings.c                           |  33 ++-
>  10 files changed, 326 insertions(+), 124 deletions(-)
> 

The series looks very good to me.

Thanks,
Michal

For the series.
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

> -- 
> 2.25.1
> 
