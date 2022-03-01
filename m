Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4E44C83FA
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 07:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiCAG0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 01:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbiCAG0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 01:26:36 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9D96FA0A;
        Mon, 28 Feb 2022 22:25:55 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21SMwTxN023040;
        Mon, 28 Feb 2022 22:25:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=nEk6V14mvdMtFTf22Z4ku52QJzk/MD0lBaH4QOspRJo=;
 b=l99cvejf5tv7W7KQ5woqNaYeRrG3puvbjPGQ1QQEFbM8eeelj3IUrbsBgjzLn7Bcq7vR
 Rd+BdjXZjCvSC2Y8e3IkPrkftCRJmYpx6KpeSYjX98nBHZt/LnuBPETNL2X16bpCEvKe
 ImWbzULW9EUKE2Su5Y05WL0nqtbIEgOu678= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3egx7a654t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Feb 2022 22:25:41 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 22:25:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRhXlApWrBU+QVriHBTIYdbgZaLc6kS6SgMNJOq0bNGtFxP/UEZGI/J/aO045De1Y4ptk18rJUoMX81TfZKDrRg8ZgMrBrWGyrPPHmwq/9szjo7ELiHHV7foslHvJCOMimmz4/mlmOP6qqe6D07zprN9S6kpRyix3LjIXNkLLwGmrNqFCSzL4D3+8Rq/rwTkreUpTkeWW9TmC29AvhMSFFwRA1tcydmRfgjzR1doJG5c39sJG/Ixj0VaTDIvB6P/uvjWG6FRXvm5ZnEwugWBlgpB/pLJFM7aL2Ks9WLw+jcEzxteAgMoexuJSQeMSRJN7cdHwOCqFx4wigS2ePPgKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nEk6V14mvdMtFTf22Z4ku52QJzk/MD0lBaH4QOspRJo=;
 b=HJJLQhVXE1gGdHSd4UNKVV+wG0qivRcV+sCUlv+n8HqHJM80NNz3Tw12r6stdUUWtKyvuItu+IxFkkCSGwFtEuzbyC6IWEd4GGPF0wXIk+i3dFg67HmKxwz6sy0gnCG/i51A7LF8D8fxv+nxt3T3feLBesOKQbpjsI4G6EucXA8l1PZoB0D8M5jYeNu/PA54kkRWzKKjpnWxPdqTN3CNXZvZ51N5G0ByBP7NbsWBpcmvBLnUDSsgez0mQ+fqz75IOqURnJzL0ybLxluJGNcVPF4wqoPuKzHGzTajE6lPnEMtsAUFa/SaufTMJMalEF7uMWXn+5Htw+gnXqaV1l6IHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM6PR15MB3227.namprd15.prod.outlook.com (2603:10b6:5:170::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Tue, 1 Mar
 2022 06:25:39 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%8]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 06:25:39 +0000
Date:   Mon, 28 Feb 2022 22:25:36 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        <kernel-team@cloudflare.com>, Ilya Leoshkevich <iii@linux.ibm.com>
Subject: Re: [PATCH bpf-next v2 2/3] selftests/bpf: Check dst_port only on
 the client socket
Message-ID: <20220301062536.zs6z6q56exu3hgvv@kafai-mbp.dhcp.thefacebook.com>
References: <20220227202757.519015-1-jakub@cloudflare.com>
 <20220227202757.519015-3-jakub@cloudflare.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220227202757.519015-3-jakub@cloudflare.com>
X-ClientProxiedBy: MW4PR03CA0128.namprd03.prod.outlook.com
 (2603:10b6:303:8c::13) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbb89805-ef7b-48dc-fb6c-08d9fb4c4e11
