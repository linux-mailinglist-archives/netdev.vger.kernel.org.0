Return-Path: <netdev+bounces-8551-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E72724854
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:56:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E77031C20A5B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C583530B80;
	Tue,  6 Jun 2023 15:56:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B331237B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:56:16 +0000 (UTC)
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2049.outbound.protection.outlook.com [40.107.104.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1C210F7;
	Tue,  6 Jun 2023 08:56:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqzMzdF0CcvWJm5OBReAoA7x5+W1Fdh0X2TSWsU/UvHVRRqN2fzquscE8MZpM4samZvSCl658K/rD9DZeSgpF3xZUmODbwWXj/d9D5C3mRaXqrZ2gpM0917faJfSueHMVjOoNGCUafJRE4kX0pzNw1lwhflmPoWeC/R5o8G7MTkZVO6ylsPOnuOECgO8J7A6tgPwfd0hrdSMVYUC5rkQiDQs/cvX84AEZHFy1YBpOmgL/eClNailkA93f7WC3UvAw0bJ/3O7yCgzzXxnEdVuOkM9SE/YXQNRcOZB8ezFm3BF8lPhKzLFVjrwiyzyY5txMniuunIVoheDj4nwfdKLEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StPWFbvQRCC58TB134SLDh42/K5iPmHHW8Uo1f5WOIk=;
 b=kd01yazIPoBjgRcoZsMscsg7tY7WNqZyYCIbrj7wGrF/H7o9u23A1K9eWLRx+lmbjScJL3bD5u5qV/f9t1Ss3e7NWQU0SHWtwWC2F82CWoYXkgT+uqvkHX7vlzQR1Ah8P7DGZOmxvwY2yOu2afp2zZTD1C0WM8LTFdrrJv9n6KQUQhtbZugCvEmoqAK+UerP2PeBlO6AlHOJsDeMdtureJ6kKCB+2Vew7H2Ed+KDu+4vvoqPB7+EBvbujtPF1P4uvxWZcDZq8j8qUxAPH4YG9zFON4Bd9nKXs8c/L1Am962i4OOkPfxsxTkvpfcrUnT6sr7oko/X7JCwEhkysbx7Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StPWFbvQRCC58TB134SLDh42/K5iPmHHW8Uo1f5WOIk=;
 b=SntJ7B33+zy9Yg6wcznXR+o096WbL/y6X6ZsAmUF7rCDJhVyGpgmmIN30HnsAFp5sAQBQ43Ae2jbgIVk8U/mwFiIKXhBjTQs17UvcPGB4M5wRSdY7+O9XB3BtCwH5DH5okRJMVeNmAzukIYPP9QY5MxdrK+/reRg5cRRXG3R8xA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by PAXPR04MB9400.eurprd04.prod.outlook.com (2603:10a6:102:2b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 15:56:10 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::5ca3:2022:337:7c40]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::5ca3:2022:337:7c40%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 15:56:10 +0000
Date: Tue, 6 Jun 2023 18:56:05 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH RESEND net-next 2/5] net/sched: taprio: keep child Qdisc
 refcount elevated at 2 in offload mode
Message-ID: <20230606155605.so7xpob6zbuugnwv@skbuf>
References: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
 <20230602103750.2290132-3-vladimir.oltean@nxp.com>
 <6bce1c55e1cd4295a3f36cb4b37398d951ead07b.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bce1c55e1cd4295a3f36cb4b37398d951ead07b.camel@redhat.com>
