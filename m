Return-Path: <netdev+bounces-6710-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A7F717860
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:36:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEB901C20D76
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BEBEAD50;
	Wed, 31 May 2023 07:36:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D097A944
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:36:45 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2131.outbound.protection.outlook.com [40.107.237.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353E4E5
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:36:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNsyBlNE2T0w3J0IQ536D1u3+sq4u1pIg7jBlaXUvHlVLOyy8EKLm7MhiFvHlRyDZkbQeIfUxiB9ecChopIelXofAOmO6p18rv8juv27xllJqtt/uE7eqeUMcYgBbDnSwzoECQZTAhf+cY9SQuO97zHYwwlNK7cJctB2GoG+tfZOM5OGM7kzznSwkwk9YSUISOBF0E1D1zuoemwMOEfjRZcUPPesl3iqpJ6gwulGNoaWGVatQ5wmBqxpctxGNsxJkSAAodIy7pEuv/v1NGimgVVihPQcf9aPRTUH90MzSJ0SBYoDrvg4k8K+jrciiPsQlPa4gWOkB3/V+pVnJdfzgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IocztVIS2An9qVhOchrVv2SOHWcZnFBBVSDRuO+d/Ys=;
 b=L1iCTjuvULLS/akonmPbPAX5HVIHYGpdWQ256av5fTDiloFL/zkgzBHtwdjxFqdxF1w56bfcMNvUwVya80ekoLE6RqcnURRx5720a525dxx0/yUj/EHbsrmfQArW23GV1TnDoo0y8a8TsN4z3HsyGB6vrhYy5ODej9wctp4tmSJaO8asoPKn3Xn93VHo20wC4OEnCq2BxP1KRXlSVosjpglElizYbRdNtrRtHbLAIAl+ipWP9i6a1yozg3O7w1KjkdGrRZ/nBD+ldq9Io9H+3eCV1mpr/pkASNFYMkM8Ufrh3531l55VMyTqqiThDK01LoTPNTi667qw30OSHxtv3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IocztVIS2An9qVhOchrVv2SOHWcZnFBBVSDRuO+d/Ys=;
 b=voK5ONvW/AVZnlBWxnKVNU9zz7Womh5yp//GgHkOOAiGlbIhcFtd5NcWVl3e+6fZ5UiNFei3bwGKzNbdjHXNDY4KSmfsrBRqvTMASk7JQHwDKh+8uIoYgBn8OPfhnEzQOiU6ipIGPZmsVO+LcMZOgh201A7+7wPCjifA+x7tsMs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3875.namprd13.prod.outlook.com (2603:10b6:a03:226::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Wed, 31 May
 2023 07:36:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 07:36:39 +0000
Date: Wed, 31 May 2023 09:36:32 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: intel-wired-lan-bounces@osuosl.org,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
	Victor Raj <victor.raj@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH iwl-next] ice: remove null checks before devm_kfree()
 calls
Message-ID: <ZHb5AIgL5SzBa5FA@corigine.com>
References: <20230530112549.20916-1-przemyslaw.kitszel@intel.com>
 <ZHY8MqU4Kfb+aTIP@corigine.com>
 <08806483-959b-925d-2099-561d0f0278f8@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08806483-959b-925d-2099-561d0f0278f8@intel.com>
