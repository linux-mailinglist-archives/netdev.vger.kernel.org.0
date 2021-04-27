Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD9236C43F
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 12:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238782AbhD0Kg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 06:36:57 -0400
Received: from mail-mw2nam10on2085.outbound.protection.outlook.com ([40.107.94.85]:6939
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238519AbhD0Kgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 06:36:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JP3AnSM2NdhB70jiRXrL6hCBb80ljDxW19SIhNAQNTWnj1uM+onum/51qvIemrmY6BpWwWmpNVPkRe3GmRwwvSQI2l+1QNisg7BRvSmPOj8WET6Q0NdQltDU8GyfBvdq7QGGZEt7B95UW6rh7BuTe6te4SuB4QzsrjRv9r6D3KHdWRzf9CDvGOm8bhhO9ie3Wb70cov/m9tRUwLUKwLu2jHTnpX8SQBcRyDDhESj0F4nh0BAy0doDpN+VXWYPP/d3QJnewiCNM+s0LMk6uAZpcbkt3wu6SECaIHTs1ZOJffCx5YwTMfh/K1OwUOroEhwKar/SNtuejEDZmiiT3kwGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvDrsW/MKdl9io654kXHRVI1XiR1fBEsnjacBEJ3Chw=;
 b=A0kHSmKLheL54JC3a5LFSefApTU0HSf/jJKKh/tC/nS6rVX3ZmDPQIcWZhXVMXlK9WIcZgmCGcI2u4vL5dwy/97nmbinum1lFZljaW+0EwQz9poKcVBkm8++uOsmOrqGKfHqo1lSny76KCYIzC/HwDR1dK5EkmTp4bFKggE2fjGIOU+UbAYh5XcxDK+MgSpDKFMrA4n7cDaQ4LS3tTCxDVldZdf7fGC/MuwyAg228Q9phURfCEXiHWnvpr2fyeChUod0/sJKMJtYGWZydHnLMiQN2bJA99nSlyMT1CFGJcGk13H+5hwgjrr9yyQxdEfWXgDOQpt1ylbOvpWtoKGsaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvDrsW/MKdl9io654kXHRVI1XiR1fBEsnjacBEJ3Chw=;
 b=peMYWDU7WaFeztst7cehCW1C/PjORJvhnA7MdM7KRbdSSk853X/0MdSwpLbipFDzTRr9yn6XOVeEFPGHbTcZgNWvgSI+WgDDyblf5ylcXeD7hhHKr7nvq3LIvAeddk3lvIRWfYOFii+ikJONf72FCxyNc4pHC7UWVlRcH3h7aJ8rWVWdB8a/MqyezBesTaYwAs7yCC4v27s82+HFjuQr0GC+CrA/nYnaZTOAEKrKinp1FpiV6X+e7NUcnGJf+gHzL4MDf65k7hZwiQ8tHDtO/mWbApEq/FaJ7EUpprKKq8vNJmSFK/oWRxeibhBsvfEpUFVXA91xxFNMKCevO2Py6g==
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5214.namprd12.prod.outlook.com (2603:10b6:5:395::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Tue, 27 Apr
 2021 10:35:54 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6%2]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 10:35:54 +0000
Subject: Re: [RFC net-next 4/9] net: bridge: switchdev: Forward offloading
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, jiri@resnulli.us,
        idosch@idosch.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-5-tobias@waldekranz.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <ac177d80-6530-be48-95bc-57652a31fe6a@nvidia.com>
Date:   Tue, 27 Apr 2021 13:35:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210426170411.1789186-5-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0016.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::26) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.78] (213.179.129.39) by ZRAP278CA0016.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Tue, 27 Apr 2021 10:35:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d71bd0f-6420-44d8-1545-08d909683c7a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5214:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5214E68BA43C1E52715B336BDF419@DM4PR12MB5214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iE3HD35L0A5ZXM8FHuYPKqFCaqwaB8fwgWAVNUlA3pvpedjTnFE+42kySkMLDy0y4YRliv0m1hOZQpb75TpaXJ0ifzQQyUuD9j/Ei3neeBMi3Y/wUkmqlRRbtsgpz/2QrLxkVznFrOd81zAQ3hH62/914nmWjMwjPl42MuMyK9w0WhuqEwHELHdfYSBDJLh6LSZ+qnhtM+dWegVwhIda5sSFqKkIbTjRN6F818zO5rh5s321W69w8Kvcw510SDNzvkTDFFclDtJ2nVUb+TJjHSaSTaBYJDN5FREhjX8wIZN1TklVCPE9unc8sfu+CCDWSk50woUxRY8IMHzJHmKIABqQUNIEuxMRhZ1rm2JvwjJrAWE8z4IzxJ4PyuMkiajNjUw3o7C06jVs+QLwogIbGmUfIaH9Z9/OAWqSHtS8VQv8extF6vwmdcDyhQC3iVlFCMlU328HSvU7eHgrJM9WkVZSW8g6Pi8wOTNTKSr3x9kAFosPc/10pcoS4s66pxkSdKyoC64sbHkC9P38Z/XwHXFIWftBQBsTZjCBCeUfEL7k2bR8TmCjbwLmmKquLYecnWseTe9x5nOwRnzr6tT2plCU/HfJ23Pf5kFbsg5KjpgZ2aseFOSQ5nwpGDL0hXwCntlHNCdsuP5uAayhX1DKb5jwoAj9WlyHEtKzOh1xID1V7wRZ4SK/8VORzmKAifJD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(6486002)(36756003)(86362001)(8936002)(7416002)(8676002)(31686004)(2906002)(5660300002)(83380400001)(16576012)(66476007)(2616005)(31696002)(26005)(186003)(4326008)(66556008)(16526019)(478600001)(38100700002)(956004)(66946007)(53546011)(316002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d015R08rQ2RhVm9KR0FjTEE5MFJhamlDaVV2OTAvYU9XeXY0TXpncHVLUUFP?=
 =?utf-8?B?a3dkTGlRdUoweTBvUXpub3lQam9BenZ3S2dwNkswTUdZaWlGNFdSM1AzZUdU?=
 =?utf-8?B?WHRuTmRIZkc2SlhPbDdRWUEyQm5ENHNLWVo2ckNTQjNkYVdPM2FJUDU4RGhi?=
 =?utf-8?B?ZUlBWXdTSGN3Zm51ZXE4ci9IZ3ZmY3RwTE1hRHRIUDBIOFBoSFpMZ2cyN21K?=
 =?utf-8?B?SUswV09odW9IK1RZR24xR3VPdCtiNUluOXBFNnBveGYvQkVTV2pGRmpxcS8z?=
 =?utf-8?B?YklvcG1SMEtLNlRoTVZqNldBVDlEWDhmVUEyVEcrWUxJNGV4Qm1XZlM3Y3dn?=
 =?utf-8?B?WTVmVDgxTzhKTTFSWEk0ajBMcVNuM0JaTHFQNEJsVmpOY0UrUTl4WkRpM1dx?=
 =?utf-8?B?OTVoN1hTZlVjc2pLT0tEZVpLRnI3VGZRZVg2MHI2WDhxY1ZsSGZQZHg2SHZI?=
 =?utf-8?B?ZEtQL1FvMzM1VjE0WFBkcTJDOXF2NlBKM29ac1NHRmhsZlpXeXcvN2IzUHBi?=
 =?utf-8?B?QmJDNFpjU2ZvSmgrdy96ZTk5bThraXNOaVhqQ2k4bWdFcS9vb0hlS2ZzK3Mx?=
 =?utf-8?B?VjBodXJVZVJKd08xOURyWXFyRUVlSmhkY2dISTQ0ZWpSQkdkNVA2dUwrMzhm?=
 =?utf-8?B?OTduc2d3c3NZUFFtV3FJVU9haGlWc1Y3UzdJanNHVFdINHR1Rm5iZUZQb3hz?=
 =?utf-8?B?aWtiVnhraFVXZENTYWk1T0dkaG4wcEVOamM1RVpma09XSy9idThXU0oyN0hy?=
 =?utf-8?B?dU9nT29JNEI3a0pTM0ZQcmFZZnpVTGh6R0QrcnpsSzJ6aXYxS3Q3d1J4bU9u?=
 =?utf-8?B?N05OWGlVeXJMcHJSQmcrbUZZcGs2TzltVUJEbzM5SXVyWW50VEJNbHdidjda?=
 =?utf-8?B?V0Y5c3Y1T3ZBdytWQStaZk1TdVZVWEQyUWtESytOcDBhaUFrdUNrR2pmK0dM?=
 =?utf-8?B?RnFZRzRpRGoxOUJsbWcvR1RtaTFtcm1HUGJjSTMwVUM5N2l3SVJpMk82anBC?=
 =?utf-8?B?TXNEQ2tTZ0lud0l5SHFTa0syMXdJTXg5QkV4dURDT1BxTVd4VGcwaGZWbWVh?=
 =?utf-8?B?NTdsQUNLcWlKT3dQdG8rNTR3TlBKMUwveFp3QkF6YThKeHhwWE1ESVl2N2lj?=
 =?utf-8?B?clZiR2JUcDRYTG5mTWQyS21YLzlBRHZmWXNxNDl3T2lDZDhrZmlxVFFMcC83?=
 =?utf-8?B?R2pxbUU4YVNjcEt3cUxKR3hMWGs1dFZLemtJS09rMzRaZDJqbVFTa1h6OGV1?=
 =?utf-8?B?YVRkaUVpMVdjNW9waGFGY3BJcG1za0FvNFV1ZUtjWFZoaFBkQSsyUTZqU1JG?=
 =?utf-8?B?SVZNTDZKTUY0a1lyL3RHaXcvd3BSTHNKeExPRkdqQ1lLSlUrdG8yalU1eS9Q?=
 =?utf-8?B?NGg5UWQ5ajBKZUs5QkQ0TklaRnVMcGtUZ1BNdGdKQWdzWWx2dU5ZT2tORzNB?=
 =?utf-8?B?MzRxc0RsWWFxN0M3WTZFRXhsTjB1RHpNRyt1dG1SUnNvUkczZTQ5Uk5NOVBx?=
 =?utf-8?B?TFhqQW1mYUxvVVhOY1B2V1ExTFV4ZVowT21SYzNlT1NFc3JyTHFQSTltMkhi?=
 =?utf-8?B?Z2xTeGFUaGd0TGlrWU5uM1dCNVp0eURMVU83T1ZQT0tsWkxlMnpjRS96dXBu?=
 =?utf-8?B?c3V3eTVNSEYwdjZySDRIYlNLZjQ3UCtNeWx0dkcwQ0VhYko2Q2FnaVBTbW1D?=
 =?utf-8?B?K0lUYVprSzVZWXY4b0Q0bUtFMTZCRDNEcHBZWHgrT1V0SEV6VGVvTnhsWFdq?=
 =?utf-8?Q?Ldjp+DFEpqNo2D98KQe7QgcpeyhUG1nBXgtQ1AN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d71bd0f-6420-44d8-1545-08d909683c7a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 10:35:54.6673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OSM6vJMUuJ76++044KZt2x+q//0BjBtLceQGATI5nIsqBmt2T/5CN5uq4RzvPmKuTmBvAeN198cORi/06MMXIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5214
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/04/2021 20:04, Tobias Waldekranz wrote:
> Allow switchdevs to forward frames from the CPU in accordance with the
> bridge configuration in the same way as is done between bridge
> ports. This means that the bridge will only send a single skb towards
> one of the ports under the switchdev's control, and expects the driver
> to deliver the packet to all eligible ports in its domain.
> 
> Primarily this improves the performance of multicast flows with
> multiple subscribers, as it allows the hardware to perform the frame
> replication.
> 
> The basic flow between the driver and the bridge is as follows:
> 
> - The switchdev accepts the offload by returning a non-null pointer
>   from .ndo_dfwd_add_station when the port is added to the bridge.
> 
> - The bridge sends offloadable skbs to one of the ports under the
>   switchdev's control using dev_queue_xmit_accel.
> 
> - The switchdev notices the offload by checking for a non-NULL
>   "sb_dev" in the core's call to .ndo_select_queue.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  net/bridge/br_forward.c   | 11 +++++++-
>  net/bridge/br_private.h   | 27 ++++++++++++++++++
>  net/bridge/br_switchdev.c | 59 +++++++++++++++++++++++++++++++++++++--
>  3 files changed, 93 insertions(+), 4 deletions(-)
> 

Hi,
Please try to find a way to reduce the number of new tests in the fast path.
This specific feature might help these devices, but the new tests hurt everybody else.
I don't mind the control plane changes, but I'd like to minimize the fast-path impact.

Do you need "accel_priv" to be a pointer, I mean can't derive sb_dev from the port alone ?
Either way - you can mark the port via its internal flags if it can accelerate, those are
used frequently and are in a hot cache line (by the way that reminds me that the port
offload mark/hwdom should be moved in the first cache line).

For example you could possibly drop fwd_accel, add the bitmap in a union with sb_dev pointer
in br_input_skb_cb which can be set at __br_forward at the accel check and pass it down to
avoid the final test. Furthermore since the hwdoms are bits and if the port accel is a bit
you could probably reduce the nbp_switchdev_can_accel() helper to one test with a few bitops.

In nbp_switchdev_allowed_egress() I'd make the hwdom tests rely on skb's offload_fwd_mark
so in the software forwarding case we could avoid them.

I might be missing something above, but we have to try and reduce these tests as much as
possible, also the port's first cache line is quite crowded so avoiding any new fields
would be best, i.e. at some point we'll move the hwdom/offload mark there to avoid pulling
in the last cache line of net_bridge_port, so it'd be best to avoid having to move accel_priv
there too.

Cheers,
 Nik

> diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
> index 6e9b049ae521..b4fb3b0bb1ec 100644
> --- a/net/bridge/br_forward.c
> +++ b/net/bridge/br_forward.c
> @@ -32,6 +32,8 @@ static inline int should_deliver(const struct net_bridge_port *p,
>  
>  int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
>  {
> +	struct net_device *sb_dev = NULL;
> +
>  	skb_push(skb, ETH_HLEN);
>  	if (!is_skb_forwardable(skb->dev, skb))
>  		goto drop;
> @@ -48,7 +50,10 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb
>  		skb_set_network_header(skb, depth);
>  	}
>  
> -	dev_queue_xmit(skb);
> +	if (br_switchdev_accels_skb(skb))
> +		sb_dev = BR_INPUT_SKB_CB(skb)->brdev;
> +
> +	dev_queue_xmit_accel(skb, sb_dev);
>  
>  	return 0;
>  
> @@ -105,6 +110,8 @@ static void __br_forward(const struct net_bridge_port *to,
>  		indev = NULL;
>  	}
>  
> +	nbp_switchdev_frame_mark_accel(to, skb);
> +
>  	NF_HOOK(NFPROTO_BRIDGE, br_hook,
>  		net, NULL, skb, indev, skb->dev,
>  		br_forward_finish);
> @@ -174,6 +181,8 @@ static struct net_bridge_port *maybe_deliver(
>  	if (!should_deliver(p, skb))
>  		return prev;
>  
> +	nbp_switchdev_frame_mark_fwd(p, skb);
> +
>  	if (!prev)
>  		goto out;
>  
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index aba92864d285..933e951b0d7a 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -332,6 +332,7 @@ struct net_bridge_port {
>  #endif
>  #ifdef CONFIG_NET_SWITCHDEV
>  	int				hwdom;
> +	void				*accel_priv;
>  #endif
>  	u16				group_fwd_mask;
>  	u16				backup_redirected_cnt;
> @@ -506,7 +507,9 @@ struct br_input_skb_cb {
>  #endif
>  
>  #ifdef CONFIG_NET_SWITCHDEV
> +	u8 fwd_accel:1;
>  	int src_hwdom;
> +	br_hwdom_map_t fwd_hwdoms;
>  #endif
>  };
>  
> @@ -1597,6 +1600,15 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
>  
>  /* br_switchdev.c */
>  #ifdef CONFIG_NET_SWITCHDEV
> +static inline bool br_switchdev_accels_skb(struct sk_buff *skb)
> +{
> +	return BR_INPUT_SKB_CB(skb)->fwd_accel;
> +}
> +
> +void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
> +				    struct sk_buff *skb);
> +void nbp_switchdev_frame_mark_fwd(const struct net_bridge_port *p,
> +				  struct sk_buff *skb);
>  void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>  			      struct sk_buff *skb);
>  bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
> @@ -1619,6 +1631,21 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
>  	skb->offload_fwd_mark = 0;
>  }
>  #else
> +static inline bool br_switchdev_accels_skb(struct sk_buff *skb)
> +{
> +	return false;
> +}
> +
> +static inline void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
> +						  struct sk_buff *skb)
> +{
> +}
> +
> +static inline void nbp_switchdev_frame_mark_fwd(const struct net_bridge_port *p,
> +						struct sk_buff *skb)
> +{
> +}
> +
>  static inline void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>  					    struct sk_buff *skb)
>  {
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 54bd7205bfb5..c903171ad291 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -8,6 +8,26 @@
>  
>  #include "br_private.h"
>  
> +static bool nbp_switchdev_can_accel(const struct net_bridge_port *p,
> +				    const struct sk_buff *skb)
> +{
> +	return p->accel_priv && (p->hwdom != BR_INPUT_SKB_CB(skb)->src_hwdom);
> +}
> +
> +void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
> +				    struct sk_buff *skb)
> +{
> +	if (nbp_switchdev_can_accel(p, skb))
> +		BR_INPUT_SKB_CB(skb)->fwd_accel = true;
> +}
> +
> +void nbp_switchdev_frame_mark_fwd(const struct net_bridge_port *p,
> +				  struct sk_buff *skb)
> +{
> +	if (nbp_switchdev_can_accel(p, skb))
> +		set_bit(p->hwdom, BR_INPUT_SKB_CB(skb)->fwd_hwdoms);
> +}
> +
>  void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>  			      struct sk_buff *skb)
>  {
> @@ -18,8 +38,10 @@ void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>  bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
>  				  const struct sk_buff *skb)
>  {
> -	return !skb->offload_fwd_mark ||
> -	       BR_INPUT_SKB_CB(skb)->src_hwdom != p->hwdom;
> +	struct br_input_skb_cb *cb = BR_INPUT_SKB_CB(skb);
> +
> +	return !test_bit(p->hwdom, cb->fwd_hwdoms) &&
> +		(!skb->offload_fwd_mark || cb->src_hwdom != p->hwdom);
>  }
>  
>  /* Flags that can be offloaded to hardware */
> @@ -125,6 +147,27 @@ int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
>  	return switchdev_port_obj_del(dev, &v.obj);
>  }
>  
> +static void nbp_switchdev_fwd_offload_add(struct net_bridge_port *p)
> +{
> +	void *priv;
> +
> +	if (!(p->dev->features & NETIF_F_HW_L2FW_DOFFLOAD))
> +		return;
> +
> +	priv = p->dev->netdev_ops->ndo_dfwd_add_station(p->dev, p->br->dev);
> +	if (!IS_ERR_OR_NULL(priv))
> +		p->accel_priv = priv;
> +}
> +
> +static void nbp_switchdev_fwd_offload_del(struct net_bridge_port *p)
> +{
> +	if (!p->accel_priv)
> +		return;
> +
> +	p->dev->netdev_ops->ndo_dfwd_del_station(p->dev, p->accel_priv);
> +	p->accel_priv = NULL;
> +}
> +
>  static int nbp_switchdev_hwdom_set(struct net_bridge_port *joining)
>  {
>  	struct net_bridge *br = joining->br;
> @@ -176,13 +219,23 @@ int nbp_switchdev_add(struct net_bridge_port *p)
>  		return err;
>  	}
>  
> -	return nbp_switchdev_hwdom_set(p);
> +	err = nbp_switchdev_hwdom_set(p);
> +	if (err)
> +		return err;
> +
> +	if (p->hwdom)
> +		nbp_switchdev_fwd_offload_add(p);
> +
> +	return 0;
>  }
>  
>  void nbp_switchdev_del(struct net_bridge_port *p)
>  {
>  	ASSERT_RTNL();
>  
> +	if (p->accel_priv)
> +		nbp_switchdev_fwd_offload_del(p);
> +
>  	if (p->hwdom)
>  		nbp_switchdev_hwdom_put(p);
>  }
> 

