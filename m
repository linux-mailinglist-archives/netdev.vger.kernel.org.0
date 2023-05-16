Return-Path: <netdev+bounces-2894-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 084D7704756
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6E3B281544
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34C9C200A1;
	Tue, 16 May 2023 08:05:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F125168CA
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:05:57 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2118.outbound.protection.outlook.com [40.107.94.118])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1D649D1;
	Tue, 16 May 2023 01:05:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8HoG+itgGKa/NxEFWFY+YCkujQnxYZspqyQ7aP9e11b7NjGYhtAg3IwqCKzbKFahYLulPI2dEcvLumFXHrPxe2SYB/2pK3DPgSb8TLj9jqG23my8ymRN1J5wurK+E4I/2ji+1uuSX5ZX7fDoimx+Xikhj9H+Fhd3KBZO80DwPLQ1IV8v1FDuIVc+IJjzA7TUwml8SN0tasD5hwI+JctGCO/YoIZzNucsmHxiRgs/xRg3wN+YaEi9XUndVRvlhpPgGnpjnK3LRTeYNYq9q/7T3PC5y/M6Jkpv0aG6lO0CISoufkM10eQBnofB822Y+Nt2sNBHjUypyhnP8BE/mxvMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLx4sXunLZrfwp3LEPjxO1wSov8W3sutrn6njyOi2U8=;
 b=KJI/VDUF6pc/J8pdtB7po098+AAWq1IieFzK3jBt1bh28/dI7IcopTXVlbzsjNYpLvdvLJcCsuEvohhBkM8Fpsr/OgwgSd11wtuB4OaZhDMfFrAEoMEbqoXQF1UZRpERFsAKk8kG6zE+X5qih07hsNY1XL+CXoyORLckVNrdTn/w0qSQZFwbFHQjoIX7uvp+iK9Ga23O16Sw3UhMGjdnS//adS3MNonEbsm1j1pfI5ax3vdwmj4pO7u16RNRobfG+NZs2/HdGqQB0qy23t6TdVtbhnqiIUez+qZT9wHPXySH94rzy+qdUBiIELJ8BcXut4sFhWtHo98+Iyq13CnrKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLx4sXunLZrfwp3LEPjxO1wSov8W3sutrn6njyOi2U8=;
 b=Epg2zVJadOMgjRxY59fZ4bDelPRJAk8tLuIhjuuCiKp2dcACSa4cz2kMQiBCLZUgKVaCsb/teezmyrvPHPwUioHBZjpkcFG//Skh6AiiJD/b+FT34ONYIhedgQvCusWdkHihJPyczfo2enXZQ8FFFUItI+Pa1HbGNQvWcDKdu80=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4840.namprd13.prod.outlook.com (2603:10b6:303:f6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 08:05:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 08:05:51 +0000
Date: Tue, 16 May 2023 10:05:42 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hariprasad Kelam <hkelam@marvell.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuba@kernel.org,
	davem@davemloft.net, willemdebruijn.kernel@gmail.com,
	andrew@lunn.ch, sgoutham@marvell.com, lcherian@marvell.com,
	gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
	naveenm@marvell.com, edumazet@google.com, pabeni@redhat.com,
	jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	maxtram95@gmail.com, corbet@lwn.net, linux-doc@vger.kernel.org
Subject: Re: [net-next Patch v10 4/8] octeontx2-pf: Refactor schedular queue
 alloc/free calls
Message-ID: <ZGM5VmGcuEFG2Jh6@corigine.com>
References: <20230513085143.3289-1-hkelam@marvell.com>
 <20230513085143.3289-5-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230513085143.3289-5-hkelam@marvell.com>
