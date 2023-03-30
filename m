Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B3B6D11F6
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 00:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjC3WHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 18:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjC3WGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 18:06:55 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253FA11EBD
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 15:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680213955; x=1711749955;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tQw2PeNe8sLLFIhRO87wHEVnjuOBPu/ALSzWve4RPDw=;
  b=llEI8FPTOTfpwPwmougcyPHrXW1tHDOXynAYKtPu8/6H6b/wnXGNX12m
   +TUMpBF6g9zuo5lrnrRMbjlIVl5BPgJeLc9lRZVOM4xoz5f7nv9/anM/M
   +huwnWEo26QAdawUcInZHTpwEXOSf4K/6MTvddf7e0UdV2RncLtAnl71U
   IkV49Lw4A1XyiW+gEj0aptuS8XoN6MEr0ChEpK5Kzg7WwLKwoRJpaDq/3
   apuH2DZdSgYIijrY6ea490f3TROUDNjKS0ZNkQcicBs9Woi81JYsjayGE
   GpnZc5wvQGwB1AjKr8GIurNLLov9QU6s5LIjd5Rw5lzEfPJ953livh973
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="403995392"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="403995392"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 15:05:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="717488833"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="717488833"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 30 Mar 2023 15:05:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 15:05:50 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 15:05:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 15:05:49 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 15:05:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2VPN0txMN6jwNZOHaRVmNTiy3SFbUru+bLbPIq1v4NDCTgR+kn39EgcNA55e40WNeoDidoXmSIK3asY7knxoi867il6lfMWiesPF0vCFlPoEzQuo6O9DtbTQN5oxbAvA12s51YGZRs1zGMgQ+Kq69zrx7BWdz2CDvbZxGdGffloFadEN2evt7E8/dpxVnaB8OLilWeo+msZqexGawPOyNE943yuknc3Nr3hnnVPynbAY1IOd44ZkYbIuD9hC9SGa+ReDnmAY7+WANXri/iz0haLHXOO3c1YFaJ4uZokXHXUfo34qghI6wXR63R0Ai4FUXxxGQnyq3/ezNZ2HMuiFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z7camYwnJPRIlgB9m4ZulCxHmXx9AropDrH2YZ4zPo4=;
 b=Ajk0iRsEEAQVGPj0sMopYvpwm0le6YhtyRcwDhNoBY9XrT6nwdxE+tsaQv1CDxEfI7+ce+GPP3PM5pBUuVZ5P0Fv36ITw1kywrwIvES4lUPiTV9w9aP33cRHKzGgNfFJzdZrCvhOQ935U3Bt9p8Ier8gXU8B0T+CONQ0asgQ5tqdn1OP9fLVHvK6U79eeGoMNEyfeOnJdoEJOaczS1L62d+I2PYgVmBpNCQgeYP3SHb5OcO7+Rog36PSNtz/qYSW+FP2V7+jVr/EPjBIPnC/8j+y2FHUP1IWs5A+Mv48Cj6kZVsYFffZNtwLaga0Yr2W79dRWpD/fH/pYDAFSdeUgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2599.namprd11.prod.outlook.com (2603:10b6:a02:c6::20)
 by PH8PR11MB7096.namprd11.prod.outlook.com (2603:10b6:510:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 22:05:47 +0000
Received: from BYAPR11MB2599.namprd11.prod.outlook.com
 ([fe80::c76f:9b76:76c5:5ddc]) by BYAPR11MB2599.namprd11.prod.outlook.com
 ([fe80::c76f:9b76:76c5:5ddc%7]) with mapi id 15.20.6222.032; Thu, 30 Mar 2023
 22:05:47 +0000
Message-ID: <368e6437-958a-2f59-66e7-e0eaf9afc12d@intel.com>
Date:   Fri, 31 Mar 2023 03:35:36 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [Intel-wired-lan] [PATCH net-next 14/15] idpf: add ethtool
 callbacks
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <shiraz.saleem@intel.com>, <emil.s.tantilov@intel.com>,
        <willemb@google.com>, <decot@google.com>, <joshua.a.hay@intel.com>,
        <sridhar.samudrala@intel.com>, Alan Brady <alan.brady@intel.com>,
        Alice Michael <alice.michael@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-15-pavan.kumar.linga@intel.com>
 <53741774-bf50-4c17-9ea9-0c101ea21d52@lunn.ch>
From:   "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>
In-Reply-To: <53741774-bf50-4c17-9ea9-0c101ea21d52@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0224.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::19) To BYAPR11MB2599.namprd11.prod.outlook.com
 (2603:10b6:a02:c6::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2599:EE_|PH8PR11MB7096:EE_
X-MS-Office365-Filtering-Correlation-Id: a1ef3cfd-4dbe-44c1-5250-08db316aea72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R6hFNyFWRt0rWdUXv0hOPtdFBZCH5gd/OUeKotxVHtJYn8foo+aHOWrD/VQ/IUJJ2PZ4COz/wbJjx2YbdE4Bo0mYW/biFWgxPWOI5kkWEroWoRvncy8B0an3NejdDHSgi/OSb+ONH4FVcmQE0u8f2RxS5J4IGC2LMNY9ex1jHmtz6PrzYi4hyPqoNoQEK/WHpPnpRLvpIUUrCCX/ZxtaTTCtUDPgsByUBAhJFgIkOwRBxOqkOzACXnldUnaxNewbwIHIhzj5PFOQycL8SAcrBeHn8erUHdwIKTYsC7rXYxJ0Uji//9SlEDd2/6lQNtqVoWp96RnemxT2k2YPVOAMjllXEN3NmwSpJdNyBbQbglddXvR2n/2+ABsMxcGy2ZNAcMb/NRgnnA4sMKApisG07BntycBQt/wrQYcUSSJWyV8s4SgN/laJLMK399EYEzZ3aui3y7OIRUVsP7EegMPLK6O6wafVOjEza944eP1Jqkzbo6SQDKs1ZICIQcbP3vRBK+MnzJuajO33iYtnYXGNiy532sxTEvFyFDLZ70mu+ewcsHigKMFxkbLVJBhIL1EyEnv4u9yyotsTpK2rdjiNKChmQ8qFwrkjoEKPKWBBr1/ZtkuoH7OrEBcrCDQgzC+xaYvUhFyqiVX/mW6rUSrbsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2599.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199021)(66946007)(6916009)(31696002)(66556008)(86362001)(66476007)(4326008)(5660300002)(55236004)(2906002)(41300700001)(316002)(478600001)(54906003)(8676002)(8936002)(186003)(26005)(6512007)(6506007)(53546011)(6486002)(107886003)(36756003)(2616005)(6666004)(82960400001)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEw3RmlqMnBlclY3Q2FGQ1daK1pvTDB1akc4OTFVb1BxakpjcGxKUU9lRDZp?=
 =?utf-8?B?TVl3UzloRkovckVOVGZQTXJCQjg3aGc0cHRZN3hhc2x2bU9hWlpNaTk3cEFV?=
 =?utf-8?B?cndYRk5UWWdIUTRHZTdLZzNMRFAxY2R3ZVlkUXl2RS9qVnBHdjhwU3FRQ1Q3?=
 =?utf-8?B?VXoxWnhTQjBMdXZaYmtja1YxMForOVMrZjdkbElRMTVTaEVhM0VjMVBiM2RT?=
 =?utf-8?B?YkFwZWNWRDQ1amtPVXZ4eEtGL1VzZUZpWEhqOUFsSzF4RGx0ZUgwT3lhTENJ?=
 =?utf-8?B?Y3FPTHovbWlkUUthUGcyczhiMWVseVluUlBEeWFobTlQVnZKV2FNZUErRnFy?=
 =?utf-8?B?WEdZbXl2NzBqUy9wby9EV2U5QzZvV1dvdVRqR0hlejN6djdGUXJ3TlJBYTcz?=
 =?utf-8?B?SlErU1ZMNEFtSkJtalduMUxDYmZ3VlZpRFM5bEluVWhqaHlaeWNwM0xTSFI2?=
 =?utf-8?B?b3BHNEFnMjdUZnRoOGowKzROTjUzaFNVNGhDcXNmejdqWWR3MDU5ZVREZXBH?=
 =?utf-8?B?TjRUdDNKMWRMSHlpQ0JJN0czc1pBREZVQ2IybFRxcXRHNnBrc2Q5YzBveVA1?=
 =?utf-8?B?UWQ1SCtCU0JZaXBxcEVBZGlxN3hySTRWNG9Ec21RcHNQbzJxL2dsNXNveTRP?=
 =?utf-8?B?UFhiNzE0bDRxdlRnemRwdFlVU0tnRmd6M0E4UVJtcTBKWGVFRGQwRmZ1NTFx?=
 =?utf-8?B?dlZ2ZFA3cStHWHdBNXBkWlBYajU0UFU5SHZyVGVaUU1DanMreTNyOEFkUmw1?=
 =?utf-8?B?aS9lalRvQjhsMExRL0dOSTRUaVRZb2hVUUsvUVRTZFcrc0IwYmU3eDdWR1BY?=
 =?utf-8?B?ZEVJalpnSHYvc3BPZXdqeUQ5bUpaSSttTURjUFFNOUZnbVZ4Z2dMSUY0cis4?=
 =?utf-8?B?VHoxREJzcThZRTJjM1lmRm5JZytnL09qdWw1aWRwa2Zva2lGRkFvRElUZWYv?=
 =?utf-8?B?KzVjeFRodnpaTzdpa1VwYy8zemZLZG8vYlNXRkZEVzVaVGFsQUdnMnduZEZw?=
 =?utf-8?B?TjRlRnZ0MnhBQVdvb0hhT0tJaTJJbDFkeWlFb0I2c2dJRkRiRlZYQk9uVGo1?=
 =?utf-8?B?M0FWdHJGa2p5R05FTForcWdtYkZsT0dTSVZlZVQ5NVk0SDgxQmw1dzlReUtG?=
 =?utf-8?B?L3FqTFlRdUhiM3J2aitadCtvcHNHYnV1ZzZsV3cxNndRSWJBNUwxU1RFTjV4?=
 =?utf-8?B?djhxMGNSR3phMUxMRW5tcWI1U2lRRzlZVzZydExVWlNHSjZoVXpQdzVFMmRt?=
 =?utf-8?B?c0UzVHlydHcwVFVJVVYwbmRDbW84MlIvVzBPZXo3N011WEFwVnFYVWJZOHlK?=
 =?utf-8?B?dEVkQWk5aUxyL3ErWHRXUUZPVTR5ZDVzQzJRT2pqZ3Q4OE53MG1oR2czckpP?=
 =?utf-8?B?c0hwTlA4T29NQzFvTXhXNFp1SHl1ZzEyRUp3alZLenhUUm9VSGtUYTFEMUhS?=
 =?utf-8?B?c2dPbGVhTnpvUDVOcTFiaWRWc01JdGpQZklPRnZZL1NEUWsweFh4WUl0ZXNW?=
 =?utf-8?B?TUI2VTdxdVZOaGh3WW1hc2pZSDZlSHdON2NIamhLY25xOGJNZTlnTjJKYXlP?=
 =?utf-8?B?dHpCdXJUT2Y3NTY5Vldab2pZMXp1ek9lajJtYytsMHdFYkdoWTBUNGJZR2xx?=
 =?utf-8?B?RVNBSjFuaW1qQ2E4SkVNa29HTmc2NWVMbkdlVWRTcnlZVFB2NG1hckl6NTdP?=
 =?utf-8?B?RTBpUDZ3aXdKZ0ZEN0o0Nm9JbWd4L2JQeExzZy84RysrQlJNUk9Ncnp6QzFK?=
 =?utf-8?B?ejgxclExNk9FNGxlaDZqSkh2dHhsN1owbmxsUUtweVJuaURkb3dqS1hqOTFM?=
 =?utf-8?B?OUZpOTdibStaR3lDaEhJY0h4UUIyMllVd3QxYUZ3SUtCbmxqMVA4eC9ZUFZD?=
 =?utf-8?B?TzhlUFU1M3hTVjJhYjNQci9HZGRuajFITS9sZlFtZStrMHI4YWJqVUg2ZDdt?=
 =?utf-8?B?bDJFMi9pUWh3Sk1nbXIzc3A4b29NbU94eG92UGlKY2R4VmtOSUZXVTVWQUtN?=
 =?utf-8?B?ekhHdHhkMVBLVG5rdDlFdnQvUG5jUFZ4cG9pLzZIYllDMFpKNmtFd056Mzkw?=
 =?utf-8?B?bnZOM2dtS2VwUmtwR01oVEREeGxjVWhIWXJudUhBRWJSQmxnNnlVdElQY202?=
 =?utf-8?B?cFZGUURJaVhtWjU0aTBqTzc0eW9GbjQ0TkFwNkgwYnJKVnZ1WHVhZFROZGxi?=
 =?utf-8?B?bnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ef3cfd-4dbe-44c1-5250-08db316aea72
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2599.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 22:05:47.4738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7xMPRAMgM5W2FRQghgdLgHwkjTjKWzuK1o54T0efragXtQHtLTU6t72p/yR/9WB1d7zFneVgbRZSaBj6FeE/Hru2oUMpBu3VKnbMMJ7fpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7096
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/29/2023 9:03 PM, Andrew Lunn wrote:
>> +static int idpf_get_link_ksettings(struct net_device *netdev,
>> +				   struct ethtool_link_ksettings *cmd)
>> +{
>> +	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
>> +
>> +	if (!vport)
>> +		return -EINVAL;
>> +
>> +	ethtool_link_ksettings_zero_link_mode(cmd, supported);
>> +	cmd->base.autoneg = AUTONEG_DISABLE;
>> +	cmd->base.port = PORT_NONE;
>> +	cmd->base.duplex = DUPLEX_FULL;
>> +	cmd->base.speed = vport->link_speed_mbps;
> 
> 
> No supported modes, yet it has a duplex and a link speed?
> 

At present, the supported modes info is not provided by the device 
control plane but we do get the info on the speed.

>> +static void idpf_recv_event_msg(struct idpf_vport *vport)
>> +{
>> +	struct virtchnl2_event *v2e = NULL;
>> +	bool link_status;
>> +	u32 event;
>> +
>> +	v2e = (struct virtchnl2_event *)vport->vc_msg;
>> +	event = le32_to_cpu(v2e->event);
>> +
>> +	switch (event) {
>> +	case VIRTCHNL2_EVENT_LINK_CHANGE:
>> +		vport->link_speed_mbps = le32_to_cpu(v2e->link_speed);
>> +		link_status = v2e->link_status;
>> +
>> +		if (vport->link_up == link_status)
>> +			break;
>> +
>> +		vport->link_up = link_status;
>> +		if (vport->state == __IDPF_VPORT_UP) {
>> +			if (vport->link_up) {
>> +				netif_carrier_on(vport->netdev);
>> +				netif_tx_start_all_queues(vport->netdev);
>> +			} else {
>> +				netif_tx_stop_all_queues(vport->netdev);
>> +				netif_carrier_off(vport->netdev);
>> +			}
>> +		}
> 
> It has a link speed even when the carrier is off? This just makes me
> think the link speed is bogus, and you would be better reporting
> DUPLEX_UNKNOWN, SPEED_UNKNOWN. Or not even implementing ksettings,
> since you don't have anything meaningful to report.
> 
> 	Andrew

You are right. When the carrier is off, the link speed should be set to 
unknown. Will fix it.

Thanks,
Pavan
