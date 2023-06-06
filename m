Return-Path: <netdev+bounces-8358-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66AC1723CC5
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4718281570
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E031F290FC;
	Tue,  6 Jun 2023 09:15:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9CB290EA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:15:59 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338BDE79
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686042958; x=1717578958;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/28z0nD5V+2BPNofCMfN1S+WZFMQpAiYX2IEFAm8/58=;
  b=c7H+QB9gHUS3TybKIsNeJxKS2OF7vv87mPSigo58OOUaCxMqWmAibNti
   GBary+HiRxIFrWaDd1Or4BkuPdZ2Q6PUOOb2LX3e2hA7twsM9EV/F+VSE
   qCdT+ZtewN57bkHrAxw0GhlGPxikmjYupUBd2DYZz2DXanjb0jQVJA2Ft
   S2sN5HZnfoJLIDkakpVu3GeeZyalz7lKTC6v9PSQSktMwO32nYT0GjXXc
   mDTI9n31W2X/R35pPSKlE+67FWbHKvPfmMhkSPZjApi+yTF32/xteFB/f
   8rggmQawZtPfkSXz5vv0RjtfYp4PHEN9nvDWKlbn+Qhmest/zBBBropBj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="359067434"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="359067434"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:15:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="738707645"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="738707645"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 06 Jun 2023 02:15:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 02:15:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 02:15:56 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 02:15:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQ0MA71dbt6GFv/UbLJOrKOi3yDV0ICctedkAcgeeiGUqSv1EizcHdGak11EEXOfei7guYwbWRZgHIKSJ//FrxhN8cAhZUSAF5lJ62UlRIxKoQlzcHIkxIa72nzN59bC0kqD4pAoSSA1ULUBb2eQRfILe3KtwEUO5BzdCDPQEJ9GpJxqFSpsAUTSD58QJyX10XXJYW/5eoUb8lsElS2vM8p1vf5AtXhUJQi4iEOCyQieP01GFAVNegsCR8Ext4rH01Cp2iqd07lj996wD7yqHJHeWff2UmZ2BJPaVVsYa2ER8wZg3ttlN76HCYmlrd3IZATohAlVxdiIUt3Y44kH0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qe+2r4U0e3lc+0NdQvgv0jCJJSEPrMH/5f+t3rf0h9E=;
 b=YSNH2vywpkzXL8FKkrx52v3P2C0n0nRzdIfxaTVOtT4nEeTek7AR+xQH8zzheejcgYiJxXa+SMMl3LC3FORv4MO3xQF+Sh4A66IlkIvlUku1SSqTmu+qtX3szNptgk6ENuMnKqWPG3PKHl6MK8cXsfz2AOKGDrEQz3rBHT0Jhucx7+YWSZjmnkOpEt4XVv3xw3WD97ANo5DP7+sTDUGi4jRtMPHY6wVtBVgoCJyC8XtY+NL6p6EAAvqXwp8agI6VUOHeB5ggblISfAvTenK33MkTheLSC5sSjRVGNGzfMuJhvOWBYNspbPZW3NUTjyN/UYPwrbyuWklNeRI2SjfHdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by PH7PR11MB7569.namprd11.prod.outlook.com (2603:10b6:510:273::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:15:55 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe%5]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:15:55 +0000
Date: Tue, 6 Jun 2023 11:13:01 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Xin Long <lucien.xin@gmail.com>
CC: network dev <netdev@vger.kernel.org>,
	<tipc-discussion@lists.sourceforge.net>, <davem@davemloft.net>,
	<kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
	<pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>, Tung Nguyen
	<tung.q.nguyen@dektech.com.au>
Subject: Re: [PATCH net-next] tipc: replace open-code bearer rcu_dereference
 access in bearer.c
