Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4DC6D4EEC
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 19:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbjDCR0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 13:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjDCR0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 13:26:47 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B513113;
        Mon,  3 Apr 2023 10:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680542806; x=1712078806;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jWLE3P5AwU+l9qIYMswvippFjwIYn8nuFIB8ynCWmOw=;
  b=LF+r5sobqfsmGtpctdOVgiD/jVwdX5Ccdiao+uKDqq0briE6XPy9yoMT
   xpnJVzaoqe5nZt58i8iIcPwVS1B/BPYwq1yrjB4IIt1BjJzlFe9La4Dsz
   qQcCJqrntBQLp59URKLUP0me0v5HiaXd5pWI4bxxSEHP3eDH4Vc9ock/5
   rc3cj1yhvpjvqB6GSrxyO2epl1RLf1YlxAheDuyuwZ4xV1w4c0pTThX9L
   IJb1NLdCEG4uiRCqMgUJc+UPBdMOxCGT3vWrzx276c5xYe9n2arfy20IV
   UNXBvXnThxinmRvjvAOMHiX31+EVu6FCHMYUal+2sQtkYtZJKDGHubFpH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="428254370"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="428254370"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 10:26:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="829649672"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="829649672"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 03 Apr 2023 10:26:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 10:26:45 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 10:26:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 10:26:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 10:26:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3YBX9jiFUuXPWFtZGP/glpHsdp9LpHq8mjJuzX2Ix2wZG3gwo57REsxgzRyA+Ek39E+tyq3IqFTuCWH4VnL22ME0OhCzro4FGuuj1s2CvEV+/i2Q4BshXSiO+mY1upX4WFn9Fb6CUbZ5QjGEd5gQ2LWuOxZxBV8BkmP5u3HwZ66H02dOa5rJdKYvhMgpILOBj4wzfIyPnB4c6wn4GyB6LWRqt/igVWE3E01KTKyEbrwT+PoT/8KsGLi9NfDp8HgUBhjkZC+7rP+PMIuNTUhobsEhZ0CXgVEzcNrta6+uj4QPj12LVS48AFBIN4Jr9eui3mx0gyUhhQlZuoCHhGjJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YbkpszxyXPPAfp4ZxzLn6Hunw9WumRObVLZuAGMj4BQ=;
 b=QVaXCuS/pnQLPa6lNWbitVwOprXw/9jYIX6PkHvGAYDS2muOwO7LvzwB2Qq7lyO48oo/8ODt1k5Leh+YPi4yOTW1TWEEQSe9MTAdlOHd44jA9GZuPHnnVYXczJvpR+Mp8EoSi5HzNPImApC0LJGghbWiArKm3H1KSd09NCDwNEUAB2izlcxYvsF9qHFZ+zhVV0dQUVQ8BlxS2nebBycHq3QM+4kXORnZkz3nwZQCaW5ZgjU+6YdFPrAnavWj17XFPiVHqtuKPhQ8XZv23/X/GPtY9M6A+VIjJWgdFaYgeH4+LIWIV8yrwbbaVhGovbY6ZfuLLOnM+P58H4z8hAXt9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM6PR11MB4692.namprd11.prod.outlook.com (2603:10b6:5:2aa::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.33; Mon, 3 Apr 2023 17:26:20 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 17:26:20 +0000
Date:   Mon, 3 Apr 2023 19:26:12 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <bjorn@kernel.org>,
        <magnus.karlsson@intel.com>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next 4/5] tsnep: Add XDP socket zero-copy RX support
Message-ID: <ZCsMNKCK0xQECDJh@boxer>
References: <20230402193838.54474-1-gerhard@engleder-embedded.com>
 <20230402193838.54474-5-gerhard@engleder-embedded.com>
 <ZCsKkygVjB3J+XrO@boxer>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZCsKkygVjB3J+XrO@boxer>
