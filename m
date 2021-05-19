Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80EC388A0F
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 11:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344343AbhESJCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 05:02:44 -0400
Received: from mail-mw2nam12on2076.outbound.protection.outlook.com ([40.107.244.76]:18401
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232558AbhESJCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 05:02:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3UcmwdU2hqpM3K+5EnNns7+yEsbcPJokOqbXX2JgE9H9vrpcsqwxKrRcAoMn5OZuOGk1FoBjQxpN6Ja2CGY3UQdwNLE8Vwzgo8Kv9VmgLQfRCSkZHjl0s433ZcSKJsk/HKQlHfMfEm6jMxudl+y1l+c3tuJBmyxvSm+mVUPpPdqd6rslTXwAq1lWioLu9GAfBDqBniTYdECn6ypx2+GITAs+mEccgkfFOXhtvwYWz8O4Z/RjPiWQV6yhZPPNrFW+Egppr2Ph7unljTIvGFg44l/oIMLxfNARM15yRUWpms9rDPFviZ9iyZI66aaKOks/guR0tqneeooORrOJ6Ne6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGN1bcbkNbDNALgpvq1WIMsGMOJY9Rmqqz69b5gzQ2I=;
 b=euc+iB2LBmNRxpp5CxADDZIDutOQ//Xc48wwXZxvjn5tGpwvG/EKWFhF01nHeidWkzyy84rHmrKvUKrmoMqs1ANjVEvurbRtab6H0cc3taTnybU5QrpM5Ja8Q76Ale2VL1cGnALvFHwYmN1gAhgYQniiw17dMGlEpOCyJ6tVtVv4sGEtCudxFM9uFtlOdliKzT6WQRu9DgvSztHE0nq2BIvIcdqTLvB0qRBi6jDu9bdMPutApvjSB9ncYeCOYIoI2Jj0QUvjo4BObORKTEsaawdUt1iTlZc+g88704A6u26XhmNJ75gs8td4aB8Il/Rs5w6577VsuqisY/iNEytOkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGN1bcbkNbDNALgpvq1WIMsGMOJY9Rmqqz69b5gzQ2I=;
 b=Phb0HkV0EhwDKmpc8vPy8oq84ok9MlkRZlhL1fLr1/8O8PWHhe9ZXXdejz53QkcshOB6EvOGQTQyAoRiDcf8IyPcfSQ0qVedNMkoAdbVb4h1sgais0VPk+ESLfVfqPg4A6hfp17UBD3s86tTMLzL9LUfKRoRzr17BKMrxUxvhXCLmwglcKvbLuhtfNyclrGBk5gan7iwnnytbYv3TRI3D9QnWAsrXrdFz//pLbtH23UvPQr6nEn2PaSKM8iiBkve2rT7sBTqPEf2c/e5c9sDC3X1m9n2VIMTdoP+ErIAR0t2xdHFLYZBz1rV+5o8h4PfjTj2XQWq0JGRyXVxrSbxSw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5551.namprd12.prod.outlook.com (2603:10b6:5:1bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 19 May
 2021 09:01:23 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.032; Wed, 19 May 2021
 09:01:23 +0000
Subject: Re: [PATCH 1/4] bonding: add pure source-mac-based tx hashing option
To:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
References: <20210518210849.1673577-1-jarod@redhat.com>
 <20210518210849.1673577-2-jarod@redhat.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <57bacfa0-2d51-1c37-209f-44a3934a55a4@nvidia.com>
Date:   Wed, 19 May 2021 12:01:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210518210849.1673577-2-jarod@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0029.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::16) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0029.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Wed, 19 May 2021 09:01:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12c5c5b7-25e2-4bba-5e91-08d91aa4acf1
X-MS-TrafficTypeDiagnostic: DM6PR12MB5551:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR12MB55515CE083498FEF92D28125DF2B9@DM6PR12MB5551.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m3lbtCPx4PgdZMnenIU2kaGTurEO/ZEGHEYbqPiwaDmF1fCl5U+yWWGjBlvd9f6BHNM8hmv5l/hMpqlb7FxMoc8UMMvAfG6xS/Sd/LqM4eNPR9Ts/aUhZpWcIkOMrXbMcci93Ueq/yroJvnB9b04XawP6LiBzo3azhPjtTVXNdl5XcE3p5f0XQ0Kf368AAG2WnwhMsMb6qbj+ESBDqzrgbHZN7zE8E6D+i+oE6TQzmY3CiLYTI9Mie4OIbZoJtWNcNSlKyfHyHbZCUGCEEO4W2Lh46yu5nsym96rFRS74REudOgjE+pdReFjXvR3nvBR/l/Ji0T1jhGOGIK+Sd/cTRjMgyuPVe4ybgkO5BVeNaH3NqXA00OxkVjuAFtM148PWFzfCdV8rofDDoK8SdmcVvfVtw6GhcPaEUHTcoxL9ZZAb4liWocs2m+fu1vxhYLFqvm86S2lUaUkhJRZNZQB5viOSQRoH7s4eP0zXpamwnIKds29dUxee5tEG5TxQpgDpu+U/uMqtRmP5zPcdQvK0nUfLuOUDDXoLbBEkTKIzi7oVcxykraFVIISFPltM40mKHRqWWUokVJG6gclGuZi3rM5qYJrYD9RXNfp36SgfU0CxZ+VQYkoxCbr8gylfZCqLcEfLZFa5KctERIaduOrFL8TN8v7dbV7ogKfMQq3XF/75h2S9tRkHnMcTrQvc8fh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(36756003)(316002)(16576012)(53546011)(16526019)(8676002)(186003)(2616005)(956004)(6486002)(83380400001)(54906003)(26005)(8936002)(31686004)(478600001)(31696002)(6666004)(4326008)(38100700002)(66946007)(86362001)(66476007)(5660300002)(66556008)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QkZqYnMzK0VTWnEvdmw3UmtoZElBeFJOUVFVL1QrTWExaEFaYUd4RzdjTHYr?=
 =?utf-8?B?OElYeXpjejRTTWxSS3ZtSjRnekxoM3Bwb3lQc3pvYzZubmQzVFowbXFQekZt?=
 =?utf-8?B?Z3VHVDdyTEE1UWtPSXNmZFZmRFZkVU9sekNaKzljbGhvM1gxNE1yNHZQT1JE?=
 =?utf-8?B?OUxRL3NwMkxMVkVLbjYzSEhmV1pyNEU5bTJyZGZNQWYzbG1JM0c2RVlYeWNa?=
 =?utf-8?B?R3ZaWEFQUmE4TCtGOGt6aXFUS0pRQTZieGJZK3c4Tmh0ZjJIOFdvNDVvNXJ1?=
 =?utf-8?B?aEVpYVlqaUlXYURBbDNzbDBCR1lJTytXR3RiakxCb25neGdWb1RkVTFlNHhr?=
 =?utf-8?B?ZjBOQ3ZWUUF0NTRIOUtyWkZpS1Zvd2pzWldyVEFRUDM1RjFWcXd6Z0RDdjFO?=
 =?utf-8?B?QzRQQ215SUZMWXRIaDczMTk0Ri9QRkt5ZWJsTW9kZFg5YTUxaXhTZ05HbjJs?=
 =?utf-8?B?RWtzdmp5M1puTHNvYmtHR2tGbndOTG5yY3FkeElHcXR2WUNLT1lLUTJRK1lB?=
 =?utf-8?B?S0tWZVBWZFhiS0t0Z0IzeHo4ZjArY0kxQlcwZjN6K29BbjVKUmI1UlpIL29R?=
 =?utf-8?B?UGJEbGduNFRQRzJmRGxTQ09iNlc2R0VwNjl1SXc0WWt3dnZUVUtqbkVINHRt?=
 =?utf-8?B?S2hjQXJpQm1QazVMZEhPcllqcVVrMUJyY1RaYll3aUMyOS94WjdMTERIempu?=
 =?utf-8?B?eEdrd3A4R0hJWGh0WkdKbjFCcGZPMG41T0lueENhMTVpVlBFc1gxTmE3NjFr?=
 =?utf-8?B?akJtcjFqVUw3WHExTkFSelA1VGxuR0c2cjNZaHg3U21FVGZ1ejF2VWx6WnJp?=
 =?utf-8?B?d2hhWlhRNEhKcG5QampXWHNHaS8wd05rTVF5ZkE3Ym12Qnp6alpVaDlySDdB?=
 =?utf-8?B?MDZBeWl1cDNVRGtnTlBwSWdjMUdZY0MzdzJOd0hZeDlzblZEdCs3MlhZUTBa?=
 =?utf-8?B?S3R1dGFZNXQzV0Qvcmtlby8xRWxlMFpRanlXOVFkM1k5MVppT0RWM29kemhi?=
 =?utf-8?B?eVBzclJZdjBvTXpXdEtEOHpNaFV3bzdYOHF2RkNTcm1WT0FjUlROTFZYUndX?=
 =?utf-8?B?NEdVMmlSb0pRUkVZaWNwc3JNMXZCTUpnOVZndkJKeWhpN1BmNVZyVjdhTmgy?=
 =?utf-8?B?WHJMVVhCU3ZhZkd1RndsZnVWTm5BcGxDMm5wVUNvZkxVUit4bk8veFdmcHhu?=
 =?utf-8?B?TWpVSDNwblA3djA4Z1c3VHNTTW1YYkd6MWxkdGZIdmJsRW9kSFZJVkhTZ3Uy?=
 =?utf-8?B?M3hkVUlzS1JUakNDMHhobENNcXFpbVZRTEZ2UG1zTFRIc3Q3eVZOeWlDQXdx?=
 =?utf-8?B?djhKVVZKRlFIR1gyQXVpZ3hvN2pqdG51WjNQaGRLdEMyc1ZYRHpOV1A0SlpZ?=
 =?utf-8?B?S0g2M3llSHdFMURCalE4T3JtY3YwOVcvRG5GdVdTT3R1cDZ2R2QvMUNvS21a?=
 =?utf-8?B?blR3RW9LdW4wY3B4ZmdJNmZDdnY1ZlEzbElPL1pCdzRJWmxFYURYMmNtZXJh?=
 =?utf-8?B?cXE2M1JvVXpTa2JhY1J1Ly9ITGI2M1JUUFZyWWJXb0Iyc3Z1cFZRME5LeURz?=
 =?utf-8?B?SjRQM3RrekZqWjhub3dxcFd1RHMyc1hUd2dpMDhSV0JyK3QzTkswbVFZZ3RW?=
 =?utf-8?B?OUI4L0E2MHNqRmM0dWVBcDJWMmRmMEt0SnNuYlQ2M1VqTjJFM2w4cmdiZEZR?=
 =?utf-8?B?TzhGcnRXUk1WK0FmT1U0b1V5VmxtSkpQenBmd2NSOXdxMDJlM3Y0QVhKQnJ2?=
 =?utf-8?Q?JMa7i0y/rJiQZkuzm3Zbrzz5JDvHvkJWvSbLJtz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12c5c5b7-25e2-4bba-5e91-08d91aa4acf1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 09:01:23.2474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VG7vR/OtnKPRIA2Yc/vI3tBl5oRyhoCJ3HmdyMshtJAa45zv6fRFm1B45wW/12DSR6Skhofyaw7B2buGEAJkGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2021 00:08, Jarod Wilson wrote:
> As it turns out, a pure source-mac only tx hash has a place for some VM
> setups. The previously added vlan+srcmac hash doesn't work as well for a
> VM with a single MAC and multiple vlans -- these types of setups path
> traffic more efficiently if the load is split by source mac alone.
> 
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Thomas Davis <tadavis@lbl.gov>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  Documentation/networking/bonding.rst | 13 +++++++++++++
>  drivers/net/bonding/bond_main.c      | 26 +++++++++++++++++---------
>  drivers/net/bonding/bond_options.c   |  1 +
>  include/linux/netdevice.h            |  1 +
>  include/uapi/linux/if_bonding.h      |  1 +
>  5 files changed, 33 insertions(+), 9 deletions(-)
> 

Hi,
It would seem you keep adding modes for each field, that seems unnecessary to me and
it also affects the fast path - each new mode you add is another 1+ tests in bond's
fast path. You could instead just add 1 new mode which has configurable hash fields,
take the "hit" for it once in the fast-path (if chosen) and use that.
I'd like to avoid tomorrow getting another "dstmac" mode or something like that.

In fact both of these new modes are unnecessary in most cases, you could use any available method
(e.g. ebpf) to compute and set the skb queue mapping on Tx to choose any slave and that would
override any hash or bond mode. Check __bond_start_xmit() -> bond_slave_override()

