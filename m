Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080E5614F18
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 17:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiKAQVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 12:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAQVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 12:21:40 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2060c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::60c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A103D1C431
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 09:21:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJm7OZd1p2vWR27dzq8TEB5rsKKmXdwTH1ZjvFunJ/jV4c1AuPwmOSEXwjThszh/rvaW3wTFxhycdxAsvX6ah2Pv7LHqLMhUtSWJ8swnAtY6jW8mLHDhnaLaoTRw8GoI3DScITEhbIjmzpMHD3qiaI4GsSRLM7Yd29rxnp1RFQT/ioEkNveAabu5A6mHKxw4AhNPYAreOo5VZ3/UQKMbid+6x2EZR0kIuAOLZYHQRaJBaui0Ei47dsb/eN7fsfTV0GiSjnm+DIoPlkcU3gm/j5nGoTWRYVcLAHnTXEnahzxdLiC30yc+rZbeTsF9e4USk8STRg7UtoQ77nQb0l2LgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JEmbdbStzrlSHqIrXJbGyL6Xn7V0A+cyU2kYslFZL04=;
 b=la1OREUGrLoBVFvTOsm2GO6gvOR9ajBnGCFQPm5HUHiufOMPPgI+NQxE8BteesSghcMQRHsykzkxzductgUdQtQZ76TVcssBIuNB65bxxUt9ato4QoWRf1xiSZguT8IbfwNiNxh6TZntm4s5/rL9iE9RpGwIw0HrB6Ulb+RRE/vPKRVUfHQCfN+nCfntYA2QmfsQrpBsC0h26FZX1VLJ2efdaNeKfN0RZUaWaH45FAmTGfrQGIk8Ocwn/XtIYFMGB11YpXvLEry7SqsLgrSfq6UDHmffEHfH0WI2x32vRp18Jbdkdw7hZHG13bHkfqRkPt8lhbvghlVVZYT1r7c1nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEmbdbStzrlSHqIrXJbGyL6Xn7V0A+cyU2kYslFZL04=;
 b=aqoTCxl0v/R8UzBumUNoooHzQYzzP7JWrxy+vEF9490iC7k/eUm+D26gz7YfHLpQTXSRGTYw6ncsNmL32sCm33WBQNMfceUlc6geSbp6FYLPCylv7zgoo1AlN8xWwGo87DYu+F6HkpJT4dHI0YBuXeayKbet0ihoTlazuTQK+rY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8270.eurprd04.prod.outlook.com (2603:10a6:102:1c7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Tue, 1 Nov
 2022 16:21:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.018; Tue, 1 Nov 2022
 16:21:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next v2 2/2] rocker: Explicitly mark learned FDB
 entries as offloaded
Thread-Topic: [PATCH net-next v2 2/2] rocker: Explicitly mark learned FDB
 entries as offloaded
Thread-Index: AQHY7e8Uq67dvCt7OESrOLYUQfK0Lw==
Date:   Tue, 1 Nov 2022 16:21:34 +0000
Message-ID: <20221101162134.c3kxls7tvz2csctm@skbuf>
References: <20221101123936.1900453-1-idosch@nvidia.com>
 <20221101123936.1900453-1-idosch@nvidia.com>
 <20221101123936.1900453-3-idosch@nvidia.com>
 <20221101123936.1900453-3-idosch@nvidia.com>
In-Reply-To: <20221101123936.1900453-3-idosch@nvidia.com>
 <20221101123936.1900453-3-idosch@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB8270:EE_
