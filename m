Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D462583AC1
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 10:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbiG1Iyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 04:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbiG1Iyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 04:54:37 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10088.outbound.protection.outlook.com [40.107.1.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC7B65569;
        Thu, 28 Jul 2022 01:54:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3ctmGlpMuQQQPW4jMYvX6UdT9EIxVATQN5iUvHBHzWY2eIhVC97ZKszcCtEa1mvslCOaOZ2LhIC0MpfIsyHGKEla2JoQiyhQJbdQrRQgkhgKnKfwHEMgpjp86APv/m8isgKlgleaZzDgBbt2hgzWfy4rZlQIGpmjDZTzShnJpnIs1Wop3YGArVwwSK0R2O+vpL5EsUa6qB4dCc5Fdcu8D4iJ0Z1BsqbToMwoNW4k5ROWBa8rtUhB3rbABg82/mUVKwwoZ5PEjSI1FkFudViZFgtaco2on3c6hgNudLv8wQ6+DZu6KPcvMzuRyouy1e3YcqfMPJ7ailvPaI2I47nWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72CBIPWzwTnqjKCU7jOjYI0q3C8GePJ8rejAArPfoF0=;
 b=L5PmO3S2/QAFEpNrUzAUgiCAA6v6pwrZwHd9vELORf71iaVivZ80R4BnvwFBU08eQVbPB4NIzEc6Yjq0g6SIus+wmyOTvgQh/VsBnXxrVVBWf46s0if3mQna/Dikibkx9YBtfZQOlztr2rdMT85nNcr9bVwEalPtrLpretwU3wOCvRKZGvz21gRYYrBGcxj7HgEBmESV2Zj4sW+LJINm+Xxnj5nKnVQ/O2Tg/rUM5Vu/oAV/AEutDhx0Snv8stLshXF7aYv+PVKls2gpkvdiuC7XTVPhEMEy0OmPBWckmTQVAVygu/TUBSJlzrclJQPMRm3GW3i4/vZpo//5/ifnZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72CBIPWzwTnqjKCU7jOjYI0q3C8GePJ8rejAArPfoF0=;
 b=UXo2Q61fIwYejJCrSxH95+559s5nIW5CZldTV97Y84xJGu9zP7hpyTdkY4Z2+kiCxsnd2Qah+JeVG1Yazpc/E2WDMQOBp5XU+rAw7JLQip6io++KEcDtQK0isIQZAMBWYTT6EZ+78nFhgKVYwGLDLABQriLlq28OfHDkhmPEFD2GRU07aCjsVV07M/zIOXGEpkIUpK71DaJmHY9nTtAZyfMrhFidMsDyFTbMpHt4X58YnBx3CxCbW4Z+wY3q9exdaljx4WCqK8mRtVt35nXU+xxZEp2fZssfu7Y2TPmYXiapmLbAMZU9zEhZ9N4fKVBFLgdpX0IJIxiJF8mli9B3Zw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM0PR04MB7138.eurprd04.prod.outlook.com
 (2603:10a6:208:19e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 08:54:32 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d%12]) with mapi id 15.20.5458.025; Thu, 28 Jul
 2022 08:54:32 +0000
Message-ID: <4dfebefb-b4a4-ccdb-d0f7-015273710076@suse.com>
Date:   Thu, 28 Jul 2022 10:54:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: handling MAC set by user space in reset_resume() of r8152
Content-Language: en-US
To:     Hayes Wang <hayeswang@realtek.com>,
        Oliver Neukum <oneukum@suse.com>
Cc:     USB list <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <2397d98d-e373-1740-eb5f-8fe795a0352a@suse.com>
 <YuGFOU7oKlAGZjTa@lunn.ch> <353a10d11f2345c8acff717be4ade74a@realtek.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <353a10d11f2345c8acff717be4ade74a@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9P251CA0023.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:50f::19) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74505603-3913-4d42-9a3a-08da7076c9c7
