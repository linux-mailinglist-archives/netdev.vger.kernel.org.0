Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904F4628745
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbiKNRjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237317AbiKNRjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:39:35 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7A2C742
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:39:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXOtgv/qeJthptH6rNZHPh83KIVb8C3M3hAydFuBROSLcrP9JpIAG0duNDRCTb/oBsTyblrlcMz8rsbhE53xps4vcMmk+AUxOLXAxa+TipE5P2mr36NvTeBc7M4KcdL3zndP+ZYdDXHgqL8iTS3nDjxAjcfT0hOGdphO1Mb2x8LH2wr7WXfYh2kdrnCAITiQkVWXj78mSwGwwZoTLi8jb2xvrETzTUfVg4ddQmn+VoCcj3AAxSqs1VG18tgEhnLy+KIKoiCad1IVTNvhjkjQJUW8PuBaxAdBLNug5qqTiTNpKHlV2AwlU/rxIuRN56FJkQtgkofZpEDft3ipm/lGXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWeRWH9W8i6cFLlcZM6f9RgMzi4dM1v0RZGfMcl+wxg=;
 b=mgmVM2Xu0Fuk9+7sfCK8rOJDZbW7gEd273Vs69uaXGjIMkYYOEPKVcPipd6mLjbJS+zNgNHxxr9QslfEA5u0qwABl5c6KjLMoHd4bvT8XG8Eo5E8oDpeflx9Rbc6KV+1DNFymI6nlVyyeQki6IFTJnnhIfQ9uhmPkLl5pX7m3QLQyOPXB8eIyvBsdk8EB4qF7sANHc8EFrP354Ji3OsiQ9pYOQW+4++RULDcqIj6aOe+no2sfFpcrQMRQYodEJt+aK0v8KZdmSOz5a6WlQn/UL0nUst+eaDIX+HP2veDa37sIstBUr6oRebSVqx/VbhHVDkXFmaGko3836WSObcJkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWeRWH9W8i6cFLlcZM6f9RgMzi4dM1v0RZGfMcl+wxg=;
 b=p98Lufa8yeVaoYmmrBVJMhgqo3ftTVx3/SO9nhP7DBK2ULEIYxXlVSEAY/y1MjCgzwl/6fY7Zwh52jZL6ZbxmPnh5Kau8oX/LltmcFHurM4bHcjaP+1r1eC2QgwbpVO/CI45zxOxS3nGTfJ8vfxrrQfgZdwTn112Eyl9ODBXbnA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SJ1PR12MB6315.namprd12.prod.outlook.com (2603:10b6:a03:456::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 17:39:30 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 17:39:30 +0000
Message-ID: <9180965b-fe96-7500-d139-013d1987c498@amd.com>
Date:   Mon, 14 Nov 2022 11:39:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 net 1/1] amd-xgbe: fix active cable
To:     Thomas Kupper <thomas@kupper.org>, netdev@vger.kernel.org,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Raju Rangoju <Raju.Rangoju@amd.com>
References: <b65b029d-c6c4-000f-dc9d-2b5cabad3a5c@kupper.org>
 <b2dedffc-a740-ed01-b1d4-665c53537a08@amd.com>
 <28351727-f1ba-5b57-2f84-9eccff6d627f@kupper.org>
 <64edbded-51af-f055-9c2f-c1f81b0d3698@kupper.org>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <64edbded-51af-f055-9c2f-c1f81b0d3698@kupper.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:208:160::23) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SJ1PR12MB6315:EE_
