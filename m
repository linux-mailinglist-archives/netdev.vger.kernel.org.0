Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F17E5163F2
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345166AbiEALMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234935AbiEALMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:12:00 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2060.outbound.protection.outlook.com [40.107.104.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439714EDF4;
        Sun,  1 May 2022 04:08:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a57Eo+N0KjJTPiK5HrzpGPkAa3hdEC7qK/4Knl/V9JAHqRDk98JcmZBA23Epj7H67AoBbOtD+1As+j936Es40QXOU9/WrBKavyNWBJFs49OS5uzIm4gm52AFHY5aKcchqzm1rkw12ZbsRXcyIbIsballW+HDo1k579CoYrdQ7KiK15TiJcuP0MMEyoP3vnrf8/KIEtSCPJvH4jUHEqyKibOxANU3iWSoukhfab/zoqyTumXkQ1OijY54B+KlVLUTxlLw8cmw7rJp38OdDesA6+pfbUKOve7DZJTJ/qpF8g20JxueEeKrvqvaWBMPZBISob+jG3AgmF4sO/O5kBsKyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eYctLJsHIhOgOsfpfB9WC9e/KRgflrhu1VhrXpagynk=;
 b=VwTPETDMqYkr4/SrsWoBst1FiZxtjxf/WGYiZAVrM42SevlwIl26r9O8Goj6a0Z1aNyPuHINOKUWVz2pOVo/BvNtIOQJE/t57bMU+W1Tmd8sTi2EYhI9PiwFjHRCn9yJrvc5huNcEwYRSJ5qV9ELur3ottTqs45LXdbpWxiZpS6in000siZ9Oate9MQvahQ+On9D9MlkrTv3l66XJ9Gbfw7F718JHhjhzfA7gLOFTMDdlzKMASknBMsTjV12D9A0ZUwDBwjd82GxtP3+buoul9GPvouRpLPrl5/urvNRRwWXePf42tlnNzpViT67aL1CmoWB1EZuO3xmzKGd3zoDwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYctLJsHIhOgOsfpfB9WC9e/KRgflrhu1VhrXpagynk=;
 b=FhT/Ca/pvacQLQv/iKXoepBch1I2LsvTYlMBHO1qLd6L4pwaIz3GeNDi67TLuRQ32zw6psK5jC2IyXZcTy7nrUQwPzHGWc/KpclWDwD7Rvk9Ea1S6LEPjPO8hEmgewzkIMJL0K9M7tJRphrMFhfyI/rCxEq798RiD/Uq2a/tnug=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6862.eurprd04.prod.outlook.com (2603:10a6:803:130::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sun, 1 May
 2022 11:08:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.014; Sun, 1 May 2022
 11:08:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next 1/2] net: mscc: ocelot: remove unnecessary
 variable
Thread-Topic: [PATCH v1 net-next 1/2] net: mscc: ocelot: remove unnecessary
 variable
Thread-Index: AQHYXOlXKyVUt7/ZYUirbL8KuFWiB60J3cKA
Date:   Sun, 1 May 2022 11:08:32 +0000
Message-ID: <20220501110831.klfcbqiapumdndyz@skbuf>
References: <20220430232327.4091825-1-colin.foster@in-advantage.com>
 <20220430232327.4091825-2-colin.foster@in-advantage.com>
In-Reply-To: <20220430232327.4091825-2-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa4c944a-6e8e-4958-aaca-08da2b62edbd
x-ms-traffictypediagnostic: VI1PR04MB6862:EE_
x-microsoft-antispam-prvs: <VI1PR04MB6862E29E5A0C1776C9D37976E0FE9@VI1PR04MB6862.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LlHwQfzncFOE0I4Q/VwzOVWnJ9aywyJMfnouKiCZLZ+h72TGWZq7I7NIF3GceckbIvaJmGlAtQFSDpVDpSZEHn5i5D2BdFd6O7Oce5NtoUX8JU9Zu3sEc6Ney9OhY0a3Ad/w4hG/cp+BVuA1M59UTPoBfifhxkXmhaHPySOT1EEZO9Miun+Tpw8j3yTb/g69K0c1O6iDOA+JvHeuRD1zx+L4EQE5upzwMyLVU3yXrLiZBupVk8QCmPOvuGJAo9YaGYOFHq5sw7QwcZ/RTxVtn3lSdppA5OjOcIsVC2GUcGSSSSbSIpSDcn4wy3uqD+8TVMCDflzCqL+fHIgz2s/uaEdWaXaEjnl6TD9xqYveKR1WoywqKgFint8E/3IkRVgYSh95GYX8pQHJMnklIW723OrOQPpUo9lneTy8YEs090J63tt20PcNtC0fJvKODavNbuetTNUvd3UTeYoaTIcx4fH2pfrbuYG8lKINnbshsqpY49zc3xifA8zkCvZK8nK3oSbo0nuTmmvZb8fEXc8OV2Zm/czt/VqjCLAY9M2oNj4GdElf3aIxRifY8mE3R5bmBxFcy5o3Cm6hJvTpjVudGNN8gbPNudonErfeIBb0DwoaUenGx8JsnQcR3B4csXjRVc9XNgXjogZAieCvGCp6Ohq+MTpqXgxUOxssaCV6gYeK74o6Q/dRRlkxcfyc38ph03hTww7tZUhhaFeoz/vSdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(1076003)(2906002)(86362001)(3716004)(186003)(5660300002)(316002)(6512007)(122000001)(9686003)(6506007)(33716001)(26005)(4744005)(91956017)(76116006)(4326008)(44832011)(8936002)(8676002)(38100700002)(38070700005)(6916009)(54906003)(66556008)(6486002)(66476007)(508600001)(66946007)(71200400001)(66446008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7bOMVmEgNRID2XOmUskP72cYSLS7BsqYGhGKSLnX9hw20dCDrY+5MpCvVy0K?=
 =?us-ascii?Q?+UH/VhEv+ce6R87r4OXq64Q7h3xJwAKQf+oQ+hd2ViMaqbUB5fC/8VZBAJpx?=
 =?us-ascii?Q?w1XePENic1nrtQCF/KYzRxsCZaRCCRasy9pL2420FEroGIahLyqTU0VPBeqG?=
 =?us-ascii?Q?nFV9K/K97dHGMtlhLZwDw4Fr/CZSc1VKHhLrp514Rw9+2kgl+MU3c+nsBhC6?=
 =?us-ascii?Q?l/9mx6F89PRmBkklovVd33UuqANmMqrJgv6jAkEqQb3A8dKkZ9JV9fXycAdc?=
 =?us-ascii?Q?marTAQnTbKwsakY7jyLV3k+vjJ4ypfjXjXvfaz55zFeh3mZmXbRGeV73OVSg?=
 =?us-ascii?Q?Hu/VkmHHMDCVgrKiLks/JosSZGAHDCNG+rL/5gD5hPBbNfrj6JOGTyjPGML/?=
 =?us-ascii?Q?u8eEdM/y/rE8pwRzUxKJahu/eKAPY7Xe5SMRtvFss4ndn+F1h0aZYNFDhJ+A?=
 =?us-ascii?Q?hhi0Uom+0TG593GpARVB8RfDc1RIw8L1MT7r/fomOC3ULdNoLyUtAcSNCF7G?=
 =?us-ascii?Q?Y8m6yeU/FT94CpaNUwP8WLNYdPvdJIE0qV4LlL3nnMLJBcuydL8o6PL8+OJZ?=
 =?us-ascii?Q?aeStj9albwB53sBl45KkDcZggrGrDd7sLotUTRr8EfMeDobTaMd7TFDOEgwh?=
 =?us-ascii?Q?2GuqhXDxs3PLstJwGfKObRrsGPt/xAuP1AXFvTp/OLaIhqNF+bx5tqG5tjqH?=
 =?us-ascii?Q?NX4IZYqXuJt5OdSay3rv67hQqkXpWHiEpG+NMeqTL79xXGxbcPUOjYGI1Hyb?=
 =?us-ascii?Q?BXHq/cdpjxvrsftNu9+GTs7S1SV7Cbgn04NK6f7VDN25VHC/VgsbZpmROoQ8?=
 =?us-ascii?Q?xeUgkvMwQo9yiOUGJcOrVD9G4JlXh1zcfcxSmVMYJb7kdIJ+xr1HIxW8MPBB?=
 =?us-ascii?Q?G9Y9hm+GYHZ7rartbbjxyqFYAn3vWhyknQftq4dXJNbQ65h6OnQNEIO2efG1?=
 =?us-ascii?Q?BPsiEbVmoDXsBW/MZRrhjvdV+OpnW2Bf6CaFTHaiv1geJya9+hd5j8FM0Gti?=
 =?us-ascii?Q?YP+GUp/DM8Ykw9IzCpxxXjZwdTpYmcA1Yk/9aOasiusGVFEi1UOY8eX4VaBd?=
 =?us-ascii?Q?GCewO+vI0E7vo1ulI/pI18fbGgJ84Dzv28dEmojC/AzF78ySXxGQqeWls5j4?=
 =?us-ascii?Q?zj/txWSgptTMh9cQCfyZ3/0VFqT0VmzeeZBGzdiD0sZq62n70v8BidEW74sU?=
 =?us-ascii?Q?H03NJ68yVAO3+grfUoDrZqEyoTTq/8oT7/f+V4I+/OeljFpeWocPtX6T9E4r?=
 =?us-ascii?Q?I4711hCQ88A8URzJn4ADrzCnv7/EVHtcjx+6ji3DusQhfgYXDTezXJGaqH6P?=
 =?us-ascii?Q?X4J1SwVSzyxv+yk8qbOHqhh0MbgPlqp+Lm0/pIyCHN+ud4CMkTSR2TjNOOY6?=
 =?us-ascii?Q?t4XdhU6ABLq+u9Hx4FMIylYGfY+AusJhZa/I1+hpdtP965j1PTAfLbA3XaKv?=
 =?us-ascii?Q?L5Va1e/zJ66prfDfugzEziP87aYlaBx7DsiGcyuAFo9HrI3kdFrd3JIrsj8L?=
 =?us-ascii?Q?P0o5o14ut2wjLloCOYi8dsbPVzIjwbjPjrFrBtDC4kvhx59C94Nt3YoYj7s2?=
 =?us-ascii?Q?Grbrh92yclXp/U8caqhty2n+JewC6dMxU1KqsYbknREXXdFB1Kv57pik80XR?=
 =?us-ascii?Q?O2x7PVSDNZiJpVG3XADMeZImowjJETy8V1m0M3/OwoUNc8TS4brPhMM1JcEw?=
 =?us-ascii?Q?T0+0nNduiRwPlcFMl9o8HkUdVdz2TcFO2hWSreom3ABpFHzUxtls2rJ05mpB?=
 =?us-ascii?Q?Z8tvCqK+G4wZUk2n2ny+BKcuwpCKcUQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B6464C7F17DAB14FBA427848C19521F1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4c944a-6e8e-4958-aaca-08da2b62edbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2022 11:08:32.1609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E4ERtltoKlqPm/jxWE4wOA+uqhje95awu+a7YfKpunTlhY1VP1jtMHADulQ2w3uiUMXVrNYgNhK1p9z0fm4ynw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6862
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 30, 2022 at 04:23:26PM -0700, Colin Foster wrote:
> Commit 2f187bfa6f35 ("net: ethernet: ocelot: remove the need for num_stat=
s
> initializer") added a flags field to the ocelot stats structure. The same
> behavior can be achieved without this additional field taking up extra
> memory.
>=20
> Remove this structure element to free up RAM
>=20
> Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
