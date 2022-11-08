Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198AE6219BF
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 17:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbiKHQtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 11:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbiKHQtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 11:49:12 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1567756572
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 08:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667926152; x=1699462152;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b1g6RdFwdojuxufbkdSNtLmzdzvNRKXeSDk4SPFQ86A=;
  b=eK0UHZPZMrVV3qUD+fvMnVe9IJzVLPnbuUM0/btMeropaquQ4dhkuLLE
   a3bC1ELpgimvU5VmvMR7xES4qziY3l25CBLW49p4XNfi1moBbdJirBx2d
   auakLqgkdJ8YrdtlpfCwnZemGfyC3b7PAxtWecmjXvv7b8HdmJXOaUutU
   9jsCG0dQdK377/wghIeUvWdlB9f8Fqc7YsIboQLRgq346zK7LaHlzkxTo
   h4Agwlq/srjGoYc+cq6mtWc373UokuhLKHRYha0Td/AQoSBtKb3tTGop1
   2HvNMv10I4O1DwhF8sIXrGYGqlDWWntt44+qw8saYEuTFLdv6og2T3lAO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="309454101"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="309454101"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 08:49:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="705365557"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="705365557"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 08 Nov 2022 08:48:57 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 08:48:56 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 08:48:56 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 08:48:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZYCdPQlfPan7vXM8vstCkkVTDn76ovEX8Vqz51FwyvELMxi1tCWrnMbUbRhtAf/zkseMKnajm6IA3pmsoUgIWo9YEG37dV72+mMIuxw/l+Ko3xsCWb5pKi45fwUZRZv7s3/v2GjbG9S35JuTTJWTxrvUGctfxEAICTQeAmXJtorwAdHttVQun4PMuKFDyds4peS6Q6p6gUd6anOTylDzpWsKg6Vnv4S+YET+t8foWNtmpXs5D3NMIi+SCFnD4RTcMpu2kCsx4TaUy7ulVPgAnhZsTOVfSJoocbWqJuzdf6Uh8w9hnMg0ET9y5YJuMH6yomPZ+Wm4n+UIdq8aHj5aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dCe/4XgadpDnoKzW69qYIdnQhwz9rvUA+g5qZJ399HE=;
 b=I+0aJU5fYrxQLpBu+gC+Dnx5jg6aM8MPX/IqFGDx/wRvcHR8zC1kOxJdLpKFANjEkOEMv0kDaKovtJZ6FRom7XZZSuetLz3JYT2APmuymMe/bT+cNbVxmcD/3IsXO43XztX3Qb3v/bs3woEw6duatusnRy2lg/mqEwYYX3yXVPNbj1R2cyCunKLp5R5mvnDXkPLWHUry/iVRX7X3X2yJGMR66anqPJgPWEDL+7fhENYmKFjmGjFPEtnITHXszYxB6UzflnO5P4L/bdg/pcnv1yS3a+IE4STFNTbZEnTxIKgvOcpzZOyM0OQqAePKBJWpRLPsv/mCiVkCUaRn6xNGAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY8PR11MB7010.namprd11.prod.outlook.com (2603:10b6:930:56::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 16:48:54 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 16:48:54 +0000
Message-ID: <cfaddfeb-7159-98e4-f6c1-ae18e4ed31e1@intel.com>
Date:   Tue, 8 Nov 2022 08:48:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next v9 1/9] devlink: Introduce new attribute
 'tx_priority' to devlink-rate
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Michal Wilczynski <michal.wilczynski@intel.com>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>,
        <anthony.l.nguyen@intel.com>, <ecree.xilinx@gmail.com>,
        <jiri@resnulli.us>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
 <20221104143102.1120076-2-michal.wilczynski@intel.com>
 <20221104191021.588acef2@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221104191021.588acef2@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:a03:338::23) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CY8PR11MB7010:EE_
