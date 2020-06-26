Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4092420ABE5
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 07:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgFZFlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 01:41:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2102 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbgFZFlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 01:41:24 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05Q5YcRM023374;
        Thu, 25 Jun 2020 22:41:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=nhpRJo6y1oxwYMpONKwMh2Z6sHweTUMOZfKzzj8KB2Q=;
 b=g21meispwktOnZ7V053OZoOo12D1crGzxAl1lyoI7+98ZzlH77Ce9qS5Qac1UAwMXQ3M
 /t3M6KziJ2psEIU5B/T5CtZX//krG7NK0+ZGVjWK7/knq/4h6RGFtRXZU33kWm7qM25p
 bpku+Y9EfZbCNqG11UQFmA2JCYgtHcwVZjk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux1eus39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Jun 2020 22:41:22 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 22:41:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIQoPMlKsCIPLR1YgpU8Dil6cVRPOUYd/fUH3msTLCxk8lpv1pToSn1IFZfW7UINBeBaeC7IWDaQDjStrrXzvx4tb/OeigHltSjlmbXJXSgCrXEonjcBzvKcRqbZzW93EbJyd94k/q5+FeZD1ji3hHGyCxtNmmYylG+W8W3yW+TowzW/roRJ3x60hyhTQcGyNUIvEY2jnboe+TtrdxBxAnbj/HRLBAOLjNCB3v5VDzBVDYU99NV+cEgV0Qw9wzyyLmYmu4YHnMyDadMN2i8ux5k7bGDf+y70grnvjQwMhCCjG18PKc6/wj4KtJHsqYONDbqvpmjdqkJVHNvp4ERbOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhpRJo6y1oxwYMpONKwMh2Z6sHweTUMOZfKzzj8KB2Q=;
 b=Lx6U9ob31RiLAW4MgchsPDGkoqXkp3v1vHN1XvTCHst4pMDb+2cBX2xTdswCBsenAG9S2AP6RdAEG1GWuoWKx82SbToKm7X81u25ODeL1p9c8F5ix6Sx0YFjHk0CNp79Eh1u0KD8Q3FkxsXCwo+W4s+JEMGAfQ1m8Zxs7PlSFRtNqHBUJsl0UtQnUzytor3XAdP0PfXvBWsiQGIJHaNkKKj4GUZ5lB2LHwniMHVBGJnlezetQb6cgiFqEk7gGcDt7Yf8IPwTl6LK1H4jg0w733Rwel7dRXJAILuJ1CIaGGZdIG9Zh0jZlOkViqDbAnrWTh61PHa2B9fd3DE2zaGe/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhpRJo6y1oxwYMpONKwMh2Z6sHweTUMOZfKzzj8KB2Q=;
 b=fRT4pDocAz4mUeILbm6AXkUBZk9zxWPtNutve0fCBtcr5qo5t8ch38y6qi/KbgaX75VNC1F19YdjiMnrjDLJhBO72qC3gb1qTp9FZNG3ljQGjmzbv5z3fo4Qpl0VaC+x/D+56DSrEkDdevXyMFKPZIWOBHMYECvJp8DBbggg9o8=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
 by DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 05:41:07 +0000
Received: from DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc]) by DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc%5]) with mapi id 15.20.3131.021; Fri, 26 Jun 2020
 05:41:07 +0000
Date:   Thu, 25 Jun 2020 22:41:05 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 2/4] bpf, netns: Keep attached programs in
 bpf_prog_array
