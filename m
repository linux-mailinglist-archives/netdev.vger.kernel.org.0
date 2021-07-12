Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B323C5C28
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 14:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhGLMby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 08:31:54 -0400
Received: from mail-dm6nam11on2058.outbound.protection.outlook.com ([40.107.223.58]:52801
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229793AbhGLMbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 08:31:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obDnt4fbh41BuoUOE/C7Xga8OF6h/MH3mvPOaP+j4hygO/lKV/bdzJoEJ0mbzpL+dSCWMM6diS+nhRshoLVtVsFxlpRtrjnUtkvopFKFfAMc2noBJBAamtmAP8Krm3MU7FTKMGZo5HW4/bWHBxteT87AhJDR3x0eQoR9sfRJo4pvs9AuUu2mtPsRLwCZO1EmlcDfaEtkv71yFkDc0tyaihVTUAY5ATE/DBSy1hYzpJ/OJFNsFaPrrTzu6/H2l34rUvCbBx7/OR1GaXaXjSYKp6JNpwxd/bHEsp94IQPxIyfFKySSL1Ah0P/uqxHRqOknPd6zUdvKm7DCOa89h3uL1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IFKTrTtnbhlh5FwP2+F2M6aKgvexDd+C1J6hpfCXb4=;
 b=iwYm+W8yq8DnMciJ9ZYz90RbyGTDeFot5HkHrOUw7rkBUKQOG4Rfjb/bOUF05kwABPILbDt3WpJGipHjHs38yybLfU3B+BNXiv0ehy1huHROX1sG9BT8XskWt9aDsuQc/FqgZoxGxLSP/Tl63WaKrxGXn7O/pJtOQW04doSj27HGoM2/jVyT6xIz5ZeNH8wXIvedY3eecH9yr5YJAvJQnxp0hZ3MWfl/wZnVT7DoU4NZCoBMqJzGvsGfjcbb3rHlzCyb6IPBnx6a7sQhh1B+qzaAXlZGkcOCRN3Ezf89+Vldk9WbqvK/32PPxnirmh/+KjGQSaA5FpopxE3JUeLXNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IFKTrTtnbhlh5FwP2+F2M6aKgvexDd+C1J6hpfCXb4=;
 b=RwHerN4OweowePSS12fWaEiUyk30SVSpFKZM1MeJukpOnYqzpBKur9MFF4+HmDKRTebWRnBgWEOGTYVIIlfle6S0/agwVqsjAdPXoNbbVi8v1Wv/LeezB37N9eMZW3GarfFnGsmXlIQFr71unqSzzOTS9fXIagxXcQbIaBh2jtNdz/EjS7teDoVNEuuVcFIePWp607BlN2KGlXXvSjgPXkPihkPC45lRYoAroaVnnQ9qkHgbWY6bCRa49pZN0ExLO3YHu0weGgnv0e1OEd9J25NC6YR6Nfqx80ho4U01F9PhlRTaIPp9jwIb7ZfAfpYRAsaii3NaBw/1uElDx6UHeQ==
Received: from BN9P223CA0011.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::16)
 by CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 12:29:04 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::b9) by BN9P223CA0011.outlook.office365.com
 (2603:10b6:408:10b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend
 Transport; Mon, 12 Jul 2021 12:29:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 12:29:04 +0000
Received: from [172.27.12.28] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 12:29:01 +0000
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
CC:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
 <YOLh4U4JM7lcursX@fedora> <YOQT9lQuLAvLbaLn@dcaratti.users.ipa.redhat.com>
 <YOVPafYxzaNsQ1Qm@fedora> <d8a97f9b-7d6b-839f-873c-f5f5f9c46eca@nvidia.com>
 <ba39e6d0-c21f-428a-01b1-b923442ef73c@gmail.com>
 <37a0aae7-d32b-4dfd-9832-5b443d73abb6@nvidia.com>
 <db692da0-680f-a6a9-138b-752e262bf899@gmail.com>
 <5324ca9a-6671-2698-f6a4-4ac94ad7bc26@mojatatu.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <2dc2bcf7-e953-a1a4-d015-40de72d1f8aa@nvidia.com>
Date:   Mon, 12 Jul 2021 15:28:58 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5324ca9a-6671-2698-f6a4-4ac94ad7bc26@mojatatu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc038b06-05d2-4f89-e23e-08d94530a306
X-MS-TrafficTypeDiagnostic: CH2PR12MB4133:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4133382C2B61915EE7136A2DB8159@CH2PR12MB4133.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:422;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nnfw7ZpZOVo0zaSf433+J8sAGB5cO/ecXiyIoOuiul1tL8tLFG/W+s6MfYGZu9CuGaOKPlOjPEnfBNC4WQvvk3Re3cHDh1fOFX6xjxDgJJ9E3rKk0C0WGfcAg3Sz8vQ8V9fKeRsz5MckmSp0U6AOdk8TGaLgs1z6oF1Ueftu9HELAsY/tQgjLhZfdnkzc82UvFOla1yOT6xO0/Hw5uCUMwBzu/9sjub3VeAIbToztcM6ZP20L9mH+6nMyed8XonrcvjjtmVW8SnJm6mPPYarwWItzKWXgVTqZLEoE8oLBhOXG/E9S8/Wh1LZADytefmoqaAwGOdpOr7txTdiL3ktFSm7CArcysIfE23vImjElL+fw8Wv5m8JC9dCyRzIM5ITqRKyegkONJgjPq30TJUVjDiKqKsw0WrsJCV5ug017ENoUbe1ae+/X845d9eZaYlDG4mf64YyQ7cXY7yR3D7XJlzV1AMpSnPbhjtBJQQ9cwfE/JyGIegGE1OY5+pLO0yI7kM2CXGXk7LhTUtgeW73Qc0xjFJpWTWDUCCS3nLj5P8DxYowdU6DJe8VmRVqgMoWPwxR/SH/hNCEh1/6NwZ6VO8HpD6DPAR6kPEONQstm1nToE1WtgESbCfa2CMmMdrhbGyDVN/3BLc02lPOUImr6bMPqY88nLymAaKVm4R93t2uVfcFoyGCooeOUzJI/rQJiAL5yEQxpJFspv0mTIijlZeffOzW9ebSkqziWV0O4SmPIvmzBlQc02ZzYamf8GRIgF9oNZdO1OdsUNOmHyjIig==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(46966006)(36840700001)(2906002)(336012)(8676002)(82310400003)(426003)(316002)(54906003)(36756003)(110136005)(47076005)(2616005)(34020700004)(8936002)(16576012)(4326008)(36906005)(36860700001)(70586007)(82740400003)(356005)(6666004)(7636003)(4744005)(31696002)(16526019)(186003)(5660300002)(86362001)(26005)(31686004)(83380400001)(70206006)(478600001)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 12:29:04.3641
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc038b06-05d2-4f89-e23e-08d94530a306
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-12 2:02 PM, Jamal Hadi Salim wrote:
> On 2021-07-11 12:00 p.m., David Ahern wrote:
> 
>>> ...
>>>          action order 1:  police 0x1 rate 1Mbit burst 20Kb mtu 2Kb 
>>> action
>>> reclassify overhead 0b
>>>
>>>
>>>
>>>
>>> -       print_string(PRINT_ANY, "kind", "%s", "police");
>>> +       print_string(PRINT_JSON, "kind", "%s", "police");
>>>
>>> -       print_uint(PRINT_ANY, "index", "\tindex %u ", p->index);
>>> +       print_hex(PRINT_FP, NULL, " police 0x%x ", p->index);
>>> +       print_uint(PRINT_JSON, "index", NULL, p->index);
>>>
>>>
>>
>> Jamal: opinions?
> 
> Looks good to me. Roi please run the kernel tests to make sure
> nothing breaks.
> 
> cheers,
> jamal
> 

ok
I sent patch titled "police: Fix normal output back to what it was"
I ran the tdc tests and passed.
