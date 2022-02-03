Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8464F4A851B
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 14:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbiBCNVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 08:21:13 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:23365 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233495AbiBCNVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 08:21:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1643894470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fgEqoVzvk+pCK5XKar6b4PrK5+z8/ItBRkwYJwPDhb0=;
        b=h2a+p6iD3exwGCmS4pztUsN6cAlT5P8kUBxo8FpLBBcOzgGfoYFel/xae6yHgtXj3MXb+O
        EXFQCR+g8PZYFSOAS3Nt0nUIYn+DIP6DjSWp8P37BKw2Sr5VxmbnuMyAWY/EJwvZMI+fT5
        +ELbzMFF74Vju0EA24VpmUmlu1Gw00o=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2112.outbound.protection.outlook.com [104.47.17.112]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-34-8VvdXfsNMAaGJvqAp_82mw-2; Thu, 03 Feb 2022 14:21:09 +0100
X-MC-Unique: 8VvdXfsNMAaGJvqAp_82mw-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjyyWJoJTp0mqZY5v9BmXRJuu3V7yPYgYflveF/LEuQiO7IhUOkS8rzXag5Q0skAELV7EC9wpDvatj0nh28VgqmXBAGfswwG9Z724ddCteiRuB58nH6CRDfvLysS859IUdl8M9vKHODoa0ahEsqxl0YO2FjyxEuT+/wBBAqR5a+xjiP/r6Bz7e94oYexPiQY1/i5HICZdSM2pxcenCc3Ktp1lPr32P2DnsjrgRHlTodlY8yuVCQa7yGJpkoPf/0wkKMbSn1x9hVgde57vzn+R0GhnJqkL1YuPkKNGOUflRQv8ZzGVm8KH9q89+Fr3pYN1h2Y2aa/0GOmxLN57FuB8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nZ76lkzxbtrGWQUl9oPhyy4zIRYiWVp+9EZXD6sbLQs=;
 b=oV/4Xpa+ENVPofxvWYXyie/xZF398RdofP+JMAMWqUo2eGFs6Cnpy+0KCROhKe56nONgPZbbEcpy2u1ncmejcXzSaDDlqwmbsnntKcQm4KQ1EYTTPePliZjviQuSf+nK0Gm/OEoBgy1Hd9hD4YeMkvEji2hRLuONYrGyAlXfisG/sYa+Z0MLsyXII6ab58ENmmJWmRB6Vwlitp7p7CXLcdVOX9M8jvU6KjHVw1KoTIIbME+UPKv/WrN+fpUQJC46TAIGhNuk3DBP3+RQ2/eyeUHhQJyrJ3p+jckXrIX2wj6/MBMxkfuPixqvHryrdxAMLXdx5umbOSh4FR5f2F5NTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by PAXPR04MB8350.eurprd04.prod.outlook.com (2603:10a6:102:1ce::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 3 Feb
 2022 13:21:06 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115%3]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 13:21:06 +0000
Message-ID: <eef8994a-6bda-8f72-c299-b3f133301f30@suse.com>
Date:   Thu, 3 Feb 2022 14:21:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v1 1/4] dt-bindings: net: add schema for ASIX USB
 Ethernet controllers
Content-Language: en-US
To:     Greg KH <greg@kroah.com>, Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-2-o.rempel@pengutronix.de>
 <YfJ7JXrqEEybRLCi@kroah.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <YfJ7JXrqEEybRLCi@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6PR08CA0038.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::26) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 314dabac-8d32-44b6-28c8-08d9e71808cf
