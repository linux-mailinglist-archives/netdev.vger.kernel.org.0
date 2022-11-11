Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6F06260AF
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 18:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiKKRxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 12:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbiKKRxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 12:53:06 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF3D77E43
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 09:53:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJ7i2Z9Td/01BLnkhIftIyiX/VMdBxzyeSBxaeYK+5WHD/9quQsLZ/cb0Nprhau6RNMu4UHTm5qSjROyGMcdwCP2TRqMXOSaxym/XfrnbWUMI3xkA02/tXtglrKfoC8K3jxY8LBWo5PDanAsZ28l0R5HbtQF3nXDLxe1nqA+WmU4rlEootn/v/WcBAoj08Rzf4KSH4nYFRpE/AolD0sAQAs2fGLSJOQew0T9tWXrvzk9CyucdQ97P9X4QoQ8T8gDtS4Yii6uwcjUTip/M+h8nDeq+8KA3A02My5rqAnQ0kwZdzgIXecSK10vNGr6iv9AFXQwk6+2vYIGV8xMEO3f/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFpzAC5f0bEzaVt82u+pI5W9Ri8SmKJyZe3hCq757L4=;
 b=W7L9aO8jLKRpGgNtslEFRE5lgGNVqFqTxawVL55fWKHoJ2K9DOzkNy+ZnB8XtpeJbequzpw52N8ZSRMBwTXuOgWA1cnCFz0jLNjCGNXd6HgsUnoTjf/PSkgeVKdbpn2MAy8RjbVuBomBPSzWhpA24TrcuQRN0/466zn/j/7aWNBw+KRoRjmz6Tteudm3kt9CiFQcqB+gwqrWRj1agochdCmSt7NrUa6LwwHbBUjWvrAJ/Sru6WmyxKjdpOFYmlohBGzwLXCqKk6OdtYXTxKlnldAusQBHIkiR1QnGihfnzwMWRp7okCPdtNWFsoyIsJDu23CGrW7IsXUoVYQOU3sHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFpzAC5f0bEzaVt82u+pI5W9Ri8SmKJyZe3hCq757L4=;
 b=BHzpmMbwcKSiGO06i7DoVgRFkh/ZdRjTWM1kHMz5QpOcEaxoP2PVyw8F0+H5fXTZvQjCPXu4/PLPZg7wSXL+WwzykAK0dpkuB+UO1M20tYUvh8Dxko+QB3L8hohGMlI6VuYQra5KXCAr3rYBH7JPCIELg6DlIi6tT2b7DByhaHQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BY5PR12MB4132.namprd12.prod.outlook.com (2603:10b6:a03:209::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 17:53:02 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 17:53:02 +0000
Message-ID: <c37e43b3-1659-126c-aba3-32dc8c3abde5@amd.com>
Date:   Fri, 11 Nov 2022 11:53:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 net 1/1] amd-xgbe: fix active cable
To:     Thomas Kupper <thomas@kupper.org>, netdev@vger.kernel.org,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Raju Rangoju <Raju.Rangoju@amd.com>
References: <b65b029d-c6c4-000f-dc9d-2b5cabad3a5c@kupper.org>
 <b2dedffc-a740-ed01-b1d4-665c53537a08@amd.com>
 <28351727-f1ba-5b57-2f84-9eccff6d627f@kupper.org>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <28351727-f1ba-5b57-2f84-9eccff6d627f@kupper.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0074.namprd13.prod.outlook.com
 (2603:10b6:806:23::19) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|BY5PR12MB4132:EE_