Message-ID: <20200626054105.rpz6py7jqc34vzyl@kafai-mbp.dhcp.thefacebook.com>
References: <20200625141357.910330-1-jakub@cloudflare.com>
 <20200625141357.910330-3-jakub@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625141357.910330-3-jakub@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::18) To DM6PR15MB3580.namprd15.prod.outlook.com
 (2603:10b6:5:1f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:7d5a) by BYAPR03CA0005.namprd03.prod.outlook.com (2603:10b6:a02:a8::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Fri, 26 Jun 2020 05:41:06 +0000
X-Originating-IP: [2620:10d:c090:400::5:7d5a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1072e61-4318-4fff-7b85-08d8199385de
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:
X-Microsoft-Antispam-PRVS: <DM6PR15MB23168FBF7D0424499C5D6D73D5930@DM6PR15MB2316.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5TSzwxRUIWGQx2PQoTXd+MDUM2i5cV97roSh4nnvbxAWs6JRh0hV/D6P/kodD12B+5kEM4ry5mQiAEKMWe+DRu1CwvC42QcEoWVBB2LBPMWr+lg2ooVj5E3AG+Um1X3jSp9cepSUxSjYthlRHMMb18UAYuAD5TNVb//MzsahY4SvXOorgYTiTN26H8VLOLTZn4q9dq5LPafJnt4RSjLlDYNLz7W91+LeS7AFbhm2pwV9H/NNvGUWsXQdPIwmttBgFydzyiT/AmljNdmnqQBYyIkvmsZXLv25WIipvIuIMCNtr5VOMK4L1vKOyFtxdQ0Vkq/QJT3C915ZBI57aL/lZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3580.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(346002)(39860400002)(136003)(396003)(316002)(8936002)(6916009)(2906002)(9686003)(1076003)(66946007)(7696005)(4326008)(52116002)(66556008)(8676002)(66476007)(83380400001)(86362001)(16526019)(6506007)(478600001)(55016002)(186003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Wsw3QJPQIu6h5Tv9Z7GheG/f0Q4yNjlgZH7iLpRx7DKPUou6Ys26e+aTo2Xs9NgGYZcY0YerkDjZWqt1tRV5VIKfLcCCk+c1ZP3R4IOrqX32xgRmILThdqyJOjIhuI0b5DtnFrCEkz9YjfNUwl3FC+tNz69aRkNyFhi4eQH1UsNuzrZLU+6uHFkm6g4Kxwru2zGz6aaK5pOqGF66dRbQdmxyFgqpeMd1EOGhoNkIm3vF+NU7lxUARUUsaOml2uv4SGDpjG8BRCo/RKfsf5fzicBMqB16gOvkQgKV58WGjVxdtnl9/REkCd9nh6vmtvk+98rYurtC4TuEUNybeF150Rjt8RnoZCqw5ucsIdDJQggnHwx1aANIdXFVZc2sthAalnQm5m7RTpNjUM+vn2uDTyhMar/n77B7rS7oRuWRm70rMXr+C2WbocsgmvFedWUKx+sOhyXPnYOWK4jzPQAz/YV6VJbDDvaJrdux6ibbpGeFHY2BExvrV2UH3k1SidoNpKuGpJlEjahjk10zqLkjeg==
X-MS-Exchange-CrossTenant-Network-Message-Id: e1072e61-4318-4fff-7b85-08d8199385de
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3580.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 05:41:07.6648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AZunjjoSoDgw1o44ETZA5mqdJVythLppKbdhacCv4LxCfv5nczIrMgylfdtQuvHP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2316
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_01:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 cotscore=-2147483648 spamscore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260040
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 04:13:55PM +0200, Jakub Sitnicki wrote:
> Prepare for having multi-prog attachments for new netns attach types by
> storing programs to run in a bpf_prog_array, which is well suited for
> iterating over programs and running them in sequence.
> 
> After this change bpf(PROG_QUERY) may block to allocate memory in
> bpf_prog_array_copy_to_user() for collected program IDs. This forces a
> change in how we protect access to the attached program in the query
> callback. Because bpf_prog_array_copy_to_user() can sleep, we switch from
> an RCU read lock to holding a mutex that serializes updaters.
> 
> Because we allow only one BPF flow_dissector program to be attached to
> netns at all times, the bpf_prog_array pointed by net->bpf.run_array is
> always either detached (null) or one element long.
> 
> No functional changes intended.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/net/netns/bpf.h    |   5 +-
>  kernel/bpf/net_namespace.c | 120 +++++++++++++++++++++++++------------
>  net/core/flow_dissector.c  |  19 +++---
>  3 files changed, 96 insertions(+), 48 deletions(-)
> 
> diff --git a/include/net/netns/bpf.h b/include/net/netns/bpf.h
> index a8dce2a380c8..a5015bda9979 100644
> --- a/include/net/netns/bpf.h
> +++ b/include/net/netns/bpf.h
> @@ -9,9 +9,12 @@
>  #include <linux/bpf-netns.h>
>  
>  struct bpf_prog;
> +struct bpf_prog_array;
>  
>  struct netns_bpf {
> -	struct bpf_prog __rcu *progs[MAX_NETNS_BPF_ATTACH_TYPE];
> +	/* Array of programs to run compiled from progs or links */
> +	struct bpf_prog_array __rcu *run_array[MAX_NETNS_BPF_ATTACH_TYPE];
> +	struct bpf_prog *progs[MAX_NETNS_BPF_ATTACH_TYPE];
>  	struct bpf_link *links[MAX_NETNS_BPF_ATTACH_TYPE];
With the new run_array, I think the "*progs[]" is not needed.
It seems the original "*progs[]" is only used to tell
if it is in the prog_attach mode or the newer link mode.
There is other ways to do that.

It is something to think about when there is more clarity on how
multi netns prog will look like in the next set.

Other lgtm,

Acked-by: Martin KaFai Lau <kafai@fb.com>

Please continue the other discussion.
