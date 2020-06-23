Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76C0205BD0
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733305AbgFWTeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:34:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45104 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733220AbgFWTeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 15:34:03 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05NJUXwZ032350;
        Tue, 23 Jun 2020 12:34:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=B4aq+wbb/u1qjD4EYqlP9lqIWKDpfQkClb5KLMxM2oQ=;
 b=dM9R6dCz3nzRelMNyqGSNnWeScTi7iAc8Nau5e+D1WEqXt9YSj96poc5+y73N11ilhNd
 9refiziV7GqSefsc8uggSxijy2h4yCLCSJksiseRqNhvoG6SjkPyh5Gf0up4aAB0rCdh
 CtIjoX8UznWZ6+I/yJoUQAiWekEf5t2mFWs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 31uk1y9qsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 12:34:01 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 12:33:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8+MvDMN/PYmcKXlgmy8+N1tO4woYCVsbxbah8GU4Yv/MLkH0tj4GLLA3Js+OvQu1VS3aGcXGdpa0XVj3XkoTzjjtxZHDv07XCYnISGU1pz+u9aHGIHxGUHMtw+OVdtTMTnrujZFHoCw+OONWUtpv0OwYvqKPlmXlaD1NbWge/Z9Z+5+Y08R/MCl7cV+Q3u/N07Z/mlC7sbpE/yhpO3TzCJZxraIXRHxZKfufaZ2yoaB32HwOmcMJ5lRfAnKK8IHfJNsdDI4HK8e0yu26W+eYFVkfqwdlrbybeXh2KePm/GXxP1utQPfhT1xczxJLTFD0LKUt745KO1lqY1iAN/xUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4aq+wbb/u1qjD4EYqlP9lqIWKDpfQkClb5KLMxM2oQ=;
 b=og3dZ9b2L+qhCA19hFXJfbdBgYUbuRZmM8SeUfLZYTzzXW38pqtmxgrxtxhzLL5/hAK2r9jpewOIngbE/VVmIr0c2d/cRKs7UgMCzbTr0DoXK3maTdSAJ05GXZ7jXaD9aTGQqq+mcKtGTO58s/LaKp1lA2xUblSo7gSB40geq7sOWAgQ3ps1GO32aYCnlftoFZh0Dmc595garMep//0odZS3VaYdSMns5u/nBwjHYfE8C5LE54ro54sDrpbERmpoxWFk296BZMAK+sCBFwCjDJCD5zEcgeah1HDVjeJqaYpNWzLnOw46G+3SL4ytktBDin7M1FV0j6lSqHp6Fx07rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4aq+wbb/u1qjD4EYqlP9lqIWKDpfQkClb5KLMxM2oQ=;
 b=cMSinV4H91QzGvSQOTHbCCd1OPurtjIWq2hSSHKxAuI6QwhoWT8/Dnv+Ewa1apYtYDeVM3OuD1q2FSijaCeUtEuUt80dgL+2gvSDPG3ZTdwUMtMPkztyNLiuvyThOhT7GarnCkDo/HySmJs5xz+mYriT/p4TeoD78JAbe4Wn65M=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
 by DM6PR15MB3738.namprd15.prod.outlook.com (2603:10b6:5:1fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 19:33:58 +0000
Received: from DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::88ab:3896:e702:55e4]) by DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::88ab:3896:e702:55e4%6]) with mapi id 15.20.3109.025; Tue, 23 Jun 2020
 19:33:58 +0000
Date:   Tue, 23 Jun 2020 12:33:52 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf, netns: Keep attached programs in
 bpf_prog_array
