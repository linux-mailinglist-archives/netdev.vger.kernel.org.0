Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5FD5224F9
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiEJTnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiEJTne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:43:34 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBFD5AEFC
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 12:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652211811; x=1683747811;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qaKDm9Ix47IAvWRdB46aYZMpob3OXDObMdHDXqGldfY=;
  b=S6Anf1N58VZY93xoFReRSBBnAkQ3Au6f3Q1WVwS3yNqnckZAYks2wfp1
   igez3+Nm9hjbxejP0iknBvyYBugTRQkxU3HJtx9t66YlwEuYVxGoK6skQ
   8bUZ65lUWuDTQm0UbRKPWHpaNyQPvkVFwNfeBD5cPE0GhkD9WjHPDQBkK
   AJtzkSNYwT6omxcOpQxfPhXwAfTVHP5Nkj38kEgBepPphykas0jOYMdxY
   WE5BKHoZoISHT2P71oaf6rwOrnHIVqXGSPFo22dTRMLACDTHwFgvITin+
   pwLUvvb9Lj2SLSu1Al8oDeAPQD9yEK4RuElY5QVGHKis4OfgIVQzYpt3l
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="269151166"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="269151166"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 12:43:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="657798015"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 10 May 2022 12:43:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 10 May 2022 12:43:30 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 10 May 2022 12:43:30 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 10 May 2022 12:43:30 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 10 May 2022 12:43:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhWy2HJW9QJ+g5MnTAkfBcmyGyD2tk0nAx9n2EIVF8vISO+vcL6kmvTj5wp3Jfpa/EiQeC32h1ehEdk45Jwuxt/VVzlqodImnmOzbDtNMwflyzzDtbwudyZj4kBOi5VsBXaKiOuLccuzieP9fqZQfEAe3L4z/WZMEDmUJA5bs/npve7u31B9Lui12txHMoAlszwm5Bb5IvTq7vVatQ9IN9+GmUaOMxjmHkqIgpMzIJT6gpcgwPdmmJo8G69cCw9EpFKTRfWhqhCWXOMJZYz/PhqPcbn3+cAd/BMkqQcA3sAlVoFcYqRe0ev84e23y3VTdVld5iZugJsCVOhsLlO+Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0I8/c50VA5XZV1+bpLl4TGPlcHc53eB0Uyzn3/Bltn4=;
 b=ZtnxpT/A6TVB7Njvtn3n1T65OLqYDZnCBDQDpa7NcPw4C9+12A1be6hkGyjvWHHhE9JRhWbHaPrFFayxV5GikfIKrMAqP1VaejKS2qZXE48JQQF4KuqU84x4kE2BEFR7v2XWv/BsB+UHCIA+7TvI850jb3pmWQeiEkYLB8mh66ST951OTfvzj+RvNuPsloj88Pm9+9J1tp/axLRi+ltsTgYTxAQsrxl5WxvMOACXJdxOxXOuof/kQlDfzbEzqHNfmrf9AV5XafysWyv1Q8pWLJPQOwkgdrWYGHAVE18GulxAyQsSBU8+zMnOYKQNYEbJ1EnkRao0vL7YUzLbXk5hHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by SA0PR11MB4560.namprd11.prod.outlook.com (2603:10b6:806:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 19:43:28 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::2d92:b42:12d4:bd51]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::2d92:b42:12d4:bd51%6]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 19:43:28 +0000
Message-ID: <7963e252-05cb-349e-5902-c4e38f7e9405@intel.com>
Date:   Tue, 10 May 2022 12:43:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] igb_ethtool: fix efficiency issues in igb_set_eeprom
Content-Language: en-US
To:     lianglixue <lixue.liang5086@gmail.com>,
        <anthony.l.nguyen@intel.com>, <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>
CC:     lianglixue <lianglixue@greatwall.com.cn>,
        Netdev <netdev@vger.kernel.org>
