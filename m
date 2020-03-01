Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F93174C47
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 09:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgCAIgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 03:36:40 -0500
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:55878
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725861AbgCAIgk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 03:36:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ogs1ots+VuSo4RDd4aBAUWYQY61WDQBQHAeJa93EgjA+T9wzNOFwTuIU7d3PDbA5wQqZP/+bUfbHPlFIAxnWdKjmRICewaVnvr3w6gRs6jQcVwwdBzQbD7dGCVYaw/SmXjPwaki2GY7BM1NNtQ3IpNlM8HdwomxbW9jk88IVqNCtNvAoCvCLSKXQ9vITVce0n1V9kbAm9Cdi+mzi6t+sx7mt0on1ZPi5KwqBbHpZ9P3lCFmSaWwMHUvCoFNqldS4/+psU1q6kJDSco/hJ1OG/F/So63yHJD2DW396We6dy5himW0j1Pe0zdb6y3rQ9+nvtS7tkYMt92fMeWnSMBkig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I40Jiv7gLXSu0fe7LGw5/Kh1PgQdNXR4a0ERjPrUW0A=;
 b=UD+wtluVnDqG+hHe+HiMkPlSIhddgYPKLDzOFWt9VE644vzb3aBhBUGUrL1sp+3ngkvezpuDC6705JHj4U38dEEY8UuMsOWwZaMYyDA7nYg0/a3BWKwSWtrQwDdCn3Kk+zYnCg28HsobxgfPkZRJucEPKr+ExQqFCcX3jUg5MxQtRgu7AZKY0xds77ar2/6DI18YKgAYQx+cLM6Ig3WvHznsYgYuarxPbZjnXcG9w1b0UipraUC+AO9S2F/2tbf628WCPXrhI7t5nzTZJMjr2CQtP8gmBA987DIT/+Ae8kCBhTKtz8RKYSz7SEV26C6XQqhgFvSn4MpDR5WOG2Bdog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I40Jiv7gLXSu0fe7LGw5/Kh1PgQdNXR4a0ERjPrUW0A=;
 b=WQdCas8QWdndD4Nmq4NfZFS46mIUKbndUEXT/OVcu+RmaENAat+9Lfh1oYQR8IBmm/dR2LJH6XCQg+1f6kgI/Zvd9GtWSUtiyMQjK6ACPTEcBWBD29IYbbiuX/WgQ72OMr63LVQY/7JPTA1pZUqPAK0DqEUcg7CsgZGEhi5MinA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=borisp@mellanox.com; 
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (20.181.27.19) by
 AM7PR05MB6711.eurprd05.prod.outlook.com (10.186.168.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Sun, 1 Mar 2020 08:36:04 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::9025:8313:4e65:3a05]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::9025:8313:4e65:3a05%7]) with mapi id 15.20.2772.018; Sun, 1 Mar 2020
 08:36:04 +0000
Subject: Re: [PATCH net-next v3 1/6] cxgb4/chcr : Register to tls add and del
 callback
To:     Rohit Maheshwari <rohitm@chelsio.com>, netdev@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, varun@chelsio.com, kuba@kernel.org
References: <20200229012426.30981-1-rohitm@chelsio.com>
 <20200229012426.30981-2-rohitm@chelsio.com>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <57eb8055-a4ad-1afd-b4f4-07bbeaa2b6f6@mellanox.com>
Date:   Sun, 1 Mar 2020 10:36:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200229012426.30981-2-rohitm@chelsio.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FR2P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::14) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.80.4.9] (193.47.165.251) by FR2P281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Sun, 1 Mar 2020 08:36:03 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b6f0097d-74a3-458b-e39a-08d7bdbb943b
X-MS-TrafficTypeDiagnostic: AM7PR05MB6711:
X-Microsoft-Antispam-PRVS: <AM7PR05MB6711E4B062ED712104801E49B0E60@AM7PR05MB6711.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0329B15C8A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(39850400004)(396003)(366004)(189003)(199004)(8936002)(26005)(316002)(16576012)(53546011)(66946007)(52116002)(478600001)(81166006)(31686004)(4326008)(81156014)(36756003)(956004)(5660300002)(2616005)(8676002)(186003)(66476007)(16526019)(66556008)(86362001)(2906002)(6486002)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR05MB6711;H:AM7PR05MB7092.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MnZPid5AS21h8n2maThMpNXulaTioJ8VcC4vNqfxkTH3d0DOxEPpRY5mUdKQXcPIpK5BO1SuM7rsA65hmopmJrdh6cGhpAAwgFSUDQvILYtuPiWT9RhudexU3tnv1/GKFnhixGYiFGfa9E2Q8dVB9aHZk1BQhQ4mWrHFLTkrxXe13OMSm3ndvCnk/UaldTHhfHEsX4ybZhQQ1dBbH+qLaTbRzSYUBaB61gAMFCMH5b2WcQ5a5wTnsHbkUvAPmx9sRRQGvcjSw9BscBZhdrbB38EbMs09m1F3/ajYTdGc9psPlSF0DJDiC5HREUfsv9hVXFUXlO0euR0xAf4jY7cuqnALwh/1lA6ncT7MlQ5+K8tN+5HyXG8f/ZDpME8ep6dZVpV/gHAjDy1ZNT9c5uX8AZRc9177JqBzHxJQRiOZTAual/njGTyPT7bchUGqyQPo
X-MS-Exchange-AntiSpam-MessageData: AOxqOCWiULORtr8L+Q0X/neNvUl/ydteZXaSpvJQIWoRRxtbhvYKNWcB5PQr7M5DsB4mHXfxj+emWCCBruEGzeIghTNVwsWmPCcRzm2DTllDQ4lSqvSmzoK8vks/WiSPAe7I5Ebf0HiZvG+JeOiYlA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f0097d-74a3-458b-e39a-08d7bdbb943b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2020 08:36:04.6023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3irkOeR371zbERBowOcrwLNRImb0wrWirgR2+3Suj8W3w8fzdrem41nMfDSwEvyzQ7VC2Lh6aMwXXGMXsd7gOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6711
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rohit,

