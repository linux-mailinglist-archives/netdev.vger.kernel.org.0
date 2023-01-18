Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AE9670FB9
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 02:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjARBOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 20:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjARBNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 20:13:39 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729F6172D;
        Tue, 17 Jan 2023 17:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674004069; x=1705540069;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HPyuCE0T2gBxkwRK4figbfMymAShggt3SC2GTYwVte4=;
  b=iheomAdNf9xXG5Bc6i8Xy9LwduvkIXpuRpG5F3TXG7DgTG3VKKox54fr
   s4v3uPNwkkcTDap+QbY5zHDoJ09zIaIF+z4kAQY62FyJe33rcnn+riFFb
   SzLC5Nlk4QAvKi8Y19uKqOVZV4nhIhvakcB5jXFhVikEqmfCA4cAJg3YL
   E/XyXQQzaGPOtay6WIa0zcfJsDwfvXKIcr7/T4B2l0MwWeRLkCUDfrNLg
   A2W2yjRQUI1LfnFpwG+ap09jE1zPdcAecV8R8CYVixrpBieOP/e9Tk1bt
   Fc6OWAVeuyxyZZiar3rxY381H30gSyJO1ylkzlf34UKK4ETIrzP/8qarz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="326139695"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326139695"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 17:07:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="801976036"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="801976036"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 17 Jan 2023 17:07:47 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 17:07:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 17:07:47 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 17:07:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PrbvlqMiNGO9JTNMKfpwlUokZHdheARjA2qsdoqFxoWhjxGpxd0shp+4g6Vc59I4Tykqd384/w6t/25GgAdU9n9zslAvJY0vWzvd6s9tPpUIT/N40bZ0FNd6nnpCKPgtoLAYI34CFRcaR2Eix1Bt0/S3U4qxYK7UXyfhk5yaarXEdR+L42feU5OFziMrR2FZm8jguy6ene5W3FfQJxCrNVev9/qOMME5mbq1lXk4jjAA8kddqjBN9oaBLOuv4kgc9fWhWwavwn46oGmbiq3RUsxUfXVTjy3FlhsEFzLY8Dozn4/EJLSQO90QZBT9l0UgOPf4WeJwJMJQOM4r/bic6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/ILd8whqQdCsUIYHRzf7xRZ8uQfenpZn+fEPODU+T0=;
 b=Wl2LHRxIPzBUgOU+IOFp354QKkGGzMIas/xLtdS7mzNtQiT3iE5XC18hkVMWverZwg8U1bQHdvBB6NpV9rb62kdPPeklB6UqmHQ1skYAx79+cYsVpSgNmLf7f3d/ysj4HH/S4RuW0efNZxeRLlr8G0Ljv1aRfx8TxKHWbi0QITVLqrib3QY08MGP0IkY/3j92SRV1KivkrnxBzJs7oBTBJVvIw/qhc/ZbIJFLOLqXYG6kAEn//6qKXYTu3l+AJ34GRWIaSA77y5dm2n43CdJncNqMKBYqnzCuk/Se6jkKe6Yaw1uvwBgiBDSsqmVKUevuccouoPXbUgJpG8MYm8qsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by BY1PR11MB8126.namprd11.prod.outlook.com (2603:10b6:a03:52e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 01:07:45 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e%6]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 01:07:45 +0000
Message-ID: <5d3d42ba-c25a-acfd-e271-003e86b290d6@intel.com>
Date:   Tue, 17 Jan 2023 17:07:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 4/6] net: mdio: scan bus based on bus
 capabilities for C22 and C45
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Joel Stanley" <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-aspeed@lists.ozlabs.org>, Andrew Lunn <andrew@lunn.ch>
References: <20230116-net-next-remove-probe-capabilities-v1-0-5aa29738a023@walle.cc>
 <20230116-net-next-remove-probe-capabilities-v1-4-5aa29738a023@walle.cc>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230116-net-next-remove-probe-capabilities-v1-4-5aa29738a023@walle.cc>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::33) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|BY1PR11MB8126:EE_
