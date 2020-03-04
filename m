Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F50179645
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 18:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387406AbgCDRGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 12:06:04 -0500
Received: from mail-eopbgr00057.outbound.protection.outlook.com ([40.107.0.57]:21486
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726561AbgCDRGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 12:06:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MywgYV2Pzb8JXkGqW2rLXJQd8ZQfGoRgD1SgI9oTaE9Oto+oIA/ZQ7tggArBAnybNuQEEYtxSNRtM6oEMPMY2SKSRe74qYLZQOdLexzvkr6raDnwoG19ueUv5j5cD45cVh6T+9q/7hb/ZvEN28eDQ7pP1TmeyYQW3IKjIPEYY/3kxA54svK6D/WIWFZrEFadwE2fF1/5o5lV8HCIfQG1S0EQHS5uTBfglKkCBwgVJinr4PJh7ZN19M4OlRityIXEwy/V3o2sjWABf+LIC5fRJFe4/h5AT1HIBSaRJhPdK2E6Mn1FNwF/aV+koqs2z5nC147qQfYxlcjM6Gpl8sEc7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akHtkCOQTJ5fdn2Ug4RXXGpMpqwbF9MNjyClpXcKnW0=;
 b=flDI3oDlsr4/kTnayQOJua9KXUqbxBFpWD1N0y8Q/22d0B+wizHSXZ/YeqE6hs4gCrL4XfDcOtIIN92Jtvn1GHq+AZqcIHeUUPkF0ArT9d9HIQ+NVNpKqzRKnFi8VEew4tMVeeqMN4mijcLmh5z8aaeX8SmVgYj+9WOioHqUNaApaumKsUY/tKd8g3BKB1iMF+6cb5XywNaOuP/vbPAb98JXDUpR5ui0BuwOHP3nkVv0NFZssYbCFm7mo95hTINmP5m75xQEc0a6FF8DXSs3jv3LxvbkykF9tMRYl0ljYk10hnf12DYwniTcl/i878i2+7QO0VAP/OjJs3LSd9UeZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akHtkCOQTJ5fdn2Ug4RXXGpMpqwbF9MNjyClpXcKnW0=;
 b=kNfco+8M9vR2Iov+Wo8Inz6fkhIn2w1p2yeohGnWhAydPGGXhFSdqp8LoOgNsQE6tCbOgiKO8j0Q7uWaw7ufxrNMLKVjS1hTejb7uSdpYKmItWuWoEOOGdHB3rtE9edlcMskqyhhPIASq0fpipF5RYJy7B6V6lii3O1BP3+T+fE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=borisp@mellanox.com; 
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (20.181.27.19) by
 AM7PR05MB6866.eurprd05.prod.outlook.com (20.181.26.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Wed, 4 Mar 2020 17:06:01 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::9025:8313:4e65:3a05]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::9025:8313:4e65:3a05%7]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 17:06:01 +0000
Subject: Re: [PATCH net-next v3 6/6] cxgb4/chcr: Add ipv6 support and
 statistics
To:     Rohit Maheshwari <rohitm@chelsio.com>, netdev@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, varun@chelsio.com, kuba@kernel.org
References: <20200229012426.30981-1-rohitm@chelsio.com>
 <20200229012426.30981-7-rohitm@chelsio.com>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <8164bb64-3446-02ab-2dc9-68e995047229@mellanox.com>
