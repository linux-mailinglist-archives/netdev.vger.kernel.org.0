Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B563628AD2
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 21:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237373AbiKNUvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 15:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237084AbiKNUvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 15:51:18 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23467178A3
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 12:51:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpxt/kS5GOzV6/E4iETOwJppfycVd7KLisOTbMigSP2g+o7rfMR6v3O7xbhezijj1Aqa4TTXGM4fkuP3HlJD0QOICC+dYd/0YYzWLJJ9X9qHxPevymXxgJEj+dfxC0AZbbYkuEm5ndqoE8OCPY2XjaTF+Egna6gFYM/cuwnfT44M0PatoDtHjlboRaevTZIvwm5gi6M0W0MQZE/yD7KOIh0GZ6Fkdb6cIbHALfUT+9K3ewpUFrvC1wN2giw+aLnpo0K0XDmBNcdme7erFpt1//KE84QMnNv1nE/tzYt1fXFuRLtDb9/74qmmeBm2VsB73fAycEDm9DpTeF3RUt9uoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnaSn6KWqg+IJm3sP5HxhCG3MrKPJylZNWQa/zxr2ds=;
 b=Wu3QHGmW/VMMqi9XYlsVAYyXY79GuPvbtpYBigk7Q/jSWuVHYJssYSfUBSZZVUkDY9syFo8f65H3pxS0/rC17pH6S7bo6mXDdoNYxyXuD3O7gQRTcJAKsL+11jPa22caIzyjyd+OmuxLEKiA2/lFsN4A3dmMq6ykduPCuoaflQS6O1YnYPhHZxn/JMU6U27h7jurUrnmhYatLvIwAl3Ng+zEBzWOHsLdUjbjQeyDgAvuX9TyMobMcB0JIvYMPRPGSAY7AMKoUmpQssy5Uws8K51ufBH2oMgWZqi7rtgu48582q+Ncs0Y5DFw6SCW9BCz9asCmv4yk6HBAyH2+nD+Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnaSn6KWqg+IJm3sP5HxhCG3MrKPJylZNWQa/zxr2ds=;
 b=Fp41dHLQAd8WONvpmRXQylU9JqUUcNFqaEhGDRIfMp2GIvHyQvn+eBtayvDLjWMt4qyT905b/Op9k+SUAlc1B8WXCqE2x42VhxEKm8JvpD+nPoYmTe220H6ZdA7d/Tz4xpI3cxXhYB2XU4klm9fGnmAjOktYlY68gpBvhvF1ZoY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by LV2PR12MB5919.namprd12.prod.outlook.com (2603:10b6:408:173::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 20:51:08 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 20:51:08 +0000
Message-ID: <e80db268-3aca-e5f7-6eb0-4ba88999a7a8@amd.com>
Date:   Mon, 14 Nov 2022 14:51:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 net 1/1] amd-xgbe: fix active cable
Content-Language: en-US
To:     Thomas Kupper <thomas@kupper.org>, netdev@vger.kernel.org,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Raju Rangoju <Raju.Rangoju@amd.com>
References: <b65b029d-c6c4-000f-dc9d-2b5cabad3a5c@kupper.org>
 <b2dedffc-a740-ed01-b1d4-665c53537a08@amd.com>
 <28351727-f1ba-5b57-2f84-9eccff6d627f@kupper.org>
 <64edbded-51af-f055-9c2f-c1f81b0d3698@kupper.org>
 <9180965b-fe96-7500-d139-013d1987c498@amd.com>
 <5fb7e87f-83fb-252b-1590-c6ff5862bbaa@kupper.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <5fb7e87f-83fb-252b-1590-c6ff5862bbaa@kupper.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0275.namprd03.prod.outlook.com
 (2603:10b6:610:e6::10) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|LV2PR12MB5919:EE_
