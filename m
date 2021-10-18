Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEC8431745
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 13:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhJRL3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 07:29:53 -0400
Received: from mail-am6eur05on2097.outbound.protection.outlook.com ([40.107.22.97]:22966
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229491AbhJRL3w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 07:29:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mocTDpS/S6l7frDES2hIBj5eDjBBt6OVlQkm0noBeeNdkQySdexJ1qejem+7CU38iu9GVKDxagxnukp+spj3397DBK17ALj5pdm9bNKJAHqbX67hRNi6ZriopQxpB3qUM7WdwSXWKnxCjTRcjwWhEB2Ju6L6cy98hMFpoFCj7qjyVN84x4eyu1tYsu86CQ9ajxWlm/sMeX7WXY7+fhdJRoCoM2AziqCm2tu/jrCyvtl+tkSAmR1+ELAO2B53QeFwNS2RxRwvzySaal3mh6S0nIHSiWrSUO5zYLt7rvneLhxMmYgez4YPTORbyj71uiQVjtqD4RHeqDanmbOm9/aJTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZINK1R7I5glM0tdcfPWpWOOyobDPOGOJJzQMc8fqeo=;
 b=QAvpqKnXxFNwgw1pAiS3kftTblux+c7uPTxTGwVW6vzN+nO/hpAvhBmo0RxEmKlickly0GXWfz80omp2uWA2WJdwIQbayi2ZF+OendGxJ9qktPFEQpFMV3e1LvxTyz5622u0SpA0vOZvuxzLFKs9q3prCXt4ZiTsW9j8XxgxuCevHyLASreNk3Lky7CkQjwprvYpRe+MSEG9S48idZWAuPd8RLp5ZEsnXVOE9o8ANeGYqtvmy+zG38w+jN5GFM0MHhebPUwtfncE6FH04+z/BATZwcvn1licVc9Sezj28AY5DNRjLeIgAb0grz3yCpSTHSiC7tfquWBfOJNYu0AqoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZINK1R7I5glM0tdcfPWpWOOyobDPOGOJJzQMc8fqeo=;
 b=RzyvERph3ltPXW905UM8ZyyJgDM+D5B5oPrIjFOcAGm0E4QkAZpdUHRvi+L8std/6oP39si4auE8U0C7yzUbd+DBZx4f+P/n+F2TIewJaPssJpI+M9gBs1DHbd0OAK3MBkgjbvbaHz6tHtdlxHVvJBYzNzQ+pxFHsIPCZYHxs08=
Authentication-Results: agner.ch; dkim=none (message not signed)
 header.d=none;agner.ch; dmarc=none action=none header.from=toradex.com;
Received: from DBAPR05MB7445.eurprd05.prod.outlook.com (2603:10a6:10:1a0::8)
 by DBAPR05MB7448.eurprd05.prod.outlook.com (2603:10a6:10:1ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 11:27:37 +0000
Received: from DBAPR05MB7445.eurprd05.prod.outlook.com
 ([fe80::98f8:53ac:8110:c783]) by DBAPR05MB7445.eurprd05.prod.outlook.com
 ([fe80::98f8:53ac:8110:c783%3]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 11:27:37 +0000
Date:   Mon, 18 Oct 2021 13:27:35 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        f.fainelli@gmail.com, Andrew Lunn <andrew@lunn.ch>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Agner <stefan@agner.ch>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] phy: micrel: ksz8041nl: do not use power down
 mode
Message-ID: <20211018112735.GB7669@francesco-nb.int.toradex.com>
References: <20211018094256.70096-1-francesco.dolcini@toradex.com>
 <180289ac-4480-1e4c-d679-df4f0478ec65@csgroup.eu>
 <20211018101802.GA7669@francesco-nb.int.toradex.com>
 <a06104cf-d634-a25a-cf54-975689ad3e91@csgroup.eu>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a06104cf-d634-a25a-cf54-975689ad3e91@csgroup.eu>
X-ClientProxiedBy: GV0P278CA0036.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:28::23) To DBAPR05MB7445.eurprd05.prod.outlook.com
 (2603:10a6:10:1a0::8)
MIME-Version: 1.0
Received: from francesco-nb.toradex.int (93.49.2.63) by GV0P278CA0036.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:28::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 11:27:36 +0000
Received: by francesco-nb.toradex.int (Postfix, from userid 1000)       id 7DD2310A08AC; Mon, 18 Oct 2021 13:27:35 +0200 (CEST)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24a476e8-1530-40c4-8805-08d9922a498e
X-MS-TrafficTypeDiagnostic: DBAPR05MB7448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR05MB7448D6D698268C3BF9F99BCAE2BC9@DBAPR05MB7448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hxb2cpN/0QoPiBYS1X6VaIkjgUhYDT6Uj/RTDaw/S5jo5jbxEqXG+0/wSr5GaOOgIi9wsisk76UDTFCj0l0j9bNHTlc5tinIdbSoU72O/G9tlh5IXxl7qSCr/9HwmRHE4wUsXl+3/CQGY6laAiaojR/0HRdPx97TPrPFufHz0TDcopIusRmbDDKbvU+HyQYvf7V4b/ywPDklADkVqwCLjfSTJZyomdbM0gLeEU3oDpaf1A2gXyoGYzTS7x4QLQPUneyOJ2sx09cMpSYAeM1z1qpkMTrVuLR8FNoClMV4+2Bb61zN4N7f95bkA1sIVRm0pCeQHagq2sygAqX68dbhjPTnm3aO9o5OeZDpuAag2bTjvuay+OMqpNzYbkinyM37pIwG5TiFSrjgqJcYHuGPSDypa853G7d5uY9l/rUCa4cxPkx+BC9dku79YMM8eruyCHhKz4b7OYQEJbvqWV2XG7zs3PbViXrJFAufif2Dqw8KYPBUBFbUXDFadXb1cD1+CeHzdrko/qIW2On3ncIemhUaru6oZ/7d6KlWH2u3IjFZ6EeIcuCUjCR/M7EXwhY3uK9nBuSH2vLZGI7Cl9Jz7ufX3+eQmvSb4I/T1n++phdFebs4rTA25aGWQtgsnMzP6liQhQILVHavCwrIxN9DZVzO/l1J0M+cNQy+WvAbtsJHxZDKHf1veLvZ+SU+tfHXgBs3+XMG+p/R98h/6H9nsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR05MB7445.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(376002)(396003)(346002)(136003)(1076003)(83380400001)(86362001)(66946007)(66476007)(66556008)(110136005)(66574015)(508600001)(38100700002)(44832011)(186003)(8936002)(4326008)(8676002)(52116002)(5660300002)(2906002)(26005)(7416002)(316002)(42186006)(38350700002)(6266002)(54906003)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?310ZYG0e/DALEYMDlGUwDfOa/UaQh5myxwong4S6BzcH12mtkViOxGhRA3?=
 =?iso-8859-1?Q?qkOe7sQ6OLLXMZplcbME70qT9ndwVn2GAA/qIzNnehcZ9QAoWzP9aJQLG/?=
 =?iso-8859-1?Q?xzmHfsZtjSqcE3n5ocOglIYC/lflz4USoKkj8brKtbX/QVDk2oTxb9AI7w?=
 =?iso-8859-1?Q?o27ymAUGBIbInolFUzUjFvCH7+PLqo0Bx71uy4DuLx0d0gFIUDkaYtz5Kg?=
 =?iso-8859-1?Q?B8eeGvyu8hbi6Un/XGDKD05Thf39GDnkeshEC9SzwGh5V5CyL5ZRJPIsB9?=
 =?iso-8859-1?Q?oWAG6fURoomv9FciuMtY/dQkIvAFPgYIMqU0HZ0LgtgUNkT4MzwWtBKCJW?=
 =?iso-8859-1?Q?ptOkf+1WEL3/Bx9qjJBhoX7roGmsKOAXb87Qa58oiXZ37ciR/2w7KEwEFi?=
 =?iso-8859-1?Q?oOZ28hnNDnedShlKPm/N1iSZM+JnA/sh4l7KL+LhGR04rMsEMWglSf6vOa?=
 =?iso-8859-1?Q?ggiSFBojoZGrR78PgOV6z9Ue2m90e9XCUIo3ATeVB1k9hwgiee2hhfeieu?=
 =?iso-8859-1?Q?dvJVD3OcWU9Cd7zqek+32dLmfmFCwAtbnUcrgY5XAc6dFoJX4u57fJ7nGS?=
 =?iso-8859-1?Q?TtWwcnE5wdKSVFGx8zDvvmFEn7udBJ/V3+bI3WaNqFi/SMAWN0rrmgJ9NL?=
 =?iso-8859-1?Q?BFNYa0zHbFV59aLlFqRQgMn6FDMktWK3xB7LLOHzRFK1uv/niQ8EgODtaN?=
 =?iso-8859-1?Q?4GavuDe5F4dMlZZcid8azSeG/T8I6ArApyZv9cNScFK0kq34B7NfOsk6jI?=
 =?iso-8859-1?Q?xITPIEdZMBkv8Or8fzZxsXG/6v8dKncKW3vs1kV2SZwJ2rw6F9VEGmKEQu?=
 =?iso-8859-1?Q?3ixWZCbfUQnbKCoMsZe9LEQBn46WAy1hzo7/ru18HuwJ17azuieZVhWIpo?=
 =?iso-8859-1?Q?0j03HstasUjr1Mflp+NL1aGNCiIWjo8aEcarNdCJvibfTcJ6BisOQ6MwRK?=
 =?iso-8859-1?Q?W5OE5KmC+NwqY5vcBQK37uP4AH8o1AZxugfwUQTpR3jR1maBcF3MmYV7aA?=
 =?iso-8859-1?Q?CNI6LcfPfKKGkuFd7Q5xYTA1c3EFY2+QeXuMji5eJ+L8D/qXn5SSdq/Or4?=
 =?iso-8859-1?Q?XcmEgaSinJPcHDwWBC8LCzWIuGrhFmxmfKQW+m+rno4PdTR14DuboKnhbp?=
 =?iso-8859-1?Q?lkspRBzixT70hW4BT0e39a+AY87JIft5YA+yTtcir4WQSB8crHobW/7S/1?=
 =?iso-8859-1?Q?kPJ1cNK7saxEWH5HRp3KJ3Zk84mGrqmbehIpaBot532Jrfcs4vJFgoE8ox?=
 =?iso-8859-1?Q?dP6RThIdf2RfydIBkq050g5p4JkZNxtZM9kimjfwqF4mS5GofIzFZ1im13?=
 =?iso-8859-1?Q?GmcYZWx0Ux2q2sQjSWRQhRj1JWK9tX0JXe9I95GTeT9Xjfhx3mA1GMidFd?=
 =?iso-8859-1?Q?/brumejHwd?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24a476e8-1530-40c4-8805-08d9922a498e
X-MS-Exchange-CrossTenant-AuthSource: DBAPR05MB7445.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 11:27:37.0751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AxHDfSChq/jTHAajznVN2rCUrY7K6RTuKBN+Ydw9DgiDTNBLkhkNpwB5ZxKd/AbsieBRq8cAGzg6QEopedu/PF2YT7HZw74/eZrDKNn4ZGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR05MB7448
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 12:46:14PM +0200, Christophe Leroy wrote:
> 
> 
> Le 18/10/2021 à 12:18, Francesco Dolcini a écrit :
> > Hello Christophe,
> > 
> > On Mon, Oct 18, 2021 at 11:53:03AM +0200, Christophe Leroy wrote:
> > > 
> > > 
> > > Le 18/10/2021 à 11:42, Francesco Dolcini a écrit :
> > > > From: Stefan Agner <stefan@agner.ch>
> > > > 
> > > > Some Micrel KSZ8041NL PHY chips exhibit continous RX errors after using
> > > > the power down mode bit (0.11). If the PHY is taken out of power down
> > > > mode in a certain temperature range, the PHY enters a weird state which
> > > > leads to continously reporting RX errors. In that state, the MAC is not
> > > > able to receive or send any Ethernet frames and the activity LED is
> > > > constantly blinking. Since Linux is using the suspend callback when the
> > > > interface is taken down, ending up in that state can easily happen
> > > > during a normal startup.
> > > > 
> > > > Micrel confirmed the issue in errata DS80000700A [*], caused by abnormal
> > > > clock recovery when using power down mode. Even the latest revision (A4,
> > > > Revision ID 0x1513) seems to suffer that problem, and according to the
> > > > errata is not going to be fixed.
> > > > 
> > > > Remove the suspend/resume callback to avoid using the power down mode
> > > > completely.
> > > 
> > > As far as I can see in the ERRATA, KSZ8041 RNLI also has the bug.
> > > Shoudn't you also remove the suspend/resume on that one (which follows in
> > > ksphy_driver[])
> > 
> > Yes, I could, however this patch is coming out of a real issue we had with
> > KSZ8041NL with this specific phy id (and we have such a patch in our linux
> > branch since years).
> > 
> > On the other hand the entry for KSZ8041RNLI in the driver is somehow weird,
> > since the phy id according to the original commit does not even exists on
> > the datasheet. Would you be confident applying such errata for that phyid
> > without having a way of testing it?
> 
> 
> If your patch was to add the suspend/resume capability I would agree with
> you, but here we are talking about removing it, so what risk are we taking ?
yes, you are right.

> In addition, commit 4bd7b5127bd0 ("micrel: add support for KSZ8041RNLI")
> clearly tells that the only thing it did was to copy KSZ8041NL entry, so for
> me updating both entries would really make sense.
> 
> It looks odd to me that you refer in your commit log to an ERRATA that tells
> you that the bug also exists on the KSZ8041RNLI and you apply it only
> partly.

I think I was not clear enough, the entry I changed should already cover
KSZ8041RNLI, the phyid is supposed to be just the same according to the
datasheet. This entry for KSZ8041RNLI seems really special with this
un-documented phyid.
But I'm just speculating, I do not have access to these hardware.

Said that if there are no concern from anybody else, to be on the safe/cautious
side, I can just update also this entry.

Francesco
