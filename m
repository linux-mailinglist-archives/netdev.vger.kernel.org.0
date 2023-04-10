Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D926DCB69
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 21:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDJTNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 15:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjDJTNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 15:13:00 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F3A1739
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 12:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekT1uZ4ICWap9Y37BfwsZAar45KrlNMoCruVog75WexnRSuXyrFRb908vRLwgMCgTYOjztGVelRFqT3uTK2V0aWskI3dQn/vGPbSPE84wtPy2W2X6EVvN5WY7CbhZtT8HeFWoO3l5JA8sRxI2G9lJ2FtINh05gRf7ASPxUyA6wtRCG/BNENJiYuGUkw/QMriTVwY8oJaBJF0FmFaEss19kd7jm+E5uuQ71gl243I0pf+KHjBTJJIVxEwrA+f2gn4D3RpoT1drO/lkEqbL3o58Z0Fve+MrfgVuPQ5fxej9DWUU1QqDEj9YCn/KjgW0ven/xFnRu9lxV8BU5N46Zzkyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/0Szz2lyUcBK6WczJ0dwWDQzHT4A7WDrI2sLDrLK3Vw=;
 b=U4NGIWIqrcoVJhtM1SU3BcMxzgrxs8j3DrhW7izYx+3VkUfRZegGpZUHejBRYERxp2zI8onSdUdNc1bB/U2YPkdr+9cXZjppERD3eRVD2aTsi81aoNRfDWiJGuyqLH0BtJRZVS5qjzB0USou+EHmQgnGammYOeQ0zbKwkocVzPmW9IF6GhRDqDOhlg386QpMXVTPeeeBZRG0gRkblfZPUdHZthtvcHueXbjFavOqkkm0NH6BMgBJutbTYFlwrHCFNrIpXHCmN9QTzWeT6HPsOuwlO8UDX00CG+1mkmhfBSSjaTEOQnHgT/rsbwia1Dd5YmRySStyJuEZxfH7ONLvEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0Szz2lyUcBK6WczJ0dwWDQzHT4A7WDrI2sLDrLK3Vw=;
 b=jtcBJHfONFO6yA/anVnlrAZR7cLbKj+rUyRSFbxhY65uGROcUcouBUe0DYdi1DfbU4fdhgGWocGMXZKaFnoD+02BH5YfBd3u6mb6eTJgjpYH1uEfrC0P5+iYlkjahfphhs4sml4THcMBm+IZsnPx/YyNHL/aieqBO+fxlE6V8zY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH0PR12MB5646.namprd12.prod.outlook.com (2603:10b6:510:143::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.30; Mon, 10 Apr 2023 19:12:52 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 19:12:52 +0000
Message-ID: <1f03f358-3c52-8bff-f251-1e4177488cfb@amd.com>
Date:   Mon, 10 Apr 2023 12:12:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 03/14] pds_core: health timer and workqueue
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-4-shannon.nelson@amd.com>
 <20230409115110.GB182481@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230409115110.GB182481@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::29) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH0PR12MB5646:EE_
