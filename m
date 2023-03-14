Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAD96B9C3F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjCNQxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjCNQxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:53:38 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C279C23334
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:53:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xb2mNCsWNGqM4413yXV8z1ThIKWJr3lxAy8FeZe4aogeIesGEdSdBvnZG3zgNpl6jwCgBfSsWWELmNIOMo008l+oXK2gk0ubd7JBljLUcUq845cjXJVZ5NfY1HzH0jAbAXxJUY6Y3wHfux5SlnZyeTVaPy/u7kWRHfrHZcQJQTEPj4rf/VCh3XNTA397tkHoiuu0aC1NjKPLQc+rswdUuG3GDaHr7uUB2CuabGKrw4A+W35/3t+OyRg50GuV6RWmJQF2jsdwJOtKX9bKkTsDpyR7H0/rLVpNrQkfKcL2b+g7Q4sybcmaLAOWl67Cvghn0eyzDnaSlLvA5gEkHWPUyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vmuKdeBJ6efansvp0QargR9caWa4JGPspp1VnFTh2Ss=;
 b=WIT8v4+/uiWC/iumOfC6fwtbYscPPBRa37Osf2ufWTdka+K+XyY0SJE/ROX42uxrvQzvpj0IpmiUMTwFndXpV48UHT5dsiwfz2pLrhPIy1H+7UnffeC18lliKsP/IXiEkp0cKwHgym7S/IwkoBEIxLo1onHz/3qCj/EXHnYIPpkVf6DYsPx1zQfT/JZDGZ0eR8mQJGWDSnXYWX1pRYFFLVAZ9oQmx1eyNZ3Byz3+ZVz4p0k41LPIpc5TzMxUSiOsDiMPs3wcw5v7YfMdRtZ/DzURTkcca/VQykCVmWG2xClVDPNRfAGCkrS69xiQpvYSAmkN+tWSKwW2+BJD9PIZHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmuKdeBJ6efansvp0QargR9caWa4JGPspp1VnFTh2Ss=;
 b=EiLpaqGnxW5nyAVcAhpBDPcnVrBucUXWZFJX6+a6ICDQxlun2bONqvkZET/N2xuPbPBxBC1u1HMQ9Eb2Hm0NKZ78LQ1/QVcMjfPzWCG+lHvlWNPZ5c50jAOgnK7sFOsf34DMoU2yOpg0eRoBBMgxAJoaXtOxuaWE2dHkWUA7UN8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SA1PR12MB7367.namprd12.prod.outlook.com (2603:10b6:806:2b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 16:53:29 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%8]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 16:53:29 +0000
Message-ID: <398bef7a-795b-d105-d8e5-57ef1c39049c@amd.com>
Date:   Tue, 14 Mar 2023 09:53:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v4 net-next 11/13] pds_core: add the aux client API
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230308051310.12544-1-shannon.nelson@amd.com>
 <20230308051310.12544-12-shannon.nelson@amd.com>
 <20230314121452.GC36557@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230314121452.GC36557@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0148.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::33) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SA1PR12MB7367:EE_
