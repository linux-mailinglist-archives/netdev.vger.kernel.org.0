Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FCB509E6A
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 13:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388754AbiDULVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 07:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiDULVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 07:21:47 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2999417064
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 04:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1650539935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kr15DjI7zOA058z/UiuWHCEBCwadPpMwW+Jxqd+VdfQ=;
        b=AZlzV2jiB8k7LznEHBtiM8iPvI1WKHKse4XEZxw9sFNAbV+idCKGFHJvd/8+5Mb1/Tt0qH
        pOOwwHHtCptgxY2gd7x7g9iAso+82BuHZY3QJBfc488DxCkFomTSahGLI4evZ+MQghfH/Z
        6SCKuSd+zuKYtY13kF0VyTRCtTrTcWc=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2110.outbound.protection.outlook.com [104.47.18.110]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-29-uCHQ4-mzNQORL2m1VQCOzQ-1; Thu, 21 Apr 2022 13:18:51 +0200
X-MC-Unique: uCHQ4-mzNQORL2m1VQCOzQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llir65PuTEk2qpbHte2LLiPqdJPXli83U1jth8yLcGoAFS3uDlpmkuDTK+9PYUARt0up+QRnfseT4bCat3zIg2VDNCC9c1UWquI3Mq+JD8QmFIrhr8H0AEENYewfyQ4uuOYsldatMGvRIvmK+8LQ7OUQflL33XJ7LVihxxeJSiu7nsf5zBFKZNsygHlTxmwH4mub79S2d9T3vxG7YTuFTVosfwXfCnW8ml8XtoTJ0FF7AD5iftTe+GvtS9I9tbo2e7Vf85lyW1NPISpsd5oENjcb1InOzziTIQ4pfJ7Q1vR2FibyGZhGDhxKQfbdtwe4oy12Amvm11uqYhCJeUkhNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kr15DjI7zOA058z/UiuWHCEBCwadPpMwW+Jxqd+VdfQ=;
 b=SlhbDdpsB2bTyNXoSz5zcDTzpyDcQtEpjs05N8UoVaobjRBj6rj1D4/Gsk+Q5IduAYLCc7bW15y6iHCU7NcdNYL3tMVKbNOWTlCtQqDI/mYEO+zFnDeF+nQqTWF7rimYMJQqx6QeYgtp2TWZ3YnqlTJDXn6GLWZy2SOkR9Nurr84IU8j2t3sXQryJ3lWhWfcK+kzNS9aZC/yKdRcwahF+uZVO+2xUomN9AA9WcmokaaMKWubB2+UHt8JE4SmvATu5pN8VBaSYZ6y0J0KTFyNrUZo3ezpf9urInzuOognTtf5t7wxNIbmKpQHYGfdJ+HT1uNTmsIG3KlIHbkp763rEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by VI1PR0402MB3824.eurprd04.prod.outlook.com
 (2603:10a6:803:22::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Thu, 21 Apr
 2022 11:18:50 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5186.014; Thu, 21 Apr 2022
 11:18:50 +0000
Content-Type: multipart/mixed; boundary="------------TTrGWMGr7D37aSuJ72wIOBTE"
Message-ID: <6a709974-e5c7-9a58-e751-3f3306503b6f@suse.com>
Date:   Thu, 21 Apr 2022 13:18:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
From:   Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH] driver: usb: nullify dangling pointer in cdc_ncm_free
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        steve.glendinning@shawell.net
References: <20220409120901.267526-1-dzm91@hust.edu.cn>
 <YlQbqnYP/jcYinvz@hovoldconsulting.com>
 <CAHp75VeTqmdLhavZ+VbBYSFMDHr0FG4iKFGdbzE-wo5MCNikAA@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAHp75VeTqmdLhavZ+VbBYSFMDHr0FG4iKFGdbzE-wo5MCNikAA@mail.gmail.com>
