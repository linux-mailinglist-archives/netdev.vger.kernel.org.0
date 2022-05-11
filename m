Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13291524070
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 00:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348934AbiEKW5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 18:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348903AbiEKW5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 18:57:50 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150070.outbound.protection.outlook.com [40.107.15.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5E83B3E2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 15:57:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFeCqx9vM2hlN2NZgvO37lN/CKCzBZkrGTbV8Sluro27Txb+lGqQ17r/LnhSN092LksOvu1OCbic3v8+0LgAAd24CQRraSmXFd3ABTm4uQAMQiEd2iatOvBJodbUQMJKFZbKu9CeHEJwQFZWlBVDPQjWrd5OCyixd1xIEn31eNPsjHnEyGMF6XpG0b628HleD9RZrDBAPRt9RDi71Ux0ejOo3wGMYXxi0e/qS+2SkAQ7l/1fMFiXsmLQ7kDLLlXdzBH9OskDa3DO0sdlATDhnWHbdLEUzF310QBx5Wopzke/EKS5txLrpbSExLN4oCsfn02jJd759KTHMrBbnfWkgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McuCJeGrUSOPauXuOljmxZQfm9ZmsQ9BuV66PqhvZhc=;
 b=haD9ABVkAUZQvRc2uBEUEqxEW8g+CcCtswx6B+YsmKnFebLUT/xPOtG5YbR/oXWkOJggxmAmgUtpdFEDvpizvMbXHsNfcL6uPe7liUNU7cK/EX47YpB5G/I2rXaZ0xTuavrR/yuh05n75NxSPXM52Jr9rhC0ggu5/tdBfE4om/LhOx3wblDEbzNgt3UbqFcrvX3n3fInLlWRwbhGQi37wr1/1dRnrpu1piZkHY+kflrFY/pBRMynkge2yMmqjBuLuIDWA/qpzNPi3odz60W7gvXSVkMXACU1BoRbia7GYcz86U3/5Ke2Sz4a/lBo6Ev78NNXJnbc8NpKY3uG781hyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=McuCJeGrUSOPauXuOljmxZQfm9ZmsQ9BuV66PqhvZhc=;
 b=fMKHlV14x7I/d9ACYUANcSbWnKcseB9OgLIaR4eamLgejVTe6XgcWAKGOywfBCkQ+PqHNLn7hDQIb0R6gqWpXVhcSXGfmvirYWy+OH0cT6K8i6PrUyOJg1dA6DLC37UEPYBN9923HF5nsUckItXagllv+lU8U8WPAABiv4zWH7M=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9399.eurprd04.prod.outlook.com (2603:10a6:102:2b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Wed, 11 May
 2022 22:57:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 22:57:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Michael Walle <michael@walle.cc>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: count the tc-taprio window drops
Thread-Topic: [PATCH net-next 2/2] net: enetc: count the tc-taprio window
 drops
Thread-Index: AQHYZIwYAyud9yi3kkettoRjyMxmN60aQ40AgAAIaIA=
Date:   Wed, 11 May 2022 22:57:46 +0000
Message-ID: <20220511225745.xgrhiaghckrcxdaj@skbuf>
References: <20220510163615.6096-1-vladimir.oltean@nxp.com>
 <20220510163615.6096-3-vladimir.oltean@nxp.com>
 <20220511152740.63883ddf@kernel.org>
In-Reply-To: <20220511152740.63883ddf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d1fecf5-fae8-482d-8229-08da33a1aa38
x-ms-traffictypediagnostic: PAXPR04MB9399:EE_
x-microsoft-antispam-prvs: <PAXPR04MB9399B132697E856AF2BA003CE0C89@PAXPR04MB9399.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jdWYDRs+bXf3liA+xsluCoKldqXFhCNyC2v7czLfYG68/87mG0HhcJHxgo3EYquM+wKbp8NJAFlpSONZZrJwq7eDcUCtoT4u/K4pbKHOG9hvmvGlYyCGugtw63gx+BVqdfJGbv7dmpVtOGKc8FBu4UpV86tb1CqjaVc7xJzkgo5Vpdrmm74KfvXIx73orNw2rvpVUNnd71Srqnm076Bfd3KU0X6KLY5tMA81QdGYPYpx4SF8ACuUjEJGDcjnau5s3waniwwe8tNQcXXuorLprfcnWLi82/laq2sgM7IoHFgyKDWC/v3zjZ3Xsc/25yGslazjhjEa9yKNczcxLeQyWSHhM9WwiUbncPjRMXP/8t4VLdFFlALM0K7jtDgVdArMQY5zI1Z+WysjiIYa7gUgRtaMEv4/wwOyYv97D4T1NyOPdU91u6zCQdsE4KUnZQggy+Pu5/kzGIAKeOfFbqan5UW4q54Wj07Ftj0mD5rGKNczfA4luQMce4nWWbLCznNIwO1wlzKpqQTkwzCe6Fd2Qq55c0jSIY4Cvv9eGqTkQNPic41wcSLlD2L7u2ZKe4lQA6BXbzGsZ1M5dwg3GulomGL8+qAMINVufm0z/CXw9y9vFRFVjbNHo9Nt+YIZKblhhrcguMSLg3RW/C/YpRKtVvW9PuZxCb4CfdUZs+qybcPlnVJ+N04WIymSR26BOuOfGorvQDJCS73ao2JfA5HSRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6512007)(5660300002)(38100700002)(1076003)(38070700005)(64756008)(6486002)(83380400001)(508600001)(9686003)(71200400001)(26005)(86362001)(2906002)(6506007)(3716004)(6916009)(54906003)(19627235002)(316002)(186003)(4326008)(44832011)(122000001)(91956017)(76116006)(33716001)(66476007)(8936002)(8676002)(66946007)(66446008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iqaG9v7+LFUwfmMeYzaxbKSQLvdlJYl8ZCfZTIMrMUNqJu5FdfvBCwNNuOv4?=
 =?us-ascii?Q?6mAadUgNBTTe/JqVJ/ikdLYnYc7FMH59pExYAYp+Rhq17rupOvf2XQ7cjvQd?=
 =?us-ascii?Q?qUQ1ZbxzW/l0fLKBNzpgL9J+7ya1fGt65fiNDb/8JQfXA+zKk0m1OzrGprXF?=
 =?us-ascii?Q?2jbd8JdU+TNtQS6ka662EZ2SehxMjNqEy5m0xdkNq+lD5z9KhAVPzXnh56WU?=
 =?us-ascii?Q?VaV72ROXnkXrYJBXOfrzkbPVkdmT1FFnOOMn+SZG1ecwwXZrsK4Mk9lRzpYD?=
 =?us-ascii?Q?XzvHTslJex5uboMcoJm2vadPVritcQAK7OfDsnHQFbsCfVTgFihXpn9/S1s1?=
 =?us-ascii?Q?6in4KWEvCLvj0VvdBkPabUWOC7mYGgAa9lc9Ywe/LJ8C9Uhx+OUTkn1h1gUD?=
 =?us-ascii?Q?zv0BsbW5zNzIGpI3ksiIlSFBTZc71GlC2uP4tYKljLUPNKdkL19dZA2osG/M?=
 =?us-ascii?Q?vM2LpWRldB8j9R+zwWEivwgIxQ9XplDT92lNFgIPNQY+Khx80T+kE7f0uv/0?=
 =?us-ascii?Q?MRFMxP8DJJ/nnymaWtwo+suCUnhMLyrucMueIYO9qY3YnHIl3S0P46j2IYmc?=
 =?us-ascii?Q?XNZEJLpkfF7juCTWhNZ/PnU0aixfuzZWDvwiCR7/SBBdcyu4hCqwlRaDf0LA?=
 =?us-ascii?Q?CYNLkHaBl8L6SeEUa0r7jH3rjsKd58fpkX4pAElLPrjjvYTu2LoRqqMW3z/x?=
 =?us-ascii?Q?wWh4V1kjjNutijKyv3+QoFlBcCTaf5ro03yTNiXiiNa9NZ4KZIDG0KYK2Tmu?=
 =?us-ascii?Q?F5AwHs0boDwFwWGGsB6NIUoGGkz4XrMUs97TUlejh9rdy6KoGkcUoM2dO8hp?=
 =?us-ascii?Q?ddzStvb9prr/Q6snnMR4qJmxxtDj+3h/ljdVYIu5pNYZibgodvFzXGk/a53i?=
 =?us-ascii?Q?mQHz0dbbt3Mks2QtQKeHJf/Uco1y2CM2CpGwhR7aMIxNvtedmxNE1lgsFhiH?=
 =?us-ascii?Q?LP7amcjNlKisBUZg+BY9xTzI1USRSIJ8lbWbypEwTFFBzFd/IbYxZu1j7F3t?=
 =?us-ascii?Q?cQz7CTBROTJGggELqpOOPgEGV1yt5n2B9FfYE2PcJahPAKR6Af2akGg8e5U/?=
 =?us-ascii?Q?Z4gyRg9Io4gG230ivxgeeK8qJJ4o4tB/FzLtuEkNjuosq66YKi+DLkRfE7Fr?=
 =?us-ascii?Q?RHZJ9IiBpjg/O+6MVJwZLPtNQ+aGa+q6WE6QumlEFSPewGekmjj5GA995uXz?=
 =?us-ascii?Q?8EKS1JrCweiPxXa9u1TrCURmlV3peW9F1pdFSI+sw9xWFFBNo0IwStArwAFk?=
 =?us-ascii?Q?rI/vkDVBYmtPuFfHNJ8aoIpqibwwCvTNUXJuFuEDXJeSV8jtrrGT4VotyomI?=
 =?us-ascii?Q?t+9b9LrWdN1WJsViEwbbz1iBU0HxGJajOYjFlToy5fMmNanfEgtnbmemIUa6?=
 =?us-ascii?Q?dHaLi4eYd0l1HI3i0dvUcDYxF7JWx0ylxWL0sMnf8eplhBFEIG0ZZh5SHDps?=
 =?us-ascii?Q?RQh+2Gv7D/J6AXgCKpeJt7VCETVrEaGv2s0o9qOuYiY/c2D0+pExN/y9ulP1?=
 =?us-ascii?Q?ke7GDt/H6Cjlhs9pvKKpnVmLpn+2Or2ZaVqOCMVOOq2Z1LQvvLj7c2osCpIM?=
 =?us-ascii?Q?RmouW2wLAYo7qnwj/k8UN/yfcTgDyHKoI8vaJsMa4LKgo1gFB34Kfe18ipkG?=
 =?us-ascii?Q?O+yhjMOlHik4YQOVxgnG0FwrW4ZHoyIYGHAPJwfFlTY/94zOShcPvGpCK5KX?=
 =?us-ascii?Q?QpfKO1DjeT/ud7PDIl0mJdBeclIz1hBfPmm7lh/ONDLkhnfTCRYxuokkhPSQ?=
 =?us-ascii?Q?MDXvxBBCs87NtZ43H+ZwBnQRZ2RPU3Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <868F10FA5FF9A34AB7AE80290D5DC870@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1fecf5-fae8-482d-8229-08da33a1aa38
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 22:57:46.4459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bw8up7qmy1ZasW4s1iADQ5JppNkHJXCFrFtj7+Cc+KztkTA3/D+TlT7tQkacc2bRI3aDQyovRBiUI0+Ug2ZOfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 03:27:40PM -0700, Jakub Kicinski wrote:
> On Tue, 10 May 2022 19:36:15 +0300 Vladimir Oltean wrote:
> > From: Po Liu <Po.Liu@nxp.com>
> >=20
> > The enetc scheduler for IEEE 802.1Qbv has 2 options (depending on
> > PTGCR[TG_DROP_DISABLE]) when we attempt to send an oversized packet
> > which will never fit in its allotted time slot for its traffic class:
> > either block the entire port due to head-of-line blocking, or drop the
> > packet and set a bit in the writeback format of the transmit buffer
> > descriptor, allowing other packets to be sent.
> >=20
> > We obviously choose the second option in the driver, but we do not
> > detect the drop condition, so from the perspective of the network stack=
,
> > the packet is sent and no error counter is incremented.
> >=20
> > This change checks the writeback of the TX BD when tc-taprio is enabled=
,
> > and increments a specific ethtool statistics counter and a generic
> > "tx_dropped" counter in ndo_get_stats64.
>=20
> Is there no MIB attribute in the standard for such drops?
>=20
> The semantics seem petty implementation-independent can we put it into
> some structured ethtool stats instead?

My copy of IEEE 802.1Q-2018 talks about the following MIB table entries
in clause 17.2.22 Structure of the IEEE8021-ST-MIB:

ieee8021STMaxSDU subtree
  ieee8021STMaxSDUTable
  ieee8021STTrafficClass
  ieee8021STMaxSDU
  ieee8021TransmissionOverrun

ieee8021STParameters
  ieee8021STParametersTable
  ieee8021STGateEnabled
  ieee8021STAdminGateStates
  ieee8021STOperGateStates
  ieee8021STAdminControlListLength
  ieee8021STOperControlListLength
  ieee8021STAdminControlList
  ieee8021STOperControlList
  ieee8021STAdminCycleTimeNumerator
  ieee8021STAdminCycleTimeDenominator
  ieee8021STOperCycleTimeNumerator
  ieee8021STOperCycleTimeDenominator
  ieee8021STAdminCycleTimeExtension
  ieee8021STOperCycleTimeExtension
  ieee8021STAdminBaseTime
  ieee8021STOperBaseTime
  ieee8021STConfigChange
  ieee8021STConfigChangeTime
  ieee8021STTickGranularity
  ieee8021STCurrentTime
  ieee802STConfigPending
  ieee8021STSupportedListMax

The only entry that is a counter in the Scheduled Traffic MIB is Transmissi=
onOverrun,
but that isn't what this is. Instead, this would be a TransmissionOverrunAv=
oidedByDropping,
for which there appears to be no standardization.=
