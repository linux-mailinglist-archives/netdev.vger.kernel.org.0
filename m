Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BAD609195
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 09:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiJWHPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 03:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiJWHPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 03:15:19 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1991840BEE
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 00:15:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8UhT8jSSkqSczajqZBi4P73o2TJ0D/pQlPuG39JiEj5JidoGGX3XAdQlAUtezXgAQpS3yG3KzMREhFPiRwsobyuQwtctYdIdodaTw+VSp7GEyes6kP7EMwE6fud2b4KUKe0nk9aPAM5Q9qv+z8bAdwJW6a09bKD8XHRFy7BkRRK1jPCOIFEolsyvv/Et4VjkaiOClIbonpWs1Kg6gxKjPx4OQRzdhXMyyR2OE9MolZ62MJ7VcbA6TsVL/9J2Q722RzuAy5QznaxRCVh2jJbRfptbeuS5U3e1dgi74qefGjJ32iYEdmneSHutYAq52iNMVL3e+7G9IvLBeMpyazdMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1NS+L8LjS5xYqVwGCbH0JjsuLnyNWzDugJA0WwwNz8E=;
 b=T0Qf1nJS6gT3MpE36wUbIwU7CYLyhOEkdMKo1R8sIYtKMoItXZs3YTqFCR6hvodVivZQeW5eIVBRzUoCyZ3r5DXrsvREnmWBnzVOU0VqEKeFV95Wl9RCPDnmZZETzogrAJEclsgdLcn4ogX30+bMvxSXacGqnPCR5CfN4sGFPLdVs8BG1fc9PS1O6bMaQK3PVtjlemRZ0kxrHycUWd/zDIsJ0hC+tCvDYCoUlbq5E+/+h5HyCgINlnvruoQcGH1D65rJSxfGdrpdsAlvhPedYbMO3rjW66EVdIBg7b+I6X7oKf+moxrhqAqEZ+uCjCKZdWjJ2kkxwXohVchQkK4xww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NS+L8LjS5xYqVwGCbH0JjsuLnyNWzDugJA0WwwNz8E=;
 b=pfqbzyfdRBfm7Ckl0VKancIAnD9e+neqHZZRyikSpQwyPAI/36zb1w0bXZR1Vrgo7wiA9Nll/t90MFv390q7QYFMoRWRP/VCAVmw1661wExakX83aFahduYcodiRrfaZ2DH0AaRuJpzlxvoHpuwEYBS0ZzJYdm7TP7kLr6i4B+CLTxgdJWHwfWZe7Zkrcu8X3r36vEDOp0jho2uWiTmLNbm/RKjW8QaO9I2NY3rJFg5j3QtT8Fg8xG6vkSwCPI481T+DiOYrbimONTwxVBe1JLOJKUfGTFO3Id+uQOB8KGQlxCNlm9ebM3mZ6p9xFxHe6/x/2ccwQGpOjM0VE7MtlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 IA1PR12MB6329.namprd12.prod.outlook.com (2603:10b6:208:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 07:15:15 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::1926:baf5:ba03:cd6]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::1926:baf5:ba03:cd6%3]) with mapi id 15.20.5723.032; Sun, 23 Oct 2022
 07:15:15 +0000
Message-ID: <acb0cac6-17a9-3443-71f4-1f52b2186de7@nvidia.com>
Date:   Sun, 23 Oct 2022 10:15:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP packets
Content-Language: en-US
To:     "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
 <44132260-2eba-1b92-af75-883a3c4e908c@nvidia.com>
 <SJ1PR11MB6180523C0BEBB1AECB72C109B82B9@SJ1PR11MB6180.namprd11.prod.outlook.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <SJ1PR11MB6180523C0BEBB1AECB72C109B82B9@SJ1PR11MB6180.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0293.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::10) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|IA1PR12MB6329:EE_