On 2/29/2020 3:24 AM, Rohit Maheshwari wrote:
> A new macro is defined to enable ktls tx offload support on Chelsio
> T6 adapter. And if this macro is enabled, cxgb4 will send mailbox to
> enable or disable ktls settings on HW.
> In chcr, enabled tx offload flag in netdev and registered tls_dev_add
> and tls_dev_del.
>
> v1->v2:
> - mark tcb state to close in tls_dev_del.
> - u_ctx is now picked from adapter structure.
> - clear atid in case of failure.
> - corrected ULP_CRYPTO_KTLS_INLINE value.
>
> v2->v3:
> - add empty line after variable declaration.
> - local variable declaration in reverse christmas tree ordering.
>
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> ---
...
> +
> +/*
> + * chcr_ktls_dev_add:  call back for tls_dev_add.
> + * Create a tcb entry for TP. Also add l2t entry for the connection. And
> + * generate keys & save those keys locally.
> + * @netdev - net device.
> + * @tls_cts - tls context.
> + * @direction - TX/RX crypto direction
> + * return: SUCCESS/FAILURE.
> + */
> +static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
> +			     enum tls_offload_ctx_dir direction,
> +			     struct tls_crypto_info *crypto_info,
> +			     u32 start_offload_tcp_sn)
> +{
> +	struct tls_context *tls_ctx = tls_get_ctx(sk);
> +	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
> +	struct chcr_ktls_info *tx_info;
> +	struct dst_entry *dst;
> +	struct adapter *adap;
> +	struct port_info *pi;
> +	struct neighbour *n;
> +	u8 daaddr[16];
> +	int ret = -1;
> +
> +	tx_ctx = chcr_get_ktls_tx_context(tls_ctx);
> +
> +	pi = netdev_priv(netdev);
> +	adap = pi->adapter;
> +	if (direction == TLS_OFFLOAD_CTX_DIR_RX) {
> +		pr_err("not expecting for RX direction\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	if (tx_ctx->chcr_info) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	tx_info = kvzalloc(sizeof(*tx_info), GFP_KERNEL);
> +	if (!tx_info) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	spin_lock_init(&tx_info->lock);
> +
> +	/* clear connection state */
> +	spin_lock(&tx_info->lock);
> +	tx_info->connection_state = KTLS_CONN_CLOSED;
> +	spin_unlock(&tx_info->lock);
> +
> +	tx_info->sk = sk;
> +	/* initialize tid and atid to -1, 0 is a also a valid id. */
> +	tx_info->tid = -1;
> +	tx_info->atid = -1;
> +
> +	tx_info->adap = adap;
> +	tx_info->netdev = netdev;
> +	tx_info->tx_chan = pi->tx_chan;
> +	tx_info->smt_idx = pi->smt_idx;
> +	tx_info->port_id = pi->port_id;
> +
> +	tx_info->rx_qid = chcr_get_first_rx_qid(adap);
> +	if (unlikely(tx_info->rx_qid < 0))
> +		goto out2;
> +
> +	tx_info->prev_seq = start_offload_tcp_sn;
> +	tx_info->tcp_start_seq_number = start_offload_tcp_sn;
> +
> +	/* get peer ip */
> +	if (sk->sk_family == AF_INET ||
> +	    (sk->sk_family == AF_INET6 && !sk->sk_ipv6only &&
> +	     ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
> +		memcpy(daaddr, &sk->sk_daddr, 4);
> +	} else {
> +		goto out2;
> +	}
> +
> +	/* get the l2t index */
> +	dst = sk_dst_get(sk);
> +	if (!dst) {
> +		pr_err("DST entry not found\n");
> +		goto out2;
> +	}
> +	n = dst_neigh_lookup(dst, daaddr);
> +	if (!n || !n->dev) {
> +		pr_err("neighbour not found\n");
> +		dst_release(dst);
> +		goto out2;
> +	}
> +	tx_info->l2te  = cxgb4_l2t_get(adap->l2t, n, n->dev, 0);

I see that you make an effort to obtain the the L2 tunnel, but did you test it? I would expect that offload would fail for such a connection as the KTLS code would not find the lower device with the offload capability..

If this doesn't work, better remove it, until the stack supports such functionality. Then, you wouldn't need to retrospectively obtain these parameters. Instead, you could just implement the proper flow by working with the L2 tunnel.

> +
> +	neigh_release(n);
> +	dst_release(dst);
> +
> +	if (!tx_info->l2te) {
> +		pr_err("l2t entry not found\n");
> +		goto out2;
> +	}
> +
> +	tx_ctx->chcr_info = tx_info;
> +
> +	/* create a filter and call cxgb4_l2t_send to send the packet out, which
> +	 * will take care of updating l2t entry in hw if not already done.
> +	 */
> +	ret = chcr_setup_connection(sk, tx_info);
> +	if (ret)
> +		goto out2;
> +
> +	return 0;
> +out2:
> +	kvfree(tx_info);
> +out:
> +	return ret;
> +}
> +
...
