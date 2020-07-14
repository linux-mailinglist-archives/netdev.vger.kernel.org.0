Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781B221EDBE
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 12:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGNKRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 06:17:39 -0400
Received: from mail-am6eur05on2053.outbound.protection.outlook.com ([40.107.22.53]:18912
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726788AbgGNKRi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 06:17:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hc/W14LI4xdu32Moi8DUR/SYdKfjomgkSm40n7FyTiMBs3oZAEWEq31uckrVmr2gXOkfFw+wLoF6i18sTkLRjwGHzptPasJOqrfBpg7FDXqX/d7z3iMJyZl8koe+YJKlkIohPsElgFPx2sw2CZk4z8kNfbTyJRGCE5jhCy3u0ePDpw+1N5odsQQAkhP201fZRoeE3lzOv+WfkUHVBE1fDEQTg7+ANvpThGX28PxrvEEl3odkR7JOAjcvv4pnha1HqmBl8qI32k98sOJGCfEIOe3wBooB4nj3b+IgPAgtwbEJpTIDL9ir91Fpx2adfz+/EfhlRgeYdZL5uyZJkY/ORg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQhV3fgVt5MX44jdYBr9MGgfOymqOOX5q3Bw5wgKVfQ=;
 b=HJYi6lhqn4oAYQq6L5CFLXKcVK+rtNHEvCM5uyNlKi+m69zYm9QeBY3TqnOKkDclX6D8ETvRGvQwJ0dGrNhPiNdmcnS+ri+fruf6gwr7TDRAeOyzx3iamZjuAIBzyEMqHDrTuwffLT5FyUkGcwP+ei4IMttovwb3J8/xTP3KCEP6tGZ3kgIfTbLB5u3FHvcJRczwt/t+jzdR5vo2owcSTZ51f6SoOLwo7u9taZvop7ZsTTWED4E02rvfzB6SWmKE7BZiURgfzq2yd7SQqql6CvuO5VO1eLLr9Vlk1xPdavdZ5028ssGPMEF6aahOVFHqH7cABU6W8GoLiQf3E0EWYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQhV3fgVt5MX44jdYBr9MGgfOymqOOX5q3Bw5wgKVfQ=;
 b=VZMDtJmss6pbcrnQwFOdf+DpQWtpafdv0KukzqXVMeOGfdnSk9ml01ld85Dgmt1xGMCfovzuttpAgRUQd4F/nhNWyozGSSLeC8+t63BbQ7mwnRK2GmP8nwmnZwU65e4YUB6dvM3+KftLqq0W57/v4n4gL55xlO7h7QPEMCE51ww=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM5PR0502MB3044.eurprd05.prod.outlook.com (2603:10a6:203:9f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Tue, 14 Jul
 2020 10:17:34 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2%7]) with mapi id 15.20.3174.026; Tue, 14 Jul 2020
 10:17:34 +0000
Subject: Re: [PATCH bpf-next v2 11/14] xsk: add shared umem support between
 devices
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
References: <1594390602-7635-1-git-send-email-magnus.karlsson@intel.com>
 <1594390602-7635-12-git-send-email-magnus.karlsson@intel.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <fc6e254c-5153-aa72-77d1-693e24b49848@mellanox.com>
