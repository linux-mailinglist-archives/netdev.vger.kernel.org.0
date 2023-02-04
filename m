Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A56B68A996
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 12:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbjBDLJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 06:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjBDLJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 06:09:35 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F71A4670B
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 03:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675508975; x=1707044975;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+01KjNtYNn2AWoTN/N5k+6EniaSPSYZqB38Lt+12UZE=;
  b=WrxszTq5MEee3zLd/H22fLFCINnnA19snAx51wuzxfgXoVVF8mnVhU6V
   sDpag/QH68mj1i5kTWdEG0zS2GDfuHxvVkefqMUTB0dMUGH44D2VmLalA
   UchMhzo8ZJ03TLELv7RMCrrKNU2JBw6iFllIEsXtMm4IHUegRWwCaNzI8
   T+/rqpuqf41ucDNRdQiM2L0STzERZ2LfEV8TSk2b/LD5bPob0i2z3GEOY
   4g6R++4/2IMqR1exu9KP8h6pAXVg6hAwSWb5a6i0QhbVPf7tyyJMee9xG
   nsNKiE+xxoINi9O4b/+Za6LFWRBqzOo4AvJQ2TI8kVXDAK5yMBTtJozCZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="331065139"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="331065139"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 03:09:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="729531397"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="729531397"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 04 Feb 2023 03:09:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 4 Feb 2023 03:09:33 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 4 Feb 2023 03:09:33 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 4 Feb 2023 03:09:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQ4lGdhgNOkMR+wrknuLuOnj2ZHNsAAue/9Jx5EpN0Za+MDwo6e+nDtMJucC1FZnxhRb1QRoHj6X+MbMwF1TepFUpwrKf9O67ND6dq1DhEhi/kzmaN+L17KW2YwClaru1kbEMi/8+oHljVkTrBb5c6qFRo/EKJGLHmiROAJzwxTpxgIO80d/Jgb/eBiG3fZMX8n+vdnrykMmdAqkNB2OaYUr3wv9GuA8eOl4iwYkuhEAwigBcm3lDk+QnYy4u1Pell2BPuQPftZmKKY6m05wW2uXfDzdK7LxXrTQy4Us5bOmaKRVM9R0dck++UmhZTIbDIEzdgISqv4rYISbHSXPBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+M8wwJZTlRKiE/Tkv/CMOtDZ3eol1f5XrDXWvio+j4=;
 b=dO3wg2YwBTMY5Zl+SkzBHyaUmlP8hR73/iAx5on2uZIuxPxqbpf8cglnUklMqA6c7QC9X6X/Hidu73oJtW02HpAroPz9MfBxbgX6JEwBmVyeYrR/Kwv+U37583oPRbK0Sw2SszFcYsrD2/HB+S1mQWWzosrmSsCBqtuSZrg+DcF/bxFpowan/y0ESoTXGj9xZ9IlC/V0MzZTR3HIYasAVJoEUK0wrptazYgu5puZGP5USLMGjrDZI9Yi/X4oXbey4Uq5UdTSkjg/MHnm5OUMd/cwD0hRgw615oyPSRvNMFLlveJ4GaeqjJtjmTqALWoMXdSRPVFoTesV3/gaeQDBZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH0PR11MB7448.namprd11.prod.outlook.com (2603:10b6:510:26c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.36; Sat, 4 Feb 2023 11:09:30 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Sat, 4 Feb 2023
 11:09:29 +0000
Date:   Sat, 4 Feb 2023 12:09:23 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Shannon Nelson <shannon.nelson@amd.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <drivers@pensando.io>,
        Neel Patel <neel.patel@amd.com>
Subject: Re: [PATCH net-next 4/4] ionic: page cache for rx buffers
Message-ID: <Y9484wAMzK+byKeq@boxer>
References: <20230203210016.36606-1-shannon.nelson@amd.com>
 <20230203210016.36606-5-shannon.nelson@amd.com>
 <20230203202853.78fe8335@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230203202853.78fe8335@kernel.org>
X-ClientProxiedBy: LO4P123CA0139.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::18) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH0PR11MB7448:EE_
X-MS-Office365-Filtering-Correlation-Id: 23bc88f7-35c4-4fc8-f466-08db06a04924
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FrTlQmTKm++MbnFHP5A0gId8cxaJdzXAeVtZzUIuSVojztrI/A3bFb+1qc7qTZSQFJJluycYO0GVOLSnQ06CWb/EOioHVMQHPG36w/3erW41UKyfgzzoorvEdCtK3AdkIQASTR/4rr8i7YoS0UFN2to5t5B7lncnQ+VpaavkbPuQWsBYe12RJ1ByxjBxgsM7MJ9vKE1wfNBKoNep9n9oI8MFbqLBRxe6koeMTpH/EPvb6G1lIATEjQp85+IWjQ1sqxmrdiy/8ic6Uz0RDoRFx2r33Y67tGtT3Zr8w2F7A2yNTi9fQ5GlNk311uG1xAxhc5Z7h4nPyLYQStgRiGpBXri8o6/ks82bc7157chCqJrCWXSvGMTxeJMjeEo1DLRtB3n2rfNlC7AG3EPWRKIhTWrKfuDiVqGNgDylqUsqSkOhSIQoA0fZnjyHTEE/PIqyiUdfjre/QwGhU5EQcb5Cs5dH4eG3JipnLnDOipD9EcJjGP8j0nESgnWehCCNupCPr8aWCEfzxs6aDeADCcFgaIuopJcDBpmwEDl+ddtsZnkak2rG9zJq6b8YSk8eAkmjI6hcoy3vTCXT/1a2RfUd9w8Lz8YSk2GtWPo1Vyhf3v4y//P+dCDDalnvBIOSDct5uRw0q6xQZkD160/hc+UkyrGEwN8jZxykqHDHhAiEHBScYFvxWWOilmFDOaPoVFH+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199018)(26005)(86362001)(44832011)(41300700001)(4744005)(9686003)(6512007)(186003)(33716001)(6506007)(2906002)(6486002)(478600001)(6666004)(8936002)(38100700002)(82960400001)(66556008)(5660300002)(6916009)(66946007)(316002)(8676002)(4326008)(54906003)(66476007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZrGHiHxNYVTvTQXeG81ZpJ3XGpRGlQyvzJePHEtrI7vFbmc0vrQt3kmZ7zD3?=
 =?us-ascii?Q?KSHA2EYyY8ijVgwy4+HxdgKEUFQo7qaTmJuu0O+NSLx6/vA3rb8WB2FDogvr?=
 =?us-ascii?Q?yreChH5c7BE9tFv9He89Y/o2ieLU0mBBHIeFcYp8EB4+KMs2Kw+670Uqa5ZK?=
 =?us-ascii?Q?QLES6juszMTcUcr88eC7BFK5gfsXl2DDBULnLNcEnLRbq5Sglagz03yc9Cxk?=
 =?us-ascii?Q?59oySBD3dYyZxmhD9dF44k9glgEXXneYX9B906WJ//jbHCqwxEJrSkozQbLp?=
 =?us-ascii?Q?d4a6gXFSrr2yaBCMDaTVm9sXa2X2XvbFIQXyYJtcs0mgRGyuuTBgzA849sEr?=
 =?us-ascii?Q?jkGUDFmD86tNTDJGPm4CjfraVeNvD/r/FMHMI87/udZKdNcn6R8n0meAL3/z?=
 =?us-ascii?Q?Kmjw+riqhtxemioh7N8SkMIk/9ndxuV4igHUrxMhsf/qmHi5G3aABpbsTb/9?=
 =?us-ascii?Q?EJdrSUyPspK3bcLeLIvMcf8Eh6N+GXf0KtKSvXpikWcGb0F4Zu+E9R0RgEyS?=
 =?us-ascii?Q?VXcCLqbTO4SCrOoqLor5BwWGM55Grbrknzcw70EcxQW3NHYBONaX8J/CHGZm?=
 =?us-ascii?Q?0ZP++nZiLXKu8SsVEF60cJvvDjozJPACFsxHKss9cyyS9/6nbcD0/nC2TjNa?=
 =?us-ascii?Q?xe/19qKaYrwdRjzOu/QaEozNL3ayXh3BEAbCOFs2rtGBbpvUkURwr343zUMY?=
 =?us-ascii?Q?3mhPzT+ystdmriVoxZocosC7E3KqUK3dV8WNK8vnAEUuycHGLGcuq/C2y1Mi?=
 =?us-ascii?Q?fHioZ0UfdYKzqT6ugd+SkcP+pauvbb1XJlhiIb2+Y7LnZsC35vjRGMa6bqAx?=
 =?us-ascii?Q?23kEhep6bmlwVK9eLvUHfEFVCAqhb8OKxDb8TsaC7IyIaETYzVEFZ5obHsIm?=
 =?us-ascii?Q?IOesshTXrR1zXgOEwYL1UWhA3YhzOvEBCV390dRSHpVzmTs4SqI1yWYDECPg?=
 =?us-ascii?Q?EaXZaf68ldb6qOP5hcXHKNwe39KQdo2hqWWZs+RmaiiCyfGvJ6DloneKp3Vh?=
 =?us-ascii?Q?VbqZ1LtiEqUmm/A9nwVu6o6aEOLd24q6uf6UYs4rMqEHJPiwhSdCCZJzUbx1?=
 =?us-ascii?Q?+G8FldU4RtTgi28WfzgvOHDGiA6ZEvSSlKYisjXh0rZAhKizfOiqfUkOZVgS?=
 =?us-ascii?Q?lyRAa7MW/vO0vNKh4LLax0B5vGBjEIIWztjRpBMHGtCVzReD2mpoa5Up3iH5?=
 =?us-ascii?Q?x/M4tu8KUkWR6pN7xThLxl5NiLN/eh2eySjRGDl/AmzOoHr58Ao8BgW4FyaZ?=
 =?us-ascii?Q?a9SnQZkb9UHImIQv+Gc7MurjpQF4oA1NLDtPn4BYpaSlGNnsr0yADxNTAfTV?=
 =?us-ascii?Q?EPI8TU2Z6d5ScWAhsxKZ99r1upbsRDm+0u7KFCO8e3n0/2Ol5JFIAxG/yDqg?=
 =?us-ascii?Q?c+q1YoCdSeyXjB+vuuBufytSduO17UfPZThimwLs0t149yRr8e53X5pNa1iL?=
 =?us-ascii?Q?SQwjxMIGGveFYJ+d8cUPRlLQmutCZ+EH9EyBDGloAbiSjB4P+ZEOYGYhBa94?=
 =?us-ascii?Q?KssDaiqusTv1Cv9bZ55WAERSSCpc0i8YZmKAkbQUjYsZarO1FFvE4kY601N1?=
 =?us-ascii?Q?WkL/3CefUHGjF2xQWnb0Z9jizIutpSbqkSYBd3WrTY4seRxVGSSBeLwsxuCc?=
 =?us-ascii?Q?4L+gn6nXjdPhOW1g7fO6TtE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23bc88f7-35c4-4fc8-f466-08db06a04924
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 11:09:29.6468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r83ww6FifCvRvBMBI8VOPkR5ONM407Qwue4EO2V7T1syBUWzPwmijfRKy0aimynRRDiSkVySmeJVXpLprn9n64bODLZG+WxIGMDmx076Hfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7448
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 08:28:53PM -0800, Jakub Kicinski wrote:
> On Fri, 3 Feb 2023 13:00:16 -0800 Shannon Nelson wrote:
> > From: Neel Patel <neel.patel@amd.com>
> > 
> > Use a local page cache to optimize page allocation & dma mapping.
> 
> Please use the page_pool API rather than creating your own caches.

+1, please also add perf numbers on next revision