References: <20220510012159.8924-1-lianglixue@greatwall.com.cn>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20220510012159.8924-1-lianglixue@greatwall.com.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0006.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::19) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1ac8660-88d7-4f21-db42-08da32bd5b06
X-MS-TrafficTypeDiagnostic: SA0PR11MB4560:EE_
X-Microsoft-Antispam-PRVS: <SA0PR11MB45601ACE3AE284FD698B54C297C99@SA0PR11MB4560.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pa2XQRaGRyp7Wds0BBi767LEcwtlz4jttAbJwjIyjZohkkbkRvxnE1GqVvxDVGakFCPHMMgTo0tXdyhpU5kA8XH3rHmZE+0RFbyZ1vV1nQMIygBh0qr8rSpgmtHltu95uSK39m3kOrmY85MXYmChAYL1ukITR18aa7NBhzH4jZbqIC0u31rSZhLOPjdVA6VPad1jlo8mZ9U3QNQ7Uyv0lle2KcBndTA/7awsO4BjlPlJAZWfV/rYJMEsn9omavV6vLojs5IjJTGBHmwZ4GRRoTaHxs0G8j5QPISrBclalq2h4vT1YuuZjjUwCwWI22F0NS1VbVjiZJJ92gQo2181cqXX6gp1/GenSvfUjRGGlcTb70KPVtRk7msZrTdxYTU/tdc0/bOSRdj9VU6iAv+d++i/tZjyirrXWjLnXyGQqFMHOIAftHI2c/rhZTrnnU3yBFt0iDK1BcNEYKp00w9JcW0bI49ShR5hVUjzvMNC2poMIAz0zoRVcqrJCNdaFxxI8jsmyaj32YYm3YR7TzhvEWCFkoGryHHluYJ12rdx2ccVJmQYVHYSKKoZwrQaDPwH6UNMrymUaNGXu8Kr8UBsw/2QSVfhgRdjX+y92z9jS+R6uNiOUtpnJFmPWMBxxZctFmp0Y/jRhpnvaggileNZ5RAgTGQJxrD/R9kQQg+89MM+sAQYq4a6TMMzqE1YN8tryIIkz3V5nFFZuiPLPQJRLyoI3F/s0HBScZo3Rvn31rNpCicFIe6b8LW0cNbsb85T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(6512007)(6486002)(66946007)(44832011)(66476007)(316002)(508600001)(86362001)(186003)(2906002)(4326008)(54906003)(8676002)(31696002)(38100700002)(2616005)(82960400001)(8936002)(6506007)(31686004)(36756003)(5660300002)(53546011)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDFUTzZqL2dodW1sNHk3QTlNZXJtMGV1N094aGM5L1Y5YXZRTVAxbzNPZUow?=
 =?utf-8?B?SHVGOTF3V3FTWFplY1JQbk84dkhmN1ovQXRUNlFhZ0UrSUZmSUtTZ1pjNWsz?=
 =?utf-8?B?UjNDTngxOGJzNmZHdVVWWTFwTmQwZEZUSFBnazcrYnFxa2xvWnlOS0lPbTVm?=
 =?utf-8?B?d1NDYlZhbkxEd0ZrNzNuSzUvSVZzSVJrend6SFpUNGtyeUFjQmhFbmQxN0l0?=
 =?utf-8?B?Z3NWSi9lVVhpYWdRU25lVlFmTEhNNkdmdWJYSVh4UkRDY29HcjRxT0dPaHl5?=
 =?utf-8?B?bDZjcWZpU0ZJSlpSWkVHYU9wamJvdm9hdkd2OG9QNVFpbnVqcmdoT1NuQVNm?=
 =?utf-8?B?emJKUEpjSGdSbU5zRWdiZXUyWG8rVXZROVBkZi9VdCtTeVNDQUFPS1VJUnFY?=
 =?utf-8?B?a1NhRjJWcHZ5RXZzYUdTSjFEVEZWa1hEUjhhYnBQVHVOczZLTUJJWkM4UnVB?=
 =?utf-8?B?UEhDbFlpVVBsUHErcGVSVzR5Ym0rMjU5bTlIQTJad2FaeFBMNWFXTzdPaWlx?=
 =?utf-8?B?Nkw3cncvVG1RdHRML2JseHIybHErTC9jenhRSitGd0kra0pWUTF6amtNdVU1?=
 =?utf-8?B?b1VjdWtSVHVnaGRBWjVLenJxVlI1ZUl5RmVpcjI1MkR5T3d2dC9BMkRiNnBz?=
 =?utf-8?B?Rm01TlM5RzJ4ZFdFY0RmVE5senB3QVZsM2l4bExWcWxibmxQcnNYL3RkUVg1?=
 =?utf-8?B?K2x6RlVadWlSSXRLeDNZTkhwZEQvUE5aaDYrZXRFOVk1QXI4Y2w1UGdjSml4?=
 =?utf-8?B?RHcreTBJbU15bkhkYS8xUHRvaHIxWG5IcGExQkJiS25scGExWlV4UHZRYnI1?=
 =?utf-8?B?VE8yYVZXYjloVytqMHkxVm9ySlBTRWdtdk1UWm0wYnZRVkd4R3ZETEZGSVRQ?=
 =?utf-8?B?VVFTcUlodXFCUlg4ZGpPTWY0amVibXlkMGVXajZtVStXUW9yK3NyRnJmalFP?=
 =?utf-8?B?QlN3ZkdydzNsbFpoSkhVUW9ZbDhOeC9mMHpZYjVmcmkvWGF2VldkSDlRYzNQ?=
 =?utf-8?B?VUdBY3NyVnhjNXRqWHpBZlFHWWpQSndNbkJnc1NGYW9oY0NWcFkvTHBwUlpZ?=
 =?utf-8?B?M3FTOEpuRHdDOFhveGhSZDBlYlZVa24zenB1eUI3cXV0MTZycFErbE9mbURh?=
 =?utf-8?B?NXo3blM1Y0Q5MXZXRmNjQmJXNFR6UFV4azczcEpvOGF4Qk1rWmd3bCsxajR3?=
 =?utf-8?B?bE9EYnZKVkY5dHJQMTZSaHhLZ2p6b2xXT0pzUjFUSDJ5eVhld0ZxR2l2V3Fu?=
 =?utf-8?B?aDFRdGJ0Z3JESmRWbi9oVGY0akNvbUkzNEJyaTUyL0hnNzkvOFI3d09Nc3Rs?=
 =?utf-8?B?K3VsMTFHUVM5QXcydHNBSGRoQkN0TXJRbEdnUVhFRzY2RHBrNU8xYUFCVGc5?=
 =?utf-8?B?eVErY3ZrRE9yVWQzanNOSXpic2p5bmE3UWxqZENZblR4cDJuY2kzMlFtUGRS?=
 =?utf-8?B?NU5Md29vV0FiTXE0RE51RE5xUkR5WHU2S2UwVmZ3UjdBSWZudTdEUDRhay9t?=
 =?utf-8?B?ZTdzdnZPYjhXZ3MvbFRZS3BzdVdHZTJuWDVGNUZqdk1HejZqc3NOaGlhcE1L?=
 =?utf-8?B?SEwwbVlGck9iQ2lMcVFWbkxnS1NGN0pLWkp1TlAwZm1SNjZnK09qSC9ENnFo?=
 =?utf-8?B?OTV1SThKYkErWGpqRmx1dUVxcmZHQUZkanAxbUlXWFgrYnJBYnlHeXJOSXZx?=
 =?utf-8?B?OTd4M3hiZzVKNStoNlZid0plMm93UlFlWjdrKzNHN0ptZGFKcUVPajFBNURj?=
 =?utf-8?B?RWZDYzZ1TjVOTmM5V0x3ckdqRjZBMnJ5L29JR09sb0xGenIwb0ovZDZneGxW?=
 =?utf-8?B?Q2xrYTVHTlpYbVI1dlJVTnpQMk44UFJETlV3cGs5TWJ5OHZyVTVING8zVmJh?=
 =?utf-8?B?eTI5VmRuVWtzKzV1bUREbjdhWm5sSGY5YmlNOTJJeEVYb016S2FObXdwd3M2?=
 =?utf-8?B?T0VyVFdIT01XSG9VQXJxNm12cjA3TzVSNWFQazNpUk03NzVaY0lob3J1dUhZ?=
 =?utf-8?B?bDZtWDlSQW9aWEhPcFVYbzhTNWtvRTU4QXcvRlJqLzBaNEtuNnU0dk9HR2gy?=
 =?utf-8?B?UjlHUWRGUTFUbGZETGhnZHJFVVhtOC9JZVNuMHJGWWM5N1h6dGZVRXJwaGR4?=
 =?utf-8?B?UHVrTHN0TG5IbFJHNmVsKzAyU0NWSUs0NDU0QTQveWJFdHVDY20xeHQ4cXhi?=
 =?utf-8?B?V0I3c0VuSHQzNTk2Y1FRMGVISURPQ29OZDN3d3poaTVBdXFSOVhWSDlLUTRQ?=
 =?utf-8?B?WmxBWHRjdnVISzZidkY2V3BRb2N5NHJFeUNaOTQzS09XVGg0Zll0bjFWYmJt?=
 =?utf-8?B?WUR5YVdzd29KblQrdWlRTUkvNi9EbUR1aDZqS2xNYnZXY1VlaXoreGUvcXdU?=
 =?utf-8?Q?DqtKi+3pjvdJWIauv24XYFVXhIVGYFL1IelbG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1ac8660-88d7-4f21-db42-08da32bd5b06
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 19:43:28.5604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: quYjq93TP9qpZXoFJiBLiQlnWwIXZfSBvfrQ1J/SbyL++9Fjao18tIVfn7eIxFsMWElSMfQddGz6K+BfHt46ahOrkzQHEUu9zMdosFdJCRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4560
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please include netdev mailing list when mailing the maintainers of netdev.

