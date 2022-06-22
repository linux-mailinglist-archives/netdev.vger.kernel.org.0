Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17DDC5543E7
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 10:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353711AbiFVHmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 03:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349317AbiFVHmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 03:42:22 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60061.outbound.protection.outlook.com [40.107.6.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23D6377DE;
        Wed, 22 Jun 2022 00:42:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMd4ZqwOEPH/92g9sAMcE8LNo4PlKjF+KJWEsjUDA/ok22SXOOauqyCdk7L9D3fqPF0oTYsgaFOZUXFfbw7anEg11J3whaqdBrtPdlGiq6Dh3Ky8bG6QgetwH3xN8UfFZYRh4TKQkj2nPv7b9oV3+CdAC/Yxe9ce47KPeCKPXGTd6siAXs1SHsE1owIpTzBMpqfUdU7ypVhhzsT5GsnbRdyGmm7cuVsQWJshcSr/nZim4fClcmwD8tlwXVWxsiYtfrPv3givG39NuFn2ZGkT2WL14+daz+NNvaPq+RxvDLwVC8GaGJkASeYckvwdrr5ifWdEF1hS3HZha+OcVe9RwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iT2Czux06e7L3iyjzBqKPb9bFFRDQokpMyLiemx09Lw=;
 b=QBY3UItyQG7QrqpEyzdWpwEEAuqF/e9acvRTYyhBjuO+YzJBS+i7Vtwp1JLbOAl6wpKr08LzEGeP0YepN7U2YTZIkWrV0wryv13yJmur25ytXiKZX5WtoJbdRo1jAl3tMIPIF3XjMPXIkh/3IiSbCFsipMt/zILleCApeH56vZAqnZVq7QNQooHG/U7rpeD19iA8GY8sntXefuErG3JZtnssaBBJJxq1g6xhDAmp44HED0EpYk/67HD1ekS00HpnsfhwJf5TD5XhwNZEpgWDyIBv/OC6i5IgnVOIt1tZQ75Lk/CQmTOrKXCugUAyWXHKx6kyOK9jZkziPK1vMjnZ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iT2Czux06e7L3iyjzBqKPb9bFFRDQokpMyLiemx09Lw=;
 b=QomjCqVxljd6IpF8dIJ467BAYFPF7QRZl0dBlMAcOEZZYfkMOekRWjRyh1syLcMS/GhDvQQ96UyHLJlcRbFkMgnwrTbCocEtk2vcgpnUmTnVzkraLQby++blyhL+xqlwBIRSRav+FPfHqDJN/WZFvm/Z+g62u8b9VbCpIfOkj8QB3pCrQTAitRWD/OKEGJRgwNfQ2PAvDnfEsf6w4Uei+GazsNnsaKlxE6IquBpmKLzbo0UShO/cB/l55WDlTygei77CUgAr+02w/cXcgLqYqUfmQBuMOBmfaQG8khmMexWLWzYc517g1oF1Y68bvzQ3X/JwSvyShKreTihQhUaTXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by VI1PR04MB7199.eurprd04.prod.outlook.com
 (2603:10a6:800:11d::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Wed, 22 Jun
 2022 07:42:16 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d%12]) with mapi id 15.20.5353.022; Wed, 22 Jun
 2022 07:42:16 +0000
Message-ID: <d0b8dc35-efe6-c60a-f914-a0a30481efbc@suse.com>
Date:   Wed, 22 Jun 2022 09:42:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net] sierra_net: Fix use-after-free on unbind
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>, Oliver Neukum <oneukum@suse.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Jann Horn <jannh@google.com>
References: <80e88f61ca68c36ebce5d17dfcaa8e956e19fb2f.1655196227.git.lukas@wunner.de>
 <60a08f2c-6475-4bb2-1cc8-1935a5ddeb79@suse.com>
 <20220621164316.GA8969@wunner.de>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220621164316.GA8969@wunner.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0752.eurprd06.prod.outlook.com
 (2603:10a6:20b:484::7) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bae303cf-5c8f-4c11-3555-08da5422ba60
