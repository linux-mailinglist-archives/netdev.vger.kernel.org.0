Return-Path: <netdev+bounces-2895-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8137D70475B
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AE3C1C20939
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84E96200A9;
	Tue, 16 May 2023 08:07:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D25B19518
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:07:15 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2106.outbound.protection.outlook.com [40.107.94.106])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3447C1FEF;
	Tue, 16 May 2023 01:07:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eMbjBWsJIwIt1x0nJg37PiHKlCP6mkbRJDwR92yDML6Kv0gHCbArHItNYJVMTqyw8sB9sRvtsex37SVUQT8odjFZqRJcxYGNCsBEnY7ZMnaA2E2qo+KBlYQwihCIa57NXaXkSaKBCmldpLAiULioRW3QrJEJzKcZQ1I6TTaj5TLNfUdbSMAWmgpAIgR6aJwKAaohBk0K78RpgariuIyqH1OmB4s2uS0rjTM2I7jk0CVuZdThV/XippIlwDjFvmEN0FPgPJ/Rzn72gO6jTptjN94BAd56yPrQJREnHUWg+D65RUbS2BM8zvXwfsWuLnHNQ5hLUcPSGWp2haTK50AAyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sfvCQItQcyP45z3rReH+rUj3KDk+7T30TQq0lMOzZNE=;
 b=d9c3CV8Z3w/phFS0E6HiqTAuuZXP2+XI3EamDOWUGwTx/FZl0TQ6M0NmyLAa1ONGEMq4ACHliRhm8casN3AvYTSB2jSnbq/1TcKULS8iMKA0IDNmQdomNwoyeRHWZNvGAeWUVHoORDlZWqNkKTwLOCeLbE86i6Jnv7+t0dNJyAv5qSnmp8T0LJLnG26mkh/wRtxifKGIAEHZybcZNH8xsbCh9TvMjGmxjuWhAVaNHHKV6+JxNPRwiBn7qLO+/7S7r0aAhbtMLWP/tj4+j8q0bfIbzeaRB21MqRH7vHztDLfPuUXeh4iTLO0kJWOOaqI5ddD1+ihsWwESUsXDaAQARQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfvCQItQcyP45z3rReH+rUj3KDk+7T30TQq0lMOzZNE=;
 b=s7C48aIqhaA9/CjePuI8NfzsJjJ8GEACYm3dupz+pL9iqZVluVBvEK3/eSS5eBawz0BrU9F8sPCG1EwkAyAVnPOZyLJaSRNpBGUg1nQN8Vqms5730Y4wWixatb2hbaIBi9noNGWavm0Eodf0bqB625Z371fCDoRp2tz+JWoFCtk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4840.namprd13.prod.outlook.com (2603:10b6:303:f6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 08:07:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 08:07:12 +0000
Date: Tue, 16 May 2023 10:07:04 +0200
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
Message-ID: <ZGM5qO+Uhea7eGGt@corigine.com>
References: <20230513085143.3289-1-hkelam@marvell.com>
 <20230513085143.3289-5-hkelam@marvell.com>
 <ZGM5VmGcuEFG2Jh6@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGM5VmGcuEFG2Jh6@corigine.com>
X-ClientProxiedBy: AM4PR0902CA0018.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4840:EE_
X-MS-Office365-Filtering-Correlation-Id: 072fa85b-98df-4edc-f0c4-08db55e48dc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rJnVdu5cuVhE+wlwY99639eamc1EsgsfR3LEFkUAU+rVlbAXit64ekwEBjolYvkvQfl8au0cd4gPpPKDoDztNG/JFKosKf5Rsw+y1CqOv2vbhs9WHt//kSy8pTA3Ws+5In6UJpRvqP/eUgNBVUGEDRVvZ8pcTlxSCOFP7KJXfaLBWOL/k5ynmoPzM8njWDlY9Ydj0CTVhAJ1HygMzc4KsurtE65dZX3u7+ybZZOfJBpyUiaVSfsVZpvh783OCgCIDbal176g+ITf1I/dwsZN5m6VjvkN+xP13pMa/qBoEplef1iI+jAqgqy+6DQn3MGh5F2YmVUoFyXKa32hIh/o5uCqMp9ATzVBUZHFL2RYHsmzewlW1Yjl9WX86bag4DAkQDDKYrOW3Lsix4LRK5COsequEYO5+PywtN7LRUztuxQuz1uCl7a+YieThS7qEFruJWo5SUGcBisWtfAIhrGYE2HXFqd7h9riYCATqFC3e3TrUNTTP0Z9vd0H5REK2T+wkn5jg8IM8VvvlZa0oMfpamRUQNJMk2Fnga7tzgpgxc++bGFQij1KWjj8+LGZ4ydA/mjmvdX/Ej+Ev0P0/MhCU9pIOAi5iGBc/1dGf8G3csM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(39840400004)(376002)(346002)(451199021)(36756003)(86362001)(316002)(66946007)(66556008)(66476007)(6916009)(4326008)(478600001)(6666004)(8936002)(8676002)(5660300002)(41300700001)(2906002)(7416002)(44832011)(38100700002)(2616005)(6512007)(6506007)(186003)(83380400001)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s172XiiF9oXrabOlz6oYRH7rbxUBsjMmq0/GkHTDZAvhkz2+SG0pz8HdCJLl?=
 =?us-ascii?Q?50oXLedpLRLbmd9yjVheUxyoFSA6ZVHWpyn1N3XRrccOYoIaYoQdxFBObM2V?=
 =?us-ascii?Q?kqezqTIa8ZD4XUbGMBWaFHoY/Akp//UnY6eESe6Xis9vBbGVbSt/ErRkaamP?=
 =?us-ascii?Q?avO8A1aAeSCXqsbsjFWCuNj4MIy8kQ5tr3WVqzBHMonR3cCXXAFzb95oeIPt?=
 =?us-ascii?Q?IQvQ81ufa2XLGJT8WaFC3XzJPO+1RfwA/34hdX6GMpuvb3CkOthlxJBMS29V?=
 =?us-ascii?Q?Zobd4+z48+92tlzpQK+S8FYte7na0CxCRccB1ysxXgCfAWLdoiZtw7KckCae?=
 =?us-ascii?Q?fjXoVP9hlHwDsMkbSWojS6JuZkyIDCczM7j2D9yGRNjZjC1FMXoZFIr2wL8b?=
 =?us-ascii?Q?hNTDP37S2TPwIP18d+uG9z1kCJZ3BDRZrs4ShfRLn2b22mbzx8MtmRP1/UW8?=
 =?us-ascii?Q?+PS1XlM69MrGPMVzsu/o7bR1xIJiUSurj40Hq5C5SUTtdjDpZ8niHEa4njIz?=
 =?us-ascii?Q?3u3CrkVG4R/ysBM47WQ1T85ssPYjAfEIcD4JLJztihG1O/6QOrLoZrK0k8EI?=
 =?us-ascii?Q?kqOacSXc9r2W5Rtqt3i15/UQxs1gVPe8Jenm449OHOibyyI4PfLYXYZVhl9c?=
 =?us-ascii?Q?xAa1zF0+R30BVhaKaPH/c1YplhhRgp+DOTUBUuhzp6yooTo96VemytAmvfDR?=
 =?us-ascii?Q?UmL8YPEggFeN2xVZVP0bquasUH7UfsE0K5WIRjZO6mdXLHf6n3Ot5Ke1+EBA?=
 =?us-ascii?Q?i9BFNB0w/tZrmRDhzj6JcuL9CO9kxzDiON/rKoCl2cLF5JwrFY6Dr01Uofe+?=
 =?us-ascii?Q?CORNTNb4wwxqLpeTaA7mZ6nRdXPJrbI8adZQtJlXUU+vblwTXjIGo9yaQ8g5?=
 =?us-ascii?Q?xIAHhmfd9jHYyf/IQPwMaWyIhrj0JKQfydbqHFZdY9oqtMtnelGKkloH+bc/?=
 =?us-ascii?Q?BNmp/ZeWrWUdFpnuwCKII4k47YCTXHShEWhBCEJ1EfUrKdnUSeHrBQhHAYI0?=
 =?us-ascii?Q?nj5gwGGROZ2j4SKHvFIzEjHYbTnnWYN9aV0hVb9I8PmOnkMc+SWPPKXP/mT5?=
 =?us-ascii?Q?S/Bii3s/C3ATmSIbE59UL94JrabjB6fdgA6qGq4lNhlVz+UWj+Uld4dqkj8e?=
 =?us-ascii?Q?dNGgGv2YIAoe+TvW9nfu3F9ccWDtAzsHue54JNgqsNNshjwZYdxZEALyfEzH?=
 =?us-ascii?Q?4JuEghff/SSND8jck3fuh6IGFsMkFku8RS3so0fcEkeg2Y3S7B5quxvcZlzn?=
 =?us-ascii?Q?BTNXnj84TMi5c8G9k44xh+QDoWTfOeD7RsELuvrrtqd3y+UTd9vA7Hg/UviE?=
 =?us-ascii?Q?2uxq0EC+iD+2fWnW1JEg+VSkhH+aUmfVAhXtPn91mWuPXivMAZ4k0uZ8bNPx?=
 =?us-ascii?Q?20M8UQU/AjZOpy6aBe3sMVp/xW6MWqKWsizcCUKbgxZz89lTR0TEofk/uV9h?=
 =?us-ascii?Q?zJdz+kiwGV/HLFRAFV7pWDErTvgtsgDSeqGis8D9ot+b2vBDYIufF+kIaw2x?=
 =?us-ascii?Q?qje7rirxVmRq6dMsQvy9BYf2uBmY19YC8CBOigDnSTp33TkvF9zCw+SvvoQs?=
 =?us-ascii?Q?jr6v2GsIkbd8roLY5Asre0gyXGixALFAn+tqgOGLl1ILh+fWKamSPcKU2LdW?=
 =?us-ascii?Q?GBiqjSPWJ5TTOkYCegpaS/IkERgNZtElJNqvKTXddTat3rqPWsh3h2uFBGIh?=
 =?us-ascii?Q?Xyw3mg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 072fa85b-98df-4edc-f0c4-08db55e48dc4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 08:07:12.3797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1UJnq6m+30JRjMyyTB6DeUVKGOudr1vPUTWT52Whd1gnkRLbsfLcfnYMUJj2tm3Hh5OMmeWohwe8wA6tRPaxDSM2ShImoP9kxCrtRsSM7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4840
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 10:05:54AM +0200, Simon Horman wrote:
> Hi Hariprasad,
> 
> On Sat, May 13, 2023 at 02:21:39PM +0530, Hariprasad Kelam wrote:
> > 1. Upon txschq free request, the transmit schedular config in hardware
> > is not getting reset. This patch adds necessary changes to do the same.
> > 
> 
> nit: s/schedular/scheduler/
> 
> > 2. Current implementation calls txschq alloc during interface
> > initialization and in response handler updates the default txschq array.
> > This creates a problem for htb offload where txsch alloc will be called
> > for every tc class. This patch addresses the issue by reading txschq
> > response in mbox caller function instead in the response handler.
> > 
> > 3. Current otx2_txschq_stop routine tries to free all txschq nodes
> > allocated to the interface. This creates a problem for htb offload.
> > This patch introduces the otx2_txschq_free_one to free txschq in a
> > given level.
> 
> This patch seems to be doing three things.
> Could it be split into three patches?

I see that I was a bit late with my review as the
series was applied yesterday.

> ...
> 
> > -int otx2_txschq_stop(struct otx2_nic *pfvf)
> > +void otx2_txschq_free_one(struct otx2_nic *pfvf, u16 lvl, u16 schq)
> >  {
> >  	struct nix_txsch_free_req *free_req;
> > -	int lvl, schq, err;
> > +	int err;
> >  
> >  	mutex_lock(&pfvf->mbox.lock);
> > -	/* Free the transmit schedulers */
> > +
> >  	free_req = otx2_mbox_alloc_msg_nix_txsch_free(&pfvf->mbox);
> 
> Mainly for my own edification:
> 
> 	- otx2_mbox_alloc_msg_nix_txsch_free is created via the
> 	  M(_name, _id, _fn_name, _req_type, _rsp_type) macro
> 	  around line 844 of  otx2_common.h
> 	- It calls otx2_mbox_alloc_msg_rsp
> 	- Which does not call any allocation functions such as kmalloc
> 
> >  	if (!free_req) {
> >  		mutex_unlock(&pfvf->mbox.lock);
> > -		return -ENOMEM;
> > +		netdev_err(pfvf->netdev,
> > +			   "Failed alloc txschq free req\n");
> 
> I think that given the above it's ok to log an error here.
> As the allocation core won't have (because it's not used here.
> But I wonder if it would be more consistent with how
> allocation errors are usually handled to move the logging into
> otx2_mbox_alloc_msg_rsp().
> 
> > +		return;
> >  	}
> >  
> > -	free_req->flags = TXSCHQ_FREE_ALL;
> > +	free_req->schq_lvl = lvl;
> > +	free_req->schq = schq;
> > +
> >  	err = otx2_sync_mbox_msg(&pfvf->mbox);
> > +	if (err) {
> > +		netdev_err(pfvf->netdev,
> > +			   "Failed stop txschq %d at level %d\n", schq, lvl);
> > +	}
> > +
> >  	mutex_unlock(&pfvf->mbox.lock);
> > +}
> > +
> > +void otx2_txschq_stop(struct otx2_nic *pfvf)
> > +{
> > +	int lvl, schq;
> > +
> > +	/* free non QOS TLx nodes */
> > +	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
> > +		otx2_txschq_free_one(pfvf, lvl,
> > +				     pfvf->hw.txschq_list[lvl][0]);
> >  
> >  	/* Clear the txschq list */
> >  	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
> >  		for (schq = 0; schq < MAX_TXSCHQ_PER_FUNC; schq++)
> >  			pfvf->hw.txschq_list[lvl][schq] = 0;
> >  	}
> > -	return err;
> > +
> 
> nit: no blank line here.
> 
> >  }
> >  
> >  void otx2_sqb_flush(struct otx2_nic *pfvf)
> 
> ...

