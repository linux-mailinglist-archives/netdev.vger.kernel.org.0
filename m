Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DD22793C8
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgIYVyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:54:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23948 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726348AbgIYVyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:54:23 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08PLZLbo001618;
        Fri, 25 Sep 2020 14:54:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8dri0/oVpx9WUY+zq0NUlvgY4GmtGOsXCTD9jbFRUU0=;
 b=N+i6cIUdkkQza/1sTYZGIOOnCk9cC4XreX7+s5QXelRv/faVjLYm5rnyLRQ85PdCFR2y
 zFzxZEqBMrsdwx/3DDHMnmIKXVil2jGYpGS1Wd0cjdOLhkRN1Etns9Asgt6ATyQsbIdr
 xorJPKVNomagneRbZ3LfaE0PwLAfvTTmydc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33s8su4jmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Sep 2020 14:54:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 14:54:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZLY6MS/6NVCBAJlUWuoSq5cTK0e2GQzhu+pCFT/W0bqWw1O4hZpADemUimIwPkHbfp/F3radlgkSViF6zwgVd3gg7cHh4l1PLzfgnftC7D6FBqccPxDxf7SJrmYT1YnPQuvewuj+ZPXkcKE4sOsXtbOvSJkUpqUL40E5wTG1PI/YrWP8OIqJrRNi/He/Dtwc4V6rsWR7xIoa9HNO6mOf4nAUjPGQc0K7rXJXZWCKu+d5+mjOnemuhrm2PWOi5N8DrvgoSR1tydguDdZZY1cYzItsawjBiJcwbJn+QDkpyCmVoV+JuhACPogcuHSZX34ZM1WIiR7AC+wJKD/G5HJyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dri0/oVpx9WUY+zq0NUlvgY4GmtGOsXCTD9jbFRUU0=;
 b=KgnmaLpwHqUhkso6jkjCdWdguH3Emahq0O1fz7M+Zhodz4tJuiP+NYbcCAWNgZAmahDfvUq4JxJeI+873xfyMoL7H3Z7drx2Y3Tq2oi+x/HBst/gpB15740gi5Q+/dcE1/YT0Z5UVocc9KxhHqFQHJujq6Q0Ei3TjwFV6MmEvOx9GIswav4m4ouT50NaS5+IeN+8TLM+8i/xmvQybJ8fd3XY80+eBP7K361dl/rlQoJF9Srrt6IQGF094g9Y184TthIauaDccHEVKPEfYuJVnYk63yWUEI6YxSiV1EujLBN4VUU2lGV7eNrfk9n/bxNf+xF/g6tG0N71kyKlQo9ZXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dri0/oVpx9WUY+zq0NUlvgY4GmtGOsXCTD9jbFRUU0=;
 b=W8vPz0RDkN5vWbK0FZbD4mrMptUwSvnFb8x35K9vDumV1jobMBT9wr9viEeNTagbZdj00CD/zGUP59UOVhK4D32yBRLhsu47Md5vTl8ESPYJ0ja41WTkuyy7B6F0owzZWn+KpKUYIK1RNogdNQ2jw7PHl7WlgpbXmR8A9de7mZ8=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 25 Sep
 2020 21:54:06 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.027; Fri, 25 Sep 2020
 21:54:06 +0000
Date:   Fri, 25 Sep 2020 14:53:59 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@cloudflare.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] bpf: sockmap: enable map_update_elem from
 bpf_iter
Message-ID: <20200925215359.l5lbicqdyx44spoc@kafai-mbp>
References: <20200925095630.49207-1-lmb@cloudflare.com>
 <20200925095630.49207-2-lmb@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925095630.49207-2-lmb@cloudflare.com>
