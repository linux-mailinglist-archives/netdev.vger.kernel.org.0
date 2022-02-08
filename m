Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8DF4ADDFA
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 17:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382711AbiBHQKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 11:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343745AbiBHQKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 11:10:35 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2081.outbound.protection.outlook.com [40.107.21.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19712C061576;
        Tue,  8 Feb 2022 08:10:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYUhO6j95T78IwxK/oX2QAV+ulQJrVKuXloOQyV65W4D8CCnBApqhtZReLFcfyrzm8rQGLkZiylswT/JPBXSKaUvb4tbGaRlFanqosA4G3toNRFEoRAl41gXtS1t8FXOJVEulGXr7uHnVk14j9scZc/+HDu4w23VCR/gbr41zVQQJkqiI/IQP6imaJm1eQVLG3zoN50HD2fUyL2Hjw0uHLp+UBA0xpyesruRe7ALtgHsOvxLIGez6x5xzSSYwu5clH11FY/Zd/IF8t/0lUGmXShNjdVmT0h1zkLhBmjIM+JtAfkTX8XXYmwvfUMq2iYjAeoVEPNxaJHcpTX51kpfaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ewc07h/MRKlFueVRwXeH/einljp9eG4NulVGPJOlVpg=;
 b=Lq3t20leNe8wHw9b1pq9K2D6hdHkHmC7EwftdinfqPxZBHZUE73eEDetD/z2ubjHlKB1VlN1TRNCjAt1PtHW9BHpaH1lAF/dUIMgso4W4BF91XW0KrTarUoblv/V4DWD+ff54Tf0vQc68Q6/n45qamRno3sdt6uLC545ykTpaku5/fNlw/9qFysHSGhI9556M+LBglLCMeMlsamHrHfu6hBC8bcMtonJrp42YFpDDhVLA9dSbGMLltUssuoJIltA2oL8ui9aAPOGdd/LXdz1uLOJ4MhM9aMCGQuUsqVvcUbxQ9yltA2+LXfFo8L6vo7ZbZtUODwFzeoyRfYTFOyjRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewc07h/MRKlFueVRwXeH/einljp9eG4NulVGPJOlVpg=;
 b=HZsxehiCT7smnXpfTE0gre8GGPsh9l02eLDy6NAeMOH+x+G95x1B6zway5fWMpInpowy15EATneeCMb3NhAVbZjLbCM9cWstk5ZAjHkxiO8Imc0d2cVntylKkrVPE0ttwi1n5QzllASCiimb4kINUNatd//9XwkbNIYws1jGcUc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8299.eurprd04.prod.outlook.com (2603:10a6:10:241::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Tue, 8 Feb
 2022 16:10:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 16:10:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for
 stats
Thread-Topic: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for
 stats
Thread-Index: AQHYHKbq8GXukjoutEaxquFuvaFzqayJwKKAgAAI4ICAAAkwAIAAAMqA
Date:   Tue, 8 Feb 2022 16:10:32 +0000
Message-ID: <20220208161031.3jknptcqcc7sltwk@skbuf>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
 <20220208044644.359951-4-colin.foster@in-advantage.com>
 <20220208150303.afoabx742j4ijry7@skbuf>
 <20220208153449.wyv7xrv4kotji7mb@skbuf> <20220208160742.GB4785@euler>
In-Reply-To: <20220208160742.GB4785@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4dd920ea-4f45-486c-ad09-08d9eb1d8865
x-ms-traffictypediagnostic: DB9PR04MB8299:EE_
x-microsoft-antispam-prvs: <DB9PR04MB829992F90987B5603E758D55E02D9@DB9PR04MB8299.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZIVuJ+JIvHggIskY9HH6TmbE9vhv7opg4zLwgeOim6xWHCWkdoBj1x5V4UfAhPUn5WyaK4mN/JBbY98FpBsEiFmWY5o3F7CI+jBfJbZktGJuaYeFinsZLHKydtN42KD1Zzp7E2m6Pxu3jFD1gEnymsxWTkgKRA6NtZQuwdzhh5FwAojHiSDIBTC0Q62tI+4HNOYOVe5M3kuXdRUFO0G3/4zJS4ZW82C5qSmVAoC9zGfLay3L1cM5XzCKvUR3XaD4ZMhSNoQyuqhWxZ1Q777ycrM8SjaUH8RkhVgo2ggn5wEAVTpmLYrZRrjTZ8UlncUXdDwMScmeCnp3Yl+Uly8O7zJ4fT9592ZhBMtJ9S+Yll1c5X1YDBMY/Wt9akdP8yzGGIASrcIGM9LeEPr7YntWOyyTf8nP8kWpKwsoyfWnhj1zstnmGkNiwnoEWBI0ui6eHkWm5D78GDEG9xtucR5ICoaS22y2noMv85b7Qc2RnGLhNw691A0w48LlskQTYWQZasEN+yrPmE+cbpuBoMnO5D1c1kLS6ZrOnIUegBCEZ89+N9zGXSFErNgbUvQBrYF3qNhZJnCj8QGHfomj93TKoHqvNPo7+R2+0TUU6Gsveljt9rcGFwQ883DmXGvneaFTFmyJojP/x7DbmwYzW73/Jw0jh/uZmyUp/M3nwKz1Ym2hJOoLJdSAB8GlUJ9+yn4Z/+MTX0uhWybAdTzreYysaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(33716001)(71200400001)(1076003)(9686003)(6506007)(6512007)(6916009)(316002)(54906003)(5660300002)(38100700002)(122000001)(2906002)(4744005)(26005)(186003)(8676002)(66946007)(4326008)(8936002)(86362001)(66476007)(76116006)(508600001)(44832011)(38070700005)(6486002)(66556008)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MXYVvqb9ir0WacztkOgjtaXvUkapr7EQFxs5egBqMicpXVo7jy4G3AvRyxpp?=
 =?us-ascii?Q?G2KEPiUA2YD7tCi6xMpIg3lteJVtc+FPu8+Z4YCxtINbhwB7OEURTxaLvBg+?=
 =?us-ascii?Q?KWQouHNJm+sdRAsRlt0lz6EDjhm5cOc4x9E2So4DN2To5zyHfu5rMxW3ZrEa?=
 =?us-ascii?Q?Bkq6Tmvy6zCcukdZaONqCHud/VXbsuWnH4ZBZiOP3EEAQVO2cmfkQA6T/30l?=
 =?us-ascii?Q?ZXd0xcnshjLhA+oLjuA4uFT+krixz1uQn5/blGwbRKqxAuRxNQrYSSCxsddO?=
 =?us-ascii?Q?e7S8mgybUKYpXGpoOOMzB++JapQ/eU4/TFsXF5UOSev2D3yicJhIfFk7JYBz?=
 =?us-ascii?Q?wkyst7mbXSzEALEHs7dTeEMaJZEnEbkfjIJ7gYLzHo9OE82LJOsh9d83EPUr?=
 =?us-ascii?Q?v6VUcymbxCXz0chBHowMc1zFpqqitQlPCpkJ3bk0EsysKqR8zpMDxSkHpqr+?=
 =?us-ascii?Q?t+HSXtQr1tFUwUtXlYFRdyKdMVlO38ZX8xFBVgfJvbTYG7WEe4lKzr00cCi2?=
 =?us-ascii?Q?Zk5JOasNJmNqZex4c04lZ2rmNtksWD/OsHXbc2RrkFQmXWZ8Aj0xFiGUcS4C?=
 =?us-ascii?Q?RfENbkCmISWFa/LiTN0I1iKU7WSsnXlPm1NpsH+NSbTkHDUu96sqQ8BKa6/p?=
 =?us-ascii?Q?Xtujqv9xJzjJ4oH6DeOOoQmsGYuvGtBqohI3/arzHDXpN7665ldgW2915J49?=
 =?us-ascii?Q?z+8BX1LO7D93CWGVcx2ggZcj5YSl7hFWbAT+HIUmoB5KD4wMCYpwMYP9dEuH?=
 =?us-ascii?Q?v4eUEZDgjdz1N2FIhNncpAZ4Xy8f2h0pazzq3l0kBAAWqlPeHtxaMYtx4St3?=
 =?us-ascii?Q?LsR17Cfza+aE8RJgxgqpAjPAAojwPyLchtbn4bsRyREaMh4s17s5y9sFWUjX?=
 =?us-ascii?Q?SEBzkWwG+2OLJwZNVZ4/TQ+BVD8HiPYKMjXuWltRnVrszIoRcaBsrO7G8xW+?=
 =?us-ascii?Q?q3BuFddDpQNNAz74Ohf2mA8FDk8UK40G/36FrLMuHEDBTb7YfBObYyllz/wD?=
 =?us-ascii?Q?+6xOmP4116RFXHDUsW2IB6nhgTLWcRp0wUOpjo+SLOOYUjMOhG5GOuPWylE3?=
 =?us-ascii?Q?RDHxqv0UEjVD1dKTjZ9zjF5/uB+csCPfvZynpHmKoug4s2oR3a4XAafNO1wi?=
 =?us-ascii?Q?k8zBGT5jd4LofEtXwteMgxBRlsnZyYFqE9wddblE6YmXQQbODGAdYLzbB7dQ?=
 =?us-ascii?Q?etWbTtFcZ/lfIscU31P7hr3MBCwZa5QA4JvPE+KXQhqjPP9HdHRLClWIJ0DV?=
 =?us-ascii?Q?9M/FFdLaMczmdFZbbAK5gHoczakSqiVMAR+9cIIz/l2MDv/IJB/AxAdbTNsU?=
 =?us-ascii?Q?FPWn6G6X17D34vudvJNfNKKV2XfYi+H8d5vLzmIEn5mMEkR22nmHWwkSha94?=
 =?us-ascii?Q?4FlHrNOZuJ6b3Ey+fS6iv6jVhGlivPq0fcL3RleInFWLtdmckRpj5C9wSk+P?=
 =?us-ascii?Q?FUlgw/sG79tqg0C1tv9Hf+MHC7zYmeHgSI0gOShvvE9n813RJ+IQduaGfZ/D?=
 =?us-ascii?Q?NxgbAGeIzDM19q3nb+o+iei7/BfUYtMwxVnvkY8TgeKCX2E+oLzyykH9aOFA?=
 =?us-ascii?Q?eTIkm/CkIUn7zV4plFo9xrXToQ4XzUT70clJ9D1AD5Y0ueYx+vrEG/BHmLNp?=
 =?us-ascii?Q?2sTlxESMGLLMvWJTqwkO74E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <326122240F23884FB62592CA74DEBCDA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd920ea-4f45-486c-ad09-08d9eb1d8865
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 16:10:32.3017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 67NUfXKqX0+MtKqZ7rBmxaIsyQgSUz4NWO7zRMFZvW0BFvZVgBrSXwTSXZm9ibXGErz+iyOlcyUw8iozw/xelQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8299
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 08:07:42AM -0800, Colin Foster wrote:
> # ethtool -S swp1 | head -n 5
> NIC statistics:
>      tx_packets: 942
>      tx_bytes: 48984
>      rx_packets: 764
>      rx_bytes: 37808
> # ethtool -S swp2 | head -n 5
> NIC statistics:
>      tx_packets: 946
>      tx_bytes: 49192
>      rx_packets: 1
>      rx_bytes: 46
> # ethtool -S swp3 | head -n 5
> NIC statistics:
>      tx_packets: 1
>      tx_bytes: 52
>      rx_packets: 1699
>      rx_bytes: 80658
> # ethtool -S swp4 | head -n 5
> NIC statistics:
>      tx_packets: 0
>      tx_bytes: 0
>      rx_packets: 0
>      rx_bytes: 0

I understand what confused you now. These are software counters patched
in by dsa_slave_get_ethtool_stats(). They are in no way the counters
from felix_info :: stats_layout, please compare the strings!=