x-ms-office365-filtering-correlation-id: 84a8d1b5-1f14-4909-fcba-08dabc25250d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qSfc2+hUw2r9G0uQB09M6AqC3AFqXjZQNfLurICkQTk8c1JlZRAJaKM9IBd3l97E7uuWb8UlXMyNTJMa765M8q4vYw942WfZQjYY1ulsBa2nFN2bb1KN8pzjxWnD3i4KNRfN1pKJ6oSw/gLd2wFYoQ2BTSQU8kxADYHdFCWgAc+VNr1orDly86e5bY2wHCNb63vTuNkAcYmh4vObJI9dA64V3of5tUCvokHkVUGOQrAtsKeALX7NXHZSV33q6NykM0SXjAGEvLpLwvzmdr3dtMCZHFJvQOtUaT2H1r5YpSNbH5+G2HXJg8a72Cek4dffvbvDVrzQh8bEVv785/isQyd03eD3AtamtvLIKhqgUmuEuaIJOzweO8NqV68lRwcDQ5kamaSarblGs9sVAMc8YHCtjDQiFvwyqijV0UDgwLy1bccxWGiRkvAhatFqbuREbS8tKwRxGCpg3m2baTLT0hcf9oHQb4B5E2dA1NfQGPmL6yNSyPGCihVHnrxCCDbld8GGY+1sDB28FtcZojJgUuSbnKIpXjXp0BLMfHzt7Prj6g3HD/LBaPKngCmhGJYe/l4dTKEs2ekBnUlYigxpNsj+ct/fHJjN45plAmDf70D8LxHpxBjVWZovYKck+udA5+aa/SW7u3YTOis4OPI4s15tUXJi1eyeeIRtoaAC4g/rtbsVkOEb6rUbUGuVZEY1C/OiZBthwDm5rSKsI9hwoE9Z9zmzJD8dVIWyoedMeOBhEOZeYC3ysAdt56nMVzL8vmTHPq1DdApVoDN84gzp3UAuvwHROlsJWlLkJ/tZN6I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199015)(83380400001)(966005)(33716001)(38070700005)(86362001)(122000001)(38100700002)(76116006)(91956017)(6916009)(54906003)(316002)(44832011)(4744005)(5660300002)(186003)(2906002)(1076003)(6512007)(66446008)(6486002)(41300700001)(9686003)(8676002)(4326008)(66946007)(26005)(6506007)(66476007)(64756008)(71200400001)(8936002)(478600001)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6AJjH6EWf9fd1CrUQ1bjQdac4IbSeR5/AyPd1U1OiIdnksjU+gyHQnbi5QaV?=
 =?us-ascii?Q?oknCLTEkoal5VEPnlSwdooqgcGZb35tMahEnh7OaDUE4RvaCwVVPYjOen0ee?=
 =?us-ascii?Q?HIoJS4aiZ4bb6yBP5EZD+Io0LRLNVirYz6tbcuSkgyKbVxtAV8xfweGTjhB4?=
 =?us-ascii?Q?T1KoNkw0PzuBEhAPNt7h38H56XjC65/UyCT0W3zsTfA5LikL3xCanycSRD3j?=
 =?us-ascii?Q?5SrcucTKf7DfvDvB/Ih0iNnktk5aVBVGxfSSFKMONq7YQnynDNCYr2JN1sug?=
 =?us-ascii?Q?KfFGAcfYDe5h/NMt5TF35NitRsMYHg95d2YNrqKisuREJUEIStt1zzMEm/eQ?=
 =?us-ascii?Q?k+ek2fGXq7iNQj0QAjbId64qn0DVrgaA21lupWPb2hAJtjhbBV4xNxOvYNI/?=
 =?us-ascii?Q?eJNK+bc196D4jHWxiwZMCsKyXdU9VfYQnLJZ/2GuBUzlMmlJae1vl/dpiTT3?=
 =?us-ascii?Q?NZp/p60yLGR76npGvbcrg38TMaQUlR2XkmhE7z8v9NAqgN6/h/XhdolC70pZ?=
 =?us-ascii?Q?LoZOMd4BTwUeFPiT+focEMYoo+1TWois+wW+5C7VqkC6sr4xV67ArlzWMJAv?=
 =?us-ascii?Q?Af3sAeHC43+raanRdP7cshNBlgfpuunhkygLq5iSn5A9EpTTiKRWG4Tkb7cG?=
 =?us-ascii?Q?FaKsrvcJWsoORJZP+zyNlWd5cfMnzjEOYTn1Ocg/y8AJtGJp+U2ZQiABt9Rm?=
 =?us-ascii?Q?sdSzK97pJK7aVJ+MdQSxni1jkVoGbHXJTBYXs7XRumEp/Ruz9gy0sJjGqgDM?=
 =?us-ascii?Q?sSYLQbwQcBkvziLoX4tPCBgjpBkt3MqR7nSpn/FaUQUulNrIDH5Nztwyfq2N?=
 =?us-ascii?Q?E1nVuQ4R/PMSd+gZlJrSO6a2GtcrwET0zBPM8a1Kq5fCBQcQ2xc+KCRXdLVa?=
 =?us-ascii?Q?LI5XVnKffOmUiLEWgISNrAJISaH3fE5Kritue6E7Tn+ccZfChJyQT92GE34W?=
 =?us-ascii?Q?Eubaj5Qgpe/6Dvqx9HqVbhA8Zd1WR27rS46X3+0FvRL5r7cyK2NVQAA8ol0i?=
 =?us-ascii?Q?4RfM2WoCtdCT7XDqmEulDKxATSpZQVUl1T5H/+3vKxBxw0uN/JcFP6Vh1Ci4?=
 =?us-ascii?Q?ZzizyETbRSkfZc58iNdXOC1rMIv9lwtaQu9ioQJheKZL2FdwoDvVXZXNRfS7?=
 =?us-ascii?Q?1lHeGz1Lbgy0cGNdNFGj9R33n+3w0ufKjPBb14+d4sYkeZU9czFiAJoKOlpj?=
 =?us-ascii?Q?xHAqZxZazVgnUDBMkDnZRbCfofxAKj2Nf91qqLF8JUTEgsqnJe1zkHRwwMCx?=
 =?us-ascii?Q?b9/viXISIODbgvkZM6gPMyE8oV87jBb2pQG4K0+SVHFLh78/kLTp1A92h4S5?=
 =?us-ascii?Q?fvJXbstGsMwytVF3+nZdHL3Wc/577Bu4B/+9EYSfP/HdFXlUUBdCHZz8HtCY?=
 =?us-ascii?Q?1O8XLi9t4TQ4cIHsf4YxieX8jo7lM1WLcia6oWJZN98BQ9zZyRnnqZmOx5R1?=
 =?us-ascii?Q?75Ah7k0og297wl8N5TmP81xkDNd2v9MAmZa+xu1kfGZdYAFJNI8EEoVK/v8v?=
 =?us-ascii?Q?WGZdPAah9C+8/l9wAoIm53iy02Nd+G3GbJPeBud2oaXQGHmmDJ2uML4YxZln?=
 =?us-ascii?Q?gNw3H0StqeuLKNb827fl5vOb8kCQtQmIqm4fbP6rt6pH/3EcJE6e3flGJ8C/?=
 =?us-ascii?Q?1g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0644EEC9A1983640960A580D7EC41B45@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a8d1b5-1f14-4909-fcba-08dabc25250d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 16:21:34.7675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gu500KjEdYxOdgTi9Fa4IBndbqUyxUW2YanEFz9Lii52k+s+EDGAkqLOF5/SjCeVZBU9X1wUIClyT/6K5mFF+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8270
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 02:39:36PM +0200, Ido Schimmel wrote:
> Currently, FDB entries that are notified to the bridge driver via
> 'SWITCHDEV_FDB_ADD_TO_BRIDGE' are always marked as offloaded by the
> bridge. With MAB enabled, this will no longer be universally true.
> Device drivers will report locked FDB entries to the bridge to let it
> know that the corresponding hosts required authorization, but it does
> not mean that these entries are necessarily programmed in the underlying
> hardware.
>=20
> We would like to solve it by having the bridge driver determine the
> offload indication based of the 'offloaded' bit in the FDB notification
> [1].
>=20
> Prepare for that change by having rocker explicitly mark learned FDB
> entries as offloaded. This is consistent with all the other switchdev
> drivers.
>=20
> [1] https://lore.kernel.org/netdev/20221025100024.1287157-4-idosch@nvidia=
.com/
>=20
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
