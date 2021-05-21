Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADB238C889
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbhEUNnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:43:31 -0400
Received: from mail-dm6nam08on2045.outbound.protection.outlook.com ([40.107.102.45]:8160
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232641AbhEUNna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 09:43:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzGkzHoDFxErywCU+oeXUJq7sfl4A6Tk2XLWSloH30aeKKQzWWGfrBcrwxONunTzAOG/8RaUgcsU+lq3co/aYPzEHW0Njt7AQJrR53Wr1CJB/WPWOTPS9pHdF+DnKr8p4fnZtRC4FhGfiIAPuiHyt23BhOzFbIMmi9Icuuq4QEzmz2gofydY7Fu3oV105ACTXI1Y6WwzV2mU+RpC3j8uTY+AfVP2pPNzEgzBcH98DdhaS4qHuBjGa+JRzE19tt0IZKcl+Re9QWSAr8cW2iDbZUdSsVoIpuDNdV4fz9UAWqsclJM/34c8wKHGwD8hapVNh0h+6PxFqkWB3KeucRjnpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYoL2800+FG2eCuSu3TzinDizYiW2xEuP+dmjkfBx4g=;
 b=A9o/0ce5ENH/vxC3W+yo9KXkjgHCawfm8es/mCJol29Zcl93UM05lBaW5jn2la6fODNWV2j+9BpLVmUgt+lRdNoNizY339bPAUglxA0gLQavXxd2vITOYVW2WMnWFNd/R+korxZgv3OBXvFzf76KVZooqwJSJpN2cZ/2vQg6ThGB7k53vO0ebgov+4MaOUtMqzUg7Haoav5pE8MrFxuLAQeBleCgorvtyFLbZMJ5nvzTMDmmDyzpEDcyEvJT5NAXZ8SUr1QYCapVMY4Q2jC2G7eCyBlZrp73S0kiAS0nWGA/D9Si2lGOLhJTgAOC8Xsr7mfzBWE9yJ/3sqeQmGvmVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYoL2800+FG2eCuSu3TzinDizYiW2xEuP+dmjkfBx4g=;
 b=OSSP+X++G2LpUaRgZVi88D4p+CP2698I11Cez6Am0mz3eXSu3TYbEQ8Liqnsp5gu9CX4Sf4HtGNlSACk9QSpCV17BdEUpGrwg3XSaajZUjG/fWeerrUkWD1LlYI+sebaMh2tDRw4R7X/QeXb+dEZJrpVq6WdxHZUlJRGrqlJoGKQU30PtqpW24fyJikQON49rIkyJvXs8zuAHFYhRSX4sq9Ewdz4Mi4BA3FKbH8SlRDgCdyy+GOeul13TN8FakLUZcUD1huOapcKvK1V1Ymp6jBOKh6OXj2jXLsJQvGPhnLmsF7y9GxgLDutzuHSHBxK1pNajiN9CkGVW18+NS+IIQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5552.namprd12.prod.outlook.com (2603:10b6:5:1bd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Fri, 21 May
 2021 13:42:06 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4150.026; Fri, 21 May 2021
 13:42:06 +0000
Subject: Re: [PATCH net-next v2 1/4] bonding: add pure source-mac-based tx
 hashing option
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
References: <20210518210849.1673577-1-jarod@redhat.com>
 <20210521132756.1811620-1-jarod@redhat.com>
 <20210521132756.1811620-2-jarod@redhat.com>
 <cfdef650-265c-19fb-de91-0f1ad0fed3e5@nvidia.com>
Message-ID: <32adf8f9-e0fe-dd7f-70eb-db9f04470be0@nvidia.com>
Date:   Fri, 21 May 2021 16:41:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <cfdef650-265c-19fb-de91-0f1ad0fed3e5@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0043.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::12) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.64] (213.179.129.39) by ZR0P278CA0043.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 13:42:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f11a4ee-9238-4048-1952-08d91c5e3936
X-MS-TrafficTypeDiagnostic: DM6PR12MB5552:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR12MB5552B8726D1701841E59A4A7DF299@DM6PR12MB5552.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1thkVO2WCyk6y245pPfON29RfMwiGnFAbBqZD7dWfl0tym1JUYpOgzn15YYts0ciJuFHY9pW98zOSXJadgXGrrQe9/j7DzwPPIEmDlT5zkAp0WlxiszU3Ivb//S0WwjQTCF0x+uTBbVHyQ0zU8q5LBf5hBIP8b4jNcKMmFeAQtzcRAboEE8WdS+JoqdjlgnrSDvIVdPYEc+79hXN+qNWmd+RiZCPuu+YLFcmCpx7Gl6err3PjoTuO6OTy8puOcpn2losoRVwElGwULh/dzoMkijEwA6Y/olpS5UmK+Hy2hSa6is+j3WdAc3++QLrD3mN5GIWG1KrIvOKfM8HfmyNPI24XMvHkoegly7u+b+AvXYd7hbHxbnG1oIfW8OcurDrz7278XkN7WvDTuxK4X0fP8MOektdJ9YVs3NB67kZ952Hh1L7sedreK5Uxcf+iKPnu1ZKOMV5/ZgEINxcq4QOfXhaQeMbTWx9d5RP/meGZYYfXXDYA22zG2zGmKhy7XIaRXLSsZkkaBKWjKpwVHkneGuxEQNKSt+VEGj0m4fjl+srNQc7LYlnt+osgEFpAMkmZwlw5+OfEMbmcBIl8L9xzLG56phmmzwjQy7WfiNHpCdSvUIrSnn9+D9Z5ReV66whVsDlT88uX6PI+9SYGlAqOzqTKouJwn2Bo7lPzV7VBdseZmaBJNKlcL1ZIO2LW4UN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(54906003)(4326008)(26005)(316002)(16576012)(86362001)(31686004)(16526019)(38100700002)(6666004)(31696002)(186003)(36756003)(53546011)(956004)(6486002)(8936002)(5660300002)(8676002)(2616005)(66946007)(83380400001)(2906002)(66476007)(66556008)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Qm1ZbkhPbmhmRmVxOW9yZXN2Y3FUM0FMdW82YTRCV21ReTFBb0M0Y2pxNnFa?=
 =?utf-8?B?SVdkM29PSmkvUWlMRkVzUGNiT1lJSGl4N3dQNTJsT1NaaDVuRkFkNTVUaVNK?=
 =?utf-8?B?Zllud0p4ekIvN2UybmZBcWNDZkJZK1duYWZOZ0pXQzJsWlVBaXF0OCtieTFX?=
 =?utf-8?B?Wm13ZGFYZWRSN2hxL2wrMGovZ1Vza3F2Y0RjNDcvcHdLeVJYdGVrbi9oeFBT?=
 =?utf-8?B?MkdaeUREVTh3TlhGUEFSSHhzZDdRZ3JIYVJOTks0U1BOc1FqNHBnbHhjQlZk?=
 =?utf-8?B?cUxrRThiaVV0ckFCRFFqdmRPempZSlpmck9kVlZTTlNVMllsbDhqaXhUYXJ1?=
 =?utf-8?B?QWJOS1ExWUYzeDVDYS9XWVhPaGJrZm9qbnc0VCtlckNJMzh2N1NBMDVGdzZZ?=
 =?utf-8?B?R2JQdEtiUmNsWXJlcGpoMDRnbG5ZZU1RdERSYlpXODROT2Z3Z2JMWXlpcmYr?=
 =?utf-8?B?REQ5UjE4UDZDcTRRcHpoUUNBM1ZTSTdNRDFxYS9JcG10NStYNlNXUi9NT1pY?=
 =?utf-8?B?eEJESWNpT01CVFNKQVVma2h6dmhqZVBCWWs5aXV5c2V3SEIvUGRGRnNQa1Q2?=
 =?utf-8?B?YzRSZDhpRDRub0JLeEw2VWxreUNWenVTVDN4WlBhU3Zubk5iUVdISW55Ymhv?=
 =?utf-8?B?N1lybmZxVi9YdHZwS3JJRmJtUjdveGNnbTJoZSsxYllKbDhuaE9kYzVJSzdt?=
 =?utf-8?B?bHlnSzk5N2N4SzUxZW5hdkNrK3M5UFlxUS9yMktSU2tXczJHWjdCeHB6SVBh?=
 =?utf-8?B?R0JDamhjWFJLcW0xN2g4RnV4NHdOa3RCUU13VFpCSmFrVlE2VTZYSnM2U01W?=
 =?utf-8?B?QmhCcnVYZDZRQUtwc0hEcld5U29VNWtmRmh3WU42UHh4c05IME5OdTV6QVBW?=
 =?utf-8?B?Q0hjN2VqaFI1R3p3NjdidzV0dzBTaHZpQ0xDWnBEa3ZEVjIrNWFHU282cDdZ?=
 =?utf-8?B?SUlCOFNjc2praGZXVVJwTlc5V1d0UU5JTnZTajNRSkZvNGlGcGdRNmdCbjBz?=
 =?utf-8?B?QU5Wb3pJYjZFZnZuSzh3YzhIL3REQUN0eG44ODFLdEtwZXFtNEpKdVRObFJu?=
 =?utf-8?B?YUREZVd5VkJUZlkwbzhiNjd6dVN1MW5PWEQrUk1FWkQ4bU05YVBuaGNXSTND?=
 =?utf-8?B?RXFOZlZqUWY5OW4rRjdkemo0ZExVNVAxZDc4M1RPaWtWT2I2R29vaUk0VWov?=
 =?utf-8?B?Z0YrSm9obFpCdmIrY3JsalJPeEc3QTVGNnMvU0FBYlFVbGRieFdzWjhGRmp2?=
 =?utf-8?B?SUg3ZElZeFZIeTJlcXQzWFlGSUk5V2hrSHJDS2JlMmpzUGJ6OGhzNm5pTU02?=
 =?utf-8?B?YVltK2tqUVBBcWRaaVE3b3IvY2N3cS9jNjRqZk9tVldzSzQzbFY2RldEcGMw?=
 =?utf-8?B?dlJ6SzVXUExHQXBZOCtGdGNNNkJVOW9nWS85Vk5RZThRL0ZzekdjWFBkMGgx?=
 =?utf-8?B?VGV1Z0JTSkoyZnZVaDV3UC84VWZ3eXNscjlINGhyT1RwakRpbUIzcit2Lzd6?=
 =?utf-8?B?NTdNQjB4TVhrd2FvY2RDN3lObDBNM3dlVDRQRG9aZjRXYndOQ0NvSmRRN1JG?=
 =?utf-8?B?bFVSdC8vcGdVY3hCSHJzVEZvZzFrTXJyS1VHQjRnVlkyUCtJLzlWS2piemlL?=
 =?utf-8?B?bVAvZElVcXhZVmpsa3dSSS9WWC9sUEVaTFpXU1lFNFRINlViamZpSzYvN0xx?=
 =?utf-8?B?WkhuQ2NsYjJCajNpcVFQdllWamZnd0hjQzdyODlZVWhGMDBxZTh1MjBVSytZ?=
 =?utf-8?Q?YwbDQfc2lvZod0i5WvVBMdgMLPGefQZkYT5Xa03?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f11a4ee-9238-4048-1952-08d91c5e3936
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 13:42:06.4624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ih8F60hPz34geNeFpUDYSUfUV5pTzRygS0KGh52Rf3nx1C8RLhKCpG6LvEJGTtVUVw/UmyZKd/fFCLh/bmSO3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5552
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/05/2021 16:39, Nikolay Aleksandrov wrote:
> On 21/05/2021 16:27, Jarod Wilson wrote:
>> As it turns out, a pure source-mac only tx hash has a place for some VM
>> setups. The previously added vlan+srcmac hash doesn't work as well for a
>> VM with a single MAC and multiple vlans -- these types of setups path
>> traffic more efficiently if the load is split by source mac alone. Enable
>> this by way of an extra module parameter, rather than adding yet another
>> hashing method in the tx fast path.
>>
>> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>> Cc: Veaceslav Falico <vfalico@gmail.com>
>> Cc: Andy Gospodarek <andy@greyhouse.net>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Thomas Davis <tadavis@lbl.gov>
>> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>> ---
>>  Documentation/networking/bonding.rst | 13 +++++++++++++
>>  drivers/net/bonding/bond_main.c      | 18 ++++++++++++------
>>  2 files changed, 25 insertions(+), 6 deletions(-)
>>
> 
> Hi,
> You seem to be missing netlink support for the new option. Code-wise the rest seems fine,
> my personal preference is still to make a configurable hash option and perhaps default to
> srcmac+vlan, i.e. it can be aliased with this hash option. I don't mind either way, but
> please add netlink support if it will be a new option as it's the preferred way for
> configuring.
> 
> Thanks,
>  Nik
> 

