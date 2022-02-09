Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584C04AF3D0
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 15:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbiBIOMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 09:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbiBIOMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 09:12:16 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27DDC0613C9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 06:12:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmChZxn5zRPdPD7dBikQiPDSaydkMY+KtB3KFrpTEvJ3PfIVzyIoy2iVvEhQCdgtjo6PMbZPa+5u1dgyckDy9ER/KXcVAp+WemYIRjWnFwJsngdWMAcYfXvSJV92gx928gpv7oF42jT5vwoGGmBEYHEYbMGZ+88+0dxw+6GYuQU4ENni3mrtOm9jeb77gSHAtCYIz9iOa0KmfXQwl8dt4gcoribSZ6rf/5BOVK994M7hOA8pWVGuS9Uov71TsBgD6/JINjWQxx0Yjc+BMXYo+I/8D6GEulm5HEHQx7d0xYNhxzpAjMdmUm93cTmT+5/gicyeEYdXW2qj5TA4Qy5RiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=suDMsFhWpKnIEGW+1cMgqxwmkHOK/ihNK1pBToVKvfk=;
 b=W2D4AeFVBjWXWy6nx/WtwjaikqwPo/ksMJuQZaHf+vAUebc2YEP6algOjhs1ea1h1HJ943vAap0sZ7KJBQ5FV+xlrLYkm+K6WATiQGTG52MncQwAkPlvxQkidihZLJCb8mU72XOyw+JGq9jPUBakGfyjdlA6XW7ZLikVNubfrAuNsxnuP7iLcrGNmZWK+uj4vrw0R0hCFVe3U6dFu7YU1wUuU4Pcp1ZKkGavRYuW3kKmB4pXXSXo0QSeS+qIMU5qoOpwsx4NwEe3INMaOcyl+xf6OTjxQPpAR+/FyRDYWWfUfm0q9nhxepb1knyzRiR1Se0Nren3aBV0yn0ZeldKNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suDMsFhWpKnIEGW+1cMgqxwmkHOK/ihNK1pBToVKvfk=;
 b=pPNm8g9m69k8AJtXifV0dhoRMhoIpBnfMhGTPiPuP1uYwVJizqU0YlfyUOXTn5+WA5l1iT6kQmgxlQ4F0W6WMxUK2r+r8MKQd8U/E5/AHAvD/TbBPOVpprsi4OTlvJKkNHYW2/nPPnBY2NySk2PI2JGwqL7r6kgbSFu5F6U5csI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 14:12:16 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b%7]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 14:12:16 +0000
Message-ID: <d2daf824-8df9-7d8a-c991-264f256bd99f@amd.com>
Date:   Wed, 9 Feb 2022 08:12:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] net: amd-xgbe: disable interrupts during pci removal
Content-Language: en-US
To:     Raju Rangoju <Raju.Rangoju@amd.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Selwin Sebastian <Selwin.Sebastian@amd.com>
References: <20220209043201.1365811-1-Raju.Rangoju@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20220209043201.1365811-1-Raju.Rangoju@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR01CA0025.prod.exchangelabs.com (2603:10b6:208:71::38)
 To DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd69a5c3-da3b-4579-9f77-08d9ebd62cf0
