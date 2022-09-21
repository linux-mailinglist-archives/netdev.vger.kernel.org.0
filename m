Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668DB5BF1EA
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 02:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiIUAW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 20:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiIUAW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 20:22:58 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2088.outbound.protection.outlook.com [40.107.104.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABD572EE7
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 17:22:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdWDof31R/7MUq66Vyq/iuiatOUvW4VqzEa+Vl9ORE2OMsCiipTATso4/0d9Co+k4Loj0pCQzW7vY5f4i+LbactKWo7KWVyP5UaltBDLyuzACwOZ8DSfjKMhuFPByJVJ/Q35DhqZGRNZZY47SQcuwDT6Om8HKXtZos1pJpstFJKTB9mGuyZmk+crTcR9HQlAafR9Jzk9o1QyUAm3O8wmGbvO3NrHDKulkQD3NGGAWzv0WR+Of+E0QihfG6ZqCcIrSbVhsdd2OutkN7o9DngBcQnZcI71y8mPBUUhfFqlOcy6E5ccvQO02LX/+DheSKJB1nIlMLXG74tTh6S1ipvUFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oSFw/OfnqUJQgSeMhTl/06eNCKr5htNtiCU4FsoYXXs=;
 b=m7tC4zRXiisWZRVChoeHbLL7cmV08bJYkugqxPEBpXzvwRoMSHin0Hsnj2tpn8/8cpuX0WS4Qv0d4ifsBt1wn+KN7OWy7HXXC55buzQtyO57B0BjR1ymGvDJW762Q9v+LukPXCro/X/Xy2egXZMAwfwspzuMT7jp5H8zBFbSGMm6gHsyuci2aD0ZFZ/5ZFD+ifjeApg4yhz5ertJBunQ91R5K09hR2JvrE6gDF2jx15BzSlXxH3moWJdWuNxuUYQVIoPFTETK8T9YfFXMcSnyhm+DUrped/jEAh39jMjN164xAStnbSXoqxoV3qKFFuq8zSkBjNuXXDZy6pF5i1tlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSFw/OfnqUJQgSeMhTl/06eNCKr5htNtiCU4FsoYXXs=;
 b=XmXjtj0yoM/NlXgBCH0RJFmg8DTQ3/BfL9UhZrHglXYcFS/sz6JZbmDpbJGrQJJQX9PBuIXI/PJ45qVoTUVIcYseC/T6n8oMgpKPG1D+09hNrc4RFoiCyvAnmvdUl2N6ZlEd5LizVntL7KBR6Hw8G41Ei6WMv7QtT5rA6KQLwtg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9079.eurprd04.prod.outlook.com (2603:10a6:20b:446::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.15; Wed, 21 Sep
 2022 00:22:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 00:22:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v0 2/9] net: dsa: qca8k: Move completion into DSA core
Thread-Topic: [PATCH rfc v0 2/9] net: dsa: qca8k: Move completion into DSA
 core
Thread-Index: AQHYzHXViyfkGghB2U2CmPjwCD82Sq3oZaeAgAChKwCAAADXAA==
Date:   Wed, 21 Sep 2022 00:22:54 +0000
Message-ID: <20220921002254.s65zkhhqextierln@skbuf>
References: <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919221853.4095491-3-andrew@lunn.ch>
 <20220920144303.c5kxvbxlwf6jdx2g@skbuf> <YypYqqwgllmcPJZj@lunn.ch>
In-Reply-To: <YypYqqwgllmcPJZj@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB9079:EE_
x-ms-office365-filtering-correlation-id: bffdce64-dba4-4863-b123-08da9b676dab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: el82rMUK2tKe+68y5gjd2xui4Sm4rsYiGR/vyBNLHnag2iKw2fGZu5yFuxzZlTIwpXcyMZ8F1Z5vo3agmojyYNl7b9yywLqx4A7DUiV7og03OI51zKNxJ3FOiyqHxSQljbpLjIqL+kdgOU76hb3YfJztSDVlzKk67gWfizwA5FD7jjqI7g7sg1Dv+u42NEc4Fa8/ZtxwtgLWeutfyPtKBsAJU63+epvFDFq5+yZ80HHdbASLBE2GYeOg4kK/FY/CP8HzBOI0nxknAhidcKms2CwaXUDAqrzzbXLdOYmPsfSxAzcezkGfQZ1xtEjKct9uoZQ8rqO9XGJd4ktS36Pq5ohRnN6n5KZLvGIwsb1nC+80ryuEi40AfTVnn5gNNsucyWv5LPSpL4N4kV1U0411/gHlwh4NT17R/FyK4ky/Tiw6E+JmIR3b5NXM6ukZTBueGCNzRFCRGOS32nv0zvqmYijamJ8DweB41DCYKIGX4H/iV2Thu9lxoe4O6YBg/VOjDA9P/wDl0bBM6gx/qzQ4dCLZAwPuIMrT7PPE/KbFfTTT/JotoUeNcZabP1IJbAXvdyJx2xshTDSj+2g5ocsgZvohkiBsdEbZoPVhuha1EuBr74g8FjM0phn1fRQ5njtbG7PMGZd5b0tnvk++PLaNiU6VuY02f0D9AOW1BE61MYLjD6YuHdeFepP0Ze1IqXlW3kfTQM+PmNhRvv+1RHSmaqv14Eloy4h2em5NwXdk+bcdsKSZKTPkfYwjOfVFnC4rCFA7SSZN1sPvUvU8iI6CjCHt7p4sm9iJF9rXTDIWM/0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(451199015)(8936002)(5660300002)(33716001)(54906003)(26005)(6512007)(9686003)(38100700002)(6916009)(91956017)(66556008)(122000001)(83380400001)(64756008)(86362001)(2906002)(66446008)(76116006)(316002)(38070700005)(478600001)(6486002)(6506007)(66946007)(8676002)(4326008)(41300700001)(66476007)(44832011)(71200400001)(186003)(1076003)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yT9+cS6H4WrXbyj1TPkx2whEnp46I+o6XqjddoVinU1ZyjLnxQhviJo1HzM9?=
 =?us-ascii?Q?DvHpyTUGZVjQEnwJupuSLIWkSCguiyTNcH1sIJSJzmmcK1Dvfq7y+x8E0NdM?=
 =?us-ascii?Q?yvx+Y0bkQf/sbcfy1c0u5U27yc9hCemjgmoqlmVwnyORNEUhEFUj/5GILs38?=
 =?us-ascii?Q?WpekfHePQzTptdMqtcKE3tzZIw2h1WnrE821otxHqjG+ox3aa467yG15ei6d?=
 =?us-ascii?Q?tiumkoN2sMFFwghIEpU3XLUNNA+QO0kId9zniHA/OsoL4QgrQtX2H4xNLwDY?=
 =?us-ascii?Q?YQ6J0Af4tiXnKTczhzjLDHhNwB/UNDeoNNyl0vmk4qvjQzz2Vshfcl1UuPNS?=
 =?us-ascii?Q?N4NsOUZkZHHTk0wTCCFT7L4nOjoT1fNOLX6/n5Rd+eHedL8b0PyRH68Ak7FP?=
 =?us-ascii?Q?gnDqjzWRtVz6Squij8682o4bHmA5TCJ1izs86uZlFSo5xKKHAb/TzgmBSetR?=
 =?us-ascii?Q?ENh/PvCUW4Lr3bgSXhkudB07J+ZeccTktO9Mtf5rFDe8dAGOdJ0oynBCWzbP?=
 =?us-ascii?Q?UuhYlBJrXWh1BDDkbxfbUfMZmNSLLf2uJlBtkBHMl+hEWlYwsLG+MAwvV/V6?=
 =?us-ascii?Q?NAOV3ywQwcHLdiDTsCaRvCthl5TkJ01CzlXajJR4ZGMtohCJovS9Gn4me7j8?=
 =?us-ascii?Q?sHS+N8LBzocA4ObjNOXkZlb0hq6AKJMo34y51mJEzleEPq0c0a9ry1IWTKWh?=
 =?us-ascii?Q?YGwc5k7RM/lygLsoRsSw7RZQiEqomp4+xYYZ/AEFjg+yj4awIBaoWk5tBsLH?=
 =?us-ascii?Q?zL1JGenGUL/GiKZh8VQf+NaiR92Jh5iutZxEEwyNcwtvY40NyAIje48DqTPl?=
 =?us-ascii?Q?ZqyB6o5tPbYy3XZ3b3aPIDDYcY6W7wnsG53s+8GNGKdbDgv6bVUo9EusR+ZG?=
 =?us-ascii?Q?fUg/ojbMWwF7Aes+XueEro1Tdh7EkExf0/SQpAhs0Klfs5Z90dNkFljIYYIa?=
 =?us-ascii?Q?05G5rRh+SdStQKVVhIdH0SeUGfVmVYPRuVb8nICzVj6R5M+VBlFg2PafPEDN?=
 =?us-ascii?Q?Jqpf7jFLujNfzz6OAYWwD8rH6WXXoVzlDWtb8DYCqQ5YCO1dqzBrwefK/tn9?=
 =?us-ascii?Q?En17VD4vgaiGlR7GuSiCO1JQJMAC3rWxnpUbzE992u6Det49D2ZHvrzux4ps?=
 =?us-ascii?Q?OQq5YHLnnKHBFRtKT2jrIS4eIxvOY8M0aWrZWfQgk8ISRJstMUrfdAs4pBpG?=
 =?us-ascii?Q?gxITBzGUb+U4dO2SY/Hk4ZM2bGV3bZ0JV6mBqO+AdhqZ4wLM5xw/h1n6Z2Rf?=
 =?us-ascii?Q?qyQ2C9Wi1iFDqgj7Ii5T/xa0Ip+A7fAitpHjqeq2qW7O7anPMfwsKDG9EP/A?=
 =?us-ascii?Q?eljfeSmbZuPjluWdm8CJfr/8WNdpOCGTU5Is5ZPsbimP6CRqstEND/yulQp3?=
 =?us-ascii?Q?cALkbo0iA0Q2hdufoczmDUJMA0x5ITrMM1QAP3JANTYT1VT0Gq9wW+/GzoZD?=
 =?us-ascii?Q?IMCztn7Hnk4TpNhAS4Fb5R1Bad2FkdYCtU5rvMacWFLYKEYT6Lpzz/ZEpud0?=
 =?us-ascii?Q?XcJE3i6YyzcglFfgqOWC8Ghpa0Rz67RKx2RaLbF+Ve8vq5NyiW9XSgNT6xAB?=
 =?us-ascii?Q?GoQOfGYwHtrXcvQhoumNoHQXvNcDemdD8xuJQphe8m8pDheigsH6wyvMnaDY?=
 =?us-ascii?Q?LA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7FE128637E32EF43AA80C8F3F3D2CA38@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bffdce64-dba4-4863-b123-08da9b676dab
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 00:22:54.9783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dN7tyxGlcosBHPhUezhrk+NBsaWD2EbnIP8OoSifciqChWTpHbBDNpY9x5RB6Myu3KVCw3Xi7rozyz3yCJe5pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9079
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 02:19:54AM +0200, Andrew Lunn wrote:
> I've been thinking about this a bit. And i think the bug is in the old
> code.
>=20
> As soon as we call reinit_completion(), a late arriving packet can
> trigger the completion. Note that the sequence number has not been
> incremented yet. So that late arriving packet can pass the sequence
> number test, and the results will be copied and complete() called.
>=20
> qca8k_read_eth() can continue, increment the sequence number, call
> wait_for_completion_timeout() and immediately exit, returning the
> contents of the late arriving reply.
>=20
> To make this safe:
>=20
> 1) The sequence number needs to be incremented before
>    reinit_completion(). That closes one race
>=20
> 2) If the sequence numbers don't match, silently drop the packet, it
>    is either later, or bogus. Hopefully the correct reply packet will
>    come along soon and trigger the completion.
>=20
> I've also got some of this wrong in my code.

Wouldn't the programming be more obvious if we didn't try to reuse the
same dsa_inband structure for every request/response, but simply
allocate/free on demand and use only once?=
