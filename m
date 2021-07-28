Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265C43D870D
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 07:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhG1FKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 01:10:35 -0400
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:24938
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229752AbhG1FKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 01:10:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJeRG+lHPQDteyqzu+ABJOU7FG+jx4cqS5wYLk9RwGBRdfQ9bf7qSBb9nyPUPDOoVnlSKH1g6UiBfeTgsOdg+ohMR/5XXxijtgP1gnmV0AogJjpMG6e/Dk0kIyVSDUU7ucxymkFQdaXlPB+l8HHsWkTZUdnh8aMEQZlDEi1KL/E7YXLWuU0AmzdOa8SBRgyG5eRK9+3aol4mwU135I71FXBHn8iqyKG145EPRJjPccYiGIYZrtr7YDRxmuiwS3fVe0pNJTMWZuCDMSHeodfccvrcsqwoTZO3i4lho2lUYv2Sfqa6aJwhQHDt4nRxaHS6xo67YqLzSQqK6eCzUb1LbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jF+Y/uDqwP8I3z6e1SDIANkVmFYW+67KuNXKr5AON20=;
 b=HwZ2XOAl3PLFGBeGTcULAPYJFXRcagetTl2lzmpdFHmKrnHEMo0HTQSEUyySJU5juoHeVAS57ndARGYN6g8IG0aMSZBntOyY0AF+8CQcGe3MI865BSN5MNoH5JLOOKLhapVv2P6Txa0XvFHHxQ3bfURx1fFTXy6gXvhqgNNKUVdgA9hHvc+UrkgtQLRse2nyQwL4bteUf+Td52gFYFqyMwQJ1ieIvHVCQQoGcLLfl4Ydpqkz/rEncvS7u4n36wMR55CYZs9S++fCAMKmEasn9qMFwr2EAnJG/eW8hEtA1v4++b9P02B+xvD/5mRBZ+Oaj2Zx8sMUM0jFsdY/bRtsPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jF+Y/uDqwP8I3z6e1SDIANkVmFYW+67KuNXKr5AON20=;
 b=KV6ruMSQbEkfefTNqloc5h11zezayLfXIRvNx6d4SGJQ62ZGQHo0Vyiwz6Bh0/n4+mICqKtng5b1oOTHCBJl3yjaQQ2gNUV3x+mlUr6aFYzX0V/jPzLPXLYWSZquVnYPZFijb7IkFzx+cSWz2R8TcpxwdXai1/unqT829CrLJo0=
