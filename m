Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C41B2F6268
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 14:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbhANNum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 08:50:42 -0500
Received: from mail-am6eur05on2096.outbound.protection.outlook.com ([40.107.22.96]:55905
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbhANNul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 08:50:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVMHcfAGbSISwpK4pyZ3/AxyUGX8d/tCc7hR7lheC87IUyvCT0Ig2d9dMSaZUGSjfIe7uRYBDKRJwYMVeuIIzx4mSYgBvNjx96NP3NkHtAGO9OG9ADKWgekUuVkAEouyOoFtJwldUP0QqUmRhhfYvUI00oy2LHBhyb7eZCYEsX28zneW3SlK8nXT1n5eV8vLYh9HcgTUVmXaCxKGGwr0AwaP4VE3ot0iMzgSleIFQ52cvJLVLsIBNnCQp7HB/8WKlj7tTI9e/sHN5Awh/YiJFdFcJBmz0DfGzqCPhXuJ/MlEoyLGdVl7DYlckf5OwKk0N4MWq/XgqkFC63pBNu779A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NqgTtukvBENHxtXS4gPssyxg21DwjJhB3ZU/68wEslQ=;
 b=nQ9SdrwlDMQwfRMKth3rLcMcXb5WliUtrgkeQ3GoT2vFG/BjAKxyKvYPkQdntUQUrbZehikED1if8ClEqiRD8RSQ4qK5IeWZVYZJVv/sRQIMFsjErEl7PfzRG7b+nuM1xS/ROn8pXpeW8hyuwklO5IjTAqRBmtpAgyEGi/Oqb/nIc3MwAdSOG0xy+II6C1Wie5xQX9LbYw6tfjc3bfuH+UVINB7hPftGy6eAhFFtsYjFbFRg8cifThSrs2Czs/226fKYQa8Lci7wPBQH2cDWZn/qmrpJA7TgYztpkaESjhhcXvzVwUYhUCu7fM0pKylx2dDO21DjjwZtWQBH7lzXuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NqgTtukvBENHxtXS4gPssyxg21DwjJhB3ZU/68wEslQ=;
 b=UJZIVHvFIWer04CSGx2IUxsnBIeo0KYuYpuhCcoxGL9i1vC1OCXwW354NWm/72qiI9XraLgYt6BpExye/t4pzF4Uakw0BTqMCxRpP89AFsKXwB0SGqv6rNxPokEBweenq2NDTXsqyImSZWmCobbGniisrx08KD0Pir3BkWVS1fA=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3059.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:163::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 14 Jan
 2021 13:49:52 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.010; Thu, 14 Jan 2021
 13:49:50 +0000
To:     Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: commit 4c7ea3c0791e (net: dsa: mv88e6xxx: disable SA learning for DSA
 and CPU ports)
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>
Message-ID: <6106e3d5-31fc-388e-d4ac-c84ac0746a72@prevas.dk>
Date:   Thu, 14 Jan 2021 14:49:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0007.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::20) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6PR02CA0007.eurprd02.prod.outlook.com (2603:10a6:20b:6e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 13:49:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c21b60e0-91b9-4ebe-6378-08d8b893435d
X-MS-TrafficTypeDiagnostic: AM0PR10MB3059:
X-Microsoft-Antispam-PRVS: <AM0PR10MB3059329285E032B9AB206A0D93A80@AM0PR10MB3059.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7BF22xxtxPj4PBhV0mLJ0kUVTwfJVDTOuc0pjkDOwZDT6tLfALDwo5bfEY4WLYyQIrMpX+W1KSwavVvIa5byRbVxLxqGoQ9LAPTlwqbt83q5UyN+rZVK96z9LQK0THEYPRGejqcEyAgF7WIeY+snz6h0kyza1FzCf5lxwXbqjiN4c5ZuYgsIIe/fh3wh8XU/01IvDXWulpbOYvyneqstK28QS7aNaQSTlutCBTBCwFzCP9M/WVxioYHFpjU4yaL40NiqSv41CT485MzAKRRZA4paSakH6QEGz0X1fwUz0rmaGPpgQlnLOpIaJN6RTrNMXavcR4868JU0JxYodqR3tZ+64dORXATvXKrIzA2sFlwIfr6ZuqiywHrp0juIPnnX4Y6X2pLPWnrdqikqTpiqhT3FlOAO/K1Su/YQJXODGRS5I5PSqQgJQExMSn2B61O1B0eEYvkDO/7oba1v+jkGySNY+xxY32/Fa0xrWt6q9AQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(39830400003)(346002)(8676002)(31686004)(66946007)(66556008)(6486002)(110136005)(66476007)(316002)(2616005)(16526019)(86362001)(5660300002)(2906002)(26005)(36756003)(8936002)(956004)(4326008)(44832011)(83380400001)(16576012)(478600001)(31696002)(186003)(52116002)(8976002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?5sHTwT6/x91ynCd4Y3gDNT++QWEQNUXpL0x3HH2CT7z55/u6w91mwYj1?=
 =?Windows-1252?Q?hUV4AL9oi8xbcJjGeohlCwktZRCYr/9792rL2ZR/e9Wa1J1K+jT6l2t2?=
 =?Windows-1252?Q?1QmAH7zxDB6Zd1TS07dAssVcax4b6wFIULGIpDBog/rRRiqmHnnuXQQ2?=
 =?Windows-1252?Q?nGzdsrIL9Sq/orWm3RmdRNmsRpd/yCt0LTTa55Cb8DX9AU2f8l4bLsvl?=
 =?Windows-1252?Q?Y2yg9ohjT+evYxvrzYDHZytoYFm4SYWp5oiO78GKAfOTXA1e1K06xARF?=
 =?Windows-1252?Q?Lotz2IvYvd6/ll+jDTg/cx7ALtRDuHMY+80q46BioDnR4QT/9LdZZEle?=
 =?Windows-1252?Q?8qxk3FaHxbIeAl4kcg0VL5GqQBnTphH98TdFuJetmrKwhjCUOa7j+l1/?=
 =?Windows-1252?Q?JCz402/3Z77k3MHEECaGdIu0Zm/GDG6CjTl4t1kub+H51Iiwet1KUuwD?=
 =?Windows-1252?Q?Lt6KG1F23zHOr6JrYS2ro3ePkafxWE7v4Fw2YmOZxdZv9NouV+Xt39BC?=
 =?Windows-1252?Q?T9qespTtwrCXSl4c+hIsbWaV0mmmbngfDctIJel8FSkZCdvsiN8QANbj?=
 =?Windows-1252?Q?gZwsem4/HSe5sfYcuAjKL2YeN/3mhIjXje1wW2GrRp6LPIBNMh0fd8Uk?=
 =?Windows-1252?Q?5bxHiZsw+jLD6R2gsFwaWybh7JOP9I06yCY5wHJ0CRAm1o7LrkDqTnyW?=
 =?Windows-1252?Q?l63BNvQqFhz0Pxg8E7YMtG2M45S/q/Cz5260KgPro0AUyH8HQeYyJ2H5?=
 =?Windows-1252?Q?WmAINRe6vnOFLEXSJUe6bxjPfuswiz8ioNocLDvz9TzTlN9Q2oyc2ESx?=
 =?Windows-1252?Q?9atuj9B14calczPqrITmFJbADmXf45CRLA4Tz8G1PnaWh4hz5RLUijsP?=
 =?Windows-1252?Q?sg69iBmQ6YjBaD+X49VdjWl7Wi2xYsEFVgHuYM/lm6Vj5E2JqepV+SOD?=
 =?Windows-1252?Q?sXRFtlnnl550pPF2c2RETwkqFeqlFx8bnHv3E+EVbb2iUp4bjobxdP98?=
 =?Windows-1252?Q?Nv30h+50KmmR6RVHJxzCCWnrY714qsFeoT4E6QOnPDvurqHy+6QBUbXj?=
 =?Windows-1252?Q?Qan62QGQvSAlS5P2?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 13:49:50.1243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: c21b60e0-91b9-4ebe-6378-08d8b893435d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bvBcNVjbUmXt9YBGIxj+TVYIjf36Efz/NY4Kbk3jNwCs4UAiKusCftHanqwI3vDRImpMXcrwUEThnrNfgRIOGsQr0W7E3qZrSte/TZmOimk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

I've noticed something rather odd with my mv88e6250, which led me to the
commit in the subject.

First, the MAC address of the master device never seems to get learned
(at least according to "mv88e6xxx_dump --atu"), so all packets destined
for the machine gets flooded out all ports - which I can verify with
wireshark. That is, I have three machines

A --- B --- C

with B being the board with an embedded mv88e6250, A pinging B, and C
running wireshark - and it shows lots of "ping request (no response
found)". Same if B pings A; the responses from A also get to C.

But this is somewhat to be expected; automatic learning has been
disabled by commit 4c7ea3c0791e (later commits have change the logic
around there somewhat, but the end result is the same: the PAV for the
cpu port being clear), and I can't find anywhere in the code which would
manually add the master device's address to the ATU.

However: Even when I do

-	if (dsa_is_cpu_port(ds, port))
+	if (dsa_is_cpu_port(ds, port) && 0)

and verify with "mv88e6xxx_dump --ports" that the CPU port now has the
expected value in port offset 0x0b:

0b 0001 0002 0004 0008 0010 0020 0040

(it's port 5, i.e. the 0020 value), I still see the above behaviour -
the master device's address doesn't get learned (nor does some garbage
address appear in the ATU), and the unicast packets are still forwarded
out all ports. So I must be missing something else.

Finally, I'm wondering how the tagging could get in the way of learning
the right address, given that the tag is inserted after the DA and SA.

====

But this is all just some odd observations; the traffic does seem to
work, though sending all unicast traffic to all neighbours seems to be a
waste of bandwidth.

What I'm _really_ trying to do is to get my mv88e6250 to participate in
an MRP ring, which AFAICT will require that the master device's MAC gets
added as a static entry in the ATU: Otherwise, when the ring goes from
open to closed, I've seen the switch wrongly learn the node's own mac
address as being in the direction of one of the normal ports, which
obviously breaks all traffic. So if the topology is

   M
 /   \
C1 *** C2

with the link between C1 and C2 being broken, both M-C1 and M-C2 links
are in forwarding (hence learning) state, so when the C1-C2 link gets
reestablished, it will take at least one received test packet for M to
decide to put one of the ports in blocking state - by which time the
damage is done, and the ATU now has a broken entry for M's own mac address.

Rasmus
