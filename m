Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815EC63725C
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 07:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiKXGaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 01:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiKXGaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 01:30:06 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2084.outbound.protection.outlook.com [40.107.20.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76850942DE;
        Wed, 23 Nov 2022 22:30:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVkEps824w/De5gW0Yubv9ufwYsSV0T9mesgfZS01oRf910X3QvRs7Ax5xSx4YDt6OuJvbz4XRLNzQn36ooUykfIKnQa+oyStZDlsYTH/JToG7ICK587DJnFRdHRhn+fL4oWnfJ6Vqm9ZEuZOAdowOW3kNoOZbRQYADjUe451grTlNK13wGJwfTM58doNb+WYouhab4KV2R5oZPjnPBIHPMnKhEJYKR1Pc7TWzfTYvGAzLrpYgloVI1ZaiiFrHSB/gXIiJOQbiVdyR0tlutMnVOuI1KrlW8QpvKz+5ZxOS7v+8F7hKBShVknO8u/cISYr7wZgpkKCphNxSDK9z5/Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRJoHx2IinM8ItMff9jCO5ySEY41CZ+XBF0eIC0xJDE=;
 b=fwBdPjRlDvpU9p8pNEz16YAjNGvXC8zXxT27YuuONCug0yInFEz8rshSdRVxY9WN8hRiuox3h3AgYWyHc4fH2URxG/4XGtrjKiZBaJpH8acS369Y3Lyt0tgotf6IYhKoPuvf19bEp3ewn+WyZ8xFRadSKtjF8BdYRk6CJA4pOzveRG23wq9ciERJo6fdxtGZjz5sIqlBp8+OFvTfF8MNAY0yjJSNeu2xmg81evc6ThgpG0pl2f9KVqJ/X/SguMRk7FnK90pY8IE1QY9n5zmRaGWUUEZosCodr8ZnOJGChGaPNR4BCa4KeTxiBLj80rgtGvP0MCTVTcmm6kv1s3YUoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRJoHx2IinM8ItMff9jCO5ySEY41CZ+XBF0eIC0xJDE=;
 b=v8mVYDWMyJaBA5N0gslBO/Exs4I1q3gHUVO4ViY46A4Md5M2pqiYxKrr7WOdfPbUkAekkjPg5XK2uMzAnZv0FYCR/ACcTwr+Jr1wCeOxtWc1XlYDTrl4yyWtm40Lhr/Cm7pICePJFgpZ92RbFXCjgjSA7AoVNADpEfsDULJtGQ4JFkKPjDpHVJ/1WLBbbfuYmgUObwMyJRUndDlp/z2tHtEoIJ3JBaY+U/2V88vL9JApdxhrzbReyfNQUBSnLDTwMt/VOIHAY7uAX8FgI/hnU6LaJBzWU1ZTn8KFGVB2yE0UOAmAWNRlTnxOTR3m9cSXoGnxsdf/tTqDdgjjj9R+ig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS8PR04MB9009.eurprd04.prod.outlook.com (2603:10a6:20b:42d::19)
 by AS8PR04MB8561.eurprd04.prod.outlook.com (2603:10a6:20b:420::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Thu, 24 Nov
 2022 06:29:58 +0000
Received: from AS8PR04MB9009.eurprd04.prod.outlook.com
 ([fe80::696b:5418:b458:196a]) by AS8PR04MB9009.eurprd04.prod.outlook.com
 ([fe80::696b:5418:b458:196a%3]) with mapi id 15.20.5857.017; Thu, 24 Nov 2022
 06:29:58 +0000
Date:   Thu, 24 Nov 2022 14:29:38 +0800
From:   Firo Yang <firo.yang@suse.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, mkubecek@suse.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        firogm@gmail.com
Subject: Re: [PATCH 1/1] sctp: sysctl: referring the correct net namespace
Message-ID: <Y38PUmjeFWApHnrh@suse.com>
References: <20221123094406.32654-1-firo.yang@suse.com>
 <Y34ZVEeSryB0UTFD@t14s.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y34ZVEeSryB0UTFD@t14s.localdomain>
X-ClientProxiedBy: TYCP286CA0047.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b5::18) To AS8PR04MB9009.eurprd04.prod.outlook.com
 (2603:10a6:20b:42d::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB9009:EE_|AS8PR04MB8561:EE_
X-MS-Office365-Filtering-Correlation-Id: a846dca4-e81c-47c5-4cea-08dacde54ec8
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JMMaxiTJ61Si8OOTKY3Q+5yc4SuxgtiD9SlWLmud6r4uw6lERCNaHqhhbX/Co/MjYSX8pHZDek+lniem8ule6SzWkoxAasVAbGgAsALbumnfbMbBZ8uXJCzVcZeqn2CJsLYNunPuI8iTfaKaVZd1RxJc0+eMI5yIKiCwiOFheyLNPEYjnJhO4lqT5D4cCw6H+Cj3RV7i2U4WbMymI2SHmYv/evuy2/blcj/6uVCRIFnp7sR1umnYNRHu4d4luZg7D86tID51rfGYukVaLtD27+LDFbJuro/e6hZBSNnCFHn5TBlGtErA7tn3kfcO/vb9gn1FbBn0VeWbBXl1+sbgaER8p0q76YfVic7wt/UoaUgsphCLHm799N4xyeYIhWgWEMQQU1cqyDJpcPGqdiRbMU2YRKiLYEQ1bZNhs6YA5RkE63NO1FyWUO2EVcymoHLznsgWKEfe6zxsVGi8kWHKLh3gL4pR8tHxMfTYWWXrp7twaAQiuR4P7NVgTbdbyNvsEKuoM9KLteYAycnX2mjpGJ0HLeP8+xToIqPa06FYeyR2tnrx87wctvr+lqerj5zMW7qnnRLaUR0GZ0mtmYjPuTnp4qm3xJ5UST9iZgXaNKdLrFjy+WtJVz/QIDu90uGITiHZjKOobnb4b72G4iyAIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB9009.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(316002)(6916009)(6486002)(6666004)(6506007)(6512007)(4326008)(66946007)(8676002)(66556008)(478600001)(66476007)(5660300002)(7416002)(44832011)(186003)(8936002)(2906002)(83380400001)(36756003)(2616005)(41300700001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjFEcU40bXJkQzFTNE1KVU9sMWpJNDk2NzNVOFFqdlVXZE1RdmdhVFpLMU1q?=
 =?utf-8?B?UTE3L0pzSWdVYnRDOTdsbStnTTB6WmcwOVR2UzFBcU1yVlVtVmx5UXNrZDQr?=
 =?utf-8?B?SC9oNmE4cUlQOWx0SjVhRmFNd2VEcEZhaXh5RjVaMk5aYjZNcTJNeW0zRkhB?=
 =?utf-8?B?THYxN203WmxBOFVBbXdDaU1uNGxLVE5iK3o1amhRTHExTXBSOTRVei9XMUFM?=
 =?utf-8?B?akNBQjJZQnpzTWlmK2UrclhBTHgyZEdDUDNEbVVPeWh0Y0cvQUFDM3c4eUQ2?=
 =?utf-8?B?OXFTR1FPaGpqRHA4VG9aVVpqNDVZSXphQStQTTJ0TnQ3VWRPNW9XMHMxVWZh?=
 =?utf-8?B?UUdzemZ3NThHcVE0WEpGT1ZZQ1FKUDNKaEpqWWkyUDdzSTJVREVBSXdjZGZr?=
 =?utf-8?B?cjhBbk5FL0MvZVo0eEZYODF6aHlIZVhaMng1bENHRGgxY1orQnJJK1RqNTNs?=
 =?utf-8?B?Y3kxKzVwRDFmdnpXRFQwdXlqRXlCSXVkdFIvSzAzZThQZWRYRW05aFhXTUM2?=
 =?utf-8?B?YjEyRktmZnhCNXgxaTVZcjFtZzJaeTk3bjc2YUJsdDh3cGFzVXFnOGNKUi9U?=
 =?utf-8?B?NVpDSVV6Q08xZlpQcDdWak9wc014WTVPeEd1Z3pvdnFzNFlQeGE1KzEyWGIx?=
 =?utf-8?B?SDRnVXRrcXlUSHlsQjk0TlpNcGRER3U5U0NGd2laTk5WTmxlVE1PTWRhQ1E2?=
 =?utf-8?B?VmUrU1E3OEhOODhSZnRRaVVMcFcvcVpIVm8zVHIwcDhpUVdWTUFKZjViTENJ?=
 =?utf-8?B?djBPTGt6VFVnZHNtR2podS9DVGxkYlNYdkZZNWdmamdjWHlwaGEzS2FxQ01O?=
 =?utf-8?B?dE5Ld2VpSVEvbFROZm5GN2RhN0RKM29BSDFiN0VFN2MyajlsLyt4bE9wM1FJ?=
 =?utf-8?B?TzAvL0dEY2hLVmJBZ2hrR3IyRG1wY0MzL2RsUHpsUnNXUnpMcTJFNTNlR3Qv?=
 =?utf-8?B?ZnBzQUxwZXBHQjdHRHZVbElJQW50d1cwTFF1b1cvVnlmV29nQVlrZXZVRXR6?=
 =?utf-8?B?TDVHNFp4RkUvdHA2eTgrUlJWWFd2T2FkZmppcCtIM0h0RVZUa2RPY2RwMFhT?=
 =?utf-8?B?NUdJbXRGdDhtK2tMSnZ5S0ZYVFIrRi90ODJNUHg1YUM4Rm5mVVhndXBqRXhh?=
 =?utf-8?B?L2ZZelpPR2w1MUNnSnJheWMxTDFMMCt3bmZVMEFkakZGREFTQmc4MmFPejhR?=
 =?utf-8?B?ZHBsMGF5RmdBalN6cnZ3ZTZOQWd0MmFlaTRDT1pkMjZwWko2eGQvREdFb3lU?=
 =?utf-8?B?WWNtMVc0NktJZjFPNmN1Q3RUb1pnc0JzY0hocGdKT1liNDNYaExpYW9uLzE5?=
 =?utf-8?B?YXBMNzByeHk0NlZqakpiZXZYNW0wb3Z5T1ptWDd1VkJMM1BHUzFyd2l2RlVP?=
 =?utf-8?B?Rms5Yng1TUVveHVJMkhZSXFMejVyWXl5aFl4WWd4TitWZzZtN0N2dmd6N29C?=
 =?utf-8?B?bXVHVDRSTCtiQk5JanpPaWhmQ3FBSndzWWdPRGlOa2x1WlpHd2xJT0JpNDZ3?=
 =?utf-8?B?SXI5V2JtYms5UkJ0RVpocDFIL2tIRDNEcWp5R2R4QjNoMWtoWHgwZHpPR1h6?=
 =?utf-8?B?OTAzODVsUkVlbDh6OUJwMUMyNWUzTGM3dXllV29RZlZRczN0VTlFWVE3V2c1?=
 =?utf-8?B?YlFPYnl5UDBkTEpTd2F1QnVRRjNBWDViUWdUa0hsQ3Z0blB5bjdQdWU1MzM2?=
 =?utf-8?B?Uis1S2RCUnpWd3hZTnBnaE1zRHBINkFua3g0SHV4WjgzaDVXbGw4T3ZTWU53?=
 =?utf-8?B?YjFqU014ZzhoRHlZQTRJTjQ1QW9WQ2lhVC8vRGpLYTNPeGl4bHhOUXM1djg3?=
 =?utf-8?B?M2taM2REVFU5REc2akpVYTB1WlJKS1Z2allTMmN4b2xUTk4yWGUydzdnODdK?=
 =?utf-8?B?RVVUS2ozLzMrNnQwanpvemhPQ2dXQ1AvSkxSQjVOWEVubUUxNVBPbzRFSDlx?=
 =?utf-8?B?M2tvL0RTYllabG53NzhWdnRaTWNrVURoOWV1emRvbkdLQnpqNVRGdGxyZGxJ?=
 =?utf-8?B?RHlWaHlGNUFHVTRiZmZKdGI5NG1raVljR05SVWVRaXF4WmhjeDNFNWozbVlU?=
 =?utf-8?B?NDVHUFJPVWUvY3BqOUNJamdHOGVpRFltWmJFcDd0ajlvTW9yOGlWakF5eTJW?=
 =?utf-8?B?UlJDN2djWG9YMU8wRzJ1OXVJT1lHNjExOGFpNzhnSzZDTWROdkxWMnRWN3BH?=
 =?utf-8?Q?Pc6qqLjCDGqDNEMZHCblkxN4fexq7PUq8UTEWSBYG0wh?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a846dca4-e81c-47c5-4cea-08dacde54ec8
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB9009.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 06:29:58.3831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6RRJ1N7BFotvFTSUktsAm2RnJVhGw29/f1VpIXQojMnshe4QuDK5j7VPgz7Qq3oosBmHUIHgPAPXA5L7OCAV2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8561
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/23/2022 10:00, Marcelo Ricardo Leitner wrote:
> On Wed, Nov 23, 2022 at 05:44:06PM +0800, Firo Yang wrote:
> > Recently, a customer reported that from their container whose
> > net namespace is different to the host's init_net, they can't set
> > the container's net.sctp.rto_max to any value smaller than
> > init_net.sctp.rto_min.
> > 
> > For instance,
> > Host:
> > sudo sysctl net.sctp.rto_min
> > net.sctp.rto_min = 1000
> > 
> > Container:
> > echo 100 > /mnt/proc-net/sctp/rto_min
> > echo 400 > /mnt/proc-net/sctp/rto_max
> > echo: write error: Invalid argument
> > 
> > This is caused by the check made from this'commit 4f3fdf3bc59c
> > ("sctp: add check rto_min and rto_max in sysctl")'
> > When validating the input value, it's always referring the boundary
> > value set for the init_net namespace.
> > 
> > Having container's rto_max smaller than host's init_net.sctp.rto_min
> > does make sense. Considering that the rto between two containers on the
> > same host is very likely smaller than it for two hosts.
> 
> Makes sense. And also, here, it is not using the init_net as
> boundaries for the values themselves. I mean, rto_min in init_net
> won't be the minimum allowed for rto_min in other netns. Ditto for
> rto_max.
> 
> More below.
> 
> > 
> > So to fix this problem, just referring the boundary value from the net
> > namespace where the new input value came from shold be enough.
> > 
> > Signed-off-by: Firo Yang <firo.yang@suse.com>
> > ---
> >  net/sctp/sysctl.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> > index b46a416787ec..e167df4dc60b 100644
> > --- a/net/sctp/sysctl.c
> > +++ b/net/sctp/sysctl.c
> > @@ -429,6 +429,9 @@ static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
> >  	else
> >  		tbl.data = &net->sctp.rto_min;
> >  
> > +	if (net != &init_net)
> > +		max = net->sctp.rto_max;
> 
> This also affects other sysctls:
> 
> $ grep -e procname -e extra sysctl.c | grep -B1 extra.*init_net
>                 .extra1         = SYSCTL_ONE,
>                 .extra2         = &init_net.sctp.rto_max
>                 .procname       = "rto_max",
>                 .extra1         = &init_net.sctp.rto_min,
> --
>                 .extra1         = SYSCTL_ZERO,
>                 .extra2         = &init_net.sctp.ps_retrans,
>                 .procname       = "ps_retrans",
>                 .extra1         = &init_net.sctp.pf_retrans,
> 
> And apparently, SCTP is the only one doing such dynamic limits. At
> least in networking.
> 
> While the issue you reported is fixable this way, for ps/pf_retrans,
> it is not, as it is using proc_dointvec_minmax() and it will simply
> consume those values (with no netns translation).
> 
> So what about patching sctp_sysctl_net_register() instead, to update
> these pointers during netns creation? Right after where it update the
> 'data' one in there:
> 
>         for (i = 0; table[i].data; i++)
>                 table[i].data += (char *)(&net->sctp) - (char *)&init_net.sctp;

Thanks Marcelo. It's better. So you mean something like the following?

--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -586,6 +586,11 @@ int sctp_sysctl_net_register(struct net *net)
        for (i = 0; table[i].data; i++)
                table[i].data += (char *)(&net->sctp) - (char *)&init_net.sctp;
 
+#define SCTP_RTO_MIN_IDX 1
+#define SCTP_RTO_MAX_IDX 2
+       table[SCTP_RTO_MIN_IDX].extra2 = &net->sctp.rto_max;
+       table[SCTP_RTO_MAX_IDX].extra1 = &net->sctp.rto_min;
+
        net->sctp.sysctl_header = register_net_sysctl(net, "net/sctp", table);
        if (net->sctp.sysctl_header == NULL) {
                kfree(table);


> 
> Thanks,
> Marcelo
> 
> > +
> >  	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
> >  	if (write && ret == 0) {
> >  		if (new_value > max || new_value < min)
> > @@ -457,6 +460,9 @@ static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
> >  	else
> >  		tbl.data = &net->sctp.rto_max;
> >  
> > +	if (net != &init_net)
> > +		min = net->sctp.rto_min;
> > +
> >  	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
> >  	if (write && ret == 0) {
> >  		if (new_value > max || new_value < min)
> > -- 
> > 2.26.2
> > 
