Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB203102564
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfKSN1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:27:55 -0500
Received: from mail-eopbgr730044.outbound.protection.outlook.com ([40.107.73.44]:14336
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725798AbfKSN1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 08:27:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxe+EDSJyascJ541us+BBuj75Qdi2jviJ/Rmr+15YvoJzfS72QADmj3hzgTBAKLsimmTJZg+yJjOO1WlB/5PTH9kdDN4jYmnFTYC5fDarc4rdZgE47rCBHkyGMmiAFbOzeWyNL1wKMXek+2tST4J0rq7yBW/OFEONhjsIL/uD/0qRI4/qFa8Sm5u984NhtOmaQ1YVWsRlZxS4fW0h8dcdtcIVTXORbPRvblfHrabVfnQ3BZuKAFKtq3sCAWBd8+qFORMurLjX9fmbHQaGuIecGSYyH+gd+hiXAGX2lSz+tSnWUKOQfQCxMW5npGwscdeef+QTP4PrcmyWQk7twq6+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1Ew/gOEqrsj5xhS8Ui6gdwvsMK1TlrL9AOyYmUmklI=;
 b=SrSc8fHxmQsjTxvWVWOlrNjRUlGNy3lNHlwf3zyyyeZhRLN78VcpLgH9QecFKZEdxQuCqFMOz2STRuPcLYrlAb3/5bSMpRNdL7z8LBuX1/Qmu9FHCf/LdqvohKVY2PW/JB2WY2LPEqtksaGMclt/ySi+yCxzUH2x1LWhmHYBCs4fhwnc9d8F9nZZQWtbXK6pBIzqJ/Z5v0uzidoX+fDS94EgpAuWMIlkYJat4yaxBrKqluvFPoiI1vQrexaFmY59Qxvy6+dUY6TveQeYbdnFOWEGBR+Un6k/s71QVSNZeeztjsn1VcZbXlMq/9xrNtWQvJmc7bKstRhR09pVFczDcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=huawei.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1Ew/gOEqrsj5xhS8Ui6gdwvsMK1TlrL9AOyYmUmklI=;
 b=qAvOxjYm/6oX52593748H6rd2U+jGj8unAIY1K40ZU9FUk8sE9X6c8Cy9hbuhv/5w2SPiSN7nwPWUUrOPIUiDovCbYkL7k28BzIwAOcjyXfqhBQnBHYZgEH1tI5ECgk0Kvd2cb7STLw5W5+9WN5qOlKYWoUUKQnKwXaYY2azwfA=
Received: from DM6PR02CA0065.namprd02.prod.outlook.com (2603:10b6:5:177::42)
 by CY4PR0201MB3553.namprd02.prod.outlook.com (2603:10b6:910:8e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.29; Tue, 19 Nov
 2019 13:27:11 +0000
Received: from SN1NAM02FT046.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by DM6PR02CA0065.outlook.office365.com
 (2603:10b6:5:177::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2451.23 via Frontend
 Transport; Tue, 19 Nov 2019 13:27:10 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT046.mail.protection.outlook.com (10.152.72.191) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2451.23
 via Frontend Transport; Tue, 19 Nov 2019 13:27:10 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iX3XB-0001gV-Hr; Tue, 19 Nov 2019 05:27:09 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iX3X6-00015E-EB; Tue, 19 Nov 2019 05:27:04 -0800
Received: from xsj-pvapsmtp01 (mailman.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id xAJDR0aV032491;
        Tue, 19 Nov 2019 05:27:00 -0800
Received: from [172.30.17.107]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1iX3X1-00013a-VC; Tue, 19 Nov 2019 05:27:00 -0800
Subject: Re: [PATCH] mdio_bus: Fix PTR_ERR applied after initialization to
 constant
To:     Harini Katakam <harinik@xilinx.com>,
        YueHaibing <yuehaibing@huawei.com>,
        David Miller <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, mail@david-bauer.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
References: <20191111071347.21712-1-yuehaibing@huawei.com>
 <CAFcVECJQH15y78YPurq_m2bDigQ6EzSCZHZMROHRFe-rJKw88g@mail.gmail.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <d01319c1-56d4-d707-549b-2f8b52fa8450@xilinx.com>
Date:   Tue, 19 Nov 2019 14:26:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAFcVECJQH15y78YPurq_m2bDigQ6EzSCZHZMROHRFe-rJKw88g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(65956001)(2616005)(426003)(81166006)(11346002)(305945005)(446003)(229853002)(186003)(6246003)(336012)(31696002)(70206006)(50466002)(2906002)(44832011)(2486003)(36756003)(6666004)(478600001)(356004)(486006)(476003)(14444005)(126002)(23676004)(47776003)(36386004)(230700001)(81156014)(9786002)(5660300002)(107886003)(31686004)(8676002)(76176011)(8936002)(316002)(26005)(53546011)(110136005)(54906003)(4326008)(58126008)(70586007)(106002)(65806001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0201MB3553;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d67c3c56-bc5e-498a-af23-08d76cf42e99
X-MS-TrafficTypeDiagnostic: CY4PR0201MB3553:
X-Microsoft-Antispam-PRVS: <CY4PR0201MB3553405BFF7FB32F2864AB83C64C0@CY4PR0201MB3553.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 022649CC2C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ay3y3M6P9ayPgVh3qLRmad3qzNw4meCS/Pzpz8NsFweRXwUFqNVeGMAjUBotcPtkTX1R3LErszVdYAuXXFkDXBBp0wU4zZQ+5Txv7h0bgefEUY2XJgiNTl909GOGOrzqt0kCXHc90Or4Yf1DSqqepxOZ9D4pQAyFmlsR9oAP6KjXjIB12ECRGhvbxnSQKj5CTWBa/RIxRZS2wDVvzjp7FGMXAsmuVlAm8/GnGn2z871cb0CX8b7jtZrpGIqHioeDEDvstASAqh5wn2xUzBeH71CLZvJQS6cQwgGUnRRRPYB9emrX+2I+lZgQvwm8FueXqJ3V4Dv1YJKecD43NIIvCiuypRYAndgrVg3VTGKK+Mw6uKIDudA0uqyH+DyhEyHQBsrcKHA/YS//RB1Q3FkHC+YK90eSupH9meh9rKh01bS2SNgKAuXhMIbqsL6aA8GO
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2019 13:27:10.4727
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d67c3c56-bc5e-498a-af23-08d76cf42e99
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0201MB3553
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 19. 11. 19 13:58, Harini Katakam wrote:
> On Mon, Nov 11, 2019 at 12:53 PM YueHaibing <yuehaibing@huawei.com> wrote:
>>
>> Fix coccinelle warning:
>>
>> ./drivers/net/phy/mdio_bus.c:67:5-12: ERROR: PTR_ERR applied after initialization to constant on line 62
>> ./drivers/net/phy/mdio_bus.c:68:5-12: ERROR: PTR_ERR applied after initialization to constant on line 62
>>
>> Fix this by using IS_ERR before PTR_ERR
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Fixes: 71dd6c0dff51 ("net: phy: add support for reset-controller")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  drivers/net/phy/mdio_bus.c | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>> index 2e29ab8..3587656 100644
>> --- a/drivers/net/phy/mdio_bus.c
>> +++ b/drivers/net/phy/mdio_bus.c
>> @@ -64,11 +64,12 @@ static int mdiobus_register_reset(struct mdio_device *mdiodev)
>>         if (mdiodev->dev.of_node)
>>                 reset = devm_reset_control_get_exclusive(&mdiodev->dev,
>>                                                          "phy");
>> -       if (PTR_ERR(reset) == -ENOENT ||
>> -           PTR_ERR(reset) == -ENOTSUPP)
>> -               reset = NULL;
>> -       else if (IS_ERR(reset))
>> -               return PTR_ERR(reset);
>> +       if (IS_ERR(reset)) {
>> +               if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOSYS)
>> +                       reset = NULL;
>> +               else
>> +                       return PTR_ERR(reset);
>> +       }
>>
>>         mdiodev->reset_ctrl = reset;
>>
> 
> Adding Michal Simek to add some test comments.

This patch is causing access to bad area on Microblaze with axi ethernet
driver.

The issue is that origin patch was checking ENOTSUPP and new one is
using ENOSYS which completely changed kernel behavior.
And this is even not described in commit message.
I will send a patch to fix it and would be good to get it to v5.4.

Thanks,
Michal



