Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D26D4A8184
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 10:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349725AbiBCJed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 04:34:33 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:53514 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232576AbiBCJec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 04:34:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1643880871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ncw2kWOjez7dLFA4O9EPyyiSuZ1gSc3/hhS10AUsDs=;
        b=WOMGvzQ42Zb0wPD7fkwGjfPEA3/KLS+FiGStTr0rAIejePuD8AH3v+dIOvTvsghU0Ezn3W
        GJNgKzLd75srPg+Rg8JW3vmbE3YH3DW1+GnzqOwq/giJsCpz0fdUZWzUccKy/HEJsBwo8d
        7t8Pw0lyRW+x9oZC/5q5POelI3WpcmQ=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2056.outbound.protection.outlook.com [104.47.14.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-2-DpU7YE2EO5uS0LMVMatmYw-1; Thu, 03 Feb 2022 10:34:30 +0100
X-MC-Unique: DpU7YE2EO5uS0LMVMatmYw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/AY7xGmcK9+jjgXy5uhWZb74ldJjwiGaDvrl/vCtfSPAK5hPamE3gsaWyxaU8t8UvUX4nQaFYH51XcnPUjl0kMSVLChSNC+bY8x+8fhVSZDKGLFQi/vwSQaBVF4H/ynQo6IbcyojY+qel908IHmzQh0kh19D529NMvjz+s3VONgsVg3h/o65PPAdpSBCOsfmFXKeyoBr8/xj5mHqEqxKWFQvG7Mr1IGK3zHnLrHwJq82nKY//UjvEFflybpNeeq5AXPPNjjOZW1/TKWcW1UBoazMokzCz+r60Tnw9Fsusw+UFGdVsY5EoGYJKKSUIHaDbzJW2vSKIpv0YhxwQIWrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVQnAXTf+AO9z/BWyyoYFdEUMdk+E4fUWk8PA8/BvGU=;
 b=Yp6pbJN+UhnK+tq84RFjbtG9grKHu4mT7KeaNxUTeGO9ynRefGzT0boYX223eSoLU2el8P0corzMZkMgCFcrITL4aswtpShBxu0N0317RKIaR6nU+aMpZgaWcWm4BnuKP7EGqllEBv5eFv//8naGFAsfOJqODmHbVuYJXLVdqNS8SoK8J3YgF8TjgY80fWYBWmL4J9eMVWYYUBLb2GMEOHolpMksxzm4NqohepFBmc7RADZ1QFik+wqYhr7hP5rGxWcxY/umlvX7QqQJZ6WQOiXhubGhNe0oQswt5k19JNeCuzKmrTGmOSO8R06SHkBv36aekWM8MPJD5G+p/9sW/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB6PR0402MB2695.eurprd04.prod.outlook.com (2603:10a6:4:95::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 3 Feb
 2022 09:34:28 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115%3]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 09:34:28 +0000
