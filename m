Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5CC4B8B19
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbiBPOKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:10:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiBPOKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:10:51 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2064.outbound.protection.outlook.com [40.107.95.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FEF2A417A;
        Wed, 16 Feb 2022 06:10:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7gDYDzPLBkbLkJLSm0DoUQy+3sVoLe4p9CMl+S06aq2z7qkh3/HqXF40NOzTKVAhM3j6csmslSxzH+SmxU8vU37dhaSpjgyM+vAjqNurditlxAEycqJGJ3bWO4T3D1ZO5T0iTab0iJHIQVJ3cwrCoruX4W58i/iLQIQJ6GtdsYTd0/mgL9Zmj0yb1Sp1812H2p5gTYIH9iWyRBl53POauD306mzYxHLQF/JnNWGMeQUf2In72Ls+3XX/3IagPVSY3Wm55Ix5gHchbSwqhBw349UebOtBblhWdaELNukRSHJ551vv/gpzTd8e6b/1DFMlthI8bJ6O4dUcguGcXnQuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=haYBsUlkenmZRmgbEO8REa1PNe64l3WjMB0B0L8C9Nw=;
 b=gR18xh15vmj5Y03vGaMcg85fOZ+SJDxZbgNdrNlb3D4KbPZqslrE8s0EMTD2km5rs4R11J0u4uRbIA64+YDnFlomt7vKZHuUmIfgD8VGVDJBFyuYJyLeo+7ObBqTibMuscK1YZIBxPBe74d0FXjlEQliC0zlLIBnblUsjQkmpHc5PlpBk6Hfaiewye6rsFNsBJN4i0ysY9O11y9EV0KVux2uGD6J6c4ji2ABNBo0ugyUpFECtX3Ikl4WaCP2FSfKOaAvb+s04seR3tbZl+L1vW2NILwZ+L4gsFoeMWfa8tnOWtx/Wn6na8TYwfCJEcdPoxCy6gVN/nECfMGlme3tMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=haYBsUlkenmZRmgbEO8REa1PNe64l3WjMB0B0L8C9Nw=;
 b=s/Nhwy484z0+dFWd8eGHQFVP0+M5MFDXp2b/q4fwCQspxqMUw8PjBH7Rt8JxNg7eARTB/2on4cUesdMIolB0ah4LubfDclW+5qLVWZQJkpr8xlvtlbUAvCmMBqyFCCTb3Oo/CrsIW2qElHmnXmBfGSaJf2JyrSdb8Eaid+ZRws9j/ilYl86Eanpxx+MFuwAdJCIQYxG9B9LTWk8evZ1WkbSD29+Fw422uNLAuX+94f6akH9+fm379UvIwAL2/XaLu9KwiSYYjtiIya7PvEKr1Bq3RHCQOcfpDK/zRq3SydERDUkQ98b6xPTpGi9Z9KcuPNsxq3nEdquUJEShSYyL9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21)
 by BYAPR12MB2934.namprd12.prod.outlook.com (2603:10b6:a03:13b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Wed, 16 Feb
 2022 14:10:37 +0000
Received: from BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::fc78:7d1a:5b16:4b27]) by BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::fc78:7d1a:5b16:4b27%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 14:10:37 +0000
Message-ID: <7eed8111-42d7-63e1-d289-346a596fc933@nvidia.com>
Date:   Wed, 16 Feb 2022 16:10:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 01/14] netfilter: conntrack: mark UDP zero
 checksum as CHECKSUM_UNNECESSARY
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
References: <20220209133616.165104-1-pablo@netfilter.org>
 <20220209133616.165104-2-pablo@netfilter.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220209133616.165104-2-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P192CA0085.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:8d::26) To BY5PR12MB4227.namprd12.prod.outlook.com
 (2603:10b6:a03:206::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1487dc89-272f-413f-78d3-08d9f1561ac8
X-MS-TrafficTypeDiagnostic: BYAPR12MB2934:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB293427CAE3AEB73CD2F8B5DCC2359@BYAPR12MB2934.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9/WUP05rxdKlrA0V+esFTWLGFBX3xpCSJp0/EBsEoGxbFVWr042j2rv5FXJVMXCgWid671h2A0m54+/493lU5/0qp54JkSZ4twVRm34eOvbjUrQ0nhQsPjTFBHmnInim/LWlWzgQNhkKMvg64rWKRi3iIfOlyaSJrF/2WIP/Mw7RIv0mky4S1IGGjpKZQJuq67rTRg9f6OKxH70ZZk7v+ByJtorN588MHkiYVCk4f7eaVU6KTbyEQYy/TF6a6oVjLbOpOhifc5t9qfk0jBUcdA7ZH4CpT8qxmn+09vKiPSgWcGPWK+fjqIxxkw3IksMuFIIILiVHIUQZv4vWHeaL4LPych76oTXVc43rWB5s5T/fXEHvvS1ynYogurJPhq2DTuedY3KUytlhIGow1CjpcLalZP5b38IVycHl3hv4NJwGcfVdLkapsa3ZdX9h0dFvj2NVA7HM3C3mQVLX4gWJEs7e+8xeQ+cYTZlUouXiF/74Ag7GDl50jGp/nG7s8Rnij9D+tqysQK93dFhlMm6+yGYecHKVbjtcvEZH9fZMh70qTCKe4Js55mlr+1XDLfKAJRKkL3LHM+i4wQZsXBsQqMW5MgPYQvAMD++XWwJwRPCxRHaHaOSYWYMpYvzykWDx5JFl5cgFZqB9vdKTN+dgDBGjJw+ex6ORSMTEfRjzKYvF0pSzcFvXlBEiTOZDxRSdE7kg0nNA0u/7SGFwBM7UoWN4F6JIBj0kgNYN0t6zPtg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4227.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(31696002)(38100700002)(31686004)(6666004)(86362001)(6506007)(6512007)(8936002)(36756003)(186003)(508600001)(316002)(5660300002)(2906002)(83380400001)(26005)(53546011)(8676002)(4326008)(66946007)(6486002)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHFtTVVMdDRDckNVeTk0dW95UlJ6VTFWaTdFcnhyUHIyazk0R3ZEVnNLbi9z?=
 =?utf-8?B?Z3NXY0gxQXJ4aFp3aHBJaU9iUG96N1VCR3ZTUlh0QmxBeW5vWlRrQkVGZ0Rh?=
 =?utf-8?B?WjhFN0QxdjlJZTZqajVFSS9zeUdhOTNhT2J2VE92OVZjWVBLMXVTeDNXdTlp?=
 =?utf-8?B?YkswTE5vSUFBb0lneEU0b2xZWWt3R3dpZDh0dVZBRTA2bXBNYStEM1hQUkpo?=
 =?utf-8?B?SmNzaStKZFRYaXB3OVV1NS9HeXlHb1FyRlcrNURLZU5XY0JFUnB5V1RSQmJV?=
 =?utf-8?B?TGFDTjFjTlpZUzhRaXNwZlpuakVxWk5ROEpIQUxzSzg5SVBZbTEwdnlISzhz?=
 =?utf-8?B?cW5PMWRrczhhY2J3M2ZlRE1HbVdxVTQvYVNEQ0dsdXhPd01MVTU3bG1hUUpZ?=
 =?utf-8?B?ODBwZ0p3QnZTTC9jR2lQVnlOQlkxakhvbUxCR0g5bVNNZldVVzdGTDkycXhD?=
 =?utf-8?B?SFdoVlpKZlQ5WUpzZnJOMWJFU05zeGtnb2htOU1TTmlhQ2tweFpmVG1GWXli?=
 =?utf-8?B?b2g5YXhLK1k4T0xoekltOUk4aE1VU1ZkdUFNald6elJ1K3ROSC9qMUpnaVhF?=
 =?utf-8?B?OURDajZuZk9md1NaU2Y4MWNyYXRybS95cmt0SzFLaHpycXU0YTNVNFRmQ1Fp?=
 =?utf-8?B?ZWNwczdwcmxGY09CR29OcnV1akxnOW9IQ1Q4b2pKY0Q0KzBEU2NvcWhXWm11?=
 =?utf-8?B?L2FmR1l3c0FHK3g5elhmNTM3MXA0ZHBnREVqK2REc2h2N3U3OENhdWlKczJM?=
 =?utf-8?B?d3pNUlN2VkJaYXVIWjYrTFhVZkxtRm1JU05wdVh5QjJ5alVtTXRXMENXM2l1?=
 =?utf-8?B?WkNIM3ZOak13WmoxUjA1Tzc2MU5BZTdFRTVYU2k1clprcmxRalQ1M3Qrb0xF?=
 =?utf-8?B?OWhPNmNTVEVtOUdiQUN0MTZRMnpjQUMzbUNIVy9sU2krL2ZuTElGdVhlYWxN?=
 =?utf-8?B?NE84NHQvYkV3MEtGeXpxL2IvQ1c0MDVhamJYQ3JxZm5nZkRJZ1hlZWYrRUhE?=
 =?utf-8?B?Q01nRGY0MjdabWZkUUFGVVNIbGFEK05OU3JnVGZSVFdDTmRCcnJkVWhpOVdJ?=
 =?utf-8?B?dGo0aXRIMmloMW1NSHFJUGpjcStSRklrdW14OFIvd1ZXb3RzSnltdGY1NGV2?=
 =?utf-8?B?WWZRcHhsN1FlN3pEdC9RYkJGNkl5bDFzaFU4Y1VjMFhFU3EyRXBnSWh2OGdz?=
 =?utf-8?B?N2piQmZNMjZLYWF6bWdOeXlFcXRhaG9vZXlMUGxjMU9HZUVGZEh2eW5YbEpO?=
 =?utf-8?B?ZE5QQVNzM1p4MEZDWmt2MlpBTkZFS2FMN2Jac2ZhaUdVcGsvaXZnQnVaMEpO?=
 =?utf-8?B?NEhmVVhTMEpFc3VjS1o2U3M5aHlHTVNzYXVTTDZBSjFVWEprSVYwZ1NCd0hu?=
 =?utf-8?B?dy8zVlBzNnY1Y29TcE52b3BNWEs1dE5wY2ltb2I5R1d1cXVyVXljMlNWVnln?=
 =?utf-8?B?b2l0MWw4M2Rqd292YlROYTAzK005b0g3Uit4cjZvYmhrTjhkYjZLL1pXRG9W?=
 =?utf-8?B?aGNDb0tTc0tWVkI4eEZuaG13Y2VnMXhVb0d0QUM5cm9hYklyMkpBRHZvK2JK?=
 =?utf-8?B?MUo4alNrUFN0Z1VOQnJPRTd5NmNWdFJnSDlIaUtBZkNuajVRK2xRQ1QxRDlV?=
 =?utf-8?B?akxZOUNjbjMzQTBISGg3MlFyclcxVnhHYjdPUFc0VHhLOTZ5QmRrWnJmQ1F2?=
 =?utf-8?B?T2g3bzlnQ3F3U2s5MVhXcWs5Qldxd2JZWVJrNVMxR0wyREwxaitFcXp3ZEkr?=
 =?utf-8?B?RUZDcDZRNGFsOGlKVEp1TnFORERVcnRMRlp4dU8wb1F5TUtDTGE4amhsK0xD?=
 =?utf-8?B?d05rdUJkbjFZY2lBZHFHTWM2TDZDYVFUVFhhVUVxMmt5cmk2V0xZbWUxMWQv?=
 =?utf-8?B?Y2hVOER3eUVYQmJ2MTZxdHA4WkNsQ0pkQlJ2ajhwdmVvdUREakZRWDJFS0Ju?=
 =?utf-8?B?LzRNMkNVbCtmRnJWNG9TSmpqbUR0MzZ2dFo4QjRSNVNhQ3JMeERabUNCWFA1?=
 =?utf-8?B?d3FwL2QrcXYvbWMwbEhsa0lSbk0xbW1YVnBJQmovVFVLYXJQY09CWFZEOXJT?=
 =?utf-8?B?dWlERkJRZEZXOGVTNjhMblRjS01TQlRBdjcwUXhJS3BGUzRrVVo3K2RMc2E0?=
 =?utf-8?Q?TwXc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1487dc89-272f-413f-78d3-08d9f1561ac8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4227.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:10:37.2524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /gtZWLI7ZCJVR/2J6rLAirs+c/70hmK55VM61MOz6MJndfQ3pv4MeNxBUy+kB0JD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2934
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2022 15:36, Pablo Neira Ayuso wrote:
> From: Kevin Mitchell <kevmitch@arista.com>
>
> The udp_error function verifies the checksum of incoming UDP packets if
> one is set. This has the desirable side effect of setting skb->ip_summed
> to CHECKSUM_COMPLETE, signalling that this verification need not be
> repeated further up the stack.
>
> Conversely, when the UDP checksum is empty, which is perfectly legal (at least
> inside IPv4), udp_error previously left no trace that the checksum had been
> deemed acceptable.
>
> This was a problem in particular for nf_reject_ipv4, which verifies the
> checksum in nf_send_unreach() before sending ICMP_DEST_UNREACH. It makes
> no accommodation for zero UDP checksums unless they are already marked
> as CHECKSUM_UNNECESSARY.
>
> This commit ensures packets with empty UDP checksum are marked as
> CHECKSUM_UNNECESSARY, which is explicitly recommended in skbuff.h.
>
> Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
> Acked-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_conntrack_proto_udp.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
> index 3b516cffc779..12f793d8fe0c 100644
> --- a/net/netfilter/nf_conntrack_proto_udp.c
> +++ b/net/netfilter/nf_conntrack_proto_udp.c
> @@ -63,8 +63,10 @@ static bool udp_error(struct sk_buff *skb,
>  	}
>  
>  	/* Packet with no checksum */
> -	if (!hdr->check)
> +	if (!hdr->check) {
> +		skb->ip_summed = CHECKSUM_UNNECESSARY;
>  		return false;
> +	}
>  
>  	/* Checksum invalid? Ignore.
>  	 * We skip checking packets on the outgoing path

Hey,

I think this patch broke geneve tunnels, or possibly all udp tunnels?

A simple test that creates two geneve tunnels and runs tcp iperf fails
and results in checksum errors (TcpInCsumErrors).


Any idea how to solve that? Maybe 'skb->csum_level' needs some adjustments?

