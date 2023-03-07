Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9406C6AF5F0
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbjCGTls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbjCGTlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:41:07 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C01A2274;
        Tue,  7 Mar 2023 11:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678217312; x=1709753312;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IXRi/zhaL0xkvww4GcHYrWpoOGckjLxs/218XqiIj/A=;
  b=Z4IIywUUzbC13R3nCEIxHxGMy1wC6+mt5uNW5dVt0dB+yepbeZpUDnfC
   0vlsdUTm82uJQlSkls+zXL2C3T9tc86Nv7LUV6JoMjNZyL2Q+aIVRoTU7
   DWK2yDdzT/JuBOiS5KgJFNUJr+tatI/1D2vf42DQO8bcx29xZbxWenfmu
   aHCuFfsE5ANwrh4AQ/ZKuBbrBbLl7EtI42hhdppswV/s9ptpeEyJEgwyL
   4hqd9v7Dc1qB9L1Tz5pkmnUdmfpiJQxANRn/VvviWkofrjrI1vZXoY2BP
   iEU+PMAmQicyXkk7S+CBcIWl+dJj89qBYoPGImv+hKs9KC47W/Ixt8Asd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="316351199"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="316351199"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 11:28:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="626659078"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="626659078"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 07 Mar 2023 11:28:30 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 11:28:30 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 11:28:29 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 11:28:29 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 11:28:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcV7bUpQwkHF36N6J0Jv+D/i7vGSd4cy+JFoQ8EaBerzlc2tZv2OOvBaHADCEEeai5H1Xf9Je6P3WITxYXaDlI8TqwWwgp74h7np+P2epuo+b3pnQ4rf8fCEX3MVZNuIXT2ZhGjUHh8sRdFVwH6F292mkP7FB7AHwhBp2tdcX5Jkw9n4zUy6biDzh4P2dwk7dPGwo3uapG7t6dOGxlQY7lnf5k5yCtd/Z37Ut/N9sJv8pbfDLzL/+gvoVRzecbss3ujLvzrS+/lfQgfAvsBdWlqushfapT0wiFSlv4hbCbCqWObzPbz/zgcdSvZapDCUQQtYhZzKw7lS4NvKrBe29Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jpHUFoPmYRbKDYy0T5I3ALcU/gc+5k1Rr/4sD54bmqo=;
 b=lzFlOyzP/4O1LzpkRFQO0T/flNR0G11yoaON42qXIkjDPerQL8mpU6LxRDjqpbhnK9cm1AKm272intAmZzTvvkq9JqFnWcCGutn2eYGB2a/+BFm95CSaNAb5Di4Ped+6bNTFBunAmOcm61IA8CQS8zMPzlQ7a+Vz2JF5OCOsLLN0LrHc0NwAtSIwgjsg4lgGoFiHyp55ayoZAvVCJ6eDmv/M7OAxGYabIfr5ODkaQejXidR2D9oMYbN3y6eH21n91bovNK31V3Z9NLMKIbOj0UPguDQ/me6EDiC3zTvTmv+g59+eM+++oi6HdvTk4sE4Of7l8D6j9Q/OI5MRK0tFgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by SA3PR11MB8003.namprd11.prod.outlook.com (2603:10b6:806:2f7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 19:28:27 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c2c3:34a1:b4cd:b162]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c2c3:34a1:b4cd:b162%7]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 19:28:27 +0000
Message-ID: <8d328bae-6363-952f-3324-84d000fb2328@intel.com>
Date:   Tue, 7 Mar 2023 11:28:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 00/28] PCI/AER: Remove redundant Device Control Error
 Reporting Enable
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        "Ajit Khaparde" <ajit.khaparde@broadcom.com>,
        Ariel Elior <aelior@marvell.com>,
        Chris Snook <chris.snook@gmail.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>,
        Manish Chopra <manishc@marvell.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Mengyuan Lou <mengyuanlou@net-swift.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Rahul Verma <rahulv@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasesh Mody <rmody@marvell.com>,
        "Salil Mehta" <salil.mehta@huawei.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        "Somnath Kotur" <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veerasenareddy Burru <vburru@marvell.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        <GR-Linux-NIC-Dev@marvell.com>, <intel-wired-lan@lists.osuosl.org>
References: <20230307181940.868828-1-helgaas@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230307181940.868828-1-helgaas@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0075.namprd05.prod.outlook.com
 (2603:10b6:a03:332::20) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|SA3PR11MB8003:EE_
