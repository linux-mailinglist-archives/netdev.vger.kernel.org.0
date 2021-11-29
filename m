Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E124611B5
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344404AbhK2KGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:06:45 -0500
Received: from mail-bn7nam10on2080.outbound.protection.outlook.com ([40.107.92.80]:28769
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345333AbhK2KEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 05:04:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVYQzTkEiKdC7R2Xu1QH7oy7BN0n2adXC5YqfKXAJSRXaUWGbrgAdE0zrSb/DkduXDZPGsICE6g6NMLSWLAjdWW4tnl30MzktxfJ8I1CRqcUij3YN6yJ4zJTFFa5BR00mEy/BaFA0Wdaxg3uURqyUch0QA0JoZhviBrWnvcu25IYmQ2iUByvA3muRv7VJQP6M1AppheLSJLDwiXRDnCaRXYJCsWU0Ap1LNFg0+JDgZ8KdKgotPQ4XoUzzLYGslXX+k4bR4H/5RL3Xm1yEo+a7tbOa2gNqk/s2nLsFJ1JzZl/MXy4XakMOVOxgQNUhecmpLKKxKGf0uUpE4PfzcnNkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFnhqNCnKwx6IJz9q6XdyZni/0Dh8kYftbLZyO4u/TE=;
 b=fcsQVghObFyrAlVJG8KuL/silK33dhd2lWyI8/wcc1VGffeyfjugN99T2ExRKgkXd8OGqbN1Hm8vLzaujKuIaPhi0orBdtQbpAxCmbmHStbPdcoOjjI0olP8XTYDJ3mtvGkifQKExEC/urXAy+fEVYEhFlnlyCCsiSRctIqCdPk+aPsTdMqSuzy5zDCnqSewMG/CroljXMi9/YuryWuCi0bq4SayaIFZ/9aBDAWT3h+XzlH6PE2SA5wBtaFEV122kAVUlU6KbDDdKseDbRfxPq+/DcV9xx/UwrGNP9dZ0xb2wIKin+sl2O/DnEwy5GW4BsFOEuGsCfj2eVGSNgHHWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFnhqNCnKwx6IJz9q6XdyZni/0Dh8kYftbLZyO4u/TE=;
 b=BA08gp5PBpZqryJWl7UiKZmhognKLJ4qkiv0MNE/Dzfe8/gh2Hc2kwJWOBmv+/L/Vue7g/k+8P+UW76h7n8wMOgDccsTfeaIwCfiKhQuY7igS64a5aBskgX01Cn6OwFOW0yezE0N4DyzN9CHLyZwKju0W9cPf0cQw19vkWA7r9+PdvsWsrhy2rOqsm5WCCFO2bVrj/Lik0mzz+tzrXip8JKrmc6FAhclCpiQbGfT1kGWBZZiTVy30zH2GsSMfKy+8OUtRGheB54PO0pUTTaNqogwU0STNMxjc6f/3midEyoPwa9CamTuHH/1KoHR7PwDIFfKvf0/IvYWf4tUX+SB0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Mon, 29 Nov
 2021 10:01:26 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df%3]) with mapi id 15.20.4734.023; Mon, 29 Nov 2021
 10:01:25 +0000
Message-ID: <41088611-712e-3f31-cf44-de50359ceccc@nvidia.com>
Date:   Mon, 29 Nov 2021 12:01:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net-next] selftests: net: bridge: fix typo in
 vlan_filtering dependency test
