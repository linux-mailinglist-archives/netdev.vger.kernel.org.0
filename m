Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7DC43313D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhJSInN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:43:13 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:22517 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234132AbhJSInL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:43:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1634632858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oT3yntYjFTj2N8PIpuaDiwDwCqs+85QID6dyNwUOBFs=;
        b=H4mnEbVUj8mI50OsRRvp5oOJ5NDj2R//4zKohOw30SmSAWbA6ud2HOVaLiNBNbNkO/rHIh
        e+5JBiDWJOVbe+AjkZa5MDGVPrZGcNb0bJT6zty0sLdTowBynU3shckAw3i5hAhGkDsHhI
        7o+nzj+VS1yEd71+f6S+no1NLQh3p5A=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-31-y4iEPW6FP1-NNa0JFoHvWg-1; Tue, 19 Oct 2021 10:40:57 +0200
X-MC-Unique: y4iEPW6FP1-NNa0JFoHvWg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQ865chhhrgHDgHWiWBA9EVRsTANv0vbXb3MtBKCFxhl83tdENBZrtSc854ss16WvSHdu9em3+lfq7AvTAKlQVy8UmYQDyEacxrhnjG7dCKqbEt3brSPv1G/m+bmDksS26T7ZOckx46udQpJOhw0FT7OPIXzsSnpdLpcLkfy9iOJZZ+XDxhjZEfktdzhmZ5+PWQjWPi+4yK7C9PnUyvxnuJDnyvFXAQTewEV3Ao9DqtNsmZkg/NHJG1I5TrTzLOiTF74dcgHlClHrIhg0sdCTTJkJERDlkjvP99/bnb4eO3MqOFM0uVQfARKcXqJALAGhn7AOhl91VnMqE5842Hm0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oT3yntYjFTj2N8PIpuaDiwDwCqs+85QID6dyNwUOBFs=;
 b=TUgNlSUtrfJ1BYiHB3P6MmwtOL3uTqiK3RVS8S/2aewGMWTnVItGxKQ2KtxDgyvJR394MrVGJaS/FbdKVYBkwN28lIX/QOkYkJrlVY9cTmKE+T19xpFARR5PstW6xrmKb1908dp3Wq+pHLpEgOH1/xg7U3QPQAS1S9eaUCo5R3EcIaD4z2HhCioVtYapmHXbaN/rWgtFkac36h6cw+azpetYPjBy/Q7vJ9pd/7YPR1sCLsk3iuWgBShlrWoREp0SBgcZzR7zBwa3Xo2WEzhkeV8nPeymY/+ltche56grJcxUdDZ/1vKWDenhLbZzJVPt2DPrlOuAbBh3yvcKl1zHTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB6PR0401MB2293.eurprd04.prod.outlook.com (2603:10a6:4:47::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 08:40:55 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 08:40:55 +0000
From:   Oliver Neukum <oneukum@suse.com>
Subject: Re: [syzbot] divide error in genelink_tx_fixup
To:     syzbot <syzbot+a6ec4dd9d38cb9261a77@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000809ecc05cea5165d@google.com>
Message-ID: <649fd15d-4e23-f283-3a58-f294d59305c7@suse.com>
Date:   Tue, 19 Oct 2021 10:40:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <000000000000809ecc05cea5165d@google.com>
Content-Type: multipart/mixed;
 boundary="------------FA2C7BB85455DE572841162A"
Content-Language: en-US
X-ClientProxiedBy: AM6P194CA0037.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::14) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from linux.fritz.box (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by AM6P194CA0037.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:84::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Tue, 19 Oct 2021 08:40:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 598cf07d-6c25-4808-e173-08d992dc2aaa
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2293:
X-Microsoft-Antispam-PRVS: <DB6PR0401MB22931CE14336C54FB00DE4D0C7BD9@DB6PR0401MB2293.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 77RV43nRfKNnT2Rts4xLagHs8+t+DDWM3LK2hclGogXKm31SIbfy5Ig6eIoJvri27asrXrBsnd663OwV3933yKsNPQnIY1umDKHDbmhINSIqEnsJjvi49beTsl86u4KjPei86gDcmxIiwDjQJ2+y7Y4rxJaIbSMIjK41wxCGjXj6CrPzIKQiPR4NgXk7FR9YSpPia/XmljerSU6ZzVhJbUesNg8MqENNBX3qQYq6fzpE7soxmamgxAKG0wim+wBNcsgFkFlbzgTgQnUV6osKrAZ9w9Jfvo8k2OezfimPh/w3jgXIHeNdRycj/mLU947mbhr4uGn84Vz1iHDcFubuxAdZRUU3ns6DrpxMX8mHvUD5y67MV4PEu7mwNFLkW8MfIonCQTImCIkMHQCMIQAZIadteokpAzar8aDD6vjyn9WTcJOGPavGqNLUZdRmwcGmLk0p+u1BHw0MZLU7Yuz5tXhk6gTUhCnHAU95GIEKC39N8tRrlSLKcpCEYsWmX8zfeKkh5ZoI2+TWAuOWNnlgFY0eQmpbp2GI70sjTASGDzW3NNTBo8uijcOnqDm4TYCHiRQt7ajVDl8LMEIE4Iaaj0vL/kmScuDpKRiK/efPK5YHMWr0CG+HjISBS265l6RXLcn9fVuiPZwaRoVB3tnY3+QMh0FRZH1rb8sDgxIPLE1waODXMCgjjo/HzFX6dIgTsg3GcF8vK3j7kWAQv99pxkJ1A7YAvTFLDRyHXL4h8WjQP7W9JMh/wzMpiJBAvf9YNamwZMqSCYpsJlzzlFhwzY+RkNfnXt19I2312kI6MJYnKM/6dEoYRK7XfyDfeFHAEJB5yHHwEgp62Iphz6bwpTPQjwXO0cHUNtIgXJMvHvOtNYGOEaPhW6EF1p/GrBJAUP7MAW06EzF31MirLNWBxsfHiAgAcldj7wk6GxY0IkY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(2906002)(53546011)(36756003)(508600001)(86362001)(66946007)(8936002)(66476007)(31686004)(38100700002)(33964004)(66556008)(8676002)(316002)(186003)(2616005)(6486002)(31696002)(6506007)(6512007)(966005)(235185007)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlRmU3ZucmNDTFJjMk5jVFpmMWI1NDVzY0NYT1BZbzE5SEczLysrNlp5WXlo?=
 =?utf-8?B?bTZ6UkhTdkZ6dFN6ZElNa3B0SThkSitLMTJTMDQ5RzNXdlRVL2FlZWM4UkdW?=
 =?utf-8?B?dDlaRkJDWHpmRnZrSUUvNStOdEJYaEsva2sxOVBFV2VackU5WnlTOFY4a3d2?=
 =?utf-8?B?Y0ZiU3o5cmpBS0xOM1d2Q3hyaHpNUi96cHNVaDRsTjFIU0JkT1dHOTZhdTFv?=
 =?utf-8?B?OEY4ckZhcThaWTlXSEdmdU52T3hQZURoL3d6eW04WWd1dmJTNTRMeldtTk5J?=
 =?utf-8?B?RllRT0QwMGgxMzhZdkNBemVSeXp3S205OWJ3UC9RZ1oxQ2xLWlZpOVZFY2ZF?=
 =?utf-8?B?NG91YlpEV0VlRDU0VTF0aUliSWh1cnA4dmxCVndFWjhkdjhOdWs1UkVDSnRK?=
 =?utf-8?B?QVRBN0lmdWhWVTN1WUl0V0FQOGdvMUh6a0JqaW5TVHNkd0tIRUV1TkVqL3Mx?=
 =?utf-8?B?WlpQVGpjbXRoaVdIbkc3dUpzSE11ek94ZWpNcVZWNWNJSGRTRDlZNVdqN3RL?=
 =?utf-8?B?SDh1M2sxUFllR05FT0tWalZQQU8yUnBuWUFVakdPK1JBQ1lnSlB6cFNFQ0Ir?=
 =?utf-8?B?VHBOYXRqTGgxNTZsYmlMWm5NRTYyTGdWZHJ1enlINzlZQmJmdHM3UEpQVEx6?=
 =?utf-8?B?OFRNa0F1ZktvWTNCSjBHM01yODBLM3ZTd0xpaUQ4MUxQcWhmM1c5aURHd29m?=
 =?utf-8?B?K1kyUkh2aGFiRzJocDAxdXJQYVRhdVpEaGpDM2dFUjZFSEltZFR6SVNVK05m?=
 =?utf-8?B?TUdGTjNEYXk0cGNzKzljd2pTQ2JMU0lVWE9HcnA4dk1SQ2Y4NHNTYWRrMGRn?=
 =?utf-8?B?VExpMnJEVml5QjF4ZHV0MGlWdkpzMEhLOGpQb0p4ajY5N1lSaERqR0svOFMr?=
 =?utf-8?B?bFpZVTBiM1hibVhZY29LOHdzdk1CdU9vWTl2V2Y5ODlLSk9BcGVDYm9razd4?=
 =?utf-8?B?Wm1idVBYSVNmcmFMUU1nZXoza0swMjhyUGZoWXNrSnFNVlpnVnZCZGFURjli?=
 =?utf-8?B?NUlXc0YvUEp6TWhUeTdkQzdheFlhNFpaWDBsRCt3MkJrMmwzSFBZWHVEZWI2?=
 =?utf-8?B?Ny9Da0VTUDM1VlArb1JaSVJQYUYvVE91c2xFOFdWZ3dra1I0amhzbUZobEpM?=
 =?utf-8?B?TmpwWTNZbFB5OE5RaGxvc3hIYVhaam15aDBUeTJoWlZGbXByeVFsV1hOTzFZ?=
 =?utf-8?B?R0NqMmRLZ2R1eHJVbFIxeEpzZjJJS1FSRUVRUkVGSHE4NXJJZTdSR0dvOXVp?=
 =?utf-8?B?Zm84eFk1ck9EeEpNeFd2MmgxK0VOSS9VbGlpaFN6VHBYbTFFK0Y2UEx1RWxk?=
 =?utf-8?B?K204VWlVUUlrdkJ4UDNPak41anZ2b240MnBNbnpXTzZjWTFOSGhVV25jNDRP?=
 =?utf-8?B?RnArcXJYZHZ4Q3V5cGtJcDUybVc0eDdGUWRETjdKWHJqZUZNN1d1NGdZZ3hl?=
 =?utf-8?B?cy9XVmdNbUZNZ1cxeXVENjZNemJjamdTSlFja1B4WFVyWmREMXlmNjZjQjJ4?=
 =?utf-8?B?Q2tia2k4Q3gzeVRubEN5enRKV1BtdXhzNVZqWE85UDFZbzZPcWhuUW05RXd3?=
 =?utf-8?B?eW1wWStmaUZKNE5tTGI2MHQzeUxIMmxYanBJWWRWcWpkUUNVZDJDaDBtM3Vl?=
 =?utf-8?B?ZWFYTnduN0FsTVZ4TVJscFVLSHU3ZitMVmFycy8vcnloOHNXdVBxNWkvcjZI?=
 =?utf-8?B?WC82REYvZW16RUpuUUYrNWtiUGJwdzNLLy9lTzVEU29YN3NUZnN3bUVZYi9w?=
 =?utf-8?B?RTVwN0hQbmFoVW9XUkpvSTlnMzZlWVM4YmtiMVU2ejBJUlJyMGN6ZjhBa0VN?=
 =?utf-8?B?b3hvcktQeEVhYzJLR3VPU1dRK3dpVVV4OTZ5dE9VRUJjMHJPK0Z0bE01Wk5j?=
 =?utf-8?Q?n4+6v6tVQplnn?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 598cf07d-6c25-4808-e173-08d992dc2aaa
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 08:40:55.7067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwVOqtp6DBZnWt+8G+8ytaUoA+8Ch31WzGs9pZwuzM/qEgPLo1VV7I50sYTqWh8LiUqgvT5GNkNhE2ETjcxY9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------FA2C7BB85455DE572841162A
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit


On 18.10.21 20:55, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    660a92a59b9e usb: xhci: Enable runtime-pm by default on AM..
> git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
> console output: https://syzkaller.appspot.com/x/log.txt?x=1506ccf0b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5016916cdc0a4a84
> dashboard link: https://syzkaller.appspot.com/bug?extid=a6ec4dd9d38cb9261a77
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11308734b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f56f68b00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a6ec4dd9d38cb9261a77@syzkaller.appspotmail.com

#syz test   https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git c03fb16bafdf








--------------FA2C7BB85455DE572841162A
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-usbnet-sanity-check-for-maxpacket.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-usbnet-sanity-check-for-maxpacket.patch"

From a5270791d4480e9a6bc009c69a4454039aa160e7 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Tue, 19 Oct 2021 10:02:42 +0200
Subject: [PATCH] usbnet: sanity check for maxpacket

We cannot leave maxpacket at 0 because we divide by it.
Devices that give us a 0 there are unlikely to work, but let's
assume a 1, so we don't oops and a least try to operate.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
---
 drivers/net/usb/usbnet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 840c1c2ab16a..2bdc3e0c1579 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1788,6 +1788,9 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	if (!dev->rx_urb_size)
 		dev->rx_urb_size = dev->hard_mtu;
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
+	if (dev->maxpacket == 0)
+		/* that is a strange device */
+		dev->maxpacket = 1;
 
 	/* let userspace know we have a random address */
 	if (ether_addr_equal(net->dev_addr, node_id))
-- 
2.26.2




--------------FA2C7BB85455DE572841162A--

