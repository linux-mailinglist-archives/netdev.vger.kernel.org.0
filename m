Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387FF17967E
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 18:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbgCDRPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 12:15:38 -0500
Received: from mail-db8eur05on2076.outbound.protection.outlook.com ([40.107.20.76]:41048
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727023AbgCDRPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 12:15:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmDVJPIwHntLCfHyJyJiOi5DKNHX4iQkvpnV1z/NOW/j164bRWSulKSxaCtardKpe9oXHEGU/kuPyScr+loejS/Rmw4TljUd43Vu5I+fw0J5kMXSJNV+inWY9fFjR0Z40ySTxDgc6on+HRFcjEitWFwjuFcZl/KBb9DNmqgEKYw+Bqbm5W4SJL2LIpefwjkjaebKl+5CaidszJ5yHOjOjvr5JEO1+sxoLlDaK3X3ajhOqnM2RUNtCaMJthtc/2k8/L20Bj6q1TGgct7ZLA1ec2JPvVe1m9ZqdhBFVIU/0ev+lxzzXTZN6SFWTi3XLk5SE+wJl/iZmOa4tkAT/bufCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwLZDO/aXExuAgZskPPZeVvaxOY5Bv1DCgYA7+8LWyg=;
 b=Ymu43+EP40vu21CHoQOUOY50y6jgnyvLd44hPk65TKedkytIOnmQdX6D4jcoS9t6afEus7YS50K9TXNyudC6sEBqfv1oGupHDi2vmZLIh9w5Ny6eCf6Ul8AzDVMRy3Pfw2AHoN1iXEhcNdRM5Y/qS94k1ig4Ke3XmzOtd+bfsMtiQ6n5Z/DnUTRWmiv9Gfe6fZzxTAHNP8ViQIYJpk7hO8ocDLGf6YL7NBQlgmp8MGpSZuJTCzGQwXS3cbWIgGXq6cL1OWJAPStvOPCalUjiEjIDojt7xXJGCSUOjEnsE+tyoWq7Yic0Tth3Gi3iwqxQz0uRz6sShGiSOEWKuw+82Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwLZDO/aXExuAgZskPPZeVvaxOY5Bv1DCgYA7+8LWyg=;
 b=pByIBX5crxaVz8oyG5m+dr0gnOxi3By4Sw0H8QX4N7+Ug5cRRbqGFTq0OgO73NHa73b648K1Dix6xNRkr6Kn2NMNvmxWm0aDtDX2n/Fp+49+rN3TFkpl0sgWs7xRQXOv7z7KzoT+CFxy92rePEu9gPM3qnYTeBYn3fRe8lUPWC0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=borisp@mellanox.com; 
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (20.181.27.19) by
 AM7PR05MB6727.eurprd05.prod.outlook.com (10.186.168.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Wed, 4 Mar 2020 17:15:30 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::9025:8313:4e65:3a05]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::9025:8313:4e65:3a05%7]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 17:15:30 +0000
Subject: Re: [PATCH net-next v3 1/6] cxgb4/chcr : Register to tls add and del
 callback
To:     rohit maheshwari <rohitm@chelsio.com>, netdev@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, varun@chelsio.com, kuba@kernel.org
References: <20200229012426.30981-1-rohitm@chelsio.com>
 <20200229012426.30981-2-rohitm@chelsio.com>
 <57eb8055-a4ad-1afd-b4f4-07bbeaa2b6f6@mellanox.com>
 <97ae4b0b-6ffb-9864-493b-159f581f7809@chelsio.com>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <49ddd44b-b3b7-7e2e-cc18-4158b51aa861@mellanox.com>