X-ClientProxiedBy: CO2PR18CA0060.namprd18.prod.outlook.com
 (2603:10b6:104:2::28) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:4e29) by CO2PR18CA0060.namprd18.prod.outlook.com (2603:10b6:104:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 21:54:04 +0000
X-Originating-IP: [2620:10d:c090:400::5:4e29]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae6acc7b-fa66-4ed4-cf3f-08d8619d85d2
X-MS-TrafficTypeDiagnostic: BY5PR15MB3571:
X-Microsoft-Antispam-PRVS: <BY5PR15MB3571E77D2D2731DFD2CF77CAD5360@BY5PR15MB3571.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZL4Lv2m9ERGOgr/WQm1AedflRUjf37f9TEi8Ecnv0db4ORxiFhK71ZSUBn6YSIbpEKNKXPKX1ZhmTtW2Lv1lq05+tz5nQaKN5G7boeEY0ChWo6qPSDYNcRihiGKZls0o70atMyJVgUTzEsG5UuxTXFiVAPi1/sV6xmfPIvqkVZfpPl4XNcNZOzDb8uqHeHNELalI490ov1tJv60NCrfWoKXppn75ddTEhRFD4boJ39slPUZx8HUEnW16UcejX633Kjlx2o+CfFgWhTsFo7x3YbVBgsW11WRPJkqHOI5usmZQAgbeEIyUSevfrmQc7LBDS0UT5hTAfRjhTndq/EvciRgQwbpss8oE9vnzkyU6CaOo58rN9jcLbj5xXYu4MclX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39860400002)(136003)(396003)(5660300002)(6666004)(4744005)(54906003)(8936002)(316002)(4326008)(55016002)(8676002)(33716001)(478600001)(9686003)(66946007)(66476007)(6916009)(52116002)(1076003)(7416002)(66556008)(16526019)(86362001)(2906002)(6496006)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: AohtMgheXRIjGVjanRsCzrq4Hf7+4sx/oKsFIU8ACjDWVGhDa6FUMpcJfRUyvSfjubWzUDW7I1IEs0InApSdJ3iGg0n2G7rt6yzMmlTbmkPu2th4hd+Hc3A6Afg0D4feiL4VnEV28EyATHB2PueC5KvBGXrN4UDC3//P6ANqzMnSaNIzHW2VZTgyoEmCk/Zm6ZfoXAdFDAVczINZacgK+cl0J63N/2nVGlFYCtsSu3yuseHGXHvltjE9fEaCMKDdFfHbEKycsou7AItkmS696lowczwj/U5lCM0hrQK4cd7agZuhb6DUbud27Hg4ORpfAv/Onc3GM55WRiPVltuscd1xvEH9L5PN19TxHEm47UTACBqtBj98v6WM65QsANP/cNWxU2yAToRcPmz5zffgMZXeB/pGWYHs2shXBpAyZt4/lLK9J4qPbxsvTJm0JAyeBTiNQSf7H2uzdDWAOnepTR74YyjZT1xM7VZBQcK5Xdxh6S30Th59qQ+kpv/06spJzZ8477lHtuz2SLaRtHAgVrRBI5d6tuFhDayHplZkAlYsVzbpRNv5C7SAkL5MrZAvAs1o31Gy7vaL40F/yv93R/PMiL9WCFQf+GRevByKMPl97NzvY9R0jcWR6OlGIyI1wZu1HsfruguheCwrejkGSaQjctenlfWKWE0aoM+Z1VQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: ae6acc7b-fa66-4ed4-cf3f-08d8619d85d2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 21:54:06.0167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sN/yRaNA1OWN8NrgPbamuv23a3peXeUxVUlliPDctN/AHciEl3YdZ7IlzZLtEetj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3571
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_19:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 suspectscore=1
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250158
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 10:56:27AM +0100, Lorenz Bauer wrote:
[ ... ]

> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index e1f05e3fa1d0..497e7df466d4 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -610,6 +610,9 @@ static int sock_map_update_elem(struct bpf_map *map, void *key,
>  	struct sock *sk = (struct sock *)value;
>  	int ret;
>  
> +	if (unlikely(!sk))
sk_fullsock(sk) test is also needed.

> +		return -EINVAL;

> +
>  	if (!sock_map_sk_is_suitable(sk))
sk->sk_type is used in sock_map_sk_is_suitable().
sk_type is not in sock_common.
