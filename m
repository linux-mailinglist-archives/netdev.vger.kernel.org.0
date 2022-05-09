Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C57951F80C
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 11:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236743AbiEIJ1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 05:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiEIIzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:55:49 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2103.outbound.protection.outlook.com [40.107.20.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B524EDE4;
        Mon,  9 May 2022 01:51:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQooT5chXtOAzYfqFHaoUB70ZTkgcV2is9PhWachql6r1PVlTJu16S7LjUBuo8c3Z7xd8NW/sLaHCBRbieFzxEyzSySexM5q4Dj41dYQxeoXX3FWj/RLlrpERAa7bZYbg8r7paO3kdGiY4J72mgF1QgDvZBtq/f7LO7O5RBTgi6yZQRIJnN9tiHd8U2/LNlAufYMh5Kgow0y6xAiSfBMbwAisbqwEt3O31KgotL8geHbt21k083gMnjiH9+Lo5Wy8+o0slGddaDJqekbZTmRkWOu02DBGN36pgCcgbFj6uEoyWHAV93pwi/tBlICSlm7BBZ0WAVKWs0Cf9UjybPwSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2o5aRWvKddGMrhTtL0IJbHEeivDyPkW6nsORysaFxUw=;
 b=nMmf4SDk+AcMn4G0BmSfNwGH7967igjxQo9OlzRlT6hLWOx4eXXOB+NONI6WIX2s6KAk4FvIvNKX/6wIZfeBmCOUjQJCgxOwxpkCe/y1CP6NPDLhOa46bzBFzjyUv72YP3P4qkN5uBUGUQwFcGUkYqBI0WCe83K4+NsoiFX70l4nkfCtStXUMWnIYd8sHnNh2duRl1Beb+ndoLp4eSVGJdaX0+U48uk63svt4O89hTF9Ys7j+v+/5LkjMDionmjjxCzzYy/BM3usRBzLWpGe7WRqarhLAS5t1GZZfMxb1UuH5+gBp1yKnlmmTsdj9JuXKYbODU3Kjkkv+9831zlUNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2o5aRWvKddGMrhTtL0IJbHEeivDyPkW6nsORysaFxUw=;
 b=KfaEPcafd3fRApdtHx6gcpO4NU/VsOXHe6uyPi30toSKLokdkhmgFm4mwLPLMig7aRgJVbgMZ0cfu41uSW6NEz5HGrXZbx/H49TxD0UfeVmvQ92+LdoTaOd1WatXJIUJI3NhJezHDkdWDC5ESKfS/xPWIjPlc1gSx4LUD7+ZJ70=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by AS8PR05MB7910.eurprd05.prod.outlook.com (2603:10a6:20b:31d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 08:51:53 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::c4b9:8da4:3f97:a2c6]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::c4b9:8da4:3f97:a2c6%5]) with mapi id 15.20.5186.021; Mon, 9 May 2022
 08:51:53 +0000
