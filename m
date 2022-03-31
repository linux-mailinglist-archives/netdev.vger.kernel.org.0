Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D21E4ED716
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbiCaJhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbiCaJhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:37:31 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1263B6E6A
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 02:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648719341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qdw4vQzSJlO0aIkDmz9xqbIt6nFOVA32pU10tfroGNQ=;
        b=hVXNR4hlLJBa8Utq+SsBqpgajQO/0sroh2Q5z6E7TrFCvhY5QTP6eh34nRAcTCE+01yTI1
        Sn3J/d39ghsG+GbdQxbLjeyCBgM2F3SCa6tEnpjIxIRZsH0nE03JWuFnlChCsos2Nh/4qk
        HbuF6qsSStfiJmn2j4SkXL9u5/Kt5X0=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2056.outbound.protection.outlook.com [104.47.0.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-25-wNpNRFbHNJywWfECaVMgKg-1; Thu, 31 Mar 2022 11:35:39 +0200
X-MC-Unique: wNpNRFbHNJywWfECaVMgKg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OakIMzTo2rtzHC2xb4Ssy34cW3MSYKDFl0oDUozy1lw6mrCcOMnBeZQu7uaG2G8Arae2xUAgTjzDW8HiYBFDBzVYvecZ643e30YxhDmDmQc+KeTSP0P4JGWCGj6jxXvK5urZgJTDlsodU07k7qfvVMFieYhpYOHS2fcGGVP9FpIdo9igD5j3lxOWLGlxkHbi2ZlBe/ZBfRQCApcv+rXKgS+HhYo7L0MmDuLiS78n3+AHxs24k0Q0dU6CxTvEcD7zvxI09xF5bGK4rTVUzcnXFBf0CSqObgNsUnGuC0HSxdqJYNg9x2tk0+PRvyKEuFh1B6C6H3yN+lInGeX73Vc4cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRd9tovJmr3elTx2aYOSHlQgPzywDt6CQuGYUL0WYBE=;
 b=RGUfivu7JFrTB1CRVDN4d+fvwsFFYQbSFjgy4Oh0AWeVd/cufVXo2t9REVEa1xTqwPID85it06dKPKeTorOVkgDG17N34BODYWCO/DSYXtMDvgKKJxDt2Xbt3jM2WOio89MKb/Ua0mQ+M7g/1ZixXHUkXNEDdA5KUI/cjnBBH2NDN+U6nbNJe1QppUciazJhpC43fHpoXJyueCqV239e/prf+PCYy83esiSTMhY77bjMU8qYTcs/G/HRLIKvAF/IdCTb1zXa88DTn5XgTFQdktaFWYkgLgdPcCtQjArXFDqqaQkjNNatjAXJkMs7Ae4qy7hCyXJNxNZiRKt8Pfxlvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by AM6PR04MB5285.eurprd04.prod.outlook.com (2603:10a6:20b:3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.21; Thu, 31 Mar
 2022 09:35:37 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::dccb:257e:76a7:c42]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::dccb:257e:76a7:c42%7]) with mapi id 15.20.5102.023; Thu, 31 Mar 2022
 09:35:37 +0000
Message-ID: <be77e0dd-80c5-ac12-8be5-b2c2b74857f7@suse.com>
Date:   Thu, 31 Mar 2022 11:35:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>, Oliver Neukum <oneukum@suse.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de> <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch> <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de> <20220315113841.GA22337@pengutronix.de>
 <YjCUgCNHw6BUqJxr@lunn.ch> <a363a053-ee8b-c7d4-5ba5-57187d1b4651@suse.com>
 <20220321101751.GB19177@wunner.de>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220321101751.GB19177@wunner.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM5PR0101CA0019.eurprd01.prod.exchangelabs.com
 (2603:10a6:206:16::32) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2249c8e9-436d-489d-563f-08da12f9cff0
