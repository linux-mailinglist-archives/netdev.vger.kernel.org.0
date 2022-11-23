Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A9C6359F5
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236448AbiKWKbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236429AbiKWKbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:31:15 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014714E410;
        Wed, 23 Nov 2022 02:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669198540; x=1700734540;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rIZ2gnend6eHsDmrijtkLlI/9Ud3NzV4WbSr4P8UCqc=;
  b=GDmvniFZeT44KicKELRenoOj7yUr/Cgtv9nBAGEo5lIivl60eyzUOunV
   qxzNOGyr6RnZrmw0jJLu+ViT67CVBwAgdv2vcXME429e2YSMQcIOnQRbm
   clAWjMUujIZh+cfiUnKHeCE40Ri5CluwhGpW/ifmDPUWhBrCq+f84VNGx
   wri7fj8MrFvcJvh60GDtX1NthJMjRd8cdudra1FHgz8L+pnmOx5vWQfB8
   kWwyt9yqPivRttu8Ssp3YjduHmoMLvZ5OqAISqLSok3/bEitBDH0JqGbc
   JgpsDqk0I0bMhkh4idREXwW0XZ5hz4g1HE12zsRtlupEmXFIQSS2gHEw4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="297392061"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="297392061"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 02:15:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="784196733"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="784196733"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 23 Nov 2022 02:15:39 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 23 Nov 2022 02:15:39 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 02:15:39 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 02:15:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSVLEtHsCttNdUo+tYZjGFZQsiIm4FhBJuZS+yRL7vVzV277xVHdlQYS97IwUND21xCi/dq+XAehJ9s4K0dSLrWqguLYpU9PtTZelk20G4xQJmbLNLYBw9awVS4tjdx0LqVhh0IVgBewthvtnGDS5cvh4q+xowxF0t7fDxEURupqEr0urS7qGqsPoiAd3/gRnRdDAXKqdRCtzUY89yqO9TRBSyCwimo0pMvyj5fIu40k8SlFapn6X+4iyinZdcq1NKwZr1+wV+Ywp8HHMV51vGCQhxii3u/IjlzPsNicgCSMvmitek3nC8Vyia/TKRdlR/PkhWbksrUnymKOW+S7dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QrLXk8I/yR2l7WalXQmD7x4joh2kSOplj4G83QHUW0A=;
 b=mJNW9oWwGykT7mzEQDdTdZK83Okp53FAwPL2vkZ2cEsIjbzhqIROMb89Yo0ekbr7/RZgPxbjhpZU+TyqYglUKS9zmmJfh5Q16ryI2G0i6VnEy69aM2PoOmcR/hArNK96qJwErKXHMzFxAjngpB2rtAjuHTyPSJtn9WP9ZBC2V3O2GwOgza3zrvMF6G2V8HrtMOULQ4b6AZNHfHWnIVftPs8B/0k8X01VmoDpjlJ5T1bUpjuqIopBZ1qDhVd2bDGEW/wMrBEmCDJ3erv7SDHs32N7uR85X3BLFlAanoaczqibKOQ86EKnH4fLxpckZbqr9bP53VxIP0zRmCNOO1oJoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 IA1PR11MB6514.namprd11.prod.outlook.com (2603:10b6:208:3a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Wed, 23 Nov
 2022 10:15:36 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::bd73:eae0:3c7:804]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::bd73:eae0:3c7:804%2]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 10:15:36 +0000
Date:   Wed, 23 Nov 2022 05:15:21 -0500
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Will Deacon" <will@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        <iommu@lists.linux.dev>, <maciej.fijalkowski@intel.com>,
        <magnus.karlsson@intel.com>, <larysa.zaremba@intel.com>
Subject: Re: [PATCH -next] iommu/dma: avoid expensive indirect calls for sync
 operations
Message-ID: <Y33yuSmiMPr6IOet@localhost.localdomain>
References: <20221112040452.644234-1-edumazet@google.com>
 <Y30gZm0mO4YNO85d@localhost.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y30gZm0mO4YNO85d@localhost.localdomain>
