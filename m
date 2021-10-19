Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533A443312D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbhJSIjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:39:33 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:57068 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhJSIjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:39:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1634632638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wloYTZ9BYjCMK0ZZ3CXmBx0X5GA1po9Gm7GPgAi43xg=;
        b=ZnPNIwwg2Y69lRAGGmuUFcd0wfLaa47YKPl3XLOvGnFprKETxj25/WlfhjgZboYWUXHDPy
        FSjYWQlzxeK3/9P6Klerx5NcEddg3QjbBmmfMafJPXis6YAEHlvEiGrcRwfHaP9rzq2uOi
        hY8m6wae6WfO6xARMbkcj7kf0gQTGBo=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2051.outbound.protection.outlook.com [104.47.14.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-37-Sbap5vZSM_CMxFkHAr_Bmw-1; Tue, 19 Oct 2021 10:37:17 +0200
X-MC-Unique: Sbap5vZSM_CMxFkHAr_Bmw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2tx29WdU2puPZtoHkX4/Ccs2GD3OPKuyWB9XcJDQzpZe/7wX56t8VoW754kW7cWP26ltB03vNtNFlnLwbTi660C5M6/XpmACNpiQUMbPtWlcGNuXS7/RDFsrivTrvmS/2shfvTfbbN0qDCcadA2F9ds+KBxu9+Ghg6ePiWABRlP62IipdBu1fWaS5rtmFwxO5WUHPPt1y2leXC5n9kXhSN4RSCazwzaR1QHo5Hz3TplqoRpxvE7vNBod6WO+pxbPNY2ii4Z9I6zVazagHlOMAqPKcu2sGQ+udYe6lmyc8erqQ28POIv5c1JtgQp/qg7Bsj5sBAKVd0F5EWGW4eQYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wloYTZ9BYjCMK0ZZ3CXmBx0X5GA1po9Gm7GPgAi43xg=;
 b=OIS9w/zo+sEqSxtVf+jDLa2Tt5RQF7FQ6ZZrLSpNMuxVoruix/+dZI8OQ+SrPmqyC3Waj6xuhQeoDl9cwdUvp9jyG8HMLqoWwt/vFfO7C9smAhm3TFWQcPF+7oXUyB6bBlrPTClrAqY/FI3nPzdpXaNjkS8fkGwrmZhBDutUoHkJiZarBzR0dTwNI5xqzI8wKipXjsVVDeuSERSkdxB/qkH482ZB+rKgZfz2RSIn41iouE5dCkYa5QWABoAlHisNERk6nEPFlefiUwZj52YdVpR7kmsfFve0dyoxNEXNW19Uo3J3sOXKn6vPwTqJGVof1m2Og+6GGTJOlKtJEV9LUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB6PR0401MB2647.eurprd04.prod.outlook.com (2603:10a6:4:39::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 08:37:16 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 08:37:15 +0000
From:   Oliver Neukum <oneukum@suse.com>
Subject: Re: [syzbot] divide error in genelink_tx_fixup
To:     syzbot <syzbot+a6ec4dd9d38cb9261a77@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000809ecc05cea5165d@google.com>
Message-ID: <370f6719-b2db-20f8-9a3d-0e1927931b06@suse.com>
Date:   Tue, 19 Oct 2021 10:37:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <000000000000809ecc05cea5165d@google.com>
Content-Type: multipart/mixed;
 boundary="------------3BDE35EAA337CDA1DB4980CE"
Content-Language: en-US
X-ClientProxiedBy: FR0P281CA0037.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::19) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from linux.fritz.box (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by FR0P281CA0037.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:48::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.13 via Frontend Transport; Tue, 19 Oct 2021 08:37:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dd3adfa-3070-4a5f-1b77-08d992dba79e
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2647:
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2647AE6021F7E43B26942A6AC7BD9@DB6PR0401MB2647.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +xUjU+AwBC671gfR/tx8D+jRhtl4ZoW6YVlyjBsPxgM7wcZGdBINmIcuisDod9r56HT96IHHiHcu6JYPwYx+ISku/NEEe/cKwT61nBOZ/O54U3d5FRh8UtcpyvUPkbUwYu3yzJUBxrW15qZmJbSqDQkbsYE6EfhK+HNREQuczn1cIFdFzMfK+w4h7GEgN2TkVCxn7nmbyZf5igOIzTy7I6hdGYwZslghNlbUsMFcxlG3fObdGgtdUwzbhGy3h9j+uSaiPBADLs+iJdO9ot6tSETsWdj6nHOSrkq2BCpNqvVYJDGr5iXLqev5KvtrcErY9/O4XwHho3nnR44W3Q0JqeCxPhVlo7tPE0KOo6rVtk/EwmffBtBcGl9WVWvzmB2ZDH0SFphJps2FkUmdTaHgYF8AQDJ5RltlD3+eY3UySGvJOQzUxG2MRP9M/3YbAkHSax7Wcv5jQ1EivmVUDIs66tzLAgoudZJyR98nWdg6rkiRwTkElXVLK8unYvjhI7Q0mSwFq7WPhVo7AQiNYSFERXIdBk9rx9cUXquoHksqCtLvXS3VHFXgcmfTnAKLQ5ULBa7CYgcROBZPslLzlbYTtxXuUtfWRoXHCc8T1D5jV/D8qSc7CT11vo4CBfaZHl9iXrjZCE+3kZBOVseaXWpxwKpMA3leq60uukK4Rw1Do1tBIvuoqpJfdpuhRIdgAU+wiEF+8RZWYvSmTLQ/JRoN3RC9VwpoVprO81BIFP/9UABxzlfw9O60+VzL0n4TCkk78BhI8zGL547VPy/vtmtJIzsDWBfYIB8Gb3YHsy5HisDT7/1gqQYSsxRXVwrQ9ZSno8KSK9mP+kfAp6ChSLhtJo9gCwTJmLGmK69ZB25Z36Sd/26rVGUO++gF9zGHd0nbybcri4kZ10e6zfKRaVOKzH8iKeIFvvkFLKELhUxOqyw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(36756003)(235185007)(2906002)(186003)(5660300002)(53546011)(31686004)(6512007)(508600001)(966005)(66556008)(6486002)(8676002)(316002)(33964004)(2616005)(66476007)(6506007)(31696002)(66946007)(86362001)(8936002)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGlmbVQyQTQxaUluY3JYYXNWeW9UUVMzb01QU21EdlZiR21lZEN2d2hwQWxY?=
 =?utf-8?B?VHpYMG1RTkFTb0grVmdDWjNrSTZzbTJoVUE4VHJDY1gwSFhjU210YUpmR3lS?=
 =?utf-8?B?VWpZblNCRXcwaEpmSkVnOFRTUDJxbVFHVVZKb2JmbTJwdE9saW4xeTBocFJW?=
 =?utf-8?B?bVZ2UlEyOHBnUCtyMmNGSGhNOEM0WHdub1RQMnBsS1pwaG9YQXdzb0huSEps?=
 =?utf-8?B?Nmc4RVhUZ1VWL3JvNjB5RzdZKzQ5SHVWZDlmbCsxMHBvQmM0Tk04V0lnSDZD?=
 =?utf-8?B?Q3BYemVzMndxd1JOSVNxdld1WTdGUEJENDZyZTkyNmZSWXdqYmszRVlrVFhK?=
 =?utf-8?B?SkZqWUM4OE5hTVNSdmYyWGErRWZiejBpMUpZZE9nQTUyWktKRUo2WEUrdWxS?=
 =?utf-8?B?UXJJODBJaFFKbE9vVFJDSDBnam5hcU1mTFhoVWVZM3VkdzI3cTg0VDVMT2VV?=
 =?utf-8?B?ZjhYaXlvODJXMStPV0l5cU96SkJOeHFySnlmcjdlSEY3WGdTZDE2YUpncVNL?=
 =?utf-8?B?MHcwZWIyTjdWWFlTN1lnV05uaFZvRC9OekVJUWlycy9CR0hUK1BDRTNZMlBI?=
 =?utf-8?B?ZVVIdGlBLzBtdThmNG1HTGRBWFArdVR0VFUzZkhtbndqZFFMZnpaMWhFQlM5?=
 =?utf-8?B?V0RXM2dRSlFvUlI5Q1ZCc3BDb3N0eXBrWFk2aUJ4OVczNWtjWUNQZEtkYXF4?=
 =?utf-8?B?eHZKS2krYUNMT1RYOW5QVFM2SndVMWxDbHFFaTgxUVBuVnpWMlB4bEJKK2Va?=
 =?utf-8?B?bXVjQWd3cURsUXYyNzE3bGs5L0RGb2NtS1p6V2xCMXhWNVZqeTlNTXpsU2hm?=
 =?utf-8?B?aVVMNW9maFFINjBISVFVdDdJRCt6VjE4WFJDNFVXNlk0QTR1VkJhdnhEOE9Q?=
 =?utf-8?B?Q3hTTDFyU3FpWVF0aEJwZVREYlk2eTRQR2tIRjB4eU82Q0c2T2F3Rms4MFVW?=
 =?utf-8?B?U0t6M3BtZGhrZS9SUWNRcDZ3QWlXT0duaDB4RmZQUGpyQU1jSTR3VDRKazNG?=
 =?utf-8?B?cnl2bmFYYVBmMXF5YkZQMWYzRDgzRzJQNEtPK2FWWTJOeURlY2xwMkt5U0h0?=
 =?utf-8?B?c0hBRVRwa0FOcWE0a0NqRzVJUG0rUS8zajVFVDBPaWhwb05yNjVSc1A4SFpp?=
 =?utf-8?B?OVd6MFRYVktwNE16U0RoTXBHeDVkVXVkdFp6aEtXdGxKcFNFd3MvcDE0aTcr?=
 =?utf-8?B?dDB4Qk1nOUhkNlFvQXZKN25SdGsvY0pUaUtYMGRVaU5RR0tFeHpjcTNiU3BV?=
 =?utf-8?B?MHR4ckM2ekJiRWxxM205YlVDc3FWZmlGYTN5TzE3cHJ3RzhqUEVBaTJ3K0ND?=
 =?utf-8?B?Q0xHQjFOY2NyY0h6bnhBdWQ4WjNTdER3ZlhxUml2MFJiam9uZWFvc0VCa0li?=
 =?utf-8?B?V2FPaVl1N0srQlh4U2pUVmJMcXFTOCtYRFJ0TTVaaUZHL3hJb0F1bXBVSk5u?=
 =?utf-8?B?Ty9PM0pkWkJaRDNhejNXRkxxTjJ2Rk5RZmo1cVpyeVd4djczeEJaYkN5WjJs?=
 =?utf-8?B?VE94Y0FWUGlkdExXb3UyZTFZclYxSVVLcktWLzZqalZ5aGVQVzliSmx6NUhR?=
 =?utf-8?B?RzlqV2ZxTzE2UEd3bFZ3V1h3WFlSSU5ZdU9nWVVYdVdlbk1FazJmUHFYY0Vh?=
 =?utf-8?B?NGdsTGhsdDlmdVpNc3hUYjAwRERTc1l0VG1jK09LbExwVlRSWStscnVlSVpF?=
 =?utf-8?B?VEdzY0FMNDVkbzE3V0ZxRUVMdXlDeGFVZ2hWSkhYeEhUNkZYQVRQRjYxTWlx?=
 =?utf-8?B?cjE5RHNtMjR0b2NyMTNDWVNudGdJekJLZTIzUHFnc2ZPOEZSVVRzNFlVczNQ?=
 =?utf-8?B?ZEovcVhHbXFVK0NrWVRxS2RGc2puM2J5Nk5TeHBqL0c5cjBVMWd0Q2VPTUNU?=
 =?utf-8?Q?bDu3Z+W/IqdDF?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dd3adfa-3070-4a5f-1b77-08d992dba79e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 08:37:15.8684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FnqVl9TkjroFCCW946TVXBftk1rwqMW8O4KIrKJGJW95BZjU7mGzB0s25v5ogzli2ZU7ttSPUGwXvXMVkoxLBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2647
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------3BDE35EAA337CDA1DB4980CE
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

#syz test  
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git c03fb16bafdf





--------------3BDE35EAA337CDA1DB4980CE
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



--------------3BDE35EAA337CDA1DB4980CE--

