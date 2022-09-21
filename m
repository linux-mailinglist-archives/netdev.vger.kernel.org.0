Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB645BFFC2
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 16:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiIUOVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 10:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiIUOVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 10:21:19 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2088.outbound.protection.outlook.com [40.107.104.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08A452FED;
        Wed, 21 Sep 2022 07:21:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewLwjhJmn/HzT4eH/ClPaMokl+L/2QMKWdDORn+k2vgUMT1tj4It8mplQ6VUJAEKMabnfrNdCCxBztYOTZPni5T04XMLQsRu+Tyr9bM6X+yIhG/mjkVyXdB6g7T+qbpCBY8vi4eB+MJnmFHzLN1BN1tUOmlxHKpjgBeqzj0h8AyBU7Sx5pH+apx3Sz06OFRpKKPlw+Mw6V3c7wz8qQrAwRi7rZdk/XhFiwVnuf6Te3lviX5Uhy0BHPkgKTz+6hh7Pk/bDyJr4YSUhsAc3qo3GAGmyU6kK7fbSoVHk50WabSQ7UuJom4S2pznUjUGUYJBZpjF+Iq4L8bxBjcRl8qasw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTPEdaGBwUhIAoNtjW19u9bA5khsZ5c2kGgKqBvdX6I=;
 b=kZZRjEYv6OLx1A/nwLUZQV9Zho77QOFrdqP7YaF68rCSISzavpy732PXLwRhTpSgFxirZ41jwy9Nw5f0tKpjN6bvFV68h5kz6Avhhw51Nv9JUETtiJRBccRQDgKspHw+WT6K1xrM8lVZxAjrwFYFDg8swYf9a60dMYdIzumMCVzQXavZEOsy3Dus1np/X2+S4ta4uzDLRH8EzU/dLQLdtF5bjZUqOfGLEajGgcKMBCulYIyywVhJRDj9WFCYYcMwsKVK3QXBKTCVFjCuPnB8dJlHXpQHLHTQxRcwCcfoBtIBhi4DCpGNY08kzawalQBgxL1yC2WirocKuwgLX8SRrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTPEdaGBwUhIAoNtjW19u9bA5khsZ5c2kGgKqBvdX6I=;
 b=ULV82o+mYliDHB+3xacwUPHqwsWH37GR2FWZTaLh24B0UIyIgYgKxIXnHgoTRphxijSfj2Q4i/VYFhSvDXv4h/kwUSw+zjKDrPih3PB7G/80PpVIGSXQOhrukrTke04KOtm3TL8O/5omd+dJ1sVDAHfBCclYY97TDWLKUif6JMM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8244.eurprd04.prod.outlook.com (2603:10a6:20b:3e0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 14:21:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 14:21:16 +0000
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
Thread-Index: AQHYyE9hWKLuwg2RcUaJgx4+STifDq3fOt+AgAAHiYCAAMIyAIAAX/qAgAlj7QCAAAGjAIAABMcAgAAouACAAAKOgA==
Date:   Wed, 21 Sep 2022 14:21:16 +0000
Message-ID: <20220921142115.4gywxgkgh2fqthjz@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-9-vladimir.oltean@nxp.com> <87a671bz8e.fsf@kurt>
 <20220914184051.2awuutgr4vm4tfgf@skbuf> <87r10dxiw5.fsf@kurt>
 <20220915115925.zujsneox4jqzod2g@skbuf> <87bkr9m0nn.fsf@kurt>
 <20220921112916.umvtccuuygacbqbb@skbuf> <878rmdlzld.fsf@kurt>
 <20220921141206.rvdsrp7lmm2fk5ub@skbuf>
In-Reply-To: <20220921141206.rvdsrp7lmm2fk5ub@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM9PR04MB8244:EE_
x-ms-office365-filtering-correlation-id: 46212cd3-8787-487c-618b-08da9bdc8bcb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QV3Lv4WaFwDga3Y7bdVSsFotSd7LHIrkLMXX5FTUFBk5ITrwQeBXC9aTG1aYC1NIsy6rvIdY0PiiNbdrScliYZ6r6VbjnrLp9r6/koW3p59IrxvaQaeaUUBns2Sd24UpCooS1fdfdX0zzCf6P6G1XoNLZjyAZoxayJf+/DsmkuhYsU8Q/FkWCqIeMGSVf+2oYkQFoU6q36m2FYoeh2WlK5uJhMqHx+2j4D/UH6JkPOY8nQtQVwfwYDGjI/cxqg0H59vNDUejEXwRanbl1LufGUaiKhmtnBMZ6Qgau1o5mQXj5Jc9SFGBkmq6lQvMoXeMttw2J8h2dKOTb6Aa+NEp+JYqbAXv54Hdkw0Ofh2zFgWwM9i2kTFOmtG1UHIRo/gFEe64t+39PLr6QwkWNJZZPjkNoB2t9HodoTYuBoDZFqXf2IXUcPd+u6381H9j/ujr5CppmReIpYoI9wpPm8mSYFLtMGLVjw9btjNl21Hv9w2+2fdQFHcu9p30YIQjDzhQYNp9zACcCKEXAFT8GV2X2qI+Of4j6uMAJjlqmrhGVkjT9dw98UfA9FyELdmoXuNhZO4ECziZuDARaXntYBk61H/AkAxv5IAaAjBqihDw/Y4UQV3ejjeaeJ7XdDtAZFqFQV6nj+Jx7tRBHcq5ZexQDFXjz5SnfAdCJ4DqZnXIb7aZ+rhuDYhXmDXKgB5jMqlva2XfJm3U2glAInVYCOKQfQYkU8yDpx5y7785bqTN9UUu0dOa+81GfCeBCv8RAAtbV7zAa28tekKQvwo9jsS2cQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199015)(1076003)(33716001)(122000001)(38100700002)(41300700001)(478600001)(71200400001)(6486002)(86362001)(2906002)(38070700005)(44832011)(8936002)(5660300002)(186003)(7416002)(6506007)(26005)(6512007)(9686003)(66946007)(66446008)(54906003)(91956017)(6916009)(316002)(66556008)(76116006)(64756008)(8676002)(4326008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f/9L+VgEnYu7xl6CrOi8V/WtafYNvAHd9H2HfWutEl5H+wfenQoMgx9VqRsM?=
 =?us-ascii?Q?CRMSnMLqGkeE8iPp9jtUsJyM3cGIw1jF4zpYZBPGp53c6WozLFeCXcA1GxTu?=
 =?us-ascii?Q?deoFXuwILSxujJEASAOy9Iyt6Zg6ghPcFa9ZXrAKRCa2iyydC09NdRD5uylm?=
 =?us-ascii?Q?k4qKpi9GO4HMsATus0u+qhdDT7iNZ71ln2HzZjmFCab6XAMdv4N6u3IkkIa1?=
 =?us-ascii?Q?gno1ZCUPIckaa3xGryhraib706acprICZN9uWRWITQpdaXdDk9dmjl1fJGgT?=
 =?us-ascii?Q?3Czuhcmmmlc5IZJCSM+PlcJgJInr7+KWXTc5m4qi2V7kuVfxMZpDYPZMZbk3?=
 =?us-ascii?Q?XJgUFZAOqdR5caBeo4OivCJijPMcOvv9s5NWNMgVuJczAOiFJ4xe8KLFERbz?=
 =?us-ascii?Q?dAAy9jfGOvbQ8kKS9a5TfbZhvwZGUsbjeUUPGW/HdTLDIwQ2rU4CIMT4TG3z?=
 =?us-ascii?Q?6A5ne96KE8QUEyBTYadaH2RSxXBjpEjlGgFFFDcWivooV2An67PFHLIpO6Bp?=
 =?us-ascii?Q?oVfQ4I0jm6omo7hn4fccdAKaLrjw1nZk+KUMqWsGsJlr34rhK/hFvEEGCF6F?=
 =?us-ascii?Q?SYSEc24O8ikKXEy84DlXqCDMCB8o/pF2islJcZ0b/jkkcNixl+z3xGqOdmWg?=
 =?us-ascii?Q?b0Vh8Q5+61CE3YhXHsoDPoEF8LGR5HNbew4rSe+alX91N48cozIfbAF+v66U?=
 =?us-ascii?Q?Hn8LgSlQEHgUxzrKBiyWDTi0qqAuORTl/vL3xL5ZkWiiW6CZ1+vv3V2NHLYC?=
 =?us-ascii?Q?YUBrNs7k9cK34vG/nv5wDRYezZNxaCqnAsgRfbak9PK1+ZJQgMAES1zDUo/m?=
 =?us-ascii?Q?RL1PUq76l7apzH/wuGAl7pIBhj08l5sQDsqznvAqA5824BQqJLTvLBGpfhdo?=
 =?us-ascii?Q?/+nc1JvlegHpNZBeajMPwGfYxlL087gNAwi8AR17aUP/9LmpY0xiBYYM1MdZ?=
 =?us-ascii?Q?O68eGquqftShVJ3lah4zcsDforeWpxpNwzirQ8JqLDvHwNybEKJE7CZPtxON?=
 =?us-ascii?Q?yni6hg3BjEvZaZRyo9Tdxjj2Hq6yPMHkArKgxHwHQMiUpD4r1Jn6G6hbXCXe?=
 =?us-ascii?Q?188go4FYoq54SscGaNJzxWJ5w5DGbUjc94E4CDdDl8rU4pgz3MnsySZVOIdo?=
 =?us-ascii?Q?0Nj/NcdUWjuZ1v2NjT5C4ikArf7l55ivWSuDBRCa2E2MrUUeHRkr4PgZe1T4?=
 =?us-ascii?Q?pUzjKnfS3XEnnaQ114VXoStyRx4GSLT7TJpisuyxG3/uVh78Q+DNu4dqH/7C?=
 =?us-ascii?Q?+vY3VzFtqYs1c7+Ife1GBvSh/tAPZi+qkREHRwodPEteg4Y0PnqbkRudybFf?=
 =?us-ascii?Q?STTMYktk931OdsTAa3nWSsmhGn0BSHy7TG4I93z1cu68O2dJy6FACXTWp2ea?=
 =?us-ascii?Q?aubxKJciHmeJslZJRDpZeVvbaocNiIGS/Mlbd3B3MuoydwXIua7jzBMuKClB?=
 =?us-ascii?Q?RQkLsBEar/Yvl3UaAPtUZUWh38h17Y+V1JpqfkXmMiZI0YsBMeiloAoQhc7A?=
 =?us-ascii?Q?jIIj2IQGi1M2EnJ1kQQ2RvfrvHSKioS4Adhv9e0IsOYdqCIUGsblVAhoLnsw?=
 =?us-ascii?Q?pgN4DLTs51DJ7tTrox96WKlUPJYyXN31E1w3kY8+xLfxMPXVRqrbFRvDwxYw?=
 =?us-ascii?Q?MA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2ECB73718EC27E408D3300F1C91487E5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46212cd3-8787-487c-618b-08da9bdc8bcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 14:21:16.6193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NkpRCcwJxETvC3QnvZ/VI5u7xTh3WDF1i8zlt+NP1Id3zQDKYF/qZthhRsP2ElU72TKaEft+irCybPO68pTNXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8244
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 05:12:06PM +0300, Vladimir Oltean wrote:
> On Wed, Sep 21, 2022 at 01:46:22PM +0200, Kurt Kanzenbach wrote:
> > >> So, configured to 128 and 132 bytes (including VLAN Ethernet header)=
 is
> > >> the maximum frame size which passes through.
> > >
> > > Frame size means MAC DA + MAC SA + VLAN header + Ethertype + L2 paylo=
ad,
> > > and without FCS, right?
> >=20
> > Yes.
> >=20
> > >
> > > Because max_sdu 128 only counts the L2 payload, so the maximum frame
> > > size that passes should be 142 octets, or 146 octets with VLAN.
> >=20
> > Ok, i see. So, for 128 max-sdu we should end up with something like thi=
s
> > in the prio config register:
> >=20
> >  schedule->max_sdu[tc] + VLAN_ETH_HLEN - 4
>=20
> What does 4 represent? ETH_FCS_LEN?
>=20
> So when schedule->max_sdu[tc] is 128, you write to HR_PTPRTCCFG_MAXSDU
> the value of 128 + 18 - 4 =3D 142, and this will pass packets (VLAN-tagge=
d
> or not) with an skb->len (on xmit) <=3D 142, right?

Mistake, I meant skb->len <=3D 146 (max_sdu[tc] + VLAN_ETH_HLEN). So the
hardware calculates the max frame len to include FCS, and skb->len is
without FCS, hence the 4 discrepancy.=
