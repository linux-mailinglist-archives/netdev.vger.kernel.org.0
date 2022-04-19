Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1684506B62
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351884AbiDSLuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349667AbiDSLud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:50:33 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C437344FB
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 04:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1650368867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ic9IpbtajKUZ49wrCOHBmtewrJWY3OUbkG9I8BJr7yg=;
        b=YtX08IvaA+xELZU1BXlbcXPQftk3I9ZTtB8xLqFGzGetAu0+7lBsYVsrZm/2BLA6BEcG16
        allFjVhS9cgclXvC/E6DgCDCE1t/aGZ6ne81a4M7OKYODgPcazy4hkKOzE3mzgZSinIbsI
        cA692RKztvVs+ACVoPgTSrRIIM6EGhI=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2169.outbound.protection.outlook.com [104.47.17.169]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-41-fd-9P15qNnqR3-g8VUSUsg-1; Tue, 19 Apr 2022 13:47:44 +0200
X-MC-Unique: fd-9P15qNnqR3-g8VUSUsg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsmjG6mI1FC3tEt617sSHtfUPP8jhkUZwFTe1aARPziMrQzQ2xXoUVRSV4UYx2Z11Ab1iq47SJEQN7+c9/AWA8fBQSv7f6gfvafzalmpkGaxxcSWXcGXuod7AXRv42kzyGeTpHdYv9+wRocuUvhzhAGAhVNbtmL266ruVbJHTqg4w6l0/n5ys+YsW7SUEys1EW006qEb9cf2k9+PmBaaYbLbCjQpUxVIl6lMCj8FGfOVWkBzM/iyDmIkQyEK9ptOlv8P4a3hQeWpde8N8mtl2d8YIw2qFtJxdY5Q4FsaH8J9jsl85WNCGTINP7WEaereV9mg00Z+OKbcT3Rb0tLsng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ic9IpbtajKUZ49wrCOHBmtewrJWY3OUbkG9I8BJr7yg=;
 b=hHcPhlwN3zGnLXm0HcCG2cpfGuodTqFWvxRrY36fpXrNjWE35I8obLjsvI8yk/LxWPL8986Oa9XScFevwCu76+M5ToJfa5KdKAa8eyzAZOtIrMK/s8ZYavksk23YpKsqI9+ZH9yZKlqlXuH+uyq19CmmmqjK7omGG0xKXwrvRhagZiOwNSL284xLLvll1HL9sw/aOat41Hs5fXR7+fekXkQyE+hOCivJsSudfoGTJP7j+PN94p3CcNhZ+vMLywyXn9h7NDgIK4wd6ePxSDphYtMLZQgUNVnxCztZbyB6viGEEilHlAzLhLVUnyOk/dQgKtl6FOMQwbDgK42Iemf4vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM6PR04MB6661.eurprd04.prod.outlook.com
 (2603:10a6:20b:d8::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:47:42 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:47:42 +0000
Content-Type: multipart/mixed; boundary="------------9TpvbyysGbGnJ9PxZsbqPstO"
Message-ID: <d851497f-7960-b606-2f87-eb9bff89c8ac@suse.com>
Date:   Tue, 19 Apr 2022 13:47:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] driver: usb: nullify dangling pointer in cdc_ncm_free
Content-Language: en-US
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com,
        USB <linux-usb@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20220409120901.267526-1-dzm91@hust.edu.cn>
 <YlQbqnYP/jcYinvz@hovoldconsulting.com>
 <CAHp75VeTqmdLhavZ+VbBYSFMDHr0FG4iKFGdbzE-wo5MCNikAA@mail.gmail.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <CAHp75VeTqmdLhavZ+VbBYSFMDHr0FG4iKFGdbzE-wo5MCNikAA@mail.gmail.com>
