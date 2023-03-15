Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D226BB6D5
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbjCOPBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbjCOPAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:00:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19585227BD
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678892410; x=1710428410;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cQlwok33olXmqxD3mac9E1LI7AMC02cmDTeuP7YsaEw=;
  b=AdG+TBa1Gg6xRvtqtBh+FBisDNre/rIQaBTNQPZ5mst4d1oWZQX58ibc
   zL6SLqTG8J3UKOPS31e6uH8uS12m0nHY/4qNx1CTp1HLmotT8JPqkEh9f
   WreT2mv0CO37KaZss2Omo2sdFG0p3eEzfjPBTTlEU6AaxfhP0sXXcc38C
   geDdrQUcuJ7swOInpshqHkr+X5EUXM52J6DXs6wfKFdZzvlw2XX5vxUIF
   bLAriipxIxzR/nPY21kcm4nZb2KveFo4FNuxrI4GZmoCnk7fmtl6cgGAF
   zvYOcurs16JH0neTxSifTbqLCL7c2pN6u6xqCJDqJDA7TueuGK+GnrKHn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="365409249"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="365409249"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 07:57:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="679536782"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="679536782"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 15 Mar 2023 07:57:51 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 07:57:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 07:57:50 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 07:57:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZyHpXB3i+mnqSnz4OUMESDMrWg2I9kk/MkQn0ophHXyvyFFvjK+ogfKtHkPuFEiUlHc1OZYmw8pypCsDqd+gDc8MUIf9025Mu3zW6Zy4apzhazCmPeOjI+SfikHKYupmkdYq5XSRMls23dhTV7CJ81AejyZBFqQRqLnoBsIiVf1WigAMKVJhnIiiervrbpMydOujvSHaH/dUGLoG92CL6EbIjU4jzlcWZ/hB01Dj8ccHZfrr7+Bid/D3j4mGoQI468dX1J98bXxQv/Ze8EiZHA9DHZWnNfelT4IFEGcHQQMN50zIusNFBFMpWQrgk5XLmAqqz+BSjfyzIOMNt/PcUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+qXj4crD2u4OoZm/r7rG+jyj690D8wO9hs82ZhR2AXw=;
 b=B9yDzxgPhI1YKmhrOMWVmQW8MAKMk6gYC+EMaJy6jvg0ERLU4njzAHj2PaDzQzSUqCsl/zMmEupNGDUz61VRUVU+NruvhZlLV9E8okVmLmRRlJw91oDu7/vy7sLy6+Wv0AuLU7IImD/k25900ytqeYKFYWefrTBR3SVFqzrrHkk2Bg81x2VImGEA3uImQJNL03ItTKnI5/XgQZiKGyoeMOtce2EGoOV3XAHu/WrlNVF+HzaA5hQhhynhf06sjTmf5wiA3/OQudbHtnK2Q6gUrz4G8yRLe53zSNEthxJt88Ayyf2RH9nBsYLENonR/FO2Ud20NIJV8/zfjrcAAKX+Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 PH8PR11MB8064.namprd11.prod.outlook.com (2603:10b6:510:253::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Wed, 15 Mar 2023 14:57:48 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 14:57:48 +0000
Date:   Wed, 15 Mar 2023 15:57:40 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
CC:     <netdev@vger.kernel.org>, <monis@voltaire.com>,
        <syoshida@redhat.com>, <j.vosburgh@gmail.com>,
        <andy@greyhouse.net>, <kuba@kernel.org>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com>,
        <jtoppins@redhat.com>
Subject: Re: [PATCH net v3 0/3] bonding: properly restore flags when bond
 changes ether type
Message-ID: <ZBHc5Bosaw6XZOwM@localhost.localdomain>
References: <20230315111842.1589296-1-razor@blackwall.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230315111842.1589296-1-razor@blackwall.org>
X-ClientProxiedBy: FR2P281CA0131.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::14) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|PH8PR11MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: c6e6a0b8-0037-4a9c-c2ba-08db2565a43b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i/MuCNWJxlomS6+gw6jF+hEBXP+gSDc3pbNhTLx2SQWKUxm/ZqrBgCjJNSpMw6s04gQ8KXyYxoYAMzdKoC4NTcnImA976iBfImUwPBWwHyhcptPuLmJtOAn6iNMVAmZncsgmpUrF1CvVwkvikB9zXQdq0FV4wXkD2z6mdU7bTia5/cHxAfHycfOsaK3OCD8q0P5fe83e9RMp+pX2LZsdg+/U9z9TH/xenDoOpOiYI9mAdsJpw6Vuo1zlvxO5CDiMGFyIOdwIdUoiRlqfBizQK7gbCNvg4qD+x2P2YLFbOHPsRqZt5naZF+fjXeO2RQLfj8TmqSNT+1mu9hRGe6ujkmTR5HtDaDPb9DwkK8JM0KFnlUh1iqvsrkGOCX8ZSONFdY54Ffhs0yRhyimgvwuc3oDtVIo/zfDBZp0AxGuH6FFJI1SuWPSPNtE6SmIbKUM5nEUb+Vb39Np+LqTr2HsdJBfybOv9NeWHBxkI9OzT6ZHb4hCDjfeU9W/1/ltLPKMjsvZilQOCTG2Oi2nLjamO8F7n+BWMlY3pxxRLarSGTGksD3Dp32lqVWma/B9ReIz2BsCdwhk3t2RQp+UGWnQhhGUleq5kDvCavprDAgYXpkWbOM3TFKNoXmg54z4f8y6MCaPTnkqd97j9hJ8ZLJU1/vShvDqcqpT4pyxyeUtpDxiZ35E8EE7cCxkZIoLh07PB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199018)(7416002)(9686003)(186003)(44832011)(6512007)(26005)(6506007)(8936002)(83380400001)(6666004)(82960400001)(2906002)(38100700002)(6486002)(5660300002)(966005)(66556008)(316002)(41300700001)(8676002)(66476007)(478600001)(66946007)(86362001)(4326008)(6916009)(99710200001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ej5mS22rxDq3GjYFLJOrIABHM83pI9Os/C2NUGRG5+JwKe8BVHkQytViFXVV?=
 =?us-ascii?Q?UXNqCH9rYxqxLEUNSFfL225aUbat2cYieKKZ1DNbPdFDVxzqzcVkuFFs4TZ/?=
 =?us-ascii?Q?6RhZMU/b8d9/7sNa6z2aHK7JmrI3lgWLMfLI5Un3YvAg0EpNZBW9/qsj9poI?=
 =?us-ascii?Q?Tey7wHNHV5u+e89035usVjUi879ZPehoW3q5BlJNHI0WqneyER43d6jm0hjc?=
 =?us-ascii?Q?mRbnX2oo0Wg6yaEkD9LkBm7nCZ1zv5yP8K7GPFQru2De3oJ+VIy9xKvY1wSm?=
 =?us-ascii?Q?aKdWUJzWgNIM0FGhZtuRuyEb1xNl2AojhqH+VkuR/Qsv2J0RgPiaBmWCCgTM?=
 =?us-ascii?Q?+/b+WKsSO/7kxnGmUXgrQhJPzEcFI8FeeRkCgK0+bBocg2fFcMtoIjcE53lg?=
 =?us-ascii?Q?d2WT6fOCKyJ8B0P/4U+T15fFFPTkwlX91ZLhUUg3GiuZLeU73HYn6q9HzfWN?=
 =?us-ascii?Q?Eq/rpnz7O+fVdMtfGbyDe/71f0Z1MKyn3IK5aCKq40rWr8fQ6Tg0ruuiVuAv?=
 =?us-ascii?Q?1Y6G8lAF326mviNdVw3yN1vZZw4DJqzP7gVUFz6/mxKEr4RlD/VAyDsRfPi2?=
 =?us-ascii?Q?K9lzYlOE+NbNPlELpm2oYFa2Kef02evFbjPS6meaQqbRRGKFAZ3XCpRZ1suj?=
 =?us-ascii?Q?9XqQpJFE5XR3guI8U0QV8EQfMAoAbYSKA/shuXpLHjnDavKYaHrwzZAD/QqF?=
 =?us-ascii?Q?UOSFOXFyQbeFBCHJVp0k/ny3LdbU8FZGc6Ys6gr1kkH71m6TAbd7oyG3dRHz?=
 =?us-ascii?Q?Y/x3qDwv/KBZbvnlTp3gjqiCsqlWlewPUR6aIW6eGa6zgq9W0arqgSgxHzdS?=
 =?us-ascii?Q?NBLX3uK5ARvjoJMTsb6BkWu5w6IExtC8apmuCCxc/eizYaLAYBwdykxWAPEk?=
 =?us-ascii?Q?A/0qaxzm1bsok7b9kzOedecw2av/mc5B6+zT/m9HpT767Wfcl9Z0BiAvyFNi?=
 =?us-ascii?Q?B+WnH85W/NX1g5U84UGVSGO2fy1Cyl+clFFic0jtR+AXM5l0A3E7oEprWjSG?=
 =?us-ascii?Q?dxRewOAHi70nJb1nyzs4UYZCTgL0WCGkJtdUxhJ3hxLAKLZqVja2Sa1BXbqF?=
 =?us-ascii?Q?WPZ1k6siWyAYSSVtu13GWjF8lMUuk87rWYWW/2i3DiJ2N0yQrIcKcsW9pcsS?=
 =?us-ascii?Q?flI47Jv95NxHLwbWfopcQVUqeHVYC9hlCO9m/o+FQRizyyub1c/Z+QncTv4L?=
 =?us-ascii?Q?95j4g9+39Lou2S72wWrU5K9Ymvp+fFl1GrkcYF9N+ZNvkOXk7H7lZ5DRCh7r?=
 =?us-ascii?Q?v3wqFNNnEVKEwqdxpXaIT7upSzwj5w+ilucnwO0Odtusrio2FDbRY9PrAoMp?=
 =?us-ascii?Q?uv+mhDQl6C+Fx+of/g+/twCQQCtv8vOy9Kw2r6xfxYPTQnxoYRINYnQo6Jbl?=
 =?us-ascii?Q?LX5IiOyKyp9D3woZS9c9S3sxedNBFDlsdZ08WE7OS4vqc6K9UC3JsjzIdZaC?=
 =?us-ascii?Q?kEmuzqT+Dszh9Ybnqu06iPG8Hv6O8rnzQbgKNkR/RqsAzY589ziSwiD6mgiQ?=
 =?us-ascii?Q?n+DvnT7Z7uH1dS9uB6Wf+fK9E1mPdSbbleqEleb5z2zWXErrzDaKFbux35Ft?=
 =?us-ascii?Q?lbBRj8CaPhCjFsO9fZ9ftvNwhrq2SmdqbOsihElL1RUdjiInYEFMq0uOwNua?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e6a0b8-0037-4a9c-c2ba-08db2565a43b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 14:57:48.1924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /u9vZ5PxNOC31fQNyANYuq5BZMKwlhIAPpmFZd4yyVceCdn9ms2vdoEH7VHvZkKsJ2/pSCkKxtA5btvCjLNhnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8064
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 01:18:39PM +0200, Nikolay Aleksandrov wrote:
> Hi,
> A bug was reported by syzbot[1] that causes a warning and a myriad of
> other potential issues if a bond, that is also a slave, fails to enslave a
> non-eth device. While fixing that bug I found that we have the same
> issues when such enslave passes and after that the bond changes back to
> ARPHRD_ETHER (again due to ether_setup). This set fixes all issues by
> extracting the ether_setup() sequence in a helper which does the right
> thing about bond flags when it needs to change back to ARPHRD_ETHER. It
> also adds selftests for these cases.
> 
> Patch 01 adds the new bond_ether_setup helper and fixes the issues when a
> bond device changes its ether type due to successful enslave. Patch 02
> fixes the issues when it changes its ether type due to an unsuccessful
> enslave. Note we need two patches because the bugs were introduced by
> different commits. Patch 03 adds the new selftests.
> 
> Due to the comment adjustment and squash, could you please review
> patch 01 again? I've kept the other acks since there were no code
> changes.
> 
> v3: squash the helper patch and the first fix, adjust the comment above
>     it to be explicit about the bond device, no code changes
> v2: new set, all patches are new due to new approach of fixing these bugs
> 
> Thanks,
>  Nik
> 
> [1] https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef
> 
> Nikolay Aleksandrov (3):
>   bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type
>     change
>   bonding: restore bond's IFF_SLAVE flag if a non-eth dev enslave fails
>   selftests: bonding: add tests for ether type changes
> 
>  drivers/net/bonding/bond_main.c               | 23 +++--
>  .../selftests/drivers/net/bonding/Makefile    |  3 +-
>  .../net/bonding/bond-eth-type-change.sh       | 85 +++++++++++++++++++
>  3 files changed, 103 insertions(+), 8 deletions(-)
>  create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
> 


For the series.
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

Thanks,
Michal

> -- 
> 2.39.1
> 