X-ClientProxiedBy: BYAPR11CA0076.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::17) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|IA1PR11MB6514:EE_
X-MS-Office365-Filtering-Correlation-Id: 461797a8-10a0-4a18-00df-08dacd3ba991
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ixZMt5ZoUoic5Chhyq2Oejl8aA8tfOKkXsE3sSmGLYMcEoL922lBnC/tZiN/pTBz45JSQbAmw5eLTxxomi2vxRfSEDHqJd0H5r9SwavXKO7DxDkbQrZNWZwAxjtpfcaDW+EdjCJwoj3RpaoY/F46L6PEhmdOaK124UbNKOVM7/65DTLYfQhg8+DXECurK3qb31hsJvsnYNo2lHF0yJLcJPghW+NaS6AQL1qYM6NEbm+Efnfzj6wq+OmfzvPGumxSrPJWKDWbyOW6KsubwZsqSfStKJHi7o9x+xSoj6PukA+vWR2URurQmCivn9LsT1g/RnBRr2tbW3yMWGUujxmBrTWU4kZQwXRdIGxhb5vBzptlZ1LR/FIf3nCdteKnnv7hYJwXUERm3qRvx+gacp/NeOMbVr/nobr3U6kO7TX16jnYKfgmwVWwxcShjrGVUYi7aerVE1tuxGL5JCjGCs0EKaqlaEjECqpas5oQvys3kXEw7l0uYdko+FD1oAuRPb+918fIbM9QHw5rwFl6oNqdrZS4Yl+1Z2v9tPHGlzUUMrvQ20n7FuHfdiSB8SkyX4WZiAJe+wIzXFFUt3zrBAYWDHNB1KUqDNBqUbQbvelCTfJ4dEeB+ceMYGTEjT1kGa6MjLj7wEPPc2ihwbQQ3jR/Pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(396003)(346002)(451199015)(38100700002)(86362001)(82960400001)(83380400001)(8676002)(4326008)(8936002)(26005)(2906002)(4744005)(44832011)(66556008)(5660300002)(316002)(6666004)(9686003)(6512007)(107886003)(6506007)(478600001)(66476007)(6916009)(66946007)(54906003)(41300700001)(6486002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4YyxXeDWxrywjAShtA2va6fh/xn0r2KaM63L+Wayfm7rqsRstPfehvTjcyN1?=
 =?us-ascii?Q?ipWPwMX0JZSmzJqzpdp89T6kBHdnnFvDzVoFjw4IARVxCZGJl5m7ESn3JJWL?=
 =?us-ascii?Q?2xeXlch8u5xsHxW9lHoWBuIy7XTCgsubeGURzY2bf+euLQQu4VZQFIk764ta?=
 =?us-ascii?Q?IxmgLzLzoVBpFgHbUOl1MlcpA2F0FlOYm5ihLGBuK/nFhn2HerM8s9m0xaSH?=
 =?us-ascii?Q?KLT2w6A0KoA+1hGpKGfo11yOlNMVJb1haj+Z3i+YLMjUMa+5idZoc4P15y1Q?=
 =?us-ascii?Q?xwfm8D44N6VmYu2X0SQxdk9gORxk1GOKACx92c1+2GAjw6eGk6rZDA/hEbnV?=
 =?us-ascii?Q?LBGCkKpoG/byA4DX49S08PPfCOyrYwMx1fE7qM3EtVwnEqPvTe5xnxJvXjFl?=
 =?us-ascii?Q?i/jyzUoUUoSNhj3dMR7Vg9ECBpYGqw2P8vo3aoShOm2t0Xp09utRzyEobos5?=
 =?us-ascii?Q?06VKydE3LrVYrBS0U5ADM3eI/RGSRv7KQYQXoUCg0LMdk2+bM7jfKzq71Fc/?=
 =?us-ascii?Q?GGMEOCVSSQlwdaTDKIGYKpFwJM9hC3RsRETe/vRI9GIViMrczGkrZVI1AjWK?=
 =?us-ascii?Q?I/17oWDBRQA50Iryu2s/4mP1Jh7lwLD7hNEMS4E/gyXNIMmipkW3S7JtoiQD?=
 =?us-ascii?Q?CNqYNPl26bGNyUz1XrF51hxl9pnCqxVoAWIkRa9ZAbefo/KjpeHEZ8LllW27?=
 =?us-ascii?Q?RObeBLLBT5yxmrO3ZI5VnJV2prlBTBbTvalfZe9s409SjohERH7adudaPZMi?=
 =?us-ascii?Q?FObYtu1JJnxl/GEK5JSsC1/Xl/YDdb5n+Jxb0IpqWthsWrqcsW3U6ZCWTdUP?=
 =?us-ascii?Q?+pN4QThCEhsESJ5bVIhMlNFmYYfYt9vBj8Y09qhuLj2f/Odn3u8vXJvPA2A/?=
 =?us-ascii?Q?YaXwLuQo6um0UE0Yyh0PcoTG9zGhj06FZ2IHKkiCd0pE5I/WeZZt/VkyyMvA?=
 =?us-ascii?Q?fgAMrVSl0Mw63yl/CMRQsZW1CixlZ7Bz4rb0Zo/vDMvYSEDrJC7k/7sAzGay?=
 =?us-ascii?Q?B6IR+iz8A1RWXVPASMpikN2gSIxAKSgStAIgU+cUkGcoNAqBatTecUBpcb1Y?=
 =?us-ascii?Q?Dc9x0AWz8rXAa4HNrAwBY/HB4bR+5qrXBndtvU7ZTbVCm4UBij/ZFzMv/Uwe?=
 =?us-ascii?Q?J7Tf8YN4hdNLLax+XDdHX7EeERXAt4767fnEu7qAhWoo3gKss86ucW2xyazL?=
 =?us-ascii?Q?Ekoi3htBTHd1cPjn1uyQjTAF+Ylv9e1eoKpgJwdOIcDQA/K7QUXfVj43Vmfp?=
 =?us-ascii?Q?fK6MVgcSaWtsHQcBqDXkTqx9qULlI08NA5HR8WiNZck7mkYHjznJzjm1iQRB?=
 =?us-ascii?Q?bOayYmKT/KJCxu98L/a4WEge6GcBkm7A+/4dMA32P5fL4dTaeVDaxSK4xu9W?=
 =?us-ascii?Q?HVyISwwvAB5WYd/tOulzxMZDdpSSZoc3SPbiLbcVgWIOkfFtyMQbA9A5rj4Y?=
 =?us-ascii?Q?tDeuxO78qGLbbLT+XXq0yMkkU5lDAIBL7+AhW1UZUQHh+rebTmPJHckZqP6C?=
 =?us-ascii?Q?GRcgu0MVrAZ7XrlD0xiJOlyS/jTxuI2Qe0FuJC/a5HjEwe9TPZjb5MqUj7Tr?=
 =?us-ascii?Q?sg6MFD/ymdsT3CoVlDuvFR/qtgInScgAUBVo85Ic9YE8QoODSLJOWa9qS/1j?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 461797a8-10a0-4a18-00df-08dacd3ba991
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 10:15:35.9525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C5CF1/mUQHctXl7xPZkJViKECDuaNmuCcIhv943kPY7WbYEz2Wxhl9k9TouqQ9v7nVy0HRQJl7KQWTViS4q9dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6514
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 02:17:58PM -0500, Michal Kubiak wrote:
> 
>  Together with Larysa we have applied that patch and we can confirm it
>  helps for batch buffer allocation in AF_XDP ('xsk_buff_alloc_batch()'
>  call) when iommu is enabled.


I am sorry I have forgotten to add Larysa to this thread, adding.

Michal
