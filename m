Return-Path: <netdev+bounces-8411-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33505723F4D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:23:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FFC91C20EE0
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277272A9C5;
	Tue,  6 Jun 2023 10:23:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C02128C3A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:23:16 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F6810F6
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686046992; x=1717582992;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2J4fRnYXueVsFen5PZS4ma1Hp0GP+X9mktOiN0tTLtE=;
  b=N7teVAhKyS3H4QpPHvAtby3HMa282lKywMgqJE38hDtlgzj2Sb0zlQ4W
   maPrVY6q2ScXwczdxEx05AB8lLaayYg9+fEwMx0Ih6JQT/dyV/pEu7EWU
   UGy64bYBJbOuOxtKMeLQ0mWbFL8RS9hDgVdgKjTH0yZFdu+WlhURXouIO
   joKJgVuIRZTDHbqboytTzavkQ+4oebMwhOCQ8xr1vsQ44HVHzKyKNZY6t
   TT30teTnskn/UqZVhMH/sCvhZ5itNiFfPHX7e+pVQli2ETYRQkzSlQfyK
   AHlp4INmuMVQrYx6XNlC5Q0letxYHKTjMyhMjw8tfbT9TsmgcOhLH1sEd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="355480170"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="355480170"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 03:23:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="798783846"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="798783846"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jun 2023 03:23:11 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 03:23:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 03:23:11 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 03:23:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgcjeDcm5Y/DBkpaUkCP6j8K87anvNk8tsYBpZrCKg5ZWvdJLIp/uONKVZeBiUgqv8FOp+vv8QLbRGawny44Abd5iR9okzOpr9tNBDIWD3u6aunJwr62DmUYJnN7Vm6aClbnt53jEYbb7vnqH55ewQdU0qlTM5ygwJqzE95sWg70HXihxLRy7JRunSpsJpTUKlekP/uo5vjnvJ9BahRz8hV8/GHknpPii8k/DsPqOUEZP/t6SPqbvd0a/ZMaoigo/ri30P6eQ88BDWvfyANrswcUwZJInoxXhO+Ra3HFfBtQ6PByX0qL6YAKnPKwZp8ZWgJJuWq7xIMslFnxH9WCtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwSqx6lkA563yQRlQ4br9e8gVaaW303KhSEtEVLc3V4=;
 b=G/gYSOAoOv0O1s5I9WUtDf3EjW+msRpp+XZAuJNL2UiQpCejZlE2B2q55izVw/+OAxjD/n35gQnyvfucrD3wYr99o5urunwJr/xPZ6VIeNp04uAo+jbVV6wP67zqlRPlhjPYRKEO1JkCGHH5rqzch0HzBv6rnmWImbLwKO0VdQcKtsByb+X99tnLfKdmy74s9IU+EUn8+/TWg1M9OoOHKkWY8OnBv7hNext3ymolWKi0vMZlPXU4hC+k74gMZQwbpCX5nb3qF6JzNlllsko3TZZaml2LeW4x353QkkcCe0xrJbJVhz8i2amiQRraj7qPgk9XrbGIDAqwkNrtamFGCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DS7PR11MB6221.namprd11.prod.outlook.com (2603:10b6:8:9a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Tue, 6 Jun 2023 10:23:09 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Tue, 6 Jun 2023
 10:23:09 +0000
Date: Tue, 6 Jun 2023 12:23:02 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>
CC: Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
	<netdev@vger.kernel.org>, Piotr Gardocki <piotrx.gardocki@intel.com>, "Michal
 Swiatkowski" <michal.swiatkowski@linux.intel.com>, Rafal Romanowski
	<rafal.romanowski@intel.com>
Subject: Re: [PATCH net-next 2/3] iavf: fix err handling for MAC replace
Message-ID: <ZH8JBgiZAvNdfg4+@boxer>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-3-anthony.l.nguyen@intel.com>
 <ZH40yOEyy4DLkOYt@boxer>
 <29e3a779-2051-d4bd-08fc-2835b05de55c@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <29e3a779-2051-d4bd-08fc-2835b05de55c@intel.com>
X-ClientProxiedBy: FR0P281CA0101.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DS7PR11MB6221:EE_
X-MS-Office365-Filtering-Correlation-Id: 47c1e205-511e-4c82-ff52-08db6678067c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XdDg6eH5RRw5+bJFijPlpG3Y79WYPz5k8siPJqij2yOp7KHr7e7L5yTjZgruwh+X95/z+tEhNiSOCzg4IDgdrpX2Rfw7xO203Z1k4b0POXKnA0xmQJB0ehah0i0zsy3MxA3YhNrtmBJtkfoOMmxUtayIt6hHNPy641Nl+NYTMrqcxSigZwSulOnnF2jOEdBelP7kJ4N97wH03+sBlK3vhOEcVS1Pt2ONmz5f4LWwqbx3O/YMICA8Zg2lFynh/D+b/d86w9busjDt0AtTytI6UG4oDsr3r68Wg/c01ygd8hCTjAMsMx2o984Y9xgQDg3Tk5DzAK7/+Jlua57P8Qj1x372eIiuFGz+iGM5okLYWWBJFDWvxJDTlr1PqykXEy1zHFK94Nj1zFFNtXdPKzx/nUnFukaNaRpHy2w1kuBeeZYXIikF9NrTqiBzTPPKHeRJ2jK4yPa2EYZnMS8YmdAVjqzrWahMf2g2Lpr+NICgNTz/X7GtkNR0GFNX/5IWZmpsoCjncVODffuKQyHcD4/Qca/JhJWmV6ewhp06rgZXZHXF3Cki3b4JXIE/2CoKHtfB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199021)(83380400001)(38100700002)(86362001)(33716001)(82960400001)(478600001)(41300700001)(6666004)(6486002)(54906003)(5660300002)(8676002)(6862004)(44832011)(66946007)(66476007)(4326008)(8936002)(66556008)(6636002)(2906002)(316002)(26005)(6512007)(53546011)(6506007)(9686003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NsdONqZlZNXBEst+W1A6vSWIoXv9Tw8/e5BY8hwiwDkGlfhywqUzVqfBFZ2Q?=
 =?us-ascii?Q?BKkX6+LMr3/DLuhO6MFfoTpcccvSB1xw4pLhgXwXdgaOgTlvY+pUjlzd6URt?=
 =?us-ascii?Q?zGoZmwqB71p2j99+siZs8p3Fa6wfcbtGqMT1TLgL+Dbql77AgYcMUkJZBEdG?=
 =?us-ascii?Q?T+Wr4HXOm6dErub+rE9+VzPQ5zDFZTUVkmPl9nahvTFZ42cRL7+F/ZnUVJRM?=
 =?us-ascii?Q?Mqkescd22u0L0G/UIsdu6stCIFkWTdbnmzk/hgUYn2Wu0OSgo+cmHww/ls1l?=
 =?us-ascii?Q?vAIRQjhXZQx7z/RrulY5qr0G+XtnhuwdlgS55EU0kf2nkNQZE650BV9YF1PJ?=
 =?us-ascii?Q?HdsdJj4PvqP4H5q0xEwa58MXuLVuZyiywxw9JzRxHfl3Zr9EkaByjrMmZcda?=
 =?us-ascii?Q?eUMZlmuXhCp6EcfPzjM5tBI6RW92IUrMA1Oz0dhn69kKDXgmcwSvCF9OkyeZ?=
 =?us-ascii?Q?XFWWzoq8lnbqs/7tVw1yMTD8BhwAon1VcpP/j8AcSOowkZJVZBtTqKujb08T?=
 =?us-ascii?Q?WwCwRWFGdtHpUYmB8hqvXmGr1UkuIJXXsuEDvhHpMroXjipEwdl14RhjOhwv?=
 =?us-ascii?Q?tFLE90fikB1ydmqsk0oVatnJs911XKs8n4cn7dBJVR2n4UCMof/AH6DmJJ4H?=
 =?us-ascii?Q?WlimCWL6eY0K61VRG/Ge93yOTJsbw7dok5OFbKPO9M0WF48hgSdV1KRPZzKS?=
 =?us-ascii?Q?RTVEGpnS0uxi044L1B05nBqcc9Jyxo6yOGaekzIkM6dTQ+rQSaBXrBYMl64s?=
 =?us-ascii?Q?H0R7i5Z+1tt9p5TNoVWm3goUiQWna9/2YXINNoUPtT4PeZT/u0ripG641hxW?=
 =?us-ascii?Q?VlIfnZxBZxiUtvA5X2cxN6dh+2niC7PWjwNJNeByZsfM53R8oOY559hMPcfH?=
 =?us-ascii?Q?nrSPqiXtJ2/35kxPVQpeX09uuW/u/atzVARAHQhWr6+gugHtHnKo7QHcMAGE?=
 =?us-ascii?Q?9ZY1ppTkD4VT27aJgFFrA1RF99jtbaTF5bI1i+ZZnf6JfhXVlIrzxmxtfx4/?=
 =?us-ascii?Q?MyEcRqCgdvqYalnKZYMobt9v6ilhg42FEUFAyyIibDfDwqH/+6XyzKwkrSA+?=
 =?us-ascii?Q?vk6yJWcReJt7wD2kdzqdbBrKq1QAEW2Jha6/SNAALyHAl2wk/hYuDIdxUGhm?=
 =?us-ascii?Q?M/nmRwPExMsXmniuqRgTcynqHhUuO5UrSvexxwcBHj2/C0Fr+dzqRRElDBP7?=
 =?us-ascii?Q?Di/uYQuVN9PlaxXZFfli5QjOi2E1b50QZ5w1WcrZSnysxzux32PChxjwLbfv?=
 =?us-ascii?Q?dkR7/Jka9X/QrPwV7I0UvF1rWs+IYlfLIcMRGi0EjcfzV7D5okpXOftf5yx5?=
 =?us-ascii?Q?ratdnoNt8WONi6P7ex3pN/M21ph+19SzI6a6eVoT6g3JP9NuAzF4I7UTdFPb?=
 =?us-ascii?Q?SQURY9shpiG7ZMWX2qTHUNG+IO2iXrIYI1KEwvycMO2ZoatuhhESIMnHok3y?=
 =?us-ascii?Q?SSdqhPTUatwEdipgTmA/u5Fm9ff+DXcVrOflXvYVrVfYpCjEDm7ho3eZguzz?=
 =?us-ascii?Q?L1KI6ifg5oiESwhfD1KMnRgpNvkBN18lpUD+6dKB5bbca0MUaAlfBqd2h+HV?=
 =?us-ascii?Q?zawwiW6rI3xPhCfBmfG1jrdNQ771y39P4Zp9yHvaaUyhB0h8Q/DSgKLX2M7/?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47c1e205-511e-4c82-ff52-08db6678067c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 10:23:09.6901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NvwoF4RjDTwTaHUgAkTvj/ZSzpIfHVKZe6KKyRBkoFqCs4t2+jgMW34/EwxoR/e56FqPd2Rmqyd7sBgY8vghgzHffPWvpr+4xvhxopylhuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6221
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 12:14:49PM +0200, Przemek Kitszel wrote:
> On 6/5/23 21:17, Maciej Fijalkowski wrote:
> > On Fri, Jun 02, 2023 at 10:13:01AM -0700, Tony Nguyen wrote:
> > > From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> > > 
> > > Defer removal of current primary MAC until a replacement is successfully added.
> > > Previous implementation would left filter list with no primary MAC.
> > 
> > and this opens up for what kind of issues? do you mean that
> > iavf_add_filter() could break and existing primary filter has been marked
> > for removal?
> 
> Yes, prior to the patch the flow was:
> 1. mark all MACs non-primary;
> 2. mark current HW MAC for removal;
> 3. try to add new MAC, say it fails, so that's an end with -ENOMEM;
> 4. ::is_primary and ::remove fields for the ::mac_filter_list, alongside
> with ::aq_required are left modified, to be finalized next time
> user/watchdog processes that.
> 
> For me it was enough to treat it as a bug, and for sure a "bad smell".

Thanks,
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> 
> > 
> > > This was found while reading the code.
> > > 
> > > The patch takes advantage of the fact that there can only be a single primary
> > > MAC filter at any time.
> > > 
> > > Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> > > Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
> > > Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > > Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> > > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > ---
> > >   drivers/net/ethernet/intel/iavf/iavf_main.c | 42 ++++++++++-----------
> > >   1 file changed, 19 insertions(+), 23 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> > > index 420aaca548a0..3a78f86ba4f9 100644
> > > --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> > > +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> > > @@ -1010,40 +1010,36 @@ int iavf_replace_primary_mac(struct iavf_adapter *adapter,
> > 
> > from what i'm looking at, iavf_replace_primary_mac() could be scoped only
> > to iavf_main.c and become static func.
> > 
> 
> makes sense, thanks

are you going to followup on this? probably there are some more low
hanging fruits out in iavf such as this one.

> 
> > >   			     const u8 *new_mac)
> > >   {
> > >   	struct iavf_hw *hw = &adapter->hw;
> > > -	struct iavf_mac_filter *f;
> > > +	struct iavf_mac_filter *new_f;
> > > +	struct iavf_mac_filter *old_f;
> > >   	spin_lock_bh(&adapter->mac_vlan_list_lock);
> > > -	list_for_each_entry(f, &adapter->mac_filter_list, list) {
> > > -		f->is_primary = false;
> > > +	new_f = iavf_add_filter(adapter, new_mac);
> > > +	if (!new_f) {
> > > +		spin_unlock_bh(&adapter->mac_vlan_list_lock);
> > > +		return -ENOMEM;
> > >   	}
> > > -	f = iavf_find_filter(adapter, hw->mac.addr);
> > > -	if (f) {
> > > -		f->remove = true;
> > > +	old_f = iavf_find_filter(adapter, hw->mac.addr);
> > > +	if (old_f) {
> > > +		old_f->is_primary = false;
> > > +		old_f->remove = true;
> > >   		adapter->aq_required |= IAVF_FLAG_AQ_DEL_MAC_FILTER;
> > >   	}
> > > -
> > > -	f = iavf_add_filter(adapter, new_mac);
> > > -
> > > -	if (f) {
> > > -		/* Always send the request to add if changing primary MAC
> > > -		 * even if filter is already present on the list
> > > -		 */
> > > -		f->is_primary = true;
> > > -		f->add = true;
> > > -		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
> > > -		ether_addr_copy(hw->mac.addr, new_mac);
> > > -	}
> > > +	/* Always send the request to add if changing primary MAC,
> > > +	 * even if filter is already present on the list
> > > +	 */
> > > +	new_f->is_primary = true;
> > > +	new_f->add = true;
> > > +	adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
> > > +	ether_addr_copy(hw->mac.addr, new_mac);
> > >   	spin_unlock_bh(&adapter->mac_vlan_list_lock);
> > >   	/* schedule the watchdog task to immediately process the request */
> > > -	if (f) {
> > > -		mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
> > > -		return 0;
> > > -	}
> > > -	return -ENOMEM;
> > > +	mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
> > > +	return 0;
> > >   }
> > >   /**
> > > -- 
> > > 2.38.1
> > > 
> > > 
> 

