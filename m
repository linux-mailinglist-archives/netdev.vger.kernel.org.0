Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3261C3ABD02
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhFQToS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:44:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25098 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231382AbhFQToQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 15:44:16 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HJa6Tj018544;
        Thu, 17 Jun 2021 12:42:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=IDbeUvGOfkexL09uPrhfhFsBMfViGA8HeynEtGJ4Qgo=;
 b=OKEKVTcrFesLTcSLr+LJ7PWwTogcWm9JCFz2v2208cBi5oHKYEP1YBH38le4buVIqxXS
 dU5v8/B/4gViegAE9w8FLRwiWvzDMJLRN/UjMVuQ3Zyf+eXeKnD/SQJr9dut1ZezA5yA
 pRZZ0mcDe/UkDQtU1X1kccH9oykDvZY0P4o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 397jq2j2vf-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Jun 2021 12:42:04 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 12:42:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVIUE+Mtl3kmHCyUAbL3FnToj3mJvpsoej+BhLMOnKOKvztVob3tnPxULnicdADME9zq/3/iBO6wwK5HRsTO1tPq0/WXdnk/F09VZak33ZdVlcUatWDIk0kLMC9w8DO5ynmq00lax4YLNls7SEXLCuqtxvhI0LfDHe8rIE7iOiza5WK/tNC82HyDql4Jtk2wmeMXrqKWV490wIIz3aG+mqSJYeunVtwmXzM8ydnYr2DEsMm13tbJmKbDKTXYN9bQ6jZIzeLNDiu2wCga43M35v9Px0O51j4Hthw9sPRofwJGerTvbBeZn4UVZRvpkXMOxoYH8KsP+Oamfqx1lKgvwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=up5rJeFhRiNoE4xd6467noVKOOTtwZhi8xZvB4/LHhg=;
 b=Wv7aZbMEw534xn7aWxdS9tVNNg22834QLO6Aj+SR4jqaOGcrFXCevZscvke9hBg+KCEFLhxPTDtHqoAhZs0WmApGNWDyiiH0GmVpBldecGTlSzPHp2IFOIY6Ke0jI9GVGc+I1K1wPHApSxTw+NansVZ4TprTMhum01kRz4VKv3ORyWvZMbG8R3aGDFd8GH0p8XacuTuwUqsCepMtSP1MJAs9EN7SA86mOaW/xIO/Xs1lNc0P8idyusKDpSymQo6y59mibG8ERyBMUgVVVvbFV0oaQCPGx6HgICgoMvWZVnu2oYtX53NZ3iOcfWUfkkog+nbcD8VeXckol7Q3Cn0MyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2239.namprd15.prod.outlook.com (2603:10b6:805:20::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 17 Jun
 2021 19:41:58 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6%7]) with mapi id 15.20.4219.026; Thu, 17 Jun 2021
 19:41:58 +0000
Date:   Thu, 17 Jun 2021 12:41:55 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next v2 03/16] xdp: add proper __rcu annotations to
 redirect map entries
Message-ID: <20210617194155.rkfyv2ixgshuknt6@kafai-mbp.dhcp.thefacebook.com>
References: <20210615145455.564037-1-toke@redhat.com>
 <20210615145455.564037-4-toke@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210615145455.564037-4-toke@redhat.com>