X-MS-TrafficTypeDiagnostic: PAXPR04MB8350:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <PAXPR04MB8350BF7A8DFF5027AAEFC6F5C7289@PAXPR04MB8350.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TDTiD/qNmCBwTRN++3TyJ/XlIXAyyX+hYuBNawXcxJfiju0CfQYYJRAHBz/V0R7qh6+J9X/jjlR1DBS7CoUuKi0igLYWvJ6uSgbaHHbkc4oVd5Lj3S90WXS0n/0EIc3KThsqh2zbLBI3I3XozhAM41Zufih63wEPshd1vQCo3ty2hLIf0F7jGXwPGjWy/f3qaRW9KZ9dic/pJAae5HJ+zAPveleozFwkuy+sPJfCKUTYQ7O8XNmMz6GQVvCNAaPC2PrD93/tibQ0fSV9FcqF9nSVDsQXzAaFVMV/LnIKAHGvpdMRbxMFnmszc5cEEDMx0LNeDBB4V0vFIlpwAnnOIKiBwLgcx/x2xL0FAWZAOCmoMuGw5alqwsCa4hOVB8XSUy/9ZCXvhj3k9O6yXc4IVIndnPjF6YjzzY7XW+AQ1FldlCZ5OzaDx/+eEZBU7lnoGne/oTuPHEHKPQo9qMwZf1BEChI6G7y5BfwiaCATtcjDniTC/+gNwJhRnE/x+ErhpX2+5RoiY6o6OM2DJgqluO085fu9zq2hC8d+DZZ5ESQ4i2p79UvnlaE2wbG9I6/S/QcNvTXb7Yho+lV0JuJ4dvps51sLcNi/OL6m/4ebSkIxUpnhZJaZaI5j/Y0B1Y3aBB58xqaKukrZePaOaFDndFSo/a96lKq/uuR8Qco5BtAYiiXjbnIS1hT/zN/6KYUhbiWDV1gmpRtfeiU10AgQHCYfkiGqtjhW9AZNCo2ZnaWhOeKtgx6PpGzni+/kBfo1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(316002)(508600001)(2616005)(86362001)(110136005)(54906003)(53546011)(31696002)(6506007)(8936002)(186003)(66946007)(7416002)(6486002)(66476007)(66556008)(36756003)(38100700002)(8676002)(31686004)(2906002)(4326008)(5660300002)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CJD1Ln/hFW/3q6AH+1DHT7JDrHUv4aTyyJZa/+82TOjCso3gRDu3shbPfoC+?=
 =?us-ascii?Q?GfQbujRkgVqePQ00RNMbrPDNxVSltkSMIMX1YaUK5ZUOC3Y8L0IeTXP1JIcA?=
 =?us-ascii?Q?8p+eDh+fQRnIXx4oZz12oO1ORrTOKeDeYNNB9bZMl87RcAMJ/5Tlk/57zk7p?=
 =?us-ascii?Q?OKc4M0706pwK56UkGV8CxqvWCOmuuFkXaPk1jCQfERQdst4FV+zfMHzhvoJK?=
 =?us-ascii?Q?jzKPLy7DSW1SSAe6TrTp5Vz7tnU08jTtYMelyNedkVE/SlBOJAXXxj2pcBN7?=
 =?us-ascii?Q?lmwySPvpdq6xF1V+cGx3A9gGVNP9wVObVfLNkcXfV1nam3yyN3cx/PpU1TQl?=
 =?us-ascii?Q?EQdXcmZzZTpvdtckI+m9LPC6jhFV7HpNxNJlEdXL6mK9bJZtk//Fs34iZDEe?=
 =?us-ascii?Q?xNH/ptGFeQ1sqp7DQvAXt3bbsQtOVNXsXtYwIMSsUUmBPxylHdzP9CJzTNOk?=
 =?us-ascii?Q?LLW2nfbXTAEk+np8X0UWvbqq7g0XSnPZDwYIsdAnz+YZI4m7W/m8qbil5DLn?=
 =?us-ascii?Q?kyeu1ZQk5aFXTn/NDZz2AuWOVOUXLxG0J8UiWq1MlICOxGWaYiYMqGYC/Nmk?=
 =?us-ascii?Q?gegBXt8c64PhinBu46NawBNlNkjZFVcPq/B4xJWJKqHsxsDy9PaD7FxTK+/b?=
 =?us-ascii?Q?ZsmrEHNcgruEOQaazM8d6S/Zk6v60g5vXupbYwOzNudXiRtA+pjAIct973bR?=
 =?us-ascii?Q?BDaAaMyJuiJrpInI5d004lJhNFjgVP+Y9QhlVufNxUEXVX+XcHAiSUZjFtfE?=
 =?us-ascii?Q?9gBpdaURsFuLeWzhrHHlpu4bd4vukxLsM1dn3FZk/d6LR1fa++2rx9yC9wg/?=
 =?us-ascii?Q?32oSKbYr6h+99RQaAxNBsONuXNzzJRS+PoLofKQpH7ViaPtF486CXu7reGzq?=
 =?us-ascii?Q?ChP71yAIc4ZL/snlSg2EuLIGShX5YwOUj0zP5YYE1Em3rAo88k/7+JVOyFru?=
 =?us-ascii?Q?k4o870fkM6jKTbH9LeRyYWNyL66Ez8yqFzUDd9VfaOYJjWXpcS8zFqP1aAMM?=
 =?us-ascii?Q?84ZZJAQk69844hkg8qBfeANjM0aPGNvPm0KQ4nDRNIa2yTfv6p18BViz17d6?=
 =?us-ascii?Q?VTGEuYyzNmXxlTpMegTkvPuJzczzPRLPsr9EPaZBGWuQDc6KR7w04YOVdty7?=
 =?us-ascii?Q?HI9uAR0+jnfOkvudXBYVHgKrOpzx6Y/Gnij91y79q5X2qfeLy6rtdqN1ZoVb?=
 =?us-ascii?Q?cRqtSFBN06tdZtwQSy4Ym0wZUYdIBAG7CCtTeEGes6r1Pqj6U3fmr4UU225F?=
 =?us-ascii?Q?lZbUY/RLVa+kD4eZBtXaqTd24yDmuv9OvejaKLcIr0XuZApRxDXllUcdCrR7?=
 =?us-ascii?Q?kV9admix8cZZcQp89++dOiaSP1uAqVRj2HziL0+irgCi9BzAjL5CZgzM5dcr?=
 =?us-ascii?Q?aitxXdSZCGHWMUO3PIZ4Lc/Zu2ejF5o9/uIR4IOjIaalwpSQpOVZc0HjVn+h?=
 =?us-ascii?Q?O1pbeCALpPmnyNz9BD8mdoJy4CYbOnuJmSl4YYexkjNkOiZRGXBXcAK5HE0O?=
 =?us-ascii?Q?g6TMrJxMMls+8kYenhsn6gFz9leP/1npcADQtwEFHnr3EiSXRZjfWwVFUPXm?=
 =?us-ascii?Q?1BahCIYy7A+UHqjfEifmw1OrsrMlqlsCaKwmQGzEyDi4LzBBwjtM6vCd8uEq?=
 =?us-ascii?Q?ps+P7nb5/4t/mXDv6CrBh8Q9j5r0eKdOD8yhAD1EJEgeO0q0Xrsca+OKepRR?=
 =?us-ascii?Q?G3vAqTBQywL8cikslMzsIhuUgh4=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 314dabac-8d32-44b6-28c8-08d9e71808cf
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 13:21:06.3911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIlpUtJxIodquPmGoGy6YbvOz8AUf21kGOtgJk5odggf2ihxpBkIVtb1eCwmHSEvBaWJArellGTBWHtbRN8OVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8350
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 27.01.22 11:59, Greg KH wrote:
> On Thu, Jan 27, 2022 at 11:49:02AM +0100, Oleksij Rempel wrote:
>> Create initial schema for ASIX USB Ethernet controllers and import all
>> currently supported USB IDs form drivers/net/usb/asix_devices.c
> Again, you are setting yourself to play a game you are always going to
> loose and be behind on.  This is not acceptable, sorry.

Hi,

having checked the DSA subsystem, it looks to me like
the "label" tag is quite common for those setups.
I am afraid we cannot tell the DSA people how to build switches.

The question then becomes whether switches using USB
internally should be different from other switches.
I'd answer that question in the negative.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

