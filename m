Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046D563D514
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbiK3L6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiK3L62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:58:28 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527936DFDC;
        Wed, 30 Nov 2022 03:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669809506; x=1701345506;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nK99zNxXxKvEGYLOOK7z6x6WoYxvd4iUA9WN4m5ppWI=;
  b=kTJxklfR0WEvXAc/+S90/wswLc5DaDY/jgRevjAzxKfzTI90h1v3UnlV
   XxTyv+xZBTOdJP2ZvGr9lmGJN2ZPxcVoxt8ooL/NCaWFWZAfmrPJnhSk6
   PC484iT32aByA/rQ8NR5omaj8R02Ze/K7oaoAdL6UBLJAOBiYarkvBJmx
   rqzftoJk7iXwGktTJLZ/MrnaXJI+JANiOIqfrZauHWh+l7zxsVVRUZQu7
   HRdH65DfOKqLXLgKbTlKhdXnc7jmwOs9Q1jsnJ8dxjYKyjfQgSxTwdPgu
   t6FOHT6ibnYXVClOcBWfPkObXDnrgzfTtTAdkQ7p/wMRjy1tADKJGWHfj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="295740925"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="295740925"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 03:58:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="675001657"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="675001657"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 30 Nov 2022 03:58:25 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 03:58:25 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 03:58:25 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 03:58:25 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 03:58:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4vZ6NioBA7vx/SryawQNxsU0o0fA3uuF5O7MfefygKjbP9tYCP/1YXa8fN4rZ6zBvnNGP7j67eePxH5rLTFPd1zyOyqYjiNDnCMeV8l4jy9BgjouuiLa/daDOtdbLsS2Ja8go5r5p3ezb/7zoBsFXKS6IFSt8Ixj03VW/1KWD7jPFFLt3WGMwJiE2HDkPuuaUnUzGl1PfsHp2qBV6jcWhBo7pKxhSFpsiotjE38EwAnIQoWHbl8yxIGP+ZEGkZi6RcV9/COqe9DoFqpZh2wZokWvgYareKM9GC6rqgUyPALN8ZcYTcN7DFFYWtjq/1JqGQcrI4HccoSInF5dHIjAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WrVvL4oCELV5T5IL2jHWbyhpYZWHQK/BnnEFWxRw7g=;
 b=a3tZ68l89yenUTgL/t24qk6ZYy51baii7pDp7nBQiluFU4jYBnS1+5Zz+9d2KZbYhst1oUaX8yNa+9yZ/Z9+6u3YMIX4bXh3k5hxRZne5arCJC04OnVcKl3wXu+Rz/3hmoMSnnxEI8nJotzLWPrs/1UThSbqhtq2BgiRdeXj8dJY0hhS6mpdm6RKztwuO3+7blQiCNqIxZg7BPBXfv6I28mDUtiUOZrsnZAu5fx46e3obfR9UmBUE8uVbaVd8cnZcUUOjvTc54GlhoxztPcZFV0q7py217dKvazwPY7rpH90+9Vat/641PC5W135qMHhNJE+NZvNn3JGBhJ4nUvxeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA1PR11MB6685.namprd11.prod.outlook.com (2603:10b6:806:258::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 11:58:05 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%7]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 11:58:05 +0000
Date:   Wed, 30 Nov 2022 12:57:59 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>
CC:     <bjorn@kernel.org>, <magnus.karlsson@intel.com>,
        <jonathan.lemon@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] selftests: xsk: changes for setting up NICs to
 run xsk self-tests