X-MS-TrafficTypeDiagnostic: AM0PR04MB7138:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GDwXJAUODu0KMKCWHF7qDapu7QxssE22oWrYdoxztJIhunpuBN5AQFHtdmI+B0+W1fdeH2pCbmVXzyxGTJxhW+CeSVNv0pXpJl8TxdqwNHGBuEpkBRphAiHE1ocUc1e0PkVdhC2sP6SNTE2RA5YBEo/ypz/iWfsKKO4NmXwJ6OMHeNYEM+1SKAyfNqjCArANpIShyzky6uXVex/lq/AtASndcGuc7clms8BIvOeTfe66TOlUij5+lFAAVUhhMSYqSJOQ8WJtjtYeKpjqRvlP8k6v2G6XwgYgDvvt9MgXgooFu7OBa4hMRgtaGmDOwQs7Uj6OxNAg0qXBHJ/UK+mwn/B2u+ScIDub6gnChsMm/MTLagwHKyjoFskYOT/Sm1psF2yd9icZ+tn2bbYxgTfn6paa/5C+n+7QRBubbz1hV4E2DVCQMID/YaPYbTpV+E4ZE/0v/quTmHUm2BicdXQ0hRAxis3ql33SX98rW1b+yyRVCpOs9tpLfqaJwrFhgAJyhnzkx7KHsBIK19R5SzZAxF6reNPjROtITfwyUmAL4FcLZr74abGM5a+qBcbe9dk46TiIPuUVbCjMQVl16GKAWQ6Bjuppu0uQ7AnIAMMAJYR2qmvyb1L8sUKqo3zmzJAVF0DxkLHzzr8z+KdI6Uu0pR3xrdRXo2ic2DGD3UW5E7EWadlkh2SsKy8f+Hm3KKKaHrhrvlA9r+F4E28+7wUCGE7RRMus1E8oIVR7FPatyIluBPfaCEqOSKupOKP7ZOG7c+SOfYnKm8JjRkY/md08u4wZciLE+SP9vn/BAb/rL8kBK7eZuxYUuBB+ahuOFqTWI49GP+ekbSBgT88nrL1Odw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(376002)(396003)(346002)(136003)(6486002)(186003)(31696002)(86362001)(53546011)(2616005)(6506007)(2906002)(6512007)(478600001)(38100700002)(41300700001)(83380400001)(36756003)(31686004)(4744005)(8936002)(5660300002)(110136005)(66556008)(4326008)(316002)(8676002)(66946007)(66476007)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEF3MG1WZGxvWXJnelovMDg0RFJwMUdoc1BVc0lvTmMxUlRIYVZOaGhPL21v?=
 =?utf-8?B?Z01JUjNMdUJaeFVreVF3bnVPbE94cXpFWEFYM0plVmtTcHl2Zlg1dnhUTngz?=
 =?utf-8?B?bWlxUkZ2TnFSZ0EvdVp4QzFzdk1sd3BIeHErSmtlMFlvdm5RTGl0MEU5a09s?=
 =?utf-8?B?VkFXWmhCcXM5aE1BQTRxbE43N3VYc0NCZFFjOENsWUJqTGcwejJjOGxkTjFR?=
 =?utf-8?B?VnlFWDJjYVJUSERLMHh3Vmh0MWZoTEYyeVE4eGRTVTFWN0s0MmczU2g4NTdF?=
 =?utf-8?B?Q0o4bmJDV08zcjUrY3c2aXA2bXRNK1NpSExDYTNvWFRrQ3F6ZmlJMjlrdlc5?=
 =?utf-8?B?OGNzL0ZFTVNvanFmek5WeEJtL0Y5T1pWMDhtdUpobThvOStyMU9yUnJhUUp6?=
 =?utf-8?B?UUc2ZERDVytQalcvS2dGRVJOZWFORWpRU2NJcEdRdXN3ZnphRTgxMlQ2R1g0?=
 =?utf-8?B?Ni9FSDRaL3AyMFc5K2dEYytsSFZoOHB0dXdVUmFrUTVmaEVtMHI2SEZzVmxH?=
 =?utf-8?B?NnZuVmNsVWxnRkJ2SHQ1MjVNWUR5VkZvNXRTMHNpTXBQWFFRbEUrbm1ZaUgx?=
 =?utf-8?B?WmhVcjZGOC94OEFmSUd2WUpjbEdkNVRseVplZDBNUXBIMC9VOXFEaG9ISHln?=
 =?utf-8?B?UDBtcjI2NGZkSVlFNHZrdm5PdzNOTGp2b1dRazJvN2NITjdCbENUVlU2U3pB?=
 =?utf-8?B?eWhyL0ZuaFpBMFVLYkliNUw4ZGd6ekQ5M3pMN2Vtb1RReHhkdUtJN1ZtNGJC?=
 =?utf-8?B?QkZ2eXU0NHZheHpyQTgva0gzaE43aEUwaXNGckVDTFF1ZldPYjhmbFNEakpl?=
 =?utf-8?B?QlNTUEhBNHMzNjE0MTFjMjcxSlZCQ0dmL2llaE1DZ3ZaZ3hsc204NnlwVTZD?=
 =?utf-8?B?MG9QZzVZRC9kbXBEdjdKV3JBS3ZmMlQ5RUZObE1oMWd1enJ4dzJUNTlmRGhm?=
 =?utf-8?B?ZWVZWmdOakxDV2VVSUVWN1dNQUhQRTR5Qkh3VDZrS0JYeWllSVFxbUdPbHMr?=
 =?utf-8?B?VmlVc1lra0FoeTdEVzBQVXVWaGxoYXNBMXpmRTlKdU9ZcVFzNThYVXQzd0s5?=
 =?utf-8?B?S3pPTWRkNjJhUlc0NlRsRDk1ZkpUYWNjNlQxUjcvME16T2s2d2NicjFUNGQz?=
 =?utf-8?B?ZkpXbW5NNUJpUHg4SEFDREcrSmtSbCtQU3dhcU9uSW51R3VVdFRQa3F5dHQr?=
 =?utf-8?B?SVF3OHhaRmdRRVFyZlRoWG93ZXdqRVhCQmRKblRveWVkSmhGQitPQXJYNERO?=
 =?utf-8?B?UFNCOWJFTzBUWnllbXo5RHdQY0dnV3EyRlJVMXI1TGFZYVBycnZSWkVSTjFS?=
 =?utf-8?B?RGRCRU5LdGJUQVZ5WVBLZmlmUnN1QkJHaDZSK2tHazhjeWZMNllRbTRiT1lN?=
 =?utf-8?B?MW9kT3RPTmlaNHRiL29wWFdDREJ4bXdReEhrbDJFWnl2NUc1a1ZTdmt4UFZD?=
 =?utf-8?B?UGgxVmdpOGZqZjZkZDlRbzFIS3VaVnN4amtOTVg0UlJpdVdJOGRkV0libEtC?=
 =?utf-8?B?Si8vdFYrVXk1NURsVnY1M3lKN09DdXJpZC9Lc0dhMDgvSFBWQVZMOWdOREoy?=
 =?utf-8?B?ai8xZGtMS1lMQWFNNzI3Q3Bvc1NKSmUwclZ6MWFJTXpta1hRTnpuWm85Nkhp?=
 =?utf-8?B?QjBDaElCcU8zaDRnalRFZUJvOWJ5QkNRemZvT3R4SkdsQ0ROL0RTdW1qTmVG?=
 =?utf-8?B?YlpDb1BSa25mamdmUVdsSnNVYXl5Tk50TE9lejNSdEZ6UWR0QS90RGQvbHdG?=
 =?utf-8?B?N3ZvaHg5VU8zTE85QVBVUHZYOURLMWpHYnlnbUoyMWZ6UkNwZjB5ZUdnTW5r?=
 =?utf-8?B?WGtrYWkzVGhlUStGczNlUkJrNGp5MEM1SldZeHNuS3pVbGptaEIwV1Q0MTM0?=
 =?utf-8?B?SUYyb2NrcmNzQ1MyeWlXbnVKM1BLbWtLUVgyZURxcXdMcjBOSno4V1VucS9m?=
 =?utf-8?B?R3ltdGNHNHRSN20xSHlFeGFUMlRPVVFWWFZwa1ZUNVhGdVNLTnozTndnOUtk?=
 =?utf-8?B?TGJpMXJ4dkhaSmpRRTA4dERmSjRNY0d6REFEMWhiMlYxVkJ0YXd0NXVJUWxu?=
 =?utf-8?B?ZXM5ZmZmS1BGczJQSkhhODVMSVpGOE5VZURncWlpZnQ2Y1dIVUJrT28ybHBp?=
 =?utf-8?B?QW9ER2dyVkE3QTdubmFJWjlxdmpISG5tN292TXdpQ2I3VGk0TndxVnVweXB0?=
 =?utf-8?Q?le7eHQZ+ju23yuJ34FT6UJ3NeBuHF1loWmVDnY+y4CCD?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74505603-3913-4d42-9a3a-08da7076c9c7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 08:54:32.1662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SW9OlV/zZ/GrjnKAAOBYVH9WbwAOF/f6Pkm8Kpd3i45iR0HbdkRC+p9VkiK7wdJpOfriN/fcGB6tk9jkvt3iZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7138
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28.07.22 10:40, Hayes Wang wrote:
> Oliver Neukum <oneukum@suse.com>
>>> Date: Wed, 27 Jul 2022 13:29:42 +0200
>>> Subject: [PATCH] r8152: restore external MAC in reset_resume
>>>
>>> If user space has set the MAC of the interface,
>>> reset_resume() must restore that setting rather
>>> than redetermine the MAC like if te interface
>>> is probed regularly.
> 
> I think this patch conflicts with commit 25766271e42f ("r8152: Refresh
> MAC address during USBDEVFS_RESET"). The results would be changed.

Argh.
OK, thank you. Do you agree that a manually set MAC needs to be kept
even through a pre/post_reset() and reset_resume(), while a MAC passed
through needs to be reevaluated at pre/post_reset() but not at
reset_resume()

> Besides, I don't understand why you set tp->external_mac = false
> in rtl8152_down().

Frankly I need to undo the effect of ndo_set_mac_address()
at some time, but it is unclear to me how to return a network
interface to its "native" MAC.
Any ideas?

	Regards
		Oliver
