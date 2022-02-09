Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1554AECEB
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbiBIInH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:43:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbiBIInE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:43:04 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A690C1036B2;
        Wed,  9 Feb 2022 00:43:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZVSZW6gMmz/kzeeBtOKJW/e0GeOEKtulXQ0yMr8N2QJYXkmIu6ZIPyrtPXh95SwXgEFCyhnQPSCgmSYj39QvX1U06HfYVaXwuI4Sw260FIIV02l5hUlMD6P8egznplQtB2/Zde1DDlZpmiOTiN0EaPm3/7JHz3TY1C5y3GhASB2Th1V+C+Q79TferlxbQsgGy1JJAAQG9QTniUMhb8kTOPWbkIkCSgzUW1O7jI2O6yoOrzxWUlRU0cJOS+sXYN+3K6HbxEDZDsu7rzCypapMIziQVvEzaeaVfewW5zhNhJ2eUTwOaeA3wO7JCVplvWnxyI7texn2eWb4+8y1SObEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60Y3B742ITMAagpD+1O+LHFv7ILD8egJdHXJqAI2iPc=;
 b=d8YJHy2eSw/dCDUQ5O28YbzC1nj9s3Sq76Wau/4v5h5INF9v92nwmt3NeZpbpvWoV7R9KaJZkSevuNFI0XDesBauKMv5G/e4Mnd1IOJ9mrHl39rOatdKqf8HKHiVXq5P0HSPetRekItLwtTL+VR4XCoyL3s0+q1X2bhsS/6ngc9pXidg6FRynF085X3xKVs6u5oR7q2ugFAXqqvDkkAPShU98/3XeI95YEQMUWpYdS/4UvzJZgalw/JXQFNzyD6r9kU6GzSlo3DxLo4agGBAPBnWIBsu6q7x4iAI8VWYejk0bXRi7qL3gdzf5SwOODeW/fqg/owyYWHpY/9eN1BN+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=pengutronix.de smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60Y3B742ITMAagpD+1O+LHFv7ILD8egJdHXJqAI2iPc=;
 b=bAepv62B9EWslFcrgPyrE51VDCQcaEmz7ye40VcH6TusgwpeYOKYmR56769Ld417Y4gk6v65JERotSqh3OXZSoj+hpcFBcDeZzRiS/gPA7tDOdIKxYYDTj8K+/Syf6i/ItItdBoj1rwpXdNFB+gNIqks9duwINREq6GfNCbFZOk=