X-MS-Office365-Filtering-Correlation-Id: c1735bf8-e018-4c38-3cda-08db24aca300
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ANdG/M/ErCiREwVFQyNJlqrzBfQ+GQ4+3MCnAcXEDVgZqlSRPpgBG131PcBe3hSuKtkz6OEigCPIxCNQ2/k4ZVbjylXvAOrVSbbCgeIF75I2AAft/tMdzYyOj1P1SN0QKvrBGDk+oXeYcJdSLr7MHLXzGeCHRmtgI5ohJK+sa6S2rDxdfBq7j7IHaexkck8/wd1uhRaopv7N5DQh42Owvky5bNXdRs0kXr+POJHTaLlBL9JAWZApRT4wQm9N/EDHGSuEm07bxchpT5s2IPLfvfBP+iruTXI3x5SMFZsHqKjXvRbryaHyXMnKFS5ZVoeerWLggtv1m3ff1aBTfOcnhew0Fg7AnATvk1+f81AQXd1q6DW2+u9QNP5caOyOZVg49cIQhPi5AE9J+u+8WQzWbZ7IQa5IZg+ocb83d5YxjHO+RszDvpPnDjf3my6U+lc47dYOe07KIwdwt9PhSdcIxF4ZOqv8q+eCXcr9XSLz6Loo9idjJ8DnrWMHwTp68xDMQVnLESng6bwyq0ROnBadHToYB9Q+9b4CwkOmEh77X3RlwfKM02ao8aBcHnP15nc9x0eCZwEbqxMcDUPyO/V5bLW2jkaulsJ3TkN9F+c8ISqhKSfFIS+xtEfaxk4gZsK3RGOqDERdgu3frQMTRfMgsTlgP9j2+Rc6x/aEdOGmR17tv5wJZEp71o0vF/OLxs0Tz6Erwlwv4MUPBSGliHS2HRqU/Z8l0gO6+afMgucmnCk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199018)(31686004)(5660300002)(8936002)(44832011)(2906002)(38100700002)(31696002)(36756003)(86362001)(41300700001)(478600001)(6916009)(66556008)(8676002)(66946007)(66476007)(6486002)(6666004)(4326008)(83380400001)(316002)(26005)(6506007)(186003)(6512007)(2616005)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUI3V1NCZWFOczVkemdjVENHeFdCZGNkSE1DS2tsbUVUY2VVRUY2VWJrK2tN?=
 =?utf-8?B?Sm8wS2Fzd1EwRjEyeFZ1SHpKdVFYbWhpUXQ1MmJndzByLzM0SWV5M1lOUFVE?=
 =?utf-8?B?MktXY3V4ZXZLWFZVRnVwQkdNcDI5QnE1T1AzNHpxS09DVVBaYVlTaXhnTk05?=
 =?utf-8?B?WjBSM1RGT3NYK2srajlJS3pwenl0azdyZGhEKzVjVjJhZndOTTF2ZnpTL2dm?=
 =?utf-8?B?T3hwaDhnWFY1V2xyV05iMy9BbW1SYzBNMGl4bVpxcVI4dTh1TUZZZ2JqY24v?=
 =?utf-8?B?RCtKUzF2cUl0QkpyaFFWdFdxbGFIT3V4d3FIN05pSHZkNlBHdkwxYUU0dXpW?=
 =?utf-8?B?dFpkK3ZnVnQva2Q4MEw0WnhHYThsNjBHS3loK01YZ3JVK25RK2JGcGxsMVVI?=
 =?utf-8?B?MUcvNUFyM2JHOStDVnM0am8zdXMvYlZBM2NNOFIwVDM0TDNsb0VLY01nRlVW?=
 =?utf-8?B?dzZTZ0FnTWZnaDZmMXJOc3NiQTczOFFHOUczYnJIZ1JadXVnbEJsZTJLWVI0?=
 =?utf-8?B?YklWRFlzME1PSENWTUcrZSsrbHo4WTJDZEpxc3JtcmRKTzRVQjFnNWl2bjN1?=
 =?utf-8?B?UkZSSDVhL0ZlSUJmVUJxdk0wKzZZQVpENWVGWGpKNGc4QXJzQVc3UVpnZnBl?=
 =?utf-8?B?S3RtZVVoYzNIR2REWU1FRWo3Yys0c3pINmhmU2VGT2Zvdm1wMzl6VXlLRGV0?=
 =?utf-8?B?OG4yNk0xa3k0bkUzbWk2aGVkelIwUitVK2NxV0N0YzZrNHgrTXdJK085TzlU?=
 =?utf-8?B?Q2c2NDQ0MTlNU1B1VGFJemlocVFtaEtqUmNxK2Q2SGFkNmJicHQzaW95ck42?=
 =?utf-8?B?K21OelB5bGQ5WUlqMDNxMWRJTWcwVDVJV0dBNHMwSTAremJNeERTNXRIdm9P?=
 =?utf-8?B?NWcyamRNT1F1d1I1L1BzOHNXRzBHWDIwenVCSENwakdETXdZayt4S3VuRWdM?=
 =?utf-8?B?eU84L0NKVURJaEtOZTREd0NyTDYxV0NWYmZFTElXaTdEeVM1ZDBqcTJmbWgz?=
 =?utf-8?B?dVlIRWYxVXVCcWxOemc3NkxrRXNhYW5NV1kydVFwVFFWU05UdXFPaUhrK2FW?=
 =?utf-8?B?UlVOd3V6dnRpYytsRUtsLzNLU1B2N3NjdVB3RVUxQm45bHZXZk1XS2tGZ2E3?=
 =?utf-8?B?UEllTDFvV3RiamxTcUE4cGNha1IwL1ZZSEdLcW9TbFA2MXVHK08zQlZ4QXMx?=
 =?utf-8?B?YzJmdGsyZklXMFhvbDFjaUllTzM1TEwwU0pLSGFXZ3BjWTkxQUlObVdKU2hY?=
 =?utf-8?B?UE5nRmhsZ255QTZGVEFYKzUyeTZ0VStidWRFLzVtb0t6VmZSWm1uSy9vUWF5?=
 =?utf-8?B?ZnhkWU8rYmRaM01kOXdJWE9acEpLOTY2WXhsNDlOT0NwS0QydUg2MDJINGMv?=
 =?utf-8?B?NTFacFdVUVoxeHUwYzFNVitSWlJwVnUrYkYzREFmd1dsMk0yRUcyVWVKUytu?=
 =?utf-8?B?OThjUWJZS2NCbTFVWE50TExieGpPdWRsR1NqUjBrMG1YVVNYUXZGR1BpbEFa?=
 =?utf-8?B?Rk8xRjVEOTVKZGlheFVTbmZVdGJKUGNGZHB2N2gxN2lLcTBDNkZ4a3NGNFkr?=
 =?utf-8?B?SjlpRXZSQW15Wkg4V25lNU5XRjJtS0IxRGpCT2IrL2g1OGRDU1Y2T2NGREFF?=
 =?utf-8?B?Y1NaQmNORFcxZUdBWFg1NTQ2a2ZrQnd2OXZLYkNVTVUwTWRMTTVWSnUxZVpR?=
 =?utf-8?B?NzFubHp5Z1U1NExaaisyUXlUNjFkZGdQYkozcGU1MjRkbFdGMkJYWTgxSkJn?=
 =?utf-8?B?UGdnZFhCc1kzUjQwMTZ0T0tVN3J6QWFySWNNcUN3UlZYTEdxUG0yc054QVhV?=
 =?utf-8?B?RmIzTVRQNHhTWERIdmlNaFVJOUJJa055Sk5vampWam9ZbmpkdVJkYTR1UnJO?=
 =?utf-8?B?Q2RFeFhsT0RwVEVXR1JvV2ZYajNtZ1RjL0trTWdFREs5OHhlZ1VYei9meFNi?=
 =?utf-8?B?aUxBWCsxcEtEelp2d3JhUVZ4TDQ4bTVvQW1MY1ZzUWcyRVJsZThpOFRKQkxE?=
 =?utf-8?B?VGliQWV0Vkd3UFRxMlJHZGVqZU1TWEZ5Sy9qdG5Ublh2Z3dmTWdPbFNvWUVQ?=
 =?utf-8?B?Q1NlaGFqWm44NS9lM1lkMlVoS2p0aGtrZzVSa1ZGRDNFVGRkeG5OSVROZU01?=
 =?utf-8?Q?4O1LDYZdtcKA41EcNd9zHl9pM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1735bf8-e018-4c38-3cda-08db24aca300
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 16:53:29.2764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nOH7K5fwXIatqK2WEDuiqLI25qbAUfI6NzXt5kUKHaw2But1n9qNVe+sG1GsgYICOekHw7elwr9vrze1n5qgRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7367
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/23 5:14 AM, Leon Romanovsky wrote:
> On Tue, Mar 07, 2023 at 09:13:08PM -0800, Shannon Nelson wrote:
>> Add the client API operations for registering, unregistering,
>> and running adminq commands.  We expect to add additional
>> operations for other clients, including requesting additional
>> private adminqs and IRQs, but don't have the need yet,
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/net/ethernet/amd/pds_core/auxbus.c | 134 ++++++++++++++++++++-
>>   include/linux/pds/pds_auxbus.h             |  42 +++++++
>>   2 files changed, 174 insertions(+), 2 deletions(-)
> 
> <...>
> 
>> +static struct pds_core_ops pds_core_ops = {
>> +     .register_client = pds_client_register,
>> +     .unregister_client = pds_client_unregister,
>> +     .adminq_cmd = pds_client_adminq_cmd,
>> +};
> 
> <...>
> 
>> +/*
>> + *   ptrs to functions to be used by the client for core services
>> + */
>> +struct pds_core_ops {
>> +     /* .register() - register the client with the device
>> +      * padev:  ptr to the client device info
>> +      * Register the client with the core and with the DSC.  The core
>> +      * will fill in the client padrv->client_id for use in calls
>> +      * to the DSC AdminQ
>> +      */
>> +     int (*register_client)(struct pds_auxiliary_dev *padev);
>> +
>> +     /* .unregister() - disconnect the client from the device
>> +      * padev:  ptr to the client device info
>> +      * Disconnect the client from the core and with the DSC.
>> +      */
>> +     int (*unregister_client)(struct pds_auxiliary_dev *padev);
>> +
>> +     /* .adminq_cmd() - process an adminq request for the client
>> +      * padev:  ptr to the client device
>> +      * req:     ptr to buffer with request
>> +      * req_len: length of actual struct used for request
>> +      * resp:    ptr to buffer where answer is to be copied
>> +      * flags:   optional flags defined by enum pds_core_adminq_flags
>> +      *          and used for more flexible adminq behvior
>> +      *
>> +      * returns 0 on success, or
>> +      *         negative for error
>> +      * Client sends pointers to request and response buffers
>> +      * Core copies request data into pds_core_client_request_cmd
>> +      * Core sets other fields as needed
>> +      * Core posts to AdminQ
>> +      * Core copies completion data into response buffer
>> +      */
>> +     int (*adminq_cmd)(struct pds_auxiliary_dev *padev,
>> +                       union pds_core_adminq_cmd *req,
>> +                       size_t req_len,
>> +                       union pds_core_adminq_comp *resp,
>> +                       u64 flags);
>> +};
> 
> I don't expect to see any register/unregister AUX client code at all.
> 
> All clients are registered and unregistered through
> auxiliary_driver_register()/auxiliary_driver_unregister() calls and
> perform as standalone drivers.
> 
> Maybe client, register and unregister words means something else in this
> series..

Yeah, I'm not thrilled with the overlap in nomenclature either.  In this 
case we're talking about the logic in the pds_vdpa module connecting to 
the services needed in the device FW, and getting a client_id from the 
FW that is used for tracking client context in the FW.  Maybe these 
names can change to something like "fw_client_reg" and "fw_client_unreg" 
- would that make it more clear?

sln


> 
> Thanks
> 
>>   #endif /* _PDSC_AUXBUS_H_ */
>> --
>> 2.17.1
>>
