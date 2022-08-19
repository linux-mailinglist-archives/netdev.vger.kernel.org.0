Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298E0599D74
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 16:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349499AbiHSOUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 10:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349216AbiHSOUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 10:20:03 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20088.outbound.protection.outlook.com [40.107.2.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DB517A95;
        Fri, 19 Aug 2022 07:20:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atPBgK53D9xSQe8ZgAHlZ18jMRmpYWRinWQg5kikdZaKdTJTeXh8/E3x2mcTLwaeZhuH2PnHzAhejMb+zGjCdF8hLgXobV9J+apLnXGACZHE7LlTsXmH8nEQB3+iaThAHi6eojN2tPk0QeURYzTWKqPqeszuY+AVPhZM6YTSMLRFHWFWPfiWUdij6AGHyjf+zFHWk4tHiPM6C7dSbZcmv3Yd4soQ5JrOm4UQmaGn93M29p7+kLhPbArGSnefsECbUpB/RKORwSwWN6zwGl3IyvOY9KeFyRfZlLEgOec7Z6ZmcyOcmNoRDTCUCEtFt4dz8ArvHV8cXTnlK22f1Tl4rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SNZD5DdVSN0FSW17J7VO0Skug7he4fJGT3ME942KDJI=;
 b=cMvx4IKurEinC8k25zx6k49B00B7nl61gD9FEdHIEQd30JFCk2sNF7fHOA47mzdPSiQxAmeiw44jIdZreh8/hCrp9Nj0UzGI8WsF3lj/EO/OLajaMIw2EqMbL/ubLpTVs8/WEVc4Xs0rUL1V83DzgykX8yZaLhfQqYmDDpZ9sq2B0P7GSD4K8LAaE89WSr1ZUIhsmJgpZ70nOvS7tdR5Ry1puE7I0lrgCmaB94EGto2HgPX388iDCwh7F/iS2yezXwKEcDo6cb8iaFAQSlXU/BEU+iR//NgoFSV2NbofsTzZsaN7Z7tz6pJuhMIBr8qJSURNTCGn+lKoC/UwItQ9DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16) by VI1PR0101MB2574.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:5c::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 19 Aug
 2022 14:19:58 +0000
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 ([fe80::19b7:7216:e4a2:b0b]) by
 AM6PR0102MB3159.eurprd01.prod.exchangelabs.com ([fe80::19b7:7216:e4a2:b0b%7])
 with mapi id 15.20.5504.028; Fri, 19 Aug 2022 14:19:58 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v5 0/3] net: ethernet: adi: Add ADIN1110 support
