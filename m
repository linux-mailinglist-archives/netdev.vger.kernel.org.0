Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD31C698B27
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 04:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjBPDZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 22:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBPDZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 22:25:23 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DA5C7;
        Wed, 15 Feb 2023 19:25:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cu8xE0CU4zsUg7vAbRl2a8mHE5QcHPYHz0FOzsdYR+K3Aw31jgdtC7yIr81qzsSaV7KxrCBhySKBKcuPiEuFtm5g7v84cW3x155bbFZgsOHJZgAc139x2Ov+3kOt2GIeBjDh41qOIOWAIs2xcVI/HA8KvgKG2cnVc4sWLGzeJImEC8HYRMDLYxBC5+7wYtabLtQc9OiJwxHgFjpLr5wvWxwidmoV2MDGRusxmqTRxPM/bh9lZ/addyImQf31JjrCdhx7ccr5jhlK07tp/T65I+V44WPBVoYRWIPswszmu5IcNUehZTiXzZ6INW6JePvAEdON5Jp8P8kPOTw/xETVJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hvYafqrauu4TTlCCzck5/yZ+RJ9WwG4TDx+jlRER7U=;
 b=TYDhUPCb2vB2g3ykUnK9/3FfIfkE+rUDraWS8FwjcREsLfq4FhTvQwXgKGyIlzSHQu66G+WoAaelpSqIZMfTG70RmCeoH/7wRJbd0Y6b0rAPg+cdKPStRc1aXnnliisNsS3FE3xGuGBAsZ882wgjMZdG59bhtQ4co9VWS3OImmFE76aYtWvMrDgplGc/QkbVV4xzewxy+LjBDoiB719YPNGKhEfPvaDUWvw9Woi2r5qU61zP0gLOWiqnEs00AsuEkwoov8LYCv5qlvgGPfMz7l+cDIVAG3y18ATVujvrj33dM8v1UC+CtG+Mg6HbdCXqMI9TBnZdCZCXKJTcjjVtzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hvYafqrauu4TTlCCzck5/yZ+RJ9WwG4TDx+jlRER7U=;
 b=F2b0/zvZzbUJ1mzcTta4dFWkyniRFWyoLRSGhQ3W9Tr2zxlwUlXqla/F/YyYYbFIF3xN/kWqaKCxwR4t+Mrj/mdIPvGq8MgTJU8+avCl8JseVOjCSb8JyY0x6N857aocr0qwLXp7KjKLM8Qbium+nXVSiJLsnGxVo/BV/8jBugQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20)
 by CH0PR12MB5385.namprd12.prod.outlook.com (2603:10b6:610:d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 03:25:20 +0000
Received: from DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::c552:5881:efeb:fac5]) by DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::c552:5881:efeb:fac5%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 03:25:20 +0000
Message-ID: <4912931a-67c9-8f9c-bb08-611eeb3d6c03@amd.com>
Date:   Thu, 16 Feb 2023 08:55:06 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] amd-xgbe: fix mismatched prototype
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230203121553.2871598-1-arnd@kernel.org>
 <20230206222839.0df937c9@kernel.org>
 <0441fa72-a07a-8c3e-717d-563f03fd2ea1@amd.com>