X-MS-Office365-Filtering-Correlation-Id: 34971bf2-0658-45ec-dc22-08db1f422006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2lriVrwvyi2Y6CsMMC3G3wL258tnokug8BuuZ1iFKwC6r9omaopuO2KpU0qJN8Y+IczeCtsKpGdNPfBarpQgFC0GjXg5HXyEU9RGaT9n53Ip4NyImAavqmVhdqzT/6F6TEVFQWz6sFclQRd+z7Ylu7PCjGp6tnDfEXS5hwL6Ftcx3pDjyOsnsRp5wXWQ13mgNbJuj68bzTng++d0dxYZl50gzV0VkwlMoxkuw05g+yRC1wxsG7v7aZK1O8skRnpHhsBI1mXK+1FtzMbiQYwzCflQETCCUEUPc/jhdYr7FjUQjiaisBPiG4UxWHUW8s3TxRYzK5va35BDQkrBIkTgh9ri8LIAuTCnjbgSbLqtizuUWLotXTXB7XV540BDH+Rjc0+Q+Zbbf/VPDHo1xbhz8j5jLz9JgOesaRXjreKrktNMXSJu8bG60tbEaBxz1fh4qPFOOtbBPb2xb60D8Ft9JMYPTUalnG8Rom7PFYwvq+xqbcmb93opEJgS66h8n+Wm8neQ0sxlmMr4jX1Zce9D5gc8RT97bXfLO2QNa9L9etBpDPC8TbSaLUNNDO4RFxZ3pagIGc78is6919nu6NW8BQtGYy/iilDpuRejRzltohtk8bF7Q+HANbTP4KB5KPD5Z2Rouko/cVrmnc53AsHez/uMyGaaVHvb1BHPto1yEAdg6AMgH6yS4heQTsbG4/WZLaFN6V0sAYxHrrws4yvsjRZfRR77ajZ0BQ8hLno+sbI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199018)(2906002)(38100700002)(186003)(26005)(82960400001)(6506007)(53546011)(6512007)(2616005)(31686004)(44832011)(6666004)(4744005)(66946007)(8936002)(7406005)(66476007)(66556008)(478600001)(5660300002)(6486002)(7416002)(41300700001)(31696002)(110136005)(8676002)(316002)(4326008)(36756003)(86362001)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzllMklucHJ5Yzc3WG0xMHYxbGJBMHJUeXljWnBhdFhBQks5WGx4VmtGczM2?=
 =?utf-8?B?S2JXQXR0VEhjWmhvMnM2aEt3S0pMdVZqVklwQU1FN2FWUGlSS1dya3oyVzkz?=
 =?utf-8?B?M2laOUpPTFdMRkYrUzRZVVRIVHVqclVUWTIxdlNXZk9kL2pzTnpqRVJnajJF?=
 =?utf-8?B?Mk9DbEpUMTducENDNVhTYjV6WlJrRmg1NVIwQXhBZ01DZTBYUDJDZkJhZDhj?=
 =?utf-8?B?eWVlODBLVnQybnVLclJnU25kYXNhVkplNmpieEZtMis1TndmZzk1d1R5Zzdi?=
 =?utf-8?B?S2FaenhaMjdXeFpVMmNJVjVKK3U0UEVTWkFIV3Z3OUFxMXd1amJEeUZXWEVL?=
 =?utf-8?B?eVFHRG5yODZrTFdzMURzMEhRR29NZ2JDbC9CSXRXMzgxb3Zlcm0zOE84SjlD?=
 =?utf-8?B?cGtRYjh1REErVzltSXhtQnJZaXZHZUhZQ01mQzA5Z2t5MHQybmlRSjRQN2Ey?=
 =?utf-8?B?bDNwNGJOKzQ1UVByVkdUQ3JieExDZHptV1BXNTZ0QUdvV3hNZnRubys3UEtq?=
 =?utf-8?B?RjJEL0duM2dpa0VmSU9lbERiTXBwOG9EUXFTbUVuc093cEQ4RGpna2dxM0o3?=
 =?utf-8?B?czFMZzJ6NVRwWk1JM0g0ekdENSs5RjJWSy9wOUFVbHRYOXdDOXhUQ2orTW5l?=
 =?utf-8?B?VjQxb0tPYlNydXhobTVwQVdqZHVlc1JyVDZpOWc5Q3F0WjVrUXlUWEJtajJu?=
 =?utf-8?B?WFE4QmVVVmJ1VmdlaUIwb0VLZlozSWEwVjI5ZVkza01IRE9yYUFZOXdTZUo2?=
 =?utf-8?B?MVdmTHpqSVNxd0JUZm9KYitkSms4VTJLYlZoSTlPN0lYN1hKUmxkR1prZFFU?=
 =?utf-8?B?MEEzNVh2TFh4Qko2OTExK3J3eE5jc2RSamE5SlgrRXMzRFJBR1BhTk1MQVRn?=
 =?utf-8?B?ajU5QVhDVDZDRlRCT2VmbVA2c3c4QitSZ0pQUjlpa1d3aEQrR2daVk5Vcnl4?=
 =?utf-8?B?Q3g0VlBtSVd2d0VBK05LTkVPandiRStabDhxVEc3aE1BZFl2MWJrcHVYS2Fw?=
 =?utf-8?B?ODFSVXZBSjR0QzZSYU9IWFZva2NINjJodkhVclVxdk5UVG14VEl3QjB2Z2tw?=
 =?utf-8?B?eWl6NDdWaXRSN0pJeXRyNzl6V3NRWGFqdzNIT1VRSlhRdjZrQ2trUTdQbHg3?=
 =?utf-8?B?UENNWEZpVTlLN1NxYjIySlBSajFkL01wS1l6UjBXbDBTOFdHMm1idEllSkJI?=
 =?utf-8?B?MVkwNURTRXoyQTNURFIxYjk0YUQ2bENDUXRaWG4yeTNJTko5cVRIZ0VMMzdh?=
 =?utf-8?B?MmZGdVhkNUFYRHBVUUwvWFN4Sk1idHovKzQ2akYrQUhtSVU5bUlwV3JlT3JP?=
 =?utf-8?B?NHFUNElvMm9zUDBZbXV0eGlHVGlLamFuTVVhWlNUbnNGVU1mYXpiRmFMZ2R2?=
 =?utf-8?B?dXB2WnVtaS9uaWJFWlB3Smg3NzlFQ2pJbXRtZmowMi9mQ1V1ak96TW1uR2ZE?=
 =?utf-8?B?eCtNTFF2ZjhBaCtSUnIxaGh6REVkam1tM0lJTjVpY1ExRk1oUTNVb0tDay9S?=
 =?utf-8?B?UGJnU2dabWRLek9MWFpINDJMbHFOZmlLcFNlbFhFd1E3KzNNN1lSTlNWWElp?=
 =?utf-8?B?R3VKcTFXendTMzd2TGEyT2V2VFFEQ0crV2JYaTloUVRjbmdtd3JtSUhzdkZI?=
 =?utf-8?B?NnRpSittOW4rOVdpVWoxVjFjNXdYaG1KbHAxOFdYSUdOTW9rOFFtTmhDZU8x?=
 =?utf-8?B?c09IQytnZ2p5SXpIdDI3VE5CU0RMQW9mUzVvd3pmUkhINDBJWVlVWGlPYXZQ?=
 =?utf-8?B?ZlNNUFo1MHBBQzlqYjVlWWVXLzJuMndyTHczM0hFWERkWEgzK0t1RnZDZjU1?=
 =?utf-8?B?SmliK2N1NVF5YStBVG9Wb0ZwbGdvMEtRMEhJUVFvWTNNY28vMU5RRlZqNlZ2?=
 =?utf-8?B?NGw4T1Jycm82a3o1bk5QOCs4ZlM0bzdoRTNjZk9VM0pXNUxPSG8zQUk0c251?=
 =?utf-8?B?WUg5ajJGZ0tNWjlWaThjeTN1WjhneDNqVDFmMkNJdDJJYVlnMmRIbnlnakZN?=
 =?utf-8?B?YXIrSU1ibURyemVOeTNvbWhrb0NCOXFTYUVqaUlWYWJsQzNaekk4YzBEQ293?=
 =?utf-8?B?aHk2Wkk4YmFtL2l5Z3ZCdFE0NXl5cncxOUJwdWRNMTJCTkdxL2s4Z2YzVVBX?=
 =?utf-8?B?L3VzMjVqd1RFKzJJTTVpMmdXOHYxdFJJb2dDNEdkdlpzQlZwRlhuM0VSSTFr?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34971bf2-0658-45ec-dc22-08db1f422006
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 19:28:27.1179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LxReCQfBSEK6gEOhBvWTgqDWbGIVZMyZEVyQdptPlzolafA2Ova3nA6phs1T/rIqELK3H+3NaSO68n899V2nFETJimwWTKDjBz2yKy5PGi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8003
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/2023 10:19 AM, Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is native"),
> which appeared in v6.0, the PCI core has enabled PCIe error reporting for
> all devices during enumeration.
> 
> Remove driver code to do this and remove unnecessary includes of
> <linux/aer.h> from several other drivers.
> 
> Intel folks, sorry that I missed removing the <linux/aer.h> includes in the
> first series.

For the Intel Drivers:
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


