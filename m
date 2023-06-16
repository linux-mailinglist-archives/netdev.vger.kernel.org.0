Return-Path: <netdev+bounces-11586-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB048733A6F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:07:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB76E1C210AC
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A19151ED50;
	Fri, 16 Jun 2023 20:06:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE7D1EA84
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:06:11 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0589A35A4;
	Fri, 16 Jun 2023 13:06:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esmgW7AvtdMSja1i7ylYK+TLt4yjGvGupumCi8VbQle4zk7ou6LhVDpTNvPVn0MY7N7oXv4e/lAX+0fu4d9s4e+ADALC54JKUwE+V2noW6c9DrPeH25QUVid9In5D4eAQnO15SjTvcDNfK/lQflbWqltAJxHaq42ZElPUnC4Mw4tiKME/dlGX1hxfklCzQDFAVz9xTyye64vCKmELS6acZBAGisK67/3758W9SnUd0yUL74sxA0ANQutDiGZgKl5u0gdiOIUfcQ7Y23mvyuBm7ZJ6bsQMkBNHn668jUQfSuaGclS+IKEiSIfHBkeRphW9xz20KHkSkKmM5sVV77LhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZENkJL/rkio35CYyoFmGL0SHf22KdBKyvHF385+8138=;
 b=MEzY8eGu9UbxZI1Y98AZHPa+aZvp/vwXZKNHf5DnhE/ZtwulZCnXsZdgO9ZRYcLZP/zTFxOIu9OQtOQCRJ0tM894yGWaeW6abeSfy+UDwooEnr2w4vp+8ndxTKpJE2WlQyT9AlnSXO5qQvqVa9AghMMaNeU9A1zkkh1X1yyIGTBx04sUIjKA+Y4tIQo5tE6ug8R21trdjpW3Al0s1/Ws90OyHQTilQna2issCkG1hbOvzkN6QmYS7jbxQH4mlulAXbElRPe0oIywXrnz6LgyR2VNjo9mC1DMZVytxuxxVkJUkDDCMLnQENqJG/qeWCOpZeSz+tTklZnl+nZc0pQcDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZENkJL/rkio35CYyoFmGL0SHf22KdBKyvHF385+8138=;
 b=Y8czigC7P21+MDR9LbKje9ask23weMe5ByAIW8nvpDv+8H19sN239fgsaTrByL4Oet76qUhIWLITHRFJ5GkpraXUahDC/tLQmJVtofDegx8SFuHxiVC9+b4/S6f17YSn7V2au2fEtrdLcD/eSzEH3VkU74UA3anSbpToqleMpNc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DS0PR12MB8563.namprd12.prod.outlook.com (2603:10b6:8:165::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 20:06:06 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e%3]) with mapi id 15.20.6477.037; Fri, 16 Jun 2023
 20:06:06 +0000
Message-ID: <91f8f8ba-dfc1-2d42-3aa7-f7c5eebf9a56@amd.com>
Date: Fri, 16 Jun 2023 13:06:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v10 vfio 0/7] pds_vfio driver
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
 <BN9PR11MB52764A3D962F65B25FCE88748C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB52764A3D962F65B25FCE88748C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0100.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::41) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DS0PR12MB8563:EE_
