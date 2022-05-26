Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8279E5347B4
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 02:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbiEZAw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 20:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345747AbiEZAu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 20:50:27 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150055.outbound.protection.outlook.com [40.107.15.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669BE6594;
        Wed, 25 May 2022 17:50:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AamkLUq214m2+vtAftumEq1HlTmSv+ijUgrPPd+sLwZjjr2iicr2FnS73GfVLfsjLkIXqewWO1LfFeQTrmZwIOY5AhQY5+Z1DqjJWYOKS5VwGg7M2rUCNk9+dJuD7+qgkawsa0BIE3FkdTeaZwUcczMMFxPLkAFRUaNlAoSNgs4FMWOZFVNsWT4IhITZDG3/D9dSMPSADdLKye/76lhqnG6PPYDnL+TzO/vKBbAMmJQRYSwKCAspQzuvrxd2MDFmvlxmUza5QFn1BcvkGqVz5oVezIa2u/mNRsutOZheIM6treK0UPHayuhw848NobSjVlcBhDql3BOvnMcWaYEf3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJ5IgUTSvy7JzQop5DtFK8bddhP8dxy04oz71Yb8INI=;
 b=adkCWZ+9jpPOH2N4age0Lm6L0BW0bWQn7CWw1L1DXSUDooBeSAVXGsPxuS1t/DXiizAoQo/SsA75I3WqgLmmGWror2EECoF268KdtkJoyqlD5dHAIg//giMa4QGHdDWtO5TYnC976nMQ/haKnkiJhnDGplcHwElne9ZElDUYNMpu0fcE0AoR+NO30vP8RYYLTmef6LB/AJmbqBQVY6qhnYNdoy+EXvbA8MYCKfgfZkQrI6eSsUu9o1FkkDW+bCvSyVj+n0hv2xAqLdOAgodDbwJdBfEcNcjc643ELDUahNri+4ENidig5Kwx8wR7rFRlaQfKfbnT9LYGCPFBEPZv9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJ5IgUTSvy7JzQop5DtFK8bddhP8dxy04oz71Yb8INI=;
 b=AYLC1KO8z1fIaUbZIf++Basub7W/H6cRG8/nctWmf+CbM+0K+7tfjeG+K/Q4o7CZQDccRPPXjgE/RV3elmJXBgpissXzMI9CDqy9wW+J7UuZ0oPa8k3Hh/jpnzYYASKD6lpFk4UnrsdGwFseOHqzggmJmo//hecZZs2DMpmpMDw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB5558.eurprd04.prod.outlook.com (2603:10a6:20b:9a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 00:50:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5273.022; Thu, 26 May 2022
 00:50:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <ferenc.fejes@ericsson.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>
Subject: Re: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
Thread-Topic: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
Thread-Index: AQHYXU7ReS+uKz5es0qSAulr7qr8960RgRAAgABGeICAAAZagIAerKeA
Date:   Thu, 26 May 2022 00:50:22 +0000
Message-ID: <20220526005021.l5motcuqdotkqngm@skbuf>
References: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
 <302dc1fb-18aa-1640-dfc7-6a3a7bc6d834@ericsson.com>
 <20220506120153.yfnnnwplumcilvoj@skbuf>
 <c2730450-1f2b-8cb9-d56c-6bb8a35f0267@ericsson.com>
In-Reply-To: <c2730450-1f2b-8cb9-d56c-6bb8a35f0267@ericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c043e50-e818-4f9b-aab6-08da3eb1b6cb
x-ms-traffictypediagnostic: AM6PR04MB5558:EE_
x-microsoft-antispam-prvs: <AM6PR04MB555838AC981F7D6A4271202AE0D99@AM6PR04MB5558.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1+JvgmqbZ0K2GWAGGcUwfPGj3mwa2E8HgXkrafsPsfHvjyTVRtT9dluXzmiQzqTkWTL15wqQGAM1cHDx0MOo0gyDqSH4hRVn1aRdWKs87nifcf3N+I/VE6JCfiF/wnJ00tGC2Y7DDmxNCTOYoMgf46lRzJ3R5qJ377JrnLdtNci9JpFcpWHCXPs4f+LjlV2ChU1/y/3AKTCA+K5hty8elIs8lvrgEOe0xvtDF79diDTbptw8l1eiM5FSx7XM28Jq92cFRgyuracUErES29zeH8QouZllzmUT0hvMJEpITyn+GkY65LPaUag1a/mEBWNzPqSdTd0qMLoeDxm7Jep2PT0uc4SawJbMsu/imQihlnadWpUtm0g8nJlZJ0Zu4fOJgHP066ViG52T1zweswhN7+MOS7WUyr5tH0bng6Q8mVglH/XRI0mmy+zle7gdjU8rVA2XdW810XwYhdrdNF2GiUYeb90woGcGEZ2EaEQz6iESgGmGeFsoguCxSnle/BOQjwfnU5CyWyE8zz/oBO72tFve+DfM4dIUQk9SCVs+zLHOUOE4X0X0Q9A8YuNHpjrDL9QaO6HHrOgq3EovJWaTBM0GMjmltO50kOyPwqV6pnPW5SuHE46j79q9o0eZvwosOCOx1amcHSKJaC22RwokDaceHvUcm6XwEtlvfKhQb8wZb51asTlqaw5W6WExIDN7mPu0/zoDyTA8t5bE0Cph5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(2906002)(6506007)(9686003)(6512007)(26005)(54906003)(508600001)(8676002)(6916009)(316002)(86362001)(122000001)(4326008)(186003)(1076003)(33716001)(5660300002)(8936002)(6486002)(71200400001)(83380400001)(64756008)(38100700002)(66946007)(38070700005)(66476007)(66446008)(76116006)(7416002)(91956017)(44832011)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NT8XWKqpj6nro6tDoQglkUI+gEgtQqRfEEkeTang43l5wb/e4sHCBWr8G3Qw?=
 =?us-ascii?Q?knmsofXtSHrCiYkcJivkx9TWQmiHWjV5TCYW8IHvG2+4VyypRguDcKg0dVMs?=
 =?us-ascii?Q?/v9LA38j4gD484G7bJe0OaA6RtFtUVmuhcqLg9H59kspbtHnYO9V66S80MTk?=
 =?us-ascii?Q?5RkLebB0C2+HJFezhjuQfEEQNm+exTYstorX5Y35h1dQ64JRoqC+v5JLl4fY?=
 =?us-ascii?Q?j/hJoEVp7SoFbpwADbou2KzIamDZtp0wKoJzR2xpUnoMuNxkLL/7kJFOX9e2?=
 =?us-ascii?Q?Wpria1REUb3408knWYDzNaH3i6LNdIU8HZQOYq0qBw0scci4TW7xY+6+LAcp?=
 =?us-ascii?Q?i+ylmZdYOjxCZQDmauEdJcE5SNJP7APVFxp4wVwYReQEPGQVhhTImvQby+Zt?=
 =?us-ascii?Q?JhNj+Tt8ejqVqiLqgVUuFv2y06rXB8gIvxEfMcy0C/QdylVFLuH2dU/yhleF?=
 =?us-ascii?Q?ncOW3/hSYenxpe2/HQW+nSxPwX88tZBJK/N9mzBpQkNdU3PteqvQXZx0O5SP?=
 =?us-ascii?Q?cFA8BJJ4EaFdjDu3zEJfvE3saHxWkTHWH9NrE1kfEosw08aTux0LW65Wba7n?=
 =?us-ascii?Q?XrmNSNL8Qro4lqfz3lssYl+RCr4RTb9taxzNgQwPYRCyTWKgrAXej/9snufG?=
 =?us-ascii?Q?w+yGctkxZgpSZNrc1RAutPv/xt7dcdIygaUt/App069o1bRujuPnQC27GzHN?=
 =?us-ascii?Q?/iVG9IImrrXkSwklwuIAPg/VVw28Bg50BDnRej2PYqI5zY+zHeQIyohpW/aK?=
 =?us-ascii?Q?IqwkI6oRribHxW6R7DFANmx4yHHcmFDywS9bO0qyJFtrXkuF1CuWrol1KvhU?=
 =?us-ascii?Q?05cSmuu3f/pTOcRm7LMykzwat7tEwTkco/2prXEWhrlPJwv5yUIt+ibrOUEe?=
 =?us-ascii?Q?xGCa1HAS+ICTmjt6i201FI9VoM3dNtJnLjm8ZxIpcjYmudtA2YKxTE3nghCo?=
 =?us-ascii?Q?Gp4jNb+2mA9faoLX9jvi+P8jZ9n74SruOn+tVOXsgN3XcprkYjMo/M7GKnOg?=
 =?us-ascii?Q?Cdz0OzMJW140B6X5OY7qQ8dEC7pPllinVyCBpjwWlk11SscKJEHp1sO1Ogtf?=
 =?us-ascii?Q?pdOo4eLsqZfqjq5+LxfiosqwRH5aL9+96utektrBrCrs7X1eGrPkjTk4g2xN?=
 =?us-ascii?Q?2aNEar450BRTwQpILOa2/S8lIa2RqWJ0Y1n7giEp59GsGUEDmj/3XZHbMLej?=
 =?us-ascii?Q?dT7caenLKcXB5ij8AaJ5h1rHdKcVgQf8ZSW8FcvswQterf8M93oVOTS2u7Ut?=
 =?us-ascii?Q?pDys+QL++KlQA1gHxO+Kd/kV8UVUlDyD8xzqul3EXgxPIhJ02rKWPZcPcN1S?=
 =?us-ascii?Q?kt5jTgwBva8aOozYHcroI7QRySu3IOCiwrc6E5FXWoyFzcwUDeCoBs3bHaaG?=
 =?us-ascii?Q?nDnkEG+uP+oUiMTB0W1pgbPlPYBZQsh355+QpkBZQTDUgx9HDEVSxnak1/eH?=
 =?us-ascii?Q?b8DJh1Wtovb/jHKUuLMcVx8X1gS0dIbvEaDrR3WjfXNtij6L4aye+SkwmqvL?=
 =?us-ascii?Q?8M8UKlFuEHGtKqmct6fNedx0DCrMgZA97ps2Tqpnt7wyQJFMfmR2BXaY62dv?=
 =?us-ascii?Q?mafqJIq3Ttkopukg89NpmUvOgEtRiGTgqu6/zWZnwZwmSa2La+Axqz3TKcrs?=
 =?us-ascii?Q?95aboSXhL1pT8mOeBgegG2wMl3y4ty4CVcQYrv4DuJCa7BG7uy3jutXklVxf?=
 =?us-ascii?Q?K16K8IJYCBYBUbvp67LrXXqcNLBa729XoJ2xZ/61CH928AP4Y3vUK3O9NtED?=
 =?us-ascii?Q?PQ4/izj7z9c5XWqjBOj9Mb0Y1auCmfA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B5CDD0C4E2DAC44B89F1BFE597B08549@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c043e50-e818-4f9b-aab6-08da3eb1b6cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2022 00:50:22.3124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EprumB8dB+XKMmWDtCKGwioXbl4hviD4bQrbYspyqWiLQCu3jd4QmFqts+63UOiFxEFO/tSwUJg53EAscmL16g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5558
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 12:24:37PM +0000, Ferenc Fejes wrote:
> Hi Vladimir!
>=20
> On 2022. 05. 06. 14:01, Vladimir Oltean wrote:
> > Hi Ferenc,
> >
> > On Fri, May 06, 2022 at 07:49:40AM +0000, Ferenc Fejes wrote:
> > This is correct. I have been testing only with the offloaded tc-gate
> > action so I did not notice that the software does not act upon the ipv.
> > Your proposal sounds straightforward enough. Care to send a bug fix pat=
ch?
>=20
> Unfortunately I cant, our company policy does not allow direct=20
> open-source contributions :-(
>=20
> However I would be more than happy if you can fix it.

That's too bad.

I have a patch which I am still testing, but you've managed to captivate
my attention for saying that you are testing 802.1Qch with a software
implementation of tc-gate.

Do you have a use case for this? What cycle times are you targeting?
How are you ensuring that you are deterministically meeting the deadlines?
Do you also have a software tc-taprio on the egress device or is that
at least offloaded?

I'm asking these questions because the peristaltic shaper is primarily
intended to be used on hardware switches. The patch I'm preparing
includes changes to struct sk_buff. I just want to know how well I'll be
able to sell these changes to maintainers strongly opposing the growth
of this structure for an exceedingly small niche :)=
