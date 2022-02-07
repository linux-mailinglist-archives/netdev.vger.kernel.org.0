Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9846F4AC36A
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352359AbiBGPaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377803AbiBGPTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 10:19:50 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FC0C0401C3
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 07:19:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGX7mhu3ZnvQtoydHSzZLj6f6KHzmMwE0NHly4Z1wu+6CoREZ4gP/9rJOHh0ZSRGSx4y3k/OxghNIvTSHVIDDXTIUFN1YSuuUADeFkok8rNM4coMf7adkEUbU20m8jYmTuC9PWRDlcrqXjQqVFjqVdze3M0MiYgIMuiLsgTID2f3V+PuLc4KxL+DiTfzvSS5lUAh8gx/BBbPsRznJOFf2G1gteppXSdO1y1neaP+pXkcILdHMHdIl9WI0PXpHNxy4KUa8/91LHw/GxSuUjzQTD2TA74c0iu3rKxNCMIDxe5wigMLM6nNMlfkA7zTC7xQ2OGmYpZnVhgnfE3wnP0FHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1acHjsfh/esRVv4GSW6gUsYYWfIcSzroTJ1WTDYQys=;
 b=Xf8yvfYRjGp6pmuIB6JKcjsbgP8mAI9JXAHuPST2BVvlnUijPWc0cWJR6c9ICfI91iULTwknu4kWt97IZh9v6NWs0UhGyRUKsIG0qZ/x22mfU3HA77YuRB+0sPl4e5vzuIzM5tf4t49nZzSm1A1jAVGNGs2wgFeULmnbzKBViyoL3j3mLpX6qA8/PFM2idyQ6Bu1oYpX1+yw6adJWIUatFEX5O5Iylk3hcmgLqGcCxsosvk/lQwiFGrU1x+FV4s2Fvg43jc9lQfou8IvFUseFp3BHxnbYsR41mk8H0GLmszyncoPNzRo6HpnRGrBmyGdoLJ5eORk+zhtO29vFewuLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1acHjsfh/esRVv4GSW6gUsYYWfIcSzroTJ1WTDYQys=;
 b=Oq90AEOCZ17cYPrkg6eSghjx29um2bfurKmAecWQ7+c4PmEVKdBS05yxB/0SUgQ25UdrPMSDLP4cigngzI+dt0Pd6XycxhoUB8FxxclkRCNzyKf/AnIjneLRIKmPl4kUZbK6GuiyQ5T9Izc2jXvOoS5lOtGXdqHFX7DaIe+2Stg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by DM5PR1201MB0234.namprd12.prod.outlook.com (2603:10b6:4:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Mon, 7 Feb
 2022 15:19:47 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::c194:a53d:81a2:ddf7]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::c194:a53d:81a2:ddf7%7]) with mapi id 15.20.4951.019; Mon, 7 Feb 2022
 15:19:47 +0000