X-MS-Office365-Filtering-Correlation-Id: ad4dc80b-f395-4377-29c8-08dac681f471
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Umz4i8xq5/2WI2dNIIck01auolBaGpbiNJBIKo3/3hg6Uv4B+y+Ynk5/NiyUI+iUJKKuWqmJqvu2ilhpGuyJEGGYAw3UTeIgYpy+1r66kRHHx5wnRnoNcbaytO7xqRxpIDc7r5L8QqGoigUBqnbl56qV8OqveJlKCyLySwhh2+YQnsyuH1S1m6yU/wVA3460/vty9wZ1IN+Jagd3VS6ZQBe0jTXWgQFAaYPbuRQv/52GnBRFDXXOBJvRqyX00wVfvWZXTMOQkh3gBfIa/M1JisCKESRTx+WDGrz4AOxmru3qXVi6zBzD/dV85SpfMc5Jzc1yJlMoUeEg70+me0UvJp4eBwYJVAmNUInDFyZ95ra5z5/0Rj78IwE7C2UyTMuKGRE2SeZlvg/GfdeQraIN9yZjIjtZXnOibMOWE6zUgynXQVMX60JiKWEfnq8zj/JHXEN3q2mgxA5JhQtElfberekfzxd6gJ2Czs1YAR7+rmOeenc4oNUODQLf/cLpDG6jymxfis3RIol18QEks4ju/jObp9o469M+egehHO4Y486c3gafQcyc3qjJ0zQL43FlBJ1AbvjCc1M+OVAOhQrxJgArB4DD+ivzOEOTTPPIOPY+wN3WY54bOHE60fa2yR0A7T1mZgE7hpd8KnAoA8WPhXKbmxngvJwepj9kg8zSDshe8Ll48FwCUJ5xByrF1VVq1rnFi5oUY+PB/EhdXFTDh7hCEdcCVMM/je+pC7Nm0d0VL68GykkzBh3xGwtHsAkykMBcgmVRLiRNTeWNFaMH9fM1zFyXGJyEaWq/BJRiIEY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199015)(2906002)(31686004)(36756003)(26005)(41300700001)(8936002)(6512007)(31696002)(86362001)(5660300002)(6506007)(478600001)(53546011)(6486002)(2616005)(186003)(66556008)(66476007)(4326008)(8676002)(83380400001)(66946007)(38100700002)(316002)(6636002)(110136005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVMxMS9yUGFsa09ZbUZGamhYY2dKSlkyNDFjTFZ3ZFg1QTdrQXllZnJhcDlB?=
 =?utf-8?B?dHhjaWxTODhQMVlLOStLYURnTFRnczVFdEtqZ3BKMDZNQ2hzZGN0Y0JFeWtp?=
 =?utf-8?B?bXZDRVJwSmVURTB4UVVCT3VBOGJZcmt1ZjUvWlVuVzRHV3dHcHQvcFRLZ0hS?=
 =?utf-8?B?VWpOUE1wazI4L2JYS2tjYnY0NHZ4YTQ0aldEOTRQU1JhdWFNSVpHd1lwUjhD?=
 =?utf-8?B?d0RWTWM3M1hLTEg3amtYdmM5WkMvdzl5azZ0LytBUWJhNXRJTHNHd3dreHZY?=
 =?utf-8?B?YVZlb2ZEejRrTmlhdStybzlycWgxR1RxM2kyZlNxSkhUTHJPeVg1dDZDdGNJ?=
 =?utf-8?B?dVlSK2FIWkV5MkhIK29uYTAweVRPTFo1TW84aEFHMEdnZlY4elZBZ0k5RHpQ?=
 =?utf-8?B?VENweEJ4NytlRENYc3hNcGM5dUpuMFVzbUxhWjRsRjYzR0VyNmp0WHppYkVx?=
 =?utf-8?B?OTZQSGQyUm1FZk12WGl6YzB6OUhnU0dOL2FHWjg5dExFUC9BTHk1SW91K24y?=
 =?utf-8?B?VXV5MDJCSTIweGRidXVaWXljZjJ2OTlscGlod2tHYlhLb1pBdll0NmVoN0Er?=
 =?utf-8?B?TjBvaXRUdS9UK3lLWFV0d29aSGtwTEt6N1NZZnBjNFVYbFh6UEliN1pBajRI?=
 =?utf-8?B?djBaMEJ6ZC80Y3M4Smxycm1DQjZKQ1R4Yk9Ja2NPVGxRbHl0ckRYSEM0REU0?=
 =?utf-8?B?YUZvbWNkejdIYXlTVFhETU9nM0cxbzJJd1RpSUpuOHVhdEFicXBaa0Q2bEdw?=
 =?utf-8?B?Mis2RCs1QlI3NTNITTM5VytjME5xaUJVRlMzdk5TcXhNNDhmcE5Zcm1PNmp0?=
 =?utf-8?B?eUdYalF3RUsyclp2RWxJQVNQNUMyQUoyS2JMc1RTVWQ5M1JueWh3UFpDMjha?=
 =?utf-8?B?YXFlWTZyMTBFVnMwZGRhNm9DZStFRkNMRDE3MTk1dmQyUHB0TVZ0d3hTTFFH?=
 =?utf-8?B?dFBOdXlFVEhqV0xuenRYK3hTZStnNUlFajNGaXNEMW1UczJXZ3o4enB5ZVNG?=
 =?utf-8?B?Z1VuWUduOVVseU5WdHhIY2kxZ1Q1bzJSV2hoRldseWFtRFJhb0dqR1lDVFlC?=
 =?utf-8?B?aTdUUjBjQXRLTC9YNW9vRVQyM2ZiTFVlT2Z0Q3dyd3dsVlFINFBpSXlrdVR1?=
 =?utf-8?B?M3J2TzRxU2hwODE3eE9lc3RvdXRBWmZYR2hYMDFhM0FiWXh0ODlaTzgzK1Vi?=
 =?utf-8?B?N3RDMDB6dzlDdEVMSmcwT2MvMWJYS0dBcnhON0pJWlgvTkJOZ1ZIZkxoVHV6?=
 =?utf-8?B?WDUrdTRCbDc3c01oWEdYYUczTGtpM1BNS2lqM0YyWnVWejVqenZqSWU0RHdt?=
 =?utf-8?B?ZlBuMDJmVGZSR3lFMndyaitVVlRWRzBtdTRmWkNGQzU0cXhleHZ1Y2F0a3VI?=
 =?utf-8?B?RWovNHVINVZvdmFFdm5iYzQ5bFB6VDVIQmJYRDVHTExBMWI3c3czZ3c0MVB1?=
 =?utf-8?B?VVBVYmJEdUhkaEtHZXU1Si95WE1nZk1VbTRHVTVOYlpTZ1dJT3IwNWxmZS9K?=
 =?utf-8?B?M0J0S3B2bmxYcW0ramhEdW9xYnBGbjVWb2haSENJTmk1a2x4elpINTR4bjIw?=
 =?utf-8?B?UkFBQVg5MzdsYWZKVlk0SGZxVnpkM2xRSndzZzdBRnp1cW00Q0xaOUQ5azVR?=
 =?utf-8?B?bkpxd3ZEdStqTi9nb1NBS3RsUGZvWDZYQnF0YzdCTUZwK3lIUit1a1Zzc0dC?=
 =?utf-8?B?bVkwZzJKVGQxd1NWcjhWSkxxMG9yWGU3ZjZOL01tQWhpeUZmc0dVVndJQTVE?=
 =?utf-8?B?akFVS2QzbE1aVDN4UkxXbWdVTTBPSFJ1RCtZWlRKbUVmczV6TXhseVkycDZL?=
 =?utf-8?B?UU5hQnkySFY4cHJndlhZZkRDVzhlOXFPd25PTGJxOS93Zysxb0V1ajNLZWZV?=
 =?utf-8?B?bDZjZkZlVzdYZUZHS1VDenA1dUtPOFJ5MWVkUDA0bGRlcWdvNWc3NDA3Zm50?=
 =?utf-8?B?dFNCanJmeGRLbnVWN1Nhc0Rwa1dQVFVla3RuYk1tOHBiSlhzdkkyNHJpN3RJ?=
 =?utf-8?B?ZCt5SHJ3K2t2MmczVDZSNmVLMXZPdmgxbXFjVDB3cjdVY0x6RUZwb3ZFRlly?=
 =?utf-8?B?ZEtOc2d2blVGL1FUUGhSZW5HanVmNWRKNDRBUFlpUVpxZ2dEUllhY2x0RXND?=
 =?utf-8?Q?tTHEmRYLNGmCEJqjXYeUVKJPo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4dc80b-f395-4377-29c8-08dac681f471
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 20:51:08.1734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j0skwQwqPM4ofFEnIbIL4XEupUpSHAVSTTA1NzJCYLIMutWgZWb4pbU7blBmZ0GaphMz8keaRV8kjJ2g6jwf5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5919
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/22 13:20, Thomas Kupper wrote:
> On 11/14/22 18:39, Tom Lendacky wrote:
>> On 11/12/22 13:12, Thomas Kupper wrote:
>>> On 11/11/22 17:00, Thomas Kupper wrote:
>>>> On 11/11/22 15:18, Tom Lendacky wrote:
>>>>> On 11/11/22 02:46, Thomas Kupper wrote:
>>>>>> When determine the type of SFP, active cables were not handled.
>>>>>>
>>>>>> Add the check for active cables as an extension to the passive cable check.
>>>>>
>>>>> Is this fixing a particular problem? What SFP is this failing for? A more descriptive commit message would be good.
>>>>>
>>>>> Also, since an active cable is supposed to be advertising it's capabilities in the eeprom, maybe this gets fixed via a quirk and not a general check this field.
>>>
>>> Tom,
>>>
>>> are you sure that an active cable has to advertising it's speed? Searching for details about it I read in "SFF-8472 Rev 12.4", 5.4.2, Table 5-5 Transceiver Identification Examples:
>>>
>>> Transceiver Type Transceiver Description    Byte    Byte    Byte    Byte    Byte    Byte    Byte    Byte
>>>                          3    4    5    6    7     8    9    10
>>> ...
>>>          10GE Active cable with SFP(3,4)     00h    00h    00h    00h    00h    08h    00h    00h
>>>
>>> And footnotes:
>>> 3) See A0h Bytes 60 and 61 for compliance of these media to industry electrical specifications
>>> 4) For Ethernet and SONET applications, rate capability of a link is identified in A0h Byte 12 [nominal signaling
>>> rate identifier]. This is due to no formal IEEE designation for passive and active cable interconnects, and lack
>>> of corresponding identifiers in Table 5-3.
>>>
>>> Wouldn't that suggest that byte 3 to 10 are all zero, except byte 8?
>>
>> This issue seems to be from my misinterpretation of active vs passive.
>> IIUC now, active and passive only applies to copper cables with SFP+ end
>> connectors. In which case the driver likely needs an additional enum cable
>> type, XGBE_SFP_CABLE_FIBER, as the default cable type and slightly
>> different logic.
>>
>> Can you try the below patch? If it works, I'll work with Shyam to do some
>> testing to ensure it doesn't break anything.
> 
> Thanks Tom for getting back to me so soon.
> 
> Your patch works well for me, with a passive, an active cable and a GBIC.
> 
> But do you think it's a good idea to just check for != XGBE_SFP_CABLE_FIBER? That would also be true for XGBE_SFP_CABLE_UNKNOWN.