X-ClientProxiedBy: AS9PR06CA0341.eurprd06.prod.outlook.com
 (2603:10a6:20b:466::14) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 295f21d4-7791-43cb-1b3e-08da2388b4a0
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3824:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3824EFAF1C4DE08C77ABB1CCC7F49@VI1PR0402MB3824.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2vqhV5AP+QlO8KUoQcKii6eMDRl3w8MB9PpVocQkd/tg4W3oUFD3OUTiBfssP3Z8CSTYVqz8+1Rb1pzAvuJa2kf93EOczYeXG5ZtMXHojhnWyBgLVM8c05sG/S3X2LeOiCeYiY37JVpJiXtMexmDc4NFEIaiORb2joZkT3KJ+lp0QDAA1zmq+ThDe42hMksx6L0lw2zr4GIfD7Z+1t/U3TS1NNT2Txw5bQH0oCu+bfnvrzlpq3XcS6+b4gFmLrQGXIK5MYeBxTqHhkmBOmZWIAQdcAtoIqqM/kiM+952a7Da2crt26y5jE4StxaTXGtC19RU4qplzGbpbxhBf5xHpT/yTHafzbHFM4FxD5I24kgjgXf/X/qI2Cb2w12oF1xnav9c83Y4B3F/F3/qsrik3kAfIz8wHDESpCawUjGwPEuBhcXtP6mVHdkMLMiehhpU3yyN79qh9O+zK7XG3w1kuootaG1w6qpYtXkF11b5vKXMRIjziJB7qvnPITHM+apoWdC+QHpY65WkvV+gjcoxqtt30qqMzH1QIphgoc3RLEl57GG29DRuLPqfMT/kWWne+08pD7MEUqQjlZbYd+jBppncwauwtSWP3BZYA8cIkzVhPKgVYDu77Hm9zAZSHGF1D3hKaM+7hvdRkuJ/lhwomQ5aBFAc4jIIYYF1EHlRdDvmsocWMzLmD4WxXGdmmaQV+PcfqeYJvvoppHPFEnFV5GNizAnMFcVVISOjLlc7iNI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(4326008)(66946007)(66556008)(2616005)(66476007)(316002)(186003)(36756003)(8676002)(31696002)(235185007)(5660300002)(7416002)(8936002)(6666004)(6486002)(508600001)(6512007)(31686004)(110136005)(2906002)(38100700002)(33964004)(6506007)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZERJUjN4ZWkxaXdJbEJCT3FLay9WN1FIRFloSG5lTkIwNUxjaVRzV3l4YXFW?=
 =?utf-8?B?ckFxY0ROVXJDYmNwS25Pamh6RTR5MXdoamhDbE5rZjdnRDlIY05xVFVqdEkv?=
 =?utf-8?B?VGVWTHc5a1pDcklId21zaVdPSGJUN1dvYzI1c3BYbmJrelcxZkI1OE5MZVM1?=
 =?utf-8?B?VjNZaThicnoxNng5RCsvNklqbjJrcjhHdE1Zenk4WFk0NG00MFl4d3NRVkVW?=
 =?utf-8?B?Y3RTZFVTY1pUaE1hTFFBU0RURkVCN1dyTUdsTm90cDhDR3Zwd0NESllYd1c5?=
 =?utf-8?B?RzUyZUVwL3JwMmZEL1FKazdCMm9ib3RmTEFsWkN4d3RTdllZbmlCYUozUXNX?=
 =?utf-8?B?US9QWis5bmRXY2t5VmdoV05leWdkTXBCT01zd0pnV0xFaGpFbVplSnhrN0o1?=
 =?utf-8?B?WDdFNzdJNWtDcjBvc1ptY3ZZQ24yeUhiQ2c3eVVUSmNwWnBkeXlGTE03OGFv?=
 =?utf-8?B?dEhIMlBkWmpBdFZlbFVxTUlub1B2ZVZrS25XcWozUlN0S2VVUUhVcTZSSWpl?=
 =?utf-8?B?bWJJWWFuMDRZUnNTRHRQR2h2L0FLUXZjcldaeGhiQkFrOWJkSXJTcmxKMUlE?=
 =?utf-8?B?bkMvV2UzQWtka3FncEtvb1JPTXo3d2paVThVRnhGU3JuME1VYmZYcE4xWERS?=
 =?utf-8?B?YUtFNThaTTBtMXROb3dES3pOTjI4cm5wVWdFUm9jNUhndzk2QTVrYUFpVStU?=
 =?utf-8?B?L0hkbjEzdXFCVnVEK3RGc3N5cm56Qk5sZzhnRzBRSG9uZURzVE1kNExUbC93?=
 =?utf-8?B?TEhvbHI2L1pPeHc2bVdQdFdmT2FPMGRHMVFkZHpCbUVlRG9mTFRGc1NRdmha?=
 =?utf-8?B?cVRMeDc4YjZUSGRKV2xld1B4WlVFODkyMU4wVzd4NFVBTThlK0psQ1h3UGdh?=
 =?utf-8?B?RjZJb3cyUjVZeTdPSG81VFhoMTl2aVFuK1BNQStpMG5tSVQ2eTd0a2JTK2pF?=
 =?utf-8?B?dW5aVnpzN0IrdXhkbXROVTZyczM2eVZaYzdLQytqRTNoVkdGMzlBaklVYndU?=
 =?utf-8?B?YSt1Z01SMDhTbWRUbzE0Q0dGWVJGSDF3MnB2M3ZRZDQ0djVvU09NaHZkVGYy?=
 =?utf-8?B?SlRYUStnYXQwcVZIWVR3K1dJUHZQWWJTRFBzQldzcjBtNmJIeGVGSmF2MFJH?=
 =?utf-8?B?dzBuZEJ0TXBvM1h2azVQS0pOSEpZczR3RUt3SFJ3bHJTM2QxenpJdXFrYmVD?=
 =?utf-8?B?THBQN1B4cVROdEhWNy95b2JFN2hOanRINTVIVlc2aHpCMW45eFBMVVAyQjdm?=
 =?utf-8?B?d0hLcjFuZ3g3M29URWIyTGdpTnYrMmR5MjF2M204NldFdnFNamVLMHRNc3F5?=
 =?utf-8?B?eW94QXNCcjB6REFkOVhWYm9DYjhuL2loK1FzZ0UveUFVNnlPc2MvZ05qeVFn?=
 =?utf-8?B?c0k2eXhXZ0hPWUF6VmZlUEVWSDRTUWVYVWpHY1ZJNUJydS92QmhiNTJwMEdm?=
 =?utf-8?B?MlYzaUJ5Y0U4b2hpdEd5bDRWMW4weTdhVk1kZlRhaWgzamVYT1p5cWVIY1Zt?=
 =?utf-8?B?UTJ6MEoyN2VkblZzRisyd3RiRFlQbEs3YlhMZjdNb2ZSMmEyL0hqZG5MbFdZ?=
 =?utf-8?B?dTJqMWhaKytFb096Z01KTERNY01OVDg4SXFsdFBqUzBZZ2xadDU1WmJ4RW15?=
 =?utf-8?B?RWRWUWxrVUE1OUszQjZDeTdjR1kzSklLNzJZSVNyRmtHU0daQzUxNDZvZTZM?=
 =?utf-8?B?dFU2c3JmbUdITjdmeUlpcXN0b3BnY0dsM2owRkVJbVlQQ0tpS2lqaWNpT1h5?=
 =?utf-8?B?RFdVQjNONHBSQ0hEbGZtNFhYNGlieXpOWWhJbldCbjF4cjVaZEk1eXRRQnBj?=
 =?utf-8?B?N3c2L2N0anpNMnE3WDJ0YXRLNTFoczlDZ1dIaUxLY1duODdxY29zcEE5K1d5?=
 =?utf-8?B?ZHA2bGZvSVFkUVpwaHk5QWRCNzdVVHdXWndlTWNPa1RONnFXZktSTktrakhO?=
 =?utf-8?B?Ri9KRGRoRnhrWmp5Y2pjQ0hCUnMzSmplYWRGcnZPcnQ4V2hOa0FlS2c5aFQz?=
 =?utf-8?B?Vzk5UFEzNDc4QnkwSk5YVUN1T3pnMThpa2h4bWtqWHhPek93UDc5eUFNOXo4?=
 =?utf-8?B?TXIxMjVrOFROczQ0TkdrMHJ3bHNJdnNSZWduOUUxTjk0WEJhNTJUQmtpQ3U1?=
 =?utf-8?B?NjRkcXVRT3FpOFNZd0RWa1BjS0FHNDMyUVNncGZybmlZdU13L0diOHRGQnNU?=
 =?utf-8?B?QWx4T1NBdlpGSkQ1cHExNzRiUEd4aVhPNWI1ZFp3YUxwNWkrSnZ3bHNidWQw?=
 =?utf-8?B?bUpQayszWGE2L1haeGVLcG1OV2p6UFRjY0RsMWVSWWpDSXZ5RFRzUzNBbTk0?=
 =?utf-8?B?eG1tdWhjaTJsOWhaQ3hVQTNLOXZicW5ubEZLSlhCYkYxaGp4ajR5UXBzdnBM?=
 =?utf-8?Q?vyAXTqQLO17iLNEwIxVt2rr8oZjZOkSo1lL7jv6GSMHqd?=