X-MS-TrafficTypeDiagnostic: MWHPR12MB1502:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1502D3A907B3D20187EFE92EEC2E9@MWHPR12MB1502.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R4EenXNEz/oR7BU+cxWIN9n8tDana5mdmPdzKFTn/A3ifptJ2aTjpD1FvcrQRirakIu755D8iLWXduinkGydrJsPes16lk78o1z77ccSY2BH8lFI9GXGrN/qION6r75lKeWBzZr6tDdAuNifUYBOEEq3rroSlKvkwFmjSl/Uywb2N8Jq8X6YFz9+5LkPq6718AFQ7/QfyYC6HY1darRU4Wj/VYcLAacGHn6GcG+kyV0hUNoTB/zGgg4AlNU9bl28YqdOaa2b1cU857qZSAegU+VCIoafnN1sFEv42ueua1PuZwWIqIJgtRcGszKcc5wznHU3zqKzBnS3YB5A4P3n5F9MC6rfllhgjPauxqnQY1HG/kMLgyOwl8G3QvtWs4QEGTfJ+vjSRUCabGnEVo8WYKckNnk72A79TgE9kvSdNqXER2vzbxhCJ+u7nhIfuTzjyKoTXx0QrJHdp7qsREYJgSOBd0/leXCbW322lhK2LHYVXYRIgNyW9TBb9KpAS2rEfnZZJ9+tUaFj456sShN+Fz9oMnjZKJl+aGMyohVFXupkJuZsXnZvCRLGxqjm1nEfIVdpzjtWdTpcWIUlHMYl9Bkb74GverdjkjqaPAQccTJqWDplhDqyv81EjXqJ+PuBTNbN8v4eHIade9AfDV4Q78jOE+8NQUlDtcK3RGQiLuMITF7AbbfcRQYy9lCjyUEoy9h0ItjYT4ZlF9DqCxVC0E+4UZJ+l2EwhhyQdZZ+5GOOZSMvsDlIQfAHne9l3RdR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(83380400001)(36756003)(26005)(38100700002)(6512007)(6506007)(316002)(186003)(31686004)(2616005)(2906002)(6666004)(4326008)(66946007)(31696002)(8936002)(5660300002)(8676002)(508600001)(6486002)(66556008)(86362001)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1hmSkJvODNpQ3huSGR0UHlNVS9PbmlkVDNxRlBuYXd6akRDMW95cU9STEZ0?=
 =?utf-8?B?Zzh5VEN6QTlvbVZiNngrdWhrUVlnN1BkZ0tWc2RkR1puSUdpVmFMUUZlUG9T?=
 =?utf-8?B?TEFaT2cvNHJ5NHRPNkxPc2toWTNrV3BYMk43YXg0QUFvTk1sVi9RNjNLckNN?=
 =?utf-8?B?TTh2K0kxcElJaDdURVc0R3NQYllkK1RycjZ3OXdmc09WUEVnR0w1Q0JVd3lu?=
 =?utf-8?B?eFUrQ0hVem9hYXAwZHY5ZFJvT0twWk53QXhuam9rOVUwZExlWGJrYUlsbDEz?=
 =?utf-8?B?RXFFTjJhcGJLMThzK0tHMEl3VnhNclZkSFNGN25QNzB4WmVqQk1kWks0TGtt?=
 =?utf-8?B?NzdmeURrL21iTGNVSkJjVFF1czM5WVRUcWgxMmh6a2F2UlBQdlRybllrcllz?=
 =?utf-8?B?KzZDL3ZmeUxieFhUQ0laeCtSZ0FGMTdYWkl2UzFaTGdVVzJieks0QUptOFh5?=
 =?utf-8?B?MG9NTHFHeXJEUmo0enlySitNc2hzVVU5ck5xQ1RETHI0SG1aQnYybkMwN20v?=
 =?utf-8?B?VmtreGV4WUtiNlFpUFZYSmpsU0JJOUhhamovSGEvRlNPYlBBTkhIVE1jc1hS?=
 =?utf-8?B?WHBuL3o2Sjd6WGYxVGJ2Mk5kMzdPMWVWc2hQZkJ4S2F6ZXQvbzFGRm9uYlhZ?=
 =?utf-8?B?NE5CSjl2RlVjMERGTDJ5S0tBRGxHVU1Kc3lGTXVDc0xoODU5Y2oveHlUdGFU?=
 =?utf-8?B?bEpNVlQvam1VWXZFbllTRlRhT1pKUmNMQWpNYStpOEdmQXdMSUNteEtKOHFz?=
 =?utf-8?B?MnZLU3ZjZyttYitoKzdRc0c0ZWViQittR2FtRGQ1YUdZTEk4RG40TWx0enc3?=
 =?utf-8?B?SFJEVFo4RjF5SXJOd0hnZ1Y4ZG44SjJidWhkWUpDU2NrVGJxRll5dnJ1OEdN?=
 =?utf-8?B?UjFsWlROdzlxbUFVZWZNMmMrejB2T3VSa1Jjb1dwWExnYlNrTHVwMXRRVmpr?=
 =?utf-8?B?NSs3RDZCQWU4YllHaUJvU3h6S0hxazRqaGlrMmJ3dVJwMk95RFNFbk5kUzk1?=
 =?utf-8?B?b2RiQWs1ZmFhdnQ1MXpEL1Q0OHkzUzZIQ0FXcjRMOTV2ejdMVjgrcUJ4SXRp?=
 =?utf-8?B?OUV4eG9Kc0lmWjVmMW5wUU9GdmRsSThxcE1wVkVmZTZzZHRQVUtlUnRlamhz?=
 =?utf-8?B?RUg2dkhlUVV2UCtNNWtoVUJnYzNkcVJCRkV4WW5GZVlweERzbmNsYW5ESnE3?=
 =?utf-8?B?UGNjcGF4RktZRGE0REtNOTE1bFMvV3lmemRIZzkweE1XNTZEVWE0WFRUL2dJ?=
 =?utf-8?B?MWNEV1ZPUXRQM1pPb1U2c3E4SFdyYTUvMzl5c3VUTE9LaHF3azhVME9vQXNG?=
 =?utf-8?B?WVBVaDFZOEdaRnpoempjK09pZXRrR05hY2F0R3dPWnFzUU9ONGVoTTdLQmQ3?=
 =?utf-8?B?U2ZMOVRaYTdwanFrVVJTcE5hT3IyQWhUblV2c0NKYkpQZmM4RG9uSHdna2JX?=
 =?utf-8?B?ZGR5M2lzTWg5UHU5Z0lxVkJjSzh0SGo4V0pDWTE3Ull4K0RSTVhuY2E3Rksz?=
 =?utf-8?B?VTZCMWFqck12bU1zOThOYnRkMGtaRE00b1RPeGRyUXhld2x5cHZsNVlYNTJT?=
 =?utf-8?B?bExWV3AzeSs0dlVFaDBQMU83NDRlbjZlanhiak1xOFArbjZOdkROdVVKODMz?=
 =?utf-8?B?V05GMk9CbGF3Tm5kb01nQnFlMHRBVTkzNDBPTFJoM09lNDVGMWhmQXR3UUg0?=
 =?utf-8?B?NFM4alM3VENpTFNzb0Z2ekNScnRKWXp6ZzU0a3JSWEZRZUp5WkRybkNkT0t4?=
 =?utf-8?B?NWxqWTQ4V1dkSTFhYkVnYnRDS1ZzUEtJdzd6S2w5Y1UwRzFKS2s4VmFQR1Ay?=
 =?utf-8?B?OTM2MC9KNWQ4UHZJeTFiV0pQVDNIU0lEalFGUHViVGpqNUcyKzgzWTBsS0hB?=
 =?utf-8?B?TG9NaWNIdXU0czA3TlFMZEZPVWYreVR4aFdkVW1qWU13a0ZrbWhOTG1sdzhQ?=
 =?utf-8?B?VW1WdDZFaUNTQlcwSThYTVlPS1RvRS8yNUczNnFBVTdrUDQyVWlsY0p5RVUr?=
 =?utf-8?B?akd0OG5ZOUNzeGNNS0xLRkQvT0ZON1FmdmpTMlZNekRyUllZcG00b2d6NjJp?=
 =?utf-8?B?bTRMakVYT1ZOd3JxYWxkQjBUR0QzbjR6R0dsVXFLNFc0SFp4a29FTXRYOVpZ?=
 =?utf-8?B?aitsWHA0cU4ydmVvYXVLS1BTdEJkc3UwOHdBbWpKNGxNaFdyaS9uT3dQOXpI?=
 =?utf-8?Q?QwuDhp+iN1hkcndP9R29k14=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd69a5c3-da3b-4579-9f77-08d9ebd62cf0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 14:12:16.1162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L7By8GiErlFqilV+1JYoKQEThtCI+vxxDTjjnm+kh5W7H+zNb/v1gyTvQEFUitW8UKNUtjOJDe/5LH07VXSZ0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1502
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/22 22:32, Raju Rangoju wrote:
> Hardware interrupts are enabled during the pci probe, however,
> they are not disabled during pci removal.
> 
> Disable all hardware interrupts during pci removal to avoid any
> issues.

Are there issues? I would expect the change log to say what the issues are 
and hence the reason for making this change.

> 
> Fixes: e75377404726 ("amd-xgbe: Update PCI support to use new IRQ functions")

Is this the right fixes tag? The XP_IOWRITE() that sets XP_INT_EN was 
introduced in: 47f164deab22 ("amd-xgbe: Add PCI device support"). If the 
idea is to be certain interrupts are not enabled for the device after 
removal, wouldn't that really be the tag to use?

Or was the introduction of using pci_free_irq_vectors() in combination 
with XP_IN_EN not being zeroed the true cause?

> Suggested-by: Selwin Sebastian <Selwin.Sebastian@amd.com>
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-pci.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> index efdcf484a510..2af3da4b2d05 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> @@ -425,6 +425,9 @@ static void xgbe_pci_remove(struct pci_dev *pdev)
>   
>   	pci_free_irq_vectors(pdata->pcidev);
>   
> +	/* Disable all interrupts in the hardware */
> +	XP_IOWRITE(pdata, XP_INT_EN, 0x0);
> +

Shouldn't this be done before calling pci_free_irq_vectors().

Thanks,
Tom

>   	xgbe_free_pdata(pdata);
>   }
>   
