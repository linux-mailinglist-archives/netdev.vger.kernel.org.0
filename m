Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88922632A71
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiKURMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiKURMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:12:02 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BDEC847E;
        Mon, 21 Nov 2022 09:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669050720; x=1700586720;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VfDyM6/YWJGyVSVeCdWyBhrmUi2F3ZPSWOcon5pkTcI=;
  b=gpUUEwOSLdk+ogZ/LtjuLp/q0jXt5gey6W+cXs2JPklHae49edqBG3RI
   1UNuVHK74gZTCQhZgCZHDjzv+TkxZDK+gbH3OXNcjuRKBJMHVUQ/uKdH1
   CEgF0Jo5oV2jDLo4QtJEdEDiEVndlsEvtfOg3jKokOKr2508kPuvRs3ne
   lKQzpEF0wmg2n0UUe/p3+5iAJfu3by5o1ChlZ3oK+foG2iKLGRYqSHjOr
   7BJFPt12MyoZVRyrHwCivAU1ZNbfjnh5FdHeDGzCfx6z9R8mZnmN1hVb2
   /V75AvCdNee73ywTaoOJ9QdkIIH2oTXXXkSQN6jEI7zlDGngpba8CofZd
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="293320177"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="293320177"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 09:11:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="618894470"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="618894470"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 21 Nov 2022 09:11:58 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 09:11:58 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 09:11:58 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 09:11:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6xTmwoNHMoeT4Tn2qkVxVgC0hdtcWhXyWFfekg3nFO2vnPAdIRiPTx47vROAZluJifByVVmPeL1BwbX7ETqaW2+ED4OcQ6u8Oy54GS1qX3Gm3IAKR4Ah2jyrzQ+tR3fwGffWJ8sd0fH7ngrKMvRCjaaJbWWEdMSmW8QxNv3NUj3EoAgeQs5hu79wNL4gDx8i6FovRosfyXYJIKgnS2aWwBovBnbHNiOQH3C2lSPoDFohRMd3eL34GsamBYippxTdT12PdDb8uvpHMhZpEANsI71wdYMKWQxt6sp2dnZLejrI0xT5IXEcxXKLHF3hxaIU4tkhwxzVfVpsNwCP05zmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=teK6a1tQk8q+3CXKtvb+S+hpzQy/Lfeh8kovYfpbc2w=;
 b=Z7Km9/LiAPH2BeCivzw1ZKBNCMl3twBSFrdDuY6o1jQzNECiQ1+i9e5DhMG9XSxss8IpLibFqk2DN+Eny7ZsULsw8LoLGSxWbPqumN3JK4FHrW3i+hsGemm6YchAMkU7k9aTdvcv7yakgt8ebnLh2OSECuOZniKdqi/DJvIFDqKDE+v1Ows0KngXxuW2GKW9s18ck5roz4ays/EaAL1lARZjbjqDqJeRgkvFnOj8/rjnPiZTGui4j5LFQfqnvKzmLWMfypzWmMs/a4kpRzUhRXaU8HsFA/azX/msSzfFxGkn/Fyfk0B1XSO6LsXLoI43gpXunjXfwBtfpO5JZKEg8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB6332.namprd11.prod.outlook.com (2603:10b6:510:1fc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.9; Mon, 21 Nov 2022 17:11:56 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Mon, 21 Nov 2022
 17:11:56 +0000
Date:   Mon, 21 Nov 2022 18:11:50 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Roger Quadros <rogerq@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vigneshr@ti.com" <vigneshr@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] net: ethernet: ti: am65-cpsw: Fix set channel
 operation
Message-ID: <Y3uxVncNY+ewcsK/@boxer>
References: <20221121142300.9320-1-rogerq@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221121142300.9320-1-rogerq@kernel.org>
X-ClientProxiedBy: FR2P281CA0133.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::17) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH7PR11MB6332:EE_
X-MS-Office365-Filtering-Correlation-Id: 6aaabe2d-2b7d-4b19-160d-08dacbe37e7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: onvA1V7o2cJcoDb+U2klXUt4fo8OUBZXxMFJh3ov05SFNg761ikhi66wsFmwQM7HLtUSV8cW9GltcrCk4nUrZylLW+wjmT+8dO9E9fQMMw0t/nk3MWFDk8UDq7LtAOl8TG4mXUfgwdyvZGliQcKdnXKSVuY2Qyd1lVbEHmn9bqbvXCfZndXGkduVAwsmyOqnc/sF9exl7GHCVkg3wefhVQgwU27pmPSgceODzn30N0NmeYvhXRzA2mtDpyatdJYmT+dTt+nshUzbQBjVJ1WxrjfCxYqbtOQWIACKoQpw/y+Y/s8j9s6CxVKJVcv64LUuIEiqfdKyg5S8jxoNKUh5FSgg1vg68x8/VpxxKr7+ZCE8sG9vn6wR/tlCEu8ssupuYERtwVHhEji1W7ZAL7940xu9KPhNWg1XYTU1mDzVw4dwj6niSSxVsapc6D+oxttvvPHlsZvZ/L2yH3W4lRJ7GxpOwkue65w49IzrSKP1Xe0J9GJO61dWNqBA4i7kLIcbK4dBHOM4iLw7dT+oKm5k8DiVKdoSiiZkcyw+9gSIKyqFmG28RgHzMpPInSSz2FHmGPoX6LJUJW5pmhMqqvjgPrhwGX4lbZu38cMGW/dFW2WEiBTMLZHB9xg9osDYvcMx6mBvoMOc0d2sPyXiOrQChg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199015)(6486002)(66946007)(316002)(44832011)(6916009)(478600001)(41300700001)(5660300002)(8676002)(8936002)(66556008)(54906003)(66476007)(4326008)(33716001)(2906002)(86362001)(82960400001)(26005)(9686003)(83380400001)(186003)(6512007)(6506007)(38100700002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J2zF8y1JwxXV7MMeGn2V4aW7l0fiCHcbxXOLG7QR4Yd00n0zL1OKMs0aJ5sO?=
 =?us-ascii?Q?jR+jp6WkBrdJSRdZQu2cziPoYyNeN/AH9BGvZfUM1HOBPyfm2YUhzJUE8gcw?=
 =?us-ascii?Q?8TPJo1Rg7Vcg9m7M5gUZeUnyx3jKb8tHAjnIpo8/SgqNRwGf3uf1UEVG49rT?=
 =?us-ascii?Q?heIzcNNR4Kz7lBgw9Iyc7/I2xQSFNWzMWr5oXJjCpe5Rjm3A5oAVMpOVqF69?=
 =?us-ascii?Q?Lpd+g/iZQvUWr+aBsdEV034DpA6YvbGNP3BvFnO5qM89K+FySw3p514nYXbU?=
 =?us-ascii?Q?qZCeRpAb2bSKf559u4klCryMTC7uiYtYl26YL3pIoyN4O8/GF3f1OgLOL1uD?=
 =?us-ascii?Q?z/sZbnaT0bqEkoNUtSSHQ4wR1dSMqAepOZO/ivE44uhP3ya1mViSUUJgguRS?=
 =?us-ascii?Q?Jjnu/+oI7GrQRNZIamEN1vOxxigb1hPzj5a82NR5qezozrwD6M/Zf2epdWGa?=
 =?us-ascii?Q?dFsxYP41GAqfC6GXmqYtx/2NjJjOWFOOIbEJaOB/0mNFnBDnlfqTBu7IIz8l?=
 =?us-ascii?Q?YdKIFYHNgH1/PeTmuSG1UaoYIZKrmawU8cQhZcDiP50brqzBdilVLIEK1R7e?=
 =?us-ascii?Q?RXS9ybSOzYUujo+9NuK+yxDV8WkYxjmFXO2jye9HL9MLuInKBGXXupW1ryDq?=
 =?us-ascii?Q?0xA3FyhCMCow6MbAvZlmrafAmz1qvWvzabTFwLKn32vKnQavRS6msYccymmd?=
 =?us-ascii?Q?vPrCb+1BSV798/+Xxk0I7QKrZqE6pg/ZjL0kdRCv1tQum/7YQbHNEbhmZe76?=
 =?us-ascii?Q?DbA9aEAd7IVVeTVKV36IvlPyrNhsD6miDdV0vjcullPg6tvw6Amio4FZuw24?=
 =?us-ascii?Q?MCPkp2sOEs2zAWlmSfUQ5aW38k5ckzSWL3OBzUySyGO3ppASo2fD9/nMrNec?=
 =?us-ascii?Q?hiYKkFv0mreD4P5IUwyN4yS/ZE3wdwF8P80TKiZq/vjRoeb6IM/FIVR7x8K2?=
 =?us-ascii?Q?R+bcycr6ii3Roka6OZ+kDDerp508Hn2jXj0Kr7zLg9s/bYhFnlW4x9wonxfc?=
 =?us-ascii?Q?m/JKPuErjWhOTjdIcT0pH1y5hN85j8AGq46dcHBRJM6EJwE9VlHE4pIYQ0H1?=
 =?us-ascii?Q?JNPwgT2+Y5D4GvJhNpav5LSZRfybElzrWiBdjhE2VfXt6lmWLWNaAwnhr2Ae?=
 =?us-ascii?Q?oR/QI3Gv3R3gDVvR38lI2D0A1nBsMlI8lJ3jdZZJnCAi3p+Nsd8xl4zKq/vz?=
 =?us-ascii?Q?iWQD+7uA4VroGE7+ptQ3uasGMZVn0BExs8/PctnS6RfX1htz7GMRQM8+1Hys?=
 =?us-ascii?Q?wKvjiaeyotmfi7G7OEeotUAl6D6F6jfKO2NIRWRHCG+dCfyiGY5+BtNpptzi?=
 =?us-ascii?Q?TE3TWPtx8YqpAixI4QQNinYEiMByzgbs9QelYpLyz2F0+IrfG1wYzFRbjSOR?=
 =?us-ascii?Q?y59dfsr8oCrXCekn2xkSA90BgKPDfZszirwSCR859hQvfz/2pbM9UH0hM3D8?=
 =?us-ascii?Q?j6VAC+Hc8bj315wsMKL+k9vhRcAb8cktyV8ahtfCiRXkB83QN8cReMXVLW2j?=
 =?us-ascii?Q?Y0bV6byBVDPxFZez7qQ0BoU4uX1O6179X11C7ifX+pKYMJVzHasLCGu5aLry?=
 =?us-ascii?Q?YjlbZ7l3e51S5AgvGWE61ok2XLoSHB4VqOGFeheVCe0Zn4rZ6x16ACaBGBjO?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aaabe2d-2b7d-4b19-160d-08dacbe37e7e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 17:11:56.7647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: he5HL7hP64mcS7gwqtfs14ol5tNvHz1Vbg2ans2kVB1QPI5qsafFMScVjR+6r0kzm6KkACdyRuMiKm1KG7ItdqIZ1U3BCklh/S8Wz3fzvMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6332
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 03:22:56PM +0100, Roger Quadros wrote:
> Hi,

Hi,

> 
> This contains a critical bug fix for the recently merged suspend/resume
> support that broke set channel operation. (ethtool -L eth0 tx <n>)
> 
> Remaining patches are optimizations.

So I think you should resend and specify which trees should these patches
be routed to. I'd say first one goes to net with fixes tag and rest should
go to net-next.

Let me take a look at the contents of this series.

> 
> cheers,
> -roger
> 
> Changelog:
> v2:
> -Fix build warning
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c:562:13: warning: variable 'tmo' set but not used [-Wunused-but-set-variable]
> 
> Roger Quadros (4):
>   net: ethernet: ti: am65-cpsw: Fix set channel operation
>   net: ethernet: ti: am65-cpsw-nuss: Remove redundant ALE_CLEAR
>   net: ethernet: ti: am65-cpsw: Restore ALE only if any interface was up
>   net: ethernet: ti: cpsw_ale: optimize cpsw_ale_restore()
> 
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 167 +++++++++++++----------
>  drivers/net/ethernet/ti/cpsw_ale.c       |   7 +-
>  2 files changed, 99 insertions(+), 75 deletions(-)
> 
> -- 
> 2.17.1
> 
