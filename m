Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F514D459F
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 12:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235775AbiCJL0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 06:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbiCJL0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 06:26:16 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AAC141471
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 03:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646911514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fYHzzugIpoqv9jcTwr1G4+YenM+mNW/B4TImu6c2A0c=;
        b=aAT6bduMydjILbHoh3OHpSs649jQsixxbiM7VMPYKO52nNKvur8L8ZWZA/80Rq9Xq0Ej5d
        x6uvOZTuMj/XvM2MU+DusxqznNhRKexwy6fdRBMT16/R08SigV9lbm3LtW2kVFA+9rvsXD
        QSBxD+Q92BZTnGU3m+vQeRY7ehodGyw=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2056.outbound.protection.outlook.com [104.47.14.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-28-KPM3TG7pNR-JelmNbTHgtQ-1; Thu, 10 Mar 2022 12:25:13 +0100
X-MC-Unique: KPM3TG7pNR-JelmNbTHgtQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XK+GxxQfDdtgK7i2ib8bdtolSKTCHO3fcU5B1dvxlt34v0XYYB/pokjfiIrJ0wasq5HHg+8/Ivsx0GUwjl1+/iCXndlG4oKjBt7H8KLvfOiz2hjJ/No16nyKee+OeSFMpcmS3l6zgSxSr1IPGQl3P1ZZmyWiad2kZBzM1cZpx+dYqVT8UKrb8gBI+00lyoYTVHsBte0ws6eepq7oq59UYr83Wqi3HBgFyjZsw/M0JZxNShw3xCEhid4x3YL3ekff2v3cFl0Mnota4WoOtrdYlvGjKBg1tMGlmXDnCsf3r/q37Nco84xkhYVY1OU33zUS0AGgS/kBZtyIE7Fs3OEvnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5/RDI3wKg+ATbuGMbdyhFQv0u/gn9y3b4uDuVgQpOv4=;
 b=HVqYKeLg9KpIWqHhyYoC/FYl6eYFZ+WDk0t85bP8HW7wXlYv8DrxQJA7Vld+0dTaDbYWA/xk4fESNHGUcLORSmDNkw4aEgKuRoUdpVLPRcBqZ1ZxQhzlNMI8NtFIOMps5mdnJ05ChnVyDvyxBq4Fphookg2DszQqIGONLRt+Z2wFha4lwddbpSVgCvGqUbtnQFwkZWFQppoU0V8pKYuUOmyH9INTx0zTqPyHBSLIgL9FImEAtAcqJ3AfIrL+rGLAMf8Tix8WDsgrYvKO+ro/8/7J3xgujC6uk8TdtS1uKtHq8L16ji2SdaVNvjlWBo8T5sBVmKTE+fa1EGTAtK9zuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by HE1PR0402MB3595.eurprd04.prod.outlook.com (2603:10a6:7:8e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Thu, 10 Mar
 2022 11:25:10 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f%5]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 11:25:10 +0000
Message-ID: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
Date:   Thu, 10 Mar 2022 12:25:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To:     Oleksij Rempel <linux@rempel-privat.de>
CC:     Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Oliver Neukum <oneukum@suse.com>
Subject: ordering of call to unbind() in usbnet_disconnect
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:80::15) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a4f6977-b012-409f-4324-08da0288a33d
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3595:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0402MB3595AD1184F494D0570CBBCAC70B9@HE1PR0402MB3595.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pRtiDhu5munod174J2KCOpf96HUxFbMHuT1QzB0jXfHA0k+SKHZNsTuWdJBWGD34KCupS1hR4PL2ui7yl+ay/RdinmpUqwML07gLJT+f76NfE0ccb05RJQJF0HO5fRslCaH5a3IgIg6+t42eBnJnsv7q4zcoLP8L3BQ60Qi587/M22c4PhrwW0SyLWOTD2k0aJhaYoN5wAt3ulCTA4KJuh/T5W+JY7Xqm9RAUFC4397PwVW2OggRNrnE4R3uL8IPrOXHIY2/HW8OGn+uVXGfvYNUTrR7KBUMvA1YSsmh5vg9cB81nDMJyC3KcGtLRONIGTx1SXQuwr6lRdYGgp20ZNSThjIuLIBRnTERkRYbPam0sAHGID8iCp0JhF8+ZWqA+xaKigT/7Qs+cvkgMuI1Ig6gd7fQAfp7Nl+N0djSfMN57qSGj+kaOna7D+AvMW6+MLrqB0e7gP8UTb/bGQ8tfGuOq5sgzoyvVIexKoD7hpHMhJpcCxuUbY7Euyt+NYjULWxzfDIWu4iSnP5fBkOkuFXZqjNs6tuCM402FvCMu5S958SX/YwbwulhfRS//0z9uscCGojsjHsFmzOiYM7MNYFycZ62EC4zLpvygrCnj7syJmfhrWfVqPfByZVu7oYFE31JnMBmGnXzelispvia3AGM/bUHV3YpgtzIfVadD6+BmUvzvEyv9wPeUvoFndd9m28QcOnmuvoKoWiVh9kwmxn7nr4x6RVoa/HNWLdXykA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(316002)(6916009)(6506007)(6512007)(36756003)(508600001)(2906002)(6486002)(2616005)(38100700002)(186003)(86362001)(4326008)(8676002)(31696002)(66556008)(66476007)(31686004)(8936002)(66946007)(4744005)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2FwucQoetFQva/gjzKNGyZSVG4GbjRj217t5a7Mi9G5PV1Vy4R6xCIPL67aK?=
 =?us-ascii?Q?VvtET6KOmbAVnvLUjkW1/wg5mxVfG1BjssjHAD+UiwB4denc7GkJ+OYEvhf6?=
 =?us-ascii?Q?aYRVPjqpqYs8ktHHODd5nM18RriLC2qsIv+mG1aJ2DC8GBRI09WlEAOuIRml?=
 =?us-ascii?Q?SO2DL5Qp24R+xf0w+YdVfy6gyuiaBnJjnorMf4nIYkmedpJnsJqsvtM4h45C?=
 =?us-ascii?Q?Clm4bbQWfwfG2IPC92MZUSyeFGliHZ/R+4bPG2IYjpRUDfm2ce2eCEUR/Gh7?=
 =?us-ascii?Q?Ft+PngfTfTGnFxjQfDwOU08kqCSKGlj3gUNbG0+k+xXIMiaZqeBBQciVi5WZ?=
 =?us-ascii?Q?NGBNEDV5wiyFoHGqpqBDnYKHuQX4ZVnnXhnTbB2cFv6pm1Fm3ntmYPBQJiSb?=
 =?us-ascii?Q?w8qribzQuZV6HiAW5r0BMZRoiPuCdexe0aGTAhNlU90yldMH8hAnmJY45eUV?=
 =?us-ascii?Q?QG0vg75SBbTklo94IZJyvFn25cSbqagWGmjxbM6BsUqjBPkwsVFUamkwzcXu?=
 =?us-ascii?Q?AONu8qLHRl43IRFjmwrvTu07fJu03hlCmXE1n1uB4Y1p2usR7Tz6ECaqMxa2?=
 =?us-ascii?Q?rxm2mti2YDPwv9V5CPsHUo4v6xyUyvmyNJ0vsay29tcPGycSQzC8ZfDlblvi?=
 =?us-ascii?Q?+3TIPf1kDepV1YfB3rfHoPxOnEmpLr+snwvhSrNQPdk5xNiqfWkI1c8ySs2m?=
 =?us-ascii?Q?hRZBFanzG8WhqTEVBFwHpxFtd9eHElZAoCbPBJNfbgmYJ1lWJOeCZhaN9tPg?=
 =?us-ascii?Q?1XzqDGsyZ7lz8oaPYauX7yg6ju62KTgoahe+k2lNKtzpiSaQ6Twos3wsO/iZ?=
 =?us-ascii?Q?bWFJFkFme2151iHl83HvEKG+TbVnrQzvtU8wy8JuuwQJLIWYJEX/6GVSTK8v?=
 =?us-ascii?Q?JOPgAswm+Pd7uTEKIZtdxnb6ZO0fbyqyezN7F+1zCIroUGQL4Mqx/Z5NQyci?=
 =?us-ascii?Q?DuCTm5h6Iop9RMivT7KG85Rnbg3w8v+K5/DI0+1lJg2S4eifgmpdbf9SJ/PQ?=
 =?us-ascii?Q?eVcSujawzIdd3Yr7PCA7Si97x8Dkdss1W4OyTVBkEKVB04UYEyc3ebNLvMDa?=
 =?us-ascii?Q?cXjSIto22ZhgQdso9tVzcwVqM/d8x6u3f4ITGg8CdcZwQGT51NMIBfiC78ho?=
 =?us-ascii?Q?fV13yp+ft1eQVFzYKyGspICAZnb9iluvun4ffMIfE9kF+BbsKZHhYebtEg8Q?=
 =?us-ascii?Q?d4zXG5K811msR8hxR3Iw0g1MhqJessi9F2z0RTYYA7XE6mAF8rfdfMkMX0OD?=
 =?us-ascii?Q?AFqupL9qQELJVMcrSkMlKPjd+Lb1+p4o7yWQKpzEjRV1WM7BmMzextxBtOJH?=
 =?us-ascii?Q?LGsgSHgzX0jS9PqD+ITOfUgxb8PV04jgn9i1uBB58LXZWFR8N2//1bltjWq3?=
 =?us-ascii?Q?e+jHoQZXkKQuFBmHbiMWohGlKvGXbHD4ZQM9ZOzBWeAU+XU4a+gv1U6/iMFl?=
 =?us-ascii?Q?GTBpdldNQ8vrZDIOBSktayjqmABUVtY7NfQwZOHSdt7WZ3b0FEAeObfWElG1?=
 =?us-ascii?Q?mNizVndUVXniAxMqlee/gAxln2+L8WzwGdos3aKOOOmHyfNj/7+jF2D7GLEl?=
 =?us-ascii?Q?7JY4JfW+hs++4Z3QapMxhlwQqn8KjXyE2BMRnT02UXFzg0jaK2LjSk/MsSXT?=
 =?us-ascii?Q?uShz12nzVyH4EN4BzAlJHzW/YafIxeNJrf/H3FCc8YV59RwgK/KXVnWlPCnO?=
 =?us-ascii?Q?h91L+7LEaQzm02zHkBEMFTXQNGY=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a4f6977-b012-409f-4324-08da0288a33d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 11:25:10.6355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZin9DM6UXS8iI33aAK7ghi/wnuDKWnFKBIlMXwUz268F7vZUTKQLtanOb6+jIpw5tNfqXkntyWAZdAuOq+vxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3595
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I got bug reports that 2c9d6c2b871d ("usbnet: run unbind() before
unregister_netdev()")
is causing regressions. Rather than simply reverting it,
it seems to me that the call needs to be split. One in the old place
and one in the place you moved it to.

Could you tell me which drivers you moved the call for?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

