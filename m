Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B446ECBC0
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 14:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjDXMDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 08:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjDXMDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 08:03:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E743A9A;
        Mon, 24 Apr 2023 05:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682337807; x=1713873807;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Wo0WjcC496asUigQ3xVn8WwEq56T9T9aBQyv+pXYz7M=;
  b=mbDSblk9o0o16jAKvFy1RVtJ/EuaS2bMKDAC4nH7S6fueoVqmh1DdBJP
   wsSL0l6eUMcD5JfNOzsCqGujjSxjK1kLBZmCOyNP21CuJkdp5eOZ/Phh/
   HO0Qa0tn+GV3ZcmnsdBPqBatJ24WorQuVeDKtQpolXYIhFnhXyFxS7j4U
   o78GzMoUot8UVj4BwSCdN8dTUNNxlhEbyz8zGF/kGSfWw2FIhaVbgoGGD
   4LuOzLg3BVRBi1A/lmR4mvjIR4KRqy6mcX4rOtxXwF8abNAfqOAwKQu4d
   9xSSe+QWLEZ2RQDiIBzJ7SE/QwMfqKGg6eFDRrTvGN1Ths3xuBC0GIdOI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="346458293"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="346458293"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 05:03:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="804595830"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="804595830"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 24 Apr 2023 05:03:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 05:03:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 05:03:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 24 Apr 2023 05:03:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 24 Apr 2023 05:03:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOiOl3Be+PVMYEQPHTBzrkHjXrThRacAQyC3xqeDqaT/vCupdV26TcUdeTYp5KB2zieDg4mZLym5Hw7dKgeI6B7vGdM1wOyUMTWQTxWgM3ldgNWrRI2Zkd1idwen5iJN0m00CY3NVGISrNed+ZVzobYDWwM8IpfIErbAnQ2x+TVCiLhB13V516JwAYQ4SqRhZdL5FJX1MYIjG1HJKIRAondnP09y43ttJ1Nr/Mq+RymINZzo40U35S+Gr6pWNOf+DxIPBVQxEjcSZ5k2ulGFX7xN33OnPoeAMxxMPsz83D84X1IfrjzSvPl0Aix8SRCa4nQqhNPEup4jQjET7EOqbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VxW3cdw5vNNP7IYC6tOHbsBq+Tyl5pr1GHZU1VCFBAc=;
 b=UGOfXdbQqUYv5awXDar9hFHWxTKTg7Dqf42QRyNKuRmfvO4HSKdVei8+inRfbA2XkcLqqPcZy2A3oBeFsoGGYGGJ7L64XmwV5dnOey13uuqK8c6NzdN4PszwzHNP0q2f6urVuNfKu3sunQk9NwDxlXAkIUTvrXImpAWAjVXRlSKp29o/Sc7OI6lzO/HBVFiXLvqM3CtzPwDLt29fFxtewqylnpBtoSnl4LA8EmZX4LS0g3veQUTvrmq4Q/Xu2EIlpd3rUhLlpCVJaABS055UJQhMihCVQjxHaya5TFOwrm4gQ3ESDEuUwv/NObFVyZ+IF0cCUOIrdNNOZw0+CioczQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CH3PR11MB7842.namprd11.prod.outlook.com (2603:10b6:610:128::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 12:03:22 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 12:03:22 +0000
Date:   Mon, 24 Apr 2023 14:03:07 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <bjorn@kernel.org>,
        <magnus.karlsson@intel.com>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next v3 6/6] tsnep: Add XDP socket zero-copy TX
 support
Message-ID: <ZEZv+5DJbEzn28+M@boxer>
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
 <20230418190459.19326-7-gerhard@engleder-embedded.com>
 <ZEGd5QHTInP8WRlZ@boxer>
 <fddf3dd3-2d75-3969-7a62-a4eeeb6ef553@engleder-embedded.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fddf3dd3-2d75-3969-7a62-a4eeeb6ef553@engleder-embedded.com>