X-ClientProxiedBy: FR3P281CA0026.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::17) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DM6PR11MB4692:EE_
X-MS-Office365-Filtering-Correlation-Id: 34a0c5ef-754a-4f31-9621-08db346889bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TjMU6UZSjHpnfjFRRpBMzhA2n4Ya7Azj5hcX42faVPItZZF/JBJZeznPxuyQ+ch1kEiKyLzS3QpIbqlbag5EzZwaWGxhd4dvga8RONZvbZNyRvG7T4NBmhLkBR/bIzRB6Pd6m0JmjdXimnGSuiNjGseCl6yDvLGOzv4Hhexm0jOkRNlJWObBeipXeUrW/xMVBAw53lm5M0olFoc65ObniBDSTYYQ3vWGNG1mRK0fHkJ6d2QuGTlk26DQFQKRsmcZs1EEHULtLN6AiCYhTEgldfwkID7Hnx1OVyj3hkg8w4Dp6LewamSAZDBKx44/VGJQy4CmanGqAFzMK4kfpBxyYoreX8q3/P7k5s4IXxAQ2uxgfIEZI224OQZXOj1ITKHEwv1CTp2PgJcL7qfZNw//b8QtUjpNdwOMk/IQbB5RnAannbfmb/aJ4A5mgbAQK39fPi2O/y0CTdUj8P2k4+CvkvYDJOrQPfnUVgxnfPA4S2jyZCoxHJrTndfDqvjMHzVqBRSuc4wAD8HnKAfgrc+0gDwB/Sr1WYp4eNu8beITdKEJLbZ/XKEQKTNrRnu0gF1C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199021)(2906002)(44832011)(38100700002)(5660300002)(66476007)(82960400001)(66556008)(66946007)(8936002)(41300700001)(4326008)(6916009)(8676002)(316002)(83380400001)(86362001)(478600001)(186003)(9686003)(6512007)(6506007)(26005)(6666004)(6486002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QULwvN5e87N9B1NBsOWCFeXO9tZ2Qn4V89fQcyXDxoZ3ZQl8yfYW8+/AB0gb?=
 =?us-ascii?Q?R4cFapa2jgMCFsi1gj5L7BtsH8BRmbKKW1b54Y+u8TsoRMAcJMbEIqmsVXHF?=
 =?us-ascii?Q?yVzwA3Cri1rY/eVwd7wOWH9BhU87OCAIj1kUMGLjiNFjy4LiQ8qqseY9yP15?=
 =?us-ascii?Q?yYchtPhK91cUVmSTXC38MwL4yKfP0VbK7eBEVIijK+glhUvzrLExaGfJ94cB?=
 =?us-ascii?Q?Nkip2LH57sEdccHgJ6e8DqZDTDZOnPnC+8qeX1kLlnwVbe44sgOJ0JZF0Riq?=
 =?us-ascii?Q?7ND2ePQuNd3BrjfI0Tgbm3yjxVoGhC5OL4nTycEW+ZWnnpWfLkNYwX6rHxHV?=
 =?us-ascii?Q?ufwrTBjiAo/cc2g6e15CmQbZNvQF5OCk4Z0knaY3qaIfU3RjxM2b9BBw4Wb2?=
 =?us-ascii?Q?eT7PEc6igv+cMZgvmkfrMf5vUTb2ODl8sJ0/8xi5PhANwGKmtp3loXuYbBSE?=
 =?us-ascii?Q?5qnJLGbLPu3VjJWlhNQesTFqRjbSMXNWjEcuSLkw4H/cIEMgtyOM3P9sFR33?=
 =?us-ascii?Q?LJSV3/fmBW626J8J0iK/dXDO5iFasLDARkNiJxh/Tz5niEm/FQzaK2YbShoV?=
 =?us-ascii?Q?RjHbkVcg+ahAOw+DK8S9z+UB6rkBslgkCMBk3kv0ERWY2E4rxZ8+2jDJ4P6o?=
 =?us-ascii?Q?bqJJ9/fKc0NCOMa0LnC18J3KCt0F2bpnQNtl7Mw/kMe1xdDM26CKlvX9Mj/r?=
 =?us-ascii?Q?KG0eoZpyDeRXBpnR0HtY/tJr8GC+VjzpPQIGUZH3ITholuVoogr+1RknKya+?=
 =?us-ascii?Q?5Pr34KInjBn/0qvxe43dSTG9wNMc31SlUYbBT/VZEilsrZ+kxNDrbn4OYju2?=
 =?us-ascii?Q?zBg1THD/Ual1KW3rcKr45J8oi/RvAVSLEYPW7nRjgeeaDL+XaQfRzd4tGQaF?=
 =?us-ascii?Q?MnzL9ZTFxjbP1lmpF+CJ8Ff7nI5WfcrEZQTgLkPAYV7Z2d4DqivvnoEZLGww?=
 =?us-ascii?Q?hfK7OzBHGlqwAiUkODedip5T1rLoRDpErIn7/2XjHdMDVzb/WC1WM+MNaCiR?=
 =?us-ascii?Q?+kBMiR4ogWtb84mlCcITE7OzH9tQke0+tr3LmpIz335Zg5lMFipbCJPXaKHX?=
 =?us-ascii?Q?sbxb2O1a+g096mKhQfxXcmcl9DfcXvJJeMyMljfigKwnddjiy5Dqy8LBFJeS?=
 =?us-ascii?Q?b2c67bSw11qaKq7v8xZMVcnJonB84jPGtMIFgzJ6S+gQoLXpbxgL77t3q9Fm?=
 =?us-ascii?Q?dsJgMaMydDx/p55TzIXotVaeY9jNDTetj47T4rH+L0RWOD3nV/6imJvxcaSL?=
 =?us-ascii?Q?2p/8sLryYX2muqZrm379IQWQ+5gRHYKTee13a2rYUSXUxMRvpu3Uy9/L6Hbx?=
 =?us-ascii?Q?MkBWvtBYpV+A5c8y+DRqTlcQQpaW15I20j77xzwLJP4Wm0pAXUS/9G4HfNt5?=
 =?us-ascii?Q?bkplQUziYg12iRjaDTg81YAAJb9SOOA2gBvsCsp3Z5JULAeNmRkru/4y5u9T?=
 =?us-ascii?Q?4/THsQPKpPSyJa0o5kmqN/NgAHZjkXgNoJG1/U1YapquHg2M1/0d/yKr9mM7?=
 =?us-ascii?Q?ymZ+Hnw6DccUD6+uABr45fAY0+f+004w4LnYyTdTk1Sc27TgjTY+Kyl2xw2M?=
 =?us-ascii?Q?yMNG/4R6hik2cCltCm+4InM1Ix2oddusF0PDGiYrd5XEg7e/Qo6Fkow+dmP4?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a0c5ef-754a-4f31-9621-08db346889bb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 17:26:19.6859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i5ECDPVxsk63UJcTfI32CEnUfGya0F4swRV+gUeEkzXyxSZJ4GyC4cvPURUYXlMI8uu9VIuCyNIQAbeS/lytMlKkm4SQGW3iGyCbQQxATEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4692
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 07:19:15PM +0200, Maciej Fijalkowski wrote:
> On Sun, Apr 02, 2023 at 09:38:37PM +0200, Gerhard Engleder wrote:
> 
> Hey Gerhard,
> 
> > Add support for XSK zero-copy to RX path. The setup of the XSK pool can
> > be done at runtime. If the netdev is running, then the queue must be
> > disabled and enabled during reconfiguration. This can be done easily
> > with functions introduced in previous commits.
> > 
> > A more important property is that, if the netdev is running, then the
> > setup of the XSK pool shall not stop the netdev in case of errors. A
> > broken netdev after a failed XSK pool setup is bad behavior. Therefore,
> > the allocation and setup of resources during XSK pool setup is done only
> > before any queue is disabled. Additionally, freeing and later allocation
> > of resources is eliminated in some cases. Page pool entries are kept for
> > later use. Two memory models are registered in parallel. As a result,
> > the XSK pool setup cannot fail during queue reconfiguration.
> > 
> > In contrast to other drivers, XSK pool setup and XDP BPF program setup
> > are separate actions. XSK pool setup can be done without any XDP BPF
> > program. The XDP BPF program can be added, removed or changed without
> > any reconfiguration of the XSK pool.
> 
> I won't argue about your design, but I'd be glad if you would present any
> perf numbers (ZC vs copy mode) just to give us some overview how your
> implementation works out. Also, please consider using batching APIs and
> see if this gives you any boost (my assumption is that it would).
> 
> > 
> > Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> > ---
> >  drivers/net/ethernet/engleder/tsnep.h      |   7 +
> >  drivers/net/ethernet/engleder/tsnep_main.c | 432 ++++++++++++++++++++-
> >  drivers/net/ethernet/engleder/tsnep_xdp.c  |  67 ++++
> >  3 files changed, 488 insertions(+), 18 deletions(-)

