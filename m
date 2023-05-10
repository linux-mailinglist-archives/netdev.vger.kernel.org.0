Return-Path: <netdev+bounces-1476-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 636566FDE3F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:11:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 859691C20D84
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A5B312B70;
	Wed, 10 May 2023 13:11:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2529920B42
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:11:01 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7616D3AA6
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 06:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683724259; x=1715260259;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=a85UjBwN1b9/K9dI+/h0yiH0vgx42LnIKueYcWQcRPE=;
  b=kzg6pywCOatoQpuL0Rh3faE4hMpJZx94ijYiPWJqkhyHlroB9+pA+Pzm
   aMLaOQ81KdU+ewXdVwJHBxC1U9aTTEVZl7b8w5NOBVEoxj80NGqce7//d
   ktKpf4AvUfAEB/zeUi+pd6tWz0TrcEPpw/A8xsNNPY1iHThu9Wy0R38kQ
   cirHtujIbD2PQU0E3jDhZvPmWKwDKN2+AbjVxKOF20AtKSQXByNVFlL3s
   jLBaa/9/lnf9VCM+TQrO4DUWYuq5GQDo+HISth1+CPkhJ7BnHc1NpT/WQ
   LmTmm6qMGoWdNn5inxSkA2AFiZ8rg/KMT3zqSZNTcRh9SYQvEWVz3j2CI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="413508555"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="413508555"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 06:10:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="823534608"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="823534608"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 10 May 2023 06:10:58 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 06:10:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 06:10:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 06:10:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 06:10:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnaKPKGWTsAQhaEBGDDDaQ6YV+QcfwsLcZkOI45V3YtURBjO+PF3tqitmw6/QOpFdwFxRYFQ1Jox9AcU69dp1dehvOVv2r0tuRyX/TIvbYqZd6YUZnIyhgSv1+vjqaoY/7mBlf+rMxROlat1TXr1wnblm5DPjk79XemCMr9y2St/7ju0m047/psVR/Su6I0q9aTtTxH4GAoO6PgFtHc6f0xMk5xCkc06yyt3R42hmpAvZHQi2Q2xSvhWK6R4R+3dWUsduhmeBeGOnj/UqBRZv4iG8uuXo/YqG9OR2fgskL4XIy6AvoFiLmpIBffEbCCDvt89rjkPW5vA+yH6mFb+9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PPvnSCi+bjPEfAOnZTvWxpqoUESzAYbsbrkbpIjHHlE=;
 b=Ts3FrsG7jjnJSw6PAP99hH8z7K15OskcmEY2Z6wthagVpYTttBiwXKT7nEH9BX/doOyuz81NkggV6WCNFKLggqTS9Ttqqziunl5Doo2rPhGdKphPZCWZiAlvrI8XaJ6oN7/w0aK9uFL+TTZ+nqRiKbUY3ezwCVe5qowORsEV+7lbY32cCuwMwL+gxbuHu7ou3MX91N07Nj1c+YZyjIii78AnuvhuYc6kqgXkTA16jEZ/q3aPeN50RJC29l007WxvuKwsBI7YdqR0gGaP1QF8puIx97DncUEf+W4vGhIPQz2JvfOBneOQpvtdWbNofENQSnzhNlqSj1ADVZD2Xyb9rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 DS0PR11MB7189.namprd11.prod.outlook.com (2603:10b6:8:137::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.20; Wed, 10 May 2023 13:10:56 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::66f6:544e:665a:9bec]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::66f6:544e:665a:9bec%6]) with mapi id 15.20.6363.032; Wed, 10 May 2023
 13:10:56 +0000
Date: Wed, 10 May 2023 15:10:44 +0200
From: Michal Kubiak <michal.kubiak@intel.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Kuniyuki Iwashima <kuni1840@gmail.com>,
	<netdev@vger.kernel.org>
