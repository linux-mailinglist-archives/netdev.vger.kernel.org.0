Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF7143330E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbhJSKFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:05:17 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:30821 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235105AbhJSKFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 06:05:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1634637777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ElthTP5BMM6lKTCwTgMfl4fQSvAaZo2dcCkcuX0dcBU=;
        b=hcO8GQLfZKfFvOf+6eI4lph6s2kT79tGRsmHdCRpLYV3e4jd+WIAIk14oaMnvEAEOhZpTD
        J7UXSruZwPZp5VbRNPddbOjmBHTwD9/Yli311WnOCKwdmYGxdTYifsjOlZjprxwLa89IZU
        Dt5SBWgn+wT6PSrimjWINYk6wYIs888=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2104.outbound.protection.outlook.com [104.47.18.104])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-36-KI3x4IHBM3qrFQvL0ZZO9g-1; Tue, 19 Oct 2021 12:02:56 +0200
X-MC-Unique: KI3x4IHBM3qrFQvL0ZZO9g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UupALiiTWdBIss/t2NIzbFQqA0RyvJPE1cqYvRcaoFw04Jno5wY5qyt1LsGdmkvfLZ6pP4UXK8K404TPeo6gX8D8wIQeS6lBMJmYWHcq7nhIFar8LjRs6qWXX+mj+693LdB7u89GTwdL1tOIBKe5J5W1fZFnwne0fHKpUNqMGGc8yMQQc93wqLKFf/8i+yteoI41W/53vVqWvwmHEASjrAmcHhNJlOZA3QqCQ4Q7/wj/JefGJ2fTaosBJaM77VF5mhVjfsOsz1FjGljtIGgEf7/sV2gZxHt8cAsWg3NrD3mNCjyB6FtTUDGPdfdj76U67u2RkGtmuFwPRWF87nlRyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElthTP5BMM6lKTCwTgMfl4fQSvAaZo2dcCkcuX0dcBU=;
 b=IYVqjJA5em932ZLKPRoeI6QrdPA3TZygRznM5jFLbHofuclGS3cB6qM/ucJbRINnhpnBu2BAvxusPwFbnpbcS0YjL/uM6+NzYKfipuPZZvGpIZqyZsIeNSz3mDxls2/wmnNcpIDHTccB9LYMFEZbIFfSyWS1uyb2yCtlXMyHDSxGhuGe/XUHhB3yuaajJnINpP1lU7+bvCw+BPfU0hg/ygRdaWlx6m4sDXBEIjwgQcoL4Fb6k45Z+yR71aD32dfO4D9o0Fc/IcGQBYjiNWcgTf3yFMXCOa2Y7JJahNO//8cicgINhKptK21lHyGVMKvT8iYuYMql+meXoq4GNUzCwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB8PR04MB6764.eurprd04.prod.outlook.com (2603:10a6:10:10d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 10:02:54 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 10:02:54 +0000
From:   Oliver Neukum <oneukum@suse.com>
Subject: Re: [syzbot] divide error in genelink_tx_fixup
To:     syzbot <syzbot+a6ec4dd9d38cb9261a77@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000809ecc05cea5165d@google.com>
Message-ID: <28d9989c-4a80-daf7-d0e0-ae8e56b6e4d9@suse.com>
Date:   Tue, 19 Oct 2021 12:02:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <000000000000809ecc05cea5165d@google.com>
Content-Type: multipart/mixed;
 boundary="------------39FC8B90E38B602D5E2C221F"