Message-ID: <Y4dFR9oR3AAIcPlB@boxer>
References: <20221130094142.545051-1-tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221130094142.545051-1-tirthendu.sarkar@intel.com>
X-ClientProxiedBy: FR3P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::10) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA1PR11MB6685:EE_
X-MS-Office365-Filtering-Correlation-Id: fb6410f1-624c-4666-8bc1-08dad2ca23a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bp3rbgv9skuVdcv9ItZqkhMNqIubp6Sy79Mm+zDAe3AVcoE4VXAr5NzuJvkl+C3DVDroQY+CKo7WhfZ12qM68XkmNUjL+TgPwH+Wrnlk+IHClLUmim7XxQ8e27Ohl0s6RN+kT62ZDNyMezEWhn9E8lLI937eJYj5XGyUAgrJzFDtx4//jw+rliCZzw/56zl0mFixFWhEO+35X2LRMD+0aTCpSdYqK0vUpBsMScvF9Il0LCE3Lfz8qPmN3IvtvlRwNgnozlpCxCVwoOpZUAG45Uwvml+PMiLwya4GJd9pblB40PRmzCQYx4c2FbpadQtw3jsJDgu9eKNOa67FKc9aBIhBeKUeF6YZAJOPqSnrkjpa9WPjSnQBsw07TwtSNdV9fSXiGn8nw1Tkf6LNqAJuyZiJIZQalWS3pZ4IH6zSwWlJI8pV84zSwYCvBAjGiALJw306XGyoFSz55BJL2ng/wEzbnSz7CGniO0wh8mnE4m0hY16pWCh06TOT5zZwR1I0n0nSftLr4gTnCXGQoEqyjKyK+hxDAb8+hJ786wich0SZPjqs4Fnpj3vfHZ+KuvwYPJ2IefamxGf/UCuPFg6yq1Dq1Rr9HaMkF3kURs5q4df855d6TFqRPsxyaO9NiSKw2L0kjZpx7mhSchC+szMcyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(136003)(366004)(376002)(39860400002)(346002)(451199015)(6512007)(82960400001)(86362001)(33716001)(6486002)(41300700001)(6666004)(9686003)(6506007)(5660300002)(66476007)(478600001)(8936002)(316002)(6862004)(8676002)(66946007)(2906002)(66556008)(6636002)(4326008)(186003)(26005)(44832011)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mhx3m+sBzBdeLEvz1fdvwQJnxiHLgowUQ+1wSiGjgYh1dKLdjNrUTAVr2C5O?=
 =?us-ascii?Q?1MxjWvX9b9Gj6ZhAsARaSnGeT/B6TVHm9kp4RrLZCwG0Wr7KmDmeyja2qkQo?=
 =?us-ascii?Q?1NahTOgAnDh2hYdv4m6/KEJ5kz5Psw5oHEH2/gsuvS6GseGtk8v29rj0uLCp?=
 =?us-ascii?Q?kqnZrvO5Cd+++O3umrgqZSag+RFLE/Vqek7a663xJs6N0mNgYUol5W2kqyw8?=
 =?us-ascii?Q?X+RaGZHwOMj2N9PpWW8O82gQp5LlLglhsqbomYSXDVnggr/vPDBqaPUV/HUU?=
 =?us-ascii?Q?pnv9yuEWsgjv7bkYL3NxsnAU21aCEDkZ1EzK3KO7Sp+gaKYKWmdbbi7oa1cv?=
 =?us-ascii?Q?W6rft1Ws4FHwRoJPdjFfa5dzcWVoX3RFJEWQXBWiVaHZZKaRAu/3gJ+mTUPt?=
 =?us-ascii?Q?FunCWEn46J/j40AbVh1BCk4pMqtZlVJTX7ezkit1NRcT5OvkXaEgSuAHwyrt?=
 =?us-ascii?Q?8b/tNzxxeMH4z87lnQu+qb//8je/ibKN/CsKeWleAHVbqfQ4m/VZt5tAJNq4?=
 =?us-ascii?Q?GKfNPiXGOARjXDbfG/xMfridt+r0H5Ww7kXzp7lpQE7cATklgUrNDVhFwUi9?=
 =?us-ascii?Q?EtgGW75JwIVFSjYyCgKa5xK2d9WYa96oPp2JzgL8uKrmnSGBYAHzBGFyFxa+?=
 =?us-ascii?Q?Epx/q7UHpCNJiVjcIqZWdJwdhguthQdj7ysRbUe9Vn2Gywhr+WmUzrTF3893?=
 =?us-ascii?Q?PYZbJGV7uomNSE+iEoOY5k4kspO8GLnQEUE4pDwQNqkI9ZaFSLvX6+5jMoBh?=
 =?us-ascii?Q?vf+Q0JDVqRFJzl3AJkpXC7BaVwSce9KONyEbjq+rngNSUxRWn/QQP6+T5Bee?=
 =?us-ascii?Q?hvyx3XHjZQcS+GUzASZPZDin+2fMkswvN5PmKwYt3Xady2tApCDvQrJgcGM0?=
 =?us-ascii?Q?+tVhNgEN9uaIuCykjjSFM7nVlUOWVWgDqj/w3dM2rbPwELzl72OreFuHmXKC?=
 =?us-ascii?Q?xNgurFn/w44MfusNufrrYTZ6kL21xA9b+oChWB15HRrA3EC4E9wGyx9BOByf?=
 =?us-ascii?Q?KMQDu03MuEtEahHby2+akv95Pz450oMQsSHSucv6nTtV1/iAuJXCjM1Qx7qh?=
 =?us-ascii?Q?plhr7etfxTNottAdksdMJvs16WmDYLBGkDouDvF88lZAKLA4zf0WT53L0KC/?=
 =?us-ascii?Q?b4tEhzWkhOf3ubOLWOcnLiq/T17WNG4Cbp4/+UK6AHjUDm74vxgr/aOVhTCP?=
 =?us-ascii?Q?k9WsnUKh5hzIKtBCrei6nr6uDKKPz5nfsX69y5LhLD3tz1f/ny4VCxN/jaSB?=
 =?us-ascii?Q?g+RfMLDSFkLRMP2NbDdeCqXiYIngO6DbeY96A2Mr29+mwZ9di+9rI71gRlPA?=
 =?us-ascii?Q?huRACREF3x2YxZTfOowTwDScV8lLc6jkNsDBnM0KdXwINnlaM89wxbv6/BHc?=
 =?us-ascii?Q?HuDzIXcAHxGKsqN3y952utHR8AgmBwy+EoiM1flrZ3qgeyPHn6kONgI76B+B?=
 =?us-ascii?Q?sUpzfNQnfTP1bFEX17LfD1Xn37W6Ovr64piMapmjV2Nl1nsdNN0GMD818xzj?=
 =?us-ascii?Q?IYI7rYO53e5Bpq9N7Q4VZ7cu5gKwqsUWXnDWe/Inp6dyaJ5LKA6ZhZ4bRGai?=
 =?us-ascii?Q?DW/ItR2wjQkFLYfytmLjaLJnLnqUvwRBeTgNrohq32667/Jg/6OMf6veaFzt?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb6410f1-624c-4666-8bc1-08dad2ca23a7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 11:58:05.0693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BME1P1ZGvBp9cIA0U0hg2nKxO+kRJdBnVhCeg8d+yUiskd9IMYAzoaMd7qGgbh011GA7HW+Lgb7/EG/MKnRO59IRnqG4eMuyokv40+rD9D8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6685
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 03:11:42PM +0530, Tirthendu Sarkar wrote:
> ETH devies need to be set up for running xsk self-tests, like enable
> loopback, set promiscuous mode, MTU etc. This patch adds those settings
> before running xsk self-tests and reverts them back once done.
> 
> Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> ---
>  tools/testing/selftests/bpf/test_xsk.sh | 27 ++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
> index d821fd098504..e7a5c5fc4f71 100755
> --- a/tools/testing/selftests/bpf/test_xsk.sh
> +++ b/tools/testing/selftests/bpf/test_xsk.sh
> @@ -106,7 +106,11 @@ MTU=1500
>  trap ctrl_c INT
>  
>  function ctrl_c() {
> -        cleanup_exit ${VETH0} ${VETH1} ${NS1}
> +	if [ ! -z $ETH ]; then
> +		cleanup_exit ${VETH0} ${VETH1} ${NS1}
> +	else
> +		cleanup_eth
> +	fi
>  	exit 1
>  }
>  
> @@ -138,9 +142,28 @@ setup_vethPairs() {
>  	ip link set ${VETH0} up
>  }
>  
> +setup_eth() {
> +       sudo ethtool -L ${ETH} combined 1

what if particular device has a different way of configuring single
channel? like

$ sudo ethtool -L ${ETH} tx 1 rx 1

I am not sure if we want to proceed with settings that are specific to
Intel devices. What if mlx5 will this in a much different way?

> +       sudo ethtool -K ${ETH} loopback on
> +       sudo ip link set ${ETH} promisc on
> +       sudo ip link set ${ETH} mtu ${MTU}
> +       sudo ip link set ${ETH} up
> +       IPV6_DISABLE_CMD="sudo sysctl -n net.ipv6.conf.${ETH}.disable_ipv6"
> +       IPV6_DISABLE=`$IPV6_DISABLE_CMD 2> /dev/null`
> +       [[ $IPV6_DISABLE == "0" ]] && $IPV6_DISABLE_CMD=1
> +       sleep 1
> +}
> +
> +cleanup_eth() {
> +       [[ $IPV6_DISABLE == "0" ]] && $IPV6_DISABLE_CMD=0
> +       sudo ethtool -K ${ETH} loopback off
> +       sudo ip link set ${ETH} promisc off
> +}
> +
>  if [ ! -z $ETH ]; then
>  	VETH0=${ETH}
>  	VETH1=${ETH}
> +	setup_eth
>  	NS1=""
>  else
>  	validate_root_exec
> @@ -191,6 +214,8 @@ exec_xskxceiver
>  
>  if [ -z $ETH ]; then
>  	cleanup_exit ${VETH0} ${VETH1} ${NS1}
> +else
> +	cleanup_eth
>  fi
>  
>  failures=0
> -- 
> 2.34.1
> 