X-MS-Exchange-AntiSpam-MessageData-1: h1L6tyOLIJvxyA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 295f21d4-7791-43cb-1b3e-08da2388b4a0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 11:18:50.0042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02qXGIMmF8v9MwCHI3+dk4CgIyPnF/Z7DHIb1989v/ua3gysl12X/TTLxVRuN9GcNzGphWlEwtBcKczSjc6pYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3824
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------TTrGWMGr7D37aSuJ72wIOBTE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


So I am afraid I have to ask again, whether anybody sees a fundamental
issue with the new version attached patch, as opposed to it not being an
elegant
solution?

I corrected the stuff Johan found and split the method in the asix driver.

I do not understand smsc95xx well, so I left it in the current state.


    Regards
        Oliver

--------------TTrGWMGr7D37aSuJ72wIOBTE
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-usbnet-split-unbind-callback.patch"
Content-Disposition: attachment;
 filename="0001-usbnet-split-unbind-callback.patch"
Content-Transfer-Encoding: base64

RnJvbSA1OTUzYjNiMTJkZDZjZGQ4ZDBiZGIwMTE5ZWU2MjdkNjIyMTlhYjFlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPgpEYXRl
OiBUaHUsIDEwIE1hciAyMDIyIDEzOjE4OjM4ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gdXNibmV0
OiBzcGxpdCB1bmJpbmQgY2FsbGJhY2sKClNvbWUgZGV2aWNlcyBuZWVkIHRvIGJlIGluZm9ybWVk
IG9mIGEgZGlzY29ubmVjdCBiZWZvcmUKdGhlIGdlbmVyaWMgbGF5ZXIgaXMgaW5mb3JtZWQsIG90
aGVycyBuZWVkIHRoZWlyIG5vdGlmaWNhdGlvbgpsYXRlciB0byBhdm9pZCByYWNlIGNvbmRpdGlv
bnMuIEhlbmNlIHdlIHByb3ZpZGUgdHdvIGNhbGxiYWNrcy4KClNpZ25lZC1vZmYtYnk6IE9saXZl
ciBOZXVrdW0gPG9uZXVrdW1Ac3VzZS5jb20+Ci0tLQogZHJpdmVycy9uZXQvdXNiL2FzaXhfZGV2
aWNlcy5jIHwgMTMgKysrKysrKysrKystLQogZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMgICAg
IHwgIDQgKystLQogZHJpdmVycy9uZXQvdXNiL3VzYm5ldC5jICAgICAgIHwgMTAgKysrKysrKy0t
LQogaW5jbHVkZS9saW51eC91c2IvdXNibmV0LmggICAgIHwgIDMgKysrCiA0IGZpbGVzIGNoYW5n
ZWQsIDIzIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvdXNiL2FzaXhfZGV2aWNlcy5jIGIvZHJpdmVycy9uZXQvdXNiL2FzaXhfZGV2aWNlcy5j
CmluZGV4IDM4ZTQ3YTkzZmI4My4uY2RlNGQyMzRiOTc1IDEwMDY0NAotLS0gYS9kcml2ZXJzL25l
dC91c2IvYXNpeF9kZXZpY2VzLmMKKysrIGIvZHJpdmVycy9uZXQvdXNiL2FzaXhfZGV2aWNlcy5j
CkBAIC04MDQsMTIgKzgwNCwxOCBAQCBzdGF0aWMgaW50IGF4ODg3NzJfc3RvcChzdHJ1Y3QgdXNi
bmV0ICpkZXYpCiAJcmV0dXJuIDA7CiB9CiAKLXN0YXRpYyB2b2lkIGF4ODg3NzJfdW5iaW5kKHN0
cnVjdCB1c2JuZXQgKmRldiwgc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYpCitzdGF0aWMgdm9p
ZCBheDg4NzcyX2Rpc2FibGUoc3RydWN0IHVzYm5ldCAqZGV2LCBzdHJ1Y3QgdXNiX2ludGVyZmFj
ZSAqaW50ZikKIHsKIAlzdHJ1Y3QgYXNpeF9jb21tb25fcHJpdmF0ZSAqcHJpdiA9IGRldi0+ZHJp
dmVyX3ByaXY7CiAKIAlwaHlfZGlzY29ubmVjdChwcml2LT5waHlkZXYpOwotCWFzaXhfcnhfZml4
dXBfY29tbW9uX2ZyZWUoZGV2LT5kcml2ZXJfcHJpdik7Cit9CisKK3N0YXRpYyB2b2lkIGF4ODg3
NzJfdW5iaW5kKHN0cnVjdCB1c2JuZXQgKmRldiwgc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYp
Cit7CisJc3RydWN0IGFzaXhfY29tbW9uX3ByaXZhdGUgKnByaXYgPSBkZXYtPmRyaXZlcl9wcml2
OworCisJYXNpeF9yeF9maXh1cF9jb21tb25fZnJlZShwcml2KTsKIH0KIAogc3RhdGljIHZvaWQg
YXg4ODE3OF91bmJpbmQoc3RydWN0IHVzYm5ldCAqZGV2LCBzdHJ1Y3QgdXNiX2ludGVyZmFjZSAq
aW50ZikKQEAgLTEyMTEsNiArMTIxNyw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHJpdmVyX2lu
Zm8gYXg4ODc3Ml9pbmZvID0gewogCS5kZXNjcmlwdGlvbiA9ICJBU0lYIEFYODg3NzIgVVNCIDIu
MCBFdGhlcm5ldCIsCiAJLmJpbmQgPSBheDg4NzcyX2JpbmQsCiAJLnVuYmluZCA9IGF4ODg3NzJf
dW5iaW5kLAorCS5kaXNhYmxlID0gYXg4ODc3Ml9kaXNhYmxlLAogCS5zdGF0dXMgPSBhc2l4X3N0
YXR1cywKIAkucmVzZXQgPSBheDg4NzcyX3Jlc2V0LAogCS5zdG9wID0gYXg4ODc3Ml9zdG9wLApA
QCAtMTIyMyw2ICsxMjMwLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBkcml2ZXJfaW5mbyBheDg4
NzcyYl9pbmZvID0gewogCS5kZXNjcmlwdGlvbiA9ICJBU0lYIEFYODg3NzJCIFVTQiAyLjAgRXRo
ZXJuZXQiLAogCS5iaW5kID0gYXg4ODc3Ml9iaW5kLAogCS51bmJpbmQgPSBheDg4NzcyX3VuYmlu
ZCwKKwkuZGlzYWJsZSA9IGF4ODg3NzJfZGlzYWJsZSwKIAkuc3RhdHVzID0gYXNpeF9zdGF0dXMs
CiAJLnJlc2V0ID0gYXg4ODc3Ml9yZXNldCwKIAkuc3RvcCA9IGF4ODg3NzJfc3RvcCwKQEAgLTEy
NTksNiArMTI2Nyw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHJpdmVyX2luZm8gaGcyMGY5X2lu
Zm8gPSB7CiAJLmRlc2NyaXB0aW9uID0gIkhHMjBGOSBVU0IgMi4wIEV0aGVybmV0IiwKIAkuYmlu
ZCA9IGF4ODg3NzJfYmluZCwKIAkudW5iaW5kID0gYXg4ODc3Ml91bmJpbmQsCisJLmRpc2FibGUg
PSBheDg4NzcyX2Rpc2FibGUsCiAJLnN0YXR1cyA9IGFzaXhfc3RhdHVzLAogCS5yZXNldCA9IGF4
ODg3NzJfcmVzZXQsCiAJLmZsYWdzID0gRkxBR19FVEhFUiB8IEZMQUdfRlJBTUlOR19BWCB8IEZM
QUdfTElOS19JTlRSIHwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9zbXNjOTV4eC5jIGIv
ZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMKaW5kZXggNGVmNjFmNmI4NWRmLi4yMGNlODgzNzM4
MDkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3VzYi9zbXNjOTV4eC5jCisrKyBiL2RyaXZlcnMv
bmV0L3VzYi9zbXNjOTV4eC5jCkBAIC0xMjIzLDcgKzEyMjMsNyBAQCBzdGF0aWMgaW50IHNtc2M5
NXh4X2JpbmQoc3RydWN0IHVzYm5ldCAqZGV2LCBzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZikK
IAlyZXR1cm4gcmV0OwogfQogCi1zdGF0aWMgdm9pZCBzbXNjOTV4eF91bmJpbmQoc3RydWN0IHVz
Ym5ldCAqZGV2LCBzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZikKK3N0YXRpYyB2b2lkIHNtc2M5
NXh4X2Rpc2FibGUoc3RydWN0IHVzYm5ldCAqZGV2LCBzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50
ZikKIHsKIAlzdHJ1Y3Qgc21zYzk1eHhfcHJpdiAqcGRhdGEgPSBkZXYtPmRyaXZlcl9wcml2Owog
CkBAIC0xOTk3LDcgKzE5OTcsNyBAQCBzdGF0aWMgaW50IHNtc2M5NXh4X21hbmFnZV9wb3dlcihz
dHJ1Y3QgdXNibmV0ICpkZXYsIGludCBvbikKIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHJpdmVyX2lu
Zm8gc21zYzk1eHhfaW5mbyA9IHsKIAkuZGVzY3JpcHRpb24JPSAic21zYzk1eHggVVNCIDIuMCBF
dGhlcm5ldCIsCiAJLmJpbmQJCT0gc21zYzk1eHhfYmluZCwKLQkudW5iaW5kCQk9IHNtc2M5NXh4
X3VuYmluZCwKKwkuZGlzYWJsZQk9IHNtc2M5NXh4X2Rpc2FibGUsCiAJLmxpbmtfcmVzZXQJPSBz
bXNjOTV4eF9saW5rX3Jlc2V0LAogCS5yZXNldAkJPSBzbXNjOTV4eF9yZXNldCwKIAkuY2hlY2tf
Y29ubmVjdAk9IHNtc2M5NXh4X3N0YXJ0X3BoeSwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3Vz
Yi91c2JuZXQuYyBiL2RyaXZlcnMvbmV0L3VzYi91c2JuZXQuYwppbmRleCBiMWY5MzgxMGE2ZjMu
LjVmMzg1MWU2MTU3MyAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvdXNiL3VzYm5ldC5jCisrKyBi
L2RyaXZlcnMvbmV0L3VzYi91c2JuZXQuYwpAQCAtMTY0MSwxNyArMTY0MSwyMSBAQCB2b2lkIHVz
Ym5ldF9kaXNjb25uZWN0IChzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZikKIAkJICAgeGRldi0+
YnVzLT5idXNfbmFtZSwgeGRldi0+ZGV2cGF0aCwKIAkJICAgZGV2LT5kcml2ZXJfaW5mby0+ZGVz
Y3JpcHRpb24pOwogCi0JaWYgKGRldi0+ZHJpdmVyX2luZm8tPnVuYmluZCkKLQkJZGV2LT5kcml2
ZXJfaW5mby0+dW5iaW5kKGRldiwgaW50Zik7CisJaWYgKGRldi0+ZHJpdmVyX2luZm8tPmRpc2Fi
bGUpCisJCWRldi0+ZHJpdmVyX2luZm8tPmRpc2FibGUoZGV2LCBpbnRmKTsKIAogCW5ldCA9IGRl
di0+bmV0OwogCXVucmVnaXN0ZXJfbmV0ZGV2IChuZXQpOwogCisJdXNiX2tpbGxfdXJiKGRldi0+
aW50ZXJydXB0KTsKKwogCWNhbmNlbF93b3JrX3N5bmMoJmRldi0+a2V2ZW50KTsKIAogCXVzYl9z
Y3V0dGxlX2FuY2hvcmVkX3VyYnMoJmRldi0+ZGVmZXJyZWQpOwogCi0JdXNiX2tpbGxfdXJiKGRl
di0+aW50ZXJydXB0KTsKKwlpZiAoZGV2LT5kcml2ZXJfaW5mby0+dW5iaW5kKQorCQlkZXYtPmRy
aXZlcl9pbmZvLT51bmJpbmQgKGRldiwgaW50Zik7CisKIAl1c2JfZnJlZV91cmIoZGV2LT5pbnRl
cnJ1cHQpOwogCWtmcmVlKGRldi0+cGFkZGluZ19wa3QpOwogCmRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L3VzYi91c2JuZXQuaCBiL2luY2x1ZGUvbGludXgvdXNiL3VzYm5ldC5oCmluZGV4IDFi
NGQ3MmQ1ZTg5MS4uZGQ0YTExMDRlMzMyIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L3VzYi91
c2JuZXQuaAorKysgYi9pbmNsdWRlL2xpbnV4L3VzYi91c2JuZXQuaApAQCAtMTI5LDYgKzEyOSw5
IEBAIHN0cnVjdCBkcml2ZXJfaW5mbyB7CiAJLyogY2xlYW51cCBkZXZpY2UgLi4uIGNhbiBzbGVl
cCwgYnV0IGNhbid0IGZhaWwgKi8KIAl2b2lkCSgqdW5iaW5kKShzdHJ1Y3QgdXNibmV0ICosIHN0
cnVjdCB1c2JfaW50ZXJmYWNlICopOwogCisJLyogZGlzYWJsZSBkZXZpY2UgLi4uIGNhbiBzbGVl
cCwgYnV0IGNhbid0IGZhaWwgKi8KKwl2b2lkCSgqZGlzYWJsZSkoc3RydWN0IHVzYm5ldCAqLCBz
dHJ1Y3QgdXNiX2ludGVyZmFjZSAqKTsKKwogCS8qIHJlc2V0IGRldmljZSAuLi4gY2FuIHNsZWVw
ICovCiAJaW50CSgqcmVzZXQpKHN0cnVjdCB1c2JuZXQgKik7CiAKLS0gCjIuMzQuMQoK

--------------TTrGWMGr7D37aSuJ72wIOBTE--