X-MS-Office365-Filtering-Correlation-Id: cdcd49b1-681f-4a36-ec9b-08dab4c65518
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IP4Ti1IPohuhVlzhmHN4B5sYBxcj83afTHDKkXyD2gzYjSH8fybVxgBgxXfbnV7CqZVC+9etFoD4S4drNm10Lna3BJH3YNEbqrOvqx6alipUR9BDFhfGaRd3dReLcGBRgZnjUbf3Evv9DwKZnK7gG10kq9ss6qPTffOYEUVoNK1lLNuJpZDgpYo5aPNJA0wWwX0YPh8vrNZBHAmkZDa7llsqEbHVy/DYoHgtKZO2yKgRRF4n/emmjQYZGQ1EXS2QoBr4ij8qGkUxc1ayFkM4ctu2XqOKDuKmftvQOQT9bn182eTXnwxRSP1sJiZkwbgQtgabGm7zS8V+GTvycnHt/JYD2oXrwannLcTnLE8E8Hh+0A+YvtQsa/Cq0zuiaRE/LXKv51qkIMFbNh8SWfYzyQVv7zWkBCMLhKfcsmjUXv0mTqUXsnP2Hbbl/OkUdGM8mJ+aA7aEM5B4xTHfgPxFZxXe/1zPnEZwm0EjJFTSur/pltKlCAv8DFczVWLQP+m1RJYFOcrHichWjf6UTBhY23ev9W+z/FLhunaJJA5w8seMCHF3LINHdDZFB1EgDR0Yp64y/Nn6cbj0IMM7mYc8EyxbPOZPyZY0/iKaHGxThA6Yi6RrwzJ/gG2/twJwF7LnzOQ86W86y16YZXB/kuCS0unfaGrC4PLdqXgtgW3r/Idv7mP/N5LlXAZVGYfE63ELJoupnV0vCt1ObUyssvyiBt59/Cb7Axp7BtW74UdEbKB1Sm/MdLwo+3+XwsLKHCVPBLmDxsPxoZoFGZtOSmeRva2GaxccgW8a6njkktgWC3M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(366004)(396003)(346002)(39860400002)(451199015)(31686004)(36756003)(31696002)(86362001)(38100700002)(41300700001)(83380400001)(5660300002)(2616005)(8676002)(6506007)(53546011)(186003)(6486002)(6666004)(478600001)(2906002)(8936002)(7416002)(110136005)(316002)(6512007)(26005)(66946007)(54906003)(66556008)(66476007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z21lcVRJSmpGRlJtQ21zTVpXZkZrWWNkRHNDRHRNaHIyQnIrUVJyTlRDL0Y5?=
 =?utf-8?B?azJ3WXltYzEwZnZyS2F3UFArNmh5cVdZNmEreGw3dTZWQ0ZNRGtIQUtvQnBR?=
 =?utf-8?B?S1lWUFY2eVVSbkhaSTNJYnNHV0FPVmN5YjhxbUZEckdTWHozajhKWlQ0NEhN?=
 =?utf-8?B?L2hJcmhPR3dlNTdRcE9NY1VPMmQvdnQrTm01VnlNZ2QycFMwU0tacHNQU1p0?=
 =?utf-8?B?YnhJalR2dk5YdGtUMVNaRHBrUGN2YUlYRUlBZklCaEZBbHZVTmRFQ0Nkb2ph?=
 =?utf-8?B?NTZJdVZrdlM0V2J6NU5iVGhPZDdnNjBVYnJWd0xxZlQ3SU9zYzlZQ3c2azU1?=
 =?utf-8?B?VWNndTZSVy9TSURhTFBEcTVYeW9TSUJIVjVzYnVFclNkOVl4VWl1bGxIZVhn?=
 =?utf-8?B?MVk2S0Rqc2VSdnNkSHNUUDFhN095ZGN3TUhKeFVEWlFNQ2FhR2NDYk1GeW0y?=
 =?utf-8?B?MFRuME9OYk80R0Z3WVV2dzR3aGQwNVRjemIzWFI5MlBzTHREbDhzb0RaSUhv?=
 =?utf-8?B?bDhjTnR2amo5N25OcjhEN1dReFQ3c011YUZ2TzQ2MUpCK25tUk9MMmRUSlBo?=
 =?utf-8?B?MnRGZmFtUHYvL2J2a3dBVUg2SlFlNGhPcnJKWUhvQnNpTkdvVEc1VmJ5MHd3?=
 =?utf-8?B?NHhLWU5YcmhSL1VHc2M3dlRJeWdueVJzR1FYemt1TzYvZnJIYXZVWXMxcldm?=
 =?utf-8?B?aTZ2MjI0SytQZG1xTHEySndrRUNib0ZURWF5Wk9vTmw0by9JNWhrTE5TNnV0?=
 =?utf-8?B?blV4NlMxcTRFTTVab1JFTjVnZTlnd2hHaDBUNTFSaVNYK09rbVNhMlpUb2ZI?=
 =?utf-8?B?UEdGRWJwRnZOVU5VRjhjRmJWN08ybnpCRDhNQTZKZ1NlU210ZkhHTEMzUTBi?=
 =?utf-8?B?STRpZGNGZzc4cFpWaGF4WTAxbFdnclZJVWdCN3FhWGt4V0ppY012NTdmOUFO?=
 =?utf-8?B?a2UzUjRXQ3gxUW92ZlNpTnBLWk5JQm5CVzh1bWM5bnBMSTNRV0VpMkRkVFhw?=
 =?utf-8?B?d3BrNkpuOVh3c0ZJVkJ1NUhCUjRmdjk4aUMzMWFwRDV2MjlQZDV2bjJUanlT?=
 =?utf-8?B?MDZnSFhIZmR3QlVxem55cEpTY1I3RFVsdU9OZWxkVjBvOVFlY2c5eDVPdjN4?=
 =?utf-8?B?dEFFaUxEN2NuRVorcGZhd2lFcVFNNUJGV2pYMi9DUlJzT1pXSCtyd0MvWHdh?=
 =?utf-8?B?VUdnR2Q1RUlCb0ljTjRBZ1FPMkM3YkcrZVEwNEw3cSs4cTdtTUoreks3cE5z?=
 =?utf-8?B?d053SElCN1hqbVozUGZhY1kwQ2dnaUxtaStnTEJHaGZmSlEyTHBXelhvTjR5?=
 =?utf-8?B?ZXlIc0d0RnRkNjdtaFd5WlZyVytwUzlsL1hkN3EyV1FqZ3d5b1BFQXpXbXFB?=
 =?utf-8?B?WCtyMW05bHZtajE5cEI1MTRBc2J3Y05pUC9nSTNCYm5oV1c0bXl1QmNHM3M2?=
 =?utf-8?B?Um4vNVZ1dUhyZ0hMa09vMERYWndLRzRFbkJKR1dJUHVUUjBCVFc3RVpGTVdP?=
 =?utf-8?B?RTlFZjVaTVJ2WlYxM0FMTE5MeFFXV0hJbkZWTVRJWnRrMjhSUXVBdENkVWVn?=
 =?utf-8?B?R1lHYldHTmZsWm5ROHU4Tm1GdURSMUM2VTVhWmdnN1RnZHEvZXMydW04SC9h?=
 =?utf-8?B?K1M4WDlGOXdveWF5eFFLUWZDWWRSUHlHUE5JMzd6WXA3UjBjdDBiL2gvWXdq?=
 =?utf-8?B?R2F4UHpHbjBsNVpyZnp1TW1Hemwxd0dYc281NkwrR2lHUzBvSzdLd3E0Qy9u?=
 =?utf-8?B?QUlXcTFLd0FVcnFXRDFsaHMxb05STDB1c25kRjBobzIwRFF4ekJ2SVhLcFZH?=
 =?utf-8?B?a2Q1WENxb01JRytxQWd2bEVTakF6OVlTc2U1VDRsVHIrTWVyM1BxMkZEVVU3?=
 =?utf-8?B?K1AzM1dOMmVzYy9naHRJcUxuVnMxQ3ZLaHBtcmJDcWd6bnNJcEZYVmZtS2Vp?=
 =?utf-8?B?cU5IbXhxN01RV01hN04zeitVa0dkVXZJV2xjL3FoZlhIc2wwUVRJU1Z1N29R?=
 =?utf-8?B?cnBRdWZxa3ZZSzJtUWxlREEySWY0QUEwOEpYYXR1YjZncmZLTE9sTFZVY1NT?=
 =?utf-8?B?czFndXdVQVBUajBmQ29UY2ExdUhEVC9JQW1TaWtZMThLajMxOXV5dmhaR2FU?=
 =?utf-8?Q?7mL8t+D8rwu+2FUTNMuNoXzMU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdcd49b1-681f-4a36-ec9b-08dab4c65518
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 07:15:15.2598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ZRtNwtaApmQI208ukgcxMfVPzWKFHPSa/CMLj+btyP33WFTYqQJ/scDG3jgTflC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/10/2022 17:23, Zulkifli, Muhammad Husaini wrote:
>>> DMA timestamps through socket options are not currently available to
>>> the user. Because if the user wants to, they can configure the
>>> hwtstamp config option to use the new introduced DMA Time Stamp flag
>>> through the setsockopt().
>>>
>>> With these additional socket options, users can continue to utilise HW
>>> timestamps for PTP while specifying non-PTP packets to use DMA
>>> timestamps if the NIC can support them.
>> Is it per socket?
> Yes it is per socket.
>
>> Will there be a way to know which types of timestamps are going to be used
>> on queues setup time?
> We can get the which timestamp that is supported through "ethtool -T" command.
> May I know why you want to know which timestamp need to configure during queue setup?

In mlx5 we need dedicated queues which support port timestamp. In
today's implementation we have a setup time priv-flag which dictates
whether these queues should be opened or not.

>
>>> This patch series also add a new HWTSTAMP_FILTER_DMA_TIMESTAMP
>> receive
>>> filters. This filter can be configured for devices that support/allow
>>> the DMA timestamp retrieval on receive side.
>> So if I understand correctly, to solve the problem you described at the
>> beginning, you'll disable port timestamp for all incoming packets? ptp
>> included?
> For ptp, it will always use Port Timestamp.
> Other application that want to use DMA Timestamp can request for the same.
>

How?
When a packet arrives from the wire the hardware doesn't know if it's
ptp or not. Does your hardware inspect the packet headers to decide when
to timestamp it?