Content-Language: en-US
X-ClientProxiedBy: AM5PR1001CA0052.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::29) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from linux.fritz.box (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by AM5PR1001CA0052.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:02:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb9d0a46-1fb7-4b3c-4cdc-08d992e79e3c
X-MS-TrafficTypeDiagnostic: DB8PR04MB6764:
X-Microsoft-Antispam-PRVS: <DB8PR04MB67644E0EEBF650B267AC81FEC7BD9@DB8PR04MB6764.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:254;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DjfuKPH6+HqqzXGpnGSytI+0fKOIBrXktWOd940PKXxXrCBqQogPTXaWWBqM389mxhtD7xsiYA99qNQl4tftA5BDYR6H0VQYfeSux1ZirqA6NPQjmn3Lz1Wn7+o+LnEDKbtcK0rld0tqTUNffMiqpk/740D8g1qwMy7gMhxBnToOoxlB5hZYpFVpQo7g7G7VE29mjVXP8XVQvzuQ736f96Z6lcWd/YuW7UCsT5pKuC2UXQcSVOqXkkhzFeG8ZUFao2zc+3YyzSGN10yXoZuIi7+cDVz0Yk+mtSmtAQkVD+fR4x6Ggfz5O5OIUE+9KXEViHiW2QjwTsuJTGmmBvDsY5O3UL3GKbcQzjpNqP5kIu1HxXdVzs+RwZL2dXchdLujh+PXl0ZCxw6cD017LWfpjPU9QhF5niXpW+/5y3PddQ8v3II8vhW34Ij8I7gsMp7JrnnvSiO5F9uq4p+IuzZrDJ2DvEoMnL+pz9jhWFdHcDqKgL3pC1k/dcAKKCzuZnC3R2T0ZPFoOBNKuN9rdvRLdnmWR5zdDRASdstn8OiOx3lLQhTznrIpK6+3m5BOfyDsDDftQYbfZze9rXjALIcr3y2SnGJzjQk+jj5UMef3k/D8nszT7yTqAHtF6QQLPO8+WTVxorz9cBiL9eO11mjocJMrbhwg7TyEjuw/Hiz3WFmsRpwq02VGOfOiLuPOCKnDF34rfLUKCUazXYPXh6ExJwddikBL8An8TwpZPlVn3fD1+jmzpdVMPxSYZiXkpHgY/Wqes3/rL6sT4ycdVKX/aT9W6EWisb824rD1RKu+2efA0iiIkuFVdsl+dtdQEZpfeicKG1OThEZVVxs6vOQOADxo2K1BlNVwqD1A6o1nyO48dcoRASCN8gqAjVkCB5oADbKFzumFsR2y1QSnXsinuourtRS9xCb9zg9p0/SCIUk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33964004)(31686004)(186003)(66946007)(6486002)(66476007)(66556008)(31696002)(8936002)(38100700002)(6512007)(966005)(53546011)(2616005)(235185007)(86362001)(8676002)(508600001)(2906002)(36756003)(5660300002)(316002)(6506007)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzMzQWh3T1V1M2RWM285QjBWSXhUcW5GMGhhRVhlUFBWdnJWWDFJSDAxYWFq?=
 =?utf-8?B?b0xkOExJUEF4OTBtNm9tZVNPNnpJdVFtTW9DdndjWmczQTF3citPSGtVajM1?=
 =?utf-8?B?RlpSTHR3dnM0TDZVQytuaEE4YWd0d1Z5eDhhZjF0a282MGJiSFpBbFVYUmZh?=
 =?utf-8?B?bGFsdTVRQ3YwOWNML3BOajZQWU56YncvV0plb3NmWVVaZ1RpSk4wZTJnc2Jm?=
 =?utf-8?B?Ui9XQ3VOaWhNcUpzNEFhYVhSR0JXYW1HalBwNDRlaWhnQjl4Y0xoV3VVWk03?=
 =?utf-8?B?dmV5ejZQSXZQVzVLMTZLcWQvRTRDNjZ0bTAxMGRIZVJQQnMwTG8rT2VEUDVy?=
 =?utf-8?B?ODF2RGZWNHBtRmsyK3p2a0lLaEtMUk52ZmtzNnRiaitlTktRVGhWd21Ga0xk?=
 =?utf-8?B?MCtkbU5HaUFicURvMmxVVFRIRytTY3RZM1NpaWtuMFFSNDA0LzV0ZnYzbkwv?=
 =?utf-8?B?OC9YTzRpMHdSSVY3MFl1bG9YQVRKbm1YSFYvVWRPaEhDbjk4dXNRQTZIeHV2?=
 =?utf-8?B?dlVjL1FGVi9WbW9HeXpRUlNzUXlrbnZ4RnJZNW9MMDIxZkdKVjJxWFFCTlg0?=
 =?utf-8?B?ZitSN2Erd21VbWJ1R2I0SjhtWnlxL2ZPUjJUdnFhVm5ZZnJFRjhmQ29VeEI0?=
 =?utf-8?B?a29WczJLV3lSdGdmaUJPOFY0eTVpYXZTeFpiUm1kOUs5aUlNaXN2SllLcVVz?=
 =?utf-8?B?M1RxTHRvQWhTQmpmK3Z4R0sxV0RGUHRTTk5yOHYrS0J3Z0R1cUlwRkp1eWt5?=
 =?utf-8?B?Y0k2dWcvQTBzak14NTllR0ZFWm8vWmpOSDEyU1VxM1k5cnZ5RFJqQUFZRTF0?=
 =?utf-8?B?b0RxQ2lqcFN6bEN6YlhIS3ZQWFlCRkxjL2l4N1BjcW5QN0gzcnZEM0JPaE1v?=
 =?utf-8?B?MUdyeGZSTk9helF4bEFJVXV2c1NwbmZyYTVJQjk4SmNPZjVtdURDekNLdDdy?=
 =?utf-8?B?UTdFUDBaaldoeGR1OTZIWndLRmxVVk5mclZqSklQckNHTk9OWkJQQVdCVkR1?=
 =?utf-8?B?em5KVDdIdGVPMkZSQ0NyZnpESFpjNFlKbXlqcVZ0WHVVa2JoV2lCT3REa1My?=
 =?utf-8?B?OE5wcDkxdmVqK3BRNVVJczBFMUFzVnhnWlhQRUZRRTB3ZFA0Q2FKNVY1ZVpt?=
 =?utf-8?B?NVg4Nk01WEJGdDhKYVorQ00vUnBSd3RxRmxJSDBHSVdjS21MRjZLQm9KbVZ5?=
 =?utf-8?B?K1FEWTY1ZVFaTGg0OFJVTlN1a2c5SnNCTjlBbHRCcHA0djVKV3Q3VnlLeTh3?=
 =?utf-8?B?ZGptYzY2VmRGc0VFaUtTcThCb1ZUTENLeVhGajJQWWhqcHZuWkNjemtMZ1lV?=
 =?utf-8?B?bndmRVcxYWtpQkZOZnNBbkRQUkFjUkdVU3FIRzZoLytlaXdyTS92Nk5TYndI?=
 =?utf-8?B?TWhVaE9KNTk0bVBPQ0FaWTRKRkRWT0xrckl4Vmw5Tm1nWExpcnl4cHhtRWpK?=
 =?utf-8?B?eCtYTHdFQzJadTkwTmVwN25GWlJBeWk4Ly9NZWM0NU5FSTBXZTNJMEM5RnF4?=
 =?utf-8?B?cG1SSXF3c0RnaTBwR1lYZXZJeTZqbGw5cGdxUkw4Tm0wc2ZuT3JjbE1uNUgz?=
 =?utf-8?B?MzcyT2ZNMzBHQXljUHNwN2xHR04rS2FDL28reVpVSXh1c2dTUjNlK3AvZGRw?=
 =?utf-8?B?STFqNVlzMEtWazRQenRzdDVQclVVVWhMOVkvQ3QvOVk3TEQ0K1VINU54bTRH?=
 =?utf-8?B?R3MzZFN4U25ZNVNWMyt5SDdkZXRVVDR1TENFdmNkN0twMUhIUWRTMURuWjJY?=
 =?utf-8?B?MkpOOHZYTTRLajl4NUc3MTdpbnZMK0laSXM2dWpTN1lPNnlPd040S0V0dnpR?=
 =?utf-8?B?TWxoYTdLUHJEQWpCeFhxU1hmZVh3bElCdXFSMWRRMG5XeFVuNDFDREh2dVpE?=
 =?utf-8?Q?LSAyQcIHCuCPz?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb9d0a46-1fb7-4b3c-4cdc-08d992e79e3c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:02:54.1267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nR7TB+4XfTIkD+1yo3Uz4pVPvsY70ZC6ghiDjWvkeqaT0p0BilGr2BHwgTK0P9xf4l/UDJqu5P5qqM04Hrg4AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6764
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------39FC8B90E38B602D5E2C221F
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

#syz test https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
c03fb16bafdf








--------------39FC8B90E38B602D5E2C221F
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-usbnet-sanity-check-for-maxpacket.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-usbnet-sanity-check-for-maxpacket.patch"

From 1bf4920e0c85fd0fd49f95e2b41e104c77a95de7 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Tue, 19 Oct 2021 10:02:42 +0200
Subject: [PATCH] usbnet: sanity check for maxpacket

maxpacket of 0 makes no sense and oopdses as we need to divide
by it. Give up.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
---
 drivers/net/usb/usbnet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 840c1c2ab16a..396f5e677bf0 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1788,6 +1788,9 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	if (!dev->rx_urb_size)
 		dev->rx_urb_size = dev->hard_mtu;
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
+	if (dev->maxpacket == 0)
+		/* that is a broken device */
+		goto out4;
 
 	/* let userspace know we have a random address */
 	if (ether_addr_equal(net->dev_addr, node_id))
-- 
2.26.2


--------------39FC8B90E38B602D5E2C221F--

