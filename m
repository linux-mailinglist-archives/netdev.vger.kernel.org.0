Return-Path: <netdev+bounces-8413-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59753723F5B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67D791C20F04
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A84E2A71D;
	Tue,  6 Jun 2023 10:26:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ADE28C3A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:26:57 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E57E8
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686047214; x=1717583214;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Lc4RemE8tkRQxaxo4NLUv8fxWRmJtok1bW49IMcttCI=;
  b=m4+LBUz0zoqo8PmIZnxZnOeXc3e4hgznemMLd/kAvH4rGc7MdYf16dDw
   J22db2kFPs6SE5FO4GgazlcfHk6Qr1Qe6xPUONeMehoXI8AJoC26msMH5
   J6u3+3+Dd+alWge2iSVAofSmWp/hPcDtFtXr8o1tcWB52MNFIVfkTbrr4
   LDy1CcMXk9TGAIbUClwO9YLROcd5j5qyoAjjhVBYlIUs0QmwGkpAcFx55
   W5DiLVRLO2TRAPbSZmFThdxvTkqUwpo2waw40L6OjZTokS+krAOmPH6JK
   j9pwERmLyp7CVADtbP5u27thlZIcZdMBRFJJpZ7DNcauRpwZGtfQP/qnF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="422453835"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="422453835"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 03:26:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="778937046"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="778937046"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jun 2023 03:26:53 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 03:26:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 03:26:53 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 03:26:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lU5R4C4JR3jR8TQmWJ0/1R02755g8qbLMSRbpLixsPoRlQ3IJkvGeIe4gdND/SPrC3agw0ROIgwgGT6K0nz6RzXvYm3lG6at8tai16eBYyi9iUUzC0xFe7ws2ZP2i6R9foCSrCUb7e2kHH/ymd6NlkpvgLd+qloOVBWCJ//OVSRVI5V03L7x3Scweq9whEbpjfEMdGTlB7RvcUlEWrf7yxhd9JN623SNCoLkl3ug18uogyiryrWnWmkqEJHG6K0Qdw2FE5XlaXMGmDT+PEWAtWHsdH3Wfs5IUOuZEgdqxe/54TzKrX4jXcDdDCHiY4F9MTAFYrGRInxDDzLwWD8huw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5A3P9+6vvhEKAzeBxuJnw16PV9XUdJNwUTEsBQaTRr8=;
 b=oRagnDcFWOAoh8GUZVhWeM6T5TkzsPuY4V+QJJ5ohlJALXZBVrjbVrtvij1Q+B0x1NNJEPZO4IfWMkI7ajRz9oygtnIXd2Oa0dkrumcAW3JiiYnhZ8GB5hU0PB1udXdz5fYE+du0sATe5pFsvvkCM3f9H3fUtwqZbKAn8XK7XE3mLjphM75ci6VsueFHKWRiJOypp1PodCV9KLU5/jOPM5nw+ExorRmO4WJuX92fDqcAYay9g//8NX7nsxDJ46QvB/FqW3JPUPWRT2d3hFlY9QgCuhAlcK03ocnxygGrH6ygNZEV/dztBwaF1CXVd/KjisykNflCYHtXtf5AQGME6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM4PR11MB7256.namprd11.prod.outlook.com (2603:10b6:8:10c::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Tue, 6 Jun 2023 10:26:51 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Tue, 6 Jun 2023
 10:26:51 +0000
Date: Tue, 6 Jun 2023 12:26:45 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Ahmed Zaki <ahmed.zaki@intel.com>
CC: Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
	<netdev@vger.kernel.org>, Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net-next 3/3] iavf: remove mask from
 iavf_irq_enable_queues()
Message-ID: <ZH8J5ZypMeSESSZd@boxer>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-4-anthony.l.nguyen@intel.com>
 <ZH42phazuTdyiNTm@boxer>
 <9b4c8cfb-f880-d1a0-7be9-c5e4833f3844@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b4c8cfb-f880-d1a0-7be9-c5e4833f3844@intel.com>