X-MS-Office365-Filtering-Correlation-Id: 06340b3f-d2cb-4542-fd6f-08dac1a91f59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TE2LD7WHjIe21+8XtmhZrHsVkPNH0w4ztEeXq81XQZ+2uGbQU3Wyg99WW8V2qNwsXma+UbI/ezd7wG0PStOkvAUIqg27TQgD6xdtJmzh4/4toBfB5QFZmRTfYyHVDBWdApn+JaXD7bTMzjscUwW2bYhbRdWDx08mUldy8oZzEvJyDi5oa1iXpbD2rJEscfl1WoRVRiNOsjCJdhwKqXWe39OLukgy/IOgxaewYK/EE3cvhGdQsWCyPEM24EKvpwEWJqqelCv+IydLiHOf/QDF7KwKeGWE8Ij+z6sdmMR6HKY31oG9oJvIZ+ZaB+cE43C7NivbSTtV+w52vwHLEALhT0uXbLkXiu/HfkGi8BujyMRLkZbBPqB8Vd4T7I2YwMtfwb4AbssQ5Hm2IlQYYbJmPIeuXYjhw1BRuOElh6oEu/TUStJpGBRjL5AvIJA0eQ2iPUI6gAyb7chwlQtBzDL0xKGCPeJOENHDl7mILmoB0+1FfOXGJN3/drdNho6SOfQGLg6/HlkzUMzw9r6P3AbygRAwvusn7dIXo6F400n4nF87boqGiswOblZRpGsyd3wRw8cZTP+16Dsy9H3GSNT5yyUHYqRdtKqPQkUlSzHnKHYbZ6wM3Wp6eBBhTc9BGEgwcJYBxtvisnEwgh2aOLdzA0oiJLPWlHKg6LiXBZ5rnO71+GJPEqvrypNb3fjg4Pf5xvra8MQICz8mUt3AKFH+E7A4mPq++64434ohZHsPibpIenU95QrK/zijtt9/rcmZlzNEtBH7QSLUGu0uKvYDgpdVhaX2HOQByBDxr2doEv0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(31686004)(6666004)(6486002)(66476007)(53546011)(478600001)(4744005)(2906002)(82960400001)(38100700002)(36756003)(31696002)(86362001)(26005)(6512007)(2616005)(5660300002)(186003)(66946007)(66556008)(8936002)(6636002)(8676002)(316002)(6506007)(110136005)(41300700001)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djVWbE04c1dNN2d4eGdvSTdzQ3hJbHBMUS9uMHNXWEVCcmVLWWsyUjEyMFJv?=
 =?utf-8?B?cFFjWExsSGR5U2dHajdCQkdDYW9tRW8zaHFPVmRaNG81dVZhWFFacXJlLzMw?=
 =?utf-8?B?UHpRN1oyR2JMOVhZYkRYR1NtNjBucDFuUWxhV2dvY000VVYyQ1NqeVJzSWtM?=
 =?utf-8?B?UEhmdGNCZDVua0o2Y2kyRUpPcGtGeWdaLzhybFJQSHhldGVjdnpDNGhzS3VZ?=
 =?utf-8?B?SUpLNTJiYWlyeDdSRzE5WGlVNE84aHFoQXBtN3NhajVZVUdzcmpRZEtseVRO?=
 =?utf-8?B?bVNkUDZ2MTBIeWlkR1RNTUhCYWZ6WE8wcnRDdFdaMFZDMHNwZ204KzJtdm9E?=
 =?utf-8?B?cEZVc0I4eUU0M3RzQi9SYTgyNit0U0pjV1BKYTNGMC9lRDNCRjkwdnIyckhY?=
 =?utf-8?B?VmN0ZUZMSXBIV05KS0lVV3N5TG9NenhxWWhQRnVQZ0cyNmN4RzRHV0FEWWxy?=
 =?utf-8?B?UU51clJieFUxR3YvY0tTRUVERTlOTndpNVFkbTVNYlVTMTlkK3YwSCtaeXpp?=
 =?utf-8?B?bm91b3JXZzFLaERnbTlLVUQxMWJLbWg3dlc5Y2lxWnRKanpDcEhlK0ovT3Fh?=
 =?utf-8?B?Y2tyN2JzQ2RzMHNNN0gzMk5ZZEhPb3h4VkxJS3M3OUZSN3ZpU1VWZHdPNjdV?=
 =?utf-8?B?K004am43b1B2Z1FoZ0xSK29QaGhSMEZ3dWN4dU1WQUhFODV5dVhXNEZJblox?=
 =?utf-8?B?VjRvMzY3UitBbmdjL2pvOEsxOTBPZ04vUjZ1Z2VRSUYyd3Y3VCtjeWZEendJ?=
 =?utf-8?B?U1U0ZUVsV0RXb3pvMDRPNWdHWlNFOEMvTnNnbzJ6b2pNNURuWWxBYWxtaFBP?=
 =?utf-8?B?dWhIL1BqWUJzamFoRVpaTUZSYUtoNXArSUxxZUtZeFgvdXdRVUFqT1hLUEZ3?=
 =?utf-8?B?dXNDTnZaZWFhYUFxRmRBZkJxT3pZbFgrVnBobEpmd1BtTGFMZzdQVEVqR1pY?=
 =?utf-8?B?WW55SWcwRXgyOWxWVVVxUldIb1VDTlJCN2VhcFlPK3U1ZmxIakFVdGZYOVNw?=
 =?utf-8?B?UjZvVUZRbVViakNpeXpIRjg3bHdYREk1ME5OdkxzVXYyUnZBVG0vOW8yVk8v?=
 =?utf-8?B?bnlIZ1E4aG9LaGpGWTlNWTRzRnc0bFFKa1lxVEprazdoQkNWOVRpdHZUSEJ3?=
 =?utf-8?B?V3N1ZHZEWUNFbXB3RlNrVUdJWmxWZFJ5SkdBK2pQYksrekdOdjlDUU9rK0E5?=
 =?utf-8?B?WThqQlEwbVpFNlBrVGRGOUpTbDgwMFFZNjdLUXovNjB2Rkd5NzQvVXNaK3Va?=
 =?utf-8?B?R0cxTnIyaEdtM3lGdnlZWWR0b1Bxcmt6cVZUUHo1UmszeWxCU2JObHJtcmdG?=
 =?utf-8?B?ZXoxSGthdVZHUVZiZkcySUxUc2EwSUplRnVacENZa2w5ZFN4ck16dk5zYTlX?=
 =?utf-8?B?Rll1eWd4Y1NlRDdrOFBRUkpscldiSUpIQklpYnlIbDdXR0NvaCtsdDFoTVBx?=
 =?utf-8?B?bTVFVWZnRTRobFdRWWlIclI2cVVQd0lCRHBTRWNTQ1E3QVZsTHhBZTEwVVBY?=
 =?utf-8?B?RGxlOUROTDBUNEVOTXk4ZDFOKy90TkYxZGltb1lxK0dIK3pvVXNFbUJnbS94?=
 =?utf-8?B?em1uK1Vhb2ZQNlN1M1dLMUJTSzY3ZWtiaVp4OFF6M29xb0JOREI3Y0F5MjBa?=
 =?utf-8?B?RTRzYUZoVWZ6ZU8xQjVmVFFGQjBRUkpQQXVNWE5CeVJtY0tRT2EyeTRlQWdl?=
 =?utf-8?B?WGRsamx0Y25YN2ZNdnEyZExVVU9IOHJNWHcrVHlNcW9xUGRvV2hOVVdGNHVN?=
 =?utf-8?B?NDRpcFF1RzlTUnQvdlNNWUhCUnJGbndzT2JqVjBVcmlUZE9udmwrSmsrSGxI?=
 =?utf-8?B?QkN6NFh2WXJOcmFKaGZoV0JsNmxKbEcxOXRqNmt0WmZ6bzg2RHlqekNET01Q?=
 =?utf-8?B?SDVmUElnYVlOemFuQlZnd2t0MFJEalYzSmdxaExka0RmaEdUQ1lwb3VzRVNX?=
 =?utf-8?B?VXNGdVVTdjk2TytEMkliaGxkdFc5Tlk0Yk9hS0FmajZucDRONVdmNjNzc2NW?=
 =?utf-8?B?SjUxY3VyeVcxTWpWRjl4L1NTbVFiOWtPTHBKdXU2Q2pCaUZpcUpPcUEwRThH?=
 =?utf-8?B?b2lmVUpKSVcxSThseGxnUWpqdllOdm5MSUJrMW5oR0JKcFlIMnNWTkYvcmJY?=
 =?utf-8?B?QUY2Rk5jZGZ3QkljYS9UckRDcXJvNFY4M0xLRWp1UXlRTnJuaklZRU0wVEgr?=
 =?utf-8?B?dkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06340b3f-d2cb-4542-fd6f-08dac1a91f59
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 16:48:54.6908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17ItSbuUcIPkjGx5sxzsZxiIciwPf5d2Bzn3iBmXY2KELNz7qMRrknlvTQ6GadVYfnbRZ4RFsRsX0dGLtUVgT2PnSvj0GJn/1J5Xa+COLHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7010
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/2022 7:10 PM, Jakub Kicinski wrote:
> On Fri,  4 Nov 2022 15:30:54 +0100 Michal Wilczynski wrote:
>> +		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_leaf_tx_priority_set) {
>> +			NL_SET_ERR_MSG_MOD(info->extack,
>> +					   "TX priority set isn't supported for the leafs");
> 
> Please point to the attribute - NL_SET_ERR_MSG_ATTR().
> 
> I'm not entirely sure why we keep slapping the _MOD() on the extacks,
> but if you care to keep that you may need to add the _MOD flavor of
> the above.

_MOD is useful in driver code because it will indicate that it came from 
a given driver module, but I don't think its useful in the core devlink 
or other networking files.
