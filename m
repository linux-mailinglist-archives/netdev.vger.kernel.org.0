Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF46D469581
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 13:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242970AbhLFMTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 07:19:41 -0500
Received: from mail-dm6nam10on2050.outbound.protection.outlook.com ([40.107.93.50]:17504
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242106AbhLFMTk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 07:19:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrvTnkmLE/9asncpQ3LE0fpDz79s7OWp/3iXdJi9k02ZVvYn60OT0kGsn2Ia9O+2Al92eEywVYdTFkk7qhhnva0c9STY3+WMDMK83zbm+DFGtaqQZEYFKzXotYvzCXMLi4mw2S5z0u3XS2AoMg72qNmK0QvDaa/LeqOrgIcse1wHOLjJo6QDAYDXY3XIJkO4MYn5lOF6lH0q4u5BTtgP7kTzJ0PTAp182vaLmrH+nKByG6uVSn7chvemhfxe2VHF4/023DrKSe5GY0WIovVYMp5ne6ZnsJwKuN82z8MDyAeVLEI0GXn0U/skS0AiIipvkHtUNQi2ZP7J4p+yXAH11g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaoULu0uA+efOoFEoEoD12zUtd9mDiQS0wwxfEa5jYE=;
 b=etnGWa9I7mwAOzKlzVh/fxsTLW8KrsvCnmFhpfoGVy+nh/7xWz4GXW4P+Lhf7ngyxXDpB9DQ9/+cwWNKMDga5UZa/fHlKbvgU7KTHSrE6vGELnatsh/rR/m/14E72X7KN9POt0/63vN0xaZRHzOPLIukmiZzgaibZh1uJZJbl17AstIA9Yaa0kwx5pJLJvYYc3A3KV04xwrqpjG3Yr9U0GxD8p0eDppKvWHttvSucap0QtCiYj02hQPTJDhOyEJUSkpHDZmiOTLZC3R1s1tS94Tt8zqdvo0eYlLaDczNlzvYq5X0X3F+KHaDdNvCoVh4CJA1B9UeIOtrxEwVwIe4AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=kernel.org smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaoULu0uA+efOoFEoEoD12zUtd9mDiQS0wwxfEa5jYE=;
 b=WCAvQ1luR2fztzcUw/TwIQEilyi8hSmj3Olaf6jTnQMuqH1Db5kQoWg/2G1cSp1sa3swqkoWQmtdpOrMJKYlS5p2bPKkliooQ0ORSQJLaWBeztjes89Wvsd/5lgTIdxaZXbuikP6Ipg4VifSEQIisV4wizRQvvGeojasflA7feA=
Received: from SN4PR0701CA0006.namprd07.prod.outlook.com
 (2603:10b6:803:28::16) by PH0PR02MB7704.namprd02.prod.outlook.com
 (2603:10b6:510:53::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Mon, 6 Dec
 2021 12:16:08 +0000
Received: from SN1NAM02FT0054.eop-nam02.prod.protection.outlook.com
 (2603:10b6:803:28:cafe::c4) by SN4PR0701CA0006.outlook.office365.com
 (2603:10b6:803:28::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend
 Transport; Mon, 6 Dec 2021 12:16:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0054.mail.protection.outlook.com (10.97.4.242) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Mon, 6 Dec 2021 12:16:08 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 6 Dec 2021 04:16:08 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 6 Dec 2021 04:16:08 -0800
Envelope-to: robh@kernel.org,
 geert@linux-m68k.org,
 davem@davemloft.net,
 kuba@kernel.org,
 nicolas.ferre@microchip.com,
 claudiu.beznea@microchip.com,
 palmer@dabbelt.com,
 paul.walmsley@sifive.com,
 netdev@vger.kernel.org,
 devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org
Received: from [10.254.241.49] (port=41474)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1muCud-0008CS-UO; Mon, 06 Dec 2021 04:16:08 -0800
Message-ID: <37b26b32-5828-df7f-3f73-6b9a4ef9d4e4@xilinx.com>
Date:   Mon, 6 Dec 2021 13:16:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] dt-bindings: net: cdns,macb: Convert to json-schema
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stefano Stabellini <stefanos@xilinx.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
References: <104dcbfd22f95fc77de9fe15e8abd83869603ea5.1637927673.git.geert@linux-m68k.org>
 <YagEai+VPAnjAq4X@robh.at.kernel.org>
 <CAMuHMdW5Ng9225a6XK0VKd0kj=m8a1xr_oKeazQYxdpvn4Db=g@mail.gmail.com>
 <CAL_JsqJHkL_Asqd5WPc7rfqXkbz1dpYfR0zxp5erVCyLiHaJNQ@mail.gmail.com>
From:   Michal Simek <michal.simek@xilinx.com>
In-Reply-To: <CAL_JsqJHkL_Asqd5WPc7rfqXkbz1dpYfR0zxp5erVCyLiHaJNQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f38daf2-77c9-43a5-ef48-08d9b8b22f5b
X-MS-TrafficTypeDiagnostic: PH0PR02MB7704:EE_
X-Microsoft-Antispam-PRVS: <PH0PR02MB7704228C093EC94EC5892988C66D9@PH0PR02MB7704.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pEhab+IXpqFxN9CEpR9oVc6Rqhl3TCK6ve7PIRKoNyvNjy9/uvdmpU2qXzDI1xaHynrfHPuPiD3bxEQjrc3HNMAel1c0aVfbkZp8GMAtz6AiseAHja5oPaGJ0OJyPwLJ7S97zaDI9GN9BDsPR9ou2TA+ifGyDfLIfouZNt5kzGmbH1j6coiB5tpOs7sLBGt9TsVJLtxZ7Z3MwNcvcpMyAZvQargxfZbxxT+7QMGD48n78nMAWfwj5pk5Ya4kN0SldYPIVKoSMqKjKL4z2VAYbkfxv+5PpJbpMJsHjrNoCFOfEXbUvUtJH7XskVnBykWWEURZ+enOo551WunkCLos/Q6IxDTwvFWx9xmxgcNJx0sg/pm8h0sGwN4oHtC6IqLYxtnYMXm00o0mnCUgETKVgc0Ji+TnTAnCFP+HuaQWv/DzDO2O/8wVthTMn8WAB+RA6bo8bvaWM2TwuBoywCS0ASDzPjFQzCMxV1spHvCRCwnSdEaoV29K2vYqlBM5h5vU9nSZ9AcJVXAl0ecEEOVwnNwF4dMy1giXf8huneRk6ENds1BvdeAgSC6f1B05w1ZEDyyn5Vq7h9d1V/rbQKIuPAsMOgNcB0GxE8W0z8wJTi6sCHruN6V3kAsw8z3eoQqozVvhdqZH/k+DuoJKEBsqTSwFWlO2DU0DiqQgF8c+Adu/yUJUZd2gUP30sligYE6+Y0HDQzX2OBAnjAWa2nZEj77Y1tr/Dt/3tQsDngHgq57jqB4Jv7f1axV8aWASm6LbHiqmtBd44S+VDtmSZePXSg==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(36840700001)(46966006)(53546011)(2616005)(4326008)(70206006)(70586007)(316002)(508600001)(82310400004)(6636002)(110136005)(54906003)(2906002)(36860700001)(44832011)(7416002)(356005)(6666004)(7636003)(9786002)(186003)(8676002)(26005)(336012)(5660300002)(31686004)(8936002)(47076005)(36756003)(83380400001)(426003)(31696002)(107886003)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 12:16:08.7098
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f38daf2-77c9-43a5-ef48-08d9b8b22f5b
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0054.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7704
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/2/21 16:53, Rob Herring wrote:
> On Thu, Dec 2, 2021 at 4:10 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>
>> Hi Rob,
>>
>> CC Michal
>>
>> On Thu, Dec 2, 2021 at 12:25 AM Rob Herring <robh@kernel.org> wrote:
>>> On Fri, Nov 26, 2021 at 12:57:00PM +0100, Geert Uytterhoeven wrote:
>>>> Convert the Cadence MACB/GEM Ethernet controller Device Tree binding
>>>> documentation to json-schema.
>>>>
>>>> Re-add "cdns,gem" (removed in commit a217d8711da5c87f ("dt-bindings:
>>>> Remove PicoXcell bindings")) as there are active users on non-PicoXcell
>>>> platforms.
>>>> Add missing "ether_clk" clock.
>>>> Add missing properties.
>>>>
>>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
>>
>>>> +  '#stream-id-cells':
>>>> +    const: 1
>>>
>>> I can't figure out why you have this here. I'll drop it while applying.
>>
>> See arch/arm64/boot/dts/xilinx/zynqmp.dtsi and
>> drivers/iommu/arm/arm-smmu/arm-smmu.c.
>>
>> It wasn't clear to me if this is still needed, or legacy. Michal?
> 
> They should update to the iommu binding instead of the legacy smmu
> one. It's been around for years now.

At the beginning it was there for XEN usage which was using this legacy 
binding.
Stefano: Please confirm that it is not needed anymore that we can remove 
it for zynqmp and versal.

Thanks,
Michal