X-MS-TrafficTypeDiagnostic: AM6PR04MB5285:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AM6PR04MB5285CF24F7AA983D835588DFC7E19@AM6PR04MB5285.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xS3OQQ4Xi2Q+uY/q9bejEzPz5WW4jYSGAHQLOAedFPBZbfr3v69R4pi5YgsByMLrLdWyf86lZkv5Qo06Iknl/dvVJ/a2rEGRz7Q3qqiT+WgBpUTgi39SP00ud9ZFe5HzF3bDoift3/38OFuovUmDpAizz4gmY77cXd1AAS/VuyXPimyboyukCVOLlNybNaYUlbWDQovmXFtCAPloYDq/JznN8H26DnDTQe95APWmPt9Z7wjWnzLAQq9JKJwe4VcEXKwsw9XGwyWjKhxPT4jpBk9YmOqW1fe46ceu84fbw297NyKEBfTPG8UEM2tVSLXNv115EQnHWm5/wNp177k1igsQD4Gv4WDJOMRwtNw/p4qQE2pln/TcdG9D0RbYWSgE1J4QyX23qWlf9B7Zv3sgKGqZkZ0vaz3/75c6m46Kq6lJlf71BbKRFwBKSjJMqpH7HM9EFvcf05NtMKAJRjwKrrB1dZB2IZ3D13Xuin5a5VkYX8VVOi7L7iySxrMQ705Az9udPqRUU+SZxpLsui3bW3akMUfUN8lVWyHdYabhRs1LN4QvgVUfWQQVXln20dpZN/fzjfwJ+yrBK5+ziOYZD+yFMsDZiKisliZnlhrrocsm0NvSUtoc5ufPCHpVU20F/NmMAtqgzicP0UsbEwuDpJPeI4XRDUZh2oiCaHQc6U5VK3p83Pd3JRdry/EZ1wXfA0Eg64UkIQqwPvWTL5kuN7C5U/vVlWoybd4MJjHAEoo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(110136005)(508600001)(38100700002)(8936002)(316002)(2906002)(6486002)(31696002)(4744005)(5660300002)(86362001)(36756003)(31686004)(54906003)(8676002)(66946007)(66556008)(66476007)(53546011)(4326008)(2616005)(186003)(6512007)(6506007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H8ZICCwYjlgV8vBs4P+XIPBliXC8g3l6UPpWbyOD/mVQULKcHTcirTpz20V8?=
 =?us-ascii?Q?A+TzhQAosVAgTFt2khcejXyveqJZZZsxqMAim8TFmRcxjFbN3EWIteG8XOdH?=
 =?us-ascii?Q?QbsrqWnUUYtUeS0hRcllOAiIyR665YkUMsahApEtQ4xCUJJH+hvTnixNjTGe?=
 =?us-ascii?Q?hkRWIko2dlramo9MuXnUuNAf9o1d7a1dMPw1g6eAIkEIbb+26cBt+edvuxgj?=
 =?us-ascii?Q?SgXRQM2kBa/ZuUJ6U+KbE7pb9QN1AXAMvKKtOYQt36HJ4Pg/oB6LW/hoiNzY?=
 =?us-ascii?Q?jqfhHFEsK2XR3LhRxTg3kU1PaRtjfk726440kuwwysAU/6AaOVAs4DYp4F4+?=
 =?us-ascii?Q?VvTRfY4Z3Xvx/iorHublzbJ3NSL5ZgH8OscuxNLXLwC5loVbp9lCi6H7TfH6?=
 =?us-ascii?Q?ANLcfwnXI+ShMB9rSfmXJYVmWOhrINLEqLtKBSH/1HtcLKBgeY4U7bZrsWS0?=
 =?us-ascii?Q?rlBa4I2Svf5z/8Tl6SIsHesLV+c9jX5/SjRjUGN/q0KGoTpuWhMYzudv+ugg?=
 =?us-ascii?Q?EJiTb5aoRE7cNAaiYRn7xQbCSIt4axkpi/nn61tTdhbIJoslOoZ49bHNf/3E?=
 =?us-ascii?Q?LbgH1xX+sd+epNSDfVpqBlduJtYwQmUiw7b6nB62yjnZX9IaiZVstwkeBTMf?=
 =?us-ascii?Q?+BMj0gYLjQ1hXwCcDA8JIY3WvxdQ0qUAqEGHpItoDXQSPKrvFnrgxpWNnWFw?=
 =?us-ascii?Q?V//pO5bpdwMLuhWH0LT7E52Bn3Me1hmR1msqSOSDPLu4bARNE1Kr3ufz7tDA?=
 =?us-ascii?Q?ZcO9/8OIFVexMO00HnwPGgf8vJKQakY3JAcjp7MtsLbg9gVQwR70lrAfJhMm?=
 =?us-ascii?Q?stbaEfodDDI92Bt4ch4u2kmm/aM+av7QkKfPCodnSFNnk5tJC02PHoCJp0bd?=
 =?us-ascii?Q?XL9QPwddwMYWmXohElfJvjP+6gZAcmybHrWetWcAexyFm2VKfsG3wp58U8tZ?=
 =?us-ascii?Q?Lu7+xNKjD5Wv4a1eRLbObKsFv+eLVmqbVxEC/ayrHxaH1AdlmufatPzhxxXE?=
 =?us-ascii?Q?0CY/IcwOpgOekt0MtdIvKOwHFCnIjlX5SzjbpDWyU25JqorFgnWEJlXNvwLb?=
 =?us-ascii?Q?gr3aAUG602paQn3gTjNgOYu/xXRRh/ONpPKpaTXvhKO58hQaVOVR+BhvShBB?=
 =?us-ascii?Q?5jph3HEQYA8UtP/GhcZ7A5VWcd3CKoml6REHaE/wOlJYbVTQLXUvEQL1VcwL?=
 =?us-ascii?Q?J5Qjbf3NMULYEeAX/Tw0IkFETZAA20Y3DDBCCoVq0nGa3jqdbcCqCVVEl4qT?=
 =?us-ascii?Q?Dss1HCsP86iWD/nFIvLiuYsh76I9SlxmpOtoa2cdift8CYL5gcMfBkueEI9J?=
 =?us-ascii?Q?8E+cBG9ghutKAw1uUjr3GiQdeRlzRtucaknLEfWETnnTESAi2ATBLORgQQ6y?=
 =?us-ascii?Q?WZ8ZGvkXpDrALovid0w0Tp2zZA74jIt1jYYgmD1awEuUuO1KaOlpzb9bQZlq?=
 =?us-ascii?Q?pXiVIfnrjTGcEn8HKYcKDobRbl/IzK4mIeG2YXBcBuMqApZu5tYkwvjPO+Ew?=
 =?us-ascii?Q?+N9AAUiOThiQorhQDhera4vVlar7do33bv3dFZCeGdHhiaWNNHsy+hgbd9JL?=
 =?us-ascii?Q?qI67HsxQvYJSbauJ/8jNDzZobQLuIhz8bRgouQtT95y9A0X2R1o5R5XDbixg?=
 =?us-ascii?Q?RBi0yew5c3nXKOrTFiiiiGrUKVxTVxMjg2kC1SzYv8u/43jtDWMbRq7acJc2?=
 =?us-ascii?Q?LY+0KRBoJS2VVSk0wI781NgkRpMZ5lsuoGYuuyLap+UxKyl1eo9xz68HVO97?=
 =?us-ascii?Q?CDw4TiX/KDFybJ9rkQ5rZ7sSdaU3lp59XuPVhxfku3frIb+zjQgkDVASQpbl?=
X-MS-Exchange-AntiSpam-MessageData-1: q9/KGstrLfTFpA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2249c8e9-436d-489d-563f-08da12f9cff0
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 09:35:37.5980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oUCJgvADo5TocHxgWR2toR5O7P4EWCP1iuYTN8QpEpSyRl3j7XDHrifk4eEJhThgXQp1xlg0BLVC1T194QASVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5285
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.03.22 11:17, Lukas Wunner wrote:
> On Thu, Mar 17, 2022 at 04:53:34PM +0100, Oliver Neukum wrote:
>
> By the way: 2c9d6c2b871d caused breakage in smsc95xx.c which was
> subsequently fixed by a049a30fc27c.  That in turn required another
> fix, 0bf3885324a8.  Some of these code changes will have to be
> rolled back or adjusted after reverting 2c9d6c2b871d.  It's a giant mess.
> It's possible that more drivers saw fixes due to 2c9d6c2b871d,
> I haven't checked that yet.
Very well, but in order to do so, I guess we need a fix first.
>
> Oliver, why did you want to revert 2c9d6c2b871d, i.e. in which drivers
> have your users reported breakage?  Do you have bugzilla links?
I made the patch in response to a security report about a DOS attack

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

