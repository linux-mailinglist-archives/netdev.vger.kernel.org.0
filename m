Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4E66F210D
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 00:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346868AbjD1WxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 18:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjD1WxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 18:53:10 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA7F3584
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 15:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682722389; x=1714258389;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6HJb7PzU1oeXIAkfalIO+E0NzZHvB1dAFb1gjqh6g14=;
  b=W2Jea4gUefY/GVxCcCvee/aDrhaneXCa6I+sFnulo6seCrkBjR3jB4wD
   2rqUC0/MpGb+QIkyE1rZUhJoS+2IoYeH08nyXhEj1IQ4x14d+9N73Ui+r
   GWJXjImrsVU9gL4utFUOSaVtIGif0QiAVHJv+B1JHI9Ur+s8iseu8/iVV
   JKOCGgxw/07+rRF/Mb2QhjpDSXuf4dwOLkg4W0snhuxxk7kDE7Z/XjkBv
   V5zT/Z0VOD3zwYk/q+FflxnoCtYYqKKUHj3i6ffoLBbCQZ6XvPi3FnxG0
   PxO4uJk+L+zVoa7NRaOTrzp0Y/4DAPOwHRrj4flKYTMyACuRuHWhCseA+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="349906989"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="349906989"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 15:53:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="727693260"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="727693260"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 28 Apr 2023 15:53:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 15:53:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 15:53:05 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 15:53:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSBCB5Blaj8VOM+ADRDObjTrMSvzRNoCm96AALjGBEY+hIOxmiBibCzne/UMk2xr7IzJWP9i8ebidc19vyP1/ofQEEf2OhnGtk6alEp0Nic7QxWCKWULWW6U4iP2k3F4hV7eN3c2IqfZs5hN7NdFBkBxa++24xdOkJGwqL9u+9bHGbKYVxve2NTjoDVz7vjtgK/oZyT11112OznCXtx8q7FEinlo4C58sthXLS9ID2xvB5LrCfftK/jeNLyA8+UIeC5//Sp9uo0qSzHKIjd8byy1zdhztWGYf6322/3MI7t/dfK4TDlkQxZSKxM82KiDAHLw0dD430LVenXpxHWTHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i9Ajn8xKFmrYkkpZZQOCfZdDa+5XlVNojZy8C7Na7Zw=;
 b=T+GdztAW56kJPGiJhfclSr82c5KusgtEGzLiAAO+4ib0DsSqtr9VyqETYw6HOj8wrV/Lo/RSOL40C7eKPqRI/73zrMbO0ipITO0kVDYMXAwYjiEnsC6jfTsr0FMQQAQ9GfIresvc/ECaLDsgIAheNkgPc0TrVM8p4Iq9iuC6/dl+Bao8kgPxI4JPa7ghxOHSwRSpaN4NY0wVS6BMiVOSzeQw9DPXob3/drzUANo8beBXYkLioIA71LvPrp4VXF4a9DriLV18QfYGOuEsMaURYinfL/zyZKBpY2q+fRRpfjR4MF/AZps7qLE6JtFboEvk/DBJlemvsZ77yDkoX2yRoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB4893.namprd11.prod.outlook.com (2603:10b6:a03:2ac::17)
 by MW3PR11MB4746.namprd11.prod.outlook.com (2603:10b6:303:5f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.24; Fri, 28 Apr
 2023 22:52:56 +0000
Received: from SJ0PR11MB4893.namprd11.prod.outlook.com
 ([fe80::8da5:1406:4bce:1b77]) by SJ0PR11MB4893.namprd11.prod.outlook.com
 ([fe80::8da5:1406:4bce:1b77%4]) with mapi id 15.20.6340.021; Fri, 28 Apr 2023
 22:52:56 +0000
Message-ID: <e7cdeea9-0ee4-7d08-f13b-e8afe13095a7@intel.com>
Date:   Fri, 28 Apr 2023 17:52:53 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH RFC net-next 0/2] pds_core: add switchdev and tc for vlan
 offload