X-MS-Office365-Filtering-Correlation-Id: 32eface0-a37a-4774-5672-08daf8f0685c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T9I/sR5A/dDralJxXzL7u21RmBuCLFNao+L60rMSKqOK9KPNisI7EjBj9VYdG8/4jq5MNd+/RVSREWJ8k9fA4xLpXseBWsrCXlQbq1hc3PfDaf9WvhLwD5mvjfRNjtSAkdpk5WjUu0yp5HKizYcXayDaDlK5E7FRP50OueR+EJUBA9skrJ6hNsi/qGz2jskW+iorIt+PHSiDTKGihBGEyRmeU1MNx51POGqe4rsj8UBL+EHJvQNkrbbUSqu3OmdER/XiC1eiwv7GctQ5QKL2qESMGbqhRpPgWk9ajitxDWnJdobu5AaO0+dqSr8HgGDuF6KNj6mhT3MOZORXrCI5T3CSXVpEryj/LQrh7Dic2eOHaQENXH65KSVmBizJRBGXd6A/oE0fNwWE+eQgQou3FA9BfVURmOE6huELVVIWIaFrrfx8TBLWud3khhjLS7yoT7P/DTuvIXzKMlGrfVvV7LQlK9Kr0I6G825OdkegOdaGeE62sE6akzALyFmYS9VLPhO4pkSRY6BUxd8defMU6rEqhbh9vpiqeuBISt1Gzxhh9qUf5trZVluGuycCrF26sQYBnHg0KUnySRD3IeG89/4G3yFbE0l8MtI7RJ6LTu3FeKBGKpGvOrr6glzs/vkNA64ypZjJxfC5VdMVUUxbfiGsRxJR0904cAm+lgV5wPJggu2KXC4cnF6TwY+lkgpplQ/45kI2PzwUwDyyQzfjiLkZHVcC3b4ApGchqCqrpQ7kQZSO1o2rJxBP1Pn4pQvH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(38100700002)(66476007)(921005)(4326008)(82960400001)(7416002)(4744005)(66556008)(86362001)(31696002)(2906002)(44832011)(8676002)(8936002)(5660300002)(66946007)(6506007)(53546011)(186003)(6512007)(2616005)(26005)(6666004)(6486002)(478600001)(316002)(41300700001)(110136005)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3lLSzhCYXdqajd0Z0YreDRtZXlvb005ZHJSTXF5Y0t1TTBrSGFQM1NlZEV0?=
 =?utf-8?B?UFgzdVlPM0lJb1R0ZFU3Z0VPNkszeDV5TGZwWTBTVVk5NEIvbnRWS014dHZV?=
 =?utf-8?B?dVRaT1hmd1J6bmRUK1RRaGx1MEtENkRZcld4ZkdyMnp2a0tRLzA4MVFocWVk?=
 =?utf-8?B?bkhGRHM1NG0rZmlJcTNuOEFrSWJFOFlvZlhnNVc2Qm5JanUxdk5HUjZEWHpN?=
 =?utf-8?B?Y2FiU2FzNjRhMUovMHZ1Mk5XTkhIdVBSTzVkMHl0cXp5QllDVXp0Ty9VVC9r?=
 =?utf-8?B?eEl2ZUNxa3o2MHdGQkF6cHp4MzNOVUxyaTN3OEFjdUdsWHJLNjhZbGF6RUxu?=
 =?utf-8?B?SnFldG5HaDJ1SzhkclBSQzJjVHFWaWJXTW5ONjNvSCtkMzJLMHRKWW5MRXRZ?=
 =?utf-8?B?ZGt2L0pRYUZ2MzNLNzNSUW1jUXZSSEpieGxGdWY2Wkpmdmt4dWFsNlVkdmUz?=
 =?utf-8?B?ZmE2bEg1U0hiVzExK2E3QVJtOEdwZm0rMlNZK05XM2FkMWp0T0M2azNJNTRx?=
 =?utf-8?B?R29pRjhVdHJhWXMzb0I3OHY5K3VFeDdFOE1COTRKN2VYR2ZINkpQaGxjTytP?=
 =?utf-8?B?OUFTeWpGUXkvYkNKQlZsZWR4YVViM0J6WFpJRjhQNlJhaVhiOFJRdmR2azFn?=
 =?utf-8?B?d1hSVnRVUTZsaE9acm9SOEo0dVk2UGdMR0srMnlmdkFtUWpNbEV2VUVxak9i?=
 =?utf-8?B?VmpWcWNkWWoxQ0pmTXA2WkdpRjVTMkxPU3Z2VWVMNnZpZUFUSkpLNnYwejFC?=
 =?utf-8?B?NWhCbkNZZmJsSU9iV0tnMlRacUZuZkROTEJZVklpbGJrL0g5czQxMmZXODZJ?=
 =?utf-8?B?RklVT0w0VlhIcWorV2ppTmRxUnRNR2VxdmFvMGxicWQzWHNLVXdTQXJiRlJq?=
 =?utf-8?B?aEZic3B5TjJ5alJxclJKcWNubko4NStDdEk4NW5pTS9ORG1qM2crdXZJZVJB?=
 =?utf-8?B?UHlITHB5VWZ1a2dXU0dvOUF5S3k0cktNOHo2YTZZcGcvSkQwSTB3NDFUUmRO?=
 =?utf-8?B?T21xRm53S3BQZFlUeXBJekpWNkZkZHRQZTRDWjdjWkViSy9VcVlLblpZSWpz?=
 =?utf-8?B?MkRUOXFrSlZzV2toRExCL05JSXFxdkhIaUE5WkxWWk1JTDB3a2hFRjlxRElW?=
 =?utf-8?B?dUtjRmdTckdRYUdjeDFKUEtHSmxWdmI2SkIwY3ZSUVoxc1VuOG5Ed1JVd0M2?=
 =?utf-8?B?enVRMDkxTmxhNG1JM1dydHkrOGNpeEx5MjZka2s5d3Y0OW4zOWpTRGxoZWRJ?=
 =?utf-8?B?TVZNekpGQXF4a3dXYXFVcWduWkZxWERURmlGSkhUUlRBUFUzd3ppNEorZVEv?=
 =?utf-8?B?alIxd000WitWVUxJWjBZbmpjamhzaDJtak5hM0pwRXovZThIcXFncjVYQXpr?=
 =?utf-8?B?YXNvZkt1V1oxeTBpTEd1VXVvdUptVHlZRklkUTRMaWs3UUVCSE8vcStqZzZz?=
 =?utf-8?B?bkpHMC9EVElHQVplSytKNk9ZLzIwcGZBMWpRZ053WE5hemNjNzNiTVIzbFpr?=
 =?utf-8?B?a3ZNR3JUUzFlTHlaZytvZGF4dUs1ZmhNMFNPNlI5SU41bFhTWjRxakxQUkU1?=
 =?utf-8?B?QnNKczgrdENyVWNBWTZTK21aaldlSThhRFkwRXBNMk1QMUx1cnZMS0EvelFx?=
 =?utf-8?B?aEt3b3lZbHNpT0tlVURmbmRRUUYrVHJ0QnhDY2NBQ2xHeUNDemo4dWUyUEli?=
 =?utf-8?B?ellqR3ZCcnRNOXdlSEVRNU5SSGdlSmR3bDY0S0czazh1QmVhamFJeWlPVU4z?=
 =?utf-8?B?Sm5iaVZDRllKVkF4V0QvVTErTGJlb0lHNUgwVFZUK1ByNEE2L0lKVkdsdHky?=
 =?utf-8?B?b2YwNExCU0EyYnhzTlloL3JpSnZPRHA4K1FwUUwzakNpVE1VUFFMaWNwY2JG?=
 =?utf-8?B?RzNuMTM1M3c5V3hYbTkyU096S0l0enJTdEwrUTRPclF1NkpiNzk5eHdmVVZp?=
 =?utf-8?B?YU5Sc1JPUnVCWjBzcVA1Y1BoMEZ0YlVvSmduWGgvbk9oOHFKVnBRMVF1OWQ3?=
 =?utf-8?B?MDlBVklSWHQwUmJVZ1VKamdvVFcwY1ptNFdlZGFnejdBdE9MWW1SS1VNR2x4?=
 =?utf-8?B?N2YxVDNKYlpxR0Uzc29aUjVaV3NScVlDeXdQUVpWQldlVFFhdmZOQmJ1dmhC?=
 =?utf-8?B?TTMwVWIrVnFacExycjhPWTNyZEh2dnlWNzMzYWdYN2JLS1hXWGE0bHByeWlE?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 32eface0-a37a-4774-5672-08daf8f0685c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 01:07:45.4942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gq+g7zFS7trZ1SRcMti2c8fZBUdUNoGTszanDRM+kx8gofW4/E9RwPAMOuYiV3ROtRZk0TBsxcy4lGqJcrlEnlpthstt8LeNLQ2KMAFR23A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8126
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/2023 4:55 AM, Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Now that all MDIO bus drivers which set probe_capabilities to
> MDIOBUS_C22_C45 have been converted to use the name API for C45
> transactions, perform the scanning of the bus based on which methods
> the bus provides.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>

Nice, cleanup is looking much better

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