Except the if-then-else block above will set the cable type to one of the 
three valid values, so this is ok.

I'll work with Shyam to do some internal testing and get a patch sent up 
if everything looks ok on our end.

Thanks,
Tom

> 
>       /* Determine the type of SFP */
> -    if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
> +    if (phy_data->sfp_cable != XGBE_SFP_CABLE_FIBER &&
>           xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>           phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
>       else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
> 
> Cheers
> Thomas
> 
>>
>>
>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>> index 4064c3e3dd49..868a768f424c 100644
>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>> @@ -189,6 +189,7 @@ enum xgbe_sfp_cable {
>>       XGBE_SFP_CABLE_UNKNOWN = 0,
>>       XGBE_SFP_CABLE_ACTIVE,
>>       XGBE_SFP_CABLE_PASSIVE,
>> +    XGBE_SFP_CABLE_FIBER,
>>   };
>>   
>>   enum xgbe_sfp_base {
>> @@ -1149,16 +1150,18 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
>>       phy_data->sfp_tx_fault = xgbe_phy_check_sfp_tx_fault(phy_data);
>>       phy_data->sfp_rx_los = xgbe_phy_check_sfp_rx_los(phy_data);
>>   
>> -    /* Assume ACTIVE cable unless told it is PASSIVE */
>> +    /* Assume FIBER cable unless told otherwise */
>>       if (sfp_base[XGBE_SFP_BASE_CABLE] & XGBE_SFP_BASE_CABLE_PASSIVE) {
>>           phy_data->sfp_cable = XGBE_SFP_CABLE_PASSIVE;
>>           phy_data->sfp_cable_len = sfp_base[XGBE_SFP_BASE_CU_CABLE_LEN];
>> -    } else {
>> +    } else if (sfp_base[XGBE_SFP_BASE_CABLE] & XGBE_SFP_BASE_CABLE_ACTIVE) {
>>           phy_data->sfp_cable = XGBE_SFP_CABLE_ACTIVE;
>> +    } else {
>> +        phy_data->sfp_cable = XGBE_SFP_CABLE_FIBER;
>>       }
>>   
>>       /* Determine the type of SFP */
>> -    if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
>> +    if (phy_data->sfp_cable != XGBE_SFP_CABLE_FIBER &&
>>           xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>           phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
>>       else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
>>
>>>
>>>
>>> /Thomas
>>>
>>>>
>>>> It is fixing a problem regarding a Mikrotik S+AO0005 AOC cable (we were in contact back in Feb to May). And your right I should have been more descriptive in the commit message.
>>>>
>>>>>>
>>>>>> Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
>>>>>> Signed-off-by: Thomas Kupper <thomas.kupper@gmail.com>
>>>>>> ---
>>>>>>   ??drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 5 +++--
>>>>>>   ??1 file changed, 3 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>>>>> index 4064c3e3dd49..1ba550d5c52d 100644
>>>>>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>>>>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>>>>> @@ -1158,8 +1158,9 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
>>>>>>   ????? }
>>>>>>
>>>>>>   ????? /* Determine the type of SFP */
>>>>>> -??? if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
>>>>>> -??? ??? xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>>>>> +??? if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE ||
>>>>>> +??? ???? phy_data->sfp_cable == XGBE_SFP_CABLE_ACTIVE) &&
>>>>>> +??? ???? xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>>>>
>>>>> This is just the same as saying:
>>>>>
>>>>>   ????if (xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>>>>
>>>>> since the sfp_cable value is either PASSIVE or ACTIVE.
>>>>>
>>>>> I'm not sure I like fixing whatever issue you have in this way, though. If anything, I would prefer this to be a last case scenario and be placed at the end of the if-then-else block. But it may come down to applying a quirk for your situation.
>>>>
>>>> I see now that this cable is probably indeed not advertising its capabilities correctly, I didn't understand what Shyam did refer to in his mail from June 6.
>>>>
>>>> Unfortunately I haven't hear back from you guys after June 6 so I tried to fix it myself ... but do lack the knowledge in that area.
>>>>
>>>> A quirk seems a good option.
>>>>
>>>>   From my point of view this patch can be cancelled/aborted/deleted.
>>>> I'll look into how to fix it using a quirk but maybe I'm not the hest suited candidate to do it.
>>>>
>>>> /Thomas
>>>>
>>>>>
>>>>> Thanks,
>>>>> Tom
>>>>>
>>>>>>   ????? ??? phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
>>>>>>   ????? else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
>>>>>>   ????? ??? phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
>>>>>> -- 
>>>>>> 2.34.1
>>>>>>