X-MS-Office365-Filtering-Correlation-Id: 0440de7d-ac2f-4681-f40c-08dac6672f00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BLdH+DhE6xDcbA7jjF7h+UjRluw1E0z+DJOWdxvZ3tCSllyYm+3vuK2s4CWgHkkEyH8gFbMuR8zdJYxSIZliwVrrFZp4ATjNnQcYSn2nkrVue8CsOvk+mPnWNy6JqS14Xf+ZbKJA6P88JQXa8lOqDn2UHkHfU39UROxG2XjC2OOAhxkit5OiXB9240VanjqbmEqmI2B47+vdLYj+7H8ELkbW6jUEocGebGRp4+KMniQYVItY5YcCIWbaRNQJt0/v/ndNoYWZZXAOLLbsI+VqGCesVNEN2G5Rvqo5TeTAv/At4ljy4pY5s+9I8plrkXn+dvOTgmBy/Y2WUmL3o6615//lVA0je0n1yNcpg9W7SCNcoQkSxIXzU2+erpudt7C7euzTwa9SyB2fTUp3hOJEq+q5m0xDHlROeCI3hoizXcTbYjkkq4pFXPYJBVxDXUxylOGglpaaKbof+r/my6UYzZi5QJK0qyZLfOMkjP952EJCyv1hBKzKQM0eKUk9/SOoqbhbd7LzDiMuyus8pePuG7QSEiWN+YCNlo+e+7GgNI8aTX1UhTlGlg3dp/718mYMURjzka6t76EWK9TXS0q1auwJIc2bNjtLtgnOKGGpbM/KIUp6JSSx+DEuNL+kR+AcvZeWdA2MWl14CH4TMgpaC662zWPUdnFkXuWV089J+IUKGzurnDsfaPvLYFBobdhU2cIPYwVbMRjY5QxggPKaUlEDSQbiVle6AtavOwZUP/3WAiKmbD5OD28VJK08QNOYJAa/AKKHr8uUwPfu9dUld91+K1Rrha8sia+M2dG7Qt4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199015)(83380400001)(2616005)(186003)(2906002)(8936002)(38100700002)(6486002)(478600001)(26005)(6512007)(6506007)(5660300002)(66556008)(66476007)(8676002)(53546011)(4326008)(66946007)(41300700001)(6636002)(54906003)(110136005)(316002)(31686004)(36756003)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czB6QnhhMXRFNk5LaGFRVkc5SVVpZmVCa0lzYjZGNE1GNy9pazRHbUg1bGZ6?=
 =?utf-8?B?MTlQY1VGUktJcmxuS1huclpZaFhxTFQ5QnB3NndKNUpqRTIxVW5uTm1ldURs?=
 =?utf-8?B?SlpxaWJyNUFWa09qZFBsS1pMYmV2NnlGKzhlTGxqODZwL250TWlkTmNMVG5j?=
 =?utf-8?B?d1luMzhlYVp1TkRtV1JXY2NvZDJabTU4WXVnVTI5RllYS0ptU2poSkJVbHp2?=
 =?utf-8?B?VnI4eEU1NmE2SE1kTjNuSlNXbTlzNDEyRDFuOWtLU2Z0SEsyTWtzanN2bk9p?=
 =?utf-8?B?VG1TTkQ3dlNLaGVubjliZHg2TkFJNjhBVmJ6Tnd0T28zNHZzVXVQSkNMVVhS?=
 =?utf-8?B?aGc5RCtLTXB0OWhEVThrb3B2VFJxY1d3UW1QOUxoQUpCbjlEUlhJb0NSSHla?=
 =?utf-8?B?WjdFSHNZQmsrUG05anFDd3FhVEViQk5aa0RNUjRVSzZtUFJvT1h3OWNTNFpZ?=
 =?utf-8?B?N3dwbHE5dFlBZythYitkaTZzRDVhN3ozSGFvTkhPZ0JoZGR6T1VycWlqQlEw?=
 =?utf-8?B?cnYvNXE2UXdWbE1WYzlEcTd4Z0lLaGN4dzZESjhWSXZRSFFZMCtVeEtnWGto?=
 =?utf-8?B?L0VqOG4xbTRJZFIwamFwTnY4ZGVQR1o5b0xCRXRDeWJtaWp4emwyY25ITDZB?=
 =?utf-8?B?UEUxN0xhMS9sVmkxa1Rtcjg0MlRaUGZyY3BGUHNKMjhGdm9QcFkrRldYQ0lp?=
 =?utf-8?B?YnVQUDR3SS9CQ2pqaTFsTmZ2WGFBbEh1a013SmtMN1o0OTVPbVJIU0k5U3Y5?=
 =?utf-8?B?elBCSUVSZWNsS0VzeE5oblRoaUtmZ0k2SVpJVnVIMk1sWlZKWE16T2Z5OHlu?=
 =?utf-8?B?a2lwTk85ZDlZdDFDbEhNWVpxd1pndWlHVUk4c2pDYTdhTWx3d2FLMGNFSk9j?=
 =?utf-8?B?ZC9iS2YwNG9qNDcwUURGcEpyNlJ1UXZ2ZnRaaFNEMTB1NEtrSG9tQkJBVjR5?=
 =?utf-8?B?RXM1VUpLUmRqRXk5cFVFUXM3ZEhHTmxrZDhLMG56MW9HT3lLaWl3NWNhaHB2?=
 =?utf-8?B?c0VOcHRkOTNSVVl6TEkvWm91Ukk4d3dpNUl4dHlHaGVpOHNGRHNnRm9kOVhj?=
 =?utf-8?B?YThtSDhSTjc0cjFWWFdFQjNId2RWUENNSVN2ZWhYeGg4MTdUSmRrZlU3TlFm?=
 =?utf-8?B?ekwrTFcyNThxMjNRdnVYaW5ZTUVHV0dyK1FpdE8xMVJ2d3o1a0lqaHYwS0tC?=
 =?utf-8?B?Vzl4VGFYanYzcGcvZTBPN0MramNYZTl6SWNPTXV6R1VialpkenJTclJyWHU2?=
 =?utf-8?B?UzBtLzJIa0JZRWgzNGxDdk4zSUxjQXVBZE02Und5Z1lRZkhKRFh0dTJYS3k3?=
 =?utf-8?B?cGkxSDBtZ29PaG80SE90Y20wdEpDSEJ5dEV4NDFRTW0wYUdsTW1pN3FrZUUz?=
 =?utf-8?B?cHRYSVRyY2plSzZiZjdJMU4yNVRwR0JqVWU3azE3aGdLbzZSSklHNk1pYUJu?=
 =?utf-8?B?LzA3ZGN2VXdpZWpOYWxjVDZqVDdObUNqNzl6K2dYOUl3ekczeFFDWFFnSE9R?=
 =?utf-8?B?N1pRNW9Rd2ZEd3ZHNjdzRUwxbWhWWk5XQjhNaTBwUmdibFczZyt1clFoeExI?=
 =?utf-8?B?NmhnemxtZDRuOEtIOUUzTzhYUm9XczFxTUZ6RHYrTG5HTWljcWY2L3RIdjZI?=
 =?utf-8?B?N24vZ1E1bUZsR3FRZ2dGUmloZmpqeDIwRUxlTlNxRXJYNzlZajJwcWprM1Mz?=
 =?utf-8?B?b2pOdzBiREV5N3R4aUhXZi9BbkRJTzVBRVkzKzNWelBNcmR0Y1pwN3cyVkdr?=
 =?utf-8?B?QXQvWmlqZGJsc1lHOHZVZU42UnNCY3hkMEsxc29NaWxobER5RDBMZlBlYTFk?=
 =?utf-8?B?RzU1ZTZtcjFtWWFWSU5TOXZXeldUeGhySnBQcUw5bytIUUI3SjZuSTVhUHRu?=
 =?utf-8?B?WGRYa0d0c0JEdVFReU1wbkdZN2VoNlFBK1pUN0dwN2hkQm9oTHJSTTcwUzdH?=
 =?utf-8?B?NXZYRHVOeFNDdlE4Y3djUFZSSGdUc3pZL2dQcm5HdkZvREM3UGZUNy93MjU5?=
 =?utf-8?B?a3hrR2dzWEd0UFdka0gxd0VPOHo4cFJFNDBXLzV2V0dCMmdRMklMcDBkanFD?=
 =?utf-8?B?L3lyOUVoSk1CLzVMUlJWcXBuKzRBSjYvMkJ2bjhDbWYxYlQzeUJHU1BLblNk?=
 =?utf-8?Q?n6djaIx0g6XlXlVZmvqT3hb7+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0440de7d-ac2f-4681-f40c-08dac6672f00
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 17:39:30.0756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +8kOAg5qJZX8AVk1R1iQB00ANYvbI/EU9jf+mskgOPrwIshWHl0EZD5MeDWHisa60gUWlzY1FwuxlGAYfZvF7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6315
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/22 13:12, Thomas Kupper wrote:
> On 11/11/22 17:00, Thomas Kupper wrote:
>> On 11/11/22 15:18, Tom Lendacky wrote:
>>> On 11/11/22 02:46, Thomas Kupper wrote:
>>>> When determine the type of SFP, active cables were not handled.
>>>>
>>>> Add the check for active cables as an extension to the passive cable check.
>>>
>>> Is this fixing a particular problem? What SFP is this failing for? A more descriptive commit message would be good.
>>>
>>> Also, since an active cable is supposed to be advertising it's capabilities in the eeprom, maybe this gets fixed via a quirk and not a general check this field.
> 
> Tom,
> 
> are you sure that an active cable has to advertising it's speed? Searching for details about it I read in "SFF-8472 Rev 12.4", 5.4.2, Table 5-5 Transceiver Identification Examples:
> 
> Transceiver Type Transceiver Description	Byte	Byte	Byte	Byte	Byte	Byte	Byte	Byte
> 						3	4	5	6	7 	8	9	10
> ...
> 		10GE Active cable with SFP(3,4)	 00h	00h	00h	00h	00h	08h	00h	00h
> 
> And footnotes:
> 3) See A0h Bytes 60 and 61 for compliance of these media to industry electrical specifications
> 4) For Ethernet and SONET applications, rate capability of a link is identified in A0h Byte 12 [nominal signaling
> rate identifier]. This is due to no formal IEEE designation for passive and active cable interconnects, and lack
> of corresponding identifiers in Table 5-3.
> 
> Wouldn't that suggest that byte 3 to 10 are all zero, except byte 8?

