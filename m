Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B38221A368
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 17:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgGIPUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 11:20:18 -0400
Received: from mail-vi1eur05on2044.outbound.protection.outlook.com ([40.107.21.44]:18918
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728003AbgGIPUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 11:20:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTMS2m6OaZ7Sb1adT8gA3Va3/6SZooRA5lR6cGAsd6vt+evU2+W0XMjkpbhXq+1PeMagWKpoDNw4ctukLX6Yj8jUkypCpSqTgwysqWDQIGG2NNRhNZzrrKQd7NULUVERWSnKusCBBqPHe/VvqxQFG8VvWrD1k7BqnVNDlSFU0yd6eSKHxmjSIKDa4plndXET+LI5cstfr8Vy+2C+5KngFTU5YvVktJTq+9rX2Wozrlo8VVl/HtM1EGWbPENGDEvu0Wuxa3p/+v2zfNNDYxFc/C1OfLQwM5arMqGS5SYJ72K8kkUqSedQmu/zUsQHRBHkZWZReyZ4uaiQjVcD7Zf4Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgLtLMiMVUeVBCcsQUkT9HLgXOd5dMjC2kBX/OezW5o=;
 b=a0zKnuIsYO4ZLFkxpwkRIovF17eInBIEbIrawswT2biWMFUqlnFzeXEgPRi9PcXk7vmZlOASDEMiYDQ0PUd+qR4M/VWX+yVUQptjOFw44s9TuF1MLfJpWF9RXJT1KeqIs01hz4OLhfDHFKtiOYGVlf4z4gSSDV0C2xxo9cyF2tGbSyE0Stb/FfSNMAW+ESL20vG1JL6w9vYQCL4A9R03ocCnvYpol4Tqnq0fBRdeYM2N8AzetvtAoZ3CS5Dn4MS2yb1gUllsFmfgT3nSPcjoUiXNEK3vMoA6mqnSIPmLBp05adV5CKw4IQGr71OjJPOjkXBtCjwD+HyOzhw5GL0bqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgLtLMiMVUeVBCcsQUkT9HLgXOd5dMjC2kBX/OezW5o=;
 b=jmfE/ZYDRSA1KEm+T56TU2O22NYG/sLr/onUHqOnOqRqlfz+bu32IpCab0Jf8r9jgE0dXzpvwOB7KIT5mK6OYyDAn5RKUy0u8x5KG6D3HSdbLLEkFINz4h2H14wEWE5lxPwDlYtycCEWSgXLpB3J/qL+mOY+89JUjbtYtiYy3/A=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB5427.eurprd05.prod.outlook.com (2603:10a6:20b:5a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Thu, 9 Jul
 2020 15:20:14 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2%7]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 15:20:14 +0000
Subject: Re: [PATCH bpf-next 11/14] xsk: add shared umem support between
 devices
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
 <1593692353-15102-12-git-send-email-magnus.karlsson@intel.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <f6008a8d-92bd-85f5-1c84-8aa638bbacef@mellanox.com>
Date:   Thu, 9 Jul 2020 18:20:10 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1593692353-15102-12-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0022.eurprd04.prod.outlook.com
 (2603:10a6:208:122::35) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.44.1.235] (37.57.128.233) by AM0PR04CA0022.eurprd04.prod.outlook.com (2603:10a6:208:122::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Thu, 9 Jul 2020 15:20:12 +0000
X-Originating-IP: [37.57.128.233]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 18860298-35c0-408c-592e-08d8241b93d8
X-MS-TrafficTypeDiagnostic: AM6PR05MB5427:
X-Microsoft-Antispam-PRVS: <AM6PR05MB542795E47AA665534A9D243CD1640@AM6PR05MB5427.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ehqHxI+zejHYJGhtIxaKvNcXfY+tGLjYDTiBnPTJI5KYsr1Z9dYudAcjdYh1EfaV0p9EywMND4sn6HZWN0FXLSYw7UDTjg8w7JrBtgh1RS56ZwdWPB3FOvi0ctAW1ZXZdDCvILhcrWzYmhS2Jgrom98JuC5S+yBE/3O3YaGog2bmgPkAWrr39hGWuvvT6pmYsAv64ZuJMoUsQEGYbdJ1MXpDzwBnz9ieqNoAist/TEQPCPRhDZcOcbS5xv3edB8WsEDaXNLyU8DYA+j2t6bR5NepOJgGbCZxco503pf0xcbC+hM2pZUC8TnFN1RaT0TIQqi0jfFm0amxBCZP6Qnmnj9cCRQRiqzdhTEP5kskWtTcKx3dyeZwqE5EPknUOrLf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(66556008)(36756003)(2616005)(316002)(956004)(52116002)(55236004)(53546011)(4326008)(8936002)(8676002)(2906002)(83380400001)(86362001)(31696002)(26005)(16526019)(186003)(66946007)(5660300002)(16576012)(7416002)(6486002)(66476007)(31686004)(6916009)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XrBL0xaD0y0n69PXrSE3gF8AR03Pm8RDVEqDRqbRqPvk0kZdeDd+zjr5u7YqPtybfBacJKBYmDGv/b+un8ieHUsQbS4rQPVkYDOgr2iaqMQAXUSbZIDwy1yLr8VbgUN6hL4XSSn2+iDa5Mr8XIKGkbAxAkRdY37GGWj8Lw1hDrvoHoSaIdAhXaCEJ4vQ+dL9kxREOiA5JuLARBK0GCbqHO+wsY4kgpAnTjUacn1ohVNTVOdy/WAqSFGHy3aU4zPNQifFN2xHfkLgPYD4asgVqphgPe7ZKGXYGeRpjqrPgqj/YTHzr5uhsu1EfXvBMv7tjuVanrGaaimgKMY2b9SfJrRLdDx7848f4MpSbVVRWMhr5vjHg73olMpCsk55NM9LBlGnKQGRbizwZHmZqSKa+frQK5iPAlFIFzXgeFgVvjsx61fDcLpBrO2wpsYg2FKSi+ijmn1OlxNFaUvEjN+9N5T7yWoTYjKJD39U6tME9us=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18860298-35c0-408c-592e-08d8241b93d8
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 15:20:13.8490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /iB8sZz+NXDXyvC19aTRBfPpuKeh0DHb9PPoafpdteIE9GaabFEC0FWjblEXpRoNukr40ZaKXqB/pdjrk9Gaag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5427
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-02 15:19, Magnus Karlsson wrote:
> Add support to share a umem between different devices. This mode
> can be invoked with the XDP_SHARED_UMEM bind flag. Previously,
> sharing was only supported within the same device. Note that when
> sharing a umem between devices, just as in the case of sharing a
> umem between queue ids, you need to create a fill ring and a
> completion ring and tie them to the socket (with two setsockopts,
> one for each ring) before you do the bind with the
> XDP_SHARED_UMEM flag. This so that the single-producer
> single-consumer semantics of the rings can be upheld.

I also wonder what performance numbers you see when doing forwarding 
with xsk_fwd between two queues of the same netdev and between two 
netdevs. Could you share (compared to some baseline like xdpsock -l)?

> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   net/xdp/xsk.c | 11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 1abc222..b240221 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -692,14 +692,11 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
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
>   			new_pool = xp_assign_umem(xs->pool, umem_xs->umem);
>   			if (!new_pool) {
>   				sockfd_put(sock);
> 

