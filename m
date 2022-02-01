Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAB24A5753
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 07:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbiBAGok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 01:44:40 -0500
Received: from mail-eopbgr40076.outbound.protection.outlook.com ([40.107.4.76]:21886
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233800AbiBAGoj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 01:44:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2QsBHiA/4szjhQ4i3WhIgPav6X5tcRHkMdp2L9CzoVUmlblpWMLkW03iooD1aMQLKlEFhVaUuMU12tNjbBck0pG5Xbyd5rl5svNkN9rPv+MOZskQ9bU0MBRGVb8qRw2b5xg2a3Pv9B4vOaUrD5oNkJc2mvZanjvMK94SjQATyDqGKpyHN+VY+0wy2S/rI/mmzyIM2TgkFETiXOtN6ZaaYM360YVAU/LvU6egmYNc4TvrNxYw3zRF5T4S29/k1pFnLOciLzE5IFQwcAkussi8RKem2Ob2PcP1f117n8pokd9ul4dUs8yQGkdL2S7fMtb1k3uVy+D3akH2YoEnRkbYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oq2IMpF61QUGcxy1dJBPW9IH9fgJCW3fc+auXUwcE10=;
 b=OuODX7VrGGUOgDNQ8qMHgrYpznmJoVxV+lf91RE7kcKI9l/tMiezHPqd/+3q2nbvHn9yNOdUY2+yS/Ztv3OGQjDx+7AQxl6D5HrG+CbhNX0q1eXN0GHwknoP6Rz23J2a+3k+/ZZ/tlfBDd3eqsOUmlI2ozIY1F7Z/HxVnvBOAqeVqJnR0zOjbrVtE6aWbV1+yep9zHnBWT1iW3uBXVimoxcgZxwdmdspg/277HVxmE1gOpty5iktE5SE1eJsU8NM8qrpeXvjeQHeQkXzQe0l+NBrB7qa5hKw1bLVLhlmqExjmKqeHrtSLD/W80u4ihwjDQP6puH99X/uP1y7r3IJbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.73) smtp.rcpttodomain=kernel.org smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oq2IMpF61QUGcxy1dJBPW9IH9fgJCW3fc+auXUwcE10=;
 b=UjteLeZpXKTAcRKz0Y6TUMjE+RGmP1rhHiyR0Ns2SoI7DhFz5icTfVuw0IvymGPUAdLXJu8Khk8xGGMr9vHmzq8vhCN3fHfq7ovlhVpbNAS2Erg61kFddhuCnGoR2J+yLCspdKFVZpBJ1Dbc6IVFFJLEoDk0vaNeewKah0vNhW4Tb8h4QSB4nBMK4CjekUZHAUoLF6+8cG9eOBoQyfoQokNqdhb28zczZFWH2viVMLUSQzaceKI/yYtHqHURUpq/CgXb5C+ArF+Z5u7+9wTwkiFWB6M1Nb6MzF/k+/Ndy/YqBXCB3uxDlWIPz+wanwNKNBVyjs39F+4tYoLQV3o/vQ==
Received: from SV0P279CA0050.NORP279.PROD.OUTLOOK.COM (2603:10a6:f10:13::19)
 by AM6PR10MB3400.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 1 Feb
 2022 06:44:36 +0000
