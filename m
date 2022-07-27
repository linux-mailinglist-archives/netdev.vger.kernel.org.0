Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5B45825C7
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiG0Lj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiG0Lju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:39:50 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150047.outbound.protection.outlook.com [40.107.15.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCB14A817;
        Wed, 27 Jul 2022 04:39:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpYM7oXPOHTY0kVAVRwDF/2fub/hO5Db/MFaSeZHxPms/JJVAQnueOJXGjJoSGxuUstc8UQlbsp1tPn05INfeIvPlOaZYVzJ6Agorq8M+04Ff8ML7qGkK178De1XGMZl/DmtuARHTpvG8C8nmX0tjSfMq8q0ZJxz70tDT4TH7avyRHBtMZwStKb1OAEyDrCO/McEcWEz3Sgxxn6xoxJ9jF/LsHHgNk2bnA44COemn8WYQRIKQKGwZcHDFP6gqmq2yZa31WrdAuep9eGGTqKO190Q6j/YiYNfIFQth8ibKXS4OoGP0b47Mxq8WMMLwgaRTagcYmMh3Lpfb7kr26f7GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJp0V+0kY8rdq0JAprqzgWILm1S7hYossD2/Gky3V/U=;
 b=kg65X1x4QYtFfmtM+DjvB99Ax4XZa0VspNx7W0/ztBH71wzfvWJN1ocKtzA3A47nJaZ7Y7JHtaGwCPgDhpWE8YurOz8zHml4ngTczPQjvy7iubaAXFmnaGHxdXxFP1DRv1v/IGwRIoK8eSSsT3E4X8GTWEzQhFio4TImDNEsWMbCWXG0hF1L++PWFgOxsOHU5QsdXGdkOwdl3jO1Yl+/43SMLEtS/fca8h2H8/M2D+RSDKp3SuzKFlnffzcFjWFsqQAZ38BjtFqFk4lTNhs73J+6Qcig8KbdRvLWMaTmXMqtrXhiB9GsECsbUqHz4vBYX6Q7WNLRaKAtqCLUzLV0Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJp0V+0kY8rdq0JAprqzgWILm1S7hYossD2/Gky3V/U=;
 b=hW9WSM9Aku7lO3u8xKdWMDvUMm6/IA15ZkjR4kb4UnRxBKGhqL4PvUjYfNjTA6NDXHsIbDUS7Y7xRd42Zw1qK7yQcjgKMnzQ6w7zisuBUVaG6TvOoqJ0QaFy0MHKn7ccP2oNn6Wkdej8VT4ZWkHXyZn1evPtUo9p1AVY4K6XxB+DkJTHgDfVJ4bc/LRlNlna7VvlUldN+qpYfztRLUZ5MAYo1Y0sSxKqycm3Gac3MJ0QvN7+FQ49yj3LXY8O7m4RjnCTKwbTzVpWZaZXTvwGo70h3SfB6MoU8YqNpxVg1Bvs8SzqYKcsQ/Pa4I5dTg0GLrGEDJefCW2N7nNC+zmjUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM5PR0401MB2641.eurprd04.prod.outlook.com
 (2603:10a6:203:3b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Wed, 27 Jul
 2022 11:39:46 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d%12]) with mapi id 15.20.5458.025; Wed, 27 Jul
 2022 11:39:45 +0000
