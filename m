Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6BF644B00
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiLFSSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiLFSSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:18:07 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2069.outbound.protection.outlook.com [40.107.212.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154ED766D
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:18:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVoAI5mNXsEt0npICDImy16VjtyzlVO3+mgXJczQcoh0QK8dfeKPA/+V/DevURiiT+GhmmwfR6ynbKnGhQynKxvU9j4ZU5uibLlPQvW9qGKLTbISxxpYVVNCDg/TC6ArRsdMCAH0m6bRsixz34fgubyztdJQMUg31+tB0mTYjQ3SxIR7JFfURZ7x3e/zm5VS6bBivboJ/gEqVlMlJZ1XioC2gg60ln7+9W6HK/8lO/erEbSImgNfCqVYfKE7xxbEU5W/12MHB7iIsZxd5CulQUdNrnBtxwX2eX5pZz/GQBX+Vpsu1o5hWa4kwc4IL7gNXiHB+/t3KW64RiGU/pHL/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8aCYm4yrBsqpqtpBjIiFW5EQ+ca4O6oY79N2AfXpHfQ=;
 b=fycBG40c37NIU3MjTZtyO5VCwYnyxvi0Y71f+BBHjCwZYOt2rbHK1C7hoI8oQWEO8kgnQi0PLePNCq6M6ZCpd0e0BjkXjuh2cQPP569mvSr94d0Mw+WpmA80gMhZmr7StPcjLTifJ1rMbowZNqlxvL8AyuADcfWMeDhTDTigEhHslfps3P6lQnUjZqiONqe+UOiExk4GT3xTfK78b0HTjCKutF0E5QFlu3sy+m+jeh67N0k9+mKbSQ4jBS8w0AAVzyBG4U1kcgJ52GJ0PLDsxZYpQLPKUJAWWatryQpnXiNdOgnTdQq3Vl14YeMba1RzrKaGY4UFeudf3+jjPSLltw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8aCYm4yrBsqpqtpBjIiFW5EQ+ca4O6oY79N2AfXpHfQ=;
 b=zOBbxx5y7fdHMCigxYXG8tk5kDJ9He3+iKOQqvsTi2iD1V8PbB2iwwBdVYMEsRq6XOOn3gDjLOJ0wdHeSlOgQKHSRxkQ2UijtB4Vbs4ak1GJWgEQhT/w3ypAtWAkhpyIDtInwNEGT5WmlTsYU1MopABeXFYX4GYyde3GjI1MEkE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 MW4PR12MB5625.namprd12.prod.outlook.com (2603:10b6:303:168::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Tue, 6 Dec 2022 18:18:03 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%7]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 18:18:03 +0000
Message-ID: <1d1f00e2-6c71-9a60-e83d-4b1e521c82fc@amd.com>
Date:   Tue, 6 Dec 2022 10:18:00 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 1/2] devlink: add fw bank select parameter
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <20221205172627.44943-2-shannon.nelson@amd.com> <Y48GR+NShwJiIBTc@nanopsycho>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <Y48GR+NShwJiIBTc@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:a03:254::18) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|MW4PR12MB5625:EE_
X-MS-Office365-Filtering-Correlation-Id: dff6b138-f861-4230-705d-08dad7b636ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZiDqYiCFMB+H7JCF5JqGOlIYD1qMB/OyXiF5zJ7/2W8qGSQi/WJTVSq5H8nNNeGn6xB9OnAQZiy8Qq+ddD/ihtSnODQFttMQgZWFlZahXV0NbedVWFIl6JU6XYjMmw9E/wzQ25c10ViAAPVUfMEYEiNT3F5XDCggzqH2xRKfLPKXw+HFMg3/gVMZFFDH4oVmc8rK2nn19rReoRV6jscEL3KCX36YjSbk4nVeYZ95LRAIrmYxc2VOubbJGfUlyfSYo0jqHTm5j1zWTvDERFE1VdjulJZkWXN/69mpyZayfeg25sHHkW+Oem0gsdggFTji5Of3dnDf5AbCaUMAnBS54OeUwRcRL7oIXmHjpDgO7Wv6V7Eg3mS1lr0OyCz6uevyPBognWSZy/4XPgkm4lF4xr67qlZ9gW/KN7eB02sMKSiUDeWKLCtzZllhntTxVIobML+uFxYPc8REiaw0G7Wur+bnx5M+Ikx16Xnn4V8dN4DnjHPrKOU3ALGCe+SNyAI7TdqKtilKOoJx/tJSKhww83W00TkHp1M4u25Sw0Fo/YNPIHFy3iov9DyoJL7dN21Ma3WFqWhjRNgUxM2U6/dDv7bGGZJthlw+6lUpXLHcI/7+QG7NPtXsTgfaZZir3kSI4wzP9W8qQ8ySrN5UI7CaaVX+boitx6IlVhjQ9QzHGH1dwE8clh1wPvM629WwK2ML4Sp2fWZ/Sk2hNwX/EbRiBHNH85nhxmCCzrp+Hz9asHj1+Y8HbvGLXc+9S4PGOnbJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(451199015)(83380400001)(86362001)(41300700001)(8936002)(38100700002)(31696002)(15650500001)(2906002)(44832011)(5660300002)(4326008)(8676002)(966005)(26005)(186003)(6512007)(53546011)(6506007)(2616005)(6916009)(45080400002)(316002)(478600001)(66476007)(6486002)(66946007)(66556008)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFJNUmFJdVRWUFZCc2JiMGhhOWluelVobndmMDhiSm5kc2JRNHNtME53dFVy?=
 =?utf-8?B?R2lNV0lQR3dkVmxTQVY4ME5iQnZFYjljOWZ1TXlmN09IUkdPdENnRXlPZTJF?=
 =?utf-8?B?NDE2TnNHRi8yTHV4WDhsblZFa1Mzd2hxMVFEY1YrRHNLdjFoaWFkQ2FtVldO?=
 =?utf-8?B?aVZ1TWxWYkFIaTcvZWtiL2U0RU15VEtjUVBpcGVGb3h1NytnR0NZbkRCZmRB?=
 =?utf-8?B?b1pxTkZrM3lPQ3FNMHFCazAvVUNIdFFHUzVxeDlPc2JzWVo0cmF3dkVYYkRY?=
 =?utf-8?B?QVZ6YWVqUXM1VVZWMUV1M3ZGMCticzVPVjB6a0MyczgvU3F2L3M3RVd2RmVp?=
 =?utf-8?B?anliQ3FLMjlRQU1GeGhpaGZOK1FXMjdFTnV5TmZZU1BRZmM5c3hJbStrU2l2?=
 =?utf-8?B?TnpRdU45RVR1SHJ6Z0pPbUtWQzNpQTUzQms2aVliSlE2SnQrWFpiZHE0UXB6?=
 =?utf-8?B?SEozMnNLdExEbk94WGRaSWZTOTJ6dHN3T1hXTk8vZXd2eU9ueEJFVTlzZ2ph?=
 =?utf-8?B?ME80Wnlud3JjTUFVVFFZY2lDZWZGdnAvM0ZVcForM2dvUStKK05iZ2IyV0VQ?=
 =?utf-8?B?QkdLM1IxQlFvRFo1U2FTNE1SVStvNTAxVWtRNW51SFI4czZyWFlCQWk3SSt4?=
 =?utf-8?B?d2V5YkJmV1AwQlBzamZBdzVDOVhUWFg4MHlvbDQzd1hPUTNITHRJUzhjamhX?=
 =?utf-8?B?M2ZhbjNvRkFNS1AyVG11ckxvTStmQUtJOGJJQ2hleDNqKzBLQjFlZUs2U2to?=
 =?utf-8?B?VDByMjZOZk5ROTJZUXVTeUFIcFB2dHhKazZpMnBwL09RRDlKRWVjV3BYdS9m?=
 =?utf-8?B?REJZWHlBSkNwUzU5KzhlcTF2bTdPMUpoMEJVSVdDS2JKT2UwdUU1bjdmV04v?=
 =?utf-8?B?cmxqS1ZFc0RKQmRQWm5TU0VXVXRqVzZrUmFGSXJXQit6eStLMWUzUVlxR2RX?=
 =?utf-8?B?aTZwU0t3UXFSNVlvR25SOGpyWDVCZ0NqY1hINldtZzg0b0RsQTM0SU5sOGxp?=
 =?utf-8?B?RzE4S0tSaU5nVUNYNVduOTJnVjRzZGJpbDdabXpId0ZVZzdZQ1NOMU80ZE1T?=
 =?utf-8?B?T0xhcyszMlIzR2FhNHNpbVI4QkxQaElhekwxemlaUHdHNUVDYzc0cWFuS0sw?=
 =?utf-8?B?Mzk3S0VBYUh0bVpvUXl2Z1BXMDdodU1uMDYvT2lLZnFzNDJWMFYzV2Q2L1dI?=
 =?utf-8?B?V1JVcHk4ZmJJNFJrWkZ0TzM0NzBka1llZzF2WU4xd1NpRUhsS0IwSkVMU0Zh?=
 =?utf-8?B?YkUzb2EvVU5TeS9MNG94MVBxUUFNVlI1QWN1SzN5bXlYajV0RnNCWmJ3MDJR?=
 =?utf-8?B?QlI0bUUyWUNQTUFNSXNZYzdtcFBuWGl4RE40TFhGc3B2c3pubnhTU2poVFVI?=
 =?utf-8?B?NHZyS2JWZjRCb21ZNkpUQ0N2VXhVd1ExdlZlWnVia2NTV0Q2b2MzS0tIaEcw?=
 =?utf-8?B?M25QYlMwOXUvR3BTTGJYL0pFb0x4RHJUc3huK0puSmROZWRBTmVidHJRNG1x?=
 =?utf-8?B?NzliQjBJbDBRb2cvSXJKL3AxaWJaUlJ0NzZFTENuM0lXRUpjODBzWWhOOWdo?=
 =?utf-8?B?cEhlUTNZOHF3by83OFlnL2tCaEU0UHpZK0NNT0FCWmVBeVIvM1QwNE5yYzk3?=
 =?utf-8?B?cS9SWXdUbEFvSEJnSUhsTllmd3dKTXVCbGJ4endnTTdFUmZQV0pRdExva3lm?=
 =?utf-8?B?OE9HS00zTEVBUC9RejJiSlFxemJCZ0w2bE5Dd24xSEFZdFdPejlMaDNPR2Zt?=
 =?utf-8?B?cDFlZlhkL1ovVXRrcmZVdlJHNnVzQmdDQVZ2bTMzMWx1UjVIRXZDdDIwUk4y?=
 =?utf-8?B?VjlZZnZpL0dnMW9BNnZzR3BicWhVa2ljUURYL2V4SlRrazZrMmI0ZGFIQWpB?=
 =?utf-8?B?YUlHZ1J6T25wSUFkVkNhU2liVmVjblY1emxlalJUM3BhVTUxWEtpY3lEeG9Z?=
 =?utf-8?B?V1dETnV2eDViNHZCbTFKN3hQWUd2Tnl3b3FSQTBUempBVVRkcG10T2tWem1k?=
 =?utf-8?B?WDVpaGxGTHM4ZWxKWlh5Z1VMcXZNc01BeFVSbHU3Y3BvR25DME1HUjZBYzB2?=
 =?utf-8?B?SEs0WHF3TkpLWmNwODNjb1RCUDhEeWhxKzE1ME1JOE1rUXZaKzBOM2JSam5G?=
 =?utf-8?Q?F2yagiKDHWHeG/f6sydV1lgLV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dff6b138-f861-4230-705d-08dad7b636ca
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 18:18:03.0852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQYdq4i3bLGHHsSMO6mVP5e27EQ5M/EdU/ZuIxJ4y316Q2OxSHUBXqZ7tTAWcM5jr/TeCzp70nErsyEP6vcqXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5625
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/22 1:07 AM, Jiri Pirko wrote:
> Mon, Dec 05, 2022 at 06:26:26PM CET, shannon.nelson@amd.com wrote:
>> Some devices have multiple memory banks that can be used to
>> hold various firmware versions that can be chosen for booting.
>> This can be used in addition to or along with the FW_LOAD_POLICY
>> parameter, depending on the capabilities of the particular
>> device.
>>
>> This is a parameter suggested by Jake in
>> https://lore.kernel.org/netdev/CO1PR11MB508942BE965E63893DE9B86AD6129@CO1PR11MB5089.namprd11.prod.outlook.com/
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>> Documentation/networking/devlink/devlink-params.rst | 4 ++++
>> include/net/devlink.h                               | 4 ++++
>> net/core/devlink.c                                  | 5 +++++
>> 3 files changed, 13 insertions(+)
>>
>> diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
>> index 4e01dc32bc08..ed62c8a92f17 100644
>> --- a/Documentation/networking/devlink/devlink-params.rst
>> +++ b/Documentation/networking/devlink/devlink-params.rst
>> @@ -137,3 +137,7 @@ own name.
>>     * - ``event_eq_size``
>>       - u32
>>       - Control the size of asynchronous control events EQ.
>> +   * - ``fw_bank``
>> +     - u8
>> +     - In a multi-bank flash device, select the FW memory bank to be
>> +       loaded from on the next device boot/reset.
> 
> Just the next one or any in the future? Please define this precisely.