Message-ID: <20200623193352.4mdmfg4mfmgfeku4@kafai-mbp.dhcp.thefacebook.com>
References: <20200623103459.697774-1-jakub@cloudflare.com>
 <20200623103459.697774-3-jakub@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623103459.697774-3-jakub@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR06CA0035.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::48) To DM6PR15MB3580.namprd15.prod.outlook.com
 (2603:10b6:5:1f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a860) by BYAPR06CA0035.namprd06.prod.outlook.com (2603:10b6:a03:d4::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 19:33:58 +0000
X-Originating-IP: [2620:10d:c090:400::5:a860]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6163c518-c5c9-49db-64f5-08d817ac5ff4
X-MS-TrafficTypeDiagnostic: DM6PR15MB3738:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB37386C12A0955AD7F84DADE2D5940@DM6PR15MB3738.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BmHNWA/bqkmSDwPZlA9/JWGYSlEP92dWStyYu91hzyThtVHUG6xGucDqXytyycde3rTrXuuy7apPyYMg/1fpevnu3A86yQmuUN6a+wyCvNDuvTKVNkEBf3UXsfIT5PIv6iY8zjVtOwP5gkD8E3osmCgqvQLmu8stbQ9bJwljETCv/sLuKSED2QsvSw3EjjaWk53LUbxv+kcah8Y/9C2DI8KVV9gEKgd0GIWf55qWdPdNXXoQ/3YCoHjKcdnHkG193zHl0TVP8eOIi76zYBiODlcvkuEiTv09NbZzN5fZzfBWVKcCRsEbcMT/82GT6d//g7diz5b02YUYTxMxfBeRRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3580.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(39850400004)(346002)(376002)(136003)(66946007)(4744005)(5660300002)(478600001)(4326008)(6916009)(8936002)(86362001)(66556008)(66476007)(8676002)(6666004)(6506007)(83380400001)(7696005)(52116002)(2906002)(186003)(1076003)(316002)(16526019)(55016002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6dOrvQdL/LLE4ogNTCcLl9szg6GEw93KzHsZuYrd4+tZoEgxgajZDXzsG9lRGFiB2F95ofbWnLJCO7kjApL0EHxK63YJdDyBGu9EJ+M4jj3nWxUMDVQeOjQtrQan/BYQIbPBiQtGWnq8HtvohE5hVJVGCsHQ3nQb0I74s00kt/sG8+wNS3J/vv8hde6zi7eRkKbdbGEcqu4Ej+8cb9pL9LHOZ4VEdJnisjliiy+Fi8o2ircetDeIK3ltjhb5dJ/UDt+mtGsegRx7Cf5mTH9P96mGX1di1MTZ9GIyqtEbyb/w1IpXn2onLMuNSaD4DmNq1Yggyb1sJ9yjDy/ph8nm07p/fwxphhQh2s7G+sEVNhzd3fXQQ8aRbIh45Cr3zgqhQrrgqjPA3yOJP5PswoZyXU8Xq+xQsNlxi8gpvO8uZlnSh043W1DIfoV/6Z6LZM4g6NgegH+/er98U20HT5F3NCKXfe6hQpB1lMTaC9bXU3gh8qNAMPd6sE8JGzWNKa7WUM9P//Z+srQCLV4V+4ZBhA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6163c518-c5c9-49db-64f5-08d817ac5ff4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 19:33:58.7499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EpZw0YacIOgJPfKTWzVY/Yx/5IBM99krajopLK0JjfxwAbMl3f/m5KIU9GkSfaQr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3738
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_12:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 mlxlogscore=670 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230134
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 12:34:58PM +0200, Jakub Sitnicki wrote:

[ ... ]

> @@ -93,8 +108,16 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
>  		goto out_unlock;
>  	}
>  
> +	run_array = rcu_dereference_protected(net->bpf.run_array[type],
> +					      lockdep_is_held(&netns_bpf_mutex));
> +	if (run_array)
> +		ret = bpf_prog_array_replace_item(run_array, link->prog, new_prog);
> +	else
When will this happen?

> +		ret = -ENOENT;
> +	if (ret)
> +		goto out_unlock;
> +
>  	old_prog = xchg(&link->prog, new_prog);
> -	rcu_assign_pointer(net->bpf.progs[type], new_prog);
>  	bpf_prog_put(old_prog);
>  
>  out_unlock:
> @@ -142,14 +165,38 @@ static const struct bpf_link_ops bpf_netns_link_ops = {
>  	.show_fdinfo = bpf_netns_link_show_fdinfo,
>  };