X-ClientProxiedBy: AS4P195CA0054.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3875:EE_
X-MS-Office365-Filtering-Correlation-Id: 27cf8120-9db1-4913-6bc6-08db61a9c544
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mOawJq9chW9z6KxlLANDPNmA/UpHtaC2l8e3222f5vm2EA6XLnE34TW9DaPxclxaz5RyDUqe+2432f1LWXCrVMZj3mLWwjUVMo8LIWZaIU7bLVtN5EB8Ol/JfbRdAP04d0Codm/lrW8t2z/3nd7rGRr6RNb3WFlGEt+7USydsZWj4rYfI8JTRQf1Wz2UaUH4zb4mQvHD8gq0Mfj5eR4/gBmR8kABfiHr89YhUQiS+X6P1hWvvOTMy2JOMRQDYoP/YA9oky5vcaFACYXNk802liKscsJZ0NQyPIXWRzCGMLcz9T+oSHUs14YHf+yjUaThuEPhjUbRUiGl5oks7yicYTTgT34/qIx6ggI1KKAnfcz6Cn/IEIkqmRE6b0+60Djsp1nd3WEbgsib9uLLhMfAArpW+ybejUfhFOKGatsOJvf4Ws0Kz8q7KK8KjOK7Q9+iKIoy1/hUdERaSTGF83OLMjuTGogwoyzsCp269wIhbTZ9MwXbzMB4RBu/TM8R4k9NDzgIS08E48XH/hHKeqcSSVsD+A4yWPcQsYBgeQ0h5L7wy6hFtwDXmHbLfuPyEp04
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(366004)(396003)(39830400003)(451199021)(6486002)(41300700001)(44832011)(86362001)(4326008)(6916009)(6666004)(316002)(36756003)(66946007)(66556008)(66476007)(7416002)(5660300002)(186003)(2906002)(53546011)(6506007)(6512007)(2616005)(38100700002)(83380400001)(478600001)(66899021)(54906003)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yU5N9/ShzopZ5c0ClOFV0lBASAtMF0U9tEei3C6usIIatoXfvXylZRwMd27e?=
 =?us-ascii?Q?6pQpqr+JJkJ22ISmGRyZ4oTveavNYUD1tDWwjwc5BmIgXtrNeSUIJgZm9zyn?=
 =?us-ascii?Q?YDFjwx5dXbuNT4beyGVlppLS+lkIi0a5kkRuOcHKCkWbdJ6FwkQetX4xAj4z?=
 =?us-ascii?Q?O+vZXj4nSC6P5ms/rDMxcAo8Bb+YnEV36ruSRQmN7e2uEzdHHYjfLOwwviNM?=
 =?us-ascii?Q?KMvXs3pEhYwU6rpiqDFVrAQ2EvsgcKi/cVnWGv98Ve5OCslg5drDhHu6cYrB?=
 =?us-ascii?Q?kg6CWWxUX0QPV+Pf+MKIv3e6uFDh5nNZMfqGjXEktCYgkl9HK37CSrnyJsqv?=
 =?us-ascii?Q?iyLsHkGvzl7AN2CfsrIUkdm9hMY3qyWAWtD+Xcx7yEeaMaoycLAjCAx2++5Y?=
 =?us-ascii?Q?+Xu3X9cmVyMgdDXsDf0U3jroKamK9dikcaGTxKcLF7k3QSu0JYks8Y1Eub7y?=
 =?us-ascii?Q?kzb+PkhDFS4IPnsMXu1/ammZdovU4UABzgLKK1ObbNmnx2hYAy/v+08GFGdO?=
 =?us-ascii?Q?ALPJQcyZhI18pvFiH5/vcA3s40KSgAsZfY0gtuUinxw+fYSQwqpRGY+MVRqD?=
 =?us-ascii?Q?AWzIaOwfcJGOtTe6z2EOIln79Z9gSsXYnpDevDncGJlESwXDDgvldWyEJTcL?=
 =?us-ascii?Q?2zu7/a9FR1UCKxy7QmJ+Jqm2WMOp27NEuUlUPJRIf3PuISP8Uf/buoTwkFGR?=
 =?us-ascii?Q?wGJ8r1z5jPadp4+U6ZgpXlAkAMI7BiTOml91ahuDTfnN90LuLVo+tRDnfbvU?=
 =?us-ascii?Q?6zc+AiKwn63VKsbEplWa5EupQOeHcAo4mnBzdjuwysoGjDojk4qzxbQoSknP?=
 =?us-ascii?Q?aaXk9goOlUAoDOOiGjHdQhs7jt0wuZl6jT2e/am3bBDpA8CFhM97ttNx0EuQ?=
 =?us-ascii?Q?maB+g8p8reCCL9Qr3q14EJns1MOHGLqZBm5fEnv4vAfigROhehPS5+SaEopf?=
 =?us-ascii?Q?9xP0zRyzcPqFAYN16UyMv6L42Ej5t/XfGpgpanihfWeX4c5ZH05Fzv88YVcb?=
 =?us-ascii?Q?iW/d3kW/Qkfs7lvCp6I1I/7vJfcHvIsaq5JwXqQ4FgjfGGszW+VZaVeWPaz6?=
 =?us-ascii?Q?Pjom7dg3y8fK5YBqR47cbk4VPx5clPYeNqfqoXr4cvxTqWXrseMxu3GX/t3B?=
 =?us-ascii?Q?Zi3lffKC1Dqb7nGe0Kqgv+oazeps/lBz62sm5S2NELV5rC65TIHYInrYiBHQ?=
 =?us-ascii?Q?xR8pCaVbOkSIb4KYN3JO1Ma2lh5Aj+zQpMuZnWmJTuo0CUTdyfel/tFPbNm1?=
 =?us-ascii?Q?ANwZCHXgPOfvrzMYkxnRf+S2tKqo8Om9xZHTk9O3jXFAy0TlvynQPDHg4GjX?=
 =?us-ascii?Q?vLbTlOC74nSUeFSRThXEr09BE2UadhtQcNI2c83CqFaA/NgJVMdrqKubB1na?=
 =?us-ascii?Q?JDwehVWhq0bt+rOKArUo1tFg1iXJ3VHHYMHweqlB1uDn7L1m/kPrUWoRPGxm?=
 =?us-ascii?Q?ibOHLlI20imbgLkk9zTh1Er0lqG6HXaEvbhJ6Q4qzThwo1FYTgLELYrw0Rco?=
 =?us-ascii?Q?nQAbfA7k8vqNo9qIOTSl8kkb3LFaOh8OS7lvi6GeAp4QL35pgbePNV2lQ493?=
 =?us-ascii?Q?jrjDxA1ApndZ6p5qUuRZsDaAb+oId10vadh6S2gcUSzHChw1YUoAtwKaiwaE?=
 =?us-ascii?Q?gjbEKu3cQJ2QLe+CvVlMxSvraUGvEjb+XlAFxwKGQzAD7ECTYG/bExxYpmQl?=
 =?us-ascii?Q?78UhQg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27cf8120-9db1-4913-6bc6-08db61a9c544
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 07:36:39.1570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAAT6BEeKq+2N9f+hn3OlHJAswAUWq7BsRovxuRTph3+en3j3M8PT2oY1BViv+AtYtK0c0oCPPUv1E1E6QGLBMXU1j/qd95Ba2lcwFUexZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3875
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 12:06:15AM +0200, Przemek Kitszel wrote:
> On 5/30/23 20:10, Simon Horman wrote:
> > On Tue, May 30, 2023 at 01:25:49PM +0200, Przemek Kitszel wrote:
> > > We all know they are redundant.
> > > 
> > > Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > > Reviewed-by: Michal Wilczynski <michal.wilczynski@intel.com>
> > > Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> > 
> > ...
> > 
> > > diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
> > > index ef103e47a8dc..85cca572c22a 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_flow.c
> > > +++ b/drivers/net/ethernet/intel/ice/ice_flow.c
> > > @@ -1303,23 +1303,6 @@ ice_flow_find_prof_id(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
> > >   	return NULL;
> > >   }
> > > -/**
> > > - * ice_dealloc_flow_entry - Deallocate flow entry memory
> > > - * @hw: pointer to the HW struct
> > > - * @entry: flow entry to be removed
> > > - */
> > > -static void
> > > -ice_dealloc_flow_entry(struct ice_hw *hw, struct ice_flow_entry *entry)
> > > -{
> > > -	if (!entry)
> > > -		return;
> > > -
> > > -	if (entry->entry)
> > > -		devm_kfree(ice_hw_to_dev(hw), entry->entry);
> > > -
> > > -	devm_kfree(ice_hw_to_dev(hw), entry);
> > > -}
> > > -
> > >   /**
> > >    * ice_flow_rem_entry_sync - Remove a flow entry
> > >    * @hw: pointer to the HW struct
> > > @@ -1335,7 +1318,8 @@ ice_flow_rem_entry_sync(struct ice_hw *hw, enum ice_block __always_unused blk,
> 
> More context would include following:
> 
>         if (!entry)
>                 return -EINVAL;
> 
> 
> > >   	list_del(&entry->l_entry);
> > > -	ice_dealloc_flow_entry(hw, entry);
> > > +	devm_kfree(ice_hw_to_dev(hw), entry->entry);
> > 
> > Hi Przemek,
> > 
> > Previously entry was not dereferenced if it was NULL.
> > Now it is. Can that occur?
> 
> The check is right above the default 3-line context provided by git, see
> above.

Yes, right. Sorry for not checking that.
This does of course look good.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


