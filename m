Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89006638AED
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiKYNMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKYNMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:12:45 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A2E201BF;
        Fri, 25 Nov 2022 05:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669381960; x=1700917960;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=jp7L85flSiz26lcWnzBMPmPu8bgBXwHzw5jdjcBrIXM=;
  b=IbVRwSV5IR2TFWAAbHnmyZK8e04l307HZX0zyJWxL7UG4yNDlChLmBjC
   wTFLTCMfPQYQYOq+YrSKrsQoIQ4+2GK8yPeFzB7Sj3q2THfCdFsx0L+1l
   koo65ygsKfmR82A2W8beXnNKClf2Vhlj+nOYY066zbJzzD+iMKQEhLC69
   tkvEiHvDipUyWVp58FOI5UI8ZiN72evXXD9+Q6D4YZ272RHhv0ilSRhBL
   JrWWL0iTjgLuWhdsl/Ola+85GhImryWSLiUXFgEEszZqrtAcGuq+l3whk
   10Bld1tJmeuHGYuMjDsDxIfgujuTaM6vNbO1UVLKTASC+5s/1LIbK4tC/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="297836931"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="297836931"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 05:12:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="593217215"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="593217215"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 25 Nov 2022 05:12:39 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 05:12:39 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 05:12:39 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 05:12:39 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 05:12:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GAhmLi6su6KD0MdjtfV2Cd6CesnzV6E76Scx4jj1GtKhNtczYXdr4g9KNRL/Tle8nyf9VW3ayHxw+aMCR1l5oQXjDlnLUkRBvgdY/erLbrO6zPp3A5Mtqx6AAz8MZKcZe33XmQXXFl1q84yjlctUBxGWG3QPdpy5X0lBBhUkCEkkERl9lSMKf+MqZQ/MU73Ah3L8CcHxWMDl7ATkrLMnesehwuiX6fNNGJZzoz+NyCYTV4l25wQvsdVzg9lUuliya7HCYdAY4jrL3qY0kB0E0c7frn3c1tCnpYdW/4iuNJbAp59qGX8us1uM/1tTK+u4GobMjraB4zPJrZA3h4tRPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mh49mDSL5J4GxigyI78WBOPPP0mo9dLBB+FMLbldUpg=;
 b=AJxu83JAg+71QXR0wmnVxouC0CDNjAK3KnyBe0sHBaex/4YqHsutzhd9wpu6Dsadvr+n4p0CiI1xlN4FR4DqAUPS2TocwJf3KpUm1c0ULAWKAZ3yjW1l6jGCmCLioU64gdZk55K+ksEYUnZ/fmAQLm1JDld4D+e6Xqow1MldV/PB3BMQc+44ej8x667r10+vwXtCLuqxIPrqdGviqExZsYz/hhMQ1rn+ourZhCdhFDdPrcWE79wx6wxCoO3dHKKK+pBrEEduuvPppskQd5j3z1xtY3V9ayHehe9GOxb0OmZ6CtjrX68CIuozjYJUuVACLPX8vywUFa5JpgsUqb6xTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BN9PR11MB5259.namprd11.prod.outlook.com (2603:10b6:408:134::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 25 Nov
 2022 13:12:35 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Fri, 25 Nov 2022
 13:12:35 +0000
Date:   Fri, 25 Nov 2022 14:12:21 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Yan Vugenfirer" <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Subject: Re: [PATCH v3] igb: Allocate MSI-X vector when testing
Message-ID: <Y4C/NZEDxH00z/hT@boxer>
References: <20221123010926.7924-1-akihiko.odaki@daynix.com>
 <Y34/LDxCnYd6VGJ2@boxer>
 <4a2d4e3e-5b15-2c58-dc49-92908ab80ad0@daynix.com>
 <1434bd67-1707-7e43-96b6-d2294ff7f04d@daynix.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1434bd67-1707-7e43-96b6-d2294ff7f04d@daynix.com>
X-ClientProxiedBy: LO4P123CA0662.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::18) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BN9PR11MB5259:EE_
X-MS-Office365-Filtering-Correlation-Id: 1101e3b4-e323-42b6-220c-08dacee6b7f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rGLGoAFGPnmyXxzXSUcYYrMzCFgpaG4MBtH3HtaUiH4Q+o/N9HmQYuvkxQ6RfpPGkWx6nCMjv9VqQxZyVfItBxO1ASitx/lqMvi6h+hmlnBG6KrDpyNqrpridZt6Drtl0rH1cyxMk242IZ7nezykrMQ3ojfg5GaoS9do9Fj0M4FAOfuxFaukoDYcfBETi/cGFeFoME9WNepu4Gq9URsGrDSSsNhSnyhncQuS1Yr2HKMBKsDym5CDQxX5RW0J1btsA9OVpf2DaYW3DtThlk0slnUh1CK15pOCNE4hwc8CN03GzpLQgNZkV8AVlSMX3UPEljgF45D4VNolDE+DgYQLT1mX23yJBOPDXTesdTuRKoRPdCCoB+8BEqWgJ+Aenby50Wb8Pg1SujVFdAht8XaQIP4O2l0S1GcOsWG6FVuTbWPnGFfw2BZ9I5dQqaA9BMJD+5uQqkPVldgMpP05CJASYoYPG20uM6R9JgOiUo6vPPAyY34gdmmzWn2jgZ+ELGAMz7xMVc8h/VCIIQwbxcC6uequNLgEkxMYm+bJ1QcqEDu7yAdcQmcqVEwGkqurMQ+X9GIVNarIxUZqqXB4PNmnof6Ffvu3LkoBllmDrEQVuvg/af0YL3VtAOvGuLjrKc+bHlLlbXKA8JdaOXPUD4JKb7q4ubENpvgtFVCZjjVm+hoZcSgbHHHXv2zq3UU+W/lfyxFj0V1Rk3QTVI7p9TlrpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199015)(86362001)(66476007)(53546011)(66556008)(8676002)(4326008)(9686003)(6512007)(66946007)(8936002)(26005)(41300700001)(478600001)(6486002)(966005)(6666004)(6506007)(6916009)(54906003)(316002)(82960400001)(38100700002)(44832011)(5660300002)(2906002)(7416002)(83380400001)(186003)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?geyhBr02xqR3m8FxsfyPBqd6xHUp7etIQVCmfatyVdNZNG+ia1DRCN7KYE?=
 =?iso-8859-1?Q?bNK87LgFMHRf0NrIzEEwlPERd3Ly8kfrRlQrRAchQXG6Fcf6TmqrHT96Nb?=
 =?iso-8859-1?Q?hx2DhZMQz6qkuUMPyAVNui06eEDrfPNyjSMWnBJCgePwbh3Lki5eAxOuNg?=
 =?iso-8859-1?Q?32DMBYV+7L6S65DC4ewBXPAlqNoTzDCKRHORCfXkj/3mpZq29bHcrPvsL6?=
 =?iso-8859-1?Q?DUzfeMAQu7qI/FQgzEEn/bivaX9xgqjk3HGNRMv+V2CC2V6GqyUkmmCMFk?=
 =?iso-8859-1?Q?l5qS698+znx465kK+XjOpy/uJZ+H4OIunQ9B3kfqc48yW/QX7iXqDlsIe4?=
 =?iso-8859-1?Q?uwlqkZiJ8W/YwXwk3xEbOTpADsWaZjUBdyusOzjs1CA1mLxVm/1wtuWCil?=
 =?iso-8859-1?Q?miCFM3nvMYFX33ro0YPaOhUCp0gAxSY9pjMh0gMHBHSn21G3md5IebCctH?=
 =?iso-8859-1?Q?3v89lAzOget9vN/jvgkL2paHbpazcJRhUNKo3LIKmdIsdDT5cRmN1Zii4U?=
 =?iso-8859-1?Q?deV0Y770Fo1M6JzmpI0emNG72MY8wR0qQpOMsFr3VWOqprQ0j3EXBd0gaA?=
 =?iso-8859-1?Q?lCs5J+5ieW5r/zr5h4wctQkkNaG8BYlPjnSNnj4sOP3bBIXkN4xl6AX82w?=
 =?iso-8859-1?Q?JNqksmlZ/Jc5URLQXiTWghgtPf72LC0ZLigYleH4IxUxmEgSQFCQr5gSiY?=
 =?iso-8859-1?Q?C26sW+mFStxAH76Sw8enmIJnOu2+a7nGYiZ0M7NpHJ25AjLDzQ+2TlfjPY?=
 =?iso-8859-1?Q?xyx/c24sz5xYU6zA9EzIWlHVposQ9Rr2rOKORfgfdCjYr77l67l36THwX1?=
 =?iso-8859-1?Q?anYpHKU+SWK/9ugDjT/2qCpK0jVIjiJiNLbs8OVpfzDazig3AGneFXVDuU?=
 =?iso-8859-1?Q?ZmQ1IPIubM2iEYSG/NhygVPXBzM5I4bsJzIncWQRcAuxjBjbq1Oy4ob3f9?=
 =?iso-8859-1?Q?HoYNY6b43Y54Kiz0pwIz/4E2vb9nKZZWpcNX4D7ySCQ6Qs2mlNb4EOgyz6?=
 =?iso-8859-1?Q?x2Ve/745Twwgekfyik/f9Pbsmc93F3o1jgl/3yHZzW17ERsUhhxr5ovHAg?=
 =?iso-8859-1?Q?Pb+wVBI5NR0FvK3pzKhG8/HIdTk5lfoPMQWLZeHR44RUE4K5xqm2WzdWja?=
 =?iso-8859-1?Q?w6X9g9n/XaSJnFn07MBV85TXPVeDWz71T/A5rgjG0mI99bF6G5nTWDTKx2?=
 =?iso-8859-1?Q?7KMkzVpbWjCe2TeJAOqPNAQ5iOwY2t0Hm5uHrr2ZYgDb8PeqLSG4l/tufy?=
 =?iso-8859-1?Q?0yAWZ4UiaW7ag71Y0ue98iDBbMGgOd4v3CF/Hv3mVYtrOIlYSm+JopvWd8?=
 =?iso-8859-1?Q?HAF8cPZ54Ulf7fGvjyWZ2giiy1E+dovZIUbavibX+e7cajbGUGEQcwZAAf?=
 =?iso-8859-1?Q?hc9yQtlopymDD7ctOJ0E8A3vqmfBuS+392mcL/1wkcAmlI1mhy/FvtmlTM?=
 =?iso-8859-1?Q?oV8NihKl6t0cxTYXsK5SnGPgmgdATQjeFAwAO9cLbpk+nPzk2uvER9VFtY?=
 =?iso-8859-1?Q?JdBNlb1Y+ihYTfUev1ZBIkauCG4uOWw0nNL3TMmmybZ4AOrfc9oLYrMegR?=
 =?iso-8859-1?Q?F0e7+gA2zQKzk3SrR1LOEKm/L02DRXZWAraQS8JvXdlSmziCg+050UwbUw?=
 =?iso-8859-1?Q?dtDN+1oRS1oJPV1tPq/4UOK9neyZVs/oA3ktMC5vdf6UCIzkTHmO45ug?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1101e3b4-e323-42b6-220c-08dacee6b7f4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 13:12:35.1782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DtbfaGZPqb9rG96T/4pqdPXGwoHxc7W5rGH1GX6nKnb8oK/4xfBNMGkCz89RHX5k3/IlokT97CuQDL1PY1ozdtuFWje8sReZ0GArJYsuSjM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5259
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 06:50:45PM +0900, Akihiko Odaki wrote:
> On 2022/11/25 18:48, Akihiko Odaki wrote:
> > 
> > 
> > On 2022/11/24 0:41, Maciej Fijalkowski wrote:
> > > On Wed, Nov 23, 2022 at 10:09:26AM +0900, Akihiko Odaki wrote:
> > > > Without this change, the interrupt test fail with MSI-X environment:
> > > > 
> > > > $ sudo ethtool -t enp0s2 offline
> > > > [   43.921783] igb 0000:00:02.0: offline testing starting
> > > > [   44.855824] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Down
> > > > [   44.961249] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is
> > > > Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> > > > [   51.272202] igb 0000:00:02.0: testing shared interrupt
> > > > [   56.996975] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is
> > > > Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> > > > The test result is FAIL
> > > > The test extra info:
> > > > Register test  (offline)     0
> > > > Eeprom test    (offline)     0
> > > > Interrupt test (offline)     4
> > > > Loopback test  (offline)     0
> > > > Link test   (on/offline)     0
> > > > 
> > > > Here, "4" means an expected interrupt was not delivered.
> > > > 
> > > > To fix this, route IRQs correctly to the first MSI-X vector by setting
> > > > IVAR_MISC. Also, set bit 0 of EIMS so that the vector will not be
> > > > masked. The interrupt test now runs properly with this change:
> > > 
> > > Much better!
> > > 
> > > > 
> > > > $ sudo ethtool -t enp0s2 offline
> > > > [   42.762985] igb 0000:00:02.0: offline testing starting
> > > > [   50.141967] igb 0000:00:02.0: testing shared interrupt
> > > > [   56.163957] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is
> > > > Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> > > > The test result is PASS
> > > > The test extra info:
> > > > Register test  (offline)     0
> > > > Eeprom test    (offline)     0
> > > > Interrupt test (offline)     0
> > > > Loopback test  (offline)     0
> > > > Link test   (on/offline)     0
> > > > 
> > > > Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> > > 
> > > Same comment as on other patch - justify why there is no fixes tag and
> > > specify the tree in subject.
> > 
> > I couldn't identify what commit introduced the problem. Please see:
> > https://lore.kernel.org/netdev/f2457229-865a-57a0-94a1-c5c63b2f30a5@daynix.com/
> 
> Sorry, the URL was wrong. The correct URL is:
> https://lore.kernel.org/netdev/be5617fe-d332-447a-b836-bec9a6c6d42d@daynix.com/

Please change the subject to:
[PATCH net v4] igb: Allocate MSI-X vector when testing

and add n the body
Fixes: 4eefa8f01314 ("igb: add single vector msi-x testing to interrupt test")

Also, it is a good practice to include changes between revisions even if
it is only a rewrite of a commit message.

> 
> Regards,
> Akihiko Odaki
> 
> > 
> > Regards,
> > Akihiko Odaki
> > 
> > > 
> > > > ---
> > > >   drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 ++
> > > >   1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > > > b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > > > index e5f3e7680dc6..ff911af16a4b 100644
> > > > --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > > > +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > > > @@ -1413,6 +1413,8 @@ static int igb_intr_test(struct
> > > > igb_adapter *adapter, u64 *data)
> > > >               *data = 1;
> > > >               return -1;
> > > >           }
> > > > +        wr32(E1000_IVAR_MISC, E1000_IVAR_VALID << 8);
> > > > +        wr32(E1000_EIMS, BIT(0));

Should these registers be cleared at the end of igb_intr_test?

> > > >       } else if (adapter->flags & IGB_FLAG_HAS_MSI) {
> > > >           shared_int = false;
> > > >           if (request_irq(irq,
> > > > -- 
> > > > 2.38.1
> > > > 