X-MS-TrafficTypeDiagnostic: VI1PR04MB7199:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VI1PR04MB7199E6D3AD7A4567D9FA13D1C7B29@VI1PR04MB7199.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5B0YxxD2svriCgCEdlDNx5GCFCeQmCGNVjVMCuO3M/zSWwSocs1rnBlYnkxtBcJNK0mSkGZZ9Kee5OGGRNLxhbpc3HSIfkRF3xuiOQb1OQ0UJDy4BtYf5MZ61SOcHjvzTHOHuoN/m8efTtDSk3B9Rfq/pq5CUYpQ6eNJAT/ZfyJK7HcJ57U6NYzw2/i/CMQ+doBUh1QdgReeeON6gUcPa6yI3ZnNxRwLJxXYYrmnjqh8AxxiDgCgJqFbNoqINGe729pLuQ5LnZp9hxffWTYTATfy0Nwb72MZxzDxxnQ4ypRlONgmh6UvQnwmUJrCbDsriD4rkJKPsBk3ExMbObTE/bqk8esMI1tKkIGxYoiaYxB+zKxrqU3lmyCLT/JcU0vHJXCCtnfcZGZ1Wqj/LZejFTpxcxM72h/udmhWhQL6XPN0N1kMFm1VqGkpif132XYh5onHpcFzxlkArJXaSMe1KlUuo80I6FlvJY93A6afuEkCoY3pzkIPSFNR8JwRWLE8MYkC0ND3UhioQvMsa6XPNHvnG/1jmPjYqBOmx8ibYnlydi07XNYTnu/T59DjzLlgRs88h5HcKEDsYB/hAadTweGuUb9+WWVXWOXe35s6QxChuBb5K/VbSm3eOx9p2dgCAO50PzzNvU5rz894SEfIKyioLP2jqLOKmTM0cCHehr9lhipkGVMVD6wlpt2u0YPFxfFqOEn026cAKvDIZdSlk9QM73GxsOiB8oQo1BXpz0s7l6spnYoiHjhF7cI/qob1lgXzwgKpTRDUWR6sxLn7ysG99g8SRrxg0u8+w/F1sHZGFXYF0Xv0XZmQmdd+HnW3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(396003)(366004)(346002)(136003)(66946007)(36756003)(31686004)(4326008)(83380400001)(8676002)(66556008)(6486002)(2906002)(8936002)(478600001)(110136005)(966005)(6506007)(54906003)(66476007)(316002)(186003)(6666004)(86362001)(2616005)(31696002)(38100700002)(53546011)(5660300002)(41300700001)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjhZeWJCUy9NdSszQW45K3EybmFITVAzdCtRUXZjTExEbkVzRng4TXFZamZr?=
 =?utf-8?B?d0RXRHFadVhGU2JwaXBuYXU5Mm9JNW5SSEpmSmMxYWtVajNpU1BWSms2d3B1?=
 =?utf-8?B?RTliSmRnYWN3NVQ3QXBzT21qTlpIWldBUkE3dVUvcXI1ZWN5aG1Ra2J6RjhK?=
 =?utf-8?B?M0x0ZExrQ0V1YlpDcGFpSngwN29iYjFtNVYrcW1vSWVVeC9XM29wRmxtL2pL?=
 =?utf-8?B?SldUdTFXUXZPZ25HR2dpdGNsMWhiUzlKaThGTFBheVpSUjVoVkRSYWhiR0kv?=
 =?utf-8?B?MWozQXBwQzZYcnRhaWZKb0xjYXpVUDZEOHdNQTMvYzZLbDNKWFN4ZmxxNENh?=
 =?utf-8?B?STJpTTRHWERkT1JjQVBKNDFNZHJqNzlEMlY5ZXVqNnNvVTlsUkVmNWV2ZENZ?=
 =?utf-8?B?dGxXV084R2E4Z2phZlIzNlVGc3VQTzZqS2p0aUZPWHFsV3AzUWt5VWluNmgr?=
 =?utf-8?B?T3c0dE02bEhqVjFia3U0cXB4dnV0bkNuazRyZlp5Zm9uUHo4NVI0L3ZvMUpq?=
 =?utf-8?B?Rkd5QUljRFRXTUJkU2hyRkYwSWVrM3liemZ6OGVmRjRIdU4wOEhNUEp3YmZa?=
 =?utf-8?B?dkx0RWVINjEydGJzQ1Njb2ViZlVtVGloWTBwWmJ6eFRhK3dyUjRQaVkwQlhq?=
 =?utf-8?B?UEtJU2JYc0RiZWFyYWExakJzRlJTb2RSOVlGNjJya1d5cTdYYVltV1ovWXRn?=
 =?utf-8?B?TGNGMFJJbi8xbk9XR1VaRU9YUnZWdHBYU1JqRzBMcThqeloxQ0NES3IyNkdB?=
 =?utf-8?B?a1BzUFNGZHVRbTdyM2pBMXpjME11TnZGTlU3Wk84K1dwRWpnK3FWTDdHS3RD?=
 =?utf-8?B?WksrU0tlMUIvOUNzVlVYUSt6Z3BQc3FxUmdkRE9KL2gyckpQTWdqMDA0VHRj?=
 =?utf-8?B?d0MyQWgwcWlGZVR4TVlVTlE4UmtkbGtudkxjQlczVjJRaW4wTHQxRDVNbUY1?=
 =?utf-8?B?NDNraVA4QWc5NlNlb2FxWm9RMTE4R1hKcGFGR2pZaW5zOERObnBGWnZSK2d4?=
 =?utf-8?B?bkZtaThQbW9aOUprcjFJQjFycTlKOWo4S2dBQUY2S3dJWW1XNmVKSlNjbVZj?=
 =?utf-8?B?b1AxK2ZOam1FRkl1cjdUd2Y0d01HcThaeTdkUS8vRHJpSksrcVI2MldpbEhT?=
 =?utf-8?B?akZHQ0xvZUhVQ3RCaExURUtxVjN5RUYxdEhhZ0tjZnJGQVBPSW9weS8yZFFt?=
 =?utf-8?B?dU8xUTJrWlRBMitsaGJSN2JRdE54dmc0UGlGQk0zSC9wdTlRWkpzOFVDR3hJ?=
 =?utf-8?B?bmE1dW5yZXpLZXU3ckhHL0ZqQ1Ewb1YwREo1KzVnRWpQRVJyQTdMcmEzbWZi?=
 =?utf-8?B?dU42bVBhYVN6am1kbE11S1NhUHlQMERtMjZQS1Z1QVVsd1E4ZDdvbk5TQzhw?=
 =?utf-8?B?S2QrSk85M081ODVnQ2UySDR1ZExUTE1GRDBmVTFhMElNZGlnalhYbVRVSksw?=
 =?utf-8?B?d1Iyd1pGL2ZKZ3IrMjFnOWxUVm9tWGtsNUJHRnRHbktCQXB3NlZZNkNnU054?=
 =?utf-8?B?Y3dBbUpCUmR0eFY4SzJoVFp6Q0p3L09YZUNISVVsM014aHc4anlLT2x4OVVq?=
 =?utf-8?B?T1BVdHBWc29ZNEt6eWh2UWwwNFg0YXJqakRDNTZFaVZwY1dYTm9QNGJiMnZp?=
 =?utf-8?B?ODFVeEwxSTBQMGxJeXJsWTBJanZrcDVRRzlLaWZMalFaTHU0cUpacmFwT2F6?=
 =?utf-8?B?V2RPb3dXV1FqV3JzL1Z3a3UwNE0wVXZtWnNOcDlGMXlMd0EvaHZCWHZOUE8y?=
 =?utf-8?B?OU5TNGZBaVdLWnduOTgxOFNubitncUV1Q0FQMXhZMnlJOGY4MExjYWtzQ1c0?=
 =?utf-8?B?aTYyV3lBVVZZOFVvQURPWmE1UFlaaExKQ1FIb0c5T3E3N0tubUdwWEt4dFlQ?=
 =?utf-8?B?Y0J1Nk9qVkcvTWQ2VXU3WUNhcTRkNmViTDV2T0pLeXFaTXcrS3VYU1dGV3dZ?=
 =?utf-8?B?cjdNZE5nWnVBY3lMOEZNY3dvRHMvSXl5dm9weEdmdE5kVWpaUjM0eGNTeVZ6?=
 =?utf-8?B?WGorNnlYQ3AxR3Q1clB1Rm84cGhZSWpGaGhVdUNYUjBsQ090L1dFbnhSVmlu?=
 =?utf-8?B?eCtuVFJVemo1MUszTHJCLzJzc05pNUxwOGltRGpvdzE5NzRhS2VGVHVFWmhZ?=
 =?utf-8?B?dzJjcHN2cTVjM3IxMEJvYklOeGpjMnIzSkowOHA1WmhxYVFUcGFzd3lhclJ6?=
 =?utf-8?B?YTU3bm5pZERFeDhhUFB5dm41Y2NuTkdTMGd6anFESnpMTDRjTUFQd2xPT2NP?=
 =?utf-8?B?TWpCL3crZVl0QlA2S2dMd2g2RTVCcVprajhWYXB1R1FGdDh1a05wQUhhT1RM?=
 =?utf-8?B?WkdwYUZhVjBqM1MvSVVZZnFPb0pCTFVqWEwyeFFQK2ZpZTg3UXk1a3ZmT0ds?=
 =?utf-8?Q?5xv5RNuj2jE2GiMA3sKJZyIQmb/yLkeJ5sgxYs2UtVMV6?=
