Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA667525347
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357007AbiELRL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356971AbiELRLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:11:12 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FAF39146;
        Thu, 12 May 2022 10:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652375471; x=1683911471;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fcdlyP2kuFpzW7hLhH+3vUlXjpccRbyNO0cjsXgGVJs=;
  b=flMQMnqeeuo3n113Y2oUmMYOCxnm5z1YRTU+JxvwHTRpN/CtkpUBUVjN
   vDFqHgNVTe7WtiRhp9XppLo0L1JcDGxjylNm/6z/IkZqtEDQdHHxmBgHO
   9m29/denpNFdzE8H4CMVuL2+B2WJlaQtCLWvXRG7wY4GsvGsPqX9lhkIr
   huY0XAnI9IuxHFln922urKj5FQOEYMQR72XdxsreppBSsE3ULEj/32kGF
   FtJFdlC+V3iyX9QWd4FecNOfmYgc3gLh7sE2I1/T1Umq63wc0puzBqGoj
   duemOR+wcXanbo92hd3KCflRFW34nksQV/ll4LN2Ij2qfGWRY4NvkoDj+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="267656796"
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="267656796"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 10:09:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="624487664"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 12 May 2022 10:09:14 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 12 May 2022 10:09:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 12 May 2022 10:09:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 12 May 2022 10:09:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 12 May 2022 10:09:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GaRl3RtrhRDeIjAxxQT3zTDm47yvSNSOglPzYa5i3QPXAAJ+jGq7Dr+LXhhmls6upfUn6whtkwntC9lRUBDxjoNSEIqGQB4MEwIdunEorSjvQfdErlMIt5K0Ga44fqXvPDezDCBe3LEr+Gl4jzfcfAZ7Ls6MBmXQdPGmgTn7E326y459zFj/MQAp1g/Evr5vZqqwhTbUuVjhjtt+u0JLLA7Oc5MpBTQlGP1AJTV+VPH6F/9VLrRzKqwPYCXTxArMbHJ6TrwngXHGgL8FGcslIIUucNRmkidGooHKcX0IZ6ytxN/7Kouv7ilUB3q9ZoX5Dkvz3PRGE9lOnBgA2Fgslw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vRqqT2wP728GnuqcYKrW7PN86wRk5EcL2IW7Vg5zbQ0=;
 b=lrCdLgXRBn11RKtmICCNQJxBypIDkd2PQyhw7ZLn02KWgfTjGUcdOQibuKxY2ForFCNCIAFcO6TL7TVGZo3iuiz0UueUZ1KKJFx0v7oLRbnye9bYcOrTQVAugxXA43tvXoH+b8OMwlZ23iYij5xD0N/7Ox0K3+SGKfun8HtsgPhmoeAbvv4PAfi13m0KYvFTOa0bxKnZ5OddanoJqiz8exhbkPqsnuaiuui0b1RJdhvvb3eO5KoN3jWlPBUGpsP4idgtCAMpg4hvi/p8BjY0D2u2bP3bHByDaRfps8T/KHgS2Gp/2ZzZzcZ6hew3Ww5e2euUCIhYqLVUXAfo3ODyLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3224.namprd11.prod.outlook.com (2603:10b6:a03:77::24)
 by MW3PR11MB4602.namprd11.prod.outlook.com (2603:10b6:303:52::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 17:09:12 +0000
Received: from BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::99e4:a24a:d119:5660]) by BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::99e4:a24a:d119:5660%7]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 17:09:12 +0000
Message-ID: <51308ed3-09c1-6bf2-190b-306abd42f3da@intel.com>
Date:   Thu, 12 May 2022 10:09:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Manual AN-37 for troublesome
 link partners for X550 SFI
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     Jeff Daly <jeffd@silicom-usa.com>,
        <intel-wired-lan@lists.osuosl.org>,
        "Skajewski, PiotrX" <piotrx.skajewski@intel.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20220316192710.9947-1-jeffd@silicom-usa.com>
 <56cd0dde-600d-1bb0-1555-e66de8c37236@intel.com>
