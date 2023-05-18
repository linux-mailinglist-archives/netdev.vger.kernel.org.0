Return-Path: <netdev+bounces-3710-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DE6770865D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:05:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A2AC281197
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E6124E8F;
	Thu, 18 May 2023 17:05:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5321523C90
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 17:05:21 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2106.outbound.protection.outlook.com [40.107.244.106])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F07A199
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:05:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=loGCHF7/eGaiAnHOeCO4YhXG4VAUsza09gucRWu3W8gZaGJigx/E7IOGFGzAiRxbJUk+rXptUr85HvkHBLp77w3opUhtxAFrIhhaNtIEFBSxAbZ998+ZJXtY87GUqkEXuBp/xuizyy9sL3z9ColZz7FfpH8gVrKsSFm5mgjMCoialMhgevHMKL9PyCb/WPrFGnMaqfgYarpgyJR1ZRjOADlVYUDHaCSKjslYyoQ7543rtsxeFc+WYG0BHLj8kR63zCz6upyi+wcNlK/FCawPbO6/ibbpq+9GuMj+oA8EJOvTUNeSEYRb7qnjSqj0wW1HEpX7o3Ll27IFJL0h/qE8Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMBRcJTEwvSeCzLv7+SJ8l9OBjeJVQCpI75n77ZrDDQ=;
 b=D78zEuBH7d/aI7f7Bi8c6ZYaB/5VFgYPF/CuiV8UMOXQXa+fygC0q/y4WqC8Peq/eN8kNuVo0CtjO4n7UGy/hPng+6vEeNpNSX4JrltZHZLicup0cxFfBV5WoNlJeTuHnlwqmmgn5V+JioIlqZV37KgobeiRp8w98PV48ogwwdfX3oj0fHoZJ64AvwrO7FDuwHQvvQcoAb8o7/Eu54MelyR/7LDR6906py5leadTsdcavDqdIu56F87f9xcSYuNOOP+uWGyJ8y1oy7btCcodU3aAVSkwCmxRQKQJC/sSRn+dPGSJ3ebuycM4iF0L/uAoCZMqeMHHBkP2qZomv/KwKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMBRcJTEwvSeCzLv7+SJ8l9OBjeJVQCpI75n77ZrDDQ=;
 b=W2dFLprAaARTka+eWBlbeIXXYPOs9fblEvQYVJcgR9G+zs8SYV7mA5EIlbwT+V5BbD5Z+vA/6def0hUbr17R0lX/l92W3cNyFsO8oB+7Vv1k063Vj6YNFbDSOp+C6BnLBCSI9yLOWzM/WQ6fABUhqTwe7V7udCHZv7syWo10kLY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5721.namprd13.prod.outlook.com (2603:10b6:a03:408::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Thu, 18 May
 2023 17:05:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 17:05:16 +0000
Date: Thu, 18 May 2023 19:05:00 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	David Lebrun <david.lebrun@uclouvain.be>, netdev@vger.kernel.org,
	eric.dumazet@gmail.com
Subject: Re: [PATCH net 1/3] ipv6: exthdrs: fix potential use-after-free in
 ipv6_rpl_srh_rcv()
Message-ID: <ZGZavH7hxiq/pkF8@corigine.com>
References: <20230517213118.3389898-1-edumazet@google.com>
 <20230517213118.3389898-2-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517213118.3389898-2-edumazet@google.com>
X-ClientProxiedBy: AM4PR0902CA0017.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5721:EE_
X-MS-Office365-Filtering-Correlation-Id: 64ae631a-012f-4b2b-ed88-08db57c20ce2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MHklQI1qyz6uss5WdJPwAkl1/pkafp0n0/70qFjBLTz8sxW2DtsojYoUhrvqFqM4+/ICxA7FNyGBdN8qXT3y21I/sdZpeQ0p3//2htAz4jO755jWgDbBpEg2LZn0kdzD3TQW+9uSMv+UvL8g/NSsikqNwMof5M/V4eY0J/l9j4GaSCy0jA1Vms3oZcS3tHAh3aU+UDvRb2GUf0stXhnZo5zQrJMiSA5Tk8vMq2AAGevr8WEwDJKNrUNurMLhKMsYIW8h974LJWdb4sKpGdYoPRCYjrnPx+z6sqq+a//B5vmo8RltlUek8jqAMNnQxTB/sLCyPTblikHNFdZfo4nPD6A5OEvRHNCa1w3n1pwmNVnhkZzacouFISPkRHWJaqFvLQGqHp36o1vi1LN3FpnfOj7Fsspc4gOd/MLLm2TQrj9M8LMyhcMbrgW3CaRr/KuLxdvdzpUl5Jk2s47MGUlAd1r+sIsTVyn0KaNDLfl3gbMBc3D44olV30kO3VkVsT+ZLbIdnURqA/tdba04jdrEjBdKxf6PZWJH9DHjT4Wh9ceUpiDVoIyxcaPvpOmsKv3mKPB4WsSqgdTofe/yZzBp0vFbDU/6k+gejJiFFNtxdPY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(376002)(366004)(346002)(136003)(451199021)(86362001)(66946007)(478600001)(4326008)(6486002)(66476007)(66556008)(54906003)(316002)(36756003)(186003)(6506007)(6916009)(83380400001)(8676002)(2906002)(2616005)(44832011)(6666004)(5660300002)(6512007)(41300700001)(8936002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cVs2PyDVboOom7F3pnPyBAgF8yy7N5FEbYfGSvL16hGpHlDgmxZnQaStHP+F?=
 =?us-ascii?Q?FBQ7Z+CYRlb7tgdWYaaQhYi5P8TxU2KyMONjf/R4usTFpkOktLeOis4FjWXb?=
 =?us-ascii?Q?XOlgrR6CQKXkcAB78BFIsvi9ZVojfheypKObLAHD5rHEhS90UX7F+K16SYwd?=
 =?us-ascii?Q?ACd+gVfJ947x8il2p8OjkTfxuDc1EOVLu0KUPKinCwRijO1HDjqHYed+wskW?=
 =?us-ascii?Q?I6psbYYrPiqH7+lsIp3IhvNHO6kkJVxiC1PBLm9wPUFghQm7rorU/LGMbZtL?=
 =?us-ascii?Q?FnZeoKD7KhEtHZYJvGvhpUPeg2DMQaaBhFp/aFe6m3godfr/9P5iD3Bc5Dv4?=
 =?us-ascii?Q?TRzUQicXE43JCEqxddmWDAwmQEM8yJfWSdZk6jwyVu2tuvTa5dNGA3u1j8k/?=
 =?us-ascii?Q?RzgTzief0pZZdMIL0O9qknMR+u76IMaJwghxfppuiWJnmKm+ot4msrChUAuu?=
 =?us-ascii?Q?ppA2p3xpidszZWXkstqfQq7KYaNNv9xeyhmth3NlpKp/Uvymq/aOGnFLfqhw?=
 =?us-ascii?Q?elZk4PS2je5uHdWkkhmWmkyLKfA9olCPUtnAgSxjlkzdWSnYMBiVMt2sJm4v?=
 =?us-ascii?Q?2f1fRNYEzpw7GjBWhi3dc6+GLsiCZD8kMCFtjH/n0wk6K9vaVFVygtxbKzt8?=
 =?us-ascii?Q?xCox/ibZLkU/0F/dqg2Dity0D4A563elm7A+jbGP89aVbMJxfAJ2X1mPbAUT?=
 =?us-ascii?Q?FW/1/Zz96ouSNjd2FgcraiJ5j0Cxt67f8znMNCxSK8RZeq9ekULKWYPzgcS+?=
 =?us-ascii?Q?VMh1U/3P2YAp6rrDuRxHM11KBs0EGiHilPqbbL1+OFPDLNJC/KpiJwVSYbD/?=
 =?us-ascii?Q?Lm4LDtjmIJO9I/TwtFDD2uOrq7uWp2spfrwRzPwStScOMdLuCpw4q5VgS9Zv?=
 =?us-ascii?Q?wuUV6czWgUrAzj+FW7psznqSjEew+mOmphzrvyRPJzranv3By08lDP0Lp/i0?=
 =?us-ascii?Q?VslCRgGsERGYTjmnbwXBv8lz0cgAfjxvqL/KYhda2q4xnM3ktLpAbm7ZLHhT?=
 =?us-ascii?Q?RtoivoxQf/ZvN9Li7by4cTx9vjW4A3xDGs404IL2ibvhLKm5FG1cc+D9TvAC?=
 =?us-ascii?Q?DjMFpI4ptZ4XaALhnnm6OFBmBKLS7vY/tZCPViaTuLakJpY+TCBjW2YW22ji?=
 =?us-ascii?Q?9s8sCrzDgW2QgzEnrThNL0KMfoUiKqZkK7SsNYLLhMecUhc3LPBV9Rn60Tt5?=
 =?us-ascii?Q?I1l0n7hKNpiyYAbtow10AVYetdn9ARax1gRhmOgTp5mfzOZIfT1uhzS23ZXq?=
 =?us-ascii?Q?yf01TFHiK2LocLFQbxdSgTahFUNB4m8MnIOzlQfsDX2p4vjXjl2PDM6YJHo8?=
 =?us-ascii?Q?pm9ScigTt1v6e4nsfQx8zzDhci3tDzzb5rXK6MPk6dQboHNLqofRjiQ6so3F?=
 =?us-ascii?Q?XUvi9uSFNMDwGcZXtkfFja2TNYkDMeAujx7lF2maPqlf45jC37Vccjy6iAPX?=
 =?us-ascii?Q?2zJN1N4cX7FTKydo9HziRt4qi3NzcHlJlAYDjv3IcbgLzahijOEYb5+MIUIP?=
 =?us-ascii?Q?nKoyDFozDEEWWMxiBXi5PFWU9tu92GyhWoPmLHO4zKd7BsPv70dpPuqNnxDC?=
 =?us-ascii?Q?hN50bQtQ+nwukHSa0CifxG3Z40KwmSugumD+a91bIkQAos0QT7BUhDl+p+je?=
 =?us-ascii?Q?2e1P3uFrPvbK000Nc5A9kEocK3BmK4Zl8kruDXH5+RzkY0b0KZdBcERhX1hA?=
 =?us-ascii?Q?gJI0mA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ae631a-012f-4b2b-ed88-08db57c20ce2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 17:05:15.8345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7KYXR2O7whV2Zsp/3n1cEXTZ9xiBBJCNuCwZhF7JPGY9oWlva+yebPkPq+KETb+pMK3p3QlOOmUWqsbcOQ1PKoxZpbTUt5jk8YUJQE/1Q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5721
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 09:31:16PM +0000, Eric Dumazet wrote:
> After calls to pskb_may_pull() we need to reload @hdr variable,
> because skb->head might have changed.
> 
> We need to move up first pskb_may_pull() call right after
> looped_back label.
> 
> Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Alexander Aring <alex.aring@gmail.com>
> Cc: David Lebrun <david.lebrun@uclouvain.be>
> ---
>  net/ipv6/exthdrs.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> index a8d961d3a477f6516f542025dfbcfc6f47407a70..b129e982205ee43cbf74f4900c3031827d962dc2 100644
> --- a/net/ipv6/exthdrs.c
> +++ b/net/ipv6/exthdrs.c
> @@ -511,6 +511,10 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
>  	}
>  
>  looped_back:
> +	if (!pskb_may_pull(skb, sizeof(*hdr))) {
> +		kfree_skb(skb);
> +		return -1;
> +	}
>  	hdr = (struct ipv6_rpl_sr_hdr *)skb_transport_header(skb);
>  
>  	if (hdr->segments_left == 0) {

Hi Eric,

Not far below this line there is a call to pskb_pull():

                if (hdr->nexthdr == NEXTHDR_IPV6) {
                        int offset = (hdr->hdrlen + 1) << 3;

                        skb_postpull_rcsum(skb, skb_network_header(skb),
                                           skb_network_header_len(skb));

                        if (!pskb_pull(skb, offset)) {
                                kfree_skb(skb);
                                return -1;
                        }
                        skb_postpull_rcsum(skb, skb_transport_header(skb),
                                           offset);

Should hdr be reloaded after the call to pskb_pull() too?

> @@ -544,12 +548,6 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
>  
>  		return 1;
>  	}
> -
> -	if (!pskb_may_pull(skb, sizeof(*hdr))) {
> -		kfree_skb(skb);
> -		return -1;
> -	}
> -
>  	n = (hdr->hdrlen << 3) - hdr->pad - (16 - hdr->cmpre);
>  	r = do_div(n, (16 - hdr->cmpri));
>  	/* checks if calculation was without remainder and n fits into
> @@ -592,6 +590,7 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
>  		kfree_skb(skb);
>  		return -1;
>  	}
> +	hdr = (struct ipv6_rpl_sr_hdr *)skb_transport_header(skb);
>  
>  	hdr->segments_left--;
>  	i = n - hdr->segments_left;
> -- 
> 2.40.1.606.ga4b1b128d6-goog
> 
> 