X-ClientProxiedBy: FR2P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::22) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DM4PR11MB7256:EE_
X-MS-Office365-Filtering-Correlation-Id: ca842ef6-c211-44dc-db7c-08db66788aac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GtZ6dLVnRD1KvVSI2VUdsrwmzmZp0rMMiyX0ye1x14tynqZF1DKMPUDjFyzuwwfcH6fWCIF2GOBV74vUt6lfE9paat6yeAUfVk+/PdFagQ0Cm8G4cuNCWY25ySuMNJdr5qwPx8iOlITuMW7OpkLLNr1Uwlyik8YhbUpG/YU68r6Qkv32yNj2x5KQXwk/U2AYSlpyOgb7mRl4pg2aoz2aJ1ux1o2475zs7ZNcYtwY/O/DZJf2XHshWQpqDlxWga+1XuKd78EqqypHWtiG7AfpcFPkguPOdIVmiDXNvEBie+KENbXvYkAGaaExFn/RUA7L1R/L22DfE3UL/y2VKwtHImZuNkOyjb91dkS/mwOVHg4BOWWLTOoLJQ3fJBDz/xqEoe5fOejma+mlPnTaDJwmgbeyg3AomePHTMONk798Cyi7qEdDC5gln+YY+8ckEiCKxfN8uoxM2LCPyTp8gmzkyUuSu8NvH0D9y3FJuSeuLSFWANspLKTNbQcASXkQhdMtIp1pSQZP4HCKYg+6hE9RBUNq6v68Jf/ABYyVCztfXV8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199021)(107886003)(33716001)(6506007)(9686003)(186003)(26005)(6512007)(53546011)(966005)(82960400001)(83380400001)(6486002)(6666004)(54906003)(2906002)(6862004)(8676002)(8936002)(44832011)(478600001)(5660300002)(86362001)(6636002)(38100700002)(4326008)(66476007)(41300700001)(316002)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ZacFw2fpWkffCNDchQxa6nX4wQmadYCiUTMDsw268H/gBaUEWXMHuS689o?=
 =?iso-8859-1?Q?wDpGeOU5bzzZbXXooGd0R8XD+WjvM0DnlrWhJLT5JE9JvlpabHHcH4APQR?=
 =?iso-8859-1?Q?Xc+VBh2ZkJVnHU3ntHHqsLVgiQniBPj7dcMtJ2S2XSLVxXKwQx3AQfPnCq?=
 =?iso-8859-1?Q?BJbgWmNY7joYN/7ytm0I9fTP3n8huCVmQm//jgfyvimZdJjvUrYLODA78u?=
 =?iso-8859-1?Q?itMKfqCcndwZpDiKqmcr0Yi9DRYalb+i2fMWBC2pMNeTG7WMpTWDxZOL07?=
 =?iso-8859-1?Q?vEZ2aZ9Y8ki1wLQNWQk8255nP898KmecONoH1aS6ryEcuoW6vmx1x9RyvX?=
 =?iso-8859-1?Q?27k6PifEDVVNnQUjwS8HNRMIrBrZiWdKWM1qsLgOGiJyrfUXZogQZ9N/ES?=
 =?iso-8859-1?Q?naZEErklkBCWVU6cb8v7cgd6Ew2NVd1habgo8oDPnfBCB5/n+00E7vQb6l?=
 =?iso-8859-1?Q?qiy3OkbtsocgmpqLrXx9IlbFXoROeJfHeDXQgIw4o+M1bVnBzAfV6fEM59?=
 =?iso-8859-1?Q?LoTl95XARc1NyvCBQZmtcUS4UUxwlba6bIoIGiel7RSXvTdaQ8WXVN0lbu?=
 =?iso-8859-1?Q?5axugh5zRjM/wecK0CJ70c9AdUt+1ykdK7zal+YcZtRRlC5APXDUHzdLFG?=
 =?iso-8859-1?Q?2MK14lkS99bgX9C50zPOmFnq8KBeRequhLesyRwTaXaeBd9hKDm8TLjlpF?=
 =?iso-8859-1?Q?IRFkzphpk78LIUy4bSWwvcXTCQ6WIDmSuNnH348C28fhCAGyCAIPJ6P90e?=
 =?iso-8859-1?Q?bVoKBBOB5CXizjUJhZKMHrwhkEbQN1m6TUdawmS2Zg1VZZVg9t1Ps49kqo?=
 =?iso-8859-1?Q?Zd+jN1OWpFoBq0XE8WNwbg0B04vrMiJIrjnyNZaELPigXhRoFLOhTJIBGt?=
 =?iso-8859-1?Q?JUB8dk/dcsv3p+UCw5yM01Ni/JHs2VWBFyimdL+7j8oikbVacc4sQY6JPN?=
 =?iso-8859-1?Q?jhTisdBBNgM/Rb7BzamgZ4gdK4rJcSsZQRWDcbOUyRLs+f478J07SMcgxj?=
 =?iso-8859-1?Q?OYOsXD0Wf9yve8c2qbaiLtaW7f9hCSqAAKnETZt6/LIs2b3CTLvKYX9sug?=
 =?iso-8859-1?Q?E2ix/D8cPBSAeDX9qDHT0JT6FyrYyQ+iVslPi5ontOBqaKmnCZq4S3OIqo?=
 =?iso-8859-1?Q?lY6DE49Dr827jO2JaQmmUNIJaJXdyr1E6N2Os1OLCeF66ahjcSn6E5Xng+?=
 =?iso-8859-1?Q?tGJPJapfyEATJCsUeeSg8Sl0ppd2ntVukDpyPgZyRe63EEeIxa7Ht/HS6Y?=
 =?iso-8859-1?Q?b4OT/uNvUQ01Oe9K62ELF/maLskCLaB33htIqqW6bL7bP3r/NinD4MD085?=
 =?iso-8859-1?Q?8Uc6he4bGLD4FA0FqKpoXH0ITmb0B9gyY+5lUefTc495/B0K3CsHXp61/h?=
 =?iso-8859-1?Q?chq1Ji/dWhgaPJVf54IMAi+AR4qMTTU9YzoyczHdwdq1kJajpF1PZN37CO?=
 =?iso-8859-1?Q?jJo2dsvxsyA+iZBj5OZnZ8zgFbjxNJ372x5/Zim7YolF1Lz+Mh7JWXVoxA?=
 =?iso-8859-1?Q?jBW4S/RHoGiKdmLcMuOupgdI8xyoyPq6KYOvyWPhFHGmNB9qpX4E6NnPx7?=
 =?iso-8859-1?Q?4XHCUxjqXVjOWsmzcflMGUFb49CwD2+SkhNu4tU4w0dyBOa8WD5WyaZsHO?=
 =?iso-8859-1?Q?3AVjvuWU4FVutgjHJwPoaOFd9qLXuFmxSIrpohTOtAml9lH2CTmE+Fiw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca842ef6-c211-44dc-db7c-08db66788aac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 10:26:51.3879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3lb5R6fJCrJ5dGdEgNkpTPsuevWPLRIrYEjOI2eQDZ+5D6Pb0oTKNYuZGWOPcE8S/QYM0Q5D1aNY49O65Y1kttM5T/wvrLcyQkNYyTUubk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7256
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 01:56:48PM -0600, Ahmed Zaki wrote:
> 
> On 2023-06-05 13:25, Maciej Fijalkowski wrote:
> > On Fri, Jun 02, 2023 at 10:13:02AM -0700, Tony Nguyen wrote:
> > > From: Ahmed Zaki <ahmed.zaki@intel.com>
> > > 
> > > Enable more than 32 IRQs by removing the u32 bit mask in
> > > iavf_irq_enable_queues(). There is no need for the mask as there are no
> > > callers that select individual IRQs through the bitmask. Also, if the PF
> > > allocates more than 32 IRQs, this mask will prevent us from using all of
> > > them.
> > > 
> > > The comment in iavf_register.h is modified to show that the maximum
> > > number allowed for the IRQ index is 63 as per the iAVF standard 1.0 [1].
> > please use imperative mood:
> > "modify the comment in..."
> > 
> > besides, it sounds to me like a bug, we were not following the spec, no?
> 
> yes, but all PF's were allocating  <= 16 IRQs, so it was not causing any
> issues.
> 
> 
> > 
> > > link: [1] https://www.intel.com/content/dam/www/public/us/en/documents/product-specifications/ethernet-adaptive-virtual-function-hardware-spec.pdf
> > > Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
> > > Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> > > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > 
> > > ---
> > >   drivers/net/ethernet/intel/iavf/iavf.h          |  2 +-
> > >   drivers/net/ethernet/intel/iavf/iavf_main.c     | 15 ++++++---------
> > >   drivers/net/ethernet/intel/iavf/iavf_register.h |  2 +-
> > >   3 files changed, 8 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
> > > index 9abaff1f2aff..39d0fe76a38f 100644
> > > --- a/drivers/net/ethernet/intel/iavf/iavf.h
> > > +++ b/drivers/net/ethernet/intel/iavf/iavf.h
> > > @@ -525,7 +525,7 @@ void iavf_set_ethtool_ops(struct net_device *netdev);
> > >   void iavf_update_stats(struct iavf_adapter *adapter);
> > >   void iavf_reset_interrupt_capability(struct iavf_adapter *adapter);
> > >   int iavf_init_interrupt_scheme(struct iavf_adapter *adapter);
> > > -void iavf_irq_enable_queues(struct iavf_adapter *adapter, u32 mask);
> > > +void iavf_irq_enable_queues(struct iavf_adapter *adapter);
> > >   void iavf_free_all_tx_resources(struct iavf_adapter *adapter);
> > >   void iavf_free_all_rx_resources(struct iavf_adapter *adapter);
> > > diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> > > index 3a78f86ba4f9..1332633f0ca5 100644
> > > --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> > > +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> > > @@ -359,21 +359,18 @@ static void iavf_irq_disable(struct iavf_adapter *adapter)
> > >   }
> > >   /**
> > > - * iavf_irq_enable_queues - Enable interrupt for specified queues
> > > + * iavf_irq_enable_queues - Enable interrupt for all queues
> > >    * @adapter: board private structure
> > > - * @mask: bitmap of queues to enable
> > >    **/
> > > -void iavf_irq_enable_queues(struct iavf_adapter *adapter, u32 mask)
> > > +void iavf_irq_enable_queues(struct iavf_adapter *adapter)
> > >   {
> > >   	struct iavf_hw *hw = &adapter->hw;
> > >   	int i;
> > >   	for (i = 1; i < adapter->num_msix_vectors; i++) {
> > > -		if (mask & BIT(i - 1)) {
> > > -			wr32(hw, IAVF_VFINT_DYN_CTLN1(i - 1),
> > > -			     IAVF_VFINT_DYN_CTLN1_INTENA_MASK |
> > > -			     IAVF_VFINT_DYN_CTLN1_ITR_INDX_MASK);
> > > -		}
> > > +		wr32(hw, IAVF_VFINT_DYN_CTLN1(i - 1),
> > > +		     IAVF_VFINT_DYN_CTLN1_INTENA_MASK |
> > > +		     IAVF_VFINT_DYN_CTLN1_ITR_INDX_MASK);
> > >   	}
> > >   }
> > > @@ -387,7 +384,7 @@ void iavf_irq_enable(struct iavf_adapter *adapter, bool flush)
> > >   	struct iavf_hw *hw = &adapter->hw;
> > >   	iavf_misc_irq_enable(adapter);
> > > -	iavf_irq_enable_queues(adapter, ~0);
> > > +	iavf_irq_enable_queues(adapter);
> > >   	if (flush)
> > >   		iavf_flush(hw);
> > > diff --git a/drivers/net/ethernet/intel/iavf/iavf_register.h b/drivers/net/ethernet/intel/iavf/iavf_register.h
> > > index bf793332fc9d..a19e88898a0b 100644
> > > --- a/drivers/net/ethernet/intel/iavf/iavf_register.h
> > > +++ b/drivers/net/ethernet/intel/iavf/iavf_register.h
> > > @@ -40,7 +40,7 @@
> > >   #define IAVF_VFINT_DYN_CTL01_INTENA_MASK IAVF_MASK(0x1, IAVF_VFINT_DYN_CTL01_INTENA_SHIFT)
> > >   #define IAVF_VFINT_DYN_CTL01_ITR_INDX_SHIFT 3
> > >   #define IAVF_VFINT_DYN_CTL01_ITR_INDX_MASK IAVF_MASK(0x3, IAVF_VFINT_DYN_CTL01_ITR_INDX_SHIFT)
> > > -#define IAVF_VFINT_DYN_CTLN1(_INTVF) (0x00003800 + ((_INTVF) * 4)) /* _i=0...15 */ /* Reset: VFR */
> > so this was wrong even before as not indicating 31 as max?
> 
> Correct, but again no issues.
> 
> Given that, should I re-send to net ?

probably with older kernels PFs would still be allocating <= 16 irqs,
right? not sure if one could take a PF and hack it to request for more
than 32 irqs and then hit the wall with the mask you're removing.

> 
> 