Date:   Mon, 9 May 2022 10:51:49 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net] netfilter: nf_flow_table: fix teardown flow timeout
Message-ID: <20220509085149.ixdy3fbombutdpd7@SvensMacbookPro.hq.voleatech.com>
References: <20220509072916.18558-1-ozsh@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509072916.18558-1-ozsh@nvidia.com>
X-ClientProxiedBy: AM6P191CA0016.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8b::29) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ddf538c-5cac-4157-51bc-08da31992a1e
X-MS-TrafficTypeDiagnostic: AS8PR05MB7910:EE_
X-Microsoft-Antispam-PRVS: <AS8PR05MB7910AE221C1E29D4F4E08942EFC69@AS8PR05MB7910.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SMA/PoIiW81mh4d8m073410jK6NRNRxAQFDaIqSUe+oDLV1MyCd8tJyrOkjQsjjsGhPvYIg5AlZdIh24CjYkxAhGBrqP0viMVkQx/WjWDuKe1VarIs6P90gQ/YxP2hTK+McGgSpSz0JkcEfy0PXc0ihaM7akREfM+w1hIxtToDapar8U3cHxp/l2jIN7pSB/aokKILlGo+jM/9HANxB0oLp33tyqPQ9Bc3zc7lg2QWNnBFcNFFSzZgwzYG7k+umbnlpMzUOOoZPe/iYo/qAUbowVoOb3PE30bIKvrOmX5FOG9j95QkwcEjJQEmDn9B34JOgosDvSLP9jPhWB6jJ+fFKebLlJ3diRHr+4sUkRXDMQy0PCixZFxFSMFUhgdamwHfHHy/UqVtWqPY6ImqTpeTdkXP6PcaB8Gj7LLNqPqqOEo/TeKqHGnePwbApL4ix7Rv5swDmFpc2s/7g2SHD7MQOLEfM5a+vairVvGRjzvGWdJK+157YJHhqLKfDesw91zuSD9g5g7gFliiFPhPQVHd5A5Ck5l2mbB7ElYtoaierIKUUfSO4Ns36nitFp9HFe2eehRNotldma3gRPwsgvQ4mZK56aF7fnFSEI927P3XxwGYVCtxJFybi/VR+lMKfyV5VFdrxbwI0YuNrITwKY2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(376002)(396003)(39830400003)(366004)(136003)(346002)(508600001)(316002)(38100700002)(6486002)(8936002)(54906003)(6916009)(8676002)(4326008)(66946007)(86362001)(66476007)(83380400001)(6512007)(44832011)(26005)(6666004)(9686003)(6506007)(1076003)(186003)(2906002)(5660300002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p4QbAvD9P34gZba24bt1mw9WTLAJ1dKy2wHpI4YBlyINnVlE2vlctgBzkm56?=
 =?us-ascii?Q?BOF9MD3bkpQMBvVWK9T0MW/UGSnHveBXoDv/vccGyQmPB9w2cvj++jV/oSgk?=
 =?us-ascii?Q?0GZwejb5c8POkJBKkkpSXbEaHsvn7Zuv/pjVXOMo1STfWGnb7O9XtNmVdz1A?=
 =?us-ascii?Q?bIU0aHlD7EhhaMHc/obQnPofTZQR9/gmh77ux6PSdqowH5jp6Ov5SGzeGfZu?=
 =?us-ascii?Q?D2InNkMhWhqyu8dSzVzXxNAnGshJOpcT0BgOU4C5aJBHp/tUd+Z27TIFAF2m?=
 =?us-ascii?Q?x7bCortmEkryl1qpmwx3eBsYrnDpZs+KtScAfbyBuWIfuci05l4eaoKVkdxP?=
 =?us-ascii?Q?bwEws3eLxoFEGYXcRrNcfSar4PAtFmonbMI6HIAyXnA6TR8CQLj7iRVFUtlg?=
 =?us-ascii?Q?Asn+CJ2Zg5Ws0ILMKB7i3drFhps/Ba4sj5+ziCPJoZ0gJR4kX9G+KYTJ/rk6?=
 =?us-ascii?Q?+CT0pGO+ML7dW2edDVu89zEuQrwL629mmp+0UXJyKbdu5JDv6qiHYyOfQms5?=
 =?us-ascii?Q?X97UIMo866PDVDUTfKcwHArkceTwjPnQBznUII+fNVNCupkLGE3WtjQar4O9?=
 =?us-ascii?Q?5+btac+0453NZgdulJUeAglb29JD6vWdpc3LF9uh/YmdryXSF9ozZ3PYU5I7?=
 =?us-ascii?Q?DV6rG7zwYh6ri4gSlRfJ/QycAHJhtnvB9kuxIDGc8zv6MjeXo8m+QMAZ/L/m?=
 =?us-ascii?Q?Q89ufBrph5ghXLsylXXOFxt4CdIZiNYBCRPzZsoVYMZkFAajkeuJnXxRgdSq?=
 =?us-ascii?Q?ksZYCvwdmv4DSim+OytCm+0ma5A4P+ZrVb696LFkk2lt4IGB9lSBQh1BANLk?=
 =?us-ascii?Q?GVS9l/Ks+tWy9z275WEDY3NhxKb92+LtdBASell/qNCnBPR22xK18ud8+NuV?=
 =?us-ascii?Q?wKoyOfZ2OUTsqeCEslkqaHTuuRV8Dfy0bwfg/BJNiC/b14MHB+Y+Za/ej3mI?=
 =?us-ascii?Q?r7wxi9JsPXLL8HShYzbWo7rfPL99YsdDk4nuU3/8C5GvYacdokCl+/GUL2C6?=
 =?us-ascii?Q?d52YP8HtBPPAmxHoNQKpb6BamomwtVVPmF8xxR5s0YVDc6b5Ezi+4NJiV76X?=
 =?us-ascii?Q?aLoTYJAuw5X7sTijOUJBGs/2eYSsxmB6Uizj026fyIuTvIRvgnDlUw3Ho8lG?=
 =?us-ascii?Q?hnDNQ5dDIrruJI6NrVD5DeHHqgT/gus9KXapyobk6WEaGgGQOBXU1goUAVSl?=
 =?us-ascii?Q?R+XuUaZ8goGFo5zfjVA0ARrC3be36NdUoXe40YE/Crn6pAbTn7uzhyVBqFsX?=
 =?us-ascii?Q?VJesvlWS8bbNFcIYv0PAn8h9PtDawjrlLoKgxegVzBSmbLmQHX4KH8zw+adc?=
 =?us-ascii?Q?eygeNhRwX3AfbmHHZVxY428W6KPXx2L/i86IzQC7bmkc+73XbW4QlSzCuVY/?=
 =?us-ascii?Q?4ZFRZUCy/QJfJlO5TdxjZ0mKT9pEb48lC7eECb5pscPVSajFbGRbeW4jpklK?=
 =?us-ascii?Q?vI56UeO5sq+XjtLBs/Hl1LVnyKSt2tRnfpPDTLNZwsfWWK5UuM2qdJwd5JQo?=
 =?us-ascii?Q?drelx1WK/nLVCJIA0yHcKr9oQk7tTg56NJOokPmC217kS4W0yWjFnl7Tb5OX?=
 =?us-ascii?Q?FFRRZhjt/ySsniHXGqBMtQGru3yAVXElEi5surK7YnBhvjmfkX99u0xsPPGb?=
 =?us-ascii?Q?MzWZb2U5qQiXjj2pKeExtfwo9mnK7pvgVb+WtwquupFQb5pdsAF5abFvXmYE?=
 =?us-ascii?Q?Py7il2kGNru7cfAzrMbVso40Bx3i8njjRfyOio0LjOeUOfdH1zAXsheiWxXq?=
 =?us-ascii?Q?xPDxDpqCXzi5zfYkxOpVLyiNhTvtf3A=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ddf538c-5cac-4157-51bc-08da31992a1e
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 08:51:53.5389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nVYV8J8bjm8dNxQyRSpw5y1T6c2NXO9PyYKPGyfjGw+YS4XOdqBHf39dC2n/kCNvyTXe2dGtkKYGZZBEwq4h/roxKKuQ0d2FKtA7lfelM6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR05MB7910
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oz,

thank you, this patch fixes the race between ct gc and flowtable teardown.
There is another big problem though in the code currently and I will send a patch
in a minute.

The flowtable teardown code always forces the ct state back to established
and adds the established timeout to it even if it is in CLOSE or FIN WAIT
which ultimately leads to a huge number of dead states in established state.

I will CC you on the patch, where I also stumbled upon your issue.

Best
Sven

On Mon, May 09, 2022 at 10:29:16AM +0300, Oz Shlomo wrote:
> Connections leaving the established state (due to RST / FIN TCP packets)
> set the flow table teardown flag. The packet path continues to set lower
> timeout value as per the new TCP state but the offload flag remains set.
> Hence, the conntrack garbage collector may race to undo the timeout
> adjustment of the packet path, leaving the conntrack entry in place with
> the internal offload timeout (one day).
> 
> Return the connection's ownership to conntrack upon teardown by clearing
> the offload flag and fixing the established timeout value. The flow table
> GC thread will asynchonrnously free the flow table and hardware offload
> entries.
> 
> Fixes: 1e5b2471bcc4 ("netfilter: nf_flow_table: teardown flow timeout race")
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> ---
>  net/netfilter/nf_flow_table_core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 3db256da919b..ef080dbd4fd0 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -375,6 +375,9 @@ void flow_offload_teardown(struct flow_offload *flow)
>  	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
>  
>  	flow_offload_fixup_ct_state(flow->ct);
> +	flow_offload_fixup_ct_timeout(flow->ct);
> +
> +	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
>  }
>  EXPORT_SYMBOL_GPL(flow_offload_teardown);
>  
> -- 
> 1.8.3.1
> 
