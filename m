Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B47247A795
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 11:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhLTKN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 05:13:27 -0500
Received: from mail-mw2nam10on2046.outbound.protection.outlook.com ([40.107.94.46]:16000
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230354AbhLTKN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 05:13:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIzctoPNqmXOYFT3VLY9empBqjnhjotvwtCNYnhL+jtnNoVIxFDtoOO4tj1dpInGs1bLh5n7wDTnUA6h3PyV+JJQbsBeRRaE0rHrTvgpSV3IJa9D2D9msJqOmKYIDZCOu2rkCLpL0zWR5rTL2gkW2hHyZkxiRODYtrAsJbPD6pUSn8zzXdpkWjwXB/ILBQrS2EENNYNlgRzOqNeuR7vkpq85Xc6ebXsdlD9ojXnldpaB72xi3th6v43TRjc5xmqZ3/QNUFJcaJ7dMX79vnN6PAIMY+33xEijyqJd51bsJhmwNT6PJDw/RLcnZbF6f8c/DESz/0Zp+jjuG8QfVn7trg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0c77hh6zjIu8crlvndxBo7s6vaOthyZS3lQqfbOUBE=;
 b=SYlcVuTse65y/dpe5AvFqi63ikxSV741U8WkMSgvfXe+EzBNiodKcHT4702GEfuGh3Lj5yWZGSJPVN3ouqlyPkVmmAHm6fJKeam4vDNeCyE9HZ8+C/0krLeHAY2H9oIsBUE6lWN7zaicTNk0JPCh7etUg8hZdwoI2I02jdnoSj6VQX38AcZfVq9WpI8gvQIS4rb59nMo2+lo28MGeo74AoflmE17hRtzlHbsFTWwTg6wL7vDHvYoiS6kS4inXVQTMxggwv2RszC8wLBSBz32rjBbvZWsxWHDddQ+7Jubz4YelarUW+UXRxdTPX+oJFZhUar1IcfaBeLu98TeQdnhSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0c77hh6zjIu8crlvndxBo7s6vaOthyZS3lQqfbOUBE=;
 b=F2jMLuoNuvd8QMQP33mEncKgnuD9eO+0lBafTMy2weVeRtwlU1+pvQEIJjm1DAe48mPDHX2JPUS627BQmnzAol9wqssjkxnFejssVsvazjmttj7DA8yUe3gGA7il2r+2IYu/5y/TNCqTx9OQzWNVECgLn3tngTxk2jw+y8ByZ6I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20)
 by DM6PR12MB2652.namprd12.prod.outlook.com (2603:10b6:5:41::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Mon, 20 Dec
 2021 10:13:23 +0000
Received: from DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::101c:b284:d085:c7ee]) by DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::101c:b284:d085:c7ee%5]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 10:13:23 +0000
Message-ID: <24152108-701d-7f0d-6b60-8bde179846d5@amd.com>
Date:   Mon, 20 Dec 2021 15:43:12 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH net-next 1/3] net: amd-xgbe: Add Support for Yellow Carp
 Ethernet device
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Raju Rangoju <rrangoju@amd.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Sudheesh.Mavila@amd.com
References: <20211217111557.1099919-1-rrangoju@amd.com>
 <20211217111557.1099919-2-rrangoju@amd.com>
 <e913ba80-59a3-413e-e18c-f7c0d48712ba@amd.com>
