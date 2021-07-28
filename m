Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439B53D8C58
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 12:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhG1K7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 06:59:04 -0400
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com ([40.107.244.77]:32471
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232530AbhG1K7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 06:59:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LfR3bJOV5ed4pupZzxgIm0k2Uj1Z2aOcePIjvKAil6xD2nRsskKh+U6y8FD/PD+2/K3Qjjg5SMrthj5EV/RnZqohGXrK478f03KLx1I+kzzlqSATvKyxPz1YEat6oZ7fwy3G63DQc1B9auZ9uIWVehYMlZZ81uHZfEe2QPExmyaJ4hrDpD9qMlHFhCSPlWfEfb84X0Nbs1w787QhIWn3bQXVmOtUkUr23REApoIV3RHuGYXVfe0XITbY9xQROR2Um6xJu0heHJAaHHpspcCusysC0u0pzGLZmApJDsjUioPMeqbRIKAACtcPA1QXjlpGRFnL9vFXZsg8m3tnlkSHdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BU4XlDkEHD8qfUsONJ7TIbifcBqfpb7/52Fe7fW+Ufw=;
 b=cwq7g0lhKJ7AEN9/FM8J7n0T3IXjnVHKWh/bwoggWZ3VApt76JoudElmXeK8Y72eYxweqyjVmfnQ0GrEEET6yIJCci9XAjNhMXlQWumox6XfrDxZKD08ljrQUddcZQNcbMAK55AiGZdAQr4CBA756vZBnrnPUDgsq2LEfMrl65N56sB7xpWITpfmndjaSs8nGTPkcXNL+hrL2TyLQlCaqDpHx4bUfRN3Ojrback2Xf3I106p+16IiuoXR/YgfDhrHD0HC48pqan4kI74rCCXSs0YHjkEyEz+lfO7Y0IL0/Y3CDiaZttfVycLNQytEuVNl59aT2uNrtN8fFoVavcE1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BU4XlDkEHD8qfUsONJ7TIbifcBqfpb7/52Fe7fW+Ufw=;
 b=a+ZW60N9tEcVlsGIgxEP0Bl7S0wyoLeIyHCQEaW96OmfKSE2Vr111hT7JbbtRj+AMw1e3tdmDqgoHXd4cqLiuYJOPRS+LsqCKZYLLnxnEiMlAOoeNDVngOwNkCsZDl9o5NCdolv8lZpi/IU3pGFtlPZTkKveobXk6wDW+z0O+Is=
Received: from DM3PR12CA0079.namprd12.prod.outlook.com (2603:10b6:0:57::23) by
 BY5PR02MB6916.namprd02.prod.outlook.com (2603:10b6:a03:234::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 10:58:59 +0000
Received: from DM3NAM02FT048.eop-nam02.prod.protection.outlook.com
 (2603:10b6:0:57:cafe::a2) by DM3PR12CA0079.outlook.office365.com
 (2603:10b6:0:57::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Wed, 28 Jul 2021 10:58:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT048.mail.protection.outlook.com (10.13.4.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 10:58:58 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 03:58:58 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Wed, 28 Jul 2021 03:58:58 -0700
Envelope-to: devicetree@vger.kernel.org,
 netdev@vger.kernel.org,
 kuba@kernel.org,
 davem@davemloft.net,
 robh+dt@kernel.org,
 gerhard@engleder-embedded.com
Received: from [172.30.17.109] (port=38044)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1m8hH7-0003ks-Uz; Wed, 28 Jul 2021 03:58:58 -0700
Subject: Re: [PATCH net-next 5/5] arm64: dts: zynqmp: Add ZCU104 based TSN
 endpoint
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        Michal Simek <michal.simek@xilinx.com>
CC:     Rob Herring <robh+dt@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-6-gerhard@engleder-embedded.com>
 <CAL_JsqJC19OsTCa6T98m8bOJ3Z4jUbaVO13MwZFK78XPSpoWBg@mail.gmail.com>
 <CANr-f5yW4sob_fgxhEafHME71QML8K-+Ka5AzNm5p3A0Ktv02Q@mail.gmail.com>
 <CAL_JsqK9OvwicCbckvpk4CMWbhcP8yDBXAW_7CmLzR__-fJf0Q@mail.gmail.com>
 <CANr-f5zWdFAYAteE7tX5qTvT4XMZ+kxaHy03=BnRxFbQLt3pUg@mail.gmail.com>
 <43958f2b-6756-056a-b2fa-cb8f6d84f603@xilinx.com>
 <CANr-f5xu=xHn7CGve3=Msd8CEcoDujQzSYSNQ2Zbh7NOvyXFYA@mail.gmail.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <839bdf26-6aef-7e05-94b9-78c0d2061bf9@xilinx.com>
Date:   Wed, 28 Jul 2021 12:58:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CANr-f5xu=xHn7CGve3=Msd8CEcoDujQzSYSNQ2Zbh7NOvyXFYA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07162a7c-8614-4d21-63ce-08d951b6b395
X-MS-TrafficTypeDiagnostic: BY5PR02MB6916:
X-Microsoft-Antispam-PRVS: <BY5PR02MB691690688BFC499D439F9DB1C6EA9@BY5PR02MB6916.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mO+gHuJPOCKso6d+d/TX7ndbaJkR4jgTbfLY0Zp/CourxdnyhuuRl4nmdcY7AKcu+wJm5cwBNb8Ah39Rz5xK5BdyDKl4R//MDy7czCT9Mkt5a0/JqlUWbMpAfgoLN1SMU7tsfG9utsFdudxaAk2ypoPJKWpolH9ZbtKGdhHA1eKpZh706KKtSihf3QyjSOJ5lEAX4jgVInH1dO22meXzZIxMpWaUyODaKJ2S4Knhnelf3dKW93098Q/UU5fPOo/NOvZk+BAnS0kLUsiSpH0KNSZq2j9yApjo9LBfe1/xi2owkbrXucDiYmzw4CaB9nbp5i0fMc3YwOltub6kwUWCLjLu67+d2J0+CDOnyYNACTPhif8yH7xZMVcODdAmiaWJAxjNNUP2PSdF9IiAHyxfAh9oQta2LkdGA/ykxIR54bONDD9Mq0qwJJUnQDr9pZstEekix3U5+7KHHYXGXmzB9fnLraGLGcqzstJLRDRB5ZT3FmCoi9euNIqi3qoGvMgXS3NI2gwF29tJHkW6R5BjXzjLHAKV+gr57Xv3FOYVV2LSGMOgLHdrdrxRXr9zJ7HryBU0C7Z7kADdRcN2YSMNBZQs3G2h+SEOriDPks/m+HFTNVp9A25V/titnkgDY4McxJvNAaiV2U1Vcq0rLQ7BPIbb4/tOnmvNh6desRvtEfAa0F7pGeIIdOYwd0/GTiI5xlxGxejPLTMPJIEmHfzZFuxGRbxhqfODODxBaa5jjHO9Bt46PQaVmFTXPYFlrrid
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(36840700001)(46966006)(6666004)(36860700001)(7636003)(8936002)(9786002)(2906002)(47076005)(36756003)(36906005)(31696002)(44832011)(53546011)(356005)(316002)(5660300002)(82310400003)(83380400001)(426003)(70206006)(2616005)(70586007)(336012)(186003)(31686004)(478600001)(26005)(82740400003)(8676002)(4326008)(110136005)(54906003)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 10:58:58.7546
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07162a7c-8614-4d21-63ce-08d951b6b395
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT048.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6916
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:19 AM, Gerhard Engleder wrote:
> On Wed, Jul 28, 2021 at 7:10 AM Michal Simek <michal.simek@xilinx.com> wrote:
>> On 7/27/21 10:23 PM, Gerhard Engleder wrote:
>>> On Tue, Jul 27, 2021 at 10:18 PM Rob Herring <robh+dt@kernel.org> wrote:
>>>>> The evaluation platform is based on ZCU104. The difference is not
>>>>> only the FPGA image. Also a FMC extension card with Ethernet PHYs is
>>>>> needed. So also the physical hardware is different.
>>>>
>>>> Okay, that's enough of a reason for another compatible. You'll have to
>>>> update the schema.
>>>
>>> Ok, I will update Documentation/devicetree/bindings/arm/xilinx.yaml.
>>
>> In past we said that we won't be accepting any FPGA description in
>> u-boot/linux projects. I don't think anything has changed from that time
>> and I don't want to end up in situation that we will have a lot of
>> configurations which none else can try and use.
> 
> I agree that it does not make sense to add configurations that no one else
> can try and use. The goal is that others can easily try out the IP. I want to
> provide the FPGA image to others who are interested. It won't be many of
> course.
> 
>> Also based on your description where you use evaluation board with FMC
>> card it is far from any product and looks like demonstration configuration.
> 
> You are right, it is not product, which is addressed to end users. It is a
> demonstration configuration for developers. Isn't that valid for all evaluation
> boards? As a developer I'm very happy if I can do evaluation and development
> without any vendor tree. I can do that now with the ZCU104. So a big thank
> you from me for your work!
> 
>> You can add the same fragment to dt binding example which should be
>> enough for everybody to understand how your IP should be described.
> 
> This dt binding example is already there.
> 
> So a device tree like this won't be accepted?

You have to share to customers bitstream. Likely also boot.bin with
PS/PL configuration and other files in it. That's why it will be quite
simple to also share them full DT or DT overlay just for your IP in the
same image.

Till now I didn't hear any strong argument why this should be accepted.

Thanks,
Michal