X-MS-Exchange-AntiSpam-MessageData-1: yFlTUbRGlg6Aig==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bae303cf-5c8f-4c11-3555-08da5422ba60
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 07:42:16.0866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gyJaJr0uS+RqnhphAbr6BZtUq8Pye+COmbO6XgPuUJ8HTos1sE8utwK7ZKoWnCv3QnpKOY2jPHKLYF1gL5upAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7199
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.06.22 18:43, Lukas Wunner wrote:
> [adding Jann as UAF connoisseur to cc]
> 
> On Tue, Jun 14, 2022 at 12:48:23PM +0200, Oliver Neukum wrote:

>>
>> as far as I can see the following race condition exists:
>>
>> CPU A:
>> intr_complete() -> static void sierra_net_status() -> defer_kevent()
>>
>> CPU B:
>> usbnet_stop_status()  ---- kills the URB but only the URB, kevent scheduled
>>
>> CPU A:
>> sierra_net_kevent -> sierra_net_dosync() ->
>>
>> CPU B:
>> -> del_timer_sync(&priv->sync_timer);  ---- NOP, too early
>>
>> CPU A:
>> add_timer(&priv->sync_timer);
>>
>> CPU B:
>> cancel_work_sync(&priv->sierra_net_kevent);  ---- NOP, too late
> 
> I see your point, but what's the solution?