X-MS-Office365-Filtering-Correlation-Id: 2547dba5-4182-4ce8-7184-08dac40d93e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C4B/hCuMB8HqZUo3XNWs4R42WOBRe9rZvoNoNPzJC5GW0KBuWP5Ytx5OPKy9J0D+rNArQAqoTzfDir8bbu+y/KbGcUEmap27KuJTuzZpdAI4N1EknQvU6VccOim6YPo/jK/ZkkRcAnPxiUh1+hQEB+GAVNzVfiyZPW/Y6T/Byykr6/qsD0+18qBJ7u7/aqQX9xRE7Ur1ljlEHS6KikVXdqEBHaHgbRaWL3klUUfNstvKoi+BDjUz8Ww9P9sTyXNsvDetRv+Kd2heVcsytBAjABIGBDpA3RAiNFC8QbXeU7xLO2u6pxFVivH0u7LjbgpDvQw+FgldfkDEXNaJ1AcmWae6TichJP5Mt48+Aqk7uuV6m8/clBz5jIj7jGIvwEkl8Xvo1sRx8GqG3p1s8tFdJJ9YXyfAvqInOPdsKj7WPh/cMHBXKnMFSv4nGBcqFnitMVLn83FTkzKqlE5lfFiP8aiy/hx1fz+ODAa+DmSkH2Nqhu/uI/aWlP0QU3+plIoHpPD5zhryMD/M/OVMe0x54whcv2ZZAz0ektdMW6RvknwKa9vksvk4ZyJPG6M79Kruya9kKPZWxc9n3EiP8z69lpi/VrdLHQuDmfwJD4RM3/Z4zRChZMAI+stddIWzUY9Pd/1ycdJ8qpUVv1IBa1tDDX8eQpDotHfvrtbwpUcqKqWLgs2l1C60Mmw8wx99x0N9YH4RcOdieLA06BsUi76Bdgnqw8f43870EoKSpRFApVm09tHPxZ39rJy3erJnXVD8ufOr2SSeT/HmbCKf7HBd5weiHMglYoC00371PL9XDDKrXZ2YCPLLIVlmz/UwTYQy/V+FaxJli8b8iq3gDdtGIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199015)(31686004)(478600001)(38100700002)(83380400001)(6486002)(2616005)(54906003)(110136005)(316002)(6636002)(6506007)(26005)(53546011)(66556008)(6512007)(8676002)(36756003)(86362001)(66946007)(31696002)(66476007)(8936002)(41300700001)(5660300002)(4326008)(186003)(2906002)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGh0RzJWN1J5c0FXYVhnTlBvRW9BN292Y3VxdnlrWjJkL1AvV2FmbncxQjRj?=
 =?utf-8?B?RGY0Qy9HMTIwdFlRVWpwdmVJMkU5bk5HNHdDdmJPcE5QVVV5M1dOa09heUts?=
 =?utf-8?B?U04wSm9MQVFnbitaZHY3MTF2TUNuZzBuMWI1MXgxTGVSZm43Yi9ONlhnRVYw?=
 =?utf-8?B?UjhJWHh5Q0gvZUlQWXFNaTV3ZjZORGZ0YnIvcmNIQkxQSmJOekJvUFgyLzl1?=
 =?utf-8?B?akJ5L3RNcDM1eHpjSmhYamRlOG9UNmlvaTA3NFNqQlB2TEFZRnlaRlptdWN0?=
 =?utf-8?B?a3RIczJXOGV0MnVGTlY4WlI2RHZWRHBMSk12S1JCTjNhQXYraVFNZHhYcitK?=
 =?utf-8?B?Q1RZMzFwZTBOR0xsaC9vbGM1TVZwQTNWVzV4cnRpZHNHNVlXN1Rjd2ZoZFp3?=
 =?utf-8?B?NHhLNVoyWGFRMVB6VytoNkRzaUZQY0RBdG5NQi8wdHNCM3VNRVRTTjRsRmV6?=
 =?utf-8?B?UzJIaCtZRjhFWHZtc1g0c01mZVAwNGZyWWNtMWR2RlFnOG5GUTZOb2ljQ045?=
 =?utf-8?B?ekV4VXAwK0VsWWdJdkpia1lxTHVaSjdnS2pHZXVWaVkrTG40NmpraDVHc21B?=
 =?utf-8?B?Tk5NZXNnRXg0ZkRRTzltVlo3L2dQNXIrT2FqRGFvRzY5eWZ5bC9NK2o5aVdr?=
 =?utf-8?B?eFZ0Y0NOazZRcWZNWmVVQ2tyakpNWG5RQmFId1g4TDNwRklVR251cTdNRHU3?=
 =?utf-8?B?bGVlRDY0OVZSbS94NkZFQUpkdDlSZ1lHZ0lLZUNGTzNaK3JLWWF0VTRCOWxI?=
 =?utf-8?B?SThIQS9Ga2VMUmpRRDBCcHZMUnZYNG9ZdFRvdUNmWFZ1eFlZa1IzMkNZMWZy?=
 =?utf-8?B?SklNeXlQZk5IU3djM21mRGZTZ1psMTEvUFBINmRvRzZmTE1YaFZ5a2RsRTdV?=
 =?utf-8?B?cURRVEFqQllwUE43U2wrTWc3cGtmam1kUXRQclR1YkpoUEVCVXdMVEt5Vitp?=
 =?utf-8?B?REs4RXlaUjhYdmU1VlREdzN4bThSYU5OSXMwMUh5ZjZQSm93OEQ2NXhzMVBN?=
 =?utf-8?B?MENCTjFIblR0cWlueWFLaVVIQzZlWXhzcmpDcVZoTmR0UmJ2NDBLbElwa08v?=
 =?utf-8?B?SmNRUGQrNmdIY25GQzdxdmV6TFczcm1vdEV6aU8xUEV1cmlGTjllUTdRc2tx?=
 =?utf-8?B?M1R2aFMyY3RhQlhlU2k3bXJSK0plTkZUeEFNWHUvRWswdmY1VWJnQnlFK0hi?=
 =?utf-8?B?VURPTjNjOXJJZkRuYmY3TTNIMi9hVEtSQWliRmlVYzZhZDd6MG9qbWk3Tyty?=
 =?utf-8?B?MnJYYkJNR0ZaS3F5Nm5Sa2VhdTBLR1FyWGpZVXArY0dDUmgyY3h5RnRIaWtq?=
 =?utf-8?B?bzhrRCt0U05Eak81cnRnMWo0L2s1SnhJaGtsR0ZJU3dVT0pRMmpJdnhTWmNs?=
 =?utf-8?B?dExZUnprcmNjQ2txak1QOWh4czhUbXVtSXVoRUpicXJxTkppVjJHNlU5dkVj?=
 =?utf-8?B?UVpHeVFkYTVKTFh2ZHNNMzhSNHRjRU9lMU9MN2dzQlhEOWxsditDcUNkd0M1?=
 =?utf-8?B?ZXRmakZaam1aamZWZHZHMllTNkZTOXFRRzdqTzh6bzArQTVQR215OURDaXpW?=
 =?utf-8?B?MGN4K3NlRkxtZ0pRRDlKTzhhOFI5clMzRU5YZEdMUzBYcTh2RzdXYm9rNmdt?=
 =?utf-8?B?R0tYbU5tdm5hWHdBWjVDcFFGdCt2bmRZN1JQaUdKZ2JPK2dzN3grbnIvNmtZ?=
 =?utf-8?B?Tms3b3hXeC82R29ySXN4K2FYY3dtWExwT2IzMVhrczAyci9xNUt0S2NmZmpK?=
 =?utf-8?B?MXMxaWswT2cwc3VpckpUbmJXTndOSjRVajBjMGNHTU9NdDc1Yk1xYTJqeXkw?=
 =?utf-8?B?WmNRanU0Tml1cjJVRHdNSVNxZlZxcmdjVUJnZWJTNU9vbGY0MVc5NzVTMkQv?=
 =?utf-8?B?M3hsa2g5c0pqK3dhWit5OFVVejdtSktYYkxRWGdtWEFPUFRzNnlnVmhzMEF6?=
 =?utf-8?B?MDFPTEJpZU1OSGNMenQrb2QzNG1lUGg3ODFlQnR1TktaYkRsQmxNM3hBbTFR?=
 =?utf-8?B?a0JmdERaUDVITDd6VnFaU29zSG9PUnlCaVVzSzVXQ1grTGpLWXNYMUpKOUVG?=
 =?utf-8?B?VlNUdXQ5VVhzVHlkQWd5MnNDNnZDRzVkTWd1Z0NKcHNRbW9WYW5zNWFvbGV6?=
 =?utf-8?Q?ILyDVoilhfzHXw3hyoF02IGWD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2547dba5-4182-4ce8-7184-08dac40d93e3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 17:53:02.2215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jGD1/7IcLyNVqxE+EYcsnI/uDpF+SPtQrLlByEg4vKjlLZ0BsG3eM7/B5vTRoFcEuc495J5Q1lrnylTm/AAamQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4132
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/22 10:00, Thomas Kupper wrote:
> 
> On 11/11/22 15:18, Tom Lendacky wrote:
>> On 11/11/22 02:46, Thomas Kupper wrote:
>>> When determine the type of SFP, active cables were not handled.
>>>
>>> Add the check for active cables as an extension to the passive cable check.
>>
>> Is this fixing a particular problem? What SFP is this failing for? A more descriptive commit message would be good.
>>
>> Also, since an active cable is supposed to be advertising it's capabilities in the eeprom, maybe this gets fixed via a quirk and not a general check this field.
> 
> It is fixing a problem regarding a Mikrotik S+AO0005 AOC cable (we were in contact back in Feb to May). And your right I should have been more descriptive in the commit message.

