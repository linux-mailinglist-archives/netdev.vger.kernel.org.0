Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24303598645
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245564AbiHROpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343762AbiHROpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:45:25 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2085.outbound.protection.outlook.com [40.107.22.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2527339B93;
        Thu, 18 Aug 2022 07:45:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oS9t9qyIUpOiZd3GMPOxv/Mf560oD7uVFWeo3GcK6MpVh6i7EgOje1E7Gfbp+3MRgbBaLktmWEqGgx8f5PVOQaGcICvyK5YP0nzeBgesZWHFrQ/oWPYQg++t8AmBls7GzqSgU5yLHPLU2M4+RxvSfoAluEkMzBzkayGnbKjagiKLOmt6joTpIKwb91FdkbAo+tDPpnSO+JKqDwh+5A5rUqc4Q3t8jLq4tc8quns63TwgcMkjl8TkIlgiuwahziIkMd5e9cDECBNtCehPZ5zmOPeO3ikfnwobwBqlxxQhBWobaogfXFMiXSmXnaxOft8FJE0cqTq9fkoU3DnlVrxzZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0bvFNxHgbo+6AI5RXArJV/N4e4WEdGq0jFTTDX6xwSI=;
 b=QsHXX+dEYjUXQhseIzi/ymyclWGqQsfXBsRZkFAU92YxNkxStEIEUpZ5C1o02R7AxVTWUISTD/n/5/LUgqXuFJw+snfu1W/1ekCNjL2wmaK47Syya8a1961nVmaapSWbRmoQe5UVWODiCQO1v/Q9noH4ZFLoKKzaiB446n5TMgE5G0/Mi5Qwpp3wpXjBuwDZhwO1PQU3lbUFuNEtUisWwoIrEJNGlHOOoDnWqGiNHxHNVKzQRsivQOlNSF8qPeqqQgf2s2WfZy4CjTa6M/7XBRMEYCN5yU3zSTV0PagRUB3nn+6opTLJ8LNis42dARmaA/QjGZibZwAYutxNQMZsYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bvFNxHgbo+6AI5RXArJV/N4e4WEdGq0jFTTDX6xwSI=;
 b=FQytjBbZfSfb+lu4ewNKXbSIAzlirBS9JWPQxsN52LIdOq5moHoiWvaLOxaxO9J285OAyvrkS1AktXfBVxp/jAxuXNlC/C06ExV2GeSDDvnJAnQrgp7+943sR8OMd8QcueOEu4CgpuVRRSQyceL3PGCiCUc/yzg9WwHdrmWEzUI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5242.eurprd04.prod.outlook.com (2603:10a6:10:18::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 14:45:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 14:45:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH devicetree 2/3] arm64: dts: ls1028a: mark enetc port 3 as
 a DSA master too
Thread-Topic: [PATCH devicetree 2/3] arm64: dts: ls1028a: mark enetc port 3 as
 a DSA master too
Thread-Index: AQHYswuYcty39xB2oki6+ppjVdlEF620u/EAgAAAQIA=
Date:   Thu, 18 Aug 2022 14:45:22 +0000
Message-ID: <20220818144521.sctrmqcfzi6e6l3e@skbuf>
References: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
 <20220818140519.2767771-3-vladimir.oltean@nxp.com>
 <f646670f8ebc64cf1a3080330d54d733@walle.cc>
In-Reply-To: <f646670f8ebc64cf1a3080330d54d733@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4172ea4d-df43-473c-6b5a-08da81284789
x-ms-traffictypediagnostic: DB7PR04MB5242:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wV9+/pblpciTnmRv/SrlaJ/uwFQgBx33LG0HtH4qTqYLdsRmjZoinLtm9je0B1a0NPYPbWpAvPP7gsc+PqJffxBRPCrlRz9xuel/NXZEIO/vz63qHf6d1sWDOPXPQyGD5kGTrNw7/zeBslGwCEbpD1II1Go7gWU4QyLFPIEwL25spIJVxowFpDXd22NRLbHU5Dlxlg+h+Uc+9unDTcPyyv3kDqVJsnqdE2DrIFgUP70ILfSmG8pKJ2zbsDa+tpKSY+QB84h9qaPkFeyyoZ2cpP8KVbTZfJv1uJaJCtApFDsGgwQM6IKTwUnRLvsjnaxE+tjHnGSbPlWUzf+8adlYe2N2uYtqGAMwjnOt55DE2tSGwXlRAetqfUzajUWFogWDKfH2juNkbUsVil6xIwQnvTQHfFKo2D2bcX1oQsZ3RFgISG9MNbts5pZLXP3zsxUEKaR78AZKrA4IS2uH8IoulFcrXZakz8cUGAnnqZ6yV0KdFO6dCN3gaYtnGzpb8brq9CkV6EkpJLv9/gomZc0W9qPABSf4PX2KsQchg4+iCzO7mI0ohyr/2/MwcrYgnFsdV3va09Jp8FIKwvX7zZIebEXbvo+Xch+HETpuBiOr3MwkpTI415rqhEsKcVp3OX93bjwLWesEOnpYOKMUee+f2MecxbvKFHIACtdy19Xb7tG2w4fXuoA1+jTy+hedP4d7FB8DBkRzyIye0HvCeZ/hsEEK0Ket9Y2e48JHZ8Ky+73zK0pEzeYfCAViV9WtjMCL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(8936002)(9686003)(54906003)(38070700005)(5660300002)(66446008)(316002)(6916009)(558084003)(41300700001)(66946007)(64756008)(8676002)(478600001)(86362001)(6486002)(4326008)(71200400001)(2906002)(6512007)(26005)(76116006)(1076003)(91956017)(66476007)(186003)(44832011)(66556008)(122000001)(6506007)(33716001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b9u4NSecPk1d5MZUU1cJh3c4vFxmtZligH2wbUnqvq4Xi8vj78hvGuDowaGY?=
 =?us-ascii?Q?/WjPlbm19wlAKFzBTmfiPGynCYdzRMl538OOuOjgDsDO+Xfot0H+C6x6jDUw?=
 =?us-ascii?Q?JK9ksn7aP7rB/9Xab70Jq56BnZ4f1qHczSbP65vVryhBi3xD3+GN3tn0qgdT?=
 =?us-ascii?Q?zTn3Xuc/K5nHDSNtPTu8FlsjxiQ3QWTmQm4YfvkISCPOAE0Mj2b8ui7pHG7g?=
 =?us-ascii?Q?Geqs7YiqVZmGdk1Xp1ZikNGnrhqcM+TZSIfisWXaXqg64sRybxKPgtVPvsB6?=
 =?us-ascii?Q?2HibxMXdn6NpZ2dy3hDuonFmVh6oQ9RPIg2fzMVH39ZcMowy5YZV1S0xGFd5?=
 =?us-ascii?Q?/850Z1cjshzGV3NuDbeY3oJFM2JEJpj3n9Ch3+2Ag+a7kf70bthHPPnnsCF2?=
 =?us-ascii?Q?AgrioLnJG3HlnoXu61Vg1nDjYMlUaULb+EpL/1FMe5fBJj50cLclh0Tqovmy?=
 =?us-ascii?Q?wrDX9QeacBHT+M8OPTPmFQ11o6YCJC8/QDevaMzu5BD2/+ufUo2LF+YQvKo0?=
 =?us-ascii?Q?KkzALjUIzHFQW+yDSoD1dSX4Oo/GlJ0GXX1NAUCROBMyIOOLrR/F9lY5K4qV?=
 =?us-ascii?Q?RDsE+10GbadpX79AAmjuY2EbjYmIp78RWDMSkIJc+bweOE6yBJh7x0AQRjZb?=
 =?us-ascii?Q?zzBXSw3J1Qd3PILIBjdhvu21q3K6SgSmCGkR15qcSwuEitvK1tL3K0eazma7?=
 =?us-ascii?Q?828nBJOVBmU4zmjjkn34bH5QrfI5WyMdORA0oQ983zph3otOvE8DfPzkszRA?=
 =?us-ascii?Q?BLjb7YfHJpo9vreunLzpGnDKNqxyJQ3ZaT5mqpiQjcf0AQkcxIDW52zOuGkj?=
 =?us-ascii?Q?FZw2o6Ko6xJ150EVm9Z43rX3yZRjjuM/XuvNhVQlJomPFbYPnJdR8cmW+WVe?=
 =?us-ascii?Q?revgKb5DEomHE3AL6He1lMj93ae9UUiIDV1yA7M6ToV7h6dJbopJ0+eF74+0?=
 =?us-ascii?Q?ihP4fzIt5UyMqnBRCxw87q9VkDZ8z4JdU8DfEEsy6u/sz74/X2bncpxz8QJS?=
 =?us-ascii?Q?0DIZXyVzadJ6BaqgubH8K6BffN5U2OJM9bGcs/UgC3pFOSTueeLv81PIHr/i?=
 =?us-ascii?Q?GOWUr39g01u7LCi9DHZs5QzIC0Z/fvkMxAUyEXuQ6cH3aJYlhPpPYxbOLqLg?=
 =?us-ascii?Q?5Pk/vozZAacjeO2+22j8iwAb2JWBXFrrAvFL8JmcTU5w0+m3a1cZgEqT4bUA?=
 =?us-ascii?Q?ef28aJq05BTAX5XsRyOxfmwpp6BFK9Henoib8fsO26m1+mbdPzyviFqdx8EM?=
 =?us-ascii?Q?Z8V1SEpgfO64+7IjoBaFLtorW9Db30/45ZyyR3G/pb3KT5WDQsoxFBRTwxid?=
 =?us-ascii?Q?QcQo8EPosqvtbUZBc6cMjShixAH/D4W/DeNc/Upzt4AWWJcVQE1VBnVPvSnI?=
 =?us-ascii?Q?wQv+BG/do8W46gnebYRIlOa4ofeLYN2pWvyr4DnvcVxCRbaZw/4CQqii3Hxm?=
 =?us-ascii?Q?D18M7jnKMGZtbdowAO3u3cjgj3TH9EBN+1x23FlqX48giFZTFu2jMXbsdSTv?=
 =?us-ascii?Q?up5SPBpdi57PGcBbCsslFZlmVXB69jsZ1f0xAhXoKI20w6lAuE+KR4r6y8VC?=
 =?us-ascii?Q?AmOaRsWK4KpvJmnUBhoxz5nKko6+LtYTfrEgpbhPOWeOcLti91gPBHbU7mWW?=
 =?us-ascii?Q?qQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <03C80202F1B86D4F9E0F91E4D172FF3D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4172ea4d-df43-473c-6b5a-08da81284789
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 14:45:22.4740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RK9odziDKg26cZa9R8TBLGkenEIWrwt29nuhlVNamHS+aL31TjExhIyJQ5nGq6AIK8SZuPgxA+RTt4j7NsSI8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5242
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 04:44:28PM +0200, Michael Walle wrote:
> status should be the last property, no?

idk, should it?=
