Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECD36B91CA
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjCNLiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjCNLiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:38:01 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2118.outbound.protection.outlook.com [40.107.94.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D809E32E;
        Tue, 14 Mar 2023 04:37:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIhe9BlohCxaYyXXVIEhIF0mUTlW3Iombjlo03H1nQuaiHaxwwlK45HVvE4VJ0v984rqLELjzUoXtIblTRUxxrE9G7RQqHuSR6ZmtcbSrdsF2plW6M7X2wwGSG/eM5NwIN0DgU5AqQQH3FxZU+CWyJVSFXvAm7DrUa6CKX+et+3DHm+MFDr37YdWxfV98zbyPY8NFZRzD3/haxX2rYWO6aPX40k10wZd8XUgxjJRckm5k6nABD/4jp/Y7cNKsfxnbHjLQmMOoNwG2qgq3bsRfa48wGpo8ZbI/FfnbPgxlZ1C/Rsa3cMUcQwQd35LbOSIS2S/NVnAunyNmhAlawPbMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9EcrCZkKM2HtYqeu6Q1TVl6Xz3OSOobjJ4WWYXXBKU=;
 b=HD6iyoRwj+GVWyfGcPUNEO7gfSjwqdOUEQvsaLxFTjgKewVhW3ys5JmttQqd8BjNqaXJPlx2Y+T34UiCsJS5o+0DC/ZP4soGGQVHcioqckIdPTMh0iL9TN+bJWI628uSDIbZ0h5BgwkismJQ/InFVg9EElR1MUkOp8lo/HmzBP2h3PcOnlicRHySrOigA47Ajccp6wG+gqsAIGRPszS/CYz38h8DGT6YNbSV4A96x+CWLF9FRzNPTkaCp0RtNuwVm5sL/zPLhYIIVLIcX6ZxGt8PC5nnYKx+H+BBxBDqPd1AqnaTBHQ1B2FQMLn31H5HIYpffrbh17DYRoZhl4paEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9EcrCZkKM2HtYqeu6Q1TVl6Xz3OSOobjJ4WWYXXBKU=;
 b=Hn9fCRr1WWXBZq8nTDWbbXlGTx4zR5dLERIe1OgwhunRbwvDkB49LSLhFeWib2SqMNTKWny6bFiFTGO5Z/atll4XOXhTcvt/qrucr0lRIMMzkO0+ZDELspJWpPbcC6lBjx0DHOMfGUgf95pVkAZ1CS2fLqCUY4uERjZ0wF8t8dQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB6148.namprd13.prod.outlook.com (2603:10b6:806:337::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 11:37:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 11:37:52 +0000
Date:   Tue, 14 Mar 2023 12:37:45 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, sinquersw@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH v2 net-next 1/2] net-sysfs: display two backlog queue len
 separately
Message-ID: <ZBBciS/flAz2cPBq@corigine.com>
References: <20230314030532.9238-1-kerneljasonxing@gmail.com>
 <20230314030532.9238-2-kerneljasonxing@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314030532.9238-2-kerneljasonxing@gmail.com>
X-ClientProxiedBy: AS4P189CA0031.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB6148:EE_
X-MS-Office365-Filtering-Correlation-Id: 676a19b5-5c9b-45b7-2fd1-08db24808bd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d2TofWOa570LS559GmT49skD1Bv23ECmrmKG7S2icIE5+SjxNOB/jCAvNPbZHRY6znkt24bXhD+5x/kjQN57euBLK9COUgeC6ruCD0FFyP15jYKZoCGwUU5GocJmQG/hpw+ZkmsXC1ivsaFKz56tkTtOaMQmXmyTIL7zV/Ax7Z7kqpgQX57904xcwC8fd+6FMupuSLKgVZF5IaBCx9sTPES6xKBw1cHCPtI3DwWo0U7kSzfbGSarfsB2+xNlYcvCxQ6n04nN/J8clsHF8wWzM5xWnJ6uyqmiPLYzUBwOLCc6pUNAr5wfHk8IkNd1OoS6lnCRuhy8dbx+y2bNsDzzrtbBelaWDtR02uZ1gcUopvJqUtmKqGripDCALqDMHVwuj0J3Zv7VGQw+4jL9tC6erG1R29b7vI69MJKjLSNpvclMdFqLE5Ot/eD/uPuY4tWZir4m+9xJIDkaLuc+BLOZGhRu6OGm/5uOGqopBPDnJu/5zg0+O5x6Oq1tYXqJ8NHFRJ0IWG+WCZfrxIfskwUGOf+gzyxhcd6+p2Kniwn0iOArDm+bRmigC4HIUKwfoFbJvFc8+gvFxc+chSTDtTnMKOqArMEybdqDm5ceB07guszb5jvllmW0pXnUVEVO+NdvHKGwZWSodMU7uEVnYiZO2WrtfpPuZJxkGK51qpHVoCSumbRzi8etFSf5IdogN6KP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(376002)(396003)(366004)(346002)(451199018)(8676002)(41300700001)(4326008)(66476007)(2616005)(6916009)(66556008)(66946007)(5660300002)(7416002)(44832011)(83380400001)(966005)(8936002)(186003)(6486002)(6506007)(6512007)(478600001)(316002)(36756003)(6666004)(86362001)(38100700002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iYlTeqfpRLobVHSjKJKIfvLUomfR/Q2lYXj3RZvCJk5uQjvNUC/U8AO+E3pM?=
 =?us-ascii?Q?dMAmXBib24UxOJvsAQysWHawWMCpvjrpCmDW6gZmhOB9Ur3bHz8rfRSitHJu?=
 =?us-ascii?Q?XT8zH41qrW7a1zCFePLtumjWbotn2cYeVMUhzz1ihHzXIrHtv0a1KUn+8cA0?=
 =?us-ascii?Q?OYtXWa/9KL9UoPAUxNKfsBmI36w7zLEG8zLBMYKnZ9Ma3eg1Z9jAN1USDvgv?=
 =?us-ascii?Q?iUbAnIcTMVwjpHKmRTIJZ4aQzO6XzRKtc6p+VwZe7EKsLFlVF0lkudS74bR4?=
 =?us-ascii?Q?RUC8rhAcIswyy0D2ig5LkoOPvkr29m+Vo7dAZwrQGTpByiCIDQdbscvVImmp?=
 =?us-ascii?Q?wZYkgyIRwywZSS3DjIxctsHcLMSpevDsh+RPm2bqQYZaQnN5jTk3rGtKWSag?=
 =?us-ascii?Q?ywT9PD/FnQZjqwxvkI6h30OkUc3Q+TfWf2+0pKHVMDou0/n0aYG3JSFKfbgY?=
 =?us-ascii?Q?D4I6Uw74edHySw01i/ektZZSthRH1PnOq7Hs5mSC3+FwW6a88v4QjnkoFH6i?=
 =?us-ascii?Q?9H7apj+6BY+VLbt+PfDKbkhviGyuCfuhRofnmF0w6DPnAuOd5d5gWaXzrudo?=
 =?us-ascii?Q?/fnoECXg+LPOu5tHA3sKLKI/PKPlHqAbXSEsqEXKRWkw2QTVHiQrDpCJrL/y?=
 =?us-ascii?Q?/LvBuZxu/tP6xKvZyR1OD00uckqribG7Op4RWlxCo5h4ytX4QlsGpCfO1nbT?=
 =?us-ascii?Q?dXmQv+4Hw/gW0oSHrrp2KF7+mSvBtqqtS5vYVdpsrJXlaRt4ZQ41KOjj9/kB?=
 =?us-ascii?Q?wcV5xRTljjSyDs2/mIQv5353925VzbJgu4jreVXDV6f86JfjR3yxsSYpnxDd?=
 =?us-ascii?Q?/VhiNOavtfioNYP6KKmTiyfDlsnX7uH8YkrFFQQsc+xBz+JVfUeIwoMSvdgR?=
 =?us-ascii?Q?3jUHW7afiXoPTnMKROH2iRopLbknMw+ol/0F1q3ObR85KDIUCj7FnMX2KnW7?=
 =?us-ascii?Q?gcI65SixeDP9Tj0EBKeYtg99XRmCeWjAgnjrwF+6pKEv81GAWt/Di7yA4xVY?=
 =?us-ascii?Q?v1JcvIM4l2eJowretWM8w8ElL75F/ryKoxW6KxsjEdZvLSW5KNZ8jMqo1N5R?=
 =?us-ascii?Q?EnENxmjmOMM4QuCMBNaQFGtQ+5uDX4bi6ydWetCeIDOLTJa9Z1wHbncjucEz?=
 =?us-ascii?Q?BnowD1jAXm6DPQwAcLEg3yvRITmQDFTQA0iCtlgAxgYVJ0RuSQdzLdgP4wVH?=
 =?us-ascii?Q?K7eW/jDhMpIZ74XJsr9uJ8YbOFOw8G0ZAoPGXYle1ZMLCMsvGegRBVQVW6mY?=
 =?us-ascii?Q?qRNUrmYLipUsOUWmDIF2/D4DN3Kw9zOkEVbxW6gEBIPbEhoIns2MZ3F/LeR/?=
 =?us-ascii?Q?1jGE4G862h049MOUTY1SNPP9MBzgwv2+RMZ7AMRaeMr5ObG07zaYJX/NObxl?=
 =?us-ascii?Q?+ErHoVc9cDF8tl5o27oeGTWFYBU664E0ePrDpCy0waOZ5wJYFf41rZzGXTB4?=
 =?us-ascii?Q?7/+o+jmCEpKsvoGWD/VewdVoVBxbUcTRnosjGwCVPM58ipRIgDzStZ82dkuY?=
 =?us-ascii?Q?irOoZe7KTEaytL0G+2zGoRNIou0zDMhc10056LvCW8PbCwXLNmIrXfoNyvVp?=
 =?us-ascii?Q?f1Mg9HiWYV06PvCu+CJxy2HjuzqcmOl8kWekw9t1inS8WcOD/0ywFPCkE2v5?=
 =?us-ascii?Q?fHFeBVsNEMI7M1kKU2ZwDAssP1keJ+444uX1xDs9t/bDgo4dDKgT3/MpdhmX?=
 =?us-ascii?Q?ZAz4zg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 676a19b5-5c9b-45b7-2fd1-08db24808bd5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 11:37:52.5206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4rdf1majWkrOzbB0ecWy/bV2bsarFOSP7UHNEAzZBbQr3FLD8N9So1maUVE2JpYg2nABWN0NfmQ7bD9Zwz5BWpcCAKJBB0jWd4XXgOraYkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB6148
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 11:05:31AM +0800, Jason Xing wrote:
> From: Jason Xing <kernelxing@tencent.com>
> 
> Sometimes we need to know which one of backlog queue can be exactly
> long enough to cause some latency when debugging this part is needed.
> Thus, we can then separate the display of both.
> 
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
> v2: keep the total len of backlog queues untouched as Eric said
> Link: https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing@gmail.com/
> ---
>  net/core/net-procfs.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> index 1ec23bf8b05c..2809b663e78d 100644
> --- a/net/core/net-procfs.c
> +++ b/net/core/net-procfs.c
> @@ -115,10 +115,19 @@ static int dev_seq_show(struct seq_file *seq, void *v)
>  	return 0;
>  }
>  
> +static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
> +{
> +	return skb_queue_len_lockless(&sd->input_pkt_queue);
> +}
> +
> +static u32 softnet_process_queue_len(struct softnet_data *sd)
> +{
> +	return skb_queue_len_lockless(&sd->process_queue);
> +}
> +
>  static u32 softnet_backlog_len(struct softnet_data *sd)
>  {
> -	return skb_queue_len_lockless(&sd->input_pkt_queue) +
> -	       skb_queue_len_lockless(&sd->process_queue);
> +	return softnet_input_pkt_queue_len(sd) + softnet_process_queue_len(sd);
>  }
>  
>  static struct softnet_data *softnet_get_online(loff_t *pos)
> @@ -169,12 +178,15 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
>  	 * mapping the data a specific CPU
>  	 */
>  	seq_printf(seq,
> -		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x\n",
> +		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x "
> +		   "%08x %08x\n",
>  		   sd->processed, sd->dropped, sd->time_squeeze, 0,
>  		   0, 0, 0, 0, /* was fastroute */
>  		   0,	/* was cpu_collision */
>  		   sd->received_rps, flow_limit_count,
> -		   softnet_backlog_len(sd), (int)seq->index);
> +		   softnet_backlog_len(sd),	/* keep it untouched */

I'm not sure the comment on the line above buys
us much outside of the context of development of this patch.

Likewise in patch 2/2.

That not withstanding, this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


> +		   (int)seq->index,
> +		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd));
>  	return 0;
>  }
>  
> -- 
> 2.37.3
> 