X-ClientProxiedBy: FR3P281CA0132.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::12) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CH3PR11MB7842:EE_
X-MS-Office365-Filtering-Correlation-Id: e59b8436-7f6d-44bb-ea49-08db44bbe699
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4jAr4M21ZwCV4AmioHLstOjQaV58G+UNgn2TPFKmIzqBYQrYaWIpPlv1hgWGh+nyYUA8cXQo3FHIPgAcDcprBgFBiReVTHn13Mcm+jwAlHJMyk51P6qCmHz/+bF1XrkSQSGL8Tx5MtwP0IlJhupbqi5wwHskNhVDOquvgttaNzbeb52lk+opkY7D3Ns2lPYZLQr2aXplyuEfy+f+5KsS8jyZtCWFdJ9YObHcNlWViQZ3nkBSIWvzS+XAyI+Ja+eN4cCT+SNHGxhK/8uan3QM7kc5oZ79eHoUcZgljPbGuuIA66NDatt+QKedN2dXqwRppyUopIR1Z8i2WlUxY5nDI1KMj/BxAp1n1yDkjk4FG79dDWURiiwlk04ynu4Z1cIlsTKbfAyv6sWueU9VtgyxP+aPbuvmtLaHzEX8tjs+V5EmG3u56+g8Vy1STVTImbw83mrgy1dGM+b1q91AAOMgGx/W49Plb6cCJW21yz8XHbvtEjmq44s+MwgSfvxvTEltd4sef7YDsMMU/0BtJ1Z46SGNgIVsntt7lfHmj64g/An9Um++7k6UExlLZdkTkGRX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(478600001)(82960400001)(316002)(4326008)(6916009)(66476007)(66556008)(66946007)(41300700001)(44832011)(2906002)(8936002)(8676002)(5660300002)(38100700002)(9686003)(6512007)(6506007)(26005)(53546011)(33716001)(86362001)(186003)(6666004)(83380400001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LWeuU2sUcOpXllk7tDcdpGRp2Cc52gGM2g4mdCMTa0tf479ksW8LAutOvoKs?=
 =?us-ascii?Q?D+3Ir/fBTjd/tWbL/VnDLzkQC41i+GdQRvP9qRn+suI/A1Eig+2CsUZxDpg8?=
 =?us-ascii?Q?urDGcCg3jqcvXjI3BOB96/sUZjMQiO6DAqtEzf/s8q0WAv52l6I6AcF4i2vX?=
 =?us-ascii?Q?sPOp43eCcJxArnNGBeqSTZ0dvS1PITlhf12pPYT7hvzlGO5JXjKGaBy1Tbzz?=
 =?us-ascii?Q?k9oJ09drkxsXLuchJgtiCmA3jL7k+dnj0xSU7uniKLmJvzlJvi1CvadpTL08?=
 =?us-ascii?Q?sI0+JJEa4p94oGr91U1xusGS8NKWdjMs89NalFyCwxbp5VIBz4lFnPYB9L3k?=
 =?us-ascii?Q?BawzWn/rOJlp3nY1I26TLFOpGA32rMK6SImuaLJJv514y+tTnUOGHGpgdpgH?=
 =?us-ascii?Q?GqcjhE0qmcvsWthoQAXca1kLIo2j8o1z1alP3RBVwHikvJATVkvLSfg2l7NS?=
 =?us-ascii?Q?GFWuR6Vztn7XJFCbhqFJJX7cHnqajNSZlPXZpdfYsaltfpSSABU9nfDtTVI+?=
 =?us-ascii?Q?2/5p9b1SYgQY/0EfcLSwbfflfm9cduGCHavT4hnn+3K0Yoqhms+2H3QpdS9R?=
 =?us-ascii?Q?mzkjs637hjRwo0h1A1NBmIOT4sVga46QcBYymTKsffPdQ54+IWd1wG1KqEsY?=
 =?us-ascii?Q?jiVeeG5qz2adTCvqm+wixsIUpViQKJKWLraCkIE40PjRMWaN79EEQzVdlAk8?=
 =?us-ascii?Q?b8jUuKsV2t4jHhg3wpB849/3aF8XVZ95BwsYrDSgdtM9gof0d4pg3rFrn5VM?=
 =?us-ascii?Q?FKONIR1XefTKezk+Nm6ANi1DNf/Mi58nAo4GXQ++BQhN+ATZ0veV+Zc57zKY?=
 =?us-ascii?Q?94aDRvfaUgJ3F+/JDeu4Ow5i9UNAEM4M9+sZVhOB/Y5PNgTo6HHWResnorMM?=
 =?us-ascii?Q?qW+WDWdqel1EgpfsLizQF+HXTASSi+Gwq4pSe2HbEQdRD5XSO9TT8pUSq/Ox?=
 =?us-ascii?Q?zrEsLqcismLqI8JtCpc/O/2DUNsN/z8Pqsj8c+RJZJeGHQxb05lFrCyVE9HB?=
 =?us-ascii?Q?BbS92f+JGB7cDVgmdzEaZMkAlJSTix4jKipeudNej2aWb1swUKjixj+ULrnS?=
 =?us-ascii?Q?VgHmSMhaNNMmDZXQuOuuexPlkS7A27v3GhZLnY3cxh9quPCCZfMWoXxr4Iqd?=
 =?us-ascii?Q?J5lu2uqk7GxBRRn3jUPL2yL+JKvjeh0qs6JY8NqAY39J+Txq9syPwswjpLsj?=
 =?us-ascii?Q?5X5vdsy2LvQmkZrj1TnpuPXFzurZfwuNwZw5kMrUa5CpVAiwKt6v0yNnORTp?=
 =?us-ascii?Q?V5vsagctA9vQUHza1ryDDeBfaSCsD7cr//W0TudZwuGFvNCIVSyxa35Sl4zo?=
 =?us-ascii?Q?HXkTpf8Fl8Zk/i1iSO04hhT1kV78+DciOagu9SFmckpq14xZ11Fr4IYMcQaY?=
 =?us-ascii?Q?r/Ck9CLehUaWuf3JiPZ+62GYDddmJLsNR5Lbw6+qDG2dzg0J0qIs+XGWyG5X?=
 =?us-ascii?Q?zuQdW1vEblLx5odY2KAR6OZGtNuaJyv+cVHOUbeCXiddfu8bp20hQnMMH42u?=
 =?us-ascii?Q?vDZJSxddl6fzie3EFy3kEuaxp7uhZ226yYJT7paQUP+b6iWrnqL4ySzaG7+O?=
 =?us-ascii?Q?xVpktPx0AITUPokkywPEYK6avmxpsNCVVJLZOjWlNLJP1/axDTZZO8V0fSbC?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e59b8436-7f6d-44bb-ea49-08db44bbe699
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 12:03:22.3603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R4KxbmLsR/MyeVFu19cB2/hbNe4DKTr4vGAp52uu6yx/+wtkiyiPmTTe6Zq5KgYJLjrxFhXqCidn9AcZkZBRKy/Ot7U1l6RpuHetqAFj+GQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7842
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 09:02:56PM +0200, Gerhard Engleder wrote:
> On 20.04.23 22:17, Maciej Fijalkowski wrote:
> > On Tue, Apr 18, 2023 at 09:04:59PM +0200, Gerhard Engleder wrote:
> > > Send and complete XSK pool frames within TX NAPI context. NAPI context
> > > is triggered by ndo_xsk_wakeup.
> > > 
> > > Test results with A53 1.2GHz:
> > > 
> > > xdpsock txonly copy mode:
> > >                     pps            pkts           1.00
> > > tx                 284,409        11,398,144
> > > Two CPUs with 100% and 10% utilization.
> > > 
> > > xdpsock txonly zero-copy mode:
> > >                     pps            pkts           1.00
> > > tx                 511,929        5,890,368
> > > Two CPUs with 100% and 1% utilization.
> > 
> > Hmm, I think l2fwd ZC numbers should be included here not in the previous
> > patch?
> 
> Will be done.
> 
> > > 
> > > Packet rate increases and CPU utilization is reduced.
> > > 
> > > Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> > > ---
> > >   drivers/net/ethernet/engleder/tsnep.h      |   2 +
> > >   drivers/net/ethernet/engleder/tsnep_main.c | 127 +++++++++++++++++++--
> > >   2 files changed, 119 insertions(+), 10 deletions(-)
> > > 
> 
> (...)
> 
> > >   static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
> > >   {
> > >   	struct tsnep_tx_entry *entry;
> > >   	struct netdev_queue *nq;
> > > +	int xsk_frames = 0;
> > >   	int budget = 128;
> > >   	int length;
> > >   	int count;
> > > @@ -676,7 +771,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
> > >   		if ((entry->type & TSNEP_TX_TYPE_SKB) &&
> > >   		    skb_shinfo(entry->skb)->nr_frags > 0)
> > >   			count += skb_shinfo(entry->skb)->nr_frags;
> > > -		else if (!(entry->type & TSNEP_TX_TYPE_SKB) &&
> > > +		else if ((entry->type & TSNEP_TX_TYPE_XDP) &&
> > >   			 xdp_frame_has_frags(entry->xdpf))
> > >   			count += xdp_get_shared_info_from_frame(entry->xdpf)->nr_frags;
> > > @@ -705,9 +800,11 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
> > >   		if (entry->type & TSNEP_TX_TYPE_SKB)
> > >   			napi_consume_skb(entry->skb, napi_budget);
> > > -		else
> > > +		else if (entry->type & TSNEP_TX_TYPE_XDP)
> > >   			xdp_return_frame_rx_napi(entry->xdpf);
> > > -		/* xdpf is union with skb */
> > > +		else
> > > +			xsk_frames++;
> > > +		/* xdpf and zc are union with skb */
> > >   		entry->skb = NULL;
> > >   		tx->read = (tx->read + count) & TSNEP_RING_MASK;
> > > @@ -718,6 +815,14 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
> > >   		budget--;
> > >   	} while (likely(budget));
> > > +	if (tx->xsk_pool) {
> > > +		if (xsk_frames)
> > > +			xsk_tx_completed(tx->xsk_pool, xsk_frames);
> > > +		if (xsk_uses_need_wakeup(tx->xsk_pool))
> > > +			xsk_set_tx_need_wakeup(tx->xsk_pool);
> > > +		tsnep_xdp_xmit_zc(tx);
> > 
> > would be good to signal to NAPI if we are done with the work or is there a
> > need to be rescheduled (when you didn't manage to consume all of the descs
> > from XSK Tx ring).
> 
> In my opinion this is already done. If some budget is left, then we are
> done and tsnep_tx_poll() returns true to signal work is complete. If
> buget gets zero, then tsnep_tx_poll() returns false to signal work is
> not complete. This return value is considered for the NAPI signaling
> by tsnep_poll().

i was only referring to tsnep_xdp_xmit_zc() being void on return. Thing is
that there is currently no way you would tell to napi there is more work
to be done. you should do so if desc_available == batch. That would mean
there might be still descriptors on XSK Tx ring ready to be consumed. NAPI
budget is out of the picture here.