X-ClientProxiedBy: AM0P190CA0003.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4840:EE_
X-MS-Office365-Filtering-Correlation-Id: dc06bb30-965d-4b3b-c216-08db55e45d99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QjrA2Aq4H2R2L1tU2E+82xy8mU/0MHuQRBGrAe1RbyyFS0UiutHwijv2XmGxNlZm77uyUidT5aASZWiW1cTTIqn0nHU29RUm/Kp0t96Zws4sQz5NOBUv0KPgBhjhMC/oMk0Ntz7NZUUvoTgufuw9iyLhdYNv+SHyu2mRRjMO4nnCc/GT3/VyaUtbrtTN2xHznf4r1uHoNOpUCtX3J/v/H9VyJKGqHt91Es6qQ4pCHccrZSZ2EvlJUkRUdeJ4Gng9axGpEI63sTXjl5J29l8bz6pFPA1IFRbIM2NKgxEZttM0Um8W4gYgCh5xcQkpZ6WToVvNRut17rGACUTVhBChvyiuermydkSUU6pOiJf+q11wqXjmNCtJfuXk8JPqXnIZk2E0DCFSm73D8YpnFaRa7s23nQhmNIc5CfL46RiaMhKkUSRDoWKOpFpsnSqCGNVT/chp7LvQOnJn/hf33vbJbDugLNZJM1OHqoWaFVP845XVW3DsBw/NK58nJBv9ax1KjBSrua109CTo/nQ1m5ccwgdxEkbS/xk90rj4OrYvjpzO/IgHjtpzDIt/u8tBhXOf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(39840400004)(376002)(346002)(451199021)(36756003)(86362001)(316002)(66946007)(66556008)(66476007)(6916009)(4326008)(478600001)(6666004)(8936002)(8676002)(5660300002)(41300700001)(2906002)(7416002)(44832011)(38100700002)(2616005)(6512007)(6506007)(186003)(83380400001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gLLoFbA07zQuboSjI01O6Z264XFxSB1rjS38srIKnQcn62QW5WK+TCyqcEMQ?=
 =?us-ascii?Q?zxRfvXTvYe0MSJV2PvQRQq2pHsnfvn2QqBRbZQGFmpO1w8OgrcuhV58rLTBy?=
 =?us-ascii?Q?AZVESTBA5UGWwZAuR5ItyWGcWmHbbNUaG7GOGvUXYVtPnK7pBsHsbZN9Igg8?=
 =?us-ascii?Q?VUobFvUnwpykcqg6HZsnX++YTvcZBPVG2DTjrwbRxeuQ96tBbGaPDQgKkhTB?=
 =?us-ascii?Q?nsHmKfd5PgZwpgiJcddMbpswfgGBHkAYsL7s15GRPAoFHhM5dGPIzui4don+?=
 =?us-ascii?Q?DIQLorDwOA6nQu1gLjJYnfxu7RohItV4QLuatHt6oCGniskaeLLcrhll+Uuy?=
 =?us-ascii?Q?dQZ1bQpY7bsI2A/8Sj4xo717Q24UXmjUoRpatSqGjFj9T0/KObEe6bX/zTll?=
 =?us-ascii?Q?2GjcRWE7r6YCqP7sOoQfPVD7PnrEYjgGZq9TPXBe3jAOp53brQt9nEIqOaEU?=
 =?us-ascii?Q?TKL7e+ESJlZnuKS+5BtWbybuY2GCUht73JhnWMWjLhlHIXBEceCQu/E7l4EU?=
 =?us-ascii?Q?EBYIw/AN84cmc02JLdc0KctUi+iptS3iHFM2a+g9XoD3xVep3HRHMnk3kMn0?=
 =?us-ascii?Q?AdgKPxd3LYuhMIJ1kq14LAtFi8/dCmTBx9j+xsEc2uIqAT0FjQWXiH3fiIbP?=
 =?us-ascii?Q?oLLj4niKAo5JtzW0UoqMd4QrQu36WWuDDCdBqAuWAaYYCKOGe6at00mB1tfW?=
 =?us-ascii?Q?koBRWJYCTJHHfxWYv4YkeVV38jqU14Yrt0H9YtGB6hI3enHdyeg0ziPChdMR?=
 =?us-ascii?Q?I5c4MfxepHcIPMzblcpvtY/eAzMnpWbmF1HdDkT/78Xao8rz337zAdiNVZFi?=
 =?us-ascii?Q?t3tuqsNHdOeSF+aV7LRcfT5ANQWjkeKIVclznkGxposLJQCw1Va2kUyoybTz?=
 =?us-ascii?Q?bBJADfJVkbQuFoZiAfentgJYQziNS2aLJZszYQeaDRUNW/kzNzbzbINSosFA?=
 =?us-ascii?Q?WF7toQFCODAx1MwEA/rcRaigxSBG0nXR/jg0stdXecOMgfgVaNzbTqHy1TDX?=
 =?us-ascii?Q?307ph1U3/fcS5qksr9cMSZySMbD0uVhkySroDgIapWV3JijbKY0H7kK2B6Iz?=
 =?us-ascii?Q?MRJXY6PPs+dTcxI3wi4f/5vLgowIt/VzUHpNED0m9b5hQ7E3nun7iNAYlmEU?=
 =?us-ascii?Q?l2ayfqR0OVtsE236c+q2oCDsmOfP16MLoSX6Twfjp9+bEDk5oalw2rdraepR?=
 =?us-ascii?Q?M+GLIWKJuYO53zD/IjzRlTuawzFrnVm2sR4v8R759voS4AtBUqUc9LNzNqgE?=
 =?us-ascii?Q?0QXy7H6C4OREas8xv/zB3OHB/120hib0MS8b8g73560+Zp+5Huskm3yniB2W?=
 =?us-ascii?Q?/qXXw257bB0H2W6RjP2fPrPISRc81yqChgQO+thNwszg2Nrin2rmPnbONfKe?=
 =?us-ascii?Q?Mio6EJ0siO3d8Tv9vQdxmEVpoOEmSKcV436rvo0Wjlr9wPupyV+ChKVnLX5m?=
 =?us-ascii?Q?ZQedn5P5IJ0PZu3/DVRhOutI3homDD1gP3x7edHAtNWEmHvuWUFEbrP7nAQa?=
 =?us-ascii?Q?5Tg7lPYFTwv0YxJLpsRw6mbcWmoW0vrTy5UjOzdqAghXmUKm7UXmX9L5gPh0?=
 =?us-ascii?Q?S3qEwl8egZ3KNDN6g81h/gmcDjaHH5TFZBwXxc05EGdN8rqmBuSEfPrq8sB8?=
 =?us-ascii?Q?jX6/tE+tlnUr623VnKpvNFD3urx06l8sIgoo+lsYPsxRSb2a2IUd/wyqVb1l?=
 =?us-ascii?Q?NE5OqA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc06bb30-965d-4b3b-c216-08db55e45d99
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 08:05:51.5803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N0QQ9PRlBj/3crDPTsuhxkRQlsaFKGt6WwrnxLGChNdIWQQAkJMrKBQ3Lma5+DNe8UwAzUuC3sf35S/NUQP2+MCETL7GMHHkdGha4q+HhkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4840
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Hariprasad,

On Sat, May 13, 2023 at 02:21:39PM +0530, Hariprasad Kelam wrote:
> 1. Upon txschq free request, the transmit schedular config in hardware
> is not getting reset. This patch adds necessary changes to do the same.
> 

nit: s/schedular/scheduler/

> 2. Current implementation calls txschq alloc during interface
> initialization and in response handler updates the default txschq array.
> This creates a problem for htb offload where txsch alloc will be called
> for every tc class. This patch addresses the issue by reading txschq
> response in mbox caller function instead in the response handler.
> 
> 3. Current otx2_txschq_stop routine tries to free all txschq nodes
> allocated to the interface. This creates a problem for htb offload.
> This patch introduces the otx2_txschq_free_one to free txschq in a
> given level.

This patch seems to be doing three things.
Could it be split into three patches?

...

> -int otx2_txschq_stop(struct otx2_nic *pfvf)
> +void otx2_txschq_free_one(struct otx2_nic *pfvf, u16 lvl, u16 schq)
>  {
>  	struct nix_txsch_free_req *free_req;
> -	int lvl, schq, err;
> +	int err;
>  
>  	mutex_lock(&pfvf->mbox.lock);
> -	/* Free the transmit schedulers */
> +
>  	free_req = otx2_mbox_alloc_msg_nix_txsch_free(&pfvf->mbox);

Mainly for my own edification:

	- otx2_mbox_alloc_msg_nix_txsch_free is created via the
	  M(_name, _id, _fn_name, _req_type, _rsp_type) macro
	  around line 844 of  otx2_common.h
	- It calls otx2_mbox_alloc_msg_rsp
	- Which does not call any allocation functions such as kmalloc

>  	if (!free_req) {
>  		mutex_unlock(&pfvf->mbox.lock);
> -		return -ENOMEM;
> +		netdev_err(pfvf->netdev,
> +			   "Failed alloc txschq free req\n");

I think that given the above it's ok to log an error here.
As the allocation core won't have (because it's not used here.
But I wonder if it would be more consistent with how
allocation errors are usually handled to move the logging into
otx2_mbox_alloc_msg_rsp().

> +		return;
>  	}
>  
> -	free_req->flags = TXSCHQ_FREE_ALL;
> +	free_req->schq_lvl = lvl;
> +	free_req->schq = schq;
> +
>  	err = otx2_sync_mbox_msg(&pfvf->mbox);
> +	if (err) {
> +		netdev_err(pfvf->netdev,
> +			   "Failed stop txschq %d at level %d\n", schq, lvl);
> +	}
> +
>  	mutex_unlock(&pfvf->mbox.lock);
> +}
> +
> +void otx2_txschq_stop(struct otx2_nic *pfvf)
> +{
> +	int lvl, schq;
> +
> +	/* free non QOS TLx nodes */
> +	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
> +		otx2_txschq_free_one(pfvf, lvl,
> +				     pfvf->hw.txschq_list[lvl][0]);
>  
>  	/* Clear the txschq list */
>  	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
>  		for (schq = 0; schq < MAX_TXSCHQ_PER_FUNC; schq++)
>  			pfvf->hw.txschq_list[lvl][schq] = 0;
>  	}
> -	return err;
> +

nit: no blank line here.

>  }
>  
>  void otx2_sqb_flush(struct otx2_nic *pfvf)

...

