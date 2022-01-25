Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714BB49AEED
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453944AbiAYI4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 03:56:43 -0500
Received: from mail-dm6nam10on2044.outbound.protection.outlook.com ([40.107.93.44]:13921
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1453047AbiAYIvs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 03:51:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3VzHD9hzu+6UrBssZB1wwoEihpAzWnopEnX37W3wJfzXKmw/2cc4Bg/HSiOxkUs8WvJte1V6ODRZVg2vxzs+a+nQlTIdUJsiP97t4l5g3SSb7OyODLMmPnMnsw6jiIEQxEGIk/GRYq9R12vte0gFPH1vwVfYiSTgqafv3Maehr/XFFpell0GYtsklgjIe8E9w0JYIFq2Omr3BG7d+Be1vfsYuY1pnpobwDlw3VXmVvyOQ4sQ/V8KrwP9rdu8JlBmM4oPzmEIc4D7oPQxQAQAf50iJqjp9lCd088e2vwQ0N9u/bJsxKIX/BTkbYA8+8iTB9jOr0/XkgTaA2ZO88LIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=piKaVNgi3La+hreHQbg1ourx3dit7Yxq7IZAOlArQeU=;
 b=iCeP3HGBarYf2UCSvhC7Se8oMPPVmv0b7mbrv2zTqsm+Rs2KPmULcas0jCtOwqk/FJY6ri761A2ydX0CS/BN4/prns/g/GU60xOook5K3OoUp0cNEKnVAZmIapGEY+0Z2Rj88JaAC4rRS8Eqj1H7DarkbI5vW2Mk//fDfAGVVviKhZBFNZ76ReNtRCo/vUY47LOT9r6JUmEN0wxL4RdzUZirxz0ygc1cdfC5Fj8DO3OdTcU3MPVuYWqSm1XkqbcYZVW/gu6KVE9CLxIvFFk8gA5JLVZkzcrGvdX1aLLOjo4YjkR+7SZ/K1ya0/W1QlaP+vs2ZaOVt6BoAHPKbBS7XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piKaVNgi3La+hreHQbg1ourx3dit7Yxq7IZAOlArQeU=;
 b=pYuHboQq9Y3Ev7bcWjvPZtCXR0JtZeBx5BUFUdC3Vwgo/zLdaom7RorwuHHZZLRfAKyTMFI3S+fmXyHyNuyEpH+Cihd2EVBOlsof4wkONkqRQWl0yT/j60NvnU3ZYIBXjyPgA6RwOXiFVb+YXhnsVDL57GOQHa8d/CXf+NDC8IV0l8v6bj62oZd6/p1aCTyKGrkpVw3nJ024BMkw5s1Ow3UuAZCiiyiseuCCPNhOv6mQCWGRCVwSMQdc4082367c5fzSN2zu85+HxOj74MQX7OUCprMoahhMFgmOyrqp1YuWxX7h2yY77O5UM+hkuAEC++l42Ou4P/67R3L5DRzWPw==
Received: from BN6PR19CA0075.namprd19.prod.outlook.com (2603:10b6:404:133::13)
 by BN6PR12MB1585.namprd12.prod.outlook.com (2603:10b6:405:9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Tue, 25 Jan
 2022 08:51:41 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:133:cafe::31) by BN6PR19CA0075.outlook.office365.com
 (2603:10b6:404:133::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17 via Frontend
 Transport; Tue, 25 Jan 2022 08:51:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 08:51:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 25 Jan
 2022 08:51:40 +0000
Received: from [172.27.12.100] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 25 Jan 2022
 00:51:35 -0800
Message-ID: <d0afa956-6852-2749-fce8-2a3e06cae556@nvidia.com>
Date:   Tue, 25 Jan 2022 10:51:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v9] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
Content-Language: en-US
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andy@greyhouse.net>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jay.vosburgh@canonical.com>, <huyd12@chinatelecom.cn>
References: <20220125023755.94837-1-sunshouxin@chinatelecom.cn>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220125023755.94837-1-sunshouxin@chinatelecom.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: drhqmail202.nvidia.com (10.126.190.181) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6475981e-8b65-45d9-05a6-08d9dfdfe847
X-MS-TrafficTypeDiagnostic: BN6PR12MB1585:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1585C8D26C94692B9281A4BDDF5F9@BN6PR12MB1585.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zLTqNJxXRb2w3yIJmII7RLvu0xEn+dgmhkoNCWnsJuPOJPo5xa1BtI/qLiaFuneBe4QPq9j6XgPdPj7AWbxKtmundAjxSCYPX8UjrYBh6zFtph8mDUTZk5YU26edfR7QPDK6aKqZ6GT/5X++vsRg7vrQW4jjHRsG2voUpKB07JyKkolTztBKGlDTi1Tfs279zbLHIvXl6LOQrSArfa2VPOjambY3OYCmW7OpZyfvIF49fwAyw+zZH56jgP9csnVfPyNRFjtgJqMjKMjgyNEX25c3bLsgzCqluxTN+HrsC7AedhdZgVL4aXqLjUN0TFLgAHuO0Z68Lj5rXOCMXEwR7GrQndGtMdzqOmVwKuhjs4sxk4lGFZoDC0yv48XS0sPU2K8iQAiGlcdzHuOn7XIfB+LsYjxxmkFlsGLeE9Ywfz2Dbs/obtQZ9FFGQd5Rfy13aUeEuaXI5x9rfiz6XGDzDHSwgfDFRqX0Z1UjkseSTQVucc9Xg2OdG1A9qKftQeMi0RTC9Ktv95bayJaA3ORcI+dbFdVpnm/k9/P9olMcE/VHo8xSzvD3KbNsfvs3bQBh5ppV9EI/PI31Dk3Irht6pspG7b/K/EUI6jxWwfY9dSbk0NXrYs1pk4ya1oODhPttAxvdIiQItAoYeg/re37Uk1lueSL7TZ/XfUQSsu6njmktryapskki8z7bBe4bblRGEhj0t1BDHHyfxYJSnrA5BE3Yqpx7fq7+zS0SZUTNmHJNgiT7MziC1lsCtk7dnu0jTfBXMajZCOqOUk0YW56fCGoNsltvCLj6Rv3TQE8Kk1+2xktvjiTzVLzVe8+5uSYHfZGOmemrYK4RJnQ3YUXwGA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700004)(47076005)(54906003)(86362001)(82310400004)(53546011)(31696002)(356005)(83380400001)(31686004)(316002)(110136005)(16576012)(36860700001)(40460700003)(70206006)(4326008)(336012)(2616005)(426003)(7416002)(36756003)(26005)(8936002)(8676002)(5660300002)(16526019)(6666004)(2906002)(508600001)(186003)(70586007)(81166007)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 08:51:41.5430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6475981e-8b65-45d9-05a6-08d9dfdfe847
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1585
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/01/2022 04:37, Sun Shouxin wrote:
> Since ipv6 neighbor solicitation and advertisement messages
> isn't handled gracefully in bond6 driver, we can see packet
> drop due to inconsistency between mac address in the option
> message and source MAC .
> 
> Another examples is ipv6 neighbor solicitation and advertisement
> messages from VM via tap attached to host bridge, the src mac
> might be changed through balance-alb mode, but it is not synced
> with Link-layer address in the option message.
> 
> The patch implements bond6's tx handle for ipv6 neighbor
> solicitation and advertisement messages.
> 
> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
> ---
>  drivers/net/bonding/bond_alb.c | 38 +++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
> index 533e476988f2..ba7cc1a9bf6c 100644
> --- a/drivers/net/bonding/bond_alb.c
> +++ b/drivers/net/bonding/bond_alb.c
> @@ -1269,6 +1269,34 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
>  	return res;
>  }
>  
> +/* determine if the packet is NA or NS */
> +static bool __alb_determine_nd(struct icmp6hdr *hdr)
> +{
> +	if (hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
> +	    hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) {
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
> +{
> +	struct ipv6hdr *ip6hdr;
> +	struct icmp6hdr *hdr;
> +
> +	ip6hdr = ipv6_hdr(skb);

You can't do this in bond_xmit_tlb_slave_get(), there's no check if the IPv6 header
is in the linear part before calling alb_determine_nd() there. You can combine
bond_xmit_alb_slave_get's IPv6 header pull with alb_determine_nd's, just please leave
a comment above the call in bond_xmit_alb_slave_get() that the IPv6 header is pulled by
alb_determine_nd.

> +	if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
> +		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr) + sizeof(struct icmp6hdr)))
> +			return true;

