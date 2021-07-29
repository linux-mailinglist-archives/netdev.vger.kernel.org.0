Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851293D9F09
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhG2H5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:57:30 -0400
Received: from mail-bn7nam10on2063.outbound.protection.outlook.com ([40.107.92.63]:2800
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234680AbhG2H53 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 03:57:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLWu8rNq9Q7dWLdwvCPFGF/x6wGXD/U3USe2Dyxjx/c6ZGlOecB7AsuhmZsJ76fZfFUk70CQJM8+wFJesweIvLZyOMrO3k/KEhZu9h/ocMGj9tJ3J8d4Vo6SLPao0uSl2TLctCilEvzRcKeWZ0MCqrLbpFgPpEOGO9jC8hIbpOQyMW26GhWNdu6XSfxtNgOKXrshsZ6Kzbd7AXSC1ASCKOFKchiL5EwFef8dYdqxNQuEJw2KMP9SHKd+tBbr9oIKnpdx5i+obfK8mDqftRqesdexmuVcplnoCcVsqLXnLv2h4MwM/oDulBk0xBP76Cy1FWl1ElIF7N3RNk2nQS4JCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAdo+/A2IFLHdntOZoXxooXpilSfhYh3Dw3garFmy2w=;
 b=C7B0UFhpnjpFyKUyzJbNZJvJ5YtBG6yFd7yVZFE4Wj9ru1Cyx7alKJtMLe01D7i9fl8uEJmxKO22rtguAdgnDAMzwzRM1tRc8ocEW5JwVeYJxRRYJc64kC0PwdKk7fX/qCbuSyVDyyjMbyZ9Trhsa4GtonsroCD+qV2ZlN2GZ9L7GVkKCO12rdMT1W9hkiremvGR6oDTnPBauGmWG6hFBm3hao9EV6uuDEzsUXRl+jckqNDkECd5ap1i77y63+mFNPTjeGS6zytb9Zq0ia58gkcpRmFTWy4MlC0vhpgSgnRJED6dTl8+op3pt6rWPn1avK2JqcT5d5Taf3jMH+S+vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAdo+/A2IFLHdntOZoXxooXpilSfhYh3Dw3garFmy2w=;
 b=FmRkROq1aLzt0g0gYpVmZ3MdfCOvvk8Yxi1uPFUoVFlN87vss/rdbK+lr4GDs4NjsS5k5UI4NOdEU/UpqNHFgx4cxz7PdXGvR4P3QHk31gT6FI1KXr6pZMW8WjKrqo03C7DQ9hslPQDuUMVVT/CngESSVM2Q8gvR4GJ5OVmO4eQ=
Received: from SA9P223CA0002.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::7) by
 MWHPR0201MB3515.namprd02.prod.outlook.com (2603:10b6:301:7e::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 07:57:22 +0000
Received: from SN1NAM02FT0026.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:26:cafe::67) by SA9P223CA0002.outlook.office365.com
 (2603:10b6:806:26::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Thu, 29 Jul 2021 07:57:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0026.mail.protection.outlook.com (10.97.5.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 07:57:22 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 00:57:22 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 29 Jul 2021 00:57:22 -0700
Envelope-to: devicetree@vger.kernel.org,
 netdev@vger.kernel.org,
 kuba@kernel.org,
 davem@davemloft.net,
 robh+dt@kernel.org,
 gerhard@engleder-embedded.com
Received: from [172.30.17.109] (port=50734)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1m90uv-000DBl-LX; Thu, 29 Jul 2021 00:57:22 -0700
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
 <b3921ff3-55d4-0d26-ebe3-2fee0c73332e@xilinx.com>
 <CANr-f5y4=1hj-6WFT1HdewU=sich6KgkgmR6-qWimFxQiV5MFQ@mail.gmail.com>
 <2a151f9a-f743-31f4-a4c1-cdf15daf1b67@xilinx.com>
 <CANr-f5wuZTo-bH2rvB8oCGKJe4Qmg-gz9r7ym_VhWemP42o2sQ@mail.gmail.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <326af2cb-1796-f10b-06a6-8494d52f2387@xilinx.com>
Date:   Thu, 29 Jul 2021 09:57:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CANr-f5wuZTo-bH2rvB8oCGKJe4Qmg-gz9r7ym_VhWemP42o2sQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf7abca5-432f-4867-7050-08d952667f68
X-MS-TrafficTypeDiagnostic: MWHPR0201MB3515:
X-Microsoft-Antispam-PRVS: <MWHPR0201MB351598A8DA168A4DA45EB2DEC6EB9@MWHPR0201MB3515.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q5ctM70pvsv5TR8looiG+H9tP3TGBV8v+pjX+i2byQhF3XMMeaIVwBxFGbj30q3VfHVxtDK72ZwxGuuL4C/mwJSS8pulg/t4y8tRCOqoUTpFfwcb7au2AzjJr0TBaFNotOv0cmzwfvujoU5OKBDn06yP87Ug8znFFcxlxIw9ThC3t797UThNmmaYAzwGB7Y2gCqlnAEk44vWIDl/jNKK0jwZ0YOBV+zxFbAIvCQv+8eNOSlfBEtOcgUz17v01T9xQiMrr653VID+0nn01jZHduFddHfWfBPXZmELp2Lp/HakyJx4HY+dohR2CY+pDqgUe3CFM3U4ELqkhGkZPKsAnOzM8EdQ0mndnuNOomoVMA7382Ni/7ZTiz8tIsip3EccjATdWKSDG2d1rY4iqeFPpdBpEJvnKQfovxTrLQm/vJgG/ApSibpo4pwedBEw7BdlOHeruOJ86tTLmOfy9PnObCcapxhbP1/03sc0uVpGOkOYZd9koaDGGYZBMV5BhmMmpfzrEq9/SHSFmUTnnbioaB+SZNAiSUc/NdPP0tOWxTh8aGiYt/ErEzbBfz/83dRgfFA3/cKoH1CbOuJZVsvAu8rfw88xQH1S9FTRpQcE6lEtkkvw0MtnMA4Kp5qXjsLZKqL4tGPcJ/mCiwqLtPSle8PJRBBEkA2FKc8nuzWj6JDQzeraKPVWS96cPMSanF8fSo2q3kOu4ygF3b1I2hG7Jo61XfLl/A7fODAjHLllEpOT8vD9h7W8gYF7S2m7Z6UXzVpIKrifeVzXqixu4N+IOQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(36840700001)(46966006)(36756003)(82310400003)(53546011)(47076005)(54906003)(82740400003)(31686004)(8676002)(6666004)(8936002)(26005)(186003)(36906005)(336012)(7636003)(9786002)(110136005)(2906002)(356005)(316002)(83380400001)(31696002)(5660300002)(426003)(4326008)(70586007)(2616005)(44832011)(70206006)(478600001)(36860700001)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 07:57:22.6518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7abca5-432f-4867-7050-08d952667f68
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0026.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0201MB3515
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/21 9:07 AM, Gerhard Engleder wrote:
> On Thu, Jul 29, 2021 at 7:07 AM Michal Simek <michal.simek@xilinx.com> wrote:
>> On 7/28/21 10:14 PM, Gerhard Engleder wrote:
>>> On Wed, Jul 28, 2021 at 12:55 PM Michal Simek <michal.simek@xilinx.com> wrote:
>>>>>>>>>> +      - enum:
>>>>>>>>>> +        - engleder,tsnep
>>>>>>>>>
>>>>>>>>> tsnep is pretty generic. Only 1 version ever? Or differences are/will
>>>>>>>>> be discoverable by other means.
>>>>>>>>
>>>>>>>> Differences shall be detected by flags in the registers; e.g., a flag for
>>>>>>>> gate control support. Anyway a version may make sense. Can you
>>>>>>>> point to a good reference binding with versions? I did not find a
>>>>>>>> network controller binding with versions.
>>>>>>>
>>>>>>> Some of the SiFive IP blocks have versions. Version numbers are the
>>>>>>> exception though. Ideally they would correspond to some version of
>>>>>>> your FPGA image. I just don't want to see 'v1' because that sounds
>>>>>>> made up. The above string can mean 'v1' or whatever version you want.
>>>>>>> I'm fine if you just add some description here about feature flag
>>>>>>> registers.
>>>>>>
>>>>>> Don't Xilinx design tool (vivado) force you to use IP version?
>>>>>> Normally all Xilinx IPs have certain version because that's the only way
>>>>>> how to manage it.
>>>>>
>>>>> Yes I use an IP version in the Xilinx design tool. I use it as a version of the
>>>>> VHDL code itself. In my case this version is not related to the
>>>>> hardware software
>>>>> interface. The goal is to keep the hardware software interface compatible, so
>>>>> the IP version should not be relevant.
>>>>
>>>> I expect this is goal for everybody but it fails over time. We normally
>>>> compose compatible string for PL based IP with IP version which is used.
>>>> And it is quite common that couple of HW version are SW compatible to
>>>> each other.
>>>> It means use the same HW version as you use now. When you reach the
>>>> point when your HW IP needs to be upgraded and will require SW alignment
>>>> you have versions around which can be used directly.
>>>
>>> I would like to follow the argument from Rob:
>>> "The above string can mean 'v1' or whatever version you want."
>>> If there ever is an incompatible new IP version, then a new compatible string
>>> can be added which means 'v2'. E.g. for 128bit physical address support I
>>> would choose the compatible string 'engleder,tsnep128'. I don't see an
>>> advantage in adding a version number to the compatible string.
>>>
>>> This IP will be used in products where compatible hardware is a must.
>>> An IP upgrade which requires SW alignment will result in heavy complaints
>>> from the customers. Such an IP upgrade would result in a new IP.
>>> Like for shared libraries, an incompatible API change is similar to a new
>>> library.
>>
>> From my point of view where I expect the most of customers are using
>> Xilinx DTG (device tree generator) compatible string is composed with IP
>> name and version used in design tool. This is unique combination which
>> properly describes your HW.
>> And choosing different compatible string or string without version is
>> breaking this connection between hw design tool and sw.
>>
>> From my perspective it is much simpler to understand that your HW ip
>> called ABC-rev1 requires DT node which is your_company,ABC-rev1 instead
>> of any made name.
>> But up2you - you will be talking to your customers.
> 
> Thanks for explaining your point of view. From my side I don't expect that
> Xilinx DTG is used. The few people I know who are working with Zynq/ZynqMP
> are using the Xilinx tools only to generate the bitstream. This way you are able
> to do software development for the Zynq/ZynqMP like for any other hardware
> platform.

Definitely possible but when you have 20 soft IPs if you are not using
DTG you have big issue to have proper IRQ ids, memory maps and make
sense to use DTG to give you that initial description which you can tune
by hand. But it is decent starting point.
Maybe in your TSN case you are dealing just with small number of IPs
that's this is easy to do by hand.

Thanks,
Michal