That looks like a fiber cable with a dedicated SFP+. Can you supply the 
output of an "ethtool -m XXX" command and a "ethtool -m XXX hex on" command?

> 
>>>
>>> Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
>>> Signed-off-by: Thomas Kupper <thomas.kupper@gmail.com>
>>> ---
>>>    drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 5 +++--
>>>    1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>> index 4064c3e3dd49..1ba550d5c52d 100644
>>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>> @@ -1158,8 +1158,9 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
>>>        }
>>>
>>>        /* Determine the type of SFP */
>>> -    if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
>>> -        xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>> +    if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE ||
>>> +         phy_data->sfp_cable == XGBE_SFP_CABLE_ACTIVE) &&
>>> +         xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>
>> This is just the same as saying:
>>
>>      if (xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>
>> since the sfp_cable value is either PASSIVE or ACTIVE.
>>
>> I'm not sure I like fixing whatever issue you have in this way, though. If anything, I would prefer this to be a last case scenario and be placed at the end of the if-then-else block. But it may come down to applying a quirk for your situation.
> 
> I see now that this cable is probably indeed not advertising its capabilities correctly, I didn't understand what Shyam did refer to in his mail from June 6.
> 
> Unfortunately I haven't hear back from you guys after June 6 so I tried to fix it myself ... but do lack the knowledge in that area.
> 

Adding Shyam back to see what the status is...

> A quirk seems a good option.

The quirk may be that the parsing code calls a function that updates the 
eeprom data in memory based on the SFP identifier.

Thanks,
Tom

> 
>  From my point of view this patch can be cancelled/aborted/deleted.
> I'll look into how to fix it using a quirk but maybe I'm not the hest suited candidate to do it.
> 
> /Thomas
> 
>>
>> Thanks,
>> Tom
>>
>>>            phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
>>>        else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
>>>            phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
>>> -- 
>>> 2.34.1
>>>