Date:   Tue, 14 Jul 2020 13:17:30 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1594390602-7635-12-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0070.eurprd04.prod.outlook.com
 (2603:10a6:208:1::47) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.57.1.235] (159.224.90.213) by AM0PR04CA0070.eurprd04.prod.outlook.com (2603:10a6:208:1::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Tue, 14 Jul 2020 10:17:33 +0000
X-Originating-IP: [159.224.90.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 01183551-9da2-49f9-94f3-08d827df1fce
X-MS-TrafficTypeDiagnostic: AM5PR0502MB3044:
X-Microsoft-Antispam-PRVS: <AM5PR0502MB30446FF3E76052002B69C607D1610@AM5PR0502MB3044.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bf0tQxay8gFnoq/vX+WEGhp2ZbsESKA52sWbYpONQGxjzhbfvxhwv6jrFkONgDDU9aaPrrVCU29OaOWpWhS9BuJEYdYBM5Wbktbufjn83wFl5lXKzi1BEBhzkjK5c4b6ubdWARp2aNwpafiBogw4IERM8wk/d7FuU3+jEfQiNx2solUPQL7iljZpAbm0Kf/3jj3xhSBTBdMU0rMsrPncJ0uBOoQYKVK3synq9KXrNuAlVztEkB7HceAjhGw8BjL5gQ5OIE0nSTv/fVLuRPHeBh1jOZf3xhNrh2P+ITQRkTO6Ui3D5f0Q9UUXfUsi2zPUJwKXsSJuUNUfC8WygShlyLQpU31rT1FupxYYRdEjuOZ74g5ivP9/DXh5brgCvsy1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(478600001)(2906002)(83380400001)(8676002)(86362001)(31696002)(55236004)(16526019)(52116002)(26005)(6916009)(5660300002)(36756003)(186003)(53546011)(66946007)(956004)(16576012)(316002)(2616005)(7416002)(8936002)(66556008)(31686004)(66476007)(6486002)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LHS/oePBUUHEssxQ/3fD+QUqlSGzQv1agEyIcu2ZJZ4lmLC4PZzzMjtJCjBnMLAbj4l5hiVniA5Oc1Ka8qjWzylOoEePThXvuHvTy6hNfMTU6Mwx+gcYum3rajdTcNnZ7sRcjhkE12TDdRl1L1nseGJyD0yglJLSio0XmlkD+kUB5vH9ToQCFuJC0lCVvqPfbkd8WeBCSfcT99wBkE9aOKTo73oZ6dxmUJR3sM6DwLm8PzbaO+UBmw+fkL2mkTURdH0/OxZumRECPJpn2vcP83SIfg1OKptUfjgQhP4dZfJVk2uk/RN54wrF+sACfATznk5ZliuPdScekxsMD4S8FE/qI7xds8c6Gk/mD6RxDdHHVKwT0CGlKGzA8A3rGaLW3UULXj4ZyjZFJdpkfos7JqaZeuSbrZmdFn6DSPMhFUq3PVv/Y0KPEtnGAn4wIPQNN8wmnQN+3MHvgAGte7gkWYmHpGySE6Bn4+RwGQfXk4/gYUfDlsKGZEAYEk7vgn8J
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01183551-9da2-49f9-94f3-08d827df1fce
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 10:17:33.9466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k9Nq0S/QehEGV3NAO6UGoCske1XUTqOmu6qV+ob8Ej9hu0RiZxzUCg2moiJBGtGTqPkuAO6ENcM0YgHFVh7UNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0502MB3044
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-10 17:16, Magnus Karlsson wrote:
> Add support to share a umem between different devices. This mode
> can be invoked with the XDP_SHARED_UMEM bind flag. Previously,
> sharing was only supported within the same device. Note that when
> sharing a umem between devices, just as in the case of sharing a
> umem between queue ids, you need to create a fill ring and a
> completion ring and tie them to the socket (with two setsockopts,
> one for each ring) before you do the bind with the
> XDP_SHARED_UMEM flag. This so that the single-producer
> single-consumer semantics of the rings can be upheld.

I'm not sure if you saw my comment under v1 asking about performance. 
Could you share what performance numbers (packet rate) you see when 
doing forwarding with xsk_fwd? I'm interested in:

1. Forwarding between two queues of the same netdev.

2. Forwarding between two netdevs.

3. xdpsock -l as the baseline.

Thanks,
Max

> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   net/xdp/xsk.c | 11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 05fadd9..4bf47d3 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -695,14 +695,11 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   			sockfd_put(sock);
>   			goto out_unlock;
>   		}
> -		if (umem_xs->dev != dev) {
> -			err = -EINVAL;
> -			sockfd_put(sock);
> -			goto out_unlock;
> -		}
>   
> -		if (umem_xs->queue_id != qid) {
> -			/* Share the umem with another socket on another qid */
> +		if (umem_xs->queue_id != qid || umem_xs->dev != dev) {
> +			/* Share the umem with another socket on another qid
> +			 * and/or device.
> +			 */
>   			xs->pool = xp_create_and_assign_umem(xs,
>   							     umem_xs->umem);
>   			if (!xs->pool) {
> 