From:   Raju Rangoju <Raju.Rangoju@amd.com>
In-Reply-To: <0441fa72-a07a-8c3e-717d-563f03fd2ea1@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0012.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::21) To DM6PR12MB4170.namprd12.prod.outlook.com
 (2603:10b6:5:219::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4170:EE_|CH0PR12MB5385:EE_
X-MS-Office365-Filtering-Correlation-Id: d339b71f-bae1-40a9-ec02-08db0fcd6e94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: haABROdeSbo+gwXZSwBX45VV00tYuP7MHGpekQmDHbqZGz18J6/ToXVdplqPzf9NnfqwOGQMgvJjTo4dvWIIeW+oRPC7sQbJv0eeSKasSvrzWbzEq4V3lfN5hriADDPxl2iYZLOnKJRpRHjTt/ex3Y+WC4jS9cy/oJbL7hlnFhBHl0+3ooDEDC3utD4XdbRQBctvovhFph8lVkX7p4/7wTxZepuGKPHWj9Z0LZ65jMQVNRxLreOakebGclVnnRDSxywNXCuuoB4zY0IGAN0ArI1XKy+QNEZ70zGE8DsH/hDfFdKubNdyMYGRUhSQdyrot+sjLF5ZYnymoTCpglJY68TjgrCWuHd3LV13+nWhWmKOQQpvPTekSs4o8r6t9fankzgNUthFizZs12rxawOuWgSoqIwi50+4k4FYOju2ArRZoFwCUgh5D7IzmeNj4t0Ayy6vnkQdhksgWYEp2GxsLnW12ALMoK9F1UPdjvadXD8D+CqF6YK/0P5IU5AdZRz0iPFaxpd4WAv5cjuysXV66qIJ7uIj4raeS/1v8T/99iCbCLNsshINbVMjbTdyjOzCv/oiVitKm1+zBtWgx67ewwNZOanUhxf6SNFnsn6SwhMjEkpXzZdGBmubleCkuKfsroZjxJdJ9p+dPdqtG5ZGC0HJaz0zmAYRF5iTLqwZWKludhiZI2rDqFpmFCHYzYQe7CzWPpWctIf12AOV/Cu1jJTUM4uYg/p4k36IfsRUvEM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4170.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199018)(86362001)(31696002)(38100700002)(83380400001)(36756003)(6486002)(478600001)(6512007)(6506007)(6666004)(186003)(2616005)(53546011)(26005)(41300700001)(66476007)(4326008)(8676002)(2906002)(66946007)(6916009)(66556008)(5660300002)(8936002)(31686004)(54906003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmxpMGI5bURPRHRMb2dhMWs4K3NKMnVRUUwwRU1SeEdBMlhNbjBXdXBObCtE?=
 =?utf-8?B?MG9kbzd4ZFJlVTlmYWtsbGlGSTdHWFRHNGxJZkJzeWMyMFJhWkQ0OCt0U211?=
 =?utf-8?B?cm95N0IwNmlDTHRRQ0hZVkJTVWhlNFJDM2ZqK1IwUGlwSkJLczVzSVltdFhL?=
 =?utf-8?B?RWNLWkp5eGNuR1lBUTIzU2YrRUlMelNwVjlQWm10Y2Y4TGpBVi80NEthck80?=
 =?utf-8?B?ejlKamVST0x1YUJ5cXZaOEJtTU9qZXZpV0VUekpwN05pSmVnQ0NLalVKcEVu?=
 =?utf-8?B?ZUhoSzVmVE9mSGF1a0RnMmM4ZmQ4TjNZMWtpYWlhdVRPZVhwVXM1OVpGRUFr?=
 =?utf-8?B?ak9kV0ovZ0svZDBvRFEzKyt2ZmFDaExjaDFKZ2taUHJlSVNldTVoTkwxQjMz?=
 =?utf-8?B?WmpOMVhLcXYyWjF4Zk9hZkhXZWJ1SW5UcjdBV0pJK0dEUWc4OG85ZyszckNa?=
 =?utf-8?B?cVJJcmZjZjVmZ29MaUhkckZGMnFXZXdIcmdPOHZnUER4WmsvSjlVYmdMVk9y?=
 =?utf-8?B?WWR2bG5RUlBxN0p1VUhPZ0U5dmpTYnhsZDlEWFNGNEZQRzFCalRlQUVPdGlF?=
 =?utf-8?B?Q2krSUxjYWhBRGlXMDBwTGt6UTQrUkgzY0luUHZHT0VBOUM0OTMvYXp1L0JE?=
 =?utf-8?B?b3A5Wmo0Q1RGNHJaNDlzbExNMjYrbngwL05HUnFvYmVzQzAzVnhGTEkxUlZn?=
 =?utf-8?B?eXpuaEJLeTF4N1BZWFNrS1RVdnAxbWJPQ3pKUkFYd1JxZ2toNnl5dUpDSWcr?=
 =?utf-8?B?ZllhVDBFcFpOcFoxajN4M1JJa3lZZTdRc1cvYVlKSHdWVlU4dFBCK3d4TXE0?=
 =?utf-8?B?L2dxeXZRYm1pZzdocmdjclJzRTEwTzNHNVNTbDllUEVyZHFFVFlEZG9FSWJB?=
 =?utf-8?B?M291YjdMZ2N6V1ZycXg4c3cwQ1pyZFNlcXFKSkpIbFVVODZSYmZMbVo0S0Iy?=
 =?utf-8?B?Z1JNcXFuQzhNNXpkVFJIQWRBaHVLditlWnVtcWpwR1hIL2IvNTc3QlN5M0pH?=
 =?utf-8?B?WDRiV25qQXRqeW5wQ1FxOHNldFBLTGI2YTh3MlJYNGJyOS9tSEk0dVNsQlJr?=
 =?utf-8?B?dHExaGFGcStLYmhEN01yaGZRV2dZUm5TYkZ6NVk1WFJnNzVqSTFZSkJVQnhG?=
 =?utf-8?B?TUhGRElUaHV4Ri9IbTdBV0VneU1VRUY2R0dYM1lGaVh4dlNweGxCSzlJanRj?=
 =?utf-8?B?WGZ2RzF1UUNtblNLT0FRQWFUODl6WnUvV2xSMkJ0N2s0YXRlUDFaTS94dnFs?=
 =?utf-8?B?WFd5V0tPZXptb29yZVo3NGVzZmJBdEJCamtzaGNycmV5aUR3aFVjaHlvVGpt?=
 =?utf-8?B?RUJZeGpNbnk0SmY0WHJjbVk1c2xsc3REMmRIRUJkenVBT2RlOUxsdnBJY0RE?=
 =?utf-8?B?OVFHSytCb212UEwrQmtsOXpVeXFLRTJlVUg0QmpselVuVkVkUVNGOWsrb1Br?=
 =?utf-8?B?NzU3ZFhmVk5wSWEzbTc3c0pVaU8wUk9OdytoVWNsaElRRzMwMUh5c1VnZ2lP?=
 =?utf-8?B?c1JCUzljQXlsZm9BQ2dNZ0FGYlNRdlJ4VHVYVjJaWkR5RklMajFMb1ZGWmFJ?=
 =?utf-8?B?SkRqeCt0Z3hlU1hYbFM3TnZTcVA5R1d6QWRwRjdVa2QwTnVhcWgyZ3dycy93?=
 =?utf-8?B?NFc4UWJLWTdWNDRKZ0hFK2gvQnlFUzlFeExPTXRSOUJKU1hzNmtyTmNDY2RY?=
 =?utf-8?B?SEVTVXYwTDk4Vng2Y0EvQkVDUHJjSXpHYUNBcVYxdlBlczZXdHpwaXhGMHRi?=
 =?utf-8?B?Y2k3OVgwbmZkZ2JuV2VMZ0hNWmx0ZCtkTWJKZjNOSG9FYnJHejFwZEpFdG1k?=
 =?utf-8?B?NjduM0ZCYjFIcmUzYzNUUjBSNVhBYXVXWE5JN05IYkhXL2tLeWhoY01RbkpQ?=
 =?utf-8?B?U1BUMEwzOGgySklzY2EvcjQ1NmlCWkMvWmJBc0pDVWVST3J4Y1RSc05nWlVw?=
 =?utf-8?B?MmVYUXZtaEFLdG12TTVLTzM1TG02dGJhNEVDaHJTY3o0enN2K0lheU1iYTdp?=
 =?utf-8?B?eTJrUElGZ0U5Zi96QUN6NDlwWm9welQ0U0JNcHF6UHRhRG5hTjB1OXMyTkF2?=
 =?utf-8?B?WkZ2TG9CS3F1UFZ0WE94VnlUNjVMVy9ld0ZFTW9NTHFiZTdYb1BhOFE4SEdt?=
 =?utf-8?Q?2VZEFBofTf9qn+BoYw2oSAT8q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d339b71f-bae1-40a9-ec02-08db0fcd6e94
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4170.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 03:25:20.5085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dX6xp3LIhI0z7SJYFO244nvvSDdC3q9JX0AS6rJ41nN0u3zmCy/3YJH8YHOTnq9kX7UuRn6GUBKK/48gfdlWrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5385
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/2023 12:24 PM, Shyam Sundar S K wrote:
> 
> 
> On 2/7/2023 11:58 AM, Jakub Kicinski wrote:
>> On Fri,  3 Feb 2023 13:15:36 +0100 Arnd Bergmann wrote:
>>> The forward declaration was introduced with a prototype that does
>>> not match the function definition:
>>>
>>> drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:2166:13: error: conflicting types for 'xgbe_phy_perform_ratechange' due to enum/integer mismatch; have 'void(struct xgbe_prv_data *, enum xgbe_mb_cmd,  enum xgbe_mb_subcmd)' [-Werror=enum-int-mismatch]
>>>   2166 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>>>        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>>> drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:391:13: note: previous declaration of 'xgbe_phy_perform_ratechange' with type 'void(struct xgbe_prv_data *, unsigned int,  unsigned int)'
>>>    391 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>>>        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Thanks for the fix. What's the compiler / extra flags you're using?
>> Doesn't pop up on our setups..
>>
> 
> Yes please. Even this does not pop on our build systems too. Would like
> to know those extra compiler flags.

Hi Arnd,

Gentle reminder!

Please share the compiler details / additional flags used to reproduce 
this warning.

Thanks,
Raju

> 
> Thanks,
> Shyam