X-ClientProxiedBy: AM6PR10CA0093.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::34) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0778b15-9213-49ec-ebd8-08da21fa69a1
X-MS-TrafficTypeDiagnostic: AM6PR04MB6661:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB66611C2D617F93AA3291DA0BC7F29@AM6PR04MB6661.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RkeUruYvxCVSYwMOhPKexqN0ZCv2QEJi+dJg2fSjCNOqy3tKZReB4WBsuc2ohXgGTGEGbwppDnb+/oPiU/GnGqRoAad1H7GPUFThZnbRKTNl8vCqafuRZHZoGkJcbDvUDqgY10g34MrajlsyVsupR3N4TUHnqLs5DuRO+dTwN3vNEmWZJNznQqUoyELKMhvjHEovIpUa7uZvKzGtT6xW8n/q3Mo/rj9Ql1GqpcpHbkS+/bp221WrRhmL7mybTEocoOENWJ/qD9OObHQoX45YhXywW151yJm+dGVVEyQaWq8ogvF2V5YxDSKMSq0fHVJPa10zVWm9fskk0aPyNjUhzaLetBA+FlxTeW9XcmVe/idul1iQUJHyNcQnjaURHqQIyKc2eWiNS3bxEWR0ZVSSN1n3bHa+IFF5N1n0h3BTcFElM7cFDsjjZPu1f/KI+RFbawv02ZOSCiZgMjuqocIdYq416wmf58l1hPh1UL/UxmXwzDBfAxJvF54u0RI06YBo+Q/2X2WHi4BGnowL1fgFCk7GStu2h/BlaNCZOO/82odJln80pG/ZnvkCBGG03/uKiEcahAvPthGtZ6AMGEwzNJt7PGot08mUaHcZQKIKb5oJo7mDuNWA0HN9YzidRCXyXm9m+mVnVSW5xHbF6Oxqso7uQz+E3+SzIXpaJ1DMxw99wRuqVpehTNa9Lm0cZKd6vfV4GcqjXMju0HqIpO5cdi39pqxKcLwJP6MmhBAGdUM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(8676002)(66556008)(66476007)(186003)(36756003)(8936002)(83380400001)(2616005)(2906002)(33964004)(53546011)(6512007)(54906003)(6506007)(110136005)(5660300002)(38100700002)(235185007)(4326008)(31686004)(316002)(31696002)(86362001)(6486002)(508600001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUI0WUNmZWZhTW5ScVNqUDhGVTZlSXZGc2xFcS9iMW9reHR2clg5bjVSTTFy?=
 =?utf-8?B?Tk80ZkIwRW85TUV4a1ZxL2xGeXdMUmtxMCtNeGp2Z0w4QklHZVdDQWRmTFpS?=
 =?utf-8?B?YzlvblZKcWw3T1FwV3hqN29hNVFDNFg0OVdURGxhdFg5d3BYdGhBTExrS2o4?=
 =?utf-8?B?cFNWUlhqc1FNRXhEZzJUWWlLc2M5dXVqaFhXOEVDY0E4SkVFcThPaWdVTVBF?=
 =?utf-8?B?QmNwbENPalpoYU9FNzVEVkNhT09xUHdlN3UvNlZEaGtWUVJTU2Rjd05UQmdq?=
 =?utf-8?B?L1JIdUhoMkJUcitKOFplZk0wby9VTk4ralBVR2lGc3FWMGJSSWpJWEViNHgr?=
 =?utf-8?B?SnE0OXY0T1I1RGZCM0lwRUphMlczNjd0NzV3S2dvMkdVWXJ5WXNXd3ZYVUNP?=
 =?utf-8?B?d0ROVDBrNzJ5c1k2NFRUcG1udmFGcmNuSGZlNGFIbnBETEpLTkhLOUJCcWNq?=
 =?utf-8?B?Qng3RUgrWjFtOHp0ODlGWlRnVkMzRjRSdDBlOGIrVVhlUFJhME9KdUdoL2Vo?=
 =?utf-8?B?N2JkS0d2OHB0aW5DZ2hBOE5SRE1BWTRWY2I4YWhMT0RSc3NEQW0zbSs4MjRG?=
 =?utf-8?B?cFVhbDE3dGxNeHlydkZDakVuSTJRYmw4MklRdUlJTW1KQzVmaVl1OXVpS2JG?=
 =?utf-8?B?R2ZKWkdqeVV3QmJ3ZkRsQUt2VnI1dUNmaXc1dVloTnRJTk9QV3lrUW04NTFQ?=
 =?utf-8?B?Y3R0enFXL1R6RXVDVXRzVlRlT1BwcWNQempsWVl5Q3g5MjdheFZBZi8zQnY5?=
 =?utf-8?B?b1RNY25JOWJDY0FCNDJ1ODEwalJrZk0yUTIrTkw4RmRmZXF3cU5yaVI5YUli?=
 =?utf-8?B?RFdrZ3B1MlkraGd4Q0N4K29MMkhIK3Q5bkRIUlF3dXRoR0FRVEphQkg0UUhS?=
 =?utf-8?B?SlBvenpJaEtzOU1Tb3U4T1JNY01jRWdEUXpZdTRaeXhkRTNYMmwyMEpQa3hI?=
 =?utf-8?B?VExIUmYrU2tZcHk2emxSOSsvVHhrVThJdU9zWjdveENUVnZmWHdaU0NzczFJ?=
 =?utf-8?B?bENFRzRUWWlLOUtKSGV3eDgwQkZOOTFwYXpxZDcvYlpOTno1OEF1dS9BeW5W?=
 =?utf-8?B?RG1MeEd3MzlpM2VMZ3BlTDYwSmhRdmhHd1FLd3cxUkRERlhHQmU3Y3lmc1d3?=
 =?utf-8?B?TG5Va3NuS0MvZno4Nm95VWhyVk5mSC9UT05malVON21xRTlUT2RoYTFhaWt0?=
 =?utf-8?B?YUg3emFzVm4vUjRTWTZuR3NZV2hEODNlN1NGZUltZy95ci9kUUdyQTVRd1I5?=
 =?utf-8?B?d0l1bmFEK0FkNS9lanFPcXdsZ1ZBQ0dtdWJhNHVPamdMaUN2UitHTm9ZdHJM?=
 =?utf-8?B?MnJoMjJYcUlDRTZ1UytCWTRmU1F3OVZya2tYbHNwR0dZajdselJCa3FZTWxY?=
 =?utf-8?B?MHpKSElVTWdMQmtWN3VKcUc2aFl6SzIwWkw4eXhGQURYaHJUeHZCVEtsb3c0?=
 =?utf-8?B?bDhydTdXOEdPMlhqTi9BYm91ZEpncStPcGpWS2N5ZHFlQ3V0bEJxR1FIbEJH?=
 =?utf-8?B?M2xXNmJaSVFBdUdLZkk1Wm1kTThaL1M4Vy9XaEc2ZFlWNW14NHVBSEMrM2Zo?=
 =?utf-8?B?MTl6Y2xrNkdEdXd3Lyt4c2xlcTFFcGVDTDlONjFXN0ExWTNUQXg2SDlMQVB0?=
 =?utf-8?B?bmxvUk9CZDVVL1ZOM1IzdVNJM3hTQStLVGhsRjFRN1lwOVFWN1Jzcmt1c0Ux?=
 =?utf-8?B?ZEVIOWNzMjZnTjNnai9yUi9vMnB1TUhhRVpEdm02Y2FtZ28rM0cxZkQxRE5J?=
 =?utf-8?B?MlRaZXRySG1RWmdhVHJDSEE2Q2lnaStHb242Rk1XdUMrUTc0L0ozcWtKR0di?=
 =?utf-8?B?eGx4NDY5SGYrMjJ0Rmpab0NScHJUVDh2TkxlZkdsektGazFnTWpEN2hKZm4z?=
 =?utf-8?B?MmFiSVEyQTIxRzBqN09Qd3BmQU5iTmRQOGlURzVVSGNHSWk4MUtjaDRCd2dD?=
 =?utf-8?B?dGVwSSt2OENROUZoZy9NaVNjbk1HcU9jL1N4c1NMd2d4dE5pNGN0ZE95UEUy?=
 =?utf-8?B?RjVMaUwvR3Z1MldpbXZHNFhvdzhSVVhuV2NjaUorTmorbXJsRTJsVmwwU3RG?=
 =?utf-8?B?UXREVVRsdDQ3TmxCK3ZJSHkvUkcwNElMS0RURWh3RVVoMTdmM2I0MGNlSWM4?=
 =?utf-8?B?alVYMjZVbkpRWUlWQlhFZkpvc1JzK3pBRkZ1MENXdmdISUZuTW0zMitScXcv?=
 =?utf-8?B?c2lPd1c2a2VjbHltQmR3c1ZOYTZnbFkwVUcwNnpuV2ROR2pONEVIODZpQU40?=
 =?utf-8?B?dWIrWDVocm9ocVpkVHRoYktScCtqRkVpY1czNkxMSkcyVlNaUjVkWU1FeGJi?=
 =?utf-8?B?SXNOR1N6V3lXcmJ2VlIxb0p2NTFrYVpvZ3M2S2ZUT09zL2tUNHNVdFRtTFVD?=
 =?utf-8?Q?M3m4MATLR/qdxrtxG6hW29YORllr0Yp749QGq7TRebTwz?=
X-MS-Exchange-AntiSpam-MessageData-1: XXBCU71ea3SEVA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0778b15-9213-49ec-ebd8-08da21fa69a1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:47:42.6137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vtwpq1ebKMiZcESaKHYrNqwDio7aJm1d3UPJKvEkWhdKwdMmtM/3EMp3Hym7yMQgpNl/UfJYOsGKR84KLLw2Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6661
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------9TpvbyysGbGnJ9PxZsbqPstO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 14.04.22 17:01, Andy Shevchenko wrote:
>
> Good question. Isn't it the commit 2c9d6c2b871d ("usbnet: run unbind()
> before unregister_netdev()") which changed the ordering of the
> interface shutdown and basically makes this race happen? I don't see
> how we can guarantee that IOCTL won't be called until we quiescence
> the network device — my understanding that on device surprise removal
True. The best we could do is introduce a mutex for ioctl() and
disconnect(). That seems the least preferable solution to me.
> we have to first shutdown what it created and then unbind the device.
> If I understand the original issue correctly then the problem is in
> usbnet->unbind and it should actually be split to two hooks, otherwise
> it seems every possible IOCTL callback must have some kind of
> reference counting and keep an eye on the surprise removal.
>
> Johan, can you correct me if my understanding is wrong?
>
It seems to me that fundamentally the order of actions to handle
a hotunplug must mirror the order in a hotplug. We can add more hooks
if that turns out to be necessary for some drivers, but the basic
reverse mirrored order must be supported and I very much favor
restoring it as default.

So I am afraid I have to ask again, whether anybody sees a fundamental
issue with the attached patch, as opposed to it not being an elegant
solution?
It looks to me that we are in a fundamental disagreement on the correct
order in this question and there is no productive way forward other than
offering both ways.

    Regards
        Oliver

--------------9TpvbyysGbGnJ9PxZsbqPstO
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-usbnet-split-unbind-callback.patch"
Content-Disposition: attachment;
 filename="0001-usbnet-split-unbind-callback.patch"
Content-Transfer-Encoding: base64

RnJvbSAyZTA3Y2NiZDE3Njk4ODk5NjNkMTI5ZWM0NzQ5MDliZGNhYTRjNjRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPgpEYXRl
OiBUaHUsIDEwIE1hciAyMDIyIDEzOjE4OjM4ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gdXNibmV0
OiBzcGxpdCB1bmJpbmQgY2FsbGJhY2sKClNvbWUgZGV2aWNlcyBuZWVkIHRvIGJlIGluZm9ybWVk
IG9mIGEgZGlzY29ubmVjdCBiZWZvcmUKdGhlIGdlbmVyaWMgbGF5ZXIgaXMgaW5mb3JtZWQsIG90
aGVycyBuZWVkIHRoZWlyIG5vdGlmaWNhdGlvbgpsYXRlciB0byBhdm9pZCByYWNlIGNvbmRpdGlv
bnMuIEhlbmNlIHdlIHByb3ZpZGUgdHdvIGNhbGxiYWNrcy4KClNpZ25lZC1vZmYtYnk6IE9saXZl
ciBOZXVrdW0gPG9uZXVrdW1Ac3VzZS5jb20+Ci0tLQogZHJpdmVycy9uZXQvdXNiL2FzaXhfZGV2
aWNlcy5jIHwgOCArKysrLS0tLQogZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMgICAgIHwgNCAr
Ky0tCiBkcml2ZXJzL25ldC91c2IvdXNibmV0LmMgICAgICAgfCA3ICsrKysrLS0KIGluY2x1ZGUv
bGludXgvdXNiL3VzYm5ldC5oICAgICB8IDMgKysrCiA0IGZpbGVzIGNoYW5nZWQsIDE0IGluc2Vy
dGlvbnMoKyksIDggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNiL2Fz
aXhfZGV2aWNlcy5jIGIvZHJpdmVycy9uZXQvdXNiL2FzaXhfZGV2aWNlcy5jCmluZGV4IDZlYTQ0
ZTUzNzEzYS4uZTZjZmE5YTM5YTg3IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC91c2IvYXNpeF9k
ZXZpY2VzLmMKKysrIGIvZHJpdmVycy9uZXQvdXNiL2FzaXhfZGV2aWNlcy5jCkBAIC04MDgsNyAr
ODA4LDcgQEAgc3RhdGljIGludCBheDg4NzcyX3N0b3Aoc3RydWN0IHVzYm5ldCAqZGV2KQogCXJl
dHVybiAwOwogfQogCi1zdGF0aWMgdm9pZCBheDg4NzcyX3VuYmluZChzdHJ1Y3QgdXNibmV0ICpk
ZXYsIHN0cnVjdCB1c2JfaW50ZXJmYWNlICppbnRmKQorc3RhdGljIHZvaWQgYXg4ODc3Ml9kaXNh
YmxlKHN0cnVjdCB1c2JuZXQgKmRldiwgc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYpCiB7CiAJ
c3RydWN0IGFzaXhfY29tbW9uX3ByaXZhdGUgKnByaXYgPSBkZXYtPmRyaXZlcl9wcml2OwogCkBA
IC0xMjE0LDcgKzEyMTQsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGRyaXZlcl9pbmZvIGhhd2tp
bmdfdWYyMDBfaW5mbyA9IHsKIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHJpdmVyX2luZm8gYXg4ODc3
Ml9pbmZvID0gewogCS5kZXNjcmlwdGlvbiA9ICJBU0lYIEFYODg3NzIgVVNCIDIuMCBFdGhlcm5l
dCIsCiAJLmJpbmQgPSBheDg4NzcyX2JpbmQsCi0JLnVuYmluZCA9IGF4ODg3NzJfdW5iaW5kLAor
CS51bmJpbmQgPSBheDg4NzcyX2Rpc2FibGUsCiAJLnN0YXR1cyA9IGFzaXhfc3RhdHVzLAogCS5y
ZXNldCA9IGF4ODg3NzJfcmVzZXQsCiAJLnN0b3AgPSBheDg4NzcyX3N0b3AsCkBAIC0xMjI2LDcg
KzEyMjYsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGRyaXZlcl9pbmZvIGF4ODg3NzJfaW5mbyA9
IHsKIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHJpdmVyX2luZm8gYXg4ODc3MmJfaW5mbyA9IHsKIAku
ZGVzY3JpcHRpb24gPSAiQVNJWCBBWDg4NzcyQiBVU0IgMi4wIEV0aGVybmV0IiwKIAkuYmluZCA9
IGF4ODg3NzJfYmluZCwKLQkudW5iaW5kID0gYXg4ODc3Ml91bmJpbmQsCisJLnVuYmluZCA9IGF4
ODg3NzJfZGlzYWJsZSwKIAkuc3RhdHVzID0gYXNpeF9zdGF0dXMsCiAJLnJlc2V0ID0gYXg4ODc3
Ml9yZXNldCwKIAkuc3RvcCA9IGF4ODg3NzJfc3RvcCwKQEAgLTEyNjIsNyArMTI2Miw3IEBAIHN0
YXRpYyBjb25zdCBzdHJ1Y3QgZHJpdmVyX2luZm8gYXg4ODE3OF9pbmZvID0gewogc3RhdGljIGNv
bnN0IHN0cnVjdCBkcml2ZXJfaW5mbyBoZzIwZjlfaW5mbyA9IHsKIAkuZGVzY3JpcHRpb24gPSAi
SEcyMEY5IFVTQiAyLjAgRXRoZXJuZXQiLAogCS5iaW5kID0gYXg4ODc3Ml9iaW5kLAotCS51bmJp
bmQgPSBheDg4NzcyX3VuYmluZCwKKwkudW5iaW5kID0gYXg4ODc3Ml9kaXNhYmxlLAogCS5zdGF0
dXMgPSBhc2l4X3N0YXR1cywKIAkucmVzZXQgPSBheDg4NzcyX3Jlc2V0LAogCS5mbGFncyA9IEZM
QUdfRVRIRVIgfCBGTEFHX0ZSQU1JTkdfQVggfCBGTEFHX0xJTktfSU5UUiB8CmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC91c2Ivc21zYzk1eHguYyBiL2RyaXZlcnMvbmV0L3VzYi9zbXNjOTV4eC5j
CmluZGV4IDU1NjcyMjBlOWQxNi4uNjJkYjU3MDIxZjVmIDEwMDY0NAotLS0gYS9kcml2ZXJzL25l
dC91c2Ivc21zYzk1eHguYworKysgYi9kcml2ZXJzL25ldC91c2Ivc21zYzk1eHguYwpAQCAtMTIx
MSw3ICsxMjExLDcgQEAgc3RhdGljIGludCBzbXNjOTV4eF9iaW5kKHN0cnVjdCB1c2JuZXQgKmRl
diwgc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYpCiAJcmV0dXJuIHJldDsKIH0KIAotc3RhdGlj
IHZvaWQgc21zYzk1eHhfdW5iaW5kKHN0cnVjdCB1c2JuZXQgKmRldiwgc3RydWN0IHVzYl9pbnRl
cmZhY2UgKmludGYpCitzdGF0aWMgdm9pZCBzbXNjOTV4eF9kaXNhYmxlKHN0cnVjdCB1c2JuZXQg
KmRldiwgc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYpCiB7CiAJc3RydWN0IHNtc2M5NXh4X3By
aXYgKnBkYXRhID0gZGV2LT5kcml2ZXJfcHJpdjsKIApAQCAtMTk4NSw3ICsxOTg1LDcgQEAgc3Rh
dGljIGludCBzbXNjOTV4eF9tYW5hZ2VfcG93ZXIoc3RydWN0IHVzYm5ldCAqZGV2LCBpbnQgb24p
CiBzdGF0aWMgY29uc3Qgc3RydWN0IGRyaXZlcl9pbmZvIHNtc2M5NXh4X2luZm8gPSB7CiAJLmRl
c2NyaXB0aW9uCT0gInNtc2M5NXh4IFVTQiAyLjAgRXRoZXJuZXQiLAogCS5iaW5kCQk9IHNtc2M5
NXh4X2JpbmQsCi0JLnVuYmluZAkJPSBzbXNjOTV4eF91bmJpbmQsCisJLnVuYmluZAkJPSBzbXNj
OTV4eF9kaXNhYmxlLAogCS5saW5rX3Jlc2V0CT0gc21zYzk1eHhfbGlua19yZXNldCwKIAkucmVz
ZXQJCT0gc21zYzk1eHhfcmVzZXQsCiAJLmNoZWNrX2Nvbm5lY3QJPSBzbXNjOTV4eF9zdGFydF9w
aHksCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC91c2IvdXNibmV0LmMgYi9kcml2ZXJzL25ldC91
c2IvdXNibmV0LmMKaW5kZXggYjFmOTM4MTBhNmYzLi41MjQ5YTdkN2VmYTUgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbmV0L3VzYi91c2JuZXQuYworKysgYi9kcml2ZXJzL25ldC91c2IvdXNibmV0LmMK
QEAgLTE2NDEsOCArMTY0MSw4IEBAIHZvaWQgdXNibmV0X2Rpc2Nvbm5lY3QgKHN0cnVjdCB1c2Jf
aW50ZXJmYWNlICppbnRmKQogCQkgICB4ZGV2LT5idXMtPmJ1c19uYW1lLCB4ZGV2LT5kZXZwYXRo
LAogCQkgICBkZXYtPmRyaXZlcl9pbmZvLT5kZXNjcmlwdGlvbik7CiAKLQlpZiAoZGV2LT5kcml2
ZXJfaW5mby0+dW5iaW5kKQotCQlkZXYtPmRyaXZlcl9pbmZvLT51bmJpbmQoZGV2LCBpbnRmKTsK
KwlpZiAoZGV2LT5kcml2ZXJfaW5mby0+ZGlzYWJsZSkKKwkJZGV2LT5kcml2ZXJfaW5mby0+ZGlz
YWJsZShkZXYsIGludGYpOwogCiAJbmV0ID0gZGV2LT5uZXQ7CiAJdW5yZWdpc3Rlcl9uZXRkZXYg
KG5ldCk7CkBAIC0xNjUxLDYgKzE2NTEsOSBAQCB2b2lkIHVzYm5ldF9kaXNjb25uZWN0IChzdHJ1
Y3QgdXNiX2ludGVyZmFjZSAqaW50ZikKIAogCXVzYl9zY3V0dGxlX2FuY2hvcmVkX3VyYnMoJmRl
di0+ZGVmZXJyZWQpOwogCisJaWYgKGRldi0+ZHJpdmVyX2luZm8tPnVuYmluZCkKKwkJZGV2LT5k
cml2ZXJfaW5mby0+dW5iaW5kIChkZXYsIGludGYpOworCiAJdXNiX2tpbGxfdXJiKGRldi0+aW50
ZXJydXB0KTsKIAl1c2JfZnJlZV91cmIoZGV2LT5pbnRlcnJ1cHQpOwogCWtmcmVlKGRldi0+cGFk
ZGluZ19wa3QpOwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC91c2IvdXNibmV0LmggYi9pbmNs
dWRlL2xpbnV4L3VzYi91c2JuZXQuaAppbmRleCA4MzM2ZTg2Y2U2MDYuLjRkMjQwN2YxYWU5MyAx
MDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC91c2IvdXNibmV0LmgKKysrIGIvaW5jbHVkZS9saW51
eC91c2IvdXNibmV0LmgKQEAgLTEyOSw2ICsxMjksOSBAQCBzdHJ1Y3QgZHJpdmVyX2luZm8gewog
CS8qIGNsZWFudXAgZGV2aWNlIC4uLiBjYW4gc2xlZXAsIGJ1dCBjYW4ndCBmYWlsICovCiAJdm9p
ZAkoKnVuYmluZCkoc3RydWN0IHVzYm5ldCAqLCBzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqKTsKIAor
CS8qIGRpc2FibGUgZGV2aWNlIC4uLiBjYW4gc2xlZXAsIGJ1dCBjYW4ndCBmYWlsICovCisJdm9p
ZAkoKmRpc2FibGUpKHN0cnVjdCB1c2JuZXQgKiwgc3RydWN0IHVzYl9pbnRlcmZhY2UgKik7CisK
IAkvKiByZXNldCBkZXZpY2UgLi4uIGNhbiBzbGVlcCAqLwogCWludAkoKnJlc2V0KShzdHJ1Y3Qg
dXNibmV0ICopOwogCi0tIAoyLjM0LjEKCg==

--------------9TpvbyysGbGnJ9PxZsbqPstO--