Almost forgot - please include a cover letter with overview and motivation of the changes.
Also I guess these should be targeted at net-next (or at least the new option definitely should go
there), and please add changelog between patchset versions.

Cheers,
 Nik

>> diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
>> index 62f2aab8eaec..767dbb49018b 100644
>> --- a/Documentation/networking/bonding.rst
>> +++ b/Documentation/networking/bonding.rst
>> @@ -707,6 +707,13 @@ mode
>>  		swapped with the new curr_active_slave that was
>>  		chosen.
>>  
>> +novlan_srcmac
>> +
>> +	When using the vlan+srcmac xmit_hash_policy, there may be cases where
>> +	omitting the vlan from the hash is beneficial. This can be done with
>> +	an extra module parameter here. The default value is 0 to include
>> +	vlan ID in the transmit hash.
>> +
>>  num_grat_arp,
>>  num_unsol_na
>>  
>> @@ -964,6 +971,12 @@ xmit_hash_policy
>>  
>>  		hash = (vlan ID) XOR (source MAC vendor) XOR (source MAC dev)
>>  
>> +		Optionally, if the module parameter novlan_srcmac=1 is set,
>> +		the vlan ID is omitted from the hash and only the source MAC
>> +		address is used, reducing the hash to
>> +
>> +		hash = (source MAC vendor) XOR (source MAC dev)
>> +
>>  	The default value is layer2.  This option was added in bonding
>>  	version 2.6.3.  In earlier versions of bonding, this parameter
>>  	does not exist, and the layer2 policy is the only policy.  The
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index 20bbda1b36e1..32785e9d0295 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -107,6 +107,7 @@ static char *lacp_rate;
>>  static int min_links;
>>  static char *ad_select;
>>  static char *xmit_hash_policy;
>> +static int novlan_srcmac;
>>  static int arp_interval;
>>  static char *arp_ip_target[BOND_MAX_ARP_TARGETS];
>>  static char *arp_validate;
>> @@ -168,6 +169,9 @@ MODULE_PARM_DESC(xmit_hash_policy, "balance-alb, balance-tlb, balance-xor, 802.3
>>  				   "0 for layer 2 (default), 1 for layer 3+4, "
>>  				   "2 for layer 2+3, 3 for encap layer 2+3, "
>>  				   "4 for encap layer 3+4, 5 for vlan+srcmac");
>> +module_param(novlan_srcmac, int, 0);
>> +MODULE_PARM_DESC(novlan_srcmac, "include vlan ID in vlan+srcmac xmit_hash_policy or not; "
>> +			      "0 to include it (default), 1 to exclude it");
>>  module_param(arp_interval, int, 0);
>>  MODULE_PARM_DESC(arp_interval, "arp interval in milliseconds");
>>  module_param_array(arp_ip_target, charp, NULL, 0);
>> @@ -3523,9 +3527,9 @@ static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk,
>>  
>>  static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
>>  {
>> -	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
>> +	struct ethhdr *mac_hdr = eth_hdr(skb);
>>  	u32 srcmac_vendor = 0, srcmac_dev = 0;
>> -	u16 vlan;
>> +	u32 hash;
>>  	int i;
>>  
>>  	for (i = 0; i < 3; i++)
>> @@ -3534,12 +3538,14 @@ static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
>>  	for (i = 3; i < ETH_ALEN; i++)
>>  		srcmac_dev = (srcmac_dev << 8) | mac_hdr->h_source[i];
>>  
>> -	if (!skb_vlan_tag_present(skb))
>> -		return srcmac_vendor ^ srcmac_dev;
>> +	hash = srcmac_vendor ^ srcmac_dev;
>> +
>> +	if (novlan_srcmac || !skb_vlan_tag_present(skb))
>> +		return hash;
>>  
>> -	vlan = skb_vlan_tag_get(skb);
>> +	hash ^= skb_vlan_tag_get(skb);
>>  
>> -	return vlan ^ srcmac_vendor ^ srcmac_dev;
>> +	return hash;
>>  }
>>  
>>  /* Extract the appropriate headers based on bond's xmit policy */
>>
> 

