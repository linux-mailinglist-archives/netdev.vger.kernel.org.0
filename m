Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D923D9D0D
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 07:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhG2FWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 01:22:50 -0400
Received: from mail-mw2nam12on2075.outbound.protection.outlook.com ([40.107.244.75]:57696
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230257AbhG2FWu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 01:22:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFobI5IcwKu0fUOJ5W/Hz8C13/yaDJPaCZeaP3Pe1AsPaoyFpxYypKYB0glIcBnPCyJEk1Tda60iq7Za8Xfr6NhqLlCLDA8sIVLkEVldDD2vCOAvF+Eq6jEPDpzp6+601gOtYZ9N+zCcS3CJk+mNxahDDemaxEIyn988HWO7K6r8FhRLrQb04+vM+jnPcbtLrRTtRXskXbEpyr/Mn8XmkFKFEPMFroMlrew/ZnOIzUt0hvJ+ClGfRSmB1PGwOLuEOY/IHHmOklGJq0tZFWdIaQFa3j6d4zEq5QbC1sncaLMtLahKVXEBVAOHLo/X7fwlOL/8crDa3fMJewPVIaDYgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VxUVP6tO1qLcY1Y7ME46II4VtlL/hkv8TwWylkHNH/s=;
 b=SQO30jWsbRQnkuZ00jM3EFh5mL/cqyl+DQgIAhohj40y1oBL0CooNcUHDcQbHcJ+/KOe7OnOBHQ+HAEWZ+g7/9H/jCvocK4Axjs5vTM5DvU2A5PkfwaFKEiFcHiU+g6oJWIC0udC4uSk9/+AGBmxhbdISy01cj/x6+jDlAuW5IqS43oBW5DgOKd4B2NpjDIQwjwLIq5yvrpgr7UpN470GyQ/Ol0ka+KkLnu19tXnPsEO66ahZrdSbCS914v/8xNtxecQCHBpb6/gnNlhjo/mLAZh+bNVC7DieagmN6aNFpbfktGNWT+wIkbmyiOffl0zdu/2dh0Piwok4paC0CAn3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VxUVP6tO1qLcY1Y7ME46II4VtlL/hkv8TwWylkHNH/s=;
 b=ABdXMNs9Nl8p82WFQ8M6EYGfoVneJsCIKACbT2vE7bWJbji28/PT0Q5/JxF2mljBeGLNBAsBgtHsjlBPKcMk2Afigltpa+8iarLTeYGQXxoGpU6lwiKtp3nPqRrNiR5/mJQWzCWqa62WXj3jaN4fNIz9uKWTHTbkZViPNRJZlV4=
Received: from SN4PR0401CA0041.namprd04.prod.outlook.com
 (2603:10b6:803:2a::27) by BY5PR02MB6386.namprd02.prod.outlook.com
 (2603:10b6:a03:1f7::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Thu, 29 Jul
 2021 05:22:45 +0000
Received: from SN1NAM02FT0015.eop-nam02.prod.protection.outlook.com
 (2603:10b6:803:2a:cafe::af) by SN4PR0401CA0041.outlook.office365.com
 (2603:10b6:803:2a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Thu, 29 Jul 2021 05:22:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0015.mail.protection.outlook.com (10.97.5.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 05:22:45 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 22:22:44 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Wed, 28 Jul 2021 22:22:44 -0700
Envelope-to: devicetree@vger.kernel.org,
 netdev@vger.kernel.org,
 kuba@kernel.org,
 davem@davemloft.net,
 robh+dt@kernel.org,
 gerhard@engleder-embedded.com
Received: from [172.30.17.109] (port=36808)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1m8yVH-0006EH-Og; Wed, 28 Jul 2021 22:22:44 -0700
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
 <839bdf26-6aef-7e05-94b9-78c0d2061bf9@xilinx.com>
 <CANr-f5xJbTYa-jPzVMPcAV2Un+POBn24gd+604rzPt36RkRcDQ@mail.gmail.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <d763d777-f258-7390-a85a-6cae098102eb@xilinx.com>
Date:   Thu, 29 Jul 2021 07:22:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CANr-f5xJbTYa-jPzVMPcAV2Un+POBn24gd+604rzPt36RkRcDQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd641934-b715-4b01-de29-08d95250e597
X-MS-TrafficTypeDiagnostic: BY5PR02MB6386:
X-Microsoft-Antispam-PRVS: <BY5PR02MB6386068B22CCBEC527699137C6EB9@BY5PR02MB6386.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lmizIKoH4glsoWa32AjGRm2kUrCUQjgr4jzHfX74KzeXiP803UHlC4GvdIg4LGKbbPsSPqILG7DS0MNY41CgrRTgW0eyLY34/KAq8NZxpq0w7zzsnaw4flCqi27UIPpjbgBfZIJcq9DoMytW+4cU94AcbrYi402hXXFW94xwFaM9nTYpq9cgYgwTawCkc2M+9CDFrS/jKPxHHu/loSYSAdcf9j+aoajiDw9Bv0ichMGwo7HjFEflJiikgsDXMOaXm1N9z3u4CrUxQH75YXiECJNz7taEvjXZUpmQXkTJM0qdadTJIha1HprrU8f1kcXM3Klq6mNnVkNhJwz8g4MYyArm9O2DOoSfdch4qY+24i8hhgK1avnK7BhAiKkHTEm/POUGK6DEs+qioi4xji8rSe1zSWrf17VIzhZ3ndxjjdowit9hgLbXjfxyoPokG4WjkwtN2onRK73iHqui/vlOdBPuzKosl0zJmaeO9bUDapWaydSvhBMQg17V4T/ELk3Dr1/JaTCryoo6B1t0EIF+x4zQT+44VxlW6u6ZzlEUWkjAc1m3JGSUbFTsUqgyHNnZKYmrJNInVGj0nR8bcrt6tfgk/ISaAefPtOVnKjWW2m8I2Ke3o8io41LJHtTHzPi3+QL23pguoS2UdyKtTtbBmWlfXAhEpKH8V/8GK+vbZzeppmiDJAfYHphmhMUJKXQAxiC7WZCyzUzzuCpji/sm84XLjPr/w9kchJUyMnuXEGbXfmOpXRBXpR262EvNiKOW
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(36840700001)(46966006)(26005)(66574015)(356005)(47076005)(2616005)(36860700001)(4326008)(9786002)(5660300002)(7636003)(31686004)(53546011)(6666004)(82740400003)(110136005)(31696002)(478600001)(44832011)(316002)(70206006)(83380400001)(54906003)(186003)(2906002)(8676002)(336012)(8936002)(70586007)(82310400003)(36756003)(426003)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 05:22:45.1622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd641934-b715-4b01-de29-08d95250e597
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0015.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6386
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:51 PM, Gerhard Engleder wrote:
> On Wed, Jul 28, 2021 at 12:59 PM Michal Simek <michal.simek@xilinx.com> wrote:
>>>> In past we said that we won't be accepting any FPGA description in
>>>> u-boot/linux projects. I don't think anything has changed from that time
>>>> and I don't want to end up in situation that we will have a lot of
>>>> configurations which none else can try and use.
>> You have to share to customers bitstream. Likely also boot.bin with
>> PS/PL configuration and other files in it. That's why it will be quite
>> simple to also share them full DT or DT overlay just for your IP in the
>> same image.
> 
> That's possible of course.
> 
>> Till now I didn't hear any strong argument why this should be accepted.
> 
> I want to try a new argument:
> 
> For new bindings a schema is used. The goal is to ensure that the binding
> schema and the driver fit together. The validation chain is the following:
> 1) The binding schema is used to validate the device tree.
> 2) The device tree is used to "validate" the driver by booting.
> 
> So the kernel tree needs to contain a device tree which uses the binding
> to build up the complete validation chain. The validation of the driver against
> the binding is not possible without a device tree. The only option would be
> to compare driver and binding manually, which is error prone.
> 
> If device trees with FPGA descriptions are not allowed in the kernel tree, then
> the kernel tree will never contain complete validation chains für FPGA based
> IPs. The validation of bindings for FPGA based IPs has to rely on device trees
> which are maintained out of tree. It is possible/likely that schema
> validation is
> not done out of tree. As a result it is more likely that binding and
> driver do not
> fit together for FPGA based IPs. In the end the quality of the support for FPGA
> based IPs would suffer.
> 
> I suggest allowing a single device tree with FPGA descriptions for a binding
> of FPGA based IPs. This will build up the complete validation chain in the
> kernel tree and ensures that binding and driver fit together. This single device
> tree would form the reference platform for the FPGA based IP.

This is good theory but the only person who can do this validation is
you or your customer who is interested in TSN. I am doing this for quite
a long time and even people are giving me commitments that they will
support the whole custom board but they stop to do at some point and
then silently disappear. Then it is up to me to deal with this and I
really don't want to do it.
When your driver is merged you should start to do regression testing
against linux-next, rc versions. When you convince me that you are
regularly doing this for 2 years or so we can restart this discussion.

Till that time you can simply keep rebasing one patch with your DT on
the top which is quite easy to do and you get all
functionality/advantages you are asking about above.

Thanks,
Michal


