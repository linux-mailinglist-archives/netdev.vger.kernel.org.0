Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6805A67A5B4
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 23:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbjAXW2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 17:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjAXW2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 17:28:51 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6E71BFD
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 14:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674599330; x=1706135330;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qZlqHa1cl1Ozis5Kql8lZAagN7snKLMF49JT+Bh+los=;
  b=OvziquKlyvn4xaFgPLDYMmbzcMmoU+WiU8qMyskPmvDkzVqT8m/bdOsY
   nPEpYKMx1FpeMzewSI8BkihGIutdGPI4lVWFL82D8ffu+kn+gZ6tSM5p2
   qxrOr7YZd3r8Y0m0NRSwcrrTWDN9PyuXx5nZ8iF2323aPcKrzfHtV4meD
   py+vOAj11NpaKo6Y21uFyo82rMITyje3KghBVbW+m1eLor+6U/yFXKU1Y
   iSp1XCVivr88vY3s7aFzAnXwYCHbcsHiiiiczfZT+3f9Dox4ZSOEcpSYb
   O1zMqS2XXNQtjoM9RizU9+iDXuLIdel6/HLEpbwaUg41YJFKk6SwMRxFq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="326459644"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="326459644"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 14:28:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="655590699"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="655590699"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 24 Jan 2023 14:28:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 14:28:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 14:28:48 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 14:28:48 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 24 Jan 2023 14:28:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q98yVsUvukWBok4oJ2XkASrTJF3kAymd1ZcnCLIdUq9V0m+j+9czMUzsWns0ioVtHaQW4P4lH7Azh2eJDuvXpA3Pdv2wPK9o8IROvghUtmqL1Q4tQKdbtTcPDOLhRRlH4YS5QdVevPcXrAGcr8lUBYApRaK8WCqstvCHec1rQCmlZ6CV0DonwWrHcxJv2mjMQUaLvlvYLM+CCPIbuluyOdP6cx22nbPtMDds+hFSH5wUdvAfdjS858sG6wd/EcVIEbvhQY51IFANIYtnYi5QoCciz2/HXu0/9kTOa2BPYAt7P+z8RZESuvCzhrNR/sONCIiy469ExI5y0vQ+am+DhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y0qmLbWqfBLqAFPy3BH8m9e5TAMcx5dS6v8raiRJGt4=;
 b=cIqWiVOetLA7x1me2qWbJghLb1xDL1gzqYCdnjgHhiJNUPimh+TltBdgCx0esW0VFPsoH1kH+KboI/br+4+w2X4VglE+mUpk8jy/kLdCRUS316UMT/lUdu0lPl+mbZoZ4G5jtfqdh8LNqOVEVrQ0cm0wu7hTOsfa37K+5oFF/IkD+IKPQtZmX/s/qItfOtvaKFflZZ9rpaE0Zo9/ir6EpgZvARQzqG71d63LId0kGaRkhH3h3ew7JcZiLnRmijYtInoQhtdCrit6D2nAT4MVnn7FLiV4EBn9RWhB97Ya5tN1A/gyqf9u1kG02EywdEh7FEOVxiuFJ/JVmSzLYxFkZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB6503.namprd11.prod.outlook.com (2603:10b6:8:8c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.28; Tue, 24 Jan 2023 22:28:45 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 22:28:45 +0000
Message-ID: <7fbaa5fc-af4c-70d5-1328-5463265658b0@intel.com>
Date:   Tue, 24 Jan 2023 14:28:43 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: PHY firmware update method
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>
CC:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, <netdev@vger.kernel.org>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
 <YzQ96z73MneBIfvZ@lunn.ch> <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch> <20220929071209.77b9d6ce@kernel.org>
 <YzWxV/eqD2UF8GHt@lunn.ch> <Yzan3ZgAw3ImHfeK@nanopsycho>
 <Yzbi335GQGbGLL4k@lunn.ch> <ced75f7f596a146b58b87dd2d6bad210@walle.cc>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <ced75f7f596a146b58b87dd2d6bad210@walle.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0138.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::23) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB6503:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f34dcbf-73b5-4023-2a43-08dafe5a5ac5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: feLgvIbLOi/MIc9TMFMes+QylzOGfO1L/UdxTAP7dNzL4TCqZYJQOzg+vaWZTofrQ2NBFB9pfTIJgAb+Iv6x9WcmOpiNg+kqJFtO+7ywthuJSGw7uH0z90319Xe40ziBL5nvpVHbstLPWMe2Wfo0NNU9tQUmZdrrvo25BflaviMARePSejvRUCqtKCJ1fv+ubVLaX3VL6r5QCcHGgggXLBK0QCN9nlToitnwPI7yxKCpJ7qPeqzs3IuMMWcDdpIEhfEPQfy9wA3DwOAj9lbk6sLAycV36o8TX7Kn3rvs3E388fSEJ4ePDVvWWInRrxhas/KNHkGAITNjQIvu0z59w39rKninhKbf4TI06vBXVCPPNeb/OsuaawMeNCVkk0hGgOxzb/176iCw76P7iEjIskDBiCKO1Y33q5TSRgRzNoSrkh9Em/J5M8EsU4gSXrW8hFwMzG6fwnkbXCjzWpYyzDU6mNgSK80Tn82MXh/iYfvBJgGmIDL0YU6bIWNo/wHhl8Cxmlzs448LDZ+jivaOFtF0vTBUxpIWaPwDc18j1FuOWVjszMKbYcizuhhI6SS0iWmOrXSX4BKPVTQi6IL6jtCkwC0XTOhm8E91Gk9LzO09+DAyAlxQpFErE+1Df7oS5nveHcCbZvviXTXflMrsmG6klnt2zZwsX/0bqBAZtNiX5T/9u13oH3PTyJv68yCQ5ib3CG79R5e2JQpUejfJ9YDhjkSmJGaRGAs3mB03xoc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199018)(4326008)(66556008)(8676002)(31696002)(8936002)(66946007)(36756003)(31686004)(15650500001)(66476007)(110136005)(186003)(41300700001)(6486002)(2616005)(6506007)(26005)(82960400001)(53546011)(86362001)(6512007)(83380400001)(38100700002)(2906002)(5660300002)(3480700007)(54906003)(316002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWFoWW42UFplbGlCTldvTFB2amVPWWllVitDdTI0SG5DdXU3WDN5MnZTM25L?=
 =?utf-8?B?bTFJOW5EcElxS2dHdVFxNjFZQkp6MHBRQm5Ia3c5ZkQrQ2lMK1ZlZW43L2lE?=
 =?utf-8?B?ZE5zbU5rekMzRldkUytrUWVZWWFzcU56Y1VUTXdKdE4ybWtYaElPaGpkYjZO?=
 =?utf-8?B?akpYeEtaNHE5cHJaVUpSdVQ0c1JpcXJrUC9UQ3pURU1TcWRuN0ZMaTFXYzR0?=
 =?utf-8?B?M0xheFhLSER6UFQrcHJsdTU1enBvOTNhb3JCK0taY0dmYko4NUU5OU9ZN0Np?=
 =?utf-8?B?VWdkekpJckpvV3JiendzMDhkZmFHVlFDM3FvTFhUYUNsTXNoN1R1WG9JV2R0?=
 =?utf-8?B?ZUx5Z2o3R2xpRVJ3aEprVXlzWU5sc0ZZMFRHcDVkNFYxeVZFa0p4ZjI3WUJn?=
 =?utf-8?B?UXRLSU9rRUZZK29oZGU5UFo3R2JMdis3MVU3MjBOdS9naTVCcWhrRktxUGMy?=
 =?utf-8?B?TlVTV2JqN1A2YjdjZUpjRmVhNEFHNWpUQW9xVnBmT3ViMDdUMWZiamYzUlls?=
 =?utf-8?B?Z3lXdG1Kb0dqYUpYT3RtV3RwSDlmWnliQkRRWVdFMTR6dUpVbkc0M3NtRWpn?=
 =?utf-8?B?eitxR09jbTM5clAxZCtRa09mV2ZKMDVqZ0prajh5YmhBWWd6ZnRCdFFxdVZq?=
 =?utf-8?B?OWxPOVM0ZWszSDZLeUF0VHMrQnFtamd2eDZRbmxWaURTeHZUa29LL0tLMW16?=
 =?utf-8?B?SDM4N3JFM29TK2hFY3BRcjgzOC9STWNySHIvRmpFSFpDeDJYaHA4cjJrUG5j?=
 =?utf-8?B?ZWh1THp5UDFyYjVWcm01eXk5cGMyZ2V1MmplbE14VldNVjdOVXYyMmhPQmx2?=
 =?utf-8?B?RzYvTWRtSUNCSTk5YkQxUDYxUW5GN3Jyb1F4YXNoeHV2M1Z5TnV4VnM3YVRK?=
 =?utf-8?B?dWdYNFBEQlFPK3Z0SGFwRENvL1AxeCtsTW8zYy8wWEVSTGJFVXczYTVqbGt6?=
 =?utf-8?B?YkUzOE1icit1WDNWVXdxRFp6S1dNU09nTmRpR0pxdU5tUHFtRWFjRWU2SmNk?=
 =?utf-8?B?TFQ1SGhQN2FQcGcxU0RoTmloOS9UN0xJYXJMR2gvVTBLbXdHbDQ0UDMxNFE5?=
 =?utf-8?B?MEJQb1cxa2tDZ0VyTmNGY09wSW9VRjR0aDYzT05XS1N1czVzSTk0TFFTb0d3?=
 =?utf-8?B?WGRhMWYvU0tXNEttRmxJWlpPc0l5RFNaUkhYZUtxU0gwMTl4YVU4cUQ2dnRM?=
 =?utf-8?B?UHh1dU50WnVYTlVCQ3Q1cU00ZW1PNTUxcE0vcXVHSjFvRDdHV0FQUVZIbHZv?=
 =?utf-8?B?bStMQ0RxbGVtYVBIYjdEQ3Z5NFpKOVUwSlhRMTF3REpPVXZwZkdQQnNWbWRN?=
 =?utf-8?B?OFFaWVhXTFlXZ0p4bW9kamxSRGl0TXZ3clF6VU1EOWMxcXk4NUxIaGNSYy9o?=
 =?utf-8?B?MWxseVAxS1ZhaUw0Wll2MERBVlpFQm83cVRxZXlCTTdpU1ZuQUtKdGk0UXlX?=
 =?utf-8?B?Z2NMYjFIdmpYNXZhZTQvaXZkVjV6bktsdzc1S3hLOWl3S3dncHlDckRWNU9R?=
 =?utf-8?B?VXdwMkFCTzVOeTVUWFQvRVRLYk9xTDNyL2VwVm5PTnZySDRUNnExeUV3RDV0?=
 =?utf-8?B?RkhmUjBrVllJMWtpWHdEdzdWS0NsM3lkb085RkVJRlNPU3pQdnJIUGVRUEpQ?=
 =?utf-8?B?SVk5VG5IaU9KMFcyTDd5YXJFVDZXK25DbWQvdzd0YVdKNU5nbDRWRkh6QktB?=
 =?utf-8?B?dktXM0t6dEs1akp3OTZyUUE5Y3M5ejdxSlNRdlN3elAyK2NFeWpva1pKVGU4?=
 =?utf-8?B?UTlIZUdLQi85OFA2dVZCRE9nVUdJOHF3UEg1V25zZmIxc25UbVdlYndqUXoy?=
 =?utf-8?B?d0ZJdjRxenNlWFMxdEpEa0pmcFY0NVRrQTI1L29BdVA4b3JaeE5tZURRMXpv?=
 =?utf-8?B?MnREZFpxMXE5TXN6UXpkczkwb3JQVlVVSHY2bE9WaTRqbmtKU3EzdFVpK0RX?=
 =?utf-8?B?cW5ZeUZ0YmRuT1kvZWZvNEpVY3hubVQ5c3c5eldzdHFncU9tNWgydEhJamRF?=
 =?utf-8?B?SVFhb2V0SnFoQWJ1WUdqU2xndzNYT3ZOOGhtWit3anVGVlg2Sy9HWkc0dXpr?=
 =?utf-8?B?aUJZUUVPcVVmUE8xemRqNFNNa1V2SU5ySTd2WlZSdHgxYjBJYlhDeWJRWXpS?=
 =?utf-8?B?Y3poY3pOQ0xuU0cvcHN6L29ZTUppc3lUWlE0eFU3aytpUXVRSllMMDh5b3Jy?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f34dcbf-73b5-4023-2a43-08dafe5a5ac5
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 22:28:45.0822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5qgbYZr773eHOBIGdO6IgT8pJ62o+iZ+i9xEECKlAjZXpKIZr/DxWJlutppcGVdEnOJa5PxS6fa+BbnoEGbbpLq16T46Iz5zEjPV6VPvEv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6503
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/24/2023 9:11 AM, Michael Walle wrote:
> [sorry for the very late response, but I was working on getting an
> acceptable license for the PHY binary in the meantime]
> 
>>> Yeah, I tend to agree here. I believe that phylib should probably find 
>>> a
>>> separate way to to the flash.
>>>
>>> But perhaps it could be a non-user-facing flash. I mean, what if 
>>> phylib
>>> has internal routine to:
>>> 1) do query phy fw version
>>> 2) load a fw bin related for this phy (easy phy driver may provide the
>>> 				       path/name of the file)
>>> 3) flash if there is a newer version available
>>
>> That was my first suggestion. One problem is getting the version from
>> the binary blob firmware. But this seems like a generic problem for
>> linux-firmware, so maybe somebody has worked on a standardised header
>> which can be preppended with this meta data?
> 
> In my case, the firmware binary blob has some static offset to get
> firmware version (I need to double check that one with the vendor).
> Of course we could put that PLDM thingy around it. But it seems we are
> mangling with the binary provided by the vendor before putting it into
> linux-firmware.git. If I understand Jacob correct, Intel will already
> provide the binaries in PLDM format.

Correct, we ship the firmware binaries already in PLDM format, but it
*is* more or less just a header that gets added ahead of the 3 binaries.
(the header points to where in the full binary file each actual firmware
binary data is located, so we can combine all of our images, i.e. the
main NVM firmware, the UEFI firmware, and our netlist firmware)

> 
> Another problem I see is how we can determine if a firmware update
> is possible at all - or if we just try it anyway if that is possible.
> In my case there is already an integrated firmware and the external
> flash is optional. The PHY will try to boot from external flash and
> fall back to the internal one. AFAIK you can read out where the PHY
> was booted from. If the external flash is empty, you cannot detect if
> you could update the firmware.
> 
> So if you'd do this during the PHY probe, it might try to update the
> firmware on every boot and fail. Would that be acceptable?
> 

Wouldn't you just want to update when user requests and have info report
something if it can't figure out what version?

> How long could can a firmware update during probe run? Do we need
> to do it in the background with the PHY being offline. Sounds like
> not something we want.
> 
> -michael

I'm not sure. Since the firmware is loaded from flash I would not expect
to need to download it every probe. I would only expect that if the
firmware had to be loaded each time and wasn't maintained across resets.

For example the ice hardware has some data we load that does not get
saved to flash and we must load that after every probe or reset.
