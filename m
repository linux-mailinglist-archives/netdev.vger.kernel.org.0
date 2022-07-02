Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6462B5640BA
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 16:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiGBOal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 10:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiGBOaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 10:30:39 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140070.outbound.protection.outlook.com [40.107.14.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC32BEE16;
        Sat,  2 Jul 2022 07:30:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izeBA/DsMzId3lsVVWRKsaJZfgiinw9h+XgVi/PFy9yUdfwmHjgziXj+8bfRZn7d1lHI93zo3j+QyVvL+wFHaN4d+B+iXWt8DVa//mlkzN2ghARChlyn8q7qcwlSArPi8xWwYPJClK0g+6ZvVk2KnQT4q67MT03S0xI/amIrhhv07r+YceImqh8/vFAeo+pUK9aZJduHQICa/foC6U4/7tl6GvJNYnv0Pg1m+xT6K50X2ZD/hkRstXO1JlYl4JtnrY5sXPK+9s0cm3AX8t0JkwfygR2h7Qws9sd1ja6b4mYNh7BcBiSjbOwrb87YMCgJOUk8Zp2gPDdCwyRhtd1NHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f92iB/1sCSkqkrs+X1d3KWthEwUAPAUegca28y3q1OY=;
 b=Ega3DER5JLd0YbAuFUqXfjQOrHHHaUexPu12PG65zoNloo0Wiq1dkLhFAFZIbrDsGsHic/tJEhRBRq7HFGd4upSxj+hft0HDi2BsVJIvNWl+BJRJMfpO4I0Ru6rgMSXYazUpd7yUNuIUTAUSOPlTzErAKIzDAo7ID24Zk/6YEAqeNn85D7uFaz2NqJ9iPWXoQII7lOJ/QLTpWaKDvtAuYZ91bs8AU+y1L+PMGc04AcgYL6ul+TZ2ZiK7wPEyAyFSuA3byl+2Xn6J/ZZmk774CBwmNhJkDgm0TFGXcFv8gynoGuknQ/j6snNiB7XDGg+XZLiml+oXdJuGagl2gsnSwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f92iB/1sCSkqkrs+X1d3KWthEwUAPAUegca28y3q1OY=;
 b=jPVYP+CSF7avU0/AckdL7x1fNVnfUL/Bsub3j21tM3cyx/tYmTnPgMtjYTh2HA10FpjkVehDJ8y2oNbXhTig/04kbE6LhBtV8Kv+T2kzUPTFJC28IkON8z4dxnj3nMaeOMOP0VGglYdupEiLfXCbQf4/BFOXoKP6MjU7tr0qB4Q=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4307.eurprd04.prod.outlook.com (2603:10a6:208:5b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Sat, 2 Jul
 2022 14:30:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.017; Sat, 2 Jul 2022
 14:30:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 1/7] net: lan966x: Add reqisters used to
 configure lag interfaces
Thread-Topic: [PATCH net-next v3 1/7] net: lan966x: Add reqisters used to
 configure lag interfaces
Thread-Index: AQHYjYwYhWMj5wH+LkGBDISvBcNvTK1rJX2A
Date:   Sat, 2 Jul 2022 14:30:36 +0000
Message-ID: <20220702143035.p5pmw43szqg5awye@skbuf>
References: <20220701205227.1337160-1-horatiu.vultur@microchip.com>
 <20220701205227.1337160-2-horatiu.vultur@microchip.com>
In-Reply-To: <20220701205227.1337160-2-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65b90cb9-bed1-44c9-50b6-08da5c376dd6
x-ms-traffictypediagnostic: AM0PR04MB4307:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cZgmR+HnYxcjcOonAbOGErBLhP/nzs4f0i+DzVuyw6jurfDDRT9ui56/L/oy/JiWJBzRKEqliJdWIsHc4vHsOiGbwg2zgg/4Ryp/O/7vxuose8yKsg+mdBEcigm6QlWLiu7nIgoMlsOZvJ3Xrxps3HV41KkROnj/SUxozUS1g6T7phK35ZeWM4g95PQepfs02BYe62i7RIn3LSIvj1qZmeTJQ298dD2aY/uZVKXSkBca/l8WjxIpUbR/Wn5Tx0yjxyxcL7xdTiWTy4bSI5IjcQuDVoat7s33nMspGip74arqoCd39ZJnBOhRS3iVtfd0vxwA/awTpuw8BoIeogRAaXbmu0tjIhmRgkIXOmVb48HiK7Q25KLKxM1kzgBEEqvmNGceZIiyMfXosGZWM32ZhAYUhApZIQxp+FxsDLazDX8MBhKuCVlPqbKI5V7oYooDiRxnM/MEfvuzVOki/ULvfHtJuL/LqHKDjICRYmAYiVxKuUY5/9VASvjtOntM6HS56rVqD+9laxoIqbLd9IR+9sY+VQLO/+WmiXCo8qLm633TSrxoOlS8tMmrynK3uxFaB1YH0VOkIbuw/dx1Yw5/setGEBkc1yE+XvkEvF36sRLeKOMiXNj2o6LTcQvLS0Zn1cDsz2UOt2j/L8xwWyJhye61MDj/w/4sKoVRqoK1xLMYBet4v/JN0uRNhfsEdbPqi6JoGdfuDTkMwvSy3fFW2XG3VgNHhUVExLmviC+B26uriPWBbe7OJ9ITh5BXbecHAVdq/NTAqiGz2wJBNGHBb1oD2qC+Nl5lYyrFCbAOHGULi26wGXG67HgY421ev/EzT3mabUt+zoVVAa8VHCC/SIS6yoxGCQvJ3kAZj5DuPuM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(346002)(376002)(396003)(366004)(39860400002)(558084003)(86362001)(33716001)(38070700005)(122000001)(38100700002)(8936002)(6486002)(478600001)(2906002)(41300700001)(5660300002)(44832011)(316002)(6916009)(54906003)(71200400001)(4326008)(8676002)(91956017)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(186003)(1076003)(26005)(19618925003)(6506007)(9686003)(6512007)(4270600006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w8VnzhV4ut/NUJRIJYgc3C+kA7Eg09+EqDqBue3tP/D2vKBOgPWE3vxgbLW8?=
 =?us-ascii?Q?4hG4RU+3MowzIvZ2NXhZkUIzX1vFPhKNd7/SoeON2K8ofVtaQt2ca3H94jjW?=
 =?us-ascii?Q?C1HYWylM0929qqd0JYHDGfIJVVO+ehymOxbPVQgBnh+vMWxPHK0p5wOJeV4M?=
 =?us-ascii?Q?NTYVECC3UDmap59IKQzbtQiZHQyRopxK6kSKrFK3xtusB28isAl+u3TGoWwT?=
 =?us-ascii?Q?sVlApF5IhMAxFaRH6bJCfZYR2ZKJaE2wL4BFjEQRPFavda8uIv5vaXN+cLeI?=
 =?us-ascii?Q?RvUnIis228Iw+D518Oivn4Vl68kDRosbFdybdueQUNDNjuFKsdtOdsEKYvSs?=
 =?us-ascii?Q?uAoJYB5kfQoylIuuhIWuX/NmuzB32GJPZEXeItOW0p+UUbqadJ1rV0/wwTmZ?=
 =?us-ascii?Q?AxBKI6a9gSAtCyE3LBt2vQiou6Q3cmxdGIXTeCp+GusamxMKsEjQlt4C+T7X?=
 =?us-ascii?Q?HxLnbhkjLUOcCfr3RmOUdMwTA+G4jDzbLL56oA7QiqABWdapkC655hnu4YhB?=
 =?us-ascii?Q?EafxOlIz/EhPLoiEP7Y0G5oMJmESGpsbjaWZnA3mHAxrCtY8eZQvz/uc9gc0?=
 =?us-ascii?Q?Xb3p2FZtzSeU3RhqLVJDoeCKraLfbpruWyjtAkUd9E5fDVHuekdIDldDjflG?=
 =?us-ascii?Q?gbnOw/f1WE2Tz21/xqNKQW3mAZrMFRNgsET7euwyC7FewnMZuBrPX97On3oy?=
 =?us-ascii?Q?c8WFdP+3TX/+b9ETn73KZ2VJP6bIRQN3dUgAlPSTrRokfYfIpSUb2V3hj1lC?=
 =?us-ascii?Q?mZK0yu9m56RVaWjMfY85SIUQCsy2kSJJ13To22kqmhel2SbeFinuJ+y61AFE?=
 =?us-ascii?Q?wGbtqGMj64ojLir9PGzAdLpAyUYmm4l6TqKzxE1+neu14VKJoB4nGjCwr2GP?=
 =?us-ascii?Q?vYCyoPfV1nV6l5FeOML/CetiW2cZRbm5KHETFJgxA4NGQxtYt5pwjoFuzYDt?=
 =?us-ascii?Q?Tn+zQXAt9u5FyL6z6IcRPiQKUbMw0VpD5lIkk7VbmfMN+i8KRBNg/ywI3L6r?=
 =?us-ascii?Q?cgr7nhCmZ8R46t681yOLv6z27Cp/qYtfAMocjpVrnQQTUOQIq4pULa/9TKQc?=
 =?us-ascii?Q?QpacpSseMIojuE+mbWN0dSK9roYEa7lgwhA4Qlwd4ZFWW3iaoWz852ys4dcd?=
 =?us-ascii?Q?J7aCuy3BiGM88mBQtutYNtIDvkkQEJ+OeiG/YfsfStgwHMQGwh7oP0APMnmR?=
 =?us-ascii?Q?teLvEMNVmXaIgv81/eU3IwQZAfb7oPOCengqA8S/BcdAfY9iubNnD4HHaHMv?=
 =?us-ascii?Q?h+2IXFeK98/u/FC6k4W7LedwSxZaszv2Ytd/NUoB7sMfYb6CgunxsAQ+6SLb?=
 =?us-ascii?Q?+4BokB1WHN9I15SvnnQiP/HgPW45cLbzv7J2teMSAY84NAPGfvwGVP/IE8k/?=
 =?us-ascii?Q?VCTVwtIGdwayDY3kdId0+tqZ+ZaZpIdqgWEbUPrnZMr+PeMTnHqi0HRJ81dY?=
 =?us-ascii?Q?XcMuP17xctAjp5DIlrA1XWyr9XL+dR6kHv4w6bkRwzaQNJdkA1XhmBON9TXb?=
 =?us-ascii?Q?xaRj7MRqSYPpVTer4fJqd56emyozQBo1BL12LrNR5MuV1fEnxhgdc4x6mCkI?=
 =?us-ascii?Q?74O79ykIpuxXTjq108ko3SF0yQzzB2ywgdVBc6iYLatpuht9JBtJKndBc+nF?=
 =?us-ascii?Q?Cg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6B898C35083AA34F8E4012CE0EBCF87E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b90cb9-bed1-44c9-50b6-08da5c376dd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2022 14:30:36.1752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l/Ry7TdPthFsdAhc4pnlga3jIEzMsNcRlu6wd6IaQ7kljm8zFzsimzLGluLrQiP7hYEQkYvIgV56V+VPO7zqcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4307
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Comment regarding patch title: s/reqisters/registers/=
