Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F013D8710
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 07:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhG1FN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 01:13:27 -0400
Received: from mail-sn1anam02on2056.outbound.protection.outlook.com ([40.107.96.56]:43522
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229752AbhG1FN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 01:13:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0Etu6/hSwI/6fe4kIqSRKVfHiHpMGBdq2e6Fw8mwQ943xBW4zopruj2CiZkupDtrOB2HV6g2DrP+u9yJSvn6QvmaW9WMW8obq7yus3dWub8f2gdPyZUKze0zTcPji8y1PkYLE/5CBwYgukjFIIJfmKkRTYPkDwbsC5MAuGz637k1q3cixVeWH1Gl33/I1AwrAF05acW/PZRZgIvvvW4jkf6GaEMrVB08TXPlmYYMZtblQ3uDk9ddyVEpz+kh+TpailTy5IDwwzoFp81TNCREKtCeBhG/oRfj1CWYPyXNF96ngoEYNTP9ehBbrO40ekP2J3ZswkuZjqYGW9PGKYIIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4iuScFnijfROaKCvOYlCLjPQpDtNBrkD1fjvvR1X4g=;
 b=Sq/cFI+sBkbfJZhQcrbbhJeuQ3xZU9L+jOuhD3x12QwAoDCPxejTiitpP0hf8DyzUTaJaTq7Y6AA9+lKV1/nxnoPK6vPZs+ghw5Teus6XJEprCbOGOsszVkuGjdgcbq9U6nbQ/2iAfsM6HTbcPwwxjVW1FN5Bzf7u+8QI9vYRGosDYccBhaC/pmXjFGlw+wa9FrdVp0QNUtqzpFWV1dOMQrFMnBLeImrxMM7oc25H5ExydnpMR1iSZrunm6A7RcEJ6tZyvD/cWMPsRPCwyOev6fYpEbp8HFskqvoemrjJubaxvFTTA75RsIiSSbMia/HHeowDACB/qS5Dw5lagSz5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4iuScFnijfROaKCvOYlCLjPQpDtNBrkD1fjvvR1X4g=;
 b=jGNFaJaWp5K24FBM0STEfFagqbhgcMD6NmQoFguH8ubmYvx8uYGfSKIwAbFXkuIqNoLwqzEIptld5UC0nXPTPfRmLlnKm/x7qVDz3clS4PEyN3WX0zYNBIyoxRCiII0LM0gpFP4eRvUR/6mSZpDc9LJoaTYdzxyk4YfnF3CHgcs=
Received: from SN6PR04CA0107.namprd04.prod.outlook.com (2603:10b6:805:f2::48)
 by SN6PR02MB5295.namprd02.prod.outlook.com (2603:10b6:805:67::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 05:13:23 +0000
Received: from SN1NAM02FT0038.eop-nam02.prod.protection.outlook.com
 (2603:10b6:805:f2:cafe::49) by SN6PR04CA0107.outlook.office365.com
 (2603:10b6:805:f2::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend
 Transport; Wed, 28 Jul 2021 05:13:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0038.mail.protection.outlook.com (10.97.5.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4352.24 via Frontend Transport; Wed, 28 Jul 2021 05:13:23 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Jul 2021 22:13:23 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 27 Jul 2021 22:13:23 -0700
Envelope-to: devicetree@vger.kernel.org,
 netdev@vger.kernel.org,
 kuba@kernel.org,
 davem@davemloft.net,
 gerhard@engleder-embedded.com,
 robh+dt@kernel.org
Received: from [172.30.17.109] (port=33808)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1m8bsg-0003cV-Pg; Tue, 27 Jul 2021 22:13:23 -0700
Subject: Re: [PATCH net-next 2/5] dt-bindings: net: Add tsnep Ethernet
 controller
To:     Rob Herring <robh+dt@kernel.org>,
        Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        netdev <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-3-gerhard@engleder-embedded.com>
 <CAL_JsqLe0XScBgCJ+or=QdnnUGp36cyxr17BhKrirbkZ_nrxkA@mail.gmail.com>
 <CANr-f5wscRwY1zk4tu2qY_zguLf+8qNcEqp46GzpMka8d-qxjQ@mail.gmail.com>
 <CAL_JsqKq6H471iFoLWRGvNSLpaJmuF+feDFut2p+J725n3U4HA@mail.gmail.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <ae17968a-e265-6108-233a-bd0538ad186c@xilinx.com>
Date:   Wed, 28 Jul 2021 07:13:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKq6H471iFoLWRGvNSLpaJmuF+feDFut2p+J725n3U4HA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ee900ff-54db-45c6-99a0-08d951866c67
X-MS-TrafficTypeDiagnostic: SN6PR02MB5295:
X-Microsoft-Antispam-PRVS: <SN6PR02MB5295507FDC6B8775805EBC68C6EA9@SN6PR02MB5295.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A67hnXVTnxn8gykbY+nVvVO4/XfXRWNF2TytbzhTVMplQn/ltWU80d3aWmGG6qqCfRiRcf5nigEhpY6ymc4iPuIKMplQ7Rvu1TSkY/7ZvCraJPSZI9p81bgluRCCzkm/igA68uj2QYQx+SJcRPiwOAec6cvaQEL5AzvqgzIX7jZQJxnZFl0AF9UO9jqZuaHPR9uMx0DibNHsrBOrtWOLJHpUvIFqTERLqz04cRlv2xUq/4rTXXm1w6omCZ3Bj+2vvbnviqDGNpxgiCsE/GHpH+kBcyrvDoT/c/pGqZdsb4hOJWji2+wuky7He1QlO7UA09RbMvBcLaz6BPS/I9psSDt2Kz09vfMI01aRgP6fehGwiKaX+Rv0phrZMMAcgPIvMjO5KSsM1vnYzZqPWYtC9u0BpIGxOL1rif+dL51wwq5bHBW7wLVK+GPJpZrnupWJgSDuARd1MH4wuVlKaJ9O+PXSbeQ2CoxEKxiL4Gylnj3PdQ5npaTQm16QnfCiymrykIF4AM27+uKJpkuClW1MB3okPMieiVPfYJQA/l6w+VgJfl8a+glugREHKyKkN87F+QRnL9KqdkU+Pq3OzRj6P+C3QB/wA8rMVvYkooQUo/8hEW+ciQmwBxvvF4L3BV7WZpkDgRWp7piuanXgyGuujRZUAupBr8adznHE0QscW2RVkNXuUvQpT/UNRgV/iQwyPlFM97wAzIKDxYqyIkZ3beYKTI0JVNEL3up9c74uwhm4OW/FQKC4sEp+C8++uHA1HGVy1ks0eNpGAs4Z6rpstA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39850400004)(46966006)(36840700001)(70586007)(426003)(8936002)(356005)(53546011)(36906005)(2906002)(36756003)(70206006)(7636003)(31696002)(2616005)(316002)(83380400001)(36860700001)(478600001)(336012)(8676002)(186003)(4326008)(110136005)(44832011)(54906003)(31686004)(5660300002)(82740400003)(82310400003)(9786002)(26005)(47076005)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 05:13:23.5032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee900ff-54db-45c6-99a0-08d951866c67
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0038.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/21 10:25 PM, Rob Herring wrote:
> On Tue, Jul 27, 2021 at 12:35 PM Gerhard Engleder
> <gerhard@engleder-embedded.com> wrote:
>>
>> On Tue, Jul 27, 2021 at 1:35 AM Rob Herring <robh+dt@kernel.org> wrote:
>>>> +properties:
>>>> +  compatible:
>>>> +    oneOf:
>>>
>>> Don't need oneOf when there is only one entry.
>>
>> I will fix that.
>>
>>>> +      - enum:
>>>> +        - engleder,tsnep
>>>
>>> tsnep is pretty generic. Only 1 version ever? Or differences are/will
>>> be discoverable by other means.
>>
>> Differences shall be detected by flags in the registers; e.g., a flag for
>> gate control support. Anyway a version may make sense. Can you
>> point to a good reference binding with versions? I did not find a
>> network controller binding with versions.
> 
> Some of the SiFive IP blocks have versions. Version numbers are the
> exception though. Ideally they would correspond to some version of
> your FPGA image. I just don't want to see 'v1' because that sounds
> made up. The above string can mean 'v1' or whatever version you want.
> I'm fine if you just add some description here about feature flag
> registers.

Don't Xilinx design tool (vivado) force you to use IP version?
Normally all Xilinx IPs have certain version because that's the only way
how to manage it.

Thanks,
Michal
