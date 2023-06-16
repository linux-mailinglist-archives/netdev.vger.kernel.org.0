Return-Path: <netdev+bounces-11583-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19365733A67
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:06:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 495FB1C21002
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCBD41ED5F;
	Fri, 16 Jun 2023 20:05:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E041ACDB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:05:12 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F32C2133;
	Fri, 16 Jun 2023 13:05:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBxYQ88h9z0nu1gL/jdm2b1oDM7F4j9Un1nlUm6A65b/Xwv8hH1/DlA5tJKh7P1JExgTIvvCImudEMT6TA7tAgmMtw1MHMBG0sGwxZr0UcsIO6+/yYEL6n7BRoyLKnOHwrnoqaNQxDOviReaOIxv2t3e5oBkc/5o0Np4/NIP0NqmilSWAzhug2g54NsrbrT0vLjuQDF6jwZBL8MGefVfKfLD21VXu4gca5DE+jCMn0AE77FN5z1eHGCVbnJTWNtXNWVMRAKWVvYx/2RSaJ0oEbxzEZrSlHEJo49jjREAPx74fY2Vb2DQiuHmd+tBIHHyQxrjb5OqlsPeXdeAarrFSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T1AyNl0HzHakbkrjuBAfBcc55tnW3JxrU38LTbfM/EU=;
 b=oPIXt2qhRHVhdYumQOYS31LDFUu9jQC41raiqKBdqn/JsXuXpGnFGXfMbN99nMY37UPsotG4SRLlvkpa7hZrx+5hV4bAkfRsKyqXOmGUy4TTOX1vJzYtLs5vKRGrXQz/w9/O9SwjKYEr7gcsSn0AsPnY4sw9wGb5RyXpJ0CXq1lPfqVUR4pyXugUmTijUvV6VPNV9v+43oPkICXNc+KwsoHgLKqNdY4AwKM6iXj1/isYtKoIowS/ao2eope6WCfmsYjNpP8IHuULD1dQlgCWj1H3ZVB/5Q4LftfvdfBGZdObKTanpw5XuV7YfcK0nr6EyRGpIhCjD/g702/tfkRjqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1AyNl0HzHakbkrjuBAfBcc55tnW3JxrU38LTbfM/EU=;
 b=G301RkO8edxPukdGVcmIu99v2CTGLMmVZoyLT0XU7NGp041Mb1RYSD+IVFsrSrWbVfyIfm3iLM96IFUzICqxfMWN2egh7lcGVqesOm+pDfP+Y5jr5EPSCg2FKdHQ1jA86tkYUHYbA3MQLr2NPh+fvIBW3iatiZOhBmxzy3+6j3c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by CO6PR12MB5410.namprd12.prod.outlook.com (2603:10b6:5:35b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 20:05:08 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e%3]) with mapi id 15.20.6477.037; Fri, 16 Jun 2023
 20:05:08 +0000
Message-ID: <7a539f3a-113a-b17d-eed4-f111dd22811e@amd.com>
Date: Fri, 16 Jun 2023 13:05:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v10 vfio 7/7] vfio/pds: Add Kconfig and documentation
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>,
 Brett Creeley <brett.creeley@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "jgg@nvidia.com" <jgg@nvidia.com>, "yishaih@nvidia.com"
 <yishaih@nvidia.com>,
 "shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
Cc: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-8-brett.creeley@amd.com>
 <BN9PR11MB5276C91E587D0DE40883DD5D8C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB5276C91E587D0DE40883DD5D8C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0079.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::20) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|CO6PR12MB5410:EE_
