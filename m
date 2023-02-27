Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE0C6A417E
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 13:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjB0MMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 07:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjB0MMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 07:12:39 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2130.outbound.protection.outlook.com [40.107.223.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07852007E;
        Mon, 27 Feb 2023 04:12:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5ICHGD8mmoJ+gY2XLeY5eNNa3MOOt6WbNRIsvCY78GuYuagGawSrOX4EmD/Z1lSyrE/JJoj52eXZS0eH3FLbGRnUCmFQlBtFJGcNau9G8e8WwVoACmYSaghO+ShEUKj6+aBU3xspS4XScstoKvvuXL0tMDzttRMbvxecg4jaP9t8JC/dvodcgwYafFJcnmtH0z5LWzVgMUtOpuzK6VHT2xwWHd0tX0cLavnN7myXYgLXV6+gaqJKnGj3bKyCWGvWiZ3Mx6/psepeFm6pMdqoiXq853TVMAmGahRKYkO6AemieRa3amNEU0KOW8HwMaGwi8WWXMXhYL8dQzz872/Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTFTYBB0RMm9xHiF9mhXck9E/an1XmTasB3qJ4T47U4=;
 b=ZFMiqxaUOihWzWKnHLoGXpUfqZhOHm7pOD+LcQsEE5jOGo1Ki1U8RimWkdC4OCLwfTNc3P1zbuTKmYS/r34q3NMC4miCF+AChmW6bazHIIxz2PYZdB7sH/y8KwVLDgcbmWSTirx7MFaBOnt7Lpk4aHTnM1DJ8/lCTult5BQ0SK21Lfbk2rIhydRHxKjGHyZaabE+Toe/EeFd273XmW4RzrF4jYT5pWB/lr+vLD1d95vy1gPisxmLnt0Sj+E/tsaYSEDS607pS5aal7UF+OxfAL9jJGPzTypGrJ3ykkLdAlrWZf88KH0+owPY1L9tiexgT8sahZIWoaD7/bbORJO8PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTFTYBB0RMm9xHiF9mhXck9E/an1XmTasB3qJ4T47U4=;
 b=f+i1tcjfRA0W+c6G/C74CZ4c6/vkxqAea12lkZtgnn38/ltoF3HmWGRokBLTZTwaQux/yLfjEX7vHxPLE0SEPqbXoH771u1xCtsaR1FRRbNUSrMGmRPwMPVmt9AKOCVIBz4vehTUvtAAKk2C1g7RetbmHAgasbTIdvYlg/TASL8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5601.namprd13.prod.outlook.com (2603:10b6:303:180::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.28; Mon, 27 Feb
 2023 12:12:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 12:12:20 +0000
Date:   Mon, 27 Feb 2023 13:12:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     void0red <void0red@gmail.com>
Cc:     krzysztof.kozlowski@linaro.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] nfc: fdp: add null check of devm_kmalloc_array in
 fdp_nci_i2c_read_device_properties
Message-ID: <Y/yeHqTwYrylRf6l@corigine.com>
References: <35ddd789-4dd9-3b87-3128-268905ec9a13@linaro.org>
 <20230227093037.907654-1-void0red@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227093037.907654-1-void0red@gmail.com>
X-ClientProxiedBy: AS4P189CA0010.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5601:EE_
X-MS-Office365-Filtering-Correlation-Id: 5461b097-0e8a-4b3b-e21d-08db18bbe067
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r2KCBTjBDqq+2AVwyhN004Nw8brrA/Nwib2VKTLtvbxOy0qkHiiHvVdA/SlH4mhSglRENeOxDX0j4ScYrBoma7NiFmuC5eS6nOLbohj3RCpciTxD5U5q/aK7Pv/Cr8I2j6aGkjw5V1ol9fymCsuNppPmPoIpdH6zHOC0xs1VZl2ahqov8PfefkrAVF6INSeNfoOEFIQLGWC/v5ZOokFDJNn++ErZyrPTmH81n/IxusoYZWo1I4+BwmOpipGfXzw9/rfxs/uZ5dL95j69tjy//ZqLYcgQP+jJgqV3FkwOU0Q7rIiVkrLdXCXMQ8DGQ8wvHBxEoazj5XiJvs9mpV17NrjtJ5mpkoM7PIDH1KBCpHzs5nUd8MWytF+fHUuc5dpPinuQVaqm+KOOkyQSp1kkORI7IOBPV+U3MJ76iJZBOC8QAlnKahCgZSwt9WJvgmp+ywR1oOvLEpYgulMfru2mJRgwUA7sZ8VUYGxs8+JVLENbJz3IAYwzB6DDik1c+aLKpcGShnR4Ib2KTNIT8af0TxhTM/ETXSP8JU/8IE5iHgASvFhNDyN/Hoj1WXUcj8Lwrm+HXfL4ZwCoWN+gdNfZx8ZqTV0p2iekaiLsN9f55l5kMvFdRgMUhCNd1VwXrEx6fNL+1p8eTsiaQ4XbtwLbwJFFLWaxXfxAhuopeZwsKHOW62bSrBKM85bOhMIhOrVNuHBbEbIORwLZcRmTo31oMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(376002)(346002)(39840400004)(396003)(451199018)(38100700002)(2906002)(4744005)(44832011)(5660300002)(8936002)(66946007)(2616005)(966005)(316002)(86362001)(6486002)(66476007)(66556008)(6512007)(6506007)(4326008)(6916009)(186003)(8676002)(478600001)(36756003)(6666004)(41300700001)(70780200001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hk+bM6LhNQLYgt8ZmxtNX+Vm3MQUh5PeT4e14jUvfzr7LBc+HFKEE9diZ6yv?=
 =?us-ascii?Q?w2VmIKeTzUqX7iCPiJxh3ycD2GVlpSznXl4NGAiZFBpDn7weG+WPv9zyrjSz?=
 =?us-ascii?Q?Dfsv+zEPppf/w8eH1EBx3I7+MmKLGiVQ1WOvPMEmovYvIdU0eSCDig9gb8GV?=
 =?us-ascii?Q?YIYvPr2YVUs5xloUh52P8ta74yAbKkFJlOcHXvn076ExGGAcLDtEHExJekrV?=
 =?us-ascii?Q?u18K2flUSmL4n1vrStYvqV30PHd6N+cu+SQWEKyC0LUh63gmXFtPmNbi8Arh?=
 =?us-ascii?Q?VUvOprtqh+Wh8VFD9q+HAuZ96kSULUDF9bhKybv/sXpbJ06GJgQi5AksrVDe?=
 =?us-ascii?Q?E5m0mQxOmG5SAksAQ3DfvAidWeXOnwucZz1YVPjaHaWA1rGj5NoLZrqVE6ck?=
 =?us-ascii?Q?/o9iwEF5Ib5MyKe10rW2BPzZyUbbK8MxCLbtx+1XAn0Syv30ok0FEheLL6v1?=
 =?us-ascii?Q?dcLOMV5VjQ4+VpME5qCteu6DkoHPPDNQoGygtAjR5Q/1ocNMh6cbkPot1FDP?=
 =?us-ascii?Q?uueIKcl1+zE6ZNGBNbHHBYiJ1QdRTOxM6r7B1T/1ktJJf+KH3+EllpOqY9uv?=
 =?us-ascii?Q?VdBTqq21v29ct44kKvnYr56O5xXrKP/k89Q9ZdoeM7E/nFJSGKXUmNkyDqtt?=
 =?us-ascii?Q?XjLBQxir8FVvP2bYQIsJzdJvDr2K7RLpsafYSjrp2c53KAMDH/PfimUH2tXc?=
 =?us-ascii?Q?SQW0oMzgV0kba0gqYjSpKGlzDksoIlSMytdmWOxSjTPjSkRqgoSjB3GAAGmu?=
 =?us-ascii?Q?KNvHYu3h0cYk5KrgDLF/1ZfrtC8tdEp52FBBaigQm5ecCvjCoy1+gRzJSFXt?=
 =?us-ascii?Q?OMU6ZXWwZw0IKOneGcN7tpatVRKaJdXDzOpXsceipir5QEK6CmYouFdAPTkz?=
 =?us-ascii?Q?LUXOM0ZQD/V+jb+KZCd7OPJHVpRt6z0xsvIwwnulja/xKRUT157GqtbQHIc5?=
 =?us-ascii?Q?ziEFMw3kAHB4WQaBLgxQvZaqOsg3RtS2fLlENS5TXtyaO/1LCqZ0oo5mvhFM?=
 =?us-ascii?Q?4h4WxWzFJwL+jWM27NC7FAGXudiE1SPy73SLmvrkxZA8yNpIUs4CnMizAugS?=
 =?us-ascii?Q?16P9mHU7m8a+pBrRhl1oisDoqd+j4oSD5mob66E/5b4NFDW4ekeHhwaMpiBr?=
 =?us-ascii?Q?XAzenpt+wQJcXnIbL+3QEdo7BL26hzi92WhQcvCBDincQkSxqbleUUg8FGXV?=
 =?us-ascii?Q?osP493qIpIvty4PPmoy/ylC+Z56XujjtfW6YzPwjh4RoiHemRo+4Phxa2nDE?=
 =?us-ascii?Q?GATIXFhgtZ9ztzyBJCJ/ULtIXdC8fe2Lf50bpkcgHqpUcYvJS+qnEzyJPh8E?=
 =?us-ascii?Q?m9cHFvCrp7OgcGki/KLqp9gaEuuwXbtidiqaQ6xZegN/rqsH7OrpMlM/VPlj?=
 =?us-ascii?Q?jLa1joq2tujTm0X70ID1RaKncHz0dE3xPseEDvHFZuh2leefClfY07XAQYu+?=
 =?us-ascii?Q?act9PPRd5tHLOoJD4yPIkgCglYApHCmyHTFnBBDk86HR1DqIC2L3fiVkfMeI?=
 =?us-ascii?Q?4aE9KzqqaJItR4RTQWFVUawimAkgsprdS3DYDkjwW/7RPHnQoj/rom8oKJIu?=
 =?us-ascii?Q?/DyuVnxhNpDk2nyj2cfaJB9XSKaPpV5t3lEN4W2gCPvI4zdcTc+XXVDMl3XE?=
 =?us-ascii?Q?doLp/40aRcaf/4GkN7whjC9tdWFzm6EUj2ggBMPBgCXqsOmpGCH9R/AGu3JC?=
 =?us-ascii?Q?/tPSLw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5461b097-0e8a-4b3b-e21d-08db18bbe067
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 12:12:20.7798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ioKkerUCFZvWIY6YaaxGItT7AmjhOxq5W5LFy3k5CkOy9nd7VeeXW/t+samWyR9zHOtP/0e9CdJCfkWd6O1Jd9C7RZnfpI3R39sObnMM1iI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5601
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 05:30:37PM +0800, void0red wrote:
> [You don't often get email from void0red@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> From: Kang Chen <void0red@gmail.com>
> 
> devm_kmalloc_array may fails, *fw_vsc_cfg might be null and cause
> out-of-bounds write in device_property_read_u8_array later.
> 
> Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")
> Signed-off-by: Kang Chen <void0red@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
