Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA3966203C
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbjAIIl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236586AbjAIIlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:41:07 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D907BE00
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 00:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673253662; x=1704789662;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hWjsBI0jGWU+1/SeaavzLROwDETl3Zitx/4Zl7sXWVk=;
  b=Asu5I/LRMfXcWvVdZZpxxcKNmcTobVkEM3LB3McHIDauC4L+iV4/2jO3
   Ck0nxI/4B9t8E6lMjtrACcvdRPpNIoVZhK7y847GLBm3xlOdFsnW6wnRN
   rZ5FA9VNcvX/lYw7MbtWcCvsjPjMoas8JPHhSmdoAMWxqBcnG4ZJO9bYn
   yqqLemxzHwCD9E0TGxziluao+urQzPLs1zfXkHSMOwPVcxPOWT8BNqtiA
   Bkw8NfB/+L6G/5+e+o6OiT9MSs+M/0IKUe4NcOGDAM9MerjCznI3+6tst
   lsNR0CHMTjyEYXGqFoRFezr2pNh4U45QkDQjbggNAZWPHEX4NAtFxRI0h
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="306345081"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="306345081"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 00:40:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="725093872"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="725093872"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jan 2023 00:40:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 00:40:59 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 00:40:59 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 00:40:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kw2C/Mk96ZFZQSNxoOEOjaEZoP2lVNnoZKGHGpy2GfmwbUdXUzXZZlZZ+tSrivo385cBo6qUfcKT5fcVP67zBCmwphaYxLELd9veOLRGstuwnZG+vU0o3uMTLIaL6WWWwTgzQLWQpeXX6nffCqCjl1x48GvEMU4zCZ5fl/+mYbrKR49bmMKWurnL9wu6q6Qm/tK+1pbApgyyYHXjadJvwUxx+KuvSHoYnjUs8ermRrmVyaVToZiQaWg+219AV0q7fsdS1BoXWVIWpZnMf44AowbdxCk7Rf5e8ULySLZOmLm11WaIvI0Gz1WQeHaq1FR3grBhFxYHwAZbj0eW0qe78A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNfnYMhgmBuM3uWjOoqC+/WCBqZffK+nYXHLttg8mUY=;
 b=WmiyvKenZCPHtDCYCak+RttkM5mIeeN+kTFC+8MOoPdK68VZmBXAazc4CKvN4mmCr0SoL803hlsHvzw5zUaYv1m1ikMrv3YBkoqo22FPO1hTRMKBocrPgRGzJAZX31gS8+vJ4S1AUh6jzFtbCoVBgpzkDHfIZSyXhy7ASUyU0KSgJIMKk9ZfYUMgvq6m2jjXPiSDcTDEUpsDPR/u7sWB4r7mHGF6uGLYFh8Xn5UVN6zdhYMdUcz/GQAZp/YQ0f3GXsR/sUf6l+foqKLhD5TcQGIX1hLK055mkYBY7Da22oOYJlDRGxzZcsZYPdUPdWbrxIlf5bVLxFIkzrHjW3XfnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6738.namprd11.prod.outlook.com (2603:10b6:303:20c::13)
 by SA2PR11MB5147.namprd11.prod.outlook.com (2603:10b6:806:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 08:40:55 +0000
Received: from MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::7c7c:f50a:e5bc:2bfb]) by MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::7c7c:f50a:e5bc:2bfb%5]) with mapi id 15.20.5944.019; Mon, 9 Jan 2023
 08:40:55 +0000
Message-ID: <e2aca2a1-f472-5fca-c091-7a489a55cc86@intel.com>
Date:   Mon, 9 Jan 2023 10:40:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 1/1] e1000e: Enable Link Partner Advertised
 Support
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Jamie Gloudon <jamie.gloudon@gmx.fr>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, Naama Meir <naamax.meir@linux.intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>
References: <20230103230653.1102544-1-anthony.l.nguyen@intel.com>
 <Y7TMhVy5CdqqysRb@lunn.ch> <Y7U/4Q0QKtkuexLu@gmx.fr>
 <Y7W66ZstaAb9kIDe@lunn.ch>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
