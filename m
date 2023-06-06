Return-Path: <netdev+bounces-8464-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 497E672431F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC8F928169E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69CB37B8F;
	Tue,  6 Jun 2023 12:53:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D355937B61;
	Tue,  6 Jun 2023 12:53:13 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA13172C;
	Tue,  6 Jun 2023 05:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686055970; x=1717591970;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jLBeKnOhftdo+53RujthMD4AsZQa6bTkVsXudqy8SY8=;
  b=OQtRJUZvdpdrirE0jBpjGNdZQBz7ZLPBDR3WqouvJ/U9VPRR8IUX6fmK
   t+PjzCj2GwuLLxkZ5CNI6IgvSi/ijSe427Q7ps+OXEiw+cVH9rfnxtFv6
   8jqm8SWeIF0pd8COld0YXYpXbTbO0JK9yH6UfigxzzfVezk6Xq0ZzkrMn
   9NrBacmgYkfu+pHoOQ9TlzAZ6fDV5Fa08x/+pEgZ9OkiQVwygz1bY6Ke3
   /zHfB5JiVJAPTARD41VC6xr0+SUK3+YccxSzoVYvgYnwAO8FvpZQjS2pD
   WHeOA/X86aSNbBXisB19BhKqgBgvq1fZQwCRrU5HpRsNbSnDBT8SLZNDC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="384971519"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="384971519"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 05:52:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="778987424"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="778987424"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jun 2023 05:52:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 05:52:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 05:52:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 05:52:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0oYSQMIPIguh/Vzg1ScQc39XtBYMsbWFkPcplYl/p4ymSL1ovXfXJeCsanptU+urW1Yymprr8HaUI3GrBNG8p5rOJiqDThUb2iNQyvK25wGYFc+mNNx2pKKoRDV37+piTlW/lt63Z0M2CF/ZGphNmtTCHFWJ8OtiBu7B04NYCY2ZWhd+LUuTHwmKS58EBaEJJvgrCo5oruSUp8wYFGH+zkNrMo2T1fWCN+cUT3j1L3jeicRYG9vj1RAEB9WagY0rxPfh4VVvomrdvEi8ZTgITGrBrTuYiXRfeIf5RwfHnOzF0XFxgljqzySYvzkWm2vbJ68AOxoSYaJfmzXGuMlLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hsoKg2NRAqNuK9RbSG/lL0fylKzA69xdYHTLCIhZKwg=;
 b=L3D3yzo8I0gu3I03KfIKXzrHmrNqoXi4dETcALwncYgwGw31obDxC7zvTUYtTtV6iJMCVcO9naBMcORyNY9TufjqeoRdrl7fzrtwzknITWzeSVVoxTZ8HVNV97h/SbNeQjxr+uXVzuHWnk4SLLIpWPaURFMhwoNhnD+SRLm98vSOuL/FE/tX4NQIeDvY818MJSYpPAT0k+jdEk3IEmod13so4QOmFGVLCHrVnzcxCnnCskoGP5zCVbI3C+UlXL0ugnpmCTQhn4nQfPoRkBBCwnNhAOCQOPsvmKc2YJiMYGWLmOGmScTlOP34WZGGpET+akYRu5NYBpjft2I7JnV5IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH8PR11MB6998.namprd11.prod.outlook.com (2603:10b6:510:222::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 12:52:23 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Tue, 6 Jun 2023
 12:52:23 +0000
Date: Tue, 6 Jun 2023 14:52:15 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
	<andrii@kernel.org>, <netdev@vger.kernel.org>, <magnus.karlsson@intel.com>,
	<bjorn@kernel.org>, <tirthendu.sarkar@intel.com>, <simon.horman@corigine.com>
Subject: Re: [PATCH v3 bpf-next 13/22] xsk: report zero-copy multi-buffer
 capability via xdp_features
Message-ID: <ZH8r/2zeB5mwyOvL@boxer>
References: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
 <20230605144433.290114-14-maciej.fijalkowski@intel.com>
 <20230605144310.4793f953@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605144310.4793f953@kernel.org>
X-ClientProxiedBy: FR2P281CA0180.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::9) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH8PR11MB6998:EE_
X-MS-Office365-Filtering-Correlation-Id: 737c8bcd-4553-445e-71d1-08db668cdf56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VEQnpuBPVMwbgOGJRSyk/PZttoZUPIjvGBb70o6eqPEm4Ty8E4BqpLcwspb4YgvL2USFugMrz4PqtW85Vn/tvFQ8mBO0HEOS6Uy/K/jpec0Ys0od6ZDb6S6WQ6cl6v3EMnXJn6Rl2VolmemycMZQm1iOxscpAouEptC9H07bY+wl1ctkXmEl05OjE6XYgvGfR/FDmxnhKSelAWfd+DFJYDtTGYB0mc86o1dOHDDxX/jmI0aZK+E0LbL42DsKuVl9GsQq93YuYUZ0UbTniLGF8Rdt6oH84dJ/raUeWevERs/A8fRemSJKCsrIyCuPx4FchdQhCdgvLTgMQwM8lU4ukiBgRRJQJAIpsqlgvMa7AxZ+EHPOmenxZuIoDqfefKkRaIenMNvCHTb+Cs7im47E+O/a2+M4+83dOwFIFMRgyVdPrZXGf5XUaKsvFTnBLy4X95FJgJWbt4RAdspPH+e/oJMOsBriIusOU0DQ1kwqNc/fR/tYzPof5Wf9SPi5bikQRpchupmIdGlN1tAcbPdYgduKVAEZ3WKu8Quq4kNt3kt9koEuUlpGlffE6cPx7vlQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199021)(44832011)(6506007)(26005)(6512007)(9686003)(86362001)(33716001)(2906002)(186003)(5660300002)(82960400001)(316002)(41300700001)(8676002)(8936002)(38100700002)(6916009)(6666004)(66556008)(66946007)(66476007)(4326008)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xWpLcXukOqWgchb8k7XJprRM6xgd02nuoNYUMRrWNPGbJ9dp9aRm699Wlaj5?=
 =?us-ascii?Q?FcMbtqT78SRsZX1KcbNT4++ZNm+poi59wXuQSPj9xUJZ6OwAuHBCciWNG7mY?=
 =?us-ascii?Q?cXFGKV2rOZYtru8glOfPwxWfZHFesPKqJ0wYVFN3euH2eua+7ubFrMA4O6aD?=
 =?us-ascii?Q?cGg/IuVXzD9+nOHpy2wmvVb77/GLoIe0/NfNrhb6sGWbXdXd6bR8/IFQSUxa?=
 =?us-ascii?Q?kFAVYj0+T/55m45qS90D6HNVfOxoimpGVFsb7fQ2OXtTR9FfXCUhXKmkfiDf?=
 =?us-ascii?Q?/Uud5eDm6Urx5eVFIsc/1d2N0EfGRlEBYmQ48e4nrzDIPWd2MfB3215iGn+K?=
 =?us-ascii?Q?VongnOGz+2IJmTkUyxBNM7qaLqsAz0t/Yb6tE1XG/Hf4otRdHzrYmehtdvdx?=
 =?us-ascii?Q?FUNxFsse2nNG0g+4lPzePg5O7k3d+nyMeUo4IXoniRKMHPdHhlVj1AN+zcQU?=
 =?us-ascii?Q?VRznDL0h96owgIyEoZ9WYH4mKIXgow14vcuZsesSIypshvsYxc9rHfRsZQns?=
 =?us-ascii?Q?bfLrTM+TxmflAmDWk5mMAbtnF/N2MJCLOirig47aEz0w2JRE/cCtJZGuldHT?=
 =?us-ascii?Q?Gfw+Pe9RXVIXdpXPDRpKolD7kMpX+0KB8NtTusiPPNpGrTAy4Fp7Zc0G3F1S?=
 =?us-ascii?Q?DEdPzx/GRMubtT4XYEVi08BzZ579wubV0QTaMGX0RBQN3r85KexReNKi0hc6?=
 =?us-ascii?Q?BuGZ8nb8T5XVe0dCCrsvzjyVn1t0wUYamk7hS9ENMwvnRZ7AkE1XZIrbhpdC?=
 =?us-ascii?Q?s8L/FVtjpdx+JWq7pfH9RS+/wxf/SDSwwu5331Kdp0Ygd0rFbhPLSlmMQqnn?=
 =?us-ascii?Q?q8L2iYgUxDcuZUlGKiNoEBpqgZiNlgcxZERNIKZ7HNbaiOBHsrFO73nfBBMc?=
 =?us-ascii?Q?IQr3P2z6Gm+qhxuIrOdPTjH7PaqnCmdiOK01WG+gnyFvVhQ33ygMbgcqQ2DA?=
 =?us-ascii?Q?BQuaroE6PhnjAPUzDhI7N447x8PSEEx/YOY4TLotasiVQYKAbxj8PTnvTeT0?=
 =?us-ascii?Q?MdzoQNpaRBgcqi03RyjvxYfwiQNylSf93W3taqoVFxXj2lbIrBGhoOVOg8FI?=
 =?us-ascii?Q?/4VwvMyXSxX5wHW7Yen1kJxSOuTDJwYJU/XVN4I8NGvh31uYPN36+3AcYnQq?=
 =?us-ascii?Q?e0lvDVBxJ7PdHhb7PniCUfXZz6tUguo6nQIrNPfnu/Y+IejzVFwvvG5xOOH7?=
 =?us-ascii?Q?y2ofNSwbt8dgBVW1/XNNa8FTFtIcb6UPZeKyTCQjIcRncE19u41zRxXQ5Uik?=
 =?us-ascii?Q?TiDQawBT/mbnteUOsNN6Puew0ht4zxFvGHWFWWaOVE+jsX7FXBcJyX/Sv/IP?=
 =?us-ascii?Q?Kl+T8t8zeokVQ6kUDj1YdreayRa2n3q3a4xFlvPdiJSHb0fDnFVhK2P6b1Vo?=
 =?us-ascii?Q?vFN1lCJmixPnoTy0G1n2OktEYBm7AkuvOlu8UzbH3T3RaTCC2Yq6Wmw/cqdL?=
 =?us-ascii?Q?hDumSLPIp2S3MCE4gS1LaignLuBycbC6K8GtS7djSOsM1QTjFk96D4t2KZIP?=
 =?us-ascii?Q?jPOnACuUna8HUi7Gt3rvssswO/keptPDKhAYnIVnBQLJwwSFfKukTGBhyKWe?=
 =?us-ascii?Q?GH1MBDBQOC3W5lRZ6q3N88b57Gz0YBgp6yRI2FFhNnHjhP/R4Eapgmw5RFzL?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 737c8bcd-4553-445e-71d1-08db668cdf56
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 12:52:23.2699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n3Hrm2obyRfq9MxJOo3uXX3tyuJwVu4k0B7sJYy3Ut82Hhl/x0A59bU2s3GlFRUbp8UpmlGP7ucYANkFB0lgoRL/83STjAcmZE8rD5HQQL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6998
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 02:43:10PM -0700, Jakub Kicinski wrote:
> On Mon,  5 Jun 2023 16:44:24 +0200 Maciej Fijalkowski wrote:
> > diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> > index 639524b59930..c293014a4197 100644
> > --- a/include/uapi/linux/netdev.h
> > +++ b/include/uapi/linux/netdev.h
> > @@ -24,6 +24,8 @@
> >   *   XDP buffer support in the driver napi callback.
> >   * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
> >   *   non-linear XDP buffer support in ndo_xdp_xmit callback.
> > + * @NETDEV_XDP_ACT_ZC_SG: This feature informs if netdev implements
> > + *   non-linear XDP buffer support in AF_XDP zero copy mode.
> >   */
> >  enum netdev_xdp_act {
> >  	NETDEV_XDP_ACT_BASIC = 1,
> > @@ -33,8 +35,8 @@ enum netdev_xdp_act {
> >  	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
> >  	NETDEV_XDP_ACT_RX_SG = 32,
> >  	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
> > -
> > -	NETDEV_XDP_ACT_MASK = 127,
> > +	NETDEV_XDP_ACT_ZC_SG = 128,
> > +	NETDEV_XDP_ACT_MASK = 255,
> 
> This is auto-generated, you need to make a change to 
>   Documentation/netlink/specs/netdev.yaml
> then run ./tools/net/ynl/ynl-regen.sh to regenerate the code
> (you may need to install python-yaml or some such package).

Oh boy I was not aware of this at all. Thanks for letting me know.