This could invalidate current pointers to skb data, more below...

> +
> +		hdr = icmp6_hdr(skb);
> +		return __alb_determine_nd(hdr);
> +	}
> +
> +	return false;
> +}
> +
>  /************************ exported alb functions ************************/
>  
>  int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
> @@ -1348,8 +1376,11 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
>  	/* Do not TX balance any multicast or broadcast */
>  	if (!is_multicast_ether_addr(eth_data->h_dest)) {
>  		switch (skb->protocol) {
> -		case htons(ETH_P_IP):
>  		case htons(ETH_P_IPV6):
> +			if (alb_determine_nd(skb, bond))
> +				break;
> +			fallthrough;
> +		case htons(ETH_P_IP):
>  			hash_index = bond_xmit_hash(bond, skb);
>  			if (bond->params.tlb_dynamic_lb) {
>  				tx_slave = tlb_choose_channel(bond,
> @@ -1446,6 +1477,11 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>  			break;
>  		}
>  
> +		if (alb_determine_nd(skb, bond)) {
> +			do_tx_balance = false;
> +			break;
> +		}
> +
>  		hash_start = (char *)&ip6hdr->daddr;
>  		hash_size = sizeof(ip6hdr->daddr);

... here you have to reload ip6hdr, but that can be avoided in a few different ways.
I.e. you could move alb_determine_nd() before the assignment of that ptr.

>  		break;
> 
> base-commit: dd81e1c7d5fb126e5fbc5c9e334d7b3ec29a16a0