X-MS-Office365-Filtering-Correlation-Id: eee41371-7e60-4a1b-dfbb-08db39f79513
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RWYPr+0tJTKoRj+iwakw6IugPZQ2jcZ6CG8ZEeKf6XEKU19dQYWjEalQIiR7uFwyAuM4qO5kdB8naL9kcPwFtf7dVTOhk/KmU6oBT1f7lDb7CzToQj7Gfe7R+xxY8y5bUvCMEYIH2yJeHQrghwhW9AqwXHnevUXBfHAshif60AijGR9gz6xHNQk94ugbz6p+AM7erYXsrEcpwF50PdH4fZR2hcooY3/V6z4tzS6CoiMEFESINVLFYSfUuDHPh+rwnmnc2TfDkpIctzpk0+x1AXfJQrwctgP6XBygjE2KrmL5JXkXscl0XMIFyzu5d5HfS0GbwEsqbV8vndTarTc9YOKu7YIUY5x7kSlQDE/B4Ix/h5rfYgiiKSbpdhumL4DRvSA+AqDjiw+12jpLlumDVSU8/vPSxMXRa03McT8rXM6PtA6FAPTIJW/HfNNg7Z7tJWC2hDyHHL3Ub7HACCnIjqQqM82nc3o8S6V+TfpYDt8mGiMk15LGdlsYODNrvCtzunKY1QGykzNObJIs1tkmFOMONPa0yP7buz2f9yYHh5qoJzhXrVLPgidjRwuH7TZlBqB4P7DDFAPka/hljeFfC/mcSZRdHRMMS6dPziS7HbsITn/aIV3FaBVFiqww+85On7e0B0puDBdpLaD7UTVH/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199021)(316002)(6512007)(83380400001)(2616005)(478600001)(53546011)(6486002)(6666004)(26005)(186003)(44832011)(6916009)(5660300002)(2906002)(36756003)(38100700002)(4326008)(41300700001)(31696002)(66946007)(86362001)(66556008)(66476007)(8936002)(6506007)(8676002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUt1d1lsbllHOFY2RWFUblZqMDBrd0JtTDB0cThHT1VHdzVBTEtPK1FUd0JX?=
 =?utf-8?B?N0FHMDRMczBWVW0wOE0wcUNCQXZaNE5KZk4rem5KWkt2Sy9TZmEyVG9zZEl0?=
 =?utf-8?B?ZlJvamJDcWZLRk1PcEZvYWdRVFNnb0s5ZktSdmJjNERCZGhkYTc3TFpIMkc3?=
 =?utf-8?B?S1V2WnhQUElmbnJVQWhrbjVXL1lueVNJWEtsRytkZ2p2SC9sS2R0SUxFcnlN?=
 =?utf-8?B?eFlzTU5ESjY1a2tVcFY5akVib3FTTm96MDdvU1JvTEVKRllKaXBQbDVEcElD?=
 =?utf-8?B?TEJIZlhKK1V4cy9NOXEvUTZDZmhqTEJFZEk0UkljZGwxa3c4WEd2M3lRVFY4?=
 =?utf-8?B?TW9LNUxwREN2cUdGei8zY2V6RjVTejJORGVsNk1CVUZtTk85c0QyZnRNbDgw?=
 =?utf-8?B?MTNVZ0lhZCs5ckNwaVlBRGxGV2xyQ29zUFRSU1Z5UmhVTThtQ2JTUXVNTFZD?=
 =?utf-8?B?YzlobGRiU0dsTmJsRzczQlpNSERaVnZKSGJ6TU9PNmcyNWFNZHRzOHBxU0pU?=
 =?utf-8?B?ZDRkK2ZPejl0cnRqYjM1ejZQU1JMU24vU1RuRE9DOTU1V1gxbldPTnA0SU1K?=
 =?utf-8?B?UkE0NkRhZ00rVHd6dUUxN2pOLzNWUXU4OEQ1djhEMlBoVnhGSCtXaURaMjVR?=
 =?utf-8?B?L055YzA4ejEzWnRKVmM2U1l4U0xscFFhYnRUeUUrRTBhRVJhcTlOM3pTcjI0?=
 =?utf-8?B?NUdjWmZuMi9yYVMrWjEwMlZRRUMzQ3Q5UWNyS2RXOTFiRTNicUZ2OU5aUWpT?=
 =?utf-8?B?QUlMN2J2aU00V09NcnVnSDRNR2d4cVlnWVJuMVB2Lys0MzVoNnRSRExhdXdW?=
 =?utf-8?B?Mjgvb2x2NFYxdEtidi9OVWd5SnlSeVFyYlBHRnozcXRtVkhTdnZCQTk5UjNI?=
 =?utf-8?B?VnRVTDJOZHpCaHA4QjZWaTBTL3FjREtLK0VjbFJSWDFaNVJTTkNRT2RTTllX?=
 =?utf-8?B?b29jWlJpaGZZQUtwN29ZRG9GbFFkbWlZSHUveGduQ2I5WEU2TytTMTRUUDFW?=
 =?utf-8?B?WlBCOXZLTTR2ZWRuMmwvanZzSTBoZHVxSzlZMGtHbnRkVGphbW9QRGEweTVW?=
 =?utf-8?B?QUU0T0pxdlFzKy8weGVLSktyWUkxa09LYUVxbDhTR2RvNElPdDFzb3NMOHFE?=
 =?utf-8?B?SWxRVWFqRnpxSE9OSTdQY0ZBM1dydVhKR2NZNVNoUE85YW4wVjdFbkZTRkxr?=
 =?utf-8?B?ZzBsRXlzVzNJVDlNVElYWDZQclN0RklvRU81eGpuZGlTNU5qU04zVDkzRGZY?=
 =?utf-8?B?MThtVmNYZFdXM1duUm0wYjNjQTNuZ1NtbUJkRFFyek13THVoOEVtTXAweGFE?=
 =?utf-8?B?NGZVQTlpT2lSbXNacDFzejV3dHdzc2RrcVBROEFseG83ME5TLzlKV2xLKytS?=
 =?utf-8?B?OHU2Um04amYxMlk3K2hHWko3emIwWVE1S1lZRkRaK0hSN05qYmtSMzhkVEw3?=
 =?utf-8?B?UjNNM3lrSW9sb2piVzJ0eUIrbjltYXVPUllvSXMyQitNN1ZuZmNsQ0diNTNp?=
 =?utf-8?B?emFvSjhST0dXMGQzUlB6S3gvblA1a25QL1VqZTIwWHdwQUVNQVBOb2N2cGxu?=
 =?utf-8?B?YzFJdVFQTGRuOTdSQzFHb2JyTE1ncXF4UGFRZEcyUkYvZWR4UXE2TzVFWWlN?=
 =?utf-8?B?eHNaWlBWTWg4bzF6MWljY2Fic21xU1RUVDlFM2s5REJHVlhaSks3aWRQbVoz?=
 =?utf-8?B?SnBYL3NQNXMvRElsdTBwZUxvZGdwQUhaNWZTeDZjbUdRUWdVQ21RYzV1V1hz?=
 =?utf-8?B?Z2FEVS85U3dwaHJhbENLdHBTdTJUWGFFMlg5YnBNZVVtRGJ4T09tN3FlWHBw?=
 =?utf-8?B?ZEdCcVJLZlFRdkFCZHpaRi9qK05uSWMxM05OY3dlV1BZcnl0dTFZb0RlRUM3?=
 =?utf-8?B?L20remZSeDdQNUxRL1FEWEd3akpCcjZnemhWUGtjMHNuUUdTdE9Jam1zOVNY?=
 =?utf-8?B?cmE1b1B5SCswK2M3VlNSYXBYWDdtRHZRQWRWa1V3ck5POUpnOGh2TGNmSWZw?=
 =?utf-8?B?ajFSNUlwcGNyUkhhWlEySjFDUDVYVVA0bTRFRWlCL1Roamx1T0dYbzQ0dnQ5?=
 =?utf-8?B?eGVIekozTDVaQlNnRnFoZFJmQkVrMDVEaUovbjlzRmxncS9aTEcwaEdta0JX?=
 =?utf-8?Q?zugqrx+Ibg7D1umzPyCtJKr/R?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eee41371-7e60-4a1b-dfbb-08db39f79513
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 19:12:52.5661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CH71EgbEqdtvizgSrRcShkF8LWuOe6B5AqM1pR9fD4LWa9wozrNeUkiRAJlSVW1Iu0J400+Sj4zPfYRMnd3alw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5646
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/23 4:51 AM, Leon Romanovsky wrote:
> 
> On Thu, Apr 06, 2023 at 04:41:32PM -0700, Shannon Nelson wrote:
>> Add in the periodic health check and the related workqueue,
>> as well as the handlers for when a FW reset is seen.
>>
>> The firmware is polled every 5 seconds to be sure that it is
>> still alive and that the FW generation didn't change.
>>
>> The alive check looks to see that the PCI bus is still readable
>> and the fw_status still has the RUNNING bit on.  If not alive,
>> the driver stops activity and tears things down.  When the FW
>> recovers and the alive check again succeeds, the driver sets
>> back up for activity.
>>
>> The generation check looks at the fw_generation to see if it
>> has changed, which can happen if the FW crashed and recovered
>> or was updated in between health checks.  If changed, the
>> driver counts that as though the alive test failed and forces
>> the fw_down/fw_up cycle.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/net/ethernet/amd/pds_core/core.c | 61 ++++++++++++++++++++++++
>>   drivers/net/ethernet/amd/pds_core/core.h |  8 ++++
>>   drivers/net/ethernet/amd/pds_core/dev.c  |  3 ++
>>   drivers/net/ethernet/amd/pds_core/main.c | 37 ++++++++++++++
>>   4 files changed, 109 insertions(+)
> 
> <...>
> 
>>
>>   err_out_unmap_bars:
>>        mutex_unlock(&pdsc->config_lock);
>> +     del_timer_sync(&pdsc->wdtimer);
>> +     if (pdsc->wq) {
>> +             flush_workqueue(pdsc->wq);
>> +             destroy_workqueue(pdsc->wq);
> 
> There is no need to call to flush_workqueue() as destroy_workqueue()
> will do it.

will fix

> 
>> +             pdsc->wq = NULL;
>> +     }
>>        mutex_destroy(&pdsc->config_lock);
>>        mutex_destroy(&pdsc->devcmd_lock);
>>        pci_free_irq_vectors(pdsc->pdev);
>> @@ -270,6 +300,13 @@ static void pdsc_remove(struct pci_dev *pdev)
>>        devl_unlock(dl);
>>
>>        if (!pdev->is_virtfn) {
>> +             del_timer_sync(&pdsc->wdtimer);
>> +             if (pdsc->wq) {
>> +                     flush_workqueue(pdsc->wq);
>> +                     destroy_workqueue(pdsc->wq);
> 
> Same
> 
>> +                     pdsc->wq = NULL;
> 
> Not really needed, pdsc is released.

will fix


> 
>> +             }
>> +
>>                mutex_lock(&pdsc->config_lock);
>>                set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
>>
>> --
>> 2.17.1
>>