Subject: Re: [PATCH v1 net 0/2] af_unix: Fix two data races reported by KCSAN.
Message-ID: <ZFuX1GtbvzsI97aZ@localhost.localdomain>
References: <20230510003456.42357-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230510003456.42357-1-kuniyu@amazon.com>
X-ClientProxiedBy: FR0P281CA0122.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::12) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|DS0PR11MB7189:EE_
X-MS-Office365-Filtering-Correlation-Id: 54588fdb-9aee-44b7-fbf5-08db5157fda8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1VKx3bWu5Hw+P8GyDthlvXZSpMLBSNs8Z44e0se8IvbZ3vN+J1QFGBXhec9lkjAIaoXnrVKp2itekQ0A75czUtgFYLiYju639ursrlC98rgVED7tc9Wdcln2NlJoagoam/Iv3mi0D6x0W1LE4bgMeneiMQ5Y7vZDObP7ST/Guy3Yc4p6ntfWKT2WuZvij5SHUVpW5U9hBSSj5/2KOQ8eYxTSyxfQCEQsS/uyFRssWVIr5vdfR2UYlrFEx/hzu/tlchLPCTPnFHs9HMbVl8LEPpud2XmKAmOBlPWh4U2+I0ISH86UUi6u3l3nH14bpEE1ZxcqH/UNOtjMtCw2M7OEfXs8gavKLhloDeGh24XiIEhz9REL+xAw8+dluOo63t6CY3Wp96xGNBM6DMIXwQEcDuWz2yZ4kjuAwtQNTTD10ZofRhxTqgn8aYMA0zNExSfIDvYt+a1kdWViQGw2Ig0aXpgWd+CyQdcD96SM4bZF4ENQ2TRzDH86q1AwOSgUE0EQm2uBcvSR+oWwEoAvDjjq+TkiUfLYJ4w5hvSuAcVLIMyNzbkqYOQS9J/aRhiWc4YU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199021)(6486002)(6666004)(66946007)(66476007)(66556008)(54906003)(82960400001)(4326008)(4744005)(2906002)(6916009)(44832011)(86362001)(41300700001)(38100700002)(316002)(8676002)(8936002)(5660300002)(478600001)(6512007)(9686003)(6506007)(186003)(26005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LaOkKzYkS2BgOZqIFKO2dJwAmbU6mFyZgwFNojOjOE6J6oE3myMihOtCxjWT?=
 =?us-ascii?Q?srk8knspfW7Pu8oVOYQXK7iNcDhQ2iwU+oUSw184/HWMMpaKys9/l4w1hcKS?=
 =?us-ascii?Q?5tZ5j/M/vGIP5T9x1IS4DdUjKAszBR8BHPiLu1cw7wI4AgIvGHGT/1SL9jLZ?=
 =?us-ascii?Q?iGvvyz2yiL34RUJtaiHVNm1Q/aep/ZVy3dTmIYBr+2xVYgfJ6s+jlT+cNkCT?=
 =?us-ascii?Q?pTwyw2ccVAqIGBFm37X/H44N7hDdRe3zFmvt9ruJvn/58bsQIGCTQMLI0c+l?=
 =?us-ascii?Q?AwW4F8gSjimx777UC7ATs5bDhXi7ainU68UzTqzBWyPJxpBgeF4DUVVoV2Si?=
 =?us-ascii?Q?S0HpeseeWL8n1d5stAjfknZ2Ng/VhLM1hrtaD6BwyJbvzeco5ZioZ4hwjOjk?=
 =?us-ascii?Q?lj9lHkTLJUrEYZooKoQ+z1DTAVuuXEqPLXcwv3Ebs1lLEe3HxIZFF4te/Ggy?=
 =?us-ascii?Q?utWtP1M2FIMCwb5WAIBR+rR5f/bwoySP4N/tRVq3a1LF2lsrrbzl9OoBfIS+?=
 =?us-ascii?Q?/8x2s4lYFzVs0FPA3lVIeo7IwS4k+vmZobk3IOo+Xw4GcEXOSOGz2mLLoMVi?=
 =?us-ascii?Q?rAm9134FasE+rFuEiWsugN8G0J2Nu/DMcdxmqLjsjHhZ3s/8KdMo55gyWIQB?=
 =?us-ascii?Q?BuEhNByVi4NBRD8wXO7MPs/6RZzcoh81Rxqn6R0gTieKz3f4VfNS/RW96Tyh?=
 =?us-ascii?Q?K5cnIT32MeKTr5w5QvTyXHh8p0vCDWwQQ97pfMjOnZUoiSMjI+SG2hbtN6Zw?=
 =?us-ascii?Q?KJCYUcEMbqy+G4+U4bSCsrZHcK8LI7Dgsnd3567YhHI0OKbqvN/Vt+HwD+Qc?=
 =?us-ascii?Q?dpvMEWH49LwFmFU8zvA1MNoeKdHWAdVULwIP7tZioiks9MdAL792TkP/o6UA?=
 =?us-ascii?Q?e3Ov+HkCimktYfya2mkGHe3gYK1LDgWNB1c7wGG7wKZo8Zimz4RbD91TxE0U?=
 =?us-ascii?Q?AN8kPDjmOLVWARDG9ylj8Ozw+uwj+PkodEmzqJxlJPMi+Jm4rn+o+oo5hLFM?=
 =?us-ascii?Q?C0JfJU/g1xKhoz6K4aHaPgQoZ7GUrXrZmsBBbv/zTjN2TAIDQPEQa5fO7NGu?=
 =?us-ascii?Q?0xGMqQIsRuZuev3OorDGmGjDr+mthvd69sopDi22ePAK2KWn7HFzuQOGO2PF?=
 =?us-ascii?Q?Q+/uZIuVf+8roNeTKrOp5YAn99pcdFelcZeuh0o4DUx12X0MEuHJCVXoafm0?=
 =?us-ascii?Q?CROsC7SED5s4TrKi+slLqQWEm9jwOvjLX+SWvrUwOrG8weGZYp4WoCG9Ifxe?=
 =?us-ascii?Q?mTgb6DE0nskYzmGMV7ntLI6M+W4lOsUns3GRXjELdth18sM3gVQjsies78Xl?=
 =?us-ascii?Q?Dk3Im8rEWMs25jC2rvvBJGqgj8TAqNj3znewG8PlpOgYW1Sj09rC9oBbPekk?=
 =?us-ascii?Q?OhIwJiaSV+WLBsG58VimB8VvXvOGzSBO7YaOq8vLmJlwyojzR5ThAZgo6CMp?=
 =?us-ascii?Q?tUEh+CpdvjpW0JQJZpO4aEluCuBqgEkhRRqvmmfUjBBYFFmtbp9aIAYJXTW2?=
 =?us-ascii?Q?JZM5ksMq8pMbAoNH5vr1o57p21Hkj8vulDfVPelKSomiy9L1iGzqzqmImQwt?=
 =?us-ascii?Q?CzNoX5Dl+M6WJdaKv6muWdaoz+Fh4ZuYODDNH2DwAzhJUE3h87mifoU8qIav?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54588fdb-9aee-44b7-fbf5-08db5157fda8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 13:10:56.4477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sm5oe9iEb7p6wYdatEeoh/LzAok4aJhqhRqYRBS9K8YLEc8BcQbcPGebNasuJRRGNA93sUHKVXN1ltCjNnhYlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7189
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 05:34:54PM -0700, Kuniyuki Iwashima wrote:
> KCSAN reported data races around these two fields for AF_UNIX sockets.
> 
>   * sk->sk_receive_queue->qlen
>   * sk->sk_shutdown
> 
> Let's annotate them properly.
> 
> 
> Kuniyuki Iwashima (2):
>   af_unix: Fix a data race of sk->sk_receive_queue->qlen.
>   af_unix: Fix data races around sk->sk_shutdown.
> 
>  net/unix/af_unix.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 

For the series.
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