Cheers,
 Nik

> diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> index 62f2aab8eaec..66c3fa3a9040 100644
> --- a/Documentation/networking/bonding.rst
> +++ b/Documentation/networking/bonding.rst
> @@ -964,6 +964,19 @@ xmit_hash_policy
>  
>  		hash = (vlan ID) XOR (source MAC vendor) XOR (source MAC dev)
>  
> +	srcmac
> +
> +		This policy uses a very rudimentary source mac hash to
> +		load-balance traffic per-source-mac, with failover should
> +		one leg fail. The intended use case is for a bond shared
> +		by multiple virtual machines, each with their own virtual
> +		mac address, keeping the VMs traffic all limited to the
> +		same outbound interface.
> +
> +		The formula for the hash is simply
> +
> +		hash = (source MAC vendor) XOR (source MAC dev)
> +
>  	The default value is layer2.  This option was added in bonding
>  	version 2.6.3.  In earlier versions of bonding, this parameter
>  	does not exist, and the layer2 policy is the only policy.  The
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 20bbda1b36e1..d71e398642fb 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -167,7 +167,8 @@ module_param(xmit_hash_policy, charp, 0);
>  MODULE_PARM_DESC(xmit_hash_policy, "balance-alb, balance-tlb, balance-xor, 802.3ad hashing method; "
>  				   "0 for layer 2 (default), 1 for layer 3+4, "
>  				   "2 for layer 2+3, 3 for encap layer 2+3, "
> -				   "4 for encap layer 3+4, 5 for vlan+srcmac");
> +				   "4 for encap layer 3+4, 5 for vlan+srcmac, "
> +				   "6 for srcmac");
>  module_param(arp_interval, int, 0);
>  MODULE_PARM_DESC(arp_interval, "arp interval in milliseconds");
>  module_param_array(arp_ip_target, charp, NULL, 0);
> @@ -1459,6 +1460,8 @@ static enum netdev_lag_hash bond_lag_hash_type(struct bonding *bond,
>  		return NETDEV_LAG_HASH_E34;
>  	case BOND_XMIT_POLICY_VLAN_SRCMAC:
>  		return NETDEV_LAG_HASH_VLAN_SRCMAC;
> +	case BOND_XMIT_POLICY_SRCMAC:
> +		return NETDEV_LAG_HASH_SRCMAC;
>  	default:
>  		return NETDEV_LAG_HASH_UNKNOWN;
>  	}
> @@ -3521,11 +3524,11 @@ static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk,
>  	return true;
>  }
>  
> -static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
> +static u32 bond_vlan_srcmac_hash(struct sk_buff *skb, bool with_vlan)
>  {
> -	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
> +	struct ethhdr *mac_hdr = eth_hdr(skb);
>  	u32 srcmac_vendor = 0, srcmac_dev = 0;
> -	u16 vlan;
> +	u32 hash;
>  	int i;
>  
>  	for (i = 0; i < 3; i++)
> @@ -3534,12 +3537,14 @@ static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
>  	for (i = 3; i < ETH_ALEN; i++)
>  		srcmac_dev = (srcmac_dev << 8) | mac_hdr->h_source[i];
>  
> -	if (!skb_vlan_tag_present(skb))
> -		return srcmac_vendor ^ srcmac_dev;
> +	hash = srcmac_vendor ^ srcmac_dev;
> +
> +	if (!with_vlan || !skb_vlan_tag_present(skb))
> +		return hash;
>  
> -	vlan = skb_vlan_tag_get(skb);
> +	hash ^= skb_vlan_tag_get(skb);
>  
> -	return vlan ^ srcmac_vendor ^ srcmac_dev;
> +	return hash;
>  }
>  
>  /* Extract the appropriate headers based on bond's xmit policy */
> @@ -3618,8 +3623,11 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
>  	    skb->l4_hash)
>  		return skb->hash;
>  
> +	if (bond->params.xmit_policy == BOND_XMIT_POLICY_SRCMAC)
> +		return bond_vlan_srcmac_hash(skb, false);
> +
>  	if (bond->params.xmit_policy == BOND_XMIT_POLICY_VLAN_SRCMAC)
> -		return bond_vlan_srcmac_hash(skb);
> +		return bond_vlan_srcmac_hash(skb, true);
>  
>  	if (bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER2 ||
>  	    !bond_flow_dissect(bond, skb, &flow))
> diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
> index c9d3604ae129..ff68ad2589f0 100644
> --- a/drivers/net/bonding/bond_options.c
> +++ b/drivers/net/bonding/bond_options.c
> @@ -102,6 +102,7 @@ static const struct bond_opt_value bond_xmit_hashtype_tbl[] = {
>  	{ "encap2+3",    BOND_XMIT_POLICY_ENCAP23,     0},
>  	{ "encap3+4",    BOND_XMIT_POLICY_ENCAP34,     0},
>  	{ "vlan+srcmac", BOND_XMIT_POLICY_VLAN_SRCMAC, 0},
> +	{ "srcmac",      BOND_XMIT_POLICY_SRCMAC,      0},
>  	{ NULL,          -1,                           0},
>  };
>  
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 5cbc950b34df..d88319fca1d3 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2732,6 +2732,7 @@ enum netdev_lag_hash {
>  	NETDEV_LAG_HASH_E23,
>  	NETDEV_LAG_HASH_E34,
>  	NETDEV_LAG_HASH_VLAN_SRCMAC,
> +	NETDEV_LAG_HASH_SRCMAC,
>  	NETDEV_LAG_HASH_UNKNOWN,
>  };
>  
> diff --git a/include/uapi/linux/if_bonding.h b/include/uapi/linux/if_bonding.h
> index d174914a837d..f3b4d412a73f 100644
> --- a/include/uapi/linux/if_bonding.h
> +++ b/include/uapi/linux/if_bonding.h
> @@ -95,6 +95,7 @@
>  #define BOND_XMIT_POLICY_ENCAP23	3 /* encapsulated layer 2+3 */
>  #define BOND_XMIT_POLICY_ENCAP34	4 /* encapsulated layer 3+4 */
>  #define BOND_XMIT_POLICY_VLAN_SRCMAC	5 /* vlan + source MAC */
> +#define BOND_XMIT_POLICY_SRCMAC		6 /* source MAC only */
>  
>  /* 802.3ad port state definitions (43.4.2.2 in the 802.3ad standard) */
>  #define LACP_STATE_LACP_ACTIVITY   0x1
> 

