Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B635D3940B0
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 12:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbhE1KMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 06:12:39 -0400
Received: from mail-bn8nam08on2067.outbound.protection.outlook.com ([40.107.100.67]:17248
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236469AbhE1KMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 06:12:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f97QGVivlN6RHTt33ARrhvZce8R0KtQnCp0qOW5du5uVuUjpT3nwfKid+i0cAUwjaAszUrcoc5k5DXOSMN3rw9egGB4sduhQIGBMbhEh4kEElMBh1/oPyHU5D10QmCyZTIudy00hjzkp3bXIqS03OeHTGbFCEqsVlHvUO5srzu+YCoN+vLrYrpf+2tH+ICs7nwVO2OgApFcZVklx/sZyfqZGKHqUMjgx9cMVo20Qp16FvN4AU6InE44lyn4H8eemuPxSXVPFD5/e9oq2tYIQ/E+Iw3m9OZnWIJO63dhH80UKOD4iu5CIs0N7PbujiKLjTYjivuo8M+cwKXy7nks7Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpSF8tKRyjU9pVaPF3iSDZ1mQ0A0w9jOolh0H/0tcR0=;
 b=XmdGxhDd+Hsz+7t+yEXddkRyEadKcMC4L1BNVd+/QZyhNA0AhSmnJqwtcYaE43CM4Mjk1p8lupK09PSJ28VLuq7UpNy2X+KFwTOdkbIW8fM1TGTDTowCneAFeVYDpc8cHtPW92K0stISPYahfMHLyCvAT/O1G5QT+pi98uulc6cXhfBYCd9OFuAsjDNi504Uaxe0VhaI2PjD5/0EFCcS+Y77KhvBNFX1npKmdxwOtnF+ttRMOjc/JCrFo9xDH6HNuY2VYBZmxW/Isn9Rug4lse+/rma4nW/mci2VYgiYZiPPUo5kxJFm4AwKkb0MqhgvhnSXdwgIXTbRXMrbtzZUJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpSF8tKRyjU9pVaPF3iSDZ1mQ0A0w9jOolh0H/0tcR0=;
 b=J/Mmmojo7a6YWnZfeMoSB4m2dR/inZCHB/DkmBQz/I9qwqICmqlfwKuIfVa64JA/JegWVGBhyi6u81/B8m5NFjWkby+DQPPg1rH5Uh/6xHfQOpKq2++ZC2ELS2puRASZudotihJfTOw13N5ZsvKY0OB9WcJkmKAu/ZnEJf+u9cc139Ju79BV1C/6SafMeUWdT3Xo1pwWCZ64iczP2N63WVoAONJcLEC0MkKlp5Z/GSi0kvu24DccD309HnEOM3XLWVoanu7lJTb4ChD7hPdtaRUdYj23nAiDuQcrblOhEkzJQ1aVSbVFfX4OCXex/UO7lG53oOsvq0RCM0AoNrWa+A==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 28 May
 2021 10:11:01 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:11:01 +0000
Subject: Re: [PATCH net-next v3 1/2] bonding: add pure source-mac-based tx
 hashing option
To:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
References: <20210527200051.1871092-1-jarod@redhat.com>
 <20210527200051.1871092-2-jarod@redhat.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <ac1450ca-c034-a71f-38e4-91dddecac73f@nvidia.com>
Date:   Fri, 28 May 2021 13:10:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210527200051.1871092-2-jarod@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0013.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.64] (213.179.129.39) by ZRAP278CA0013.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:10:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a49500ed-558d-48df-fb10-08d921c0e4f4
X-MS-TrafficTypeDiagnostic: DM6PR12MB5565:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR12MB556564E13537852395EB0E2FDF229@DM6PR12MB5565.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b2v+TczXEUVd8HRL7QgYnPqcfLvctq6mjEG8Emihn1RndM9BCBsx+MJebBZILTtVuDe8uDGNyWgzNToWn95L1FXVHM1HUqegwwITpfjFdvDIoA+GsnKwp+PtiTsrXdzAoK0TiNfdmvkTf4xyoBBDXrujTYIzL5xzdQgbmdJxrcK8hXMI3T+PAC9Dnjn+gpzgFFOrMKk7bY4Twu39QWTU6MGHxHPtNIERZrOQdTKGk3TqC5J0ffpBBNCd0MS3grLn7z+5E2OECujZh9fMGGLl73D6JvkZahBaSZ41CKr6iisASPwqwfO1cURaiwUv+IPfKMz4fu0WOzdsSK2FN8+Nm0lDTHB/oWC4zs8DN9dQr0sa+V5WlMNJXFCjINlpR27bpdXQf9RsLS3F5vB+brUJkil2QA450YgbydwNYT4pgAu3owuISlFPgpf2UyF1XYOBQZZbDkuhLugFwB/GfD0DlDD524qqJ+6BYnd9WPuHBiNRqkTuq+ZC/YVNgBPaFx4fx84WzHoBAPLd/zD8wvs0PJFbWZagf/f8K7GvT4DL4DgKidgz1bygFnhA3QhzJkOtOWwViDQRvLf7na3MjgqQlEfm/iWo6AizGiaW4i2jMXjnRT61Mo2G6sBWSXOScYuzyX2kbs48Jlt7s2B/NWVaC8F2sS8Trd2VKb8VQY5dHStIw3AuQY8RUC0RyD4la4/C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(186003)(956004)(6486002)(31696002)(2616005)(16526019)(36756003)(86362001)(478600001)(83380400001)(66556008)(66946007)(66476007)(53546011)(8676002)(38100700002)(8936002)(54906003)(6666004)(2906002)(16576012)(316002)(31686004)(4326008)(5660300002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dytXcis0UTRDSS9QY0pVdlZmZmZRNFFCRmp2Ykx0bWcxbGszeFNucnNCSU1k?=
 =?utf-8?B?L3hLTk9LczE2OS9vRnRPamRLRVRBRDNiUVFUeVREY0x1bXIxcFZlSTl2VGN1?=
 =?utf-8?B?Sjl5azhWeUtCcUwvMXd6ZE5XU3Z0a3hGNVpmYnpBSEpjSEJpWjR3THo2NEty?=
 =?utf-8?B?UFg3LzBUVEd6czJJQjhXYlREYkhxY3hlNEdLdmVyUnlqZFFjRVR3ekFhTjBy?=
 =?utf-8?B?OEhYb1ovZXY0NDJ2SXozeW8xV1BlM1ZPeWc0dExWVCtHbThzWUgzbUJjYW5E?=
 =?utf-8?B?UEJwSnNUeXZraVVEelhVcDBINHQyQXE5UjNqMmNQQ2RyWkZxOWxQSjlzNnBY?=
 =?utf-8?B?MHZPaUlubWVTYVB1bWwxdk9HVUE5SlJtdWVnUXJ0Y012NXFRRSsrNk5PVVZH?=
 =?utf-8?B?aGtTWG16Slpsb2hjWmJTSXBKeExxUHU1NElDcmJrZGFRQVpGR0M3ZGQ5bytG?=
 =?utf-8?B?WmZ1Q0hHbUVNeUsvYlh5MzYxRGdPQzM5TXgwcE1ncktxVHNqeURMSDNXZzhI?=
 =?utf-8?B?Z2pyMjFNVUIvZTN5VDVCaVdXQitxNkVqUko5dVpKemdiRUw4eC93QmhUOXdK?=
 =?utf-8?B?Zjd3bHFTR1F0MXlyVXJvaldaNEU4NStncGZ5dStZTk1tWWgzOFZBbng4amhW?=
 =?utf-8?B?M3FrWnVDRk9rS2hZT0JIMUNOdDFibTVoa3FCR1pxMDREUkdJN2hSdEZyL2dS?=
 =?utf-8?B?bWhFNWNUWU8wWVg5YU9iM2RYc1BtVERkbEpIWVErRjVYVHp5c2ZqdFhSZVps?=
 =?utf-8?B?V1lIeHZ1MHM2UUNsWE5KeWowK2pXN2oxQko0NFk1YVJhNEgwUXFpcjJocTBp?=
 =?utf-8?B?cENrTzJCeUs4aXFrTGRlU0pQYThRbXFRb0hnZmRFQ1BGRzlZcXRZbnRNSWYw?=
 =?utf-8?B?ZkZzOUlyL01DTWRDVTVXZ3VRZllDZ0Y4eVp0Znh4cFl6bmxDNXhYL3FBNWRE?=
 =?utf-8?B?NldISkhTcSt2WWJhZFZBenJ2WmlRbTVMak5DL3BOak5kOTNkaHVNVUJYT3RB?=
 =?utf-8?B?QUxIdmowNXoxSGxZS2Y0cGt2Q1ppdWE3TnBIMEMrZG9wSHpGY1FoVDBjTDVQ?=
 =?utf-8?B?Z1dGalhBQmlGN2xKSWVtaGFVaE5scTNYU0lYTVR6M0dsN2dxanM0d2p3aVhu?=
 =?utf-8?B?SWhqa2hiNDdZT2RhYUNUais4ZlpXdnBYVEt4WkY4eGpVZUt2RWFxVFRaVFpV?=
 =?utf-8?B?YVhId0tuMUR4L0N6ZCthMzBiT3RGajYwQzFkTUNYQmxWUXRkVytwcXBpaWpM?=
 =?utf-8?B?V01icGdZZkwvZWJEdmZ3Ym9wN1VkTTU3Rkh3VTNDK2U3ZXRidVBuWkNpU2c0?=
 =?utf-8?B?a0UyWHFkanRkY2h0OGk2SEJnZDhiSzlzaVA4azh5SXN2Y3V1cGJGVTdyQUkw?=
 =?utf-8?B?eHlTZnRZc01halpTQm9HaUpzYlVvaG55c0hDT29tRGtyajFodmhFSzlISjRm?=
 =?utf-8?B?RmZueUdxaTJsN0VDekcyNEM3OVU5QmNGN2IwRWthbnhVQjBkV3d3Mm1tcWRy?=
 =?utf-8?B?VndaaVV0Qll6WVozaFU2QnUrRTVoYndFdno4MTZNMEk3WmZoTjFVZGZZRWFo?=
 =?utf-8?B?amhheFhENnluOHRzWmhwQ2FrOFJiZ0x5L013N2VvODA5WGJxY2FiSER1MVM0?=
 =?utf-8?B?S3YxNTd6YUZ0NEtiY2hQTzQxSnFYWEZhWkc4NnZPU0xSSldmVVkwdWk5Z1lz?=
 =?utf-8?B?cWZOVkhCR0FkL1lnRmM0Y2pXcVhkRHFrZUd6MlhGTE9rY1U0VXRJRzEva1hr?=
 =?utf-8?Q?BRjrENfAfD9irG0EbfJpDYJ/YLhf/9ydWlLiNAY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a49500ed-558d-48df-fb10-08d921c0e4f4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:11:01.3461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bGXg2cyBw5HZaQUWZXQrb/EDTO/QCS1sJ3eYbxAjIc2kk7mUvw25fY0SsQYM5A9WJWGisYDDXN3mJ1bUhaPrNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5565
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/05/2021 23:00, Jarod Wilson wrote:
> As it turns out, a pure source-mac only tx hash has a place for some VM
> setups. The previously added vlan+srcmac hash doesn't work as well for a
> VM with a single MAC and multiple vlans -- these types of setups path
> traffic more efficiently if the load is split by source mac alone. Enable
> this by way of an extra module parameter, rather than adding yet another
> hashing method in the tx fast path.
> 
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Thomas Davis <tadavis@lbl.gov>
> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  Documentation/networking/bonding.rst | 13 +++++++++++++
>  drivers/net/bonding/bond_main.c      | 18 ++++++++++++------
>  2 files changed, 25 insertions(+), 6 deletions(-)
> 

Hi,
Is there any difference between v2 and v3 ?
Me and Jay commented about netlink support for the new option, any new option should be
configurable via netlink. Please include a changelog between versions so it's easier for
reviewers.

Thanks,
 Nik

> diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> index 62f2aab8eaec..767dbb49018b 100644
> --- a/Documentation/networking/bonding.rst
> +++ b/Documentation/networking/bonding.rst
> @@ -707,6 +707,13 @@ mode
>  		swapped with the new curr_active_slave that was
>  		chosen.
>  
> +novlan_srcmac
> +
> +	When using the vlan+srcmac xmit_hash_policy, there may be cases where
> +	omitting the vlan from the hash is beneficial. This can be done with
> +	an extra module parameter here. The default value is 0 to include
> +	vlan ID in the transmit hash.
> +
>  num_grat_arp,
>  num_unsol_na
>  
> @@ -964,6 +971,12 @@ xmit_hash_policy
>  
>  		hash = (vlan ID) XOR (source MAC vendor) XOR (source MAC dev)
>  
> +		Optionally, if the module parameter novlan_srcmac=1 is set,
> +		the vlan ID is omitted from the hash and only the source MAC
> +		address is used, reducing the hash to
> +
> +		hash = (source MAC vendor) XOR (source MAC dev)
> +
>  	The default value is layer2.  This option was added in bonding
>  	version 2.6.3.  In earlier versions of bonding, this parameter
>  	does not exist, and the layer2 policy is the only policy.  The
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 7e469c203ca5..666051f91d70 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -107,6 +107,7 @@ static char *lacp_rate;
>  static int min_links;
>  static char *ad_select;
>  static char *xmit_hash_policy;
> +static int novlan_srcmac;
>  static int arp_interval;
>  static char *arp_ip_target[BOND_MAX_ARP_TARGETS];
>  static char *arp_validate;
> @@ -168,6 +169,9 @@ MODULE_PARM_DESC(xmit_hash_policy, "balance-alb, balance-tlb, balance-xor, 802.3
>  				   "0 for layer 2 (default), 1 for layer 3+4, "
>  				   "2 for layer 2+3, 3 for encap layer 2+3, "
>  				   "4 for encap layer 3+4, 5 for vlan+srcmac");
> +module_param(novlan_srcmac, int, 0);
> +MODULE_PARM_DESC(novlan_srcmac, "include vlan ID in vlan+srcmac xmit_hash_policy or not; "
> +			      "0 to include it (default), 1 to exclude it");
>  module_param(arp_interval, int, 0);
>  MODULE_PARM_DESC(arp_interval, "arp interval in milliseconds");
>  module_param_array(arp_ip_target, charp, NULL, 0);
> @@ -3523,9 +3527,9 @@ static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk,
>  
>  static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
>  {
> -	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
> +	struct ethhdr *mac_hdr = eth_hdr(skb);
>  	u32 srcmac_vendor = 0, srcmac_dev = 0;
> -	u16 vlan;
> +	u32 hash;
>  	int i;
>  
>  	for (i = 0; i < 3; i++)
> @@ -3534,12 +3538,14 @@ static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
>  	for (i = 3; i < ETH_ALEN; i++)
>  		srcmac_dev = (srcmac_dev << 8) | mac_hdr->h_source[i];
>  
> -	if (!skb_vlan_tag_present(skb))
> -		return srcmac_vendor ^ srcmac_dev;
> +	hash = srcmac_vendor ^ srcmac_dev;
> +
> +	if (novlan_srcmac || !skb_vlan_tag_present(skb))
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
> 