Date:   Wed, 4 Mar 2020 19:15:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <97ae4b0b-6ffb-9864-493b-159f581f7809@chelsio.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZRAP278CA0007.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::17) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.14] (213.57.108.28) by ZRAP278CA0007.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11 via Frontend Transport; Wed, 4 Mar 2020 17:15:29 +0000
X-Originating-IP: [213.57.108.28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2a1652a5-6356-479f-24a5-08d7c05fa406
X-MS-TrafficTypeDiagnostic: AM7PR05MB6727:
X-Microsoft-Antispam-PRVS: <AM7PR05MB67274735C1279325837FCCC9B0E50@AM7PR05MB6727.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0332AACBC3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(189003)(199004)(2616005)(66476007)(6666004)(66556008)(8936002)(8676002)(81156014)(81166006)(36756003)(66946007)(956004)(26005)(16526019)(86362001)(186003)(31696002)(316002)(16576012)(5660300002)(53546011)(4326008)(478600001)(52116002)(6486002)(31686004)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR05MB6727;H:AM7PR05MB7092.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ghSKQQbMDJkd1rg3YAtmUVPANkorrkjPoRORv48bJBHQdJdNxrUrQqIBT4RJW1ZxmmxOS+9oc+hl0tu8+CiFrDKQT82M7/JSPh6CQd/vgqxoxt2TZX+wzkfEEgL5v4NlPWlq2FXiKngpztiSxI8z0eSCgGwYk3mzALh7r6GitdNO9FxWp/2vEFDQb25dGl/H1XinZYmB/Okt/SI/jq5+nr60HD5SB8lCe3hCLOLqniGXnRQD6fqXsekDtq0R2sGT/OuK3cCODFodN5eLB2G7Q/yZs9EFuRJI746upiJUp7bTw6zxpMraSv0cntMm3jtLdabw0otyZ7bZO6LR5Qfjf9qdhGNTahfiJR0FNdUIfSXRvZavvdwor2c8ARZ/lkbX5xIsf5G97wBf2cHciqoSLMHYqlNAfi2ggoMe/kIAZe/ueORUK0jm78THioXNQ72
X-MS-Exchange-AntiSpam-MessageData: cAoFgLP/KaGooz9FTRScJAX4clqEk4m3GtqbgMdZVwsmQRY2YRCXTup/RWECaRW9f1lXey/3wZN9lai4Hg68Tm4i6o/h5aqQaFB4k0QhRD4aR9JGC65SMybcAF6BdeuJYk4L0ugIVw2jkUW/cPQQmQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a1652a5-6356-479f-24a5-08d7c05fa406
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2020 17:15:30.4478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WoDkwqjTlwKRc9206ObtGFqfO8OVB8bd6L6WBM5WYmei9ksWpgzTXrPldo44YAHYU4c4mfbJsYOzr2d3gLVVSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6727
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/03/2020 17:49, rohit maheshwari wrote:
> Hi Boris,
> 
> On 01/03/20 2:06 PM, Boris Pismenny wrote:
>> Hi Rohit,
>>
>> On 2/29/2020 3:24 AM, Rohit Maheshwari wrote:
>>> A new macro is defined to enable ktls tx offload support on Chelsio
>>> T6 adapter. And if this macro is enabled, cxgb4 will send mailbox to
>>> enable or disable ktls settings on HW.
>>> In chcr, enabled tx offload flag in netdev and registered tls_dev_add
>>> and tls_dev_del.
>>>
>>> v1->v2:
>>> - mark tcb state to close in tls_dev_del.
>>> - u_ctx is now picked from adapter structure.
>>> - clear atid in case of failure.
>>> - corrected ULP_CRYPTO_KTLS_INLINE value.
>>>
>>> v2->v3:
>>> - add empty line after variable declaration.
>>> - local variable declaration in reverse christmas tree ordering.
>>>
>>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
>>> ---
>> ...
>>> +
>>> +/*
>>> + * chcr_ktls_dev_add:  call back for tls_dev_add.
>>> + * Create a tcb entry for TP. Also add l2t entry for the connection.
>>> And
>>> + * generate keys & save those keys locally.
>>> + * @netdev - net device.
>>> + * @tls_cts - tls context.
>>> + * @direction - TX/RX crypto direction
>>> + * return: SUCCESS/FAILURE.
>>> + */
>>> +static int chcr_ktls_dev_add(struct net_device *netdev, struct sock
>>> *sk,
>>> +                 enum tls_offload_ctx_dir direction,
>>> +                 struct tls_crypto_info *crypto_info,
>>> +                 u32 start_offload_tcp_sn)
>>> +{
>>> +    struct tls_context *tls_ctx = tls_get_ctx(sk);
>>> +    struct chcr_ktls_ofld_ctx_tx *tx_ctx;
>>> +    struct chcr_ktls_info *tx_info;
>>> +    struct dst_entry *dst;
>>> +    struct adapter *adap;
>>> +    struct port_info *pi;
>>> +    struct neighbour *n;
>>> +    u8 daaddr[16];
>>> +    int ret = -1;
>>> +
>>> +    tx_ctx = chcr_get_ktls_tx_context(tls_ctx);
>>> +
>>> +    pi = netdev_priv(netdev);
>>> +    adap = pi->adapter;
>>> +    if (direction == TLS_OFFLOAD_CTX_DIR_RX) {
>>> +        pr_err("not expecting for RX direction\n");
>>> +        ret = -EINVAL;
>>> +        goto out;
>>> +    }
>>> +    if (tx_ctx->chcr_info) {
>>> +        ret = -EINVAL;
>>> +        goto out;
>>> +    }
>>> +
>>> +    tx_info = kvzalloc(sizeof(*tx_info), GFP_KERNEL);
>>> +    if (!tx_info) {
>>> +        ret = -ENOMEM;
>>> +        goto out;
>>> +    }
>>> +
>>> +    spin_lock_init(&tx_info->lock);
>>> +
>>> +    /* clear connection state */
>>> +    spin_lock(&tx_info->lock);
>>> +    tx_info->connection_state = KTLS_CONN_CLOSED;
>>> +    spin_unlock(&tx_info->lock);
>>> +
>>> +    tx_info->sk = sk;
>>> +    /* initialize tid and atid to -1, 0 is a also a valid id. */
>>> +    tx_info->tid = -1;
>>> +    tx_info->atid = -1;
>>> +
>>> +    tx_info->adap = adap;
>>> +    tx_info->netdev = netdev;
>>> +    tx_info->tx_chan = pi->tx_chan;
>>> +    tx_info->smt_idx = pi->smt_idx;
>>> +    tx_info->port_id = pi->port_id;
>>> +
>>> +    tx_info->rx_qid = chcr_get_first_rx_qid(adap);
>>> +    if (unlikely(tx_info->rx_qid < 0))
>>> +        goto out2;
>>> +
>>> +    tx_info->prev_seq = start_offload_tcp_sn;
>>> +    tx_info->tcp_start_seq_number = start_offload_tcp_sn;
>>> +
>>> +    /* get peer ip */
>>> +    if (sk->sk_family == AF_INET ||
>>> +        (sk->sk_family == AF_INET6 && !sk->sk_ipv6only &&
>>> +         ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
>>> +        memcpy(daaddr, &sk->sk_daddr, 4);
>>> +    } else {
>>> +        goto out2;
>>> +    }
>>> +
>>> +    /* get the l2t index */
>>> +    dst = sk_dst_get(sk);
>>> +    if (!dst) {
>>> +        pr_err("DST entry not found\n");
>>> +        goto out2;
>>> +    }
>>> +    n = dst_neigh_lookup(dst, daaddr);
>>> +    if (!n || !n->dev) {
>>> +        pr_err("neighbour not found\n");
>>> +        dst_release(dst);
>>> +        goto out2;
>>> +    }
>>> +    tx_info->l2te  = cxgb4_l2t_get(adap->l2t, n, n->dev, 0);
>> I see that you make an effort to obtain the the L2 tunnel, but did you
>> test it? I would expect that offload would fail for such a connection
>> as the KTLS code would not find the lower device with the offload
>> capability..
>>
>> If this doesn't work, better remove it, until the stack supports such
>> functionality. Then, you wouldn't need to retrospectively obtain these
>> parameters. Instead, you could just implement the proper flow by
>> working with the L2 tunnel.
> This is not l2 tunnel related. This is L2 table index used by HW to decide,
> based on destination MAC, which physical port to be used to send a
> packet out.

Do you have a single netdev which represents two ports in some sort of bond?
Otherwise, why not just take the port from the netdev (e.g.
netdev-per-port).
Surely, there is no need to perform a neigh lookup to achieve this.