Date:   Wed, 4 Mar 2020 19:05:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200229012426.30981-7-rohitm@chelsio.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::27) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.14] (213.57.108.28) by FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Wed, 4 Mar 2020 17:06:00 +0000
X-Originating-IP: [213.57.108.28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3f00622f-d0d3-484f-e72f-08d7c05e509f
X-MS-TrafficTypeDiagnostic: AM7PR05MB6866:
X-Microsoft-Antispam-PRVS: <AM7PR05MB686669D3EA4775072525B77CB0E50@AM7PR05MB6866.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 0332AACBC3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(199004)(189003)(81166006)(2906002)(81156014)(8676002)(66946007)(31696002)(86362001)(4326008)(8936002)(478600001)(31686004)(66556008)(52116002)(66476007)(5660300002)(53546011)(16576012)(316002)(36756003)(26005)(6666004)(6486002)(186003)(16526019)(2616005)(956004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR05MB6866;H:AM7PR05MB7092.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0yLbx+2WFt80bReUuWR5NLyppHoGt7ZGCFIUWpkJwLVHj9xk3lzq6P3gsAe87oqmdZ9ATN3TmoaKuAKCdxrQvR1rfaOL7kI60VabOl/AOJIL8OJdK/p0eQPfId0P9//BnO1m0SxDgb971u2g4hc5Lym/Wefrt3XixAjq2DWlNF0gtw0VVpRYC53BSj8lWjYeXEmYocXuaIojzhoWItXUvFMKmBbQe+RNJ2NLvux2Ap28PENqmlcE05pViexNxQFIo8xJePmR9w6Y4oOpTeWiqWSYqhSovMjr2K4WWaVpSza2OJuxMschSoXjbe6lwZymXzSDxONM7/XSnoMAvLl9+kRQUhPY/2MI4ZsiUuD3rQxHETdfFeKOkMEGoruI3UD20lnUGm//i4mEK+Rjf16EpciuFjhvldu6d5gG/GPthpgAzkJGmkir2SqVGqI4VxFF
X-MS-Exchange-AntiSpam-MessageData: j7G/cgw4sMLr8L9q6usIB2yQypNSGSQjFL9tyaYx4ttrzqEgG2Wltn9nyUgyXgAd/3/Fww17cxN7qqxxi0uwdlI/LKIUcMM221CSDUfEMEnQExhTe7La9MOkim6F8dDYeBuzmehuejNOPWl5LSGqWg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f00622f-d0d3-484f-e72f-08d7c05e509f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2020 17:06:01.2013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t9LcFlBbx7cBr46QdzI6PxQFMYb/eaL9oKL1jX1LZtFzCWKlpBZNtgqid8+IiFLoPkpWzV1RnZ4ERHoxZ46Uhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6866
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/02/2020 3:24, Rohit Maheshwari wrote:
> Adding ipv6 support and ktls related statistics.
> 
> v1->v2:
> - aaded blank lines at 2 places.
> 
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> ---

...

> +	seq_puts(seq, "\nChelsio KTLS Crypto Accelerator Stats\n");
> +	seq_printf(seq, "KTLS connection opened:                  %10u\n",
> +		   atomic_read(&adap->chcr_stats.ktls_tx_connection_open));
> +	seq_printf(seq, "KTLS connection failed:                  %10u\n",
> +		   atomic_read(&adap->chcr_stats.ktls_tx_connection_fail));
> +	seq_printf(seq, "KTLS connection closed:                  %10u\n",
> +		   atomic_read(&adap->chcr_stats.ktls_tx_connection_close));
> +	seq_printf(seq, "KTLS Tx pkt received from stack:         %10u\n",
> +		   atomic_read(&adap->chcr_stats.ktls_tx_pkts_received));
> +	seq_printf(seq, "KTLS tx records send:                    %10u\n",
> +		   atomic_read(&adap->chcr_stats.ktls_tx_send_records));
> +	seq_printf(seq, "KTLS tx partial start of records:        %10u\n",
> +		   atomic_read(&adap->chcr_stats.ktls_tx_start_pkts));
> +	seq_printf(seq, "KTLS tx partial middle of records:       %10u\n",
> +		   atomic_read(&adap->chcr_stats.ktls_tx_middle_pkts));
> +	seq_printf(seq, "KTLS tx partial end of record:           %10u\n",
> +		   atomic_read(&adap->chcr_stats.ktls_tx_end_pkts));
> +	seq_printf(seq, "KTLS tx complete records:                %10u\n",
> +		   atomic_read(&adap->chcr_stats.ktls_tx_complete_pkts));
> +	seq_printf(seq, "KTLS tx trim pkts :                      %10u\n",
> +		   atomic_read(&adap->chcr_stats.ktls_tx_trimmed_pkts));
> +	seq_printf(seq, "KTLS tx retransmit packets:              %10u\n",
> +		   atomic_read(&adap->chcr_stats.ktls_tx_retransmit_pkts));
> +#endif

Please confirm to TLS offload documentation or update it if you think it
is necessary.