X-MS-TrafficTypeDiagnostic: DM6PR15MB3227:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB32272A0DFC205CD315578230D5029@DM6PR15MB3227.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mC5MhxTEJ8yEdXcLqMf3JVSsNrMPrJpQTSuSBPjTLjis0tq4ICPeffJm8som41bBptsjjJo6gvyRjzDuHAiFSwF03tb9ewUuxHZ4eJJaqIfdz7zTbNvKhJQBUGMksBT9PrqjbOi2/KjYs/BtM8jBeLa3uin+mnE4lf25/C1/y4Z1bksdjNQH35UEZD0W4/0HDxOZl2lS5wrMKh+KyY3xctFycpMyJp+wBVAncqeXXCTe7gEYHwF9NGQa/O/3JLX/+BV+DYvM7g7O8qMIoIy/iZJDMDJ7OsqoPrGZ5MN/msp5g+jWEUd6g9efyInwNc1+7BlxWuQvvaFo8simm/bXaIlC7JiHapagNg8r1rRA2PYipyTbwNJqYH2T7cj/1ynuulJpvnLUrpfHV/08o1hmTnApckXp0e8lK5zExGtXgXFABbtlAzoTiycc1iUQnGDKoPMIoSw25cUo/3d/OvYKdu5JuKMuTNhuHOZY91gdlHU/VLe/3M/xFF6RVXcbI3DkxJfYxXPI1uzkJsCmcEvCI/nrCHzcpA04vHdfLHqDGhl6B0S5MS8tJO94eGZyEf1fGWqV4RRfs4vHlSQU9D8G6GHtT0hbkPdGTJVAkiD365hzMjMjc4lEDt5T9tKYt7v0kp3eIj4T2Q0+oY48wnQm8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(83380400001)(66946007)(66556008)(86362001)(6486002)(6666004)(52116002)(6506007)(4326008)(508600001)(8676002)(8936002)(6916009)(6512007)(38100700002)(9686003)(316002)(5660300002)(186003)(2906002)(54906003)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ULbPfhTQAZ/dg53TPK96qVH2ZCcV32XU5+C5IimeCFlgWE5snIXB7pN9RUo8?=
 =?us-ascii?Q?ihtHKshms0n8mZZaV/eFj8Wvb03Pt8XV8Q7i5wqSk+2E9Fn+v7DP3v4APdpH?=
 =?us-ascii?Q?bEGCOR650jbaCUGFpGLRRWzAXPP10C/EEt1DobQatx9u6d3pgwcnrThDtG5n?=
 =?us-ascii?Q?3R6gpetO8vXK0OQx0xdzSixzecTsu0KThlvHu3LLR0M65fcNFhlsQO79rbh6?=
 =?us-ascii?Q?u0lJTrvb7q+1fW978UxidfoY52dzRemmB2cDH9DWreAEurqWDIHZkvU7jQ6k?=
 =?us-ascii?Q?wRU2X6Rq40pSctpfd3EhrTLGKpr8heJt/sG85jLQIe+MapAWkRsKZIGa9hcf?=
 =?us-ascii?Q?/nnoX1FbIxC5k0e2xcuLgW72sjYB7sIHVC7u2TOfAKx0cqhxSbdc1hySYsai?=
 =?us-ascii?Q?aYK53tm4+jP9yP++ZH9+pNYud1rA3UyKxV6XzTNWnUhORk4gTe+N7MIPokuu?=
 =?us-ascii?Q?+7Vt5coql6TOWZNKdaV49c+UFotcUuGyDMtlwJ6ZMWKZ2ze7d+fXQTRW4/fS?=
 =?us-ascii?Q?YEZTdR7cTPxIE0dkYhSNtBf781Br1k2SJdmIBvz95uhvCRz5kfKVvS1IfNhs?=
 =?us-ascii?Q?w3+I4jpmlLmsnukUSW4hyRMDDScCMaMckO2hOoIPTPG8U7E1Yo0EX6T1ZeHY?=
 =?us-ascii?Q?HC/OVI/yIkHKMEOFEABNpDB6eX54XbMNPucjhbMWM0KkfgoG4nqSS/0icmk2?=
 =?us-ascii?Q?lUn/6NSX/J+z+qu1y7kp/fymqTEzQGvhL4MDQyTtftd0RYSyBRTO648VIXHE?=
 =?us-ascii?Q?vnzd6jiP3JmXFg1EEaBATrlOS8qQgNBHM6ztVo2ZpsLslE9phlc9KXvs4QhZ?=
 =?us-ascii?Q?41AgDnskVZkcAZRxS+itOml1nAkuBrAtiCeRo/yzFY6tt4KPN8nJu2x2Zp5R?=
 =?us-ascii?Q?PhfS+1f7fTqbqzvokIk/szfJM+9L0aiBTpR9gEr7f+lVrKnyYnxOyh1qPz5E?=
 =?us-ascii?Q?seYl7tW7xOFiV+WL9EtBORLHZiXBgGJ9dsKYWZh8VO2IC7HPBTYtYCuE0M+0?=
 =?us-ascii?Q?UD9hhb4rsjL6siY6p6iiIYQAqIYC9TKxsyiwcirN0Yudow2yjJ41fRT4txck?=
 =?us-ascii?Q?lsOA9ofB0zBKQoKz7EF7IPYOAEzK6xPRL9fe0cZ7SBPeff1XfHcNJJA22MrN?=
 =?us-ascii?Q?9GDjXH5YYBV7CEqsFjCX1FS2sE9RkMTQNSM7D9P15+lYaayX1RL2EKrf1HgP?=
 =?us-ascii?Q?zQvjRVL/H4t1EvWhkJO2GIoZJQ2GbZDAAAwNOMytkJTA3h7L4Un+Yu9FQW1v?=
 =?us-ascii?Q?eJhP6yOiTeGAFF+P9DSJXQo6InEXpUN+y25eTOnAp+LznYsjEod6h3miqw7R?=
 =?us-ascii?Q?r2HV3m0IDmJAGyXSvtnOj3CpkqJwwhOeg1eDbGA7IRZjSLhen5hhErQmNc0A?=
 =?us-ascii?Q?9saGqjDspGLLcEI2+Qt+Qt0n4XRlxGYolWU+yPG7d6x3tQl66HEI1TXk6+fS?=
 =?us-ascii?Q?7yooQDj1A9EApv5+SC9ccGMU9zP1AR+McZlh5Ii6CRe8crMxFr0amKBkP62/?=
 =?us-ascii?Q?gBK6zR6tIYKoT4BvwCY4uym2q782NtBXOzLwK4ldIVTbGgz+L3OQSPOi8Xl8?=
 =?us-ascii?Q?Q1aJOTMxaDOZR16HHP0cmCeNVDfR4L8D/na6ONJK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb89805-ef7b-48dc-fb6c-08d9fb4c4e11
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 06:25:39.6907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IuE7rbbDBhZqWvU4TCZpJYbXz+8btKDhmjJ6V21u1Ekm8PHgJVKmSe1teLspZ3ZL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3227
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: rGD4ycr9mi2UDwdjTROTSTElv4s-cQpQ
X-Proofpoint-ORIG-GUID: rGD4ycr9mi2UDwdjTROTSTElv4s-cQpQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-28_10,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2203010028
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 27, 2022 at 09:27:56PM +0100, Jakub Sitnicki wrote:
> cgroup_skb/egress programs which sock_fields test installs process packets
> flying in both directions, from the client to the server, and in reverse
> direction.
> 
> Recently added dst_port check relies on the fact that destination
> port (remote peer port) of the socket which sends the packet is known ahead
> of time. This holds true only for the client socket, which connects to the
> known server port.
> 
> Filter out any traffic that is not bound to be egressing from the client
> socket in the test program for reading the dst_port.
> 
> Fixes: 8f50f16ff39d ("selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  .../testing/selftests/bpf/progs/test_sock_fields.c  | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields.c b/tools/testing/selftests/bpf/progs/test_sock_fields.c
> index 3e2e3ee51cc9..186fed1deaab 100644
> --- a/tools/testing/selftests/bpf/progs/test_sock_fields.c
> +++ b/tools/testing/selftests/bpf/progs/test_sock_fields.c
> @@ -42,6 +42,11 @@ struct {
>  	__type(value, struct bpf_spinlock_cnt);
>  } sk_pkt_out_cnt10 SEC(".maps");
>  
> +enum {
> +	TCP_SYN_SENT = 2,
> +	TCP_LISTEN = 10,
Thanks for the clean up.

A nit. directly use BPF_TCP_SYN_SENT and BPF_TCP_LISTEN.

Others lgtm.

Acked-by: Martin KaFai Lau <kafai@fb.com>