Received: from BN0PR07CA0003.namprd07.prod.outlook.com (2603:10b6:408:141::15)
 by SA1PR02MB8574.namprd02.prod.outlook.com (2603:10b6:806:1fa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 08:41:53 +0000
Received: from BN1NAM02FT011.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::53) by BN0PR07CA0003.outlook.office365.com
 (2603:10b6:408:141::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Wed, 9 Feb 2022 08:41:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT011.mail.protection.outlook.com (10.13.2.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4975.11 via Frontend Transport; Wed, 9 Feb 2022 08:41:52 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 9 Feb 2022 00:41:50 -0800
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 9 Feb 2022 00:41:50 -0800
Envelope-to: git@xilinx.com,
 mkl@pengutronix.de,
 wg@grandegger.com,
 davem@davemloft.net,
 kuba@kernel.org,
 linux-can@vger.kernel.org,
 netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Received: from [10.254.241.49] (port=35264)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1nHiXu-0006U7-80; Wed, 09 Feb 2022 00:41:50 -0800
Message-ID: <fbe0314d-bfd3-cb0c-8af8-ab5bab276cc3@xilinx.com>
Date:   Wed, 9 Feb 2022 09:41:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] can: xilinx_can: Add check for NAPI Poll function
Content-Language: en-US
To:     Srinivas Neeli <sneeli@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Appana Durga Kedareswara Rao <appanad@xilinx.com>,
        Srinivas Goud <sgoud@xilinx.com>, git <git@xilinx.com>
References: <20220208162053.39896-1-srinivas.neeli@xilinx.com>
 <20220209074930.azbn26glrxukg4sr@pengutronix.de>
 <DM6PR02MB53861A46A48B4689F668BEE9AF2E9@DM6PR02MB5386.namprd02.prod.outlook.com>
 <20220209083155.xma5m7tayy2atyoo@pengutronix.de>
 <DM6PR02MB53867DD5740FAA93CB5BC3B4AF2E9@DM6PR02MB5386.namprd02.prod.outlook.com>
From:   Michal Simek <michal.simek@xilinx.com>
In-Reply-To: <DM6PR02MB53867DD5740FAA93CB5BC3B4AF2E9@DM6PR02MB5386.namprd02.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25b050c4-4b2e-4631-8586-08d9eba80531
X-MS-TrafficTypeDiagnostic: SA1PR02MB8574:EE_
X-Microsoft-Antispam-PRVS: <SA1PR02MB857463BF04DCA5D627D6E12CC62E9@SA1PR02MB8574.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y90Bdx5Q0brLAtryq4wGYOwkaJ7KUFPdmB2GhUcio9JMoJlSuEPJ8j+PxQaeSHIF5um1zs4Pq6bISJ0hk7c6F8OjGfyEXGsxaVO8mzrYQIGcbWCc75QRLsJ0MsMF2C1aCLXZXPHL383b983pGyx7n30Xrp+6Etw6N2XIRuU9wpM/2umnlB0ORirR7j+yCK2Q2x+5ooXONXQhpNLbZ/ZBq8oKvBVoAi1bJR8YBhKW3+PjRMxhU+kS7yTfur7rs/ozvaD78cX4S25iiIm3rDTP38qxAzXCWWeQ11v0J67RrNtBeDp//VXuswAEWJ/qWbQJi95cto3D+DFCRlRa1lAr+73G0G4UNOX+UIFbWyyHiF8MXZhy0oKJ2IxnwhzLZTMg8xUfmDUah8nWo35Ig6RrRvp9W0pph2MJd/bATlA9HCOyPdj+kEdOrIZw89qFvk/jDjrmb695KQZPmyicujMwmPZENZYbOzwBWosTgCz8Qp+ldtyVYjFu8d/U5NDkThMTp5KmJ0u/Wz5QV9ndQXyFEx3IIL7c/6oQ2GWI770M+ZJXr1i5UcAbrrIQriUKV53Bz4uS1qkMwAiaji//7LwyL4d+EfFZ8HbNn9twVtpk93uLGi1dxzy57cBZh1p46rIIhNJlNVuda+GnpLASh+x0ORHh0PHo9zeNG/U40HYFl04Y4T90YSg2yeSjqT4FjAzHf3b8XbR8R75puSYq84P92lMRaRyfWmcOp+drcmc8DTw=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(44832011)(316002)(26005)(5660300002)(4326008)(9786002)(110136005)(54906003)(6666004)(31696002)(31686004)(107886003)(2906002)(2616005)(426003)(186003)(40460700003)(83380400001)(36860700001)(8676002)(508600001)(70206006)(356005)(7636003)(70586007)(8936002)(336012)(82310400004)(53546011)(47076005)(36756003)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 08:41:52.2394
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b050c4-4b2e-4631-8586-08d9eba80531
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT011.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8574
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/9/22 09:40, Srinivas Neeli wrote:
> Hi Marc,
> 
>> -----Original Message-----
>> From: Marc Kleine-Budde <mkl@pengutronix.de>
>> Sent: Wednesday, February 9, 2022 2:02 PM
>> To: Srinivas Neeli <sneeli@xilinx.com>
>> Cc: wg@grandegger.com; davem@davemloft.net; kuba@kernel.org; Michal
>> Simek <michals@xilinx.com>; linux-can@vger.kernel.org;
>> netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
>> kernel@vger.kernel.org; Appana Durga Kedareswara Rao
>> <appanad@xilinx.com>; Srinivas Goud <sgoud@xilinx.com>; git
>> <git@xilinx.com>
>> Subject: Re: [PATCH] can: xilinx_can: Add check for NAPI Poll function
>>
>> On 09.02.2022 08:29:55, Srinivas Neeli wrote:
>>>> On 08.02.2022 21:50:53, Srinivas Neeli wrote:
>>>>> Add check for NAPI poll function to avoid enabling interrupts with
>>>>> out completing the NAPI call.
>>>>
>>>> Thanks for the patch. Does this fix a bug? If so, please add a Fixes:
>>>> tag that lists the patch that introduced that bug.
>>>
>>> It is not a bug. I am adding additional safety check( Validating the
>>> return value of "napi_complete_done" call).
>>
>> Thanks for your feedback. Should this go into can or can-next?
> 
> If possible please apply on both branches.

New feature should come to next. It means can-next please.

Thanks,
Michal