X-Originating-IP: [2620:10d:c090:400::5:8961]
X-ClientProxiedBy: MW2PR16CA0039.namprd16.prod.outlook.com
 (2603:10b6:907:1::16) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8961) by MW2PR16CA0039.namprd16.prod.outlook.com (2603:10b6:907:1::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Thu, 17 Jun 2021 19:41:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32df0a8f-3362-4700-2d4d-08d931c7f851
X-MS-TrafficTypeDiagnostic: SN6PR15MB2239:
X-Microsoft-Antispam-PRVS: <SN6PR15MB22392BB55F6E355ABC2D4019D50E9@SN6PR15MB2239.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7LHN0MqB3W19x0CmseXYbMx1qx9vdY0/A1UdAQ8QYhthoDAvYEYOhJUejC3cDywBn+KGK2QNgIFC8yRh0II0hQ+3MuoR81nPbqhospmOwfzobYBR+1HAPyuwqMwPnc8yRLaR9bifWu5hDdriGQnkd6jrzg067GHsjECXiHzm7V51YJwXaSJuaCUGnqb3qDfykBQ4/h6+J87yTx2TJMh9sFaAry5sCOu/HjRUslY4xuDTdCnc0E8V9BiVQssrBwzZoxn078L8d0pn0QGBwL23TwxniN0H1WznisWgDerYNSs3r8PESv6Az3oW+DKGQYmxpHybdLPD9ec0GX/JuGXQgxymPTr40lYTnpJh6lfapXghfdiwF/wLfPuu7gxaAfsKYH1vO72TDm9XsgHIOkX6qnEBsYzzYbP/iiNH744l4Yqmos9kmoKneMekgDMKi898GzO5CAARD4gSF4pp01bu7seNOFT5Tl9/5AMo1Yw3tvLWVUg7u97x54DNuSqpC1exIz9DQkppPWQoplyWTfhLuKzi3hX16KKgLvGEGkgkH3mYJh5jHZFAYDcMefa3TShyqFHkj1DlCtP/lu42TmbCt/IK2WQeEEt9ivActaZnkKI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(8936002)(16526019)(6916009)(5660300002)(1076003)(2906002)(316002)(52116002)(8676002)(4744005)(186003)(83380400001)(4326008)(7696005)(478600001)(6506007)(66556008)(66476007)(66946007)(38100700002)(9686003)(66574015)(86362001)(54906003)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?w4nSUaB7srtAKuitpCnQgZycH/GK/0wCAxBBkWXwD9ngTOD/ccSVmeJP9E?=
 =?iso-8859-1?Q?A/4T2P8gcEm2FeF6cs+d5AVeXkuzbl345HJg7fSBnD0e1DAIKrGOKP33FI?=
 =?iso-8859-1?Q?hWyaIxpHti8zIZVgOtb8iUzJt9krpE6HV1XdAVi4BCJUwpEw32BDvTvLEe?=
 =?iso-8859-1?Q?cBgorFP538hmKXZrvvKpdsZ3iugwq0oRQTUQWNEDbKxXATMGxgUhznkEYf?=
 =?iso-8859-1?Q?OmUBwOH0BcMxoDkPT+T7rJdDEcwBDGwBxxeGJup3qXNBDSEDJ6hESO8u2+?=
 =?iso-8859-1?Q?xaY3QWs+yzut19BiOxdOKwYBOFJu6FcG8uk/VCQZkdwreul7j9S2FuJhTz?=
 =?iso-8859-1?Q?ic7lPiFN8cBX4fzfaxENLe69y509q5gGvPtC/Yd/y2l+KnEL8vWiYjD2P5?=
 =?iso-8859-1?Q?q7svx474QJEBO7c+A9KtyHLgZBsa4ogBMhqT4MzPR8qUOkxlhll/mvzdog?=
 =?iso-8859-1?Q?5tRTi24MugQRZJJRJjm7QUrMy3pmuTcv60S6huwjTQMvrTRex+VgVKwYLx?=
 =?iso-8859-1?Q?AVvMie7R3UfYv2+5JKoKF2jetiKBjzXEB2MslZtSaQsaPa0QBIzp8vkFdi?=
 =?iso-8859-1?Q?u0Alx05qUPNavtJIfGhyQK1HahOW9xLxjviKn8ade5M71lhtJSDsryL9Lh?=
 =?iso-8859-1?Q?D6MKK9Gr/lmqCG1XNcC6uHLEOwG5QLzoihKkOkwr5ph3rct2EvUONH11LT?=
 =?iso-8859-1?Q?EYz/rQBs2F736oVwAavn02zIHRfa9WnlZCKtS+iTloINJnY6gpo8wcZwW6?=
 =?iso-8859-1?Q?uyTQTB8uB+dZpj29VsZ6jvUJqXl1VXK9AjXyFvKqp8EB4l7xcxJTrnm9to?=
 =?iso-8859-1?Q?dhz5+L8eOzdLEQ/+7e+fOfSq7iRz1fL6oIjAIQibGPJJNR3lCyZsCnVMWr?=
 =?iso-8859-1?Q?ALQrf1nGrCRDwXgneMXft0q4+KdQ/RLsISUu+dL8tNxx43TBxbKXVQKBlo?=
 =?iso-8859-1?Q?i59mwhypvX32Y4nSIe5VkmaJelIGIvlH4EsgfMYjoZ8uxd5m8Kd8epzGet?=
 =?iso-8859-1?Q?n3tv9GPCVY7eQf5koZr7KmpIhRMB0/h7+jiogkjnpyYBsAHHCvxf828o/8?=
 =?iso-8859-1?Q?+aBAQHy1JqL0ZmSQhfCnLhGmdbHbgVaVZnJz6zMV0eEFSexz5FOsvshKyM?=
 =?iso-8859-1?Q?SBvMiAT4b3fEanaVicS50/ToVZiQ5DNkHwfRJxBcII7Q+eDEnOaeCVbsz8?=
 =?iso-8859-1?Q?i3c0CVE/dhZM83hTCsGxgAM1gXX4YaQdauRORnUG8qLCdcGjj+gyFtwH9D?=
 =?iso-8859-1?Q?tdQqD9iJUplfStoE49XCWs3SXYAXuS4E89i41SXpEwcRPx6C5EOnM1G5F+?=
 =?iso-8859-1?Q?AIZKRhXBpVMdNCxxPWKUc/FlnWJ0B8c3M3Jo2ghw3ikjk1ReVMfp9GUIrt?=
 =?iso-8859-1?Q?sTXfHpeKGCBq9Fq8NK87Gem76/AzQdGA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 32df0a8f-3362-4700-2d4d-08d931c7f851
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 19:41:58.5650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ilN3qAZPtonqQNXCmGA5GGcrkBVhkH3yfwMkuTa8OhuGzXf+MX2NHlUs2NIvbl4w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2239
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: RbCqKtPksVcXVZT5nCARuM6yF7x8JjQq
X-Proofpoint-ORIG-GUID: RbCqKtPksVcXVZT5nCARuM6yF7x8JjQq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_15:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 mlxscore=0 mlxlogscore=749 clxscore=1015 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 04:54:42PM +0200, Toke Høiland-Jørgensen wrote:
[ ... ]

>  static void *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
>  {
>  	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> @@ -266,7 +270,8 @@ static void *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
>  	struct bpf_dtab_netdev *dev;
>  
>  	hlist_for_each_entry_rcu(dev, head, index_hlist,
> -				 lockdep_is_held(&dtab->index_lock))
> +				 (lockdep_is_held(&dtab->index_lock) ||
> +				  rcu_read_lock_bh_held()))
This change is not needed also.

Others lgtm.