In-Reply-To: <56cd0dde-600d-1bb0-1555-e66de8c37236@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0073.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::14) To BYAPR11MB3224.namprd11.prod.outlook.com
 (2603:10b6:a03:77::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19495779-6842-43d4-5c32-08da343a2288
X-MS-TrafficTypeDiagnostic: MW3PR11MB4602:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MW3PR11MB460299C900A8B9083CCEBDA2C6CB9@MW3PR11MB4602.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uRtWM7xUCfNIsGs1uuZWeuGcjlL2dY3WnOBeObLzOGnBsqbH5azpi4xJCqlOzXX+oCU/Qd+AuhVjaGy7R9TIrGI9Eolsnw4wWwKlm5mdI/Tpg9wRHelBQSi9GUOsMb5JvaZkBweaaq6QAGZ3IWWD8VjBVxNCsh4yCL5rY4f2ep2fPFOjLbq2AsluFkPKwc0bVDA3FWoxs1+/OZQzRIa66sfL2cy13q1d3rkO3RGcj9HMJ3wQ3wettNfp6B3ilpltatbY9bmw680L3DH0SfCTHGc92nRUckYjOgow8aT/nVhWlXvwRbbalXllQ7VMhpbvTxcXR9fOUSUjfjn6++tPDBp+ttBkAdaIhfI0PCG0tTcO+j3hhOCiVcjmiw4K3C9ymzCBJzk6iRIxFw9xhAZIj6j4OHAAHxkJUIrGEDWhTcnvmgdh0/6HA7NOtxn8UeSscdOW5zS2mWseVpf56hw793aKzLGKQxRv9mV4LfLh6yMyemIQSd+bWuKEGaaSuwauZeV5rGmhN/9Wu/PaicBNMiwcXArxve0l4VOrFp9WVp0a3xy2qb4gijoomXixyUktGA8f7TgBajsQWoYVuOJHWOiHUq/X0LWY8dceClYXjPLijEP7jOmNiD0U40kV2PBLa6HiREh+yfe1rEa0srrN8viyAurXp1vV8y8Okb9QspiryHeSHRhALRMkoIIS4LFFuuxGUf3eoUvNEZu8thcoYHxhZkYBu2yWZ7u3IDKEgjqjWxBee/IJQJzPrMXPXjdioD0ZRX6QU4+F5WJFphTE/YtrXXXp0FK/zlBxKhIKjgXDIJSpxsOhcRMR4ATAYjIt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3224.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(2616005)(6512007)(53546011)(6506007)(26005)(5660300002)(2906002)(8936002)(31686004)(36756003)(82960400001)(54906003)(66946007)(31696002)(6486002)(966005)(508600001)(66476007)(66556008)(8676002)(4326008)(110136005)(316002)(86362001)(83380400001)(186003)(38100700002)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUJ1S2d1K3ZKd3VUTk55WTBYL25qSUo2aEU3S1hnV3ROTVlVa0ovN0F0Yi81?=
 =?utf-8?B?RC91RDM3MGZXRU00TkE4ZXpPaURzL1RQNldsTVZOeEhCaW5ubTkyMmhVRjMr?=
 =?utf-8?B?aENncUQ3bGJwZStnMm9paGtNUjBjQjJMalV1MnV3MFA3UTd0WVJUU0QybFR1?=
 =?utf-8?B?ZE9PWjQ3Y3pna3g3eExaWnRHam45RlJCd0o2OEdGNnc5anEvTzkwbXMyOGtI?=
 =?utf-8?B?ZUhKZGNIb0FmWTVHY2dLdmZTMUZvMUkrRk5zM09WZjNBa21BSVJkTnBCeEpO?=
 =?utf-8?B?b3pabk84cVloemRWWFdwU1piaUVOeTdLUzhoV0tXN0xzc2ticDlrL0Q4UkdP?=
 =?utf-8?B?bDh2b2ZlZXJYVlYvbDhYcnppMzQrR21FdzRvYzIxeWk2T0FJZXJPYTFxaVBz?=
 =?utf-8?B?K1NEWnVwb3l1a0tKNHNKMHhlRE9ZY3pXTkpVTXEySy85bjlrQldxS0pUekpj?=
 =?utf-8?B?WlpUcDNGazFZTS9ieEI1dUx0eU1CYzcvQS9Wd2tkNGtTRHdCUFM5dm5Tc21t?=
 =?utf-8?B?a3pzNjQyZ01IbXhHcFY0RHk4UnFMdU9Qby82VmJudUpXbHpTa3VQT29jeGJ2?=
 =?utf-8?B?ajArc1pOK2cwNlY5dW84REx0SmZwWEYzOUJ1eGpsVWxDMTlXRVpMaEVEYUZS?=
 =?utf-8?B?dHRYeTFtSTM2aVNvQkU1bzRud1JYclhOajBHeTViRXdCNWQ5anNjWGpoeC95?=
 =?utf-8?B?MHNpeWlvYmhIN0xaVmptSjJrRnp0RGJVdUJiTVFRY1ZQeW1zR3hBQnQvNFZq?=
 =?utf-8?B?Qkh0RFJMNEJFVmloTXd6cGxLeFA0NkhDVEdVZ1paRmJ1dDBPWXpia2JBL0g3?=
 =?utf-8?B?cDh1cWEwbFRPaFFOd090ajk3MTFVdXJuYXhVYkNoVlVTb0NTeE1ZUmFYV2VD?=
 =?utf-8?B?Z2YxMHFTQllBY0VnWkhBOXBYK2hFamlPNnBITmtTUC92NTRXczF3eThZRlZs?=
 =?utf-8?B?YmpGamlqM3VnbHJ4cVNmL0NyTWlneFIyL2p5eVdoMVhnT0MzdktkWkYyRksv?=
 =?utf-8?B?bzhWYkZ2ZzlMekRtdWo3V2h4WjJBWHdtbk9XR1ZPUko5Mlh3MzlpdDVvbTAx?=
 =?utf-8?B?aS9HbjNKRTdKOE95ZHZPTDZ4eDczVjVSNmgwaW1uVXM3Wm1Gd3prREt1eWJB?=
 =?utf-8?B?QkwrTTk1eml6Q3RoekxScThadEh2b2U4MUhYUW9ncjBVcGM5VmVnTFpnSWVS?=
 =?utf-8?B?cE9uUDdDSU1QMmllTXBaOU8rS1VLNXN6SGEwZWY4cXN6bFdOZ0N1bitpWlk3?=
 =?utf-8?B?eFhlWER1cy9iK0I2RW1QZHdVV0FXQVFDQkNqWFRlS1cxS05KK1NrYmdLVVdK?=
 =?utf-8?B?VjZMMnpsZmt2TVplVytzWTNNcFJrMDJDNTQyQ1RzUGlGYWZ6UmcrTFc5N1Qx?=
 =?utf-8?B?TTB1Wmp0eUIxaUVWRWZpMDFMNVlodFR1NldVUGhqWnZnUHo3VFEzKzU0N3pX?=
 =?utf-8?B?UVkvNDg2WjZmdXdzTlhXZWl1TjZKNEZvcnBpUWY4eTRwd2NzU2pnNytLV0Ur?=
 =?utf-8?B?TjJkS1BYL29ncjYvSmRjMjlxUkFHN2hNRWI5K2NOU3p4ZUZCZkR6bFdlM1l2?=
 =?utf-8?B?MzVoUCttK0M3eEVTSFIvcVQrZGQ4WWMyeVd3MGs1YVRGaG90WFcxMjZoTmJT?=
 =?utf-8?B?K1lpb0JxWTFaU2hhRnR3dGd3R3JoZHdUZTNPUVQ1VE9IVkYrR2FPam1nd1JR?=
 =?utf-8?B?L1lyVzk3QzBVb0NET2RCMUUzZmZtVkFib1llcmZsOG1IV3FTZE95aEpmT05P?=
 =?utf-8?B?T2pGbkxUd2xuME9DSjRqVlJCRWVsQm1wTUV2NDB0REJqS3NEYUZhdUVKZ2VB?=
 =?utf-8?B?WDlpMTNkYnNlSWg5TW1SaGdIMlpSSVNyZ01JZTB5d0p4SnRzbHpLZHM0NElk?=
 =?utf-8?B?M3JGOVJxVi9EY2JISTVlTy9zRksxV254TXlLRHFHbXpRczlsV0lIck50S3Zj?=
 =?utf-8?B?WHluVkxFdWI2QVk4MmR2VW1SNDdleXdFQ1lFOHJVRWpMeGJzYVRMaU52SjQy?=
 =?utf-8?B?WS81QU13V1BnSnNHUzgxaURZMHdkV0oxRWZkWGczK2JUYXg4dHhHRndBUzRx?=
 =?utf-8?B?UFZnTE5KRHhHTHI4N1loUHRZWU9QWU4xNk9NcUp2Nk8vZTg4M0RpRzhoa1Ax?=
 =?utf-8?B?RFV1Yk1oOGVNM0dQdFc3SDR3MDE1SE56SzRYeWoraXJHQk1Pd2NTTVZEcm92?=
 =?utf-8?B?QTYwSGp1QXAwN2ZuZzV4aVlua3pSYThKOEdBWE9IUGhUaE8zY0dXemU1bXl6?=
 =?utf-8?B?SkR1d0ZOV1I1Z1dnc0pMM0RPYzR4N2U4ZCttdW5MQzB4cmZlNThNUjVhT1ZT?=
 =?utf-8?B?dXd5NHkwUWlMblQ1b0hsdmMxUHgxd0xkbEJXTm50V3hlRHl1VkRiUjlsMDhO?=
 =?utf-8?Q?eqKQRD8NXUVd0ako=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19495779-6842-43d4-5c32-08da343a2288
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3224.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 17:09:12.0174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kWnYFUG4xn6OcDjz6unlsri7mppN7VHXrfXDgWn3oIcoi6lMuEgzHeoSvK9/DtwB0ZRt66SfozcY35iaRaO9dzU7dYIBhVdQ0u6+VyJ7Ses=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4602
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2022 4:47 PM, Tony Nguyen wrote:
> 
> On 3/16/2022 12:27 PM, Jeff Daly wrote:
>> Some (Juniper MX5) SFP link partners exhibit a disinclination to
>> autonegotiate with X550 configured in SFI mode.  This patch enables
>> a manual AN-37 restart to work around the problem.
> 
> Hi Jeff,
> 
> I talked to the ixgbe team about this and we need a bit more time to 
> look this over. Will keep you updated.

Hi Jeff,

Our developer is having some issues responding to this but this patch 
look ok. However, can you please address the unneeded status 
assignments. Also, replace the magic numbers for the register writes 
with meaningful define names.

Thanks,
Tony

> 
>> Signed-off-by: Jeff Daly <jeffd@silicom-usa.com>
>> ---
>>   drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  3 ++
>>   drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 50 +++++++++++++++++++
>>   2 files changed, 53 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h 
>> b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
>> index 2647937f7f4d..dc8a259fda5f 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
>> @@ -3705,7 +3705,9 @@ struct ixgbe_info {
>>   #define IXGBE_KRM_LINK_S1(P)        ((P) ? 0x8200 : 0x4200)
>>   #define IXGBE_KRM_LINK_CTRL_1(P)    ((P) ? 0x820C : 0x420C)
>>   #define IXGBE_KRM_AN_CNTL_1(P)        ((P) ? 0x822C : 0x422C)
>> +#define IXGBE_KRM_AN_CNTL_4(P)        ((P) ? 0x8238 : 0x4238)
>>   #define IXGBE_KRM_AN_CNTL_8(P)        ((P) ? 0x8248 : 0x4248)
>> +#define IXGBE_KRM_PCS_KX_AN(P)        ((P) ? 0x9918 : 0x5918)
>>   #define IXGBE_KRM_SGMII_CTRL(P)        ((P) ? 0x82A0 : 0x42A0)
>>   #define IXGBE_KRM_LP_BASE_PAGE_HIGH(P)    ((P) ? 0x836C : 0x436C)
>>   #define IXGBE_KRM_DSP_TXFFE_STATE_4(P)    ((P) ? 0x8634 : 0x4634)
>> @@ -3715,6 +3717,7 @@ struct ixgbe_info {
>>   #define IXGBE_KRM_PMD_FLX_MASK_ST20(P)    ((P) ? 0x9054 : 0x5054)
>>   #define IXGBE_KRM_TX_COEFF_CTRL_1(P)    ((P) ? 0x9520 : 0x5520)
>>   #define IXGBE_KRM_RX_ANA_CTL(P)        ((P) ? 0x9A00 : 0x5A00)
>> +#define IXGBE_KRM_FLX_TMRS_CTRL_ST31(P)    ((P) ? 0x9180 : 0x5180)
>>   #define IXGBE_KRM_PMD_FLX_MASK_ST20_SFI_10G_DA        ~(0x3 << 20)
>>   #define IXGBE_KRM_PMD_FLX_MASK_ST20_SFI_10G_SR        BIT(20)
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c 
>> b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
>> index e4b50c7781ff..f48a422ae83f 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
>> @@ -1725,6 +1725,56 @@ static s32 ixgbe_setup_sfi_x550a(struct 
>> ixgbe_hw *hw, ixgbe_link_speed *speed)
>>                   IXGBE_KRM_PMD_FLX_MASK_ST20(hw->bus.lan_id),
>>                   IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
>> +    /* change mode enforcement rules to hybrid */
>> +    status = mac->ops.read_iosf_sb_reg(hw,
>> +                IXGBE_KRM_FLX_TMRS_CTRL_ST31(hw->bus.lan_id),
>> +                IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
>> +    reg_val |= 0x0400;
>> +
>> +    status = mac->ops.write_iosf_sb_reg(hw,
>> +                IXGBE_KRM_FLX_TMRS_CTRL_ST31(hw->bus.lan_id),
>> +                IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
> 
> I don't see a need for all the status assignments, they're not being 
> used before being overwritten.
> 
> Thanks,
> 
> Tony
> 
>> +    /* manually control the config */
>> +    status = mac->ops.read_iosf_sb_reg(hw,
>> +                IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
>> +                IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
>> +    reg_val |= 0x20002240;
>> +
>> +    status = mac->ops.write_iosf_sb_reg(hw,
>> +                IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
>> +                IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
>> +
>> +    /* move the AN base page values */
>> +    status = mac->ops.read_iosf_sb_reg(hw,
>> +                IXGBE_KRM_PCS_KX_AN(hw->bus.lan_id),
>> +                IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
>> +    reg_val |= 0x1;
>> +
>> +    status = mac->ops.write_iosf_sb_reg(hw,
>> +                IXGBE_KRM_PCS_KX_AN(hw->bus.lan_id),
>> +                IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
>> +
>> +    /* set the AN37 over CB mode */
>> +    status = mac->ops.read_iosf_sb_reg(hw,
>> +                IXGBE_KRM_AN_CNTL_4(hw->bus.lan_id),
>> +                IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
>> +    reg_val |= 0x20000000;
>> +
>> +    status = mac->ops.write_iosf_sb_reg(hw,
>> +                IXGBE_KRM_AN_CNTL_4(hw->bus.lan_id),
>> +                IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
>> +
>> +    /* restart AN manually */
>> +    status = mac->ops.read_iosf_sb_reg(hw,
>> +                IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
>> +                IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
>> +    reg_val |= IXGBE_KRM_LINK_CTRL_1_TETH_AN_RESTART;
>> +
>> +    status = mac->ops.write_iosf_sb_reg(hw,
>> +                IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
>> +                IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
>> +
>>       /* Toggle port SW reset by AN reset. */
>>       status = ixgbe_restart_an_internal_phy_x550em(hw);
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