Content-Language: en-US
To:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org
References: <20211129095850.2018071-1-ivecera@redhat.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211129095850.2018071-1-ivecera@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P192CA0052.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:82::29) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.42] (213.179.129.39) by AM6P192CA0052.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 10:01:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1af0bf95-e59d-45c6-42a4-08d9b31f3468
X-MS-TrafficTypeDiagnostic: DM8PR12MB5480:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5480E9ACCBD177E229E3557DDF669@DM8PR12MB5480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +jsRRtujaso9pXBYi2+U5SpyrVgdOJAlDN6LmKjZz6w7YMkyQScAUpeyWRRyN7pONIjPsPndrEyndiT/QGCOGCTzO/Cg5V/QPuI1+IvuqRahv2ek0vjbSGqEgVlI+exO3p0M24Q0pcACtqC2uyIREGww9NtGTz/TgYVrvHWQViYfKLXv+WNshn7HLg7a/x0mWnd/uGyUie+2acP9krAstHqR4h8ky7oOwLqALP0dxQFHBzPBt4MvfgTQLjqMMh7OccZD8T7vbUKbpTSnq3Qu6O1FyyzatoszD8SYIQeCWQ6oaNKRTRfgnQJfIInxsquJu4tSskF/LgXrfL6wSNe+a/T7qX1R1r0tDAPowjmsks8j3KP5JR8AzTdoedNlrJtRFM4Til2P9zhpyWt7OiJVZ3eughmHhtX9i2oX/Tqcg7zPY7dBZJ0yqMpag8AQNABgCLB0Pzn74x/QeXEVqK4dl1UN04oex5Tgph1gD/e6Oso3PQMI9tkjl8u9QLyZDwTMkABatwlpH11nU4FejOHxJ9ErR0/lZ67vM7+aVagvWdonw5j8/NN2JL5JjVa+gHOV+676V9l+eOxZ+oWwsnkCCAe+rjdwxEYWu+olYk7m8l0WCg65r7kSoG89P5Kc1MEOPd1uPkBmV2RXbuGNc7rNaivDA7t1OvWU+cbc5XZ/idBPTAQmY8riLp96yLKK848MEs9YlDaU+tuImyjaWU/T3wccGLKMdRTpWtXXzjfwOVs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(6666004)(83380400001)(8936002)(2906002)(8676002)(31696002)(86362001)(6486002)(5660300002)(508600001)(956004)(36756003)(38100700002)(53546011)(186003)(16576012)(26005)(2616005)(316002)(66556008)(66476007)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUhtNGVkMDgwa1MrT0NwOHdWTUxWa3VreC9IRXlpdjg5bzM0Z2ZTRFo2VUIy?=
 =?utf-8?B?Yi9lU0NxSmRzMHdwSlZWdUFPU2FQRW54NHRDM3lEUktaZVBndDRKalpRSVFD?=
 =?utf-8?B?VXpPaEVXdXplL000NUJkNStKaXV5Q3hmM1VDVGVvSDhWaTJ4eGN3c1Fpa1BK?=
 =?utf-8?B?VXRNM0d2QUFzMnBtUVhFMnZRUkVSVWQ0bklNazdCaXIyaFFjMjNKZzc2VHh2?=
 =?utf-8?B?UzZqenVSVWt2NGRKNjc0NXpxWGVPNy9IUmsxSWpPK0RQTUFaQlczZmpvbW52?=
 =?utf-8?B?ZkQreWxNb3drVGgyT1I2MlhIdG5xR084bSt5UFB1RUpjWWRGS1ZSRkhtWHE2?=
 =?utf-8?B?YkN6U2FaSFA3ajl4TElqUUkvVysyRHl1Y0RhdGFCenZDTmdCTVNGYjMzTzh2?=
 =?utf-8?B?ZnF2SzZRTWxJNTdSMUFqWldQamZCYmU5WHJDVDUzTi9ieXAyczBDT3oveWQ2?=
 =?utf-8?B?cEt0UGw3TDhOMXdRS0RUS3IxRjNLRFVGWmN3RFpVVUxwaEhHMk1QS2tmdlYw?=
 =?utf-8?B?bnBTTklhejZ3NGYzV2lnemhQSmdtV0JrM0tqRTZrQWp4eWREck1ucm5UUUlo?=
 =?utf-8?B?N0RqZ2trU1Faclgwa2pscVlEWHNUMzlhSU9iK2p5dkRMeExiUHBSeGl3VEoz?=
 =?utf-8?B?L2x2bUVSM2gvQ0VrVWgrNnlBblhCNWJNZHlhcVZUYTlubU9KOGhOTmZMY2xn?=
 =?utf-8?B?RzlVU29JUDFGR3BBQ0FaVmMvbjhCaTBpL2M3eVBJT1BGQUFqdVJrcE5CZEh4?=
 =?utf-8?B?VXVzdnhwalBLQXJtQ3M4K2VrSkh6SHVlWWtFK3JGTVVuQ1JGeXRNdkxIUSt4?=
 =?utf-8?B?Y2FzNDZtWW42S0pRelBjN0JiaHNZNzA4MksydjBVYmNySWRGSUlEaVNHU292?=
 =?utf-8?B?bGpnZ0NYVzZPaFVKN0JNZ0Y1VUllRkZPeE85SnNkMUdoUWhUMVFyUFRSSDJh?=
 =?utf-8?B?bUJ5T2plV29BTVUzd010VHVjcUxHNyswbmQyMzNKNkRKQTUyN0tFVFhkdmxO?=
 =?utf-8?B?WHNPUW9CRFloTkJhSGpZUUNidmZVLzUreXN6SkdicXhtRGpaL25Bakw2cW9R?=
 =?utf-8?B?K2pRdGVOWmxkdlVxS0JaK0JoYk50WGpMQS82U0VnYmFHUkhyVThReGR3V1Jw?=
 =?utf-8?B?V0cxM1NDbStYL3NnVWtQcjhEaWdPK3ZqV0VRTzVUY1hucGRRaGNOY2F4V2tE?=
 =?utf-8?B?TWhBRGhHZFl5Mmt1SWVWZ2g5L0s1eUpvYWhnd3VJazJyVFlSNTRoOUcwRHk4?=
 =?utf-8?B?eFNJTndJVWZLS3IxbzdRSEFjZTFxaWhrM01UOW1qQklMWldKbXdoTHI1bmxj?=
 =?utf-8?B?clZlT01vUmJkcitpbkt1bks5bHRFVkdsTlNZNmNXN3dNT1JwNUdDUXhsSlJx?=
 =?utf-8?B?WnlJMk5HYnNHeStZalNrcU1nNDVzT0dYeGJJZkw5b0YvdzRNcmhkdXZJMnVX?=
 =?utf-8?B?R0tKSjRWbFkxcFdGdzEvRFZKUUhkRVJRNWVvbmNsY1lBSDRZUEdkWHRSQ2d1?=
 =?utf-8?B?MjIxcnRXV1pTaVpKZkdXV1d5Y2VndUFZVXUrRnplWjZQUFdsTXh0U2Rtd1dK?=
 =?utf-8?B?WEQ5bStqSjZXc2hvdFhGaWpJSHhlUVFWYVQrSXBuRWxvYnhqbXhTbzhEK1Jh?=
 =?utf-8?B?VnkzcUNvR3l6RXNHMXI3a0IxaUdRU1MyMlpESE51WmE2SDZWOUtqVHB4VDZN?=
 =?utf-8?B?OGZZcnRDcmZRbVZuTEtQeEJXeG1XTzR6eWZFS25KRWZDZUFYd3QxM2pYdXdZ?=
 =?utf-8?B?d3JnbndVSURTbStTeVFiTjZXaTB3dk9CVjJCb2dhWk81TkpsUHRjQWlVd24w?=
 =?utf-8?B?VjM1WGtLaHVZN0ZZN2gxdDJUNnJPOXhDTGdJTWRKNEEyOGJyNU52NDNGTTdV?=
 =?utf-8?B?UzRVeFBjUGJxWkp4Ykt3NUE4T1B4Uk82RENZZkdxbE1ZdWhiOGd3MktDcnFt?=
 =?utf-8?B?bzBiVFYwb2cwa1RWaVBTS3ZlSDFZQWZzYWZxWnN2NFBJVDA1NWUvRGtZcE1O?=
 =?utf-8?B?dXhuNkkvSFRlZ2tjdWtmV2RSOCtBamlGRmUwN0Z6WXl4VWFPUG92djI2blBG?=
 =?utf-8?B?OWNjY3V5emp4WXRmWEZwK2s5aG5UQklKUjRSbjRkOWlPSUpWZVoxRE4wTG5R?=
 =?utf-8?B?MlVMSWhaU292dW94Nm1HYTRPWmhyTitxQk5OZ3NrSDJzZi82d2pHb3RVVEpS?=
 =?utf-8?Q?+ZWnvHWdTujAP38Eo813Etg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1af0bf95-e59d-45c6-42a4-08d9b31f3468
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 10:01:25.8403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rkkvdmds08ASomQkjSCoF7/JN5BPYAkQqA9GOQ8CTW27uBTOjpOodnWvGD46HcLHQXp8sTElYdytPWp34sBsXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/11/2021 11:58, Ivan Vecera wrote:
> Prior patch:
> ]# TESTS=vlmc_filtering_test ./bridge_vlan_mcast.sh
> TEST: Vlan multicast snooping enable                                [ OK ]
> Device "bridge" does not exist.
> TEST: Disable multicast vlan snooping when vlan filtering is disabled   [FAIL]
>         Vlan filtering is disabled but multicast vlan snooping is still enabled
> 
> After patch:
> # TESTS=vlmc_filtering_test ./bridge_vlan_mcast.sh
> TEST: Vlan multicast snooping enable                                [ OK ]
> TEST: Disable multicast vlan snooping when vlan filtering is disabled   [ OK ]
> 
> Fixes: f5a9dd58f48b7c ("selftests: net: bridge: add test for vlan_filtering dependency")
> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
> index 5224a5a8595b32..8748d1b1d95b71 100755
> --- a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
> +++ b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
> @@ -527,7 +527,7 @@ vlmc_filtering_test()
>  {
>  	RET=0
>  	ip link set dev br0 type bridge vlan_filtering 0
> -	ip -j -d link show dev bridge | \
> +	ip -j -d link show dev br0 | \
>  	jq -e "select(.[0].linkinfo.info_data.mcast_vlan_snooping == 1)" &>/dev/null
>  	check_fail $? "Vlan filtering is disabled but multicast vlan snooping is still enabled"
>  	log_test "Disable multicast vlan snooping when vlan filtering is disabled"
> 

Good catch, thanks! I've also prepared a few fixes and improvements for the tests,
I'll send them out this week. :)

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