I suspect it will depend upon the actual device that uses this.  In our 
case, all future resets until changed again by this or by a devlink dev 
flash command.  I'll tweak the wording a bit to something like
     "... to be loaded from on future device boot/resets."

> 
> 
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 074a79b8933f..8a1430196980 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -510,6 +510,7 @@ enum devlink_param_generic_id {
>>        DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
>>        DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
>>        DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
>> +      DEVLINK_PARAM_GENERIC_ID_FW_BANK,
>>
>>        /* add new param generic ids above here*/
>>        __DEVLINK_PARAM_GENERIC_ID_MAX,
>> @@ -568,6 +569,9 @@ enum devlink_param_generic_id {
>> #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
>> #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
>>
>> +#define DEVLINK_PARAM_GENERIC_FW_BANK_NAME "fw_bank"
>> +#define DEVLINK_PARAM_GENERIC_FW_BANK_TYPE DEVLINK_PARAM_TYPE_U8
>> +
>> #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)    \
>> {                                                                     \
>>        .id = DEVLINK_PARAM_GENERIC_ID_##_id,                           \
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 0e10a8a68c5e..6872d678be5b 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -5231,6 +5231,11 @@ static const struct devlink_param devlink_param_generic[] = {
>>                .name = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME,
>>                .type = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE,
>>        },
>> +      {
>> +              .id = DEVLINK_PARAM_GENERIC_ID_FW_BANK,
>> +              .name = DEVLINK_PARAM_GENERIC_FW_BANK_NAME,
>> +              .type = DEVLINK_PARAM_GENERIC_FW_BANK_TYPE,
>> +      },
>> };
>>
>> static int devlink_param_generic_verify(const struct devlink_param *param)
>> --
>> 2.17.1
>>
