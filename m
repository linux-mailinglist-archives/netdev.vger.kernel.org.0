Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45444647352
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiLHPjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHPjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:39:49 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2071.outbound.protection.outlook.com [40.107.14.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1781267C;
        Thu,  8 Dec 2022 07:39:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDvHYH8LrzKwuH87X7ny58rTNy2BWAdFNudONw7gV/Krs/nHddiLoarVyZXxu/NT6QZOCTSQBBU74ved3N6EYiJqG+Qd/jWlv69BWJnPmclRM6MoK5YmZv3LPpzKz+h1pRLA0zAXKBEM2YoHT1/6WdX0qFV0ovR25HuONBXPiFE/wJaAfRr/wNuG7LcfkbveL/QNSHNloeEBA+3H3al5PsRZzP8yR3p2PQW0La1Rw3EHtpaJ0s2gIxrIU0uxAtnyW82JqE9iqptJ0W/ZfppsdZiXyQW9VkRvig+20fJDHiN341YSHlIqOSo/YuVYGmLn+hZDOC8wkNZbiOMzV25x8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iDF8EMkI8yripCfDZ3bJBR3DQ+b3eGj3Ag09PHvJTFw=;
 b=RX0UtSNln0pGZSH0jZMt7ouainxVtEYA/idsSsSDcvdfRkKLqTKwHI3/lBtgPa7fADU00sWS5dqkcqpNGLoN1n2PyYmyvwb8YdGBI21zfoYWNXe5d9Cxq6KWB//UFPVeYjW5WSQGIc1EVisLU7xiHVJLDtl+kTx9OIxiHCvpgg9IkJdBfwbSiUDDCFQj+jTTllevWOsut1Mg+XvVKk2arOr+fx0S6TxLlBSqNxG4KXzorMUYN748b4JtmSMulh/6LCrCJ4GuivsW2yCJV9YZjXLI9y6LpCbmwx/XUBkDyrlYhM8qneCxcMM8oOIEFXP4+oLC6lFbk+y2B95fznz1aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDF8EMkI8yripCfDZ3bJBR3DQ+b3eGj3Ag09PHvJTFw=;
 b=cJpO/Y0+l5pu9z5JnPyMxUEHdMs0TIXHKz4NOxkMLmh90naBzCXDvg4Ne0HalFCQVOlBe3LAqdqP6Vkya9AGFeRMCyQYYfZ1nXo/9yWXT5bfZkXbTfan44w7Ovrc4t1JAqs6Az/RskPHPCDK+EEhHUAg4NhKUcbHzUUQ1pX5uKbGw7MPW9S0fzLtZGhKqeVklg8/kCAjZ07+kdROAX06F//fV5WP/nsdCtdCq1OXBkZI9Mlel/J6wn1syX8cvOcwqPipGuBXXbuknF2dsfFPOX8KCQrJIG+U/T5QDyDfGSbloRsM2xM7pROwK3f3fnT8OwoiJaz85J0mlcxfzT/s9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS2PR03MB9492.eurprd03.prod.outlook.com (2603:10a6:20b:598::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Thu, 8 Dec
 2022 15:39:45 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 15:39:45 +0000
Message-ID: <ffebf737-413d-30d2-da53-b6131faa9b4d@seco.com>
Date:   Thu, 8 Dec 2022 10:39:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] phy: mdio: Reorganize defines
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
References: <20221202204237.1084376-1-sean.anderson@seco.com>
 <20221206185229.3f948615@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221206185229.3f948615@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0350.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::25) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS2PR03MB9492:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f063fb9-b027-4c23-6855-08dad9326e85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JV1fbwBNgq666s8JrCldYDF6qnaq5f09ZBVt8DGu1r4+U/s0nN4Xq03X8HX0XWzLIcdiLBxfg5NUTuv7jWiWIhxfN2XT3d7LahrNSXDK1jSNFUO18vdTZcQcaQh3w450fWUgXM3qksF2+EBFeRzlUXcPMY2Clwtv3DayNQvKvF4s5yOdelCOzhBKBYnUfP1sGNWUIrbYWIIy8ysj0rPA8kQI8Vhv2BYPrlk4y0ly3T42OulFKPZthlvsaCWDWeArX3zhJ/mOdCTrSLGvles/KvrzNF/s6qlvSIgmQeaYmC5MsGDrNGwyVIRwQGHyYgJHds0orO6Y3jXTykwT7ckbf8u9a4gg3vpB/uQm9MGN3xA3vAz1h99HUTeprLFOv16T7izDFoikgetHlg9seNINx7oMKHh0G6e6DidG9npMHfa0S4x8oJTRr7NMlwTubeix7q4HkkhyKn/UJMNkeSPa5H04+E3Uax5dZbfhlXo8UIaoe8r9W/9AM0SbEnSQ5E7ITJWqXFiFOMyoe+NAL57E2AtFizsVfvZWdaouOEgH16rUhEwa/wabbs8CXNkczbVNRdvF8+eCi44Uusryrq5IQONOrHoOkdUUdlkpVUnYsEZwysr5Kq5T3LqjfJ1sWioxcJagtAGUf2DhPoYZ85aoDRj1ibsvpj7JlS+sRX09ROjCTa2apQyMzj9J9DuHgIu43om9TAvSKLXkX/3JHI1yM7j0+Sf2CcZkyuKL/NgsPyPAwzZDwzGA4vgCspsARaJys4AVx6YskLV+ZkJCIIE+5u+VO6yEcuIFZdUKlmouIUI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39850400004)(376002)(346002)(366004)(136003)(451199015)(2906002)(8936002)(4744005)(38350700002)(38100700002)(44832011)(31686004)(2616005)(4326008)(66556008)(36756003)(66476007)(41300700001)(86362001)(186003)(5660300002)(8676002)(53546011)(6506007)(52116002)(316002)(6916009)(26005)(6666004)(6512007)(66946007)(966005)(478600001)(6486002)(54906003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0lsNHZGNEFzRklzZGpaZHYwMVZ0bTBjS0xkUE1zL0s1eVFzVGZ2UzN6RHhm?=
 =?utf-8?B?UWRXMGNxQzVsS0dwWGtmSnNLcmZZQkFIS0ZBRW11T1NZaFlSRVZCZFdPbU9t?=
 =?utf-8?B?V1FZM212cmYyU2hIZ2kwVUVJQjRJNkgrR1Y5SUxOR2kraHdJOHh6K2lMQUov?=
 =?utf-8?B?akpvVGd6RGJVM2Q2aG5DUldIK21zQ3lkVllscDFhTThPYmZuYk1lYlByNXFZ?=
 =?utf-8?B?enRJY0t4Q1ArUHBiSFNIWWt0VWlxWTUxMHJud3BXdk5ZcmI1VmtyVjNTQWdG?=
 =?utf-8?B?d2x1a0p4eVRZNEV4SmF5WVp2cjNLTzE2MDhBK203QmREMWxhUElLS0ZKbHQ5?=
 =?utf-8?B?dEh1b0ptRm5VQ2FYOEN2Z0lSTDZ3QWZlaWpITHJRUnoxNWxhN1NXVVpZc2xP?=
 =?utf-8?B?NUZVRGREazJLTlc4WWtIVW9ORlBaOUx6SkhWWnIyYTdkWURSNUphTVNPL0tt?=
 =?utf-8?B?Z3FWbUc0YXIvbVU4N1NFMCtXL0hPN2tVT2dGMDBvSFBOak80c0QzTzE1ZFBx?=
 =?utf-8?B?YktheTVIdGIxbjVSRnpqby9oNkZGd2t2aXg2ZC9IREZTRUZBbFVGVVJiTWpO?=
 =?utf-8?B?TlZIQ2hHRlY5RUk5Ti9pUk5PSzhpSjVRbUhvR1lNY3ZnL3JBeHc2Rk1IeEJQ?=
 =?utf-8?B?RmtQZklqMGl5QXpnSFlRZ2hWK3JkZmFXamdhazFYQ3NWZllTeHV0S1ZYaFQ4?=
 =?utf-8?B?UDdURUt4RWRzaUFOSkZrN1laYlc3Sk9Wa1VycUdaZW1QVUtKSytBVGxJY2Vk?=
 =?utf-8?B?SzJuYWgyOXhYRWM1YU95WTh6UmtxNlljakRMcVZodi83SnZBWDliV2lPZm5j?=
 =?utf-8?B?UERHL2dyQWxYenl5YmVJNWRScndCWWpQNm80RWk5a2ZBMnZLa2xRS3llV1pr?=
 =?utf-8?B?dVJFM1U5RFU2anlUUkRZb3hrR250czladEJaUmtXV3dEQnNmTmRNQk1Dc2M0?=
 =?utf-8?B?ck9vSEVvUFNvNGJyaG9RakxFRGIwL1FrdE1KS0RLQlYvbmJwbUdzOStnMDNC?=
 =?utf-8?B?OVJmd1RtOWJDYWhXVXdjR3JiRDhPbjdRb2Vkbk0vNTczQ3k2NFZMSWFnYWdB?=
 =?utf-8?B?ei9PRUNJdnZFWEl2NVNpOTJSemR4d0g5c3QxL0dJQndpRjliSlBtcjNBUzZJ?=
 =?utf-8?B?dmk2ZEQxMlNrWUdTbHA2THBwNmZjV1BrZ0N6K1pVQzkvU3N5bzAvUTQwRzE1?=
 =?utf-8?B?N2NUVVlYTUJXYWZ6NjNiUjBvT2FuUDd0R1VXb0htcHhIbU5vdWVDM0FXMTZa?=
 =?utf-8?B?OExUNnBKczBUN1VXeElkcVBqZXNrejQzVkhzWEthTFRoMmI5RGsva0pwUzBB?=
 =?utf-8?B?a05Da1JVRlZEa2ZhUWE3ckxkUDI4VUVSbmkrSy91WlFvWTRlcnJnVzA0WGhD?=
 =?utf-8?B?VlY1Ym0rTVBLODFhelBPdXV0RlA1M1pvOTFaMzNHblkyb2Y3MlFWUUNmaFRN?=
 =?utf-8?B?M01vUW1vYXpvaW9VSEt3bC9rZ1h3RzhOblFocmxteWZDcVJ1QkRCckJLaXhp?=
 =?utf-8?B?R0RYWlRPdG4vNUJoNkY0c0FWa2kwQVpRL2I5dCtsU2lZZEc1cWU1NEtiMnVI?=
 =?utf-8?B?K2V5T0hkdFRLd1BVVS8wUGdyYTlRcDdmNEpJbFVaVHFVaXVNc2liZUUzSWlY?=
 =?utf-8?B?TFErVTdjNE10NTlCMWYvV1ZkNTBTbUt3VHVJT29NaGl0SmNISWtsb1ZBT2k5?=
 =?utf-8?B?d3h6VlN4U0xJd1VpUDJqdFZHWnVuWnVKbS8xOGdzYnhzN1p3TTZFWDlHeURo?=
 =?utf-8?B?dGZMeGxqWDNkdWxlOFFoU21QVnJueHNZeC9EMjE1RTRPREJESGhKejhMVjRs?=
 =?utf-8?B?QTl6Nk84d3RNTktsM2NsT2o3SVBmejc1MEZkemcwall4TUt6aVVVaVByMzBG?=
 =?utf-8?B?eEdWR3AyRXBSN0Q3RDM0alQyNE56eGNyQlA2a2p0dm0rU05ndFRWWUFrNUgx?=
 =?utf-8?B?N2piSjNFdlZOVnAxSEY0YVdSSkpaaytEbnVwZVBnVGoyMCtUZngvcXJKRVds?=
 =?utf-8?B?RytDZzhRVi9rcFJqcUtVN2ZOOXlzb1p2YjJ5SmtVdHlzbSt4eE5JbVhxT3p4?=
 =?utf-8?B?T3hxV0JuR3dqOTVMQnVPRldUazNGSEp1Z3YwZ3o3TDVTZmFTR3FiVDZIS0Zr?=
 =?utf-8?B?SzNrNHE4UjNrbDlJVnpKc3NIWjZwaXpoN01xVHhOTWQyVnRQWFVyalp4WXd5?=
 =?utf-8?B?UWc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f063fb9-b027-4c23-6855-08dad9326e85
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 15:39:45.4686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bxd+orRo/Yr7xsOwIXFF293aCgXZwZDXYQWFUtfLvVOD+ptg/MOAVcQVCKHXGDvHfpN68BKRaefGpK7XJIexBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR03MB9492
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/22 21:52, Jakub Kicinski wrote:
> On Fri,  2 Dec 2022 15:42:37 -0500 Sean Anderson wrote:
>> prerequisite-patch-id: 53145a676b9582dde432d31e0003f01a90a81976
> 
> Hm, what is this? It's not a commit ID known to our trees...

It's a hash of the diffstat. See [1] for details. I have seen this
suggested before, so I decided to try it out. Patchwork seems to have
decided not to do a build [2], so maybe it is partially supported.

--Sean

[1] https://git-scm.com/docs/git-format-patch#_base_tree_information
[2] https://patchwork.kernel.org/project/netdevbpf/patch/20221202204237.1084376-1-sean.anderson@seco.com/
