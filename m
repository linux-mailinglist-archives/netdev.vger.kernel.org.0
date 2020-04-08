Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4001A28FD
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 21:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgDHTAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 15:00:10 -0400
Received: from mail-db8eur05on2083.outbound.protection.outlook.com ([40.107.20.83]:22186
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726730AbgDHTAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 15:00:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4ZVyRu2Bv6zMZhqrz1R3Wv4YfD9yQ7sjiYJBpkcWHy2CLRJ6Yg3rqYLcDH+15skSgSbj4eD0nGrWGl5qUOwAfJ1jX3VQGjGbPIAHlDJED1ZwRgn8DH9bpq9h3VbDqmw+CpALI/Ieh6+mnPf9+Nid7HtkLjcuyq7xcm0AA4TQznuISu5r0Cem0NbShqC1PxfLyTNIgfSyacyXhHKjjqG7rKHhvau42RElMNaYGBoRFM0LOlX9MYHEOTonQJrBnOe1mu1t6wboaPRPyv8JFKW5B5164OT8Vu4/zrUJ3ohM34Q0g2G8GRWToEYP5q6wjk4MPz+qW5S9KHIAWoh3sz87g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvlkjkvxb1birQXRTfdAjSLKrjju1OgEmfLKcFedhVE=;
 b=mQS3KWN+lpHmM145Bw6k/dIJiLVowvxDIyFK/ptkW4qxauhEt15I2hv0nAL8NRd7wYMdZZrK87AK/w7d5r5B1lcDDV7BT64BYiuWs0lJHL9PaCwYtFFRJ/El5359dDlHN4FQeuaFsFPezuM+UVOtHqLeVxMQuwA5OeiHP0Tnm64LR+9IHJH/o2h3fLFA5dFzIqvsSlZ4tj6lz3vLrdGPlYTN6hqOCIbSv4srE7+qxyu53Pqpl2PDiQYK3OneXs+FGv1tMUcdGbAPCO2s5cJ/ixdafyeCmWGzj619TkfGeKw06CvpcgVeoFniLD+BKBwYyFlI3eVhZbgPAOdx+q5KVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvlkjkvxb1birQXRTfdAjSLKrjju1OgEmfLKcFedhVE=;
 b=hGvWn9mt1VLy2Q4lXmJZViIs8Q6xbA7yvs5ynRjD+9L1NDB3Cq1l0NtQoottbQEjgSi5ceC1X28rZxqmoR1hwNwNCJpK27gktDfiJKo6Snhm3L2Y0HrgtyOBNAmid5Y6//aen83Bs/WteUdjyhlzf0ZsAWK0ClnKpBXnDoSWgcI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=borisp@mellanox.com; 
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (2603:10a6:20b:1ac::19)
 by AM7PR05MB6805.eurprd05.prod.outlook.com (2603:10a6:20b:131::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Wed, 8 Apr
 2020 19:00:05 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::9025:8313:4e65:3a05]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::9025:8313:4e65:3a05%7]) with mapi id 15.20.2835.030; Wed, 8 Apr 2020
 19:00:05 +0000
Subject: Re: [PATCH] net/tls: fix const assignment warning
To:     Arnd Bergmann <arnd@arndb.de>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Davide Caratti <dcaratti@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200408185452.279040-1-arnd@arndb.de>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <67e50644-c48e-12b7-4d12-b344f2024090@mellanox.com>
Date:   Wed, 8 Apr 2020 21:59:49 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <20200408185452.279040-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::34) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.15] (213.57.108.28) by AM0P190CA0024.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Wed, 8 Apr 2020 19:00:03 +0000
X-Originating-IP: [213.57.108.28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a6e73fbb-349b-4871-1a3b-08d7dbef0c9a
X-MS-TrafficTypeDiagnostic: AM7PR05MB6805:|AM7PR05MB6805:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB6805CEC02963CCC2CB31C195B0C00@AM7PR05MB6805.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:200;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB7092.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(346002)(39840400004)(136003)(366004)(54906003)(8936002)(316002)(16576012)(110136005)(7416002)(36756003)(6666004)(6486002)(2906002)(31696002)(86362001)(8676002)(66556008)(66476007)(66946007)(53546011)(81156014)(26005)(956004)(16526019)(81166007)(4326008)(52116002)(186003)(5660300002)(2616005)(478600001)(31686004);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YVdyO32GXQEXCd8y1dKVPaXO0ZnAl6stR1UK3JLo8ZkYl0RjaDm66U7bYUyBLkJzr9Ij3BIxGCLm88BZKVjvnJZbh/yHfEIKkUSn2d9XM52cAxpCSLMahBTKd9gEem1dlY0EKqOlzgQCURpVeiWU7ZHsgn6PvhwHnHD3QUPDk9arEXO1XyAZIhS7eOnCxYlA+GeAMHYspVFPAgOwaCwc7iPqzUTCZhOJ37ELWHjlxzVNyUNcI2GLJwH5txBQO7SC/OZUXIgBoaL2ca+Gzfzk7YYvIxLVLTvXshsLQAMEJnCpOk0yBl5CheIsBTw0aSzmT9BdfKaNgPGoK+kDlpZG1BBQwTOJZTrXaHmUR1Bi1hyUus/9vHW2j9F1tflVO7o8DHW/e5QrGKDn/eCS4i0dT/DK/cjQ5LvKl8345/Q0HqrXvRsNi6wWeo9bRjjUrUvI
X-MS-Exchange-AntiSpam-MessageData: RQxyGKtJTEFZKyfh5ZE6KtqAM7xZMIYSWvgtkETA7lJJP7rtLU+I6DcLLLUWci0Qfiw9qB5VqHcKJJldVzFE0SZ1SvEC8NSWy8KE6KIhkUO8PRFVYf1HvJEI+0SaT0D+QnsPl2eXXmpBH1U1OobMSQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6e73fbb-349b-4871-1a3b-08d7dbef0c9a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 19:00:05.2481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TRXRyRk4wYt/SgrBVhnklJmbBcveqrPv1qZX95SGwdgjJmL0LQ8NpZARbUQf7YqUMwe7j7t4J4otO9f+fs1FUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6805
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08/04/2020 21:54, Arnd Bergmann wrote:
> Building with some experimental patches, I came across a warning
> in the tls code:
> 
> include/linux/compiler.h:215:30: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>   215 |  *(volatile typeof(x) *)&(x) = (val);  \
>       |                              ^
> net/tls/tls_main.c:650:4: note: in expansion of macro 'smp_store_release'
>   650 |    smp_store_release(&saved_tcpv4_prot, prot);
> 
> This appears to be a legitimate warning about assigning a const pointer
> into the non-const 'saved_tcpv4_prot' global. Annotate both the ipv4 and
> ipv6 pointers 'const' to make the code internally consistent.
> 
> Fixes: 5bb4c45d466c ("net/tls: Read sk_prot once when building tls proto ops")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  net/tls/tls_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index 156efce50dbd..0e989005bdc2 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -56,9 +56,9 @@ enum {
>  	TLS_NUM_PROTS,
>  };
>  
> -static struct proto *saved_tcpv6_prot;
> +static const struct proto *saved_tcpv6_prot;
>  static DEFINE_MUTEX(tcpv6_prot_mutex);
> -static struct proto *saved_tcpv4_prot;
> +static const struct proto *saved_tcpv4_prot;
>  static DEFINE_MUTEX(tcpv4_prot_mutex);
>  static struct proto tls_prots[TLS_NUM_PROTS][TLS_NUM_CONFIG][TLS_NUM_CONFIG];
>  static struct proto_ops tls_sw_proto_ops;
> 

LGTM
