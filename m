Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E6B6B7AC3
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjCMOqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjCMOp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:45:56 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2049.outbound.protection.outlook.com [40.107.7.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAF62885D;
        Mon, 13 Mar 2023 07:45:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRK03Oglksn3X2LsaznDStG5vhWuxwyQ6re3OfSDGUnRfZmxgttdoeF32kHybBIooNbA2szc+T4+7VVKigeH/IOTmzRkkKkrYUMPE7NAwUVAG2VeRC8hpsJ5Bk0Jc89LM6Gt8I6/aTBOpCFUL1A3K8bX0W23ChNbzOH7vq5V2m9++ChqQ8PEcQtHCmhktT2Vxcjp4+ksyjXZ7Fed8jt0mxN8TilSLh/70qEXGHJq0AtvmxzHkFYoeyBZOoBBVgXHNWbgWNpkzAmed86LLSRTnRE8nV68xjhzZFXUj6k2sff2JlHQhq3t9D3d6JALNN/XzGfUc9zwbFyDdGGu480g6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ozjg4yXyLE07OEBwpz6SBdmGxJOPaC/5fpB6IuKlwk0=;
 b=OmBu3bwRX4ySqGcaU8QtC30kMN+4ekUsE4kmw+CVbwMfvO2AY12Ti3UesKNT2A04x2a6rV+Ln5fRVmAM3mFTlWrb0GKdvbYrHvEgK1Jy0sX8NiA4e1RRmwLDEQ43S8Y+0yV8X7xzl0R4pFg7W9b7XrQivldJVbM7x5lr8rLKSriTAPYhs735S4/qniPYSavckvU3ROs3lkvuVBLu6rZuJ/w+Lfn9lmwMvobWIxzWFPvt92jUC5TcKK+7pI10aBNBlpM21j1zQmFcTA6ATrxCNLlJj0BsDKtnzyiylpFQ3tKnGUYmNvGyxNHcU3993g6ht9JJ/ZbZRslZEDgopsUUFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozjg4yXyLE07OEBwpz6SBdmGxJOPaC/5fpB6IuKlwk0=;
 b=QV+zbztkvPbljQjkc5DrNtezpJuLe1m98j3Boxb233T0VUP8SAnZHKnMqB51rwWkdTHDwu1VR0KnMA5z8CgjuLvEdEixnKLn6aGFFjTdlLj/YEUOh+Z8+KefPi9TG14ZVO/Qf4j29umtytw4irQ9rN8k1wVcO3Bu6taaK+ycBn4=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:45:42 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 14:45:42 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        Netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v9 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Topic: [PATCH v9 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Index: AQHZVbp8EpKNG6z3K0e4xkOkfV1R1w==
Date:   Mon, 13 Mar 2023 14:45:42 +0000
Message-ID: <AM9PR04MB8603ABA9129A080BA5CDECF2E7B99@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230313140924.3104691-1-neeraj.sanjaykale@nxp.com>
 <20230313140924.3104691-4-neeraj.sanjaykale@nxp.com>
 <b28d1e39-f036-c260-4452-ac1332efca0@linux.intel.com>
 <AM9PR04MB8603EB5DA53821B12E049649E7B99@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <17a9ffd1-342c-2cf1-2a57-7fabe1fce8b8@linux.intel.com>
In-Reply-To: <17a9ffd1-342c-2cf1-2a57-7fabe1fce8b8@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|AM7PR04MB6885:EE_
x-ms-office365-filtering-correlation-id: bfbaa42a-ef2c-4616-6f70-08db23d19eef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kyyYKP8amm1F59bI8j7g26+RbHqgAVXHoujwJseXP7yhkr/Py0W72ca/pw1Pzy5/Uco07fIlti8scQw195kxq8jve+umpgVIL6ucUvQea3w9zh2zNAiOub1s9QHwQV55FHf5vo9GK2xkrsz04i2j8rtJYX60bAUduPW7DO1w2ffinaHVdO6HgBqBUW4N4RdUYeJ0tqmo/YZKFILW+GRs+45v43up75KQasahcI/prF1hF5m4pIMLKeGdL54S1x0vE1CpbBMmmWu/D0kWykrkiRwn9cYN2MHdnAIVn4VgcqsuNOu0NjWbKhicWx6k+tsVli7BuZJ/vUUNa2FOLg6ezfY2EjufpuLnAwZfYbhljNhvadpmRMuYey3Gjl8TE6Ep3uIenAsb+Q0f5o0OM8YWANgxIO1uYPoWajB9CHz31Xu7yRVFnigkH9+awu3NqQjDWMWl5Hnx5nKfV9r3W/MPl0eREE9+nOAbrGC7it1pI9N+3ahq4WzZ/CITVAXurlnXU/GXPt6Dq9qoO1sPdXilCh8YzlaULQ+ruHzEwpDNauc4DZq7nQH34a3zfHQm2qRQqQHNuVEMWF9YeVw9bfh5AooWGfcDnwUsuERXuTuEdMsJRhuoBmAWg2N+4/zBI1LwlQ0W8DUfDM+w/rQ0S19uXQWo+2ecC+rzLP+fLvVEVrpiCkGXe1JixOfrpff+Qjxm8/gqN47R2R+TpJ/vktushA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199018)(86362001)(33656002)(558084003)(186003)(41300700001)(26005)(6506007)(55236004)(9686003)(7416002)(5660300002)(4326008)(52536014)(6916009)(8936002)(55016003)(7696005)(316002)(478600001)(54906003)(66446008)(71200400001)(76116006)(8676002)(66556008)(66946007)(64756008)(66476007)(38100700002)(122000001)(38070700005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?aV/vc1uCKwEHpky3rH+zi1JMS2rBurYl/cbF6amqG7JEow/oDHUBTnYstX?=
 =?iso-8859-1?Q?rv3yJkWmpGo3eHawxaKsQEXmisWUHa7RfBOQO8HmYs8e0PLQeCr+4sDeVb?=
 =?iso-8859-1?Q?/kyTJ25rI7ygNYpAVrJp7Vy4YsykmBdfmjJx/xNp8+vWlUjc6WCULX7Ouw?=
 =?iso-8859-1?Q?NKiqRrXJKTBEbWczkXFQXaqO7TzTWw8kOoyylPIgmD0N0pwr/bxrJhcGtk?=
 =?iso-8859-1?Q?tjkF778+xHsZeOQq/ZXs09KLkfjw3BxkHL4XeWDDXvpp7XInki0jjcrB9d?=
 =?iso-8859-1?Q?Rkut1ln/YDvjQLdM3lZQsziudICmektmq1ngjFhUWARPbcrXLspmu2TtSU?=
 =?iso-8859-1?Q?0ELq5Y30U9jpico/PaIlVCFhgAm5RITfBJ5GzryhbEyw7Im1UkVyvDUzGe?=
 =?iso-8859-1?Q?8HdSxveP+8uTDrroBtnYLLwg74jMZEcxY3VlDXj7ko2mI6w7BPTlFDToFu?=
 =?iso-8859-1?Q?VPCKSePrfswNhd+N8jcjSk/AW71EJ55yXr5Lz/7V0B59D3klSyPGrAWebj?=
 =?iso-8859-1?Q?HuXEAAP6yyfYscQNFPpB/TXlupgX4dnGu5noTbSG6/dEe6ifRBx9QEITgB?=
 =?iso-8859-1?Q?FZIusAq1AMcrsOwy9D3hjSHYp5uAzVgXpcd7AfBJg0LP4uQu0qa0o+Xrxr?=
 =?iso-8859-1?Q?UabgAYVfhjILsAl/P7EZXUKc0WDOH/D7ppTacvdNR6J9ZXUnCXk2QZX2T4?=
 =?iso-8859-1?Q?mF+CvRqWyYguA82gAu3zKZhQLi+Zau1Wq74p+yCiR2/eTsX8eHRE+59RPE?=
 =?iso-8859-1?Q?q6ldRy4HpWWw9iByg5/tcqKgO8N3wggkXSawi5vCL485hlCJ+YMbiJXf7r?=
 =?iso-8859-1?Q?SdaBxBwmEJJ8P7Ez7FKk1iIRRH39THiq0O2SjSFXScu+74RTHqZRDOx2EJ?=
 =?iso-8859-1?Q?S16sBREfWEoiZNlRkub9QIbFOemI3AMbVtXcqaztiIgV3x4uohlywZmmM2?=
 =?iso-8859-1?Q?zm29w6vT+yDfiQkx7+h5PBZ1FIvNNRQefnlF+QJoKcVpv/9NuGIq/TpCnz?=
 =?iso-8859-1?Q?vsiWO+fjqMmNjTWGFSOL2OBT+ctsdeFDETTK7ssylrHKCfi+cKMkk0p7tu?=
 =?iso-8859-1?Q?8c4UPCYp4oUhsVYZuQw5HctVOJdj69Hy2ltH4/nvs0CjDo7byUdr/Qx8n/?=
 =?iso-8859-1?Q?hen9yTmQsgN2WM5pMB/4CKXXbDLqrvkvn3oQAZuKmj8GieEF4YHd9944eB?=
 =?iso-8859-1?Q?ItUM4Q+3csYIjbum54OkEbMBO9NS6FBHMLLfIIt7MVMM1l6AIAzmy+MTkl?=
 =?iso-8859-1?Q?+I55cnJ80Kd83/fT2td4DtE4KxcLHMmgUF6tjBBDznBBga0yR14nlNWl0J?=
 =?iso-8859-1?Q?SUcR1fv5hHXXBhZ89Y4UoYaI/xCy+yNpAC2ZBdHs6wzH7II0zBagwLPFi5?=
 =?iso-8859-1?Q?hvnH/KE0a34+vvKPzbxQKndnz0j39Vq9mppNd2fSG/2vggfKcVdQBQ81oa?=
 =?iso-8859-1?Q?wPpWOoyWDBCIqGgspin3XFPZT7KLDsCATINu16ixwULjEhyJil6agUO2IO?=
 =?iso-8859-1?Q?kJ1kXYwKlm3rgj/0jBDEeCpqCFyTEtXFJQHsKFwXcFXppjp3evE9/6d8rg?=
 =?iso-8859-1?Q?tVh6AhbeuKfd5+HGRHX+o3kUrdF5QkSDnjalnVhORiV7IjzM8zf8j4Z3ow?=
 =?iso-8859-1?Q?Hl2UzgzDnF+jpif3blwTrL6Jn2BAqv5PSHkGmq+hfb3Zca1FnqlZuYog?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfbaa42a-ef2c-4616-6f70-08db23d19eef
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 14:45:42.4061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IvE5vbemWsqZKNLF1A3Q/bAiNJ+IdV3yj6PxzZW49bpLv7LVQGDbHqC6iw1p9lIldK1/JDx1euPXoMj/bjXpjRBpKsEAKaiW5ZHqm+sC+Nc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6885
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >
> > Please suggest me the right way to put the version string in this drive=
r.
>=20
> I think Leon meant you should just drop the version altogether (since thi=
s is
> new code).
I mis-interpreted it as we should not be using MODULE_VERSION() from now on=
.
V10 looks good now!

-Neeraj
