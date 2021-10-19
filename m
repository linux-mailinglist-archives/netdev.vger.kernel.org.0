Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EF9433113
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbhJSIdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:33:15 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:23769 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231758AbhJSIdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1634632259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lMAP0g/LAe0u+PWhMYrqHCADAx+yD7TjdxtXXQy+E3g=;
        b=Cv6UC+KDdj212b/hyI3nIYIJmd8H9VfzwxQ/+v8liLVkAGvasLpf5meJ0ozIj9TR7dzE6N
        wjPikElW/XAzMVQmrTr4xCrSrF9O/a/56N7wPWXvvJX2ZJkWcqu9MFTOBggkCNChSWib6+
        bRCuXnU3pEfrr7bb2KIbLSih+hCQB2I=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2056.outbound.protection.outlook.com [104.47.12.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-24-vOx6rC8NMeuPAKv1kROAog-1; Tue, 19 Oct 2021 10:30:58 +0200
X-MC-Unique: vOx6rC8NMeuPAKv1kROAog-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aumxi68mKx8lzanSNiU6NsXVUyaVCZSAyuVpMCpnXVSWTnU3OkavOJyKn288E7e9+tUSPMQ7UdX+sC/hwn7SO5faPBbYqc57IMdYuCaDPEwu6pWQ6W8yGCWC7B8JsZCFHeZm22fEghkZFg1SNDyzPsfXrK+4SwuPjsO5/atJfgTQU7KlO27ZLhsJjdZrQTQLpt7Ko8EpmK+jHZ4TWXK/VyrBhfi3IPuxy+M7X0sMKTPc5L/t6FkOks3oSkADU79oUdBYlSxQccIQmB2ieSn8IBXpwpcIaJF0Ba15/GWVbzlFPEmYV4OSwUur9EJl72KVhb1/WxiTs2Jz87gmfJnrPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lMAP0g/LAe0u+PWhMYrqHCADAx+yD7TjdxtXXQy+E3g=;
 b=AozVgVjyFmyPlItic/6CeWS8YfchwAcfEj2KZUVBHllF3fkf2lTnatfojFWY+1RihmlbID/ddOAyRX0W0JZ2Xq/dvI+cloJIyI8FJjNRqQeN8z2l9L88mGdMfgVNH8X8qKcpR5lAhieUNQwEoe8BgI7T1q4ZMfjQMXQZHZ21/wI/wpzXwgs1c8n1VJ2zhKdb2u1CZf6f5jStww0sOQJND0zljJjwKN5mTwACsPood+XTVb6ONpwrI08stVj5sk18VUMIY57YztepdTGubURA4t+NsJGgy1tP9BCO1WFkUl3EE+Y4/0ilEup7PBLsm095jThMIGFJgNsbq5lpcmyxjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB6PR0401MB2598.eurprd04.prod.outlook.com (2603:10a6:4:39::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 08:30:57 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 08:30:56 +0000
Subject: Re: [syzbot] divide error in genelink_tx_fixup
To:     syzbot <syzbot+a6ec4dd9d38cb9261a77@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000809ecc05cea5165d@google.com>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <535d2ad0-1667-403a-9771-ad9c7b9748a8@suse.com>
Date:   Tue, 19 Oct 2021 10:30:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <000000000000809ecc05cea5165d@google.com>
Content-Type: multipart/mixed;
 boundary="------------A85C016ADBAF231019FF2A12"
Content-Language: en-US
X-ClientProxiedBy: AM6P193CA0140.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::45) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from linux.fritz.box (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by AM6P193CA0140.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Tue, 19 Oct 2021 08:30:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 999575bb-2f73-4c5c-b3b8-08d992dac5bb
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2598:
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2598A241F219F4E713B44A4CC7BD9@DB6PR0401MB2598.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +aMLYUt+CbvnCpS2ckuLfMDBCzYdrATRhVbp2yG2w6kTxCcnlDNxm77M+btAk8zeZjL6+Kt5aB1QzpP/yOGLiPWGkw67PvbLWQjYaFnKH+aARxt8nboHcvAz3JCyDmtDJgcnaWMosPHBw1kBE37N+UbPMySaWPvEp9uYD/mKNJh/TxAH7l3WImi4qbaMnYgsRdCJJImDc6Ti2UuHtR2olzn+bVI8SYwd4IIEGTzYFTWhzgpEIxr1oz/NXDTAsvq0XJ3yrXWeirLPES1ISuD4xJ7UYhrgdMaVTEoIaF6SID5sD0uwISGNmapjHyFuwfFr3kECfyMzuAKUrupGgMhl3idTrFvesYDxAiWe8aNOmw4IYAoaPJMIjM7yqNCQlgV0m6SfrfhEZ06g/EUwV9P4T0+2movlX85vFC110iyK7Ei7B8OWV2CSy/lM7S5sPO14J7iTxpBLRDDgcc9suDq8WukoTKxR7mghTt5qmT8XBM9grSij429XGLwbeZLUrKe6TF667DThM0Ka4ughOayBaNbv0ukIwhBs1fmjXXDqjH8v9EUJxduf27YdYNihJoYdjKNg5d1uTSlGUWrHTqV5xlHCmA546k4yZP10kd5tGbe4HAAUZu4jUpmJsvQVImp0TvQhg0xQ8R/8qMs/8QKwFp2wHyotsxBj6vzjfWpwT/C059eSOpoZU9KsHeB3Kx1wppwYDZLIsOHBtAlXa0WJzQ0xMYMhat1fAsnfgEYnf0DCBp4Exd5iiCtG6ZYSbfUnMs6TnTJHP94uHE9lUlycXhkoYcZFwtqXy6KXyYRa0QppJ2ErgSo9D5Qq1OFvW+A1+Noex2DeD7HMJOWsaG1KPQxJmCPQr+w5P4BG1jMpNsf+fwQStfIMLxJjgFgF+GWfkqRODGEhwZ/qfR21j+qUrIuHLAvi4XParpslre9TtTw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33964004)(966005)(31686004)(8936002)(316002)(53546011)(6506007)(66476007)(186003)(66556008)(2906002)(508600001)(2616005)(8676002)(5660300002)(6486002)(36756003)(6512007)(31696002)(235185007)(66946007)(86362001)(38100700002)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MW9jQ2ZVN2g4Nm9NL2t6dS9GMG12RVpaZTBIaXJTYjYrMVY3ZnNTQTA3UUg4?=
 =?utf-8?B?dmRqdWpFMmhnaW1JakkxQjFDSlh4S1lPTXpuK2tVUDNJRVFDSUhvVmlmZS8w?=
 =?utf-8?B?NTRzU0tGbzRwVldkNzFjazNzeDVHRjE4enJjenp0R1lyaDgwZGlMMDdDMmRU?=
 =?utf-8?B?S0lrUEhPUVYvTlBLVGsvc0JibzZ1Nzc5cHIyckFSOFhZcFBMUjlBZC9Rd2h5?=
 =?utf-8?B?U1RneHlYWnV0SkpscjN2eVJMVVF4OC9nbkxycTdTaDUvOTFFWHhqak9LemdY?=
 =?utf-8?B?cnhRSHN4VkZIb2NNdjdJVFZEekttT3kwWXlmZGI4b05NQ1JEU3RUcHpiT0Jl?=
 =?utf-8?B?YVR3eXdJdlM1SHdqQ2xDY0J5R2htcmdMZlZlSk5LZGxTb0dVNWZZWW9MYTVw?=
 =?utf-8?B?VVFSTTY5eGxURUJHY3duV2xzSnAweE1UN1pZRHJXYTNlc202ZCtaV1RkQnda?=
 =?utf-8?B?TzZwN1M5UVJ1YjFOdUJ6YXpCUDlubnBCYnd1M2RGV3hBeUc4bWc4MU9pVzBX?=
 =?utf-8?B?bk5ZL2wrby9VLzdXRnNmS0RtSmhTQXVNVE9uc2c3WnBaYzZmN09jNHFBSTV1?=
 =?utf-8?B?WWlaSVZaTU4vQXRGazlpRGt3TUw2dkcxQmpzNGkrc1F4bWRuZHRmWjdUV1U3?=
 =?utf-8?B?NnRQeVJ5QVRtUmVFSnA4M3dJcUtZOENwTElaS29weTVXakVBYW9oRTdxRlBY?=
 =?utf-8?B?Q1Y5K3JYRU0yaFp1S1VmZjlwblhQS0dMWXVabVBTK3FoWVhSbUY0SExjc0tJ?=
 =?utf-8?B?Ly90aDBCemJyT2VCK0VtOVhPSUtJbnAySTJYbktSTUVUTlBYa1Y1OVdDRktN?=
 =?utf-8?B?TGR5L0l4emxIUE43M0dyRGVjQkJBRzFlQSs4amJ6NTJDR0FrRFJhazZNN3Zp?=
 =?utf-8?B?dWxEK0RuSEgrM3pmcTBGUjRzMjVKc2EybTRZRzVwTitsY2t5NXRhNzcvSURM?=
 =?utf-8?B?c0M0OHdZd3ZaR2ZJa09Tc29oTm11SmNRWHJNTDgzbkc3WFhZOHNNTW5JOUxk?=
 =?utf-8?B?UWJBSGJYVWsyTTNHendVMnprdFVHeTFvdzZ5VUJmV21UcFdDaTcvT1J4SnRG?=
 =?utf-8?B?NTFVOVJBNDZKSG13Sm9xK20rUUFTUVFXU3gzbHF2dEVRSHNxeDBDeVFMZEUv?=
 =?utf-8?B?QTZJUE5aUnAwL0ltMzNHc1FDNHpHMmZTRXEycWtVSUw1cFhlZHNma3FUeFhm?=
 =?utf-8?B?eFNuWkE1L1JTNU1kMmYzaDFhWlozUGFKZ0MzdndpVUhwVlFaUGd6bnM3VVJC?=
 =?utf-8?B?N3dWb1hxY0YvK20zNU9lSlFXUG5jN3BQa2FtY2t0TE1qY0lYUXpaT0dwdW04?=
 =?utf-8?B?dFFyc0FnTG1zcWNwR2RtVEdKa0RadWtOU2cvZEUyWExYMVpKd3lzYWI0akph?=
 =?utf-8?B?T1ViOUtWQmNVVW5Vb3pKVE9rd041bUlnMHQ3L09hdEMvcHlaenE4T1NIODNE?=
 =?utf-8?B?Vk9FZ1hNOVdOUEtVWU0xWmgxNDJZa1dKWmR5N2VVd3Q0UE95eFlaOG5sbUtp?=
 =?utf-8?B?RS90Z0RnZU1ieFhtbkZYVzJSaFhIa3NZK0srT010ajhOTGlQSnF6Q2k2bDF6?=
 =?utf-8?B?VzVxTW91dU1WTVpqOG1kZmF2S0hDQVlyaWJmV0tpOXZrNms5UmxsdmFtVFVB?=
 =?utf-8?B?R2w3NncxT1ovNmgwV1NyR3ltb0NpTlltaUIveGphQ1prVWxVdFZIZUl2YXJh?=
 =?utf-8?B?cHJhQmN1aWRqa2wwLytOOFdoc25iTWxXUnlkcTJObnBxSDk2aEtTdFJGUDhh?=
 =?utf-8?B?TzByQ2o0TFlxUis5OEZNWjhoTG8wdjhoVHJLWjIxRlRqdmRIR0RZWjFXektl?=
 =?utf-8?B?b3pzS3FtZkpaWUhJdFVsZysrL2diemg4TUt2WUdjdDU3OWtZbGFPeEZiNmhB?=
 =?utf-8?Q?LcJ0rOE3khaLr?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 999575bb-2f73-4c5c-b3b8-08d992dac5bb
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 08:30:56.9123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: abbRp0yeCwVS7dVhccMbvDi7pvvWhpsfQr7XQeD/s4oo7j3MHcZ3yRu4eqQ0GA5k0z6LQGmQz8SUEJEMIZDO+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2598
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------A85C016ADBAF231019FF2A12
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit


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

#syz test:https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git c03fb16bafdf



--------------A85C016ADBAF231019FF2A12
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


--------------A85C016ADBAF231019FF2A12--