X-MS-Office365-Filtering-Correlation-Id: c3aa0450-a062-4956-c177-08db6ea4fbc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JQghP6R/gMg5mWHsiqkMCpvSe2FXDqKfcCCZKoFiq7Go0pogJcYQ+VkkPmhMRAmjgTtnk9EdTp939YpCYnwQVCuH+/6gGLLORXMMwz6I/XUum5wXL+fhbeiURryezJ2Y+ZVw6MUXVVwzWiti32ZRY0B/skQrE32cbcLJ2WITPW82CZ4c7idH05o/V7DFarjqGdl3818HSjOgbAIWJqTcdsvx21z6lnQKdWpVx4DueLwKlglaMFw5thdAAacBcdlvdC39UaC/y2AAULTbPLvlxPG+hU4HaRYzbSbhgXuJNCD4Irn2/zecb6AsnHDWYQtmleoVEDERvWwzsZsMYhvvcQlxTu4Axqap0SmeYm6Tr8VqA+qAduJvbJNKxlXndX3oMbPtDpmImUMwhWu2/j3cpe9Vw4y0UC5QjVCnQ9ezHSedzRJCHgA4IyvRNvuptb59ijiBbiMDYzD1kzWsf8bGIaxHs725omHB68O26ibCU4MCSTKRLqLrW+mERJEkrogSLTm/nrXoHZHmtb33ppWQ7rAontn/j8gUaX75f8K8ruznzpkmUIwP5xS9M4an4ifoSVoAOfd1w1hT1PAoi/x7PRIqvNHPI2jEkJEl0j8kt4onx18XulIGog6obnosL6xAffvRNdwfWJ4lo768xSCIbg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199021)(36756003)(38100700002)(478600001)(8676002)(8936002)(41300700001)(6486002)(31686004)(4326008)(110136005)(31696002)(6666004)(316002)(5660300002)(53546011)(6506007)(6512007)(4744005)(186003)(26005)(2906002)(2616005)(66476007)(66946007)(66556008)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkxVMzd1a2hSeUtkK2JhMFNPNUk3RDJZbkRBU3Y1SkZDaG5Jd3NtK1VSNUFv?=
 =?utf-8?B?Q2Fsd3o2a2NDTVhrOTVEcVRZZnlUSEwraEh5U1FRTGJYdlUyejZmWFNncmgz?=
 =?utf-8?B?SlpoM0dtQXphMTF3UGtWSU5uMkJNcWozck9nQ2VoZlJVWno3VzdVNmZnd1Vh?=
 =?utf-8?B?R1M1R0t2bXhrUUljeVZRN3pkZzJUQTM3SmZoeGgxV2RtcllOVWVoZkVGRVdt?=
 =?utf-8?B?cW9Ua3VBbVJKWVFFemxwczJpc2VaOXppeTZqY3A1RG4zK1hqTGgrajR3enlL?=
 =?utf-8?B?V2ducFVNcWdSOHpxNEVaQ1NyYm9FdXhwUXZjZURrTEpOcmtWQjY0ZkV5aE41?=
 =?utf-8?B?TW9LNi9GWkdnZmtnbGQvdEJMWFlMdTJQWTNRbTd2dWZHTVhSTElNb0JYOUFE?=
 =?utf-8?B?L0hrcEFPSHN5TnE3cnZUYU5YTWQ4NlMydmlxcjFnQzBFRklvVDFQNDRUWWUy?=
 =?utf-8?B?ckNJbDhETlVTdVpMZmF0Njk1L1FlVldwOFc0cldVamNaQ3ZGMDBIcUtnaWF2?=
 =?utf-8?B?Zlh4TTNGTjBCV3B6WXBkTFdzQ2hTelBzWFNQVHo1QXFDbXBqcUpEZ0pZbFE1?=
 =?utf-8?B?eVc4RFhxa0Y5UDdtQVRjZkNMUWNoYktZdU16NFBLb3daQnNTOUQyODgvek9h?=
 =?utf-8?B?UW5tcGFNbmNrbDJUWWZwNVFzeEpnWWlvMWZVZG53T2kvN0F3V251bzNNYzdV?=
 =?utf-8?B?L2t2QXYvUVR1R0ZEczVBM3pkdEMrbEVUY0swMUZ4OHVaNXg4b0l5V2JReWht?=
 =?utf-8?B?S0RZWEh5cXRqZGFpSjJFTnZuZ1RhbFFRcHFqZDc3YkE2UmN4RVJwL01zNkpl?=
 =?utf-8?B?RlpsaTQvS0Qrbzk5OW13Mk5kYkplVklYWDQ2WXA1ZXBUMEE0RE03NzRVUzB2?=
 =?utf-8?B?eC92b1JiY2xaN3pLb3IvekxzKzh2Ly92UTdFaTNRNlRUck10cGJTYk1aaWxK?=
 =?utf-8?B?QkdWZlp5Y2J4MVhsUW94K05JU2ovekJtQ2U0d2Z6b2xEY1JnNVFpdFFwSVZY?=
 =?utf-8?B?dWF2VksxcjU5NEtwanRBNFdoUjVCT3JlWlp0eG5uSkVQcFhWNFpobGFqNDNF?=
 =?utf-8?B?ZTRKbFU5L1JzT0VXNmRyUWhKZFFCUy9hWi83Rm5BOWprdDFTNTNHaFJBbDBD?=
 =?utf-8?B?RVVxSGtIc0JLWFluU21iMHVJVFJOUmdocE1WREpERWJYRVlBL1ZkSi83TTds?=
 =?utf-8?B?cjZRcnNhTnUxSlh4RUx5VVI2cFB1RWJzQVhkRkx3eU4zUW5yYWV3bHo1dkFj?=
 =?utf-8?B?T0I2VHBPeCtuYUkxMSt3WDVvTnIvOG9UNTg3SmQ0YjRxdWZOVWp1dGlwYlBw?=
 =?utf-8?B?Z2pOdzdTaEtyMGx0MkNzZWFFcFVWY0FjNnhjYlpwQ0JHR2JXZXdsQkpGQVZn?=
 =?utf-8?B?OGlFb3h3ZHdmY0ptd3VDNXNRR2QzNXhzbHl0cGJwRzZlaFpmUVY4eTZUMEZ5?=
 =?utf-8?B?YU1nWm95U1hoVzlTb2lIUk9jeiswQWM2ZzdyTEwyNHBJS3FaUm9mUml4aEFr?=
 =?utf-8?B?WXZScTFjU0RvbGVNbmRHc2h6TFg1MjdJUFcxU05SWE55NWRUZGk1cy9qTGtL?=
 =?utf-8?B?MkdZaHZYVGNkNDY1NzhubXlTRWxsQ0wxQmJnQmxGYXZHQmxDeUh4aHBsdVdB?=
 =?utf-8?B?eldCMSs0aE5xV1k3aU5GOWh6UUtSMlMxaDhJSGRIUXZXdjFUU28yYTBEWGtY?=
 =?utf-8?B?KzhBbit2RjdTditXS2lRWWVHQU0wQ0sxTHJ5akwzL3NuWHZEb3JMTjFpVHBQ?=
 =?utf-8?B?Rkg3c3BnTXc0a0V1QThzTWIvOUN6S0d1b1FlTnlqTlJJZUtvWmE1QlZWZGo4?=
 =?utf-8?B?cnlodmdvc1R5RHRzQzluc3pmajZXOHJLTEI1aDVxNmVma2dONkRpU3B4Tzgv?=
 =?utf-8?B?ZmNGOUhWY0FxWTc1cjBGWVJlOFJreGZubmhCMy9ETEFlRFBnRlVJemVwaUR4?=
 =?utf-8?B?UHpvdjZScEpjVHNPRDFXb2Iyb001RlhSTk1OTXRHZTZqRlpCbHF3Mm5VRjQ3?=
 =?utf-8?B?TlFhTU1EM2sxdmNnYWpGVjk1d1hXNnRTT0dydWRqcGh5OEpkSUtBNjlYTm12?=
 =?utf-8?B?WkdyM1NjaXkyN1ZsSlR5OG1CUmVoY0RGaXlKd1lQUVJ0TVJlcDJkR3U2VjVD?=
 =?utf-8?Q?mXJ3OO0c3VAng+kzMx8n8e8Rv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3aa0450-a062-4956-c177-08db6ea4fbc9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 20:05:08.2113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rc2crrY4W8u1RQoMaIZP3KGgUZJJNq9OCF5CTYJ9BBotJ3Ug/R9pnF4QhD6hsAmgaWbXDVRSkfY4Kfj6stKQSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5410
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/16/2023 1:25 AM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Saturday, June 3, 2023 6:03 AM
>> +
>> +  # Prevent non-vfio VF driver from probing the VF device
>> +  echo 0 >
>> /sys/class/pci_bus/$PF_BUS/device/$PF_BDF/sriov_drivers_autoprobe
>> +
>> +  # Create single VF for Live Migration via VFIO
>> +  echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
> 
> s/via VFIO/via pds_core/
> 
>> +
>> +config PDS_VFIO_PCI
>> +     tristate "VFIO support for PDS PCI devices"
>> +     depends on PDS_CORE
>> +     depends on VFIO_PCI_CORE
> 
> this should be rebased on Alex's Kconfig change.

I will fix these issues, thanks for the review.

Brett