Content-Type: multipart/mixed; boundary="------------jCij2OgBQPxWGCCUA4k9mDnL"
Message-ID: <2397d98d-e373-1740-eb5f-8fe795a0352a@suse.com>
Date:   Wed, 27 Jul 2022 13:39:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To:     Hayes Wang <hayeswang@realtek.com>
Content-Language: en-US
Cc:     USB list <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Oliver Neukum <oneukum@suse.com>
Subject: handling MAC set by user space in reset_resume() of r8152
X-ClientProxiedBy: AM5PR0602CA0023.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::33) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 878a704a-b862-436a-cf54-08da6fc4b440
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2641:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VTvRw8vMGtpj49zK8vDqYvyVFhyPbY+YnfnEr2eVDI42wot9QHkwdfjOu1olzJ9Wn/T5mR3scrbQw74g653M9oqStjEXqtXMM45MMjH6ah4o1/TksISP38JHsjWhjTMEEELAUIeipHJulqxAByW9h7AcOUhU72v8Oe2aFXxZVK62yqD8hYB0AjAWi25apmcbjjrqg6ceZfrT1B+E9FsPinv6og5H5Rf+R2NPErUyNPskoCV6tJ2RZ8zdOyOGBusPv8QNhinTOyMoLLY0t/lkZbH+f7ABm5bjz7sgGT3Mm2dJcpamac1wqWXb7JbAxW0uKfZYKJd+e7wNkF0m5Nl6CQ5tzdKcHR3dgkbK/hHrsgP1cTVcQcX+LI0/i/IYTWNRhzrh9XMYujN1l48gTUkEZtmH4C6h/JtGt4vOV9XQxPhXeFYc4VbuOWU8HwlhF7rKA0gFUYsqIbRvXTjXZcx8jk4QNLVcI19SmQeLGEFxgb+k1hLwm69f8esBlWw8FYER59XdO+T/0I5yflqzrlvqiExd/UivBc6hkJzVDEjR5IMNu3nknKp3SfoNcC6rXj8S1dtfu9llYMxHx/s4fMXMjO8wWE2TwG8m4FKkNsX+1OkAMKIuS+eS9yU7qJvs1dH3wCzAihJq2NrvlAjVJe9ev/0FJruCdb1l4LxC4Van059W0+CN+m8jBRBWZz24bLxICSSVuwGHkKRK1igMpRBn6+kHmvdr18m1AAn2TvJzoy49RgLqCNl0K1Y+RCRH3IL0zwSBtN8VRlQUailhvC+p+2vMKnOQmsWuD7G1wcbD5rUz1miKePMpwaFm37LcOPgGirYjmSjRh33mPX3r/24L8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(376002)(396003)(366004)(136003)(36756003)(4326008)(8676002)(66946007)(66556008)(66476007)(235185007)(186003)(6486002)(54906003)(6916009)(6506007)(33964004)(2616005)(316002)(31686004)(83380400001)(564344004)(38100700002)(478600001)(86362001)(6512007)(8936002)(2906002)(41300700001)(31696002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEcwR3FQTkI1UmdPWWJFUVlqTXhabVJzSkNTMXJVdkRIaWU4c3F4QVoxTWRC?=
 =?utf-8?B?M2lvNE94WksrTmZRWVdrV3VzbXdUUFIvK1dXR1NxS3M4bzlmcXdybExBbnZ3?=
 =?utf-8?B?Znd0NDR0a1FYWG9FcFhkbnNGTk9NYnp5c0UzU3lvSmRFUm01U3FBS0N1bVJp?=
 =?utf-8?B?L0ZmcHRNbzFkeFVsOGMzMzVJd2lWU1ByUUx4YUhocDdXMVIwQUIzNVltNjhJ?=
 =?utf-8?B?U0RMcG12QzhCZjNrYzBMMzdQVW5jc3VQcDhNR1FRQjM3N3FRRjFCWkFYUlUv?=
 =?utf-8?B?UnNPa3dZOUVaODYzYS9HbEVGa1hCSENnRHlDU2E2WU5WbjFidzZhUkptaldU?=
 =?utf-8?B?WVVmbUxQZVdvK0R2VkRCSEdtUFpiQnMvWDF5cEQ1aFhxenkzUVFSc1YzUUZa?=
 =?utf-8?B?YmZ3Zm4xbnRSVFlXQmtIbWZRYXhlSUgrNG9TWVFHYjY5UVliODZ4TGtLUUVx?=
 =?utf-8?B?TENsTmhWTG9lSEZzcEV2Rzlra2dtTytQY1JNN2t5SVZzbFVUd2RzMXArYzhV?=
 =?utf-8?B?WDZ1eTRSZDdENkFoQ0RmdHZiKzZ1UVQ1Rnlad1hBTmk1akZIb0lGOTdvUEZD?=
 =?utf-8?B?eWpBNEh5WjBUOUpYSkZCNzZ2bkRsSEUxRGFyVGYwSWVZK2xHWHJYNnhQck1C?=
 =?utf-8?B?bWh0eklVd3hwMzUzZDVOREgwd1I1QjJabXNVbzJtRHM3bkoyelI2MUVrbWZ1?=
 =?utf-8?B?Ry81bzNzV2p1T2IyVTZYYVY2Q2JTY2UvdjVUcHNNY244MndkTlpqK0pXRjJn?=
 =?utf-8?B?c0FLS2RUODdKcE1tWXJjTzhXbTFwMmsxUDNpUTY4ek1XbThTUWJRZ3pDbjVM?=
 =?utf-8?B?aUthZWRSNW53amRoYk1UU3VmRnBjQUF2aW1xMGJpZjc3N1BoRkZoYXFVL3Vn?=
 =?utf-8?B?N3NxZDRCM0NKK1U0M3dROW5PSXBKdjZkR1RnaG1WMjdzUXhrdkFZemIvVFl3?=
 =?utf-8?B?anRyaDhVWmJIQlI4OFVpTVpFMWROZ3dXclYzcHJSakRRTkxSQzJSMkNPZ2gw?=
 =?utf-8?B?NWIrTjdoTVZWMjNGeVlCM1FWU0E1aXBLY0QxWmtPR0krc0FmaU5DUHQzK0Zr?=
 =?utf-8?B?bTlHQnc2a3RQdUZSUDN0Q3hQa2h6WStiVmlsZHpyMFJPSUI5RnY5OGNxc2Fi?=
 =?utf-8?B?RG45S1RCL1NSakFKQzNPTFE2a2RSQi9tL2I0NTdTZE14bFIzR0JRK1N1MlY4?=
 =?utf-8?B?b1ZnL1pNTUJIMXBwUkQ0ZjFucUhwMHhEdmtUbjFOMHVJMC8ya0pFTDdIVkRn?=
 =?utf-8?B?Q2hvSkVZMFNlOUxydXVrTUhGTWl2OFN4S1Q5aXo1R1g3VURIdExqSDdHRUVT?=
 =?utf-8?B?dTNUZkR6dllTdktmZ2MrZFFIVEJKVHo4NUVreWlBK241OWJpSGp1R2Vqc0Jz?=
 =?utf-8?B?REFqK1lBa2tjeTBRZkszOVhCMGtTRFNXa0ZIdytyRjM3NDhqSml4MXlCaGJD?=
 =?utf-8?B?dXBuZVBlQ2JlR1JWY2pTK28rd04zdFJWaEROWVpVc2svQjB0YUt0ZU56Qlgw?=
 =?utf-8?B?QlpzUzVsZXRQTWw2QkpSTXQrdEZsdHlTWDloaTlHeHRpR0F3ZUEvdnZudU1K?=
 =?utf-8?B?anRWMTRwWjY2UlFsOGRTMmY4L1pRRDR1ZlJ1UklubUtIUjlkb3VMY0V0VWEw?=
 =?utf-8?B?YThxTk9Tb0swR3FXVmpkc0M0L3E1UzVSVWJ2RHhHMFRZZnRub1pzZmd1VWN2?=
 =?utf-8?B?SGMwaERjUndRMFV0VWtPTDgvY3VFdktUU3kyb3ZxMFlYUXlTQzNVNFJRdkZW?=
 =?utf-8?B?V1ZpdERaREE4R044WlRDaGt6c1RuT1pCZkEwa3diU1NpVHZwd291eFNySVVD?=
 =?utf-8?B?dmpGOVdDZTN0Qm1VYVkxcXJ0MHFONjZsaDRtTFNvQjJ1ekRTV1Z4REdNRDN0?=
 =?utf-8?B?akFQQ1dEV1VXdGZwKzF0U2M1Z3ZzRG0yUXRIMGg4TG9aUy8vMGFOekkwZ3Nm?=
 =?utf-8?B?dDVNdTNPaUJrNVlNbHZzcHAxWlIraUhNM293K0xPWmF1TEFYemx4WUpiYURG?=
 =?utf-8?B?LzhhT2JDNThWc1Nld1Z4d0U5UjlwSjN0K2d6eXJ4Um1ScmtUQjRTUG15bVJD?=
 =?utf-8?B?VGovdHZzY0FPd1lmVlVBcit6WnIrNEhnSVd0WkRlUnNQWjlzd2lDVWM5YmFy?=
 =?utf-8?B?YTYvajBsbk93UVJGOWR4bTRqSUR0VC9xdjFoT3dVZ1VxT2s0VDRJeTJQYnVy?=
 =?utf-8?Q?pY0msAKJSoHJyQvbBT+hh28MD3dNshLN7JA7OUmTvOOr?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878a704a-b862-436a-cf54-08da6fc4b440
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 11:39:45.7734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vK0yDHpEVvq7rqZX+YbXK4ryiAmMud5oN7hsrJhPPBFqBBVBwOYWtg9aqtKMHWinzFqGErq7shPqX+K++Nht2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2641
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------jCij2OgBQPxWGCCUA4k9mDnL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

looking at the driver it looks to me like the address
provided to ndo_set_mac_address() is thrown away after use.
That looks problematic to me, because reset_resume()
should redo the operation.
What do you think?

	Regards
		Oliver
--------------jCij2OgBQPxWGCCUA4k9mDnL
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-r8152-restore-external-MAC-in-reset_resume.patch"
Content-Disposition: attachment;
 filename="0001-r8152-restore-external-MAC-in-reset_resume.patch"
Content-Transfer-Encoding: base64

RnJvbSAxOWZjOTcyYTVjYzk4MTk3YmM4MWE3YzU2ZGQ1ZDY4ZTNmZGZjMzZiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPgpEYXRl
OiBXZWQsIDI3IEp1bCAyMDIyIDEzOjI5OjQyICswMjAwClN1YmplY3Q6IFtQQVRDSF0gcjgxNTI6
IHJlc3RvcmUgZXh0ZXJuYWwgTUFDIGluIHJlc2V0X3Jlc3VtZQoKSWYgdXNlciBzcGFjZSBoYXMg
c2V0IHRoZSBNQUMgb2YgdGhlIGludGVyZmFjZSwKcmVzZXRfcmVzdW1lKCkgbXVzdCByZXN0b3Jl
IHRoYXQgc2V0dGluZyByYXRoZXIKdGhhbiByZWRldGVybWluZSB0aGUgTUFDIGxpa2UgaWYgdGUg
aW50ZXJmYWNlCmlzIHByb2JlZCByZWd1bGFybHkuCgpTaWduZWQtb2ZmLWJ5OiBPbGl2ZXIgTmV1
a3VtIDxvbmV1a3VtQHN1c2UuY29tPgotLS0KIGRyaXZlcnMvbmV0L3VzYi9yODE1Mi5jIHwgMzQg
KysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDI1IGlu
c2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNi
L3I4MTUyLmMgYi9kcml2ZXJzL25ldC91c2IvcjgxNTIuYwppbmRleCAwZjZlZmFhYmFhMzIuLjVj
Zjc0Yjk4NDY1NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvdXNiL3I4MTUyLmMKKysrIGIvZHJp
dmVycy9uZXQvdXNiL3I4MTUyLmMKQEAgLTkyMyw2ICs5MjMsNyBAQCBzdHJ1Y3QgcjgxNTIgewog
CWF0b21pY190IHJ4X2NvdW50OwogCiAJYm9vbCBlZWVfZW47CisJYm9vbCBleHRlcm5hbF9tYWM7
CiAJaW50IGludHJfaW50ZXJ2YWw7CiAJdTMyIHNhdmVkX3dvbG9wdHM7CiAJdTMyIG1zZ19lbmFi
bGU7CkBAIC05MzMsNiArOTM0LDggQEAgc3RydWN0IHI4MTUyIHsKIAl1MzIgcnhfY29weWJyZWFr
OwogCXUzMiByeF9wZW5kaW5nOwogCXUzMiBmY19wYXVzZV9vbiwgZmNfcGF1c2Vfb2ZmOworCS8q
IGZvciByZXNldF9yZXN1bWUgKi8KKwlzdHJ1Y3Qgc29ja2FkZHIgc2F2ZWRfYWRkcjsKIAogCXVu
c2lnbmVkIGludCBwaXBlX2luLCBwaXBlX291dCwgcGlwZV9pbnRyLCBwaXBlX2N0cmxfaW4sIHBp
cGVfY3RybF9vdXQ7CiAKQEAgLTE1NzQsNiArMTU3Nyw3IEBAIHN0YXRpYyBpbnQgX19ydGw4MTUy
X3NldF9tYWNfYWRkcmVzcyhzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCB2b2lkICpwLAogCW11
dGV4X2xvY2soJnRwLT5jb250cm9sKTsKIAogCWV0aF9od19hZGRyX3NldChuZXRkZXYsIGFkZHIt
PnNhX2RhdGEpOworCW1lbWNweSgmdHAtPnNhdmVkX2FkZHIsIGFkZHIsIHNpemVvZih0cC0+c2F2
ZWRfYWRkcikpOwogCiAJb2NwX3dyaXRlX2J5dGUodHAsIE1DVV9UWVBFX1BMQSwgUExBX0NSV0VD
UiwgQ1JXRUNSX0NPTkZJRyk7CiAJcGxhX29jcF93cml0ZSh0cCwgUExBX0lEUiwgQllURV9FTl9T
SVhfQllURVMsIDgsIGFkZHItPnNhX2RhdGEpOwpAQCAtMTU4OSw3ICsxNTkzLDEzIEBAIHN0YXRp
YyBpbnQgX19ydGw4MTUyX3NldF9tYWNfYWRkcmVzcyhzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2
LCB2b2lkICpwLAogCiBzdGF0aWMgaW50IHJ0bDgxNTJfc2V0X21hY19hZGRyZXNzKHN0cnVjdCBu
ZXRfZGV2aWNlICpuZXRkZXYsIHZvaWQgKnApCiB7Ci0JcmV0dXJuIF9fcnRsODE1Ml9zZXRfbWFj
X2FkZHJlc3MobmV0ZGV2LCBwLCBmYWxzZSk7CisJaW50IHJ2OworCXN0cnVjdCByODE1MiAqdHAg
PSBuZXRkZXZfcHJpdihuZXRkZXYpOworCisJcnYgPSAgX19ydGw4MTUyX3NldF9tYWNfYWRkcmVz
cyhuZXRkZXYsIHAsIGZhbHNlKTsKKwlpZiAoIXJ2KQorCQl0cC0+ZXh0ZXJuYWxfbWFjID0gdHJ1
ZTsKKwlyZXR1cm4gcnY7CiB9CiAKIC8qIERldmljZXMgY29udGFpbmluZyBwcm9wZXIgY2hpcHMg
Y2FuIHN1cHBvcnQgYSBwZXJzaXN0ZW50CkBAIC0xNjc2LDEwICsxNjg2LDE0IEBAIHN0YXRpYyBp
bnQgdmVuZG9yX21hY19wYXNzdGhydV9hZGRyX3JlYWQoc3RydWN0IHI4MTUyICp0cCwgc3RydWN0
IHNvY2thZGRyICpzYSkKIHN0YXRpYyBpbnQgZGV0ZXJtaW5lX2V0aGVybmV0X2FkZHIoc3RydWN0
IHI4MTUyICp0cCwgc3RydWN0IHNvY2thZGRyICpzYSkKIHsKIAlzdHJ1Y3QgbmV0X2RldmljZSAq
ZGV2ID0gdHAtPm5ldGRldjsKLQlpbnQgcmV0OworCWludCByZXQgPSAwOwogCiAJc2EtPnNhX2Zh
bWlseSA9IGRldi0+dHlwZTsKIAorCWlmICh0cC0+ZXh0ZXJuYWxfbWFjKSB7CisJCWV0aGVyX2Fk
ZHJfY29weShzYS0+c2FfZGF0YSwgZGV2LT5kZXZfYWRkcik7CisJCXJldHVybiByZXQ7CisJfQog
CXJldCA9IGV0aF9wbGF0Zm9ybV9nZXRfbWFjX2FkZHJlc3MoJnRwLT51ZGV2LT5kZXYsIHNhLT5z
YV9kYXRhKTsKIAlpZiAocmV0IDwgMCkgewogCQlpZiAodHAtPnZlcnNpb24gPT0gUlRMX1ZFUl8w
MSkgewpAQCAtMTcxMywxNyArMTcyNywxOCBAQCBzdGF0aWMgaW50IGRldGVybWluZV9ldGhlcm5l
dF9hZGRyKHN0cnVjdCByODE1MiAqdHAsIHN0cnVjdCBzb2NrYWRkciAqc2EpCiBzdGF0aWMgaW50
IHNldF9ldGhlcm5ldF9hZGRyKHN0cnVjdCByODE1MiAqdHAsIGJvb2wgaW5fcmVzdW1lKQogewog
CXN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSB0cC0+bmV0ZGV2OwotCXN0cnVjdCBzb2NrYWRkciBz
YTsKLQlpbnQgcmV0OworCWludCByZXQgPSAwOwogCi0JcmV0ID0gZGV0ZXJtaW5lX2V0aGVybmV0
X2FkZHIodHAsICZzYSk7Ci0JaWYgKHJldCA8IDApCi0JCXJldHVybiByZXQ7CisJaWYgKCF0cC0+
ZXh0ZXJuYWxfbWFjKSB7CisJCXJldCA9IGRldGVybWluZV9ldGhlcm5ldF9hZGRyKHRwLCAmdHAt
PnNhdmVkX2FkZHIpOworCQlpZiAocmV0IDwgMCkKKwkJCXJldHVybiByZXQ7CisJfQogCiAJaWYg
KHRwLT52ZXJzaW9uID09IFJUTF9WRVJfMDEpCi0JCWV0aF9od19hZGRyX3NldChkZXYsIHNhLnNh
X2RhdGEpOworCQlldGhfaHdfYWRkcl9zZXQoZGV2LCB0cC0+c2F2ZWRfYWRkci5zYV9kYXRhKTsK
IAllbHNlCi0JCXJldCA9IF9fcnRsODE1Ml9zZXRfbWFjX2FkZHJlc3MoZGV2LCAmc2EsIGluX3Jl
c3VtZSk7CisJCXJldCA9IF9fcnRsODE1Ml9zZXRfbWFjX2FkZHJlc3MoZGV2LCAmdHAtPnNhdmVk
X2FkZHIsIGluX3Jlc3VtZSk7CiAKIAlyZXR1cm4gcmV0OwogfQpAQCAtNjIyNSw2ICs2MjQwLDcg
QEAgc3RhdGljIHZvaWQgcnRsODE1Ml9kb3duKHN0cnVjdCByODE1MiAqdHApCiAJcjgxNTJfYWxk
cHNfZW4odHAsIGZhbHNlKTsKIAlyODE1MmJfZW50ZXJfb29iKHRwKTsKIAlyODE1Ml9hbGRwc19l
bih0cCwgdHJ1ZSk7CisJdHAtPmV4dGVybmFsX21hYyA9IGZhbHNlOwogfQogCiBzdGF0aWMgdm9p
ZCBydGw4MTUzX3VwKHN0cnVjdCByODE1MiAqdHApCi0tIAoyLjM1LjMKCg==

--------------jCij2OgBQPxWGCCUA4k9mDnL--
