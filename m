Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4425BFFAB
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 16:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiIUOMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 10:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIUOML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 10:12:11 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2081.outbound.protection.outlook.com [40.107.22.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC502883F7;
        Wed, 21 Sep 2022 07:12:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8f0ialIgi0phane8p8WcojC0JjEGtJBwO/FevHxYAWYOjbPWZJivyO5g5qhwHmtZebkP9H2CFTPrXY2veYw8SEBQsX3dmlbgCfN/K9gWg6XJpsRNAtYEpdfThe9mz00KWxxo33Ip2DGWKskT9HXg5WVuLUlFDVL1QMeNGImogJ9pTzKhREz927j+IP4W/l5hrLYwAIVyAzRcZCg+LLE/Gxi+iFUGMl6ikH9K28PDbv6EwVlfuTuaIN6P1GFVkeOcamhYyGqhZM1MnNroKryXA6zPHDWF+ZkVhrTn6DLWWLMU5fgIR0y38e9Dwx8z3IaxqZZ/uxVZXK53bSr+1e1Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lUXhhsFWHrWUktHPdZ2SGmSPWxov+gv4k1cmZYRgtVE=;
 b=bbJYYoDdKbc4fIlcL6zKPcA0sjimj8Vg2/j8jARt/1VVVNPzym4BvoyI08hYuOgu1MFUjuxfM+xQCVLTt0I4fH0pTx0g1vstogfFP4OHksw3LUGmct8wriJXh6GhKIXIN4HrYZnAN2l5faoQqYMOUMYfVR7Kfzkn+Psxn0KRdsZ+eoWEWpuvEFOJIPonAh9FvowwSolshGVfZE51wasL4jL/ypKb5psPjarwIk6jx7V9wwxe/tnxUg2IJhmli5zUVxEOMmHb5VeISrl2GGerMADjd3HAPTTJRA5mdy5fJYAvdvzEa+xZZwz8MaPnM5ARzA9hCdbp9pCZKv7+eNLpnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lUXhhsFWHrWUktHPdZ2SGmSPWxov+gv4k1cmZYRgtVE=;
 b=OJ6xjQIiSi7nDrlNw6Cysu5oL1vPixZOumtiHsdYlA/eQaVfNYEN6dLSHzwJW0Ubbr/Wc2L5nbET1Fa9ExzMO8Of9ANZzYiaJGjmAYiZ5Nwd79aHoqoJsnQdx4dWWm7ToEyM4EG3jEhgAmC4e3xS7WmQFjnxpNsy9Vt/RNml7Dc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8976.eurprd04.prod.outlook.com (2603:10a6:102:20f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 14:12:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 14:12:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 08/13] net: dsa: hellcreek: deny tc-taprio
 changes to per-tc max SDU
Thread-Topic: [PATCH net-next 08/13] net: dsa: hellcreek: deny tc-taprio
 changes to per-tc max SDU
Thread-Index: AQHYyE9hWKLuwg2RcUaJgx4+STifDq3fOt+AgAAHiYCAAMIyAIAAX/qAgAlj7QCAAAGjAIAABMcAgAAouAA=
Date:   Wed, 21 Sep 2022 14:12:07 +0000
Message-ID: <20220921141206.rvdsrp7lmm2fk5ub@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-9-vladimir.oltean@nxp.com> <87a671bz8e.fsf@kurt>
 <20220914184051.2awuutgr4vm4tfgf@skbuf> <87r10dxiw5.fsf@kurt>
 <20220915115925.zujsneox4jqzod2g@skbuf> <87bkr9m0nn.fsf@kurt>
 <20220921112916.umvtccuuygacbqbb@skbuf> <878rmdlzld.fsf@kurt>
In-Reply-To: <878rmdlzld.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB8976:EE_
x-ms-office365-filtering-correlation-id: 4037e99a-509c-4a96-47ff-08da9bdb445d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Bq0Q7VdU0oDOCDY0v9Mb0QPdcCC9VcGhpi/jkGzcHpQu64UbzolzXW1XJ8Eav+Dd0vK82S0D/dtOKQk88hzz16WwfJD7i3zMGjS4rl91skR3KDQY05PSkjYRGwkjm0ZhJQJaY8DNv3Lg6NsnN5CkoVKvRAy4rl1iHma8KaTj8qq/RSD5LsbQhnSuASRouKIwDQxL96PQV2Y0NJrxWu46JGS63kFt6vQGoN0tDmM6WuzXjgeqFRDd6gjNATZapVPTw0GoH6ts9n7BQH5Wg1GX4WKdxlnbZxMG7l1sorNlBVWo26bX2eMRsXgWjkY3T6dZ0JS/do5ZjHclSL/k0lC4ZHV5Ts+RzikfAIziUAcISh411I7E+3jjzR/U4rSltoRLP1GOP9ChVMIQrkziqmZstrrUW4xUrEOlQNJOZooRxZv9vvuG67rVI4L4grXtiDCjDwgYj+3x9scraUP851AvKsK0if+yQEOOj2+Lhqx41WFiZFhyv/IwBPsQdIpLc89Prp65rL+UtXAHXea4FdBxs2DiFS5E6tXgVU/oFzjE2kaSA1mY71ERM5g52vGEmiW42+oHaS9lU/u6BRkW8Q39VXKpVZargewZUeuP052jWNidHu+0OD9VQi5DelultUEiGYFzgKm8YcqhUs9gkFZ2Xul4OXn6SYKh2Z3t8REg9fDDrftkOvLkighXzB+yoglYU8VXp9AklslDHQmvegbX1AMDHqDaTwcYF/GqD5ULz4K6tcN/ubskNfmaZBYUFhgVKVdxDoarrQN0KoMxKTXcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(6512007)(26005)(9686003)(6506007)(86362001)(316002)(54906003)(6916009)(38070700005)(71200400001)(6486002)(478600001)(122000001)(1076003)(186003)(38100700002)(33716001)(5660300002)(7416002)(8936002)(2906002)(4744005)(76116006)(44832011)(66556008)(66476007)(66446008)(64756008)(8676002)(4326008)(41300700001)(66946007)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?75w0drcUtPtrSYOD52x3GQWgFYhMgP5b4ursKo9cV0K4pIeM5eFbN+nQxtPX?=
 =?us-ascii?Q?FzBMLGKZFW3GhV7QO69KSLD+YnSDoyUfm/iCfjWBeQueDRm9Ch5bt7WzArha?=
 =?us-ascii?Q?RE2ZUiKlbVEDa4FXxtN4ylllY+wGCmh7pkqI/Fi59qLS2A0VKa1R+g+WFZcz?=
 =?us-ascii?Q?yRzK8znMVZh8FsgqU7w2CTcOa+9jnjZR6U1xXyeVLXlag2TVvE4sbr59Y5Co?=
 =?us-ascii?Q?rXXXpvliKrMFoQna/RcEAIMkugw8/jgbSggr0WgNLa7t2LzPnrCaVPu5Mbzq?=
 =?us-ascii?Q?Mtq8rD9f1oxa1GHTXoX2ReOvxhO5wIkzRlRtgIkMooPjwonSWI1rG18T3JWn?=
 =?us-ascii?Q?x6zXbg5rjawY7wYCDTwwmKPP79CoqEKsstUdAGxn3AenAzLbhokBpTOTiQ3/?=
 =?us-ascii?Q?GbjpH5hB9y6yPoJ4f4hnQPooZt9aORkK5y+13fUkC/lIm2JkImgLsOCk0mGg?=
 =?us-ascii?Q?yN+61K2GB9affoXgka8TnDvHYMAYtxfw5fPRF2PBlIT9+jjbshuQW5IihdOM?=
 =?us-ascii?Q?4cNjNmj+LPwWaOj6eBdTJpjejoNypyq7utuHZfLwJX0/I2T5QVuTsTCqyTY+?=
 =?us-ascii?Q?xA+J5V/H5Y/oFsru8Sw7nrpV/yY337LlOSXUsShptHus1lofL7ZvTsXQdoYr?=
 =?us-ascii?Q?V9H0WB/34q9xQIuiiawmBVFjPBy/uKu7jivvDSV/M7KtbntJm9Ar1M4oE7HL?=
 =?us-ascii?Q?DhaWjnQ8J0T7OEC/IsKelB4+sJvMRnq26NJ7z4lizDNfmtW7bsbBAtcA1DyM?=
 =?us-ascii?Q?0k8VFCamdgud6yIrIDiy0HjGALwR6/J4jldPcay8WYpOi4ImBTkjJYJbm0yz?=
 =?us-ascii?Q?/Sb50XgWfPKw40GMn+kf2siYT3zEz9oowyasaqUCnWK2hLrlL7PH8Wwk4kjS?=
 =?us-ascii?Q?9fy/474QEDXHB8Hhg/pJn9yZyHvn7JKGAGkjMliruXb7MZXevZIWxzKgzy6i?=
 =?us-ascii?Q?xrEq+bECFwg0sc0XzpaX7k/LQafYs69xqAOMI0Ot0y7Ts8drV/drtWTxOmRk?=
 =?us-ascii?Q?Y9ESymhDHSyXg4ctgJf4oQG33LKzzhHmLYVzCrHlBC/fJSFelPHzXb5K/2vv?=
 =?us-ascii?Q?YbSypXO2tQINVe1VBVNfXyqmIDsag+P7RwRlRfVWf81Pv2wjiBMY6T1rHttN?=
 =?us-ascii?Q?k5HAI+iUq2sH4tsf90DHhYUWa6ownSy5RJDStzrTKQkOn8MTieAyYCKxGzDX?=
 =?us-ascii?Q?uaLpr/U7/2OIGOsrGXW6YkSJwMPnUiauRsBpClivunGkqJ1xqMrtR7sqRjH+?=
 =?us-ascii?Q?H6qkMUzsWi02ExdQhzp+mVpsHdz1OC9CqmbMHK74MYBd+mpVZBClxSlBjmj3?=
 =?us-ascii?Q?Uja6JpDZvMea3kuV/ZfM5cEMvP9WWeNy3riJEcbtRKcs5xiKr8F7PKztB9jp?=
 =?us-ascii?Q?wmqVXC5yWtaAf22rlX71oodd5b7ENQZNqqw+QfT2R4qrlkolSrDOBsTtFx/S?=
 =?us-ascii?Q?B8cW8YNd8zSV2M+9aPFqDQiUtFK1EdItUYCgx4xfsqCzaL/Yu7WliL224DIK?=
 =?us-ascii?Q?T7NszNyr76RY3zkCvXgsg8nHptCpo3+bsdl10BJLi26hVYxA9U6Q6toR5JjT?=
 =?us-ascii?Q?KWiXCZZb6oNRyIISWY9N46EBauwKIZSJCgj0+8LA29kSDzC1hnJCisGj+z4y?=
 =?us-ascii?Q?dw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E18A677FA7601B4B98652A346CDB3702@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4037e99a-509c-4a96-47ff-08da9bdb445d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 14:12:07.2828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zJtC+PG7BPU4/gp0Nzg09dreBuze7quDBwsPqlGylgSje4xKbB51Br2YV/QCbxKGF4NYev3YPM2k66hi1cNoHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8976
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 01:46:22PM +0200, Kurt Kanzenbach wrote:
> >> So, configured to 128 and 132 bytes (including VLAN Ethernet header) i=
s
> >> the maximum frame size which passes through.
> >
> > Frame size means MAC DA + MAC SA + VLAN header + Ethertype + L2 payload=
,
> > and without FCS, right?
>=20
> Yes.
>=20
> >
> > Because max_sdu 128 only counts the L2 payload, so the maximum frame
> > size that passes should be 142 octets, or 146 octets with VLAN.
>=20
> Ok, i see. So, for 128 max-sdu we should end up with something like this
> in the prio config register:
>=20
>  schedule->max_sdu[tc] + VLAN_ETH_HLEN - 4

What does 4 represent? ETH_FCS_LEN?

So when schedule->max_sdu[tc] is 128, you write to HR_PTPRTCCFG_MAXSDU
the value of 128 + 18 - 4 =3D 142, and this will pass packets (VLAN-tagged
or not) with an skb->len (on xmit) <=3D 142, right?=