On 5/9/2022 6:21 PM, lianglixue wrote:
> Modify the value of eeprom in igb_set_eeprom. If the mac address
> of i210 is changed to illegal, then in igp_probe in the
> igb_main file, is_valid_eth_addr (netdev->dev_addr) exits
> with an error, causing the igb driver to fail to load,
> such as ethtool -E eth0 magic 0x15338086 offset 0 value 0x01.

This interface is very much equivalent to a nail and hammer, and if you 
decide to hammer the nail through your foot that's your right.

This has been this way forever (in more than just igb) and we haven't 
changed this interface to "protect" the user, so I'm really not sure 
what the value of the change is now.

> In this way, the igb driver can no longer be loaded,
> and the legal mac address cannot be recovered through ethtool;
> add is_valid_eth_addr to igb_set_eeprom to determine
> whether it is legal to rewrite, so as to avoid driver
> errors due to illegal mac addresses.
> 
> Signed-off-by: lianglixue <lianglixue@greatwall.com.cn>
> ---
>   drivers/net/ethernet/intel/igb/igb_ethtool.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index 2a5782063f4c..30554fd684db 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -798,6 +798,13 @@ static int igb_set_eeprom(struct net_device *netdev,
>   	if (eeprom->magic != (hw->vendor_id | (hw->device_id << 16)))
>   		return -EFAULT;
>   
> +	if (hw->mac.type == e1000_i210 && eeprom->offset == 0) {

before you go reading "bytes" length of bytes in the next line, you need 
to be checking the length of the write in this if as well, don't you? 
Why is this check only valid for i210? Is that the only one you know the 
eeprom format for?

> +		if (!is_valid_ether_addr(bytes)) {

this will read six bytes, but is before the length checks below.

> +			dev_err(&adapter->pdev->dev, "Invalid MAC Address for i210\n");
> +			return -EINVAL;
> +		}
> +	}
> +
>   	max_len = hw->nvm.word_size * 2;
>   
>   	first_word = eeprom->offset >> 1;

This change might still be useful, since it is obvious that several 
possible values of the first six bytes are invalid. Please respin and 
respond to the notes above.