That is hard to say. I will go as far as saying that this will need
a flag indicating a status of currently being disconnected.

> I could call netif_device_detach() on ->disconnect(), then avoid
> scheduling sierra_net_kevent in the timer if !netif_device_present(),
> and also avoid arming the timer in sierra_net_kevent under the same
> condition.

A flag you get by using netif_device_present() as a flag.

Yet the idea of shifting things around in the disconnect() code
path of a USB network driver just to solve some other issue makes
me very nervous.
If you decide that this needs a flag, please add a dedicated flag.

> 
> Still, I think I'd need 3 calls to make this bulletproof, either
> 
> 	del_timer_sync(&priv->sync_timer);
> 	cancel_work_sync(&priv->sierra_net_kevent);
> 	del_timer_sync(&priv->sync_timer);
> 
> or
> 
> 	cancel_work_sync(&priv->sierra_net_kevent);
> 	del_timer_sync(&priv->sync_timer);
> 	cancel_work_sync(&priv->sierra_net_kevent);
> 
> Doesn't really matter which of these two.  Am I right?

Yes, that is right.

> Is there a better (simpler) approach?

I am thinking about causing the timer and the kevent fail
their URB submissions.

> FWIW, the logic in usbnet.c looks similarly flawed:
> There's a timer, a tasklet and a work.
> (Sounds like one of those "... walk into a bar" jokes.)

We need somebody to start a web comic based on that.

> The timer is armed by the tx/rx URB completion callbacks.
> Those URBs are terminated in usbnet_stop() and the timer is
> deleted.  So far so good.  But:
> 
> The tasklet schedules the work.
> The work schedules the tasklet.
> The tasklet also schedules itself.

This test is supposed to make the kevent save from itself:

        if (netif_running (dev->net) &&
            netif_device_present (dev->net) &&

Do you think it is insufficient?

I must admit the logic in usbnet is not easy to understand.
In fact it may not be possible to understand at all.

> We kill the tasklet in usbnet_stop() and afterwards cancel the
> work in usbnet_disconnect().  What happens if the work schedules
> the tasklet again?  Another UAF.  That may happen in the EVENT_RX_HALT,
> EVENT_RX_MEMORY, EVENT_LINK_RESET and EVENT_LINK_CHANGE code paths.
> A few netif_device_present() safeguards may help to prevent
> rescheduling the killed tasklet, but I suspect we may again need
> 3 calls here (tasklet_kill() / cancel_work_sync() / tasklet_kill())
> to make it bulletproof.  What do you think?

I think that this is unsalvagaeble. We'd fare better with a clear
"zombie" flag we test before firing off anything.

> As a heads-up, I'm going to move the cancel_work_sync() to usbnet_stop()
> in an upcoming patch.  That seems to be Jakub's preferred approach to
> tackle the linkwatch UAF.  I fear it may increase the risk of encountering
> the issues outlined above as the time between tasklet_kill() and
> cancel_work_sync() is reduced:
> 
> https://github.com/l1k/linux/commit/89988b499ab9

Please do go ahead to adapt it to the way the big network drivers need it.
You have now convinced me that usbnet needs major surgery. This means
work in merging for me in any case. Feel free to do what serves the
users best. Usbnet is a  framework. It should be formed by what drivers
need, not the other way round.

	Regards
		Oliver
