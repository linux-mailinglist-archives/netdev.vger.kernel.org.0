Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8606654AEC6
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356135AbiFNKs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240905AbiFNKsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:48:30 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80049.outbound.protection.outlook.com [40.107.8.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765B722BC4;
        Tue, 14 Jun 2022 03:48:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVOeOTfg3EesWkoxCxjIxXVfA9LeYE7DlvmnBcST5lmLuetp1q2b+1DLzrVrWd9A7cwaXzhFJ6w8pEddpHE6NMqGDpzsw0+sTjA3R08wpoaC8tg2viV1noCHdjl3HAy7vI0U8SqA7nkYT3FARxBZvevqYaGhn7BUZ+Oy8ay0L3TGrJjy62lnwtXKg7KRXwPybF91iYyqXdgJI1QNzjzU3gxQQObbF0nOeojV+dkopnOsBOoTB/RvQUC81xn3RKwT7xPcekt/dbZ1R9mvyMb8eW/7ov3TifAwMDV0HHrJbLa8A2LJpdLttJpKnwGX7CVwjXmDvVAyMtXb5Z82nTNd8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eE2Pptoi1l+r71A/2Gr0vPGX9JZ9gme6zm84nLJ/J3w=;
 b=OT1yQ2L+5+u4HcXqjLpOYE6bpRbwX9I2AH9R3omPeU35wuMM1R+hhWUXf3xyWeoBSvrlbJqX7aYIb8ZfbQ/svklgeEXVwv+ykRkxABogS75L8WaZMeOWF1fs/gJ9GIRK1bLvhsACebBE+QrBwHWYriRpPpQO0vbNzp0lBdRvKXN8c+7Fxa9g9hQ/UIeT27nLnGqC2No6EyhXHwlvDiLc+UILo2BIcUCuDc8lIlW57RzJfRQJN0sPMUoAgNk+BKjNLx4bbFwJHkQRpVIcqzcSWpoLplw+ccDLGnO0XM/sWIJ7Wxyg2a9YLnsz5qNL4KJiJXp6FzG63lj3C7eN0Oc3bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eE2Pptoi1l+r71A/2Gr0vPGX9JZ9gme6zm84nLJ/J3w=;
 b=fsUKJHX4snlis5Ah5vzgdCI2uidWZfs3Er4y6vsdi85eyA8tf8ZBhaFAm2JC9Bcs9gV4TzbpjI25WYpLGUzAYJRkzf1kRBDNZiVSTJZ3fNU+lWwx4lh6mfyskSH2FFwZ+BC6AYvQZpwy/pIW9tDQzJLPp24XWLyd49Xa3Gh0ZIm9RiJnSTK3AUnKBu1TQRderO5sbdnfPYf5svnZPykWEu8KFutRE1DPTygP0bF14VnRc72uNFyICHaEP3YPpugxuVxotaBoYFXcJSurYBpAT02ISIVCoUM6ms59s5oUAkRSjWOrNZ0mro7BHLJkwMIpzNmp0c9mjhCx7iOdGH9Kmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR0401MB2515.eurprd04.prod.outlook.com
 (2603:10a6:203:36::19) by VI1PR0401MB2366.eurprd04.prod.outlook.com
 (2603:10a6:800:2b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.22; Tue, 14 Jun
 2022 10:48:25 +0000
Received: from AM5PR0401MB2515.eurprd04.prod.outlook.com
 ([fe80::1dcc:ddb9:5198:5891]) by AM5PR0401MB2515.eurprd04.prod.outlook.com
 ([fe80::1dcc:ddb9:5198:5891%6]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 10:48:25 +0000
Message-ID: <60a08f2c-6475-4bb2-1cc8-1935a5ddeb79@suse.com>
Date:   Tue, 14 Jun 2022 12:48:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net] sierra_net: Fix use-after-free on unbind
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
References: <80e88f61ca68c36ebce5d17dfcaa8e956e19fb2f.1655196227.git.lukas@wunner.de>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <80e88f61ca68c36ebce5d17dfcaa8e956e19fb2f.1655196227.git.lukas@wunner.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P191CA0015.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8b::28) To AM5PR0401MB2515.eurprd04.prod.outlook.com
 (2603:10a6:203:36::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e63d50c8-be18-4e81-a6e7-08da4df3685c
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2366:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2366C0D2DD81EEFBAEBF6ACEC7AA9@VI1PR0401MB2366.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1plKnTAY0hTktjraX8i2FUQrFuRRklipObpGTDn38gkwV7zQ4T+T9LisjsH6k6lYopdNRKDjzV2pVUfTABBSWZ/BtMurah+JoYl/aORIxPFU/2VNHzU9nDM507PfwSG20/Ea4BDfRMwlT2pFWuK47tEFqkMGeShB6YMGTxXl0hQh30Otg3gOCZlCFtcF/frypyaD0uvYxD+goOvV9BykRLFYIcqNLS57kuQ5i8zcrO30wGWkUWYgK3kkmLDJFALOsb0OYUv58XZ1EZgr3F7IS0nU+wJQJ15qHTsEhedHsZPJS0XKZrp/sEHYUPUVIFiSYXs+/oo+fHe1onmVE6J+aS3aMu7ff5rZQd8hhFIM7jD4q2mP1Ef1XQKgEQmbCS+oelOtZYDCLSIS4mHLJAEa4RqBOW110uuOoCoe1eMOVPio2qoOnqhBnh8o17H7exhyQcJ4hu8lfW6owzXUCqgLpfmwFLamqeOoGHsP7Q6DpQYziUOblneOw02yKtzmxFKdVkJEaS0gKojlTbLmwzhAXzGxdoajAqnnhDO4k2j5lIBjf7YoBu65HQ/1Z8tAdGUfK41kUwiVkQb6u+U24+5JtIYM8VrsP8yNL/4xIHTqNP41SIvJcr9IvQsHuPd/gNrCemvE8qv9fuDkwd0NpJ9yRMTcNAy4z6/NAlPWJC2Y3llTN7h5oZwqSRGV+TP7AWhiIIDomrZuRFmpzS43lQ8Un+LF6QzWFTi6GkGL+uOgZpM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR0401MB2515.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(66556008)(66946007)(31686004)(36756003)(4326008)(186003)(4744005)(6512007)(8936002)(5660300002)(66476007)(8676002)(31696002)(2616005)(86362001)(316002)(53546011)(6506007)(38100700002)(110136005)(508600001)(2906002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3VVWmdEZ2FqY1J3Z001N09Qc1BzRFFGZWRnZG51RjVxSU9qUndXZzJXL1VL?=
 =?utf-8?B?MFM2Yit6b01yNXdaZGhvcnVuVkdHZDJyczhjcDAzNmhtQld0RUY4eXFkMnRN?=
 =?utf-8?B?T1IxdHN4dDZlRElRSHJ0QVF2UVhidTMxa3VWeGlzY1RESEJoNWNMdjl5djMv?=
 =?utf-8?B?TnNiZDdiZU9manUxb2p5Sk56KzBCTGRGK3NRMFBtak8vZU9kMzBYd0k3TFor?=
 =?utf-8?B?Y0ttd05qN1lSZDZiVTI3ellMMmlMV1F1WTdrRUdHZmJxRjR4OExtNDdQZTlh?=
 =?utf-8?B?bWVrcWNHSnh5dUVXWXhMZko4UVRzbzhuL1RXUU9OOHUydE9pbHZ1Qndubmp5?=
 =?utf-8?B?M09CUDhlYWMrNUVsY2FTR2ROL3dsWHdrVGZZK1hBVzdWc3NCS0RoUkE2RTBQ?=
 =?utf-8?B?b0F0dkFQUzdsbWU4Y2s0NmZpOVEzNU1LWmlkTU85Q0IzNkhzblBpdXVuMUN2?=
 =?utf-8?B?TnRrNnJ4ZHJYSTlKSkxqYlp3dFdudUMwM0p3S1VjUkhwWS9DNFFOL004ZzZl?=
 =?utf-8?B?VG5xU0t3dWtwT1JLTlB6b3ZPdkE4Sk9xWTFsQXgyQXVuVE1tQWtRVzA3QUtR?=
 =?utf-8?B?T2ZjaUJMNHpEYy80RUUwdVFzbzY0dGZpMTBNdjRyY3lQYUUvV01JMm1DVXJ0?=
 =?utf-8?B?eHFDOFBVVzBBd1Z6T3FBMzdabGRjR3NLQVhFQ2dBa3VBV1BOSnZGbkVtK2Ny?=
 =?utf-8?B?WmttRkRTQzIzSVBscXdDOEEwdEs0SzNNNTFVTnFXQ3lBM3MycS9CZkM3T1da?=
 =?utf-8?B?Y1I4Q3RHTnZqaUdWaGo0cklmSEw2ckhKWGFHNlhuYk9FZjdaaGNPTVN5dVNX?=
 =?utf-8?B?dXQ2WHhNa0lncTBRcEdaTEFjTENwY2tZb0Rwd051VkM2cVZDMXppQzNhSVFU?=
 =?utf-8?B?MndieDlydFhzcEVMbk9odVl5WkJ5ZFdBVnVsencxV2NFdE5hWEdxMXpXNytR?=
 =?utf-8?B?eG0rd1VoYnJ1WThUZTNaNUpzMHpIMGpxejkyZEx6M0VZL0VCOEtid05uKzlI?=
 =?utf-8?B?UGVlYlJ5Zi91L0pnRkpHOUF2QWl3OEs1UWJ1cGtiMUIrcGdlVDB2Qys3S3BW?=
 =?utf-8?B?Rk41cEhoMW56czd1TjNCS003UTlERVRhMGFlRFFXRm1maHlUallWTkd4eFBM?=
 =?utf-8?B?M04xeENMcTFZREhRSktjWGIwVmdkVWhObGJNa0t4cXpybTlBUEdsUTB1cHps?=
 =?utf-8?B?bDV6UWtTMUlLSkx4amRWTGg5WlpkdkNwdFZ1bzNEaVFxODhIdkJsUEVaRzNk?=
 =?utf-8?B?RHc1eFRPVlpUUkJudmpNUGFQbFVYY0dWa216MFEzZVVNaFJmaHJmYnZHRlBS?=
 =?utf-8?B?ZEhMQzcxa1F2L3E1YU52T2pmdmZ5T2t2MkZwUm5CV0xEQjFDaldjamxaWlBQ?=
 =?utf-8?B?ZTlaQTl6RmM1RXBidjZOUmMxWUFxUUNET3U5cUF3M1owNHRJaHJreTdSaG1q?=
 =?utf-8?B?YXBLYnBJcEwzMXBvcENOZHZZTWVtclZnQmJ3NGVQT3VtSkwvM25QSktsRzVz?=
 =?utf-8?B?UmQ1VXZMWGxtbndPK2FjYUlzK1VOQkpwSWFzd01MSjBhU1NiZ0g1aUo0MEpw?=
 =?utf-8?B?ekM2WUtrK00wN0kvOWdhMUlqa3pjTTVkTzdlZnpHR1lGNEpkd1YzNmJydEN0?=
 =?utf-8?B?LzF5aHFDd0VGRTlqOVBJTGFLMFQ4MXh0cThmWFlYY25YejlwUk91T0d6WVFY?=
 =?utf-8?B?SVBWUitCMUszNm9lS1NEaUp4QzNBbXRGbG1LeGlPWWczWmVlZnRyS255NGll?=
 =?utf-8?B?V0h1UU45eHJZcC9Oeisvdk1EVjNGeHVSZW9ZMjNDQmdhcmFscGY2K1c1ejBw?=
 =?utf-8?B?Y2xNMEFvOUxjZ1p5MFZaRHMrOVZ3YjJOczdtQmc3RUJ4MzY4ZGlvSmtMWVV2?=
 =?utf-8?B?K2UwUHd6c3IrNDg1YXVqcXlIOXpkem5zN2hVeGkrOE45czFCRTlCeHFIQnVq?=
 =?utf-8?B?SlBhRWhINjNxRkIwSTB5S2x6ZE9OWVhpNVlESUhBN1h5MzNIcnFlQ216VGNE?=
 =?utf-8?B?NUttOGRSZjVOZGgyOVVqbGlaVjJKbUNOeUtvNVZqRWlGYVZoSDJLN0swV3U2?=
 =?utf-8?B?Z2NPU1hPanYyenpqckJVVTRqdU9kNXZneUd4RFFtY21hOTY5NkYxSFRINlJO?=
 =?utf-8?B?anJ6TDZkQnBDczJtMmk5MXJjdzQ5RHNYdVYzN0RmM1Q1TUJuaWptRHlJSTBn?=
 =?utf-8?B?aU9PKy9NcHNIaWp5T2tUN0JVS0tDZU1SVVlkQzJLdlo3S2FTRXB1RUkrTXFK?=
 =?utf-8?B?RWI2SDhnckcyWHFjcHpsbjdUSHlHaFN0UWp6eWVWNTdCWDZiR0EvYURLcGt4?=
 =?utf-8?B?dGgxRzZKcGZQYTluUkpvbkxGbGFtdGM4UnAyNXA3VFpBckJISVNWVjdKVDRM?=
 =?utf-8?Q?0FMMCYKgAUn9YI6RTg8c9acFe15lh1hHo05PeIS1E5t2P?=
X-MS-Exchange-AntiSpam-MessageData-1: v8xsXJ5Y9G4mrQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e63d50c8-be18-4e81-a6e7-08da4df3685c
X-MS-Exchange-CrossTenant-AuthSource: AM5PR0401MB2515.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 10:48:25.1359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3V1h9B8Mox3YoVdVbKoyFFsNUCYEM+2aOgOSWZRt/Cn/ApZySRzd+6cpA3jTVK2WZPADrYyboLsPLmLPsSYE+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2366
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14.06.22 10:50, Lukas Wunner wrote:

> @@ -758,6 +758,8 @@ static void sierra_net_unbind(struct usbnet *dev, struct usb_interface *intf)
>  
>  	dev_dbg(&dev->udev->dev, "%s", __func__);
>  
> +	usbnet_status_stop(dev);
> +
>  	/* kill the timer and work */
>  	del_timer_sync(&priv->sync_timer);
>  	cancel_work_sync(&priv->sierra_net_kevent);

Hi,

as far as I can see the following race condition exists:


CPU A:

intr_complete() -> static void sierra_net_status() -> defer_kevent()

									CPU B:

usbnet_stop_status()  ---- kills the URB but only the URB, kevent scheduled

CPU A:

sierra_net_kevent -> sierra_net_dosync() ->

CPU B:
-> del_timer_sync(&priv->sync_timer);  ---- NOP, too early

CPU A:

add_timer(&priv->sync_timer);

CPU B:

cancel_work_sync(&priv->sierra_net_kevent);  ---- NOP, too late

	Regards
		Oliver


