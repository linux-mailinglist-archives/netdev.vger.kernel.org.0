Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6597A4CBD78
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 13:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbiCCMRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 07:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiCCMRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 07:17:15 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2133.outbound.protection.outlook.com [40.107.22.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01DC15E6F3
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 04:16:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UyD2HVJbhU8d8cmDAbvaL3E2GPm5D5SLfEPR7HXtMSpG092IyB+sdZnJnr3KB/xZAWu73SOWCH3wXf54qZnQGgbFOP2k0ydspJwT8CDUaqqaBMR/Fgj0+a3y4nE/hLFNvv/tK7anngJZUdX6cFKdK7GFuDMUXo88H0ygFeQkK/vcWjD2USX4GcDL+/gDqftCnPLj4k1pMm1kYGhBP1dqxy9mna/J8ik+b9aHVxwFeZe3CfKAMd4h7Ew1GAQ2CbXJGLt9Zqc0gPiM4JMpYA4rxjPMzwg1FqsNapCxF1RTC+AFlPr5EoRvZKfSfnbnAGMUsYJcAwaWW5b+E5hM5brewA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JL0ICJKNp1xiI5jfGUgTdIOd//tXL7IgS2mpiczNpd8=;
 b=In31PWHpuqADQxOJ5rni7YwlVCTQ8GhR/GHEo7IZVZLz/hjk3ZnLT3CXNZNSlS9j/g2h+XatC3AVPtBtCejMcQ2Pc0MB9WGJ88X3FYaNc8RSfQLoQLJGIDD4PgZtUKKcHgMeyEfm+eGqo2Y1cnlHL68EhXq0WdEGH49EQ5+btxtz3s//e59U8EWderFO4iM/SDjTBjaROFlg4w4zRCVl90wrq4kbk0EGh7T1otyu55tabps+XlDCH0sys2toEX0qPI4kcXMt1AfPzuaIZSG7MlqtbxANo/9XjfEBXkumE4CL+jmUqOi+BHXKn16LUEmE3Hs7b0syDIFD5f/rYyxJtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JL0ICJKNp1xiI5jfGUgTdIOd//tXL7IgS2mpiczNpd8=;
 b=lP2lBZFmdVsYQ5jTYkx2pZ7x0O9P/WDqzaF8F7JHPe0SrvupsykVV3knqUMpHUwudKxjhan9Ewo+b2FDrZthKA4HIeebjC5KRI8MQFFr0n85TdP7gHRKSz54KXgf9Zxiwo2ahL7CYYuvl9l7CznjzWlAmUYjH2M9o9GkrpsyCs8=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB4712.eurprd03.prod.outlook.com (2603:10a6:20b:d::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 3 Mar
 2022 12:16:26 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 12:16:26 +0000
From:   =?Windows-1252?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 00/10] DSA unicast filtering
Thread-Topic: [PATCH net-next 00/10] DSA unicast filtering
Thread-Index: AQHYLmnRrvaRPfj7K0iMWxIuGmpsVQ==
Date:   Thu, 3 Mar 2022 12:16:26 +0000
Message-ID: <87wnhbdyee.fsf@bang-olufsen.dk>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220302191417.1288145-1-vladimir.oltean@nxp.com> (Vladimir
        Oltean's message of "Wed, 2 Mar 2022 21:14:07 +0200")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 975155dc-e684-4555-89d6-08d9fd0fa3ca
x-ms-traffictypediagnostic: AM6PR03MB4712:EE_
x-microsoft-antispam-prvs: <AM6PR03MB4712B5D8878FD5627C7FF4DF83049@AM6PR03MB4712.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a34F+yL7r/qKrXcGzAwPIgQiKe1LZGJw1gAyB3bkqDTlmnE8qsehc56abvjdU48dVkMHUiap5AVYTLw3lFpWvDvnY+zwn7DNEgWXlmX7ZyTfDG6FMJnkD6YjZN+78xUwut7wZSc1KZmkWdLGwwZ3u6Dxt2shBKfQpb1/mzdwepZFdKGkvGMJ8PReaFWY7QX7gk22AB1DFpuWtUni+v6nRT7p8OHcv5mRYUM67IAOe2T/Yj0ikOy5a4tEiEcXOW/ezvi9IydMA9uQESDd8fggb0C9RlDpA5wYLYKA5j2Wpjg89ryu2f/6aFgTBu+nSlzU+HyoUB9jgqmAO/eIPiKVxmoK680+Kw6Nv+BJvuB018N/FqN/8GdsEWYiA0h0B6xneVh58FcDRRK9WaRHueHgJ1r2ajZAqE1n10Jca62JcDNTxk65attySy64lINwxhY+flDzvSWDVSccPhemgq1efJl/58irUBky3X7e5Fsy85gZgz8iB0aO49/pCOs1QaC8RC4HEHac0XmXp90qqmhxSbOYrIGIgI3spcyMbHiPSJJ2qApo1anptBt2CAd1wX186OT0KxKCOqtbzTSrshwg8nqTD3WA1Ks/SQKoYp+px3rkwkvG3Xt3b3opyWnUsVS2L5gbeC0vi4aXkH6mXAxGYnCNkdOWYO7M8dfoA9zB1yxhLyvd1VwqIlUezeYrm0U6cHZRptF3uGtjn8JM7NNTnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(8976002)(8936002)(122000001)(83380400001)(76116006)(38100700002)(66946007)(91956017)(6506007)(508600001)(5660300002)(7416002)(6486002)(4326008)(66446008)(66476007)(8676002)(71200400001)(64756008)(36756003)(54906003)(2906002)(6512007)(38070700005)(2616005)(6916009)(186003)(26005)(316002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?hSH0FvqXYFlSapA80LeO0BWrrWza0D26fkh8PEtt3flSh6lQH/Il512y?=
 =?Windows-1252?Q?pKVVPFnIyEseWZSrymrSqKxi5Dxxtnw9p0fL8HV2KxsmPklDscVwi58q?=
 =?Windows-1252?Q?YtH6+xi0jMneiicrRUTh1SMreOWou7pPzKSLqHkIoEMu+AmqojTJI8Ar?=
 =?Windows-1252?Q?6UQcyAKd7c3q3fL8e7SZAUqg88CGVFgkSMCNDw1CdMYCUOrM1X9i9sl+?=
 =?Windows-1252?Q?OWfzHXtDV0LDy97EYu3kY2iwbtaxDusRnW8DuSRhr+pTBYd7i7v/vPQP?=
 =?Windows-1252?Q?xgu3lL/5M7iuW1R7OG0xqZV7Jr0zXbaWtpuMRmvsCH8KjbVXG8spht/Z?=
 =?Windows-1252?Q?Vu1pYKC3iQ5djf7nEO7Dn72vI/hEgubWe5fgWATrqw2YkFoAlE9j/34F?=
 =?Windows-1252?Q?q1K9ZZDNvtCc2+r8bdaRLPF7vrFVl9Eo8wI/taGdJzw63AASxj+GamrT?=
 =?Windows-1252?Q?qrjQ4HJuccRbVap8Pf6PYI/DgxdbF9whk7nzg5Lh7GLjG9S2wd1zMsI+?=
 =?Windows-1252?Q?dTI44YjMKHX3NYAvDL1v5ZIVAaLf+1rW61c80gwVZYPHAr6Wajoca1Ns?=
 =?Windows-1252?Q?oPav3V6uTIlmzggN+G62mFdeQJ8RaxDMoX41tvqraCdTjT1YrllC149g?=
 =?Windows-1252?Q?qoLvv39Dw2yRosFfFfADitFYgxR4t80pupUEFgteLbavdidYyr6XLCqp?=
 =?Windows-1252?Q?RijMCV89XwFxBza7hNbpQctkzKIDZkgMMcdDQAjt8I4SWSex13he/BDn?=
 =?Windows-1252?Q?AcSCCOf8JM/OOl/EnQE6uPwgPnkYag/9E7mjA9rzlBAlpUi9mDWafEHe?=
 =?Windows-1252?Q?5C3rILCfglIk8LoY/bEkQanoXKv05MTD5LGSmF1ykPZGr8T7eT9AkQ2V?=
 =?Windows-1252?Q?PQZOzm2T4INVpHRLIvsyWCRS4a0hGDEN3dor4JKXnDbnUp6NwEvc6GhJ?=
 =?Windows-1252?Q?1jjFCZRF58aqC5BrHfSX6eJAO8q/cSl0PqlWep+TGqQtWT4hBVHTxbLY?=
 =?Windows-1252?Q?UNbkZA+WHAy+WqGeXTmKh9/A3TR4ipcQGMU3+PvOCTmy2n7MHgQPrdHc?=
 =?Windows-1252?Q?0Om31hckUI8HvcTLCp7VrC52QR8/U0Voo9DaPhqJZV1H9DXpTkBBh2ph?=
 =?Windows-1252?Q?Bt9FfB3clNCOKnQa9b5ZfrKtLMBLqgsUpihFVZ/DOPOsxdmUEaFaIGud?=
 =?Windows-1252?Q?xXa8dovNH6AogVQiy2lQuIydgiyjP2hp5mymlHz+J+X3LYeJqJ+PxWqt?=
 =?Windows-1252?Q?6wT3/j9Co28NNIeAY5XAiNTkL+tZAg7HzwHMdusIXNPqV/Gk3JJkD1/U?=
 =?Windows-1252?Q?1NJUiJ73dAEp/y0jD2fwxtKoEa9EU09pTOy8yrIq7cq1Q/ViDRwyNog4?=
 =?Windows-1252?Q?Ok/HKrsvuAOqp04D/DeJOv+ODSd6sy18xu05YVINlQu8NvJhBtoW4QK+?=
 =?Windows-1252?Q?m4l73j+ABCP+/iiYJStISZ++Cqyfw5A3Z0T9h2mewoqRtLliPIQF39N6?=
 =?Windows-1252?Q?ia/XhXJQrLqKT0TbKKZzKKgErPk+ugTZ2ZPKUs1UwvRpYVvrgegbi8bJ?=
 =?Windows-1252?Q?EBLmKZSecuX8w8j3I/GhNoJgiSKB3N7pkUnn6iXcb81TB7USkf8i8oaL?=
 =?Windows-1252?Q?qcdwO/dpRi0C0gaq6I0VuymKApPdh9q8Lm2eH6P1r9WJQ782/1koP533?=
 =?Windows-1252?Q?WUMq7ji0qzcd7h4VCNMlUNPJ7D/983au7Yfm/yU98qMYPfzQPY1xekO/?=
 =?Windows-1252?Q?7+GKnItG0OImbh7th54=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 975155dc-e684-4555-89d6-08d9fd0fa3ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2022 12:16:26.2838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ni+rV4JKzNTf6h+ec9OrsnQQnda93knEhJXrC0FP6fnOsZYbecYpJ3SZw9oK8Br+XyBQzZtybcLY59MuNvyXRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4712
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> This series doesn't attempt anything extremely brave, it just changes
> the way in which standalone ports which support FDB isolation work.
>
> Up until now, DSA has recommended that switch drivers configure
> standalone ports in a separate VID/FID with learning disabled, and with
> the CPU port as the only destination, reached trivially via flooding.
> That works, except that standalone ports will deliver all packets to the
> CPU. We can leverage the hardware FDB as a MAC DA filter, and disable
> flooding towards the CPU port, to force the dropping of packets with
> unknown MAC DA.
>
> We handle port promiscuity by re-enabling flooding towards the CPU port.
> This is relevant because the bridge puts its automatic (learning +
> flooding) ports in promiscuous mode, and this makes some things work
> automagically, like for example bridging with a foreign interface.
> We don't delve yet into the territory of managing CPU flooding more
> aggressively while under a bridge.
>
> The only switch driver that benefits from this work right now is the
> NXP LS1028A switch (felix). The others need to implement FDB isolation
> first, before DSA is going to install entries to the port's standalone
> database. Otherwise, these entries might collide with bridge FDB/MDB
> entries.
>
> This work was done mainly to have all the required features in place
> before somebody starts seriously architecting DSA support for multiple
> CPU ports. Otherwise it is much more difficult to bolt these features on
> top of multiple CPU ports.

So, previously FDB entries were only installed on bridged ports. Now you
also want to install FDB entries on standalone ports so that flooding
can be disabled on standalone ports for the reasons stated in your cover
letter.

To implement FDB isolation in a DSA driver, a typical approach might be
to use a filter ID (FID) for the FDB entries that is unique per
bridge. That is, since FDB entries were only added on bridged ports
(through learning or static entries added by software), the DSA driver
could readily use the bridge_num of the bridge that is being offloaded
to select the FID. The same bridge_num/FID would be used by the hardware
for lookup/learning on the given port.

If the above general statements are correct-ish, then my question here
is: what should be the FID - or other equivalent unique identifier used
by the hardware for FDB isolation - when the port is not offloading a
bridge, but is standalone? If FDB isolation is implemented in hardware
with something like FIDs, then do all standalone ports need to have a
unique FID?

For some context: I have been working on implementing offload features
for the rtl8365mb driver and I can also support FDB isolation between
bridged ports. The number of offloaded bridges is bounded by the number
of FIDs available, which is 8. For standalone ports I use a reserved
FID=3D0 which currently would never match any entries in the FDB, because
learning is disabled on standalone ports and Linux does not install any
FDB entries. When placed in a bridge, the FID of that port is then set
to bridge_num, which - rather conveniently - is indexed by 1.

Your change seems to introduce a more generic concept of per-port
FDB. How should one model the per-port FDB in hardware which uses FIDs?
Should I ensure that all ports - standalone by default - start with a
unique FID? That will be OK for switches with up to 8 ports, but for
switches with more ports, I'm a but puzzled as to what I can do. Do I
then have to declare that FDB isolation is unsupported
(fdb_isolation=3D0)?

Hope the question makes sense.

Kind regards,
Alvin=