Message-ID: <ZH74neprbhNXRTTW@lincoln>
References: <1072588a8691f970bda950c7e2834d1f2983f58e.1685976044.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1072588a8691f970bda950c7e2834d1f2983f58e.1685976044.git.lucien.xin@gmail.com>
X-ClientProxiedBy: LO4P123CA0522.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::8) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|PH7PR11MB7569:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a4568e7-a3cd-4d9c-cc12-08db666ea184
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eXOqjO6F5jfIXwuYFnX/bnXERHFX6rqtVSU8777K/EwLOSe47HZsjv/1q38/44JyY5Frh8zL8DYPgyJRBF8J3lT9aAO6ODs47q7vneqfekwLvdkUM7/FhiWF4mMTjV1zzbb18IDFnWYFC1gYY9cEfPNHD/+cXCh7Qf42icd8CGr4tcXlcvPuLlkSyiWOQ9bmWzxmNACWx2IfyWj0w7hxwipWMX/vRLxxYLJE408mWhMc72SvhnDo2mBjg2vWQWBbpdaloZWlV1OxJtbowXGDtx2Da0dKtpOrrm66j5aXKeXdlRWcqnEWZAqHEhSkCyxFnWVHJW+Zb6LfRDp+rwqQyaxgPgOrm48cbKsimZX8qO5b4DHBHRSj7EfCl9C/Fgk6qvh2r1USfXSj18fm5ATESSUE3tjioD0KKEF4+1+VXvQD/+DIFY/sroob2a3cecRCH7c6p0HEVjpelMLHzK8jBYH5Fg8sJnxUf6YlL6HBJ2bFWSkIPigXzpsVNpqu7gKFCGPOex3wcifF4qaFSDcGdAI0qWR3VNvoSm/k1o2/Y5c++9T/j0Ii9beer+SiREnK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(83380400001)(478600001)(44832011)(82960400001)(54906003)(8676002)(8936002)(41300700001)(316002)(66556008)(66946007)(66476007)(6916009)(5660300002)(38100700002)(4326008)(86362001)(6666004)(6486002)(2906002)(26005)(6506007)(6512007)(9686003)(33716001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xoBBezvrWQMXk38zDgUPDk9xcYKR6nAuRPSklpxt+45y7TGzd5YoGAbURMN6?=
 =?us-ascii?Q?vD7i3mysbG2vwyBFKMaTXtWkoAE8zhBeYTQIX6UZo5lP3j/EfV3sSiblDtMF?=
 =?us-ascii?Q?NknEjs6q0ESZWrYPemr7wekmhQUBHrhO3mf0RyE/pL1mnOX2y/6ZtH5RMNCL?=
 =?us-ascii?Q?hr7sCgIa6MgtQGsP8r8o+lwHjIoxcNSTCVQcCsau21BsuIthWXKl9vb/KN4Z?=
 =?us-ascii?Q?wHovfY+wMON2LRkJbA9tr9fv8s7vmTEQJQc5RWUPwJ5lsosCuVVNrOcl7mOx?=
 =?us-ascii?Q?+vKi7COVYdlUY93oqlNOMoH9S8CtGnEKh9wwBjTAcQsaqRYlkUmg/+rGJtEZ?=
 =?us-ascii?Q?Rj9JPyoONBbgM/pmWRlATnIxF5trpdpePNOD9d+4uv4ZNVMni8nEIBa2Dp4M?=
 =?us-ascii?Q?NOVCzXWF3tzSX7Na29X0tSR0jWvGceef3K+C88b4BfgiG7qCLn0lQSeuNFXb?=
 =?us-ascii?Q?UJqOHin/G8hYHWIMGLw1KZ8BcahV0lY7Fc7AqhvvYeiCjhsKbmaAPWzNbec+?=
 =?us-ascii?Q?li+HHlZkerSjW+JVI4fF3hVhmXKSvgEJfRuZha7E8SUbE1MZ04Pfllt+hZij?=
 =?us-ascii?Q?PovuRudID5HgPN3HgvpHA8NKkVrabfxwC5+pE5CT4zMY0RBeFTgTD2CRaU8h?=
 =?us-ascii?Q?E+xAZLkeQpo6EXEq8xTfbD2Zd3qhsaG4eTiqYTa3u49B9QkxOS16iqXTHN0p?=
 =?us-ascii?Q?JXiOEtKKo5vYSBB42l9VHZky7UMJKUGlESHLzc1BoS3NgjO73/nidBUquL2F?=
 =?us-ascii?Q?HN4LlEzWjy6Ix/f47S01FBizhQpENEkbKXdBD94K/KS/eweruq1mcxUUqP3R?=
 =?us-ascii?Q?tY9dtmyq1GLwjJ376oRjvsE+Kpsfk18wi2ablfCf12EbOYRyCua2EknuPJIY?=
 =?us-ascii?Q?XMzeAWyfizdcSFAEufvqbYb5p8eJGWrc4ymFSwCklL3kc87uRv5KDBSbTxna?=
 =?us-ascii?Q?Jh42LmZMq7/sqEq2X2XOQZPBoAoBVmTMfK3YWL09DJC3ipuhaC40OB0v8sQb?=
 =?us-ascii?Q?a4S9bTR/6aIZmy3FtEarTYP9Dem9ij99q8IO6UUXKgIJhlRGC+tiRJxcmhdO?=
 =?us-ascii?Q?bp/lh09fDtOH2ghvnofrkx4o8qgxOyERh1GiFa+kkMjI8WFZpj+zOYVeStSB?=
 =?us-ascii?Q?HB2+/uchhj/DY6CpofK3QybbmEGJNAdvtQwJ2n4648j/ZkaoGzLtdD0cJ/qm?=
 =?us-ascii?Q?q/Md0qS0kR35nUm/Pmy0OBZLAZGBT9HipzWl/PDRnAHT6IYUQyq4GANbnqB7?=
 =?us-ascii?Q?qC1Z+l3AV+CZHVDpduIJl1yVzjECW8Y/h2vG1g4uDaT/JsEZdUi3x2RZz1Cu?=
 =?us-ascii?Q?B4MImmdUTeZl6y8VbcvuduRz7pdBMAza6eB+mhhgsN1GHEdo81ydrFojdTrw?=
 =?us-ascii?Q?thFsrLzMSLRgibuJTvtktuYF6FTxmm9NAKEzcmnO3ZmqF2Jy7pQjzr+g7T9l?=
 =?us-ascii?Q?DRpgMn0FWqt/9S2FhGaqT2IS2/JGBxk5aTZ66FkJO8/Ck74gLPwAQ7W/GqEz?=
 =?us-ascii?Q?JNBWQ+uu08Y0ogqtpN++FQYruVJrLe9eX6c0WXUp5rYZAIso5Q6c340e9/yZ?=
 =?us-ascii?Q?0bBPEgJAJxJ2t5FVR/MdYRDFTFWZKr3kBySXP5jBoOCkadlZmdkP6shwmoNB?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a4568e7-a3cd-4d9c-cc12-08db666ea184
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:15:54.8787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCyoG7ZhCYLQZsSbFr3svhUz7AIJ0GmffRK5romWeNhkfIY7Tcq+fu1QIGZtQK7ELvp1OEnP+TsebVgPvS6NoJWsFxkGDbmU9zN549H8rT4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7569
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 10:40:44AM -0400, Xin Long wrote:
> Replace these open-code bearer rcu_dereference access with bearer_get(),
> like other places in bearer.c. While at it, also use tipc_net() instead
> of net_generic(net, tipc_net_id) to get "tn" in bearer.c.
>

From what I see, logic was not changed.

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/tipc/bearer.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
> index 114140c49108..1d5d3677bdaf 100644
> --- a/net/tipc/bearer.c
> +++ b/net/tipc/bearer.c
> @@ -176,7 +176,7 @@ static int bearer_name_validate(const char *name,
>   */
>  struct tipc_bearer *tipc_bearer_find(struct net *net, const char *name)
>  {
> -	struct tipc_net *tn = net_generic(net, tipc_net_id);
> +	struct tipc_net *tn = tipc_net(net);
>  	struct tipc_bearer *b;
>  	u32 i;
>  
> @@ -211,11 +211,10 @@ int tipc_bearer_get_name(struct net *net, char *name, u32 bearer_id)
>  
>  void tipc_bearer_add_dest(struct net *net, u32 bearer_id, u32 dest)
>  {
> -	struct tipc_net *tn = net_generic(net, tipc_net_id);
>  	struct tipc_bearer *b;
>  
>  	rcu_read_lock();
> -	b = rcu_dereference(tn->bearer_list[bearer_id]);
> +	b = bearer_get(net, bearer_id);
>  	if (b)
>  		tipc_disc_add_dest(b->disc);
>  	rcu_read_unlock();
> @@ -223,11 +222,10 @@ void tipc_bearer_add_dest(struct net *net, u32 bearer_id, u32 dest)
>  
>  void tipc_bearer_remove_dest(struct net *net, u32 bearer_id, u32 dest)
>  {
> -	struct tipc_net *tn = net_generic(net, tipc_net_id);
>  	struct tipc_bearer *b;
>  
>  	rcu_read_lock();
> -	b = rcu_dereference(tn->bearer_list[bearer_id]);
> +	b = bearer_get(net, bearer_id);
>  	if (b)
>  		tipc_disc_remove_dest(b->disc);
>  	rcu_read_unlock();
> @@ -534,7 +532,7 @@ int tipc_bearer_mtu(struct net *net, u32 bearer_id)
>  	struct tipc_bearer *b;
>  
>  	rcu_read_lock();
> -	b = rcu_dereference(tipc_net(net)->bearer_list[bearer_id]);
> +	b = bearer_get(net, bearer_id);
>  	if (b)
>  		mtu = b->mtu;
>  	rcu_read_unlock();
> @@ -745,7 +743,7 @@ void tipc_bearer_cleanup(void)
>  
>  void tipc_bearer_stop(struct net *net)
>  {
> -	struct tipc_net *tn = net_generic(net, tipc_net_id);
> +	struct tipc_net *tn = tipc_net(net);
>  	struct tipc_bearer *b;
>  	u32 i;
>  
> @@ -881,7 +879,7 @@ int tipc_nl_bearer_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  	struct tipc_bearer *bearer;
>  	struct tipc_nl_msg msg;
>  	struct net *net = sock_net(skb->sk);
> -	struct tipc_net *tn = net_generic(net, tipc_net_id);
> +	struct tipc_net *tn = tipc_net(net);
>  
>  	if (i == MAX_BEARERS)
>  		return 0;
> -- 
> 2.39.1
> 
> 