(...)

> > +
> >  static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
> >  			       struct xdp_buff *xdp, int *status,
> > -			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
> > +			       struct netdev_queue *tx_nq, struct tsnep_tx *tx,
> > +			       bool zc)
> >  {
> >  	unsigned int length;
> > -	unsigned int sync;
> >  	u32 act;
> >  
> >  	length = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
> >  
> >  	act = bpf_prog_run_xdp(prog, xdp);
> > -
> > -	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
> > -	sync = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
> > -	sync = max(sync, length);
> > -
> >  	switch (act) {
> >  	case XDP_PASS:
> >  		return false;
> > @@ -1027,8 +1149,21 @@ static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
> >  		trace_xdp_exception(rx->adapter->netdev, prog, act);
> >  		fallthrough;
> >  	case XDP_DROP:
> > -		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
> > -				   sync, true);
> > +		if (zc) {
> > +			xsk_buff_free(xdp);
> > +		} else {
> > +			unsigned int sync;
> > +
> > +			/* Due xdp_adjust_tail: DMA sync for_device cover max
> > +			 * len CPU touch
> > +			 */
> > +			sync = xdp->data_end - xdp->data_hard_start -
> > +			       XDP_PACKET_HEADROOM;
> > +			sync = max(sync, length);
> > +			page_pool_put_page(rx->page_pool,
> > +					   virt_to_head_page(xdp->data), sync,
> > +					   true);
> > +		}
> >  		return true;
> >  	}
> >  }
> > @@ -1181,7 +1316,8 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
> >  					 length, false);
> >  
> >  			consume = tsnep_xdp_run_prog(rx, prog, &xdp,
> > -						     &xdp_status, tx_nq, tx);
> > +						     &xdp_status, tx_nq, tx,
> > +						     false);
> >  			if (consume) {
> >  				rx->packets++;
> >  				rx->bytes += length;
> > @@ -1205,6 +1341,125 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
> >  	return done;
> >  }
> >  
> > +static int tsnep_rx_poll_zc(struct tsnep_rx *rx, struct napi_struct *napi,
> > +			    int budget)
> > +{
> > +	struct tsnep_rx_entry *entry;
> > +	struct netdev_queue *tx_nq;
> > +	struct bpf_prog *prog;
> > +	struct tsnep_tx *tx;
> > +	int desc_available;
> > +	int xdp_status = 0;
> > +	struct page *page;
> > +	int done = 0;
> > +	int length;
> > +
> > +	desc_available = tsnep_rx_desc_available(rx);
> > +	prog = READ_ONCE(rx->adapter->xdp_prog);
> > +	if (prog) {
> > +		tx_nq = netdev_get_tx_queue(rx->adapter->netdev,
> > +					    rx->tx_queue_index);
> > +		tx = &rx->adapter->tx[rx->tx_queue_index];
> > +	}
> > +
> > +	while (likely(done < budget) && (rx->read != rx->write)) {
> > +		entry = &rx->entry[rx->read];
> > +		if ((__le32_to_cpu(entry->desc_wb->properties) &
> > +		     TSNEP_DESC_OWNER_COUNTER_MASK) !=
> > +		    (entry->properties & TSNEP_DESC_OWNER_COUNTER_MASK))
> > +			break;
> > +		done++;
> > +
> > +		if (desc_available >= TSNEP_RING_RX_REFILL) {
> > +			bool reuse = desc_available >= TSNEP_RING_RX_REUSE;
> > +
> > +			desc_available -= tsnep_rx_refill_zc(rx, desc_available,
> > +							     reuse);
> > +			if (!entry->xdp) {
> > +				/* buffer has been reused for refill to prevent
> > +				 * empty RX ring, thus buffer cannot be used for
> > +				 * RX processing
> > +				 */
> > +				rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
> > +				desc_available++;
> > +
> > +				rx->dropped++;
> > +
> > +				continue;
> > +			}
> > +		}
> > +
> > +		/* descriptor properties shall be read first, because valid data
> > +		 * is signaled there
> > +		 */
> > +		dma_rmb();
> > +
> > +		prefetch(entry->xdp->data);
> > +		length = __le32_to_cpu(entry->desc_wb->properties) &
> > +			 TSNEP_DESC_LENGTH_MASK;
> > +		entry->xdp->data_end = entry->xdp->data + length;
> > +		xsk_buff_dma_sync_for_cpu(entry->xdp, rx->xsk_pool);
> > +
> > +		/* RX metadata with timestamps is in front of actual data,
> > +		 * subtract metadata size to get length of actual data and
> > +		 * consider metadata size as offset of actual data during RX
> > +		 * processing
> > +		 */
> > +		length -= TSNEP_RX_INLINE_METADATA_SIZE;
> > +
> > +		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
> > +		desc_available++;
> > +
> > +		if (prog) {
> > +			bool consume;
> > +
> > +			entry->xdp->data += TSNEP_RX_INLINE_METADATA_SIZE;
> > +			entry->xdp->data_meta += TSNEP_RX_INLINE_METADATA_SIZE;
> > +
> > +			consume = tsnep_xdp_run_prog(rx, prog, entry->xdp,
> > +						     &xdp_status, tx_nq, tx,
> > +						     true);
> 
> reason for separate xdp run prog routine for ZC was usually "likely-fying"
> XDP_REDIRECT action as this is the main action for AF_XDP which was giving
> us perf improvement. Please try this out on your side to see if this
> yields any positive value.

One more thing - you have to handle XDP_TX action in a ZC specific way.
Your current code will break if you enable xsk_pool and return XDP_TX from
XDP prog.