Content-Language: en-US
To:     Shannon Nelson <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <netdev@vger.kernel.org>
CC:     <drivers@pensando.io>
References: <20230427164546.31296-1-shannon.nelson@amd.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20230427164546.31296-1-shannon.nelson@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0027.namprd04.prod.outlook.com
 (2603:10b6:a03:217::32) To SJ0PR11MB4893.namprd11.prod.outlook.com
 (2603:10b6:a03:2ac::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4893:EE_|MW3PR11MB4746:EE_
X-MS-Office365-Filtering-Correlation-Id: b19c31df-e0f0-4a45-6e1b-08db483b4e7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2txI51xRmPgc4+4i29BRMuRpvjFPAq5XD6de+yB+/93eaoG3t2wzkFad3DlzPPv0e7MijFfvoQsKimklX42l5B8WUSTXpuIZdan9+RJ1OSCFVPgkHF0iaZaqrYYloymknuvOgcp0w3TT7tGRw+jtQ6cF2/ST/sXRsqXgGOqJnN5m0uIgJUong/aQncxWrg8nK3YpvLSihr5SVBS/8f2LjLAPExkXEwgQ+yPfA90gzpFm58McYAcwrnGli7xGKAIqyzRgBAu3M/bKPbUkPk/10KISrYR2ptlY3RPCPftS8jo2rx0YZX1YyQ1d4T9gcSW8cZeCLbCLDtcnyWKpe87U9ecb2Io6Tt8Ai0WGAivMS50/40KtE7f7nj9wquqVvbxFHM0eKgLrYNAA7w/denOmqZiy1Fgp3xwOYQgWeEx7Wy/hPZlFggEXRJUCi8YFSJIw2vrS1bNepph1iAPiFCp0NV3fSiI5RtFl4ODDq7jWFIOVVOAqSQ+tEesy4uwOCgpNkqG4NG2xp5lJu+Azv3+eE7Q1g4X/HiRbCRb5SWUidFBZTo0+Q80tC71yL7zNUCe5zCsIJ1UTTr8fPydc1PvI7I0/c+J1F07i/aZXZgSjevQ2t4L50JkZnqiIXbAVduhR7CWZCZiaEkor/f7bVHdxnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4893.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199021)(26005)(186003)(6512007)(6506007)(53546011)(41300700001)(6486002)(6666004)(966005)(83380400001)(31686004)(2616005)(66899021)(478600001)(38100700002)(66476007)(66946007)(66556008)(82960400001)(4326008)(316002)(5660300002)(36756003)(31696002)(86362001)(2906002)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUZ5blZRRzd4ZnFoUmtwMDZBWCtUQi9NY3ZDYWFJcFJKSWFkencyWlN6Ymh4?=
 =?utf-8?B?WWQ3OTNOY0czV01LaW5kZUdpd0ZZRDIrUDJXOXZLcFlJdG0zdUFpcjI2WlZX?=
 =?utf-8?B?QnZjWTJMOHJHYVJUT21OS3FTRUpvQ2YwSlpoTSt0ZDk2bjIwT1RFQmw0VUFu?=
 =?utf-8?B?U2xBcDBJYUJwRjM4azAyTFhaWmlzbVhoWnNxVkxEa2RmZCtxVXlTZ29zcXQr?=
 =?utf-8?B?UmI0QlJYSVJDYzhJWk5qMkZoeEtRcCtLU3F3VTBQTkd1L3prbkx0bWhOZHpD?=
 =?utf-8?B?M21WRGI5NjFaTURPYTRJNEZaSUlzM3BkSHFzT1p1Yko2eEZ4NnR5a3krWnVV?=
 =?utf-8?B?WTArREVMVXUzN3pvaXFyRFdjMm5WNS9kQVpIRkFYUWlOazNoc3RZdjZiSG5v?=
 =?utf-8?B?MitScjNmaFk5WmdySDZNWUhGK0prZWFhL0ZxbG9KRFl5YktQdHpvVG9YUXlz?=
 =?utf-8?B?TVRjTlVFMU5VbklraWtFRDFteVZaRnBzQUtqMUVsZHZ3TkRCY1RFUlRsejNS?=
 =?utf-8?B?dk5pZVZlQnRmMDVKRTFvOHQvSFlKL1h6d0d4U1M0K2dhMFVTdkFaMkllTjJ6?=
 =?utf-8?B?bnk1cGtPTXhsVGlGRGN4WHhpd1lEQ0RaN2NuaDBuR2FjOGxWUUpLS1Rtci9C?=
 =?utf-8?B?YkJ4MEFESkh6MUJyV2NuSnVFTEw3cWZWMFZFOVJML0hDNEsxN2wrM0luS3E4?=
 =?utf-8?B?WVNlZzdhejVKMzhEMGRlcmFQWmlrQ0lQcnVTdG54R1QzUjFaM2IxS3BqWHd4?=
 =?utf-8?B?aG9aeWZEQ3JkKy8vTSt4dDcwK043Q2tIQWVsT0FQTTJtYjZncGZPMkNMUjBT?=
 =?utf-8?B?S3ZuamxEZVF5bUJpQ2xWM1duaFlqR2x0OURZckF5VXVCTUV4dU5sa2pTSEEy?=
 =?utf-8?B?Y2pHSlBlZDRFcXRrU0YrMFdFczIwdEVaZ1ZkOVNTVWtZM01IWWxiME1TSysy?=
 =?utf-8?B?NG82L25STktOOWZlYWhVd2hoRFZwZ3M2MnRBa241NStWR3ZKZDlXZDhXTUlj?=
 =?utf-8?B?Mzc4OEthQ0h1OGVOMEZKbmxXSXNFRGVQRW1ncXJ1WWxUOUhCcHBZTWZwYmp2?=
 =?utf-8?B?SDFydGRlemhGU0VoQVpOUE9tMUxvRTUrUlpSc1dPenBDTHRJaldqM2tVSTYy?=
 =?utf-8?B?bVhCTVFyNWtvV0tBYUpKY1dkUTdhY2g0UGw0NVZhcWtaaCtaQmxncmZpQXlR?=
 =?utf-8?B?dFUxK2JaS3NmUkoxNHJDSTlhV2FtNzV1RXVGemxYSHFQNFhqbEd4Z29wcE02?=
 =?utf-8?B?NENGWGVtaTEzVzhreER0YVdNbE5IUGVBV2orQWE5WTNkK2V6VEZ3SE1ad3NI?=
 =?utf-8?B?ZlVtRExoNk1VQys0WWtGZnFyODZKTmVsa0pTNGxiMWZnUWRIVTRIdC9pRHNz?=
 =?utf-8?B?TEd0NXlNRDdXQ0tvcUpxdDRpa0dKWFBlR0g3eEk3VERaaWUwMU5vWjFCejlD?=
 =?utf-8?B?ZlUwZHYwVTJLMDNqM1ZZRGNhVjhzeHkxT013anZZR2NuRFJzVXJkbDh1Y2F0?=
 =?utf-8?B?SG12Wk4yRmNjSHBicmYzQisxUmdvQ3ZLWDRZZjlNUEZPUFJjUDZQS3B5QkdQ?=
 =?utf-8?B?R21DMyt2aTFiWHg4dFBSdzIzb0QyRVAwZjV2NkRYbFU0ZnpQNTd0NUl4R1Z2?=
 =?utf-8?B?a1ZqSzA4c3drWmhXS0l4SkU0VndRczYzVHc3bnl4L3JtdUc3OXcvVFJYNngw?=
 =?utf-8?B?ZEtEY0cvZjFhc0VpUG00SnljRzVHNG1QaWVoY3NZVnVVQlZ4UU5rQWxkMnQx?=
 =?utf-8?B?cnFUaDg5Ym9FbUZEWVBSMkY2UDNsLytwdWtHRW5Gays0T0NHQUF3SDVxR3JS?=
 =?utf-8?B?Zmt0OXA2cEhXZE5ocFdSRVV4TkN0bWlZL0x0SXQ1WUtOUzI3MExWS0lnc2F6?=
 =?utf-8?B?NUJxa2p4YlRFT1A4NFJRNUt3N3BpQXNPTU9LVnFUR04rNk1xQ2w4TFZuVFVU?=
 =?utf-8?B?a01ObmlXRUwwQUwwdUptN0NwSjYyTFRkUVpCcnZtT1R2SldaYkJIMTFrcUNy?=
 =?utf-8?B?alJLYkoxbkUramRYVUw5ZjNzK3RVM0ZaL0ZPUjJXakhJRFowTUYwL3pGZk11?=
 =?utf-8?B?WmZldWpVVDg4Z0NxMEdEZ1E4cDFhU0t4N2lPUFpNemlIYUVWTTA2a0hwZThv?=
 =?utf-8?B?dlpEcDRZdWhNeE1FbUxLc2JwYU1pMWZlUWVOVG9nU0VXbFVrY2kxZTVCT3JY?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b19c31df-e0f0-4a45-6e1b-08db483b4e7d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4893.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 22:52:56.1549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jwUR55QWWvyCjNcXDZRNtQJC2ka+OOF1SNxkn217lfRWSf8+MgX0QVDpI9QDTgpgaKfe/2y7Q7QokXAXmyVCWVT5mIEfvfr7iG5H61cQTTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4746
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/27/2023 11:45 AM, Shannon Nelson wrote:
> This is an RFC for adding to the pds_core driver some very simple support
> for VF representors and a tc command for offloading VF port vlans.
> 
> The problem to solve is how to request that a NIC do the push/pop of port
> vlans on a VF.  The initial pds_core patchset[0] included this support
> through the legacy ip-link methods with a PF netdev that had no datapath,
> simply existing to enable commands such as
>      ip link set <pf> vf <vfid> vlan <vid>
> This was soundly squashed with a request to create proper VF representors.
> The pds_core driver has since been reworked and merged without this feature.
> 
> This pair of patches is a first attempt at adding support for a simple
> VF representor and tc offload which I've been tinkering with off and
> on over the last few weeks.  I will acknowledge that we have no proper
> filtering offload language in our firmware's adminq interface yet.
> This has been mentioned internally and is a "future project" with no
> actual schedule yet.  Given that, I have worked here with what I have,
> using the existing vf_setattr function.
> 
> An alternative that later occured to me is to make this a "devlink port
> function" thing, similar to the existing port mac.  This would have the
> benefit of using a familiar concept from and similar single command as
> the legacy method, would allow early port setup as with setting the mac
> and other port features, and would not need to create a lot of mostly
> empty netdevs for the VF representors.  I don't know if this would then
> lead to adding "trust" and "spoofcheck" as well, but I'm not aware of any
> other solutions for them, either.  This also might make more sense for
> devices that don't end up as user network interfaces, such as a virtio
> block device that runs over ethernet on the back end.  I don't have RFC
> code for this idea, but thought I would toss it out for discussion -
> I didn't see any previous related discussion in a (rather quick) search.
> 
> I welcome your comments and suggestions.

Adding a tc rule doesn't seem to be the right interface to
configure port-vlan for all packets sent/received on a port.
tc would be appropriate if we want to do push/pop vlan on certain flows.

   bridge vlan add dev $VF_REP vid 200 pvid untagged master
would be a better option. This may require adding vf reps to a bridge
and enable vlan_filtering on the bridge. The driver needs to register
for SWITCHDEV_PORT_OBJ_ADD events.

Extending devlink port function to support port-vlan similar to setting 
a mac address also looks like a good option without the requirement of
having to add port reps to a bridge.

> 
> Thanks,
> sln
> 
> [0]: https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/
> 
> Shannon Nelson (2):
>    pds_core: netdev representors for each VF
>    pds_core: tc command handling for vlan push-pop
> 
>   drivers/net/ethernet/amd/pds_core/Makefile |   1 +
>   drivers/net/ethernet/amd/pds_core/core.h   |  12 +
>   drivers/net/ethernet/amd/pds_core/main.c   |  28 +-
>   drivers/net/ethernet/amd/pds_core/rep.c    | 322 +++++++++++++++++++++
>   4 files changed, 361 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/net/ethernet/amd/pds_core/rep.c
> 