In-Reply-To: <Y7W66ZstaAb9kIDe@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0129.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::16) To MW4PR11MB6738.namprd11.prod.outlook.com
 (2603:10b6:303:20c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6738:EE_|SA2PR11MB5147:EE_
X-MS-Office365-Filtering-Correlation-Id: 410a1a49-7b1b-4baf-12b0-08daf21d3912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RrvKvfs8BWQy0qCy7RpIPfv4Y5HOJPEFP6UqW3hVO3eWRpgARjklQruyiLpvez/uUP1mDs16Q0Xo6MqcuSRJ+Ni6jz2SvZOaf9VnqR2G+09g+lIFzzUzt6M0Z1pSgMwhti6VVg3KermKA73cNlLIBwsax5bvfXZgdFYh9xShCz8yfaU958Qi4etglHt5edptrdQqax9tBfYpcrkigGW7JdDf+6HANnzLktdPDDZYEPsSM/X9RvOHr9v94Kg+0p9kdCppUDBTJQmZ4zb2Ep6rVZqqZK/6LtSaj+HFbSW1I/+5jOjcWVbbcCCo5AZmHzFFIgUEDO4sY8jVE8HwgFZW/GHeiDnRMV5tp5xTFtkVmqW8MV+R6xSerjrY1jXhRT8C1x7jUwIbfATdt3WagpMIPDgn7n3BcSKohIIveeLWdO2FUJOlSr1gViP4M/mYwz9XoETiC6ZrYKRtMAVj1qz9wpGTKw1Ut33jy7c6KUnd6CCyCXzGd67bWo7Me8jTGJHGP4FvPKfDg61oEo6iR3wzifFuygaiDJ2lepVbYlvPdX20dNPCrkX85K/wjERVqXElcSCd4dwwK2gqUbej3AniO4Mf+2HFf2+NULvquvRQkMB8xs2LPY6LjdRlh24Q0n6moZdk6lnHfVpqZ83BHUhG2Khocuaq7HmffxoZoZ7uoszMzadm60UpN5vmgTUTyB0+zCIQt86gR/RQzaEUlYxFqIHA4Zm/AxGtyNAJ8fUlWFcBVKxb192vF60RhcVPPFHF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6738.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199015)(8676002)(4326008)(316002)(66946007)(66476007)(66556008)(110136005)(54906003)(4744005)(2906002)(5660300002)(8936002)(41300700001)(86362001)(36756003)(31696002)(53546011)(6666004)(6506007)(966005)(82960400001)(6486002)(478600001)(38100700002)(2616005)(186003)(26005)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkxqeC90RmozRi9YTkdzRThoeDFmSS9GaHF2bnY0Mll5aXhYczF1WWVGTVRw?=
 =?utf-8?B?U2N5eWV4SXZwbzVQWmhQdmFDSExOMGRPQmcxaG1NZ0FtblVuOW1xbE5IV09w?=
 =?utf-8?B?TGUvNU15czdKRTJHUG5nUTA4ZGhYclRLN1lxbnQ5WUR5aUROdVFJU1p3MUl2?=
 =?utf-8?B?ZThtRys1WmJZS25jVnZaQjZlbDQ4WThNd2NORVE0alQ2aDhvL1pnbVlDR1ln?=
 =?utf-8?B?YWpnSjNPQkN3UHdFV0RzZUJsN3FTQVBkS3lqM0xyTGdjaUE0a2g0aEs4QkZJ?=
 =?utf-8?B?dXU5Vk8rNWtiUTN1V2JlS0tSbWZ4SzJJS2k0VTZSajR0NkNITlcvckw1ZFpJ?=
 =?utf-8?B?SGQwVVNIVG9ZeGxIRFBycXFpT1o3cUZzQU9KeXdiMHRFaWxmTVkzWlBMald3?=
 =?utf-8?B?OUZhUG5EVDVDOVZCRlFLU2IwbzEvSkRoN1pYMEJwQTFlZkpOaVBaenJzd3dM?=
 =?utf-8?B?YTVOams4aTN6ZVhjWXNuRWtNeXdVNDNPMUxLRWVHS085NHFsTmFodWl1cGJE?=
 =?utf-8?B?TUk5ZE9EM1hWNkNGckU1RFJRQS9OMDVWU3VPOHBQWlB5VjhUUWRRSTRJVWQ2?=
 =?utf-8?B?Zzc2QmtuN1ZNR1Z4TU00dlVBc3hKdlVwN3llbnFWV2k5STkxRFA2aXczK2dD?=
 =?utf-8?B?Z0hTRDVSTlQ0N2FCOXZ4c2Z6Sm44OGsrNWZKM1NTN1MzSmtEdEZpb0liM0RF?=
 =?utf-8?B?enBTQzhCM09SalFBeFJwYVlsT1lueUN3cGtxMC85a0xHMDVoRGN3dlFyY3lC?=
 =?utf-8?B?OVptNXJkbzFWQmxsY0J4YmNnbWJuakJuSEprQnVrV0RJa2JyTjJnNGsrZU5r?=
 =?utf-8?B?TnZYMHJGOCtEYzRObkcwdG11RFhtVWpCRldVQnJEeVRrU2lFeHlZYXQyakhR?=
 =?utf-8?B?eDRvMmpsRUVzclFkUTJERDNaa290S0h2c0c4dk5aSUtBY0hrQnJ0MWVKMXFh?=
 =?utf-8?B?ZlE4c3pMbyt3SFFWZ3BuQ2F0czY0KzJFUHp6UkgyWGZac2dnY1dtblR3MW5u?=
 =?utf-8?B?cy9NMGdwZFJ6bXlyV1RibVZKVFRxQTJjNHNPeUw5MDhIekVZditnbVdEcyts?=
 =?utf-8?B?Ti9WdDZlR0dvZ3J0STQ3WGNQZUtjVTRvZExsVjZjRXhoNFpzTXkzWEZpY2J6?=
 =?utf-8?B?eHluNUtuejZwaEw2K2lINkxybFNYcHo4NmZEWEE4cTAxbmhoZ3YvT000NzhX?=
 =?utf-8?B?eDRWZnlvZmE1RXB6YkZWSElhUWlLMDNNd3dlQUpnenNTTWpTL3BaOW42NUpK?=
 =?utf-8?B?Qzdhcmt4QW1OSkVKa0E3RGdyZUMxUjNvZXhXYnZockFTVG95SnlKeG90RHVo?=
 =?utf-8?B?Q0VWV3pmaXgwb000SVkyaXVvRCtxbTU2YUhTbTRtVU1rLzJCU1k1UDZtWnE1?=
 =?utf-8?B?UkFVbFVlY3lLUnB4SmFVcCs2bXFVZEQrUTFEdlliS1luL2pMN0wwN2diWEtv?=
 =?utf-8?B?UnRCcFB5QytVZ3N3L0JscWZTZExvTmZPb0FPK2txVldZd3Z2eWdidnUrNlZH?=
 =?utf-8?B?a1Y4UVltN2V5ckcyeTVsRUZidlBsNWxqeW9LbmxJVktjQ3hvV2grVVFlQ3hQ?=
 =?utf-8?B?L2tHRjhhb1RaNFZmcmdZWHNkM1pKeFVSQUpGdTh5WWM2d29qS0hBY1N6ZUdv?=
 =?utf-8?B?RzRyU1RnNW82R3dMcDhkYkJGdFgwd1IvWUNiVmxzL3A3Vzd3YTVJaytvR3JH?=
 =?utf-8?B?VlRiYUZhWFd3ZFp3a0NJY1J3QWpaS0gwQjgwSTJrQjFUbHB4bHl3eDA3UW5L?=
 =?utf-8?B?VEk0VXNJZ3ZUK2VSMDRsc0k3cW42L254US8rejhMYlZXemE3TEtKY3Z2VDIz?=
 =?utf-8?B?cHpkS0J5bWN0dG4vbDRTblFvVTNhME8yb3ZxWktuK1V5SldXUmJHVVkrQ2dt?=
 =?utf-8?B?ZVFnMHhWeU9VWVQ0T3REUUpXVzZ3clF1VmhJc1ArYXFSNXFpbHl2NDNYamtP?=
 =?utf-8?B?MHdmREV4Y0F3UmczUklzS1ltREFBRXQxN1pkYkxkcWJPQ205SnhMb1Y1cnZJ?=
 =?utf-8?B?RGZ0eVF5WWZKQWNvOXV4dHRyWHBtczRoclFJU1IyNURKNkYxNzBTZ0hqRmE5?=
 =?utf-8?B?TlJ4MFpJRFM1VkF3YmkrbkRweXg5NGl0ME0xamRWNURVRVRNSTVVcFdYU0Ri?=
 =?utf-8?B?bWNNVVhsZk1RWVJXbU9NYm5kaFZISWxCRGxLNTNjTDFrc0gwcis3YXRVREFB?=
 =?utf-8?B?UUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 410a1a49-7b1b-4baf-12b0-08daf21d3912
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6738.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 08:40:55.4441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qdF8kFzgzRBDBAYYsNhtu/cp+XS4Z8Vh6spiHprvnt8BR++S0XS44gr9bBvxDZzmGW+y0IxhWFTIiW19J5Uzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5147
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/4/2023 19:44, Andrew Lunn wrote:
>>> I don't know this driver at all. What i don't see anywhere here is
>>> using the results of the pause auto-neg. Is there some code somewhere
>>> that looks at the local and link peer advertising values and runs a
>>> resolve algorithm to determine what pause should be used, and program
>>> it into the MAC?
>>>
>>>      Andrew
>> This is a old patch i had laying around, If i remember correctly, phy->autoneg_advertised plugs in "Link partner
>> advertised pause frame use link" line in ethtool everytime the nic renegotiate.
> 
> Hi Jamie
> 
> Could you point me at the code which interprets the results of the
> auto neg and configures the MAC for the correct pause.
probably you look at  e1000e_config_fc_after_link_up method
(this is very legacy code 
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/intel/e1000e/mac.c#L1001)
I've no objection to this patch - should show link partner advertisements.
> 
> Thanks
> 	Andrew