Received: from SA9PR13CA0023.namprd13.prod.outlook.com (2603:10b6:806:21::28)
 by BYAPR02MB4216.namprd02.prod.outlook.com (2603:10b6:a02:fc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Wed, 28 Jul
 2021 05:10:27 +0000
Received: from SN1NAM02FT0014.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:21:cafe::9c) by SA9PR13CA0023.outlook.office365.com
 (2603:10b6:806:21::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend
 Transport; Wed, 28 Jul 2021 05:10:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0014.mail.protection.outlook.com (10.97.4.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4352.24 via Frontend Transport; Wed, 28 Jul 2021 05:10:27 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Jul 2021 22:10:26 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 27 Jul 2021 22:10:26 -0700
Envelope-to: devicetree@vger.kernel.org,
 netdev@vger.kernel.org,
 kuba@kernel.org,
 davem@davemloft.net,
 robh+dt@kernel.org,
 gerhard@engleder-embedded.com
Received: from [172.30.17.109] (port=33554)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1m8bpq-000DZm-DB; Tue, 27 Jul 2021 22:10:26 -0700
Subject: Re: [PATCH net-next 5/5] arm64: dts: zynqmp: Add ZCU104 based TSN
 endpoint
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-6-gerhard@engleder-embedded.com>
 <CAL_JsqJC19OsTCa6T98m8bOJ3Z4jUbaVO13MwZFK78XPSpoWBg@mail.gmail.com>
 <CANr-f5yW4sob_fgxhEafHME71QML8K-+Ka5AzNm5p3A0Ktv02Q@mail.gmail.com>
 <CAL_JsqK9OvwicCbckvpk4CMWbhcP8yDBXAW_7CmLzR__-fJf0Q@mail.gmail.com>
 <CANr-f5zWdFAYAteE7tX5qTvT4XMZ+kxaHy03=BnRxFbQLt3pUg@mail.gmail.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <43958f2b-6756-056a-b2fa-cb8f6d84f603@xilinx.com>
Date:   Wed, 28 Jul 2021 07:10:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CANr-f5zWdFAYAteE7tX5qTvT4XMZ+kxaHy03=BnRxFbQLt3pUg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 116848ba-d76c-45f1-5588-08d951860375
X-MS-TrafficTypeDiagnostic: BYAPR02MB4216:
X-Microsoft-Antispam-PRVS: <BYAPR02MB4216002B78C9972AB68ED5B8C6EA9@BYAPR02MB4216.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ztN+lX2XmvKOd39m2gPvXkygq7uqroAVQNaF8quBaqgoMdqyECNK3xviuVKuvdcmBo/icOqyZx3W0Hgy3qVXhm7uE1WXmNdvvaphBX1aHwAQPxsD9xX33ISJtL7TMj2IKVdnR/tq8f097gTd8twrU17ALBx6rrEeSg7stYaPo6bM0z4MNmmbdhTXaWqeXo3miVMgRtfWixxjvFbPlE/xsggNINO81OpT339VUU2SeS6pe91elgjspGh70t1wj1CDNRFr3kpjT0mvpzaXixdLfROtJPMR2aUTU+AF5/6jkwSbLCH0aHiEDOHk4PWMtisdApq4ZcunZrtu5xS+rM38KVP6BCZSfWEH32SeB4gi5htIlpgNNkriISwngmrtl4g4xkFI/9wttwd5Ichf8LxcdHmTMiwxPSAbDlQkxuZ7Ko9PCNI16uFKFQ0kDy7SrFyOYU7stGijDC2NLrbJig4lfV2Yt0t+zJU+NgpeDlQTEr0DHKSpPETl7g67Ng/a3bgCsK6Og4W0AHwBnOH6FKgaIW1RDUku72N9tYp9nrkUwgMduVpTvGoIGaQ1sWABn19vD1p30TNLJSQc/5HYvpvKcs3/5xpqQbxhRCvo3zYKvw6o2AZ1PogWfqZDSHBXjZnMX2lJd+SBe8f91sMxpjzrUwV2RvO1OUJHZ51FHi+HnofH8rwBIE8jp5JOHqX5Mu2T15VXJXYuPTEqQfgMBD1JrfMXHB/224/QMfG3VaR4RpPdMa3BodPRK6wU8Gy9XUJjI35ogL7EzS2LnBGg0id8oQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(36840700001)(46966006)(26005)(8676002)(36906005)(44832011)(82740400003)(54906003)(110136005)(356005)(5660300002)(53546011)(4326008)(478600001)(82310400003)(70206006)(36756003)(70586007)(316002)(31686004)(31696002)(2616005)(36860700001)(8936002)(9786002)(2906002)(47076005)(7636003)(426003)(83380400001)(336012)(186003)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 05:10:27.4324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 116848ba-d76c-45f1-5588-08d951860375
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0014.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/21 10:23 PM, Gerhard Engleder wrote:
> On Tue, Jul 27, 2021 at 10:18 PM Rob Herring <robh+dt@kernel.org> wrote:
>>> The evaluation platform is based on ZCU104. The difference is not
>>> only the FPGA image. Also a FMC extension card with Ethernet PHYs is
>>> needed. So also the physical hardware is different.
>>
>> Okay, that's enough of a reason for another compatible. You'll have to
>> update the schema.
> 
> Ok, I will update Documentation/devicetree/bindings/arm/xilinx.yaml.

In past we said that we won't be accepting any FPGA description in
u-boot/linux projects. I don't think anything has changed from that time
and I don't want to end up in situation that we will have a lot of
configurations which none else can try and use.
Also based on your description where you use evaluation board with FMC
card it is far from any product and looks like demonstration configuration.
You can add the same fragment to dt binding example which should be
enough for everybody to understand how your IP should be described.

Thanks,
Michal