X-MS-Office365-Filtering-Correlation-Id: 911233f1-9ee8-44d4-2115-08db6ea51e53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TaMr/ne4/aAQKFbGEapcMSfcJwt3XJmIGepvI8qLojATYdxZuGaUSiAFRQJgiVfcH1dcUaafx7kbDzv8iwCk7tJwRpzeuNABsi0TK+0bH/msWfs89W2qxelQBlazjRnfSrvvRYYQx5W45ZZZu6/DguagsRcHLDr3DoaUW4HpYH2mPhEY0JsNStM6M+uqwtsY0TfKfNXAxMX/0y8eeNaovzqzrK9aDcQzA5G/nnhyVnqUbZ52HsD6F02Ycj9Aqe6LoR0Co2/2tQgdH685Vi/8PBqKb63GnHTgK5h36A/e7eJyhDa7VpYeiBrxW9l3B5xMrQ3XXc52j5Opv4JiKj9FZ3LmD3gxT169HF5JpOujeYtw9RES9h3JjD+PNQ2xZPb1t8+n9VFmRVWAih6YL1S1fgyeY1YxVGYLAGZrwKY48DpX9ndN2LUtUmf49fSBDxaNfqMp2zeTJcIou6zBmK6V7cepXrkpsuXM/jah13WBIBwj2gFOwoo1l93rKK1VCOFhn4zbChtmkU3DhONUE+k9WxFPylGedC9n5OKFVEM8bn/M/GExgdB6csmQALgdK0QNrZiCD0ncBiytTLM1CXXrrhchMrOIIvCIqLspOmJ4eww0RalBirxfPp0WFibmyebWLs43cTgeIVaYKTBlOB8GRA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199021)(31686004)(31696002)(38100700002)(5660300002)(316002)(8936002)(41300700001)(8676002)(66476007)(66946007)(4326008)(110136005)(83380400001)(2616005)(66556008)(53546011)(186003)(6512007)(6506007)(478600001)(36756003)(26005)(2906002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDh1a0tBWkNUeEFxTjhDdVFLL1Y5SkpuOGcwNFNUajBxSWhycmEzUGtWTTBE?=
 =?utf-8?B?TGExQlZYU0g1NGRwYjFQZEw4OEE5VWsyei9rOTgrK2JqOVV1UlBIN2w1dTRE?=
 =?utf-8?B?cEJZM1hSdjBmVktzM05pSEhIZnBVQlNTYUFoN043MFYybm9pVW5iZEsza2dC?=
 =?utf-8?B?NWd2L2o1UEV3dHZ0clB0ZWllK3V4QlFJVnR4L1k2ZDNNRDdpdmpsMThudWRC?=
 =?utf-8?B?RFp6eXRYazVvTWpMNnFjUmtmYWxhMCtYWHhqYnpMcGl1cHBza2o2dTNYY3Zh?=
 =?utf-8?B?Zjhwc0dNRmhjU2FlRHRSYkEvbGdhanA4TXk1bFc4UmxiMTF6T1JWWFJCMUhW?=
 =?utf-8?B?LzArQUxnN1BXdnJZb3JLd1IrMWZXdzZIOXZ0QzRWdlZPNTVRa3FiSTF2Tnc4?=
 =?utf-8?B?S3RoT0VQbEp2SlQvbjN3bnZFMHVuYnFqQisvdDBZWmFEMjlzYy9vOTV1TUFx?=
 =?utf-8?B?UmJaMXhLY3RRak9FVW9iNEY3Q0RveVU1N1RnMjlGeFlNWDFXOFJBMFF0Z1hx?=
 =?utf-8?B?ckprN2VIWUZVL3Q5ZmFjWk5CMlgrdWUvVlFMYjhxTFZSTm9DdHc0LzZzREd2?=
 =?utf-8?B?N0pmektQTUhIdHFZK3lUYitXRjBiMEtycmdPdWkxQ1A4dm1oZVpFMzRIZWZz?=
 =?utf-8?B?elJDUE1KS2VPUTFFamN6eXA5RGVpZk5ZdUNpcEhGMlpvQXMrb2VxQXU1RlBq?=
 =?utf-8?B?bVNyNFQ5VXNuaitmemgraWE2Z25BSmpoZ1Z4eDRWQjdWTFU3eWdnQnhzdHYr?=
 =?utf-8?B?aHF0bGMzdDRCZWdsbXVDeUp2SGxVY0VwM0o3cU15SzV4dGpBVzBWYVI3MXlR?=
 =?utf-8?B?VktYNkg3aFFSakdPRmV0Z05qOEFLbEZLVFdES1RPMUNWRk9yaFlsVVplTENR?=
 =?utf-8?B?bFNETFVWRDhEU0ZtS0hwQXEwc2djN28yaXNVcjFoWUhBaXdoSkl5c0RqeWZY?=
 =?utf-8?B?eldRNkJ2Zi9sQmwwYVh3bk43VzFiYURheFNuZGNrVWUweXBMNXJqc1c1WjJn?=
 =?utf-8?B?eHNPWHJlVFp2L3lwWHBpa3FkTUp6N29tMVhQZHNjOW5nMmtLYnpVT1RrZGVD?=
 =?utf-8?B?Zk55Tnp3ajQydE0zKzRxK2g3K2JJS0p0QW40aWFkUmw3dmwyQjZCK2cyOVVj?=
 =?utf-8?B?NVZDcWZrOVNTUGU1dTdXWGFHTkVSak5DUVVRNnlDVHArZmc2TjJnVm0yYmpM?=
 =?utf-8?B?NmR2K1JraDNDb1JreFNLTGQ2RXVnbnF4cWY3U1A2VEpCQUdPMWgyckpHMjdq?=
 =?utf-8?B?R3lZOFMzTk80Sy9CUWxvZ1RPSThIVHEyTVh3ZklBQi9oREM0UGJzWkRlU2Zm?=
 =?utf-8?B?THhia0dLRnliL3dnQmJlSzZLV25GTWtlbHZJeG9EUlA1Wk9xRjdNVTdxaG5J?=
 =?utf-8?B?WEQzUmVGYzBTaDNSQitnT3YzRXVuSGtOYjUxQ0NUaTBqOEhhUDRHalpQTGJn?=
 =?utf-8?B?bFZiUGt3UHhUY0RQZm8rYVBGZU12djlTTnhzZ3V6RlEwL1JtaDlWc1U4NHAy?=
 =?utf-8?B?T2tUZ0czUTJPeDVMWDliVDRKd3lNR09Pb2JFblJteFVLWnRnM2x0aGh2MjNP?=
 =?utf-8?B?OFI0NWhQOXQzY1FSYVdIcjZTbG5jcVVMM2tLcDVPTXRUTDU0blFEeWQ0eU91?=
 =?utf-8?B?eDJaT2NQTG9jOWMrOEc4R2FYeDZ4MUxOUkpwUWtQNXY3YmhVM044ditobWVv?=
 =?utf-8?B?cHllQi9zcHFTdmRRQS8xRXE5TkhrRy90ZGpvV1MvL0QyVTQ2ajZ6SnhIU1J2?=
 =?utf-8?B?Ym9Ta3hsdmJBOVl3dWMxVUg3ZTVQYm5mTit0RE43K20xaXRiMW16MmFDallC?=
 =?utf-8?B?TWJHZjNKWTIrbUxWb2FKbGkvZEI0Z25UZUFIdXUzbmJONkxlUmVvcSt2aUUr?=
 =?utf-8?B?RmhLRmxsRFRpd2FwdnFDcWRlVDNlem9TeFZxYzVlUExQSmtlTERJSHpmZ1JR?=
 =?utf-8?B?SFQrQnZnelQxZjVJeE90YzFZNFFYY1lyNkVSWDZVL0xoaWFDR3BaVXZGWTlV?=
 =?utf-8?B?ZlNreWVISDNUTEpIR3VndTlaNFNnR090T1FOZEJ3Yk9tZS9EK0lvY0VkUUVr?=
 =?utf-8?B?NHA0TmEySlFCSWVRVlc3Z3BieW0yelN0UlRBOXllcDdPUndsMk5NcG1BUlVo?=
 =?utf-8?Q?keP6nN5g72BwKYXu/NqIrAPDw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 911233f1-9ee8-44d4-2115-08db6ea51e53
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 20:06:06.1454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CbVEYkhXLX6ik8JzLmEmdxhX+QEfLENIphPizpy/GJBe0FZuzyqSCzIC67Fcdi+5quWmandTAIbrOc7BM0sw/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8563
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/15/2023 11:47 PM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Saturday, June 3, 2023 6:03 AM
>>
>> This is a patchset for a new vendor specific VFIO driver
>> (pds_vfio) for use with the AMD/Pensando Distributed Services Card
>> (DSC). This driver makes use of the pds_core driver.
>>
>> This driver will use the pds_core device's adminq as the VFIO
>> control path to the DSC. In order to make adminq calls, the VFIO
>> instance makes use of functions exported by the pds_core driver.
>>
>> In order to receive events from pds_core, the pds_vfio driver
>> registers to a private notifier. This is needed for various events
>> that come from the device.
>>
>> An ASCII diagram of a VFIO instance looks something like this and can
>> be used with the VFIO subsystem to provide the VF device VFIO and live
>> migration support.
>>
>>                                 .------.  .-----------------------.
>>                                 | QEMU |--|  VM  .-------------.  |
>>                                 '......'  |      |   Eth VF    |  |
>>                                    |      |      .-------------.  |
>>                                    |      |      |  SR-IOV VF  |  |
>>                                    |      |      '-------------'  |
>>                                    |      '------------||---------'
>>                                 .--------------.       ||
>>                                 |/dev/<vfio_fd>|       ||
>>                                 '--------------'       ||
>> Host Userspace                         |              ||
>> ===================================================   ||
>> Host Kernel                            |              ||
>>                                    .--------.          ||
>>                                    |vfio-pci|          ||
>>                                    '--------'          ||
>>         .------------------.           ||              ||
>>         |   | exported API |<----+     ||              ||
>>         |   '--------------|     |     ||              ||
>>         |                  |    .-------------.        ||
>>         |     pds_core     |--->|   pds_vfio  |        ||
>>         '------------------' |  '-------------'        ||
>>                 ||           |         ||              ||
>>               09:00.0     notifier    09:00.1          ||
>> == PCI ===============================================||=====
>>                 ||                     ||              ||
>>            .----------.          .----------.          ||
>>      ,-----|    PF    |----------|    VF    |-------------------,
>>      |     '----------'          '----------'  |       VF       |
>>      |                     DSC                 |  data/control  |
>>      |                                         |      path      |
>>      -----------------------------------------------------------
>>
> 
> why is "VF data/control path" drawn out of the VF box?

Just a mistake in the drawing. I can fix it. Thanks.
> 