Message-ID: <41599e9d-20c0-d1ed-d793-cd7037013718@suse.com>
Date:   Thu, 3 Feb 2022 10:34:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v1 0/4] usbnet: add "label" support
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <YfJ6tZ3hJLbTeaDr@kroah.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <YfJ6tZ3hJLbTeaDr@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AS9PR06CA0044.eurprd06.prod.outlook.com
 (2603:10a6:20b:463::35) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19d15b70-823f-41ef-9aaa-08d9e6f85f84
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2695:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2695350EB12A4E6701F398B3C7289@DB6PR0402MB2695.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZCHVCQWHBrbtmm37EsYsOy+54lr5DRnStVuAxfuFHgFZrOnRNGOLpbAjXcQNTca0Cxm/pS4Pdm/JQQ9CCBxbUleO5/iyLqtW2/c2GiFf2F0uJfVCWna+aNb0+OVseU3Jky0l1tAdAnbS5OHEr04Mye+rz+bMfG7dO2BOKUZCQF2DgW0xJ8wXiRHoYmfsa9sGCRaYwc3OH+ihaq/PlnmStBvr93ydy5/QI+xrsRICcK80yR+nND2aB37b2gHjJAEB38Sji//LJf65Z6OFLDlxR8HPSJr2H1yy/5depEyWG0jMd6DEHOyuojukaV77adMSRZAr/OzEpQ8CL0qsIJRq87gT7RAw543VI2SPD5atndw63z+4A9q7CL3ihwvA8DBtYPKiurT9pxpUE9gHBvwjNr4miqZwp/l7sR7YKS1q7oYCJ8hBR9Drn+R9r5bUFC78/6pKRxZbguI98DnZIFzn/nkjyzZ2Jzd6MKtm7BKQSFnFxhs8bKJ+CUoX0wvSGlUiem8o8gaZm2DATXc605dZn2YaqHsy/ZW+RhlEDZLoSP+I8MLOsHn9sX4KPGOyf9upuPvgLsqC4I6AY0RfOfC1zFTlOZRUhp4ePH/XEWMkB/fzZSUb9KT5Azp36ZTLn0mNB5UhTocozNV4GQQ8qfZ+dhlJjxXT84OjrmH2dghebyYQyb0XJ+x9OKLWVsPkXmk98b50X8y7/jQGv8NGFDosEndp8+obzvh3BidCRuF6bKU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(31696002)(110136005)(6666004)(53546011)(6512007)(316002)(508600001)(38100700002)(6486002)(54906003)(86362001)(8936002)(8676002)(83380400001)(4326008)(66476007)(31686004)(5660300002)(7416002)(66556008)(186003)(2616005)(2906002)(36756003)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ysvhQBICXpRTicbiH78qwzChTCfDVe48S1ZSsN1ILjg12TIlbQvr+W9veZUP?=
 =?us-ascii?Q?79PRkiTV+eNxir1OZHVqGi1zdYl1Ao4JVtcf9N1qnzfBDkZfAU3BXzlXnYrO?=
 =?us-ascii?Q?Z9sdEbC6ehJGsFqUTuUy0g/bbNRho7wWRKZHCbqi9F28w5NNZeJQz8ZiSLHD?=
 =?us-ascii?Q?kEebKLJcUobJAXnkCISYypmQTrCJO1eB2WPRYn4y3UYHlk1sovOFvvbgQC6P?=
 =?us-ascii?Q?s5EvzwPZrfvRnhdUU8eJM9G1E+7vc6TbSZ0vxbT6JEMEFfiKL13ctGQffwib?=
 =?us-ascii?Q?RzwjtQw9rZwpRbali8nml78TL359PR9QUCvVOBWX6bvwjSHXzyi1UA/oqpsW?=
 =?us-ascii?Q?SmIx2ZJ/14017inP+AvKqDze4x9JFg0RlgfNo0ePwKXnQgGbRgGL9zGUtR6/?=
 =?us-ascii?Q?ANgc6/RcO0r356VLy/fktf9KWAGXwUcFXknbdZomUZootvEiV3o95WLlr9es?=
 =?us-ascii?Q?kvp72FRZLcQsz2ZbR/20MXC/8d3HUSzLI48cFxMxCngaL6t47OaCCiH47u1W?=
 =?us-ascii?Q?3JTEJ8x0uPztKBCB9QzTM2ewiYbmGsTBuCiS9HU9tAPUiK7gh6Dze2ezYwkG?=
 =?us-ascii?Q?codZiMwmd7YoEHR1I0NuxzaGTxOxDVQba5qWqyA6+3uFXzL7yr/I59+mcavH?=
 =?us-ascii?Q?22KuK8dtnxKofmZrZ3f8H1hfjtddNJqjv8X8U3svX84abA0JibYC4ShuvWGn?=
 =?us-ascii?Q?NNN6SCAFaXri306dUEUebSpncfIUD3GAqCDdRw+Hxk8adNrU5PepsfWp57+Q?=
 =?us-ascii?Q?CZukQYIQOKJhm77nUMpuMut04nxgBUoE6XXeYGIwY0KH6Ve1gUX4sSKEHbNT?=
 =?us-ascii?Q?7/XWFjTA7p4F8zGQ4mlIwAh+01cytw4VvZmalxkpjjU9QZOkr7dRhLPtg9Gh?=
 =?us-ascii?Q?TwIbRkM3/pfL7DuPAhc/TuyrPIarCL6NxbD3FB6QZkqCzZcKwukN8QReDQPm?=
 =?us-ascii?Q?W2g1Dac6aOrV6BTUJ2cbwclQR0XQUx93mrrN15C3nRPr+hLZTDsqh3j4yr7L?=
 =?us-ascii?Q?68S2v3iLczPIaHO0x56N6LjdwE5m8ZcVXk/Zr0Ci0NabGU8iVM0zD8pOm8ME?=
 =?us-ascii?Q?NLsxRNaANHfnmgXmt2mU+nafQXE2WNDnf29bNQhOWrUbYexs4gg1yXaBpke/?=
 =?us-ascii?Q?6yogC+gJ2+NPdu1ufflWKM9UcxBsKiu6xKmLo57AecgXYFfn+gR8L9JGJPLZ?=
 =?us-ascii?Q?qPgMbpUNz+VFHuJDJsMRuAal5jnVBYtkNWdDxXfX7b4KF63fyqfxU3Fp5L95?=
 =?us-ascii?Q?8uTSbQq+NJxNkIBewWfVhAbjwitM2RNVTmNBRrs60j3lLfB7kJ28XSeSYuZw?=
 =?us-ascii?Q?x8bI0ABXTy7h4gb9E1fcUTcnaRzt143JyVxaC4t8E4GONxHXJk20aNIcn2qg?=
 =?us-ascii?Q?gEmvIwOZUDr3lRrz72opDlxBS/1mHQ8eMBZr+mOlQe5it5C4qIClSVUBqKXI?=
 =?us-ascii?Q?aqucjkP+eb5QH058oTxwpooMDKgd6vpr8Iyz9lStQdo+m0Vlcr25DIlgK0Mj?=
 =?us-ascii?Q?XHvigEMhFf0P4TlYbUDdkk4Q4TSQDxECbls6NlYH/V3DC1XRBuHD4IzU9Sv1?=
 =?us-ascii?Q?pKKVPK23MD3nrRHX1WMFJwcVyaaOhVK2uowMOA4Wd4MrjVcXPAgm34BV3yG8?=
 =?us-ascii?Q?emWqSBz7QjhZ0lavl1jsoYaRcXPOrGYP6kiyiezbSIrviDYV6zDhGYE3wO9Q?=
 =?us-ascii?Q?QFM7Bffn3u/Z+42VhidnSI0No/I=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19d15b70-823f-41ef-9aaa-08d9e6f85f84
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 09:34:28.0783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tpUedgDFUadFZDqPQbubuvl46Wn0kHpdGC0WU5dGTKo8eFrGjIl33qazbQtuO1c8DGFBeSNhQWsno4aXcSMSmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2695
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 27.01.22 11:57, Greg KH wrote:
> On Thu, Jan 27, 2022 at 11:49:01AM +0100, Oleksij Rempel wrote:
>> Add devicetree label property for usbnet devices and related yaml
>> schema.
> That says _what_ you are doing, but not _why_ you would want to do such
> a crazy thing, nor what problem you are attempting to solve here.

Hi,

could you at least describe what kind of systems we are talking
about? Is this for a limited set of embedded devices?
Are we talking about devices embedded on a motherboard,
which happen to be connected by USB?

That is, are we talking about another kind of firmware
we are to take information about devices from?
And if so, why are you proposing to solve this on the
USB driver level?
It looks to me like those devices are addressed by
their USB path. But still there is no reason that a USB
driver should actively interpret firmware stuff that
comes from a source that tells us nothing about USB
properties.
In other words it looks to me like you are trying to put
a generic facility for getting device properties into
a specific driver. The question whether device names
should be read out of firmware is not a USB question.

I would suggest you implement a generic facility
in the network layer and if everybody is happy with that
obviously usbnet can pass through a pointer for that
to operate on. Frankly, it looks to me like you are
implementing only a subset of what device tree
could contain for your specific use case.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver


