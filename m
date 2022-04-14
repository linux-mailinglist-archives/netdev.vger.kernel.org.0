Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C027500C0A
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 13:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242633AbiDNLX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 07:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242630AbiDNLXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 07:23:22 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EB3252A3
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 04:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649935256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qlst4aMAIJ5/UYuUIRO8SdMcxxyPU1SwjO4jFcCXCbg=;
        b=N8jv1uDvog3H6vVHxBmLh7JgRo5Kx+EnRMwbjVzLAN8cBi72h+0pREPhJ8wCHBDwDW5T8c
        yZXKTEOw1qRAXjt0HX9ITVl6bjtIfMlUcYjqNkYUAyjAO+o31KSSW57RyaYdWcCPTXozao
        OCQQWYee3xBIjAKgW00qIzjxh3LlcY4=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2050.outbound.protection.outlook.com [104.47.6.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-11-K69zSEj3PnGxJZIfPQONyg-1; Thu, 14 Apr 2022 13:20:50 +0200
X-MC-Unique: K69zSEj3PnGxJZIfPQONyg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNWzDoL+YchJje39XuPG/CY4BQYMExWrmjxazgLOhSiqxAPXn4a0Z5JOodlfL6zixl27/kmNa1BXlCsfX1bnha3BYLWfvMOjIbNhSUwHJFnKEH3dQzAnqsJl1q2j+7zm+GI21LqxthvsgJMIbdge6BNvSQqTS2/eFIS+RouFTTuMePoseJLh61A5qv7lj5j/E/mqDPSPskcgxS8dVl25KYhh463cNl7Jesg7LfgIaJoNj7SuM9jlTUALWzdpE9Un+sio5EMpK/12MG0iRT4LAy6bi4AWYBs+yfshxMRpm0eYxDqvcneMHtG9D2ir3jtc7naeFGAUJ9CgAtSTJeMxlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqBTHDNE3WV18TNhcxZW+0AAIXy0PEvguCEIPXZQExc=;
 b=EfpRx1fbo8FP26isKbnTEYCHUfzvtF9WHALzpzeJYxOc4//BjAmR8Ds/R66X5j9azbPqhZBs89JN0YS9B5pZTAcrPvnNhX9NNSeQk2AI6xLLDQ6tmDxdMu5v3UOfhPyvX6ge6Qs0jtGRlwFLSfOCupjl4GEhgySvl6AwrShQtPoASMqr7NKod81LkQOf0zxRpMV9V+3aeivWpYcCeGAZFhMinXN97t5KyzlHx6FCQVxtdA3rOdrDaYEOT1XTv2fqzEG7Q3C2uQhcxSg3mxoHG4LarsmDGFixuFEtMfQYnbLENrqa5DHNRAq0aKf3OW13S5KpgKIUQr1jnATsgN8RzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by DB6PR0401MB2262.eurprd04.prod.outlook.com
 (2603:10a6:4:48::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 11:20:46 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5144.030; Thu, 14 Apr 2022
 11:20:46 +0000
Message-ID: <d13e3a34-7e85-92dd-d0c0-5efb3fb08182@suse.com>
Date:   Thu, 14 Apr 2022 13:20:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] usbnet: Fix use-after-free on disconnect
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>, Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <127121d9d933ebe3fc13f9f91cc33363d6a8a8ac.1649859147.git.lukas@wunner.de>
 <614e6498-3c3e-0104-591e-8ea296dfd887@suse.com>
 <20220414105858.GA9106@wunner.de>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220414105858.GA9106@wunner.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6PR04CA0021.eurprd04.prod.outlook.com
 (2603:10a6:20b:92::34) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76928486-ff3a-4010-f5b1-08da1e08d20f
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2262:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <DB6PR0401MB22629E8E314BF2B6CA89E023C7EF9@DB6PR0401MB2262.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TNoJjy1csDlGxGHkjJMgJM+qovCquFLVnkRUj5foe8IInEFgMWmOFwIByap3wU/65+EV9f0hNE/aCwgtnlhRmgm2KbY4O0wLwk3LlIOonQbausj/AwFsEbcE+fVETBEbhDXA1yKTyMXNvhK8bL+WuC6OAUXjACbdenvVoRNeaJ82B9yxfgJooVVMGh2uX2W16Vh5cTN9l2WnElm98/Bh9feebvylql0P2OHkEaL1PHV6NQKYzU+hKmEU2SeSLXcgt4G9PR5rxnxloOQElokb4q4ERDhSv5HPEa+GcCusAtfVEXYyzYrs6nrVH/mGsPsMVBXcF0kOej1vfF8kDVgab+tls71e/usf5Xh4SThW7BsPs2q8ohbZt4ytn9Zbw97AhWgM+lMYrEXjbCrDniUeyEY6LIJlNeJh9ckT99IJLrOzq45xLIVK8KNNYv6ak54gLf4uNnvK/ziVieZhryBvLw3ptu1ver0aL9DbjstBssTfgN+gyFBG5ZdWD4aAbDo3er4pRxEed87FUkq+0i1yIafc6xdvvME3peJJFBVgjHT+LBvttL4aDcgz7+NuN8hDbt8MDF5y82bA5kmXRqoiGrjV3MDOMN4ZtNISmf4OknzApmcp5kItI+9fWobYLxAtTA/ukIw4dJ5N7cuTQvrOyh3nDYFz7I37apUL6wVsK1hqZ48U/EtwOzQbc9mriR3/xqYGzaw6aqhYv7vKpkFxJsXidryDi1tvfUOnLlLbIB8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(54906003)(38100700002)(2616005)(4326008)(316002)(4744005)(186003)(31696002)(8676002)(86362001)(66476007)(2906002)(66946007)(110136005)(53546011)(7416002)(66556008)(8936002)(6666004)(31686004)(6506007)(36756003)(6512007)(5660300002)(6486002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E3cx+GVVcnBIS+/qLqQ9iDa8K/SHMOWgN1Z+iwOmBp81PDug1uJHI9eaiTDS?=
 =?us-ascii?Q?7v5Myf7r10UvERGR4g3emnTtLWjWFjh+K9bWM3WMF1W7tIbzvZaFenIQRiC1?=
 =?us-ascii?Q?TPCuGikSRu+vcDqIuI9BIg4wMpaG42ZJWsbVkJdgXmQxZkUUCr0yyReojSPy?=
 =?us-ascii?Q?Caaf3dCuT2K0ESJNHxPl/B+Yl5SD+dMEtoiPhgP2Fa7OzsxL9kn1Eu7o9Hi6?=
 =?us-ascii?Q?/Lh+mxvS69TgzJ919YD4gNgmgdsgM5WJB6uWG/E5AE7yAgQbZIw6RGagFBJ8?=
 =?us-ascii?Q?BaX6kswfQU/XwDDaxGgt3YCRsLVQNGuLd4kZcSXn0LsSCVbcdtcOyLXTZHEo?=
 =?us-ascii?Q?M3HcNh3yCvuDH8Zd5vgHIkTeP1n48yPt1UvdUdDNkI14dF2Z3tLmv0XYko57?=
 =?us-ascii?Q?YO+pUdYwhf1aCgGsEmrT7Ob4jsUNK7EelWTi+TLAE/yxWy6iGIosYJ0xY6LL?=
 =?us-ascii?Q?7pUPXJsrn6Zfr0u+GO/VDKry7Ys6ZgE0xG0Xeg2HwPo5YAGL4oLq1AfWWc0x?=
 =?us-ascii?Q?trtHaRhDrlGhjK2Wy9tM5lorlasHiExzO0oigVoFvFg+CD+QgCPrtEJmPmSc?=
 =?us-ascii?Q?vNbcfVWEF3CMrZ730AzOD7L7F46WqkgsZXGe76NNR3js+Kzg6tLI3Dc3gQlY?=
 =?us-ascii?Q?7sEy2TEx1bcpnkz/zAiJ/ok9H+pyHu2KKk7LMHGPf5C0qL0RAGs1VXPeK84O?=
 =?us-ascii?Q?KsZF0tErxNx0gQIeqBoqkl9BSUjGeXErcY9IQ0Z5hoRLB+skGEG2oEnKLsZq?=
 =?us-ascii?Q?GF9EbMYkEtcLSHQOXpgCLjLBgS3cY55CX3KbGh850++K7b9vLaa1Ev62PW3s?=
 =?us-ascii?Q?zJ6H3WOqJjCjY9ltWqZx8ER10+dah0FhQR5yLNO7WHNNyG+si2f5VIBT8x/E?=
 =?us-ascii?Q?qfzB7bhS48ZNdPk8nXmNHmn6L+CykJCv7hk9uFKwYQ9GYjLiU7QUxGUxtKKH?=
 =?us-ascii?Q?0u7IfKlt73Grm/PpJz8gQ5qEQmZJ+DoHZE9n7PSU56oKn/NFA6avXQcf1HKU?=
 =?us-ascii?Q?eK3hJOeXLUTnzk7BHFmUBaj14FbE+KBKccMSX5TrDRjZqEIUe1IZS9NzQudU?=
 =?us-ascii?Q?iqdADwtHJlV1LsYH3E5rnhU/RMT5D6yY/QnML1zdQfCHITsugVJ5aV045ZrQ?=
 =?us-ascii?Q?ujDZ/FllOnDF/PENlYUrguHhU8cHQ6eZgQbeUyV50S0VMNlGmXxpt+J9/15/?=
 =?us-ascii?Q?MG24TJCf17Iu48+uFBYE7S7/ikgnHu7kwAPLAWEBRfBH5UsibFVDrsSzMh0/?=
 =?us-ascii?Q?J1YEUteq0OK6mJ/+i6lh2aIoONjewt85ElTA/Cy50XTjAZF2vSLjXAwwWx8h?=
 =?us-ascii?Q?+1g4MNTd2X91lTev4hGo+KdmHf7RkxtknFKpeF5QcFS82ZQvinhCmnrTfqa5?=
 =?us-ascii?Q?WlBH5v1lkk+e1ySrLQgrtpbyc74/CX05x0hUuK2HU8ZBv3yNeAMi44FTIKJR?=
 =?us-ascii?Q?P4sDBhyn6KxN4PAGKiEND9Xdre1tbZ601RIrgmc90xMqQdAz4sGjK8Lsmw4o?=
 =?us-ascii?Q?xPQt4hF9ybODNeHUXA8ptX2PAagsCLA3L0Re0tpKSbhxJ1H3EK+GBggBhRk+?=
 =?us-ascii?Q?aF2duLJDP5+QK2F+YrGFR20dxa53c9h9XnF8kRoKEF1u5igJ66iHQQiF2mxB?=
 =?us-ascii?Q?B6H2TTHQaiRqnWdrp805UUdA6WJoimrvPcqW3vLnYKM4J0awUbIY0uBA3NHh?=
 =?us-ascii?Q?1xUmtSsjhKU+dBN9/sQ0QvB0mzRryyQzCi7IwpqHyMVQjBk9JQnaWvr1A9OM?=
 =?us-ascii?Q?RyOR6Pv32EPjLTn2LilM0LtfoBtYG0Ga83+QJF4X+ULzOwGvFwGEjWtaYX8m?=
X-MS-Exchange-AntiSpam-MessageData-1: ZUtaxseWBnuU/w==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76928486-ff3a-4010-f5b1-08da1e08d20f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 11:20:46.0741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1e41UjiwlDC375uDMzu23WcAXZ6BXmkjN7bh2CQylCtYBITBEP1er7k/jjeu4UeRuLiMhNYItuJMUe26TsWLVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2262
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14.04.22 12:58, Lukas Wunner wrote:
> On Wed, Apr 13, 2022 at 08:59:48PM +0200, Oliver Neukum wrote:
>> On 13.04.22 16:16, Lukas Wunner wrote:
>> I see two options.
>> 1. A dedicated flag in usbnet (then please with the correct smp barriers=
)
>> 2. You introduce an API to usb core to query this.
> I'd definitely prefer option 2 as I'd hate to duplicate functionality.
Extremely valid point
> What do you have in mind?  A simple accessor to return intf->condition
> or something like usb_interface_unbinding() which returns a bool?
That is a question we also need wider and especially Greg's input.
We definitely need to make sure that the interface is not already
rebound, so somebody needs to look at locking.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