X-ClientProxiedBy: FR2P281CA0151.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::14) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|PAXPR04MB9400:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f1b6329-da10-4e72-bf7e-08db66a68bc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	94aKkGAadypOI/EWTUNw0LZpo3ZQq4eyLbs+LO4vbDMkZWDOCMLO6YNR1k2pjftHlLkoJmpMINwjkI7gt0LXd+fdMwX64cKuNXLzWrcGrVLBJy5WpsdZIN3IYRLi0wbHTz0q5xeAVMnYoxIa/2yuZz6+iaCroVpEXqsaMwAR5rUnlgZtU2xZJgdZb82rra+E5CchJBtDlvzXzqLmBJGmPSHQFoJbxhuMpdwLsfEf9eZSXTtHTpGRaQ9lrgiQ204Hvg27r12SfDRf2/Sl8uMvp1ecO7dqxWkfwq9r7f2v5tnuPZ4btY2Z3iFg8XFEhw6c0bw0vpWPSgHRybFvWBTPhLUh6g56LwYzGPL+lU3ZwBzMJyx0apHQNM+swrCrGTAWCHZsJMHB6TV/9rxnm2FfEB0JfoDRE1VgANgKAUCmpv6XRuATOAetEcvrRMlk6rQ0bHdFMIRu89t0xIL969NIjs+9lY2AaR6L4QYeoQkuKl5K7TagqttgoqF7SM8MHHVF2NdTIKCLvs8kG0M3GjfXjgXfv8W7Fr2a4WhJImdVGl6lz3ewOSK77xk/ZVlExDyS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199021)(2906002)(83380400001)(86362001)(33716001)(38100700002)(6486002)(41300700001)(6666004)(5660300002)(316002)(8936002)(8676002)(54906003)(478600001)(66556008)(66946007)(66476007)(4326008)(6512007)(9686003)(6506007)(6916009)(1076003)(26005)(186003)(7416002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GYb0ScFWStHPdnzEP+xBfuDX57Kh1leo+Db38NdDP7nnIuYHRk9HZdHGPC/h?=
 =?us-ascii?Q?wwlpoGZrDfRwoz8+t1Jz51h1tctTen37HUtfhni8yyEbBdRl+f0sK77qV1pl?=
 =?us-ascii?Q?mQrUCsAW06cFRWA9nuqLGhsT2B99P0z/JW36pAgbJULBeceizI7s+p4ZGt1O?=
 =?us-ascii?Q?n/AaU5X2SD+qT/4jmH5+gPorLxbav8+lju8VZATi/P0BzLHdLyN3CYNAEc23?=
 =?us-ascii?Q?EcJ7yCvj4U5s9ioqfsFN0KDC+eGvFDNlLoEqc4K7WXlQCuagnxD2AnHvtQ08?=
 =?us-ascii?Q?anq6FCveXr5xp8GKrUH7Iar/yX8c8Rj7LDBrMCYrDAnhOyyjY7Qr0SN6V9y+?=
 =?us-ascii?Q?ffwMhJNup3iDWzGU86UDdiL+1lPdNySAld2MUFq4Y8jS6cvY7Tfblv8iKPqj?=
 =?us-ascii?Q?T4/QDFjhVQpAb+Pm9x4u1Fkx3KGKZ6RlrNh6zlF7+VR15uUbXueCzM+L0izD?=
 =?us-ascii?Q?TFtMJxuNkTpmpp3v6/4Dwi2eUyJJFQ2yuOPqxlY3HZNPhl8F3ZPWJIyWEhJX?=
 =?us-ascii?Q?d89K5MgE+8BD+hcG+jC3HDcPfjqeuot7uTmKjC2jcjF8jnSB2Ec/qJudp5H/?=
 =?us-ascii?Q?TDx9SOfAcT+r9PuDlnkft6FYYhpGT2e0xsYrh27+W7FFxDR2BzEaFtIyp44l?=
 =?us-ascii?Q?8jzDQCduGs8yDXZ0Z2Ybk0dIejnPpbX7YK18wql9YTvVS56MS3R+NAbxlpTH?=
 =?us-ascii?Q?79JKxMu+9is3vAEHHNtuuD3HrQPMYq5Dp/tk0+aLyJ/HeesTbIYgxMvzky2L?=
 =?us-ascii?Q?A2Ai8xUPHieqgL7RkyO/PzentchoH0O3IA1FRfvkm/jqnKlxkr7PpYxephhY?=
 =?us-ascii?Q?KQdhmWslphg1pIsoE78qKI20Mr2J26OlycAMlUafPK6Hh68LtObEwqBG8gW4?=
 =?us-ascii?Q?IYrXG4gm2XIGV9felMbi++OEq7P6DuwBLPc8UBhtn9TOZ8lZT+BftIUgvebw?=
 =?us-ascii?Q?8FIXyKf1umIjzgNEE6ch+nOPgfIVj7MACZKY5cI3n0hhkINX/kYJSEV6op/U?=
 =?us-ascii?Q?G3jyWyxcY/DmAE2iYp3h7UWc1NCV5oSNtv5jJvdZQDmafz/6VB9H/nEzsDKb?=
 =?us-ascii?Q?Y7TxYesMGD6CnfNJ9NWoYeC9PoNEA2LxU6zg8ZaH+HZzNEVcCmEktomiaNtm?=
 =?us-ascii?Q?2eM0BUktUnGKuVPGLsBHhmrVL9NB0nEv3Fqe+UM32ZsBAHsn9Igo1zZg5FiM?=
 =?us-ascii?Q?cTF/+LrI2ABFIN5usU0U/knAPItQeylQ3L6ttZ9vWtcfi3VIK0F3ELN+N8bM?=
 =?us-ascii?Q?Hs23c6SLdaGxDU18JKh7G9WE93FyUdc0zHav9hZAn+f/BMFuxo8CH3f7jtjx?=
 =?us-ascii?Q?3aeyTxbWaHnT0wLtHc61U4jwr0cfJryihKEN05GLqlZP62GqGCcLkrCZdoVD?=
 =?us-ascii?Q?l91yTtokM63dUdKdrzgXd0Ck77jLrS9HKQ5yB7yOxOWiAVu5U5KKdHAAoqtr?=
 =?us-ascii?Q?3WXK/Ivr8kztDFknYuXrRLZYoGsLg5akb9r8vqOES5ph5mnfO9d7IYk+jPkm?=
 =?us-ascii?Q?gq+bTlsTiY/rI47wr/Ku0yoTD1YEPrzf92vgMjsTj/XX5wQKBkwzj592nFtY?=
 =?us-ascii?Q?nvIytitiJsw4o4zLBUBeshxEtb02B/GYpoXc73dhLHxcWE+QrWBL9/CUSdSq?=
 =?us-ascii?Q?qQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f1b6329-da10-4e72-bf7e-08db66a68bc9
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 15:56:10.0627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ss8XIYG4PIBnWs3Z+OVn5mrNmktB00k7wNZJNmqU8rYuUm2WtrhIz6VlwGC7C7CTHcumfWB6o/uhV2vtpjHNfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9400
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 12:27:09PM +0200, Paolo Abeni wrote:
> On Fri, 2023-06-02 at 13:37 +0300, Vladimir Oltean wrote:
> > The taprio qdisc currently lives in the following equilibrium.
> > 
> > In the software scheduling case, taprio attaches itself to all TXQs,
> > thus having a refcount of 1 + the number of TX queues. In this mode,
> > q->qdiscs[] is not visible directly to the Qdisc API. The lifetime of
> > the Qdiscs from this private array lasts until qdisc_destroy() ->
> > taprio_destroy().
> > 
> > In the fully offloaded case, the root taprio has a refcount of 1, and
> > all child q->qdiscs[] also have a refcount of 1. The child q->qdiscs[]
> > are visible to the Qdisc API (they are attached to the netdev TXQs
> > directly), however taprio loses a reference to them very early - during
> > qdisc_graft(parent==NULL) -> taprio_attach(). At that time, taprio frees
> > the q->qdiscs[] array to not leak memory, but interestingly, it does not
> > release a reference on these qdiscs because it doesn't effectively own
> > them - they are created by taprio but owned by the Qdisc core, and will
> > be freed by qdisc_graft(parent==NULL, new==NULL) -> qdisc_put(old) when
> > the Qdisc is deleted or when the child Qdisc is replaced with something
> > else.
> > 
> > My interest is to change this equilibrium such that taprio also owns a
> > reference on the q->qdiscs[] child Qdiscs for the lifetime of the root
> > Qdisc, including in full offload mode. I want this because I would like
> > taprio_leaf(), taprio_dump_class(), taprio_dump_class_stats() to have
> > insight into q->qdiscs[] for the software scheduling mode - currently
> > they look at dev_queue->qdisc_sleeping, which is, as mentioned, the same
> > as the root taprio.
> > 
> > The following set of changes is necessary:
> > - don't free q->qdiscs[] early in taprio_attach(), free it late in
> >   taprio_destroy() for consistency with software mode. But:
> > - currently that's not possible, because taprio doesn't own a reference
> >   on q->qdiscs[]. So hold that reference - once during the initial
> >   attach() and once during subsequent graft() calls when the child is
> >   changed.
> > - always keep track of the current child in q->qdiscs[], even for full
> >   offload mode, so that we free in taprio_destroy() what we should, and
> >   not something stale.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  net/sched/sch_taprio.c | 28 +++++++++++++++++-----------
> >  1 file changed, 17 insertions(+), 11 deletions(-)
> > 
> > diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> > index b1c611c72aa4..8807fc915b79 100644
> > --- a/net/sched/sch_taprio.c
> > +++ b/net/sched/sch_taprio.c
> > @@ -2138,23 +2138,20 @@ static void taprio_attach(struct Qdisc *sch)
> >  
> >  			qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
> >  			old = dev_graft_qdisc(dev_queue, qdisc);
> > +			/* Keep refcount of q->qdiscs[ntx] at 2 */
> > +			qdisc_refcount_inc(qdisc);
> >  		} else {
> >  			/* In software mode, attach the root taprio qdisc
> >  			 * to all netdev TX queues, so that dev_qdisc_enqueue()
> >  			 * goes through taprio_enqueue().
> >  			 */
> >  			old = dev_graft_qdisc(dev_queue, sch);
> > +			/* Keep root refcount at 1 + num_tx_queues */
> >  			qdisc_refcount_inc(sch);
> >  		}
> >  		if (old)
> >  			qdisc_put(old);
> >  	}
> > -
> > -	/* access to the child qdiscs is not needed in offload mode */
> > -	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
> > -		kfree(q->qdiscs);
> > -		q->qdiscs = NULL;
> > -	}
> >  }
> >  
> >  static struct netdev_queue *taprio_queue_get(struct Qdisc *sch,
> > @@ -2183,15 +2180,24 @@ static int taprio_graft(struct Qdisc *sch, unsigned long cl,
> >  	if (dev->flags & IFF_UP)
> >  		dev_deactivate(dev);
> >  
> > -	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
> > +	/* In software mode, the root taprio qdisc is still the one attached to
> > +	 * all netdev TX queues, and hence responsible for taprio_enqueue() to
> > +	 * forward the skbs to the child qdiscs from the private q->qdiscs[]
> > +	 * array. So only attach the new qdisc to the netdev queue in offload
> > +	 * mode, where the enqueue must bypass taprio. However, save the
> > +	 * reference to the new qdisc in the private array in both cases, to
> > +	 * have an up-to-date reference to our children.
> > +	 */
> > +	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
> >  		*old = dev_graft_qdisc(dev_queue, new);
> > -	} else {
> > +	else
> >  		*old = q->qdiscs[cl - 1];
> > -		q->qdiscs[cl - 1] = new;
> > -	}
> >  
> > -	if (new)
> > +	q->qdiscs[cl - 1] = new;
> > +	if (new) {
> > +		qdisc_refcount_inc(new);
> >  		new->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
> > +	}
> >  
> Isn't the above leaking a reference to old with something alike:
> 
> tc qdisc replace dev eth0 handle 8001: parent root stab overhead 24 taprio flags 0x2 #...
> 	# each q in q->qdiscs has refcnt == 2
> tc qdisc replace dev eth0 parent 8001:8 cbs #...
> 	# -> taprio_graft(..., cbs, ...)
> 	# cbs refcnt is 2
> 	# 'old' refcnt decreases by 1, refcount will not reach 0?!?
> 
> kmemleak should be able to see that.

You're right - in full offload mode, the refcount of "old" (pfifo, parent 8001:8)
does not drop to 0 after grafting something else to 8001:8.

I believe this other implementation should work in all cases.

static int taprio_graft(struct Qdisc *sch, unsigned long cl,
			struct Qdisc *new, struct Qdisc **old,
			struct netlink_ext_ack *extack)
{
	struct taprio_sched *q = qdisc_priv(sch);
	struct net_device *dev = qdisc_dev(sch);
	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);

	if (!dev_queue)
		return -EINVAL;

	if (dev->flags & IFF_UP)
		dev_deactivate(dev);

	/* In offload mode, the child Qdisc is directly attached to the netdev
	 * TX queue, and thus, we need to keep its refcount elevated in order
	 * to counteract qdisc_graft()'s call to qdisc_put() once per TX queue.
	 * However, save the reference to the new qdisc in the private array in
	 * both software and offload cases, to have an up-to-date reference to
	 * our children.
	 */
	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
		*old = dev_graft_qdisc(dev_queue, new);
		if (new)
			qdisc_refcount_inc(new);
		if (*old)
			qdisc_put(*old);
	} else {
		*old = q->qdiscs[cl - 1];
	}

	q->qdiscs[cl - 1] = new;
	if (new)
		new->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;

	if (dev->flags & IFF_UP)
		dev_activate(dev);

	return 0;
}

> BTW, what about including your tests from the cover letter somewhere under tc-testing?

I don't know about that. Does it involve adding taprio hw offload to netdevsim,
so that both code paths are covered?

To be honest with you, I never ran tdc, and I worry about what I may find there,
unrelated to what I'm being asked to add (at a cursory glance I see overlapping
TXQs in taprio.json), and which has the possibility of turning this into a huge
time pit.