Message-ID: <06c0ae60-5f84-c749-a485-a52201a1152b@amd.com>
Date:   Mon, 7 Feb 2022 20:49:35 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: AMD XGBE "phy irq request failed" kernel v5.17-rc2 on V1500B
 based board
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Kupper <thomas@kupper.org>
Cc:     netdev@vger.kernel.org
References: <45b7130e-0f39-cb54-f6a8-3ea2f602d65e@kupper.org>
 <c3e8cbdc-d3f9-d258-fcb6-761a5c6c89ed@amd.com>
 <68185240-9924-a729-7f41-0c2dd22072ce@kupper.org>
 <e1eafc13-4941-dcc8-a2d3-7f35510d0efc@amd.com>
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <e1eafc13-4941-dcc8-a2d3-7f35510d0efc@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BM1PR0101CA0056.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::18) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 270473fa-81d9-4a60-8db9-08d9ea4d46a1
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0234:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB02347FFC74A71B091D6738AE9A2C9@DM5PR1201MB0234.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aTR9Qt1UwAXOWGnX5RyP9qTzxfTpGeJFh3oJFtQ7X+uU6f778bCS8plexR73y+Latdjyroy8Mg3D3temFVyghVFlm1IrBGLCVSlA8ueJjmjkwzxOGXJPpo2NustP4UcHydF8l9Vse3cjaNY0rcukbl1ls5DYKaF3C3tU/m1pEvSD1yThHghjmcNLUB1S7nvk1LFDLAtkpIoPr8l5UBDSB+vcVSkwR6eXsXxXqhLVo5XdCnRzgh/dyJBNTwTSOagP3NAf/Wtlf2p/XVABg/IgnBjvNxVdmhwXhf+RGg8AFbPHVc0B9sbOvnpwb6im1klp8lhWhsBJY9thavgz9dTLNGrr79IV2uqPz3JQsUSnPuIdz+o0RjhB9Z8+zJeuJZDQ3a7rqs7nlmeqpIq/6LeB5ipzzZaVKXGSR2UwBD34ho8v7srFytgHhMjVXIrlC4geF/onZvSkisDUXVEOuSpZmdrihk/w/o8PjKIpqiGvUNbwZd8Ylk7FZRReByjdLuEm0n6fIIuFRfnr1PjGDaUi8d+xKsGQaqLSzY4GEJcPUDxlVHLLxssKLVIruKqCFrX2IJFZcCLJ6jeq8s8r/D8/Reow1oIyhRPJ5Wn5bFvQa2A2sujRK7MDvLiYrzVObSbEPausaGyBuz8WJg+p6IiD4cWFE+n2FR1Exp1cYTNKpeW+aAZFgFrLXvIxrGFI9jr1Yf9hGqKA/OR1/3jqF7sW8KOxPZZzw/Oj3F0MUciDh4Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(26005)(186003)(2906002)(5660300002)(53546011)(6506007)(6666004)(36756003)(6512007)(31686004)(83380400001)(6486002)(508600001)(66946007)(31696002)(86362001)(8936002)(4326008)(8676002)(110136005)(316002)(38100700002)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHc5Tm0vSW5qVCs5ZmZ3Q0JLaGxEZnNoU0M4YzV6a01hTGxINXFmaWF6bHBl?=
 =?utf-8?B?NW9DQ2JmRG43ZmoyWG5MQU9FM3VSZXBkUHA0ODgzbGNCOXZKUjlhcWZqbWpj?=
 =?utf-8?B?b0tuMVd2eTNUdFNnUU1OTVUydlc1dVg4QkpRZ0Z5K0U5YVpXbHNrTXQ2Rlda?=
 =?utf-8?B?a1cxS1d5dFd3bUNVcldXNzlZUG8vUTBPdmRySDdkdGZ2WjBXWnRMaWZVQ2ZT?=
 =?utf-8?B?aW0xUjZRdnBTcFJ0SUhST0FmMmxtYzU2a2dOdkF0Wk9lUXI2d2JzQ05DUFJ0?=
 =?utf-8?B?TkpPRG9pdHFSbXZlMFJSdDdhS1JrcjNFSW1DcENIMnhMR1RxUzBINlpoMkhY?=
 =?utf-8?B?YmhLcGJEUkhISWRSMGFxUFRSaU9xaXpncS85Z0NWSzhzVEQ5NGlNeVdTT1ZX?=
 =?utf-8?B?RWN2ZzYzTENWWUhoS3IxTWtsY2F6c2dWbCtpOWtGK3p0M21xdDNOY3BndzhG?=
 =?utf-8?B?dkNnUnJPNWN1VGRxK3dtcDk1VHRESUFXQ3ZSYnR0Q3FoVFkzWFFodmVxazAw?=
 =?utf-8?B?SkJRMkFXT1dJMGVudlQ0RlVHQm43bXZjS2hMT2xOSi9zcUliMU1ud0g4OUU1?=
 =?utf-8?B?Vm5OMm90OUJyQWhwMzk5WmFGdHFMdVQ4VHJWY1Z3VEhXWFZLZFBrdGc2ZnU1?=
 =?utf-8?B?dXB4OWprWGwxKzZ3dGYwbUxvK0wyU1BlTWt3UnkyN2FtQTMwQ2ZFL1VGcEJh?=
 =?utf-8?B?L0gyd3Vsb1IrWnRIVFJ0d1hPVEZxTzhHdlpJYnpFRm5hM0puSyt3SjZGWG9j?=
 =?utf-8?B?b0pDVFRNZ1ZCaUVwMnk3dU5YMmlaYmFIUytvUUlYTmVsWnBVbVE4MEJBNE01?=
 =?utf-8?B?bHBYZHhwMzJGL0NIb1hYUVEyM0g2SUcyS0FTSkhZMG1sbmNyb01CTk5leUVm?=
 =?utf-8?B?NXduaGFJMGxtQ04zMkFWQmQxcGpTY3lqQUhrZDJOUFdncFJHZXZDSHFRZUdB?=
 =?utf-8?B?KzRHTk1iWnNBdEVPOWNNZG1iUG14ZG0vWGNmZHh0TzNkVnN5SkpNVW0xcGNk?=
 =?utf-8?B?bnh1VXhscTJmQWE0WDBrbW83SVB1eVAzNmo1bWVMV3p1ajZkYnVwWGFzS3Zt?=
 =?utf-8?B?bDJtcUpOd0IvVm5MeGVCZlJ3ZU0wenozSzdFQWI1NVV4OWpuMHhDekorTnpW?=
 =?utf-8?B?M2VTLzNvWDBJSWUwNGEzRGw1Q1pHWjVaQkg3b3RPU0txYlFXdTMxN1hUbnNM?=
 =?utf-8?B?WjlldWMwelZENjdBK3pIcXBVcE1EYUROaWkyOFZQRFlWbDNNWVZabUxCSUg4?=
 =?utf-8?B?N2RiR2p4U095QkRJd0xNb0hORklzQjhsYkpmaGR6eVAwRWpzSDZKTGxCQlNl?=
 =?utf-8?B?RUpOK1QzVWt3cXNoL0cxV3l4ZGFCN0preXJyYlp6UG1lMFQzZm1jUHQ5bG5Q?=
 =?utf-8?B?RlJNOUNQdTdMVVN0Y2FJczRCSi80VGQ0WlNqNmcxcVJXbGpNNFB2QmU3U2Q5?=
 =?utf-8?B?MGNUNU9YUGl1bEMzRjhGamVlUUpCMnNIeUNwRE9EMi9OVlVTalVOaUEvSjlP?=
 =?utf-8?B?bFhwSU1rT0VoK2tTWHhnUzRWRGVEREFzOXlta0szaTV4K3ZncEFXbXQ4R3BD?=
 =?utf-8?B?RDk2YStqbnVyV2VrQlNjWU9pTU41S3JJVnlHUjEzRlRyUkRLN3pRR1dHMTlp?=
 =?utf-8?B?cExqUWR0Q0FXeHY3MjVndlJ5bGdnSnJWSnQxaTBnSVF5LzF0ajdwTE9xYVdy?=
 =?utf-8?B?YkdPbDZhYktJckxUREJYdzdkZ0E0SWFML2tLMzRwSmNFVnBHTm9rZTByTFdC?=
 =?utf-8?B?YXpaVDJKcmZtNUNQV2VOYXIyekppZVNxSU43YVN2UCsrRjFIMkJHK3ByMnQ1?=
 =?utf-8?B?N2VmcUxxWk02N29lUWtnK1M1djIxQlJHZkYzWEExSGROVXdTZzJwTmZaOEtS?=
 =?utf-8?B?aEtEQzFCSS9YOVh0Rk5nbGxVVzQvb1FRa2ZubWgvTG1Iajh4blRpQ0JDWXJi?=
 =?utf-8?B?cHlsakdRNlMvS09YQ3NRdDN0TUxlUlNURVFWNFQwc3BhdVpBMnp2cVh6ZlA1?=
 =?utf-8?B?ZjhiMzZhVjg3WVQ2VFBXM3VoVlE0UjJjckVVU0Vzakh3RGdUb0lGeTdBRjl2?=
 =?utf-8?B?dFE1TUhud1BwbFBqOFloODFUV3NvSkVWbE5qZjBtcWhIWjFuVXpQcTFaU0lK?=
 =?utf-8?B?dUlUOUdMd3pCWXkrWmVoVGI1K3ZzcTU0bGJ4SytyQVFLMFZJLy9za1dRV1Fn?=
 =?utf-8?Q?bpbe+Shul6WCYP/nwr1rm14=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 270473fa-81d9-4a60-8db9-08d9ea4d46a1
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 15:19:47.1446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kFxn181E1CVpM3b8J6vOuz5WtA225XCKsrRLMCMaR6qF3pem7Q1OMtagxBOsACZM+ieP91YTDhMe4Ce/X2PTsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0234
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/2022 8:02 PM, Tom Lendacky wrote:
> On 2/5/22 12:14, Thomas Kupper wrote:
>> Am 05.02.22 um 16:51 schrieb Tom Lendacky:
>>> On 2/5/22 04:06, Thomas Kupper wrote:
> 
>>>
>>> Reloading the module and specify the dyndbg option to get some
>>> additional debug output.
>>>
>>> I'm adding Shyam to the thread, too, as I'm not familiar with the
>>> configuration for this chip.
>>>
>>
>> Right after boot:
>>
>> [    5.352977] amd-xgbe 0000:06:00.1 eth0: net device enabled
>> [    5.354198] amd-xgbe 0000:06:00.2 eth1: net device enabled
>> ...
>> [    5.382185] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
>> [    5.426931] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
>> ...
>> [    9.701637] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>> [    9.701679] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
>> [    9.701715] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
>> [    9.738191] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
>> [    9.738219] amd-xgbe 0000:06:00.2 enp6s0f2: starting I2C
>> ...
>> [   10.742622] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox
>> command did not complete
>> [   10.742710] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox reset
>> performed
>> [   10.750813] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>> [   10.768366] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>> [   10.768371] amd-xgbe 0000:06:00.2 enp6s0f2: fixed PHY configuration
>>
>> Then after 'ifconfig enp6s0f2 up':
>>
>> [  189.184928] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>> [  189.191828] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>> [  189.191863] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
>> [  189.191894] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
>> [  189.196338] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
>> [  189.198792] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>> [  189.212036] genirq: Flags mismatch irq 69. 00000000 (enp6s0f2-pcs)
>> vs. 00000000 (enp6s0f2-pcs)
>> [  189.221700] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed
>> [  189.231051] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>> [  189.231054] amd-xgbe 0000:06:00.2 enp6s0f2: stopping I2C
>>
> 
> Please ensure that the ethtool msglvl is on for drv and probe. I was
> expecting to see some additional debug messages that I don't see here.
> 
> Also, if you can provide the lspci output for the device (using -nn and
> -vv) that might be helpful as well.
> 
> Shyam will be the best one to understand what is going on here.

On some other platforms, we have seen similar kind of problems getting
reported. There is a fix sent for validation.

The root cause is that removal of xgbe driver is causing interrupt storm
on the MP2 device (Sensor Fusion Hub).

Shall submit a fix soon to upstream once the validation is done, you may
give it a try with that and see if that helps.

Thanks,
Shyam

> 
> Thanks,
> Tom