Received: from HE1EUR01FT064.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:f10:13:cafe::1e) by SV0P279CA0050.outlook.office365.com
 (2603:10a6:f10:13::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Tue, 1 Feb 2022 06:44:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.73)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.73 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.73; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.73) by
 HE1EUR01FT064.mail.protection.outlook.com (10.152.1.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4930.15 via Frontend Transport; Tue, 1 Feb 2022 06:44:36 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SNA.ad011.siemens.net (194.138.21.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Tue, 1 Feb 2022 07:44:35 +0100
Received: from [167.87.1.21] (167.87.1.21) by DEMCHDC8A0A.ad011.siemens.net
 (139.25.226.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Tue, 1 Feb
 2022 07:44:35 +0100
Message-ID: <21e7c87a-7680-bdf0-5290-90126741935f@siemens.com>
Date:   Tue, 1 Feb 2022 07:44:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Georgi Valkov <gvalkov@abv.bg>,
        linux-usb <linux-usb@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <2f001839-2628-cf80-f5e3-415e7492e206@siemens.com>
 <20220131211428.07cc4aa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
In-Reply-To: <20220131211428.07cc4aa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.87.1.21]
X-ClientProxiedBy: DEMCHDC89YA.ad011.siemens.net (139.25.226.104) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 814f2bd9-e325-4175-65c4-08d9e54e5024
X-MS-TrafficTypeDiagnostic: AM6PR10MB3400:EE_
X-Microsoft-Antispam-PRVS: <AM6PR10MB3400B773192D1DB190821DEC95269@AM6PR10MB3400.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tYGW3ePxKu4ovIQAw077zqhfBgpEvxZiiY19xQhRXRgPUrJqaOJe79Xf+ajM1Pw2gD4lv93S9WeiHBBhlGIlL0evRyjhJ66w8Jhutfa81EEugYEsBcov8DB9VwAqrhdz8CZkMhCO8ffkZti86iXAf0ApRHhJSdGdJ1fZcsZ2hPsvDqKepGRYLtKOq+6TRA1/iVbTCHmIlAGWYBIsKjNTWf0X7cJ/i21Pby4giODnVoQn7A7qcCg1JBKapOYmT3OZJeVE0q12wuryzpeChH/kZIqk2TEONBLil9qD2DnYgBNIxCwD3W8rXmh3IWF8X3M1johit5jVbopAQnLg+V94LsOZ/lNV4Q7g7eiAT7LURIWt+SUtaHFy6Fa0FoiS9Zxv5G6xy/F0n90N8/YVEbuuzIgQxrqj/LohQyxppfDwkUxcOI3aONDuCpLY28ur8YeQeYh3Yfz8Du1Fzm+MbdjhfmSz1vcaiUmhqHgaEs4EhFxbKxNcGWVLseuNATZKF15aTSPUY9wzgHI8k8GnGwUiMomnd7NFlcPdcTXJDiQJ0XA3fDmpr2sZcK4TijVFtkr23+hBmXHQakW5Hbe3OMrch+PbWRs1dAlUI3FVVwZa4kYoDw+hm+JYRB7yJn/oQEktqEjx5aLmNKidVnyztSVAM1gVzUttzs05xnoMep503OUO3YNu0X8+MexdKTpVmU+S6T5l5kwnm+TkgBhNxuZ3kj0wNJzusf15VpUhMmQjvovuS+xMqthLLvD0BoLoRZtd8JMIbEEQBRtrRXXjZ6PaRw==
X-Forefront-Antispam-Report: CIP:194.138.21.73;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(53546011)(5660300002)(26005)(16526019)(186003)(83380400001)(336012)(36860700001)(82310400004)(44832011)(956004)(2616005)(2906002)(8936002)(47076005)(31696002)(86362001)(16576012)(316002)(40460700003)(31686004)(6916009)(6706004)(54906003)(508600001)(82960400001)(356005)(4326008)(8676002)(70206006)(70586007)(81166007)(36756003)(3940600001)(43740500002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 06:44:36.3619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 814f2bd9-e325-4175-65c4-08d9e54e5024
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.73];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT064.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR10MB3400
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.02.22 06:14, Jakub Kicinski wrote:
> On Mon, 31 Jan 2022 19:58:14 +0100 Jan Kiszka wrote:
>> From: Georgi Valkov <gvalkov@abv.bg>
>>
>> When rx_buf is allocated we need to account for IPHETH_IP_ALIGN,
>> which reduces the usable size by 2 bytes. Otherwise we have 1512
>> bytes usable instead of 1514, and if we receive more than 1512
>> bytes, ipheth_rcvbulk_callback is called with status -EOVERFLOW,
>> after which the driver malfunctiones and all communication stops.
>>
>> Resolves ipheth 2-1:4.2: ipheth_rcvbulk_callback: urb status: -75
>>
>> Fixes: f33d9e2b48a3 ("usbnet: ipheth: fix connectivity with iOS 14")
>> Signed-off-by: Georgi Valkov <gvalkov@abv.bg>
>> Tested-by: Jan Kiszka <jan.kiszka@siemens.com>
> 
> Hm, I'm starting to suspect this patch is cursed..
> 
>> diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
>> index cd33955df0b6..6a769df0b421 100644
>> --- a/drivers/net/usb/ipheth.c
>> +++ b/drivers/net/usb/ipheth.c
>> @@ -121,7 +121,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
>>    	if (tx_buf == NULL)
> 
> There is an extra space character at the start of each line of context.
> 
>>    		goto free_rx_urb;
>>    
>> -	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
> 
> But not on the changed lines.
> 
>> +	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
>>    				    GFP_KERNEL, &rx_urb->transfer_dma);
>>    	if (rx_buf == NULL)
>>    		goto free_tx_buf;
>> @@ -146,7 +146,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
>>    
>>    static void ipheth_free_urbs(struct ipheth_device *iphone)
>>    {
>> -	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,
> 
> Pretty clear here in how the opening bracket does not align after the -.
> 
>> +	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN, iphone->rx_buf,
>>    			  iphone->rx_urb->transfer_dma);
>>    	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
>>    			  iphone->tx_urb->transfer_dma);
>> @@ -317,7 +317,7 @@ static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags)
>>    
>>    	usb_fill_bulk_urb(dev->rx_urb, udev,
>>    			  usb_rcvbulkpipe(udev, dev->bulk_in),
>> -			  dev->rx_buf, IPHETH_BUF_SIZE,
>> +			  dev->rx_buf, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
>>    			  ipheth_rcvbulk_callback,
>>    			  dev);
>>    	dev->rx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> 

Sorry, a submission tool regressed here unnoticed (grrrr!). Will resend.

Jan

-- 
Siemens AG, Technology
Competence Center Embedded Linux
