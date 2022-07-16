Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F5C576B1E
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 02:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiGPA0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 20:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiGPA0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 20:26:17 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2070.outbound.protection.outlook.com [40.107.21.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E48904DE
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 17:26:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0UfI8zNzlDgPWRtl2EqWLuQOLTe+YZH3NJaW/B1aiVc5CuE8FckV/AOGH0to+BM1kLLFNKisRfXTjdS8JLUcHjop9hR6mnVEjvmSeA1IULZKpVv0X6UVfntt4aRBUs8Pgk/iDY7LF9STEwZPi1E3QS3+cxwQiRd7wO3NF/VOwKnVlX4TxSKsbO/j8mJVdY8YQeFJx/HPSvG7Jj100iQ8WM2GjG1tjDh2WJ9EdipOkYbSslNb89VB+orH6/wx1BNSM/2gflBFSbfQdgfcOv95nWn7IfSj1hAXDLWtzOlNPjR50JVvG9By8obIROJs1XWW5/zRDxgJitswTlO3HbL2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHc23pn+sWsaDGg2/+zM+KW+i8srGsbfzHIMjHcwyIA=;
 b=bClhBAiXGUZIaJ2qC57GcviV5xZwSehJebRSsta8/cSUJeMLL97ElhDHaEeKfAgIXAKvi4IW/4KowBf6uNuyhO2zediyV2D5lkeYAVh0YNifZ5lkiH+whmN+jAyzezGnavLYwWVOLVNfHxSR3nvZMlXfOCaW7K/0c9qrKYVYtLija2S5SgM+TDTegcHvXLHEDF3RS+f299s7K4ooycAr1j1QB+kcioa4PMGouL8Ie3ytKyISik3xD5ndJ7Ka8xbVEPi3LklgCFc+h+Xx9ciXV6LoztHlJEZAayxNAcvz37bJtpjIY1CD/6ETSC3RcWftTdtxwWz0o5tkijzElJiMiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHc23pn+sWsaDGg2/+zM+KW+i8srGsbfzHIMjHcwyIA=;
 b=OqdVVKU6h7ftq/5dM1acFDhZIEmytNHx+Cp7LdqgBbSQ1nUduoLZq8+yPgmJcQgRdo1UaLDFaDV6DWjfa4sR7i8y5S77njebS1BJlTeb6dbeC7IM36FMFCqVMIK/TP7XIvPRzKTSm3I1gZ2bKYt42XBOGUSjdXaXLXTPPRYROrM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7275.eurprd04.prod.outlook.com (2603:10a6:102:8d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Sat, 16 Jul
 2022 00:26:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5438.015; Sat, 16 Jul 2022
 00:26:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH net] net: dsa: fix bonding with ARP monitoring by updating
 trans_start manually
Thread-Topic: [PATCH net] net: dsa: fix bonding with ARP monitoring by
 updating trans_start manually
Thread-Index: AQHYmKJbDVvU92lcVkqDHlTGpm7yu62AHOkAgAAD6oCAAAF5gIAAAb0A
Date:   Sat, 16 Jul 2022 00:26:13 +0000
Message-ID: <20220716002612.rd6ir65njzc2g3cc@skbuf>
References: <20220715232641.952532-1-vladimir.oltean@nxp.com>
 <20220715170042.4e6e2a32@kernel.org> <20220716001443.aooyf5kpbpfjzqgn@skbuf>
 <20220715171959.22e118d7@kernel.org>
In-Reply-To: <20220715171959.22e118d7@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 394a947a-4d87-49d9-4c30-08da66c1ca3a
x-ms-traffictypediagnostic: PR3PR04MB7275:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H6c3tCrl9yqR2DoAoIVr9JqUvCt4UQ9UBVffOLuYJOWM2H/tOExmfmt4I9ir2t5/aof24uvPDwCAlTklILJ7G1cMfoauflWGtmDOVATIiC6162xtBRERUu06056AC2Kh1fnRhhuWophX18TrQx7VCT4oHFctxXbFjb23tPMMIhZTpZC8AE2Lqym3l0u+PspKSbZrZbQT2KjTpThDJoGVth0dDhsGk29+Fl1I0vlobkh7ftfd5DOmCFtsLJiYdzhMY1ES/QEZugoqH3exLJTqWycEtq7vVV5vB3XfJZm6O38BxmK2/4/Av8cx7Tf+5Bjf/Cjjuzp9zmqn0O0f/z0zprdNMpQ3VZslVdTTkNd+3Ki3Bz+Q6yQrutv0kFgtpsradgIdiTMmJF7zCVK8RMe7HRnBUDzvNnK8RA9Whiun6BiuphZipOtZHGQqtejSG58b0oOKKzN5bXehsRhPk1OFfAlkcN/guGcQ8f2esGgv1bJattVsyWyPAr5swhJ+r/oZUJ8C0A2U5RlF4QiLhI6qt89HV6alIPX3f4UaF6CE3uTYMOz0ExMrG840xatZ5C8Qb/xO5/99Y6IQBSxaK8tUT3BHghMhVcCZT2WM+pt928oitAvN60nZCL8sbQypuq5r3YczhK8zagx/l5JSu+jP9XqQyXrNk/PALpXSILuR+uQAUw55n5d6o7B2zuQKPHCNmwO+ZF2Dq725yeLG98em31TcFv8mpGt+lQDgGmpgIDlcN3+gKu/oe9oF8zmO6yrk0HHu05oV6I9R+TxSar8+JqAcAf8FQmcFx2Hz0NSU42vVnMoJoirza+zsBdhP3UhgzbUKxvNvC3+f/ylvG03ZtXnzy3E5XZgQha/uwoeaGfgYTaAFVi2cIEIshGp1e98K4gGESgmO1cOoo7nm7jzWPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(83380400001)(44832011)(91956017)(6512007)(6506007)(41300700001)(38070700005)(4326008)(76116006)(66946007)(66446008)(71200400001)(64756008)(66476007)(66556008)(478600001)(2906002)(26005)(8676002)(5660300002)(186003)(9686003)(7416002)(1076003)(8936002)(966005)(54906003)(316002)(38100700002)(6486002)(33716001)(122000001)(86362001)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CwJv24FKP8rdtGTk5k+HYwU2z9PxgxcIQhVLj25mk24UfEMWO3uH7hITkrOX?=
 =?us-ascii?Q?OeZx8KrQhVroae0sdiEICx8NCEGAYnBTgLXjuncj7mAPUHnMiicE4fcGLnwz?=
 =?us-ascii?Q?cfcH+I4C+/mAraf8hwNKnXX1rBzzvNiHHHCabKbIgq3dV/5guUClKMvivPis?=
 =?us-ascii?Q?i11Wcn9VxR0VoL99yZHobwWysqYbNFBYewnin4o7U9xeIRftJAwxQWSEk0SB?=
 =?us-ascii?Q?mfh/c8E4X7gwDgx7sDVpzYDrhdARsgDML8fsEGWxg5Jo0OSz38vp58naWhV8?=
 =?us-ascii?Q?wdamaW1MwjyOXQi/He6xoUZPpUF2iSdeSmmoGRn5TbVgHy2uJNIGFbYOkUDJ?=
 =?us-ascii?Q?6Bd9vwXR8t5iBfpLONfERwb3Crr/bbgs86GSDW8RrmVjwxzIjztsDGtJdtR+?=
 =?us-ascii?Q?GgLtgH4eaosGhi/wFhCShXZ2a9d582C16OrSBAOg/hxI9N1+EttwCXPoO2TB?=
 =?us-ascii?Q?iZCAhQWIPq+5edQQdVkyFgPAHHXisEFLjPb/VjHEoQXJ5XOdlhGGHQMG0tVL?=
 =?us-ascii?Q?o/5x5Su3aFGiKW0itwPq/04ggCHzO7t9/VMMe1907SsjpjHr+2IMYWKuxY+7?=
 =?us-ascii?Q?3e4JEsF3spmrMN0qmXblmi6nAb/zLiGmP0sX1CTWnxzypGhhIIEuBymaNdDp?=
 =?us-ascii?Q?/uUO66XVTpVjBpnUyVjpFR2cqf8aO4YxjjW0jGfeQrw0KUxVxYbIHSHZqzUs?=
 =?us-ascii?Q?kIvb971eeVapmGVzTz71hwJyWvLHmsWUPsQjm7GoQP/Ma1TAfYtMfmMGsN/h?=
 =?us-ascii?Q?tFU/1Cw0EX4NjcGf/2BM6MbuHy/i94CU1rjycu7Vx28FRjmUgE8mAFVxtgwk?=
 =?us-ascii?Q?xhn71RjwmvUIm0CPsl8+Q3f94fuGFVdoqMywSM0RA5XEJ2nIKkW22Pcsn5jN?=
 =?us-ascii?Q?2rJgdN/wU4WWMtmqGCm6LDzeYT4CNY0clJ6chxv+/HoCHWoNbbZsIvENHHvk?=
 =?us-ascii?Q?O5YtYCH2sMYYkgmwFsCZu2WWZ6KXnOPv8UO5xTZ8EoOoxiVbFR1cr188CKB7?=
 =?us-ascii?Q?XO+xiMEAyTocpmqsFfoxxg4mFLoK0hZcpvpyJFstf0Er4YnEDcRhAe4igDPd?=
 =?us-ascii?Q?rrwBLX4DCPPVBiyoI8o8PuNbMcl0QRWjYXzuSWGnMqBra/j4kaGU1scb5BcU?=
 =?us-ascii?Q?zSLGiTy0MtyhASnFN54vbjRsg7aZetQ//TZcsohg8g1bixcd+ErS6NqR7cVz?=
 =?us-ascii?Q?SkxL7bAE2Yjb3ICu+hWNT1APCj2zewjvFb6UtlJYrEoaQWfgcrOJqYz4bYGF?=
 =?us-ascii?Q?cOTHuCmKi/XlUIoLYa7OOxqblBygmxcseyRYSWN6Xq3szuiCkEZ2BdysivOo?=
 =?us-ascii?Q?JgwSiDaQecig6QvMyWrBvWPB80tgsocDqqLzNKI1Lew+8dqjAqw2xzvsoh9o?=
 =?us-ascii?Q?PaYWcrA8glPFnJXneiq0Wc9/qT9jnpBy7fg4XHsgSz4+y2VBx7BSOyVTeB9c?=
 =?us-ascii?Q?DCubkRlWqLMabBZqD8DghF0TY9v9vyFcgZpqa2vp7CXojHMkRpLnCswfZoQp?=
 =?us-ascii?Q?1OSj3IgmPMFnv0k/Mey9s4PbX3sT0ozUhOYVEMGipqb92myTaYuYgGNvn6mr?=
 =?us-ascii?Q?gAX2WSH2WfiS02EcpRZw3vEMtdyW5Z8SUBJcSgC37gxyBy+Bg79j59IA/VzK?=
 =?us-ascii?Q?bw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C5DA7789629B704EB1995F3CD4C2EF06@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 394a947a-4d87-49d9-4c30-08da66c1ca3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2022 00:26:13.3573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mZBNOXLB6NyyJDxVve08wJKjeltolrBhjS0dCYBdquLw83nYOsS6CDSENwSCDBAiVJ50zO5hIbtj5kFkPFgylw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 05:19:59PM -0700, Jakub Kicinski wrote:
> On Sat, 16 Jul 2022 00:14:44 +0000 Vladimir Oltean wrote:
> > On Fri, Jul 15, 2022 at 05:00:42PM -0700, Jakub Kicinski wrote:
> > > On Sat, 16 Jul 2022 02:26:41 +0300 Vladimir Oltean wrote: =20
> > > > Documentation/networking/bonding.rst points out that for ARP monito=
ring
> > > > to work, dev_trans_start() must be able to verify the latest trans_=
start
> > > > update of any slave_dev TX queue. However, with NETIF_F_LLTX,
> > > > netdev_start_xmit() -> txq_trans_update() fails to do anything, bec=
ause
> > > > the TX queue hasn't been locked.
> > > >=20
> > > > Fix this by manually updating the current TX queue's trans_start fo=
r
> > > > each packet sent.
> > > >=20
> > > > Fixes: 2b86cb829976 ("net: dsa: declare lockless TX feature for sla=
ve ports")
> > > > Reported-by: Brian Hutchinson <b.hutchman@gmail.com>
> > > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com> =20
> > >=20
> > > Did you see my discussion with Jay? Let's stop the spread of this
> > > workaround, I'm tossing.. =20
> >=20
> > No, I didn't, could you summarize the alternative proposal?
>=20
> Make bonding not depend on a field which is only valid for HW devices
> which use the Tx watchdog. Let me find the thread...
> https://lore.kernel.org/all/20220621213823.51c51326@kernel.org/

That won't work in the general case with dsa_slave_get_stats64(), which
may take the stats from hardware (delayed) or from dev_get_tstats64().

Also, not to mention that ARP monitoring used to work before the commit
I blamed, this is a punctual fix for a regression.=