From:   Raju Rangoju <Raju.Rangoju@amd.com>
In-Reply-To: <e913ba80-59a3-413e-e18c-f7c0d48712ba@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0191.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::35) To DM6PR12MB4170.namprd12.prod.outlook.com
 (2603:10b6:5:219::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcefb2ae-7a9d-4e69-6284-08d9c3a15abb
X-MS-TrafficTypeDiagnostic: DM6PR12MB2652:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2652C8C2D7FCBEA9A0602960957B9@DM6PR12MB2652.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wWhI5qbGLaVBDnGVHOR1SCaMdir93VaeNn7Ji42CAxGwoNroZ9hjDais1oWk6ZvcVnw2zVu31weYXeE4I450N5bY4egpVVPLpi4avaOzFtMjCrQIWvH7/RoorSCUoRo1Tw+Yd1rIgm3J/qgcPviwSe7K2LCqfRp/RmY7EUasVvYlFF+CGOU6YrYiKg4h7Jzq2Sz+AgdVk96PoYeCsBVRmlwovCr/4xA/65Eqf7TVEuBt2AFp+X+9Mn6pw/pH6tQwNjy2IzWCgP4SnvD8wWvDJ7DYqxp1hEMEHWfOYCDao1PW/RRnCQQDtFRN2XMnG+g2p+udZ55MOmTH80va4m4i+sKS5gbWrvXsCPYDBLMIl+Xs+kcGOWNBPrdDxSEFxHARukIOFAN46GX8cqcfxOvJ+v+hHwcu1XgXbMb4h2JX5MdNF1Q+CwAz2vuOgjcCllafCPtZnoExOHX+y907pWbD5I/3IRhc0Q0RcUB1XzSzdMlCf4ZqU+z3pk7eJ5rr56FzpQXSeZaW28p5VBB+fn1ISucDlVy1sk1jpY99HAewpcatRhGlDbHB0q8oDfqRnjBjoraIMfLpjMlLatoXdeu1bai8vOqf85KwF6l9fzNbkyAdB2aQtsFTBaVXv3CunvpmtcN/WQDuHn0eWHQtTwd+pzSroYKkVcsh1b+x7InS8AHxBCfTXiFRaWGkWBHXc8QiE5NuQqaoqOr9ifBcxvMH62sPgPv6oRJdw03YunueUwE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4170.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(66476007)(66946007)(6512007)(8936002)(66556008)(8676002)(53546011)(6506007)(508600001)(6666004)(26005)(110136005)(6486002)(36756003)(316002)(5660300002)(31696002)(4326008)(83380400001)(2616005)(2906002)(86362001)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGwvVEkxb0MxczQydmNQRUI3QmJneFRDcWhVdmV0Uy9heFEvUjY2emd4Ykw5?=
 =?utf-8?B?b2JJZG1QckRGTGxkTVVyaG1hN2N5ZE01eTFROEpjVWlGT2VnNFF5NzFmWU56?=
 =?utf-8?B?REJ0THFxUDRoWnhsVmJlTjR4TVo0UWRmL1EwYlkzZmMwMXBGdlYwVTI4OHBz?=
 =?utf-8?B?TXRlV2ZpUnVOWVRQdGIzS2oyYThJV0dhTFpOOTJvZm5qL2V4ckQ1NDhTdnh1?=
 =?utf-8?B?V3lrR1o5ZEZSZ3R0QXFxdnV0ZFhJeTY4Rlc1Y1d3QXZyWmExRlNpS0JmaW0v?=
 =?utf-8?B?bEZ2SFgrckhsYmxtZ29menhOWEFiZi9OZlhwaytGMllucWZYcTRsTlhVWmhR?=
 =?utf-8?B?Y3lQeVVrSk9kRmEwT2doNDR2bmQrMGxGZHFUR2RiUlhSTE8vU2FhS1lSdS9H?=
 =?utf-8?B?Y0dTcWJ2aTdjMnNQTTVlMXFBUGFZT1Z6UzUyOTMzQ3VYMTNYMGRkV1YwUkpN?=
 =?utf-8?B?cjlROU9pUysrSjlaSythTFErYndBQ1ZPSnNsL2x3cWRqdTNmUzNWeGdYdE9k?=
 =?utf-8?B?ZWxyeG9Vek10UEJUbWhURTR5WVpidE1GelBmNnRUaDlmUzZYeElkVXZvQ2Q3?=
 =?utf-8?B?d1lVRUl3VXZUZ003KzJJVkN0QkNRR1p0SnEvRXlhTE92alpBb3YvdmFjbXlO?=
 =?utf-8?B?c01yTW9pNVZjcWdSemRmSWJYS3MrbEk5VkJMWTRwZEkzbFlKZWV2R1VBSnlI?=
 =?utf-8?B?YXptWU5zcUNWaVVhM25kOW9ERHRxU2ZnU2lxZUlhcFUxS25CWEFEZ2FlR2dR?=
 =?utf-8?B?WmFXVXFRL05nT3ExMHdnWWNBRmdOODdJQUlLZ2M0bGFDY2tQYTl2Q1BhVWpk?=
 =?utf-8?B?dnIxNWZZRWs5bEtpdGgzdGxVLzd1eDNOdmtVZW54dUZKWXhwcmNTNlB5ZjJP?=
 =?utf-8?B?V25wcGhCVHU5R2hsVmo2d3VUUUZTSXNjNmk4OHQyZEEyWFFVTmU4WnhnRCsz?=
 =?utf-8?B?YkJncGNSWnJoUndRaG9FcG1UcHhHY3BQbzhHSGlJREQ4TDVra3lBZmFRYmw2?=
 =?utf-8?B?ZEFuQlJVOTRCb3puaTRKZ3c2d0Z4cXQ2czVDV1dEZDhOUlVFVnd1aUEyTUFy?=
 =?utf-8?B?Z1Q1K2VtalV0cno4K3lXZ3ZVMmxUVXVRSWx4TkIwRzhHTlpGNlUxNlRYSzVq?=
 =?utf-8?B?MC8vMEFic0FUd09zQlFBemRBNk1BYUpwa2JrUytHWVNtMzFwMGpmNTNqWllQ?=
 =?utf-8?B?K1FldEZCTDd1Nk45dmU4cmxsb2tSUUtDSndLeC9KckFWbWZjVkNnMVJOL3k3?=
 =?utf-8?B?YzFZT3N3d0RpamtMV0ZzQUhJZ3FadVJLektKMU5PZ1ZhbWFlR0tWakoyYlJK?=
 =?utf-8?B?a252bHZUVkpOVHZlZnhycm9pNmdtcHJ0dzduWEMzc0JELzVBMDMyUk9OSkxw?=
 =?utf-8?B?N3hoUE5kbEpaSzYvRFJ3YnlCbnFvTEd3TERGdDMvRVdTK3dyTWhrZ09YU0J2?=
 =?utf-8?B?aUtET2lQWFVFTnVNb05UR2M0ZTNhZmx1T0VtNDZCVUltWFFueVVxZHNHa3ZO?=
 =?utf-8?B?aTMzUjBmQklSa3BJekNxcDJvOGtiYmpHSWpXQXJTZlZ2RVpIY2hubVg0NjQ2?=
 =?utf-8?B?ZTU2L0d4VGNNWENLNDVYMHg2OFN3SkkwTVJ0SmZnTFpvMHIycXNqOFZVcE9H?=
 =?utf-8?B?b3VPc3hWdWlJbTV5U2tRSkZnaEJNUk5zUHhocmdIOXRrN3Eva2c4MjJZK2FU?=
 =?utf-8?B?Q2k0Q3hIQVFhWjRzS1IrK3JhVGQ1SUtYS1JGc2RoNGE4SDhha2ZQNjlIQkpM?=
 =?utf-8?B?TGtNcW43bkgrNVhKclo5dWk3dVBkSUxtQmtZZzJ0czV0Y0dPcHp2Y05oMDk3?=
 =?utf-8?B?SFBienR1WWFaRHlOMWN2MGsva2h6S3MrY0xyTndsMzZCc1lsL1BxRW5OaTBL?=
 =?utf-8?B?Ri9FMGFtTGVYQnRYVXFBTzJiSWpCczVGbUhjc2UzVVBMVTB6dG1nMVk3cFd5?=
 =?utf-8?B?VDhpNnZsaEpTWWFpOTNGd3lPMTBWMDVpa3JWNmNnekY1eDFpWmJUTEJLNmdK?=
 =?utf-8?B?NmZPSGJ1UmNOTTdtNGlsVzJDMDNlakhIcHpsUFJNVXJnWVIzNlJackE4RThj?=
 =?utf-8?B?dGpSdGVVYlZBL3VpRXRueWFRaHdISk1DUnkyekJnNEFCYm01SmZPd0VzYmk0?=
 =?utf-8?B?T2FGUmZrR240dTVnVDdWL3NBNVRrd0FETE5nanN6UDBsVUlRSjhrc1FlT2NI?=
 =?utf-8?Q?9+hamhKyzfPpS1GDgYI1g4c=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcefb2ae-7a9d-4e69-6284-08d9c3a15abb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4170.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 10:13:23.1203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HF9+FYcWNF1pInDh3quNJlWycdW1o37lIiU/cdPMJe2QzCL0FyKlNCLqMfrCc2rl8QSmeXEzs3/6aOenBKdC/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2652
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17/12/2021 19:58, Tom Lendacky wrote:
> On 12/17/21 5:15 AM, Raju Rangoju wrote:
>> From: Raju Rangoju <Raju.Rangoju@amd.com>
>>
>> Yellow Carp Ethernet devices use the existing PCI ID but
>> the window settings for the indirect PCS access have been
>> altered. Add the check for Yellow Carp Ethernet devices to
>> use the new register values.
>>
>> Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
>> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
>> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
>> ---
>>   drivers/net/ethernet/amd/xgbe/xgbe-common.h |  2 ++
>>   drivers/net/ethernet/amd/xgbe/xgbe-pci.c    | 12 ++++++++----
>>   2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h 
>> b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
>> index 533b8519ec35..0075939121d1 100644
>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
>> @@ -898,6 +898,8 @@
>>   #define PCS_V2_WINDOW_SELECT        0x9064
>>   #define PCS_V2_RV_WINDOW_DEF        0x1060
>>   #define PCS_V2_RV_WINDOW_SELECT        0x1064
>> +#define PCS_V2_YC_WINDOW_DEF        0x18060
>> +#define PCS_V2_YC_WINDOW_SELECT        0x18064
>>   /* PCS register entry bit positions and sizes */
>>   #define PCS_V2_WINDOW_DEF_OFFSET_INDEX    6
>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c 
>> b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
>> index 90cb55eb5466..39e606c4d653 100644
>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
>> @@ -274,10 +274,14 @@ static int xgbe_pci_probe(struct pci_dev *pdev, 
>> const struct pci_device_id *id)
>>       /* Set the PCS indirect addressing definition registers */
>>       rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
>> -    if (rdev &&
>> -        (rdev->vendor == PCI_VENDOR_ID_AMD) && (rdev->device == 
>> 0x15d0)) {
>> -        pdata->xpcs_window_def_reg = PCS_V2_RV_WINDOW_DEF;
>> -        pdata->xpcs_window_sel_reg = PCS_V2_RV_WINDOW_SELECT;
>> +    if (rdev && rdev->vendor == PCI_VENDOR_ID_AMD) {
>> +        if (rdev->device == 0x15d0) {
>> +            pdata->xpcs_window_def_reg = PCS_V2_RV_WINDOW_DEF;
>> +            pdata->xpcs_window_sel_reg = PCS_V2_RV_WINDOW_SELECT;
>> +        } else if (rdev->device == 0x14b5) {
>> +            pdata->xpcs_window_def_reg = PCS_V2_YC_WINDOW_DEF;
>> +            pdata->xpcs_window_sel_reg = PCS_V2_YC_WINDOW_SELECT;
>> +        }
> 
> Hmmm... now that I look at this, pdata->xpcs_window... won't be set for 
> non RV or YC platforms, right?  All rdev devices should have an AMD 
> vendor ID and therefore always take the if path. But only RV and YC will 
> set the values. So this needs to be reworked.
> 

Hi Tom,

Good catch, thanks! I missed it.

I'll re-spin the next version with the rework.

Thanks,
Raju


> Thanks,
> Tom
> 
>>       } else {
>>           pdata->xpcs_window_def_reg = PCS_V2_WINDOW_DEF;
>>           pdata->xpcs_window_sel_reg = PCS_V2_WINDOW_SELECT;
>>
