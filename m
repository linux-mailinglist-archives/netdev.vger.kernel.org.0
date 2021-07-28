Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672BD3D8C49
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 12:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhG1KzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 06:55:19 -0400
Received: from mail-dm6nam11on2073.outbound.protection.outlook.com ([40.107.223.73]:38368
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231994AbhG1KzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 06:55:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHLD1wAUW2tyOTi2x7K1aZDttDeTwk3rGm1am2sdFQaYVWb8JR8kaI2C3KZx1BhyEhyMi5HAaAsAeujbFryLScJnb5d4ukjebdL2wXjet8nng/qBq8cWsZKWxugjl210Dy4fI1VdglC1z24jUS0hDdVXR1Wu5+QOWAtlSsA3f1QVfFtOo1uxuYHFpQQJJLRopt7L0erseIJGVawpdiKjLEpWtwvpJh0pPyHJWmuEcGMa4Pv15xkmOlbLqJDNrDkOU5mJwpSHx9y8UpjOHnuy9Nfu10ZRsvRpOBB56QUhbMriZyGRvml7iJzJzXW9NPxM5OJusCXAaOXF3B5iMCrtIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/veWbCzNmqpY0y00flMjRdID36qWP7fiH8mJ0xntYpM=;
 b=f7NxM1ljCPHt5jdenwmw5fRjB/HxDNQ7isbHq9XuJFZT5iBEAgzvFGcSK8spyZqJUcMGEPuLhrBDTYfR1vtDLAlDgkoRxT+GqsNSD8RpsA3KJVc91KwbDoJdrGGzPLUfsGBCG3If38PeKF0CYM5mpbEKjO2WHwxuDOO/XMdutGo/i9VNLVXlXfKg9cF+iKBNeb+Ghu4oLNEcOeIJEq1OlINNjZvo/Ji0G13+0sfxiu8ypcnTVWs8xvhrbzhkp+lpJbo/eVID14yq6VzDNpwovKzIapZn1rISq9mEdP38J/JiMi2+YO4gDbk9yyE/FoFniY2ZndAyDhQylg2ymU+RSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/veWbCzNmqpY0y00flMjRdID36qWP7fiH8mJ0xntYpM=;
 b=HDPc4BrpjOlizUtnt5ALYRMjBrG63IUxjshtXq/6SD7PBvbNll31ca8jndrado7yVgwFTIETQ+5WQuXgr8gaLAm0JhqbKC4e4eBiZYfIBe8+8GXnNQPQT0nc04hpyzsTrW9w1gL4auXGKX3vj5LxZfkzzzxcAFib0ULdK9Og9kM=
Received: from DM5PR2001CA0023.namprd20.prod.outlook.com (2603:10b6:4:16::33)
 by BN7PR02MB3987.namprd02.prod.outlook.com (2603:10b6:406:f5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 10:55:09 +0000
Received: from DM3NAM02FT044.eop-nam02.prod.protection.outlook.com
 (2603:10b6:4:16:cafe::56) by DM5PR2001CA0023.outlook.office365.com
 (2603:10b6:4:16::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Wed, 28 Jul 2021 10:55:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT044.mail.protection.outlook.com (10.13.5.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 10:55:09 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 03:55:09 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Wed, 28 Jul 2021 03:55:09 -0700
Envelope-to: devicetree@vger.kernel.org,
 netdev@vger.kernel.org,
 kuba@kernel.org,
 davem@davemloft.net,
 robh+dt@kernel.org,
 gerhard@engleder-embedded.com
Received: from [172.30.17.109] (port=37646)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1m8hDQ-0004n0-OU; Wed, 28 Jul 2021 03:55:08 -0700
Subject: Re: [PATCH net-next 2/5] dt-bindings: net: Add tsnep Ethernet
 controller
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        Michal Simek <michal.simek@xilinx.com>
CC:     Rob Herring <robh+dt@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-3-gerhard@engleder-embedded.com>
 <CAL_JsqLe0XScBgCJ+or=QdnnUGp36cyxr17BhKrirbkZ_nrxkA@mail.gmail.com>
 <CANr-f5wscRwY1zk4tu2qY_zguLf+8qNcEqp46GzpMka8d-qxjQ@mail.gmail.com>
 <CAL_JsqKq6H471iFoLWRGvNSLpaJmuF+feDFut2p+J725n3U4HA@mail.gmail.com>
 <ae17968a-e265-6108-233a-bd0538ad186c@xilinx.com>
 <CANr-f5zvWN6pFUqRHvYV9oMGhF+VBJzhK+yE+SqMuSEhA5-X7Q@mail.gmail.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <b3921ff3-55d4-0d26-ebe3-2fee0c73332e@xilinx.com>
Date:   Wed, 28 Jul 2021 12:55:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CANr-f5zvWN6pFUqRHvYV9oMGhF+VBJzhK+yE+SqMuSEhA5-X7Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56625e44-3392-49ff-98e6-08d951b62afa
X-MS-TrafficTypeDiagnostic: BN7PR02MB3987:
X-Microsoft-Antispam-PRVS: <BN7PR02MB3987334D97D5F8930BED3298C6EA9@BN7PR02MB3987.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5/0v+V5hWcsI2b3UXN100b7CGDvGhOMBjdEHd5cH2Ek5biOoMljLxg4B3ALu9BRmEkIGCN996KeBxY1mKmEKMz0YErWhaJpxLy8emYntzNpgKvoPwyBwrBuI1pSL6u53eSC6A4/EItR4kIPAbByw1tq/xxdhHPqC6EBOo9UCuGB9FgNsYOkVW0xrMSwI/Y/AuuieN3CrqRN5iiteicBuaCH7QDFS66QI3JA8hY8exCG35y6Mok+EYvtJFpKdMfCQkw7z9nNKi44VaiCCwz4NYDyXA0kQ56K0gcT1hjV9rkRR2UpvpNE6IRJIDoZymQjBTCn+FxI7MJW7xyEYc/BnuvcLErewKhuKFeHexHpo67fOPGLdqGMWTaYISTp4Iwouah6Hf9UsT2YrkbkCQQvNKg/+bCtu6zEMVj6BZn+5WBlsPqbMASfSsvfp1oi25yEkxS2k0VC8T78PoTMx4RWtxJinjhM1ILeGoEU/n2o5O+w1Fn21e4W4eNU5zfV9bL7rnpJiRQCGAGzo+mWA6CEWvMYjp5nsTn5GfB99uOuLG7rYcxXz/nFtLLDNI73csPzNv8J5eDE84X5Dk39F9UTgFyHLLtpTPeRSG7m8Dor8P5qawUWDKnig1SeXjNmW0hbFgX/3TrQtHExvQtAP2v1kJk5RAkx/96JTFkQ7ukOPFCiY79wx+NyzrSaK4utzkNX64SM7TQF0NENptrT1SLY4WGSH/gfwxnuq41csNFAFtfqacXl7X283JuZ3AqPo3Ozq64XF2vj0bcOJGkaAEBHo0w==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(396003)(346002)(46966006)(36840700001)(336012)(31686004)(54906003)(82310400003)(186003)(82740400003)(8676002)(356005)(70586007)(478600001)(5660300002)(53546011)(44832011)(26005)(70206006)(36906005)(8936002)(4326008)(36756003)(9786002)(7636003)(36860700001)(316002)(110136005)(31696002)(2616005)(2906002)(83380400001)(47076005)(426003)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 10:55:09.5680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56625e44-3392-49ff-98e6-08d951b62afa
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT044.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB3987
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 9:44 AM, Gerhard Engleder wrote:
> On Wed, Jul 28, 2021 at 7:13 AM Michal Simek <michal.simek@xilinx.com> wrote:
>> On 7/27/21 10:25 PM, Rob Herring wrote:
>>> On Tue, Jul 27, 2021 at 12:35 PM Gerhard Engleder
>>> <gerhard@engleder-embedded.com> wrote:
>>>>
>>>> On Tue, Jul 27, 2021 at 1:35 AM Rob Herring <robh+dt@kernel.org> wrote:
>>>>>> +properties:
>>>>>> +  compatible:
>>>>>> +    oneOf:
>>>>>
>>>>> Don't need oneOf when there is only one entry.
>>>>
>>>> I will fix that.
>>>>
>>>>>> +      - enum:
>>>>>> +        - engleder,tsnep
>>>>>
>>>>> tsnep is pretty generic. Only 1 version ever? Or differences are/will
>>>>> be discoverable by other means.
>>>>
>>>> Differences shall be detected by flags in the registers; e.g., a flag for
>>>> gate control support. Anyway a version may make sense. Can you
>>>> point to a good reference binding with versions? I did not find a
>>>> network controller binding with versions.
>>>
>>> Some of the SiFive IP blocks have versions. Version numbers are the
>>> exception though. Ideally they would correspond to some version of
>>> your FPGA image. I just don't want to see 'v1' because that sounds
>>> made up. The above string can mean 'v1' or whatever version you want.
>>> I'm fine if you just add some description here about feature flag
>>> registers.
>>
>> Don't Xilinx design tool (vivado) force you to use IP version?
>> Normally all Xilinx IPs have certain version because that's the only way
>> how to manage it.
> 
> Yes I use an IP version in the Xilinx design tool. I use it as a version of the
> VHDL code itself. In my case this version is not related to the
> hardware software
> interface. The goal is to keep the hardware software interface compatible, so
> the IP version should not be relevant.

I expect this is goal for everybody but it fails over time. We normally
compose compatible string for PL based IP with IP version which is used.
And it is quite common that couple of HW version are SW compatible to
each other.
It means use the same HW version as you use now. When you reach the
point when your HW IP needs to be upgraded and will require SW alignment
you have versions around which can be used directly.

Thanks,
Michal

