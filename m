Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B2E3D9D02
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 07:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbhG2FHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 01:07:42 -0400
Received: from mail-bn8nam12on2070.outbound.protection.outlook.com ([40.107.237.70]:17568
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229957AbhG2FHl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 01:07:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N028r05UIKm8H8Yxm0DirG+eh4QSImjTAGkXEa5mADoUXW7KJZ8t/D8nfFU4vO4QGDq+uHkfx6ajdAs6OR8A+oEFnOpc+5xdk4bNOZYOavejTPjlhRch97Zt/hIWN4vpI7QsCfM7RbjRH7+Tc4LrbIbjQyOqddtuYtIKfSCCUfOEPY9mVUDoG/CMNX02r1F9R1dp5JvWZjRqrPZkRjwmnYLpRUxvte/4/+xuJaYM7+8oK4b/5bWn+3p+kvskKOARRh4ahnkhn7q7/0LCVOCequhkbdwVu8Anpro19cM4oVjuQ2pSaDGnP+uPPDtADkNi+FWKFAzHHcD55lHCsl3oCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjs7hob4vS6vMSQgWTnkgMYDV4zWOJPHIWzOzjZRyyo=;
 b=YhWcXDCmUEoE5bY9D+tKHK6F+6NodEvX2E1kIiUehFmQiLLMxGujuo1luhjNO0QpBcnjS+blk7WMPGySxD8kO+6vk5BA66vKfgedz5amO9hRk/E02n9xPsd/w/HydATLA3qUynHyYVwTvAbKkSKaJiy+ayRLcs83BmM2eie8MNduN+1MdD9hIRT+8UncT3hXOoRKekgy0NgWSyG5drobJHRSuv4wuz2qpnrjmqYtWy1Jm/fbDjegVbYKpfpX2jExYptCVPVLGVexAtuvcE6fqoWFdb0OMU1xu88qVpWw/H6zn1GzZtngHgbjGqihbXhmEa9B4NjVH4HT85U5tYW6MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjs7hob4vS6vMSQgWTnkgMYDV4zWOJPHIWzOzjZRyyo=;
 b=aXCCfRyq9/Ux5goJOZQUY1qA0oZJwU5J5o3dEEu+PyVdR9Z7fvaiehyFBWgLw4T+JQc8/FfWuMBZoODXh5s7KcgSSEJnhZXkbXaWce8h1HkAGzYrm8HVbMIRjcaJi3cH9BxjiSBGVn3XIAlMhxDsYOaF/+7n0ZgVMWwRcxbtxPw=
Received: from DM6PR06CA0050.namprd06.prod.outlook.com (2603:10b6:5:54::27) by
 SJ0PR02MB7245.namprd02.prod.outlook.com (2603:10b6:a03:29d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Thu, 29 Jul
 2021 05:07:37 +0000
Received: from DM3NAM02FT051.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::bc) by DM6PR06CA0050.outlook.office365.com
 (2603:10b6:5:54::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Thu, 29 Jul 2021 05:07:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT051.mail.protection.outlook.com (10.13.4.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 05:07:37 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 22:07:36 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Wed, 28 Jul 2021 22:07:36 -0700
Envelope-to: devicetree@vger.kernel.org,
 netdev@vger.kernel.org,
 kuba@kernel.org,
 davem@davemloft.net,
 robh+dt@kernel.org,
 gerhard@engleder-embedded.com
Received: from [172.30.17.109] (port=35478)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1m8yGe-000AEu-Gr; Wed, 28 Jul 2021 22:07:36 -0700
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
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <2a151f9a-f743-31f4-a4c1-cdf15daf1b67@xilinx.com>
Date:   Thu, 29 Jul 2021 07:07:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CANr-f5y4=1hj-6WFT1HdewU=sich6KgkgmR6-qWimFxQiV5MFQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6652f068-dcef-441e-b88a-08d9524ec895
X-MS-TrafficTypeDiagnostic: SJ0PR02MB7245:
X-Microsoft-Antispam-PRVS: <SJ0PR02MB72459C22498B1508B17AE4B0C6EB9@SJ0PR02MB7245.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C4AuxGQnuksEfa0jze5yTnoAnBAP9VgeD9YUlXNAg3LEvG7IWnBqX7ZhJ0RhFCajc5syEOzTgLkcfho1PjXj6PwoPrVE29m3UBPwZglAScGpOx6sk/86RTnOmtFX1zwA6H1dQuSRa5e8klzZbh/hU+emrVuc2uekFydxu+FUb7cM9P6WL76CMm+9dCrAJuj0DM5fbozHzHDxxVRCZoE+r4Ccbwa/Gjku379DC3TePL6Z9G3J3nmu40677FxsEJ8llHQnWdM3yKTSXNWWYDiASQ+eZGL44AHUv+oVb03vwBVCgib7t3vD/mhbdNznBJ7CxttFu9FSjm5VuZ2mdX0G6SH/GL3AizZhqdjw8H4ki7nuIz3Nqi/OaClIxrBpSO1wd3rKBMJuDpm78cxrvzciU+gTtTeW28OuTkL0PJpAC/Zu/9OQPhE++oudAOvMODAZf3qI8Gi3oeNOO4dz7Go2Csr5w4d4ocV91BKkTnjtGVmDym4bpw0VvaXNx/L9tP1SyF465URicctLHL5rT38lCtW+iBNJ/K4/IESu8KW9i+vC0NDy+wKWkGWJsZoEIq+Po2Y+fNAjxZn2Shbw0DYrtECY23GQP5yvIDpc0ihU48f8OmepNzdQ2zoAESgGI38qEPkHB0Xc+IHZu1+vrFogVr8dCzFHCQPCzLgEtSdRrHKpwvvz93657yxoojTL/FBI6x9gyMjpb6jnNLIn2hfPMsNl0Py0mnXIcpyn4UeNEtmXbfd2fUVv+AfAZKh6MCDjxH6gAjyW0mhLB2tcl37imw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(36840700001)(46966006)(82740400003)(5660300002)(70586007)(31686004)(83380400001)(54906003)(426003)(36756003)(4326008)(110136005)(2616005)(31696002)(8676002)(70206006)(316002)(53546011)(36906005)(478600001)(7636003)(8936002)(36860700001)(44832011)(2906002)(82310400003)(336012)(9786002)(26005)(356005)(186003)(47076005)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 05:07:37.4928
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6652f068-dcef-441e-b88a-08d9524ec895
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT051.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7245
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:14 PM, Gerhard Engleder wrote:
> On Wed, Jul 28, 2021 at 12:55 PM Michal Simek <michal.simek@xilinx.com> wrote:
>>>>>>>> +      - enum:
>>>>>>>> +        - engleder,tsnep
>>>>>>>
>>>>>>> tsnep is pretty generic. Only 1 version ever? Or differences are/will
>>>>>>> be discoverable by other means.
>>>>>>
>>>>>> Differences shall be detected by flags in the registers; e.g., a flag for
>>>>>> gate control support. Anyway a version may make sense. Can you
>>>>>> point to a good reference binding with versions? I did not find a
>>>>>> network controller binding with versions.
>>>>>
>>>>> Some of the SiFive IP blocks have versions. Version numbers are the
>>>>> exception though. Ideally they would correspond to some version of
>>>>> your FPGA image. I just don't want to see 'v1' because that sounds
>>>>> made up. The above string can mean 'v1' or whatever version you want.
>>>>> I'm fine if you just add some description here about feature flag
>>>>> registers.
>>>>
>>>> Don't Xilinx design tool (vivado) force you to use IP version?
>>>> Normally all Xilinx IPs have certain version because that's the only way
>>>> how to manage it.
>>>
>>> Yes I use an IP version in the Xilinx design tool. I use it as a version of the
>>> VHDL code itself. In my case this version is not related to the
>>> hardware software
>>> interface. The goal is to keep the hardware software interface compatible, so
>>> the IP version should not be relevant.
>>
>> I expect this is goal for everybody but it fails over time. We normally
>> compose compatible string for PL based IP with IP version which is used.
>> And it is quite common that couple of HW version are SW compatible to
>> each other.
>> It means use the same HW version as you use now. When you reach the
>> point when your HW IP needs to be upgraded and will require SW alignment
>> you have versions around which can be used directly.
> 
> I would like to follow the argument from Rob:
> "The above string can mean 'v1' or whatever version you want."
> If there ever is an incompatible new IP version, then a new compatible string
> can be added which means 'v2'. E.g. for 128bit physical address support I
> would choose the compatible string 'engleder,tsnep128'. I don't see an
> advantage in adding a version number to the compatible string.
> 
> This IP will be used in products where compatible hardware is a must.
> An IP upgrade which requires SW alignment will result in heavy complaints
> from the customers. Such an IP upgrade would result in a new IP.
> Like for shared libraries, an incompatible API change is similar to a new
> library.

From my point of view where I expect the most of customers are using
Xilinx DTG (device tree generator) compatible string is composed with IP
name and version used in design tool. This is unique combination which
properly describes your HW.
And choosing different compatible string or string without version is
breaking this connection between hw design tool and sw.

From my perspective it is much simpler to understand that your HW ip
called ABC-rev1 requires DT node which is your_company,ABC-rev1 instead
of any made name.
But up2you - you will be talking to your customers.

Thanks,
Michal