This issue seems to be from my misinterpretation of active vs passive.
IIUC now, active and passive only applies to copper cables with SFP+ end
connectors. In which case the driver likely needs an additional enum cable
type, XGBE_SFP_CABLE_FIBER, as the default cable type and slightly
different logic.

Can you try the below patch? If it works, I'll work with Shyam to do some
testing to ensure it doesn't break anything.


diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 4064c3e3dd49..868a768f424c 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -189,6 +189,7 @@ enum xgbe_sfp_cable {
  	XGBE_SFP_CABLE_UNKNOWN = 0,
  	XGBE_SFP_CABLE_ACTIVE,
  	XGBE_SFP_CABLE_PASSIVE,
+	XGBE_SFP_CABLE_FIBER,
  };
  
  enum xgbe_sfp_base {
@@ -1149,16 +1150,18 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
  	phy_data->sfp_tx_fault = xgbe_phy_check_sfp_tx_fault(phy_data);
  	phy_data->sfp_rx_los = xgbe_phy_check_sfp_rx_los(phy_data);
  
-	/* Assume ACTIVE cable unless told it is PASSIVE */
+	/* Assume FIBER cable unless told otherwise */
  	if (sfp_base[XGBE_SFP_BASE_CABLE] & XGBE_SFP_BASE_CABLE_PASSIVE) {
  		phy_data->sfp_cable = XGBE_SFP_CABLE_PASSIVE;
  		phy_data->sfp_cable_len = sfp_base[XGBE_SFP_BASE_CU_CABLE_LEN];
-	} else {
+	} else if (sfp_base[XGBE_SFP_BASE_CABLE] & XGBE_SFP_BASE_CABLE_ACTIVE) {
  		phy_data->sfp_cable = XGBE_SFP_CABLE_ACTIVE;
+	} else {
+		phy_data->sfp_cable = XGBE_SFP_CABLE_FIBER;
  	}
  
  	/* Determine the type of SFP */
-	if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
+	if (phy_data->sfp_cable != XGBE_SFP_CABLE_FIBER &&
  	    xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
  		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
  	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)

> 
> 
> /Thomas
> 
>>
>> It is fixing a problem regarding a Mikrotik S+AO0005 AOC cable (we were in contact back in Feb to May). And your right I should have been more descriptive in the commit message.
>>
>>>>
>>>> Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
>>>> Signed-off-by: Thomas Kupper <thomas.kupper@gmail.com>
>>>> ---
>>>>  ??drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 5 +++--
>>>>  ??1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>>> index 4064c3e3dd49..1ba550d5c52d 100644
>>>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>>> @@ -1158,8 +1158,9 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
>>>>  ????? }
>>>>
>>>>  ????? /* Determine the type of SFP */
>>>> -??? if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
>>>> -??? ??? xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>>> +??? if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE ||
>>>> +??? ???? phy_data->sfp_cable == XGBE_SFP_CABLE_ACTIVE) &&
>>>> +??? ???? xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>>
>>> This is just the same as saying:
>>>
>>>  ????if (xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>>
>>> since the sfp_cable value is either PASSIVE or ACTIVE.
>>>
>>> I'm not sure I like fixing whatever issue you have in this way, though. If anything, I would prefer this to be a last case scenario and be placed at the end of the if-then-else block. But it may come down to applying a quirk for your situation.
>>
>> I see now that this cable is probably indeed not advertising its capabilities correctly, I didn't understand what Shyam did refer to in his mail from June 6.
>>
>> Unfortunately I haven't hear back from you guys after June 6 so I tried to fix it myself ... but do lack the knowledge in that area.
>>
>> A quirk seems a good option.
>>
>>  From my point of view this patch can be cancelled/aborted/deleted.
>> I'll look into how to fix it using a quirk but maybe I'm not the hest suited candidate to do it.
>>
>> /Thomas
>>
>>>
>>> Thanks,
>>> Tom
>>>
>>>>  ????? ??? phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
>>>>  ????? else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
>>>>  ????? ??? phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
>>>> -- 
>>>> 2.34.1
>>>>