Date:   Fri, 19 Aug 2022 17:19:38 +0300
Message-Id: <20220819141941.39635-1-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: BE0P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::16) To AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58cf5ec0-9b35-4831-7335-08da81ede53d
X-MS-TrafficTypeDiagnostic: VI1PR0101MB2574:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pe5PmnS3vDF0Srzlp/EPUkp/ixDCdSpBCZdjSl43ye4mmfib9IXHOGOU2hxFOkvIS1U0eR8hNqVTDY/VKwl8XjNHVVD7i15qtIlgZG5/pjn543PYp0b+vXvsFfJyYtf2ebP5wl+zJkf1cW+IDFwY3E7UhZorikldPr8mBLbzxQLmGrDlkZZj5gf9d5Beusqd77Lj6/B2UH6aVkKhKDFS7oxRUkZYhFClTQEDOCAoLCU6x4Cjuq0BDsgmzPVAdfDlMmSa48JAdJ81eSePAqM4bW8VRPWldOh2+8DYdXwidbIS2RKd0oVDtPsZghXV0tCK0GSQbBFggcQvGxmwf9oduPHS1OTA8cKUyN3wNpRGYJDDQb8wSeMfagnn1tGh5FiKRD8aVSg8Dm2anNgRTEN6aFuYsgS6vc+duazXc3sKdTZ00ko+masdT6PzbK98TBCCeJyfefQxpzG2UjY2r/P8KNfhymnApgU+dRyo0ZIF4XEKnOHzhaEvpjj4nN4hHPafLoRPGHcJmeni7xAfBt+ZjxpPY8VhZyr6ptFTMCBNMMNHaAKvAl7iDfKKinrCpWrpyjdUzK8JbHfyI9ot1vKtpNzMLN9bO51bv6nHMP1ixHlDn8fv4IwwUXYEG/82JEBK8TMgbBCCUFWKjy2WgEj4pZq9qOmFrSPVSnp6Yu5LQWzZpG2jUDh7GiEeSGu/YaClyusqOWHj1vLOr8ispi3pjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0102MB3159.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(39860400002)(366004)(376002)(396003)(186003)(478600001)(83380400001)(38100700002)(6916009)(52116002)(41300700001)(86362001)(6506007)(8936002)(6512007)(9686003)(6666004)(41320700001)(2906002)(316002)(6486002)(5660300002)(7416002)(786003)(2616005)(8676002)(66556008)(4326008)(66476007)(1076003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yOWlizIjCOs4ZIl+C1uqg22HDBSHWXU5QLAmXyhdrNHeB4/aWfzLyI+/206M?=
 =?us-ascii?Q?6CVMocKHU0s4VqTdgUUXHRdaUw4jxTeDkeZ3s9V+vU1y7bycX4eJ2HNHmsEJ?=
 =?us-ascii?Q?n5KHPX7YOt1PPM0QQOchVmlEgAvVYgCkFIzfvTacxn8kNzp0BERj2KltH/fj?=
 =?us-ascii?Q?yX6NikgtGTFONQoeGsgbM84JUmlZ8iUxaVCUJ71bcmhpDIe4xCGtERbR5O0K?=
 =?us-ascii?Q?6B3SN2Bv17wnkbHOT5S+YCMRQqVaotM8iG1frBUvPSr6f0mutphpFAendSbf?=
 =?us-ascii?Q?lVSkHFWaRUp6qBUEHuEB/ERa1G+TTstHmrmyKkAZXMYX6QZDpDxTcMEaZNh6?=
 =?us-ascii?Q?L0rmokgiZ8G7D53ubi2p9bkMnUfZpfMWSZhuagGpZX/ti6PSu/crkL7chMBN?=
 =?us-ascii?Q?FNSDbpkDJFfv4cdna877X84FsY+U4Erl6e3eGqZCGYCEQVGe0QuK6joTPKpu?=
 =?us-ascii?Q?YHnSMnb9v058MDyaKSvXP23QB08sQmsi2VQAnj5nZv2L5NkClrloYPh85R/t?=
 =?us-ascii?Q?gRmPRa9EVKwMuDMVDAJ1FGcpjs90cPqNmYjGy3wPjmIgLK9WG9dlECx71r/R?=
 =?us-ascii?Q?p2wRFMV4UlwwNea6/y+P4+YJeUVOJ9mrQ66qlUxng4OUwcQa1URaa3As45+s?=
 =?us-ascii?Q?Iglkth//Vqvz0ZYW8OuDze3i0hu/FegbpgqO60xAF79Uh9B16MDEypb/lLhJ?=
 =?us-ascii?Q?DTlMVC8jmELrWhK9WAsMb2pd3s+7/45ZiJ9Fy8dJJRt3onprJz0mqMOnZh9+?=
 =?us-ascii?Q?buA6KkCwzyaYE5b/9CN79qfkhJKgwafMTAdqT+Js1Zrx3c7ONiPjhRX9r1iL?=
 =?us-ascii?Q?cyOEhUgp+QrjuzgcpFVeMSt7YcHpTQmys0VbTahpYGtzGcS+jBgurQk4qR0g?=
 =?us-ascii?Q?AzQ1o4mYx4TUtHA/SGNg4E6F2Oo/b0ZOkQf+5EmExtPuWwcsaM9Uo+CgEKTF?=
 =?us-ascii?Q?4KTcW15rLZSQXujf82Hs6eDSbDm88pbZasvrOm2LtytQQmC5lk3hFYDjC3Ll?=
 =?us-ascii?Q?kkrNFbArPydpxyjaEEg7bvjGhSRriy100BA4d1vxqdQSTQ6S+3hVRgjH654K?=
 =?us-ascii?Q?OPrGq9D/Dv2ijezVzajeZ3W9//bgX/+KY7t5LzMRZ5doDnr/V81KnSdOmtwL?=
 =?us-ascii?Q?9nJGSgcNeDVEm3O7sNipr3sSBKIdRBBKFibs21R8WuswNyouIz6utRI8k1yT?=
 =?us-ascii?Q?rS0tt8ef1jxsxaFXqsvOLef2mtyyEEWHJkyvfNe0wUYlr7WVZcwNYKQS44K4?=
 =?us-ascii?Q?NW8aQ/5SPEN6Ahjvx9A5uwWQz8rCBc88qfayUvZaawIdHBF2CDVmFoGR5eiM?=
 =?us-ascii?Q?yLwgibuFBwEOIH9G+Z6eUozVXKyExLlHQ3wqgm9gOFetQSDyJuaoqjbMKnvu?=
 =?us-ascii?Q?plIFTKk2v4CKYgY/cvX5dPAEBT16kClcHGME5MBXvKaGEAe3K0EdBGJgAl7P?=
 =?us-ascii?Q?uBUnkk1KQQDfRaHuzkwpfkAI86M1GcCCjvZmD0JlcIOWepgd6O1rHOi33oSZ?=
 =?us-ascii?Q?Un22x1XMMR7VUEZzahuUQlfm0sgHyHlyz6uBbhz5Ykrfe2fPswV6iR+bDjzN?=
 =?us-ascii?Q?vhsGq9Qu0iAj+qXFNKhFrFPihfMMKG8SrlwwKgNM6I3lht1ikSCMWc3oElMR?=
 =?us-ascii?Q?n12gUfyhHr/65Z3bIZIDAQMHlsKOsDoy+XcvD65aZma47sF4iYCrQSqByOgF?=
 =?us-ascii?Q?XlPoog=3D=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: 58cf5ec0-9b35-4831-7335-08da81ede53d
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 14:19:58.3963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q6hW3btZtRocGMQVbFl77+wk/kxAp+47kanuI7I4B1jqNl0BS0qtSOre1K8eiLzYPVBwgm+T8qvClcFJp8cMhMSaAPGmfICObpb7BiQ4OWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0101MB2574
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

The ADIN1110 is a low power single port 10BASE-T1L MAC-PHY
designed for industrial Ethernet applications. It integrates
an Ethernet PHY core with a MAC and all the associated analog
circuitry, input and output clock buffering.

ADIN1110 MAC-PHY encapsulates the ADIN1100 PHY. The PHY registers
can be accessed through the MDIO MAC registers.
We are registering an MDIO bus with custom read/write in order
to let the PHY to be discovered by the PAL. This will let
the ADIN1100 Linux driver to probe and take control of
the PHY.

The ADIN2111 is a low power, low complexity, two-Ethernet ports
switch with integrated 10BASE-T1L PHYs and one serial peripheral
interface (SPI) port.

The device is designed for industrial Ethernet applications using
low power constrained nodes and is compliant with the IEEE 802.3cg-2019
Ethernet standard for long reach 10 Mbps single pair Ethernet (SPE).
The switch supports various routing configurations between
the two Ethernet ports and the SPI host port providing a flexible
solution for line, daisy-chain, or ring network topologies.

The ADIN2111 supports cable reach of up to 1700 meters with ultra
low power consumption of 77 mW. The two PHY cores support the
1.0 V p-p operating mode and the 2.4 V p-p operating mode defined
in the IEEE 802.3cg standard.

The device integrates the switch, two Ethernet physical layer (PHY)
cores with a media access control (MAC) interface and all the
associated analog circuitry, and input and output clock buffering.

The device also includes internal buffer queues, the SPI and
subsystem registers, as well as the control logic to manage the reset
and clock control and hardware pin configuration.

Access to the PHYs is exposed via an internal MDIO bus. Writes/reads
can be performed by reading/writing to the ADIN2111 MDIO registers
via SPI.

On probe, for each port, a struct net_device is allocated and
registered. When both ports are added to the same bridge, the driver
will enable offloading of frame forwarding at the hardware level.

Driver offers STP support. Normal operation on forwarding state.
Allows only frames with the 802.1d DA to be passed to the host
when in any of the other states.

Supports both VEB and VEPA modes. In VEB mode multicast/broadcast
and unknown frames are handled by the ADIN2111, sw bridge will
not see them (this is to save SPI bandwidth). In VEPA mode,
all forwarding will be handled by the sw bridge, ADIN2111 will
not attempt to forward any frames in hardware to the other port.

Alexandru Tachici (3):
  net: phy: adin1100: add PHY IDs of adin1110/adin2111
  net: ethernet: adi: Add ADIN1110 support
  dt-bindings: net: adin1110: Add docs

Changelog V4 -> V5:
	- in adin1110_can_offload_forwarding(): check whether there is a port
	not in forwarding mode. In that case don't allow HW forwarding. Added
	this bug inadvertently when I added VEPA/VEB support.

 .../devicetree/bindings/net/adi,adin1110.yaml |   77 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/adi/Kconfig              |   28 +
 drivers/net/ethernet/adi/Makefile             |    6 +
 drivers/net/ethernet/adi/adin1110.c           | 1458 +++++++++++++++++
 drivers/net/phy/adin1100.c                    |    7 +-
 7 files changed, 1577 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml
 create mode 100644 drivers/net/ethernet/adi/Kconfig
 create mode 100644 drivers/net/ethernet/adi/Makefile
 create mode 100644 drivers/net/ethernet/adi/adin1110.c

-- 
2.25.1

